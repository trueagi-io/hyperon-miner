from hyperon import *
from hyperon.ext import register_atoms

import random

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom, \
    G, S, V, Atoms, get_string_value, GroundedObject, SymbolAtom
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp
import numpy as np

DEFAULT_K = 800.0


def get_beta_distribution(emp_tv):
    emp_tv = emp_tv.get_children()  # cdr-atom
    strength = float(str(emp_tv[1]))  # car-atom
    confidence = float(str(emp_tv[2]))  # cdr-atom
    cf = min(0.9999998, confidence)
    count = DEFAULT_K*cf / (1-cf)
    pos_count = strength * count
    p_alpha = 1.0
    p_beta = 1.0
    alpha = p_alpha + pos_count
    beta = p_beta + (count - pos_count)
    return (alpha, beta)


def mean_beta_distribution(beta_dist):
    alpha, beta = beta_dist
    return alpha / (alpha + beta)


def variance_beta_distribution(beta_dist):
    alpha, beta = beta_dist
    return (alpha * beta) / ((alpha + beta) ** 2 * (alpha + beta + 1))


def average_means(means):
    return sum(means) / len(means)


def average_variances(variances):
    return sum(variances) / len(variances)


def relative_variance(means, variances, mean):
    adjusted_variances = relative_variance_helper(means, variances, mean)
    return adjusted_variances


def relative_variance_helper(means, variances, mean):
    if not means or not variances:
        return []

    adjusted_variances = []

    for mean_head, variance_head in zip(means, variances):
        head_new = variance_head + (mean_head - mean) ** 2
        adjusted_variances.append(head_new)

    return adjusted_variances



def average_truth_value(metta: MeTTa, tvs):
    tvs = tvs.get_children()
    # Extract Beta distributions from truth values
    beta_dists = [get_beta_distribution(tv) for tv in tvs]

    # Calculate the mean for each Beta distribution
    means = [mean_beta_distribution(beta_dist) for beta_dist in beta_dists]

    # Calculate the variances for each Beta distribution
    variances = [variance_beta_distribution(
        beta_dist) for beta_dist in beta_dists]

    # Calculate the overall average mean
    mean = average_means(means)

    # Calculate relative variances
    relative_variances = relative_variance(means, variances, mean)

    # Calculate the average variance
    variance = average_variances(relative_variances)

    # Create the final truth value with the average mean and variance
    final_tv = (mean, variance)  # Assuming EMPTV is a tuple
    tv = metta.parse_all(
        "(EMPTV " + str(final_tv[0]) + " " + str(final_tv[1]) + ")")

    return tv


##################################
##### Direct C++ implmentation ##
################################

def subsmp(metta: MeTTa, db_element, subsize):
    db = db_element.get_children()
    subsize = int(str(subsize))
    ts = len(db)  # Get the size of db and store it in ts
    smp_db = None
    if ts // 2 <= subsize < ts:
        smp_db = db.copy()  # Copy db to smp_db
        i = ts  # Start with the total size as `i`
        while subsize < i:
            rnd_idx = random.randint(0, i - 1)  # Generate a random index
            smp_db[rnd_idx], smp_db[i - 1] = smp_db[i -
                                                    1], smp_db[rnd_idx]  # Swap with the last element
            i -= 1
        smp_db = smp_db[:i]  # Resize to include only the first `i` elements

    elif 0 <= subsize < ts // 2:
        smp_db = [None] * subsize  # Initialize a list with `subsize` elements
        def select(): return random.randint(0, ts - 1)  # Random selector function
        for i in range(subsize):
            smp_db[i] = db[select()]  # Randomly select an element from db

    else:
        smp_db = db

    mettaSubsample = metta.parse_all(str(smp_db).replace(
        "[", "(").replace("]", ")").replace(",", ""))
    return mettaSubsample


def generet_random_subsample(metta: MeTTa, db_element, subsize):
    db_elements = db_element.get_children()
    subsize = int(float(str(subsize)))
    if subsize == 0:
        return []
    elif len(db_elements) == subsize:
        return db_element
    subsample = []

    for i in range(subsize):
        random_index = random.randint(0, len(db_elements) - 1)
        element = db_elements[random_index]
        subsample.append(element)
    mettaSubsample = metta.parse_all(str(subsample).replace(
        "[", "(").replace("]", ")").replace(",", "").replace("#", ""))
    return mettaSubsample


@register_atoms(pass_metta=True)
def avrage_tv(metta: MeTTa):

    # Define the operation atom with its parameters and function
    avrageTv = OperationAtom('mean-tv', lambda tv: average_truth_value(metta, tv),
                             ['Expression', 'Expression'], unwrap=False)

    random_subsample = OperationAtom('generet_random_subsample', lambda db_elemet, subsize:  generet_random_subsample(metta, db_elemet, subsize),
                                     ['Expression', 'Atom', 'Expression'], unwrap=False)

    return {
        r"mean-tv": avrageTv,
        r"generet_random_subsample": random_subsample,
    }

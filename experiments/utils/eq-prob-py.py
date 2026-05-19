import itertools
from hyperon import *
from hyperon.ext import register_atoms
import re
import sys
import os
import random
import string
import time

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom, \
    G, S, V, Atoms, get_string_value, GroundedObject, SymbolAtom
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp
from collections import defaultdict
import re
from functools import cmp_to_key




metta = MeTTa()
with open('../../data/ugly_man_sodaDrinker.metta', 'r') as file:
   metta.run(file.read())




def parseFromExpresstion(expresion, dimention):
    if dimention == 1:
        return [str(child).replace("#", "") for child in expresion.get_children()]
    elif dimention == 2:
        out = []
        for childExp in expresion.get_children():
            out.append([str(child).replace("#", "")
                       for child in childExp.get_children()])
        return out


def parseToExpression(strings):
    strings = strings.replace("[", "(").replace("]", ")").replace(
        ",", "").replace("\"", "").replace("'", "").replace("#", "")

    atom = metta.parse_all(strings)
    return atom






def get_variables(pattern):
    variables = set()
    for entry in pattern:
        matches = re.findall(r'\$\w+', entry)  # Find words starting with '$'
        variables.update(matches)
    
    return variables

def find_common_variables(partitions, variables):
    variable_count = defaultdict(int)  # Tracks the number of bulks each variable appears in

    # Check each variable one by one
    for var in variables:
        for bulk in partitions:
            if any(var in entry for entry in bulk):  # Check if variable appears in the bulk
                variable_count[var] += 1  # Count bulk occurrences

    # Return variables that appear in more than one bulk
    return [var for var, count in variable_count.items() if count > 1]

def connected_subpatterns_with_var(partitions, variable):
    filtered_partitions = []
    
    for bulk in partitions:
        filtered_bulk = [entry for entry in bulk if variable in entry]  # Keep only patterns with the variable
        if filtered_bulk:  # Only keep non-empty bulks
            filtered_partitions.append(filtered_bulk)

    return filtered_partitions

'''
Sorting Strategy:
1. Count the number of unknown variables (i.e., terms starting with $) in a block.

2. Count the number of concrete terms (i.e., terms that are not variables).

Sort by:

1. More variables → More abstract

2. Fewer concrete terms → More abstract

3. Fewer patterns in the conjunction → More abstract
'''


def count_variables_and_concretes(block):
    variables = set()
    concretes = set()
    
    for pattern in block:
        tokens = re.findall(r'\$\w+|\w+', pattern)
        for token in tokens:
            if token.startswith("$"):
                variables.add(token)
            else:
                concretes.add(token)
    
    return len(variables), len(concretes), len(block)
def to_conjunction(patterns):
    return f"( {' '.join(patterns)} )" if patterns else '()'
def is_more_abstract(b1, b2, var):
    def get_vars(block):
        return {token for pattern in block for token in re.findall(r'\$\w+', pattern)}

    b1_vars = get_vars(b1)
    b2_vars = get_vars(b2)

    if var not in b1_vars or var not in b2_vars:
        return False

    concrete_var = '@val'
    replaced_b1 = [pattern.replace(var, concrete_var) for pattern in b1]
    replaced_b2 = [pattern.replace(var, concrete_var) for pattern in b2]



    body1 = to_conjunction(replaced_b1)
    body2 = to_conjunction(replaced_b2)

    # Step 1: Try direct unification
    result = metta.run(f"! (unify {body1} {body2} true false)")
    if result and result[0][0] == 'true':
        return True

    # Step 2: If direct unification fails, check singleton-vs-conjunction abstraction
    if len(replaced_b1) == 1 and len(replaced_b2) > 1:
        single = replaced_b1[0]
        all_unify = all(
            metta.run(f"! (unify {single} {conj} true false)") and
            metta.run(f"! (unify {single} {conj} true false)")[0][0] == 'true'
            for conj in replaced_b2
        )
        if all_unify:
            return True

    elif len(replaced_b2) == 1 and len(replaced_b1) > 1:
        single = replaced_b2[0]
        all_unify = all(
            metta.run(f"! (unify {single} {conj} true false)") and
            metta.run(f"! (unify {single} {conj} true false)")[0][0] == 'true'
            for conj in replaced_b1
        )
        if all_unify:
            return False  # b2 is more abstract

    return False


def sort_partitions_by_abstractness(partitions, variable):
    def compare_blocks(a, b):
        if is_more_abstract(a, b, variable):
            return -1
        if is_more_abstract(b, a, variable):
            return 1
        a_vars, a_concretes, a_len = count_variables_and_concretes(a)
        b_vars, b_concretes, b_len = count_variables_and_concretes(b)
        if a_vars != b_vars:
            return b_vars - a_vars
        if a_concretes != b_concretes:
            return a_concretes - b_concretes
        return a_len - b_len

    return sorted(partitions, key=cmp_to_key(compare_blocks))

def is_blk_more_abstract(l_blk, r_blk, var):
    # Use count heuristic: more variables + fewer concretes = more abstract
    l_vars, l_concs, l_len = count_variables_and_concretes(l_blk)
    r_vars, r_concs, r_len = count_variables_and_concretes(r_blk)

    return (l_vars >= r_vars) and (l_concs <= r_concs)

def value_count(pattern,var,db_size):
    var = f"({' '.join(list(var))})"
    print(f"! (match &self {pattern} ($x))")
    result = metta.run(f"! (collapse (match &self {pattern} {var}))")
    print("the match is: ", result)
    
    return (
    len(result[0][0].get_children())
    if result and isinstance(result, list)
    and len(result) > 0 and isinstance(result[0], list)
    and len(result[0]) > 0 and hasattr(result[0][0], 'get_children')
    and callable(result[0][0].get_children)
    else db_size
)
def to_conjunction_with_comma(patterns):
    if len(patterns)>1:
        return f"(, {' '.join(patterns)} )" if patterns else '()'
    else:
        return f"{' '.join(patterns)}" if patterns else '()'
def eq_prob (partition, pattern,db_size):
    # Parse the input string to get the list of elements
    # get the variables from the pattern
    # the count the variables inside partition
    # keep only the variables that are apeared more thatn once

    db_size =  int(f"{db_size}")
    p=1.0
    parssed_pattern = parseFromExpresstion(pattern, 1)
    variables = get_variables(parssed_pattern)
    print("variables", variables)

    # parsse the partition and count the variables and keep only the ones that are apeared more than once
    parssed_partition = parseFromExpresstion(partition, 2)
    print("partition", parssed_partition)

    common_variables = find_common_variables(parssed_partition, variables)
    
    print("common variables", common_variables)

    for var in common_variables:
        # Filter partitions to keep only those containing the variable
        var_partitions = connected_subpatterns_with_var(parssed_partition, var)
        print("filtered_partitions", var_partitions)

        # rank_by_abstraction(var_partition, var);
            #  sort the partition such that if block A is strictly more
            #  abstract than block B relative var, then A occurs before B.
        sorted_partition= sort_partitions_by_abstractness(var_partitions, var)
        print("sorted_partition", sorted_partition)
        c = 63
        for j in range(1, len(sorted_partition)):
            i = j - 1
            while i >= 0:
                if is_blk_more_abstract(sorted_partition[i], sorted_partition[j], var):
                    break
                i -= 1

            c = db_size
            if i >= 0:
                print("the selected",sorted_partition[i])
                var = get_variables(sorted_partition[i])
                
                print("the selected variables", var)
                coverted_selected = to_conjunction_with_comma(sorted_partition[i])
                print("to conjunction",  coverted_selected)
                result = value_count( coverted_selected,var,db_size)
                print("result is", result)
                c = result
            p /= c

    return metta.parse_all(f"{p}")


        




@register_atoms(pass_metta=True)
def eq_prob_reg(metta: MeTTa):

    # Define the operation atom with its parameters and function
    generateVariable = OperationAtom('eq-prob-func', lambda partition, pattern, db_size:  eq_prob(partition, pattern,db_size),
                                   ['Expression', 'Expression',"Atom",'Expression'], unwrap=False)
    return {
        r"eq-prob-func": generateVariable
    }



def custom_add(metta, a, b):
    # Convert to numbers and add
    try:
        a_val = int(str(a))
        b_val = int(str(b))
        result = a_val / b_val
        return metta.parse_all(str(result))[0]
    except (ValueError, TypeError):
        # Return a default value if conversion fails
        return metta.parse_all("0")[0]

@register_atoms(pass_metta=True)
def math_operations_reg(metta: MeTTa):
    add_atom = OperationAtom('my-add', 
                           lambda a, b: custom_add(metta, a, b),
                           ['Number', 'Number', 'Atom'])
    
    return {
        r"my-add": add_atom
    }


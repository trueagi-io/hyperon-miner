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


def parseFromExpresstion(metta, expresion, dimention):
    if dimention == 1:
        return [str(child).replace("#", "") for child in expresion.get_children()]
    elif dimention == 2:
        out = []
        for childExp in expresion.get_children():
            out.append([str(child).replace("#", "")
                       for child in childExp.get_children()])
        return out


def parseToExpression(metta, strings):
    strings = strings.replace("[", "(").replace("]", ")").replace(
        ",", "").replace("\"", "").replace("'", "").replace("#", "")

    atom = metta.parse_all(strings)
    return atom


def generate_subsets(metta, original_pattern):
    elements = original = parseFromExpresstion(metta, original_pattern, 1)

    subsets = list(itertools.chain.from_iterable(
        itertools.combinations(elements, r) for r in range(len(elements) + 1)
    ))

    formatted_subsets = str(subsets)
    formatted_subsets = parseToExpression(metta, formatted_subsets)
    return formatted_subsets


@register_atoms(pass_metta=True)
def generete_subsetReg(metta: MeTTa):

    # Define the operation atom with its parameters and function
    generateSubset = OperationAtom('generate-subsets', lambda a: generate_subsets(metta, a),
                                   ['Expression', 'Expression'], unwrap=False)
    return {
        r"gen-subsets": generateSubset
    }


def generate_partitions(metta, subsets, original):
    subsets = parseFromExpresstion(metta, subsets, 2)
    original = set(parseFromExpresstion(metta, original, 1))

    def backtrack(current_partition, used_elements):
        if used_elements == original:  # Base case: all elements are used
            # Sort the current partition to prevent external permutations
            sorted_partition = tuple(sorted(current_partition))
            if sorted_partition not in partitions:
                partitions.add(sorted_partition)
            return

        for subset in subsets:
            if not any(elem in used_elements for elem in subset):  # Ensure no overlap
                current_partition.append(subset)
                backtrack(current_partition, used_elements.union(set(subset)))
                current_partition.pop()

    # Sort each subset internally and convert to tuple to prevent internal permutations
    subsets = [
        tuple(sorted(subset)) for subset in subsets
        if subset and set(subset) != original
    ]

    partitions = set()  # Use a set to avoid duplicates
    backtrack([], set())
    partitions = list(partitions)
    partitions = str(partitions)

    atom = parseToExpression(metta, partitions)

    return atom

def remove_hashtag(metta, expression):
    # Remove hashtags from the expression
    print("Removing hashtags from:", expression)
    value = get_string_value(expression)
    value = re.sub(r"#\w+", "", value)
    return metta.parse_all(value)

   

@register_atoms(pass_metta=True)
def generete_partionReg(metta: MeTTa):

    # Define the operation atom with its parameters and function
    generatePartiton = OperationAtom('generate-partitions', lambda a, b: generate_partitions(metta, a, b),
                                     ['Expression', 'Expression', 'Expression'], unwrap=False)

    removeHashtag = OperationAtom('remove-hashtag-py', lambda a: remove_hashtag(metta, a),
                                     ['Expression', 'Expression'], unwrap=False)

    return {
        r"gen-partition": generatePartiton,
        r"remove-hashtag-py": removeHashtag
    }

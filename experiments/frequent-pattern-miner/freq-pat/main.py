from hyperon import *
from hyperon.ext import register_atoms
import regex as re
import random
import string
import sys
import os
import time

from hyperon.atoms import (
    ExpressionAtom,
    E,
    GroundedAtom,
    OperationAtom,
    ValueAtom,
    NoReduceError,
    AtomType,
    MatchableObject,
    VariableAtom,
    G,
    S,
    V,
    Atoms,
    get_string_value,
    GroundedObject,
    SymbolAtom,
)
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp


# def call_python_process(metta: MeTTa, pattern):
def call_python_process(metta: MeTTa):
    # metta.run('''
    # (= (abstract-recursive $p)
    #     (if (not (== (get-metatype $p) Expression))
    #         $p
    #         (let* (
    #                 ( ($link $x $y) $p)
    #                 ( $nx (abstract-recursive $x))
    #                 ( $ny (abstract-recursive $y))
    #             )
    #         (superpose (
    #                     ($link $nx $w)
    #                     ($link $z $ny)
    #                     ($link $x $u)
    #                     ($link $k $y)
    #                     $d
    #                     ($link $g $o)
    #                     ($link $nx $ny)
    #                 )
    #         )
    # )

    # )
    # )
    # ''')

    # run_str = f'!(abstract-recursive {pattern})'
    run_str = (
        f"!(match &specredspace (SpecializationOf $c $d) (SpecializationOf $c $d))"
    )

    patterns = metta.run(run_str)

    data = [str(item) for sublist in patterns for item in sublist]

    def clean_reserved_vars(expression):
        expression = re.sub(r"\$x#\d+", "$x", expression)
        expression = re.sub(r"\$y#\d+", "$y", expression)
        expression = re.sub(r"\$link#\d+", "$link", expression)
        return expression

    # Extract structure while ignoring specific variables
    def extract_structure(expression):
        # Replace all other variables except $x, $y, and $link with a placeholder
        expression = clean_reserved_vars(expression)
        return re.sub(r"\$\w+#\d+", "$var", expression)

    structure_dict = {}
    for expr in data:
        structure = extract_structure(expr)
        if structure not in structure_dict:
            structure_dict[structure] = expr

    def generate_random_var():
        return (
            "$"
            + "".join(random.choices(string.ascii_lowercase, k=1))
            + "".join(random.choices(string.digits, k=6))
        )

    unique_patterns = []
    for structure in structure_dict.keys():
        unique_structure = structure
        var_count = len(re.findall(r"\$var", structure))

        for _ in range(var_count):
            unique_var = generate_random_var()
            unique_structure = unique_structure.replace("$var", unique_var, 1)

        # unique_patterns.append(unique_structure)
        # unique_patterns.append(ValueAtom(metta.parse_single(unique_structure), 'Expression'))
        unique_patterns.append(metta.parse_single(unique_structure))
    # uni_patterns = ' '.join(unique_patterns)
    # atoms = metta.parse_single(uni_patterns)
    # return [ValueAtom(atoms, 'Expression')]

    return unique_patterns
def generate_var(metta: MeTTa, suffix):
    var =  f"$var{int(str(suffix))}"
    return [metta.parse_single(var)]


def replace_with_de_bruijn(metta: MeTTa, pattern):
    str_pattern = str(pattern)
    var_map = {}  # Maps variables to De Bruijn indices
    index = 0

    def get_de_bruijn(idx):
        return "Z" if idx == 0 else f"(S {get_de_bruijn(idx - 1)})"

    # Find all variables
    variables = re.findall(r"\$\w+(?:#\w+)?", str_pattern)

    for var in variables:
        if var not in var_map:
            var_map[var] = get_de_bruijn(index)
            index += 1
        str_pattern = str_pattern.replace(var, var_map[var], 1)

    return [metta.parse_single(str_pattern)]


def replace_with_variable(metta: MeTTa, pattern):
    str_pattern = str(pattern)
    de_bruijn_map = {}  

    def match_parentheses(string):
        missing = string.count("(") - string.count(")")
        return string + ")" * missing if missing > 0 else string

    def generate_random_var():
        return "$" + "".join(random.choices(string.ascii_lowercase, k=1)) + "".join(random.choices(string.digits, k=2))

    # Find all De Bruijn indices
    de_bruijn_indices = re.findall(r"(\(S(.*?)\)|\bZ\b)", str_pattern)
    for index in de_bruijn_indices:
        if index[0] not in de_bruijn_map:
            de_bruijn_map[index[0]] = generate_random_var()
        if index[0] == "Z":
            # Use regex to replace only standalone Z
            str_pattern = re.sub(r"\bZ\b", de_bruijn_map[index[0]], str_pattern, count=1)
        else:
            # Replace S-expressions directly
            str_pattern = str_pattern.replace(match_parentheses(index[0]), de_bruijn_map[index[0]], 1)



    return [metta.parse_single(str_pattern)]

def sort_conjunction(metta: MeTTa, conjunction):
    nested_str = str(conjunction)
    def extract(expr):
        expr = expr.strip()
        if expr.startswith("(,"):
            # Remove outer ( and ) and the ","
            inner = expr[1:-1].strip()[1:].strip()
            parts = []
            for match in re.finditer(r'\((?:[^()]++|(?R))*\)', inner):
                parts.extend(extract(match.group()))
            return parts
        else:
            return [expr]

    atoms = extract(nested_str)
    sorted_elements =  sorted(atoms)
    flattend_str = f"({' '.join(sorted_elements)})"
    return [metta.parse_single(flattend_str)]




@register_atoms(pass_metta=True)
def redundancy(metta):
    # redundancyFreeAtom = OperationAtom('redunpat', lambda patterns: call_python_process(metta, patterns), unwrap=False)
    redundancyFreeAtom = OperationAtom(
        "redunpat", lambda: call_python_process(metta), ["Expression"], unwrap=False
    )
    replace = OperationAtom(
        "replace", lambda pattern: replace_with_de_bruijn(metta, pattern), unwrap=False
    )
    replacev = OperationAtom(
        "replacev", lambda pattern: replace_with_variable(metta, pattern), unwrap=False
    )
    sort_conj = OperationAtom(
        "sort_conj", lambda conjunction: sort_conjunction(metta, conjunction), unwrap=False
    )
    gen_var = OperationAtom(
        "gen_var", lambda suffix: generate_var(metta, suffix), unwrap=False
    )
    return {r"redunpat": redundancyFreeAtom, r"replace": replace, r"replacev": replacev, r"sort_conj": sort_conj, r"gen_var": gen_var}



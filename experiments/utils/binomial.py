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


def parseToExpression(metta, strings):
    strings = strings.replace("[", "(").replace("]", ")").replace(
        ",", "").replace("\"", "").replace("'", "").replace("#", "")

    atom = metta.parse_all(strings)
    return atom

def calculate_binomial(metta, n_expr, k_expr):
    # Try to get integers from the expressions directly
    try:
        n = int(str(n_expr))
        k = int(str(k_expr))
    except (ValueError, TypeError):
        # Return a zero value if conversion fails
        return 0  # Return the actual number 0
    
    # Calculate binomial coefficient
    if k < 0 or k > n:
        result = 0
    elif k == 0 or k == n:
        result = 1
    else:
        k = min(k, n - k)
        result = 1
        for i in range(k):
            result = result * (n - i) // (i + 1)
    
    # Return the actual number instead of parsing it
    return result

@register_atoms(pass_metta=True)
def binomial_coefficient_reg(metta: MeTTa):
    binomial_atom = OperationAtom('calculate-binomial', 
                                lambda a, b: calculate_binomial(metta, a, b),
                                ['Number', 'Number', 'Number'])  # Make sure the return type is 'Number'
    
    return {
        r"binomial": binomial_atom
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
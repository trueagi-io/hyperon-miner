from hyperon import *
from hyperon.ext import register_atoms
import re
import sys
import os
import random
import string
import time

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom,\
    G, S,V, Atoms, get_string_value, GroundedObject, SymbolAtom
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp


# Function to generate a single variable with prefix and index
def gen_variable(prefix, i):
    # Create a variable as prefix + "-" + i (number)
    return f"{prefix}-{i}"



# Recursive function to generate a list of variables with prefix
def gen_variables(metta,prefix, n):  
    strn  = str(n)
    
    # Base case: if n is 0, return an empty list
    if n == 0:
        return []
    else:
        
        # Recursive case: generate the variables for n-1, append the current variable
        return gen_variables(metta,prefix, n - 1) + [gen_variable(prefix, n - 1)]
def generate_variables(metta,prefix,n):
    variables = gen_variables(metta,prefix,n)
    reconstructed_vars = "("
    for i,var in  enumerate(variables):
        if i<len(variables)-1:
            reconstructed_vars+=var+" "
        else:
            reconstructed_vars+=var
            
    reconstructed_vars += ")"
    combined_pattern = " ".join(("{}".format(var) for var in variables))
    combined_pattern = "("+combined_pattern+")"
    print(combined_pattern)
    atoms = metta.parse_all(combined_pattern)
    print(atoms)
    print(type(atoms))
	
    return (atoms[0])

    
@register_atoms(pass_metta=True)
def jsd_surprisingness(metta: MeTTa):
        

    # Define the operation atom with its parameters and function
    generateVar = OperationAtom('gen_variables', lambda a, b: generate_variables(metta,a, b),
                                      ['Atom', 'Atom', 'Expression'], unwrap=True)
  
    # generateRandomVar = OperationAtom('generateRandomVar', lambda a, b: (print(S(a),S(b)),generate_random_var(metta,a, b)[1],['Atom', 'Atom', 'Expression'], unwrap=False))

    return {
        r"gen-variables": generateVar
    }
    

    


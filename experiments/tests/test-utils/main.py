from hyperon import *
from hyperon.ext import register_atoms
import re
import sys
import os
import random
import string
import time
from hyperon.runner import MeTTa

from hyperon.atoms import ExpressionAtom, E, GroundedAtom, OperationAtom, ValueAtom, NoReduceError, AtomType, MatchableObject, VariableAtom,\
    G, S,V, Atoms, get_string_value, GroundedObject, SymbolAtom
from hyperon.base import Tokenizer, SExprParser
from hyperon.ext import register_atoms, register_tokens
import hyperonpy as hp
import random

def biased_rand(metta,b):
    """
    Generate a biased random boolean.
    
    Parameters:
    b (float): Bias in the range [0, 1]. When b tends to 1, the result tends to be True.
    
    Returns:
    bool: Random boolean with the specified bias.
    """
    b = int(str(b))
    result =  b > random.random()
    atom = metta.parse_all(f"{result}")
    return atom




def populate(metta ,n_cpts):
    concepts = []
    n_cpts  = int(str(n_cpts))
    for i in range(n_cpts):
        concept = f"CONCEPT_NODE C{i}"
        concepts.append(concept)
    results = metta.run(f"(py-list ((concat  'a' 'b')))")
    # Format each element and join them into a single string
    formatted_concepts = " ".join(f"({concept})" for concept in concepts)

    # Print the result
    print(formatted_concepts)
    atoms = metta.parse_all(formatted_concepts)
    return (atoms)

    
@register_atoms(pass_metta=True)
def jsd_surprisingness(metta: MeTTa):
        

    # Define the operation atom with its parameters and function
    populate_concepts = OperationAtom('populate_concepts', lambda a: populate(metta,a),
                                                                         ['Atom', 'Expression'], unwrap=False)
    biased_randbool = OperationAtom('biased_randbool', lambda a: biased_rand(metta,a),
                                                                            ['Atom', 'Expression'], unwrap=False)

    return {
        r"populate_concept": populate_concepts,
        r"biased_randbool": biased_randbool
    }
    

    


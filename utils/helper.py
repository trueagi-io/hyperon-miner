from hyperon.ext import register_atoms
from hyperon import *

@register_atoms
def count_atoms():
    count = OperationAtom(
        'TupleCount', 
        lambda atom: [ValueAtom(len(atom.get_children()), 'Number')], [AtomType.ATOM, "Number"], 
        unwrap=False)
    return {
        r"TupleCount": count
    }
 
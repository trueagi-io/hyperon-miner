from hyperon import *
from hyperon.ext import register_atoms
import random
import string
import time
from hyperon.atoms import OperationAtom, V
from hyperon.ext import register_atoms
import itertools
from itertools import combinations


def combine_lists_op(metta: MeTTa, var1, var2):
    input_str1 = str(var1)
    input_str2 = str(var2)

    list1 = parse_metta_structure(input_str1)
    list2 = parse_metta_structure(input_str2)

    combinations = generate_replacement_combinations(list1, list2)
    combined_pattern = " ".join(
        ["({})".format(" ".join(combo)) for combo in combinations]
    )

    combined_pattern_atoms = "(" + combined_pattern + ")"
    atoms = metta.parse_all(combined_pattern_atoms)
    return atoms


def generate_replacement_combinations(list1, list2):
    """Generate combinations by replacing elements in list2 with elements from list1"""
    result = []
    
    # For each element in list1, generate all possible replacements
    for element1 in list1:
        # Generate all possible positions where we can place this element
        for num_replacements in range(1, len(list2) + 1):
            # Get all combinations of positions to replace
            for positions in combinations(range(len(list2)), num_replacements):
                new_combo = list2.copy()
                for pos in positions:
                    new_combo[pos] = element1
                result.append(new_combo)
    
    # Generate combinations with multiple elements from list1
    for num_from_list1 in range(2, min(len(list1) + 1, len(list2) + 1)):
        for elements_from_list1 in combinations(list1, num_from_list1):
            # For each combination of elements from list1
            for num_positions in range(num_from_list1, len(list2) + 1):
                # Get all ways to place these elements in list2
                for positions in combinations(range(len(list2)), num_positions):
                    # Generate all permutations of the selected elements
                    for perm in itertools.permutations(elements_from_list1):
                        new_combo = list2.copy()
                        # Place the permuted elements in the selected positions
                        for i, pos in enumerate(positions[:len(perm)]):
                            new_combo[pos] = perm[i]
                        result.append(new_combo)
    
    # Remove duplicates while preserving order
    seen = set()
    unique_result = []
    for combo in result:
        combo_tuple = tuple(combo)
        if combo_tuple not in seen:
            seen.add(combo_tuple)
            unique_result.append(combo)
    
    return unique_result


def parse_metta_structure(input_str):
    """Convert a string like ($A $B $C) into a flat list ['$A', '$B', '$C']"""
    elements = []
    current = ""
    in_word = False

    for char in input_str:
        if char == "(":
            continue
        elif char == ")":
            if in_word:
                elements.append(current.strip())
                current = ""
                in_word = False
        elif char.isspace():
            if in_word:
                elements.append(current.strip())
                current = ""
                in_word = False
        else:
            current += char
            in_word = True

    if in_word:
        elements.append(current.strip())

    return elements


def generate_random_string(length=1):
    return "".join(random.choices(string.ascii_uppercase + string.digits, k=length))


def generate_random_var():
    base_name = "R-" + generate_random_string() + str(int(time.time()))
    new_var = V(base_name)
    return [new_var]


@register_atoms(pass_metta=True)
def cnj_exp(metta):
    combineLists = OperationAtom(
        "combine_lists",
        lambda var1, var2: combine_lists_op(metta, var1, var2),
        ["Atom", "Atom", "Expression"],
        unwrap=False,
    )
    generateRandomVar = OperationAtom(
        "generateRandomVar", lambda: generate_random_var(), ["Expression"], unwrap=False
    )
    return {r"combine_lists": combineLists, r"generateRandomVar": generateRandomVar}


# # Test the function
# if __name__ == "__main__":
#     # Test with your example
#     pat1 = ["$a", "$b"]
#     pat2 = ["$1", "$2"]
    
#     combinations = generate_replacement_combinations(pat1, pat2)
#     print("Generated combinations:")
#     for combo in combinations:
#         print(combo)

# from hyperon import *
# from hyperon.ext import register_atoms
# import random
# import string
# import time
# from hyperon.atoms import OperationAtom, V
# from hyperon.ext import register_atoms
# import itertools
# from itertools import combinations


# def combine_lists_op(metta: MeTTa, var1, var2):
#     input_str1 = str(var1)
#     input_str2 = str(var2)

#     list1 = parse_metta_structure(input_str1)
#     list2 = parse_metta_structure(input_str2)


#     combinations = range_combinations(list1, list2)
#     # combinations = combine_lists(list1, list2)
#     combined_pattern = " ".join(
#         ["({})".format(" ".join(combo)) for combo in combinations]
#     )

#     combined_pattern_atoms = "(" + combined_pattern + ")"
#     atoms = metta.parse_all(combined_pattern_atoms)
#     return atoms


# def range_combinations(list1, list2):
#     merged_list = list1 + list2
#     i, j = len(list2), len(list2)
#     res = []
#     for sub in range(j):
#         if sub >= (i - 1):
#             res.extend(combinations(merged_list, sub + 1))

#     res = [combo for combo in res if not set(combo).issubset(set(list2))]

#     all_permutations = []
#     for combo in res:
#         perms = [list(p) for p in itertools.permutations(combo)]
#         all_permutations.extend(perms)
#     return unique_combinations(all_permutations, list1, list2)
#     # return all_permutations


# def parse_metta_structure(input_str):
#     """Convert a string like ($A $B $C) into a flat list ['$A', '$B', '$C']"""
#     elements = []
#     current = ""
#     in_word = False

#     for char in input_str:
#         if char == "(":
#             continue
#         elif char == ")":
#             if in_word:
#                 elements.append(current.strip())
#                 current = ""
#                 in_word = False
#         elif char.isspace():
#             if in_word:
#                 elements.append(current.strip())
#                 current = ""
#                 in_word = False
#         else:
#             current += char
#             in_word = True

#     if in_word:
#         elements.append(current.strip())

#     return elements


# def flatten_list(nested_list):
#     flat_list = []
#     stack = [nested_list]
#     while stack:
#         current = stack.pop()
#         if isinstance(current, list):
#             stack.extend(reversed(current))
#         else:
#             flat_list.append(current)
#     return flat_list


# # Permutations not implemented yet and also the conjunction vars must be returned with the
# # generated combinations
# def combine_lists_recursive(
#     list1, list2, length, current_combination=None, index1=0, index2=0
# ):
#     if current_combination is None:
#         current_combination = []

#     if len(current_combination) == length:
#         return [current_combination]

#     combinations = []

#     for i in range(index1, len(list1)):
#         new_combination = current_combination + [list1[i]]
#         combinations.extend(
#             combine_lists_recursive(
#                 list1, list2, length, new_combination, i + 1, index2
#             )
#         )

#     for j in range(index2, len(list2)):
#         new_combination = current_combination + [list2[j]]
#         combinations.extend(
#             combine_lists_recursive(
#                 list1, list2, length, new_combination, index1, j + 1
#             )
#         )

#     return unique_combinations(combinations, list1, list2)
#     # return combinations


# def combine_lists(list1, list2):
#     length = len(list2)
#     return combine_lists_recursive(list1, list2, length)


# def unique_combinations(combinations, list1, list2):
#     # print(list2)
#     flat_list1 = flatten_list(list1)
#     flat_list2 = flatten_list(list2)
#     print(flat_list1)
#     print(flat_list2)

#     seen = set()
#     unique_combos = []
#     list1_set = [str(item) for item in flat_list1]
#     list2_set = [str(item) for item in flat_list2]
#     # print(list1_set)
#     # print(list2_set)
#     for combo in combinations:
#         # sorted_combo = tuple(sorted(str(item) for item in combo))
#         sorted_combo = tuple(str(item) for item in combo)
#         combo_set = sorted_combo
#         print("this",combo_set)
#         if (
#             sorted_combo not in seen
#         ):
#             has_element_from_list1 = any(str(item) in list1_set for item in combo)
#             has_element_from_list2 = any(str(item) in list2_set for item in combo)

#             # If the combination has only one element, ensure it comes from list1
#             if len(combo) == 1:
#                 if has_element_from_list1:
#                     seen.add(sorted_combo)
#                     unique_combos.append(combo)
#             # Otherwise, ensure it has at least one element from both lists
#             elif has_element_from_list1:
#                 seen.add(sorted_combo)
#                 unique_combos.append(combo)
#     return unique_combos
#     # return seen


# def generate_random_string(length=1):
#     return "".join(random.choices(string.ascii_uppercase + string.digits, k=length))


# def generate_random_var():
#     base_name = "R-" + generate_random_string() + str(int(time.time()))
#     new_var = V(base_name)

#     return [new_var]
    


# @register_atoms(pass_metta=True)
# def cnj_exp(metta):
#     combineLists = OperationAtom(
#         "combine_lists",
#         lambda var1, var2: combine_lists_op(metta, var1, var2),
#         ["Atom", "Atom", "Expression"],
#         unwrap=False,
#     )
#     generateRandomVar = OperationAtom(
#         "generateRandomVar", lambda: generate_random_var(), ["Expression"], unwrap=False
#     )
#     return {r"combine_lists": combineLists, r"generateRandomVar": generateRandomVar}


# # print(unique_combinations([["a", "b"], ["c", "d"]], ["a", "b"], ["c", "d"]))
# # print(combine_lists(["a", "b"], ["c",         "d"]))
# print(combine_lists(["a", "b"], ["d", "e "]))


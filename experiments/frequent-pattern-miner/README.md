# Frequent Pattern Miner

The `frequent-pattern-miner` is a modular pipeline for mining **frequent patterns** from a given atomspace. It extracts abstract patterns, specializes them, filters them by support, and constructs deeper conjunctive patterns and returns only the meaningful based on the support they have.

---


## 🔧 Purpose

To find patterns that **frequently occur** in the atomspace, using a multi-step symbolic mining approach that includes abstraction, specialization, support evaluation, and conjunctive expansion.

---

##  Parameters

| Parameter      | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `$dbspace`     | The atomspace to mine from.                                          |
| `$specspace`   | Space to store specialized patterns.                                        |
| `$cndpspace`   | Space to store candidate patterns.                                          |
| `$aptrnspace`  | Space to store abstract patterns.                                           |
| `$conjspace`   | Space to store pattern conjunctions.                                        |
| `$minsup`      | Minimum support threshold for a pattern to be considered frequent.         |
| `$depth`       | Depth of conjunction expansion (via De Bruijn index).                      |

---

##  How It Works (Pipeline Overview)

### Step 1 — Abstract Pattern Mining (`abstract-pattern`)
- Extract **unique link patterns** from the database.
- Turn them into **abstract patterns** using variables.
- Compute **support** for each, and store only those meeting `$minsup` in `$aptrnspace`.

### Step 2 — Specialization (`build-specialization`)
- Take each abstract pattern and **generate specialized versions** based on how they match in the atomspace.
- Store them in `$specspace`.

### Step 3 — Candidate Generation
- Evaluate the **support of specialized patterns**.
- If the support ≥ `$minsup`, store them in `$cndpspace` as **candidates**.

### Step 4 — Conjunction Expansion (`do-conjunct`)
- Recursively **combine candidate patterns** into deeper conjunctions up to `$depth`.
- Clean up redundant clauses.
- Keep only conjunctions meeting support requirements, storing them in `$conjspace`.

### Step 5 — Finalization
- Format and return the valid patterns with support annotations.

---

## Output

- A structured set of **frequent patterns** (including conjunctions) stored in `$kb`, each annotated with its computed support value.
- These patterns are useful for reasoning, classification, or higher-level symbolic analysis.



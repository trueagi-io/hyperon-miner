# Pattern Miner (PeTTa Edition)

## Description

The goal of this project is to port the classic Pattern Miner to Hyperon using MeTTa, the language of OpenCog Hyperon, using PeTTa which is a high-performance interpreter for the MeTTa language. Pattern Miner is used to identify not only frequent patterns but also interesting or surprising patterns in the large hypergraph space (Atomspace). This capability is crucial for inference, learning, and cognitive architectures.

Following the original logic from OpenCog Classic and its Hyperon/MeTTa port, this version is optimized to run in the PeTTa environment.

## How it works (Simplified)
This pattern miner is to mine frequent and interesting patterns from Hypergraph AtomSpace. In order to do that, it will first mine frequent patterns and store them in a new space, which will be passed to the surprisingness components to score each pattern's surprisingness value.

**To Mine Frequent Patterns:**
- Mine Abstract Patterns:
Query link nodes, form abstract patterns with variables, and filter by minimum support.

- Specialize Patterns:
Break abstract patterns into triplets, apply valuations (including nested expressions), and build specializations.

- Select Candidate Patterns:
Evaluate support for specialized patterns and keep those meeting the support threshold.

- Expand via Conjunction:
Combine candidate patterns through variable mapping, remove redundancy, and normalize structure.

- Surprisingness Scoring (Optional):
  - Compute the empirical probability of a pattern based on support or bootstrapped sampling

  - Divide the pattern into partitions of sub-patterns

  - For each partition, compute a probability estimate assuming independence between blocks

  - From these estimates, determine the minimum (emin) and maximum (emax) probable values

  - Compute the distance between the empirical probability and the interval emin,emax

  - Optionally normalize this distance using the empirical value

## Getting Started with PeTTa

This project requires **PeTTa**. For installation instructions and setup guides, please refer to the official PeTTa repository:
- [**PeTTa Repository & Setup Guide**](https://github.com/trueagi-io/PeTTa/tree/main)

## Running the Code

### How to Run on Your Data

We have provided a starter script `run_miner.metta` in the root directory.

1.  **Open `run_miner.metta`** and find the dataset import line:
    ```metta
    !(import! &db experiments/data/ugly_man_sodaDrinker)
    ```
    Change this path to point to your own `.metta` dataset.

2.  **Adjust Parameters** (optional):
    You can change the minimum support (frequency) or pattern depth in the miner call:
    ```metta
    ;; (pattern-miner output input min-support depth mode normalization db-ratio conj-exp)
    !(pattern-miner &res &db 3 0 none none none True)
    ```


3.  **Run with PeTTa**:
    Assuming you have the PeTTa `run.sh` script (from the PeTTa repository):
    ```bash
    sh {"path-to-petta run.sh file"} {"path to run_miner.metta"}
    ```


## Project Structure
- `experiments/pattern-miner`: The main entry point for mining.
- `experiments/frequent-pattern-miner`: Logic for finding frequent itemsets/links.
- `experiments/surprisingness`: Logic for calculating how surprising a pattern is.
- `experiments/validation`: Tests and validation files to prove correctness.


#  Pattern Miner

This module mines **frequent patterns** from a knowledge base, with **optional surprisingness scoring**.  
It is a **functional implementation** of a pattern mining pipeline written in MeTTa.

##  How It Works

1. **Frequent Pattern Mining**:  
   The miner first extracts frequent patterns from the input corpus using a specified minimum support and pattern depth.

2. **Surprisingness Scoring** *(Optional)*:  
   If a **surprisingness mode** is selected, the patterns are evaluated based on how unexpected they are.

3. **Output**:
   If `surp-mode` is `none` → Only frequent patterns are returned:  
     ```
     (supportOf $pattern $support)
     ```
   If `surp-mode` is not `none` → Each pattern is scored for surprisingness:  
     ```
     (surprisingnessOf $pattern $score)
     ```

## Surprisingness Modes

| Mode        | Normalization | Description |
|-------------|---------------|-------------|
| `none`      | `none`        | **(Default)** No surprisingness. Returns only frequent patterns with support count. |
| `isurp`     | `True`        | **(Recommended)** Computes information-theoretic surprisingness **normalized** (0-1). |
| `isurp`     | `False`       | Computes raw information-theoretic surprisingness score. |
| `jsd`       | `none`        | Uses **Jensen-Shannon Divergence** to measure statistical distance/surprise. |
| `isurp-old` | `False`       | Legacy surprisingness implementation. |




##  Requirements
- **PeTTa** Interpreter
- A corpus (dataset) you want to mine patterns from
- This `hyperon-miner` repository structure

##  How to Run
To use the pattern miner, create a new `.metta` script (e.g., `run_miner.metta`) and import the necessary modules.

### Example Script
```metta
;; Adjust paths based on where you create this file!
;; If this file is in the 'experiments/pattern-miner' folder:

;; 1. Import the Frequent Pattern Miner modules
!(import! &self ../frequent-pattern-miner/build-specialization)
!(import! &self ../frequent-pattern-miner/candidate-patterns)
!(import! &self ../frequent-pattern-miner/conjunction-expansion)
!(import! &self ../frequent-pattern-miner/frequent-pattern-miner)

;; 2. Import the Pattern Miner Main Logic
!(import! &self pattern-miner)

;; 3. Import your Corpus (Data)
!(import! &db ../../data/ugly_man_sodaDrinker)

;; 4. Prepare Spaces
!(bind! &res (new-space))

;; 5. Run the Miner
;; (pattern-miner $kb $db $minsup $depth $surp-mode $normalization $db-ratio $conj_exp)
!(pattern-miner &res &db 3 0 none none none True)
```


### Execution
Run your script using PeTTa:
```bash
petta run_miner.metta
```



##  Expected Output Format

### Without Surprisingness (`none`)
```
(supportOf (link A B) 4)
(supportOf (link B C) 3)
```

### With Surprisingness (`isurp-old` or `nisurp-old`)
```
(surprisingnessOf (link A B) 0.71)
(surprisingnessOf (link B C) 0.35)
```
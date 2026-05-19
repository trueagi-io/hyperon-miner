# Validation Report: Porting Pattern Miner from OpenCog to Hyperon

## 1. Introduction

This report documents the validation process conducted during the porting of the Pattern Miner from OpenCog Classic to Hyperon. The goal of validation was to ensure that the new Hyperon implementation produces results consistent with the classic OpenCog miner when applied to the same knowledge base (KB).

## 2. Dataset for Validation

The validation used a controlled knowledge base of inheritance relationships describing individuals and their attributes.

### 2.1 Classic Atomese Representation

Example:

```scheme
(define AllenHuman
  (InheritanceLink
    (ConceptNode "Allen")
    (ConceptNode "human")))

(define AllenMan
  (InheritanceLink
    (ConceptNode "Allen")
    (ConceptNode "man")))

(define AllenUgly
  (InheritanceLink
    (ConceptNode "Allen")
    (ConceptNode "ugly")))

(define AllenSodaDrinker
  (InheritanceLink
    (ConceptNode "Allen")
    (ConceptNode "soda drinker")))
```

### 2.2 Hyperon Representation (ported)

Example:

```scheme
(Inheritance Allen human)
(Inheritance Abe man)
(Inheritance Lily woman)
(Inheritance Allen ugly)
(Inheritance Abe sodaDrinker)
```

The full dataset included 20+ individuals (Allen, Abe, Cason, Davion, etc.), each associated with categories such as human, man, woman, ugly, and soda drinker.

## 3. Validation of Component

### 3.1 Validation of JSD Implementation

#### 3.1.1 Background

During validation of the Hyperon Pattern Miner against the OpenCog Classic baseline, discrepancies were identified in the results of the Jensen–Shannon Divergence (JSD) calculation. Since JSD is a key component for evaluating the similarity of distributions, misalignment here directly caused mismatched outcomes in downstream pattern mining tasks.

#### 3.1.2 Previous Implementation

The initial Hyperon implementation of do-jsd was simplified:

- Operated directly on the strength values of two truth values (empirical and estimated distributions).
- Calculated a midpoint distribution as the average of strengths.
- Approximated entropy contributions using logarithmic ratios of empirical vs midpoint and estimated vs midpoint.
- Returned the square root of the sum of contributions.

Limitations observed during validation:

- Over-simplified representation of distributions.
- Ignored the underlying statistical distribution (Beta distribution) that OpenCog Classic uses.
- Produced results deviating from the baseline, especially in edge cases where truth value confidence was low or skewed.

#### 3.1.3 New Implementation (Validation-driven Refinement)

To address these issues, the JSD implementation was revised to closely match the OpenCog Classic approach:

- Introduced Beta distributions for each truth value, derived from (mean, confidence).
- Used boost::math::beta_distribution (via Python SciPy wrapper in boost-math-cdf) for accurate probability distribution modeling.
- Computed CDF values over a fixed number of bins (default = 10) to approximate probability mass.
- Calculated Kullback–Leibler Divergence (KLD) between distributions and averaged them.
- Returned the square root of the average KLD, consistent with the classic JSD definition.

Helper functions added:

- mk_distribution_jsd → construct Beta distribution from truth value.
- beta_cdf, beta_cdf_loop → generate sampled CDF values.
- kld, kld_loop → compute relative entropy bin-by-bin.
- avrg_cdf, avrg → compute midpoint distributions.
- boost-math-cdf → SciPy wrapper replicating Boost C++ Beta CDF.

#### 3.1.4 Validation Outcome

| Test Case                  | OpenCog Classic | Hyperon (Old) | Hyperon (Refined) | Alignment |
|----------------------------|-----------------|---------------|-------------------|-----------|
| Symmetric TV (0.5, 0.9 vs 0.5, 0.9) | 0.000 | 0.120 | 0.000 | true |
| Skewed TV (0.1, 0.7 vs 0.9, 0.7)   | 0.420 | 0.310 | 0.421 | true |
| Low Confidence (0.6, 0.2 vs 0.6, 0.2) | 0.000 | 0.085 | 0.000 | true |

- Before fix: The old implementation yielded inconsistent JSD values compared to OpenCog, particularly on asymmetric or uncertain distributions.

## 4. PeTTa Port Validation

As part of the migration to the **PeTTa** interpreter, all validation tests were re-run to ensure consistency between the original MeTTa/Hyperon implementation and the PeTTa environment.

### 4.1 Results
The validation suite confirmed that:
- **Output Consistency**: The PeTTa interpreter produced identical outputs to the reference MeTTa implementation for all key algorithms (JSD, Surprisingness, Frequent Mining).
- **Correctness**: Key logic handling distribution calculations and pattern matching functioned as expected.

The validation files can be run using the provided `run.sh` script to verify these results locally.

- After fix: With the new Beta-distribution-based approach, Hyperon now produces JSD values that align with OpenCog Classic results.
- Alignment status: Confirmed equivalence within numerical tolerance.

### 3.2 Validation of Probability and Surprise Computation

#### Background

The probability (prob) and derived surprise (isurp) functions are central to the Pattern Miner. During validation, discrepancies were observed between Hyperon’s initial implementation and OpenCog classic, particularly in probability estimation across recursive computations.

#### Issues in Previous Implementation

- Probability was computed inline using support counts and total counts, but total_count was not consistently propagated across recursive calls.
- Recursive functions (blk-prob, iprob, isurp) recalculated totals implicitly, leading to misaligned values.
- As a result, probability values for complex partitions diverged from the OpenCog baseline, and isurp intervals became unstable.

#### Changes Introduced (Validation-driven Refinement)

- Introduced total_count as an explicit parameter across all related functions.
- Ensured consistent propagation of total_count through recursive computations (blk-prob, iprob_, iprob, isurp).
- Reorganized isurp so that total_count is computed once and reused, avoiding hidden recomputation.

#### Validation Outcome

- Before fix: Probability values mismatched with classic OpenCog, and surprise values showed significant deviation.
- After fix: Both probability and surprise computations aligned with OpenCog results within numerical tolerance.
- Alignment status: Confirmed equivalence with the classic implementation.

### 3.3 Validation of Joint-Independent Truth Value Estimation (EST-TV)

#### Background

Joint-Independent Truth Value Estimation (JITVE) is a critical component in the Hyperon Pattern Miner. It estimates the empirical truth value of a pattern under the assumption that its constituent blocks are independent, while accounting for joint variables shared across blocks. Accurate estimation of JITVE is essential for downstream calculations such as pattern ranking and surprise evaluation.

#### Issues in Previous Implementation

- The original implementation relied on a large, monolithic function (eq-prob) to compute probabilities for joint variables, which was difficult to maintain and prone to errors.
- The computation attempted to find the lowest upper-bound value across partitions, but recursive handling of joint variables and abstraction ordering was inconsistent.
- Probability estimates for shared variables sometimes diverged from the OpenCog classic baseline, particularly for patterns with multiple overlapping variables.

#### Changes Introduced (Validation-driven Refinement)

- eq-prob was refactored into a structured pipeline: identifying joint variables, extracting connected subpatterns, sorting them by abstraction level, and incrementally calculating probability contributions.
- Recursive handling of partitions ensures consistent propagation of probability estimates across all blocks.
- Helper functions were introduced to filter connected subpatterns, determine joint variables, and calculate probabilities for each variable based on database occurrences.
- Abstraction ordering guarantees that probability estimates are based on the most specialized blocks first, improving alignment with the original OpenCog behavior.

### 3.4 Validation of expand_conjunction

#### Background

expand_conjunction is a critical component in the Hyperon Pattern Miner. It expands a given pattern by considering all possible connections (linkages) and creating new conjunctions accordingly. Accurate expansion of conjunctions is essential for downstream calculations such as pattern ranking and surprisingness evaluation.

#### Issues in Previous Implementation

- The original implementation uses all possible combinations of variables from two patterns without considering the positions of the variables. This leads to incorrect conjunctions where the order of variables does not match their original positions in the patterns. and gives extra conjunctions from the classic result.

#### New Implementation

- The new implementation keeps track of the positions of the variables to generate the correct conjunctions and give same order of the variables as the classic implementation.

#### Validation outcome 
- Before fix:
    ```
     cnjtion = (Inheritance X Y)
     pattern = (Inheritance Z W)
  
   return
  
     (, (Inheritance X Y) (Inheritance X W))
     (, (Inheritance X Y) (Inheritance Z X))
     (, (Inheritance X Y) (Inheritance Y W))
     (, (Inheritance X Y) (Inheritance Z Y))
     (, (Inheritance X Y) (Inheritance X Z))
     (, (Inheritance X Y) (Inheritance W X))
     (, (Inheritance X Y) (Inheritance W Y))
     (, (Inheritance X Y) (Inheritance Y Z))
     (, (Inheritance X Y) (Inheritance X Y))
     (, (Inheritance X Y) (Inheritance X X))
     (, (Inheritance X Y) (Inheritance Y Y))
    ``` 
- After fix: With the new implementation, the number of conjunctions matches the OpenCog baseline, and the order of variables in each conjunction is correct.
    ```
     cnjtion = (Inheritance X Y)
   pattern = (Inheritance Z W)
  
   return
  
     (, (Inheritance X Y) (Inheritance X W))
     (, (Inheritance X Y) (Inheritance Z X))
     (, (Inheritance X Y) (Inheritance Y W))

     (, (Inheritance X Y) (Inheritance Z Y))
     (, (Inheritance X Y) (Inheritance X Y))
     (, (Inheritance X Y) (Inheritance X X))
     (, (Inheritance X Y) (Inheritance Y Y))
    ```
the above examples are results of the combination and the generated conjunctions but they will further be filtered out based on the minimum support, knowledge base and clause content.

### 3.5 Validation of remove_useless_clause

#### Background

remove_useless_clause is a critical component in the Hyperon Pattern Miner. It removes abstract clauses, constant clauses and redundant subpatterns from a conjuncted pattern. Accurate removal of redundant clauses is essential for reducing the amount of patterns that pass for the next step, it also helps remove patterns that have clauses that add no additional information to the pattern.

#### Issues in Previous Implementation

- There was no original implementation and only used remove redundant clauses for filtering out conjunctions.

#### Changes Introduced (Validation-driven Refinement)

- Implemented the whole of remove_useless_clauses

#### Validation Outcome

- Before fix: There was no removal of Abstract clauses, constant clauses and redundant subpatterns.
- After fix: With the new implementation,
    1. Abstract clauses are removed.
    2. Constant clauses are removed.
    3. Redundant subpatterns are removed.

### 3.6 Validation of frequent pattern miner as a whole

#### Background

The frequent pattern miner is the main component of the pattern miner. It mines frequent patterns from the atomspace. Accurate mining of frequent patterns is essential for downstream calculations such as pattern ranking and surprisingness evaluation.

#### Issues in Previous Implementation

- Abstract patterns were discarded after specilized but in the classic miner implementation they are kept as mined patterns and get passed for the next steps.
- patterns that have the same value for the nodes were being given different values in the specializations
- patterns that have depth and the depth has nodes with the same value were not being mined correctly.

#### Changes Introduced (Validation-driven Refinement)

- kept the abstract patterns after specialization
- fixed the issue of patterns that have the same value for the nodes
- fixed the issue of patterns that have depth and the depth has nodes with the same value

did the above for both the functional and chainer based implementations.
#### Validation Outcome

- Before fix: 
    1. patterns like (Inheritance $x $y) were discarded after being specialized.
    2. patterns like (Inheritance A A) and (Inheritance (link A A) (link A A))... were being given different values in the specializations.
- After fix: With the new implementation, the above issues are fixed. and there are no patterns being missed.

Due to the speed problem caused by this change it is kept as version two of pattern miner.

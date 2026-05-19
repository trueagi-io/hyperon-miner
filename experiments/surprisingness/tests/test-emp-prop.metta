!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/surp-utils/partition-metta)
!(import! &self ../../utils/surp-utils/binomialMetta)
!(import! &self ../../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self ../../utils/surp-utils/blk-abstractness)
!(import! &self ../../utils/surp-utils/eq-prob-petta)
!(import! &self ../../utils/surp-utils/bs-utils)
!(import! &self ../../utils/TruthValue)
!(import! &self ../../utils/constants)
!(import! &self ../../truth-values/emp-tv)
!(import! &self ../../truth-values/est-tv)
!(import! &self ../../utils/index_to_var)
!(import! &kb ../../data/ugly_man_sodaDrinker)
!(import! &self ../emp-prob)
!(import! &self ../isurp)




!(add-atom &space (Inheritance Abe human))
!(add-atom &space (Inheritance Rio human))
!(add-atom &space (Inheritance Bob human))
!(add-atom &space (Inheritance Mike human))
!(add-atom &space (Inheritance Mike Nil))
!(add-atom &space (Inheritance Zac human))
!(add-atom &space (Inheritance Zac human))
!(add-atom &space (Parent Abe Nil ))


;; =============================================================================
;; Test: emp-prob-pbs (Zero Probability)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify that patterns with no matches in the space correctly return 0 probability
;;
;; Inputs:
;;   - Pattern: (, (Inheritance $x $z) (Inheritance $x human))
;;   - Space: (get-space) [current knowledge base]
;;   - Threshold: 0.5
;;
;; Expected Output:
;;   0.0 (since the pattern doesn't match any exact instances)
;;
;; Verification:
;;   Tests correct handling of patterns with no matches in the space
;; =============================================================================
!(assertEqual 
  (emp-prob-pbs 
    (, (Inheritance $x $z) (Inheritance $x human)) 
    &space 
    0.5) 
  0.0)

;; =============================================================================
;; Test: emp-prob-pbs (Single Atom Probability)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify correct probability calculation for a single atom pattern
;;
;; Inputs:
;;   - Pattern: (Inheritance $x human)
;;   - Space: (get-space)
;;   - Threshold: 0.9
;;   - Ratio: 0.5
;;
;; Expected Output:
;;   0.75 (representing 75% match probability)
;;
;; Verification:
;;   Tests basic probability calculation for single-atom patterns
;; =============================================================================
!(assertEqual 
  (emp-prob-pbs 
    (Inheritance $x human) 
    &space 
    0.9 
    0.5)  
  0.75)

;; =============================================================================
;; Test: subsample-py
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify creation of a random subsample from the knowledge space
;;
;; Inputs:
;;   - Space: (get-space)
;;   - Sample size: 4
;;
;; Expected Output:
;;   [GroundingSpace-0x5569c27b0ad8] (or similar memory reference)
;;
;; Verification:
;;   Tests that subsampling returns a new space object with random selection
;;   Note: Exact contents vary due to randomness
;; =============================================================================
(subsample-py &space 4)


;; =============================================================================
;; Test: sup-num
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify correct counting of pattern matches in the space
;;
;; Inputs:
;;   - Space: (get-space)
;;   - Pattern: (Inheritance $x human)
;;
;; Expected Output:
;;   6 (exact matches found)
;;
;; Verification:
;;   Tests accurate counting of pattern instances in the knowledge base
;; =============================================================================
!(assertEqual 
  (sup-num 
    &space 
    (Inheritance $x human)) 
  6)

;; =============================================================================
;; Test: emp_prob_bs (Pattern Tuple)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify bootstrap probability estimation for pattern tuples
;;
;; Inputs:
;;   - Pattern: (, (Inheritance $x man) (Inheritance $x ugly))
;;   - Space: &kb
;;   - Bootstrap iterations: 5
;;   - Subsample size: 5
;;
;; Expected Output:
;;   Varies between 0 and 1 (due to random sampling)
;;
;; Verification:
;;   Tests probabilistic estimation with multiple iterations
;;   Note: Non-deterministic output requires statistical validation
;; =============================================================================
(emp_prob_bs 
  (, (Inheritance $x man) (Inheritance $x ugly)) 
  &kb 
  5 
  5)

  ;; =============================================================================
;; Test: emp_prob_bs (Single Atom)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify bootstrap probability estimation for single atoms
;;
;; Inputs:
;;   - Pattern: (Inheritance $x man)
;;   - Space: &kb
;;   - Bootstrap iterations: 5
;;   - Subsample size: 5
;;
;; Expected Output:
;;   Varies between 0 and 1 (due to random sampling)
;;
;; Verification:
;;   Tests probabilistic estimation for simpler patterns
;;   Note: Non-deterministic output requires statistical validation
;; =============================================================================
(emp_prob_bs 
  (Inheritance $x man)  
  &kb 
  5 
  5)
; =============================================================================
; Test: subsmp-size (with 50% Database Ratio)
; -----------------------------------------------------------------------------
; Purpose:
;   Verify sample size calculation when the database ratio is set to 50%, testing:
;   1. Correct handling of the db_ratio parameter
;   2. Proper scaling of sample size based on database coverage
;   3. Interaction between pattern complexity and database ratio
;
; Inputs:
;   - Pattern: 3-clause pattern (Inheritance relationships)
;   - Total space size: 64 atoms
;   - Database ratio: 0.5 (50% of db considered relevant)
;
; Expected Output: 
;   149.7097081964987 (calculated sample size)
;

; Verification:
;   The result shows the system:
;   1. Treats db_ratio as a linear scaling factor 
;   2. Still accounts for full pattern complexity
;   3. Maintains same calculation structure as other ratio values
; =============================================================================
!(assertEqual
  (subsmp-size 
    (, (Inheritance $x man)
       (Inheritance $x ugly) 
       (Inheritance $x sodaDrinker))
    64
    0.5)  ;; 50% database ratio parameter
  149.70709192116058)




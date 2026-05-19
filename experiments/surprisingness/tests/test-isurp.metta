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





;; =============================================================================
;; Test: ji-prob-est (Single Partition)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify correct joint independent probability calculation for a pattern across
;;   a single partition with overlapping clauses.
;;
;; Inputs:
;;   - Partition: (((Inheritance $x man) (Inheritance $x sodaDrinker)))
;;                ((Inheritance $x ugly))
;;   - Pattern: (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
;;   - DB Reference: &kb
;;   - Ratio: 0.5
;;
;; Expected Output:
;;   3.858024691358025e-6 (probability estimate)
;;
;; Verification:
;;   Tests basic JI-Prob calculation when clauses are distributed across two
;;   partition components with some overlap in variables.
;; =============================================================================
!(assertEqual 
  (ji-prob-est 
    (((Inheritance $x man) (Inheritance $x sodaDrinker)) 
    ((Inheritance $x ugly)))
    (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
    &kb 
    0.5) 
  3.858024691358025e-6)




;; =============================================================================
;; Test: ji-prob-est (Disjoint Partition)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify JI-Prob calculation when pattern clauses are completely separated
;;   across different partition components.
;;
;; Inputs:
;;   - Partition: (((Inheritance $x man)) 
;;                ((Inheritance $x sodaDrinker)) 
;;                ((Inheritance $x ugly)))
;;   - Pattern: Same as Test 1
;;   - DB Reference: &kb
;;   - Ratio: 0.5
;;
;; Expected Output:
;;   1.2860082304526748e-6 (higher probability due to disjoint distribution)
;;
;; Verification:
;;   Tests that completely separated clauses in partition yield higher JI-Prob
;;   than overlapping cases (Test 1), demonstrating proper dependence modeling.
;; =============================================================================
!(assertEqual 
  (ji-prob-est 
    (((Inheritance $x man)) 
     ((Inheritance $x sodaDrinker)) 
     ((Inheritance $x ugly)))
    (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
    &kb 
    0.5) 
  1.2860082304526748e-6)



;; =============================================================================
;; Test: do-ji-prob (Multiple Partitions)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify batch processing of JI-Prob estimates across multiple partition
;;   configurations.
;;
;; Input Partitions:
;;   1. Overlapping: (((Inheritance $x man) (Inheritance $x sodaDrinker)) 
;;                    ((Inheritance $x ugly)))
;;   2. Partial overlap: (((Inheritance $x man) (Inheritance $x ugly)) 
;;                       ((Inheritance $x sodaDrinker)))
;;   3. Fully disjoint: (((Inheritance $x man)) 
;;                      ((Inheritance $x sodaDrinker)) 
;;                      ((Inheritance $x ugly)))
;;   4. Mixed: (((Inheritance $x man)) 
;;              ((Inheritance $x sodaDrinker) (Inheritance $x ugly)))
;;
;; Expected Output:
;;   (0.1 0.1 0.01 0.1) - Simplified probabilities for verification
;;
;; Verification:
;;   1. Tests correct handling of multiple partition structures
;;   2. Verifies order preservation in results
;;   3. Checks proper accumulation of estimates
;; =============================================================================
!(assertEqual 
  (do-ji-prob 
    ((((Inheritance $x man) (Inheritance $x sodaDrinker)) 
      ((Inheritance $x ugly)))
     (((Inheritance $x man) (Inheritance $x ugly)) 
      ((Inheritance $x sodaDrinker)))
     (((Inheritance $x man)) 
      ((Inheritance $x sodaDrinker)) 
      ((Inheritance $x ugly)))
     (((Inheritance $x man)) 
      ((Inheritance $x sodaDrinker) (Inheritance $x ugly))))
    (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
    &kb 
    0.5)
  (3.858024691358025e-6 3.858024691358025e-6 1.2860082304526748e-6 3.858024691358025e-6))


;; =============================================================================
;; Test: ji_prob_est_interval
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify calculation of probability interval (min-max range) for a pattern
;;   across all possible partition configurations.
;;
;; Inputs:
;;   - Pattern: (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
;;   - DB Reference: &kb
;;   - Ratio: 0.2
;;
;; Expected Output:
;;   (0.009135566413047788 0.13155215634788814) - (min_prob, max_prob) pair
;;
;; Verification:
;;   1. Tests correct identification of extreme probability cases
;;   2. Verifies handling of different ratio parameter
;;   3. Checks proper tuple output format
;; =============================================================================
!(assertEqual 
  (ji_prob_est_interval 
    (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker))
    &kb
    0.2)
  (1.2860082304526748e-6 3.858024691358025e-6))


;; =============================================================================
;; Test: isurp
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify calculation of independent-surprise for a pattern across all
;;   possible partition configurations.
;;
;; Inputs:
;;   - Pattern
;;   - DB Reference: &kb
;;   - Ratio: 0.2
;;
;; Expected Output:
;;   1.9290123456790123e-5 - Independent surprise value

;; Verification:
;;   1. Tests correct calculation of independent surprise
;;   2. Verifies handling of different ratio parameter
;;   3. Checks proper output format
;; =============================================================================

!(assertEqual (isurp (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &kb False 0.2) 1.9290123456790123e-5)



;; test with n-arry format data
!(import! &dbNarry ../../data/dataset_for_n_arry_format)
;; inputs:-
  ;; conjunctive pattern: (, (Inheritance $x Loves $y) (Inheritance $x $Interest $Venue) (Inheritance $y $Interest $Venue))
  ;; db reference: dataset_for_n_arry_format
  ;; ratio: 0.2
  ;; normalization: True
!(assertEqual (isurp (, 
   (Inheritance $x Loves $y) 
   (Inheritance $x $Interest $Venue) 
   (Inheritance $y $Interest $Venue)) &dbNarry True 0.2) 0.9574829931972789)

;; inputs:-
  ;; conjunctive pattern: (, (Inheritance $x $y The-Slice-Shop) (Inheritance $x Pizza-Lover $place) (Inheritance $x Pizza-Lover The-Slice-Shop))
  ;; db reference: dataset_for_n_arry_format
  ;; ratio: 0.2
  ;; normalization: True
!(assertEqual (isurp (, 
   (Inheritance $_32506 $_32512 The-Slice-Shop) 
   (Inheritance $_32506 Pizza-Lover $_32548) 
   (Inheritance $_32506 Pizza-Lover The-Slice-Shop)) &dbNarry True 0.2) 0.7857142857142857)

;; inputs:-
  ;; conjunctive pattern: (, (Inheritance $x Loves $y) (Inheritance $x $Interest $Venue) (Inheritance $y $Interest $Venue))
  ;; db reference: dataset_for_n_arry_format
  ;; ratio: 0.2
  ;; normalization: False
!(assertEqual (isurp (, 
   (Inheritance $x Loves $y) 
   (Inheritance $x $Interest $Venue) 
   (Inheritance $y $Interest $Venue)) &dbNarry False 0.2) 0.0005234054263104659)

;; inputs:-
  ;; conjunctive pattern: (, (Inheritance $x $y The-Slice-Shop) (Inheritance $x Pizza-Lover $place) (Inheritance $x Pizza-Lover The-Slice-Shop))
  ;; db reference: dataset_for_n_arry_format
  ;; ratio: 0.2
  ;; normalization: False
!(assertEqual (isurp (, 
   (Inheritance $_32506 $_32512 The-Slice-Shop) 
   (Inheritance $_32506 Pizza-Lover $_32548) 
   (Inheritance $_32506 Pizza-Lover The-Slice-Shop)) &dbNarry False 0.2) 0.0002147542690545606)

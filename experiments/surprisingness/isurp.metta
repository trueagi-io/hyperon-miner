; ;types
; (: emp_prob_pbs_mem (-> Pattern SpaceType Number Number))
; ; ; (: pro-prob-wout-joint (-> (List Pattern) SpaceType Number Number Number))
; ; (: ji-prob-est (-> (List Pattern) Pattern SpaceType Number Number))
; ; ; (: do-ji-prob (-> (MList Pattern)) Pattern SpaceType Number (List Number))
; (: ji_prob_est_interval (-> Pattern SpaceType Number Any))
; (: isurp (-> Pattern SpaceType Bool Number Number))





;; Calculate the empirical probability of pattern, using
;; boostrapping if necessary


;; ==============================================================s
;; Function: pro-prob-wout-joint (Product Probability Without Joint Variables)
;; Purpose:  Computes the product probability of subpatterns while ignoring
;;           dependencies between joint variables (treats components as independent)
;;
;; Parameters:
;;   $subpatterns - List of pattern components to evaluate
;;   $db          - Database/context for probability calculation
;;   $db_ratio    - Sampling ratio for empirical probability estimation
;;   $p           - Accumulator for the product probability (starts at 1)
;;
;; How it works:
;; 1. Base Case: When no subpatterns remain, returns accumulated probability
;; 2. Recursive Case:
;;    a. Decomposes subpatterns into head (current) and tail (remaining)
;;    b. Calculates empirical probability of current subpattern
;;    c. Multiplies with accumulated probability
;;    d. Recursively processes remaining subpatterns
;;
;; Mathematical Formulation:
;;   P(pattern) = Π P(subpattern_i) for i in 1..n
;;   Where subpatterns are treated as independent components
;;
;; Key Characteristics:
;; - Recursive implementation
;; - Tail-recursive for efficiency
;; - Multiplicative probability accumulation
;; - Uses empirical probability (emp-prob) for component estimates
;;
;; Typical Usage:
;; Used within ji_prob_est to compute the independent probability component
;; before applying joint variable corrections
;; ==============================================================
(=(pro-prob-wout-joint $subpatterns $db $db_ratio $p) (
  if (== $subpatterns ()) $p (
    let* (
      (($subpattern $tail) (decons-atom $subpatterns))
      ($joined_comma (cons-atom , $subpattern) )
    ($empr (emp-prob $joined_comma   $db))
    ($new_prob (* $p $empr))
    
    )
       (pro-prob-wout-joint $tail $db $db_ratio $new_prob)
  )
))



;; ==============================================================
;; Function: ji-prob-est (Joint-Independent Probability Estimate)
;; Purpose:  Estimates the probability of a pattern by:
;;           1. Treating partition components as independent
;;           2. Accounting for joint variables between components
;;
;; Parameters:
;;   $partition - Database partition (components to evaluate separately)
;;   $pattern   - The pattern to evaluate
;;   $db        - The database/context
;;   $db_ratio  - Sampling ratio for probability estimation
;;
;; How it works:
;; 1. Calculates component probability ($p) without joint variables:
;;    (pro-prob-wout-joint $partition $db $db_ratio 1)
;;    - This gives the base probability ignoring variable dependencies
;;
;; 2. Gets database size for normalization:
;;    (db_size $db)
;;
;; 3. Computes joint variable correction factor:
;;    (eq-prob-py $partition $pattern $db-size)
;;    - Estimates probability that joint variables have equal values
;;    - Accounts for dependencies between components
;;
;; 4. Returns combined probability estimate:
;;    (* $p $eq_prob)
;;    - Product of independent probability and joint correction factor
;;
;; Mathematical Interpretation:
;;   P(pattern) ≈ P(components independent) × P(variables equal)
;;
;; Key Characteristics:
;; - Conservative estimate (tends to underestimate true probability)
;; - Handles variable dependencies through eq-prob-py correction
;; - Uses sampling (via db_ratio) for computational efficiency
;;
;; Typical Usage:
;; Used within ji_prob_est_interval to provide probability bounds
;; for surprisingness calculations (isurp function)
;; ==============================================================
(= (ji-prob-est $partition $pattern $db $db_ratio) (let* 
( 

  ($p (pro-prob-wout-joint $partition $db $db_ratio 1))
  ($db-size (db_size $db))

  ; ($eq_prob (eq-prob-py $partition $pattern $db-size)) ; TODO: for fast excution use eq-prob-py
  
  ($eq_prob (eq-prob $partition $pattern $db))
  )
  (* $p $eq_prob)

)
)



;; =============================================================================
;; Function: do-ji-prob
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Recursively computes joint independent probabilities (JI-Probs) for a pattern
;;   across multiple partitions in a database, returning a list of probability estimates.
;;
;; Inputs:
;;   - `$partitions`: List of data partitions to analyze (e.g., `(P1 P2 P3)`)
;;   - `$pattern`: The target pattern to evaluate (e.g., `(P A B)`)
;;   - `$db`: Reference database for probability estimation
;;   - `$db_ratio`: Database ratio parameter for probability calculation
;;
;; Output:
;;   - List of JI-Prob estimates for each partition (e.g., `(0.8 0.6 0.9)`)
;;   - Empty list if no partitions provided
;;
;; How it works:
;;   1. Base Case: Returns empty list when partitions are exhausted
;;   2. Recursive Case:
;;      a. Extracts current partition and remaining partitions
;;      b. Computes JI-Prob using `ji-prob-est` helper
;;      c. Recursively processes remaining partitions
;;      d. Combines results while preserving order
;;
;; Notes:
;;   - Requires `ji-prob-est` helper function
;;   - Preserves partition order in results
;;   - Time Complexity: O(n) where n = partition count
;;   - Space Complexity: O(n) for result storage
;;
;; Examples:
;;   (do-ji-prob '(P1 P2) '(P A B) DB 0.5) → (0.7 0.6)
;;   (do-ji-prob '() '(P X) DB 0.1) → ()
;; =============================================================================
(=(do-ji-prob $partitions $pattern $db $db_ratio) (
  if (== $partitions ()) () (
     let* ((($partition $tail) (decons-atom $partitions))
     
            ($jip (ji-prob-est $partition $pattern $db $db_ratio))
            
             ($dummy (do-ji-prob $tail $pattern $db $db_ratio)))
             (cons-atom $jip $dummy) ))
)






;; ==============================================================
;; Function: ji_prob_est_interval
;; Purpose: Estimates the expected probability interval [emin, emax] for a pattern
;;          using a joint independent (JI) estimation method
;;
;; Parameters:
;;   $pattern    - The pattern whose probability we want to estimate
;;   $db         - The database/context for probability estimation
;;   $db_ratio   - Ratio parameter controlling database sampling/weighting
;;
;; How it works:
;; 1. Generates partitions of the pattern excluding the pattern:
;;    (generet-partition-without-pattern $pattern)
;;    - Creates modified versions of the database that exclude the target pattern
;;    - This is similar to resampling in statistics
;;
;; 2. Computes probability estimates across partitions:
;;    (do-ji-prob partitions $pattern $db $db_ratio)
;;    - Calculates probability estimates for the pattern in each modified partition
;;    - The $db_ratio likely controls the size/weight of sampled partitions
;;
;; 3. Determines the minimum and maximum observed probabilities:
;;    (min-max probabilities)
;;    - Finds the range [emin, emax] of probability values across partitions
;;
;; 4. Returns the probability interval as (emin emax)
;;
;;
;; Typical Usage:
;;   Used as input for surprisingness measures (like isurp) to determine
;;   whether a pattern occurs more/less frequently than expected
;;
;; Return Value:
;;   Returns a pair (emin emax) representing the estimated probability range
;; ==============================================================

(=(ji_prob_est_interval $pattern $db $db_ratio) 
   (let* (($gen-parts (partitions-wout-pattern $pattern))  
   ($comp-ji (do-ji-prob $gen-parts $pattern $db $db_ratio))
  ($emin (min-atom $comp-ji))
  ($emax (max-atom $comp-ji))

    
    ; (($emin $emax) (min-max  (do-ji-prob (generet-partition-without-pattern $pattern) $pattern $db $db_ratio)))
    )
        ($emin $emax))
)






;; ==============================================================
;; Function: isurp (Independent Surprisingness)
;; Purpose:  Measures how statistically surprising a pattern is
;;           within a given database context, with optional normalization
;;
;; Parameters:
;;   $pattern    - The pattern to evaluate for surprisingness
;;   $db         - The database/context to evaluate against
;;   $normalize  - Boolean flag to normalize the result (0-1 range) 
;;   $db_ratio   - Ratio parameter for database sampling/weighting
;;
;; How it works:
;; 1. Calculates probability interval (emin, emax) for the pattern using ji_prob_est_interval
;;    - This estimates the expected probability range of the pattern
;; 2. Computes empirical probability (emp) using emp-prob-pbs
;;    - The actual observed probability in the database
;; 3. Measures distance (dst) between empirical probability and expected interval
;;    - Using dst_from_interval (likely measures how far emp is from expected range)
;; 4. Determines maximum probability value (maxprb) between emp and emax
;; 5. Returns:
;;    - If normalize=true: The ratio of distance to max probability (clamped to 1.0)
;;    - If normalize=false: The raw distance value (clamped to 1.0)
;;
;; Mathematical Interpretation:
;;   Measures how much the observed frequency deviates from expected,
;;   with normalization option to make values comparable across patterns
;;
;; Return Value:
;;   Returns a surprisingness measure between 0 and 1, where:
;;   - 0 = completely expected
;;   - 1 = maximally surprising
;; ==============================================================

(=(isurp $pattern $db $normalize $db_ratio) (
    let* (

      (($emin $emax) (ji_prob_est_interval $pattern $db $db_ratio))
      
           ($emp (emp-prob-pbs $pattern $db $emax $db_ratio))

            ($dst (dst_from_interval $emin $emax $emp))

             ($maxprb (max-atom ($emp $emax)))

             )
               (min-atom ((if $normalize (// $dst $maxprb) $dst) 1.0))
))





 
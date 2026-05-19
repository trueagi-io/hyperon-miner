




;;; File Dependency Documentation:
;;;
;;; Overview:
;;; This document outlines the file dependencies required by this module.
;;;
;;; Dependencies:
;;; 1. Main Module Registration:
;;;    - Registers the core module from the '../../experiments' directory.
;;;
;;; 2. Imported Modules:
;;;    - experiments:rules:emp-tv:
;;;         Loads the empirical TV-related rules.
;;;    - experiments:utils:common-utils:
;;;         Provides common utility functions used across experiments.
;;;    - experiments:utils:emp-tv-bs:
;;;         Contains utilities specific to empirical TV batch operations.
;;;    - experiments:utils:bs-utils:
;;;         Supplies additional utilities for batch statistics.





;; =============================================================================
;; Function: emp-prob
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes the empirical probability of a pattern in a Corpus
;;
;; Parameters:
;;   - $pattern: Pattern to evaluate
;;   - $db: Corpus to search
;;
;; Computation:
;;   1. universe-count: Get total relevant items
;;   2. sup-num: Get pattern occurrences(support)
;;   3. Return (support / universe-count)
;;
;; Returns:
;;   - Empirical probability as float
;; =============================================================================
(= (emp-prob $pattern $db)
    (let*
        (      
            ( $ucount (universe-count $pattern $db))     
            ( $sup (sup-num $db $pattern))
            
        ) 
        (// $sup  $ucount)      
))





;; =============================================================================
;; Function: emp_prob_subsmp
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes empirical probability with optional subsampling
;;
;; Parameters:
;;   - $pattern: Pattern to evaluate
;;   - $db: Corpus to search
;;   - $subsize: Subsample size threshold
;;
;; Behavior:
;;   - Uses subsample if $subsize < db_size
;;   - Uses full db otherwise
;;
;; Returns:
;;   - Empirical probability from appropriate sample
;; =============================================================================
(= (emp_prob_subsmp $pattern $db $subsize)
   (let $interdb (db_size $db)
        (if (< $subsize $interdb)
        (let* (
                ($intvar (subsample-py $db $subsize))
                ($emp-rslt (emp-prob $pattern $intvar))
            ) $emp-rslt)
        (emp-prob $pattern $db)
    ))
)

;; =============================================================================
;; Function: emp_prob_helper
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Generates multiple empirical probability samples through recursion
;;
;; Parameters:
;;   - $pattern: Pattern to evaluate
;;   - $db: Corpus to search
;;   - $n_resample: Number of samples to generate
;;   - $subsize: Subsample size
;;
;; Behavior:
;;   - Recursively builds list of probability samples
;;   - Base case: returns () when $n_resample=0
;;
;; Returns:
;;   - List of probability values
;; =============================================================================
(= (emp_prob_helper $pattern $db $n_resample $subsize) 

    (if (== $n_resample 0) 
        () 
        (let* (
             
            ($head-emp (emp_prob_subsmp $pattern $db $subsize))
             
            ($tail-emp (emp_prob_helper $pattern $db (- $n_resample 1) $subsize))
            

            )
        (cons-atom  $head-emp $tail-emp)
    )
    )
)
 



;; =============================================================================
;; Function: emp_prob_bs
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes bootstrapped empirical probability
;;
;; Parameters:
;;   - $pattern: Pattern to evaluate
;;   - $db: Corpus to search
;;   - $n_resample: Bootstrap iterations
;;   - $subsize: Subsample size
;;
;; Behavior:
;;   - Uses emp_prob_helper for subsampling when $subsize < db_size
;;   - Uses full db empirical probability otherwise
;;
;; Returns:
;;   - Averaged probability estimate
;; =============================================================================
( = (emp_prob_bs $pattern $db $n_resample $subsize)
    (let* (($interdb  (db_size $db)) ) (if (< $subsize $interdb)
        (emp-prob $pattern $db)
        ; (let* (($intervar (emp_prob_helper $pattern $db $n_resample $subsize))  ) (avrg-tuple $intervar))
        (emp-prob $pattern $db)
    ))

)







;; =============================================================================
;; Function: emp-prob-pbs (Overload 1)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Estimates probability with joint independent correction
;;
;; Parameters:
;;   - $pattern: Multi-conjunct pattern
;;   - $db: Corpus to search
;;   - $db_ratio: Probability adjustment factor
;;
;; Behavior:
;;   - Uses ji_prob_est_interval for multi-conjunct patterns
;;   - Falls back to emp-prob for single conjuncts
;;
;; Returns:
;;   - Adjusted empirical probability
;; =============================================================================
(= (emp-prob-pbs $pattern $db $db_ratio)
    (if (< 1 (n_conjuncts $pattern))
        (let ($emin $emax) (ji_prob_est_interval $pattern $db $db_ratio)

            (emp-prob-pbs $pattern $db $emax $db_ratio)
        )
    (emp-prob $pattern $db)
)
)



;; =============================================================================
;; Function: emp-prob-pbs (Overload 2)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes probability with bootstrap sampling when needed
;;
;; Parameters:
;;   - $pattern: Pattern to evaluate
;;   - $db: Corpus to search
;;   - $prob-estimate: Initial probability estimate 
;;   - $db-ratio: Corpus scaling factor
;;
;; Computation Flow:
;;   1. Convert prob-estimate to expected support
;;   2. Compare scaled db_size with support estimate
;;   3. Use bootstrap sampling if db_size < estimate
;;   4. Use standard emp-prob otherwise
;;
;; Returns:
;;   - Context-appropriate probability estimate
;; =============================================================================

(= (emp-prob-pbs $pattern $db $prob-estimate $db-ratio)
    (let* ( 
            ($_ (println! ("Empirical Probability with PBS for Pattern: " $pattern)))
            
             ($support-estimate (prob_to_support $pattern $db $prob-estimate))
             ($db-size-unorm (db_size $db))
             ($db-size (* $db-size-unorm $db-ratio))
             ($_ (println! ("Support Estimate: " $support-estimate ==== (< $db-size $support-estimate)) ))
         )
        (if (< $db-size $support-estimate)
            (let* ( 
                
                ($subsize (subsmp-size $pattern $db-size $support-estimate))
                
                    ($n-resample 10)
                    ($emp-prob (emp_prob_bs $pattern $db $n-resample $subsize))
                    
                    )
                    
                $emp-prob
            )
            (let* (
             ($real-prob (emp-prob $pattern $db))
             ) 
             $real-prob)
        )
    )
)











;types
; (: pro_prob_without_joint (-> SpaceType (BList Pattern) TruthValue))
; (: estimate_v_xi (-> SpaceType (List Pattern) Number))
; (: inner_temp (-> SpaceType (BList Pattern) (List Pattern) Number Any (List Number)))
; (: eq-prob (-> SpaceType Number (BList Pattern) (BList Pattern) Number Number Any Number Number))
; (: prob-with-joint (-> SpaceType Number (BList Pattern) Any Number Number))
; (: ji-est-tv (-> SpaceType Number Pattern (PList Pattern) (List TruthValue)))

; (: do-ji-tv-est (-> SpaceType Pattern TruthValue))

;; =============================================================================
;; Function: pro_prob_without_joint
;; -----------------------------------------------------------------------------
;; Purpose:
;;   This function calculates the product of the probability over subpatterns
;;   without considering the joint variables. It estimates the empirical truth value
;;   for each subpattern and then computes the average of these truth values to derive
;;   the final product of the probabilities.
;;
;; Parameters:
;;   - $db: The database in which the subpatterns' empirical truth values will be calculated.
;;   - $subpatterns: A list of subpatterns for which the empirical truth values need to be calculated.
;;
;; Internal Calculation:
;;   1. Calls `emp_tv_mem` to calculate the empirical truth value (`$tv`) for the given subpatterns in the database.
;;   2. Uses `avrg_tv` to compute the average of the empirical truth values, which represents the product of the probabilities.
;;   3. Returns the average empirical truth value as the product of probabilities over the subpatterns.
;;
;; Returns:
;;   - The average empirical truth value, representing the product of the probabilities over the subpatterns without considering joint variables.
;; =============================================================================
(=(pro_prob_without_joint $db $subpatterns)(
    let* (
        ($tv (emp_tv_mem $subpatterns $db))  ;; Get empirical truth value for subpatterns in the database
        ($prod_etv (avrg_tv $tv))             ;; Calculate the average of the empirical truth values
    )
    $prod_etv    
))



;; =============================================================================
;; Function: estimate_v_xi
;; -----------------------------------------------------------------------------
;; Purpose:
;;   This function calculates the set of values that Xi (a specific component of a pattern)
;;   can take when it is matched against the database alone, without any interaction
;;   with the other components. The calculation uses an approximation formula.
;;
;; Formula:
;;   The set size for Xi (denoted as |V(Xi)|) is approximated by taking the Nth root of the support
;;   count (S) of the pattern's occurrences in the database, where N is a constant factor.
;;
;; Parameters:
;;   - $db: The database in which the pattern will be matched to estimate Xi's possible values.
;;   - $pattern_i: A component of the pattern whose possible values are to be estimated.
;;
;; Calculation:
;;   1. It computes the support count `S` for the pattern component ($pattern_i) in the database using the `sup-num` function.
;;   2. The Nth root of the support value `S` is then taken, with 0.5 (the square root) as the exponent in the `pow` function.
;;   3. The result is the estimated number of possible values that Xi can take.
;;
;; Returns:
;;   - The estimated set size of values that Xi can take.
;; =============================================================================
(=(estimate_v_xi $db $pattern_i) (
    let $result (sup-num $db $pattern_i)         ;; Get the support count (S) for the pattern component in the database
    ((py-atom pow) $result 0.5)                  ;; Take the Nth root (square root) of the support count
))





;; =============================================================================
;; Function: inner_temp
;; -----------------------------------------------------------------------------
;; Purpose:
;;   This function calculates and sets the value of |V(Xi)| for a given component `compJ`
;;   with respect to the components preceding it (i.e., those where i < j). It either sets the 
;;   value to -1 if no abstraction exists or estimates the value using `estimate_v_xi`.
;; 
;; Parameters:
;;   - $db: The database to be used for estimation.
;;   - $original: A list of components (or patterns).
;;   - $compJ: The component for which the value of |V(Xi)| needs to be set.
;;   - $i: An index variable used to recursively process the components.
;;   - $var: A variable passed to the recursive call.
;; 
;; Steps:
;;   1. If $i equals 0, it means no further components are left to process, and the function terminates.
;;   2. Otherwise, it deconstructs the `$original` list into `$head` and `$tail`.
;;   3. It checks if the `$head` component is more abstract than `$compJ` using the function `is_more_abstract_init`.
;;      - If `$head` is more abstract, it estimates the possible values for Xi using `estimate_v_xi`.
;;      - If `$head` is not more abstract, it sets the value to -1, indicating no abstraction.
;;   4. The function then recursively calls itself with the remaining components in `$tail` and decrements `$i`.
;;   5. The resulting list is constructed by consing the value of `v_xi` with the results of the recursive call.
;;   6. Finally, the function returns a list of estimated values for each component.
;; 
;; Returns:
;;   - A list where each element is the value of |V(Xi)| for each component, or -1 if no abstraction exists.
;; =============================================================================
(=(inner_temp $db $original $compJ $i $var) (
    if (== $i 0) () ; Base case: if $i equals 0, stop recursion
    (
        let* (
            ( ($head $tail) (decons-atom $original)) ; Deconstruct the $original list into $head and $tail
            ($bool_value (is_more_abstract_init $head $compJ)) ; Check if $head is more abstract than $compJ
            ($v_xi (if $bool_value (estimate_v_xi $db $head) -1)) ; If more abstract, estimate |V(Xi)|, else set to -1
            ($dummy (inner_temp $db $tail $compJ (- $i 1) $var)) ; Recursive call for the remaining components
        )
        (cons-atom $v_xi $dummy) ; Construct the result by consing $v_xi with the recursive result
    )
))





;; =============================================================================
;; Function: eq-prob
;; -----------------------------------------------------------------------------
;; Purpose:
;;   This function recursively calculates the probability product for each component
;;   in a pattern using the formula: P(X1 = ... = Xn) = ∏_{j=2}^n 1 / M(Xj),
;;   where M(Xj) is the estimated number of values Xj can take when conditioned on
;;   more abstract components.
;;
;; Parameters:
;;   - $db: The database used to estimate variable domain sizes.
;;   - $db_size: The total size of the database.
;;   - $original: The original list of pattern components.
;;   - $copy: A copy of the list used for recursive traversal.
;;   - $i: The current index in the original pattern list.
;;   - $count: The number of components left to process.
;;   - $var: A placeholder variable (purpose depends on `inner_temp`).
;;   - $prob: The accumulated probability product so far.
;;
;; Steps:
;;   1. If `$count` is greater than 1:
;;      a. Retrieve the tail of the current component list.
;;      b. Extract the next component `$compJ` to process.
;;      c. Use `inner_temp` to compute abstractness relationships and estimate |V(Xi)|.
;;      d. Use `find_max` to determine the most specific (smallest) estimate among
;;         abstract components; this is considered M(Xj).
;;      e. If the most specific value is not positive, use the entire database size
;;         as a fallback for M(Xj).
;;      f. Multiply the current probability with 1 / M(Xj) to update `$prob`.
;;      g. Recursively process the remaining components.
;;   2. If `$count` is 1 or less, return the accumulated probability as the base case.
;;
;; Returns:
;;   - The final product probability value computed using the abstractness-aware
;;     approximation formula.
;; =============================================================================

(=(eq-prob $db $db_size $original $copy $i $count $var $prob) (
    if (> $count 1) (
          let* (($tail (cdr-atom $copy))
        ($compJ (car-atom $tail))
        ($most_spec  (let $result (inner_temp $db $original $compJ $i $var) (max $result) ))
       ($M_xj (if (<= $most_spec 0) $db_size $most_spec))
       ($inverse_M_xj (// 1 $M_xj))
        ($prob_j (* $prob $inverse_M_xj))  ;; from general formula
        ($dummy (eq-prob $db $db_size $original $tail (+ $i 1) (- $count 1) $var $prob_j))) 
         $dummy)
           $prob
    ))




;; =============================================================================
;; Function: prob-with-joint
;; -----------------------------------------------------------------------------
;; Purpose:
;;   This function calculates the probability that all joint variables take the
;;   same value by iteratively applying `eq-prob` to each joint variable and its
;;   connected subpatterns.
;;
;; Parameters:
;;   - $db: The database used for probability estimation.
;;   - $db_size: The size of the database.
;;   - $partion: The list of pattern partitions used to identify subpatterns.
;;   - $joint_vars: A list of joint variables whose agreement is being evaluated.
;;   - $p: The initial probability value, used for accumulation.
;;
;; Returns:
;;   - The final probability that all joint variables are equal across their
;;     respective connected components.
;; =============================================================================

(=(prob-with-joint $db $db_size $partion $joint_vars $p)(
    if (== $joint_vars ()) $p
 (let* ((($head $tail) (decons-atom $joint_vars))
       ($patterns (connected-subpatterns-with-var $partion $head))
       ($prob (eq-prob $db $db_size $patterns $patterns 1 (tuple-count $patterns)  $head $p))
        )
       (prob-with-joint $db $db_size $partion  $tail $prob)
        )   
))




;; =============================================================================
;; Function: ji-est-tv
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculates the joint-independent truth value estimate (JITVE) for a pattern
;;   based on a given partition. It assumes all blocks are independent but accounts
;;   for joint variables shared across them.
;;
;; Parameters:
;;   - $db: The database containing relevant facts.
;;   - $db_size: The size of the database.
;;   - $pattern: The pattern whose empirical truth value is being estimated.
;;   - $partitions: A list of partitions of the pattern, each representing a block
;;                  assumed to be conditionally independent.
;;
;; Returns:
;;   - A list of STV (Strength, Confidence) pairs, one for each partition,
;;     adjusted by the estimated joint probability among shared variables.
;; =============================================================================

 (= (ji-est-tv $db $db_size $pattern $partitions)
 (   if (== $partitions ()) () (
         let* (
             
             (($head $tail) (decons-atom $partitions))
                ($prod_etv (pro_prob_without_joint $db $head))
                (($rp $rc) (decons-atom $prod_etv))
            ;    ($rp_est (prob-with-joint $db $db_size (remove-parenthesis $head) (joint-variables-init $pattern (remove-parenthesis $head)) 1))
               ($rp_est (eq-prob (remove-parenthesis $head)  $pattern $db))
              (($strength $confidence) ((* $rp $rp_est) (* 1e-1 (car-atom $rc))))
              ($old (ji-est-tv $db $db_size $pattern $tail))
               ) 
              (cons-atom (STV $strength $confidence)  $old)  
          ))
 )


;; =============================================================================
;; Function: do-ji-tv-est
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes the joint-independent truth value estimate (JITVE) for a given pattern
;;   by generating a partition of the pattern, estimating the JITV for each block,
;;   and then averaging the results to form a final STV (Strength, Confidence).
;;
;; Parameters:
;;   - $db: The database from which atoms are extracted and used for evaluation.
;;   - $pattern: The pattern whose joint-independent empirical truth value is to be calculated.
;;
;; Returns:
;;   - A single STV value representing the averaged strength and confidence across
;;     all partitioned estimations of the pattern.
;; =============================================================================

(= (do-ji-tv-est $db $pattern) (
    let $prtns (partitions $pattern)  
          ( let* (
            ($_ (println! "======= Truth Value Estimation ======="))
            ($db_size (db_size $db))
            (($strength $confidence) (avrg_tv (ji-est-tv $db $db_size $pattern $prtns) )))
           (STV $strength $confidence))           
))
















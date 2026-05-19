;connected-subpatterns-with-var
(= (is-blk-more-abstract $head $pivot $var) True)
;argumets: $paratition (the target patition which is a list of blocks)
;$var the variable we are concerned with

;Returns:
;The blocks inside the partiton that contain the target variable $var
;
;================================
 (=(connected-subpatterns-with-var $partition $var)

(let $_ (println! ("in con-sub-w-var")) (collapse (rmvPar (process-pattern (superpose $partition ) $var)))))

(= (checkInterSuper $var $el) (if (checkPat $el) (let $tail (cdr-atom $el) (checkInterSuper $var (superpose $tail)) ) (if (== $var $el) True (empty))) )  

(=(process-pattern $pattern $var)
    (let* (
        ($is_pat (checkPat $pattern)))
    
        (if $is_pat
            ; If it's a pattern, do the normal check
            (let* (
                ;($is_expression (== (get-metatype $pattern) Expression))
                ; ($vars (cdr-atom $pattern))
                ;($exp (if $is_exp $pattern (car-atom $pattern)))
                ($exp (if (== (size-atom $pattern) 1) (car-atom $pattern) $pattern))
                ($vars (cdr-atom $exp))
                ; ($is_connected (checkIntersection $var $vars))
                ($is_connected (checkInterSuper $var (superpose $vars)))
            )
                (if $is_connected
                    $pattern
                    (empty)
                )
            )
            ;    (process-pattern (superpose $pattern) $var)
            ;(collapse (process-pattern (superpose $pattern) $var)) ;activate this for checking inside the block, comment out if not              
            (let $ch (collapse (process-pattern (superpose $pattern) $var)) (if (not (== $ch ())) $pattern (empty) )) ;activate this for returning the whole block, comment out if not
        )
    ))

(=(rmvPar $x) 
    (if (== $x ()) 
        (empty) 
        (let $fuc (checkPat $x) 
            (if $fuc 
                $x  
                (if (== (size-atom $x) 1) 
                    $x 
                    $x
                )
            )
        )
    )
) 



;=================================

(= (extract $exp $var)  (let $che (var-exist-exp $exp $var)  (
    if $che 
    $exp
    (empty)
    
)))

(= (find-component-with-var $components $var)
    (collapse (extract (superpose $components) $var))
)










;; =============================================================================
;; Function: sort-by-abstraction
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Sorts a list of patterns based on abstraction level using is-blk-more-abstract
;;   More abstract patterns come first in the sorted result
;;
;; Type Signature:
;;   (-> Expression Expression Expression)
;;
;; Parameters:
;;   $patterns - List of patterns to sort
;;   $var - Variable to use for abstraction comparison
;;
;; Returns:
;;   Sorted list where more abstract patterns appear first
;;
;; Example:
;;   (sort-by-abstraction '(pattern1 pattern2 pattern3) $x)
;; =============================================================================
; (: sort-by-abstraction (-> Expression Expression Expression))
(= (sort-by-abstraction $patterns $var)
    (if (== $patterns ())
        ()
        (if (== (cdr-atom $patterns) ())
            $patterns  ; Single element list is already sorted
            (let* (
                ($pivot (car-atom $patterns))
                ($rest (cdr-atom $patterns))

                ($more-abstract (filter-more-abstract $rest $pivot $var))
                ($less-abstract (filter-less-abstract $rest $pivot $var))
        

                ($sorted-less (sort-by-abstraction $less-abstract $var))
                ($sorted-more (sort-by-abstraction $more-abstract $var))
            )
            (concat-atom $sorted-more (cons-atom $pivot $sorted-less))))))

;; =============================================================================
;; Function: filter-more-abstract
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Filters patterns that are more abstract than the pivot
;;
;; Parameters:
;;   $patterns - List of patterns to filter
;;   $pivot - Pivot pattern for comparison
;;   $var - Variable for abstraction comparison
;;
;; Returns:
;;   List of patterns more abstract than pivot
;; =============================================================================
; (: filter-more-abstract (-> Expression Expression Expression Expression))
(= (filter-more-abstract $patterns $pivot $var)
    (if (== $patterns ())
        ()
        (let* (
            ($head (car-atom $patterns))
            ($is-head-abstract (is-blk-more-abstract $head $pivot $var))
            ($copyHead (car-atom $patterns))
            ($copyHead (car-atom $patterns))
            ($tail (cdr-atom $patterns))
            ($rest-filtered (filter-more-abstract $tail $pivot $var))
        )
        (if (is-blk-more-abstract $head $pivot $var)
            (cons-atom $copyHead $rest-filtered)
            $rest-filtered))))

;; =============================================================================
;; Function: filter-less-abstract
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Filters patterns that are less abstract than the pivot
;;
;; Parameters:
;;   $patterns - List of patterns to filter
;;   $pivot - Pivot pattern for comparison
;;   $var - Variable for abstraction comparison
;;
;; Returns:
;;   List of patterns less abstract than pivot
;; =============================================================================
; (: filter-less-abstract (-> Expression Expression Expression Expression))
(= (filter-less-abstract $patterns $pivot $var)
    (if (== $patterns ())
        ()
        (let* (

            ($head (car-atom $patterns))
            ($copyHead (car-atom $patterns))
            ($tail (cdr-atom $patterns))
            ($rest-filtered (filter-less-abstract $tail $pivot $var))
        )
        (if (is-blk-more-abstract $head $pivot $var)
            $rest-filtered
            (cons-atom $copyHead $rest-filtered)))))




;  !(sort-by-abstraction (((Human $x $y) (Human $x $z)) ((Human $x Chala)) ) $x)


; (((Human $x $y) (Human Abebe $y))  ((Human $x Abeb)))

; (filter-less-abstract $rest $pivot $var)

; !(filter-more-abstract (((Human $x $y) (Human $x $z))) ((Human $x Chala)) $x)

; !(is-blk-more-abstract ((Human $y $x)) ((Human Abebe Chala))  $x)


















;; =============================================================================
;; Function: eq-prob
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculates the probability of a variable taking the same value across
;;   all blocks/subpatterns where that variable appears in a partition
;;
;; Type Signature:
;;   (-> Expression Expression Expression Number)
;;
;; Parameters:
;;   $partition - List of blocks/subpatterns 
;;   $pattern - The main pattern containing variables
;;   $db - Database/corpus to search in
;;
;; Returns:
;;   Probability value as a number
;;
;; Algorithm:
;;   1. For each joint variable in the pattern and partition
;;   2. Get connected subpatterns containing that variable
;;   3. Sort by abstraction level (most abstract first)
;;   4. For each block after the first, find most specialized abstract block
;;   5. Calculate probability based on value counts
;; =============================================================================
; (: eq-prob (-> Expression Expression Expression Number))
(= (eq-prob $partition $pattern $db)
    (let* (($joint-vars (joint-variables $pattern $partition))
     
    
     )
        (calculate-prob-for-vars $joint-vars $partition $db 1.0)))

;; =============================================================================
;; Function: calculate-prob-for-vars
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Iterates through variables and calculates cumulative probability
;;
;; Parameters:
;;   $vars - List of joint variables
;;   $partition - Partition to analyze
;;   $db - Database
;;   $p - Current probability accumulator
;;
;; Returns:
;;   Final probability after processing all variables
;; =============================================================================
; (: calculate-prob-for-vars (-> Expression Expression Expression Number Number))
(= (calculate-prob-for-vars $vars $partition $db $p)
    (if (== $vars ())
        $p
        (let* (
            ($top (car-atom $vars) )
            
            ($var-partition (connected-subpatterns-with-var $partition $top))
            ($sorted-partition (sort-by-abstraction $var-partition $top))
            
            ($new-p (process-blocks $sorted-partition $top $db $p 1))
            
        )
        (calculate-prob-for-vars (cdr-atom $vars) $partition $db $new-p))))


;; =============================================================================
;; Function: process-blocks
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Processes blocks in sorted partition starting from index j=1
;;   (skipping the first block as per the C++ algorithm)
;;
;; Parameters:
;;   $sorted-partition - Partition sorted by abstraction
;;   $var - Current variable being processed
;;   $db - Database
;;   $p - Current probability
;;   $j - Current block index (starts at 1)
;;
;; Returns:
;;   Updated probability after processing all blocks
;; =============================================================================
; (: process-blocks (-> Expression Expression Expression Number Number Number))
(= (process-blocks $sorted-partition $var $db $p $j)
    (let $partition-size (size-atom $sorted-partition)
        (if (>= $j $partition-size)
            $p
            (let* (
                ($j-blk (index-atom $sorted-partition $j))
                
                ($i (find-most-specialized-abstract $sorted-partition $j-blk $var (- $j 1)))
                
                ($c (if (>= $i 0)
                        (let $i-blk (index-atom $sorted-partition $i)
                            (value-count $i-blk $var $db))
                        (let $U (collapse (get-atoms $db)) (size-atom $U))))  ; Use |U| = db.size() as fallback

                ($j-blk-count (value-count $j-blk $var $db))
                
                ($new-p (/ $p $c))
            )
            (process-blocks $sorted-partition $var $db $new-p (+ $j 1))))))






(= (value-count $blk $var $db) 
    (let $conj-blk (union-atom (,) $blk) (let*
     (
        
        ($match-values (collapse (match $db $conj-blk $var)) )
        
        ($ground-value (unique-atom $match-values))
     
     ) (size-atom $ground-value))))
;; =============================================================================
;; Function: find-most-specialized-abstract
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Finds the most specialized block that is more abstract than j_blk
;;   Goes backward from j_blk to find first i_blk that is more abstract
;;
;; Parameters:
;;   $partition - Sorted partition
;;   $j-blk - Current block to compare against
;;   $var - Variable for abstraction comparison
;;   $i - Current index to check (starts at j-1)
;;
;; Returns:
;;   Index of most specialized abstract block, or -1 if none found
;; =============================================================================
; (: find-most-specialized-abstract (-> Expression Expression Expression Number Number))
(= (find-most-specialized-abstract $partition $j-blk $var $i)
    (if (< $i 0)
        -1  ; No abstract block found
        (let $i-blk (index-atom $partition $i)
            (if (is-blk-more-abstract $i-blk $j-blk $var)
                $i  ; Found the most specialized abstract block
                (find-most-specialized-abstract $partition $j-blk $var (- $i 1))))))

;; =============================================================================
;; Helper Functions
;; =============================================================================



;; =============================================================================
;; Function: get-var
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Extracts all variables from a flattened pattern expression
;;   A flattened pattern is a list of patterns like ((Pattern $x $y) (Pattern $z Jon))
;;
;; Type Signature:
;;   (-> Expression Expression)
;;
;; Parameters:
;;   $pattern - Flattened pattern (list of individual patterns)
;;
;; Returns:
;;   List of unique variables found in the pattern
;;
;; Example:
;;   (get-var '((Pattern $x $y) (Pattern $z Jon))) → ($x $y $z)


(=(get-var $conjunct) 
    (let $lst (collapse 
        (let $a (car-atom $conjunct) 
            (if (not (== $a ,)) 
                (let $firtype (get-metatype $a) 
                    (if (== $firtype Expression) 
                        (get-variables-helper (superpose $conjunct) ) 
                        (get-variables-helper $conjunct )
                    )
                ) 
                (let $b (cdr-atom $conjunct) 
                    (get-variables-helper (superpose $b))
                )
            )
        )) 
        (get-variables-step $lst ())
    ) 
)

(=(ret-vars $x) 
    (let $invar (checkPat $x ) 
        (if $invar (get-variables-helper $x ) 
            (if (== ( get-metatype $x ) Variable) 
                $x 
                (empty)
            )
        )
    )
)



(=(get-variables-helper $pattern) 
    (let $a (cdr-atom $pattern) 
        (ret-vars (superpose $a))
    )
)



(=(get-variables-step $lst $acc) 
    (if  (== $lst ()) 
        $acc 
        (let* (
            (($head $tail) (decons-atom $lst))) 
        (if (== ((intersection-atom ($head) $acc)) (())) 
            (get-variables-step $tail (cons-atom $head $acc)) 
            (get-variables-step $tail $acc))
        )
    )
)







;; =============================================================================
;; Function: joint-variables
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Finds variables that appear in multiple blocks of a partition
;;   A joint variable must exist in at least 2 different blocks
;;
;; Type Signature:
;;   (-> Expression Expression Expression)
;;
;; Parameters:
;;   $pattern - Flattened pattern to get variables from
;;   $partition - List of blocks (each block is a list of patterns)
;;
;; Returns:
;;   List of variables that appear in multiple blocks
;;
;; Example:
;;   Pattern: (, (Pattern $x $y) (Pattern $x Jon))  
;;   Partition: ( ((Pattern $x Jon))  ((Pattern $x $y)) )  
;;   Result: ($x) - because it appear in both blocks
;; =============================================================================
; (: joint-variables (-> Expression Expression Expression))
(=(joint-vars-helper $partition $uniqueVars) 
        (collapse (retJointvar $partition (superpose $uniqueVars)))
)

(=(retJointvar $partition $var) 
    (let $retPats (collapse (retJointPat (superpose $partition) $var)) 
    (if (> (size-atom $retPats) 1)  $var (empty)))
)



(=(retJointPat $block $var)  
    (let $blo (collapse (retjointSubPat (superpose $block) $var)) 
    (if (> (size-atom $blo) 0) $block (empty) )) 
)



(=(retjointSubPat $subpat $var) 
    (let* (
            ($tail (cdr-atom $subpat)) 
            ($JoinedVars (collapse (checkSubInter (superpose $tail) $var)) )) 
        (if (== (size-atom $JoinedVars) 0) 
            (empty) 
            $subpat
        )
    )
)


(=(checkSubInter $part $var) 
    (let $invar (checkPat $part) 
        (if $invar (retjointSubPat $part $var) 
            (if (and (== (get-metatype $part) Variable) (== $var $part)) 
                $part 
                (empty)
            ) 
        )
    )
)

;we could pass the origninal conjunct pattern and the partiton if we want,then get-variables retrunds a list of unique variables in the list
(=(joint-variables  $pattern $partition) 
    (let $invar (get-var $pattern) 
        (joint-vars-helper $partition $invar)
    )
)



;; Get all variables from entire partition (updated implementation)
; (: get-all-partition-variables (-> Expression Expression))
(= (get-all-partition-variables $partition)
    (if (== $partition ())
        ()
        (let* (
            ($block (car-atom $partition))
            ($remaining (cdr-atom $partition))
            ($block-vars (get-var $block))
            ($remaining-vars (get-all-partition-variables $remaining))
        )
        (merge-list $block-vars $remaining-vars))))

;; Find intersection of two variable lists
(: intersection-vars (-> Expression Expression Expression))
(= (intersection-vars $vars1 $vars2)
    (if (== $vars1 ())
        ()
        (let* (
            ($var (car-atom $vars1))
            (($remaining) (cdr-atom $vars1))
            ($rest-intersection (intersection-vars $remaining $vars2))
        )
        (if (is-membership $var $vars2)
            (cons-atom $var $rest-intersection)
            $rest-intersection))))





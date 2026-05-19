;;Checks if **all elements** of $lst are in $used
(=(all-in $lst $used)
(let $inter (set-intersection $lst $used) (if (== (size-atom $inter) (size-atom $lst)) True False))

)


;; Example:  (powerset (a b)) → (() (b) (a) (a b))

(= (powerset $lst)
  (if (== $lst ())
     (())                              ; only subset of empty list
     (let* (
       (($head $tail) (decons-atom $lst))
       ($ps-tail   (powerset $tail)) ; subsets of tail
       ($with-head (prepend-to-each $head $ps-tail)) ; prepend head to each
      )
      (union-atom $ps-tail $with-head) ; union of both halves
     )
  )
)

;; Recursively prepend $elem to each subset in $subsets
(= (prepend-to-each $elem $subsets)
  (if (== $subsets ())
     ()
     (let ($first $rest) (decons-atom $subsets)
      (cons-atom (cons-atom $elem $first)
              (prepend-to-each $elem $rest))
     )
  )
)

;; ===========================================================================
;; FUNCTION: powerset-without-empity
;;
;; DESCRIPTION:
;;   Generates all non-empty subsets of the given list.
;;
;; PARAMETERS:
;;   • $list — A list of elements to compute the subsets from.
;;
;; RETURNS:
;;   A flat list of lists, each representing a non-empty subset of $list.
;;
;; EXAMPLE:
;;   (powerset-without-empity '(a b c))
;;   ⇒ ((a) (b) (c) (a b) (a c) (b c) (a b c))
;; ===========================================================================

(= (powerset-without-empty $list)
  (if (== $list ())
      ()
      (let $head (car-atom $list)
        (let $tail (cdr-atom $list)
          (let $tail-powerset (powerset-without-empty $tail)
            (if (== $tail-powerset ())
                (cons-atom (cons-atom $head ()) ())
                (combine-powersets $head $tail-powerset $tail-powerset)
            )
          )
        )
      )
  )
)

(= (combine-powersets $elem $remaining $original)
  (if (== $remaining ())
      $original
      (let $first (car-atom $remaining)
        (let $rest (cdr-atom $remaining)
          (let $new-subset (cons-atom $elem $first)
            (cons-atom $new-subset 
              (combine-powersets $elem $rest $original)
            )
          )
        )
      )
  )
)

;;Checks if **any element** of $lst is in $used
(=(any-in $lst $used)(let $inter (set-intersection $lst $used) (if (== (size-atom $inter) 0) False True)))


;the subset can't be an empty set or the orginal set itself
(= (valid-subset $subset $original)
   (and (not (== $subset ()))
        (not (== $subset $original))))  

; =========================================================================================
;;This function explores all combinations of valid, 
;;disjoint subsets that together cover the original list exactly once. It ensures:
;;No repetition.
;;No subset is empty or equal to the full set.
;;Each partition is complete (checked by all-in in partitions-helper).

; Collect partitions by trying each valid subset
(= (partitions-collect $subsets $original $current $used)
   (if (== $subsets ())
       ()
       (let ($subset $rest) (decons-atom $subsets)   
         (if (and (valid-subset $subset $original)
                  (not (any-in $subset $used)))     ;; ((a b) ( c))
             (let* (
                    ($first (partitions-helper $subsets $original (cons-atom $subset $current) (union-atom $used $subset)))
                      ($second (partitions-collect $rest $original $current $used)))
                        (union-atom $first $second))
             (partitions-collect $rest $original $current $used)))))

 ; Recursive helper
(= (partitions-helper $subsets $original $current $used)
   (if (all-in $original $used)
       ($current)
       (partitions-collect (cdr-atom $subsets) $original $current $used))
       

       
       )


; Main: Generate all partitions
(= (partitions $subsets $original)
   (partitions-collect $subsets $original () ()))


;; ==============================================================================
;; Function: partitions
;; Purpose: Computes all valid **partitions** of a given list (set pattern)
;;
;; Parameters:
;;   $original  - The original list to be partitioned
;;
;; How it works:
;; 1. Computes the powerset of the original list:
;;    (powerset $original)
;;    - Generates all possible subsets of the list, including empty and full
;;    - This forms the pool of candidates from which partitions will be constructed
;;
;; 2. Filters and selects subsets to build partitions:
;;    - Uses only those subsets which are:
;;        a. Non-empty
;;        b. Not equal to the full original set
;;        c. Disjoint from subsets already used
;;    - Avoids duplicate element usage across subsets
;;
;; 3. Recursively assembles valid partitions:
;;    (partitions-helper ...) and (partitions-collect ...)
;;    - Tracks current partition in progress and used elements
;;    - Recursion continues until all elements of the original list are covered
;;
;; 4. Ensures full coverage:
;;    (all-in $original $used)
;;    - Final partitions are those where all original elements are included exactly once
;;
;; Key Helper Functions:
;;   - powerset: Generates all subsets
;;   - valid-subset: Filters out empty and full-set subsets
;;   - all-in / any-in: Check coverage and overlaps
;;   - partitions-collect: Core function to explore subset combinations
;;
;; Return Value:
;;   Returns a list of valid partitions, where each partition is a list of 
;;   disjoint, non-empty subsets that together cover the original list.
;;
;; Typical Usage:
;;   Used in probability estimation, pattern decomposition, or symbolic reasoning
;;   tasks where exhaustive enumeration of all disjoint covers is required.
;; ==============================================================================
(:partitions (-> list_of_patterns partitions))


(= (partitions $original)
   (let $first-element (car-atom $original)
     (if (== $first-element ,)
         (partitions (powerset (cdr-atom $original))
                      (cdr-atom $original))
         (partitions (powerset $original)
                     $original)
      )
   )
)

(= (partitions-wout-pattern $original) (
   let $partions (partitions $original)  (exclude-item ($original) $partions)
))

(= (partitions-with-pattern $original)
   (let $first-element (car-atom $original)
     (if (== $first-element ,)
         (let* (
            ($tail (cdr-atom $original))
            ($part-1 (partitions (powerset $tail) $tail))
            ) 
            (cons-atom ($tail) $part-1)
         )
         (let $part-2 (partitions (powerset $original)
                     $original) (cons-atom ($original) $part-2))))
)


; !(powerset )

; !(partitions (, (Inheritance $x $y ) (Inheritance $x human) (Inheritance $x sodaDrinker)))


; ((((Inheritance $_78904 human)) ((Inheritance $_78904 sodaDrinker))) (((Inheritance $_78904 sodaDrinker)) ((Inheritance $_78904 human))) (((Inheritance $_78904 sodaDrinker) (Inheritance $_78904 sodaDrinker)) ((Inheritance $_78904 human))) (((Inheritance $_78904 human) (Inheritance $_78904 sodaDrinker))) (((Inheritance $_78904 sodaDrinker) (Inheritance $_78904 human))))


; ((((Inheritance $_78220 human)) ((Inheritance $_78220 sodaDrinker))) (((Inheritance $_78220 sodaDrinker)) ((Inheritance $_78220 human))) (((Inheritance $_78220 sodaDrinker) (Inheritance $_78220 sodaDrinker)) ((Inheritance $_78220 human))) (((Inheritance $_78220 human) (Inheritance $_78220 sodaDrinker))) (((Inheritance $_78220 sodaDrinker) (Inheritance $_78220 human))))

!( collapse (intersection-atom ((Inheritance $x man )) ((Inheritance $y man))))

; !(let $bool (== (Inheritance $x man ) (Inheritance $x $y)) $bool)

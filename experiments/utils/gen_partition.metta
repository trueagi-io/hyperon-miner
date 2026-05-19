;; =============================================================================
;; Module: Partition Utilities
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Provides functions for manipulating logical partitions and subsets, including:
;;   - Clause extraction from expressions
;;   - Powerset generation
;;   - Partition generation
;;   - Set operations
;;
;; Dependencies:
;;   - Python backend for some partition generation functions
;; =============================================================================



;; =============================================================================
;; Function: add-to-subsets
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Adds an element to each subset in a list of subsets
;;
;; Type Signature:
;;   (-> Expression Expression Expression)
;;
;; Parameters:
;;   $element - Element to add
;;   $subsets - List of subsets to modify
;;
;; Returns:
;;   New list with element added to each subset
;;
;; Example:
;;   (add-to-subsets 'A '((B) (C))) → ((A B) (A C))
;; =============================================================================
; (: add-to-subsets (-> Expression Expression Expression))
(= (add-to-subsets $element $subsets)
    (if (== $subsets ())
        ()
        (let* (
                ($head-sub (car-atom $subsets))
                ($tail-sub (cdr-atom $subsets))
                ($current (cons-atom $element $head-sub))
                ($rest (add-to-subsets $element $tail-sub)))
            (cons-atom $current $rest))))

;; =============================================================================
;; Function: concat-atom
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Concatenates two lists
;;
;; Parameters:
;;   $list1 - First list
;;   $list2 - Second list
;;
;; Returns:
;;   Combined list
;;
;; Example:
;;   (concat-atom '(A B) '(C D)) → (A B C D)
;; =============================================================================
(= (concat-atom $list1 $list2)
    (if (== $list1 ())
        $list2
        (let* (
                ($head (car-atom $list1))
                ($tail (concat-atom (cdr-atom $list1) $list2)))
            (cons-atom $head $tail))))

;; =============================================================================
;; Function: powerset
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Generates all possible subsets of a list (powerset)
;;
;; Type Signature:
;;   (-> Expression Expression)
;;
;; Parameters:
;;   $lst - Input list
;;
;; Returns:
;;   List of all subsets
;;
;; Example:
;;   (powerset '(A B)) → (() (A) (B) (A B))
;; =============================================================================
; (: powerset (-> Expression Expression))
(= (powerset $lst)
    (if (== $lst ())
        (cons-atom () ())
        (let* (
                ($rest (powerset (cdr-atom $lst)))
                ($with-current (add-to-subsets (car-atom $lst) $rest)))
            (concat-atom $rest $with-current))))

;; =============================================================================
;; Function: generet-partition-without-pattern
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Generates partitions from a pattern using Python backend
;;
;; Type Signature:
;;   (-> Expression Expression)
;;
;; Parameters:
;;   $pattern - Input pattern to partition
;;
;; Returns:
;;   List of generated partitions
;;
;; Process:
;;   1. Extracts clauses from pattern
;;   2. Generates subsets
;;   3. Calls Python partition generator
;;
;; Example:
;;   (generet-partition-without-pattern '(And A B C))
;;   → ((A B C)) or other valid partitions
;; =============================================================================
; (: generet-partition-without-pattern (-> Expression Expression))
(= (generet-partition-without-pattern $pattern)
    (let* (
            ($clause (get-clauses $pattern))
            ($subsets (gen-subsets $clause)))
        (partition $subsets $clause)))


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

(= (powerset-without-empity $list)
  (let $subset (powerset $list) (collapse
        (subtraction
            (superpose $subset)
            (superpose (()))
        )
    ))
)


;; Documentation for (partition $conj-pattern)
;;
;; Generates all partitions that include the specified conjunctive
;; pattern as an atomic element in each result.
;;
;; Parameters:
;;   $conj-pattern
;;     The pattern to be treated as a single unit in every
;;     partition.
;;
;; Returns:
;;   A list of partitions. Each partition is formed by:
;;     1. Computing all partitions of the input space without
;;        the given pattern (via generet-partition-without-pattern).
;;     2. Unioning the original $conj-pattern (as an atom) with
;;        each of those partitions.
;;
;; Example:
;;   (partition '(a b))
;;   ;; => returns all partitions where '(a b) appears as one block
; (= (partition $conj-pattern)  
;     (
;         let $part_wout-patt (generet-partition-without-pattern $conj-pattern)
;             (union-atom (($conj-pattern)) $part_wout-patt )
;     )

; )


;; ===========================================================================
;; FUNCTION: remove-hashtag
;;
;; DESCRIPTION:
;;   Processes an expression and removes all occurrences of the `#` symbol
;;   from variable names. This is used to normalize variables that enter or
;;   leave the space, ensuring they are represented without the hashtag.
;;
;; PARAMETERS:
;;   • $x — An expression potentially containing variables with `#` in their names.
;;
;; RETURNS:
;;   A transformed expression where all variables have been stripped of `#`.
;;
;; EXAMPLE:
;;   (remove-hashtag '(#x + #y))
;;   ⇒ (x + y)
;;
;;   (remove-hashtag '(foo #bar #baz))
;;   ⇒ (foo bar baz)
;; ===========================================================================
; we can't send a variable to python in PeTTa.
; (= ( remove-hashtag $x) 
;     (remove-hashtag-py $x))






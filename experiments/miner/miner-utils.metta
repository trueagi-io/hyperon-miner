
;;;;;;;;;;;;; Sorting function for surprisingness ;;;;;;;;;;;;;

;(: insert_N (-> $a (List $a) (List $a)))
(= (insert_N $x Nil) (Cons $x Nil))
(= (insert_N $x (Cons $head $tail))
   (let ((: $prf ($lable $patrn $value)) (: $Tprf ($Tlable $Tpatrn $Tvalue))) ($x $head)
    ( if (> $value $Tvalue)
       (Cons $x (Cons $head $tail))
       (Cons $head (insert_N $x $tail)))))

;; Sorts a list of patterns by their surprisingness value using insertion sort.
;(: sort_surp_list (-> (List $a) (List $a)))
(= (sort_surp_list Nil) Nil)
(= (sort_surp_list (Cons $head $tail)) (insert_N $head (sort_surp_list $tail)))




;;;;;;; sort surprising patterns ;;;;;;;;;;
;;convert the collapsed (tuples) pattern to list
;;sort the list
;;convert to tuple and return sorted surprising patterns in decreasing order

;;patterns must be collapsed before passed to the surp-sorting
(=(surp-sorting $patterns) (
   chain (tuple_to_list $patterns) $ptrn (
        chain (sort_surp_list $ptrn) $res (list_to_tuple $res))
))



;; =============================================================================
;; copyed from chaining-utils.metta
;; =============================================================================
;; Define ad-atom-nodup, that adds an atom only if it is not already
;; in the atomspace
(: add-atom-nodup (-> $st Atom ()))
(= (add-atom-nodup $space $atom)
   (case (match $space $atom $atom)
     (($atom ())
      (Empty (add-atom $space $atom)))))


;; Add all atoms from an expression to a given atomspace
(: add-atoms-nodup (-> $st Expression ()))
(= (add-atoms-nodup $space $atoms)
   (if (== $atoms ())
       ()
       (let* (($head (car-atom $atoms))
              ($tail (cdr-atom $atoms))
              ($dummy (collapse (add-atom-nodup $space $head)))
              )
         (add-atoms-nodup $space $tail))))




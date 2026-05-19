(= (nat2debruijn $n) (if (== $n 0) Z (S (nat2debruijn (- $n 1)))))



; Main entry point
(= (get-var-index $var-list $target-var)
   (if (== ((intersection-atom $var-list ($target-var))) (()))
       (let* (
           ($updated-list (union-atom $var-list ($target-var)))
           ($idx (- (size-atom $updated-list) 1))
         )
         ($updated-list $idx)
       )
       (get-var-index-helper $var-list $target-var 0 $var-list)
   )
)

; Recursive helper: walks the list, increments counter until target is found
(= (get-var-index-helper $list $target-var $counter $orig-list)
   (if (== (car-atom $list) $target-var)
       ($orig-list $counter)
       (get-var-index-helper (cdr-atom $list) $target-var (+ 1 $counter) $orig-list)
   )
)
  





; Main function: converts variables in $lst to De Bruijn indices, accumulates result in $acc, tracks seen variables in $seen
(= (vars2debruijn-acc $lst $acc $seen)
   (if (== $lst ())
       ($acc $seen)
       (let* (
           ($head (car-atom $lst))
           ($tail (cdr-atom $lst))
         )
         (if (not (== (get-metatype $head) Variable))
             (vars2debruijn-acc $tail (union-atom $acc ($head)) $seen)
             (let* (
                ;   (($updated-seen $idx) (get-var-index $seen $head))
                 ($idx-result (get-var-index $seen $head))
                 ($updated-seen (car-atom $idx-result))
                 ($int (cdr-atom $idx-result))
                 ($idx (car-atom $int))
                 ($debruijn (nat2debruijn $idx))
               )
               (vars2debruijn-acc $tail (union-atom $acc ($debruijn)) $updated-seen)
             )
         )
       )
   )
)



; Main function: converts each subpattern in $subpats to De Bruijn form, accumulates result in $acc, tracks seen variables in $seen
(= (conjuncts2debruijn-acc $subpats $seen $acc)
   (if (== $subpats ())
       $acc
       (let* (
    
           (($subpat $tail) (decons-atom $subpats))
      
           (($head $args) (decons-atom $subpat))
           ($deb-result (vars2debruijn-acc $args () $seen))
     
           (($deb-args $int) (decons-atom $deb-result))
           ($updated-seen (car-atom $int))
           ($new-subpat (cons-atom $head $deb-args))
           ($new-acc (union-atom $acc ($new-subpat)))
         )
         (conjuncts2debruijn-acc $tail $updated-seen $new-acc)
       )
   )
)
;if we are dealing with a single pattern instead of a conjunct.
(= (subpattern2debruijn $subpat $seen)
   (let* (
       ($head (car-atom $subpat))
       ($args (cdr-atom $subpat))
       ($deb-result (vars2debruijn-acc $args () $seen))
       ($deb-args (car-atom $deb-result))
       ; $updated-seen is available as (car-atom (cdr-atom $deb-result)) if needed
       ($debruijn-subpat (cons-atom $head $deb-args))
     )
     $debruijn-subpat
   )
)

; Converts a conjunct pattern (with leading comma) to De Bruijn form.
(= (conjunct-pattern2debruijn $conjunct $seen)
   (let* (
       ($subpats (cdr-atom $conjunct))
       ($deb-result (conjuncts2debruijn-acc $subpats $seen ()))
       
       ($debruijn-conjunct (cons-atom , $deb-result))
     )
     $debruijn-conjunct
   )
)


(= (pattern2debruijn $pattern)
   (if (== (car-atom $pattern) ,)
      (conjunct-pattern2debruijn $pattern ())
      (subpattern2debruijn $pattern ())
       
   )
)
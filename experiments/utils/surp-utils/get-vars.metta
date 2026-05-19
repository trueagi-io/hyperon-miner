 
(=(check_var $item $list)
    (if (== $list ())
        False
        (let ($head $tail) (decons-atom $list)
            (if (== $item $head)
                True
                (check_var $item $tail)
            )
        )
    )
)

;; Main Duplicate Removal: Tail-recursive function to remove duplicates
;; $list: the list to process (e.g., ($x $y $x $z))
;; $acc: the accumulated unique list (e.g., ($z $y $x))
(=(remove-duplicates-tr $list $acc)
    (if (== $list ())
        $acc ; Return the final unique list
        (let ($head $tail) (decons-atom $list)
            (if (check_var $head $acc)
                ;; If it's a duplicate, just continue with the tail and old accumulator
                (remove-duplicates-tr $tail $acc)
                ;; If it's unique, prepend it to the accumulator and continue
                (remove-duplicates-tr $tail (cons-atom $head $acc))
            )
        )
    )
)

;; Wrapper for ease of use
(=(remove-duplicates $list)
    (remove-duplicates-tr $list ())
)


(=(collect-vars-from-pattern $pattern)
    (if (== $pattern ())
        ()
        (let ($head $tail) (decons-atom $pattern)
            (let $rec-vars (collect-vars-from-pattern $tail)
                (if (== (get-metatype $head) Variable)
                    (cons-atom $head $rec-vars)
                    $rec-vars
                )
            )
        )
    )
)

(=(get-var-tr $conjunct $acc)
    (if (== $conjunct ())
        (remove-duplicates $acc) 
        (let ($head $tail) (decons-atom $conjunct)
            (let $head-vars (collect-vars-from-pattern $head)
                (let $new-acc (union-atom $acc $head-vars)
                    (get-var-tr $tail $new-acc)
                )
            )
        )
    )
)

(=(get-var $conjunct)
    (if (== (car-atom $conjunct) ,)
        (get-var-tr (cdr-atom $conjunct) ())
        (get-var-tr $conjunct ())
    )
)


; !(get-var (,(Human $x tinsae) (Human $x $z) (Human $y man)))

;;;;;;;;;;;;;;;;;
;; Miner Utils ;;
;;;;;;;;;;;;;;;;;


(=(combinatorial_insert $h ())((($h))))
(=(combinatorial_insert $h $seq)(
    let*((($head $tail) (decons-atom $seq))
        ($reslut (combinatorial_insert $h $tail))
        ($comp_result (comp $head $reslut))  )
       (append-list (append-list (append-list $h $head) $tail) $comp_result)))


;!(combinatorial_insert (Bob $x) ((Human $x) (Parent $x)))
;!(combinatorial_insert D ((A) (B) (C)))


(=(mk-combinatorial_insert $main_head ())(combinatorial_insert $main_head ()))
(=(mk-combinatorial_insert $main_head $parts)(
    let* (
        (($part $tail) (decons-atom $parts))
        ($subparts (combinatorial_insert $main_head $part))) 
       (insert  $subparts (mk-combinatorial_insert $main_head $tail))))


(=(partitions ()) ())
(=(partitions $hs)(
    let* (
        (($head $tail) (decons-atom $hs))
        ($res (mk-combinatorial_insert $head (partitions $tail))))
          $res))

(=(is-partions-clouse $part $clauses) (
    let $res (collapse (is-present $part $clauses)) (or (car-atom $res) (== $part $clauses))
))

(=(valid-partitions $hs ())())
(=(valid-partitions $hs $partitions) (
    let ($head $tail) (decons-atom $partitions) (
        if (and (let $res (collapse (is-valid $hs $head)) (car-atom $res)) (not  (is-partions-clouse (remove-parenthesis $head) $hs) ))  
        (let $dummy (valid-partitions $hs $tail) (cons-atom (remove-parenthesis $head) $dummy))
            (valid-partitions $hs $tail))))




(=(partitions_without_pattern $clouses) (
    let  $prts (partitions $clouses) (valid-partitions $clouses $prts)))


(=(mk-body ()) ())
(=(mk-body $block) (
    let ($head $tail) (decons-atom $block) (
        if (let $res (is-pattern $head) (car-atom $res)) 
           (if (== $tail ()) $head 
               (let $temp (mk-body $tail) (if (== $temp ()) $head (, $head $temp)))) 
           (if (and (not (== $head ()))  (== $tail ())) (mk-body $head) 
               (let $res2 (mk-body $head) (mk-body ($res2 $tail)) ))
    ) 
))






(= (is_more_abstract_est ($link1 $x1 $y1) ($link2 $x2 $y2))
    (if (== $link1 $link2)
        (if
            (and
                (or
                     ; Check if x1 and x2 are equal, or x1 is more abstract (a variable)
                    (== $x1 $x2)
                    (and
                        (is-variable $x1) (or (is-expression $x2) (is-symbol $x2))))
                (or
                     ; Check if y1 and y2 are equal, or y1 is more abstract (a variable)
                    (== $y1 $y2)
                    (and
                        (is-variable $y1) (or (is-expression $y2) (is-symbol $y2)))))
            True
            False )
        False
    )
)


(=(is_more_abstract_init $x $y) (
   if (and ( let $res (unify $x ($link $z $w) True False) $res) (let $res2 (unify $y ($link $a $b) True False) $res2) )
       (is_more_abstract_est $x $y)
       False
))

;;;;;;;;;;;;;;;;;;
;;Define compose;; 
;;;;;;;;;;;;;;;;;;

;; replace the variable with the key value 
(:replace (->Variable ($key $val)))
(=(replace $var ($key $val)) (
    if (
        == $var $key
    ) $val null
))

;; check if var is in the subPat list and replce it
(:mapper (->Variable dic Variable))
(= (mapper $var $subPat) (
    if (
        == $subPat ()
    ) $var (
        let* (
        ($head (car-atom $subPat))
        ($tail (cdr-atom $subPat))
        ($temp (replace $var $head))
         ($newVar (if (== $temp null) (mapper $var $tail) $temp))
        )
        
        $newVar

    )
))

;;Substitutes variables in a pattern according to a provided map
; (: compose (->pattern dic pattern))
(=(compose ($link $x) $subPat) (
    let* (
        ($new_x      (   
                           case (get-metatype $x) 
                            (
                             (Expression (let $result_x (compose $x  $subPat) $result_x))
                             (Variable  (let $result_x (mapper $x $subPat) $result_x))
                             ($_ $x)
                            )
                      )
        )
     
    ) 
        ($link  $new_x )

))


(=(compose ($link $x $y) $subPat) (
    let* (
        ($new_x      (  
                           case (get-metatype $x) 
                            (
                             (Expression (let $result_x (compose $x  $subPat) $result_x))
                             (Variable  (let $result_x (mapper $x $subPat) $result_x))
                             ($_ $x)
                            )
                      )
        )
        (
         $new_y    (
                           case (get-metatype $y) 
                            (
                             (Expression (let $result_y (compose $y  $subPat) $result_y))
                             (Variable  (let $result_y (mapper $y $subPat) $result_y))
                             ($_ $y)
                            )

                   )
        )
        
    ) 
        ($link  $new_x $new_y)

))
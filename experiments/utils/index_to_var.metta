(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

(= (debruijn2num Z) 0)

(= (debruijn2num (S $k)) (+ 1 (debruijn2num $k)))

(= (fromNum $n) (if (<= $n 0) Z (S (fromNum (- $n 1)))))

(= (make_var) $x)

(= (find_val $history $val)
    (if (== $history ())
        ()
        (let* (
                (($head $value) (car-atom $history))
                ($tail (cdr-atom $history))
            )
            (if (== $head $val)
                $value
                (find_val $tail $val)
            )
        )
    )
)

(= (replacev $pattern)
    (if (== $pattern ())
        ()
    (let* (
       ($result (eval (deb2var $pattern ())))
       (($varpat $list) $result)
       )
       $varpat
    ))
)
(= (deb2var () $history)
    (() $history)
)
(= (deb2var $pattern $history)
    (let* (
        ($head (car-atom $pattern))
        ($tail (cdr-atom $pattern))
        ($history_val (find_val $history $head))
        ($newhead  (if (== (get-type $head) Nat) 
                        (if (== $history_val ())
                          (let $newvar (make_var) ($newvar (union-atom (($head $newvar)) $history)))
                          ($history_val $history)
                        ) 
                        (if (and (not (== (get-type $head) Nat)) (== (get-metatype $head) Expression))
                          (deb2var $head $history)
                          ($head $history)
                        )
                    ))
        (($var $new_history) $newhead)
        ($newtail (deb2var $tail $new_history))
        (($rest $final_history) $newtail)
    )
        ((cons-atom $var $rest) $final_history)
    )
)

(= (num2deb $pattern)
    (map-atom $pattern $x (if (== (get-type $x) Number) (fromNum $x) (if (and (not (== (get-type $x) Number)) (== (get-metatype $x) Expression)) (num2deb $x) $x)))
)


(= (replace $pattern)
    (if (== $pattern ())
        ()
    (let* (
       ($result (eval (var2num $pattern 0 ())))
       (($numpat $index $list) $result)
       ($deb (num2deb $numpat))
       )
       $deb
    ))
)

       
(= (var2num () $index $list)
    (() $index $list) ; Return the empty list, current index, and list
)

(= (check $list $var)
   (if (== $list ())
        False
        (if (== $var (car-atom $list))
            True
            (check (cdr-atom $list) $var))
    )
)

(= (find_index () $var $index)
    ()
)

(= (find_index $list $var $index)
    (let* (
        ($head (car-atom $list))
        ($tail (cdr-atom $list))
        ($res (if (== $head $var) $index (find_index $tail $var (+ $index 1))))
    )
    $res
    )
)

(= (var2num $pattern $index $list) 
        (let* (
            ($head (car-atom $pattern))
            ($tail (cdr-atom $pattern))    
            ($is_var (==  (get-metatype $head) Variable))
            ($is_expr (==  (get-metatype $head) Expression))
            ($check (check $list $head))
            ($processed_head_and_index (eval (if $is_expr
                                        (var2num $head $index $list) ; Recursive call for sub-expression
                                        (if $is_var
                                            (if $check
                                                ((find_index $list $head 0) $index $list) ; Return existing index, current index, and list
                                                ($index (+ $index 1) (union-atom $list ($head))) ; Return new index, incremented index, and updated list
                                              )
                                            ($head $index $list) ; Not a var or expr, return head, current index, and list
                                        )
                                    )))

            (($res_head $new_index $new_list) $processed_head_and_index)            
            ($processed_tail_and_index (var2num $tail $new_index $new_list)) ; Recursive call for tail with updated index and list
            (($res_tail $final_index $final_list) $processed_tail_and_index)

        )
        ((cons-atom $res_head $res_tail) $final_index $final_list)
        )   
)

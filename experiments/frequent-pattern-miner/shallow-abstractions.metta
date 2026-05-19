
(= (shallow_abstractions () $history $current_index)
    ()
)

(= (shallow_abstractions $valuations $history $current_index)
    (let* (
        ($head (car-atom $valuations))
        ($tail (cdr-atom $valuations))
        (($vals $abstractions $index) (get_abstractions $head $history $current_index))
        ($newhistory (cons-atom ($vals $abstractions) $history))
        ($abstractions_tail (shallow_abstractions $tail $newhistory $index))
    )
        (cons-atom $abstractions $abstractions_tail)
    )
)

(= (check_val $history $val)
    (if (== $history ())
        (False $val)
        (let* (
                (($head $abstraction) (car-atom $history))
                ($tail (cdr-atom $history))
            )
            (if (== $head $val)
                (True $abstraction)
                (check_val $tail $val)
            )
        )
    )
)


(= (get_abstractions () $history)
    ()
)

(= (get_abstractions $valuations $history $current_index)
    (let* (
            
            ($vals (superpose $valuations))
            (($found $res) (check_val $history $vals))
            (($abstraction $next_index) (if $found 
                                            ($res $current_index)
                                            (if (== (get-metatype $vals) Expression) 
                                            (let* (
                                                (($link $nodes) (decons-atom $vals))
                                                (($result $index) (get_abstraction $nodes $current_index () $current_index))
                                                ) ((cons-atom $link $result) $index))
                                            (if (== (get-metatype $vals) Variable)
                                                ((fromNumber $current_index) (+ $current_index 1)) 
                                                ($vals $current_index)
                                        )))
                                    )
        )
        ($vals $abstraction $next_index)
    )
)

(= (find_index_his () $val $index)
    ()
)

(= (find_index_his $list $val $index)
    (let* (
            ($head (car-atom $list))
            ($tail (cdr-atom $list))
        )
        (if (== $head $val)
            (fromNumber $index)
            (find_index_his $tail $val (+ $index 1))
        )
    )
)


(= (get_abstraction () $var_index $history $current_index)
    (() $current_index)
)

(= (get_abstraction $valuation $var_index $history $current_index)
    (let* (
            ($head (car-atom $valuation))
            ($tail (cdr-atom $valuation))
            (($abstraction $new_history $next_index) (if (== (intersection-atom ($head) $history) ())
                                                        ((fromNumber $current_index) (union-atom $history ($head)) (+ $current_index 1))
                                                        ((find_index_his $history $head $var_index) $history $current_index)
                                                      ))
            (($abstractions_tail $rest_index) (get_abstraction $tail $var_index $new_history $next_index))
        )
        ((union-atom ($abstraction) $abstractions_tail) $rest_index)
    )
)



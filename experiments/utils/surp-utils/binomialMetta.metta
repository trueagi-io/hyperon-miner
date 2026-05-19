(= (calculate_binomial_helper $n $k $result)
    (if (or (> $k $n ) (< $k 0))
        0
        (if (or (== $k 0) (== $k $n))
            1
            (let*
                (
                    ($temp (/ $n (- $n $k)))
                    ($newResult  (* $temp (calculate_binomial_helper (- $n 1) $k $temp)))
                )
                $newResult
            )
        )
    )
)

(= (calculate_binomial $n $k) (calculate_binomial_helper (max-atom ($n)) (max-atom ($k)) 1))
(=(cal_binomial $n $k) (calculate_binomial $n $k))
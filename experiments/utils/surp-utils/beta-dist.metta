;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Beta distributions from URE ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(=(beta_mean $alpha $beta) (
   let $result  (// $alpha (+ $alpha $beta)) (mean $result)
))



;;The variance of a Beta distribution is given by the formula:
;;Variance = α * β / ((α + β)^2 * (α + β + 1))
;; where α and β are the shape parameters of the Beta distribution.

(=(beta_var $alpha $beta) (
    let* (
        ($a (* $alpha $beta))
        ($b (* (+ $alpha $beta) (+ $alpha $beta)))
        ($c (+ $alpha (+ $beta 1) ))
        ($var (// $a (* $b $c)))

    )
        (variance $var)
))


(=(mean_accumulater $tv_list $pre_value)(
   if (== $tv_list ()) $pre_value (
       let* (
           ($head (car-atom $tv_list));;(Beta (mean 54) (variance 57))
           ($tail (cdr-atom $tv_list))
           ($mean_value (get_beta_mean_var $head mean)) ;; 54
           ($accumulate (+ $mean_value $pre_value))
           ($dummy (mean_accumulater $tail $accumulate))
       )
            $dummy
   )
))


(=(var_accumulater $tv_list $pre_value $mean)(
    if (== $tv_list ()) $pre_value (
        let* (
            ($head (car-atom $tv_list));;(Beta (mean 54) (variance 57))
           ($tail (cdr-atom $tv_list))
           ($mean_value_i (get_beta_mean_var $head mean))
           ($variance (get_beta_mean_var $head var))
           ($diff (- $mean_value_i $mean))
           ($relative_var (+ $variance (* $diff $diff)))
           ($rel_var_sum (+ $relative_var $pre_value))
           ($dummy (var_accumulater $tail $rel_var_sum $mean))
        )
           $dummy
    )
))


(=(get_tv_mean $tv) (
    let*(
        ($tail (cdr-atom $tv))
        ($mean (car-atom $tail))
    )
    $mean
))

(=(get_tv_conf $tv) (
    let*(
        ($tail (cdr-atom $tv))
        ($temp (cdr-atom $tail))
        ($conf (car-atom $temp))
    )
    $conf))


; (= (find_alpha $mean $variance) (
;     * $mean (- (// (* $mean (- 1 $mean) ) $variance) 1)
; ))
(= (find_alpha $mean $variance)
   (let* (
       ($one_minus_mean (- 1 $mean))
       ($mean_prod (* $mean $one_minus_mean))
       ($mean_prod_div_var (// $mean_prod $variance))
       ($mean_prod_div_var_minus1 (- $mean_prod_div_var 1))
       ($result (* $mean $mean_prod_div_var_minus1))
   )
   $result
   )
)

; (= (find_beta $mean $variance) (
;     * (- 1 $mean) (- ( // (* $mean (- 1 $mean)) $variance) 1)
; ))

(= (find_beta $mean $variance)
   (let* (
       ($one_minus_mean (- 1 $mean))
       ($mean_prod (* $mean $one_minus_mean))
       ($mean_prod_div_var (// $mean_prod $variance))
       ($mean_prod_div_var_minus1 (- $mean_prod_div_var 1))
       ($result (* $one_minus_mean $mean_prod_div_var_minus1))
   )
   $result
   )
)


; This function `mk-stv` creates a standard truth value (STV) using the provided mean and variance.
 ; It calculates the alpha and beta parameters based on the mean and variance.
 ; It then computes the count and confidence values using these parameters.
 ; The mode is determined based on the values of alpha and beta, following specific conditions.
 ; Finally, it returns an STV (mode, confidence) pair.
;;(: mk_stv (-> ))
(=(mk_stv $mean $variance) (
   let* (
     ($alpha (find_alpha $mean $variance))
     ($beta (find_beta $mean $variance))
     ($count-ch (let* (
          ;; sum of α and β
          ($sum_ab (+ $alpha $beta))
          ;; sum of priors
          ($sum_priors (+ (prior-alpha) (prior-beta)))
          ;; compute count = α+β − (prior-α + prior-β)
          ($count2 (- $sum_ab $sum_priors))
         )
     $count2))
     ($count (max $count-ch 0.1))
     ($confidence (// $count (+ $count (default_k))))
     ($mode  (
    if (and (> $alpha 1) (> $beta 1)) (
                // (- $alpha 1) (+ $alpha (- $beta 2))   ;; a-1 / a + b -2
    ) (
        if (and (<= $alpha 1) (> $beta 1)) 0 (

            if (and (< $alpha 1) (== $beta 1)) 1 
            (
                if (and (< $alpha 1) (< $beta 1)) $mean 1
            )
        )
    ))))

    ($mode $confidence)
   
))





 ; This function calculates the parameters of a Beta distribution based on the given empirical TV (emptv) data.
 ; It extracts the strength, confidence, and count from the empirical data, then computes the positive count
 ; and uses prior alpha and beta values (both set to 1.0) to calculate the final alpha and beta parameters
 ; for the Beta distribution. The final alpha is the sum of the prior alpha and the positive count, while the
 ; final beta is the sum of the prior beta and the difference between the count and the positive count.

(=(mk_distribution $tv) (
    let* (
         (($label $tv_mean $tv_conf) $tv)
         ($count (confidence->count $tv_conf))
         ($pos_count (* $tv_mean $count))
         ($alpha (+ (prior-alpha) $pos_count) )
         ($beta (+ (prior-beta) (- $count $pos_count ))) 
         ($_beta_dist (_beta_distribution $alpha $beta))

    )
       $_beta_dist        
))


(=(_beta_distribution $alpha $beta)(
     let*(
        ($beta_mean (beta_mean $alpha $beta))
        ($beta_variance (beta_var $alpha $beta))
     )
     (Beta $beta_mean $beta_variance)
))


;; 
(=(mk_distribution_list $patten_list)
     (collapse (mk_distribution (superpose $patten_list)))
         
)


;; $beta --> (Beta (mean 54) (variance 57))
(=(get_beta_mean_var $beta $key)(
    let (Beta (mean $mean) (variance $variance )) $beta (
        if (== $key mean) $mean $variance
      )))






(=(avrg_tv-iisurp $tv) (
    let* (
        ($tv_list (mk_distribution_list-iisurp $tv))
        ($size (tuple-count-iisurp $tv_list))
        ($mean (let $sum (mean_accumulater-iisurp $tv_list 0) (// $sum $size)))
        ($re_variance (let $var_sum  (var_accumulater-iisurp $tv_list 0 $mean) (// $var_sum $size)))
        ($finalAnswer (mk_stv-iisurp $mean $re_variance))
    )
    $finalAnswer
))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Beta distributions from URE ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(=(beta_mean-iisurp $alpha $beta) (
   let $result  (// $alpha (+ $alpha $beta)) (mean $result)
))

; (=(min-of-two $num1 $num2)(
;     if (< $num1 $num2) $num1 $num2
; ))

; (=(max-of-two $num1 $num2)(
;     if (> $num1 $num2) $num1 $num2
; ))




;;The variance of a Beta distribution is given by the formula:
;;Variance = α * β / ((α + β)^2 * (α + β + 1))
;; where α and β are the shape parameters of the Beta distribution.

(=(beta_var-iisurp $alpha $beta) (
    let* (
        ($a (* $alpha $beta))
        ($b (* (+ $alpha $beta) (+ $alpha $beta)))
        ($c (+ $alpha (+ $beta 1) ))
        ($var (// $a (* $b $c)))

    )
        (variance $var)
))


(=(mean_accumulater-iisurp $tv_list $pre_value)(
   if (== $tv_list ()) $pre_value (
       let* (
           ($head (car-atom $tv_list));;(Beta (mean 54) (variance 57))
           ($tail (cdr-atom $tv_list))
           ($mean_value (get_beta_mean_var-iisurp $head mean)) ;; 54
           ($accumulate (+ $mean_value $pre_value))
           ($dummy (mean_accumulater-iisurp $tail $accumulate))
       )
            $dummy
   )
))


(=(var_accumulater-iisurp $tv_list $pre_value $mean)(
    if (== $tv_list ()) $pre_value (
        let* (
            ($head (car-atom $tv_list));;(Beta (mean 54) (variance 57))
           ($tail (cdr-atom $tv_list))
           ($mean_value_i (get_beta_mean_var-iisurp $head mean))
           ($variance (get_beta_mean_var-iisurp $head var))
           ($diff (- $mean_value_i $mean))
           ($relative_var (+ $variance (* $diff $diff)))
           ($rel_var_sum (+ $relative_var $pre_value))
           ($dummy (var_accumulater-iisurp $tail $rel_var_sum $mean))
        )
           $dummy
    )
))


(=(get_tv_mean-iisurp $tv) (
    let*(
        ($tail (cdr-atom $tv))
        ($mean (car-atom $tail))
    )
    $mean
))

(=(get_tv_conf-iisurp $tv) (
    let*(
        ($tail (cdr-atom $tv))
        ($temp (cdr-atom $tail))
        ($conf (car-atom $temp))
    )
    $conf))


; (= (find_alpha $mean $variance) (
;     * $mean (- (// (* $mean (- 1 $mean) ) $variance) 1)
; ))
(= (find_alpha-iisurp $mean $variance)
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

(= (find_beta-iisurp $mean $variance)
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
(=(mk_stv-iisurp $mean $variance) (
   let* (
     ($alpha (find_alpha-iisurp $mean $variance))
     ($beta (find_beta-iisurp $mean $variance))
     ($count-ch (let* (
          ;; sum of α and β
          ($sum_ab (+ $alpha $beta))
          ;; sum of priors
          ($sum_priors (+ 1.0 1.0))
          ;; compute count = α+β − (prior-α + prior-β)
          ($count2 (- $sum_ab $sum_priors))
         )
     $count2))
     ($count (max $count-ch 0.1))
     ($confidence (// $count (+ $count 800.0)))
     ($mode  (
    if (and (> $alpha 1) (> $beta 1)) (
                // (- $alpha 1) (+ $alpha (- $beta 2))   ;; a-1 / a + b -2

                ;; the mode is just the sample proptotion, whcih is what we get by doing the number of successful observaion= alpha-1 , adn unsuc obser=beta -1.
    ) (
        if (and (<= $alpha 1) (> $beta 1)) 0 (
          ;;since beta is the count of unsucssful observations , the higher it is hte less our end probability will be in this case if alpha is too low and beta is too high , then the mean just becomes zero 

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

(=(mk_distribution-iisurp $tv) (
    let* (
         (($label $tv_mean $tv_conf) $tv)
         ($count (confidence-count_iisurp $tv_conf))
         ($pos_count (* $tv_mean $count))
         ($alpha (+ 1.0 $pos_count) )
         ($beta (+ (prior-beta-iisurp) (- $count $pos_count ))) 
         ($_beta_dist (_beta_distribution-iisurp $alpha $beta))

    )
       $_beta_dist        
))


(=(_beta_distribution-iisurp $alpha $beta)(
     let*(
        ($beta_mean (beta_mean-iisurp $alpha $beta))
        ($beta_variance (beta_var-iisurp $alpha $beta))
     )
     (Beta $beta_mean $beta_variance)
))


;; 
(=(mk_distribution_list-iisurp $patten_list)
     (collapse (mk_distribution-iisurp (superpose $patten_list)))
         
)


;; $beta --> (Beta (mean 54) (variance 57))
(=(get_beta_mean_var-iisurp $beta $key)(
    let (Beta (mean $mean) (variance $variance )) $beta (
        if (== $key mean) $mean $variance
      )))


(= (count-confidence_iisurp $cnt) (// $cnt (+ $cnt 1.0)))

;; Convert confidence to count using the formula
;;
;; count = (confidence * default_k) / (1 - confidence)

;;(= (confidence->count $conf) (if (approxEq 1.0 $conf 1e-9)(max-count)(/ (* $conf (lookahead)) (- 1.0 $conf))))

(=(confidence-count_iisurp $conf) (
    let* (
       ( $cf (min-atom ($conf 0.9999998)))
       ( $count (// (* (default_k-iisurp) $cf) (- 1.0 $cf)))

    )
      $count
))





(= (prior-alpha-iisurp) 1.0)


(= (prior-beta-iisurp) 1.0)

;; Default K value , as sated on "openCog/atomps/simpleTruthValue.h"
(= (default_k-iisurp) 800.0)
;; Lookahead
(= (lookahead-iisurp) 1.0) 
;; Maximum supported count (till +inf is supported, possibly).
(= (max-count-iisurp) 1e9)






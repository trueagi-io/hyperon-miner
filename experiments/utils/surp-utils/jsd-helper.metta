
;; Create Beta Distribution from TruthValue (mean, confidence)
;; Equivalent to constructing boost::math::beta_distribution using mean and count.
(=(mk_distribution_jsd $tv) (
    let* (
         (($label $tv_mean $tv_conf) $tv)
         ($count (confidence->count $tv_conf))
         ($pos_count (* $tv_mean $count))
         ($alpha (+ (prior-alpha) $pos_count) )
         ($beta (+ (prior-beta) (- $count $pos_count))) 
    )
    (Beta $alpha $beta)       
))






;; Main function: Compute Beta Distribution CDF sampled over N bins
;; Returns list of CDF values over equally spaced x ∈ (0, 1])
(=(beta_cdf $beta_dist $bins)
    (beta_cdf_loop $beta_dist $bins 0 ())
)

;; Loop to simulate: for (x_idx = 0; x_idx < bins; x_idx++)
(=(beta_cdf_loop $beta_dist $bins $x_idx $cdf_list)(
    if (>= $x_idx $bins) (reverse-list $cdf_list) (
        let* (

            ($x (/ (+ $x_idx 1.0) $bins))  
            ($x_clamped (min-atom (1.0 $x)))
            ($r (boost_math_cdf $beta_dist $x_clamped)) ;; Evaluate Beta CDF at x
            ($new_cdf_list (cons-atom $r $cdf_list))    ;; Append to list
            ($next_idx (+ $x_idx 1))                   ;; Next index
        )
        (beta_cdf_loop $beta_dist $bins $next_idx $new_cdf_list)
    )
))

;; Adapter to extract (alpha, beta) from Beta distribution and evaluate CDF
(=(boost_math_cdf $beta_dist $x)(
    let (Beta $alpha $beta) $beta_dist
    (boost-math-cdf $alpha $beta $x)  ;; Calls your math backend for Beta(alpha, beta)
))

;; Call to Python backend to compute Beta CDF
(= (boost-math-cdf $alpha $beta $x)
    (py-call (boost_petta.boost_math_cdf $alpha $beta $x))
)


;; Compute KLD between two CDFs (assumes both lists are same size)
(=(kld $l_cdf $r_cdf)(
    let* (
        ($epsilon 1e-32)
        ($i 0)
        ($last_lv 0.0)  ;; Last value of left CDF
        ($last_rv 0.0)  ;; Last value of right CDF
        ($kldi 0.0)     ;; Accumulated KLD
        ($l_size (size-atom $l_cdf))
        ($r_size (size-atom $r_cdf))
    )
    (if (== $l_size $r_size) 
        (kld_loop $l_cdf $r_cdf $epsilon $i $last_lv $last_rv $kldi)
        (error "CDF lists must have the same size")
    )
))

;; Loop over pairs of CDF values to accumulate relative entropy
(=(kld_loop $l_cdf $r_cdf $epsilon $i $last_lv $last_rv $kldi)(
    if (== $l_cdf ()) $kldi (  ;; Base case: empty list, return accumulated KLD
        let* (
            ($l_head (car-atom $l_cdf))
            ($r_head (car-atom $r_cdf))
            ($l_tail (cdr-atom $l_cdf))
            ($r_tail (cdr-atom $r_cdf))
            ($lp (- $l_head $last_lv))      ;; P(i) = l_cdf[i] - l_cdf[i-1]
            ($rp (- $r_head $last_rv))      ;; Q(i) = r_cdf[i] - r_cdf[i-1]
            ($e (if (and (> $rp $epsilon) (> $lp $epsilon))
                    (* $lp (log2 (/ $lp $rp)))  ;; Relative entropy contribution
                    0.0
                ))
            ($new_kldi (+ $kldi $e))        ;; Accumulate
            ($new_last_lv $l_head)
            ($new_last_rv $r_head)
        )
        (kld_loop $l_tail $r_tail $epsilon (+ $i 1) $new_last_lv $new_last_rv $new_kldi)
    )
))



;; Compute log2 for base-2 logarithm
(=(log2 $x)(
    log-math 2 $x
))

;; Compute element-wise average of two CDF lists
(=(avrg_cdf $l_cdf $r_cdf)(
    avrg_cdf_loop $l_cdf $r_cdf ()
))

(=(avrg_cdf_loop $l_cdf $r_cdf $result)(
    if (== $l_cdf ()) (reverse-list $result) (
        let* (
            ($l_head (car-atom $l_cdf))
            ($r_head (car-atom $r_cdf))
            ($l_tail (cdr-atom $l_cdf))
            ($r_tail (cdr-atom $r_cdf))
            ($avg_val (/ (+ $l_head $r_head) 2.0))  ;; Average of l[i], r[i]
            ($new_result (cons-atom $avg_val $result))
        )
        (avrg_cdf_loop $l_tail $r_tail $new_result)
    )
))

;; Compute average of two numbers
(=(avrg $a $b)(
    / (+ $a $b) 2.0
))





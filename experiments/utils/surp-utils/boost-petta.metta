;; Import required Python modules for lgamma only
(= (import $name) (py-call (importlib.import_module $name)))
(= (get-attr $obj $name) (py-call (getattr $obj $name)))

;; Import math module for lgamma (not available in MeTTa)
(=(math.lgamma $x) (py-call ("math.lgamma" $x)))

;; Log Beta function using log-gamma
(= (log-beta $a $b)
   (let* (
        ($lg-a (math.lgamma $a))
        ($lg-b (math.lgamma $b))
        ($lg-ab (math.lgamma (+ $a $b))))
     (- (+ $lg-a $lg-b) $lg-ab)))
; !(log-beta 5.0 2.0)

;; Continued fraction for incomplete beta (Lentz's method)
(= (betacf $a $b $x)
   (betacf-iter $a $b $x 1.0 1.0 1.0 1))

(= (betacf-iter $a $b $x $az $am $bm $m)
   (if (== $m 2)
       $az
       (let* (($qab (+ $a $b))
              ($qap (+ $a 1.0))
              ($qam (- $a 1.0))
              ($bz (- 1.0 (/ (* $qab $x) $qap)))
              ($em (py-call (float $m)))
              ($tem (* $em 2.0))
              ($d1 (* (* $em (- $b $em)) $x))
              ($d1-denom (* (+ $qam $tem) (+ $a $tem)))
              ($d (/ $d1 $d1-denom))
              ($ap (+ $az (* $d $am)))
              ($bp (+ $bz (* $d $bm)))
              ($d2-num (* (- 0 (+ $a $em)) (* (+ $qab $em) $x)))
              ($d2-denom (* (+ $qap $tem) (+ $a $tem)))
              ($d2 (/ $d2-num $d2-denom))
              ($app (+ $ap (* $d2 $az)))
              ($bpp (+ $bp (* $d2 $bz)))
              ($az-new (/ $app $bpp))
              ($am-new (/ $ap $bpp))
              ($bm-new (/ $bp $bpp))
              ($diff (abs-math (- $az-new $az))))
        (if (< $diff (* 3e-14 (abs-math $az-new)))
             $az-new
             (betacf-iter $a $b $x $az-new $am-new $bm-new (+ $m 1))
        )
    )))

; !(betacf 5.0 2.0 0.5)

;; Regularized incomplete beta I_x(a, b)
(= (incomplete-beta $a $b $x)
   (if (<= $x 0.0)
       0.0
       (if (>= $x 1.0)
           1.0
           (let* (($log-x (log-math 2.718281828459045 $x))
                  ($log-1-x (log-math 2.718281828459045 (- 1.0 $x)))
                  ($bt-exp (- (+ (* $a $log-x) (* $b $log-1-x)) (log-beta $a $b)))
                  ($bt (exp $bt-exp))
                  ($threshold (/ (+ $a 1.0) (+ (+ $a $b) 2.0))))
             (if (< $x $threshold)
                 (/ (* $bt (betacf $a $b $x)) $a)
                 (- 1.0 (/ (* $bt (betacf $b $a (- 1.0 $x))) $b)))))))
; !(incomplete-beta 5.0 2.0 0.5)

; ;; Beta CDF
(= (beta-cdf $x $a $b)
   (let $x-clamped (min-atom (1.0 (max-atom (0.0 $x))))
     (incomplete-beta $a $b $x-clamped)))

; !(beta-cdf 0.5 5.0 2.0)

;; Main function matching boost::math::cdf behavior
(= (boost-math-cdf $alpha $beta $x)
   (let $x-clamped (min-atom (1.0 $x))
     (beta-cdf $x-clamped $alpha $beta)))

; !(boost-math-cdf 0.5 0.5 0.5)

; ;; Test examples
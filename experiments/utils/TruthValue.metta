;; Simple Truth Value.  A Second order probability TV constructor,
;; i.e. probability and confidence.  The probability is in fact the
;; mode of the corresponding beta distribution.
; (: STV (-> Number Number TruthValue))



;;;;;;;;;;;;;
;; Methods ;;
;;;;;;;;;;;;;

;; Convert count to confidence using the formula
;;
;; confidence = count / (count + lookahead)
(: count->confidence (-> Number Number))
(= (count->confidence $cnt) (// $cnt (+ $cnt (lookahead))))

;; Convert confidence to count using the formula
;;
;; count = (confidence * default_k) / (1 - confidence)
(: confidence->count (-> Number Number))
;;(= (confidence->count $conf) (if (approxEq 1.0 $conf 1e-9)(max-count)(/ (* $conf (lookahead)) (- 1.0 $conf))))

(=(confidence->count $conf) (
    let* (
       ( $cf (min $conf 0.9999998))
       ( $count (// (* (default_k) $cf) (- 1.0 $cf)))

    )
      $count
))

















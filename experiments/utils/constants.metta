;;;;;;;;;;;;;;;
;; Constants ;;
;;;;;;;;;;;;;;;

;; For now the underlying beta distributions have a Jeffreys prior,
(: prior-alpha (-> Number))
(= (prior-alpha) 1.0)

(: prior-beta (-> Number))
(= (prior-beta) 1.0)

;; Default K value , as sated on "openCog/atomps/simpleTruthValue.h"
(: default_k (-> Number))
(= (default_k) 800.0)

;; Lookahead
(: lookahead (-> Number))
(= (lookahead) 1.0) 


;; Maximum supported count (till +inf is supported, possibly).
(: max-count (-> Number))
(= (max-count) 1e9)
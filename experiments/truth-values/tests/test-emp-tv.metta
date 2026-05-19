!(import! &self ../../utils/constants)
!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/TruthValue)
!(import! &self ../../utils/index_to_var)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self ../../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/partition-metta)
!(import! &self ../../utils/surp-utils/binomialMetta)
!(import! &self ../../utils/surp-utils/blk-abstractness)
!(import! &self ../../utils/surp-utils/eq-prob-petta)
!(import! &self ../../utils/surp-utils/bs-utils)
!(import! &self ../../truth-values/est-tv)
!(import! &self ../../truth-values/emp-tv)
!(import! &kb ../../data/ugly_man_sodaDrinker)






; !(do_emp_tv (,(Inheritance $x ugly) (Inheritance $x woman)) &kb 0.02)    
; !(let $val (do-ji-tv-est &kb (,(Inheritance $x ugly) (Inheritance $x woman))) (println! $val))
; !(do-ji-tv-est &kb (,(Inheritance $x ugly) (Inheritance $x woman))) 


;; =============================================================================
;; Test: Basic Pattern Support
;; -----------------------------------------------------------------------------
;; Verifies counting of matching patterns in the knowledge base
;; Expected: 60 instances of (Inheritance $x $y)
;; =============================================================================
!(test (sup (Inheritance $x $y) &kb) 60)

; ;; =============================================================================
; ;; Test: List Element Access
; ;; -----------------------------------------------------------------------------
; ;; Verifies zero-based indexing of knowledge base elements  
; ;; Expected: Third element is (Inheritance Bob human)
; ;; =============================================================================
!(test (get-element-by-Index  ((Inheritance Abe human) 
                             (Inheritance Rio human)
                             (Inheritance Bob human)
                             (Inheritance Mike human)
                             (Inheritance Mike Nil)
                             (Inheritance Zac human)
                             (Inheritance Zac human)
                             (Parent Abe Nil)) 2) 
              (Inheritance Bob human))

; ;; =============================================================================
; ;; Test: Sample Size Calculation
; ;; -----------------------------------------------------------------------------
; ;; Verifies statistical sample size calculation
; ;; Expected: numpy.power(44.444, 1) 
; ;; Note: Uses Python numpy integration
; ;; =============================================================================
; !(assertEqual (subsmp-size (Inheritance Abe human) 20 0.9)
;               ((py-atom numpy.power) 44.44444444444445 1))

; ;; =============================================================================
; ;; Test: Bootstrapped Truth Value
; ;; -----------------------------------------------------------------------------
; ;; Verifies truth value with bootstrap sampling
; ;; Expected: (EMPTV 0.2428 0.04109)
; ;;   - Strength: ~24.28%
; ;;   - Confidence: ~4.11%
; ;; =============================================================================
; !(assertEqual (emp-tv-bs (Inheritance Zac $x) &kb 8 0.6 0.9)
;               (EMPTV 0.2428095704426711 0.04109232092138521))

; ;; =============================================================================
; ;; Test: Simple Truth Value Construction  
; ;; -----------------------------------------------------------------------------
; ;; Verifies EMPTV struct creation from raw values
; ;; Expected: (EMPTV 0 0.00012498)
; ;; =============================================================================
!(test (mk_stv 1.7689693569125715 1.0178393379503528)
              (0 0.0001249843769528809))

;; =============================================================================
;; Test: Universe Counting
;; -----------------------------------------------------------------------------
;; Verifies counting of all Inheritance relationships regardless of arguments
;; Expected: 60 total Inheritance relations
;; =============================================================================
!(test (universe-count (Inheritance $x) &kb) 60)

;; =============================================================================
;; Test: Empirical Truth Value Calculation
;; -----------------------------------------------------------------------------
;; Verifies truth value calculation for specific pattern
;; Expected: (EMPTV 0.125 0.08888888888888889)
;;   - Strength: 12.5% 
;;   - Confidence: ~8.89%
;; =============================================================================
!(test (emp-tv (, (Inheritance $x woman) (Inheritance $x sodaDrinker)) &kb) 
              (EMPTV 0.001388888888888889 0.08181818181818183))

;; =============================================================================
;; Test: Database Expansion
;; -----------------------------------------------------------------------------
;; Verifies database size after duplication and expansion
;; Expected: Original size + 1
;; =============================================================================
; !(test (db_size (duplicate-and-expand-space &kb 1)) 
;               (+ 1 (db_size &kb)))




;; =============================================================================
;; Test: Iterative Truth Value Calculation
;; -----------------------------------------------------------------------------
;; Verifies truth value calculation with iterations
;; Expected: (EMPTV 0.001388888888888889 0.08181818181818183)
;;   - Strength: ~0%
;;   - Confidence: ~0.0125%
;; =============================================================================


!(test (do_emp_tv (,(Inheritance $x ugly) (Inheritance $x woman)) &kb 1) 
              (EMPTV 0.001388888888888889 0.08181818181818183))
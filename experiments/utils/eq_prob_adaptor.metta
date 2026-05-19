! (import! &self  eq-prob)
;; =============================================================================
;; Function: eq-prob-py (Python Probability Adapter)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Provides a MeTTa interface to call Python-implemented equal probability calculations,
;;   serving as a bridge between MeTTa and Python statistical functions.
;;
;; Inputs:
;;   - $partition: Data partition/structure to analyze
;;   - $pattern: Target pattern to match against
;;   - $db-size: Total size of the database/reference space
;;
;; Output:
;;   - Probability estimate computed by Python backend
;;
;; Implementation Notes:
;;   1. Acts as a thin wrapper for the Python-implemented `eq-prob-func`
;;   2. Simplifies importing and calling Python functions from MeTTa
;;   3. Maintains consistent parameter ordering between languages
;;
;; Example Usage:
;;   (eq-prob-py 
;;     ((Inheritance $x human) (Inheritance $x smart))
;;     (Inheritance $x human)
;;     1000)
;;
;; Dependencies:
;;   - Requires Python implementation of `eq-prob-func` to be available
;;   - Requires proper `import!` of the Python module
;; =============================================================================

(= (eq-prob-py $partition $pattern $db-size)
     (eq-prob-func $partition $pattern $db-size)
)


     
(=(m_add $x $y) (my-add $x $y))
;types
; (: do-jsd (-> TruthValue TruthValue Number))

;; =============================================================================
;; Function: do-jsd
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Computes a modified Jensen-Shannon Divergence (JSD) between two probability 
;;   distributions. This is a symmetric measure of similarity between distributions 
;;   with custom logarithmic scaling.
;;
;; Parameters:
;;   - $empirical_distribution: Observed distribution (TruthValue type)
;;   - $estimated_distribution: Predicted distribution (TruthValue type)
;;
;; Internal Computation:
;;   1. Extract strength components from both distributions
;;   2. Calculate midpoint distribution average
;;   3. Compute logarithmic ratios (base 10):
;;      a. log(empirical/midpoint)
;;      b. log(estimated/midpoint)
;;   4. Calculate entropy contributions:
;;      a. (empirical_strength * log_ratio_empirical) / 2
;;      b. (estimated_strength * log_ratio_estimated) / 2
;;   5. Sum contributions and take square root
;;
;; Returns:
;;   - Non-negative float representing distribution divergence

;; =============================================================================


;; Jensen-Shannon Divergence (JSD) function
;; Converts C++ jsd function to MeTTa
(=(do-jsd $l_tv $r_tv)(
    let* (
        ($_ (println! "=========== JSD SURP =========="))
        ($bins 10)                                     ;; static int bins = 100
        ($l_bd (mk_distribution_jsd $l_tv))                 ;; BetaDistribution l_bd(l_tv)
        ($r_bd (mk_distribution_jsd $r_tv))                     ;; BetaDistribution r_bd(r_tv)
        ($l_cdf (beta_cdf $l_bd $bins))
        ($r_cdf (beta_cdf $r_bd $bins))
        ($m_cdf (avrg_cdf $l_cdf $r_cdf))              ;; m_cdf = avrg_cdf(l_cdf, r_cdf)
        ($ld (kld $l_cdf $m_cdf))                      ;; ld = kld(l_cdf, m_cdf)
        ($rd (kld $r_cdf $m_cdf))                      ;; rd = kld(r_cdf, m_cdf)
        ($avg (avrg $ld $rd))                          ;; avrg(ld, rd)
        ($sqr-avg (sqrt-math $avg))
    )
        (py-call (round $sqr-avg 13))                                   ;; return sqrt(avrg(ld, rd))
))














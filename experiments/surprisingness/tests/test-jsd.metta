!(import! &self "../../utils/surp-utils/boost_petta.py")
!(import! &self ../../utils/constants)
!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self ../../utils/TruthValue)
!(import! &self ../../utils/surp-utils/jsd-helper)
!(import! &self ../jsd)








;; =============================================================================
;; Test 1: do-jsd (Basic JSD Calculation)
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Verify correct computation of modified Jensen-Shannon Divergence between:
;;   - Empirical distribution: (STV 0.5 1)
;;   - Estimated distribution: (STV 0.65 1)
;;
;; Computation Steps:
;; 1. Extract strengths: 0.5 and 0.65
;; 2. Calculate midpoint: (0.5 + 0.65)/2 = 0.575
;; 3. Compute log ratios (base 10):
;;    - log₁₀(0.5/0.575) ≈ -0.0607
;;    - log₁₀(0.65/0.575) ≈ 0.0531
;; 4. Calculate entropy contributions:
;;    - (0.5 * -0.0607)/2 = -0.015175
;;    - (0.65 * 0.0531)/2 = 0.0172575
;; 5. Sum contributions: 0.0020825
;; 6. Take square root: √0.0020825 ≈ 0.04563
;;
;; Expected Output: 
;;   0.0461555120911388 (pre-computed with high precision)
;;
;; Verification:
;;   - Tests core JSD calculation logic
;;   - Validates floating-point precision handling
;;   - Confirms proper handling of base-10 logarithms
;; =============================================================================
!(assertEqual 
  (do-jsd  (STV 0.8 0.111111) (STV 0.1 0.5555555555555556)) 
  1.0)


;; =============================================================================
;; Test 2: do-jsd (Basic JSD Calculation) 
;; -----------------------------------------------------------------------------
!(assertEqual 
	(do-jsd (STV 0.8 0.5555555555555556) (STV 0.7968127490039841 0.5565410199556541) )
 0.0847334463108
)

;; =============================================================================
;; Test 3: do-jsd (Basic JSD Calculation) 
;; -----------------------------------------------------------------------------

!(assertEqual 
   (do-jsd (STV 0.33333333 0.0037359900373599) (STV 0.6666666666666667 0.0074441687344913) )
  0.4796742430762
)
	

	

	
	

	
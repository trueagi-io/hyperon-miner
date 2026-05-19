; Compact, consistently formatted version of IIsurp_jsd.metta
; Functions operate on TruthValue structures (strength, confidence) rather than plain probabilities.
; Informative comments placed above key functions similar to isurp-old.

; Utility: multiply list of numbers (accumulate product)
(=(prob-accumulator $lst) (foldl-atom $lst 1 $acc $x (* $x $acc)))

; Return coherence factor list (choose max or min factor)
(=(get-coh-fact-sub $coh $maxormin) (if (== $maxormin max) (max-factor $coh) (min-factor $coh)))

; Compute conjunct TruthValue for a combination of subpatterns.
; Parameters: $comb (list of subpatterns), $db, $total_count
; Returns: TruthValue (strength confidence)
(=(get-comb-prob $comb $db $total_count)
 (let* (
   ($comb-conj (cons-atom , $comb))
   ($comb-support (collapse (match $db $comb-conj $comb-conj)))
   ($filtered-sups (filter-conjuncts $comb-support))
   ($sup-num (size-atom $filtered-sups))
   ($comb-prob-main (// $sup-num $total_count))
   ($conf (count_to_confidence-iisurp $total_count))
   ($prob-bodies (collapse (get-conc-prob-for-sub (superpose $comb) $db $total_count)))
   ($Accumulatedcohformax (prob-accumulator $prob-bodies))
   ($new_conf (* $conf $Accumulatedcohformax))
  )
  (TruthValue $comb-prob-main $new_conf)))

; Compute subpattern TruthValue interval by considering subconcept combinations.
; Parameters: $conjunct-w-comma, $db, $total_count
; Returns: TruthValue (strength confidence) or () if none
(=(sub-prob-main $conjunct-w-comma $db $total_count)
 (let* (
   ($conjunct (if (== (car-atom $conjunct-w-comma) ,) (cdr-atom $conjunct-w-comma) ($conjunct-w-comma)))
   ($filted-conjunct-w-subconcepts (collapse (filter-subpatterns-w-subs (superpose $conjunct) $db)))
  )
  (if (== $filted-conjunct-w-subconcepts ()) ()
   (let* (
     ($cart-combs (cart-helper $filted-conjunct-w-subconcepts () $db))
     ($filtered-conc (collapse (filter-subpatterns-wout-subs (superpose $conjunct) $filted-conjunct-w-subconcepts $db)))
     ($with-conc (map-atom $cart-combs $s (union-atom $filtered-conc $s)))
     ($comb-probs (collapse (get-comb-prob (superpose $with-conc) $db $total_count)))
     (($sub_avrg_str $sub_avrg_conf) (avrg_tv-iisurp $comb-probs))
    )
    (TruthValue $sub_avrg_str $sub_avrg_conf)))))

(=(sub-prob-main $conjunct-w-comma $db $total_count $conc_db)
 (let* (
   ($conjunct (if (== (car-atom $conjunct-w-comma) ,) (cdr-atom $conjunct-w-comma) ($conjunct-w-comma)))
   ($filted-conjunct-w-subconcepts (collapse (filter-subpatterns-w-subs (superpose $conjunct) $db $conc_db)))
  )
  (if (== $filted-conjunct-w-subconcepts ()) ()
   (let* (
     ($cart-combs (cart-helper $filted-conjunct-w-subconcepts () $db))
     ($filtered-conc (collapse (filter-subpatterns-wout-subs (superpose $conjunct) $filted-conjunct-w-subconcepts $db)))
     ($with-conc (map-atom $cart-combs $s (union-atom $filtered-conc $s)))
     ($comb-probs (collapse (get-comb-prob (superpose $with-conc) $db $total_count)))
     (($sub_avrg_str $sub_avrg_conf) (avrg_tv-iisurp $comb-probs))
    )
    (TruthValue $sub_avrg_str $sub_avrg_conf)))))

; Select max or min from cartesian-handled list elements (compatibility wrapper)
(=(handle-cart-probs $list-el $type) (let ($max $min) $list-el (if (== $type max) $max $min)))

; Compute combined TruthValue estimates for a conjunct from superconcepts and subpatterns.
; Parameters: $conjunct-w-comma, $db, $total_count
; Returns: list of TruthValue elements (possibly empty)
(=(get_set_prob_intervals $conjunct-w-comma $db $total_count)
 (let* (
   ($conjunct (if (== (car-atom $conjunct-w-comma) ,) (cdr-atom $conjunct-w-comma) ($conjunct-w-comma)))
   ($interval-list (collapse (get-concept-prob-call (superpose $conjunct) $conjunct $db $total_count)))
   (($supersTVstr $supersTVconf) (if (not (== $interval-list ())) (avrg_tv-iisurp $interval-list) ()))
   ($superTV (TruthValue $supersTVstr $supersTVconf))
   ($sub-int (sub-prob-main $conjunct-w-comma $db $total_count))
   ($whole1 (collapse $sub-int))
   ($whole2 (cons-atom $superTV $whole1))
   ($whole-comp (subtraction-atom $whole2 (())))
  )
  $whole-comp))

(=(get_set_prob_intervals $conjunct-w-comma $db $total_count $conc_db)
 (let* (
   ($conjunct (if (== (car-atom $conjunct-w-comma) ,) (cdr-atom $conjunct-w-comma) ($conjunct-w-comma)))
   ($interval-list (collapse (get-concept-prob-call (superpose $conjunct) $conjunct $db $total_count $conc_db)))
   (($supersTVstr $supersTVconf) (if (not (== $interval-list ())) (avrg_tv-iisurp $interval-list) ()))
   ($superTV (TruthValue $supersTVstr $supersTVconf))
   ($sub-int (sub-prob-main $conjunct-w-comma $db $total_count $conc_db))
   ($whole1 (collapse $sub-int))
   ($whole2 (cons-atom $superTV $whole1))
   ($whole-comp (subtraction-atom $whole2 (())))
  )
  $whole-comp))

; Simple wrappers to call getConceptProb (with or without conc_db)
(=(get-concept-prob-call $candidate $conjunct $db $total_count) (getConceptProb $candidate $conjunct $db $total_count))
(=(get-concept-prob-call $candidate $conjunct $db $total_count $conc_db) (getConceptProb $candidate $conjunct $db $total_count $conc_db))

; Convert a (prob-tv coh) pair into adjusted TruthValue using coherence
(=(getcohfact ($prob-tv $coh) $db $cand_count)
 (let* ((($label $mean $conf) $prob-tv) ($new_conf (* $conf $coh))) (EMPTV $mean $new_conf)))

; Estimate concept-level TruthValue by evaluating superconcepts from data.
; Parameters: $candidate (link pattern), $conjunct, $db, $total_count
; Returns: average TruthValue over superconcept estimates or empty
(=(getConceptProb $candidate $conjunct $db $total_count)
 (let* ((($link $per $conc) $candidate)
        ($orInst (collapse (match $db ($link $any $conc) $any)))
        ($candidate_count (total_counts-iisurp $candidate $db))
        ($concepts-raw (collapse (match $db ($link $anyI $anyC) $anyC)))
        ($concepts (unique-atom $concepts-raw))
        ($supercons (sub-super-concepts $orInst $concepts $conc super $db)))
  (if (== $supercons ()) (empty)
   (let* (
     ($sup-prob-body (collapse (get-prob-func (superpose $supercons) $db $candidate $conjunct $total_count)))
     ($superProbsmax (collapse (getcohfact (superpose $sup-prob-body) $db $candidate_count)))
     ($maxSuperprob (avrg_tv-iisurp $superProbsmax))
     ($avrg_super_tv (cons-atom TruthValue $maxSuperprob))
    )
    $avrg_super_tv))))

(=(getConceptProb $candidate $conjunct $db $total_count $conc_db)
 (let* ((($link $per $conc) $candidate)
        ($candidate_count (total_counts $candidate $db))
        ($supercons (collapse (match $conc_db (Inheritance $conc $any) $any))))
  (if (== $supercons ()) (empty)
   (let* (
     ($sup-prob-body (collapse (get-prob-func (superpose $supercons) $db $candidate $conjunct $total_count)))
     ($superProbsmax (collapse (getcohfact (superpose $sup-prob-body) $db $candidate_count)))
     ($maxSuperprob (avrg_tv-iisurp $superProbsmax))
     ($avrg_super_tv (cons-atom TruthValue $maxSuperprob))
    )
    $avrg_super_tv))))

; Total count helper for IIsurp-jsd (uses iisurp variants)
(= (total_counts-iisurp $pattern $db) (cal_binomial-iisurp (db_size-iisurp $db) (n_conjuncts_new-iisurp $pattern)))

; Build a super-pattern by replacing candidate with its superconcept and estimate TruthValue + coherence.
; Returns: (TruthValue final_prob confidence) and coherence
(= (get-prob-func $superconc $db $candPat $conjunct $total_count)
 (let* ((($link $some1 $some2) $candPat)
        ($coher (coherence $superconc $db $link))
        ($con_super_pattern ($link $some1 $superconc))
        ($conjWoutCand (rmvEl-iisurp $candPat $conjunct))
        ($conjWSup (cons-atom $con_super_pattern $conjWoutCand))
        ($compconj (cons-atom , $conjWSup))
        ($comb-support (collapse (match $db $compconj $compconj)))
        ($filtered-sups (filter-conjuncts $comb-support))
        ($conjSup (size-atom $filtered-sups))
        ($conjProb (// $conjSup $total_count))
        ($supConSup (sup-num-iisurp $db $con_super_pattern))
        ($canConSup (sup-num-iisurp $db $candPat))
        ($superprob (// $supConSup $total_count))
        ($candidateProb (// $canConSup $total_count))
        ($final_prob (* $conjProb (// $candidateProb $superprob)))
        ($conf (count_to_confidence-iisurp $total_count)))
  ((TruthValue $final_prob $conf) $coher)))

(= (DEFAULT_K-iisurp) 800.0)
(= (count_to_confidence-iisurp $x) (// $x (+ $x (DEFAULT_K-iisurp))))


; Main IIsurp-pln: compute subset TruthValue estimates for a pattern.
(= (IIsurp-pln $pattern $db)
 (let* (
($total_count (total_counts-iisurp $pattern $db))
   ($pattern_prob (emp-tv $pattern $db ))
   ($result_tv_inter (do-ji-tv-est $db $pattern) )
   ($subset-results_tvs (get_set_prob_intervals $pattern $db $total_count))
  (($results ) (collapse (union-atom $result_tv_inter $subset-results_tvs)))
  ($final_estimate (avrg_tv-iisurp $results))
  ($final_tv (cons-atom TruthValue $final_estimate))
  ($dst (do-jsd $final_tv $pattern_prob))
  )
  $dst))

(= (IIsurp-pln $pattern $db $conc_db)
 (let* (
   ($total_count (total_counts-iisurp $pattern $db))
   ($pattern_prob (emp-tv $pattern $db ))
   ($result_tv_inter (do-ji-tv-est $db $pattern) )
   ($subset-results_tvs (get_set_prob_intervals $pattern $db $total_count $conc_db))
  (($results ) (collapse (union-atom $result_tv_inter $subset-results_tvs)))
  ($final_estimate (avrg_tv-iisurp $results))
  ($final_tv (cons-atom TruthValue $final_estimate))
  ($dst (do-jsd $final_tv $pattern_prob))
  )
  $dst
  ; $subset-results_tvs
  ))
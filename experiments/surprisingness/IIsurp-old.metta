

; Compact, consistently formatted n-ary support helpers for IIsurp (informative comments added).
; Functions compute alternative-support intervals when a symbolic node in a conjunct can be replaced by
; potential super-symbols. Coherence is estimated pairwise and aggregated for n-ary interactions.

(= (collect-symbols $subPat $acc $position)
 (if (== $subPat ()) $acc
  (let* ( (($head $tail) (decons-atom $subPat))
          ($newAcc (if (== (get-metatype $head) Symbol) (cons-atom ($head $position) $acc) $acc))
          ($sum (+ 1 $position)) )
   (collect-symbols $tail $newAcc $sum) )))

(= (total_counts-iisurp $pattern $db) (cal_binomial-iisurp (db_size-iisurp $db) (n_conjuncts_new-iisurp $pattern)))

; For a given symbol position, find candidate substitutions from KB nodes and return matches.
(=(handle-symbols ($symb $idx) $link $nodes $pos $acc $matches $kb)
 (if (> $pos $idx) $matches
  (let* ( (($head $tail) (decons-atom $nodes))
          ($bool (== $idx $pos))
          ($newAcc (if (== $bool False) (union-atom $acc ($head))
                     (let* (($construct (cons-atom $new-var $tail)) ($interCons (union-atom $acc $construct))) (cons-atom $link $interCons))))
          ($newMatch-mid (if (== $bool True) (collapse (match $kb $newAcc $new-var)) $matches))
          ($newMatch (unique-atom $newMatch-mid)) )
   (handle-symbols ($symb $idx) $link $tail (+ 1 $pos) $newAcc $newMatch $kb) )))

; Replace original concept at position idx with substituteConcept for subpattern generation.
(=(handle-getting-subpat $subPat $acc $idx $pos $originalConcept $substituteConcept)
 (if (> $pos $idx) (union-atom $acc $subPat)
  (let* ( (($head1 $tail1) (decons-atom $subPat))
          ($newAcc (if (== $pos $idx) (union-atom $acc ($substituteConcept)) (union-atom $acc ($head1)))) )
   (handle-getting-subpat $tail1 $newAcc $idx (+ 1 $pos) $originalConcept $substituteConcept) )))

(=(handle-individual-elements $el1 $el2) (if (=alpha $el1 $el2) $el1 False))

; Scan list of candidate subpatterns, and for those matching target tar, substitute concept at idx.
(= (get-subPat $tar $list $idx $acc $originalConcept $substituteConcept)
 (if (== $list ()) $acc
  (let* ( (($head1 $tail1) (decons-atom $list))
          (($new-subPat $bool1) (handle-checking-subpat $head1 $head1 $tar))
          ($outSubpat (if (== $bool1 True) (handle-getting-subpat $head1 () $idx 0 $originalConcept $substituteConcept) $head1))
          ($newAcc (cons-atom $outSubpat $acc)) )
   (get-subPat $tar $tail1 $idx $newAcc $originalConcept $substituteConcept) )))

(=(handle-checking-subpat $subPat1 $subPat1-copy $subPat2)
 (if (== $subPat1 ()) ($subPat1-copy True)
  (let* ( (($head1 $tail1) (decons-atom $subPat1)) (($head2 $tail2) (decons-atom $subPat2)) )
   (if (not (=alpha $head1 $head2)) ($subPat1-copy False) (handle-checking-subpat $tail1 $subPat1-copy $tail2)) )))

(=(handle-rmvEl $subPat1 $subPat1-copy $subPat2)
 (if (== $subPat1 ()) (empty)
  (let* ( (($head1 $tail1) (decons-atom $subPat1)) (($head2 $tail2) (decons-atom $subPat2)) )
   (if (not (=alpha $head1 $head2)) $subPat1-copy (handle-rmvEl $tail1 $subPat1-copy $tail2)) )))

; For a symbol node in a subpattern, compute interval bounds replacing it with candidate super-symbols.
(= (handle-symbol-main $expr $subpat-sup $link $nodes $pos $acc $matches $db $full-conjunct $subPat $total-count)
 (let* ( (($symb $idx) $expr)
         ($main-count (size-atom $subpat-sup))
         ($filterd-sup-for-symb (collapse (filter-symbol-from-support (superpose $subpat-sup) $symb)))
         ($substituteSymbs-mid (handle-symbols $expr $link $nodes $pos $acc $matches $db))
         ($subsy-inter (unique-atom $substituteSymbs-mid))
         ($substituteSymbs (subtraction-atom $subsy-inter ($symb))) )
  (if (== $substituteSymbs ()) (empty)
   (let* ( ($superSubpattern (collapse (ret-supSize (superpose $substituteSymbs) $link $nodes $filterd-sup-for-symb $symb $idx $db))) )
    (if (== $superSubpattern ()) (empty)
     (let* ( ($max-probs (collapse (handle-super-symbols-conjunct (superpose $superSubpattern) $full-conjunct $subPat $db $main-count $total-count $idx $link $symb max)))
             ($upper-bound (max-atom $max-probs))
             ($min-probs (collapse (handle-super-symbols-conjunct (superpose $superSubpattern) $full-conjunct $subPat $db $main-count $total-count $idx $link $symb min)))
             ($lower-bound (min-atom $min-probs)) )
      ($upper-bound $lower-bound)))))))

; Given a potential substitution (potsymb), build completed conjunct, compute coherence and weighted prob.
(=(handle-super-symbols-conjunct ($sympat $potsymb $sup-size-for-changed-symb $actual-support) $full-conjunct $subPat $db $main-count-of-subpattern $total-count $idx $link $symb $maxormin)
 (let* ( ($completed-conjunct-mid (get-subPat $subPat $full-conjunct (+ 1 $idx) () $symb $potsymb))
         ($completed-conjunct (cons-atom , $completed-conjunct-mid))
         ($coherence (nary-coherence $potsymb $subPat $actual-support $idx $db $link))
         ($conjunct-sup (collapse (match $db $completed-conjunct $completed-conjunct)))
         ($msize (size-atom $conjunct-sup))
         ($prob (// $msize $total-count))
         ($down-weight (// $main-count-of-subpattern $sup-size-for-changed-symb))
         ($factor (if (== $maxormin max) (max-factor $coherence) (min-factor $coherence)))
         ($final-prob (* $factor (* $prob $down-weight))) )
  $final-prob))

; For a candidate symbol substitution, compute support size and return tuple for handling.
(=(ret-supSize $potSymb $link $nodes $support $symb $idx $db)
 (let* ( ($substitutedPattern (change-symb $link $nodes $potSymb $idx 0 ()))
         ($substitutedSupport (collapse (match $db $substitutedPattern $substitutedPattern)))
         ($filter-potentital (collapse (filter-symbol-from-support (superpose $substitutedSupport) $potSymb)))
         ($common (intersection-atom $support $filter-potentital))
         ($support-of-subpat (size-atom $substitutedSupport))
         ($size-common (size-atom $common)) )
  (if (== (size-atom $support) $size-common) ($substitutedPattern $potSymb $support-of-subpat $substitutedSupport) (empty)) ))

; Construct substituted pattern by placing symb at index idx into nodes.
(=(change-symb $link $nodes $symb $idx $pos $acc)
 (if (> $pos $idx) $acc
  (let* ( (($head $tail) (decons-atom $nodes))
          ($bool (== $idx $pos))
          ($newAcc (if (== $bool False) (union-atom $acc ($head))
                     (let* (($construct (cons-atom $symb $tail)) ($interCons (union-atom $acc $construct))) (cons-atom $link $interCons)))) )
   (change-symb $link $tail $symb $idx (+ 1 $pos) $newAcc) )))

; Receive candidate substitutions for a subpattern and produce (max min) interval bounds.
(=(recieve-candidate $subPat $db $full-conjunct $total-count)
 (let* ( ($subPat-sup (collapse (match $db $subPat $subPat)))
         ($link (car-atom $subPat))
         ($nodes (cdr-atom $subPat))
         ($symbs (collect-symbols $nodes () 0))
         ($out2 (collapse (handle-symbol-main (superpose $symbs) $subPat-sup $link $nodes 0 () () $db $full-conjunct $subPat $total-count))) )
  (if (== $out2 ()) (empty)
   (let* ( ($flattend (handle-list-interval $out2 ()))
           ($ret-max (if (== $flattend ()) () (max-atom $flattend)))
           ($ret-min (if (== $flattend ()) () (min-atom $flattend))) )
    ($ret-max $ret-min))))

)

; Collect n-ary interval estimates for a conjunct (wrapper).
(=(get-set-prob-intervals-nary $conjunct-w-comma $db $total_count)
 (let* ( ($conjunct (if (== (car-atom $conjunct-w-comma) ,) (cdr-atom $conjunct-w-comma) ($conjunct-w-comma)))
         ($interval-list (collapse (recieve-candidate (superpose $conjunct) $db $conjunct $total_count)))
         ($all-fn-sups (handle-list-interval $interval-list ()))
         ($retval-max (if (== $all-fn-sups ()) () (collapse(max-atom $all-fn-sups))))
         ($retval-min (if (== $all-fn-sups ()) () (collapse(min-atom $all-fn-sups)))) 
         ($out-ans (union-atom $retval-min $retval-max
         ))
         
         )
  $out-ans))



(=(filter-symbol-from-support $sup $symb) (subtraction-atom $sup ($symb)))

(=(random-coherence-nary) 0.5)

; Estimate n-ary coherence by averaging pairwise coherences (fallback to random if support small).
(=(nary-coherence $potsymb $subPat $actual-support $idx $db $link)
 (if (<= (size-atom $actual-support) 1) (random-coherence-nary)
  (let* ( ($pairwise (cart-helper-set 2 $actual-support ()))
          ($uniquePairWise (fun $pairwise ()))
          ($pair-H (collapse (calcom-nary (superpose $uniquePairWise) $db $idx $link $potsymb)))
          ($sum-pair-H (add-the-coherence $pair-H))
          ($H-joint-approx (// (* $sum-pair-H 2) (* (size-atom $actual-support) (- (size-atom $actual-support) 1)))) )
   $H-joint-approx)))

; Pairwise coherence computation for two support entries.
(=(calcom-nary ($first $second) $db $idx $link $potsymb)
 (if (== $first $second) (empty)
  (let* ( ($other-inherited-first (handle-symbols ($potsymb $idx) $link (cdr-atom $first) 0 () () $db))
          ($other-inherited-second (handle-symbols ($potsymb $idx) $link (cdr-atom $second) 0 () () $db))
          ($inter (intersection-atom $other-inherited-first $other-inherited-second))
          ($inter-len (size-atom $inter))
          ($avglen (// (+ (size-atom $other-inherited-first) (size-atom $other-inherited-second)) 2))
          ($paircoh (// $inter-len $avglen)) )
   $paircoh)))

(= (IIsurp-old-nary $pattern $db $normalize)
 (let* ( ($_ (println! "==== IIsurp-old-nary surprisingness ====="))
         ($total_count (total_counts-iisurp $pattern $db))
         ($psup (collapse (match $db $pattern $pattern)))
         ($pattern_prob (// (size-atom $psup) $total_count))
         ($partitions (partitions $pattern))
         ($results-inter (isurp-old_iisurp $partitions $db $total_count))
         ($subset-results (get-set-prob-intervals-nary $pattern $db $total_count))
         ($results (if (not (== $subset-results ())) (union-atom $results-inter $subset-results) $results-inter))
         ($emin (min-atom $results))
         ($emax (max-atom $results))
         ($dst (dst-from-interval-iisurp $emin $emax $pattern_prob))
         
          )
  (min-atom ((if (== True $normalize) (// $dst (max-atom ($emax $pattern_prob))) $dst) 1.0))

  
  ))

  (= (IIsurp-old-nary $pattern $db $isurp $normalize $db_ratio )
 (let* ( ($_ (println! "==== IIsurp-nary surprisingness ====="))
         ($total_count (total_counts-iisurp $pattern $db))
         
        ($results-inter (ji_prob_est_interval $pattern $db $db_ratio))
        (($emin_mid $emax_mid ) $results-inter)
        ($emp (emp-prob-pbs $pattern $db $emax_mid $db_ratio))
         ($subset-results (get-set-prob-intervals-nary $pattern $db $total_count))
         ($results (if (not (== $subset-results ())) (union-atom $results-inter $subset-results) $results-inter))
         ($emin (min-atom $results))
         ($emax (max-atom $results))
         ($dst (dst_from_interval $emin $emax $emp))
         ($maxprb (max-atom ($emp $emax)))
         )
        (min-atom ((if $normalize (// $dst $maxprb) $dst) 1.0))


  
  ))
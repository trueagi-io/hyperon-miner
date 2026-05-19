
(=(is-number $x) 
   (== (get-type $x) Number) 
)

(= (count-sup $db $ptrn)
    (let $result (collapse (match $db $ptrn $ptrn))
         (size-atom $result)
    )
)

(= (handle-nested-exp $p)
    (if (not (== (get-metatype $p) Expression))
       $p
        (case $p
            (
                (($type $x) ($type $x))
                (($link $x $y) 
                                (let* (
                                    ( ($link $x $y) $p)
                                    ( $nx (collapse (handle-nested-exp $x)))
                                    ( $ny (if (== $x $y) $nx (collapse (handle-nested-exp $y))))
                                )
                                (superpose (
                                        ($link (superpose $nx) $w)
                                        ($link $z (superpose $ny))
                                        ($link $x $u)
                                        ($link $k $y)
                                        $d
                                        (if (== $x $y) ($link $g $g) ($link $g $o))
                                        ($link (superpose $nx) (superpose $ny))
                                    ))) 
                )))
                ))








(= (conj? $p)
    (case $p
    (((, $clause1 $clause2) True)
     ($_ False))))


;; define system proofs 
;------------------------------------------------------------------
;; System proof for ⍃
;; if conclusion equals (⍃ $X $Y), then return (: CPU (⍃ $X $Y)) 
;; if $x and $Y are fully grounded and (< $X $Y)
;------------------------------------------------------------------
(= (syn $kb $_ (: $prf (⍃ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (<= $X $Y))
          (: CPU (⍃ $X $Y))
             (empty)))


;----------------------------------------------------------------------------
;; system proof  to calculate the emp-tv for the given pattern. 
;; The database is queried here because, when it was placed in the premises, 
;; it caused infinite results in CPUEMP.
;----------------------------------------------------------------------------
(= (syn $kb $_ (: $prf (emp-cpu $ptrn  $emp ))) 
    (let $emp (match $kb (db-ref $db)  (emp-tv $ptrn $db))
       
    (: CPUEMP (emp-cpu $ptrn  $emp)) ) 
)

;-----------------------------------------------------------------------------
;; system proof  to calculate the est-tv for the given pattern. 
;; The database is queried here because, when it was placed in the premises, 
;; it caused infinite results in CPUEST.
;-----------------------------------------------------------------------------
(= (syn $kb $_ (: $prf (est-cpu  $ptrn $emp $est))) 
    (let* (($est-tv  (match $kb (db-ref $db) (do-ji-tv-est $db $ptrn)))
           )
    (: CPUEST (est-cpu $ptrn $emp $est-tv)) ) )



(= (syn $kb $_ (: $prf (jsd-cpu $emp $est $surp)))
    (let $surp-val (do-jsd $emp $est) 
       (: JSDCPU (jsd-cpu $emp $est $surp-val))))


;-----------------------------------------------------------------------------
;; emperical probability of a pattern 
(= (syn $kb $_ (: $prf (prob-cpu  $pattern $ucount $prob))) 
    (let $dbb (match $kb (db-ref $db) $db)
    (: CPUPROB (prob-cpu  $pattern $ucount (// (sup-num $dbb $pattern) $ucount) ))
    ) 
)

;-----------------------------------------------------------------------------
;; emperical probability of a pattern for isurp
(= (syn $kb $_ (: $prf (prob-cpu  $pattern $db-ratio $emax $prob))) 
    (let $dbb (match $kb (db-ref $db) $db)
    (: CPUPROB (prob-cpu  $pattern $db-ration $emax (emp-prob-pbs  $pattern $dbb $emax $db-ratio) ))
    ) 
)

;-----------------------------------------------------------------------------
;; system proof to calculate the partitions for the given pattern.
(= (syn $kb $_ (: $prf (partition-cpu  $pattern $partitions))) 
    (let 
    
        $partitions-result  (partitions-wout-pattern (cdr-atom $pattern))
         (: CPUPARTN (partition-cpu  $pattern $partitions-result)) ) 
)


;; it turns the block into pattern and computes it's probability 
(= (blk-prob-surp $blk $db $total_count) (
    let $pattern (cons-atom , $blk) (// (sup-num  $db $pattern) $total_count)
  ))



;; gives the product of the probability of each block of the partition
(= (iprob $partition $db $total-count) 
    (let $list  (collapse  (blk-prob-surp  (superpose $partition) $db $total-count)) (foldl-atom $list 1 $acc $elem (* $acc $elem) ) )                             
)



;----------------------------------------------------------------------------
;; min max estimation of the pattern for isurp old
(= (syn $kb $_ (: $prf (est-prob-cpu  $pattern $partitions $ucount $emin-emax))) 
    (let* (($dbb (match $kb (db-ref $db) $db))
            ($min-max (let $products (collapse (iprob (superpose $partitions) $dbb $ucount) ) (min-max $products))))
    (: CPUESTPROB (est-prob-cpu   $pattern $partitions $ucount  $min-max)) ) 
)


;----------------------------------------------------------------------------
;; min max estimation of the pattern for isurp 
(= (syn $kb $_ (: $prf (ji-prob-est-cpu  $pattern $partitions  $db_ratio $emin-emax))) 
    (let* (($dbb (match $kb (db-ref $db) $db))
            ($min-max (let $products  (collapse (ji-prob-est (superpose $partitions) $pattern $dbb $db_ratio)) (min-max $products))))
    (: CPUESTPROB (ji-prob-est-cpu  $pattern $partitions $db_ratio $min-max)) ) 
)


;-------------------------------------------------------------------------
;; calculates the distance between the estimate value and emperical value
(= (syn $kb $_ (: $prf (dst-cpu $x $y $dst))) 
    (let $dst (- $x $y)
    (: CPUDST (dst-cpu  $x $y $dst)) ) 
)


;------------------------------------------------------------------------
;; calculates the all possible same number of conjuct pattern 
(= (syn $kb $_ (: $prf (universal-cpu $pattern $db-size $ucount))) (
    let $number-of-conjuct (n_conjuncts_new $pattern) 
       (: CPUUNIVERSAL (universal-cpu $pattern $db-size (cal_binomial $db-size $number-of-conjuct)))
))


;-------------------------------------------------------------------------
;; create the minimum relation 
(= (syn $kb $_ (: $prf (minimum $x $y $z)))
         (let $min (min $x $y)
               (: MINIMUMCPU  (minimum $x $y $min))))


;-------------------------------------------------------------------------
;; create the maximum relation 
(= (syn $kb $_ (: $prf (maximum $x $y $z)))
         (let $max (max $x $y)
               (: MAXIMUMCPU  (maximum $x $y $max))))

;-------------------------------------------------------------------------
;; division relation 
(= (syn $kb $_ (: $prf (divide $x $y $z)))
         (let $div (// $x $y)
               (: DIVIDECPU (divide $x $y $div))))

;------------------------------------------------------------------------
;;equality checker relation 
(= (syn $kb $_ (: $prf (equals $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (== $X $Y))
          (: CPUequals (equals $X $Y))
             (empty)))

;---------------------------------------------------------------------
(= (syn $kb $_ (: $prf (⍄ $X $Y))) 
    (if (and (and (is-number $X) (is-number $Y)) (> $X $Y))
          (: CPU (⍄ $X $Y))
             (empty))) 

;==============================================================================
;;frequent pattern miner system proofs
;==============================================================================

;; system proof to get the unique links from the database
(= (syn $kb $_ (: $prf (uniqueLink $pattern $cnt))) 
    (let* (
        ($db (match $kb (db-ref $db) $db))
        ($uniquelink (unique-atom (collapse (match $db ($link $x $y) $link)) ) )
        ($sup (superpose $uniquelink))
        )
    (if (== (size-atom $uniquelink) 0)
          (empty)
             (: CPUUnique (uniqueLink ($sup $a $b) (count-sup $db ($sup $a $b))))
             ))
    )

;---------------------------------------------------------------------------
;; system proof to replace variables with debruijn index
(= (syn $kb $_ (: $prf (replace_variables $ptrn)))
    (let* (
        ($new_ptrn (replace $ptrn))
        )
    (if (== $new_ptrn ())
          (empty)
             (: CPUReplacevar (replace_variables $new_ptrn))
        )    
    )
)

;-----------------------------------------------------------------------------
;; system proof to count support
(= (syn $kb $_ (: $prf (sup_count $ptrn $count)))
    (let* (
        ($db (match $kb (db-ref $db) $db))
        ($conjuncts (get-conjuncts $ptrn))
        ($flat (cons-atom , $conjuncts))
        ($new_ptrn (collapse (match $db $flat $flat)))
        ($count (size-atom $new_ptrn))
    )
     (: CPUCounter (sup_count $ptrn $count))
    )
)

;-----------------------------------------------------------------------------
;;system proof to replace debruijn index with variables
(= (syn $kb $_ (: $prf (replace_index $ptrn $res)))
    (let* (
        ($new_ptrn (replacev $ptrn))
        )
    (if (== $new_ptrn ())
          (empty)
             (: CPUReplaceindex (replace_index $ptrn $new_ptrn))
        )    
    )
)

;-----------------------------------------------------------------------------
;;system proof to replace debruijn index with variables
(= (syn $kb $_ (: $prf (sort_conjunctions $ptrn $res)))
    (let* (
        ($new_ptrn (sort_conj $ptrn))
        )
    (if (== $new_ptrn ())
          (empty)
             (: CPUSortConjunctions (sort_conjunctions $ptrn $new_ptrn))
        )    
    )
)

;-----------------------------------------------------------------------------
;; system proof to get variables of a pattern
(= (syn $kb $_ (: $prf (get_variables_prf $ptrn $vars)))
    (let* (
        ($vars (get_variables_for_tree $ptrn))
        )
    (if (== $ptrn ())
          (empty)
             (: CPUGetPatternVariables (get_variables_prf $ptrn $vars))
        )    
    )
)

;-----------------------------------------------------------------------------
;; system proof to combine variable of two patterns
(= (syn $kb $_ (: $prf (combine_variables $vars1 $vars2 $comb)))
    (let* (
        ($comb (combine_lists $vars1 $vars2))
        )
    (if (== $comb ())
          (empty)
             (: CPUCombineVariables (combine_variables $vars1 $vars2 $comb))
        )    
    )
)

;-----------------------------------------------------------------------------
;; system proof to substitute variables in a pattern by another variables
(= (syn $kb $_ (: $prf (substitute_variables $pattern $vars $subpattern)))
    (let* (
        ($eachvars (superpose $vars))
        (true (println! (here $eachvars)))
        (($sub $remaining) (substitute $pattern $eachvars))
        ($subpattern (if (== (get-metatype $pattern) Variable) ((car-atom $sub) $remaining) ($sub $remaining)))
        (true (println! (here $subpattern)))
        )
    (if (== $subpattern ())
          (empty)
             (: CPUSubstituteVariables (substitute_variables $pattern $vars $subpattern))
        )    
    )
)

;-----------------------------------------------------------------------------
;;system proof to count the number of clauses in a pattern
(= (syn $kb $_ (: $prf (clause_count $ptrn $cnt)))
    (let* (
        ($cnt (let $clauses (get-conjuncts $ptrn) (size-atom $clauses)))
        )
    (if (== $cnt 0)
          (empty)
             (: CPUCount (clause_count $ptrn $cnt))
        )    
    )
)

;-----------------------------------------------------------------------------
;; system proof to clean conjunction with redundant clauses
(= (syn $kb $_ (: $prf (conjunction_clean_useless_clause $conjunction)))
    (let* (
        ($conjuncts (get-conjuncts $conjunction))
        ($unique_conjuncts (remove_useless_clauses $conjuncts))
        )
    (if (== (size-atom $conjuncts) (size-atom $unique_conjuncts))
        (: CPUConjunctionClean1 (conjunction_clean_useless_clause $conjunction))
        (empty)
    )
    )
)

(= (syn $kb $_ (: $prf (conjunction_clean_redundant_clause $conjunction)))
    (let* (
        ($conjuncts (get-conjuncts $conjunction))
        ($unique_conjuncts (unique-atom $conjuncts))
        )
    (if (== (size-atom $conjuncts) (size-atom $unique_conjuncts))
        (: CPUConjunctionClean2 (conjunction_clean_redundant_clause $conjunction))
        (empty)
    )
    )
)

;;------------------------------------------------------------------------------
;; system proof to handle depth
(= (syn $kb $_ (: $prf (depth-handler $type $val $val2 $shab $res)))
    (if (== $type X)
        (let* (
        ($shabx (handle-nested-exp $val)))
        (: CPUHandleNestedExp (depth-handler $type $val $val2 $shab $shabx))
        )
        (if (== $type Y)
            (if (== $val $val2)
                (let* (
                    ($shaby $shab)
                    )
                    (: CPUHandleNestedExp (depth-handler $type $val $val2 $shab $shaby))
                )    
                (let* (
                ($shaby (handle-nested-exp $val)))
                (: CPUHandleNestedExp (depth-handler $type $val $val2 $shab $shaby))   
                )
        )
        (empty)
    
    ))
)

;;------------------------------------------------------------------------------
;; system proof to get valuation set of a pattern
(= (syn $kb $_ (: $prf (valuation $type ($link $x $y) $val)))
    (let* (
        ($db (match $kb (db-ref $db) $db))
        ( $valx  (unique-atom (collapse (match $db ($link $x $y) $x))))
        ( $valy  (unique-atom (collapse (match $db ($link $x $y) $y))))
        )
    (if (== $type X)
        (if (== ($valx $valy) ())
          (empty)
             (: CPUHandleValuation (valuation $type ($link $x $y) (superpose $valx)))
        )  
        (if (== $type Y)
            (if (== ($valy $valx) ())
              (empty)
                 (: CPUHandleValuation (valuation $type ($link $x $y) (superpose $valy)))
            )
            (empty)
        )
    )  
    )
)     

; ------------------------------------------------------------------------------
;; functions to get valuation of a pattern
(= (syn $kb $_ (: $prf (get_matches $pattern $results)))
    (let* (
        ($db (match $kb (db-ref $db) $db))
        ($results (unique-atom (collapse (match $db $pattern $pattern))))
        (true (println! ("==== Getting matches =====" $pattern , $results)))
        )
    (if (== $results ())
          (empty)
             (: CPUGetMatches (get_matches $pattern $results))
        )    
    )
)

; ------------------------------------------------------------------------------
;; functions to get valuation of a pattern
(= (syn $kb $_ (: $prf (istop $pattern)))
    (if (== (get-metatype $pattern) Variable)
        (: CPUIsTop (istop $pattern))
        (empty))
)

; ------------------------------------------------------------------------------
;; functions to get valuation of a pattern
(= (syn $kb $_ (: $prf (isnottop $pattern)))
    (if (not (== (get-metatype $pattern) Variable))
        (: CPUIsNotTop (isnottop $pattern))
        (empty))
)

; ------------------------------------------------------------------------------
;; system proof to handle conjunction
(= (syn $kb $_ (: $prf (get_variables_for_pattern_cpu $pattern $varIndex)))
    (let* (
        ($varIndex (collapse (get_variables_for_pattern $pattern)))
        (true (println! ("==== Getting pattern variables =====" $pattern , $varIndex)))
        )
    (if (== $varIndex ())
          (empty)
             (: CPUGetPatternVariables (get_variables_for_pattern_cpu $pattern $varIndex))
        )    
    )
)

(= (get_vals_cpu_helper $list $varIndex $vals)
    (if (== $varIndex ())
        $vals
    (let* (
        ($head (car-atom $varIndex))
        (($var $index) $head)
        ($tail (cdr-atom $varIndex))
        ($val (unique-atom (get_vals $list $index ($var))))
        ($new_vals (union-atom $vals ($val)))
    )
    (get_vals_cpu_helper $list $tail $new_vals)
    ))
)

; ------------------------------------------------------------------------------
;; system proof to get valuation values at given index
(= (syn $kb $_ (: $prf (get_vals_cpu $list $varIndex $vals)))
    (let* (
        ($vals (get_vals_cpu_helper $list $varIndex ()))
        )
    (if (== $vals ())
          (empty)
             (: CPUGetVals (get_vals_cpu $list $varIndex $vals))
        )    
    )
)

(= (syn $kb $_ (: $prf (shallow_abstact_cpu $vals $shab)))
    (let* (
        (true (println! ("==== Shallow abstractions =====" $vals)) )
        ($shab (unique-atom (collapse (shallow_abstractions $vals () 0))))
        (true (println! (here in sys proof $shab)))
        ; ($shab (superpose $res))
        )
    (if (== $shab ())
          (empty)
             (: CPUGetVals (shallow_abstact_cpu $vals $shab))
        )    
    )
)



;;------------------------------------------------------------------------------
(= (syn $kb $_ (: $prf (is-conj $p))) 
    (if (conj? $p)
        (: CPUConjprf (is-conj $p))
        (empty)))


;;------------------------------------------------------------------------------
(= (syn $kb $_ (: $prf  (flatten-cpu $nptrn $fptrn))) (
    let $flatten (flatten $nptrn) (: FLATCPU (flatten-cpu $nptrn $flatten))
))

;;------------------------------------------------------------------------------
(= (syn $kb $_ (: $prf  (join-cpu $nptrn $jptrn))) (
    let $joined (cons-atom , $nptrn) (: CPUJoin (join-cpu $nptrn $joined))
))
    
        
;==============================================================================
;; chainner 
;==============================================================================
;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (
     ((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
      ; (true (println! ("==== Chainner step ====="  $prfarg $ccln)))
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms)))

          )
     (: ($prfabs $prfarg) $ccln)))


     

; ;; Base case.  For now it terminates at exactly iteration Z to avoid
; ;; collecting too many redundant results.
; (= (isyn $kb $depth Z $query) $query)

;; Iterative step
(= (isyn $kb $depth (S $k) $query)
   (let* (
      ($cres (collapse (syn $kb $depth $query)))
          ($dummy (add-atoms-nodup $kb $cres))
          )
     (isyn $kb $depth $k (superpose $cres))))

(= (collapser $kb $depth  $query)
   (let* (
      ($cres (collapse (syn $kb $depth $query)))
          )
     $cres))





    

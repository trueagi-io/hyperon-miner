; (: abstract-pattern
;    (-> (uniqueLink $ptrn $cnt)
;     (-> (ms-threshold $ms)
;       (-> (⍃ $ms $cnt)
;       (-> (replace_variables $ptrn)
;        (AbstractPattern $ptrn))))))

; ;;specialization of abstract patterns on the $x rule
; (: specializationx
;        (-> (AbstractPattern ($link $x $y)) 
;         (-> (replace_index ($link $x $y) ($link $nx $ny)) 
;           (-> (valuation X ($link $nx $ny) $valx)
;             (-> (depth-handler X $valx $valy $shab $shabx)
;             (-> (replace_variables ($shabx $ny))
;               (specializationOf ($link $x $y) ($link $shabx $ny))))))))

; ;;
; (: specializationabs
;        (-> (AbstractPattern ($link $x $y)) 
;               (specializationOf ($link $x $y) ($link $x $y))))


; ;;specialization of abstract patterns on the $y rule
; (: specializationy
;        (-> (AbstractPattern ($link $x $y)) 
;         (-> (replace_index ($link $x $y) ($link $nx $ny)) 
;           (-> (valuation Y ($link $nx $ny) $valy)
;             (-> (depth-handler Y $valy $valx $shab $shaby)
;             (-> (replace_variables ($nx $shaby))
;               (specializationOf ($link $x $y) ($link $nx $shaby))))))))

; ;;
; (: specializationxy
;        (-> (AbstractPattern ($link $x $y)) 
;         (-> (replace_index ($link $x $y) ($link $nx $ny)) 
;           (-> (valuation X ($link $nx $ny) $valx)
;           (-> (valuation Y ($link $nx $ny) $valy)
;             (-> (depth-handler X $valx $valy $shab $shabx)
;             (-> (depth-handler Y $valy $valx $shabx $shaby)
;             (-> (replace_variables ($shabx $shaby))
;               (specializationOf ($link $x $y) ($link $shabx $shaby))))))))))
;; Rules 

;; minimum support rule
(: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms-threshold $ms)
                 (-> (⍃ $ms $cnt)
                        (minsup $ptrn $cnt)))))

;; valuation for top pattern rule
(: valuationtop
    (-> (initpat $pattern)
      (-> (istop $pattern)
        (-> (get_matches $pattern $results)
         (val $pattern ($results))))))

;; valuation for not top pattern rule
(: valuationNotTop
    (-> (initpat $pattern)
      (-> (isnottop $pattern)
        (-> (get_matches $pattern $results)
          (-> (get_variables_for_pattern_cpu $pattern $varIndex)
            (-> (get_vals_cpu $results $varIndex $vals)
                (val $pattern $vals)))))))

;; more of a general rule for shallow abstraction because of recursion we were unable to further decompose it into its components
;; shallow abstraction rule
(: shallow_abs
    (-> (val $pattern $vals)
     (-> (shallow_abstact_cpu $vals $shab) 
      (shallow_Abs $pattern $shab))))

;; specialization rule
(: spec
  (-> (initpat $pattern)
    (-> (shallow_Abs $pattern $shabs)
        (-> (substitute_variables $pattern $shabs ($specs $remaining))
            (specializationOf $pattern $specs)))))


;;support of specialized patterns rule
(: supports 
      (-> (specializationOf $aptrn $sptrn)
      (-> (replace_index $sptrn $nsptrn) 
       (-> (sup_count $nsptrn $count)
          (supportOf $sptrn $count)))))


;; conjunction expansion rule
(: conjunction-expand
      (-> (candidatePattern $ptrn1 $cnt1)
       (-> (replace_index $ptrn1 $nptrn1)
         (-> (clause_count $nptrn1 $clcnt)   
          (-> (maxClauses $max)
           (-> (equals $clcnt $max)
            (-> (candidatePattern $ptrn2 $cnt2)
              (-> (replace_index $ptrn2 $nptrn2)
               (-> (clause_count $nptrn2 $clcnt2)
                (-> (equals $clcnt2 1)
                 (-> (ms-threshold $ms)
                  (-> (get_variables_prf $nptrn1 $vars1)
                   (-> (get_variables_prf $nptrn2 $vars2)
                    (-> (combine_variables $vars1 $vars2 $comb)
                     (-> (substitute_variables $nptrn2 $comb ($subptrn2 $remaining))
                      (-> (sup_count (, $nptrn1 $subptrn2) $count)
                       (-> (⍃ $ms $count)
                       (-> (conjunction_clean_useless_clause (, $nptrn1 $subptrn2))
                        (-> (replace_variables (, $nptrn1 $subptrn2))
                          (-> (conjunction_clean_redundant_clause (, $nptrn1 $subptrn2))
                            (candidatePattern (, $nptrn1 $subptrn2) $count)))))))))))))))))))))


;;; rule to format the patterns with their support
(: supportFormat
  (-> (candidatePattern $ptrn $count)
    (-> (clause_count $ptrn $clcnt)
      (-> (maxClauses $max) 
        (-> (⍄  $clcnt $max)
          (-> (sort_conjunctions $ptrn $sorted)
            (-> (join-cpu $sorted $jptrn)
              (hasSupport $jptrn $count))))))))
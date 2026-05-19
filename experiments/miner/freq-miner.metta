; -----------------------------------------------
;; candidate
; -----------------------------------------------
;; select patterns with min-sup as candidate pattern
(= (candidate $depth $kb)
   (let*(
    (true (println! "==== Selecting Candidate Patterns =====") )
    ((: $resprf $respat) (syn $kb $depth (: $prf (candidatePattern $x $cnt)))) 
    ($rem2 (remove-atom $kb (: $anyprf $respat)))
    ($add2 (add-atom $kb (: $resprf $respat)))
    )
    $res
    )
)

; ---------------------------------------------------
;; conjunction
; ---------------------------------------------------
;; expand conjunctions for as many clauses as needed
(= (conjunction $depth $kb $rec $maxrec) 
    (let*
        (
        (true (println! "==== Doing conjunction =====") )
        ($prevrec (- $rec 1))
        ($re (collapse (remove-atom $kb (: maxClauses (maxClauses $prevrec)))))
        ($add (collapse (add-atom $kb (: maxClauses (maxClauses $rec)))))
        ($res (collapse (syn $kb $depth (: $prf (candidatePattern $ptrn $cnt)))))
        ($red (collapse (let $final (superpose $res) (superpose ((remove-atom $kb $final) (add-atom $kb $final))))))
        )
    (if (> (+ $rec 1) $maxrec) $red (conjunction $depth $kb (+ $rec 1) $maxrec))
    )
)

; ------------------------------------------------------
;; format
; ------------------------------------------------------
;;format the patterns and add them to the knowledge base with their support
(= (format $depth $kb)
   (let* (
    (true (println! "==== Formatting patterns  =====") )
    ((: $prf $pattern) (syn $kb $depth (: $prf (hasSupport $ptrn $cnt)))) 
    ($rem2 (remove-atom $kb (: $anyprf $pattern)))
    ($add2 (add-atom $kb (: $prf $pattern)))
    )
    $res
    )
)

;; --------------------------------------------------
;; candidatePatternMiner
;; --------------------------------------------------
;; pipeline for the candidate pattern mining
(= (candidatePatternMiner $pattern $db $kb)
    (let* (
            (true (println! "==== Candidate Pattern Miner Started ====="))
            ($initpat (: init-pat (initpat $pattern)))
            ($addInit (add-atom $kb $initpat))
            ($atom (: candidatep (-> (minsup $ptrn $cnt) (-> (replace_variables $ptrn) (candidatePattern $ptrn $cnt)))))
            ($add (add-atom $kb $atom))
            ($result (collapse (candidate (fromNumber 18) $kb)))
            ($rem (remove-atom $kb $atom))
            ($remInit (remove-atom $kb $initpat))
            ($nextcnd (match $kb (: $prf (candidatePattern $cndpat $sup)) (replacev $cndpat)))
            (true (println! (matched $nextcnd)))
            ($next (has_nested_expression_with_respect_to $pattern $nextcnd))
            (true (println! ("==== Next Candidate =====" $next)))
            ($rec (if $next (candidatePatternMiner $nextcnd $db $kb) ()))
        )
        $rec
    )
)

; --------------------------------------------------
;; frequent-miner
; --------------------------------------------------
;; pipeline for the frequent patter mining 

(= (frequent-miner $db $kb $initpat $number-of-conjuct True) 
( 
     let*  ( 
        (true (println! "==== Frequent Miner Started =====") )
        ($resultsc (collapse (candidatePatternMiner $initpat $db $kb)))
         ($results (collapse (conjunction (fromNumber 19) $kb 1 (- $number-of-conjuct 1))))
         ($resultf (collapse (format (fromNumber 6) $kb)))
         ($final (collapse (match $kb (: $prf (hasSupport $pattern $sup)) (let $vpattern (replacev $pattern) (superpose ((remove-atom $kb (: $prf (hasSupport $pattern $sup))) (add-atom $kb (: $prf (hasSupport $vpattern $sup)))))))))
      ) ()
)
)
(= (frequent-miner $db $kb $initpat $number-of-conjuct False) 
( 
     let*  ( 
        (true (println! "==== Frequent Miner Started =====") )
         ($result (collapse (candidatePatternMiner $initpat $db $kb)))
      ) ()
)
)
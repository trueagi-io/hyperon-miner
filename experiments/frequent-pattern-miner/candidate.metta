(= (candidatepattern $specializations $minsup $dbspace)
        (let* ( 
                (true (println! "==== Candidate Pattern started ====="))
                ($specializedvar (replacev $specializations))
                ($result (sup-num $dbspace $specializedvar))
                ($add (if (>= $result $minsup) ($specializedvar $specializations $result) ()))
            ) 
        $add
))

(= (miner () $dbspace $minsup)
        ()
)

(= (miner $pattern $dbspace $minsup)
        (let*(
                ($vals (collapse (valuation $pattern $dbspace)))
                ($shallow_abstractions (unique-atom (collapse (shallow_abstractions $vals () 0))))
                ($specialized (specialization $pattern (superpose $shallow_abstractions)))
                ($candidates (candidatepattern $specialized $minsup $dbspace))
                (true (println! "==== Candidate Pattern ended ====="))
        )
        $candidates
        )
)


(= (has_nested_expression_with_respect_to $parent $candidate)
   (if (== $parent ())
       False
       (let* (
              ($headP (if (== (get-metatype $parent) Variable) (car-atom ($parent)) (car-atom $parent)))
              ($tailP (if (== (get-metatype $parent) Variable) (cdr-atom ($parent)) (cdr-atom $parent)))
              ($headC (if (== (get-metatype $parent) Variable) (car-atom ($candidate)) (car-atom $candidate)))
              ($tailC (if (== (get-metatype $parent) Variable) (cdr-atom ($candidate)) (cdr-atom $candidate)))
          )

          (if (== (get-metatype $headP) Variable)
              ;; Case 1: parent is a variable — check candidate
              (if (== (get-metatype $headC) Expression)
                  True
                  False)
              ;; Case 2: both are expressions — recurse
              (if (and (== (get-metatype $headP) Expression)
                       (== (get-metatype $headC) Expression))
                  (or (has_nested_expression_with_respect_to $headP $headC)
                      (has_nested_expression_with_respect_to $tailP $tailC))
                  ;; Otherwise just compare subparts
                  (has_nested_expression_with_respect_to $tailP $tailC)
              )
          )
       )
   )
)

(= (candidate-pattern-miner $initpat $dbspace $minsup $cndpspace)
        (let* (
                (($candidates $indexed $cnt) (miner $initpat $dbspace $minsup))
                ($rem (if (== $indexed ()) () (remove-atom $cndpspace (CandidatePattern $indexed $cnt))))
                ($add (if (== $indexed ()) () (add-atom $cndpspace (CandidatePattern $indexed $cnt))))
                ($next (has_nested_expression_with_respect_to $initpat $candidates))
                ($rec (if $next (candidate-pattern-miner $candidates $dbspace $minsup $cndpspace) ()))
            )
            $rec
        )
)

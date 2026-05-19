
; ---------------------------------
;; candidatePattern
; ---------------------------------
;get candidate patterns based on theri support
;; 1. get the specialized pattern
;; 2. calculate the support of the pattern
;; 3. store as a candidate if the support is greater than the minimum support

(= (candidatePattern $dbspace $spezspace $minsup $cndpspace)
    (match $spezspace (SpecializationOf $specialized $pattern)
        (let* ( 
                (true (println! ("==== Candidate Pattern started =====", $specialized)))
                ($specializedvar (replacev $specialized))
                ($result (sup-num $dbspace $specializedvar))
                ($rem (if  (>= $result $minsup) (remove-atom $cndpspace (CandidatePattern $specialized $result)) ())  )             
                ($add (if (>= $result $minsup) (add-atom $cndpspace (CandidatePattern $specialized $result)) ()))
            ) 
        $add
)))

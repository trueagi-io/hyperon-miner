; ---------------------------------------------
;; abstract-pattern
; ---------------------------------------------
;; Extract link atoms from the database and keep only those that meet the minimum support.
;; 1: Retrieve every fact as a link expression from the database.
;; 2: Remove duplicates with `unique` so each link is considered once.
;; 3: Evaluate the links against the minimum support using `evalLink`.
;; 4: Return the unique link set when it passes the support check; otherwise return `(empty)`.
(= (abstractPattern $dbspace $minSup)
    (let* (
            ($links (collapse (match $dbspace $fullFact (car-atom $fullFact))) )
            ; ($debug (println! (extracted links are:- $links minsup:- $minSup))) 
            ($niceLinks (eval (evalLink $links $minSup))) ;; evaluate links based on minsup
            ; ($debug2 (println! (nice links after evalLink are:- $niceLinks)))
        )
        $niceLinks
    )
)
; !(abstractPattern &self 2)        


( = (specialCreator (S $debruignIndex) $values $acc)
    (let*
        (
            ; ($debug1 (println! (values:- -: $values acc:- $acc)))
            (($topGuy $tailValue) (decons-atom $values))
            ($topGuyInVarForm (eval (make_var1)))
            ($accWithVar (union-atom $acc ($topGuyInVarForm)))
            ($accWithOutVar (union-atom $acc ($topGuy)))
        )
        (if (== $debruignIndex Z)
            (superpose ( $accWithOutVar $accWithVar ) )
            (superpose
                (   
                    (specialCreator $debruignIndex $tailValue $accWithOutVar)
                    (specialCreator $debruignIndex $tailValue $accWithVar)
                )
            )

        )

    )
)


(= (buildSpecialization $db $uniqueLink) 
    (collapse 
        (let*
            (  
                ($debug1 (println! "==== Build specialization started ====="))
                ($data (match $db $fullFact $fullFact))
                ; ($debug2 (println! (data matched are:- $data)))
                (($uniqueLink $values) (decons-atom $data)) ;this will end the thread if uniqueLink doesn't match
                ; ($debug3 (println! (values:- $values)))
                ($size (size-atom $values))
                ($depth (eval (fromNumber $size)))
                ; ($debug4 (println! (depth:- $depth values: $values uniqueLink:- $uniqueLink)))
                ($response (specialCreator $depth $values ($uniqueLink)))
                ; ($debug5 (println! (response built are:- $response)))
            )
            $response
        )
    )
)
; !(-------------------------------)
; !(collapse (buildSpecialization &self Inheritance))
; !(-------------------------------)

;;temporary function to filter best candidate patterns from specializations
( = (evalCandidatePatterns $db $dbSize $specialPattern $minSup)
    (let*
        (
            ($pool (collapse (match $db $specialPattern 1))) 
            ($size (size-atom $pool))
            ; ($debug1 (println! (size of candidate patterns ($specialPattern) :- $size )))
        )
        (if (and (>= $size $minSup) (< $size $dbSize)) True False)
    )
)
; !(evalCandidatePatterns &self 10 (Inheritance $varNum0 woman) 2)


( = (candidatePatternMaker $db $dbSize $specialPattern $minSup)
    (if (evalCandidatePatterns $db $dbSize $specialPattern $minSup) $specialPattern (empty) )
)

( = (absSpeCan $db $dbSize $minSup) 
    ; a function that handles unique specializations + remove duplicates in one link + candidate patterns choosing.
    (let*
        (
            ($uniqueLink (abstractPattern $db $minSup) )
            ($debug (println! (----unique links are:- $uniqueLink)))
            ; ($debug1 (println! (uniqu_e link are:- $uniqueLink) ))
            ; get all specials since we are using branching we will have no duplicates on different links but we might have duplicates on same link so we use only_uniques function to handle that
            (($xx) (collapse (buildSpecialization $db (superpose $uniqueLink))))
            ; ($debug2 (println! (----xx----- $xx --------)))
            ($specials (eval (only_unique $xx)))
            ; ($debug3 (println! (----specials----- $specials --------)))
            ($candidates (collapse (candidatePatternMaker $db $dbSize (superpose $specials) $minSup))) ; find the candidate patterns
        )
        $candidates
    )
)
; !(absSpeCan &self (length (collapse (match &self $fullFact $fullFact))) 2)



; --------------------------------------------------------
;; frequency-pattern-miner
; ---------------------------------------------------------
;; function to mine the frequent patterns from the atomspace.
;; 1: get all abstract patterns with their support and store them in a space
;; 2: specialize the abstract patterns and store them in a space
;; 3: get all candidate patterns from the specialized patterns and store them in a space
;; 4: expand the conjunctions of the candidate patterns and store them in a space with their support
;; 5: format the patterns and add them to the knowledge base with their support

;(: frequency-pattern-miner (-> SpaceType SpaceType SpaceType SpaceType SpaceType Number Number Atoms))
(= (frequency-pattern-miner $db $conjSpace $minSup $depth)
   (let*(
        ($debug1 (println! "==== Frequent miner started ====="))
        ($everyThing (collapse (get-atoms $db)))
        ($dbSize (size-atom $everyThing))
        ($candidatePatterns (absSpeCan $db $dbSize $minSup))
        ($debug2 (println! (-------------------absSpeCanEnded-------------------------)))
        ($debug3 (println! (candid patterns are $candidatePatterns)))
        ($debruignIndexDepth (eval (fromNumber $depth)))
        ($conjs (eval (conjunct $db $candidatePatterns $minSup $debruignIndexDepth)))
        ($debug4 (println! (-----conjs:----------------------)))
        ($debug41 (println! (-- $conjs --)))
        ($debug412 (println! (-conjs- (size-atom $conjs )--)))
        ($debug42 (println! (-----conjs:----------------------)))
        ($uniqueConjs (eval (only_unique $conjs))) ;if we sort the conjunctions here we will have better results
        ($debug421 (println! (-uniqueConjs- (size-atom $uniqueConjs )--)))
        ($debug422 (println! (-----uniqueConjs:----------------------)))
        ($formatted (let $rawFormatted (eval (formatter $uniqueConjs $db $minSup)) (if (== () $rawFormatted) (empty) $rawFormatted)))
        ($debug5 (add-atom $conjSpace $formatted))  
        ($debug6 (println! (--formatted:- $formatted --)))
        )  (empty))
)

(= (expand_conjunction $conjunctVariables $conjunct $pattern $db $ms)
    (let*
        (
            ; ($debug3 (println! (duplicates check 1)))
            ($patVars (eval (getOrderlyVariables $pattern)))
            ; ($debug1 (println! (in expand conjunct_ with conjunct_:- $conjunct -> vars:- $conjunctVariables -> pattern:- $pattern patvars:- $patVars )))
            ($combo (eval (combine_list $conjunctVariables $patVars))) ;;to get unDeterministic combinations made via MeTTa
            ; ($combo (superpose (combine_lists $conjunctVariables $patVars)))

            ; ($debug2 (println! ("-"-"-"-"-"-"-"- after we called $conjunctVariables $patVars ---> combinations:- $combo)))
            ($npat (eval (replace_pattern $conjunct $pattern $combo)))
            ; ($debug3 (println! (duplicates check 2)))
            ; ($debug3 (println! ($conjunct --> $conjunctVariables --> $pattern --> (combo:- $combo) ( npat:- $npat))))
        )
        (eval (checker $db $npat $ms))
    )
)

;;;;;; substitute functions ;;;;;;
( = (substituteHelper $current ($Variables $newPattern) )
    (let 
      $currMetaType (if (== () $Variables) Symbol (get-metatype $current)) ;undermine the metatype of the current if we are run out of variables
      (if (== Expression $currMetaType)
        (let ($gotLeftVars $gotCorrectedExpression) (substituteMain $Variables $current) ($gotLeftVars (union-atom $newPattern ($gotCorrectedExpression))))
        (if (== Variable $currMetaType)
          (let ($headVariable $leftVariables) (decons-atom $Variables) ($leftVariables (union-atom $newPattern ($headVariable))))
          ($Variables (union-atom $newPattern ($current)))
        )
      )
    ) 
)
;; let the substituteMain function return ($LeftVariables (pattern made)) for a given expression (curr)
(= (substituteMain $variables $curr) (foldl-atom $curr ($variables ()) $acc $current (substituteHelper $current $acc) ))
( = (substitute $curr $variables) (let ($_ $answer) (substituteMain $variables $curr) $answer))
; !(substitute (name is $var1) ($yonas))

(= (replace_pattern $conjunct $pattern $pv2cv)
    (let* (
            ; ($debug1 (println! (in replace pattern function with conjunct:- $conjunct -> pattern:- $pattern -> pv2cv:- $pv2cv )))
            ($newPattern (substitute $pattern $pv2cv))
            ($formattedConjunct (cdr-atom $conjunct))
            ($new_conjunct (union-atom $conjunct ($newPattern)))
            ; ($debug2 (println! (return_ from replace pattern function with $new_conjunct)))
        )
        $new_conjunct
    )
)
; !(replace_pattern ((Hi This is $yonas)) (name is $var1) ($yonas))

( = (sup-evalCustom $db $pattern $ms)
    (let $pool (collapse (match $db $pattern $pattern)) 
        (>= (size-atom $pool) $ms))
)
; !(sup-evalCustom &self (Inheritance $var human) 112)


(= (checker $db $pattern $ms) 
   (let* (
        ; ($debug1 (println! (pattern $pattern -- checking support in checker function with params db:- $db -> ms:- $ms )))
        ($supEval (sup-evalCustom $db $pattern $ms))
        ; ($debug2 (println! (in check func got $supEval for pattern:- $pattern)))
        ) 
        (if $supEval $pattern (empty))
    )
)

; ------------------------------------------------
;; doConjunct
; ------------------------------------------------
;; function to expand the conjunctions of the patterns and create conjunctions of any amount of clauses

;; parameters:
;; $db: the database that is loaded and cleaned of the stdlib functions.
;; $candidatePatterns: the candidate patterns space
;; $conjunct: the conjunctions part of the pattern
;; $ms: minimum support
;; (S $K)/ Z: a debruijin index to check if we are in the last iteration of the recursion.

;steps:
;; 1: get the matches of the candidate patterns in the database
;; 2: expand the conjunctions with the matches and the database
;; 3: replace the variables with the debruijin index
;; 4: remove any redundant clauses from the conjunctions
;; 5: if we are in the last iteration of the recursion, return the conjunctions else call the function again with the new conjunctions and the debruijin index.

; returns:
; a superpose of conjunctions that satisfy the minimum support and are not redundant.
;(: doConjunct SpaceType SpaceType Pattern Number Nat Atom)
(= (doConjunct $db $candidatePatterns $conjunct $ms Z)
    (let* (
        ($debug1 (println! "==== Build conjunction with depth 0 ===="))
        ($conjunctVariables (eval (getOrderlyVariables $conjunct)))
        ($match (superpose $candidatePatterns))
        (True (== () (collapse (eval (is_member $conjunct $match))))) ;this will stop the thread if match Is not New in the conjuncts
        ($listConj (expand_conjunction $conjunctVariables $conjunct $match $db $ms))
        (True (sup-evalCustom $db $listConj $ms)) ;; the final conjunct will be filtered here ...
    )
    $listConj
    )
)

(= (doConjunct $db $candidatePatterns $conjunct $ms (S $K))
    (let* (
        ($debug1 (println! "==== Build conjunction with depth greater than 0 ====="))
        ($match (superpose $candidatePatterns))
        (True (== () (collapse (eval (is_member $conjunct $match))))) ;this will stop the thread if match Is not New in the conjuncts (repetition)
        ($conjunctVariables (eval (getOrderlyVariables $conjunct)))
        ($listConjs (collapse (expand_conjunction $conjunctVariables $conjunct $match $db $ms)))
        ($listConj (superpose $listConjs))
        (True (sup-evalCustom $db $listConj $ms)) ;; this will stop any unfinished conjunct that has lower support than the minimum support
        ($conj (doConjunct $db $candidatePatterns $listConj $ms $K))
    )
    $conj
    )
)

;; formatter
;; function to format the conjunctions by sorting them and checking their support ;; 
(= (formatter $conjs $db $minSup) 
    (let $conj (superpose $conjs) (if (eval (sup-eval $db $conj $minSup)) $conj (empty)))
)


; -----------------------------------------------
;; conjunct 
; -----------------------------------------------
;; function to extract candidate patterns and call doConjunct 
;(: conjunct (-> SpaceType SpaceType SpaceType Number Number Atom))
(= (conjunct $db $candidatePatterns $minSup $depth )   
    (collapse (let $conj (eval (doConjunct $db $candidatePatterns (, (superpose $candidatePatterns)) $minSup $depth)) (sort $conj))) 
)   
; !(conjunct &self ((Inheritance Allen $_89484) (Inheritance $_89454 human) (Inheritance $_89430 $_89436) (Inheritance Abe $_89412) (Inheritance Cason $_89388) (Inheritance Davion $_89364) (Inheritance Hessley $_89340) (Inheritance Jadrian $_89316) (Inheritance Rio $_89292) (Inheritance Bob $_89268) (Inheritance Mike $_89244) (Inheritance Zac $_89220) (Inheritance Lily $_89196) (Inheritance Emily $_89172) (Inheritance Lucy $_89148) (Inheritance Sophia $_89124) (Inheritance Alaura $_89100) (Inheritance Breonna $_89076) (Inheritance Jaleesa $_89052) (Inheritance Jassy $_89028) (Inheritance Jenica $_89004) (Inheritance Kecia $_88980) (Inheritance $_88950 man) (Inheritance $_88926 woman) (Inheritance $_88902 ugly) (Inheritance $_88878 sodaDrinker)) f 2 (S Z))

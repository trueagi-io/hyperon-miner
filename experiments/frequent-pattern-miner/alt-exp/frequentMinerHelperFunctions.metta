; ------------------------------------------------------------------------------------------------------;
; function name:- evalLink
;; a function that will check whether a given link has a support or not
; parameters:- SpaceType, link, minSupport
; return:- Boolean
; method:- check if the support of the link in the given space is greater than or equal to the minimum support
(= (evalLink $dbspace $link $minSup)
    (let $supports 
        (collapse 
            (let* 
                (
                    ($matches (match $dbspace $fullData $fullData))
                    (($link $concept) (decons-atom $matches))
                ) 1
            )
        )
        (>= (size-atom $supports) $minSup)
    )
)
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
; function name:- sup-eval
; parameters:- SpaceType, pattern, minSupport
; return:- Boolean
; method:- match the pattern in the given space and ensure its support meets the minimum threshold
( = (sup-eval $db $pattern $minSup) 
    (let $matches (collapse (match $db $pattern $pattern)) 
        (>= (size-atom $matches) $minSup)
    )
)
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
; function name:- is_member
; parameters:- accumulator, atom
; return:- Boolean
; method:- compare the atom against each element of the accumulator using alpha-equality
( = (is_member $acc $x) 
    (let $curr (superpose $acc)
            (if (=alpha $curr $x) True Empty)
    )
)
; !(== () (collapse (is_member ((hi this is a test) (1 hello world) (foo bar)) (hello world))))
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
; function name:- giveMeUniqueAcc
; parameters:- accumulator, atom
; return:- accumulator
; method:- append the atom only when it is not already present in the accumulator
( = (giveMeUniqueAcc $acc $x) 
    (if (== () (collapse (is_member $acc $x)))
            (union-atom $acc ($x))
            $acc
    )
)
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
; function name:- only_unique
; parameters:- list of atoms
; return:- list of atoms
; method:- fold the list with giveMeUniqueAcc to remove duplicates
( = (only_unique $specials) 
    (let $x ( foldl-atom $specials () $acc $x (giveMeUniqueAcc $acc $x) ) $x )
)
; !(only_unique ((Inheritance $varNum0 woman) (Inheritance $varNum0 $varNum1) (Inheritance Lucy woman) (Inheritance Lucy $varNum1) (Inheritance $varNum0 woman) (Inheritance $varNum0 $varNum1) (Inheritance Emily woman) (Inheritance Emily $varNum1) (Inheritance $varNum0 human) (Inheritance $varNum0 $varNum1) (Inheritance Cason human) (Inheritance Cason $varNum1) (Inheritance $varNum0 man) (Inheritance $varNum0 $varNum1) (Inheritance Cason man) (Inheritance Cason $varNum1) (Inheritance $varNum0 ugly) (Inheritance $varNum0 $varNum1) (Inheritance Cason ugly) (Inheritance Cason $varNum1) (Inheritance $varNum0 sodaDrinker) (Inheritance $varNum0 $varNum1) (Inheritance Cason sodaDrinker) (Inheritance Cason $varNum1) (Inheritance $varNum0 ugly) (Inheritance $varNum0 $varNum1) (Inheritance Lily ugly) (Inheritance Lily $varNum1) (Inheritance $varNum0 sodaDrinker) (Inheritance $varNum0 $varNum1) (Inheritance Lily sodaDrinker) (Inheritance Lily $varNum1) (Inheritance $varNum0 human) (Inheritance $varNum0 $varNum1) (Inheritance Abe human) (Inheritance Abe $varNum1) (Inheritance $varNum0 man) (Inheritance $varNum0 $varNum1) (Inheritance Abe man) (Inheritance Abe $varNum1) (Inheritance $varNum0 ugly) (Inheritance $varNum0 $varNum1) (Inheritance Abe ugly) (Inheritance Abe $varNum1) (Inheritance $varNum0 sodaDrinker) (Inheritance $varNum0 $varNum1) (Inheritance Abe sodaDrinker) (Inheritance Abe $varNum1) (Inheritance $varNum0 human) (Inheritance $varNum0 $varNum1) (Inheritance Allen human) (Inheritance Allen $varNum1) (Inheritance $varNum0 man) (Inheritance $varNum0 $varNum1) (Inheritance Allen man) (Inheritance Allen $varNum1) (Inheritance $varNum0 ugly) (Inheritance $varNum0 $varNum1) (Inheritance Allen ugly) (Inheritance Allen $varNum1) (Inheritance $varNum0 sodaDrinker) (Inheritance $varNum0 $varNum1) (Inheritance Allen sodaDrinker) (Inheritance Allen $varNum1)))
; ------------------------------------------------------------------------------------------------------;



; ------------------------------------------------------------------------------------------------------;
; function name:- myFlatten
; parameters:- expression
; return:- expression
; method:- perform a left fold that unions nested elements into a single flat list
(= (myFlatten $expr)
    (foldl-atom $expr () $acc $x (eval (union-atom $acc $x))))
; ------------------------------------------------------------------------------------------------------ ;


; ------------------------------------------------------------------------------------------------------;
;; make_var1
;; Description:
;;   Construct and execute a dynamic expression by formatting the two inputs and performing a double parse/eval cycle.
;;   The function formats $x and $y into the template "${}{}", converts that formatted value to a string representation,
;;   parses and evaluates it, then parses and evaluates the result again and returns the final value.
;; Parameters:
;;   $x  - First value or expression to be inserted into the format template. It will be evaluated as part of the procedure.
;;   $y  - Second value or expression to be inserted into the format template. It will be evaluated as part of the procedure.
;; Returns:
;;   variable :- $(first argument)(second argument)

( = (make_var1 $x $y) 
    (function
        (chain (eval (format-args "${}{}" ($x $y))) $formatted
            (chain (eval (repr $formatted)) $strFormat
                (chain (eval (parse $strFormat)) $onceParsed (return (eval (parse $onceParsed))) )))
    )
)
;!(make_var1 variableName 23)  
; ------------------------------------------------------------------------------------------------------;

; ------------------------------------------------------------------------------------------------------;
( = (variableExtractor $input)
    (let $inputMetaType (get-metatype $input)
        (if (== $inputMetaType Expression)
            (let $current (superpose $input) (variableExtractor $current) )
            (if (== $inputMetaType Variable)
                $input
                Empty            
            )
        )
    )
)
; !(variableExtractor (tru age is $never told (to someone $tru) (($ret $wr sdf (sdf $r)))))
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
;; variable extractor if the order of the variables matter
( = (getOrderlyVariablesHelper $curr $store)
  (let*
    (
      ($currMetaType (get-metatype $curr))

    )
    (if (== Expression $currMetaType)
      (let $currAnswer (getOrderlyVariables $curr) (union-atom $store $currAnswer))
      (if (== Variable $currMetaType) (union-atom $store ($curr)) $store)
    )

  )
) 

( = (getOrderlyVariables $pattern) 
  (foldl-atom $pattern () $store $curr (getOrderlyVariablesHelper $curr $store))
)
; !(getOrderlyVariables (hi $var1 (((var var ($asdfjkgs ($asfgkb $ask awrjk) $wert $wertr ser) gw ert) weg) wet) wetr $var2) )
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
; Check if a variable is in a list
(= (is-var-in-list $var $list) 
    (not (== () (collapse ( if (== (superpose $list) $var) 1 Empty ))))
)
; !(is-var-in-list $tr ( hi aha a $etr))
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
( = (uniteVariables $vars1 $vars2)
    (foldl-atom $vars2 $vars1 $acc $x (if (is-var-in-list $x $acc) $acc (union-atom $acc ($x)) ))
)
; !(uniteVariables ($A $B $C) ($B $D $E))
; ------------------------------------------------------------------------------------------------------;


; ------------------------------------------------------------------------------------------------------;
( = (uniqueVars $variables) 
    (uniteVariables () $variables)
)
; !(uniqueVars ($a $b $c $a $d $e $b))
; ------------------------------------------------------------------------------------------------------;



; Check if a variable is in a list
(= (is-var-in-list $var $list) (not (== () (collapse ( if (== (superpose $list) $var) 1 Empty )))))

; Check if variables from one list exist in another list
(= (vars-exist $list1 $list2) 
    (not (== () (collapse (let $equality (== (superpose $list1) (superpose $list2))
        (if $equality True Empty)
    ))))
)
; !(vars-exist ($varNum0) ($varNum0))

(= (combiner-pat1-pat2 $vars () $accum) $accum)
(= (combiner-pat1-pat2 $vars $pat2 $accum)
    (let ($head $tail) (decons-atom $pat2)
        (superpose (
            (combiner-pat1-pat2 $vars $tail (union-atom $accum ($head)))  ;; Option 1: keep the slot
            (let $var (superpose $vars) (if (== $var $head) Empty (combiner-pat1-pat2 $vars $tail (union-atom $accum ($var))))) ;; Option 2: replace with each var but avoid redundancy that might come
                    )
        )
    )
)

; Get filtered combinations of variables
(= (combine_list $vars1 $vars2) 
    (let* (
        ($combinations (combiner-pat1-pat2 $vars1 $vars2 ()))
        (() (println! (from (vars1:- $vars1) (vars2:- $vars2) (combinations:- $combinations))))
        ($boolGot (vars-exist $combinations $vars1))
        (() (println! (do $combinations exist in vars1:- $boolGot)))
        ($vars1-check (if $boolGot $combinations Empty))
        (() (println! ($combinations exist in vars1:- $vars1-check)))
    ) $combinations
    )
)
; !(combine_list ($a $b $c) ($1 $2 $3))
; !(combine_list ($varNum0) ($varNum0))

( = (sup-evalCustom $db $pattern $ms)
    (let $pool (collapse (match $db $pattern 1)) 
        (>= (size-atom $pool) $ms))
)


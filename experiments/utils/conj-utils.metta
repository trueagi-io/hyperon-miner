;; get-variables function is a function that we use to extract variables from a given patterns (expressions with variables)
;; get-variables helps as an interface for variable-extractor , which is the main function that extracts the variables
;; example:- (get-variables (this is the pattern i am talking about its name is $name and author is $authorName))
;; the above function will call (variable-extractor this (is the pattern i am talking about its name is $name and author is $authorName) ())
;; and finally this will return ($name $authorName) 

( = (variable-extractor $head () $answer)  
    (if (== (get-metatype $head) Variable)
        ( union-atom $answer ($head))
        (if (== (get-metatype $head) Expression)
            (variable-extractor (car-atom $head) (cdr-atom $head) $answer )    
            $answer
        ) 
    )
)
( = (variable-extractor $head $tail $answer) 
    (
        if (== (get-metatype $head) Variable)
            (variable-extractor (decons-atom $tail) ( union-atom $answer ($head) ) )
            (
                if (== (get-metatype $head) Expression)
                    ( 
                        let* 
                            ( 
                                ;;;;; get all variables from this expression as well as post expression variables
                                ($var1 (variable-extractor (decons-atom $head) () ) )
                                ($var2 (variable-extractor (decons-atom $tail) () ) )
                                )

                            (   ;;;; merge all variables u have got so far
                                let 
                                    $first_unity (union-atom $answer $var1)
                                    (union-atom $first_unity $var2)
                            )
                            
                        
                    )
                    ( variable-extractor (decons-atom $tail) $answer )          
            )
    )
)

( = (get-variables $var) (variable-extractor (decons-atom $var) () ) )
;test 
!( get-variables (Inheritance $new  $hi))



;;;;;; depth generator ;;;;;; 
;; input: 3
;; output: (S (S (S ())))
  
( = (generateDepth $size) 
    (
        if (== $size 0)
            ()
            (S (generateDepth (- $size 1)))
    )
) 


; function name:- does-exist
;;;;; checks membership of something in a given set of things
;; input: 2-params
  ;; 1st:- $name
  ;; 2nd:- ($var1 $name $var2 $authorName)
;; output: True ;since $name is found in 2nd Parameter
; method:- compare the atom against each element of the accumulator using alpha-equality
( = (does-exist $x $acc) 
    (let $ans (collapse (
        let $curr (superpose $acc)
            (if (=alpha $curr $x) True Empty)
    )) (not (== $ans ())))
)
; !(does-exist 34 (3 34 34 4))

;;;;;; checker checks whether the combo given has at-least one element from set of variables of pattern 1, return (empty) if not
;; input: 3-params
  ;; 1st:- ($name $var1)
  ;; 2nd:- ($var1 $var2 $authorName)
;; output: 1st parameter ;since $var1 is found in 2nd Parameter
;; we have superposed over the list of combinations so for invalid combos (empty) will close the branch which is made by superpose

( = (checker $combo $var1)
    (if (== () (collapse (let $equality (== (superpose $combo) (superpose $var1))
        (if $equality True Empty)
    ))) Empty $combo)
)  


;;;; combination maker ;;;;
;; input: 6-params
  ;; 1st:- ()
  ;; 2nd:- (($a 1 pat1) ($1 1 pat2) ($2 2 pat2) ($3 3 pat2)) ;; ($a 1 pat1) means $a whose index is 1 is from pattern1 ....
  ;; 3rd:- (S (S ()))
  ;; 4th:- 0 ;pointer 1, this shows the recent value ,from patter1 , that we use for this particular combination
  ;; 5th:- 0 ;pointer 2, this shows the recent value ,from patter2 , that we use for this particular combination
  ;; 6th:- 1 ; this shows how much i have in specific combination, till now.
;; in the process any combinations with un-ordered or repeated variables will be pre killed since we got (empty) for such cases
;; output: (($2 $a $3) ($2 $3 $a) ($1 $a $3) ($1 $a $2) ($1 $2 $a) ($1 $3 $a) ($a $1 $3) ($a $1 $2) ($a $2 $3)) 

( = (combiner $accumulated $vars () $p1 $p2 $comboCount) $accumulated )
;;;;; makes combinations by pre-killing what is going to make repetition or what is un-ordered
( = (combiner $accumulated $vars (S $depth) $pointer1 $pointer2 $comboCount) 
    (
        let*
            (
                (($randomVar $index $patName) (superpose $vars))
                ($shouldBePreKilled  
                    (
                        if (== $patName pat1)
                            ( >= $pointer1 $index)
                            (or (>= $pointer2 $index) (not (== $index $comboCount)) )  
                    ) 
                )
                ($joiner (union-atom $accumulated ($randomVar) ) ) 
            )
            (
                if $shouldBePreKilled
                    (empty)
                    (
                        if (== $patName pat1) 
                            (combiner $joiner $vars $depth $index $pointer2 (+ 1 $comboCount))
                            (combiner $joiner $vars $depth $pointer1 $index (+ 1 $comboCount))
                    )
            ) 
    )
)


;;;;; variable formatter ;;;;;;;
;; Formats a flat list of variables into indexed tuples tagged with pattern name.
;; helper_:
;;  - input: 3 params
;;      1st: $current      ; a single variable (e.g. $a)
;;      2nd: ($index $stored) ; a pair where $index is the next index to assign, $stored is accumulated result
;;      3rd: $patName      ; pattern name to tag the variable with (e.g. pat1)
;;  - output: a pair ((+ $index 1) $newStored)
;;      where $newStored is $stored unioned with the formatted entry ($current $index $patName)
;; formatter:
;;  - input: 2 params
;;      1st: $vars    ; list of variables to format (e.g. ($a $b))
;;      2nd: $patName ; pattern name to attach to each formatted variable
;;  - behavior: folds over $vars starting index 1, producing a list of tuples of the form ($var <index> <patName>)
;;  - output example: (($a 1 pat1) ($b 2 pat1))
( = (helper_ $current ($index $stored) $patName)
    ( let $formattedCurrent (($current $index $patName)) ((+ $index 1) (union-atom $stored $formattedCurrent)))
)

( = (formatter $vars $patName)
    (let ($_ $ans) (foldl-atom $vars (1 ()) $acc $current (helper_ $current $acc $patName)) $ans )
)
; !(formatter ($1 $2 $3) pat1)



; !(help!)

;;;;; all-variable-combination --the main function ;;;;;;;;;;
;; input: 2-params
  ;; 1st:- ($a $b)
  ;; 2nd:- ($1 $2) 
;; the output will follow the following rules
  ;; at-least 1 variable from pattern1 must appear in the combination
  ;; the combination sizes should be equal to the size of pattern2's variable size
  ;; the order of variables should be maintained with respect to their pattern Name Type ;; i.e we can't say ($b $a) but we can say ($b $1)
;; output: (($2 $a) ($2 $b) ($1 $a) ($1 $b) ($b $1) ($b $2) ($a $b) ($a $1) ($a $2)) 

( = (all-variable-combination $pattern1 $pattern2)
    (
        let*
            (
                ($varsInPat1 (get-variables $pattern1))
                ($varsInPat2 (get-variables $pattern2)) 

                (($first $second) (collapse (superpose ((formatter $varsInPat1 pat1) (formatter $varsInPat2 pat2)) )))
                
                ($joiner (union-atom $first $second))

                (() (println! (--- $joiner --- )))
                
                ($width (size-atom $varsInPat2)) 
                ($unpurifiedAllCombinations (collapse (combiner () $joiner (generateDepth $width) 0 0 1)) )   
                (() (println! (--- $unpurifiedAllCombinations --- )))
            )
            
            ( let $var1Exist (collapse (checker (superpose $unpurifiedAllCombinations) $varsInPat1)) $var1Exist )   
    )
)

;test by running this 
; !(all-variable-combination (hi this is $a) (i am $1 years $2 $3 living in city) ) 


;; 1st:- ($a $b)
;; 2nd:- ($1 $2) 
;; ;; ;; --> ;; (sup ($a $b $1)) , (sup ($a $b $2))
;; ;; ;; --> ;; [$a , $a]
;; ;; ;; --> ;; [$a , $b]
;; ;; ;; --> ;; [$a , $2]

;; ;; ;; --> ;; [$b , $a]
;; ;; ;; --> ;; [$b , $b]
;; ;; ;; --> ;; [$b , $2]

;; ;; ;; --> ;; [$1 , $a]
;; ;; ;; --> ;; [$1 , $b]






;;;;;;;;;;;;;;; words sorting in MeTTa ;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;; create new space and store letters with their index on it ;;;;;
!(bind! &newSpace (new-space))
!(add-reducts &newSpace (
   ('!' 1) ('@' 2) ('#' 3) ('$' 4) ('^' 6) ('&' 7) ('-' 9) ('_' 10) ('|' 17) (':' 19) ('"' 20) (',' 23) ('.' 24) ('?' 26) ('~' 27) 
   ('A' 28) ('B' 29) ('C' 30) ('D' 31) ('E' 32) ('F' 33) ('G' 34) ('H' 35) ('I' 36) ('J' 37) ('K' 38) ('L' 39) ('M' 40) ('N' 41) 
   ('O' 42) ('P' 43) ('Q' 44) ('R' 45) ('S' 46) ('T' 47) ('U' 48) ('V' 49) ('W' 50) ('X' 51) ('Y' 52) ('Z' 53)
   ('a' 54) ('b' 55) ('c' 56) ('d' 57) ('e' 58) ('f' 59) ('g' 60) ('h' 61) ('i' 62) ('j' 63) ('k' 64) ('l' 65) ('m' 66) ('n' 67) 
   ('o' 68) ('p' 69) ('q' 70) ('r' 71) ('s' 72) ('t' 73) ('u' 74) ('v' 75) ('w' 76) ('x' 77) ('y' 78) ('z' 79)
))

;;;; get value for a character ;;;;;
( = (get-value $char) 0)
( = (get-value $char) (match &newSpace ($char $num) $num))

( = (get-value-of $char) 
    ( let $ans (collapse (get-value $char))
        ( if (== 2 (size-atom $ans)) (max-atom $ans) (car-atom $ans) )
    )
)


;;;;; separate function ;;;;;
;; input: 4-parameter
    ;; 1st-param: ($a $b $c $d) ;; 2nd-param: 2  ; mid-number 
    ;; 3rd-param: () ; accumulator ;; 4th-param: 0  ; how many elements is there in 3rd param
;; output: ( ($a $b) ($c $d) )
( = (separate $given $mid $acc $curr)
    (
        if (== $curr $mid)
            ($acc $given)
            ( let ($top $tail) (decons-atom $given) ( separate $tail $mid (union-atom $acc ($top)) (+ $curr 1) ) )
    )
) 

;;;; slice to half function
;; interface to separate function accepts list of variables and returns what we got from separate function
;; input: ($a $b $x $y) 
;; output: (separate ($a $b $x $y) 2 () 0)
( = (sliceToHalf $given)
    (
        let*
            (
                ($size (size-atom $given))
                ($mid (+ (/ $size 2) (% $size 2)))
            )
            (separate $given $mid () 0)
    )
)

;;;; who is first function ;;;;;;
;; compares whether 2 words and compare which one comes first in alphabetical order 
;; input: 2 params
    ;; 1st-param: ('z' 'e' 'b' 'r' 'a') ;; 2nd-param: ('a' 'p' 'p' 'l' 'e')
;; output: second ;; since apple comes before zebra alphabetically 
( = (whoIsFirst $word1 $word2) ;handle first incase they are equal
    (
        if (or (== $word1 ()) (== $word2 ()))
            (if (== $word1 ()) first second)
            (
                let*
                    (   
                        (($firstLetter1 $restLetter1) (decons-atom $word1))
                        (($firstLetter2 $restLetter2) (decons-atom $word2))  
                        ($currentLetterNumber1 (get-value-of $firstLetter1))
                        ($currentLetterNumber2 (get-value-of $firstLetter2)) 
                    )
                    (
                        if (< $currentLetterNumber1 $currentLetterNumber2)
                            first
                            (
                                if (> $currentLetterNumber1 $currentLetterNumber2)
                                    second
                                    (whoIsFirst $restLetter1 $restLetter2)
                            )
                    )
            )
        
    )
)
 
;;;; merge function ;;;;
;; get 2 sorted expressions and return 1 sorted expression (by merging the two)
;; input: 3 parameters
    ;; 1st-param: ( ('a' 'b' 'a' 'y') ('r' 'i' 'v' 'e' 'r')) ;; 2nd-param: ( ('b' 'r' 'i' 'd' 'g' 'e') ('d' 'a' 'm')) ;; 3rd-param: () ;answer storage
;; output: ( ('a' 'b' 'a' 'y') ('b' 'r' 'i' 'd' 'g' 'e') ('d' 'a' 'm') ('r' 'i' 'v' 'e' 'r') )
( = (merge $left $right $store)
    (  
        if (or (== (size-atom $left) 0) (== (size-atom $right) 0))
            (
                if (== (size-atom $left) 0)
                    (union-atom $store $right) 
                    (union-atom $store $left)  
            )
            (let*
                ( 
                    (($leftCurr $leftLeft)  (decons-atom $left))
                    (($rightCurr $rightRight) (decons-atom $right)) 
                    ($sameWord (noreduce-eq $leftCurr $rightCurr))  
                )
                ( 
                    if $sameWord
                        ( let $joint (union-atom ($leftCurr) ($rightCurr)) (merge $leftLeft $rightRight (union-atom $store $joint)) )
                        (
                            if (== (whoIsFirst $leftCurr $rightCurr) first) 
                                (merge $leftLeft $right (union-atom $store ($leftCurr))) 
                                (merge $left $rightRight (union-atom $store ($rightCurr))) 
                        )
                )
            )
    )
)


;;;; merge-sort function ;;;;
;; accepts one expression and sorts it
;; input: ( ('b' 'r' 'i' 'd' 'g' 'e') ('a' 'b' 'a' 'y')  ('r' 'i' 'v' 'e' 'r') ('d' 'a' 'm') )
;; output: ( ('a' 'b' 'a' 'y') ('b' 'r' 'i' 'd' 'g' 'e') ('d' 'a' 'm') ('r' 'i' 'v' 'e' 'r') ) ;; by splitting , sorting and merging recursively
( = (merge_sort $toBeSorted)
    (
        if (> 2 (size-atom $toBeSorted))
            $toBeSorted
            (let*
                (
                    ($sliced (sliceToHalf $toBeSorted))
                    ($leftPart (car-atom $sliced))
                    ($right (cdr-atom $sliced))
                    ($rightPart (car-atom $right))   

                    ; ($sortedLeft (merge_sort $leftPart))
                    ; ($sortedRight (merge_sort $rightPart)) 
                    (($sortedLeft $sortedRight) (collapse (superpose ( (merge_sort $leftPart) (merge_sort $rightPart) ))))

                    ($answer (merge $sortedLeft $sortedRight ()))

                )
                $answer 
            )
    )
)
 

;;;; chars To Atom Converter ;;;;
;; input: 2 parameters
    ;; 1st-param: ( ('a' 'b' 'a' 'y') ('b' 'r' 'i' 'd' 'g' 'e') ('d' 'a' 'm') ('r' 'i' 'v' 'e' 'r') ) ;; 2nd-param: ()
;; output: (abay bridge dam river)
( = (to-Atom $word $finalAnswer) 
    (
        if (== $word ())
            $finalAnswer
            (
                let*
                    ( 
                        (($head $tail) (decons-atom $word))
                        ($parsedHead ((parse (charsToString $head))))
                        ($ansJoin (union-atom $finalAnswer $parsedHead))
                    )
                    (to-Atom $tail $ansJoin)
            )
    )
)

;;;; explode function ;;;;
;; input: abay
;; output: ('a' 'b' 'a 'y)
( = (explode $word) (stringToChars (repr $word) ) )

;;;; sort function ;;;;
;; input: (abay is the longest river)
;; output: (abay is longest river the)
( = (sort $toBeSorted)
    (
        let*
            (
                ($explodedWords (collapse (explode (superpose $toBeSorted))))
                ($sortedWords (merge_sort $explodedWords)) 
            )
            (to-Atom $sortedWords ())
    )
)

;test be running this !(sort (hey i am Yonas Student))   

; Name: is-var-in-list
; Purpose: Checks if a variable is present in a list.
; Input: $var (variable), $list (list)
; Output: True if $var is in $list, else False
(= (is-var-in-list $var $list) (if (== $list ()) False (let $head (car-atom $list) (if (== $var $head) True (is-var-in-list $var (cdr-atom $list))))))

; Name: vars-exist
; Purpose: Checks if any variable from list1 exists in list2.
; Input: $list1, $list2 (lists)
; Output: True if any element of $list1 is in $list2, else False
(= (vars-exist $list1 $list2) (if (== $list1 ()) False (let $head (car-atom $list1) (if (is-var-in-list $head $list2) True (vars-exist (cdr-atom $list1) $list2)))))

; Name: is_member
; Purpose: Checks if an atom is present in an accumulator using alpha equality.
; Input: $acc (accumulator), $x (atom)
; Output: True if $x is in $acc, else empty
( = (is_member $acc $x) 
    (let $curr (superpose $acc)
        (if (=alpha $curr $x) True (empty))
    )
)

; Name: is-member-custom
; Purpose: Recursively checks if an atom is present in a list using alpha equality.
; Input: $x (atom), $acc (list)
; Output: True if $x is in $acc, else False
(= (is-member-custom $x $acc) 
    (if (== () $acc) False
        (let ($head $tail) (decons-atom $acc)
            (if (=alpha $head $x) True (is-member-custom $x $tail))
        )
    )
)

; Name: fromNumber
; Purpose: Converts a number to PeTTa's successor form.
; Input: $n (number)
; Output: Successor form (S ... S Z)
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

; Name: count
; Purpose: Counts occurrences of an atom in a list.
; Input: $atom, $list
; Output: Number of times $atom appears in $list
(= (count $atom $list)
   (foldl-atom $list 0 $acc $x (eval (if (== $atom $x) (+ $acc 1) $acc))))

; Name: evalLinkHelper
; Purpose: Adds a link to accumulator if its support meets minSup.
; Input: $links (list), $minSup (number), $acc (accumulator), $link (atom)
; Output: Updated accumulator
( = (evalLinkHelper $links $minSup $acc $link) 
    (if (>= (count $link $links) $minSup) (union-atom $acc ($link)) $acc );check support and add if it meets minSup
)


; Name: evalLink
; Purpose: Filters links by minimum support.
; Input: $links (list), $minSup (number)
; Output: List of links meeting minSup
(= (evalLink $links $minSup)
    (let $uniLinks (unique-atom $links)
        (foldl-atom $uniLinks () $acc $link 
            (evalLinkHelper $links $minSup $acc $link))
    )
)

; Name: sup-eval
; Purpose: Checks if a pattern has enough support in the database.
; Input: $db (database), $pattern, $minSup (number)
; Output: True if support >= minSup, else False
( = (sup-eval $db $pattern $minSup) 
    (let $matches (collapse (match $db $pattern 1)) 
        (>= (size-atom $matches) $minSup)
    )
)

; Name: giveMeUniqueAcc
; Purpose: Adds an atom to accumulator only if not present.
; Input: $x (atom), $acc (accumulator)
; Output: Updated accumulator
( = (giveMeUniqueAcc $x $acc) 
    (if (is-member-custom $x $acc)
        $acc
        (union-atom $acc ($x))
    )
)

; Name: only_unique
; Purpose: Removes duplicates from a list.
; Input: $specials (list)
; Output: List with unique elements
( = (only_unique $specials) 
    (foldl-atom $specials () $acc $x (giveMeUniqueAcc $x $acc))
)
; !(let $conj (only_unique ((, (Inheritance Allen $_74568) (Inheritance Abe $_74568)) (, (Inheritance Allen $_74508) (Inheritance Cason $_74508)) (, (Inheritance $_74442 sodaDrinker) (Inheritance $_74442 ugly)) (, (Inheritance $_74382 sodaDrinker) (Inheritance $_74382 human)) (, (Inheritance Abe $_74328) (Inheritance Allen $_74328)) (, (Inheritance Abe $_74268) (Inheritance Cason $_74268)) (, (Inheritance Cason $_74208) (Inheritance Allen $_74208)) (, (Inheritance Cason $_74148) (Inheritance Abe $_74148)) (, (Inheritance $_74082 ugly) (Inheritance $_74082 sodaDrinker)) (, (Inheritance $_74022 ugly) (Inheritance $_74022 human)) (, (Inheritance $_73962 human) (Inheritance $_73962 sodaDrinker)) (, (Inheritance $_73902 human) (Inheritance $_73902 ugly)))) (superpose $conj))

; Name: myFlatten
; Purpose: Flattens nested expressions into a single-level list.
; Input: $expr (expression)
; Output: Flattened list
(= (myFlatten $expr)
    (foldl-atom $expr () $acc $x (eval (union-atom $acc $x))))
    

; Name: make_var1
; Purpose: Returns a placeholder variable.
; Input: None
; Output: $doesNotMatter (placeholder)
( = (make_var1) 
    $doesNotMatter
)


; Name: variableExtractor
; Purpose: Extracts variables from an input expression or variable.
; Input: $input (expression or variable)
; Output: Variable or empty
( = (variableExtractor $input)
    (let $inputMetaType (get-metatype $input)
        (if (== $inputMetaType Expression)
            (let $current (superpose $input) (variableExtractor $current) )
            (if (== $inputMetaType Variable)
                $input
                (empty)            
            )
        )
    )
)

; Name: getOrderlyVariablesHelper
; Purpose: Collects variables from an atom or expression into a store.
; Input: $curr (atom/expression), $store (accumulator)
; Output: Updated store with variables
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

; Name: getOrderlyVariables
; Purpose: Returns all variables in a pattern in order.
; Input: $pattern (expression)
; Output: List of variables
( = (getOrderlyVariables $pattern) 
  (foldl-atom $pattern () $store $curr (getOrderlyVariablesHelper $curr $store))
)


; Name: uniteVariables
; Purpose: Merges two variable lists, removing duplicates.
; Input: $vars1, $vars2 (lists)
; Output: Merged list with unique variables
( = (uniteVariables $vars1 $vars2)
    (foldl-atom $vars2 $vars1 $acc $x (if (is-var-in-list $x $acc) $acc (union-atom $acc ($x)) ))
)

; Name: uniqueVars
; Purpose: Returns unique variables from a list.
; Input: $variables (list)
; Output: List of unique variables
( = (uniqueVars $variables) 
    (uniteVariables () $variables)
)

; Name: is-var-in-list-Superpose
; Purpose: Checks if a variable is present in a list using superpose and collapse.
; Input: $var, $list
; Output: True if present, else False
(= (is-var-in-list-Superpose $var $list) (not (== () (collapse ( if (== (superpose $list) $var) 1 (empty) )))))


; Name: vars-exist-Superpose
; Purpose: Checks if two lists are equal using superpose and collapse.
; Input: $list1, $list2
; Output: True if equal, else False
(= (vars-exist-Superpose $list1 $list2) 
    (not (== () (collapse (let $equality (== (superpose $list1) (superpose $list2))
        (if $equality True (empty))
    ))))
)



; Name: combiner-pat1-pat2
; Purpose: Combines variables from two patterns, avoiding redundancy.
; Input: $vars (list), $pat2 (list), $accum (accumulator)
; Output: Combined list
(= (combiner-pat1-pat2 $vars () $accum) $accum)
(= (combiner-pat1-pat2 $vars $pat2 $accum)
    (let ($head $tail) (eval (decons-atom $pat2))
        (superpose (
            (combiner-pat1-pat2 $vars $tail (union-atom $accum ($head)))
            (let $var (superpose $vars) (if (== $var $head) (empty) (combiner-pat1-pat2 $vars $tail (union-atom $accum ($var))))) ;; Option 2: replace with each var but avoid redundancy that might come
                    )
        )
    )
)
; !(combiner-pat1-pat2 ($var1) ($var1) ())


; Name: combine_list
; Purpose: Combines two variable lists and checks for existence.
; Input: $vars1, $vars2 (lists)
; Output: Combined list
(= (combine_list $vars1 $vars2)   
    (let* (  
        ($combinations (eval (combiner-pat1-pat2 $vars1 $vars2 ())))  
        ($boolGot (vars-exist $combinations $vars1))  
        ($vars1-check (if $boolGot $combinations (empty)))  
    ) $combinations  
    )  
)
; !(combine_list ($var1 $var3) ($var2))


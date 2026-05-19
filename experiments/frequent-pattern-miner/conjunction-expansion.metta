; /**
 ;  * Given cnjtion and pattern, consider all possible connections
 ;  * (a.k.a linkages) and expand cnjtion accordingly. For instance if
 ;  *
 ;  * cnjtion = (Inheritance X Y)
 ;  * pattern = (Inheritance Z W)
 ;  *
 ;  * return
 ;  *
 ;  *   (, (Inheritance X Y) (Inheritance X W))
 ;  *   (, (Inheritance X Y) (Inheritance Z X))
 ;  *   (, (Inheritance X Y) (Inheritance Y W))
 ;  *   (, (Inheritance X Y) (Inheritance Z Y))
 ;  *
 ;  * It will also only include patterns with minimum support ms
 ;  * according to db, and perform alpha-conversion when necessary.
 ;  *
 ;  * mv is the maximum number of variables allowed in the resulting
 ;  *    patterns.
 ;  *
 ;  */


 ; The starting point for the conjunction expansion. It passes
 ; the Alpha Converted pattern (if necessary) to the expand_conjunction functions.
 ; if it passes the minimum variable check

(= (expand_conjunction $cnjtion $pattern $db $ms $ac)
    (if $ac
        (let* (
            ($cnjtion_vars (get_variables_for_tree $cnjtion))
            (($apattern $pattern_vars) (alpha_convert $pattern $cnjtion_vars))
        )
        (expand_conjunction_rec $cnjtion $apattern $cnjtion_vars $pattern_vars $db $ms)
        )
        (expand_conjunction_rec $cnjtion $pattern (get_variables_for_tree $cnjtion) (get_variables_for_tree $pattern) $db $ms)
    )
)

 
;; ==============  alpha convert  =======================

(= (gen_vars)
   $x
)


(= (find_value $keys $vals $var)
    (if (or (== $keys ()) (== $vals ()))
        ()
    (let* (
        ($key (car-atom $keys))
        ($val (car-atom $vals))
        ($keytail (cdr-atom $keys))
        ($valtail (cdr-atom $vals))
        ($res (if (== $key $var) $val (find_value $keytail $valtail $var)))
    )
    $res
    ))
)

(= (address_conflict $pattern $cnjtion_vars $seen_keys $seen_vals $pattern_vars)
   (if (== $pattern ())
       (() $seen_keys $seen_vals $pattern_vars) 
       (let* (
           ($head (car-atom $pattern))
           ($tail (cdr-atom $pattern))
           (($val $mid_keys $mid_vals $mid_pattern_vars) 
                    (if (== (get-metatype $head) Expression)
                        (address_conflict $head $cnjtion_vars $seen_keys $seen_vals $pattern_vars)
                        (if (== (get-metatype $head) Variable)
                            (if (does_exist $head $cnjtion_vars)
                                (if (does_exist $head $seen_keys)
                                    (let $finvar (find_value $seen_keys $seen_vals $head) ($finvar $seen_keys $seen_vals (union-atom $pattern_vars ($finvar))))
                                    (let $ranvar (gen_vars) 
                                        ($ranvar (cons-atom $head $seen_keys) (cons-atom $ranvar $seen_vals) (union-atom $pattern_vars ($ranvar)))))
                                ($head $seen_keys $seen_vals (union-atom $pattern_vars ($head))))
                            ($head $seen_keys $seen_vals $pattern_vars))))    
           
           (($rest $final_keys $final_vals $final_pattern_vars) (address_conflict $tail $cnjtion_vars $mid_keys $mid_vals $mid_pattern_vars))
       )
       ((cons-atom $val $rest) $final_keys $final_vals $final_pattern_vars)
    )
))

(= (alpha_convert $pattern $cnjtion_vars)
    (let ($converted $keys $vals $pat_vars) (address_conflict $pattern $cnjtion_vars () () ()) ($converted $pat_vars))
)


;; ================= alpha convert end ================================

(= (expand_conjunction_rec $cnjtion $apat $cnj_vars $pat_vars $db $ms)
    (let $npat (expand_conjunction_connect $cnjtion $apat $cnj_vars $pat_vars)
         (checker $db $npat $ms)
    )
)

(= (expand_conjunction_connect $cnjtion $pattern $cv $pv)
    (let $list (replace_pattern $cnjtion $pattern (combine_lists $cv $pv))
        $list
    )
)
(= (replace_pattern $cnjtion $pattern ())
    ()
)
(= (replace_pattern $cnjtion $pattern $pv2cv)
    (let* (
            ($sup (superpose $pv2cv))
            ($exp (substitute $pattern $sup))
            ($new_cnjtion (, $cnjtion (car-atom $exp)))
        )
        $new_cnjtion
)
)

(= (checker $db $pattern $ms) 
    (let*
    (    
        ($conjuncts (get-conjuncts $pattern))
        ($flat (cons-atom , $conjuncts))
        ($result (sup-eval $db $flat $ms))
        ($final (if $result $pattern ()))
    )
   $final
    )
)


(= (remove_conjuncts_with_redundant_clauses $conjunction)
    (if (== $conjunction ())
        ()
    (let* (
        ($conjuncts (get-conjuncts $conjunction))
        ($uselessrem (remove_useless_clauses $conjuncts))
        ($unique_conjuncts (unique-atom $uselessrem))
        )
    (if (== (size-atom $conjuncts) (size-atom $unique_conjuncts))
        $conjunction
        ()
    )
    ))
)

;; =========================================================================



(= ( expand_conjunction_disconnect $cnjtion $pattern ) (
        let* (
            ($cnjtion_vars (get_variables_for_tree $cnjtion))
            ($pat_vars  (get_variables_for_tree $pattern))
            ($acvar (alpha_convert $pat_vars $cnjtion_vars))
            ($acpat (let $pat (substitute $pattern $acvar) (car-atom $pat)))
            ($npat (append_pat $cnjtion $acpat))
            ($nclause (remove_redundant_subclauses $npat))
        ) $acvar
))

(= ( append_pat $pat $conj) ( , $pat $conj))

 
; ------------------------------------------------
; do-conjunct
; ------------------------------------------------
;; function to expand the conjunctions of the patterns and create conjunctions of any amount of clauses

;; parameters:
;; $db: the database that is loaded and cleaned of the stdlib functions.
;; $cndb: the candidate patterns space
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
;(: do-conjunct space space conj_pattern Number debruijin-index Atom)

(= (do-conjunct $db $cndb $conjunct $matches $ms Z)
    (if (== $conjunct ())
        ()
    (let* (
        (true (println! ("==== Build conjunction with depth 0 ====" $conjunct)))
        ($listconj (expand_conjunction $conjunct (superpose $matches) $db $ms True))
        ($fitlered (remove_conjuncts_with_redundant_clauses $listconj))
        ($final (replace $fitlered))
    )
    $final
    ))
)

(= (do-conjunct $db $cndb $conjunct $matches $ms (S $K))
    (if (== $conjunct ())
        ()
    (let* (
        (true (println! ("==== Build conjunction with depth greater than 0 =====" $conjunct)))
        ($listconj (expand_conjunction $conjunct (superpose $matches) $db $ms True))
        ($fitlered (remove_conjuncts_with_redundant_clauses $listconj))
        ($conj (do-conjunct $db $cndb $fitlered $matches $ms $K))
    )
    $conj
    ))
)

; --------------------------------------------
;;  formatter
; --------------------------------------------
;; function to format the patterns with thier support annotation.
;; 1: get the matches of the conjunctions in the database
;; 2: sort the conjunctions with a custom sorting function and get only the unique conjunctions from the sorte results
;; 3: create a flattened conjunction  using cons-atom with the sorted conjunctions and ,.
;; 4: add the results to the knowledge base with their support
;(: formatter (-> space space Atom ))

(= (formatter $conjspace $cndpspace $dbspace $cnj) 
    (if $cnj
        (let* (
            (true (println! "==== Formating  started ====="))
            ($sortedlist (unique-atom (collapse (match $conjspace $pattern (sort_conj $pattern)))))
            ($sorted (superpose $sortedlist))
            ($res (cons-atom , $sorted))
            ($var (replacev $res))
            ($sup (sup-num $dbspace $var))
            ($final (supportOf $var $sup))
        )
        $final
        )
        (let* (
            (true (println! "==== Formating  started ====="))
            ($final (match $cndpspace (CandidatePattern $pattern $cnt) (replacev (supportOf $pattern $cnt))))
        )
        $final
        )

    )
)


; -----------------------------------------------
;; conjunct 
; -----------------------------------------------
;; function to extract candidate patterns and call do-conjunct 
;(: conjunct (-> space space space Number Number Atom))

(= (conjunct $dbspace $cndpspace $conjspace $minsup $depth)   
                   (let* (
                        ($pattern (collapse (match $cndpspace (CandidatePattern $patterns $cnt) (replacev $patterns))))
                        (true (println! ("==== Conjuntion expansion started" $pattern)))
                        ($conj  (do-conjunct $dbspace $cndpspace (superpose $pattern) $pattern $minsup (fromNumber $depth)))
                        ($reduct (if (== $conj ()) () (add-atom $conjspace $conj)))
                        )
                        $reduct
                    )
        )
; Check if a variable is in a list
(= (is-var-in-list $var $list) (if (== $list ()) False (let $head (car-atom $list) (if (== $var $head) True (is-var-in-list $var (cdr-atom $list))))))


; Check if variables from one list exist in another list
(= (exist $list1 $list2) 
    (if (== $list1 ())
         False 
         (let $head (car-atom $list1) (if (is-var-in-list $head $list2) True (exist (cdr-atom $list1) $list2)))))

(= (vars-exist $combinations $vars)
    (if (== $combinations ())
        ()
        (let* (
                ($head-comb (car-atom $combinations))
                ($tail-comb (cdr-atom $combinations))
                ($check (exist $head-comb $vars))
                ($res (if $check $head-comb Empty))
                ($rest (vars-exist $tail-comb $vars))
              )
            (cons-atom $res $rest)
        )
    )
)

; (= (combiner-pat1-pat2 $vars () $accum)
;    $accum
; )
; (= (combiner-pat1-pat2 $vars $pat2 $accum)
;   (superpose (
;     ;; Option 1: keep the slot
;     (combiner-pat1-pat2 $vars (cdr-atom $pat2) (union-atom $accum ((car-atom $pat2))))
;     ;; Option 2: replace with each var
;     (combiner-pat1-pat2 $vars (cdr-atom $pat2) (union-atom $accum ((superpose $vars))))

;   ))
; )
;; Update 1: Add $full-vars to arguments
(= (try-replace $vars-to-iterate $full-vars $rest-pat2 $current $results)
   (if (== $vars-to-iterate ())
       $results
       (let* (
              ($var       (car-atom $vars-to-iterate))
              ($rest-vars (cdr-atom $vars-to-iterate))
              ($so-far $results)

              ;; Update 2: Pass $full-vars to combiner-all, NOT $vars-to-iterate
              ($after-this-var
                   (combiner-all $full-vars $rest-pat2
                                 (union-atom $current ($var))
                                 $so-far)) 
              
              ;; Update 3: Pass $full-vars along to the next recursive step
              ($final (try-replace $rest-vars $full-vars $rest-pat2 $current $after-this-var))
             )
         $final)))

(= (combiner-all $vars $pat2 $current $results)
   (if (== $pat2 ())
       (cons-atom $current $results)
       (let* (
              ($slot      (car-atom $pat2))
              ($rest-pat2 (cdr-atom $pat2))

              ;; 1. Keep original slot
              ($next_current (union-atom $current ($slot)))
              ($after-keep
                   (combiner-all $vars $rest-pat2
                                 $next_current
                                 $results))
              
              ;; 2. Replace this position
              ;; Update 4: Pass $vars TWICE. 
              ;; Once as the list to iterate, once as the full master list.
              ($final (try-replace $vars $vars $rest-pat2 $current $after-keep))
             )
         $final
         )))

;; Entry point remains mostly the same


; Get filtered combinations of variables
(= (combine_lists $vars1 $vars2) 
    (let* (
        ($combinations (combiner-all $vars1 $vars2 () ()))
        ($vars1-check (vars-exist $combinations $vars1))
    ) $vars1-check
    )
)



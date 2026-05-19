; (= (substitute $pattern $sub)
;    (if (== $pattern ())
;        (() $sub) ;; base case: empty
;        (let* (
;                ($head (if (== (get-metatype $pattern) Variable) (car-atom ($pattern)) (car-atom $pattern)))
;                ($tail (if (== (get-metatype $pattern) Variable) (cdr-atom ($pattern)) (cdr-atom $pattern)))
;                ;; process head
;                (($newhead $after-head-subs)
;                   (if (== (get-metatype $head) Variable)
;                       (if (== $sub ())
;                           ($head $sub) ;; no subs left
;                           ((car-atom $sub) (cdr-atom $sub)))
;                       (if (== (get-metatype $head) Expression)
;                           ;; nested list → recurse, passing whole $sub
;                           (substitute $head $sub)
;                           ;; constant atom
;                           ($head $sub))
;                   )
;                )

;                (($newtail $remaining)
;                   (substitute $tail $after-head-subs))
;              )
;          ((cons-atom $newhead $newtail) $remaining)
;        )
;    )
; )

(= (specialization $pattern $shallow_abstractions)
    (let* (
        ($spec (substitute $pattern $shallow_abstractions))
        ($res (if (== (get-metatype $pattern) Variable) (let $head (car-atom $spec) (car-atom $head)) (car-atom $spec)))
    )
    $res
    )
)

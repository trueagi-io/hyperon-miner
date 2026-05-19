
 ; True, but no confidence.
(= (DEFAULT_TV)  (STV 1 0))

(: confidence (-> TruthValue Number))
(= (confidence (Bl $smt)) 1.0)
(= (confidence (Pr $smt)) 1.0)
(= (confidence ($type $mean $conf)) $conf)

(: strength (-> TruthValue Number))
(= (strength (Bl $smt)) 0)
(= (strength (Pr $smt)) 0)
(= (strength ($type $strg $conf)) $strg)

!(strength (STV 0.1 0.2))

; (= (gt-zero-confidence-eval $num)
;     (if (> $num 0)
;         True
;         False
;     )
; )
;; this take truth value like (STV 0.1 0.1)
(: gt_zero_confidence_eval (-> Atom Bool))
(= (gt_zero_confidence_eval $x)
    (> (confidence $x) 0)
)

!(gt_zero_confidence_eval (STV 0.1 0.2))


(= (exist $value)
    (if (== $value ())
        False
        True
    )
)

(: Pattern Type)
(: Db Type)

 ;;Simulation for the emp-eval
; (: emp-eval (-> Pattern Db Number))
; (= (emp-eval $pattern $db)
;     (case $pattern
;         (
;             ( (Parent abel henok) (0.6 1))
;             ( (Parent abel mary) (0.7 1))
;             ($_ (0.5 1))
;         )
; ))

;  ;;Simulation for the est-eval
; (: est-eval (-> Pattern Db Number))
; (= (est-eval $pattern $db)
;     (case $pattern
;         (
;             ( (Parent abel henok) (0.55 1))
;             ( (Parent abel mary) (0.65 1))
;             ($_ (0.5 1))
;         )
; ))

(= (emp-eval $pattern) ( (Predicate emp) $pattern))
(= (est-eval $pattern) ( (Predicate est) $pattern))
(= (jsd-eval $f) (
        (Predicate jsd) $f
    ))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;Creates truth value to be use on cog-set-tv stv is just an alias
(: cog-new-stv (-> Number Number Tuple))
(= (cog-new-stv $mean $confidence)
    (STV $mean $confidence))

 ;  ; Returns truth value of an atom
 ; (: cog-tv (-> Atom Boolean))
 ; (= (cog-tv $atom)
 ;     (match &self (ConceptNode $atom $stv) $stv)
 ; )

 ;Assuming the database is something like this
 ;(Inheritance Allen human)
 ;(stv Allen 0.98 1)
 ;The tuple is like (0.9 0.8)
 ; (: cog-set-tv (-> Atom Tuple Atom))
 ; (= (cog-set-tv $atom $tv)
 ;     (let* ( ($var (cdr-atom $atom))
 ;             ($var2 (car-atom $var))
 ;             ($mean (car-atom $tv))
 ;             ($var3 (cdr-atom $tv))
 ;             ($confidence (car-atom $var3))
 ;         ) (add-atom &self (stv $var2 $mean $confidence)))
 ; )

 ;; $conclusion:  ((Pridicate minsup) $db $pattern)
 ;; $tv: (EMP 0.5 0.6)

(= (cog-set-tv $conclusion $tv) (
        add-atom &self ($conclusion $tv)
    ))

 ; asssuming the db is like this
 ; (Inheritance Allen human)
 ; (stv Allen 0.4 1)
 ; (Inheritance Abebe human)
 ; (stv Abebe 0.6 1)
 ; (Inheritance Allen human)
 ; (Inheritance Kebede human)
 ; (stv Kebede 0.9 1)
 ; (Inheritance Allen human)

 ; (= (cog-tv $pattern)
 ;     (let* ( ($var (cdr-atom $pattern))
 ;             ($var2 (car-atom $var))
 ;         ) (match &self (stv $var2 $mean $confidence) (stv $mean $confidence)))

 ; )

(= (cog-tv $pattern)
    (unify &self ($pattern $tv)
        $tv
        (DEFAULT_TV)
    )
)


; ! (register-module! ../../../hyperon-miner)
; ! (import! &self hyperon-miner:experiments:utils:common-utils)
; ! (import! &self hyperon-miner:experiments:frequent-pattern-miner:freq-pat)
; ! (import! &self hyperon-miner:experiments:utils:index_to_var)
; ! (import! &self hyperon-miner:experiments:utils:blk-abstractness)
; ! (import! &self hyperon-miner:experiments:utils:gen_partition)

!(import! &self ../../common-utils)
!(import! &self ../../index_to_var)
!(import! &self ../../blk-abstractness)
!(import! &self ../../partition-metta)

; (= (can-unify-ground $ground1 $ground2)
;     (if (== $ground1 $ground2)
;         True
;         (if (or (== (get-metatype $ground1) Variable)
;                 (== (get-metatype $ground2) Variable))
;                 True
;                 False)
;     )
; )

; (= (can-unify-ground $ground1 $ground2)
; (unify $ground1 $ground2 True False)
; )

; !(can-unify-ground $x $x)
; !(can-unify-ground Abebe kebede)


 !(is-blk-syntax-more-abstract ((Human $x $y)) ((Human $x Abebe)) $x)

!(is-blk-syntax-more-abstract ((Human $x Abebe)) ((Human $x $y)) $x)

; !(is-blk-syntax-more-abstract ((Human (Person $x) (Person $y))) ((Human (Person $x) (Person Abebe))) (Person $x))

; !(is-blk-syntax-more-abstract ((Human (Person $x) (Person $y))) ((Human (Person $x) (Person Abebe))) $x)

;  !(is-blk-syntax-more-abstract ((Human (Person $x) (Person Abebe))) ((Human (Person $x) (Person $y))) (Person $x))

; !(is-blk-syntax-more-abstract ((Inheritance $x (Person $y))) ((Inheritance $x (Person Abebe) )) $x)



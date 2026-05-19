!(import! &self ../utils/common-utils)
!(import! &self ../utils/index_to_var)
!(import! &self ../utils/sort)
!(import! &self ../utils/variable-combinations)
!(import! &self ../utils/surp-utils/blk-abstractness)
!(import! &self ../utils/surp-utils/partition-metta)
!(import! &self ../utils/remove_useless_clauses)
!(import! &self ../frequent-pattern-miner/conjunction-expansion)
!(import! &dbspace   ../data/ugly_man_sodaDrinker)
!(import! &kb   ../miner/freq-miner-rules)
!(import! &self ../miner/system-proofs)
!(import! &self ../miner/freq-miner)



(= (init-miner $db $kb $ms)
    (         let* (  
                 ($1 (add-atom $kb (: msT (ms-threshold $ms))))
                 ($2 (add-atom $kb (: dbref (db-ref $db))))
                 ($3 (add-atom $kb (: dbr (db-ratio $db-ratio))))
                 ($4 (add-atom &self (kb-ref $kb)))
                 ($5 (add-atom $kb (db-ref $db)))
                )()))


(= (test_AB_AC $db $kb $ms $limit $cnjexp)
    (let* (
        ($init (init-miner $db $kb $ms)) 
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance A C)))
        ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance A C)))
        ($cnd (match $kb (: $prf (candidatePattern $ptrn $cnt)) $ptrn))
    )$cnd)
)

; !(assertEqual (collapse (test_AB_AC &db &kb 2 2 False)) ((Inheritance Z (S Z)) (Inheritance A Z))) 

(= (test_AB_AC_BC $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms)) 
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance A C)))
        ($dbadd3 (add-atom $db (Inheritance B C)))
        ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance A C)))
        ($dbrem3 (remove-atom $db (Inheritance B C)))
        ($cnd (match $kb (: $prf (candidatePattern $ptrn $cnt)) $ptrn))
    )$cnd)
)

; !(assertEqual (collapse (test_AB_AC_BC &db &kb 2 2 False)) ((Inheritance Z (S Z)) (Inheritance A Z) (Inheritance Z C)))


(= (test_AB_ABC $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms)) 
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance A (And B C))))
        ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance A (And B C))))
        ($cnd (match $kb (: $prf (candidatePattern $ptrn $cnt)) $ptrn))
    )$cnd)
)

; !(assertEqual (unique-atom (collapse (test_AB_ABC &db &kb 2 2 False))) ((Inheritance Z (S Z)) (Inheritance A Z)))

(= (test_ABCD $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms))
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance C D)))
        ($dbadd3 (add-atom $db (Inheritance E F)))
        ($dbadd4 (add-atom $db (Inheritance G H)))
        ($dbadd5 (add-atom $db (Implication (Inheritance A B) (Inheritance C D))))
        ($dbadd6 (add-atom $db (Implication (Inheritance E F) (Inheritance G H))))
        ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance C D)))
        ($dbrem3 (remove-atom $db (Inheritance E F)))
        ($dbrem4 (remove-atom $db (Inheritance G H)))
        ($dbrem5 (remove-atom $db (Implication (Inheritance A B) (Inheritance C D))))
        ($dbrem6 (remove-atom $db (Implication (Inheritance E F) (Inheritance G H))))
        ($cnd (match $kb (: $prf (candidatePattern $ptrn $cnt)) $ptrn))
    )
$cnd
    )
)

; !(assertEqual (unique-atom (collapse (test_ABCD &db &kb 2 2 False))) ((Inheritance Z (S Z)) (Implication Z (S Z)) (Implication (Inheritance Z (S Z)) (S (S Z))) (Implication Z (Inheritance (S Z) (S (S Z)))) (Implication (Inheritance Z (S Z)) (Inheritance (S (S Z)) (S (S (S Z)))))))
; !(test_ABCD &db &kb 2 2 False)

(= (test_ABAB $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms))
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance B C)))
        ($dbadd5 (add-atom $db (Implication (Inheritance A B) (Inheritance A B))))
        ($dbadd6 (add-atom $db (Implication (Inheritance B C) (Inheritance B C))))
         ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance B C)))
        ($dbrem5 (remove-atom $db (Implication (Inheritance A B) (Inheritance A B))))
        ($dbrem6 (remove-atom $db (Implication (Inheritance B C) (Inheritance B C))))
        ($cnd (match $kb (: $prf (candidatePattern $ptrn $cnt)) $ptrn))
    )
$cnd
    )
)

; !(assertEqual (intersection-atom (collapse (test_ABAB &db &kb 2 2 False)) ((Implication (Inheritance Z (S Z)) (Inheritance Z (S Z))))) ((Implication (Inheritance Z (S Z)) (Inheritance Z (S Z)))))

(= (test_AAAA $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms))
        ($dbadd5 (add-atom $db (Implication (Inheritance A A) (Inheritance A A))))
        ($dbadd6 (add-atom $db (Implication (Inheritance B B) (Inheritance B B))))
         ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem5 (remove-atom $db (Implication (Inheritance A A) (Inheritance A A))))
        ($dbrem6 (remove-atom $db (Implication (Inheritance B B) (Inheritance B B))))
       ($cnd (match $kb (: $prf (candidatePattern $ptrn $cnt)) $ptrn))
    )
$cnd
    )
)

; !(assertEqual (intersection-atom (collapse (test_AAAA &db &kb 2 2 False)) ((Implication (Inheritance Z Z) (Inheritance Z Z)))) ((Implication (Inheritance Z Z) (Inheritance Z Z))))

(= (test_transitivity $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms))
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance B C)))
         ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance B C)))
        ($cnd (match $kb (: $prf (hasSupport $ptrn $cnt)) $ptrn))
    )$cnd)
)

; !(assertEqual (intersection-atom (collapse (test_transitivity &db &kb 1 2 True)) ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z)))))) ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z))))))


(= (test_long_transitivity $db $kb $ms $limit $cnjexp)
    (let*(
        (() (init-miner $db $kb $ms))
        ($dbadd1 (add-atom $db (Inheritance A B)))
        ($dbadd2 (add-atom $db (Inheritance B C)))
        ($dbadd2 (add-atom $db (Inheritance C D)))
         ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($dbrem1 (remove-atom $db (Inheritance A B)))
        ($dbrem2 (remove-atom $db (Inheritance B C)))
        ($dbrem2 (remove-atom $db (Inheritance C D)))
        ($cnd (match $kb (: $prf (hasSupport $ptrn $cnt)) $ptrn))
    )$cnd)
)

; !(assertEqual (intersection-atom (collapse (test_long_transitivity &db &kb 1 3 True)) ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z))) (Inheritance (S (S Z)) (S (S (S Z))))))) ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z))) (Inheritance (S (S Z)) (S (S (S Z)))))))


(= (test_SodaDrinker_incremental $db $kb $ms $limit $cnjexp)
    (let* (
        (() (init-miner $db $kb $ms))
        ($res (collapse (frequent-miner $db $kb $limit $cnjexp)))
        ($cnd (match $kb (: $prf (hasSupport $ptrn $cnt)) $ptrn))
    )$cnd)
)

; !(assertEqual (intersection-atom (collapse (test_SodaDrinker_incremental &dbspace &kb 5 3 True)) ((, (Inheritance Z man) (Inheritance Z ugly) (Inheritance Z sodaDrinker)))) ((, (Inheritance Z man) (Inheritance Z ugly) (Inheritance Z sodaDrinker))))




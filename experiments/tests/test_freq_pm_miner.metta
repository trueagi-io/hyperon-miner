! (register-module! ../../../hyperon-miner)
; ! (import! &db hyperon-miner:experiments:data:sample-data)
; ! (import! &db hyperon-miner:experiments:data:ugly_man_sodaDrinker)
! (import! &db hyperon-miner:experiments:data:small-ugly)
; ! (import! &self hyperon-miner:experiments:rules:conjunction-expansion)
! (import! &self hyperon-miner:experiments:frequent-pattern-miner:frequent-pattern-miner)
! (import! &self hyperon-miner:experiments:rules:use-python)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:remove_useless_clauses)
! (import! &self hyperon-miner:experiments:utils:index_to_var)
! (import! &self hyperon-miner:experiments:utils:blk-abstractness)
! (import! &self hyperon-miner:experiments:utils:gen_partition)
; ! (import! &self hyperon-miner:experiments:utils:variable-combinations)
! (bind! &kb (new-space))
! (bind! &dbspace (new-space))
! (bind! &testspace (new-space))
! (bind! &specspace (new-space))
! (bind! &cndpspace (new-space))
! (bind! &aptrnspace (new-space))
! (bind! &conjspace (new-space))
! (bind! &linkspace (new-space))

!(let ($link $x $y) (get-atoms &db) (add-atom &dbspace ($link $x $y)))

(= (test_empty)
    (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 5 0 False)
)

; !(test_empty)
; !(match &cndpspace (CandidatePattern $pattern) $pattern)

(= (test_AB_AC)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance A C)))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance A C)))
        ($cnd (match &cndpspace (CandidatePattern $pattern) $pattern))
    )$cnd)
)

!(assertEqual (subtraction (test_AB_AC) (superpose ((Inheritance Z (S Z)) (Inheritance A Z)))) (superpose ())) 

(= (test_AB_AC_BC)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance A C)))
        ($dbadd3 (add-atom &testspace (Inheritance B C)))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance A C)))
        ($dbrem3 (remove-atom &testspace (Inheritance B C)))
        ($cnd (match &cndpspace (CandidatePattern $pattern) $pattern))
    )$cnd)
)

!(assertEqual (subtraction (test_AB_AC_BC) (superpose ((Inheritance Z (S Z)) (Inheritance Z C) (Inheritance A Z)))) (superpose ()))
; !(subtraction (test_AB_AC_BC) (superpose ((Inheritance Z C) (Inheritance A Z))))
; !(test_AB_AC_BC)

(= (test_AB_ABC)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance A (And B C))))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance A (And B C))))
        ($cnd (match &cndpspace (CandidatePattern $pattern) $pattern))
    )$cnd)
)

!(assertEqual (subtraction (unique (test_AB_ABC)) (superpose ((Inheritance A Z) (Inheritance Z (S Z))))) (superpose ()))
; 
;  !(test_AB_ABC)

(= (test_ABCD)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance C D)))
        ($dbadd3 (add-atom &testspace (Inheritance E F)))
        ($dbadd4 (add-atom &testspace (Inheritance G H)))
        ($dbadd5 (add-atom &testspace (Implication (Inheritance A B) (Inheritance C D))))
        ($dbadd6 (add-atom &testspace (Implication (Inheritance E F) (Inheritance G H))))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance C D)))
        ($dbrem3 (remove-atom &testspace (Inheritance E F)))
        ($dbrem4 (remove-atom &testspace (Inheritance G H)))
        ($dbrem5 (remove-atom &testspace (Implication (Inheritance A B) (Inheritance C D))))
        ($dbrem6 (remove-atom &testspace (Implication (Inheritance E F) (Inheritance G H))))
        ($cnd (match &cndpspace (CandidatePattern $pattern) $pattern))
    )
$cnd
    )
)

!(assertEqual (subtraction (test_ABCD) (superpose ((Implication Z (S Z)) (Implication Z (Inheritance (S Z) (S (S Z)))) (Implication (Inheritance Z (S Z)) (S (S Z))) (Implication (Inheritance Z (S Z)) (Inheritance (S (S Z)) (S (S (S Z)))))))) (superpose ()))


(= (test_ABAB)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance B C)))
        ($dbadd5 (add-atom &testspace (Implication (Inheritance A B) (Inheritance A B))))
        ($dbadd6 (add-atom &testspace (Implication (Inheritance B C) (Inheritance B C))))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance B C)))
        ($dbrem5 (remove-atom &testspace (Implication (Inheritance A B) (Inheritance A B))))
        ($dbrem6 (remove-atom &testspace (Implication (Inheritance B C) (Inheritance B C))))
        ($cnd (match &cndpspace (CandidatePattern $pattern) $pattern))
    )
$cnd
    )
)

; !(test_ABAB)
; !(intersection (test_ABAB) (superpose ((Implication (Inheritance Z (S Z)) (Inheritance Z (S Z))))))

(= (test_AAAA)
    (let*(
        ; ($dbadd1 (add-atom &testspace (Inheritance A A)))
        ; ($dbadd2 (add-atom &testspace (Inheritance B B)))
        ($dbadd5 (add-atom &testspace (Implication (Inheritance A A) (Inheritance A A))))
        ($dbadd6 (add-atom &testspace (Implication (Inheritance B B) (Inheritance B B))))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 2 0 False)))
        ; ($dbrem1 (remove-atom &testspace (Inheritance A A)))
        ; ($dbrem2 (remove-atom &testspace (Inheritance B B)))
        ($dbrem5 (remove-atom &testspace (Implication (Inheritance A A) (Inheritance A A))))
        ($dbrem6 (remove-atom &testspace (Implication (Inheritance B B) (Inheritance B B))))
        ; ($cnd (match &kb $pattern $pattern))
        ; ($cnd (match &conjspace $pattern $pattern))
        ($cnd (match &cndpspace (CandidatePattern $pattern $cnt) $pattern))
        ; ($abs (match &aptrnspace (AbstractPattern $pattern) $pattern))
        ; ($cnd (match &linkspace $link $link))
    )
$cnd
; $res
    )
)

; !(test_AAAA)
; !(assertEqual (intersection (test_AAAA) (superpose ((Implication (Inheritance Z Z) (Inheritance Z Z))))) (superpose ((Implication (Inheritance Z Z) (Inheritance Z Z)))))


(= (test_transitivity)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance B C)))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 1 0 True)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance B C)))
        ; ($cnd (match &conjspace $pattern $pattern))
    )$res)
)

; !(test_transitivity)
; !(test_transitivity)
; !(assertEqual (intersection (test_transitivity) (superpose ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z))))))) (superpose ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z)))))))

; !(match &cndpspace $pattern $pattern)

(= (test_long_transitivity)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance B C)))
        ($dbadd2 (add-atom &testspace (Inheritance C D)))
        ($res (collapse (frequency-pattern-miner &testspace &specspace &cndpspace &aptrnspace &conjspace 1 1 True)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance B C)))
        ($dbrem2 (remove-atom &testspace (Inheritance C D)))
        ; ($cnd (match &conjspace $pattern $pattern))
    )$res)
)

; !(test_long_transitivity)


; !(remove_useless_clauses ((Inheritance $o89 $g09) (Inheritance A $g09)))
; !(remove_conjuncts_with_redundant_clauses (,(Inheritance $o89 $g09) (Inheritance A $g09)))
; !(remove_conjuncts_with_redundant_clauses (, (, (Inheritance $n27 $q72) (Inheritance A $n27)) (Inheritance A $n27)))

; !(expand_conjunction (, (Inheritance $w99 man) (Inheritance $w99 $r52))  (Inheritance $r04 $r52) &dbspace 5 2 False)
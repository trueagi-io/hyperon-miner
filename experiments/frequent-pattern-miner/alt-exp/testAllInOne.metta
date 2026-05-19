; !(import! &self ../../data/small-ugly)
; !(import! &self ../../data/ugly_man_sodaDrinker)
!(import! &self ../../data/dataset_for_n_arry_format)

;; lets transfer this data to other space
!(bind! dataBase (new-space))
!(let* 
    (
        ($x (get-atoms &self))
        ($debug1 (remove-atom &self $x))
        ($debug2 (add-atom dataBase $x))
    ) ())
; !(-------------- new database atoms ---------------)
; !(get-atoms dataBase)
; !(-------------- end database atoms ---------------)

!(import! &self Updated-frequent-pattern-miner)
!(import! &self Updated-conjunction-expansion)
!(import! &self Updated-frequentMinerHelperFunctions)


; !(import! &self use-python)
; !(get-atoms &self)

;; space for the final conjuncts
!(bind! conjunctSpace (new-space))

; !(frequency-pattern-miner dataBase-space conjunct-Space min-Support number-of-pattern-in-one-conjunct minus 2)
!(frequency-pattern-miner dataBase conjunctSpace 3 1)

;;;;;;;;;;;;;;;;;
;; Basic steps ;;
;;;;;;;;;;;;;;;;;

;: - Initialize Miner – Create a function to initialize the frequent pattern miner.
;: - Mine Patterns – Extract patterns that meet the minsup threshold.
;: - Launch Backward Chainer – Use the mined patterns and the surprisingness rule in the backward chainer.
;: - Calculate Surprisingness – The rule triggers do-isurp to compute the surprisingness value for patterns that satisfy it.
;: - Sort & Return – Return patterns sorted by their surprisingness value.






;----------------------------------------------------------------------
;; init-miner 
;----------------------------------------------------------------------
;; Initialize hyperparameters in both knowledge bases so as to make them accessible for the chainne.r
(= (init-miner $db $kb $ms $surp $db-ratio $normalization)
    ( superpose (  
                  (println! "==== Initialize hyperparameters =====") 
                  (add-atom  $kb (: msT (ms-threshold $ms)))
                 (add-atom  $kb (: dbref (db-ref $db)))
                  (add-atom  $kb (: dbr (db-ratio $db-ratio)))
                  (let $res (db_size $db) (add-atom $kb (: dbsize (db-size $res)) ))
                  (add-atom  $kb (surp-mod $surp))
                  (add-atom  $kb (db-ratio $db-ratio))
                  (let $res2 (db_size $db) (add-atom $kb (db-size $res2)))
                  (add-atom  $kb (db-ref $db))
                  (add-atom $kb (: surpMode (surp-mode $surp)))
                  (if $normalization
                                              (add-atom $kb (: normalize (normalized True)))  
                                              (add-atom $Kb (: normalize (normalized False))))
                                
    )))

;-----------------------------------------------------------
;; get-patterns
;-----------------------------------------------------------
;;Returns frequent patters with their support from the kb
(= (get-patterns $kb $res) (
    match $kb  (: $prf (hasSupport $nptrn $count))  (add-atom $res   (: $prf (hasSupport $nptrn $count)))        
))




;-----------------------------------------------------------------
;; mine-surp
;-----------------------------------------------------------------
;; extract the mode of the Surprisingness
;; if the surprisingness mode is none return lis of mined patterns
;; otherwise launches the backward chainer for surprising patterns mining
(= (mine-surp $kb $res $surp-mode)  
  ( case $surp-mode (
        (none    (get-patterns $kb $res) ) 
        (jsdsurp (let $result  (syn $kb (fromNumber 13) (: $prf (jsd-surp $what_is_surprise $value)))   (add-atom $res $result)))
        ($_        (let (: $prf $ccln) (syn $kb (fromNumber 19) (: $prf (Isurp  $pattern $value )))    (add-atom $res (: $prf $ccln))))
    )                                                         
))




;--------------------------------------------------------------------------------------
;; pattern-miner
;--------------------------------------------------------------------------------------
;; Chainer-base;d frequent and surprisingness pattern miner.
(= (pattern-miner $db $freq-kb $surp-kb $initpat $ms $num-of-conjuct $cnj_exp $surp-mode $db-ratio $norm) (
    let* (
        (true (println! "==== Pattern Miner Started ====="))
        ($dummy1 (collapse (init-miner $db  $freq-kb $ms $surp-mode $db-ratio $norm)))
        ($dummy2 (collapse (init-miner $db  $surp-kb $ms $surp-mode $db-ratio $norm)))
        (() (frequent-miner $db $freq-kb $initpat $num-of-conjuct $cnj_exp)) 
        ($dummy3 (collapse (match $freq-kb (: $prf (hasSupport $nptrn $count)) (add-atom $surp-kb (: $prf (hasSupport $nptrn $count))))))
        (true (println! "==== Surprissingness Scoring Started ====="))
        ($dummy4  (collapse (mine-surp $surp-kb &res $surp-mode)))
    )    
          (get-atoms &res)
    
))

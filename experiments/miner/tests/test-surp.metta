
;; import utils 
!(import! &self "../../utils/surp-utils/boost_petta.py")
!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/constants)
!(import! &self ../../utils/TruthValue)
!(import! &self ../../utils/surp-utils/partition-metta)
!(import! &self ../../utils/surp-utils/binomialMetta)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self ../../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/blk-abstractness)
!(import! &self ../../utils/surp-utils/eq-prob-petta)
!(import! &self ../../utils/surp-utils/bs-utils)
!(import! &self ../../utils/surp-utils/jsd-helper)

; import truth value computing components
!(import! &self ../../truth-values/emp-tv)
!(import! &self ../../truth-values/est-tv)
!(import! &self ../../utils/index_to_var)


; import surprisingness scoring functions 
!(import! &self ../../surprisingness/emp-prob)
!(import! &self ../../surprisingness/isurp)
!(import! &self ../../surprisingness/jsd)


;; load the db space 
!(import! &db ../../data/ugly_man_sodaDrinker)
!(import! &db2 ../../data/dataset_for_n_arry_format)





;; load rules , system-proofs and miner-utils ...
!(import! (superpose (&kbNarry &kb &kbNarry1 &kb1 &kbNarry2 &kb2 &kbNarry3 &kb3 &kbNarry4 &kb4))    ../surp-rules)
!(import! &self  ../system-proofs)
!(import! &self ../miner-utils)



;; mocking the frequent pattern miner results 
(= (mock-frequent-miner $kb) (superpose (
   (add-atom $kb  (: FACT1  (hasSupport (, (Inheritance $x human) (Inheritance $x ugly) (Inheritance $x woman)) 1))) 
   (add-atom $kb     (: FACT2 (hasSupport (, (Inheritance $x sodaDrinker) (Inheritance $x human) (Inheritance $x woman)) 1)))
   (add-atom $kb (: FACT3 (hasSupport (,  (Inheritance $x human) (Inheritance $x sodaDrinker) (Inheritance $x ugly)) 1)))
   (add-atom $kb(: FACT4 (hasSupport (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) 8)))
                     )))
                     

;; mocking the frequent pattern miner results for n-arry dataset
( = (mock-frequent-miner-n-arry $kb) (superpose (
   (add-atom $kb (: FACT1 (hasSupport (, (Inheritance $_411962 Pizza-Lover The-Slice-Shop) (Inheritance $_411962 Pizza-Lover $_412004)) 6)))
   (add-atom $kb (: FACT2 (hasSupport (, (Inheritance $_410882 $_410888 The-Slice-Shop) (Inheritance $_410882 $_410888 $_410924)) 6)))
   (add-atom $kb (: FACT3 (hasSupport (, (Inheritance $_410792 $_410798 The-Slice-Shop) (Inheritance $_410792 $_410828 $_410834)) 21)))
   (add-atom $kb (: FACT4 (hasSupport (, (Inheritance $_410702 $_410708 The-Slice-Shop) (Inheritance $_410732 $_410708 $_410744)) 36)))
)))




;; Initialize hyperparameters            
(= (init-params $kb $db $min-sup $surp-mode $db-ratio $normalization )
(superpose
(
(mock-frequent-miner $kb) 
(add-atom $kb (: msT (ms-threshold $min-sup)))
(add-atom $kb (: dbref (db-ref $db)))
(add-atom $kb (: dbr (db-ratio $db-ratio)))
(add-atom $kb (surp-mod $surp-mode))
(add-atom $kb (db-ratio $db-ratio))
(add-atom $kb (db-size (db_size $db)))
(add-atom $kb (db-ref $db))
(add-atom $kb (: surpMode (surp-mode $surp-mode)))
(let $size (db_size $db)  (add-atom $kb (: dbsize (db-size $size))) )
(add-atom $kb (: normalize (normalized $normalization))  
                                    ))))

;; Initialize hyperparameters for n-arry dataset
(= (init-params-n-arry $kb $db $min-sup $surp-mode $db-ratio $normalization )
(superpose
(
(mock-frequent-miner-n-arry $kb) 
(add-atom $kb (: msT (ms-threshold $min-sup)))
(add-atom $kb (: dbref (db-ref $db)))
(add-atom $kb (: dbr (db-ratio $db-ratio)))
(add-atom $kb (surp-mod $surp-mode))
(add-atom $kb (db-ratio $db-ratio))
(add-atom $kb (db-size (db_size $db)))
(add-atom $kb (db-ref $db))
(add-atom $kb (: surpMode (surp-mode $surp-mode)))
(let $size (db_size $db)  (add-atom $kb (: dbsize (db-size $size))) )
(add-atom $kb (: normalize (normalized $normalization))  
                                    ))))


; ------------------------------------------------------------------------------------
; ; old-isurprisingnes without normalization 
; ; define hyper parameters -> 1
(=(min-sup) 6)
(=(min-sup_narry) 36)
(=(surp-mode ) isurp-old)
(=(db-ratio) 0.5)
(= (normalization) False)

!(init-params &kb &db (min-sup) (surp-mode) (db-ratio) (normalization))
!(init-params-n-arry &kbNarry &db2 (min-sup_narry) (surp-mode) (db-ratio) (normalization))


!(println! ("========== isurp-old test without  normalization ==============="))


!(syn &kb (fromNumber 19) (: $prf  (Isurp $pattern $surp))) 

(assertEqual (syn &kb (fromNumber 19) (: $prf  (Isurp $pattern $surp))) 
   ;; Expected reslt  
(: ((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (((emp-prob-rule surpMode) 
   (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB)) ((((est-prob-rule surpMode) (((universal-count 
   (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (partitions-rule CPUPARTN)) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MINIMUMCPU) 
   (Isurp (, (Inheritance $_57590 man) (Inheritance $_57590 ugly) (Inheritance $_57590 sodaDrinker)) 0.00014607068574401354))  )

(assertEqual (syn &kbNarry (fromNumber 29) (: $prf  (Isurp $pattern $surp)))
   (: ((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (((emp-prob-rule surpMode) 
   (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB)) ((((est-prob-rule surpMode) (((universal-count (
   ((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (partitions-rule CPUPARTN)) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MINIMUMCPU) 
   (Isurp (, (Inheritance $_663566 $_663572 The-Slice-Shop) (Inheritance $_663596 $_663572 $_663608)) 0.09406231628453848)))

; ------------------------------------------------------------------------------------
; ;; old-isurprisingnes with normalization 
; ;; define hyper parameters -> 2
(= (min-sup2) 6)
(= (min-sup2_narry) 36)
(= (surp-mode2 ) isurp-old)
(= (db-ratio2) 0.5)
(= (normalization2) True)
 

;;init 
!(init-params &kb2 &db (min-sup2) (surp-mode2) (db-ratio2) (normalization2))
!(init-params-n-arry &kbNarry2 &db2 (min-sup2_narry) (surp-mode2) (db-ratio2) (normalization2))

!(println! ("========== isurp-old test with normalization =============="))


!(assertEqual (syn &kb2 (fromNumber 19) (: $prf  (Isurp $pattern $surp)))
;;Expected result 
 (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) ((emp-prob-rule surpMode) CPUPROB)) 
 (((est-prob-rule surpMode) (partitions-rule CPUPARTN)) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) 
 (Isurp (, (Inheritance $_360224 man) (Inheritance $_360224 ugly) (Inheritance $_360224 sodaDrinker)) 0.999707773232028)))



!(assertEqual (syn &kbNarry2 (fromNumber 19) (: $prf  (Isurp $pattern $surp)))
   (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) ((emp-prob-rule surpMode) CPUPROB)) 
   (((est-prob-rule surpMode) (partitions-rule CPUPARTN)) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) 
   (Isurp (, (Inheritance $_364070 $_364076 The-Slice-Shop) (Inheritance $_364100 $_364076 $_364112)) 0.9876543209876543))
)

; ------------------------------------------------------------------------------------
; isurp with normalization 
; define hyper parameters -> 1
(=(min-sup3) 6)
(=(min-sup3_narry) 6)
(=(surp-mode3 ) isurp)
(=(db-ratio3) 0.5)
(=(normalization3) True)


!(init-params &kb3 &db (min-sup3) (surp-mode3) (db-ratio3) (normalization3))
!(init-params-n-arry &kbNarry3 &db2 (min-sup3_narry) (surp-mode3) (db-ratio3) (normalization3))

!(println! ("========== isurp test with normalization =============="))


!(assertEqual (syn &kb3 (fromNumber 19) (: $prf (Isurp $prattern  $surp))) 
;; Expecged result 
   (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) ((((emp-prob-rule surpMode) 
   ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) dbr) CPUPROB)) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) 
   ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) 
   (Isurp (, (Inheritance $_394922 man) (Inheritance $_394922 ugly) (Inheritance $_394922 sodaDrinker)) 0.8333333333333334)) )

!(assertEqual (syn &kbNarry3 (fromNumber 19) (: $prf (Isurp $prattern  $surp)))
   (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT1) msT) CPU)) dbsize) CPUUNIVERSAL)) ((((emp-prob-rule surpMode) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) dbr) CPUPROB)) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) (Isurp (, (Inheritance $_403346 Pizza-Lover The-Slice-Shop) (Inheritance $_403346 Pizza-Lover $_403388)) 0.7857142857142857))
   (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT2) msT) CPU)) dbsize) CPUUNIVERSAL)) ((((emp-prob-rule surpMode) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) dbr) CPUPROB)) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) (Isurp (, (Inheritance $_402872 $_402878 The-Slice-Shop) (Inheritance $_402872 $_402878 $_402914)) 0.9642857142857143))
   (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT3) msT) CPU)) dbsize) CPUUNIVERSAL)) ((((emp-prob-rule surpMode) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) dbr) CPUPROB)) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) (Isurp (, (Inheritance $_402398 $_402404 The-Slice-Shop) (Inheritance $_402398 $_402434 $_402440)) 0.7142857142857143))
   (: ((((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) ((((emp-prob-rule surpMode) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) dbr) CPUPROB)) ((((est-prob-rule surpMode) (partitions-rule CPUPARTN)) dbr) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) MAXIMUMCPU) DIVIDECPU) MINIMUMCPU) (Isurp (, (Inheritance $_401924 $_401930 The-Slice-Shop) (Inheritance $_401954 $_401930 $_401966)) 0.8333333333333333))
   )


;------------------------------------------------------------------------------------
; Jsd surprisingness 
; define hyper parameters -> 4
(=(min-sup4) 6)
(=(min-sup4_narry) 36)
(=(surp-mode4) jsd)
(=(db-ratio4) 0.5)
(= (normalization4) True)


!(import! &db-sm   ../../data/small-ugly)

!(init-params &kb4 &db-sm (min-sup4) (surp-mode4) (db-ratio4) (normalization4))
!(init-params-n-arry &kbNarry4 &db2 (min-sup4_narry) (surp-mode4) (db-ratio4) (normalization4))

!(println! ("========== JSD Test =============="))

!(assertEqual (syn &kb4 (fromNumber 19) (: $prf (jsd-surp $pattern $surp)))
(: ((((jsd-tv (((minsupport FACT4) msT) CPU)) (emp-rule CPUEMP)) (est-rule CPUEST)) JSDCPU) 
(jsd-surp (, (Inheritance $_474336 man) (Inheritance $_474336 ugly) (Inheritance $_474336 sodaDrinker)) 0.8608962449888)))

!(assertEqual (syn &kbNarry4 (fromNumber 19) (: $prf (jsd-surp $pattern $surp)))
  (: ((((jsd-tv (((minsupport FACT4) msT) CPU)) (emp-rule CPUEMP)) (est-rule CPUEST)) JSDCPU) 
  (jsd-surp (, (Inheritance $_475070 $_475076 The-Slice-Shop) (Inheritance $_475100 $_475076 $_475112)) 0.7821118798382))
)



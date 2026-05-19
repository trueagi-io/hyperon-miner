;;;;;;;;;;;;;;;;;;;;;;;;; 
;; Pattern Miner rules ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Minimum support rule
(: minsupport 
    (-> (supportOf $ptrn $cnt)
        (-> (ms_threshold $ms)
            (-> (⍃ $ms $cnt)
                (minsup $ptrn)))))
                
;; apriori-rule
(: apriori-rule
    (-> (minsup $aptrn)
        (-> (specialization_with_minsup $sptrn $aptrn)
            (minsup $sptrn))))

;; Conjunction rule
(: support-conj
    (-> (minsup $ptrn1)
        (-> (minsup $ptrn2)
            (-> (isDiff $ptrn1 $ptrn2)
                (-> (valid-conj $ptrn1 $ptrn2)
                    (-> (refdb $db)
                        (supportOf (, $ptrn1 $ptrn2) (count (, $ptrn1 $ptrn2) $db))))))))

;; iSurprisingness rule
(: surprisingness 
    (-> (minsup $ptrn)
        (-> (supportOf $ptrn $cnt)
            (surp $ptrn (isurp? ($ptrn $cnt))))))


(:Avrg (-> (STV $num) num))

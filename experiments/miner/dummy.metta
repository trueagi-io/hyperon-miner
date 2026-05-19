(= (syn-old $kb $_ (: $prf (surp $ptrn $value))) 
      (if (> (counter $kb (surp $ptrn $value)) 0) ;; use match here
             (empty)
               (: CpuSurp (surp $ptrn $value))))


(= (syn-old $kb $env (S $k) (: $prf (surp $ptrn $value)))
   (let ; Recurse on minsup
        (: $prfminsup (minsup $ptrn))
          (syn $kb $env Z (: $prfminsup (minsup $ptrn)))
            (when ... ...)))









;; Recursive step
  (= (syn-old $kb (S $k) (: ($prfabs $prfarg) $ccln))
    (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))
            ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))
      (: ($prfabs $prfarg) $ccln)))


 (: minsupport 
    (-> (supportOf $ptrn $cnt)
          (-> (ms-threshold $ms)
                 (-> (⍃ $ms $cnt)
                     (minsup $ptrn)))))

(: minsupport (-> (⍃ $ms $cnt) (minsup $ptrn)))
(: minsupport (minsup $ptrn))

;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))  
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))                       
     (: ($prfabs $prfarg) $ccln)))



;;(= (syn $kb  (S $k) (: $prf (surp $ptrn $value)))
 ;;  (let ; Recurse on surp
 ;;;       (: $prfminsup (sup $ptrn $value))
    ;;      (syn $kb  Z (: $prfsup (sup $ptrn $value)))
      ;;         (:$prfminsup (sup $ptrn $value))))






(supportOf (, (, (Inheritance Z human) (Inheritance Z sodaDrinker)) (Inheritance Z woman)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z ugly)) (Inheritance Z woman)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z human)) (Inheritance Z woman)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z sodaDrinker)) (Inheritance Z man)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z man)) (Inheritance Z human)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z woman)) (Inheritance Z ugly)) 5), 
(supportOf (, (, (Inheritance Z ugly) (Inheritance Z sodaDrinker)) (Inheritance Z human)) 5), 
(supportOf (, (, (Inheritance Z man) (Inheritance Z human)) (Inheritance Z ugly)) 5), 
(supportOf (, (, (Inheritance Z human) (Inheritance Z ugly)) (Inheritance Z man)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z human)) (Inheritance Z ugly)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z human)) (Inheritance Z man)) 5), 
(supportOf (, (, (Inheritance Z ugly) (Inheritance Z man)) (Inheritance Z sodaDrinker)) 5), 
(supportOf (, (, (Inheritance Z sodaDrinker) (Inheritance Z woman)) (Inheritance Z human)) 5)




[(
(: (surprisingness (((minsupport FACT2) msT) CPU)) (surp (, (, (Inheritance $x#12522 sodaDrinker) (Inheritance $x#12522 human)) (Inheritance $x#12522 woman)) 0.00026951691400994854)) 
(: (surprisingness (((minsupport FACT3) msT) CPU)) (surp (, (, (Inheritance $x#12521 human) (Inheritance $x#12521 sodaDrinker)) (Inheritance $x#12521 man)) 0.0001882464522392705)) 
(: (surprisingness (((minsupport FACT4) msT) CPU)) (surp (, (, (Inheritance $x#12520 human) (Inheritance $x#12520 sodaDrinker)) (Inheritance $x#12520 man)) 0.00013659998646536493)))]



umsd_pattern = (LambdaLink
  (Variable "$X") ; [19679d5b361ad95f][1]
  (PresentLink
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "man") ; [1b55d1968390f6e6][1]
    ) ; [967d17e2430fb150][1]
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "soda drinker") ; [62707e4ca36d19af][1]
    ) ; [f2e33e97fd92a096][1]
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "ugly") ; [f273cc9fde1bcc6][1]
    ) ; [fcf0a6b2cedd2ac8][1]
  ) ; [8ec2901544b47ca4][1]
)


(,(Inheritance $x man) (Inheritance $x sodaDrinker) (Inheritance $x ugly))




ugly_man_pattern (LambdaLink
  (Variable "$X") ; [19679d5b361ad95f][1]
  (PresentLink
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "man") ; [1b55d1968390f6e6][1]
    ) ; [967d17e2430fb150][1]
    (InheritanceLink
      (Variable "$X") ; [19679d5b361ad95f][1]
      (Concept "ugly") ; [f273cc9fde1bcc6][1]
    ) ; [fcf0a6b2cedd2ac8][1]
  ) ; [d37451a9f223477a][1]
)



(,(Inheritance $x man) (Inheritance $x ugly))
(syn $kb (fromNumber 4) (: $prf (minsup $pattern)))


(Here)
(r1 $result1#4130)
(r2 $result2#4133)
(r3 $result3#4134)
(Here2)
(First: (: ($prfabs#5844 $prfarg#5845) (minsup $pattern#5230)))
(First: (: ($prfabs#6323 $prfarg#6324) (-> $prms#5847 (minsup $pattern#5230))))
(First: (: ($prfabs#6798 $prfarg#6799) (-> $prms#6326 (-> $prms#5847 (minsup $pattern#5230)))))
(First: (: ($prfabs#7259 $prfarg#7260) (-> $prms#6801 (-> $prms#6326 (-> $prms#5847 (minsup $pattern#5230))))))

(prms: (supportOf $pattern#5230 $cnt#7292) and (-> (ms-threshold $ms#7293) (-> (⍃ $ms#7293 $cnt#7292) (minsup $pattern#5230))))
(First: (: ($prfabs#8232 $prfarg#8233) (supportOf $pattern#5230 $cnt#7292)))
(prfarg FACT4 and prms (supportOf (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man)) 8))
(bct: minsupport (-> (ms-threshold $ms#7293) (-> (⍃ $ms#7293 8) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man))))))
(prfarg FACT3 and prms (supportOf (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man)) 4))
(bct: minsupport (-> (ms-threshold $ms#7293) (-> (⍃ $ms#7293 4) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man))))))
(prfarg FACT2 and prms (supportOf (, (, (Inheritance $x#8264 sodaDrinker) (Inheritance $x#8264 human)) (Inheritance $x#8264 woman)) 5))
(bct: minsupport (-> (ms-threshold $ms#7293) (-> (⍃ $ms#7293 5) (minsup (, (, (Inheritance $x#8264 sodaDrinker) (Inheritance $x#8264 human)) (Inheritance $x#8264 woman))))))
(prfarg FACT1 and prms (supportOf (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 ugly)) (Inheritance $x#8264 woman)) 5))
(bct: minsupport (-> (ms-threshold $ms#7293) (-> (⍃ $ms#7293 5) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 ugly)) (Inheritance $x#8264 woman))))))
(prms: (ms-threshold $ms#7293) and (-> (⍃ $ms#7293 8) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man)))))
(First: (: ($prfabs#12249 $prfarg#12250) (ms-threshold $ms#7293)))
(First: (: ($prfabs#12706 $prfarg#12707) (-> $prms#12252 (ms-threshold $ms#7293))))
(prfarg msT and prms (ms-threshold 6))
(bct: (minsupport FACT4) (-> (⍃ 6 8) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man)))))
(prms: (ms-threshold $ms#7293) and (-> (⍃ $ms#7293 4) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man)))))
(First: (: ($prfabs#14204 $prfarg#14205) (ms-threshold $ms#7293)))
(First: (: ($prfabs#14661 $prfarg#14662) (-> $prms#14207 (ms-threshold $ms#7293))))
(prfarg msT and prms (ms-threshold 6))
(bct: (minsupport FACT3) (-> (⍃ 6 4) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man)))))
(prms: (ms-threshold $ms#7293) and (-> (⍃ $ms#7293 5) (minsup (, (, (Inheritance $x#8264 sodaDrinker) (Inheritance $x#8264 human)) (Inheritance $x#8264 woman)))))
(First: (: ($prfabs#16159 $prfarg#16160) (ms-threshold $ms#7293)))
(First: (: ($prfabs#16616 $prfarg#16617) (-> $prms#16162 (ms-threshold $ms#7293))))
(prfarg msT and prms (ms-threshold 6))
(bct: (minsupport FACT2) (-> (⍃ 6 5) (minsup (, (, (Inheritance $x#8264 sodaDrinker) (Inheritance $x#8264 human)) (Inheritance $x#8264 woman)))))
(prms: (ms-threshold $ms#7293) and (-> (⍃ $ms#7293 5) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 ugly)) (Inheritance $x#8264 woman)))))
(First: (: ($prfabs#18114 $prfarg#18115) (ms-threshold $ms#7293)))
(First: (: ($prfabs#18571 $prfarg#18572) (-> $prms#18117 (ms-threshold $ms#7293))))
(prfarg msT and prms (ms-threshold 6))
(bct: (minsupport FACT1) (-> (⍃ 6 5) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 ugly)) (Inheritance $x#8264 woman)))))
(prms: (⍃ 6 8) and (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man))))
(First: (: ($prfabs#20185 $prfarg#20186) (⍃ 6 8)))
(First: (: ($prfabs#20969 $prfarg#20970) (-> $prms#20188 (⍃ 6 8))))
(First: (: ($prfabs#21417 $prfarg#21418) (-> $prms#20972 (-> $prms#20188 (⍃ 6 8)))))
(prfarg CPU and prms (⍃ 6 8))
(bct: ((minsupport FACT4) msT) (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man))))
(prms: (⍃ 6 4) and (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 sodaDrinker)) (Inheritance $x#8264 man))))
(First: (: ($prfabs#23255 $prfarg#23256) (⍃ 6 4)))
(First: (: ($prfabs#24014 $prfarg#24015) (-> $prms#23258 (⍃ 6 4))))
(First: (: ($prfabs#24462 $prfarg#24463) (-> $prms#24017 (-> $prms#23258 (⍃ 6 4)))))
(prms: (⍃ 6 5) and (minsup (, (, (Inheritance $x#8264 sodaDrinker) (Inheritance $x#8264 human)) (Inheritance $x#8264 woman))))
(First: (: ($prfabs#25526 $prfarg#25527) (⍃ 6 5)))
(First: (: ($prfabs#26285 $prfarg#26286) (-> $prms#25529 (⍃ 6 5))))
(First: (: ($prfabs#26733 $prfarg#26734) (-> $prms#26288 (-> $prms#25529 (⍃ 6 5)))))
(prms: (⍃ 6 5) and (minsup (, (, (Inheritance $x#8264 human) (Inheritance $x#8264 ugly)) (Inheritance $x#8264 woman))))
(First: (: ($prfabs#27797 $prfarg#27798) (⍃ 6 5)))
(First: (: ($prfabs#28556 $prfarg#28557) (-> $prms#27800 (⍃ 6 5))))
(First: (: ($prfabs#29004 $prfarg#29005) (-> $prms#28559 (-> $prms#27800 (⍃ 6 5)))))




;!(eval (filter-atom (a (b) $c) $x (eval (if-error $x False True))))
;!(eval (filter-atom (a (b) $c) $x (eval (== (get-metatype $x) Variable))))
(= (iss-variable $x) (not (== (get-metatype $x) Variable)))
;!(iss-variable 4)
;!(eval (filter-atom (a (Error (b) \"Test error\") $c) $x (eval (if-error $x False True))))
;! (filter-atom (a (b) $c 2 3) $x  (is-number $x))

(: filterr-atom (-> Expression Expression Expression))
(= (filterr-atom $list  $filterr)
  (function (eval (if-decons-expr $list $head $tail
    (chain (eval (filterr-atom $tail  $filterr)) $tail-filterred
      (chain (eval ($filterr $head)) $filterr-expr
        (chain $filterr-expr $is-filterred
          (eval (if $is-filterred
            (chain (cons-atom $head $tail-filterred) $res (return $res))
            (return $tail-filterred) )))))
    (return ()) ))))
    
;!(filterr-atom (a (b) $c 2 3) $x (eval (is-number $x)))

;!(eval (filterr-atom (a (b) $c) $x (eval (if-equal Variable Variable True False))))

;!(eval (filterr-atom (a (b) $c) $x (eval (if-error $x False True))))
;!(atom-subst 5 $x (is-number $x))

(= (atom-subs-customm $atom $var $templ)
   (function (chain  $atom $var (chain (eval $templ) $res (return $res))))) 



(= (filter-custommm $list $var $filter)
  (if-decons-expr $list $head $tail
    (chain  (filter-custom $tail $var $filter) $tail-filtered
       (chain  (atom-subst $head $var $filter) $filter-exp 
                   (cons-atom $filter-exp $tail-filtered)))
      (return ()) ))


(= (ch1 ($x $y))  () )


(= (filter-custom1 $list $filter ) (
  if (== $list ()) () (
    let  ($head $tail) (decons-atom $list)
          (let $tail-filtered (filter-custom1 $tail  $filter ) 
             (let $filter-exp   ($filter $head) 
                (if $filter-exp  (cons-atom $head $tail-filtered) $tail-filtered)) ) )
  )
)

(= (filter-custom $list $filter )  (
  if (== $list ()) () (
    let  ($head $tail) (decons-atom $list)
          (let $tail-filtered (filter-custom $tail $filter  )
             (let $x  $head 
             (let $filter-exp  $filter  
                (if $filter-exp  (cons-atom $head $tail-filtered) $tail-filtered))) ) )
  ))


(= (filter-var $list $var ) (
  if (== $list ()) () (
    let  ($head $tail) (decons-atom $list)
          (let $tail-filtered (filter-var $tail  $var ) 
             (let $filter-exp   (== (car-atom $head) $var) 
                (if $filter-exp  (cons-atom $head $tail-filtered) $tail-filtered)) ) )
  )
)



;!(eval (== (eval (car-atom ($x 1))) $x))
;!(ch1 (x 2))

;!(eval (filter-var  (($x 1) ($y 2) (2 $x) ($x 4)) $x))

;!(eval (filter-atom (1 2 3) $x (eval (< $x 3))))

;!(eval (filter-custom1 (a (b) $c 2 3)  is-number ))

;!(atom-subs-custom 1 $x  (< $x 3))


(chain (collapse (syn $kb $k (: $prfargg $prmss))) $res2  
                 (chain ((remove-parenthesis (cdr-atom $res2))) $res2-in 
                    (map-atom $res2-in $var2 (unify (: $prfargg2 $prms2)  $var2 (: ($prfabss $prfargg2) $cclnn) (j)))))


(= (synn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (let* (((: $prfabs (-> $prms $ccln)) (syn $kb $k (: $prfabs (-> $prms $ccln))))  
          ((: $prfarg $prms) (syn $kb $k (: $prfarg $prms))))                       
     (: ($prfabs $prfarg) $ccln)))


;; Base case
(= (syn $kb $_ (: $prf $ccln)) (match $kb (: $prf $ccln) (: $prf $ccln)))

;; Recursive step
(= (syn $kb (S $k) (: ($prfabs $prfarg) $ccln))
   (chain  (collapse (syn $kb $k (: $prfabs (-> $prms $ccln)))) $res  
          (chain (remove-parenthesis (cdr-atom $res)) $res-in 
            (map-atom $res-in $var (unify (: $prfabss (-> $prmss $cclnn)) $var 
               (chain (collapse (syn $kb $k (: $prfargg $prmss))) $res2  
                 (chain ((remove-parenthesis (cdr-atom $res2))) $res2-in 
                    (map-atom $res2-in $var2 (unify (: $prfargg2 $prms2)  $var2 (: ($prfabss $prfargg2) $cclnn) (j))))) $res-in)))))



(function (eval (chain   ((: ruleone (-> (minsup $ptrn) (surp $ptrn $value)))
                       (: ruleTwo (-> (minsup $ptrn) (surp  $ptrn $value))) ) )
                        $res 
                            (eval (map-atom $res $var (eval (unify  $var (: $prfabs (-> $prms $ccln)) (return Yes) (return ($prfabs and $var))))))
))



!(chain (
       (: ruleTwo (-> (minsup $ptrn) (surp $ptrn $value)))
       (: rule (-> (minsup $ptrn) (surp  $ptrn $value))) 
       ) 
       $res
      (map-atom $res $var (unify  (: $prfabs (-> $prms $ccln))  $var  Yes  ($prfabs and $var)))) 


;;(: cog-mine (-> db         ;; Data base space 
                ms         ;; Minimum support
                           ;; Minimum support. All patterns with count below
                           ;; ms are discarded.

                cnjexp     ;; Conjunction expansion
                           ;; Flag whether to use the conjunctions expansion
                           ;; heuristic rules. It will only expand conjunctions with enough support
                           ;; with patterns with enough support.

                maxcnj     ;; Maximum number of conjunctions
                           ;; Maximum number of conjuncts of a pattern
                           ;; to apply shallow specialization to, which can be very expensive
                           ;; when applied to patterns with more than 1 conjunct.
                           ;; Any value between 0 and the number of conjuncts of the initial
                           ;; pattern (excluded) will disable shallow specialization.

                max-cnjexp-variables   ;; Maximum number of variables in conjunction expansion
                                       ;; Maximum number of variables in patterns produced
                                       ;; by the conjunction expansion rule.

                surp        ;; Surprisingness measure 
                            ;; After running the pattern miner,
                            ;; patterns can be ranked according to a surprisingness measure.
                            ;; The following supported modes are:
                            ;;    'isurp-old:  Verbatim port of Shujing I-Surprisingness.
                            ;;    'nisurp-old: Verbatim port of Shujing normalized I-Surprisingness.
                            ;;    'isurp:      New implementation of I-Surprisingness that takes
                            ;;            l    linkage into account.
                            ;;    'nisurp:     New implementation of normalized I-Surprisingness
                            ;;                 that takes linkage into account.
                            ;;    'jsdsurp:    Jensen-Shannon Distance based surprisingness.
                            ;;                 The type of surprisingness is determined by the way
                            ;;                 the truth value estimate is calculated.
                            ;;    'none:       No surprisingness measure is applied.
                            ;;    If a surprisingness measure is selected then the pattern miner returns
                            ;;     list of patterns each wrapped in an surp expression with
                            ;;    their surprisingness. Otherwise, if 'none' is selected then it returns a list of patterns.

                db-ratio    ;; db-ratio
                            ;; Controls downsampling for estimating empirical probability in surprisingness measures.  
                            ;; Downsampling reduces computational cost while maintaining accuracy.  
                            ;; Indicates the proportion of the dataset used for pattern count estimation.  
                            ;; dbr < 1 → more efficient, less accurate  
                            ;; dbr > 1 → less efficient, more accurate  
                            ;; Range: (0, +∞), default = 1.0  
                            ;; Affects only surprisingness, not frequent mining.  

;;))

;; $cnjexp $maxcnj $maxcevar




---------------------------------------------------------------------------
;; initializes the necessary input parameters in the KB
;;configures and runs the frequent pattern miner with conjunction expansion
;;proceeds to surprisingness pattern mining using the backward chainer 
;;Store the chainer result in to the &res (new space)
----------------------------------------------------------------------------




[
  (Error (assertEqual (remove-hashtag (syn GroundingSpace-0x1205d81d8 (fromNumber 19) (: $prf (Isurp $pattern $surp)))) 
(: ((((((isurp normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
((emp-prob-rule (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB)) 
((((est-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (partitions CPUPARTN)) CPUESTPROB)) 
((dst-from-interval CPU) CPUDST)) MINIMUMCPU) (Isurp (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) 0.00014607068574401343))) 

"\nExpected: [(Error (((((isurp normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
((emp-prob-rule (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB)) 
((((est-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
(partitions CPUPARTN)) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) BadType)]\nGot: 
[(: ((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
(((emp-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB)) 
((((est-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (partitions CPUPARTN)) CPUESTPROB)) 
((dst-from-interval CPU) CPUDST)) MINIMUMCPU) (Isurp (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) 0.00014607068574401343))]

\nMissed results: (Error (((((isurp normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
((emp-prob-rule (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB))
 ((((est-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
 (partitions CPUPARTN)) CPUESTPROB)) ((dst-from-interval CPU) CPUDST)) BadType)

 \nExcessive results: (: ((((((isurp-rule normalize) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) 
 (((emp-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) CPUPROB)) 
 ((((est-prob-rule surpMode) (((universal-count (((minsupport FACT4) msT) CPU)) dbsize) CPUUNIVERSAL)) (partitions CPUPARTN)) CPUESTPROB)) 
 ((dst-from-interval CPU) CPUDST)) MINIMUMCPU) (Isurp (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) 0.00014607068574401343))")]
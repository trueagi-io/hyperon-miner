!(import! &self "../../utils/surp-utils/boost_petta.py")
!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/index_to_var)
!(import! &self  ../../utils/constants)
!(import! &self  ../../utils/TruthValue)
!(import! &self ../../utils/surp-utils/partition-metta)



;;import surp components 
!(import! &self  ../../utils/surp-utils/binomialMetta)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self  ../../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/IIsurp_utils)



!(import! &self ../../utils/sort)
!(import! &self ../../utils/variable-combinations)
!(import! &self ../../utils/surp-utils/blk-abstractness)
!(import! &self ../../utils/remove_useless_clauses)
!(import! &self ../../utils/surp-utils/eq-prob-petta)
!(import! &self ../../utils/surp-utils/bs-utils)
!(import! &self ../../utils/surp-utils/jsd-helper)

!(import! &self ../../truth-values/est-tv)
!(import! &self ../../truth-values/emp-tv)
!(import! &self ../../surprisingness/emp-prob)
!(import! &self ../../surprisingness/isurp)
!(import! &self ../../surprisingness/isurp-old)
!(import! &self ../../surprisingness/jsd)
!(import! &self ../../surprisingness/IIsurp-old)

!(import! &self ../../frequent-pattern-miner/valuation)
!(import! &self ../../frequent-pattern-miner/shallow-abstractions)
!(import! &self ../../frequent-pattern-miner/specialization)
!(import! &self ../../frequent-pattern-miner/candidate)
!(import! &self ../../frequent-pattern-miner/conjunction-expansion)
!(import! &self ../../frequent-pattern-miner/frequent-pattern-miner-generic)
!(import! &self ../pattern-miner)


;; import kb
!(import! &db ../../data/ugly_man_sodaDrinker)









;---------------------------------------------------
;; mine frequent patterns without surprissingness 
;---------------------------------------------------
;; number of conjucts 2 , so the depth will be 0
;; surprissingness mode none
;; minimum support 10
;;(pattern-miner $kb $db $minsup $depth $surp-mode $normalization $db-ratio $conj_exp)

(pattern-miner &res1 &db $x 10 0 none none none True) 
(assertEqual (collapse (get-atoms &res1))
;;Expected result 
        (
                (supportOf (, (Inheritance $_627562 sodaDrinker) (Inheritance $_627562 human)) 10)
                (supportOf (, (Inheritance $_627484 sodaDrinker) (Inheritance $_627484 $_627514)) 35)
                (supportOf (, (Inheritance $_627406 human) (Inheritance $_627406 ugly)) 10)
                (supportOf (, (Inheritance $_627328 ugly) (Inheritance $_627328 $_627358)) 35)
                (supportOf (, (Inheritance $_627250 human) (Inheritance $_627250 woman)) 10)
                (supportOf (, (Inheritance $_627172 woman) (Inheritance $_627172 $_627202)) 30)
                (supportOf (, (Inheritance $_627094 human) (Inheritance $_627094 man)) 10)
                (supportOf (, (Inheritance $_627016 $_627022) (Inheritance $_627016 man)) 30)
                (supportOf (, (Inheritance $_626938 human) (Inheritance $_626938 $_626968)) 60)
                (supportOf (, (Inheritance $_626860 man) (Inheritance $_626860 $_626890)) 30)
                (supportOf (, (Inheritance $_626782 $_626788) (Inheritance $_626782 $_626812)) 190)
                (supportOf (, (Inheritance $_626704 $_626710) (Inheritance $_626728 $_626710)) 800)
        )
 )



;----------------------------------------------------------------
;; mine frequent patterns without surprissingness (3 - conjunct)
;----------------------------------------------------------------
;; number of conjucts 3 , so the depth will be 1
;; surprissingness mode none
;; minimum support 10
;;(pattern-miner $kb $db $x $minsup $depth $surp-mode $normalization $db $x-ratio $conj_exp)

(pattern-miner &res2 &db $x 10 1 none none none  True) 
(assertEqual (collapse (get-atoms &res2)) 
(
        (supportOf (, (Inheritance $_498588 sodaDrinker) (Inheritance $_498588 human) (Inheritance $_498588 $_498642)) 35)
        (supportOf (, (Inheritance $_498486 sodaDrinker) (Inheritance $_498486 ugly) (Inheritance $_498486 $_498540)) 20)
        (supportOf (, (Inheritance $_498384 sodaDrinker) (Inheritance $_498384 woman) (Inheritance $_498384 $_498438)) 15)
        (supportOf (, (Inheritance $_498282 sodaDrinker) (Inheritance $_498282 $_498312) (Inheritance $_498282 man)) 20)
        (supportOf (, (Inheritance $_498180 sodaDrinker) (Inheritance $_498180 $_498210) (Inheritance $_498180 $_498234)) 125)
        (supportOf (, (Inheritance $_498078 human) (Inheritance $_498078 ugly) (Inheritance $_498078 $_498132)) 35)
        (supportOf (, (Inheritance $_497976 ugly) (Inheritance $_497976 woman) (Inheritance $_497976 $_498030)) 15)
        (supportOf (, (Inheritance $_497874 ugly) (Inheritance $_497874 $_497904) (Inheritance $_497874 man)) 20)
        (supportOf (, (Inheritance $_497772 ugly) (Inheritance $_497772 $_497802) (Inheritance $_497772 $_497826)) 125)
        (supportOf (, (Inheritance $_497670 human) (Inheritance $_497670 $_497700) (Inheritance $_497670 woman)) 30)
        (supportOf (, (Inheritance $_497568 sodaDrinker) (Inheritance $_497568 $_497598) (Inheritance $_497568 woman)) 15)
        (supportOf (, (Inheritance $_497466 ugly) (Inheritance $_497466 $_497496) (Inheritance $_497466 woman)) 15)
        (supportOf (, (Inheritance $_497364 $_497370) (Inheritance $_497364 woman) (Inheritance $_497364 $_497418)) 90)
        (supportOf (, (Inheritance $_497262 human) (Inheritance $_497262 $_497292) (Inheritance $_497262 man)) 30)
        (supportOf (, (Inheritance $_497160 $_497166) (Inheritance $_497160 man) (Inheritance $_497160 $_497214)) 100)
        (supportOf (, (Inheritance $_497058 human) (Inheritance $_497058 woman) (Inheritance $_497058 $_497112)) 30)
        (supportOf (, (Inheritance $_496956 human) (Inheritance $_496956 $_496986) (Inheritance $_496956 $_497010)) 190)
        (supportOf (, (Inheritance $_496854 woman) (Inheritance $_496854 $_496884) (Inheritance $_496854 $_496908)) 90)
        (supportOf (, (Inheritance $_496752 $_496758) (Inheritance $_496752 $_496782) (Inheritance $_496752 $_496806)) 630)
        (supportOf (, (Inheritance $_496650 $_496656) (Inheritance $_496674 $_496656) (Inheritance $_496698 $_496656)) 12000)
)
)



;----------------------------------------------------------------
;; mine frequent patterns with surprissingness (2 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 2 , so the depth will be 0
;; surprissingness mode -> isurp-old 
;; normalization -> False
;; minimum support ->  10
;;(pattern-miner $kb $db $x $minsup $depth $surp-mode $normalization $db $x-ratio $conj_exp)

(pattern-miner &res3 &db $x 10 0 isurp-old False none True) 
(assertEqual (collapse (get-atoms &res3)) 
;; Expected result
(
        (surprisingnessOf (, (Inheritance $_397368 sodaDrinker) (Inheritance $_397368 human)) 0.005585878898145486)
        (surprisingnessOf (, (Inheritance $_397284 sodaDrinker) (Inheritance $_397284 $_397314)) 0.019582495451498604)
        (surprisingnessOf (, (Inheritance $_397200 human) (Inheritance $_397200 ugly)) 0.005585878898145486)
        (surprisingnessOf (, (Inheritance $_397116 ugly) (Inheritance $_397116 $_397146)) 0.019582495451498604)
        (surprisingnessOf (, (Inheritance $_397032 human) (Inheritance $_397032 woman)) 0.005585878898145486)
        (surprisingnessOf (, (Inheritance $_396948 woman) (Inheritance $_396948 $_396978)) 0.01675763669443646)
        (surprisingnessOf (, (Inheritance $_396864 human) (Inheritance $_396864 man)) 0.005585878898145486)
        (surprisingnessOf (, (Inheritance $_396780 human) (Inheritance $_396780 $_396810)) 0.03351527338887292)
        (surprisingnessOf (, (Inheritance $_396696 man) (Inheritance $_396696 $_396726)) 0.01675763669443646)
        (surprisingnessOf (, (Inheritance $_396612 $_396618) (Inheritance $_396612 $_396642)) 0.10619553768074302)
        (surprisingnessOf (, (Inheritance $_396528 $_396534) (Inheritance $_396552 $_396534)) 0.45082830604232477)
))
;----------------------------------------------------------------
;; mine frequent patterns with surprissingness (2 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 2 , so the depth will be 0
;; surprissingness mode -> isurp 
;; normalization -> True
;; minimum support ->  5
;;(pattern-miner $kb $db $x $minsup $depth $surp-mode $normalization $db $x-ratio $conj_exp)

(pattern-miner &res4 &db $x 5 0 isurp True 0.2 True) 
(assertEqual (collapse (get-atoms &res4))
;; Expected result
  
(
        (surprisingnessOf (, (Inheritance $_993022 sodaDrinker) (Inheritance $_993022 ugly)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992938 sodaDrinker) (Inheritance $_992938 woman)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992854 sodaDrinker) (Inheritance $_992854 man)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992770 sodaDrinker) (Inheritance $_992770 human)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992686 sodaDrinker) (Inheritance $_992686 $_992716)) 0.7142857142857143)
        (surprisingnessOf (, (Inheritance $_992602 ugly) (Inheritance $_992602 woman)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992518 ugly) (Inheritance $_992518 man)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992434 ugly) (Inheritance $_992434 human)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992350 ugly) (Inheritance $_992350 $_992380)) 0.7142857142857143)
        (surprisingnessOf (, (Inheritance $_992266 woman) (Inheritance $_992266 human)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992182 woman) (Inheritance $_992182 $_992212)) 0.6666666666666667)
        (surprisingnessOf (, (Inheritance $_992098 man) (Inheritance $_992098 human)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_992014 man) (Inheritance $_992014 $_992044)) 0.6666666666666667)
        (surprisingnessOf (, (Inheritance $_991930 human) (Inheritance $_991930 $_991960)) 0.6666666666666667)
        (surprisingnessOf (, (Inheritance $_991846 $_991852) (Inheritance $_991846 $_991876)) 0.6842105263157894)
        (surprisingnessOf (, (Inheritance $_991762 $_991768) (Inheritance $_991786 $_991768)) 0.925)
))


;----------------------------------------------------------------
;; mine frequent patterns with surprissingness (3 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 3 , so the depth will be 1
;; surprissingness mode -> isurp 
;; normalization -> true
;; minimum support ->  5

;!(bind! &res5 (new-space)). 

(pattern-miner &res5 &db $x 5 1 isurp True 0.2 True) 
(assertEqual (collapse (get-atoms &res5 ))
;; Expected result
(
        (surprisingnessOf (, (Inheritance $_643210 sodaDrinker) (Inheritance $_643210 ugly) (Inheritance $_643210 man)) 0.8333333333333334)
        (surprisingnessOf (, (Inheritance $_643102 sodaDrinker) (Inheritance $_643102 ugly) (Inheritance $_643102 human)) 0.6666666666666665)
        (surprisingnessOf (, (Inheritance $_642994 sodaDrinker) (Inheritance $_642994 ugly) (Inheritance $_642994 $_643048)) 0.7083333333333334)
        (surprisingnessOf (, (Inheritance $_642886 sodaDrinker) (Inheritance $_642886 human) (Inheritance $_642886 woman)) 0.6666666666666665)
        (surprisingnessOf (, (Inheritance $_642778 sodaDrinker) (Inheritance $_642778 woman) (Inheritance $_642778 $_642832)) 0.6111111111111112)
        (surprisingnessOf (, (Inheritance $_642670 sodaDrinker) (Inheritance $_642670 man) (Inheritance $_642670 human)) 0.6666666666666665)
        (surprisingnessOf (, (Inheritance $_642562 sodaDrinker) (Inheritance $_642562 man) (Inheritance $_642562 $_642616)) 0.7083333333333334)
        (surprisingnessOf (, (Inheritance $_642454 sodaDrinker) (Inheritance $_642454 human) (Inheritance $_642454 $_642508)) 0.6666666666666667)
        (surprisingnessOf (, (Inheritance $_642346 sodaDrinker) (Inheritance $_642346 $_642376) (Inheritance $_642346 $_642400)) 0.24000000000000005)
        (surprisingnessOf (, (Inheritance $_642238 ugly) (Inheritance $_642238 human) (Inheritance $_642238 woman)) 0.6666666666666665)
        (surprisingnessOf (, (Inheritance $_642130 ugly) (Inheritance $_642130 woman) (Inheritance $_642130 $_642184)) 0.6111111111111112)
        (surprisingnessOf (, (Inheritance $_642022 ugly) (Inheritance $_642022 man) (Inheritance $_642022 human)) 0.6666666666666665)
        (surprisingnessOf (, (Inheritance $_641914 ugly) (Inheritance $_641914 man) (Inheritance $_641914 $_641968)) 0.7083333333333334)
        (surprisingnessOf (, (Inheritance $_641806 ugly) (Inheritance $_641806 human) (Inheritance $_641806 $_641860)) 0.6666666666666667)
        (surprisingnessOf (, (Inheritance $_641698 ugly) (Inheritance $_641698 $_641728) (Inheritance $_641698 $_641752)) 0.24000000000000005)
        (surprisingnessOf (, (Inheritance $_641590 human) (Inheritance $_641590 woman) (Inheritance $_641590 $_641644)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_641482 woman) (Inheritance $_641482 $_641512) (Inheritance $_641482 $_641536)) 0.0)
        (surprisingnessOf (, (Inheritance $_641374 man) (Inheritance $_641374 human) (Inheritance $_641374 $_641428)) 0.6666666666666666)
        (surprisingnessOf (, (Inheritance $_641266 man) (Inheritance $_641266 $_641296) (Inheritance $_641266 $_641320)) 0.05000000000000016)
        (surprisingnessOf (, (Inheritance $_641158 human) (Inheritance $_641158 $_641188) (Inheritance $_641158 $_641212)) 1.2325666802993103e-16)
        (surprisingnessOf (, (Inheritance $_641050 $_641056) (Inheritance $_641050 $_641080) (Inheritance $_641050 $_641104)) 0.09523809523809525)
        (surprisingnessOf (, (Inheritance $_640942 $_640948) (Inheritance $_640966 $_640948) (Inheritance $_640990 $_640948)) 0.19999999999999993)
)

)

;----------------------------------------------------------------
;; mine frequent patterns with surprissingness (3 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 3 , so the depth will be 1
;; surprissingness mode -> isurp 
;; normalization -> False
;; minimum support ->  5


(pattern-miner &res6 &db $x 5 1 isurp False 0.2 True) 
(assertEqual (collapse (get-atoms &res6))
;; Expected result
((surprisingnessOf (, (Inheritance $_668334 sodaDrinker) (Inheritance $_668334 ugly) (Inheritance $_668334 man)) 1.9290123456790123e-05)
(surprisingnessOf (, (Inheritance $_668226 sodaDrinker) (Inheritance $_668226 ugly) (Inheritance $_668226 human)) 1.5432098765432096e-05)
(surprisingnessOf (, (Inheritance $_668118 sodaDrinker) (Inheritance $_668118 ugly) (Inheritance $_668118 $_668172)) 6.558641975308642e-05)
(surprisingnessOf (, (Inheritance $_668010 sodaDrinker) (Inheritance $_668010 human) (Inheritance $_668010 woman)) 1.5432098765432096e-05)
(surprisingnessOf (, (Inheritance $_667902 sodaDrinker) (Inheritance $_667902 woman) (Inheritance $_667902 $_667956)) 4.243827160493828e-05)
(surprisingnessOf (, (Inheritance $_667794 sodaDrinker) (Inheritance $_667794 man) (Inheritance $_667794 human)) 1.5432098765432096e-05)
(surprisingnessOf (, (Inheritance $_667686 sodaDrinker) (Inheritance $_667686 man) (Inheritance $_667686 $_667740)) 6.558641975308642e-05)
(surprisingnessOf (, (Inheritance $_667578 sodaDrinker) (Inheritance $_667578 human) (Inheritance $_667578 $_667632)) 0.0001080246913580247)
(surprisingnessOf (, (Inheritance $_667470 sodaDrinker) (Inheritance $_667470 $_667500) (Inheritance $_667470 $_667524)) 0.00013888888888888892)
(surprisingnessOf (, (Inheritance $_667362 ugly) (Inheritance $_667362 human) (Inheritance $_667362 woman)) 1.5432098765432096e-05)
(surprisingnessOf (, (Inheritance $_667254 ugly) (Inheritance $_667254 woman) (Inheritance $_667254 $_667308)) 4.243827160493828e-05)
(surprisingnessOf (, (Inheritance $_667146 ugly) (Inheritance $_667146 man) (Inheritance $_667146 human)) 1.5432098765432096e-05)
(surprisingnessOf (, (Inheritance $_667038 ugly) (Inheritance $_667038 man) (Inheritance $_667038 $_667092)) 6.558641975308642e-05)
(surprisingnessOf (, (Inheritance $_666930 ugly) (Inheritance $_666930 human) (Inheritance $_666930 $_666984)) 0.0001080246913580247)
(surprisingnessOf (, (Inheritance $_666822 ugly) (Inheritance $_666822 $_666852) (Inheritance $_666822 $_666876)) 0.00013888888888888892)
(surprisingnessOf (, (Inheritance $_666714 human) (Inheritance $_666714 woman) (Inheritance $_666714 $_666768)) 9.259259259259259e-05)
(surprisingnessOf (, (Inheritance $_666606 woman) (Inheritance $_666606 $_666636) (Inheritance $_666606 $_666660)) 0.0)
(surprisingnessOf (, (Inheritance $_666498 man) (Inheritance $_666498 human) (Inheritance $_666498 $_666552)) 9.259259259259259e-05)
(surprisingnessOf (, (Inheritance $_666390 man) (Inheritance $_666390 $_666420) (Inheritance $_666390 $_666444)) 2.3148148148148225e-05)
(surprisingnessOf (, (Inheritance $_666282 human) (Inheritance $_666282 $_666312) (Inheritance $_666282 $_666336)) 1.0842021724855044e-19)
(surprisingnessOf (, (Inheritance $_666174 $_666180) (Inheritance $_666174 $_666204) (Inheritance $_666174 $_666228)) 0.00027777777777777783)
(surprisingnessOf (, (Inheritance $_666066 $_666072) (Inheritance $_666090 $_666072) (Inheritance $_666114 $_666072)) 0.011111111111111106))

)




;----------------------------------------------------------------
;; mine frequent patterns with jsd surprissingness (3 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 3 , so the depth will be 1
;; surprissingness mode -> jsd
;; minimum support ->  3



(pattern-miner &res7 &db $x 5 1 jsd none 0.2 True) 
(assertEqual (collapse (get-atoms &res7)) 
;; Expected result 
(
        
(surprisingnessOf (, (Inheritance $_767112 sodaDrinker) (Inheritance $_767112 ugly) (Inheritance $_767112 man)) 0.8507324751176)
(surprisingnessOf (, (Inheritance $_767004 sodaDrinker) (Inheritance $_767004 ugly) (Inheritance $_767004 human)) 0.8548398421185)
(surprisingnessOf (, (Inheritance $_766896 sodaDrinker) (Inheritance $_766896 ugly) (Inheritance $_766896 $_766950)) 0.8612575913482)
(surprisingnessOf (, (Inheritance $_766788 sodaDrinker) (Inheritance $_766788 human) (Inheritance $_766788 woman)) 0.8548398421185)
(surprisingnessOf (, (Inheritance $_766680 sodaDrinker) (Inheritance $_766680 woman) (Inheritance $_766680 $_766734)) 0.8612590633821)
(surprisingnessOf (, (Inheritance $_766572 sodaDrinker) (Inheritance $_766572 man) (Inheritance $_766572 human)) 0.8548398421185)
(surprisingnessOf (, (Inheritance $_766464 sodaDrinker) (Inheritance $_766464 man) (Inheritance $_766464 $_766518)) 0.8612575913482)
(surprisingnessOf (, (Inheritance $_766356 sodaDrinker) (Inheritance $_766356 human) (Inheritance $_766356 $_766410)) 0.8612531390662)
(surprisingnessOf (, (Inheritance $_766248 sodaDrinker) (Inheritance $_766248 $_766278) (Inheritance $_766248 $_766302)) 0.8612252606634)
(surprisingnessOf (, (Inheritance $_766140 ugly) (Inheritance $_766140 human) (Inheritance $_766140 woman)) 0.8548398421185)
(surprisingnessOf (, (Inheritance $_766032 ugly) (Inheritance $_766032 woman) (Inheritance $_766032 $_766086)) 0.8612590633821)
(surprisingnessOf (, (Inheritance $_765924 ugly) (Inheritance $_765924 man) (Inheritance $_765924 human)) 0.8548398421185)
(surprisingnessOf (, (Inheritance $_765816 ugly) (Inheritance $_765816 man) (Inheritance $_765816 $_765870)) 0.8612575913482)
(surprisingnessOf (, (Inheritance $_765708 ugly) (Inheritance $_765708 human) (Inheritance $_765708 $_765762)) 0.8612531390662)
(surprisingnessOf (, (Inheritance $_765600 ugly) (Inheritance $_765600 $_765630) (Inheritance $_765600 $_765654)) 0.8612252606634)
(surprisingnessOf (, (Inheritance $_765492 human) (Inheritance $_765492 woman) (Inheritance $_765492 $_765546)) 0.8612546292081)
(surprisingnessOf (, (Inheritance $_765384 woman) (Inheritance $_765384 $_765414) (Inheritance $_765384 $_765438)) 0.8612363427871)
(surprisingnessOf (, (Inheritance $_765276 man) (Inheritance $_765276 human) (Inheritance $_765276 $_765330)) 0.8612546292081)
(surprisingnessOf (, (Inheritance $_765168 man) (Inheritance $_765168 $_765198) (Inheritance $_765168 $_765222)) 0.8612332080994)
(surprisingnessOf (, (Inheritance $_765060 human) (Inheritance $_765060 $_765090) (Inheritance $_765060 $_765114)) 0.8612038426398)
(surprisingnessOf (, (Inheritance $_764952 $_764958) (Inheritance $_764952 $_764982) (Inheritance $_764952 $_765006)) 0.8610271496573)
(surprisingnessOf (, (Inheritance $_764844 $_764850) (Inheritance $_764868 $_764850) (Inheritance $_764892 $_764850)) 0.8034689893858)
))




;----------------------------------------------------------------
;; mine frequent patterns with IIsurp-old surprissingness (3 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 3 , so the depth will be 1
;; surprissingness mode -> IIsurp-old
;; minimum support ->  5



!(pattern-miner &res8 &db $x 5 1 IIsurp-old  False none True) 
!(assertEqual (collapse (get-atoms &res8) )
;; Expected result
((surprisingnessOf (, (Inheritance $_788264 sodaDrinker) (Inheritance $_788264 ugly) (Inheritance $_788264 man)) 0.00010056710257159561)
(surprisingnessOf (, (Inheritance $_788372 sodaDrinker) (Inheritance $_788372 ugly) (Inheritance $_788372 human)) 5.5020821157218e-5)
(surprisingnessOf (, (Inheritance $_788480 sodaDrinker) (Inheritance $_788480 ugly) (Inheritance $_788480 $_788534)) 0.00026562956604324957)
(surprisingnessOf (, (Inheritance $_788588 sodaDrinker) (Inheritance $_788588 human) (Inheritance $_788588 woman)) 5.5020821157218e-5)
(surprisingnessOf (, (Inheritance $_788696 sodaDrinker) (Inheritance $_788696 woman) (Inheritance $_788696 $_788750)) 0.00011951618205727633)
(surprisingnessOf (, (Inheritance $_788804 sodaDrinker) (Inheritance $_788804 man) (Inheritance $_788804 human)) 5.5020821157218e-5)
(surprisingnessOf (, (Inheritance $_788912 sodaDrinker) (Inheritance $_788912 man) (Inheritance $_788912 $_788966)) 0.00026562956604324957)
(surprisingnessOf (, (Inheritance $_789020 sodaDrinker) (Inheritance $_789020 human) (Inheritance $_789020 $_789074)) 0.00047623831092928116)
(surprisingnessOf (, (Inheritance $_789128 sodaDrinker) (Inheritance $_789128 $_789158) (Inheritance $_789128 $_789182)) 0.0019220759059029812)
(surprisingnessOf (, (Inheritance $_789236 ugly) (Inheritance $_789236 human) (Inheritance $_789236 woman)) 5.5020821157218e-5)
(surprisingnessOf (, (Inheritance $_789344 ugly) (Inheritance $_789344 woman) (Inheritance $_789344 $_789398)) 0.00011951618205727633)
(surprisingnessOf (, (Inheritance $_789452 ugly) (Inheritance $_789452 man) (Inheritance $_789452 human)) 5.5020821157218e-5)
(surprisingnessOf (, (Inheritance $_789560 ugly) (Inheritance $_789560 man) (Inheritance $_789560 $_789614)) 0.00026562956604324957)
(surprisingnessOf (, (Inheritance $_789668 ugly) (Inheritance $_789668 human) (Inheritance $_789668 $_789722)) 0.00047623831092928116)
(surprisingnessOf (, (Inheritance $_789776 ugly) (Inheritance $_789776 $_789806) (Inheritance $_789776 $_789830)) 0.0019220759059029812)
(surprisingnessOf (, (Inheritance $_789884 human) (Inheritance $_789884 woman) (Inheritance $_789884 $_789938)) 0.0003301249269433079)
(surprisingnessOf (, (Inheritance $_789992 woman) (Inheritance $_789992 $_790022) (Inheritance $_789992 $_790046)) 0.0008992822180011687)
(surprisingnessOf (, (Inheritance $_790100 man) (Inheritance $_790100 human) (Inheritance $_790100 $_790154)) 0.0003301249269433079)
(surprisingnessOf (, (Inheritance $_790208 man) (Inheritance $_790208 $_790238) (Inheritance $_790208 $_790262)) 0.0011915089859731148)
(surprisingnessOf (, (Inheritance $_790316 human) (Inheritance $_790316 $_790346) (Inheritance $_790316 $_790370)) 0.005549063525078047)
(surprisingnessOf (, (Inheritance $_790424 $_790430) (Inheritance $_790424 $_790454) (Inheritance $_790424 $_790478)) 0.01840055118306582) 
(surprisingnessOf (, (Inheritance $_790532 $_790538) (Inheritance $_790556 $_790538) (Inheritance $_790580 $_790538)) 0.35063113125405443))
)


;----------------------------------------------------------------
;; mine frequent patterns with IIsurp-new surprissingness (3 - conjunct)
;----------------------------------------------------------------
;; number of conjucts -> 3 , so the depth will be 1
;; surprissingness mode -> IIsurp-new
;; minimum support ->  5

(pattern-miner &res9 &db $x 5 1 IIsurp-new False 0.2 True) 
(assertEqual (collapse (get-atoms &res9) ) 
;; Expected result
((surprisingnessOf (, (Inheritance $_304962 sodaDrinker) (Inheritance $_304962 ugly) (Inheritance $_304962 man)) 0.0) 
(surprisingnessOf (, (Inheritance $_305070 sodaDrinker) (Inheritance $_305070 ugly) (Inheritance $_305070 human)) 0.0) 
(surprisingnessOf (, (Inheritance $_305178 sodaDrinker) (Inheritance $_305178 human) (Inheritance $_305178 woman)) 0.0)
(surprisingnessOf (, (Inheritance $_305286 sodaDrinker) (Inheritance $_305286 woman) (Inheritance $_305286 $_305340)) 0.0) 
(surprisingnessOf (, (Inheritance $_305394 sodaDrinker) (Inheritance $_305394 man) (Inheritance $_305394 human)) 0.0)
(surprisingnessOf (, (Inheritance $_305502 ugly) (Inheritance $_305502 human) (Inheritance $_305502 woman)) 0.0) 
(surprisingnessOf (, (Inheritance $_305610 ugly) (Inheritance $_305610 woman) (Inheritance $_305610 $_305664)) 0.0) 
(surprisingnessOf (, (Inheritance $_305718 ugly) (Inheritance $_305718 man) (Inheritance $_305718 human)) 0.0) 
(surprisingnessOf (, (Inheritance $_305826 human) (Inheritance $_305826 woman) (Inheritance $_305826 $_305880)) 0.0) 
(surprisingnessOf (, (Inheritance $_305934 woman) (Inheritance $_305934 $_305964) (Inheritance $_305934 $_305988)) 0.0) 
(surprisingnessOf (, (Inheritance $_306042 man) (Inheritance $_306042 human) (Inheritance $_306042 $_306096)) 0.0) 
(surprisingnessOf (, (Inheritance $_306150 human) (Inheritance $_306150 $_306180) (Inheritance $_306150 $_306204)) 1.0842021724855044e-19) 
(surprisingnessOf (, (Inheritance $_306258 $_306264) (Inheritance $_306258 $_306288) (Inheritance $_306258 $_306312)) 0.00027777777777777783) 
(surprisingnessOf (, (Inheritance $_306366 $_306372) (Inheritance $_306390 $_306372) (Inheritance $_306414 $_306372)) 0.011111111111111106)))





!(import! &self ../utils/common-utils)
!(import! &self ../utils/constants)
!(import! &self ../utils/TruthValue)
!(import! &self ../utils/surp-utils/partition-metta)
!(import! &self ../utils/surp-utils/binomialMetta)
!(import! &self ../utils/surp-utils/beta-dist)
!(import! &self ../utils/surp-utils/surp-utils)
!(import! &self ../utils/surp-utils/blk-abstractness)
!(import! &self ../utils/surp-utils/eq-prob-petta)
!(import! &self ../utils/surp-utils/bs-utils)
!(import! &self ../truth-values/emp-tv)
!(import! &self ../truth-values/est-tv)
!(import! &self ../utils/index_to_var)
!(import! &db ../data/ugly_man_sodaDrinker)
!(import! &self ../surprisingness/emp-prob)
!(import! &self ../surprisingness/isurp)

; ========== ji-tv-est in our implementation versus the classic one =================
;;;; here i have listed out the examples i have tested with, their values on the classic and on our implementation ;;;;

!(test (do-ji-tv-est  &db (,(Inheritance $x ugly) (Inheritance $x man) (Inheritance $x sodaDrinker))) (STV 0 0.00027229280235977334))
; conjunction: (,(Inheritance $x ugly) (Inheritance $x man) (Inheritance $x sodaDrinker))
; result 
;   on our implementation: (STV 0 0.00027229280235977334)
;   on OPEN-COG miner's implementation: (stv 0 0.000272293)

!(test (do-ji-tv-est  &db (,(Inheritance $x woman) (Inheritance $x human) (Inheritance $x sodaDrinker))) (STV 0 0.00021417127964592388))

; conjunction: (,(Inheritance $x woman) (Inheritance $x human) (Inheritance $x sodaDrinker))
; result 
;   on our implementation: (STV 0 0.0002141712796459233)
;   on OPEN-COG miner's implementation: (stv 0 0.000214171)


!(test (do-ji-tv-est  &db (,(Inheritance $x ugly) (Inheritance $x human) (Inheritance $x sodaDrinker))) (STV 0 0.00021417127964592388) )

; conjunction: (,(Inheritance $x ugly) (Inheritance $x human) (Inheritance $x sodaDrinker))
; result 
;   on our implementation: (STV 0 0.0002141712796459233)
;   on OPEN-COG miner's implementation: (stv 0 0.000214171)


!(test (do-ji-tv-est  &db (,(Inheritance $x ugly) (Inheritance $x man))) (STV 0.0027777777777780515 0.0006976744186046523))
; conjunction: (,(Inheritance $x ugly) (Inheritance $x man))
; result 
;   on our implementation: (STV 0.0027777777777780515 0.0006976744186046523)
;   on OPEN-COG miner's implementation: (stv 0.00277778 0.000697674)


!(test (do-ji-tv-est  &db (,(Inheritance $x ugly) (Inheritance $x sodaDrinker))) (STV 0.0027777777777780515 0.0006976744186046523))

; conjunction: (,(Inheritance $x ugly) (Inheritance $x sodaDrinker))
; result 
;   on our implementation: (STV 0.0027777777777780515 0.0006976744186046523)
;   on OPEN-COG miner's implementation: (stv 0.00277778 0.000697674)

!(import! &self ../utils/constants)
!(import! &self ../utils/common-utils)
!(import! &self ../utils/TruthValue)
!(import! &self ../utils/index_to_var)
!(import! &self ../utils/surp-utils/beta-dist)
!(import! &self ../utils/surp-utils/surp-utils)
!(import! &self ../utils/surp-utils/partition-metta)
!(import! &self ../utils/surp-utils/binomialMetta)
!(import! &self ../utils/surp-utils/blk-abstractness)
!(import! &self ../utils/surp-utils/eq-prob-petta)
!(import! &self ../utils/surp-utils/bs-utils)
!(import! &self ../truth-values/est-tv)
!(import! &self ../truth-values/emp-tv)
!(import! &kb ../data/ugly_man_sodaDrinker)


; ===============================
; do_emp_tv Validation 1
; ===============================
!(test (do_emp_tv
   (,
      (Inheritance $x ugly)
      (Inheritance $x man)
      (Inheritance $x sodaDrinker)
   )
   &kb        ; knowledge base: ugly-man-soda-drinker
   1          ; database ratio
) (EMPTV 2.3148148148148147e-5 0.09963099630996311))
; ===============================
; Parameters Info
; ===============================
; Pattern:
;   (, (Inheritance $x ugly)
;       (Inheritance $x man)
;       (Inheritance $x sodaDrinker))

; Corpus:
;   &kb -> ugly-man-soda-drinker

; Database Ratio: 1

; ===============================
; Results
; ===============================
; Our implementation (Hyperon do_emp_tv result with the above parameters): 
;   EMPTV (2.3148148148148147e-5, 0.09963099630996311)
;
; OpenCog miner implementation (do_emp_tv result with the above parameters): 
;   STV (2.31481e-05, 0.099631)




; ===============================
; do_emp_tv Validation 2
; ===============================
!(test (do_emp_tv
   (,
      (Inheritance $x ugly)
      (Inheritance $x man)
   )
   &kb        ; knowledge base: ugly-man-soda-drinker
   1          ; database ratio
) (EMPTV 0.001388888888888889 0.08181818181818183))

; ===============================
; Parameters Info
; ===============================
; Pattern:
;   (, (Inheritance $x ugly)
;       (Inheritance $x man))

; Corpus:
;   &kb -> ugly-man-soda-drinker

; Database Ratio: 1

; ===============================
; Results
; ===============================
; Our implementation (Hyperon do_emp_tv result with the above parameters): 
;   EMPTV (0.001388888888888889, 0.08181818181818183)
;
; OpenCog miner implementation (do_emp_tv result with the above parameters): 
;   STV (0.00138889, 0.0818182)






; ===============================
; do_emp_tv Validation 3
; ===============================
!(test (do_emp_tv
   (,
      (Inheritance $x ugly)
      (Inheritance $x woman)
   )
   &kb        ; knowledge base: ugly-man-soda-drinker
   0.02          ; database ratio
) (EMPTV 0 0.0001249843769528809))


; ===============================
; Parameters Info
; ===============================
; Pattern:
;   (, (Inheritance $x ugly)
;       (Inheritance $x woman))

; Corpus:
;   &kb -> ugly-man-soda-drinker

; Database Ratio: 0.02

; ===============================
; Results
; ===============================
; Our implementation (Hyperon do_emp_tv result with the above parameters): 
;   stv 0 0.0001249843769528809
;
; OpenCog miner implementation (do_emp_tv result with the above parameters): 
;   (stv 0 0.000124984)





; ===============================
; do_emp_tv Validation 4
; ===============================
!(test (do_emp_tv
   (,
      (Inheritance $x ugly)
      (Inheritance $x woman)
      (Inheritance $x sodaDrinker)
   )
   &kb        ; knowledge base: ugly-man-soda-drinker
   0.02          ; database ratio
) (EMPTV 0.0 0.09963099630996311))


; ===============================
; Parameters Info
; ===============================
; Pattern:
;   (, (Inheritance $x ugly)
;       (Inheritance $x woman)
;       (Inheritance $x sodaDrinker))

; Corpus:
;   &kb -> ugly-man-soda-drinker

; Database Ratio: 0.02

; ===============================
; Results
; ===============================
; Our implementation (Hyperon do_emp_tv result with the above parameters): 
;   (stv 0.0 0.09963099630996311)
;
; OpenCog miner implementation (do_emp_tv result with the above parameters): 
;   (stv 0 0.099631)

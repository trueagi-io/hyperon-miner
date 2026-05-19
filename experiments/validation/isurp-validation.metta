; ===============================
; Module & Utility Imports
; ===============================
!(import! &self ../utils/common-utils)
!(import! &self ../utils/surp-utils/partition-metta)
!(import! &self ../utils/surp-utils/binomialMetta)
!(import! &self ../utils/surp-utils/surp-utils)
!(import! &self ../utils/surp-utils/beta-dist)
!(import! &self ../utils/surp-utils/blk-abstractness)
!(import! &self ../utils/surp-utils/eq-prob-petta)
!(import! &self ../utils/surp-utils/bs-utils)
!(import! &self ../utils/TruthValue)
!(import! &self ../utils/constants)
!(import! &self ../truth-values/emp-tv)
!(import! &self ../truth-values/est-tv)
!(import! &self ../utils/index_to_var)
!(import! &self ../surprisingness/emp-prob)
!(import! &self ../surprisingness/isurp)
 
  
!(import! &db ../data/ugly_man_sodaDrinker)
!(import! &dbc ../data/nested_coupled/mock_coupled)
!(import! &dbn ../data/nested_coupled/true_nested)



; ===============================
; isurp Validation 1
; ===============================
; !(isurp 
;    (,
;       (Inheritance $x man)
;       (Inheritance $x ugly)
;       (Inheritance $x sodaDrinker)
;    )
;    &db       ; database: ugly-man-soda-drinker
;    False     ; normalization: False
;    1         ; database ratio
; )
!(test (isurp (, (Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ) &db False 0.2) 1.9290123456790123e-5)

;===================================================================
;isurp validation with equivalent but coupled patterns with the corpus: mock_coupled

!(test  (isurp (, (Inheritance (Person $x) man) (Inheritance (Person $x) ugly) (Inheritance (Person $x) sodaDrinker) ) &dbc False 0.2) 1.9290123456790123e-5)





; ===============================
; Parameters Info
; ===============================
; Pattern:This PR introduces changes to the surprisingness rule base. Based on validation results from the isurp-old implementation, several adjustments were made to ensure consistency and alignment with the functional implementation.

; Key Changes

; Refactored multiple rules to align with the functional implementation of isurp-old.

; Removed dependency on the isurp-old functional implementation.

; Added and configured a dedicated test file for validation.
;   (, (Inheritance $x man)
;       (Inheritance $x ugly)
;       (Inheritance $x sodaDrinker))

; Corpus:
;   &db -> ugly-man-soda-drinker

; Normalization: False
; Database Ratio: 1


; ===============================
; Results
; ===============================
; Our implementation (isurp result with the above parameters): 1.92901e-05
; OpenCog miner implementation (isurp result with the above parameters):  1.92901e-05

 

; ===============================
; isurp Validation 2
; ===============================
!(test (isurp 
   (,
      (Inheritance $x man)
      (Inheritance $x ugly)
      (Inheritance $x sodaDrinker)
   )
   &db       ; database: ugly-man-soda-drinker
   True     ; normalization: True
   1         ; database ratio
) 0.8333333333333334)

; ===============================
; Parameters Info
; ===============================
; Pattern:
;   (, (Inheritance $x man)
;       (Inheritance $x ugly)
;       (Inheritance $x sodaDrinker))

; Corpus:
;   &db -> ugly-man-soda-drinker

; Normalization: True
; Database Ratio: 1


; ===============================
; Results
; ===============================
; Our implementation (isurp result with the above parameters): 0.8333333333333334
; OpenCog miner implementation (isurp result with the above parameters):  0.833333

 

; ===============================
; isurp Validation 3
; ===============================
!(test (isurp 
   (,
      (Inheritance $x man)
      (Inheritance $x ugly)
   )
   &db       ; database: ugly-man-soda-drinker
   False     ; normalization: False
   1         ; database ratio
) 0.000925925925925926)

; ===============================
; Parameters Info
; ===============================
; Pattern:
;   (, (Inheritance $x man)
;       (Inheritance $x ugly))
;      

; Corpus:
;   &db -> ugly-man-soda-drinker

; Normalization: False
; Database Ratio: 1


; ===============================
; Results
; ===============================
; Our implementation (isurp result with the above parameters): 0.000925925925925926
; OpenCog miner implementation (isurp result with the above parameters):  0.000925926




; !(isurp (, (Inheritance (And (And (Person $x) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))

; (Inheritance (And (And (Person $x)   man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))

; (Inheritance (And (And human man)   (Or (Person $x) (Person Mike)))   (Or (And human man)   (And human sodaDrinker)))

; (Inheritance (And (And (Person $x) man) (Or human ugly))        (Or (And human man) (And human sodaDrinker)))) &dbn False 1)

!(test (isurp (, (Inheritance (And (And (Person $x) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
(Inheritance (And (And (Person $x)   man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))
) &dbn False 1) 0.001216)

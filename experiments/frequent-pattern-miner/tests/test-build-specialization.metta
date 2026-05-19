 !(import! &self ../../utils/index_to_var)
 !(import! &self ../build-specialization)
;  !(import! &self ../../utils/common-utils)

!(add-atom &dbspace (Inheritance Abe human))
!(add-atom &dbspace (Inheritance Rio human))
!(add-atom &dbspace (Inheritance Bob human))
!(add-atom &dbspace (Inheritance Mike human))


 !(build-specialization (Inheritance Z (S Z)) &dbspace &specspace)
 !(match &specspace (SpecializationOf $x $y) (SpecializationOf $x $y))
;   expected:
;             (SpecializationOf (Inheritance Z human) (Inheritance Z (S Z))), 
;             (SpecializationOf (Inheritance Rio Z) (Inheritance Z (S Z))), 
;             (SpecializationOf (Inheritance Abe Z) (Inheritance Z (S Z))), 
;             (SpecializationOf (Inheritance Mike Z) (Inheritance Z (S Z))), 
;             (SpecializationOf (Inheritance Bob Z) (Inheritance Z (S Z)))
;       The orders of the atoms in the list may be different.


!(add-atom &dbspace (Inheritance (And (And Abe Rio) Mike) (Or Human Male)))

!(build-specialization (Inheritance Z (S Z)) &dbspace &specspace)

!(match &specspace (SpecializationOf $x $y) (SpecializationOf $x $y))

;   expected:
    ; (SpecializationOf (Inheritance (And (And Z Rio) (S Z)) (S (S Z))) (Inheritance Z (S Z))), 
    ; (SpecializationOf (Inheritance Mike Z) (Inheritance Z (S Z))), (SpecializationOf (Inheritance Z (Or Human (S Z))) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance Z (Or (S Z) (S (S Z)))) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance (And (And Z Rio) Mike) (S Z)) (Inheritance Z (S Z))), 
    ; (SpecializationOf (Inheritance (And Z (S Z)) (S (S Z))) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance (And (And Z (S Z)) (S (S Z))) (S (S (S Z)))) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance (And Z Mike) (S Z)) (Inheritance Z (S Z))), 
    ; (SpecializationOf (Inheritance Z (Or (S Z) Male)) (Inheritance Z (S Z))), (SpecializationOf (Inheritance Abe Z) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance Rio Z) (Inheritance Z (S Z))), (SpecializationOf (Inheritance Z (Or Human Male)) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance (And (And Abe Z) (S Z)) (S (S Z))) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance Z (S Z)) (Inheritance Z (S Z))), (SpecializationOf (Inheritance (And (And Abe Rio) Mike) Z) (Inheritance Z (S Z))), 
    ; (SpecializationOf (Inheritance Z human) (Inheritance Z (S Z))), (SpecializationOf (Inheritance (And (And Z (S Z)) Mike) (S (S Z))) (Inheritance Z (S Z))),
    ; (SpecializationOf (Inheritance (And (And Abe Rio) Z) (S Z)) (Inheritance Z (S Z))), (SpecializationOf (Inheritance (And (And Abe Z) Mike) (S Z)) (Inheritance Z (S Z))), 
    ; (SpecializationOf (Inheritance Bob Z) (Inheritance Z (S Z)))

; the result when there is a depth
; the order of the atoms in the list may be different.



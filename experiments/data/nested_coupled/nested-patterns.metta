; (Inheritance (And (And (Person Allen) man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))
; (Inheritance (And (And (Person Breonna) woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))

; (Inheritance (And (And (Person Sophia) woman) ugly) human)
; (Inheritance (And (And (Person Allen) man) ugly) human)

; (Inheritance (And (Person Abe) man) human)
; (Inheritance (And (Person Jassy) woman) human)

; (Inheritance (And (And (Person Davion) man) human) (Or (Person Davion) man))
; (Inheritance (And (And (Person Jenica) woman) human) (Or (Person Jenica) woman))

; (Inheritance (And (Person Abe) man) sodaDrinker)
; (Inheritance (And (Person Jaleesa) woman) sodaDrinker)

; (Inheritance (And (And human man) (Or (Person Allen) (Person Mike))) (Or (And human man) (And human sodaDrinker)))
; (Inheritance (And (And human woman) (Or (Person Breonna) (Person Kecia))) (Or (And human woman) (And human sodaDrinker)))

; (Inheritance (And (And (Person Hessley) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
; (Inheritance (And (And (Person Lily) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))

;;============================================================

; (Inheritance (And (And (Person Abe) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
; (Inheritance (And (And (Person Cason) man) (Or human ugly)) (Or (And human man) (And human ugly)))
; (Inheritance (And (And (Person Davion) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
; (Inheritance (And (And (Person Hessley) man) (Or human ugly)) (Or (And human man) (And human ugly)))

; (Inheritance (And (And (Person Lily) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
; (Inheritance (And (And (Person Emily) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
; (Inheritance (And (And (Person Lucy) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
; (Inheritance (And (And (Person Sophia) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
; (Inheritance (And (And (Person Alaura) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))

; (Inheritance (And (And (Person Jaleesa) woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))
; (Inheritance (And (And (Person Jassy) woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))
; (Inheritance (And (And (Person Jenica) woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))
; (Inheritance (And (And (Person Kecia) woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))


;;=========================================================================

;; --- Men: intersect on sodaDrinker vs ugly (shared RHS) ---
(Inheritance (And (And (Person Allen) man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
(Inheritance (And (And (Person Abe)   man) (Or human ugly))        (Or (And human man) (And human sodaDrinker)))
(Inheritance (And (And (Person Mike)  man) (Or human sodaDrinker)) (Or (And human man) (And human sodaDrinker)))
(Inheritance (And (And (Person Zac)   man) (Or human ugly))        (Or (And human man) (And human sodaDrinker)))

;; --- Women: intersect on sodaDrinker (shared RHS) ---
(Inheritance (And (And (Person Breonna) woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))
(Inheritance (And (And (Person Jenica)  woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))
(Inheritance (And (And (Person Kecia)   woman) (Or human sodaDrinker)) (Or (And human woman) (And human sodaDrinker)))

;; --- Men: intersect on ugly (shared RHS) ---
(Inheritance (And (And (Person Allen)   man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))
(Inheritance (And (And (Person Cason)   man) (Or human ugly))        (Or (And human man) (And human ugly)))
(Inheritance (And (And (Person Davion)  man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))
(Inheritance (And (And (Person Hessley) man) (Or human ugly))        (Or (And human man) (And human ugly)))

;; --- Women: intersect on ugly (shared RHS) ---
(Inheritance (And (And (Person Lily)   woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
(Inheritance (And (And (Person Emily)  woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
(Inheritance (And (And (Person Lucy)   woman) (Or human ugly)) (Or (And human woman) (And human ugly)))
(Inheritance (And (And (Person Sophia) woman) (Or human ugly)) (Or (And human woman) (And human ugly)))

;; --- Cross-person intersections via Or(Person …) on the LHS ---
(Inheritance (And (And human man)   (Or (Person Allen) (Person Mike)))   (Or (And human man)   (And human sodaDrinker)))
(Inheritance (And (And human man)   (Or (Person Mike)  (Person Zac)))    (Or (And human man)   (And human sodaDrinker)))
(Inheritance (And (And human woman) (Or (Person Breonna) (Person Kecia))) (Or (And human woman) (And human sodaDrinker)))
(Inheritance (And (And human woman) (Or (Person Sophia)  (Person Lily)))  (Or (And human woman) (And human ugly)))

;; --- Same person appears with different RHS (person-level intersection) ---
(Inheritance (And (And (Person Allen) man) (Or human ugly))        (Or (And human man) (And human sodaDrinker)))
(Inheritance (And (And (Person Abe)   man) (Or human sodaDrinker)) (Or (And human man) (And human ugly)))
(Inheritance (And (And (Person Sophia) woman) (Or human ugly))     (Or (And human woman) (And human sodaDrinker)))
(Inheritance (And (And (Person Breonna) woman) (Or human sodaDrinker)) (Or (And human woman) (And human ugly)))

;; --- Attribute-level crisscross (sodaDrinker on LHS, ugly on RHS, and vice versa) ---
(Inheritance (And (And (Person Jenica) woman) (Or human sodaDrinker)) (Or (And human woman) (And human ugly)))
(Inheritance (And (And (Person Davion)  man)  (Or human ugly))        (Or (And human man)   (And human sodaDrinker)))


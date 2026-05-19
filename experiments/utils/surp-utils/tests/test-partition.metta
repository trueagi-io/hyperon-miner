!(import! &self ../../common-utils)
!(import! &self ../partition-metta)



!(partitions-wout-pattern ((Inheritance $x man) (Inheritance $x ugly) (Inheritance $x $y)))

; Expected output
; (
;   (((Inheritance $_197310 man)) ((Inheritance $_197310 ugly)) ((Inheritance $_197310 $_197376))) 
;   (((Inheritance $_197310 man) (Inheritance $_197310 ugly)) ((Inheritance $_197310 $_197376))) 
;   (((Inheritance $_197310 man) (Inheritance $_197310 $_197376)) ((Inheritance $_197310 ugly))) 
;   (((Inheritance $_197310 man)) ((Inheritance $_197310 ugly) (Inheritance $_197310 $_197376)))
; )

!(set-intersection ((Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker)) ((Inheritance $x man) (Inheritance $x ugly) (Inheritance $x sodaDrinker) ))


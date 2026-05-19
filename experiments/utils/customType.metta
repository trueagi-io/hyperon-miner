
(: Pattern Type)
(: ($link $a $b) Pattern)
; (: ($type $a) Pattern)

; (: Inheritance (-> $a $b Pattern))

;type for debrujin indices like Z , (S Z) which are recursive in nature
; (: Deb Type)
; (: Z Deb)
; (: S (-> Deb Deb))


; (: Tuple Type)
; (: ($a $b) Tuple)

(: Nat Type)
(: Z Nat)
(: S (-> Nat Nat))

; (: (get-space) SpaceType)  this is causing problem


(: TruthValue Type)
(: STV (-> Number Number TruthValue))
(: EMPTV (-> Number Number TruthValue))

(: BetaValue Type)
(: Beta (-> Number Number BetaValue))


;(List Pattern) = partition block

;list eg: (List Pattern) for blocks
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;list of list eg: (BList Pattern) for a partition
(: BList (-> $a Type))
(: BNil (BList $a))
(: BCons (-> (List $a) (BList $a) (BList $a)))

;list of partitions returned by generate all partitions: (PList Pattern)
(: PList (-> $a Type))
(: PNil (PList $a))
(: PCons (-> (BList $a) (PList $a) (PList $a)))
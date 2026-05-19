! (register-module! ../../../hyperon-miner)
! (import! &self hyperon-miner:experiments:utils:common-utils)
! (import! &self hyperon-miner:experiments:utils:gen_partition)

 ;;;;;;;;;;;;;;;;;;;;
 ;;; get-clauses ;;;;
 ;;;;;;;;;;;;;;;;;;;;
 ;; It remove And link it it exist in the input expression
 ;; and return the body of the expression
 ;;;;;;;;;;;;;;;;;;;;
 ;; input :  (And (Parent John Kalid) (Parent Jalid Beza) (Parent Nati Abis))
 ;; output :  ( (Parent John Kalid) (Parent Jalid Beza) (Parent Nati Abis) )

; ! (get-clauses (And (Parent John Kalid) (Parent Jalid Beza) (Parent Nati Abis)))

 ;;;;;;;;;;;;;;;;;;
 ;; gen-subsets ;;;
 ;;;;;;;;;;;;;;;;;;
 ;; input type
 ;;   (
 ;;      (Parent John Kalid)
 ;;      (Parent Jalid Beza)
 ;;      (Parent Nati Abis)
 ;;   )
 ;; ;;;;;;;;;;;;;;;
 ;;; output type ;;
 ;;;;;;;;;;;;;;;;;
 ; (
 ; ()
 ; ( (Parent John Kalid))
 ; ( (Parent Jalud Beza))
 ; ( (Parent Nati Abis))
 ; ( (Parent John Kalid) (Parent Jalud Beza))
 ; ( (Parent John Kalid) (Parent Nati Abis))
 ; ( (Parent Jalud Beza) (Parent Nati Abis))
 ; ( (Parent John Kalid) (Parent Jalud Beza) (Parent Nati Abis))
 ; )

; ! (gen-subsets ( (Parent John Kalid)
;         (Parent Jalud Beza)
;         (Parent Nati Abis)
;     )
; )

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;                                 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;; generet-partion-without-pattern ;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;; input type
 ;;   (
 ;;      (Parent John Kalid)
 ;;      (Parent Jalid Beza)
 ;;      (Parent Nati Abis)
 ;;   )
 ;; ;;;;;;;;;;;;;;;
 ;;; output type ;;
 ;;;;;;;;;;;;;;;;;

 ; (
 ;     ( ( (Parent Jalud Beza) (Parent Nati Abis))
 ;         ( (Parent John Kalid))
 ;     )
 ; ( ( (Parent Jalud Beza))
 ;     ( (Parent John Kalid))
 ;     ( (Parent Nati Abis))
 ; )

 ; ( ( (Parent Jalud Beza) (Parent John Kalid))
 ;     ( (Parent Nati Abis))
 ; )

 ; ( ( (Parent Jalud Beza))
 ;     ( (Parent John Kalid) (Parent Nati Abis))
 ; )

 ; )

 ;;;;;;;;;;;;;;;;Simple Example from classic openCog ;;;;;;;;;;;;;;;
 ;;; input pattern = [A, B, C]
 ;; outPut
 ;	 *
 ;	 * [[[A],[C],[B]],
 ;	 *  [[C,A],[B]],
 ;	 *  [[C],[B,A]],
 ;	 *  [[A],[C,B]]]

; ! (generet-partition-without-pattern
;     (
;         (Parent John Kalid)
;         (Parent Jalud Beza)
;         (Parent Nati Abis)
;     )
; )

! (add-reduct &self (= (get-space) (new-space)))

! (add-atom (get-space) (Inheritance John $y))
! (add-atom (get-space) (Inheritance $z $y))
! (add-atom (get-space) (Inheritance $x Abebe))

!(let $pattern (collapse (get-atoms (get-space))) 
    (generet-partition-without-pattern $pattern)
)
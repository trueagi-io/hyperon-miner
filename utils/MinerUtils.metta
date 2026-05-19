!(import! &self DeBruijnIndex)


;; Tuple count grounded python function
;;!(extend-py! ../utils/helper.py)
;; This is very slow, use the grounded python function instead
;;(= (tuple-count $tuple) (if (== $tuple ()) 0 (+ 1 (tuple-count (cdr-atom $tuple)))))

;;;;;;;;;;;;;;;;;;;;;; 
;; Helper for Match ;;
;;;;;;;;;;;;;;;;;;;;;;

!(bind! &candidatespace (new-space))
!(bind! &countedspace (new-space))

(= (get-links $db)
    (match $db ($link $x $y) $link))

(= (specialize $link $db)
    (match $db ($link $x $y) (superpose (($link $x (VarIdx (S Z))) ($link (VarIdx Z) $y)))))

(= (findsupport $sPattern $ms $db)
    (case (match &countedspace $sPattern 1)
        ((Empty (let $cnt (count $sPattern $db)
                    (if (> $cnt $ms) (superpose ((add-atom &candidatespace (candidate $sPattern $cnt))
                                                 (add-atom &countedspace $sPattern)
                                                 (candidate $sPattern $cnt)))
                                     (add-atom &countedspace $sPattern))))
         ($_ Empty))))

(= (support $sPattern $ms $db)
    (let $a (findsupport $sPattern $ms $db) $a))

(= (get-pattern (candidate $pattern $cnt)) $pattern)

(= (all-candidates) (get-atoms &candidatespace))

;;;;;;;;;;;;;;;;;;;;
;; Helper for DTL ;;
;;;;;;;;;;;;;;;;;;;;

!(bind! &abstractions (new-space))
!(bind! &specialization (new-space))

;; Initialization
(= (init-miner $db $kb $msup $highsurp)
    (superpose ((variable-mapping $db $kb $msup)
                (add-atom $kb (: db (refdb $db)))
                (add-atom $kb (: msT (ms_threshold $msup)))
                (add-atom $kb (: hsT (hs_threshold $highsurp)))
                (get-universe-size $db))))

;; Search for Triplets in DB 
;; do variable mapping and generate specializations
(= (variable-mapping $db $kb $msup)
   ;(match $db (: $p ($link $x $y)) ;; To ignore type definition in bio-as)
   (match $db ($link $x $y) 
    (superpose ((build-specialization ($link $x (VarIdx (S Z))) $kb $db $msup)
                (build-specialization ($link (VarIdx Z) $y) $kb $db $msup)
                (add-abstractions ($link (VarIdx Z) (VarIdx (S Z))))))))

(= (build-specialization $sp $kb $db $msup)
   (case (match $kb (: $prf (specialization_with_minsup $sp $aptrn)) $sp)
        ((Empty (let* ((($link $x $y) $sp)
                       ($aptrn ($link (VarIdx Z) (VarIdx (S Z)))))
                    (if (> (count $sp $db) $msup) ;; specialization with minsup
                        (add-atom $kb (: (sp_prf $sp) (specialization_with_minsup $sp $aptrn)))
                        ()))))))

(= (add-abstractions $aptrn)
   (case (match &abstractions $aptrn $aptrn)
        ((Empty (add-atom &abstractions $aptrn)))))

;; Get abstract patterns
(= (abstract-patterns) (match &abstractions $aptrn $aptrn))
(= (abstract-patterns $link) ($link (VarIdx Z) (VarIdx (S Z))))
(= (abstract? $pattern)
   ;; Todo: Use get-type and check arguments if DeBruijnIndex
   (case $pattern ((($link (VarIdx Z) (VarIdx (S Z))) True) ($_ False))))

; Count the number of instances of a pattern in a given db
(= (count $pattern $db)
(let () (println! (count-input $pattern))
    (let $dptrn (Deb2var $pattern (Cons $Xvar (Cons $Yvar Nil)))
           (tuple-count (collapse (match $db $dptrn $dptrn))))))

;; Get universe size of a given db
(= (get-universe-size $dbspace) 
    (add-atom &self 
      (= (universe-size) (let $u (collapse (match $dbspace $x 1)) (tuple-count $u)))))

;; Probability formula
(= (prob $count) (// $count (universe-size)))


;; iSurprisingness formula
(= (iSurprisingness $pattern)
    (case $pattern (
      ((candidate (, $p1 $p2 ) $cnt)
      (let* (($pp1 (prob (count $p1)))
          ($pp2 (prob (count $p2)))
          ($p1p2 (* $pp1 $pp2)) ;; probability estimate 
          ($p (prob $cnt))) ;; empirical
          (// (max (- $p $p1p2) (- $p1p2 $p)) $p)))
      ((candidate (, $p1 $p2 $p3) $cnt)
      (let* (($pp1 (prob (count $p1)))
          ($pp2 (prob (count $p2)))
          ($pp3 (prob (count $p3)))
          ($pp1p2 (prob (count (, $p1 $p2))))
          ($pp1p3 (prob (count (, $p1 $p3))))
          ($pp2p3 (prob (count (, $p2 $p3))))
          ;; probability estimate
          ($maxP (max-of-two (* $pp1p2 $pp3) (max-of-two (* $pp1p3 $pp2) (max-of-two (* $pp2p3 $pp1) (* $pp1 (* $pp2 $pp3))))))
          ($minP (min-of-two (* $pp1p2 $pp3) (min-of-two (* $pp1p3 $pp2) (min-of-two (* $pp2p3 $pp1) (* $pp1 (* $pp2 $pp3))))))
          ($p (prob $cnt))) ;; empirical
          (// (max (- $p $maxP) (- $minP $p)) $p)))
      ($_ 0))))

(= (isurp? ($ptrn $cnt)) (if (> (iSurprisingness (candidate $ptrn $cnt)) (highsurp)) true false))

;; Conjunction rule Helper
(= (conj? $p)
    (case $p
    (((, $clause1 $clause2) True)
     ($_ False))))

;; Pruning conjunctions of the following patterns:
;; 1. Abstract and specialized conjuctions, such as:
;;    (, (likes A $Y) (likes $X $Y))
;; 2. Conjunctions of conjunctions, such as:
;;    (, (, (likes A $y) (likes B $y))
;;       (, (likes C $y) (likes D $y)))
;; Instead, these should be constructed in the following form:
;;    (, (likes A $y) (, (likes B $y) (, (likes C $y) (likes D $y))))

(= (prune? (, $p1 $p2))
   (let () (println! (, $p1 $p2))
   (if (or (abstract? $p1) (abstract? $p2)) True 
    (if (and (conj? $p1) (conj? $p2)) True False))))

;; Todo: disconnected conjunctions
;; create a connection or prune??
;; (, (likes A $Y) (likes $X B)) ; disconnected
;; create a connection through a common variable
;; (, (likes A $Y) (likes $Y B))

;; notion of specializations?
;; Unify variable

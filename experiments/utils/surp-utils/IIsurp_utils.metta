(=(cart-helper-set $n $x $acc) (collapse (cart-helper-set_ $n $x $acc)))
(=(cart-helper-set_ $n $x $acc) 
  (if (> $n 0)

  (let* (
  ($num (superpose $x))
  ;the accumulator here is also undetrministic becuase we are adding superposed elements to it
  
  ($new (cons-atom $num $acc))
  
  )
  ;each time it cals itself, its creating branches with all the elemnts superposed on each previous braches
  (cart-helper-set_ (- $n 1) $x $new)
  )

  $acc
  )

)

(= (cart-helper $lst $acc $db ) (collapse (cart-helper_ $lst $acc $db)))
;the output needs to be collasped by the caller
(=(cart-helper_ $lstofsubpatterns  $acc $db) (if (not (== $lstofsubpatterns ()))

(let* (
  (($head $tail) (decons-atom $lstofsubpatterns))

(($subpat-fir $subcons) $head)
(($link $a $b) $subpat-fir)
; ($subcons  (get-sub-conc-only $head $db))

($subcon-el (superpose $subcons))
;the accumulator here is also undetrministic becuase we are adding superposed elements to it
($new (cons-atom  ($link $a $subcon-el) $acc)))
;each time it cals itself, its creating branches with all the elemnts superposed on each previous braches
(cart-helper_ $tail $new $db)
)

$acc
))


(= (get-conc-prob-for-sub $conc-b $db $total_count)

(let* (
  (($link $a $conc) $conc-b)
  ($coh (coherence $conc $db $link))
 



)
$coh


)



)



(= (rmvEl-iisurp $tar $list)
(collapse (let* (($el (superpose $list)) (($link $var $conc) $el) (($link2 $var2 $conc2) $tar)) (if (and (== $link $link2) (== $conc $conc2)) (empty) $el)))


)

(= (sup-num-iisurp $db $pattern)
    (let $sup (counter-iisurp $db $pattern)
        $sup
    )
)

(= (counter-iisurp $db $ptrn)
    (let $result (collapse (match $db $ptrn $ptrn))
         (tuple-count-iisurp $result)
    )
)

 (= (tuple-count-iisurp $atom) (size-atom $atom))


(=(handle-list-interval $x $acc )
(if (== $x ()) $acc
(let* 
((($head $tail) (decons-atom $x))
($new (union-atom $head $acc))
)
(handle-list-interval $tail $new)


)

)
)

(=(calcom ($Ins1 $Ins2) $db $link)
(if (== $Ins1 $Ins2) (empty) (let* (
  ($fconcs (collapse (match $db ($link $Ins1 $cons1) $cons1)))
  ($scons (collapse (match $db ($link $Ins2 $cons2) $cons2)))
  ($inter (intersection-atom $fconcs $scons))
  ($inter-len (size-atom $inter))
  ($avglen (// (+ (size-atom $fconcs )  (size-atom $scons ) ) 2))
  ($paircoh (// $inter-len $avglen))
  )
  $paircoh
  
  )
)
)

(=(max-factor $coherence) (* 0.4 (// 1 $coherence)))
(=(min-factor $coherence )   (pow-math $coherence 2))

(=(add-the-coherence $pair-H ) (foldl-atom $pair-H 0 $acc $x (+ $acc $x)))
  
(=(dst-from-interval-iisurp $emin $emax $emp) (
  if (< $emax $emp) (- $emp $emax) (if (< $emp $emin ) (- $emin $emp) 0.0)
))

(=(random-coherence) 0.5)


; to measure the coherence of a concept how much the instances that inherit from the concept have in common, we do this by measuring every pair wise coherence among the instances that inherit from the super concept, 

; to measure pairwise coherence we simply measure the ratio of the number of concepts the two instances inherit in common to the average amount of concepts inherited by the two instacns 

(= (coherence $concept $db $link)
(let* (
  ($ins (collapse (match $db ($link $any $concept) $any)))
  ($n (size-atom $ins))
)
(if (<= $n 1) (random-coherence)

  ; helper -> 0.5, 0.5
  (let* (($pairwise  (cart-helper-set 2 $ins ()))

  ; filter pairwise
  ($uniquePairWise (fun $pairwise ()))
  
  ($pair-H  (collapse (calcom (superpose $uniquePairWise) $db $link)))
  
 
 
    ($sum-pair-H (add-the-coherence $pair-H))
 
    ($H-joint-approx  (// (* $sum-pair-H 2) (* $n (- $n 1))))
    

     
    
    )
    $H-joint-approx
    )

)))

( = (fun $pairwise $acc) 
  (
    if (== () $pairwise)
      $acc
      (let*
        (
          ((($head1 $head2) $tail) (decons-atom $pairwise))
        
          
          ($intersection (intersection-atom (($head2 $head1)) $acc))

          ($newAcc (if (== (size-atom $intersection) 0)
          (cons-atom ($head1 $head2) $acc)
          $acc
        ))

        )
        (fun $tail $newAcc))
      
  )
)

(=(n_conjuncts_new-iisurp $pattern) (
   let ($head $tail) (decons-atom $pattern) (
    if (== $head ,) (size-atom $tail) 1)
))

; (= (// $a $b) (/ (* 1.0 $a) $b))

(= (prob-iisurp $pattern $db $total_count) (let $ff (sup-num-iisurp $db $pattern) (// $ff  $total_count)))

(= (db_size-iisurp $db)
     (let $a (collapse (get-atoms $db)) (size-atom $a))
    
) 

(= (calculate_binomial-iisurp $n $k) (calculate_binomial_helper-iisurp (max-atom ($n)) (max-atom ($k)) 1))
(=(cal_binomial-iisurp $n $k) (calculate_binomial-iisurp $n $k))


(= (return-supers ($type $concept))
(if (== $type Super) $concept (empty))

)
(= (return-subs ($type $concept))
(if (== $type Sub) $concept (empty))

)

(=(super-helper $OriIns $concept $originalConcept $type $db)
(if (== $concept $originalConcept ) (empty) (let* (
  ($conIns (collapse (match $db ($link $any $concept) $any )))
  ($inter (intersection-atom $OriIns $conIns))
  
  
  ) 
 

    

    ;striclty superpattern or subpattern 
     (if (== $type super) (if  (and (== (size-atom $OriIns) (size-atom $inter)) (>=(size-atom $conIns) (size-atom $OriIns)))  $concept (empty))

     ( if (== (size-atom $conIns ) (size-atom $inter  )) $concept (empty))
     
      )

    
    ))
)

(=(sub-super-concepts $OriginalInstances $concepts $originalConcept  $type $db  )
(let* (($superCons (collapse (super-helper $OriginalInstances (superpose $concepts) $originalConcept $type $db )))


)
$superCons

)



)

(=(get-instances ($link $instance $concept) $db)
(let* ( ($inst (collapse (match $db ($link $instance $concept) $instance ))))

)
$inst 
)

(=(get-concepts ($link $instance $concept) $db)
(let* (($concepts (collapse (match $db ($link $anyI $anyC) $anyC))))
$concepts
)

)

(= (calculate_binomial_helper-iisurp $n $k $result)
    (if (or (> $k $n ) (< $k 0))
        0
        (if (or (== $k 0) (== $k $n))
            1
            (let*
                (
                    ($temp (/ $n (- $n $k)))
                    ($newResult  (* $temp (calculate_binomial_helper-iisurp (- $n 1) $k $temp)))
                )
                $newResult
            )
        )
    )
)

(=(filter-subpatterns-w-subs $subpattern $db)
(let* ((($link $a $b) $subpattern)
($subcons  (get-sub-conc-only $subpattern $db)))
(if (== $subcons ()) (empty) ($subpattern $subcons))
)
)

(=(filter-subpatterns-w-subs $subpattern $db $conc_db)
(let* ((($link $a $b) $subpattern)


($subcons (collapse (match $conc_db (Inheritance $any $b ) $any))))
(if (== $subcons ()) (empty) ($subpattern $subcons))
)
)

(=(get-sub-conc-only $head $db)
(let* ( (($link $per $conc) $head)
  ($orInst (collapse (match $db ($link $any $conc) $any)))
  ($concepts-raw (collapse (match $db ($link $anyI $anyC) $anyC)))
  
  ($concepts (unique-atom $concepts-raw))
  ( $subcons (sub-super-concepts $orInst $concepts $conc sub $db ))
  
  
  )
  $subcons
  
  )
)

(= (filter-conjuncts $lstofconjuncts) (collapse (filter-common (superpose $lstofconjuncts))))

(= (filter-common $conjunct ) (let* (($lconjucnt (cdr-atom $conjunct))  ($instances (collapse (ret-instances (superpose $lconjucnt) ))) ($uniq (unique-atom $instances)) ($uniq-size (size-atom $uniq)) )

(if (== $uniq-size 1) $conjunct (empty))

))

(=(ret-instances $subpat) (let ($link $per $conc) $subpat $per) )


(=(filter-subpatterns-wout-subs $subpattern $wsubs $db)
(let* (
  ($pats (collapse (return-only-pats (superpose $wsubs) )))
  ($intersec (intersection-atom ($subpattern) $pats))
  ($size (size-atom $intersec))
  
  (($link $a $b) $subpattern)
)
(if (== $size 0)  $subpattern (empty))
)
)

(=(return-only-pats $wsub) (let ($pat $cons) $wsub $pat ) )

(=(dst_from_interval_lift_main $emin $emax $emp) (let* 

(
  ($lift (
  if (< $emax $emp) (// $emp $emax) (if (< $emp $emin ) (//  $emp $emin) 1.0)
))
($ans (abs-math (- 1 $lift )))
($norm-ans (// $ans $emp))
($capped-ans (min-atom (100.0  $norm-ans)))
)

$capped-ans

)

)

(=(iprob_iisurp $partition $db $total_count)(
    if (== $partition ()) () (
        let* (
           ( ($head $tail) (decons-atom $partition))
           ($prob (blk-prob-iisurp $head $db $total_count))
           ($dummy (iprob_iisurp $tail $db $total_count))
        ) 
             (cons-atom $prob $dummy)
    )
))


;;This is the recursive version of iprob-old. While the non-deterministic (or above) 
;;implementation works within this file, it causes issues when used from other files.
(=(iprob-iisurp $partition $db $total_count) (
    let $products (iprob_iisurp $partition $db $total_count) (accumulator-x-iisurp $products)
))


;;Recursive steps for isurp
(= (isurp-old_iisurp $partitions $db $total_count) (
    if (== $partitions ()) () (
        let* (
            (($head $tail) (decons-atom $partitions))
             ($res (iprob-iisurp $head $db $total_count))
             ($dummy (isurp-old_iisurp $tail $db $total_count)))
        (cons-atom $res $dummy)
    )
))

;;Calculates the probability of a block within a partition by first converting 
;;it into a pattern and then computing its probability.
(= (blk-prob-iisurp $blk $db $total_count) (
    let* (($pattern (cons-atom , $blk)) 
    ($sup (collapse (match $db $pattern $pattern)))
    ($count (size-atom $sup))
    ($prob (// $count $total_count))
    
    ) 
    
    $prob
  ))

; (= (prob $pattern $db $total_count) (// (sup-num $db $pattern) $total_count))

(=(accumulator-x-iisurp $num_list) (accumulator-x-iisurp $num_list 1))
(=(accumulator-x-iisurp $num_list $prev_value)  (
   if (== $num_list ()) $prev_value (let ($head $tail) (decons-atom $num_list) (accumulator-x-iisurp $tail (* $head $prev_value)))
))


;;==========================


;===================



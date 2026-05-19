



; (= (inititate-IIsurp-miner $db $conc_db )

; (let* (
;   ($dummy (collapse (let ($link $x $y) (get-atoms $db) (add-atom &dbspace1 ($link $x $y))) ))
  
;   ($concepts-raw (collapse (match &dbspace1 ($link $anyI $anyC) $anyC)))
;   ($concepts (unique-atom $concepts-raw))
;   ($intermeidate (helper-iter $concepts $concepts &dbspace1 $conc_db))
  
;   )
;    (collapse (match $conc_db $y $y ))
  
;   )
 
  
; )



(= (inititate-IIsurp-miner $db $conc_db )

(let* (

  
  ($concepts-raw (collapse (match $db ($link $anyI $anyC) $anyC)))
  ($concepts (unique-atom $concepts-raw))
  ($intermeidate (helper-iter $concepts $concepts $db $conc_db))
  
  )
   (collapse (match $conc_db $y $y ))
  
  )
 
  
)



(= (helper-iter $concepts-whole $left $db $conc_db )

(if (== $left ()) (finished)

(let* (
  
  

  ($head (car-atom $left))
  ($tail (cdr-atom $left))
  
   ($orInst (collapse (match $db ($link $any $head) $any)))

  ($supers (sub-super-concepts $orInst $concepts-whole $head super $db))

  ($ans (if  (== $supers ()) () (collapse (add-rel $head (superpose $supers) $conc_db))))
  

)

(helper-iter $concepts-whole $tail $db $conc_db )
)
)

)


(=(add-rel $main-conc $rel-conc $conc_db)


 (add-atom $conc_db (Inheritance $main-conc $rel-conc))



)


(=(sub-super-concepts $OriginalInstances $concepts $originalConcept  $type $db  )
(let* (($superCons (collapse (super-helper-conc $OriginalInstances (superpose $concepts) $originalConcept $type $db )))


)
$superCons

)



)

(=(super-helper-conc $OriIns $concept $originalConcept $type $db)
(if (== $concept $originalConcept ) (empty) (let* (
  ($conIns (collapse (match $db ($link $any $concept) $any )))
  ($inter (intersection-atom $OriIns $conIns))
  
  
  ) 
 

    

    ;striclty superpattern or subpattern 
     (if  (and (== (size-atom $OriIns) (size-atom $inter)) (>= (size-atom $conIns) (size-atom $OriIns)))  $concept (empty))

     
     
      

    
    ))
)


; !(let $z (collapse (match &db $y $y )) $z)

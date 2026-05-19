; Converts a list of De Bruijn indices and symbols to variables, accumulating result in $acc, using $fixed-vars as the variable pool.




(= (debruijn2num Z) 0)

(= (debruijn2num (S $k)) (+ 1 (debruijn2num $k)))

(= (debruijn2vars-acc $lst $acc $fixed-vars)
   (if (== $lst ())
       $acc
       (let* (
           ($head (car-atom $lst))
           ($tail (cdr-atom $lst))
         )
         (if (or (== (get-metatype $head) Expression) (== $head Z))
             (let* (
                 ($idx (debruijn2num $head))
                 ($var (index-atom $fixed-vars $idx))
               )
               (debruijn2vars-acc $tail (union-atom $acc ($var)) $fixed-vars)
             )
             (debruijn2vars-acc $tail (union-atom $acc ($head)) $fixed-vars)
         )
       )
   )
)


; Converts a single subpattern in De Bruijn form to variable form using debruijn2vars-acc
(= (debruijn-subpattern2vars $subpat $fixed-vars)
   (let* (
       ($head (car-atom $subpat))
       ($args (cdr-atom $subpat))
       ($vars-args (debruijn2vars-acc $args () $fixed-vars))
       ($new-subpat (cons-atom $head $vars-args))
     )
     $new-subpat
   )
)

; (: debruijn-conjuncts2vars-acc (-> (List $a) (List $b) (List $c) (List $c)))

; Converts a list of subpatterns in De Bruijn form to variable form, accumulating result in $acc, using $fixed-vars as the variable pool.
(= (debruijn-conjuncts2vars-acc $subpats $fixed-vars $acc)
   (if (== $subpats ())
       $acc
       (let* (
          
           (($subpat $tail) (decons-atom $subpats))
          
           (($head $args ) (decons-atom $subpat))
           ($vars-args (debruijn2vars-acc $args () $fixed-vars))
           ($new-subpat (cons-atom $head $vars-args))
           ($new-acc (union-atom $acc ($new-subpat)))
         )
         (debruijn-conjuncts2vars-acc $tail $fixed-vars $new-acc)
       )
   )
)

(=(superposed-debruijn-conjuncts2vars-acc $subpats $fixed-vars)
(let*(
  ($varform (collapse (debruijn-subpattern2vars (superpose $subpats) $fixed-vars)))
)
$varform

)


)

; (= (debruijn-conjunct-pattern2vars $conjunct $fixed-vars)
;    (let* (
;        ($subpats (cdr-atom $conjunct))
;        ($vars-subpats (debruijn-conjuncts2vars-acc $subpats $fixed-vars ()))
;        ($vars-conjunct (cons-atom , $vars-subpats))
;      )
;      $vars-conjunct
;    )
; )


;calls the superposed version instead
(= (debruijn-conjunct-pattern2vars $conjunct $fixed-vars)
   (let* (
       ($subpats (cdr-atom $conjunct))
      
       ($vars-subpats (superposed-debruijn-conjuncts2vars-acc $subpats $fixed-vars ))
       ($vars-conjunct (cons-atom , $vars-subpats))
     )
     $vars-conjunct
   )
)

(= (full-pattern2vars $pattern)
   (if (== (car-atom $pattern) ,)
       (debruijn-conjunct-pattern2vars $pattern ($x $y $z $f $i $j $k $l $m $n $o $p $q))
       (debruijn-subpattern2vars $pattern ($x $y $z $f $i $j $k $l $m $n $o $p $q))
       
   )
)
;use this version cuz when we try to pass the list of variables within the body it acts wierd os its better to get the list from the user directly as argument
(= (full2-pattern2vars $pattern $fixed-vars)
      (if (== (car-atom $pattern) ,)
       (debruijn-conjunct-pattern2vars $pattern $fixed-vars)
       (debruijn-subpattern2vars $pattern $fixed-vars)
       
     
   
))


;acts werid cuz the list of variables are being passed within the body of the fucntion 
!(full-pattern2vars (Inheritance abe Z) )
;[(Inheritance abe $x#37)] this is the output

!(full2-pattern2vars (Inheritance abe Z) ($x $y $z $f $i $j $k $l $m $n $o $p $q))
;[(Inheritance $y $z)] output 

;(: type1 Variable)
;(= (check $b) (let $x (type-cast $b type1 &self) (get-metatype $x)))
;type-casting the debrujin directly into variables would have been better for scalability than using a hardcoded fixed list of variables but typecasting doesn't seem to work properly
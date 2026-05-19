(=(checkInter $x $acc) ((intersection-atom ($x) $acc)))


(= (get-variables $pattern $acc)
    (if (== $pattern ())
        $acc 
        (let* (
                ($head (car-atom $pattern)) 
                ($tail (cdr-atom $pattern))) 

            (if (== (get-metatype $head) Expression)
                (get-variables $tail
                    (get-variables $head $acc)) 
                (if (and (== (get-metatype $head) Variable)
                         (== (checkInter $head $acc) (()))) 
                    (get-variables $tail
                        (cons-atom $head $acc)) 
                    (get-variables $tail $acc)))))) 


(= (get-variables $pattern) (get-variables $pattern ()))


!(get-variables (, (Inheritance Tim $y) (Inheritance $y $z) (Inheritance $z $k) (Inheritance $k $f)) )
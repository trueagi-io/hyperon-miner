 ;; Declaration of List data type and constructors
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; Define DeBruijn Index
(: DeBruijn Type)
(: VarIdx (-> Nat DeBruijn))

;; Map a DeBruijn Index to an given variable
(: idx2var (-> DeBruijn (List Variable) Atom))
(= (idx2var (VarIdx Z) (Cons $head $tail)) $head)
(= (idx2var (VarIdx (S $k)) (Cons $head $tail)) (idx2var (VarIdx $k) $tail))

;; Map a DeBruijn Index in a given pattern to a variable
(: Debruijn2var (-> Atom (List Variable) Atom))
(= (Debruijn2var (VarIdx $k) $varlist) 
    (idx2var (VarIdx $k) $varlist))

(= (Debruijn2var $symbol $varlist)
    (if (== (get-metatype $symbol) Symbol) $symbol (empty)))

(= (Debruijn2var ($link $first $second) $varlist)
    ($link (Debruijn2var $first $varlist) (Debruijn2var $second $varlist)))

(= (Var2Debruijn $second (S Z))(
    if (or (== (get-metatype $second) Symbol)(== (get-metatype $second) Expression)) $second (VarIdx (S Z))
))
(= (Var2Debruijn $first Z)(
    if (or (== (get-metatype $first) Symbol)(== (get-metatype $first) Expression)) $first (VarIdx Z))
)
(= (Var2Debruijn ($link $first $second))(
    $link (Var2Debruijn $first Z) (Var2Debruijn $second (S Z))
))

; For conjunctions
(= (Deb2var $ptrn $varlist)
    (case $ptrn (
      ((, $p1 $p2) (, (Debruijn2var $p1 $varlist) (Debruijn2var $p2 $varlist)))
      ((, $p1 $p2 $p3) (, (Debruijn2var $p1 $varlist) (Debruijn2var $p2 $varlist) (Debruijn2var $p3 $varlist)))
      ($_ (Debruijn2var $ptrn $varlist)))))
!(import! &self ../common-utils)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Unit Tests for common-utils ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; --------------------------------
;;;; TEST FOR `flatten`
; --------------------------------
; `flatten` function should accept a nested conjunction and return a flattened conjunction
; Flattened conjunction
!(assertEqual (flatten-inner (, A B)) (, A B))

; Partially Nested flattening
!(assertEqual (flatten-inner (, (, A B) C)) (, A B C))
; !(assertEqual (flatten (, A (, B C))) ((, A B C)))

; Nested flattening
!(assertEqual (flatten-inner (, (, (, A B) C) D)) (, A B C D))



; --------------------------------
;;;; TEST FOR `conjunct-pattern`
; --------------------------------
; `conjunct-pattern` function should accept a list of blocks and a space, then output a conjunctive pattern combining the passed list patterns

!(assertEqual 
   (conjunct-pattern (A B) &space)
   (, A B)
)
!(assertEqual 
   (conjunct-pattern () &space1)
   (,)
)
!(assertEqual 
   (conjunct-pattern ((A)) &space2)
   (, (A))
)
!(assertEqual 
   (conjunct-pattern ((A) B) &space2)
   (, (A) B)
)
!(assertEqual 
   (conjunct-pattern (A (B)) &space2)
   (, A (B))
)


; --------------------------------
;;;; TEST FOR `//`
; --------------------------------
; `//` function should two numbers and return floating point division result
!(assertEqual (// 4 2) 2.0)
!(assertEqual (// 5 2) 2.5)
!(assertEqual (// 5.0 2) 2.5)
!(assertEqual (// 5 2.0) 2.5)
!(assertEqual (// 5.0 2.0) 2.5)


; --------------------------------
;;;; TEST FOR `concatTuple`
; --------------------------------
; `concatTuple` function should accept two tuples and return their concatenation
!(assertEqual (concatTuple (A B) (C D)) (A B C D))
!(assertEqual (concatTuple () (C D)) (C D))
!(assertEqual (concatTuple (A B) ()) (A B))
!(assertEqual (concatTuple () ()) ())


; --------------------------------
;;;; TEST FOR `remove-parenthesis`
; --------------------------------
; `remove-parenthesis` function should accept a pattern and remove outer parenthesis if they exist
!(assertEqual (remove-parenthesis ((A B))) (A B))
!(assertEqual (remove-parenthesis (A B)) (A B))
!(assertEqual (remove-parenthesis (((A B)))) (A B))
!(assertEqual (remove-parenthesis (A)) (A))
!(assertEqual (remove-parenthesis ()) ())
!(assertEqual (remove-parenthesis A) (A))





; ----------------------------------
;;;; TEST FOR `reverse-list`
; ----------------------------------
; `reverse-list` function should accept a list and return the reversed list
!(assertEqual (reverse-list ()) ())
!(assertEqual (reverse-list (A)) (A))
!(assertEqual (reverse-list (A B C D)) (D C B A))
!(assertEqual (reverse-list (A (B C) D)) (D (B C) A))


; ----------------------------------
;;;; TEST FOR `remove-element`
; ----------------------------------
; `remove-element` function should accept a list and an element, then return the list without the specified element
!(assertEqual (remove-element A ()) ())
!(assertEqual (remove-element A (A)) ())
!(assertEqual (remove-element A (A B C D)) (B C D))
!(assertEqual (remove-element J (A B C D)) (A B C D))

; ----------------------------------
;;;; TEST FOR `is-present`
; ----------------------------------
; `is-present` function should accept a list and an element, then return true if the element is in the list, false otherwise
!(assertEqual (is-present A ()) False)
!(assertEqual (is-present A (A)) True)
!(assertEqual (is-present C (A (B (C)) D)) True)
!(assertEqual (is-present J (A B C D)) False)

; ----------------------------------
;;;; TEST FOR `is-pattern`
; ----------------------------------
; `is-pattern` checks whether the given expression is a valid pattern
; !(assertEqual (is-pattern (A $a)) (True))
; !(assertEqual (is-pattern (A B)) (False))
; !(assertEqual (is-pattern ($a $b)) (False))
; !(assertEqual (is-pattern ()) (False))
; !(assertEqual (is-pattern (A ($b C) ($e $h))) (True))
; !(assertEqual (is-pattern (A ($b C) $j)) (True))
; !(assertEqual (is-pattern (A $j ($b C) )) (True))


; ----------------------------------
; ;;; TEST FOR `comp`
; ----------------------------------
; `comp` function should accept an element and a list, return a list with a each elment the combination of the element and each element of the list
!(assertEqual (comp A ()) ())
!(assertEqual (comp A (B)) ((B A)))
!(assertEqual (comp A (B C)) ((B A) (C A)))


; ----------------------------------
;;;; TEST FOR `get-clouses`
; ----------------------------------
; `get-clouses` function should accept a pattern and return a flattend list of its clouses
!(assertEqual (get-clouses (, A B))        (, A B))
!(assertEqual (get-clouses (, (, A B) C))  (, A B C))
!(assertEqual (get-clouses (, A (, B C)))  (, A B C))

; ----------------------------------
;;;; TEST FOR `get-cnj-clouses`
; ----------------------------------
; `get-cnj-clouses` function should accept a pattern and return a list of its conjunctive clauses
!(assertEqual (get-cnj-clouses (, A B)) (A B))
!(assertEqual (get-cnj-clouses (A B C)) (A B C))
!(assertEqual (get-cnj-clouses (,)) ())


; ----------------------------------
;;;; TEST FOR `min-max`
; ----------------------------------
; `min-max` function should accept a list of numbers and return a tuple of the minimum and maximum numbers in the list
!(assertEqual (min-max (4 2 8 1 5)) (1 8))
!(assertEqual (min-max (3.5 2.1 8.7 1.0 5.6)) (1.0 8.7))
!(assertEqual (min-max (5)) (5 5))



;-----------------------------------
;;;; TEST FOR `is-member`
;-----------------------------------
; `is-member` function should accept an atom and a list, return true if the atom is in the list, false otherwise
!(assertEqual (is-member A ()) False)
!(assertEqual (is-member A (A B)) True)
!(assertEqual (is-member A (A)) True)


;------------------------------------
;;;; TEST FOR `is_more_abstract`
;------------------------------------
; `is_more_abstract` function should accept two patterns and return true if the left pattern is more abstract (either simmilar or a variable) than the right pattern's corresponding positions, false otherwise
!(assertEqual (is_more_abstract (Inheritance A B) (Inheritance A B)) True)
!(assertEqual (is_more_abstract (Inheritance A C) (Inheritance A B)) False)
!(assertEqual (is_more_abstract (Inheritance A $b) (Inheritance A B)) True)
!(assertEqual (is_more_abstract (Inheritance $a $b) (Inheritance A B)) True)
!(assertEqual (is_more_abstract (Inheritance $a $b) (Inheritance $a B)) True)
!(assertEqual (is_more_abstract (Inheritance A $b) (Inheritance $a B)) False)
!(assertEqual (is_more_abstract (Inheritance $a B) (Inheritance $a $b)) False)


;------------------------------------
;;;; TEST FOR `get_variables`
;------------------------------------
; `get_variables` function should accept a pattern and return a list of unique variables in the pattern
!(assertEqual (get_variables ()) ())
!(assertEqual (get_variables (A)) ())
!(assertEqual (get_variables (A $a $e E g)) ($a $e))
!(assertEqual (get_variables (A ($b C) (D $e (F $g)) $h))   ($b $e $g $h))


;------------------------------------
;;;; TEST FOR `is_variable_in_list`
;------------------------------------
; `is_variable_in_list` function should accept a variable and a list of variables, return true if the variable is in the list, false otherwise
!(assertEqual (is_variable_in_list $a ()) False)
!(assertEqual (is_variable_in_list $a ($a)) True)
!(assertEqual (is_variable_in_list $a ($b $c $d)) False)
!(assertEqual (is_variable_in_list $a ($b $a $d)) True)


;------------------------------------
;;;; TEST FOR `is_variable_joint_with_clauses`
;------------------------------------
; `is_variable_joint_with_clauses` function should accept two patterns and return true a variable is directly connected with a clause
!(assertEqual (is_variable_joint_with_clauses $x ((P $x) (Q $y) (R $x $z))) True)
!(assertEqual (is_variable_joint_with_clauses $t ((P $x) (Q $y) (R $t $z))) True)
!(assertEqual (is_variable_joint_with_clauses $y ((P $x) (Q $y) (R $x $z))) True)
!(assertEqual (is_variable_joint_with_clauses $z ((P $x) (Q $y) (R $x $z))) True)
!(assertEqual (is_variable_joint_with_clauses $x ((P $y) (Q $y) (R $y $z))) False)
!(assertEqual (is_variable_joint_with_clauses $a ((P $x) (Q $y) (R $x $z))) False)




;------------------------------------
;;;; TEST FOR `tuple_to_list`
;------------------------------------
!(assertEqual (tuple_to_list ()) Nil)
!(assertEqual (tuple_to_list (A B C D)) (Cons A (Cons B (Cons C (Cons D Nil)))))

;------------------------------------
;;;; TEST FOR `is_subclause`
;------------------------------------
!(assertEqual (is_subclause $x ()) False)
!(assertEqual (is_subclause A (A B)) True)
!(assertEqual (is_subclause D (A B C)) False)
!(assertEqual (is_subclause (D) (J K ((B) ((D))))) True)



; ------------------------------------
; ;;; TEST FOR `remove_current`
; ------------------------------------
!(assertEqual (remove_current A (, A B C)) (, B C))
!(assertEqual (remove_current B (, A B C)) (, A C))
!(assertEqual (remove_current C (, A B C)) (, A B))
!(assertEqual (remove_current D (, A B C)) (, A B C))
!(assertEqual (remove_current A (, )) (, ))


;-------------------------------------
;;;; TEST FOR `add-conjunct`
;-------------------------------------
!(assertEqual (add-conjunct ()) ())
!(assertEqual (add-conjunct (A)) (, A))
!(assertEqual (add-conjunct (A B C)) (, A B C))
!(assertEqual (add-conjunct (A (B C) D)) (, A (B C) D))
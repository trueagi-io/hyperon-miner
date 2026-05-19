; python bindings for generating random variables
! (bind! letters (py-atom string.ascii_lowercase))
! (bind! tuple (py-atom tuple))
! (bind! random (py-atom random))
! (bind! plus (py-atom operator.add))
! (bind! V (py-atom hyperon.V))
! (bind! E (py-atom hyperon.E))


; helper functions
(= (is_var $v) (== (get-metatype $v) Variable))
(= (is_exp $v) (== (get-metatype $v) Expression))

; generates a random string of given length
; e.g, "A" or "AB" or "ZBDS"
(= (gen_random_word $length)(
   if (== $length 0) ""
   (
      let* (
         ($h ((py-dot random choice) letters))
         ($t (gen_random_word (- $length 1)))
      ) (
         plus $h $t
      )
   )
))

; generates a random variable of given length
; e.g, "#A" or "#AB" or "#ZBDS"
(= (gen_random_var)(V (gen_random_word 2)))
(= (gen_random_var $length)(V (gen_random_word $length)))

; generates a list of random variables of given length
; e.g, ("$AB" "$CD") or ("$AB" "$CD" "$EF" "$GH")
(= (gen_vars $num)(
   if (== $num 0) ()
   (
      let* (
         ($h (gen_random_var))
         ($t (gen_vars (- $num 1)))
      ) (
         cons-atom $h $t
      )
   )
))

; extracts variables from a nested expression and returns it
(= (extract_vars $exp)
   ( let* (
            ($h (car-atom $exp))
            ($t (cdr-atom $exp))
            ($x (if (is_var $h)
                     ($h)
                     (if (is_exp $h)
                        (if (== $h ())
                           ()
                           (extract_vars $h))
                        Nil )))
            ($y (if (== $t ()) () (extract_vars $t))))
         (if (or (== $x Nil) (== $x ()))
            $y
            (union-atom $x $y))))

; finds the index associated with the variable from the list. returns Nil if does not exist.
(= (find_var_value $list $key)(
   if (== $list ())  Nil
      (
         let* (
            (($h $t) ((car-atom $list) (cdr-atom $list)))
         ) (
               if (== () (intersection-atom $h ($key)))
                  (find_var_value $t $key)
                  (cdr-atom $h) 
         )
      )
))

; stores the variable and its index in the list
; if the variable already exists, it does not add it again
(= (store_var_value $list $key $value)(
   let* (
      ($result (find_var_value $list $key))
      ($key_pair (cons-atom $key ($value)))
   ) (
      if (== $result Nil)
         (cons-atom $key_pair $list)
         $list
   )
))

(= (replace_vars $exp $target_vars)(let ($replaced $tmp) (replace_vars $exp $target_vars ()) $replaced))
(= (replace_vars $exp $target_vars $store)(
   if (== $exp ()) 
      (() $store)
      ( let* (
            (($h $t) ((car-atom $exp) (cdr-atom $exp)))
            (($replaced $new_store)
               (if   (is_var $h)
                     (if (== () (intersection-atom $target_vars ($h)))
                         ($h $store)
                         ( let* (($stored_val  (find_var_value $store $h))
                                 ($replacement ( if (== Nil $stored_val) (gen_random_var) (car-atom $stored_val))))
                           ($replacement ( if (== Nil $stored_val) (store_var_value $store $h $replacement) $store))))
                     (if (is_exp $h) (replace_vars $h $target_vars $store) ($h $store) )))
            (($remaining $rem_store) (replace_vars $t $target_vars $new_store))
         )
         ((cons-atom $replaced $remaining) $rem_store )
      )
))


; Finds common variables between a source expression and a target expression and
;  replaces those common variables in the target expression with random variables.
(= (replace_common_variables $src_exp $target_exp)(
   let* (
      ($src_vars (extract_vars $src_exp))
   ) (replace_vars $target_exp $src_vars)
))

; Example usage:
; !( replace_common_variables
;    (Inheritance $d $g $j $k $e)
;    (Inheritance $a $b ($c ($d) $e $d))
; ) ; [(Inheritance $a $b ($c ($jx) $wd $jx))]

;; =============================================================================
;; Function: subsample-py
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Creates a random subsample from a database by selecting a specified number
;;   of atoms and placing them in a new space.
;;
;; Inputs:
;;   - `$db`: The source database/space to subsample
;;   - `$subsize`: The number of atoms to include in the subsample
;;
;; Output:
;;   - A new space containing the randomly selected atoms
;;
;; =============================================================================
(= (subsample-py $db $subsize)
    (let* (
            ($random-selected (generet-random-subsample $db $subsize))
            ($space (copy-db &subsampled-db $random-selected))
            )

        &subsampled-db
    )
)


;; avrg-tv-py
;; Computes the arithmetic mean of a sequence of numerical values.
;; 
;; Parameters:
;;   x – A sequence of numerical values (e.g., time-series data).
;; 
;; Returns:
;;   The average (mean) of the values in `x`.
;; 
;; Note:
;;   This function is an alias for `mean-tv`.

(= (avrg-tv-py $x) (mean-tv $x))



;; =============================================================================
;; Function: get-element-by-Index
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Retrieves an element from a list at a specified index position.
;;
;; Parameters:
;;   - $list: The input list to access
;;   - $index: Zero-based index of the element to retrieve
;;
;; Returns:
;;   - The element at the specified index
;;   - Undefined behavior if index is out of bounds
;; =============================================================================

(= (get-element-by-Index $list $index)
       (index-atom $list $index)
)
      

;; =============================================================================
;; Function: random-element
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Selects and returns a random element from the given database ($db).
;;
;; Parameters:
;;   - $db: A database or collection from which atoms are extracted.
;;
;;
;; Returns:
;;   - A randomly selected element from the database.
;;
;; =============================================================================
(= (random-element $db)
   (let* (
           ($list (collapse (get-atoms $db)))
           
           ($length (length $list))
           ($index (random-int 0 (- $length 1)))       
           ($element (get-element-by-Index $list $index))
           ($_ (println! $element))
         )
         $element))



;; =============================================================================
;; Function: generet-random-subsample
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Generates a random subsample of elements from the provided database ($db)
;;   with the specified sample size ($subsize). The subsample is collected 
;;   recursively.
;;
;; Parameters:
;;   - $db: The database or collection to sample from.
;;   - $subsize: The desired size of the random subsample.
;;
;; Returns:
;;   - A list containing a random subsample of elements from the database.
(= (generet-random-subsample $db $subsize)
   (if (< $subsize 0)
        ()
       (let* ( 
               ($elements (random-element $db))
               ($new-subsize (- $subsize 1))
               ($tail-elements (generet-random-subsample $db $new-subsize))
             )
             (cons-atom $elements $tail-elements)
       )
   )
)




;; =============================================================================
;; Function: copy-db
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Create a copy of a given database by duplicating its contents into a new instance.
;;
;; Parameters:
;;   - $db: The database to be copied (destination for the copied data).
;;   - $old-db-content: The content of the original database that needs to be duplicated.
;;
;; Internal Calculation:
;;   1. If the $old-db-content is empty, return the original database as is.
;;   2. Otherwise, add the first element of the content (car-atom) to the new database using `add-reduct`.
;;   3. Recursively process the rest of the content (cdr-atom) to continue copying the remaining data.
;;   
;; Returns:
;;   - A new database instance containing all the data from the original database.
;; =============================================================================
(= (copy-db $db $old-db-content)
    (if (== $old-db-content ()) $db
        (let* (
                (($head $tail) (decons-atom $old-db-content))
                ($_ (add-atom $db $head) )
            )
        (copy-db $db $tail)
    )
))
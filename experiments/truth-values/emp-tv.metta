
 ;; Rule to calculate the empirical truth value of a pattern.

 ;;;;;;;;;;
 ;; Type ;;
 ;;;;;;;;;;


 ;; =============================================================================
;; Type: TruthValue
;; -----------------------------------------------------------------------------
;; Purpose: Represents a truth value with confidence measurement
;; Constructor: (EMPTV <strength> <confidence>)
;; =============================================================================
; (: TruthValue Type)
; (: EMPTV (-> $a $b TruthValue))



;; =============================================================================
;; Constant: Default_k
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Provides a default smoothing constant used in confidence calculations.
;;
;; Value:
;;   - 1
;;
;; Usage:
;;   Used in the denominator of the count_to_confidence function to avoid
;;   overconfidence with small sample sizes.
;; =============================================================================
(= (Default_k) 1)

;; =============================================================================
;; Constant: DEFAULT_K
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Defines a large default scaling constant used in statistical calculations
;;   or other smoothing functions (context-dependent).
;;
;; Value:
;;   - 800.0
;;
;; Usage:
;;   Intended for use where a higher smoothing or normalization factor is needed.
;;   Not currently referenced in count_to_confidence.
;; =============================================================================
(= (DEFAULT_K) 800.0)

;; =============================================================================
;; Function: count_to_confidence
;; -----------------------------------------------------------------------------
;; Purpose: 
;;   Calculate a confidence value based on a count using a smoothing constant.
;;
;; Parameters:
;;   - $x: The count value (e.g., number of observations or samples)
;;
;; Internal Calculation:
;;   1. Adds the smoothing constant Default_k to the input count
;;   2. Divides the count by the sum to compute a normalized confidence
;;      => confidence = x / (x + Default_k)
;;
;; Returns:
;;   - A confidence value between 0 and 1
;; =============================================================================
(= (count_to_confidence $x) (// $x (+ $x (DEFAULT_K))))

;; =============================================================================
;; Function: emp-tv
;; -----------------------------------------------------------------------------
;; Purpose: Calculate empirical truth value for a pattern in database
;; Parameters:
;;   - $pattern: Target pattern to evaluate
;;   - $db: Database to analyze
;; 
;; Internal Computation:
;;   1. universe-count: Get total relevant items
;;   2. sup-num: Get pattern occurrences
;;   3. confidence: Calculate using count_to_confidence
;;   4. mean: Calculate support ratio
;; 
;; Returns:
;;   - EMPTV structure containing mean and confidence
(= (emp-tv $pattern $db)
    (let*
        (  
             ($_ (println! "======= Emperical Truth Value ======="))
            ( $ucount  (universe-count $pattern $db))
            ( $ms $ucount) ;;  we didn't use ms for support calculation
            ( $sup (sup-num $db $pattern))
            ( $conf (count_to_confidence $ucount))
            ($mean (// $sup $ucount))
            ($confidence   (* 1e-1 $conf))
        )
    (EMPTV $mean  $confidence)))


;; =============================================================================
;; Function: prob_to_support
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculate the support of a given pattern in a database using a probability estimate.
;;
;; Parameters:
;;   - $pattern: The pattern whose support is being computed. Represents a data structure or identifier.
;;   - $db: The database (typically a space or collection) where the pattern is evaluated.
;;   - $prob: The probability estimate of the pattern (a numeric likelihood value).
;;
;; Internal Calculation:
;;   1. Retrieve the universe count of the pattern in the given database using universe-count
;;   2. Multiply the count by the given probability estimate
;;      => support = probability × universe count
;;
;; Returns:
;;   - The support value, representing the expected count or weight of the pattern in the database
;; =============================================================================
(= (prob_to_support $pattern $db $prob)
    (let $che (universe-count $pattern $db) (* $prob $che))
)





;; =============================================================================
;; Function: sup
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Compute the support of a pattern in a database by counting how many data
;;   trees match the pattern.
;;
;; Parameters:
;;   - $pattern: The pattern to be matched against data in the database.
;;   - $db: The database of data trees where the pattern is searched.
;;
;; Internal Calculation:
;;   1. Perform pattern matching on the database using the `match` function.
;;   2. Collapse the result to a flat collection of matches.
;;   3. Count the number of resulting tuples using `tuple-count`.
;;      => This represents the number of data trees that match the pattern.
;;
;; Returns:
;;   - An integer indicating the support (number of matches) for the given pattern.
;; =============================================================================
(= (sup $pattern $db)
    (tuple-count 
        (collapse 
            (match $db $x (let $pattern $x $pattern)))))





 ;; =============================================================================
;; Function: categorize_subsize
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Categorize a subset size based on whether it exceeds half of a given threshold size.
;;
;; Parameters:
;;   - $subsize: The size of the subset to be evaluated.
;;   - $ts: The threshold size used for comparison.
;;
;; Internal Calculation:
;;   1. Divide the threshold size by 2.
;;   2. Compare the subset size to this half-threshold.
;;   3. If subset size > half of threshold, return 2; otherwise, return 1.
;;
;; Returns:
;;   - 2: If $subsize > ($ts / 2)
;;   - 1: If $subsize ≤ ($ts / 2)
;; =============================================================================
(= (categorize_subsize $subsize $ts)
    (if (> $subsize (// $ts 2))
        2
        1)
)




;; =============================================================================
;; Function: add_n_atoms_to_db
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Add a specified number of atoms to a given database recursively.
;;
;; Parameters:
;;   - $db: The database to which atoms will be added.
;;   - $n: The number of atoms to add to the database.
;;
;; Internal Calculation:
;;   1. If $n is less than or equal to 0, return the database as is (base case for recursion).
;;   2. Otherwise, add a new atom to the database using `add-atom` (assumed to add "Pattern").
;;   3. Recursively call the function, reducing $n by 1, to continue adding atoms until the count is reached.
;;
;; Returns:
;;   - The database with the specified number of atoms added.
;; =============================================================================
(= (add_n_atoms_to_db $db $n)
    (if (<= $n 0) $db
        (let* ( ($_ (add-atom $db Pattern))
            )
        (add_n_atoms_to_db $db (- $n 1))
    )
))


;; =============================================================================
;; Function: copy-and-add-atom
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Create a copy of the given database and add a specified number of atoms to the new database.
;;   This function ensures that the contents of the original database are duplicated into a new instance,
;;   and then it adds a specified number of atoms to the new database.
;;
;; Parameters:
;;   - $db: The original database to be copied.
;;   - $n: The number of atoms to add to the new database.
;;
;; Internal Calculation:
;;   1. If $n is less than or equal to 0, return the original database without any modifications.
;;   2. Otherwise, create a new database by copying the contents of $db using `copy-db`.
;;   3. Add atoms to the new database by calling `add_n_atoms_to_db` with the new database and $n.
;;
;; Returns:
;;   - A new database instance, containing the original database's data and the additional atoms added.
;; =============================================================================
(= (copy-and-add-atom $db $n)
    (if (<= $n 0) $db
        (let* ( ($new-db (copy-db (new-space) ( (collapse (get-atoms $db)) ))))
        )
    (add_n_atoms_to_db $db $n)
))

;; =============================================================================
;; Function: duplicate-and-expand-space
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Create a copy of the given space and add a specified number of atoms to the new space.
;;   This function ensures that all the contents of the original space are duplicated into a new space instance,
;;   and then a specified number of atoms are added to the new space.
;;
;; Parameters:
;;   - $space: The original space to be copied.
;;   - $n: The number of atoms to add to the new space.
;;
;; Internal Calculation:
;;   1. Copy the contents of the original space into a new space instance using `copy-db` and `collapse`.
;;   2. Add atoms to the new space by calling `add_n_atoms_to_db` with the new space and $n.
;;
;; Returns:
;;   - A new space instance containing the original space's data and the additional atoms added.
;; =============================================================================
(= (duplicate-and-expand-space $space $n)
    (let* (($che (collapse (get-atoms $space) ) ) ($new-db (copy-db  (new-space) $che )))
        (add_n_atoms_to_db $new-db $n)
    )
)



;; =============================================================================
;; Function: copy-db-by-size
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Create a copy of the given database up to a specified size. This function ensures that the contents of the original 
;;   database are duplicated into a new database instance until the specified size is reached.
;;
;; Parameters:
;;   - $db: The new database instance where the contents of the original database will be copied.
;;   - $old-db-content: The contents of the original database that need to be copied.
;;   - $n: The current count of atoms added to the new database.
;;   - $size: The maximum number of atoms to be copied to the new database.
;;
;; Internal Calculation:
;;   1. If the $old-db-content is empty or the current count $n has reached the specified $size, return the current database ($db).
;;   2. Otherwise, add the first atom of $old-db-content to the new database using `add-atom`.
;;   3. Recursively call the function, incrementing $n by 1, to continue copying until the size limit is reached.
;;
;; Returns:
;;   - A new database instance containing the first $size atoms from the original database.
;; =============================================================================
; (= (copy-db-by-size $db $old-db-content $n $size)
;     (if (or (== $old-db-content ()) (>= $n $size)) $db
;         (let* ( ($_ (add-atom $db (car-atom $old-db-content)) ))
;             (copy-db-by-size $db (cdr-atom $old-db-content) (+ $n 1) $size)
;         )
;     )
; )

(= (copy-db-by-size $db $old-db-content $n $size)
    (
        let*
            (
                
                ($first_bool (== $old-db-content ()))
                ($second_bool (>= $n $size))
                ($third_bool (or $first_bool $second_bool))
                ($next_num (+ $n 1))
                
               
            )
            (
                if $third_bool
                    $db
                    (
                        let*
                            (
                                (($head $tail) (decons-atom $old-db-content))
                                ($_ (add-atom $db $head)) 
                                
                            )
                            (copy-db-by-size $db $tail $next_num $size)
                            
                    )
                
            )
    )
)


;; =============================================================================
;; Function: subsample
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Adjust the size of a given database to match a specified subset size ($subsize).
;;   If the current size of the database is greater than or equal to the subset size,
;;   it returns the original database. Otherwise, it categorizes the database and either 
;;   adds or removes atoms to achieve the desired subset size.
;;
;; Parameters:
;;   - $db: The database to be subsampled.
;;   - $subsize: The target subset size for the database.
;;
;; Internal Calculation:
;;   1. If the current size of the database is less than or equal to the target subset size, return the database as is.
;;   2. Otherwise, categorize the database using `categorize_subsize` to decide whether atoms should be added or removed.
;;   3. If categorized as group 1, add atoms to the database using `duplicate-and-expand-space`.
;;   4. If categorized as group 2, remove atoms by using `copy-db-by-size` to adjust the size to the desired subset size.
;;
;; Returns:
;;   - A new database instance with a size adjusted to match the target subset size ($subsize).
;; =============================================================================
(= (subsample $db $subsize)
    (if (<= (db_size $db) $subsize)
        $db
        (case (categorize_subsize  $subsize (db_size $db))
            (
                (1 (duplicate-and-expand-space $db (- (* $subsize 2) (db_size $db)))) ; if it is in group 1 add atoms to the database
                (2 (copy-db-by-size (new-space) (collapse (get-atoms $db ) ) 0 (- (* $subsize 2) (db_size $db))))
                ($_ (copy-db-by-size (new-space) (collapse (get-atoms $db ) ) 0 (- (* $subsize 2) (db_size $db))))
            )
        )
    )
)


;; =============================================================================
;; Function: emp-tv-subsmp
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculates the empirical truth value for a given pattern in a subsampled version of a database.
;;   The function first creates a subsample of the database of the specified size and then computes 
;;   the empirical truth value based on that subsample.
;;
;; Parameters:
;;   - $pattern: The pattern for which the empirical truth value is to be calculated.
;;   - $db: The database from which the subsample will be drawn.
;;   - $subsize: The size of the subsample to be used.
;;
;; Internal Calculation:
;;   1. Use the `subsample-py` function to generate a subsample of the database of the desired size.
;;   2. Call the `emp-tv` function to compute the empirical truth value for the pattern based on the subsample.
;;
;; Returns:
;;   - The empirical truth value for the pattern based on the subsampled database.
;; =============================================================================
(= (emp-tv-subsmp $pattern $db $subsize)
    (let $space (subsample-py $db $subsize)
        (emp-tv $pattern $space)
    )
)

;; =============================================================================
;; Function: emp-tv-bs-helper
;; -----------------------------------------------------------------------------
;; Purpose:
;;   This function performs bootstrapping to estimate the empirical truth value of a given pattern.
;;   It recursively generates multiple subsamples from the database, computes the empirical truth value 
;;   for each subsample, and aggregates the results.
;;
;; Parameters:
;;   - $pattern: The pattern for which the empirical truth value is to be calculated.
;;   - $db: The database from which the subsamples will be drawn.
;;   - $n-resample: The number of resamples to perform.
;;   - $subsize: The size of each subsample.
;;
;; Internal Calculation:
;;   1. If the number of resamples is 0, return an empty list (base case).
;;   2. Otherwise, compute the empirical truth value for a random subsample of the database using `emp-tv-subsmp`.
;;   3. Recursively call the function to perform the remaining resamples.
;;   4. Add the empirical truth value for the current subsample to the list of results.
;;
;; Returns:
;;   - A list containing the empirical truth values for the pattern, calculated from multiple subsamples.
;; =============================================================================
(= (emp-tv-bs-helper $pattern $db $n-resample $subsize)
    (if (== $n-resample 0)
        () ; Base case: no more resampling, return an empty list
        (let* (
                ($subsample-tv (emp-tv-subsmp $pattern $db $subsize)) ; Compute empirical truth value for subsample
                ($remaining-esstvs (emp-tv-bs-helper $pattern $db (- $n-resample 1) $subsize)) ; Recursive call
            )
        (cons-atom $subsample-tv $remaining-esstvs)))) ; Add the result to the list and continue

;; =============================================================================
;; Function: subsmp-size
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculates the sub-sample size based on the given pattern, database size, 
;;   support estimate, and a minimum sub-sample size. The function computes an 
;;   appropriate sub-sample size that ensures statistical robustness.
;;
;; Parameters:
;;   - $pattern: The pattern to be matched.
;;   - $db-size: The size of the database.
;;   - $support-estimate: The estimated support value of the pattern.

;;
;; Internal Calculation:
;;   1. Compute the number of conjuncts in the pattern using `n_conjuncts`.
;;   2. Calculate the alpha value, which is the ratio of the support estimate 
;;      to the database size raised to the power of the number of conjuncts.
;;   3. Calculate the base by dividing the database size by ten times alpha.
;;   4. Compute the result by raising the base to the power of 1/$nc.
;;   5. Return the maximum between the computed result and the minimum of 
;;      the minimum sub-sample size and database size.
;;
;; Returns:
;;   - The calculated sub-sample size, ensuring it is at least the minimum 
;;     size and does not exceed the database size.
;; =============================================================================
(= (subsmp-size $pattern $db-size $support-estimate)
    (let* ( ($nc (n_conjuncts $pattern))    
            (($min-size) (10))   
            ($alpha (// $support-estimate (pow-math $db-size $nc)))
            ($betterAlpha (+ $alpha 1e-10)) ;; to avoid division by zero
            ($base (// $db-size (* 10 $betterAlpha)))
            ($power (// 1 $nc))
            ($res (pow-math $base $power)) 
    )
        (max $res (min $min-size $db-size))
    )
)





;; =============================================================================
;; Function: emp-tv-bs
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculates the empirical truth value using bootstrapping (resampling) for a given pattern 
;;   and database, incorporating multiple resamples and subsample sizes. The function 
;;   first checks if the subsample size is smaller than the database size. If so, it performs 
;;   bootstrapping by resampling the database multiple times, calculating the empirical truth 
;;   value for each resample, and returning the average. If the subsample size is greater than 
;;   or equal to the database size, it directly computes the empirical truth value.
;;
;; Parameters:
;;   - $pattern: The pattern for which the empirical truth value is to be calculated.
;;   - $db: The database in which the pattern's empirical truth value is to be calculated.
;;   - $n-resample: The number of resamples to perform during bootstrapping.
;;   - $subsize: The subsample size used in the resampling process.
;;
;; Internal Calculation:
;;   1. If the subsample size is less than the database size, the function performs resampling:
;;      - Calls `emp-tv-bs-helper` to generate multiple empirical truth values (one for each resample).
;;      - Averages the resampled empirical truth values using `avrg-tv-py`.
;;      - Calls `mk-stv` to create a simple truth value from the mean and variance of the empirical truth values.
;;   2. If the subsample size is greater than or equal to the database size, it directly calculates the empirical truth value using `emp-tv`.
;;
;; Returns:
;;   - If subsize is smaller than the database size: A simple truth value based on the average empirical truth values from the resamples.
;;   - If subsize is greater than or equal to the database size: The direct empirical truth value of the pattern.
;; =============================================================================
(= (emp-tv-bs $pattern $db $n-resample $subsize)
    (if (< $subsize (db_size $db))
        (let* (
                ($esstvs (emp-tv-bs-helper $pattern $db $n-resample $subsize))
                (($mean $variance) (avrg_tv $esstvs))
                ($mk_stv_val (mk_stv $mean $variance))
                ($finalAnswer (cons-atom EMPTV $mk_stv_val))
            )
            $finalAnswer
        ) ; Return average of the empirical truth values
    (emp-tv $pattern $db))) ; If subsize >= db size, directly return empirical truth value




;; =============================================================================
;; Function: do_emp_tv
;; -----------------------------------------------------------------------------
;; Purpose:
;;   Calculates the empirical truth value for a given pattern in a database.
;;   It processes the database to obtain a sequence of atoms, estimates the joint truth value (JTV),
;;   and then uses the support estimate calculator to compute the final empirical truth value.
;;
;; Parameters:
;;   - $pattern: The pattern for which the empirical truth value is to be calculated.
;;   - $db: The database in which the pattern's empirical truth value is to be calculated.
;;   - $db_ratio: The ratio used to scale the database size.
;;
;; Internal Calculation:
;;   1. Extract the sequence of atoms from the database using `get-atoms` and `collapse`.
;;   2. Estimate the joint truth value (JTV) for the given pattern and database using `ji_tv_est`.
;;   3. Extract the mean and confidence values from the joint truth estimate.
;;   4. Use the `support_estimate_calculator` to compute the empirical truth value based on the mean and database ratio.
;;
;; Returns:
;;   - The computed empirical truth value for the given pattern in the database.
;; =============================================================================
(= (do_emp_tv $pattern $db $db_ratio)
    (let* ( 
            ($jte  (do-ji-tv-est $db $pattern))         ;; after we get jte we must extract the mean
            (($link $mean $confidence) $jte)
           
            )
           (emp_tv_pbs $pattern $db $mean $db_ratio))
)



(= (emp_tv_pbs $pattern $db $prob_estimate $db_ratio)  
     (let* (
        ($support_estimate (prob_to_support $pattern $db $prob_estimate))
        ($db-size (* (db_size $db) $db_ratio))
        ($subsize (subsmp-size $pattern $db-size $support_estimate))
        ($n-resample 10)
        )
        (if (> $support_estimate $db-size)
            (emp-tv-bs $pattern $db $n-resample $subsize)
            (emp-tv $pattern $db)
        )
     )
)
; !(import! &self ../utils/common-utils)
; !(import! &self ../utils/index_to_var)
; !(import! &self ../utils/variable-combinations)
; !(import! &self ../utils/surp-utils/blk-abstractness)
; !(import! &self ../utils/surp-utils/partition-metta)
; !(import! &self ../utils/remove_useless_clauses)
; !(import! &self ../utils/sort)

; ; !(import! &dbspace ../data/small-ugly)
; ; !(import! &dbspace ../data/sample-data)
; !(import! &dbspace ../data/ugly_man_sodaDrinker)
; !(import! &self ./valuation)
; !(import! &self ./shallow-abstractions)
; !(import! &self ./specialization)
; !(import! &self ./candidate)
; !(import! &self ./conjunction-expansion)

; --------------------------------------------------------
;; frequency-pattern-miner
; ---------------------------------------------------------
;; function to mine the frequent patterns from the atomspace.
;; 1: mine all candidate patterns and store them in a space
;; 2: expand the conjunctions of the candidate patterns and store them in a space with their support
;; 3: format the patterns and add them to the knowledge base with their support
;(: frequency-pattern-miner (-> space Atoms space space Number Number Atoms Boolean))
(= (frequency-pattern-miner $dbspace $initpat $cndpspace $conjspace $minsup $depth $cnj_exp)
   (let*(
        (true (println! "==== Frequent miner started ====="))
        ($temp2  (collapse (candidate-pattern-miner $initpat $dbspace $minsup $cndpspace)))
        ($temp3  (if $cnj_exp (collapse (conjunct $dbspace $cndpspace $conjspace $minsup $depth)) $temp2))
        ($temp4  (formatter $conjspace $cndpspace $dbspace $cnj_exp))  
        )  
        $temp4
        )
)

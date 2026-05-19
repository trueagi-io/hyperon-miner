!(import! &self ./build-specialization)
!(import! &self ./candidate-patterns)
!(import! &self ./conjunction-expansion)
!(import! &self ../utils/index_to_var)
!(import! &self ../data/small-ugly)
; !(import! &self ../data/sample-data)
!(import! &self ../utils/common-utils)
!(import! &self ../utils/variable-combinations)
!(import! &self ../utils/remove_useless_clauses)
!(import! &self ../utils/blk-abstractness)
!(import! &self ../utils/partition-metta)
!(migrateAtoms &self &dbspace (Inheritance $x $y))

;;function name: abstract-pattern
        ; Gets Abstract Patterns with Minimum Support so that we can use them for the specialization.

        ; parameters:
            ; $dbspace: the database that is loaded and cleaned of the stdlib functions.
            ; $minsup: minimum support to check if the abstract pattern exceeds or equals this value
            ; $aptrnspace: a space to store abstract patterns
        
;         steps:
    ;         1:Query the database to retrieve all link nodes (nodes that connect other nodes)
    ;         2:Take only the unique links from the queried links
    ;         3:Create an Abstract pattern using the links and variables
    ;         4:Calculate the support for the Abstract patterns and store the ones satisfy the minimum support in a space

(= (abstract-pattern $dbspace $minsup $aptrnspace $cndpspace)
            (let* (
                    ($linkunique (unique-atom (collapse (match $dbspace ($link $x $y) $link))))
                    ($result (sup-eval $dbspace ($linkunique $z $t) $minsup))
                )
            (if (== $result True)
                (superpose (
                        (remove-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
                        (add-atom $aptrnspace (AbstractPattern ($linkunique Z (S Z))))
                        (remove-atom $cndpspace (CandidatePattern ($linkunique Z (S Z))))
                        (add-atom $cndpspace (CandidatePattern ($linkunique Z (S Z))))
                    ))
            empty
        )
)

)

; function name: do-conjunct
                    ; function to expand the conjunctions of the patterns and create conjunctions of any amount of clauses

                    ; parameters:
                        ; $db: the database that is loaded and cleaned of the stdlib functions.
                        ; $cndb: the candidate patterns space
                        ; $conjunct: the conjunctions part of the pattern
                        ; $ms: minimum support
                        ; (S $K)/ Z: a debruijin index to check if we are in the last iteration of the recursion.

                    ;steps:
                        ; 1: get the matches of the candidate patterns in the database
                        ; 2: expand the conjunctions with the matches and the database
                        ; 3: replace the variables with the debruijin index
                        ; 4: remove any redundant clauses from the conjunctions
                        ; 5: if we are in the last iteration of the recursion, return the conjunctions else call the function again with the new conjunctions and the debruijin index.
                    
                    ; returns:
                        ; a superpose of conjunctions that satisfy the minimum support and are not redundant.








; function name: frequency-pattern-miner
                    ; function to mine the frequent patterns from the database.

                    ; parameters:
                        ; $kb: the knowledge base
                        ; $dbspace: the database
                        ; $specspace: the space that stores the specialized patterns
                        ; $cndpspace: the space that stores the candidate patterns
                        ; $aptrnspace: the space that stores the abstract patterns
                        ; $conjspace: the space that stores the conjunctions of the patterns
                        ; $minsup: minimum support to check if the pattern exceeds or equals this value
                        ; $depth: a debruijin index to pass to do-conjunct function.

                    ;steps:
                        ; 1: get all abstract patterns with their support and store them in a space
                        ; 2: specialize the abstract patterns and store them in a space
                        ; 3: get all candidate patterns from the specialized patterns and store them in a space
                        ; 4: expand the conjunctions of the candidate patterns and store them in a space with their support
                        ; 5: format the patterns and add them to the knowledge base with their support


(= (frequency-pattern-miner $kb $dbspace $specspace $cndpspace $aptrnspace $conjspace $minsup $depth)
    (superpose (
            (abstract-pattern $dbspace $minsup $aptrnspace $cndpspace) ; prevent patterns that dont have a support from being speciallized
            (match $aptrnspace (AbstractPattern $pattern) (build-specialization $pattern $dbspace $specspace)) ; specializa abstract patterns
            (candidatePattern $dbspace $specspace $minsup $cndpspace); get candidate patterns
            (match $cndpspace (CandidatePattern $pattern) (let $conj (do-conjunct $dbspace $cndpspace $pattern $minsup (fromNumber $depth)) (if (== $conj ()) () (add-atom $conjspace $conj)))) ; store candidate patterns
            ; (match &conjspace $pattern (superpose ((add-atom &conjspace (supportOf $pattern (sup-num $dbspace (replacev $pattern)))) (remove-atom &conjspace $pattern))))
            (formatter $conjspace $dbspace)
        ))
)


!(frequency-pattern-miner &kb &dbspace &specspace &cndpspace &aptrnspace &conjspace 2 0)
!(match &kb $x $x)
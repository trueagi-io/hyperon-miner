;; MeTTa port of pattern miner, using match.

;; Given a collection of data trees db, a minimum support ms and an
;; initial collection of patterns Candidate (containing at least the identity
;; pattern), the pattern mining algorithm works as follows

;; 1. Select a pattern P from C
;; 2. Extract the valuation set of P over db, called V
;; 3. Determine the shallow abstractions of V, called A
;; 4. Specialize P by composing it with elements in A
;; 5. Add the resulting specializations with enough support in C,
;;    discard the others
;; 6. Repeat till termination

;; Import utils
!(import! &self ../utils/MinerUtils.metta)

;; Get candidate patterns depth zero
(= (get-candidate Z $linkType $db $ms $Xvar $Yvar)
    (let $sp (specialize $linkType $Xvar $Yvar)
      (support $sp $db $ms $Xvar $Yvar)))

;; Get candidate patterns depth n. (maximum is three)
(= (get-candidate (S $k) $linkType $db $ms $Xvar $Yvar)
    (let $comb
        (, (get-pattern (get-candidate $k $linkType $db $ms $Xvar $Yvar)) 
          (get-pattern (get-candidate Z $linkType $db $ms $Xvar $Yvar)))
      (support $comb $db $ms $Xvar $Yvar)))

;; Frequent patterns Miner
(= (miner $db $ms $depth)
    (superpose ((extract-valuation $db)
                (let $link (get-links)
                  (get-candidate $depth $link $db $ms $Xvar $Yvar)))))

;; Surprising patterns miner
(= (miner-surprising $db $ms $depth $highsurp)
  (let $cptrn (miner $db $ms $depth)
    (superpose ((get-universe-size $db)
                ((let $isurp (iSurprisingness $cptrn $db) 
                  (if (> $isurp $highsurp) (surp $cptrn $isurp) (superpose ()))))))))

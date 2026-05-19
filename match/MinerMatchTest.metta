! (register-module! ../../hyperon-miner)
!(import! &self hyperon-miner:match:MinerMatch)
!(import! &self ../utils/MinerUtils.metta)

;; Load sample data
!(import! &db hyperon-miner:data:sample)

;; Parameters
(= (ms) 5)
;; Max depth (number of conjuncts) is 3
;; it starts from 0, 
;(= (depth) (fromNumber 1))
(= (depth) (fromNumber 2))
(= (highsurp) 0.8)

;; frequent patterns 
!(miner &db (ms) (depth))

;; Surprising patterns
;!(miner-surprising &db (ms) (depth) (highsurp))

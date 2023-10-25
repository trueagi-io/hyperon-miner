!(import! &self MinerMatch.metta)

;; Load sample data
!(import! &db ../data/sample.metta)

;; Parameters
(= (ms) 5)
;; Max depth (number of conjuncts) is 3
(= (depth) (S (S Z)))
(= (highsurp) 0.9)

!(miner &db (ms) (depth))
;!(miner-surprising &db (ms) (depth) (highsurp))

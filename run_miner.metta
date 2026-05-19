;; This is a starter script to run the pattern miner on your own data.
;;
;; USAGE:
;; 1. Ensure PeTTa is installed.
;; 2. Edit the dataset import below to point to your data.
;; 3. Run this file using the PeTTa run script: sh <path-to-petta>/run.sh run_miner.metta

;; --- 1. Import Dependencies (Do not edit unless you know what you are doing) ---
;; Basic Utilities
!(import! &self experiments/utils/surp-utils/boost_petta.py)
!(import! &self experiments/utils/common-utils)
!(import! &self experiments/utils/index_to_var)
!(import! &self experiments/utils/constants)
!(import! &self experiments/utils/TruthValue)

;; Mathematical & Statistical Utilities
!(import! &self experiments/utils/surp-utils/partition-metta)
!(import! &self experiments/utils/surp-utils/binomialMetta)
!(import! &self experiments/utils/surp-utils/beta-dist)
!(import! &self experiments/utils/surp-utils/surp-utils)
!(import! &self experiments/utils/sort)
!(import! &self experiments/utils/variable-combinations)
!(import! &self experiments/utils/surp-utils/blk-abstractness)
!(import! &self experiments/utils/remove_useless_clauses)
!(import! &self experiments/utils/surp-utils/eq-prob-petta)
!(import! &self experiments/utils/surp-utils/bs-utils)
!(import! &self experiments/utils/surp-utils/jsd-helper)

;; Truth Values & Probability Logic
!(import! &self experiments/truth-values/est-tv)
!(import! &self experiments/truth-values/emp-tv)

;; Surprisingness Modules
!(import! &self experiments/surprisingness/emp-prob)
!(import! &self experiments/surprisingness/isurp)
!(import! &self experiments/surprisingness/isurp-old)
!(import! &self experiments/surprisingness/jsd)

;; Frequent Pattern Miner Components
!(import! &self experiments/frequent-pattern-miner/build-specialization)
!(import! &self experiments/frequent-pattern-miner/candidate-patterns)
!(import! &self experiments/frequent-pattern-miner/conjunction-expansion)
!(import! &self experiments/frequent-pattern-miner/frequent-pattern-miner)

;; Main Miner Entry Point
!(import! &self experiments/pattern-miner/pattern-miner)


;; --- 2. Load Your Dataset ---
;; Replace the path below with your own data file
!(import! &db experiments/data/ugly_man_sodaDrinker)

;; Create a space for results
!(bind! &res (new-space))


;; --- 3. Run Miner ---
;; The miner function takes 8 arguments:
;; (pattern-miner <output-space> <input-db> <min-support> <depth> <mode> <normalization> <db-ratio> <conj-exp>)
;;
;; PARAMETERS EXPLAINED:
;; ---------------------
;; 1. <output-space>:  (&res) The place where results will be stored.
;; 2. <input-db>:      (&db) The dataset you imported above.
;; 3. <min-support>:   (Integer) The minimum number of times a pattern must occur to be considered "frequent". 
;;                     Example: 10 means the pattern must appear at least 10 times.
;; 4. <depth>:         (Integer) Controls how complex the mined patterns are.
;;                     0 -> Standard Pairs/Triplets (e.g., A implies B). Result usually has 2 conjuncts.
;;                     1 -> Basic Chain (e.g., A implies B, B implies C). Result has 3 conjuncts.
;; 5. <mode>:          (Atom) What to calculate?
;;                     none      -> Only find frequent patterns. Do not calculate Surprisingness.
;;                     isurp     -> Calculate information-theoretic surprisingness.
;;                     isurp-old -> Use the legacy surprisingness algorithm.
;;                     jsd       -> Use Jensen-Shannon Divergence for surprisingness.
;; 6. <normalization>: (Boolean/Atom) Normalize surprisingness scores?
;;                     True  -> Scale scores between 0 and 1. (Recommended for 'isurp')
;;                     False -> raw scores.
;;                     none  -> Use this if <mode> is 'none'.
;; 7. <db-ratio>:      (Number/Atom) Ratio of relevant samples to total DB size. 
;;                     Used to adjust probability estimates.
;;                     0.2   -> A typical starting value (20% sample assumption).
;;                     none  -> Use this if <mode> is 'none'.
;; 8. <conj-exp>:      (Boolean) Enable Conjunction Expansion?
;;                     True  -> Allows combining smaller patterns into larger ones (required for depth > 0).
;;                     False -> Stick to basic specialized patterns.

;; EXAMPLE CONFIGURATION:
!(pattern-miner &res &db 3 0 none none none True)


;; --- 4. View Results ---
!(get-atoms &res)




!(import! &db ../../data/II_surp_kb/state_count)
!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/surp-utils/partition-metta)
!(import! &self ../../utils/surp-utils/binomialMetta)
!(import! &self ../../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self ../../utils/surp-utils/blk-abstractness)
!(import! &self ../../utils/surp-utils/eq-prob-petta)
!(import! &self ../../utils/surp-utils/bs-utils)
!(import! &self ../../utils/TruthValue)
!(import! &self ../../utils/constants)
!(import! &self ../../truth-values/emp-tv)
!(import! &self ../../truth-values/est-tv)
!(import! &self ../../utils/index_to_var)
!(import! &self ../../utils/surp-utils/IIsurp_utils)
!(import! &self ../emp-prob)
!(import! &self ../isurp)
!(import! &self ../IIsurp-old)






!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x coffeeDrinker)  (Inheritance $x techWorker)
) &db False ) 1.7036712990880136e-06)



!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x coffeeDrinker)
) &db False ) 4.811589161216016e-05)

!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x coffeeDrinker)
) &db True ) 0.19892713455520758)



!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x surfer)
) &db False ) 0.00011281104175734944)


!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x surfer)
) &db True ) 0.699597675458203)

;;================================
;;isurp instead of isurp-old for partition based estiamtion
;;==============================

!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x surfer)
) &db isurp True 0.2 ) 0.3953685697120519)

!(assertEqual (IIsurp-old-nary (, (Inheritance $x California)
   (Inheritance $x surfer)
) &db isurp False 0.2 ) 3.167509771767761e-05)










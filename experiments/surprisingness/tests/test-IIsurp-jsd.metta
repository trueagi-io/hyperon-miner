
!(import! &self "../../utils/surp-utils/boost_petta.py")
!(import! &db ../../data/II_surp_kb/kb1)
!(import! &self ../../utils/common-utils)
!(import! &self ../../utils/constants)
!(import! &self ../../utils/TruthValue)
!(import! &self ../../utils/surp-utils/partition-metta)
!(import! &self ../../utils/surp-utils/binomialMetta)
!(import! &self ../../utils/surp-utils/beta-dist)
!(import! &self ../../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/blk-abstractness)
!(import! &self ../../utils/surp-utils/eq-prob-petta)
!(import! &self ../../utils/surp-utils/bs-utils)
!(import! &self ../../truth-values/emp-tv)
!(import! &self ../../truth-values/est-tv)
!(import! &self ../../utils/index_to_var)
!(import! &self ../../utils/surp-utils/jsd-helper)
!(import! &self ../../utils/surp-utils/IIsurp_utils)
!(import! &self ../../utils/surp-utils/IIsurp_avrg)
!(import! &self ../emp-prob)
!(import! &self ../jsd)
!(import! &self ../IIsurp_jsd)



!(assertEqual (IIsurp-pln (, (Inheritance $x human)
   (Inheritance $x gamer) (Inheritance $x student)
) &db) 0.0062148962728)


!(assertEqual (IIsurp-pln (, (Inheritance $x human)
   (Inheritance $x gamer)
) &db) 0.0075910448073)




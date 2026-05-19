! (register-module! ../../experiments)
! (import! &self experiments:utils:common-utils)

(= (expect_True)
    True)
(= (expect_False)
    False)

 ;;unit test1 for Function that checks the more abstract Pattern

! (assertEqual (is_pat_more_abstract ( , (INHERITANCE_LINK $X $Z)
            (INHERITANCE_LINK $Y $Z)) (INHERITANCE_LINK C0 $Z) $Z) (expect_True))

 ;;unit test2 for Function that checks the more abstract Pattern

! (assertEqual (is_pat_more_abstract (, (Inheritance $X $W) (Inheritance $X B)) (Inheritance $Z A) $X) (expect_False))

 ;;unit test3 for Function that checks the more abstract Pattern

! (assertEqual (is_pat_more_abstract (, (Inheritance $X $W) (Inheritance $Y B)) (, (Inheritance $X $Y) (Inheritance $X C0)) $X) True)

 ;;unit test4 for Function that checks the more abstract Pattern
! (assertEqual (is_pat_more_abstract (, (Inheritance $X $W) (Inheritance $Y B)) (Inheritance $X A) $X) True)

 ;  ;;unit test for Function that checks the more abstract Pattern for each var
 ; (= (clause_1) (INHERITANCE_LINK $X $Y))
 ; (= (clause_2) (INHERITANCE_LINK $Y $Z))
 ; (= (clause_3) (INHERITANCE_LINK $Z $W))
 ; (= (result_abstraction_foreach) (is_more_abstract_foreach_var (clause_2 (clause_1 clause_3)) ))
 ; ! (assertEqual (result_abstraction_foreach) (expect_False))

 ;  ;;unit test1 for function that checks the more abstract block syntax
 ; (= (l_blk_1) (INHERITANCE_LINK $X $Y))
 ; (= (r_blk_1) (INHERITANCE_LINK $Y $Z))
 ;  ;; Left block/subpattern is not syntactically more abstract than right block/subpattern, relative to Y.
 ; (= (result_blk_1) (is_blk_more_abstract (l_blk_1) (r_blk_1) $Y))
 ; ! (assertEqual (result_blk_1) (expect_False))

 ;  ;;unit test2 for function that checks the more abstract block syntax
 ; (= (l_blk_2) (INHERITANCE_LINK $X $Y))
 ; (= (r_blk_2) (INHERITANCE_LINK A $Z))
 ;  ;;Left block/subpattern is syntactically more abstract than rightblock/subpattern, relative to Y.
 ; (= (result_blk_2) (is_blk_more_abstract (l_blk_2) (r_blk_2) $Y))
 ; ! (assertEqual (result_blk_2) (expect_True))

 ;  ;;unit test3 for function that checks the more abstract block syntax
 ; (= (l_blk_3) (LIST_LINK $Z $W $X))
 ; (= (r_blk_3) (LIST_LINK $X $Y $X))
 ;  ;;Left block/subpattern is syntactically more abstract than right block/subpattern, relative to X.
 ; (= (result_blk_3) (is_blk_more_abstract (l_blk_3) (r_blk_3) $X))
 ; (= (result_blk_3_converse) (is_blk_more_abstract (r_blk_3) (l_blk_3) $X)) ;;However the converse is not true.
 ; ! (assertEqual (result_blk_3) (expect_True))
 ; ! (assertEqual (result_blk_3_converse) (expect_False))
!(import! &self ../utils/common-utils)
!(import! &self ../utils/index_to_var)
!(import! &self ../utils/variable-combinations)
!(import! &self ../utils/surp-utils/blk-abstractness)
!(import! &self ../utils/surp-utils/partition-metta)
!(import! &self ../utils/remove_useless_clauses)
!(import! &self ../utils/sort)
!(import! &dbspace ../data/ugly_man_sodadrinker)
!(import! &self ../frequent-pattern-miner/valuation)
!(import! &self ../frequent-pattern-miner/shallow-abstractions)
!(import! &self ../frequent-pattern-miner/specialization)
!(import! &self ../frequent-pattern-miner/candidate)
!(import! &self ../frequent-pattern-miner/conjunction-expansion)
!(import! &self ../frequent-pattern-miner/frequent-pattern-miner-generic)

; void MinerUTest::test_empty()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Test with empty db, thus expected result should be empty

; 	// Run URE pattern miner
; 	Handle ure_results = ure_pm(HandleSeq(), 0),
; 		ure_expected = mk_minsup_evals(0, {top});

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results);
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(content_eq(ure_results, ure_expected));
; }

; (= (test_empty)
;     (frequency-pattern-miner &testspace $x &cndpspace &conjspace 5 0 False)
; )

; !(assertEqual (test_empty) ())

; ==========================================================================================================
; void MinerUTest::test_AB_AC()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle InhAB = al(INHERITANCE_LINK, A, B),
; 		InhAC = al(INHERITANCE_LINK, A, C);
; 	HandleSeq db{InhAB, InhAC};

; 	// Define pattern parts
; 	Handle VarXY = al(VARIABLE_SET, X, Y),
; 		InhXY = al(INHERITANCE_LINK, X, Y),
; 		InhAY = al(INHERITANCE_LINK, Y, A);

; 	// Run URE pattern miner (using _as for testing more diverse
; 	// content)
; 	Handle ure_results = ure_pm(_as, 2),
; 		expected_pattern = MinerUtils::mk_pattern(Y, {InhAY}),
; 		ure_expected = mk_minsup_eval(2, expected_pattern);

; 	logger().info() << "ure_results = " << oc_to_string(ure_results);
; 	logger().info() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(contains(ure_results->getOutgoingSet(), ure_expected));
; }

(= (test_AB_AC)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance A C)))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance A C)))
        ($cnd (collapse (match &cndpspace (CandidatePattern $pattern $cnt) $pattern)))
    )$cnd)
)

; !(assertEqual (test_AB_AC) ((Inheritance A Z) (Inheritance Z (S Z))))
; ===============================================================================================================

; void MinerUTest::test_AB_AC_BC()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle InhAB = al(INHERITANCE_LINK, A, B),
; 		InhAC = al(INHERITANCE_LINK, A, C),
; 		InhBC = al(INHERITANCE_LINK, B, C);
; 	HandleSeq db{A, B, C, InhAB, InhAC, InhBC};

; 	// Define pattern parts
; 	Handle VarXY = al(VARIABLE_SET, X, Y),
; 		InhXY = al(INHERITANCE_LINK, X, Y),
; 		InhAY = al(INHERITANCE_LINK, A, Y),
; 		InhXC = al(INHERITANCE_LINK, X, C);

; 	// Run C++ pattern miner
; 	HandleTree cpp_results = cpp_pm(db, 2),
; 		cpp_expected(MinerUtils::mk_pattern(VarXY, {InhXY}),
; 		             { MinerUtils::mk_pattern(Y, {InhAY}),
; 		               MinerUtils::mk_pattern(X, {InhXC}) });

; 	logger().debug() << "cpp_results = " << oc_to_string(cpp_results);
; 	logger().debug() << "cpp_expected = " << oc_to_string(cpp_expected);

; 	TS_ASSERT(content_eq(cpp_results, cpp_expected));

; 	// Run URE pattern miner
; 	Handle ure_results = ure_pm(db, 2, 10),
; 		ure_expected = mk_minsup_evals(2,
; 		                               { top,
; 		                                 MinerUtils::mk_pattern(VarXY, {InhXY}),
; 		                                 MinerUtils::mk_pattern(Y, {InhAY}),
; 		                                 MinerUtils::mk_pattern(X, {InhXC}) });

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results);
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(content_eq(ure_results, ure_expected));
; }

(= (test_AB_AC_BC)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance A C)))
        ($dbadd3 (add-atom &testspace (Inheritance B C)))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance A C)))
        ($dbrem3 (remove-atom &testspace (Inheritance B C)))
        ($cnd (collapse (match &cndpspace (CandidatePattern $pattern $cnt) $pattern)))
    )$cnd)
)

; !(assertEqual (test_AB_AC_BC) ((Inheritance A Z) (Inheritance Z C) (Inheritance Z (S Z))))
; ==========================================================================================================================

; void MinerUTest::test_AB_ABC()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle InhAB = al(INHERITANCE_LINK, A, B),
; 		InhABC = al(INHERITANCE_LINK, A, al(AND_LINK, B, C));
; 	HandleSeq db{A, B, C, InhAB, InhABC};

; 	// Define pattern parts
; 	Handle VarXY = al(VARIABLE_SET, X, Y),
; 		InhXY = al(INHERITANCE_LINK, X, Y),
; 		InhAY = al(INHERITANCE_LINK, A, Y);

; 	// Run C++ pattern miner
; 	HandleTree cpp_results = cpp_pm(db, 2),
; 		cpp_expected({ HandleTree(MinerUtils::mk_pattern(VarXY, {InhXY}),
; 		                          { MinerUtils::mk_pattern(Y, {InhAY}) }) });


; 	logger().debug() << "cpp_results = " << oc_to_string(cpp_results);
; 	logger().debug() << "cpp_expected = " << oc_to_string(cpp_expected);

; 	TS_ASSERT(content_eq(cpp_results, cpp_expected));

; 	// Run URE pattern miner
; 	Handle ure_results = ure_pm(db, 2, 10),
; 		ure_expected = mk_minsup_evals(2,
; 		                               { top,
; 		                                 MinerUtils::mk_pattern(VarXY, {InhXY}),
; 		                                 MinerUtils::mk_pattern(Y, {InhAY}) });

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results);
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(content_eq(ure_results, ure_expected));
; }

(= (test_AB_ABC)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance A (And B C))))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 2 0 False)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance A (And B C))))
        ($cnd (collapse (match &cndpspace (CandidatePattern $pattern $cnt) $pattern)))
    )$cnd)
)

; !(assertEqual (test_AB_ABC) ((Inheritance A Z) (Inheritance Z (S Z))))
; ======================================================================================================================

; void MinerUTest::test_ABCD()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle InhAB = al(INHERITANCE_LINK, A, B),
; 		InhCD = al(INHERITANCE_LINK, C, D),
; 		InhEF = al(INHERITANCE_LINK, E, F),
; 		InhGH = al(INHERITANCE_LINK, G, H),
; 		ImpABCD = al(IMPLICATION_LINK, InhAB, InhCD),
; 		ImpEFGH = al(IMPLICATION_LINK, InhEF, InhGH);
; 	HandleSeq db{InhAB, InhCD, InhEF, InhGH, ImpABCD, ImpEFGH};

; 	// Define pattern parts
; 	Handle InhXY = al(INHERITANCE_LINK, X, Y),
; 		InhZW = al(INHERITANCE_LINK, Z, W),
; 		ImpXY = al(IMPLICATION_LINK, X, Y);

; 	// Define initpat
; 	Handle initpat = MinerUtils::mk_pattern_no_vardecl({ImpXY});

; 	// Run C++ pattern miner

; 	HandleTree cpp_results = cpp_pm(db, 2, 1, initpat),
; 		cpp_expected{ HandleTree(MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, Z, InhXY)}),
; 		                         { MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, InhZW, InhXY)})}),
; 		              HandleTree(MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, InhXY, Z)}),
; 		                         { MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, InhZW, InhXY)}) })
; 		};

; 	logger().debug() << "cpp_results = " << oc_to_string(cpp_results);
; 	logger().debug() << "cpp_expected = " << oc_to_string(cpp_expected);

; 	TS_ASSERT(content_eq(cpp_expected, cpp_results));

; 	// Run URE pattern miner
; 	Handle ure_results = ure_pm(db, 2, 10, initpat),
; 		ure_expected = mk_minsup_evals(2,
; 		                               { MinerUtils::mk_pattern_no_vardecl({ImpXY}),
; 		                                 MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, Z, InhXY)}),
; 		                                 MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, InhXY, Z)}),
; 		                                 MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, InhZW, InhXY)}) });

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results);
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(content_eq(ure_expected, ure_results));
; }


(= (test_ABCD)
    (let*(
        ($dbadd5 (add-atom &testspace (Implication (Inheritance A B) (Inheritance C D))))
        ($dbadd6 (add-atom &testspace (Implication (Inheritance E F) (Inheritance G H))))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 2 0 False)))
        ($dbrem5 (remove-atom &testspace (Implication (Inheritance A B) (Inheritance C D))))
        ($dbrem6 (remove-atom &testspace (Implication (Inheritance E F) (Inheritance G H))))
        ($cnd (collapse (match &cndpspace (CandidatePattern $pattern $cnt) $pattern)))
    )
$cnd
    )
)
; !(assertEqual (test_ABCD) ((Implication (Inheritance Z (S Z)) (Inheritance (S (S Z)) (S (S (S Z))))) (Implication (Inheritance Z (S Z)) (S (S Z))) (Implication Z (Inheritance (S Z) (S (S Z)))) (Implication Z (S Z))))
; ==========================================================================================================================================================

; void MinerUTest::test_ABAB()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle InhAB = al(INHERITANCE_LINK, A, B),
; 		InhBC = al(INHERITANCE_LINK, B, C),
; 		ImpABAB = al(IMPLICATION_LINK, InhAB, InhAB),
; 		ImpBCBC = al(IMPLICATION_LINK, InhBC, InhBC);
; 	HandleSeq db{ImpABAB, ImpBCBC};

; 	// Define pattern parts
; 	Handle VarXY = al(VARIABLE_SET, X, Y),
; 		InhXY = al(INHERITANCE_LINK, X, Y),
; 		ImpXY = al(IMPLICATION_LINK, X, Y);

; 	// Define initpat
; 	Handle initpat = MinerUtils::mk_pattern_no_vardecl({ImpXY});

; 	// Run C++ pattern miner
; 	HandleTree cpp_results = cpp_pm(db, 2, 1, initpat);
; 	Handle cpp_expected =
; 		MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, InhXY, InhXY)});

; 	logger().debug() << "cpp_results = " << oc_to_string(cpp_results);
; 	logger().debug() << "cpp_expected = " << oc_to_string(cpp_expected);

; 	TS_ASSERT(content_contains(cpp_results, cpp_expected));

; 	// Run URE pattern miner
; 	Handle ure_results = ure_pm(db, 2, 10, initpat),
; 		ure_expected = mk_minsup_eval(2,
; 		                              MinerUtils::mk_pattern(VarXY,
; 		                                                     {al(IMPLICATION_LINK,
; 		                                                         InhXY,
; 		                                                         InhXY)}));

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results);
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(contains(ure_results->getOutgoingSet(), ure_expected));
; }

(= (test_ABAB)
    (let*(
        ($dbadd5 (add-atom &testspace (Implication (Inheritance A B) (Inheritance A B))))
        ($dbadd6 (add-atom &testspace (Implication (Inheritance B C) (Inheritance B C))))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 2 0 False)))
        ($dbrem5 (remove-atom &testspace (Implication (Inheritance A B) (Inheritance A B))))
        ($dbrem6 (remove-atom &testspace (Implication (Inheritance B C) (Inheritance B C))))
        ($cnd (collapse (match &cndpspace (CandidatePattern $pattern $cnt) $pattern)))
    )
$cnd
    )
)

; !(assertEqual (intersection-atom (test_ABAB) ((Implication (Inheritance Z (S Z)) (Inheritance Z (S Z))))) ((Implication (Inheritance Z (S Z)) (Inheritance Z (S Z)))))
 ; ===============================================================================================================================

; void MinerUTest::test_AAAA()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle AA = al(INHERITANCE_LINK, A, A),
; 		BB = al(INHERITANCE_LINK, B, B),
; 		AAAA = al(IMPLICATION_LINK, AA, AA),
; 		BBBB = al(IMPLICATION_LINK, BB, BB);
; 	HandleSeq db{AAAA, BBBB};

; 	// Define pattern parts
; 	Handle InhXX = al(INHERITANCE_LINK, X, X); 

; 	// Define initpat
; 	Handle initpat =
; 		MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK, X, Y)});

; 	// Run C++ pattern miner
; 	HandleTree cpp_results = cpp_pm(db, 2, 1, initpat);
; 	Handle cpp_expected = MinerUtils::mk_pattern_no_vardecl({al(IMPLICATION_LINK,
; 	                                                            InhXX,
; 	                                                            InhXX)});

; 	logger().debug() << "cpp_results = " << oc_to_string(cpp_results);
; 	logger().debug() << "cpp_expected = " << oc_to_string(cpp_expected);

; 	TS_ASSERT(content_contains(cpp_results, cpp_expected));

; 	// Run URE pattern miner
; 	Handle ure_results = ure_pm(db, 2, 50, initpat),
; 		ure_body = al(IMPLICATION_LINK,
; 		              InhXX,
; 		              InhXX),
; 		ure_expected = mk_minsup_eval(2,
; 		                              MinerUtils::mk_pattern_no_vardecl({ure_body}));

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results);
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(contains(ure_results->getOutgoingSet(), ure_expected));
; }

(= (test_AAAA)
    (let*(
        ($dbadd5 (add-atom &testspace (Implication (Inheritance A A) (Inheritance A A))))
        ($dbadd6 (add-atom &testspace (Implication (Inheritance B B) (Inheritance B B))))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 2 0 False)))
        ($dbrem5 (remove-atom &testspace (Implication (Inheritance A A) (Inheritance A A))))
        ($dbrem6 (remove-atom &testspace (Implication (Inheritance B B) (Inheritance B B))))
        ($cnd (collapse (match &cndpspace (CandidatePattern $pattern $cnt) $pattern)))

    )
$cnd
    )
)

; !(assertEqual (intersection-atom (test_AAAA) ((Implication (Inheritance Z Z) (Inheritance Z Z)))) ((Implication (Inheritance Z Z) (Inheritance Z Z))))
; =========================================================================================================================

; void MinerUTest::test_transitivity()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Mine transitivity pattern using incremental conjunction
; 	// expansion. Check with and without enforce specialization.

; 	// Define db
; 	Handle
; 		InhAB = al(INHERITANCE_LINK, A, B),
; 		InhBC = al(INHERITANCE_LINK, B, C);
; 	HandleSeq db{InhAB, InhBC};

; 	// Run URE pattern miner without enforcing specialization (which is
; 	// necessary to mine transitivity).
; 	int ms = 1;
; 	unsigned max_conjuncts = 2;
; 	unsigned max_variables = 3;
; 	unsigned max_spcial_conjuncts = 1;
; 	unsigned max_cnjexp_variables = 3;
; 	bool enforce_specialization = false;
; 	Handle results = ure_pm(db, ms, 50, top, true,
; 	                        max_conjuncts, max_variables,
; 	                        max_spcial_conjuncts, max_cnjexp_variables,
; 	                        enforce_specialization);
; 	HandleSeq clauses = {al(INHERITANCE_LINK, X, Y),
; 	                     al(INHERITANCE_LINK, Y, Z)};
; 	Handle expected = mk_minsup_eval(ms,
; 	                                 MinerUtils::mk_pattern_no_vardecl(clauses));

; 	logger().debug() << "results = " << oc_to_string(results);
; 	logger().debug() << "expected = " << oc_to_string(expected);

; 	TS_ASSERT(contains(results->getOutgoingSet(), expected));
; }

(= (test_transitivity)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance B C)))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 1 0 True)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance B C)))
        ($conj (collapse (match &conjspace $pattern $pattern)))
    )$conj)
)

; !(assertEqual (intersection-atom (test_transitivity) ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z)))))) ((, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z))))))
; ======================================================================================================================

; void MinerUTest::test_long_transitivity()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Mine transitivity pattern using incremental conjunction
; 	// expansion. Check with and without enforce specialization.

; 	// Define db
; 	Handle
; 		InhAB = al(INHERITANCE_LINK, A, B),
; 		InhBC = al(INHERITANCE_LINK, B, C),
; 		InhCD = al(INHERITANCE_LINK, C, D);
; 	HandleSeq db{InhAB, InhBC, InhCD};

; 	// Run URE pattern miner without enforcing specialization (which is
; 	// necessary to mine transitivity).
; 	int ms = 1;
; 	int max_iteration = 200;
; 	bool conjunction_expansion = true;
; 	unsigned max_conjuncts = 3;
; 	unsigned max_variables = 4;
; 	unsigned max_spcial_conjuncts = 1;
; 	unsigned max_cnjexp_variables = 4;
; 	bool enforce_specialization = false;
; 	double complexity_penalty = 1.0;
; 	Handle results = ure_pm(db, ms, max_iteration, top, conjunction_expansion,
; 	                        max_conjuncts, max_variables,
; 	                        max_spcial_conjuncts, max_cnjexp_variables,
; 	                        enforce_specialization, complexity_penalty);
; 	HandleSeq clauses = {al(INHERITANCE_LINK, X, Y),
; 	                     al(INHERITANCE_LINK, Y, Z),
; 	                     al(INHERITANCE_LINK, Z, W)};
; 	Handle expected = mk_minsup_eval(ms,
; 	                                 MinerUtils::mk_pattern_no_vardecl(clauses));

; 	logger().debug() << "results = " << oc_to_string(results);
; 	logger().debug() << "expected = " << oc_to_string(expected);

; 	TS_ASSERT(contains(results->getOutgoingSet(), expected));
; }

(= (test_long_transitivity)
    (let*(
        ($dbadd1 (add-atom &testspace (Inheritance A B)))
        ($dbadd2 (add-atom &testspace (Inheritance B C)))
        ($dbadd2 (add-atom &testspace (Inheritance C D)))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 1 1 True)))
        ($dbrem1 (remove-atom &testspace (Inheritance A B)))
        ($dbrem2 (remove-atom &testspace (Inheritance B C)))
        ($dbrem2 (remove-atom &testspace (Inheritance C D)))
        ($conj (collapse (match &conjspace $pattern $pattern)))
    )$conj)
)

; !(assertEqual (intersection-atom (test_long_transitivity) ((, (, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z)))) (Inheritance (S (S Z)) (S (S (S Z))))))) ((, (, (Inheritance Z (S Z)) (Inheritance (S Z) (S (S Z)))) (Inheritance (S (S Z)) (S (S (S Z)))))))
 ; ==========================================================================================================================

; void MinerUTest::test_SodaDrinker_incremental()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	// Load ugly-male-soda-drinker-corpus.scm
; 	std::string rs =
; 		_tmp_scm.eval("(load-from-path \"ugly-male-soda-drinker-corpus.scm\")");
; 	logger().debug() << "rs = " << rs;

; 	// Start from top, conjunctions will be grown incrementally
; 	Handle initpat = top;

; 	// Note: move the definition of 'expected' here to reproduce weird
; 	// bug (the pattern is ignored by surprisingness).

; 	// Run URE pattern miner
; 	bool conjunction_expansion = true;
; 	unsigned max_conjuncts = 3;
; 	unsigned max_variables = 2;
; 	unsigned max_spcial_conjuncts = 1;
; 	unsigned max_cnjexp_variables = 1;
; 	bool enforce_specialization = true;
; 	double complexity_penalty = 1;
; 	int minsup = 5;
; 	int max_iteration = 100;
; 	Handle ure_results = ure_pm(_tmp_as, minsup, max_iteration,
; 	                            initpat,
; 	                            conjunction_expansion,
; 	                            max_conjuncts, max_variables,
; 	                            max_spcial_conjuncts, max_cnjexp_variables,
; 	                            enforce_specialization,
; 	                            complexity_penalty);

; 	// The pattern of interest looks like
; 	//
; 	// Lambda
; 	//   X
; 	//   Present
; 	//     Inheritance
; 	//       X
; 	//       Concept "man"
; 	//     Inheritance
; 	//       X
; 	//       Concept "soda drinker"
; 	//     Inheritance
; 	//       X
; 	//       Concept "ugly"
; 	Handle expected = MinerUTestUtils::add_ugly_man_soda_drinker_pattern(_as);

; 	logger().debug() << "expected = " << oc_to_string(expected);

; 	Handle ure_expected = mk_minsup_eval(minsup, expected);

; 	logger().debug() << "ure_results = " << oc_to_string(ure_results->getOutgoingSet());
; 	logger().debug() << "ure_expected = " << oc_to_string(ure_expected);

; 	TS_ASSERT(contains(ure_results->getOutgoingSet(), ure_expected));

; 	// Test I-Surprisingness
; 	std::string mode("nisurp-old");
; 	HandleSeq surp_results = MinerUTestUtils::ure_surp(_as, _scm, surp_rb,
; 	                                                   mode, max_conjuncts);
; 	Handle surp_result = surp_results.front();

; 	logger().debug() << "surp_results = " << oc_to_string(surp_results);

; 	TS_ASSERT(content_eq(expected, MinerUTestUtils::get_pattern(surp_result)));
; }

(= (test_SodaDrinker_incremental)
    (let* (
        ($add (collapse (match &dbspace $atom (add-atom &testspace $atom))))
        ($res (collapse (frequency-pattern-miner &testspace $x &cndpspace &conjspace 5 1 True)))
        ($conj (collapse (match &conjspace $pattern $pattern)))
        ($uniq (unique-atom $conj))
    )$uniq)
)

; !(assertEqual (intersection-atom (test_SodaDrinker_incremental) ((, (, (Inheritance Z man) (Inheritance Z sodaDrinker)) (Inheritance Z ugly)))) ((, (, (Inheritance Z man) (Inheritance Z sodaDrinker)) (Inheritance Z ugly))))

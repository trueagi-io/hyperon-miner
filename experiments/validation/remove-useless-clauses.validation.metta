!(import! &self ../utils/common-utils)
!(import! &self ../utils/index_to_var)
!(import! &self ../utils/surp-utils/blk-abstractness)
!(import! &self ../utils/surp-utils/partition-metta)
!(import! &self ../utils/remove_useless_clauses)



; void MinerUTest:: xtest_remove_useless_clauses_2()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Clause 3 is more abstract than all clauses of the pattern and
; 	// does not introduce new variables, therefore it is redundant and
; 	// can be removed.
; 	Handle
; 		vardecl = al(VARIABLE_SET, X, Y),
; 		clause1 = al(INHERITANCE_LINK, X, C1),
; 		clause2 = al(INHERITANCE_LINK, C2, Y),
; 		clause3 = al(INHERITANCE_LINK, X, Y),
; 		pattern = MinerUtils::mk_pattern(vardecl, {clause1, clause2, clause3});

; 	Handle
; 		reduced = MinerUtils::remove_useless_clauses(pattern),
; 		expect = MinerUtils::mk_pattern(vardecl, {clause1, clause2});

; 	logger().debug() << "pattern = " << oc_to_string(pattern);
; 	logger().debug() << "reduced = " << oc_to_string(reduced);
; 	logger().debug() << "expect = " << oc_to_string(expect);

; 	// First check the result is as expected
; 	TS_ASSERT(content_eq(reduced, expect));

; 	// Second check that both pattern and result have the same matches
; 	unsigned n_cpts = 100;
; 	Type node_t = CONCEPT_NODE;
; 	HandleSeq cpts = MinerUTestUtils::populate_nodes(_as, n_cpts, node_t, "C");
; 	Type link_t = INHERITANCE_LINK;
; 	MinerUTestUtils::populate_links(_as, cpts, link_t, 2, 0.1);
; 	// logger().debug() << "_as = " << _as;
; 	GetLinkPtr pattern_gl = createGetLink(HandleSeq{pattern});
; 	Handle pattern_results = HandleCast(pattern_gl->execute(&_as));
; 	GetLinkPtr reduced_gl = createGetLink(HandleSeq{reduced});
; 	Handle reduced_results = HandleCast(pattern_gl->execute(&_as));

; 	logger().debug() << "pattern_results = " << oc_to_string(pattern_results);
; 	logger().debug() << "reduced_results = " << oc_to_string(reduced_results);

; 	TS_ASSERT_EQUALS(pattern_results, reduced_results);
; }

!(assertEqual (remove_useless_clauses ((Inheritance $x ugly) (Inheritance Allen $y) (Inheritance $x $y))) ((Inheritance $x ugly) (Inheritance Allen $y)))

; ==================================================================================================================================

; void MinerUTest:: test_remove_useless_clauses_3()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// No clause is more abstract than the others, thus nothing should
; 	// be removed.
; 	Handle
; 		vardecl = al(VARIABLE_SET, X, Y, Z, W),
; 		clause1 = al(INHERITANCE_LINK, X, Y),
; 		clause2 = al(INHERITANCE_LINK, Y, Z),
; 		clause3 = al(INHERITANCE_LINK, Z, W),
; 		pattern = MinerUtils::mk_pattern(vardecl, {clause1, clause2, clause3});

; 	Handle
; 		reduced = MinerUtils::remove_useless_clauses(pattern),
; 		expect = pattern;

; 	logger().debug() << "pattern = " << oc_to_string(pattern);
; 	logger().debug() << "reduced = " << oc_to_string(reduced);
; 	logger().debug() << "expect = " << oc_to_string(expect);

; 	// Check the result is as expected
; 	TS_ASSERT(content_eq(reduced, expect));
; }

!(assertEqual (remove_useless_clauses ((Inheritance $x $y) (Inheritance $y $z) (Inheritance $z $w))) ((Inheritance $x $y) (Inheritance $y $z) (Inheritance $z $w)))

; ==================================================================================================================================

; void MinerUTest::test_is_more_abstract_foreach_var()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// No clause is more abstract than the others, thus nothing should
; 	// be removed.
; 	Handle
; 		clause1 = al(INHERITANCE_LINK, X, Y),
; 		clause2 = al(INHERITANCE_LINK, Y, Z),
; 		clause3 = al(INHERITANCE_LINK, Z, W);

; 	bool
; 		result = MinerUtils::is_more_abstract_foreach_var(clause2,
; 		                                                  { clause1, clause3 }),
; 		expect = false;

; 	logger().debug() << "result = " << result;
; 	logger().debug() << "expect = " << expect;

; 	// Check the result is as expected
; 	TS_ASSERT_EQUALS(result, expect);
; }

!(assertEqual (is_more_abstract_for_each_var (Inheritance $y $z) ((Inheritance $x $y) (Inheritance $z $w))) False)
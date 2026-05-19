 ;  * cnjtion = (Inheritance X Y)
 ;  * pattern = (Inheritance Z W)

!(import! &self ../utils/common-utils)
!(import! &self ../utils/index_to_var)
!(import! &self ../utils/variable-combinations)
!(import! &self ../frequent-pattern-miner/conjunction-expansion)

;; test knowledge base
(Inheritance A B)
(Inheritance B C)
(INHERITANCE_LINK A B)
(LIST_LINK A B)

; void MinerUTest::test_expand_conjunction_3()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle
; 		InhAB = al(INHERITANCE_LINK, A, B),
; 		InhBC = al(INHERITANCE_LINK, B, C);
; 	HandleSeq db{InhAB, InhBC};

; 	Handle InhXY = al(INHERITANCE_LINK, X, Y),
; 		VarXY = al(VARIABLE_SET, X, Y),
; 		pat = MinerUtils::mk_pattern(VarXY, {InhXY});

; 	HandleSet results = MinerUtils::expand_conjunction(pat, pat, db, 1,
; 	                                                   UINT_MAX, false);
; 	Handle
; 		InhXW = al(INHERITANCE_LINK, X, W),
; 		InhZX = al(INHERITANCE_LINK, Z, X),
; 		InhYW = al(INHERITANCE_LINK, Y, W),
; 		InhZY = al(INHERITANCE_LINK, Z, Y),
; 		VarXYW = al(VARIABLE_SET, X, Y, W),
; 		VarXYZ = al(VARIABLE_SET, X, Y, Z),
; 		InhXYXW = MinerUtils::mk_pattern(VarXYW, {InhXY, InhXW}),
; 		InhXYZX = MinerUtils::mk_pattern(VarXYZ, {InhXY, InhZX}),
; 		InhXYYW = MinerUtils::mk_pattern(VarXYW, {InhXY, InhYW}),
; 		InhXYZY = MinerUtils::mk_pattern(VarXYZ, {InhXY, InhZY});
; 	HandleSet expected{InhXYXW, InhXYZX, InhXYYW, InhXYZY};

; 	logger().debug() << "results = " << oc_to_string(results);
; 	logger().debug() << "expected = " << oc_to_string(expected);

; 	TS_ASSERT(content_eq(results, expected));

; 	// Same as above but enforce specialization
; 	HandleSet es_results = MinerUtils::expand_conjunction(pat, pat, db, 1,
; 	                                                      UINT_MAX, true);
; 	HandleSet es_expected{};
; 	TS_ASSERT(content_eq(es_results, es_expected));
; }


!(expand_conjunction (Inheritance $X $Y) (Inheritance $Z $W) &self 1 2 False)
;;EXPECTED
; [ (, (Inheritance $X $Y) (Inheritance $X $Y)),
;; THE ABOVE IS INCLUDED BECAUSE THE REMOVAL OF REDUNDANT CLAUSES IS NOT INCLUDED YET
;   (, (Inheritance $X $Y) (Inheritance $Z $Y)), 
;  (, (Inheritance $X $Y) (Inheritance $Y $W)),
;   (, (Inheritance $X $Y) (Inheritance $Z $X)), 
;   (, (Inheritance $X $Y) (Inheritance $X $W))]

; ======================================================================================================

; void MinerUTest::test_expand_conjunction_4()
; {
; 	logger().info("BEGIN TEST: %s", __FUNCTION__);

; 	// Define db
; 	Handle
; 		InhAB = al(INHERITANCE_LINK, A, B),
; 		LstAB = al(LIST_LINK, A, B);
; 	HandleSeq db{InhAB, LstAB};

; 	Handle InhXY = al(INHERITANCE_LINK, X, Y),
; 		LstXY = al(LIST_LINK, X, Y),
; 		VarXY = al(VARIABLE_SET, X, Y),
; 		p1 = al(LAMBDA_LINK,
; 		        VarXY,
; 		        InhXY),
; 		p2 = al(LAMBDA_LINK,
; 		        VarXY,
; 		        LstXY);

; 	HandleSet results = MinerUtils::expand_conjunction(p1, p2, db, 1,
; 	                                                   UINT_MAX, false);
; 	Handle
; 		InhXZ = al(INHERITANCE_LINK, X, Z),
; 		InhZY = al(INHERITANCE_LINK, Z, Y),
; 		LstXZ = al(LIST_LINK, X, Z),
; 		LstZY = al(LIST_LINK, Z, Y),
; 		VarXYZ = al(VARIABLE_SET, X, Y, Z),
; 		InhXYLstXZ = MinerUtils::mk_pattern(VarXYZ,
; 		                                    {InhXY, LstXZ}),
; 		InhXYLstZY = MinerUtils::mk_pattern(VarXYZ,
; 		                                    {InhXY, LstZY}),
; 		InhXYLstXY = MinerUtils::mk_pattern(VarXY,
; 		                                    {InhXY, LstXY});
; 	HandleSet expected{InhXYLstXZ, InhXYLstZY, InhXYLstXY};

; 	logger().debug() << "results = " << oc_to_string(results);
; 	logger().debug() << "expected = " << oc_to_string(expected);

; 	TS_ASSERT(content_eq(results, expected));
; }
!(expand_conjunction (INHERITANCE_LINK $X $Y) (LIST_LINK $Z $W) &self 1 2 False)
;;EXPECTED
; [ (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $Y)), 
; (, (INHERITANCE_LINK $X $Y) (LIST_LINK $Z $Y)),
;  (, (INHERITANCE_LINK $X $Y) (LIST_LINK $X $W))]



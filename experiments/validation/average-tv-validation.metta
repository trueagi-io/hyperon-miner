!(import! &self ../utils/constants)
!(import! &self ../utils/common-utils)
!(import! &self ../utils/TruthValue)
!(import! &self ../utils/surp-utils/beta-dist)
!(import! &self ../utils/surp-utils/surp-utils)
!(import! &self ../../utils/surp-utils/partition-metta)
!(import! &self ../utils/gen_partition)
!(import! &self ../utils/miner-utils)
!(import! &self ../truth-values/est-tv)
!(import! &self ../truth-values/emp-tv)
!(import! &kb ../data/ugly_man_sodaDrinker)

( = (square $x) (* $x $x))


; The slight diffrences in the expected variance from the classic miner vs what we are getting in the ported version most likely arises from the approximations we used for contants.
;=============================================================================
; avrg_tv test case 1 from classic miner repo
	; TruthValuePtr
	; 	tv1 = createSimpleTruthValue(0, 0.1),
	; 	tv2 = createSimpleTruthValue(0, 0.1),
	; 	result = Surprisingness::avrg_tv({tv1, tv2}),

     ;expected mean of 0 and variance(confidence) of 0.1
	; 	expect = createSimpleTruthValue(0, 0.1);




(=(test_avrg_tv_1)(
    let* (
       ($tv_1  (STV 0 0.1))
       ($tv_2  (STV 0 0.1))
       ($result (eval (avrg_tv ($tv_1 $tv_2))))

    )
    $result 
))
!(test (test_avrg_tv_1) (0 0.09999999999999999))

;========================================================
;avrg_tv test case 2 from classic miner repo

    ;     	TruthValuePtr
	; 	tv1 = createSimpleTruthValue(0, 0.1),
	; 	tv2 = createSimpleTruthValue(1, 0.1),
	; 	result = Surprisingness::avrg_tv({tv1, tv2}),

    ;expected mean of 0.5 and variance(confidence) of 0.000125 
	; 	expect = createSimpleTruthValue(0.5, 0.000125);



(=(test_avrg_tv_2)(
    let* (
       ($tv_1  (STV 0 0.1))
       ($tv_2  (STV 1 0.1))
       ($result  (avrg_tv ($tv_1 $tv_2)))

    )
    $result 
))
!(test (test_avrg_tv_2) (0.5 0.0001249843769528809))

;=================================================================
;avrg_tv test case 3 from classic miner repo

        ; TruthValuePtr
		; tv0 = createSimpleTruthValue(1, 0.001248),
		; tv1 = createSimpleTruthValue(1, 0.001248),
		; tv2 = createSimpleTruthValue(0, 0.001248),
		; tv3 = createSimpleTruthValue(1, 0.001248),
		; tv4 = createSimpleTruthValue(1, 0.001248),
		; tv5 = createSimpleTruthValue(1, 0.001248),
		; tv6 = createSimpleTruthValue(1, 0.001248),
		; tv7 = createSimpleTruthValue(1, 0.001248),
		; tv8 = createSimpleTruthValue(1, 0.001248),
		; tv9 = createSimpleTruthValue(1, 0.001248),
		; result = Surprisingness::avrg_tv({tv0, tv1, tv2, tv3, tv4,
		;                                   tv5, tv6, tv7, tv8, tv9}),
		; // Weirdly enough the result is 1 for the mode, which might
		; // actually be correct, would need to carefully check the math.

         ;expected truth of 1 and variance(confidence) of 0.000677 
		; expect = createSimpleTruthValue(1, 0.000677);


(=(test_avrg_tv_3)(
    let* (
       ($tv_1  (STV 1 0.001248))
       ($tv_2  (STV 1 0.001248))
       ($tv_3  (STV 0 0.001248))
       ($tv_4  (STV 1 0.001248))
       ($tv_5  (STV 1 0.001248))
       ($tv_6  (STV 1 0.001248))
       ($tv_7  (STV 1 0.001248))
       ($tv_8  (STV 1 0.001248))
       ($tv_9  (STV 1 0.001248))
       ($tv_10  (STV 1 0.001248))
        
       ($result (avrg_tv ($tv_1 $tv_2 $tv_3 $tv_4 $tv_5 $tv_6 $tv_7 $tv_8 $tv_9  $tv_10 )))

    )
    $result 
))

!(test (test_avrg_tv_3) (1 0.0006774324781404488))

;==================================


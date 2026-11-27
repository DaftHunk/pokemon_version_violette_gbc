Route16WestGateObject:
	db $17 ; border block

	db 2 ; warps
	warp  2, 17,  1, ROUTE_16_WEST
	warp  3, 17,  2, ROUTE_16_WEST

	db 4 ; signs
	sign  4,  3, 1 ; Route16WestGateAquariumText
	sign 2, 8, 2 ; Route16WestGatePCText
	sign 0, 8, 3 ; Route16WestGateLettersText
	sign  7,  3, 4 ; Route16WestGateSafeText

	db 0 ; objects

	; warp-to
	warp_to  2, 17, ROUTE_16_WEST_GATE_WIDTH
	warp_to  3, 17, ROUTE_16_WEST_GATE_WIDTH

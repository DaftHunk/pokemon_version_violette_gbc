Route12GateUpstairsObject:
	db $a ; border block

	db 1 ; warps
	warp 7, 7, 4, ROUTE_12_GATE_1F

	db 1 ; signs
	sign 6, 2, 2 ; Route12GateUpstairsText

	db 1 ; objects
	object SPRITE_BRUNETTE_GIRL, 3, 4, WALK, 1, 1 ; person

	; warp-to
	warp_to 7, 7, ROUTE_12_GATE_2F_WIDTH ; ROUTE_12_GATE_1F

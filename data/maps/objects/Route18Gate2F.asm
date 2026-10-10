Route18GateUpstairsObject:
	db $a ; border block

	db 1 ; warps
	warp 7, 7, 4, ROUTE_18_GATE_1F

	db 1 ; signs
	sign 1, 2, 2 ; Route18GateUpstairsText

	db 1 ; objects
	object SPRITE_BUG_CATCHER, 4, 2, WALK, 2, 1 ; person

	; warp-to
	warp_to 7, 7, ROUTE_18_GATE_2F_WIDTH ; ROUTE_18_GATE_1F

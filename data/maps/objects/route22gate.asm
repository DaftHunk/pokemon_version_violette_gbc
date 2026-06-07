Route22GateObject:
	db $a ; border block

	db 6 ; warps
	warp 4, 7, 0, -1
	warp 5, 7, 0, -1
	warp 4, 0, 0, -1
	warp 5, 0, 1, -1
	warp 0, 7, 0, ROUTE_22_GATE_UPSTAIRS
	warp 9, 7, 1, ROUTE_22_GATE_UPSTAIRS

	db 0 ; signs

	db 2 ; objects
	object SPRITE_GUARD,       6, 2, STAY, LEFT, 1 ; person
	object SPRITE_BUG_CATCHER, 1, 5, WALK, 0,    2 ; person
	
	; warp-to
	warp_to 4, 7, ROUTE_22_GATE_WIDTH
	warp_to 5, 7, ROUTE_22_GATE_WIDTH
	warp_to 4, 0, ROUTE_22_GATE_WIDTH
	warp_to 5, 0, ROUTE_22_GATE_WIDTH
	warp_to 0, 7, ROUTE_22_GATE_WIDTH
	warp_to 9, 7, ROUTE_22_GATE_WIDTH

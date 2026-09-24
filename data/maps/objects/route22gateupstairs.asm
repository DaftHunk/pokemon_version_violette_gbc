Route22GateUpstairsObject:
	db $a ; border block

	db 2 ; warps	
	warp  0,  7, 4, ROUTE_22_GATE
	warp  9,  7, 5, ROUTE_22_GATE

	db 3 ; signs
	sign  2,  3, 4 ; Route22GateUpstairsText_Champion
	sign  1,  3, 5 ; Route22GateUpstairsText_Champion
	sign  7,  2, 6 ; Route22GateUpstairsText_Binoculars
	

	db 3 ; objects
	object SPRITE_OAK_AIDE,  9,  4, STAY, LEFT, 1 ; person
	object SPRITE_CUP,       6,  7, STAY, NONE, 2
	object SPRITE_CUP,       3,  7, STAY, NONE, 3
	
	; warp-to	
	warp_to  0,  7, ROUTE_22_GATE_UPSTAIRS_WIDTH
	warp_to  9,  7, ROUTE_22_GATE_UPSTAIRS_WIDTH

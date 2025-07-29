Route19Object:
;joenote - add a sign and npc for the drink stand
	db $43 ; border block

	db 1 ; warps
	warp 3, 7, 0, ROUTE_19_BEACH_HOUSE

	db 3
	sign 11,  9, 12 ; Route19Text11
	sign  5, 11, 13 ; _TXTDrinkStandSign
	sign  3,  9, 14

;	db 10 ; objects
	db 11 ; objects
	object SPRITE_BLACK_HAIR_BOY_1, 6, 7, STAY, RIGHT, 1, OPP_SWIMMER, 2
	object SPRITE_BLACK_HAIR_BOY_1, 13, 7, STAY, LEFT, 2, OPP_SWIMMER, 3
	object SPRITE_SWIMMER, 13, 25, STAY, LEFT, 3, OPP_SWIMMER, 4
	object SPRITE_SWIMMER, 4, 27, STAY, RIGHT, 4, OPP_SWIMMER, 5
	object SPRITE_SWIMMER, 16, 31, STAY, UP, 5, OPP_SWIMMER, 6
	object SPRITE_SWIMMER, 9, 11, STAY, DOWN, 6, OPP_SWIMMER, 7
	object SPRITE_SWIMMER, 8, 43, STAY, LEFT, 7, OPP_BEAUTY, 8
	object SPRITE_SWIMMER, 11, 43, STAY, RIGHT, 8, OPP_BEAUTY, 9
	object SPRITE_SWIMMER, 9, 42, STAY, UP, 9, OPP_SWIMMER, 8
	object SPRITE_SWIMMER, 10, 44, STAY, DOWN, 10, OPP_BEAUTY, 10
	object SPRITE_FISHER2, 1, 10, STAY, RIGHT, 11 ; person
	
	; warp-to	
	warp_to 3, 7, ROUTE_19_WIDTH
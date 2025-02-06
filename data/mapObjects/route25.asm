Route25Object:
	db $2c ; border block

	;db 1 ; warps
	db 2
	warp 45, 3, 0, BILLS_HOUSE
	warp 45, 0, 2, BILLS_HOUSE	;warp away from Bill's Secret Garden

	db 1 ; signs
	sign 43, 3, 12 ; Route25Text11	;joenote - reassigning to position 12

	db 11 ; objects
	object SPRITE_BUG_CATCHER, 14, 2, STAY, DOWN, 1, OPP_YOUNGSTER, 5
	object SPRITE_BUG_CATCHER, 18, 5, STAY, UP, 2, OPP_YOUNGSTER, 6
	object SPRITE_BLACK_HAIR_BOY_1, 24, 4, STAY, DOWN, 3, OPP_JR_TRAINER_M, 2
	object SPRITE_LASS, 18, 8, STAY, RIGHT, 4, OPP_LASS, 9
	object SPRITE_BUG_CATCHER, 32, 3, STAY, LEFT, 5, OPP_YOUNGSTER, 7
	object SPRITE_LASS, 37, 4, STAY, DOWN, 6, OPP_LASS, 10
	object SPRITE_HIKER, 8, 4, STAY, RIGHT, 7, OPP_HIKER, 2
	object SPRITE_HIKER, 23, 9, STAY, UP, 8, OPP_HIKER, 3
	object SPRITE_HIKER, 13, 7, STAY, RIGHT, 9, OPP_HIKER, 4
	object SPRITE_BALL, 22, 2, STAY, NONE, 10, TM19_SEISMIC_TOSS
	object SPRITE_BLACK_HAIR_BOY_1, 55, 12, STAY, RIGHT, 11	;joenote - adding in a trainer

	; warp-to
	warp_to 45, 3, ROUTE_25_WIDTH ; BILLS_HOUSE
	warp_to 45, 0, ROUTE_25_WIDTH ; joenote - warp into the secret garden behind Bill's house

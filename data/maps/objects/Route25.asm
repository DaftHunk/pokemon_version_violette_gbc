Route25Object:
	db $2c ; border block

	db 3 ; warps
	warp 45,  5, 0, BILLS_HOUSE
	warp 45,  2, 2, BILLS_HOUSE
	warp 46,  2, 2, BILLS_HOUSE

	db 1 ; signs
	sign 43,  5, 11

	db 10 ; objects
	object SPRITE_BUG_CATCHER, 14,  4, STAY, DOWN, 1, OPP_YOUNGSTER, 4
	object SPRITE_BUG_CATCHER, 18,  7, STAY, UP, 2, OPP_YOUNGSTER, 5
	object SPRITE_BLACK_HAIR_BOY_1, 24,  6, STAY, DOWN, 3, OPP_JR_TRAINER_M, 2
	object SPRITE_LASS, 18, 10, STAY, RIGHT, 4, OPP_LASS, 8
	object SPRITE_BUG_CATCHER, 32,  5, STAY, LEFT, 5, OPP_YOUNGSTER, 6
	object SPRITE_LASS, 37,  6, STAY, DOWN, 6, OPP_LASS, 9
	object SPRITE_HIKER,  8,  6, STAY, RIGHT, 7, OPP_HIKER, 2
	object SPRITE_HIKER, 23, 11, STAY, UP, 8, OPP_HIKER, 3
	object SPRITE_HIKER, 13,  9, STAY, RIGHT, 9, OPP_HIKER, 4
	object SPRITE_BALL, 22,  4, STAY, NONE, 10, TM19_SEISMIC_TOSS

	; warp-to
	warp_to 45,  5, ROUTE_25_WIDTH ; BILLS_HOUSE
	warp_to 45,  2, ROUTE_25_WIDTH ; joenote - warp into the secret garden behind Bill's house

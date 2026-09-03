Route10SouthObject:
	db $2c ; border block

	db 1 ; warps
	warp 10,  5, 1, ROCK_TUNNEL_1F

	db 1 ; signs
	sign 11,  7, 5 ; Route10Text9

	db 4 ; objects
	object SPRITE_HIKER,  4,  9, STAY, LEFT, 1, OPP_HIKER, 14
	object SPRITE_BLACK_HAIR_BOY_2, 15, 16, STAY, LEFT, 2, OPP_POKEMANIAC, 6
	object SPRITE_HIKER,  4, 15, STAY, RIGHT, 3, OPP_HIKER, 13
	object SPRITE_LASS,  9,  6, STAY, DOWN, 4, OPP_JR_TRAINER_F, 12

	; warp-to
	warp_to 10,  5, ROUTE_10_SOUTH_WIDTH ; ROCK_TUNNEL_1F

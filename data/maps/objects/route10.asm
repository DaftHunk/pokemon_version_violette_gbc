Route10Object:
	db $2c ; border block

	db 4 ; warps
	warp 11, 25, 0, ROCK_TUNNEL_POKECENTER
	warp  8, 23, 0, ROCK_TUNNEL_1F
	warp  8, 59, 2, ROCK_TUNNEL_1F
	warp  6, 45, 0, POWER_PLANT

	db 4 ; signs
	sign  7, 25, 7 ; Route10Text7
	sign 12, 25, 8 ; PokeCenterSignText
	sign  9, 61, 9 ; Route10Text9
	sign  5, 47, 10 ; Route10Text10

	db 6 ; objects
	object SPRITE_BLACK_HAIR_BOY_2, 10, 50, STAY, LEFT, 1, OPP_POKEMANIAC, 5
	object SPRITE_HIKER,  3, 63, STAY, UP, 2, OPP_HIKER, 13
	object SPRITE_BLACK_HAIR_BOY_2, 14, 70, STAY, LEFT, 3, OPP_POKEMANIAC, 6
	object SPRITE_LASS,  7, 31, STAY, LEFT, 4, OPP_JR_TRAINER_F, 11
	object SPRITE_HIKER,  3, 67, STAY, DOWN, 5, OPP_HIKER, 14
	object SPRITE_LASS,  7, 60, STAY, DOWN, 6, OPP_JR_TRAINER_F, 12

	; warp-to
	warp_to 11, 25, ROUTE_10_WIDTH ; ROCK_TUNNEL_POKECENTER
	warp_to  8, 23, ROUTE_10_WIDTH ; ROCK_TUNNEL_1F
	warp_to  8, 59, ROUTE_10_WIDTH ; ROCK_TUNNEL_1F
	warp_to  6, 45, ROUTE_10_WIDTH ; POWER_PLANT

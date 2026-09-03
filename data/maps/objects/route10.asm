Route10Object:
	db $2c ; border block

	db 4 ; warps
	warp 13, 25, 0, ROCK_TUNNEL_POKECENTER
	warp 10, 23, 0, ROCK_TUNNEL_1F	
	warp  8, 45, 0, POWER_PLANT
	warp  5, 43, 0, POWER_PLANT_1F

	db 3 ; signs
	sign  9, 25, 3 ; Route10Text7
	sign 14, 25, 4 ; PokeCenterSignText
	sign  7, 47, 5 ; Route10Text10

	db 2 ; objects
	object SPRITE_BLACK_HAIR_BOY_2, 13, 49, STAY, LEFT, 1, OPP_POKEMANIAC, 5
	object SPRITE_LASS,  9, 31, STAY, LEFT, 2, OPP_JR_TRAINER_F, 11

	; warp-to
	warp_to 13, 25, ROUTE_10_WIDTH ; ROCK_TUNNEL_POKECENTER
	warp_to 10, 23, ROUTE_10_WIDTH ; ROCK_TUNNEL_1F	
	warp_to  8, 45, ROUTE_10_WIDTH ; POWER_PLANT
	warp_to  5, 43, ROUTE_10_WIDTH ; POWER_PLANT_1F

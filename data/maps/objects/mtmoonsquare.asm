MtMoonSquareObject:
	db $2c ; border block

	db 1 ; warps
	warp 16, 5, 3, ROUTE_4

	db 1 ; signs
	sign 14, 6, 3 ; PokeCenterSignText

	db 2 ; objects
	object SPRITE_CLEFAIRY, 7, 8, WALK, 0, 1
	object SPRITE_CLEFAIRY, 9, 8, WALK, 0, 2


	; warp-to
	warp_to 16, 5, MT_MOON_SQUARE_WIDTH

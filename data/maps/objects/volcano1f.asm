Volcano1FObject:
	db $19 ; border block

	db 4 ; warps
	warp  2, 23, 0, -1
	warp  3, 23, 0, -1
	warp 13,  6, 0, VOLCANO_B1F
	warp 21, 20, 2, VOLCANO_B1F

	db 0 ; signs

	db 5 ; objects
	object SPRITE_GAMBLER,  8, 14, STAY, DOWN, 1, OPP_ENGINEER, 1
	object SPRITE_GAMBLER, 21, 16, STAY, LEFT, 2, OPP_ENGINEER, 1
	object SPRITE_GAMBLER, 14,  6, STAY, UP,   3, OPP_ENGINEER, 1
	object SPRITE_BALL,     6, 10, STAY, NONE, 4, FULL_RESTORE
	object SPRITE_BALL,     6,  5, STAY, NONE, 5, CARBOS

	; warp-to
	warp_to  2, 23, VOLCANO_1F_WIDTH
	warp_to  3, 23, VOLCANO_1F_WIDTH
	warp_to 13,  6, VOLCANO_1F_WIDTH ; VOLCANO_B1F
	warp_to 21, 20, VOLCANO_1F_WIDTH ; VOLCANO_B1F

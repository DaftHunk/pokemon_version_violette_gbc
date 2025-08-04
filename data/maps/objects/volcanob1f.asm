VolcanoB1FObject:
	db $19 ; border block

	db 3 ; warps
	warp  5,  1, 2, VOLCANO_1F
	warp  5, 26, 0, VOLCANO_B2F
	warp 12, 34, 3, VOLCANO_1F

	db 0 ; signs

	db 5 ; objects
	object SPRITE_HIKER,  2,  5, STAY, RIGHT, 1, OPP_SOLDIER, 4
	object SPRITE_HIKER, 10, 37, STAY,    UP, 2, OPP_SOLDIER, 5
	object SPRITE_BALL,   2, 30, STAY,  NONE, 3, FIRE_STONE
	object SPRITE_BALL,  13, 30, STAY,  NONE, 4, TM23_DRAGON_RAGE
	object SPRITE_BALL,   4, 35, STAY,  NONE, 5, MAX_ELIXER

	; warp-to
	warp_to  5,  1, VOLCANO_B1F_WIDTH ; VOLCANO_1F
	warp_to  5, 26, VOLCANO_B1F_WIDTH ; VOLCANO_B2F
	warp_to 12, 34, VOLCANO_B1F_WIDTH ; VOLCANO_1F

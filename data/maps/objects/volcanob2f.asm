VolcanoB2FObject:
	db $19 ; border block

	db 1 ; warps
	warp  2, 14, 1, VOLCANO_B1F

	db 0 ; signs

	db 1 ; objects
	object SPRITE_MOLTRES,  8,  6, STAY, UP, 1, MOLTRES, 50

	; warp-to
	warp_to  2, 14, VOLCANO_B2F_WIDTH ; VOLCANO_B1F

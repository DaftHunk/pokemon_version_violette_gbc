Volcano1FObject:
	db $19 ; border block

	db 4 ; warps
	warp  2, 23, 0, -1
	warp  3, 23, 0, -1
	warp 13,  6, 0, VOLCANO_1F
	warp 21, 20, 0, VOLCANO_1F

	db 0 ; signs

	db 1 ; objects
	object SPRITE_LITTLE_GIRL,  2,  3, STAY, NONE, 1 ; person

	; warp-to
	warp_to  2, 23, VOLCANO_1F_WIDTH
	warp_to  3, 23, VOLCANO_1F_WIDTH
	warp_to 13,  6, VOLCANO_1F_WIDTH ; VOLCANO_B1F
	warp_to 21, 20, VOLCANO_1F_WIDTH ; VOLCANO_B1F

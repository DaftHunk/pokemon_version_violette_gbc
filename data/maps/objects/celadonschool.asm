CeladonSchoolObject:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 13, -1
	warp 3, 7, 13, -1

	db 0 ; signs

	db 2 ; objects
	object SPRITE_LITTLE_GIRL, 3, 5, STAY, LEFT, 1	; move deleter
	object SPRITE_OAK_AIDE, 2, 1, STAY, DOWN, 2	;move relearner

	; warp-to
	warp_to 2, 7, CELADON_SCHOOL_WIDTH
	warp_to 3, 7, CELADON_SCHOOL_WIDTH

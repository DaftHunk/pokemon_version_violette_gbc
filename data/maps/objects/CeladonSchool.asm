CeladonSchoolObject:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 12, -1
	warp 3, 7, 12, -1

	db 0 ; signs

	db 3 ; objects
	object SPRITE_LITTLE_GIRL, 4, 5, STAY, LEFT, 1 ; move deleter
	object SPRITE_OAK_AIDE,    2, 1, STAY, DOWN, 2 ; move relearner
	object SPRITE_YOUNG_BOY,   0, 3, STAY, UP,   3 ; CeladonSchoolText_PogKid

	; warp-to
	warp_to 2, 7, CELADON_SCHOOL_WIDTH
	warp_to 3, 7, CELADON_SCHOOL_WIDTH

SaffronHouse1Object:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 3, -1
	warp 3, 7, 3, -1

	db 0 ; signs

	db 6 ; objects	;joenote adding move deleter and move relearner as objects 5 and 6
	object SPRITE_PAPER_SHEET, 3, 3, STAY, NONE, 1 ; person	;joenote - the girl and her letter have flipped text. fixing this.
	object SPRITE_BIRD, 0, 4, WALK, 1, 2 ; person
	object SPRITE_BUG_CATCHER, 4, 1, STAY, DOWN, 3 ; person
	object SPRITE_BRUNETTE_GIRL, 2, 3, STAY, RIGHT, 4 ; person
	object SPRITE_LITTLE_GIRL, 5, 4, STAY, LEFT, 5	; move deleter
	object SPRITE_OAK_AIDE, 4, 5, STAY, DOWN, 6	;move relearner

	; warp-to
	warp_to 2, 7, SAFFRON_PIDGEY_HOUSE_WIDTH
	warp_to 3, 7, SAFFRON_PIDGEY_HOUSE_WIDTH

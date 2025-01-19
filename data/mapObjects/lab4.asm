Lab4Object:
	db $17 ; border block

	db 2 ; warps
	warp 2, 7, 4, CINNABAR_LAB_1
	warp 3, 7, 4, CINNABAR_LAB_1

	db 0 ; signs

	;db 2 ; objects
	db 6
	object SPRITE_OAK_AIDE, 5, 2, WALK, 2, 1 ; person
	object SPRITE_OAK_AIDE, 7, 6, STAY, UP, 2 ; person
	;joenote - new NPCs
	object SPRITE_OAK_AIDE, 0, 5, STAY, UP, 3 ; person	
	object SPRITE_BOOK_MAP_DEX, 6, 4, STAY, NONE, 4 ; person
	object SPRITE_BOOK_MAP_DEX, 7, 4, STAY, NONE, 5 ; person
	object SPRITE_BOOK_MAP_DEX, 7, 2, STAY, NONE, 6 ; person

	; warp-to
	warp_to 2, 7, CINNABAR_LAB_FOSSIL_ROOM_WIDTH ; CINNABAR_LAB_1
	warp_to 3, 7, CINNABAR_LAB_FOSSIL_ROOM_WIDTH ; CINNABAR_LAB_1

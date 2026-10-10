RivalObject:
	db $3 ; border block

	db 4 ; warps
	warp 3, 7, 1, INDIGO_LANCES_ROOM
	warp 4, 7, 2, INDIGO_LANCES_ROOM
	warp 3, 0, 0, INDIGO_HALL_OF_FAME
	warp 4, 0, 0, INDIGO_HALL_OF_FAME

	db 0 ; signs

	db 2 ; objects
	object SPRITE_BLUE, 4, 2, STAY, DOWN, 1 ; person
	object SPRITE_OAK, 3, 7, STAY, UP, 2 ; person

	; warp-to
	warp_to 3, 7, INDIGO_CHAMPIONS_ROOM_WIDTH ; INDIGO_LANCES_ROOM
	warp_to 4, 7, INDIGO_CHAMPIONS_ROOM_WIDTH ; INDIGO_LANCES_ROOM
	warp_to 3, 0, INDIGO_CHAMPIONS_ROOM_WIDTH ; INDIGO_HALL_OF_FAME
	warp_to 4, 0, INDIGO_CHAMPIONS_ROOM_WIDTH ; INDIGO_HALL_OF_FAME

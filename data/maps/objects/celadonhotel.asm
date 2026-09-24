CeladonHotelObject:
	db $0 ; border block

	db 2 ; warps
	warp 3, 7, 11, -1
	warp 4, 7, 11, -1

	db 1 ; signs
	sign 10, 2, 5 ; CeladonHotelText_Full

	db 4 ; objects
	object SPRITE_OLD_MEDIUM_WOMAN, 3, 1, STAY, DOWN, 1 ; person
	object SPRITE_FOULARD_WOMAN, 2, 4, STAY, NONE, 2 ; person
	object SPRITE_BLACK_HAIR_BOY_2, 8, 4, WALK, 2, 3 ; person
	object SPRITE_GENTLEMAN, 11, 7, STAY, LEFT, 4 ; person

	; warp-to
	warp_to 3, 7, CELADON_HOTEL_WIDTH
	warp_to 4, 7, CELADON_HOTEL_WIDTH

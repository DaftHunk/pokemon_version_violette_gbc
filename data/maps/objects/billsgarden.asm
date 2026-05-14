BillsGardenObject:
	db $0F ; border block

	db 0 ; warps

	db 0 ; signs

	db 2 ; objects
	object SPRITE_HOOH, 9, 3, WALK, 2,    1, HOOH, 80
	object SPRITE_RED,  9, 5, STAY, DOWN, 2	;joenote - adding in a trainer

	; warp-to
	warp_to  9, 15, BILLS_GARDEN_WIDTH
	warp_to 10, 15, BILLS_GARDEN_WIDTH

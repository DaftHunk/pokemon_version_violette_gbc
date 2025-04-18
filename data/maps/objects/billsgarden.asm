BillsGardenObject:
	db $0F ; border block

	db 0 ; warps

	db 0 ; signs

	db 1 ; objects
	object SPRITE_RED,  9,  5, STAY, DOWN, 1	;joenote - adding in a trainer

	; warp-to
	warp_to  9, 15, BILLS_GARDEN_WIDTH
	warp_to 10, 15, BILLS_GARDEN_WIDTH

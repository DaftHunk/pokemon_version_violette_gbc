BillsGardenObject:
	db $0F ; border block

	db 0 ; warps

	db 0 ; signs

	db 3 ; objects
	object SPRITE_HOOH,     6, 3, WALK, 2,    1, HOOH, 80
	object SPRITE_SACHA,    5, 5, WALK, 1,    2	;joenote - adding in a trainer
	object SPRITE_PIKACHU, 10, 5, WALK, 2,    3

	; warp-to
	warp_to  9, 15, BILLS_GARDEN_WIDTH
	warp_to 10, 15, BILLS_GARDEN_WIDTH

Route16WestHouseObject:
	db $a ; border block

	db 2 ; warps
	warp 2, 7, 0, -1 ; exit1
	warp 3, 7, 0, -1 ; exit2

	db 0 ; signs

	db 1 ; objects
	object SPRITE_BOOK_MAP_DEX, 3, 3, STAY, NONE, 1, 0

	; warp-to
	warp_to 2, 7, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 3, 7, ROUTE_16_WEST_HOUSE_WIDTH

UndergroundPathWEObject:
	db $00 ; border block

	db 2 ; warps
	warp  3,  1, 2, UNDERGROUND_PATH_ROUTE_7
	warp 46,  1, 2, UNDERGROUND_PATH_ROUTE_8

	db 0 ; signs

	;joenote - adding a guy for random trainer battles
	db 2 ; objects
	object SPRITE_BIKE_SHOP_GUY, 22,  2, STAY, DOWN, 1, OPP_YOUNGSTER, 1 ; person (youngster #1 is a dummy value for the trainer)
	object SPRITE_BALL, 22,  4, STAY, NONE, 2, M_GENE

	; warp-to
	warp_to  3,  1, UNDERGROUND_PATH_WEST_EAST_WIDTH ; UNDERGROUND_PATH_ROUTE_7
	warp_to 46,  1, UNDERGROUND_PATH_WEST_EAST_WIDTH ; UNDERGROUND_PATH_ROUTE_8

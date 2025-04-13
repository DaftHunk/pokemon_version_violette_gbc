UndergroundPathWEObject:
	db $1 ; border block

	db 2 ; warps
	warp 2, 5, 2, PATH_ENTRANCE_ROUTE_7
	warp 47, 2, 2, PATH_ENTRANCE_ROUTE_8

	db 0 ; signs

	;joenote - adding a guy for random trainer battles
	db 2 ; objects
	object SPRITE_BIKE_SHOP_GUY, 24, 1, STAY, DOWN, 1, OPP_YOUNGSTER, 1 ; person (youngster #1 is a dummy value for the trainer)
	object SPRITE_BALL, 24, 3, STAY, NONE, 2, M_GENE

	; warp-to
	warp_to 2, 5, UNDERGROUND_PATH_WE_WIDTH ; PATH_ENTRANCE_ROUTE_7
	warp_to 47, 2, UNDERGROUND_PATH_WE_WIDTH ; PATH_ENTRANCE_ROUTE_8

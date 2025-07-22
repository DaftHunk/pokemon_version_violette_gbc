Route2Object:
	db $f ; border block

	db 6 ; warps
	warp 16,  9, 0, DIGLETTS_CAVE_ROUTE_2
	warp  7, 11, 1, VIRIDIAN_FOREST_EXIT
	warp 19, 19, 0, ROUTE_2_TRADE_HOUSE
	warp 20, 35, 1, ROUTE_2_GATE
	warp 19, 39, 2, ROUTE_2_GATE
	warp  7, 43, 2, VIRIDIAN_FOREST_ENTRANCE

	db 2 ; signs
	sign  9, 65, 3 ; Route2Text3
	sign 15, 11, 4 ; Route2Text4

	db 2 ; objects
	object SPRITE_BALL, 17, 54, STAY, NONE, 1, MOON_STONE
	object SPRITE_BALL, 17, 45, STAY, NONE, 2, HP_UP

	; warp-to
	warp_to 16,  9, ROUTE_2_WIDTH ; DIGLETTS_CAVE_ROUTE_2
	warp_to  7, 11, ROUTE_2_WIDTH ; VIRIDIAN_FOREST_EXIT
	warp_to 19, 19, ROUTE_2_WIDTH ; ROUTE_2_TRADE_HOUSE
	warp_to 20, 35, ROUTE_2_WIDTH ; ROUTE_2_GATE
	warp_to 19, 39, ROUTE_2_WIDTH ; ROUTE_2_GATE
	warp_to  7, 43, ROUTE_2_WIDTH ; VIRIDIAN_FOREST_ENTRANCE

	; unused
	warp_to  6,  7, 4
	db $12, $c7, $9, $7
	warp_to  6,  7, 4
	warp_to  6,  7, 4
	warp_to  6,  7, 4

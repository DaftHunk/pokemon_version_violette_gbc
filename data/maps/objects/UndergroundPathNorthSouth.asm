UndergroundPathNSObject:
	db $00 ; border block

	db 2 ; warps
	warp  6,  1, 2, UNDERGROUND_PATH_ROUTE_5
	warp  2, 37, 2, UNDERGROUND_PATH_ROUTE_6

	db 0 ; signs

;	db 0 ; objects
	db 1
	object SPRITE_WAITER,  4, 20, STAY, RIGHT, 1


	; warp-to
	warp_to  6,  1, UNDERGROUND_PATH_NORTH_SOUTH_WIDTH ; UNDERGROUND_PATH_ROUTE_5
	warp_to  2, 37, UNDERGROUND_PATH_NORTH_SOUTH_WIDTH ; UNDERGROUND_PATH_ROUTE_6

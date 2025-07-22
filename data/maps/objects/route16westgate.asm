Route16WestGateObject:
	db $a ; border block

	db 4 ; warps
	warp 0, 2,  1, ROUTE_16_WEST
	warp 0, 3,  2, ROUTE_16_WEST
	warp 7, 2,  9, ROUTE_16
	warp 7, 3, 10, ROUTE_16

	db 0 ; signs

	db 0 ; objects

	; warp-to
	warp_to 0, 2, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 0, 3, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 7, 2, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 7, 3, ROUTE_16_WEST_HOUSE_WIDTH

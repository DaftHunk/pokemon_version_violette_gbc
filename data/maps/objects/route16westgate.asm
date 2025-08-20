Route16WestGateObject:
	db $17 ; border block

	db 4 ; warps
	warp 0, 14,  1, ROUTE_16_WEST
	warp 0, 15,  2, ROUTE_16_WEST
	warp 7, 14,  9, ROUTE_16
	warp 7, 15, 10, ROUTE_16

	db 0 ; signs

	db 0 ; objects

	; warp-to
	warp_to 0, 14, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 0, 15, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 7, 14, ROUTE_16_WEST_HOUSE_WIDTH
	warp_to 7, 15, ROUTE_16_WEST_HOUSE_WIDTH

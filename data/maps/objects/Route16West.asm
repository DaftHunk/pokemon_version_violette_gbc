Route16WestObject:
	db $f ; border block
	
	db 2 ; warps
	warp 17, 25, 0, ROUTE_16_WEST_HOUSE
	warp 30,  5, 0, ROUTE_16_WEST_GATE

	db 2 ; signs
	sign 18, 20, 2 ; Route16WestTextTomb
	sign 21, 25, 3 ; Route16WestTextSign

	db 0 ; objects

	; warp-to
	warp_to 17, 25, ROUTE_16_WEST_WIDTH
	warp_to 30,  5, ROUTE_16_WEST_WIDTH ; ROUTE_16_WEST_GATE

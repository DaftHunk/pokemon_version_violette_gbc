LighthouseObject:
	db $00 ; border block

	db 8 ; warps
	warp  2, 29, 2, ROUTE_20
	warp  3, 29, 2, ROUTE_20
	warp  5, 27, 3, LIGHTHOUSE
	warp  0, 19, 2, LIGHTHOUSE
	warp  5, 19, 5, LIGHTHOUSE
	warp  0, 11, 4, LIGHTHOUSE
	warp  5, 11, 7, LIGHTHOUSE
	warp  0,  1, 6, LIGHTHOUSE

	db 0 ; signs

	db 2 ; objects
	object SPRITE_KEEPER,       4,  5, STAY, DOWN, 1 ; LighthouseText_Keeper
	object SPRITE_FIREFIGHTER,  0, 28, STAY, NONE, 2 ; LighthouseText_Trade

	; warp-to
	warp_to  2, 29, LIGHTHOUSE_WIDTH
	warp_to  3, 29, LIGHTHOUSE_WIDTH
	warp_to  5, 27, LIGHTHOUSE_WIDTH
	warp_to  0, 19, LIGHTHOUSE_WIDTH
	warp_to  5, 19, LIGHTHOUSE_WIDTH
	warp_to  0, 11, LIGHTHOUSE_WIDTH
	warp_to  5, 11, LIGHTHOUSE_WIDTH
	warp_to  0,  1, LIGHTHOUSE_WIDTH

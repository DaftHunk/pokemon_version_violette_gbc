VermilionDockObject:
	db $f ; border block

	db 2 ; warps
	warp 14, 0, 5, -1
	warp 14, 2, 1, SS_ANNE_1F

	db 0 ; signs

	db 1 ; objects
	object SPRITE_MEW, 21, 0, STAY, DOWN, 1, MEW, 50
	
	; warp-to
	warp_to 14, 0, VERMILION_DOCK_WIDTH
	warp_to 14, 2, VERMILION_DOCK_WIDTH ; SS_ANNE_1F

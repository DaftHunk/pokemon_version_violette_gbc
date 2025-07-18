Route23Object:
	db $f ; border block

	db 4 ; warps
	warp 7, 139, 2, ROUTE_22_GATE
	warp 8, 139, 3, ROUTE_22_GATE
	warp 4, 31, 0, VICTORY_ROAD_1F
	warp 14, 31, 1, VICTORY_ROAD_2

	db 1 ; signs
	sign 3, 35, 8 ; Route23Text8

	db 7 ; objects
	object SPRITE_GUARD,  4,  35, STAY, DOWN, 1 ; Earth Badge
	object SPRITE_GUARD, 10,  56, STAY, DOWN, 2 ; Volcano Badge
	object SPRITE_GUARD, 10,  70, STAY, DOWN, 3 ; Marsh Badge
	object SPRITE_GUARD,  9,  90, STAY, DOWN, 4 ; Soul Badge
	object SPRITE_GUARD, 12, 105, STAY, DOWN, 5 ; Rainbow Badge
	object SPRITE_GUARD,  8, 119, STAY, DOWN, 6 ; Thunder Badge
	object SPRITE_GUARD,  8, 136, STAY, DOWN, 7 ; Cascade Badge

	; warp-to
	warp_to 7, 139, ROUTE_23_WIDTH ; ROUTE_22_GATE
	warp_to 8, 139, ROUTE_23_WIDTH ; ROUTE_22_GATE
	warp_to 4, 31, ROUTE_23_WIDTH ; VICTORY_ROAD_1F
	warp_to 14, 31, ROUTE_23_WIDTH ; VICTORY_ROAD_2

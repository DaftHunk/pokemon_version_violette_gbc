Route23Object:
	db $f ; border block

	db 4 ; warps
	warp 8, 139, 2, ROUTE_22_GATE
	warp 9, 139, 3, ROUTE_22_GATE
	warp 4, 31, 0, VICTORY_ROAD_1F
	warp 14, 31, 1, VICTORY_ROAD_2

	db 1 ; signs
	sign 3, 37, 13 ; Route23Text8

	db 12 ; objects
	object SPRITE_GUARD,      4,  37, STAY, DOWN, 1 ; Earth Badge
	object SPRITE_GUARD,     10,  56, STAY, DOWN, 2 ; Volcano Badge
	object SPRITE_GUARD,     10,  70, STAY, DOWN, 3 ; Marsh Badge
	object SPRITE_GUARD,      9,  90, STAY, DOWN, 4 ; Soul Badge
	object SPRITE_GUARD,     12, 105, STAY, DOWN, 5 ; Rainbow Badge
	object SPRITE_GUARD,      8, 119, STAY, DOWN, 6 ; Thunder Badge
	object SPRITE_GUARD,      8, 136, STAY, DOWN, 7 ; Cascade Badge
	object SPRITE_GYM_HELPER, 5,  32, STAY, DOWN, 8 ; Route23Text_VictoryRoadGuide
	object SPRITE_BALL,       0,  32, STAY, NONE, 9,  TM26_EARTHQUAKE
	object SPRITE_BALL,      16,  44, STAY, NONE, 10, TM04_FLAMETHROWER
	object SPRITE_BALL,       8,  61, STAY, NONE, 11, TM13_ICE_BEAM
	object SPRITE_BALL,      19, 117, STAY, NONE, 12, TM25_THUNDER

	; warp-to
	warp_to 8, 139, ROUTE_23_WIDTH ; ROUTE_22_GATE
	warp_to 9, 139, ROUTE_23_WIDTH ; ROUTE_22_GATE
	warp_to 4, 31, ROUTE_23_WIDTH ; VICTORY_ROAD_1F
	warp_to 14, 31, ROUTE_23_WIDTH ; VICTORY_ROAD_2

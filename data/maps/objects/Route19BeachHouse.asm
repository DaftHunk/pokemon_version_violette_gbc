Route19BeachHouseObject:
	db $3 ; border block

	db 2 ; warps
	warp 2, 7, 0, -1 ; exit1
	warp 3, 7, 0, -1 ; exit2

	db 3 ; signs
	sign 2, 0, 3
	sign 3, 0, 4
	sign 6, 1, 5

	db 2 ; objects
	object SPRITE_FISHER, 4, 2, STAY, DOWN, 1 ; person
	object SPRITE_PIKACHU, 1, 4, WALK, RIGHT, 2

	; warp-to
	warp_to 2, 7, ROUTE_19_BEACH_HOUSE_WIDTH
	warp_to 3, 7, ROUTE_19_BEACH_HOUSE_WIDTH

Route19BeachHouseObject:
	db $00 ; border block

	db 2 ; warps
	warp 2, 7, 0, -1 ; exit1
	warp 3, 7, 0, -1 ; exit2

	db 5 ; signs
	sign  4,  2, 3 ; Route19BeachHouseSign_Poster1
	sign 12,  0, 4 ; Route19BeachHouseSign_Poster2
	sign 13,  1, 5 ; Route19BeachHouseSign_Printer
	sign  6,  1, 6 ; Route19BeachHouseSign_Shelves
	sign  7,  1, 6 ; Route19BeachHouseSign_Shelves

	db 2 ; objects
	object SPRITE_FISHER,  8, 4, STAY, RIGHT, 1 ; Route19BeachHouseText_Surfer
	object SPRITE_PIKACHU, 2, 4, WALK, RIGHT, 2 ; Route19BeachHouseText_Dave

	; warp-to
	warp_to 2, 7, ROUTE_19_BEACH_HOUSE_WIDTH
	warp_to 3, 7, ROUTE_19_BEACH_HOUSE_WIDTH

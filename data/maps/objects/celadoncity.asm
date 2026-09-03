CeladonCityObject:
	db $f ; border block

	db 13 ; warps
	warp 8,  13, 0, CELADON_MART_1F
	warp 10, 13, 2, CELADON_MART_1F
	warp 24,  9, 0, CELADON_MANSION_1F
	warp 24,  3, 2, CELADON_MANSION_1F
	warp 25,  3, 2, CELADON_MANSION_1F
	warp 41,  9, 0, CELADON_POKECENTER
	warp 12, 27, 0, CELADON_GYM
	warp 28, 19, 0, GAME_CORNER
	warp 33, 19, 0, CELADON_PRIZE_ROOM
	warp 29, 27, 0, CELADON_DINER
	warp 33, 27, 0, CELADON_CHIEF_HOUSE
	warp 41, 27, 0, CELADON_HOTEL
	warp 23, 29, 0, CELADON_SCHOOL

	db 13 ; signs
	sign 27, 15, 12 ; CeladonCityText10
	sign 19, 15, 13 ; CeladonCityText11
	sign 42,  9, 14 ; PokeCenterSignText
	sign 13, 29, 15 ; CeladonCityText13
	sign 23,  9, 16 ; CeladonCityText14
	sign 12, 13, 17 ; CeladonCityText15
	sign 39, 21, 18 ; CeladonCityText16
	sign 33, 21, 19 ; CeladonCityText17
	sign 27, 19, 20 ; CeladonCityText18
	sign 24, 29, 21 ; CeladonCityText_School
	sign 34, 19, 22 ; CeladonCityText_CasinoPrizes
	sign 30, 27, 23 ; CeladonCityText_Dinner
	sign 42, 27, 24 ; CeladonCityText_Hotel

	db 11 ; objects
;joenote - add some items to encourage exploration of the dead areas
	object SPRITE_LITTLE_GIRL,   5, 15, WALK, 0,     1 ; person
	object SPRITE_OLD_PERSON,   11, 28, STAY, UP,    2 ; person
	object SPRITE_GIRL,         16, 18, WALK, 1,     3 ; person
	object SPRITE_OLD_PERSON,   25, 22, STAY, DOWN,  4 ; person
	object SPRITE_OLD_PERSON,   22, 16, STAY, DOWN,  5 ; person
	object SPRITE_FISHER2,      32, 12, STAY, LEFT,  6 ; person
	object SPRITE_POLYWRATH,    30, 12, STAY, RIGHT, 7 ; person
	object SPRITE_ROCKET,       32, 29, WALK, 2,     8 ; person
	object SPRITE_ROCKET,       15,  2, WALK, 2,     9 ; person	;joenote - moved this rocket to a barren area
	object SPRITE_FAT_BALD_GUY, 10, 20, WALK, 1,     10 ; CeladonCityText_Merchant
	object SPRITE_RHYHORN,       9, 20, STAY, DOWN,  11 ; CeladonCityText_RhyhornMerchant


	; warp-to
	warp_to  8, 13, CELADON_CITY_WIDTH ; CELADON_MART_1F
	warp_to 10, 13, CELADON_CITY_WIDTH ; CELADON_MART_1F
	warp_to 24,  9, CELADON_CITY_WIDTH ; CELADON_MANSION_1F
	warp_to 24,  3, CELADON_CITY_WIDTH ; CELADON_MANSION_1F
	warp_to 25,  3, CELADON_CITY_WIDTH ; CELADON_MANSION_1F
	warp_to 41,  9, CELADON_CITY_WIDTH ; CELADON_POKECENTER
	warp_to 12, 27, CELADON_CITY_WIDTH ; CELADON_GYM
	warp_to 28, 19, CELADON_CITY_WIDTH ; GAME_CORNER
	warp_to 33, 19, CELADON_CITY_WIDTH ; CELADON_PRIZE_ROOM
	warp_to 29, 27, CELADON_CITY_WIDTH ; CELADON_DINER
	warp_to 33, 27, CELADON_CITY_WIDTH ; CELADON_CHIEF_HOUSE
	warp_to 41, 27, CELADON_CITY_WIDTH ; CELADON_HOTEL
	warp_to 23, 29, CELADON_CITY_WIDTH ; CELADON_SCHOOL

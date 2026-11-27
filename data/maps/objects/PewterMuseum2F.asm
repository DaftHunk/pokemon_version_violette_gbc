Museum2FObject:
	db $a ; border block

	db 1 ; warps
	warp  7,  9, 4, PEWTER_MUSEUM_1F

	db 2 ; signs
	sign 11,  4, 7 ; Museum2FText6
	sign  2,  6, 8 ; Museum2FText7

	db 6 ; objects
	object SPRITE_BUG_CATCHER,    1,  8, WALK, 2,    1 ; Museum2FText1
	object SPRITE_OLD_PERSON,     9,  4, STAY, DOWN, 2 ; Museum2FText2
	object SPRITE_OAK_AIDE,       7,  7, STAY, DOWN, 3 ; Museum2FText3
	object SPRITE_BRUNETTE_GIRL,  3,  2, STAY, NONE, 4 ; Museum2FPikachuGirlText
	object SPRITE_HIKER,          4,  2, STAY, DOWN, 5 ; Museum2FPikachuGirlDadText
	object SPRITE_BALL,          12,  9, STAY, NONE, 6, TM12_WATER_GUN ;joenote - moved tm12 here

	; warp-to
	warp_to  7,  9, PEWTER_MUSEUM_2F_WIDTH ; PEWTER_MUSEUM_1F

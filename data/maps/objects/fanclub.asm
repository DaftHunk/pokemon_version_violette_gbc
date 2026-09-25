FanClubObject:
	db $d ; border block

	db 2 ; warps
	warp 2, 7, 1, -1
	warp 3, 7, 1, -1

	db 2 ; signs
	sign 1, 0, 8 ; FanClubText_Sign1
	sign 6, 0, 9 ; FanClubText_Sign2

	db 7 ; objects
	object SPRITE_FISHER2,          6, 3, STAY, LEFT,  1 ; FanClubText1
	object SPRITE_GIRL,             1, 3, STAY, RIGHT, 2 ; FanClubText2
	object SPRITE_PIKACHU,          6, 4, STAY, LEFT,  3 ; FanClubText3
	object SPRITE_SEEL2,            1, 4, STAY, RIGHT, 4 ; FanClubText4
	object SPRITE_GENTLEMAN,        3, 1, STAY, DOWN,  5 ; FanClubText5
	object SPRITE_CABLE_CLUB_WOMAN, 5, 1, STAY, DOWN,  6 ; FanClubText6
	object SPRITE_PAPER_SHEET,      4, 4, STAY, DOWN,  7 ; FanClubText7

	; warp-to
	warp_to 2, 7, POKEMON_FAN_CLUB_WIDTH
	warp_to 3, 7, POKEMON_FAN_CLUB_WIDTH

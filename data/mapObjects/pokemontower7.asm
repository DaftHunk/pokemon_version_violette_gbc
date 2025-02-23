PokemonTower7Object:
	db $1 ; border block

	db 1 ; warps
	warp 9, 16, 1, POKEMONTOWER_6F

	db 0 ; signs

	db 5 ; objects
	object SPRITE_ROCKET, 9, 11, STAY, RIGHT, 1, OPP_ROCKET, 17
	object SPRITE_ROCKET, 12, 9, STAY, LEFT, 2, OPP_ROCKET, 18
	object SPRITE_ROCKET, 9, 7, STAY, RIGHT, 3, OPP_JESSIE_JAMES, 3 ;Jessie
	object SPRITE_MR_FUJI, 10, 3, STAY, DOWN, 4 ; person
	object SPRITE_ROCKET, 10, 6, STAY, DOWN, 5 ; James

	; warp-to
	warp_to 9, 16, POKEMONTOWER_7F_WIDTH ; POKEMONTOWER_6F

CeladonMansion4Object:
	db $9 ; border block

	db 3 ; warps
	warp 6, 1, 1, CELADON_POKEMON_MANSION_3F
	warp 1, 1, 2, CELADON_POKEMON_MANSION_3F
	warp 2, 7, 0, CELADON_MANSION_ROOF_HOUSE

	db 2 ; signs
	sign 3, 7, 2 ; CeladonMansion4Text1
	sign 1, 4, 3 ; CeladonMansion4Text_Graffiti

	db 1 ; objects
	object SPRITE_BALL, 0, 10, STAY, NONE, 1, RARE_CANDY

	; warp-to
	warp_to 6, 1, CELADON_POKEMON_MANSION_B1F_WIDTH ; CELADON_POKEMON_MANSION_3F
	warp_to 1, 1, CELADON_POKEMON_MANSION_B1F_WIDTH ; CELADON_POKEMON_MANSION_3F
	warp_to 2, 7, CELADON_POKEMON_MANSION_B1F_WIDTH ; CELADON_MANSION_ROOF_HOUSE

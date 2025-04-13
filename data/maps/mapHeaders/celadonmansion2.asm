CeladonMansion2_h:
	db MANSION ; tileset
	db CELADON_POKEMON_MANSION_2F_HEIGHT, CELADON_POKEMON_MANSION_2F_WIDTH ; dimensions (y, x)
	dw CeladonMansion2Blocks, CeladonMansion2TextPointers, CeladonMansion2Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion2Object ; objects

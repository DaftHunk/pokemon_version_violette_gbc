CeladonMansion3_h:
	db MANSION ; tileset
	db CELADON_POKEMON_MANSION_3F_HEIGHT, CELADON_POKEMON_MANSION_3F_WIDTH ; dimensions (y, x)
	dw CeladonMansion3Blocks, CeladonMansion3TextPointers, CeladonMansion3Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMansion3Object ; objects

Mansion4_h:
	db FACILITY ; tileset
	db POKEMON_MANSION_B1F_HEIGHT, POKEMON_MANSION_B1F_WIDTH ; dimensions (y, x)
	dw Mansion4Blocks, Mansion4TextPointers, Mansion4Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion4Object ; objects

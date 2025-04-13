Mansion3_h:
	db FACILITY ; tileset
	db POKEMON_MANSION_3F_HEIGHT, POKEMON_MANSION_3F_WIDTH ; dimensions (y, x)
	dw Mansion3Blocks, Mansion3TextPointers, Mansion3Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion3Object ; objects

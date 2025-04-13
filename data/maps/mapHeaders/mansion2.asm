Mansion2_h:
	db FACILITY ; tileset
	db POKEMON_MANSION_2F_HEIGHT, POKEMON_MANSION_2F_WIDTH ; dimensions (y, x)
	dw Mansion2Blocks, Mansion2TextPointers, Mansion2Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion2Object ; objects

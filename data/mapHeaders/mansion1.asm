Mansion1_h:
	db FACILITY ; tileset
	db POKEMON_MANSION_1F_HEIGHT, POKEMON_MANSION_1F_WIDTH ; dimensions (y, x)
	dw Mansion1Blocks, Mansion1TextPointers, Mansion1Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion1Object ; objects

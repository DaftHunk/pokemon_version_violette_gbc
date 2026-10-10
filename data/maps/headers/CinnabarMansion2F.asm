Mansion3_h:
	db FACILITY ; tileset
	db CINNABAR_MANSION_2F_HEIGHT, CINNABAR_MANSION_2F_WIDTH ; dimensions (y, x)
	dw Mansion3Blocks, Mansion3TextPointers, Mansion3Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion3Object ; objects

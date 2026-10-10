Mansion2_h:
	db FACILITY ; tileset
	db CINNABAR_MANSION_B1F_HEIGHT, CINNABAR_MANSION_B1F_WIDTH ; dimensions (y, x)
	dw Mansion2Blocks, Mansion2TextPointers, Mansion2Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion2Object ; objects

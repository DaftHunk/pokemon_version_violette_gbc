Mansion2F_h:
	db FACILITY ; tileset
	db CINNABAR_MANSION_2F_HEIGHT, CINNABAR_MANSION_2F_WIDTH ; dimensions (y, x)
	dw Mansion2FBlocks, Mansion2FTextPointers, Mansion2FScript ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion2FObject ; objects

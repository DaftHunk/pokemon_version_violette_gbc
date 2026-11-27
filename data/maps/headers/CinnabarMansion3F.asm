Mansion3F_h:
	db FACILITY ; tileset
	db CINNABAR_MANSION_3F_HEIGHT, CINNABAR_MANSION_3F_WIDTH ; dimensions (y, x)
	dw Mansion3FBlocks, Mansion3FTextPointers, Mansion3FScript ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion3FObject ; objects

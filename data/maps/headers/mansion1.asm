Mansion1_h:
	db FACILITY ; tileset
	db CINNABAR_MANSION_1F_HEIGHT, CINNABAR_MANSION_1F_WIDTH ; dimensions (y, x)
	dw Mansion1Blocks, Mansion1TextPointers, Mansion1Script ; blocks, texts, scripts
	db 0 ; connections
	dw Mansion1Object ; objects

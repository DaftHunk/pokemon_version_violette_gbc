SeafoamIslands3_h:
	db CAVERN ; tileset
	db SEAFOAM_ISLANDS_B2F_HEIGHT, SEAFOAM_ISLANDS_B2F_WIDTH ; dimensions (y, x)
	dw SeafoamIslands3Blocks, SeafoamIslands3TextPointers, SeafoamIslands3Script ; blocks, texts, scripts
	db 0 ; connections
	dw SeafoamIslands3Object ; objects

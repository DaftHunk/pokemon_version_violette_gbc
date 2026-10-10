UndergroundPathWE_h:
	db UNDERGROUND ; tileset
	db UNDERGROUND_PATH_WEST_EAST_HEIGHT, UNDERGROUND_PATH_WEST_EAST_WIDTH ; dimensions (y, x)
	dw UndergroundPathWEBlocks, UndergroundPathWETextPointers, UndergroundPathWEScript ; blocks, texts, scripts
	db 0 ; connections
	dw UndergroundPathWEObject ; objects

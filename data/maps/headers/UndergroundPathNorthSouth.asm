UndergroundPathNS_h:
	db UNDERGROUND ; tileset
	db UNDERGROUND_PATH_NORTH_SOUTH_HEIGHT, UNDERGROUND_PATH_NORTH_SOUTH_WIDTH ; dimensions (y, x)
	dw UndergroundPathNSBlocks, UndergroundPathNSTextPointers, UndergroundPathNSScript ; blocks, texts, scripts
	db 0 ; connections
	dw UndergroundPathNSObject ; objects

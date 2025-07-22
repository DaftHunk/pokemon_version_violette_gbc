Route2_h:
	db 00 ; Tileset
	db ROUTE_2_HEIGHT,ROUTE_2_WIDTH ;Height,Width blocks (1 block = 4x4 tiles)
	dw Route2Blocks, Route2TextPointers, Route2Script
	db NORTH | SOUTH | EAST ;Connection Byte
	NORTH_MAP_CONNECTION ROUTE_2, PEWTER_CITY,   -1, 2, PewterCityBlocks
	SOUTH_MAP_CONNECTION ROUTE_2, VIRIDIAN_CITY, -1, 2, ViridianCityBlocks, 1
	EAST_MAP_CONNECTION  ROUTE_2, ROUTE_16_WEST, 26, 12, Route16WestBlocks
	dw Route2Object ;Object Data Pointer

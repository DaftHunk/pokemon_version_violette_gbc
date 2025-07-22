Route16West_h:
	db OVERWORLD ; tileset
	db ROUTE_16_WEST_HEIGHT, ROUTE_16_WEST_WIDTH ; dimensions (y, x)
	dw Route16WestBlocks, Route16WestTextPointers, Route16WestScript ; blocks, texts, scripts
	db WEST | EAST ; connections
	WEST_MAP_CONNECTION  ROUTE_16_WEST, ROUTE_2,  -26, -12, Route2Blocks 
	EAST_MAP_CONNECTION  ROUTE_16_WEST, ROUTE_16, -1, 1, Route16Blocks, 1
	dw Route16WestObject ; objects

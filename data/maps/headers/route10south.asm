Route10South_h:
	db OVERWORLD ; tileset
	db ROUTE_10_SOUTH_HEIGHT, ROUTE_10_SOUTH_WIDTH ; dimensions (y, x)
	dw Route10SouthBlocks, Route10SouthTextPointers, Route10SouthScript ; blocks, texts, scripts
	db NORTH | SOUTH | WEST ; connections
	NORTH_MAP_CONNECTION ROUTE_10_SOUTH, ROUTE_10, 0, 0, Route10Blocks
	SOUTH_MAP_CONNECTION ROUTE_10_SOUTH, LAVENDER_TOWN, 0, -1, LavenderTownBlocks
	WEST_MAP_CONNECTION ROUTE_10_SOUTH, ROUTE_9, 3, 0, Route9Blocks
	dw Route10SouthObject ; objects

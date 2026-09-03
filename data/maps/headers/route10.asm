Route10_h:
	db OVERWORLD ; tileset
	db ROUTE_10_HEIGHT, ROUTE_10_WIDTH ; dimensions (y, x)
	dw Route10Blocks, Route10TextPointers, Route10Script ; blocks, texts, scripts
	db SOUTH | WEST ; connections
	SOUTH_MAP_CONNECTION ROUTE_10, ROUTE_10_SOUTH, 0, 0, Route10SouthBlocks
	WEST_MAP_CONNECTION ROUTE_10, ROUTE_9, 3, 0, Route9Blocks
	dw Route10Object ; objects

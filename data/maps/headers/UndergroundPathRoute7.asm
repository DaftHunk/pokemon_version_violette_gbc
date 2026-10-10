UndergroundPathEntranceRoute7_h:
	db GATE ; tileset
	db UNDERGROUND_PATH_ROUTE_7_HEIGHT, UNDERGROUND_PATH_ROUTE_7_WIDTH ; dimensions (y, x)
	dw UndergroundPathEntranceRoute7Blocks, UndergroundPathEntranceRoute7TextPointers, UndergroundPathEntranceRoute7Script ; blocks, texts, scripts
	db 0 ; connections
	dw UndergroundPathEntranceRoute7Object ; objects

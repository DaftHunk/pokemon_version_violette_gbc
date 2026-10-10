UndergroundPathEntranceRoute6_h:
	db GATE ; tileset
	db UNDERGROUND_PATH_ENTRANCE_ROUTE_6_HEIGHT, UNDERGROUND_PATH_ENTRANCE_ROUTE_6_WIDTH ; dimensions (y, x)
	dw UndergroundPathEntranceRoute6Blocks, UndergroundPathEntranceRoute6TextPointers, UndergroundPathEntranceRoute6Script ; blocks, texts, scripts
	db 0 ; connections
	dw UndergroundPathEntranceRoute6Object ; objects

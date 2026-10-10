VictoryRoad1_h:
	db CAVERN ; tileset
	db VICTORY_ROAD_1F_HEIGHT, VICTORY_ROAD_1F_WIDTH ; dimensions (y, x)
	dw VictoryRoad1Blocks, VictoryRoad1TextPointers, VictoryRoad1Script ; blocks, texts, scripts
	db 0 ; connections
	dw VictoryRoad1Object ; objects

BillsGarden_h:
	db OVERWORLD ; tileset
	db BILLS_GARDEN_HEIGHT, BILLS_GARDEN_WIDTH ; dimensions (y, x)
	dw BillsGardenBlocks, BillsGardenTextPointers, BillsGardenScript ; blocks, texts, scripts
	db SOUTH ; connections
	SOUTH_MAP_CONNECTION BILLS_GARDEN, ROUTE_25, 0, 18, Route25Blocks
	dw BillsGardenObject ; objects

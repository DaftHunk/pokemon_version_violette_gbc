Route16WestHouse_h:
	db HOUSE ; tileset
	db ROUTE_16_WEST_HOUSE_HEIGHT, ROUTE_16_WEST_HOUSE_WIDTH ; dimensions (y, x)
	dw Route16WestHouseBlocks, Route16WestHouseTextPointers, Route16WestHouseScript ; blocks, texts, scripts
	db 0
	dw Route16WestHouseObject ; objects

Route19BeachHouse_h:
	db GYM ; tileset
	db ROUTE_19_BEACH_HOUSE_HEIGHT, ROUTE_19_BEACH_HOUSE_WIDTH ; dimensions (y, x)
	dw Route19BeachHouseBlocks, Route19BeachHouseTextPointers, Route19BeachHouseScript ; blocks, texts, scripts
	db 0
	dw Route19BeachHouseObject ; objects

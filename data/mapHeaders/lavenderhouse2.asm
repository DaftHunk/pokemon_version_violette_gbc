LavenderHouse2_h:
	db HOUSE ; tileset
	db LAVENDER_CUBONE_HOUSE_HEIGHT, LAVENDER_CUBONE_HOUSE_WIDTH ; dimensions (y, x)
	dw LavenderHouse2Blocks, LavenderHouse2TextPointers, LavenderHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw LavenderHouse2Object ; objects

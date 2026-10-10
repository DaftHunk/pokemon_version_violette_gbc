LavenderHouse1_h:
	db HOUSE ; tileset
	db LAVENDER_FUJIS_HOUSE_HEIGHT, LAVENDER_FUJIS_HOUSE_WIDTH ; dimensions (y, x)
	dw LavenderHouse1Blocks, LavenderHouse1TextPointers, LavenderHouse1Script ; blocks, texts, scripts
	db 0 ; connections
	dw LavenderHouse1Object ; objects

SaffronHouse1_h:
	db HOUSE ; tileset
	db SAFFRON_PIDGEY_HOUSE_HEIGHT, SAFFRON_PIDGEY_HOUSE_WIDTH ; dimensions (y, x)
	dw SaffronHouse1Blocks, SaffronHouse1TextPointers, SaffronHouse1Script ; blocks, texts, scripts
	db 0 ; connections
	dw SaffronHouse1Object ; objects

SaffronHouse2_h:
	db HOUSE ; tileset
	db MR_PSYCHICS_HOUSE_HEIGHT, MR_PSYCHICS_HOUSE_WIDTH ; dimensions (y, x)
	dw SaffronHouse2Blocks, SaffronHouse2TextPointers, SaffronHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw SaffronHouse2Object ; objects

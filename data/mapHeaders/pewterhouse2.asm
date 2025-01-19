PewterHouse2_h:
	db HOUSE ; tileset
	db PEWTER_SPEECH_HOUSE_HEIGHT, PEWTER_SPEECH_HOUSE_WIDTH ; dimensions (y, x)
	dw PewterHouse2Blocks, PewterHouse2TextPointers, PewterHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw PewterHouse2Object ; objects

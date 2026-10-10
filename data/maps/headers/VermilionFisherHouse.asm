VermilionHouse2_h:
	db HOUSE ; tileset
	db VERMILION_FISHER_HOUSE_HEIGHT, VERMILION_FISHER_HOUSE_WIDTH ; dimensions (y, x)
	dw VermilionHouse2Blocks, VermilionHouse2TextPointers, VermilionHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw VermilionHouse2Object ; objects

VermilionHouse3_h:
	db HOUSE ; tileset
	db VERMILION_TRADE_HOUSE_HEIGHT, VERMILION_TRADE_HOUSE_WIDTH ; dimensions (y, x)
	dw VermilionHouse3Blocks, VermilionHouse3TextPointers, VermilionHouse3Script ; blocks, texts, scripts
	db 0 ; connections
	dw VermilionHouse3Object ; objects

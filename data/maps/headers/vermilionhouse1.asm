VermilionHouse1_h:
	db HOUSE ; tileset
	db VERMILION_PIDGEY_HOUSE_HEIGHT, VERMILION_PIDGEY_HOUSE_WIDTH ; dimensions (y, x)
	dw VermilionHouse1Blocks, VermilionHouse1TextPointers, VermilionHouse1Script ; blocks, texts, scripts
	db 0 ; connections
	dw VermilionHouse1Object ; objects

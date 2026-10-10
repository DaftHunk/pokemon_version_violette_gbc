CeladonMart2_h:
	db LOBBY ; tileset
	db CELADON_MART_2F_HEIGHT, CELADON_MART_2F_WIDTH ; dimensions (y, x)
	dw CeladonMart2Blocks, CeladonMart2TextPointers, CeladonMart2Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMart2Object ; objects

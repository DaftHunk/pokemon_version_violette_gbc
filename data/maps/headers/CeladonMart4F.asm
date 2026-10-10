CeladonMart4_h:
	db LOBBY ; tileset
	db CELADON_MART_4F_HEIGHT, CELADON_MART_4F_WIDTH ; dimensions (y, x)
	dw CeladonMart4Blocks, CeladonMart4TextPointers, CeladonMart4Script ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMart4Object ; objects

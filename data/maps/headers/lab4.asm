Lab4_h:
	db LAB ; tileset
	db CINNABAR_LAB_FOSSIL_ROOM_HEIGHT, CINNABAR_LAB_FOSSIL_ROOM_WIDTH ; dimensions (y, x)
	dw Lab4Blocks, Lab4TextPointers, Lab4Script ; blocks, texts, scripts
	db 0 ; connections
	dw Lab4Object ; objects

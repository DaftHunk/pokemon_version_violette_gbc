SSAnne10_h:
	db SHIP ; tileset
	db SS_ANNE_B1F_ROOMS_HEIGHT, SS_ANNE_B1F_ROOMS_WIDTH ; dimensions (y, x)
	dw SSAnne10Blocks, SSAnne10TextPointers, SSAnne10Script ; blocks, texts, scripts
	db 0 ; connections
	dw SSAnne10Object ; objects

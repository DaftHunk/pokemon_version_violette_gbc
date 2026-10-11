DiglettsCaveRoute2_h:
	db CAVERN ; tileset
	db DIGLETTS_CAVE_ROUTE_2_HEIGHT, DIGLETTS_CAVE_ROUTE_2_WIDTH ; dimensions (y, x)
	dw DiglettsCaveRoute2Blocks, DiglettsCaveRoute2TextPointers, DiglettsCaveRoute2Script ; blocks, texts, scripts
	db 0 ; connections
	dw DiglettsCaveRoute2Object ; objects

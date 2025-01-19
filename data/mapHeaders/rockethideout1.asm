RocketHideout1_h:
	db FACILITY ; tileset
	db ROCKET_HIDEOUT_B1F_HEIGHT, ROCKET_HIDEOUT_B1F_WIDTH ; dimensions (y, x)
	dw RocketHideout1Blocks, RocketHideout1TextPointers, RocketHideout1Script ; blocks, texts, scripts
	db 0 ; connections
	dw RocketHideout1Object ; objects

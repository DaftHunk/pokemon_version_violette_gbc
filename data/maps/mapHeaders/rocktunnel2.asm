RockTunnel2_h:
	db CAVERN ; tileset
	db ROCK_TUNNEL_B1F_HEIGHT, ROCK_TUNNEL_B1F_WIDTH ; dimensions (y, x)
	dw RockTunnel2Blocks, RockTunnel2TextPointers, RockTunnel2Script ; blocks, texts, scripts
	db 0 ; connections
	dw RockTunnel2Object ; objects

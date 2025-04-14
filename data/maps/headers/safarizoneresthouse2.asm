SafariZoneRestHouse2_h:
	db GATE ; tileset
	db SAFARI_ZONE_WEST_REST_HOUSE_HEIGHT, SAFARI_ZONE_WEST_REST_HOUSE_WIDTH ; dimensions (y, x)
	dw SafariZoneRestHouse2Blocks, SafariZoneRestHouse2TextPointers, SafariZoneRestHouse2Script ; blocks, texts, scripts
	db 0 ; connections
	dw SafariZoneRestHouse2Object ; objects

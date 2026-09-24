PowerPlant1F_h:
	db REACTOR ; tileset
	db POWER_PLANT_1F_HEIGHT, POWER_PLANT_1F_WIDTH ; dimensions (y, x)
	dw PowerPlant1FBlocks, PowerPlant1FTextPointers, PowerPlant1FScript ; blocks, texts, scripts
	db 0 ; connections
	dw PowerPlant1FObject ; objects

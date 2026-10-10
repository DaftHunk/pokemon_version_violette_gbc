PowerPlant_h:
	db REACTOR ; tileset
	db POWER_PLANT_1F_HEIGHT, POWER_PLANT_1F_WIDTH ; dimensions (y, x)
	dw PowerPlantBlocks, PowerPlantTextPointers, PowerPlantScript ; blocks, texts, scripts
	db 0 ; connections
	dw PowerPlantObject ; objects

Lighthouse_h:
	db UNDERGROUND ; tileset
	db LIGHTHOUSE_HEIGHT, LIGHTHOUSE_WIDTH ; dimensions (y, x)
	dw LighthouseBlocks, LighthouseTextPointers, LighthouseScript ; blocks, texts, scripts
	db 0 ; connections
	dw LighthouseObject ; objects

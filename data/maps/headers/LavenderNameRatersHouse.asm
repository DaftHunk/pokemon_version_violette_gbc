NameRater_h:
	db HOUSE ; tileset
	db LAVENDER_NAME_RATERS_HOUSE_HEIGHT, LAVENDER_NAME_RATERS_HOUSE_WIDTH ; dimensions (y, x)
	dw NameRaterBlocks, NameRaterTextPointers, NameRaterScript ; blocks, texts, scripts
	db 0 ; connections
	dw NameRaterObject ; objects

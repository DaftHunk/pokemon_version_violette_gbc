FightingDojo_h:
	db GYM ; tileset
	db SAFFRON_FIGHTING_DOJO_HEIGHT, SAFFRON_FIGHTING_DOJO_WIDTH ; dimensions (y, x)
	dw FightingDojoBlocks, FightingDojoTextPointers, FightingDojoScript ; blocks, texts, scripts
	db 0 ; connections
	dw FightingDojoObject ; objects

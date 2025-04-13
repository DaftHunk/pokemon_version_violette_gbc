PokemonTower3_h:
	db CEMETERY ; tileset
	db POKEMONTOWER_3F_HEIGHT, POKEMONTOWER_3F_WIDTH ; dimensions (y, x)
	dw PokemonTower3Blocks, PokemonTower3TextPointers, PokemonTower3Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower3Object ; objects

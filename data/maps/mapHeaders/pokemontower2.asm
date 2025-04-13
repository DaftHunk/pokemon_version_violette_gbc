PokemonTower2_h:
	db CEMETERY ; tileset
	db POKEMONTOWER_2F_HEIGHT, POKEMONTOWER_2F_WIDTH ; dimensions (y, x)
	dw PokemonTower2Blocks, PokemonTower2TextPointers, PokemonTower2Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower2Object ; objects

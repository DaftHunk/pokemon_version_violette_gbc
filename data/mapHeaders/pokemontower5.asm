PokemonTower5_h:
	db CEMETERY ; tileset
	db POKEMONTOWER_5F_HEIGHT, POKEMONTOWER_5F_WIDTH ; dimensions (y, x)
	dw PokemonTower5Blocks, PokemonTower5TextPointers, PokemonTower5Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower5Object ; objects

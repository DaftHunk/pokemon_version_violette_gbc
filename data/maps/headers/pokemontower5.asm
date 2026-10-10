PokemonTower5_h:
	db CEMETERY ; tileset
	db LAVENDER_POKEMON_TOWER_5F_HEIGHT, LAVENDER_POKEMON_TOWER_5F_WIDTH ; dimensions (y, x)
	dw PokemonTower5Blocks, PokemonTower5TextPointers, PokemonTower5Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower5Object ; objects

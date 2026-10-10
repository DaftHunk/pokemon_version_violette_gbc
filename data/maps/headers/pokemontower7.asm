PokemonTower7_h:
	db CEMETERY ; tileset
	db LAVENDER_POKEMON_TOWER_7F_HEIGHT, LAVENDER_POKEMON_TOWER_7F_WIDTH ; dimensions (y, x)
	dw PokemonTower7Blocks, PokemonTower7TextPointers, PokemonTower7Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower7Object ; objects

PokemonTower2_h:
	db CEMETERY ; tileset
	db LAVENDER_POKEMON_TOWER_2F_HEIGHT, LAVENDER_POKEMON_TOWER_2F_WIDTH ; dimensions (y, x)
	dw PokemonTower2Blocks, PokemonTower2TextPointers, PokemonTower2Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower2Object ; objects

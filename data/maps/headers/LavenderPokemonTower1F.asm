PokemonTower1_h:
	db CEMETERY ; tileset
	db LAVENDER_POKEMON_TOWER_1F_HEIGHT, LAVENDER_POKEMON_TOWER_1F_WIDTH ; dimensions (y, x)
	dw PokemonTower1Blocks, PokemonTower1TextPointers, PokemonTower1Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower1Object ; objects

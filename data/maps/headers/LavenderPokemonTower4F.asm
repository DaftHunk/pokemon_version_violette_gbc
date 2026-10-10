PokemonTower4_h:
	db CEMETERY ; tileset
	db LAVENDER_POKEMON_TOWER_4F_HEIGHT, LAVENDER_POKEMON_TOWER_4F_WIDTH ; dimensions (y, x)
	dw PokemonTower4Blocks, PokemonTower4TextPointers, PokemonTower4Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower4Object ; objects

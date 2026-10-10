PokemonTower6_h:
	db CEMETERY ; tileset
	db LAVENDER_POKEMON_TOWER_6F_HEIGHT, LAVENDER_POKEMON_TOWER_6F_WIDTH ; dimensions (y, x)
	dw PokemonTower6Blocks, PokemonTower6TextPointers, PokemonTower6Script ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower6Object ; objects

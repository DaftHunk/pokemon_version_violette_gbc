BikeShop_h:
	db CLUB ; tileset
	db CERULEAN_BIKE_SHOP_HEIGHT, CERULEAN_BIKE_SHOP_WIDTH ; dimensions (y, x)
	dw BikeShopBlocks, BikeShopTextPointers, BikeShopScript ; blocks, texts, scripts
	db 0 ; connections
	dw BikeShopObject ; objects

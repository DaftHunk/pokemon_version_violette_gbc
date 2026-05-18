BikeShopObject:
	db $e ; border block

	db 2 ; warps
	warp 2, 7, 4, -1
	warp 3, 7, 4, -1

	db 5 ; signs
	sign 4, 0, 4 ; BikeShopText_BasketBike
	sign 0, 6, 5 ; BikeShopText_Toolbox
	sign 1, 7, 5 ; BikeShopText_Toolbox
	sign 7, 5, 6 ; BikeShopText_Gatcha
	sign 7, 7, 6 ; BikeShopText_Gatcha

	db 3 ; objects
	object SPRITE_BIKE_SHOP_GUY, 6, 2, STAY, NONE, 1 ; person
	object SPRITE_MOM_GEISHA, 5, 6, WALK, 1, 2 ; person
	object SPRITE_BUG_CATCHER, 1, 3, STAY, UP, 3 ; person

	; warp-to
	warp_to 2, 7, BIKE_SHOP_WIDTH
	warp_to 3, 7, BIKE_SHOP_WIDTH

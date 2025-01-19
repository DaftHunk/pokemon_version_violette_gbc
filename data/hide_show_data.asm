; data for default hidden/shown
; objects for each map ($00-$F8)

; Table of 2-Byte pointers, one pointer per map,
; goes up to Map_F7, ends with $FFFF.
; points to table listing all missable object in the area
MapHSPointers:
	dw PalletTownHS
	dw ViridianCityHS
	dw PewterCityHS
	dw CeruleanCityHS
	dw NoHS
	dw VermilionCityHS	;joenote - added vermilion city
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SaffronCityHS
	dw NoHS
	dw NoHS
	dw Route2HS
	dw NoHS
	dw Route4HS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw Route9HS
	dw NoHS
	dw NoHS
	dw Route12HS
	dw NoHS
	dw NoHS
	dw Route15HS
	dw Route16HS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw Route22HS
	dw NoHS
	dw Route24HS
	dw Route25HS
	dw NoHS
	dw NoHS
	dw BluesHouseHS
	dw OaksLabHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw ViridianGymHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw ViridianForestHS
	dw Museum1FHS
	dw Museum2FHS	;joenote - added museum 2f
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw MtMoon1FHS
	dw NoHS
	dw MtMoonB2FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw PowerPlantHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw BillsHouseHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SSAnne2FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SSAnne1FRoomsHS
	dw SSAnne2FRoomsHS
	dw SSAnneB1FRoomsHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw VictoryRoad1FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS	
	dw ChampionsRoomHS	
	dw UndergroundPathWEHS	;joenote - pointer added for underground path w_e
	dw NoHS
	dw NoHS
	dw CeladonMart3FHS	;joenote - pointer added for celadon mart 3f
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw CeladonMansionRoofHouseHS
	dw NoHS
	dw NoHS
	dw GameCornerHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw PokemonTower2FHS
	dw PokemonTower3FHS
	dw PokemonTower4FHS
	dw PokemonTower5FHS
	dw PokemonTower6FHS
	dw PokemonTower7FHS
	dw MrFujisHouseHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw WardensHouseHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SeafoamIslandsB1FHS
	dw SeafoamIslandsB2FHS
	dw SeafoamIslandsB3FHS
	dw SeafoamIslandsB4FHS
	dw NoHS
	dw NoHS
	dw PokemonMansion1FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw FightingDojoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SilphCo1FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SeafoamIslands1FHS
	dw NoHS
	dw VictoryRoad2FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw VictoryRoad3FHS
	dw RocketHideoutB1FHS
	dw RocketHideoutB2FHS
	dw RocketHideoutB3FHS
	dw RocketHideoutB4FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SilphCo2FHS
	dw SilphCo3FHS
	dw SilphCo4FHS
	dw SilphCo5FHS
	dw SilphCo6FHS
	dw SilphCo7FHS
	dw SilphCo8FHS
	dw PokemonMansion2FHS
	dw PokemonMansion3FHS
	dw PokemonMansionB1FHS
	dw SafariZoneEastHS
	dw SafariZoneNorthHS
	dw SafariZoneWestHS
	dw SafariZoneCenterHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw CeruleanCave2FHS
	dw CeruleanCaveB1FHS
	dw CeruleanCaveHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw SilphCo9FHS
	dw SilphCo10FHS
	dw SilphCo11FHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw NoHS
	dw UnusedMapF4HS
	dw NoHS
	dw NoHS
	dw NoHS
	dw $FFFF

; Structure:
; 3 bytes per object
; [Map_ID][Object_ID][H/S]
;
; Program stops reading when either:
; a) Map_ID = $FF
; b) Map_ID ≠ currentMapID
;
; This Data is loaded into RAM at wd5ce-$D5F?. (wMissableObjectList)

;THESE FUNCTIONS MUST FOLLOW THE ORDER LAID OUT IN "hide_show_constants.asm"!!!

; These constants come from the bytes for Predef functions:
Hide equ $11
Show equ $15

NoHS:
	db $FF,$FF,$FF
PalletTownHS:
	db PALLET_TOWN,$01,Hide
ViridianCityHS:
	db VIRIDIAN_CITY,$05,Show
	db VIRIDIAN_CITY,$07,Hide
PewterCityHS:
	db PEWTER_CITY,$03,Show
	db PEWTER_CITY,$05,Show
CeruleanCityHS:
	db CERULEAN_CITY,$01,Hide
	db CERULEAN_CITY,$02,Show
	db CERULEAN_CITY,$06,Hide
	db CERULEAN_CITY,$0A,Show
	db CERULEAN_CITY,$0B,Show
SaffronCityHS:
	db SAFFRON_CITY,$01,Show
	db SAFFRON_CITY,$02,Show
	db SAFFRON_CITY,$03,Show
	db SAFFRON_CITY,$04,Show
	db SAFFRON_CITY,$05,Show
	db SAFFRON_CITY,$06,Show
	db SAFFRON_CITY,$07,Show
	db SAFFRON_CITY,$08,Hide
	db SAFFRON_CITY,$09,Hide
	db SAFFRON_CITY,$0A,Hide
	db SAFFRON_CITY,$0B,Hide
	db SAFFRON_CITY,$0C,Hide
	db SAFFRON_CITY,$0D,Hide
	db SAFFRON_CITY,$0E,Show
	db SAFFRON_CITY,$0F,Hide
Route2HS:
	db ROUTE_2,$01,Show
	db ROUTE_2,$02,Show
Route4HS:
	db ROUTE_4,$03,Show
Route9HS:
	db ROUTE_9,$0A,Show
Route12HS:
	db ROUTE_12,$01,Show
	db ROUTE_12,$09,Show
	db ROUTE_12,$0A,Show
Route15HS:
	db ROUTE_15,$0B,Show
Route16HS:
	db ROUTE_16,$07,Show
Route22HS:
	db ROUTE_22,$01,Hide
	db ROUTE_22,$02,Hide
Route24HS:
	db ROUTE_24,$01,Show
	db ROUTE_24,$08,Show
Route25HS:
	db ROUTE_25,$0A,Show
BluesHouseHS:
	db BLUES_HOUSE,$01,Show
	db BLUES_HOUSE,$02,Hide
	db BLUES_HOUSE,$03,Show
OaksLabHS:
	db OAKS_LAB,$01,Show
	db OAKS_LAB,$02,Show
	db OAKS_LAB,$03,Show
	db OAKS_LAB,$04,Show
	db OAKS_LAB,$05,Hide
	db OAKS_LAB,$06,Show
	db OAKS_LAB,$07,Show
	db OAKS_LAB,$08,Hide
ViridianGymHS:
	db VIRIDIAN_GYM,$01,Show
	db VIRIDIAN_GYM,$0B,Show
Museum1FHS:
	db MUSEUM_1F,$05,Show
CeruleanCaveHS:
	db CERULEAN_CAVE_1F,$01,Show
	db CERULEAN_CAVE_1F,$02,Show
	db CERULEAN_CAVE_1F,$03,Show
PokemonTower2FHS:
	db POKEMONTOWER_2F,$01,Show
PokemonTower3FHS:
	db POKEMONTOWER_3F,$04,Show
PokemonTower4FHS:
	db POKEMONTOWER_4F,$04,Show
	db POKEMONTOWER_4F,$05,Show
	db POKEMONTOWER_4F,$06,Show
PokemonTower5FHS:
	db POKEMONTOWER_5F,$06,Show
PokemonTower6FHS:
	db POKEMONTOWER_6F,$04,Show
	db POKEMONTOWER_6F,$05,Show
PokemonTower7FHS:
	db POKEMONTOWER_7F,$01,Show
	db POKEMONTOWER_7F,$02,Show
	db POKEMONTOWER_7F,$03,Show
	db POKEMONTOWER_7F,$04,Show
MrFujisHouseHS:
	db MR_FUJIS_HOUSE,$05,Hide
CeladonMansionRoofHouseHS:
	db CELADON_MANSION_ROOF_HOUSE,$02,Show
GameCornerHS:
	db GAME_CORNER,$0B,Show
WardensHouseHS:
	db WARDENS_HOUSE,$02,Show
PokemonMansion1FHS:
	db POKEMON_MANSION_1F,$02,Show
	db POKEMON_MANSION_1F,$03,Show
FightingDojoHS:
	db FIGHTING_DOJO,$06,Show
	db FIGHTING_DOJO,$07,Show
SilphCo1FHS:
	db SILPH_CO_1F,$01,Hide
PowerPlantHS:
	db POWER_PLANT,$01,Show
	db POWER_PLANT,$02,Show
	db POWER_PLANT,$03,Show
	db POWER_PLANT,$04,Show
	db POWER_PLANT,$05,Show
	db POWER_PLANT,$06,Show
	db POWER_PLANT,$07,Show
	db POWER_PLANT,$08,Show
	db POWER_PLANT,$09,Show
	db POWER_PLANT,$0A,Show
	db POWER_PLANT,$0B,Show
	db POWER_PLANT,$0C,Show
	db POWER_PLANT,$0D,Show
	db POWER_PLANT,$0E,Show
VictoryRoad2FHS:
	db VICTORY_ROAD_2,$06,Show
	db VICTORY_ROAD_2,$07,Show
	db VICTORY_ROAD_2,$08,Show
	db VICTORY_ROAD_2,$09,Show
	db VICTORY_ROAD_2,$0A,Show
	db VICTORY_ROAD_2,$0D,Show
BillsHouseHS:
	db BILLS_HOUSE,$01,Show
	db BILLS_HOUSE,$02,Hide
	db BILLS_HOUSE,$03,Hide
ViridianForestHS:
	db VIRIDIAN_FOREST,$05,Show
	db VIRIDIAN_FOREST,$06,Show
	db VIRIDIAN_FOREST,$07,Show
MtMoon1FHS:
	db MT_MOON_1F,$08,Show
	db MT_MOON_1F,$09,Show
	db MT_MOON_1F,$0A,Show
	db MT_MOON_1F,$0B,Show
	db MT_MOON_1F,$0C,Show
	db MT_MOON_1F,$0D,Show
MtMoonB2FHS:
	db MT_MOON_B2F,$06,Show
	db MT_MOON_B2F,$07,Show
	db MT_MOON_B2F,$08,Show
	db MT_MOON_B2F,$09,Show
SSAnne2FHS:
	db SS_ANNE_2F,$02,Hide
SSAnne1FRoomsHS:
	db SS_ANNE_1F_ROOMS,$0A,Show
SSAnne2FRoomsHS:
	db SS_ANNE_2F_ROOMS,$06,Show
	db SS_ANNE_2F_ROOMS,$09,Show
SSAnneB1FRoomsHS:
	db SS_ANNE_B1F_ROOMS,$09,Show
	db SS_ANNE_B1F_ROOMS,$0A,Show
	db SS_ANNE_B1F_ROOMS,$0B,Show
VictoryRoad3FHS:
	db VICTORY_ROAD_3F,$05,Show
	db VICTORY_ROAD_3F,$06,Show
	db VICTORY_ROAD_3F,$0A,Show
RocketHideoutB1FHS:
	db ROCKET_HIDEOUT_B1F,$06,Show
	db ROCKET_HIDEOUT_B1F,$07,Show
RocketHideoutB2FHS:
	db ROCKET_HIDEOUT_B2F,$02,Show
	db ROCKET_HIDEOUT_B2F,$03,Show
	db ROCKET_HIDEOUT_B2F,$04,Show
	db ROCKET_HIDEOUT_B2F,$05,Show
RocketHideoutB3FHS:
	db ROCKET_HIDEOUT_B3F,$03,Show
	db ROCKET_HIDEOUT_B3F,$04,Show
RocketHideoutB4FHS:
	db ROCKET_HIDEOUT_B4F,$01,Show
	db ROCKET_HIDEOUT_B4F,$05,Show
	db ROCKET_HIDEOUT_B4F,$06,Show
	db ROCKET_HIDEOUT_B4F,$07,Show
	db ROCKET_HIDEOUT_B4F,$08,Hide
	db ROCKET_HIDEOUT_B4F,$09,Hide
SilphCo2FHS:
	db SILPH_CO_2F,$01,Show
	db SILPH_CO_2F,$02,Show
	db SILPH_CO_2F,$03,Show
	db SILPH_CO_2F,$04,Show
	db SILPH_CO_2F,$05,Show
SilphCo3FHS:
	db SILPH_CO_3F,$02,Show
	db SILPH_CO_3F,$03,Show
	db SILPH_CO_3F,$04,Show
SilphCo4FHS:
	db SILPH_CO_4F,$02,Show
	db SILPH_CO_4F,$03,Show
	db SILPH_CO_4F,$04,Show
	db SILPH_CO_4F,$05,Show
	db SILPH_CO_4F,$06,Show
	db SILPH_CO_4F,$07,Show
SilphCo5FHS:
	db SILPH_CO_5F,$02,Show
	db SILPH_CO_5F,$03,Show
	db SILPH_CO_5F,$04,Show
	db SILPH_CO_5F,$05,Show
	db SILPH_CO_5F,$06,Show
	db SILPH_CO_5F,$07,Show
	db SILPH_CO_5F,$08,Show
SilphCo6FHS:
	db SILPH_CO_6F,$06,Show
	db SILPH_CO_6F,$07,Show
	db SILPH_CO_6F,$08,Show
	db SILPH_CO_6F,$09,Show
	db SILPH_CO_6F,$0A,Show
SilphCo7FHS:
	db SILPH_CO_7F,$05,Show
	db SILPH_CO_7F,$06,Show
	db SILPH_CO_7F,$07,Show
	db SILPH_CO_7F,$08,Show
	db SILPH_CO_7F,$09,Show
	db SILPH_CO_7F,$0A,Show
	db SILPH_CO_7F,$0B,Show
	db SILPH_CO_7F,$0C,Show
SilphCo8FHS:
	db SILPH_CO_8F,$02,Show
	db SILPH_CO_8F,$03,Show
	db SILPH_CO_8F,$04,Show
SilphCo9FHS:
	db SILPH_CO_9F,$02,Show
	db SILPH_CO_9F,$03,Show
	db SILPH_CO_9F,$04,Show
SilphCo10FHS:
	db SILPH_CO_10F,$01,Show
	db SILPH_CO_10F,$02,Show
	db SILPH_CO_10F,$03,Show
	db SILPH_CO_10F,$04,Show
	db SILPH_CO_10F,$05,Show
	db SILPH_CO_10F,$06,Show
SilphCo11FHS:
	db SILPH_CO_11F,$03,Show
	db SILPH_CO_11F,$04,Show
	db SILPH_CO_11F,$05,Show
UnusedMapF4HS:
	db $F4,$02,Show
PokemonMansion2FHS:
	db POKEMON_MANSION_2F,$02,Show
PokemonMansion3FHS:
	db POKEMON_MANSION_3F,$03,Show
	db POKEMON_MANSION_3F,$04,Show
PokemonMansionB1FHS:
	db POKEMON_MANSION_B1F,$03,Show
	db POKEMON_MANSION_B1F,$04,Show
	db POKEMON_MANSION_B1F,$05,Show
	db POKEMON_MANSION_B1F,$06,Show
	db POKEMON_MANSION_B1F,$08,Show
SafariZoneEastHS:
	db SAFARI_ZONE_EAST,$01,Show
	db SAFARI_ZONE_EAST,$02,Show
	db SAFARI_ZONE_EAST,$03,Show
	db SAFARI_ZONE_EAST,$04,Show
SafariZoneNorthHS:
	db SAFARI_ZONE_NORTH,$01,Show
	db SAFARI_ZONE_NORTH,$02,Show
SafariZoneWestHS:
	db SAFARI_ZONE_WEST,$01,Show
	db SAFARI_ZONE_WEST,$02,Show
	db SAFARI_ZONE_WEST,$03,Show
	db SAFARI_ZONE_WEST,$04,Show
SafariZoneCenterHS:
	db SAFARI_ZONE_CENTER,$01,Show
CeruleanCave2FHS:
	db CERULEAN_CAVE_2F,$01,Show
	db CERULEAN_CAVE_2F,$02,Show
	db CERULEAN_CAVE_2F,$03,Show
CeruleanCaveB1FHS:
	db CERULEAN_CAVE_B1F,$01,Show
	db CERULEAN_CAVE_B1F,$02,Show
	db CERULEAN_CAVE_B1F,$03,Show
VictoryRoad1FHS:
	db VICTORY_ROAD_1F,$03,Show
	db VICTORY_ROAD_1F,$04,Show
ChampionsRoomHS:
	db CHAMPIONS_ROOM,$02,Hide
SeafoamIslands1FHS:
	db SEAFOAM_ISLANDS_1F,$01,Show
	db SEAFOAM_ISLANDS_1F,$02,Show
SeafoamIslandsB1FHS:
	db SEAFOAM_ISLANDS_B1F,$01,Hide
	db SEAFOAM_ISLANDS_B1F,$02,Hide
SeafoamIslandsB2FHS:
	db SEAFOAM_ISLANDS_B2F,$01,Hide
	db SEAFOAM_ISLANDS_B2F,$02,Hide
SeafoamIslandsB3FHS:
	db SEAFOAM_ISLANDS_B3F,$02,Show
	db SEAFOAM_ISLANDS_B3F,$03,Show
	db SEAFOAM_ISLANDS_B3F,$05,Hide
	db SEAFOAM_ISLANDS_B3F,$06,Hide
SeafoamIslandsB4FHS:
	db SEAFOAM_ISLANDS_B4F,$01,Hide
	db SEAFOAM_ISLANDS_B4F,$02,Hide
	db SEAFOAM_ISLANDS_B4F,$03,Show
CeladonMart3FHS:
	db CELADON_MART_3F,$07,Show	;joenote - blocker for new mart guy
VermilionCityHS:
	db VERMILION_CITY,$07,Show	;joenote - replaces bush outside vermilion gym with a lazy pokemon
UndergroundPathWEHS: 
	db UNDERGROUND_PATH_WE,$02,Hide	;joenote - m_gene pokeball
Museum2FHS:
	db MUSEUM_2F,$06,Show	;joenote - added water gun tm to museum 2f
	
	db $FF,$01,Show

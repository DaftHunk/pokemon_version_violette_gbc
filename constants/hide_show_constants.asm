; this is a list of the sprites that can be enabled/disabled during the game
; sprites marked with an X are constants that are never used
; because those sprites are not (de)activated in a map's script
; (they are either items or sprites that deactivate after battle
; and are detected in wMissableObjectList)

const_value = 0

    const HS_PALLET_TOWN_OAK                    ; 00
    const HS_LYING_OLD_MAN                      ; 01
    const HS_OLD_MAN                            ; 02
    const HS_MUSEUM_GUY                         ; 03
    const HS_GYM_GUY                            ; 04
    const HS_CERULEAN_RIVAL                     ; 05
    const HS_CERULEAN_ROCKET                    ; 06
    const HS_CERULEAN_GUARD_1                   ; 07
    const HS_UNKNOWN_DUNGEON_GUY                ; 08
    const HS_CERULEAN_GUARD_2                   ; 09
    const HS_SAFFRON_CITY_1                     ; 0A
    const HS_SAFFRON_CITY_2                     ; 0B
    const HS_SAFFRON_CITY_3                     ; 0C
    const HS_SAFFRON_CITY_4                     ; 0D
    const HS_SAFFRON_CITY_5                     ; 0E
    const HS_SAFFRON_CITY_6                     ; 0F
    const HS_SAFFRON_CITY_7                     ; 10
    const HS_SAFFRON_CITY_8                     ; 11
    const HS_SAFFRON_CITY_9                     ; 12
    const HS_SAFFRON_CITY_A                     ; 13
    const HS_SAFFRON_CITY_B                     ; 14
    const HS_SAFFRON_CITY_C                     ; 15
    const HS_SAFFRON_CITY_D                     ; 16
    const HS_SAFFRON_CITY_E                     ; 17
    const HS_SAFFRON_CITY_F                     ; 18
    const HS_FUCHSIA_CITY_NICO                  ; 19
    const HS_ROUTE_2_ITEM_1                     ; 1A X
    const HS_ROUTE_2_ITEM_2                     ; 1B X
    const HS_ROUTE_4_ITEM                       ; 1C X
    const HS_ROUTE_9_ITEM                       ; 1D X
    const HS_ROUTE_12_SNORLAX                   ; 1E
    const HS_ROUTE_12_ITEM_1                    ; 1F X
    const HS_ROUTE_12_ITEM_2                    ; 20 X
    const HS_ROUTE_15_ITEM                      ; 21 X
    const HS_ROUTE_16_SNORLAX                   ; 22
    const HS_ROUTE_22_RIVAL_1                   ; 23
    const HS_ROUTE_22_RIVAL_2                   ; 24
    const HS_NUGGET_BRIDGE_GUY                  ; 25
    const HS_ROUTE_24_ITEM                      ; 26 X
    const HS_HOOH                               ; 27
    const HS_ROUTE_25_ITEM                      ; 28 X
    const HS_RED_HOUSE_CUP                      ; 29
    const HS_DAISY_SITTING                      ; 2A
    const HS_DAISY_WALKING                      ; 2B
    const HS_TOWN_MAP                           ; 2C
    const HS_PALLET_OAKS_LAB_RIVAL              ; 2D
    const HS_STARTER_BALL_1                     ; 2E
    const HS_STARTER_BALL_2                     ; 2F
    const HS_STARTER_BALL_3                     ; 30
    const HS_PALLET_OAKS_LAB_OAK_1              ; 31
    const HS_POKEDEX_1                          ; 32
    const HS_POKEDEX_2                          ; 33
    const HS_PALLET_OAKS_LAB_OAK_2              ; 34
    const HS_VIRIDIAN_GYM_GIOVANNI              ; 35
    const HS_VIRIDIAN_GYM_ITEM                  ; 36 X
    const HS_VIRIDIAN_GYM_NOTE                  ; 37
    const HS_OLD_AMBER                          ; 38
    const HS_CERULEAN_CAVE_1F_ITEM_1            ; 39 X
    const HS_CERULEAN_CAVE_1F_ITEM_2            ; 3A X
    const HS_CERULEAN_CAVE_1F_ITEM_3            ; 3B X
    const HS_LAVENDER_POKEMON_TOWER_2F_RIVAL    ; 3C
    const HS_LAVENDER_POKEMON_TOWER_3F_ITEM     ; 3D X
    const HS_LAVENDER_POKEMON_TOWER_4F_ITEM_1   ; 3E X
    const HS_LAVENDER_POKEMON_TOWER_4F_ITEM_2   ; 3F X
    const HS_LAVENDER_POKEMON_TOWER_4F_ITEM_3   ; 40 X
    const HS_LAVENDER_POKEMON_TOWER_5F_ITEM     ; 41 X
    const HS_LAVENDER_POKEMON_TOWER_6F_ITEM_1   ; 42 X
    const HS_LAVENDER_POKEMON_TOWER_6F_ITEM_2   ; 43 X
    const HS_LAVENDER_POKEMON_TOWER_7F_ROCKET_1 ; 44 X
    const HS_LAVENDER_POKEMON_TOWER_7F_ROCKET_2 ; 45 X
    const HS_LAVENDER_POKEMON_TOWER_7F_ROCKET_3 ; 46 X
    const HS_LAVENDER_POKEMON_TOWER_7F_MR_FUJI  ; 47
    const HS_LAVENDER_POKEMON_TOWER_7F_JAMES    ; 48
    const HS_LAVENDER_FUJIS_HOUSE_MR_FUJI       ; 49
    const HS_CELADON_MANSION_ROOF_HOUSE_GIFT    ; 4A
    const HS_CELADON_GAME_CORNER_ROCKET         ; 4B
    const HS_FUCHSIA_WARDENS_HOUSE_ITEM         ; 4C X
    const HS_CINNABAR_MANSION_1F_ITEM_1         ; 4D X
    const HS_CINNABAR_MANSION_1F_ITEM_2         ; 4E X
    const HS_SAFFRON_FIGHTING_DOJO_GIFT_1       ; 4F
    const HS_SAFFRON_FIGHTING_DOJO_GIFT_2       ; 50
    const HS_SAFFRON_SILPH_CO_1F_RECEPTIONIST   ; 51
    const HS_VOLTORB_1                          ; 52 X
    const HS_VOLTORB_2                          ; 53 X
    const HS_VOLTORB_3                          ; 54 X
    const HS_ELECTRODE_1                        ; 55 X
    const HS_VOLTORB_4                          ; 56 X
    const HS_VOLTORB_5                          ; 57 X
    const HS_VOLTORB_6                          ; 58 X
    const HS_POWER_PLANT_1F_ITEM_1              ; 59 X
    const HS_POWER_PLANT_1F_ITEM_2              ; 5A X
    const HS_POWER_PLANT_1F_ITEM_3              ; 5B X
    const HS_POWER_PLANT_1F_ITEM_4              ; 5C X
    const HS_ELECTRODE_2                        ; 5D X
    const HS_ZAPDOS                             ; 5E X
    const HS_POWER_PLANT_1F_ITEM_5              ; 5F X
    const HS_POWER_PLANT_1F_ITEM_6              ; 60 X
    const HS_VICTORY_ROAD_2F_ITEM_1             ; 61 X
    const HS_VICTORY_ROAD_2F_ITEM_2             ; 62 X
    const HS_VICTORY_ROAD_2F_ITEM_3             ; 63 X
    const HS_VICTORY_ROAD_2F_ITEM_4             ; 64 X
    const HS_VICTORY_ROAD_2F_BOULDER            ; 65
    const HS_BILL_POKEMON                       ; 66
    const HS_BILL_1                             ; 67
    const HS_BILL_2                             ; 68
    const HS_VIRIDIAN_FOREST_ITEM_1             ; 69 X
    const HS_VIRIDIAN_FOREST_ITEM_2             ; 6A X
    const HS_VIRIDIAN_FOREST_ITEM_3             ; 6B X
    const HS_MT_MOON_1F_ITEM_1                  ; 6C X
    const HS_MT_MOON_1F_ITEM_2                  ; 6D X
    const HS_MT_MOON_1F_ITEM_3                  ; 6E X
    const HS_MT_MOON_1F_ITEM_4                  ; 6F X
    const HS_MT_MOON_1F_ITEM_5                  ; 70 X
    const HS_MT_MOON_1F_ITEM_6                  ; 71 X
    const HS_MT_MOON_B1F_JESSIE                 ; 72
    const HS_MT_MOON_B1F_JAMES                  ; 73
    const HS_MT_MOON_B2F_FOSSIL_GUY             ; 74
    const HS_MT_MOON_B2F_FOSSIL_1               ; 75
    const HS_MT_MOON_B2F_FOSSIL_2               ; 76
    const HS_MT_MOON_B2F_ITEM_1                 ; 77 X
    const HS_MT_MOON_B2F_ITEM_2                 ; 78 X
    const HS_SS_ANNE_2F_RIVAL                   ; 79
    const HS_SS_ANNE_1F_ROOMS_ITEM              ; 7A X
    const HS_SS_ANNE_2F_ROOMS_ITEM_1            ; 7B X
    const HS_SS_ANNE_2F_ROOMS_ITEM_2            ; 7C X
    const HS_SS_ANNE_B1F_ROOMS_ITEM_1           ; 7D X
    const HS_SS_ANNE_B1F_ROOMS_ITEM_2           ; 7E X
    const HS_SS_ANNE_B1F_ROOMS_ITEM_3           ; 7F X
    const HS_VOLCANO_1F_ITEM_1                  ; 80
    const HS_VOLCANO_1F_ITEM_2                  ; 81
    const HS_VOLCANO_B1F_ITEM_1                 ; 82
    const HS_VOLCANO_B1F_ITEM_2                 ; 83
    const HS_VOLCANO_B1F_ITEM_3                 ; 84
    const HS_VICTORY_ROAD_3F_ITEM_1             ; 85 X
    const HS_VICTORY_ROAD_3F_ITEM_2             ; 86 X
    const HS_VICTORY_ROAD_3F_BOULDER            ; 87
    const HS_MOLTRES                            ; 88 X
    const HS_ROCKET_HIDEOUT_B1F_ITEM_1          ; 89 X
    const HS_ROCKET_HIDEOUT_B1F_ITEM_2          ; 8A X
    const HS_ROCKET_HIDEOUT_B2F_ITEM_1          ; 8B X
    const HS_ROCKET_HIDEOUT_B2F_ITEM_2          ; 8C X
    const HS_ROCKET_HIDEOUT_B2F_ITEM_3          ; 8D X
    const HS_ROCKET_HIDEOUT_B2F_ITEM_4          ; 8E X
    const HS_ROCKET_HIDEOUT_B3F_ITEM_1          ; 8F X
    const HS_ROCKET_HIDEOUT_B3F_ITEM_2          ; 90 X
    const HS_ROCKET_HIDEOUT_B4F_GIOVANNI        ; 91
    const HS_ROCKET_HIDEOUT_B4F_JESSIE          ; 92
    const HS_ROCKET_HIDEOUT_B4F_JAMES           ; 93
    const HS_ROCKET_HIDEOUT_B4F_ITEM_1          ; 94 X
    const HS_ROCKET_HIDEOUT_B4F_ITEM_2          ; 95 X
    const HS_ROCKET_HIDEOUT_B4F_ITEM_3          ; 96 X
    const HS_ROCKET_HIDEOUT_B4F_ITEM_4          ; 97
    const HS_ROCKET_HIDEOUT_B4F_ITEM_5          ; 98
    const HS_SAFFRON_SILPH_CO_2F_2              ; 99
    const HS_SAFFRON_SILPH_CO_2F_3              ; 9A
    const HS_SAFFRON_SILPH_CO_2F_4              ; 9B
    const HS_SAFFRON_SILPH_CO_2F_5              ; 9C
    const HS_SAFFRON_SILPH_CO_3F_1              ; 9D
    const HS_SAFFRON_SILPH_CO_3F_2              ; 9E
    const HS_SAFFRON_SILPH_CO_3F_ITEM           ; 9F X
    const HS_SAFFRON_SILPH_CO_4F_1              ; A0
    const HS_SAFFRON_SILPH_CO_4F_2              ; A1
    const HS_SAFFRON_SILPH_CO_4F_3              ; A2
    const HS_SAFFRON_SILPH_CO_4F_ITEM_1         ; A3 X
    const HS_SAFFRON_SILPH_CO_4F_ITEM_2         ; A4 X
    const HS_SAFFRON_SILPH_CO_4F_ITEM_3         ; A5 X
    const HS_SAFFRON_SILPH_CO_5F_1              ; A6
    const HS_SAFFRON_SILPH_CO_5F_2              ; A7
    const HS_SAFFRON_SILPH_CO_5F_3              ; A8
    const HS_SAFFRON_SILPH_CO_5F_4              ; A9
    const HS_SAFFRON_SILPH_CO_5F_ITEM_1         ; AA X
    const HS_SAFFRON_SILPH_CO_5F_ITEM_2         ; AB X
    const HS_SAFFRON_SILPH_CO_5F_ITEM_3         ; AC X
    const HS_SAFFRON_SILPH_CO_6F_1              ; AD
    const HS_SAFFRON_SILPH_CO_6F_2              ; AE
    const HS_SAFFRON_SILPH_CO_6F_3              ; AF
    const HS_SAFFRON_SILPH_CO_6F_ITEM_1         ; B0 X
    const HS_SAFFRON_SILPH_CO_6F_ITEM_2         ; B1 X
    const HS_SAFFRON_SILPH_CO_7F_1              ; B2
    const HS_SAFFRON_SILPH_CO_7F_2              ; B3
    const HS_SAFFRON_SILPH_CO_7F_3              ; B4
    const HS_SAFFRON_SILPH_CO_7F_4              ; B5
    const HS_SAFFRON_SILPH_CO_7F_RIVAL          ; B6
    const HS_SAFFRON_SILPH_CO_7F_ITEM_1         ; B7 X
    const HS_SAFFRON_SILPH_CO_7F_ITEM_2         ; B8 X
    const HS_SAFFRON_SILPH_CO_8F_1              ; B9
    const HS_SAFFRON_SILPH_CO_8F_2              ; BA
    const HS_SAFFRON_SILPH_CO_8F_3              ; BB
    const HS_SAFFRON_SILPH_CO_9F_1              ; BC
    const HS_SAFFRON_SILPH_CO_9F_2              ; BD
    const HS_SAFFRON_SILPH_CO_9F_3              ; BE
    const HS_SAFFRON_SILPH_CO_10F_1             ; BF
    const HS_SAFFRON_SILPH_CO_10F_2             ; C0
    const HS_SAFFRON_SILPH_CO_10F_ITEM_1        ; C1 X
    const HS_SAFFRON_SILPH_CO_10F_ITEM_2        ; C2 X
    const HS_SAFFRON_SILPH_CO_10F_ITEM_3        ; C3 X
    const HS_SAFFRON_SILPH_CO_11F_CHIEF         ; C4
    const HS_SAFFRON_SILPH_CO_11F_1             ; C5
    const HS_SAFFRON_SILPH_CO_11F_JESSIE        ; C6
    const HS_SAFFRON_SILPH_CO_11F_2             ; C7
    const HS_SAFFRON_SILPH_CO_11F_JAMES         ; C8
    const HS_CINNABAR_MANSION_B1F_ITEM          ; C9 X
    const HS_CINNABAR_MANSION_2F_ITEM_1         ; CA X
    const HS_CINNABAR_MANSION_2F_ITEM_2         ; CB X
    const HS_CINNABAR_MANSION_B2F_ITEM_1        ; CC X
    const HS_CINNABAR_MANSION_B2F_ITEM_2        ; CD X
    const HS_CINNABAR_MANSION_B2F_ITEM_3        ; CE X
    const HS_CINNABAR_MANSION_B2F_ITEM_4        ; CF X
    const HS_CINNABAR_MANSION_B2F_ITEM_5        ; D0 X
    const HS_SAFARI_ZONE_EAST_ITEM_1            ; D1 X
    const HS_SAFARI_ZONE_EAST_ITEM_2            ; D2 X
    const HS_SAFARI_ZONE_EAST_ITEM_3            ; D3 X
    const HS_SAFARI_ZONE_EAST_ITEM_4            ; D4 X
    const HS_SAFARI_ZONE_NORTH_ITEM_1           ; D5 X
    const HS_SAFARI_ZONE_NORTH_ITEM_2           ; D6 X
    const HS_SAFARI_ZONE_WEST_ITEM_1            ; D7 X
    const HS_SAFARI_ZONE_WEST_ITEM_2            ; D8 X
    const HS_SAFARI_ZONE_WEST_ITEM_3            ; D9 X
    const HS_SAFARI_ZONE_WEST_ITEM_4            ; DA X
    const HS_SAFARI_ZONE_CENTER_ITEM            ; DB X
    const HS_SAFARI_ZONE_CENTER_REST_NICO       ; DC
    const HS_SAFARI_LAB_CHIEF                   ; DD
    const HS_CERULEAN_CAVE_2F_ITEM_1            ; DE X
    const HS_CERULEAN_CAVE_2F_ITEM_2            ; DF X
    const HS_CERULEAN_CAVE_2F_ITEM_3            ; E0 X
    const HS_MEWTWO                             ; E1 X
    const HS_CERULEAN_CAVE_B1F_ITEM_1           ; E2 X
    const HS_CERULEAN_CAVE_B1F_ITEM_2           ; E3 X
    const HS_VICTORY_ROAD_1F_ITEM_1             ; E4 X
    const HS_VICTORY_ROAD_1F_ITEM_2             ; E5 X
    const HS_INDIGO_CHAMPIONS_ROOM_OAK          ; E6
    const HS_SEAFOAM_ISLANDS_1F_BOULDER_1       ; E7
    const HS_SEAFOAM_ISLANDS_1F_BOULDER_2       ; E8
    const HS_SEAFOAM_ISLANDS_B1F_BOULDER_1      ; E9
    const HS_SEAFOAM_ISLANDS_B1F_BOULDER_2      ; EA
    const HS_SEAFOAM_ISLANDS_B2F_BOULDER_1      ; EB
    const HS_SEAFOAM_ISLANDS_B2F_BOULDER_2      ; EC
    const HS_SEAFOAM_ISLANDS_B3F_BOULDER_1      ; ED
    const HS_SEAFOAM_ISLANDS_B3F_BOULDER_2      ; EE
    const HS_SEAFOAM_ISLANDS_B3F_BOULDER_3      ; EF
    const HS_SEAFOAM_ISLANDS_B3F_BOULDER_4      ; F0
    const HS_SEAFOAM_ISLANDS_B3F_ITEM_1         ; F1
    const HS_SEAFOAM_ISLANDS_B4F_BOULDER_1      ; F2
    const HS_SEAFOAM_ISLANDS_B4F_BOULDER_2      ; F3
    const HS_ARTICUNO                           ; F4 X
    const HS_CELADON_MART_3F_BLOCKER            ; F5 ;joenote - added this to turn on/off the blocking sprite
    const HS_VERMILION_PKMN                     ; F6 ;joenote - a lazy pokemon replaces the bush blocking the gym
    const HS_UNDPATHWE_MGENE                    ; F7 ;joenote - mgene pickup item
    const HS_MUSEUM_TM12                        ; F8 ;joenote - moving water gun here
    const HS_MEW_VERMILION_DOCK                 ; F9

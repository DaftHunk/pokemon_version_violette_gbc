ListRealPkmn:
	db MEW          ; $15
ListNonMythPkmn:
	db MEWTWO       ; $83
ListNonMewPkmn:
	db MOLTRES      ; $49
	db ARTICUNO     ; $4A
	db ZAPDOS       ; $4B
ListNonLegendPkmn:
	db ABRA         ; $94
	db BELLSPROUT   ; $BC
	db BULBASAUR    ; $99
	db CATERPIE     ; $7B
	db CHARMANDER   ; $B0
	db CLEFAIRY     ; $04
	db CUBONE       ; $11
	db DIGLETT      ; $3B
	db DODUO        ; $46
	db DRATINI      ; $58
	db DROWZEE      ; $30
	db EEVEE        ; $66
	db EKANS        ; $6C
	db EXEGGCUTE    ; $0C
	db GASTLY       ; $19
	db GEODUDE      ; $A9
	db GOLDEEN      ; $9D
	db GRIMER       ; $0D
	db GROWLITHE    ; $21
	db HORSEA       ; $5C
	db JIGGLYPUFF   ; $64
	db KABUTO       ; $5A
	db KOFFING      ; $37
	db KRABBY       ; $4E
	db MACHOP       ; $6A
	db MAGIKARP     ; $85
	db MAGNEMITE    ; $AD
	db MANKEY       ; $39
	db MEOWTH       ; $4D
	db NIDORAN_F    ; $0F
	db NIDORAN_M    ; $03
	db ODDISH       ; $B9
	db OMANYTE      ; $62
	db PARAS        ; $6D
	db PIDGEY       ; $24
	db PIKACHU      ; $54
	db POLIWAG      ; $47
	db PONYTA       ; $A3
	db PSYDUCK      ; $2F
	db RATTATA      ; $A5
	db RHYHORN      ; $12
	db SANDSHREW    ; $60
	db SEEL         ; $3A
	db SHELLDER     ; $17
	db SLOWPOKE     ; $25
	db SPEAROW      ; $05
	db SQUIRTLE     ; $B1
	db STARYU       ; $1B
	db TENTACOOL    ; $18
	db VENONAT      ; $41
	db VOLTORB      ; $06
	db VULPIX       ; $52
	db WEEDLE       ; $70
	db ZUBAT        ; $6B
ListMidEvolvedPkmn:
	db CHARMELEON   ; $B2
	db DRAGONAIR    ; $59
	db GLOOM        ; $BA
	db GRAVELER     ; $27
	db HAUNTER      ; $93
	db IVYSAUR      ; $09
	db KADABRA      ; $26
	db KAKUNA       ; $71
	db MACHOKE      ; $29
	db METAPOD      ; $7C
	db NIDORINA     ; $A8
	db NIDORINO     ; $A7
	db PIDGEOTTO    ; $96
	db POLIWHIRL    ; $6E
	db WARTORTLE    ; $B3
	db WEEPINBELL   ; $BD
ListNonEvolvingPkmn:
	db AERODACTYL   ; $AB
	db CHANSEY      ; $28
	db DITTO        ; $4C
	db ELECTABUZZ   ; $35
	db FARFETCHD    ; $40
	db HITMONCHAN   ; $2C
	db HITMONLEE    ; $2B
	db JYNX         ; $48
	db KANGASKHAN   ; $02
	db LAPRAS       ; $13
	db LICKITUNG    ; $0B
	db MAGMAR       ; $33
	db MR_MIME      ; $2A
	db ONIX         ; $22
	db PINSIR       ; $1D
	db PORYGON      ; $AA
	db SCYTHER      ; $1A
	db SNORLAX      ; $84
	db TANGELA      ; $1E
	db TAUROS       ; $3C
ListMostEvolvedPkmn:
	db ALAKAZAM     ; $95
	db ARBOK        ; $2D
	db ARCANINE     ; $14
	db BEEDRILL     ; $72
	db BLASTOISE    ; $1C
	db BUTTERFREE   ; $7D
	db CHARIZARD    ; $B4
	db CLEFABLE     ; $8E
	db CLOYSTER     ; $8B
	db DEWGONG      ; $78
	db DODRIO       ; $74
	db DRAGONITE    ; $42
	db DUGTRIO      ; $76
	db ELECTRODE    ; $8D
	db EXEGGUTOR    ; $0A
	db FEAROW       ; $23
	db FLAREON      ; $67
	db GENGAR       ; $0E
	db GOLBAT       ; $82
	db GOLDUCK      ; $80
	db GOLEM        ; $31
	db GYARADOS     ; $16
	db HYPNO        ; $81
	db JOLTEON      ; $68
	db KABUTOPS     ; $5B
	db KINGLER      ; $8A
	db MACHAMP      ; $7E
	db MAGNETON     ; $36
	db MAROWAK      ; $91
	db MUK          ; $88
	db NIDOKING     ; $07
	db NIDOQUEEN    ; $10
	db NINETALES    ; $53
	db OMASTAR      ; $63
	db PARASECT     ; $2E
	db PERSIAN      ; $90
	db PIDGEOT      ; $97
	db POLIWRATH    ; $6F
	db PRIMEAPE     ; $75
	db RAICHU       ; $55
	db RAPIDASH     ; $A4
	db RATICATE     ; $A6
	db RHYDON       ; $01
	db SANDSLASH    ; $61
	db SEADRA       ; $5D
	db SEAKING      ; $9E
	db SLOWBRO      ; $08
	db STARMIE      ; $98
	db TENTACRUEL   ; $9B
	db VAPOREON     ; $69
	db VENOMOTH     ; $77
	db VENUSAUR     ; $9A
	db VICTREEBEL   ; $BE
	db VILEPLUME    ; $BB
	db WEEZING      ; $8F
	db WIGGLYTUFF   ; $65
	db $00

	
;list pokemon separated out by gener ratio
;leave out pokemon with a set gender or are genderless
ListByGenderRatio:
;0 to 5 are male only --> atk dv >= 0 is male
	db NIDORAN_M    ; $03
	db NIDORINO     ; $A7
	db NIDOKING     ; $07
	db HITMONLEE    ; $2B
	db HITMONCHAN   ; $2C
	db TAUROS       ; $3C
;6 to 24 are 1-7 ratio --> atk dv >= 2 is male
	db BULBASAUR    ; $99
	db IVYSAUR      ; $09
	db VENUSAUR     ; $9A
	db CHARMANDER   ; $B0
	db CHARMELEON   ; $B2
	db CHARIZARD    ; $B4
	db SQUIRTLE     ; $B1
	db WARTORTLE    ; $B3
	db BLASTOISE    ; $1C
	db EEVEE        ; $66
	db VAPOREON     ; $69
	db JOLTEON      ; $68
	db FLAREON      ; $67
	db OMANYTE      ; $62
	db OMASTAR      ; $63
	db KABUTO       ; $5A
	db KABUTOPS     ; $5B
	db AERODACTYL   ; $AB
	db SNORLAX      ; $84
;25 to 34 are 1-3 ratio  --> atk dv >= 4 is male
	db GROWLITHE    ; $21
	db ARCANINE     ; $14
	db ABRA         ; $94
	db KADABRA      ; $26
	db ALAKAZAM     ; $95
	db MACHOP       ; $6A
	db MACHOKE      ; $29
	db MACHAMP      ; $7E
	db ELECTABUZZ   ; $35
	db MAGMAR       ; $33
;35 to 125 are 1-1 ratio --> atk dv >= 8 is male
	db CATERPIE     ; $7B
	db METAPOD      ; $7C
	db BUTTERFREE   ; $7D
	db WEEDLE       ; $70
	db KAKUNA       ; $71
	db BEEDRILL     ; $72
	db PIDGEY       ; $24
	db PIDGEOTTO    ; $96
	db PIDGEOT      ; $97
	db RATTATA      ; $A5
	db RATICATE     ; $A6
	db SPEAROW      ; $05
	db FEAROW       ; $23
	db EKANS        ; $6C
	db ARBOK        ; $2D
	db PIKACHU      ; $54
	db RAICHU       ; $55
	db SANDSHREW    ; $60
	db SANDSLASH    ; $61
	db ZUBAT        ; $6B
	db GOLBAT       ; $82
	db ODDISH       ; $B9
	db GLOOM        ; $BA
	db VILEPLUME    ; $BB
	db PARAS        ; $6D
	db PARASECT     ; $2E
	db VENONAT      ; $41
	db VENOMOTH     ; $77
	db DIGLETT      ; $3B
	db DUGTRIO      ; $76
	db MEOWTH       ; $4D
	db PERSIAN      ; $90
	db PSYDUCK      ; $2F
	db GOLDUCK      ; $80
	db MANKEY       ; $39
	db PRIMEAPE     ; $75
	db POLIWAG      ; $47
	db POLIWHIRL    ; $6E
	db POLIWRATH    ; $6F
	db BELLSPROUT   ; $BC
	db WEEPINBELL   ; $BD
	db VICTREEBEL   ; $BE
	db TENTACOOL    ; $18
	db TENTACRUEL   ; $9B
	db GEODUDE      ; $A9
	db GRAVELER     ; $27
	db GOLEM        ; $31
	db PONYTA       ; $A3
	db RAPIDASH     ; $A4
	db SLOWPOKE     ; $25
	db SLOWBRO      ; $08
	db FARFETCHD    ; $40
	db DODUO        ; $46
	db DODRIO       ; $74
	db SEEL         ; $3A
	db DEWGONG      ; $78
	db GRIMER       ; $0D
	db MUK          ; $88
	db SHELLDER     ; $17
	db CLOYSTER     ; $8B
	db GASTLY       ; $19
	db HAUNTER      ; $93
	db GENGAR       ; $0E
	db ONIX         ; $22
	db DROWZEE      ; $30
	db HYPNO        ; $81
	db KRABBY       ; $4E
	db KINGLER      ; $8A
	db EXEGGCUTE    ; $0C
	db EXEGGUTOR    ; $0A
	db CUBONE       ; $11
	db MAROWAK      ; $91
	db LICKITUNG    ; $0B
	db KOFFING      ; $37
	db WEEZING      ; $8F
	db RHYHORN      ; $12
	db RHYDON       ; $01
	db TANGELA      ; $1E
	db HORSEA       ; $5C
	db SEADRA       ; $5D
	db GOLDEEN      ; $9D
	db SEAKING      ; $9E
	db MR_MIME      ; $2A
	db SCYTHER      ; $1A
	db PINSIR       ; $1D
	db MAGIKARP     ; $85
	db GYARADOS     ; $16
	db LAPRAS       ; $13
	db DRATINI      ; $58
	db DRAGONAIR    ; $59
	db DRAGONITE    ; $42
;126 to 131 are 3-1 ratio --> atk dv >= 12 is male
	db CLEFAIRY     ; $04
	db CLEFABLE     ; $8E
	db VULPIX       ; $52
	db NINETALES    ; $53
	db JIGGLYPUFF   ; $64
	db WIGGLYTUFF   ; $65
;132 to 137 are female only --> atk dv >= 16 (not possible) is male
	db NIDORAN_F    ; $0F
	db NIDORINA     ; $A8
	db NIDOQUEEN    ; $10
	db CHANSEY      ; $28
	db KANGASKHAN   ; $02
	db JYNX         ; $48
;otherwise a pokemon not on this list are unsexed
	db $00
; db MAGNEMITE    ; $AD
; db MAGNETON     ; $36
; db VOLTORB      ; $06
; db ELECTRODE    ; $8D
; db STARYU       ; $1B
; db STARMIE      ; $98
; db DITTO        ; $4C
; db PORYGON      ; $AA
; db ARTICUNO     ; $4A
; db ZAPDOS       ; $4B
; db MOLTRES      ; $49
; db MEWTWO       ; $83
; db MEW          ; $15

GetGenderRatioTarget:
	cp 6
	ld b, 0
	ret c
	cp 25
	ld b, 2
	ret c
	cp 35
	ld b, 4
	ret c
	cp 126
	ld b, 8
	ret c
	cp 132
	ld b, 12
	ret c
	ld b, 16
	ret


ListGameItems:
	db HS_ROUTE_2_ITEM_1
	db HS_ROUTE_2_ITEM_2
	db HS_ROUTE_4_ITEM
	db HS_ROUTE_9_ITEM
	db HS_ROUTE_12_ITEM_1
	db HS_ROUTE_12_ITEM_2
	db HS_ROUTE_15_ITEM
	db HS_ROUTE_24_ITEM
	db HS_ROUTE_25_ITEM
	db HS_VIRIDIAN_GYM_ITEM
	db HS_CERULEAN_CAVE_1F_ITEM_1
	db HS_CERULEAN_CAVE_1F_ITEM_2
	db HS_CERULEAN_CAVE_1F_ITEM_3
	db HS_POKEMONTOWER_3F_ITEM
	db HS_POKEMONTOWER_4F_ITEM_1
	db HS_POKEMONTOWER_4F_ITEM_2
	db HS_POKEMONTOWER_4F_ITEM_3
	db HS_POKEMONTOWER_5F_ITEM
	db HS_POKEMONTOWER_6F_ITEM_1
	db HS_POKEMONTOWER_6F_ITEM_2
	db HS_WARDENS_HOUSE_ITEM
	db HS_POKEMON_MANSION_1F_ITEM_1
	db HS_POKEMON_MANSION_1F_ITEM_2
	db HS_POWER_PLANT_ITEM_1
	db HS_POWER_PLANT_ITEM_2
	db HS_POWER_PLANT_ITEM_3
	db HS_POWER_PLANT_ITEM_4
	db HS_POWER_PLANT_ITEM_5
	db HS_POWER_PLANT_ITEM_6
	db HS_VICTORY_ROAD_2_ITEM_1
	db HS_VICTORY_ROAD_2_ITEM_2
	db HS_VICTORY_ROAD_2_ITEM_3
	db HS_VICTORY_ROAD_2_ITEM_4
	db HS_VIRIDIAN_FOREST_ITEM_1
	db HS_VIRIDIAN_FOREST_ITEM_2
	db HS_VIRIDIAN_FOREST_ITEM_3
	db HS_MT_MOON_1F_ITEM_1
	db HS_MT_MOON_1F_ITEM_2
	db HS_MT_MOON_1F_ITEM_3
	db HS_MT_MOON_1F_ITEM_4
	db HS_MT_MOON_1F_ITEM_5
	db HS_MT_MOON_1F_ITEM_6
	db HS_MT_MOON_B2F_ITEM_1
	db HS_MT_MOON_B2F_ITEM_2
	db HS_SS_ANNE_1F_ROOMS_ITEM
	db HS_SS_ANNE_2F_ROOMS_ITEM_1
	db HS_SS_ANNE_2F_ROOMS_ITEM_2
	db HS_SS_ANNE_B1F_ROOMS_ITEM_1
	db HS_SS_ANNE_B1F_ROOMS_ITEM_2
	db HS_SS_ANNE_B1F_ROOMS_ITEM_3
	db HS_VICTORY_ROAD_3F_ITEM_1
	db HS_VICTORY_ROAD_3F_ITEM_2
	db HS_ROCKET_HIDEOUT_B1F_ITEM_1
	db HS_ROCKET_HIDEOUT_B1F_ITEM_2
	db HS_ROCKET_HIDEOUT_B2F_ITEM_1
	db HS_ROCKET_HIDEOUT_B2F_ITEM_2
	db HS_ROCKET_HIDEOUT_B2F_ITEM_3
	db HS_ROCKET_HIDEOUT_B2F_ITEM_4
	db HS_ROCKET_HIDEOUT_B3F_ITEM_1
	db HS_ROCKET_HIDEOUT_B3F_ITEM_2
	db HS_ROCKET_HIDEOUT_B4F_ITEM_1
	db HS_ROCKET_HIDEOUT_B4F_ITEM_2
	db HS_ROCKET_HIDEOUT_B4F_ITEM_3
	db HS_ROCKET_HIDEOUT_B4F_ITEM_4
	db HS_SILPH_CO_3F_ITEM
	db HS_SILPH_CO_4F_ITEM_1
	db HS_SILPH_CO_4F_ITEM_2
	db HS_SILPH_CO_4F_ITEM_3
	db HS_SILPH_CO_5F_ITEM_1
	db HS_SILPH_CO_5F_ITEM_2
	db HS_SILPH_CO_6F_ITEM_1
	db HS_SILPH_CO_6F_ITEM_2
	db HS_SILPH_CO_7F_ITEM_1
	db HS_SILPH_CO_7F_ITEM_2
	db HS_SILPH_CO_10F_ITEM_1
	db HS_SILPH_CO_10F_ITEM_2
	db HS_SILPH_CO_10F_ITEM_3
	db HS_POKEMON_MANSION_2F_ITEM
	db HS_POKEMON_MANSION_3F_ITEM_1
	db HS_POKEMON_MANSION_3F_ITEM_2
	db HS_POKEMON_MANSION_B1F_ITEM_1
	db HS_POKEMON_MANSION_B1F_ITEM_2
	db HS_POKEMON_MANSION_B1F_ITEM_3
	db HS_POKEMON_MANSION_B1F_ITEM_4
	db HS_SAFARI_ZONE_EAST_ITEM_1
	db HS_SAFARI_ZONE_EAST_ITEM_2
	db HS_SAFARI_ZONE_EAST_ITEM_3
	db HS_SAFARI_ZONE_EAST_ITEM_4
	db HS_SAFARI_ZONE_NORTH_ITEM_1
	db HS_SAFARI_ZONE_NORTH_ITEM_2
	db HS_SAFARI_ZONE_WEST_ITEM_1
	db HS_SAFARI_ZONE_WEST_ITEM_2
	db HS_SAFARI_ZONE_WEST_ITEM_3
	db HS_SAFARI_ZONE_CENTER_ITEM
	db HS_CERULEAN_CAVE_2F_ITEM_1
	db HS_CERULEAN_CAVE_2F_ITEM_2
	db HS_CERULEAN_CAVE_2F_ITEM_3
	db HS_CERULEAN_CAVE_B1F_ITEM_1
	db HS_CERULEAN_CAVE_B1F_ITEM_2
	db HS_VICTORY_ROAD_1F_ITEM_1
	db HS_VICTORY_ROAD_1F_ITEM_2
	db $00


ListNonLegendUnEvoPkmn:			;lvl 30+
	db LAPRAS
	db TAUROS
	db AERODACTYL
	db PINSIR
	db SNORLAX
	db SCYTHER
	db CHANSEY
	db KANGASKHAN
	db ELECTABUZZ
	db MAGMAR
	db TANGELA
	db HITMONCHAN
	db HITMONLEE
	db JYNX
	db MR_MIME
	db RHYHORN
	db LICKITUNG
ListNonLegendUnEvoPkmn_mid:		;lvl 15+
	db ONIX
	db GASTLY
	db SLOWPOKE
	db CUBONE
	db MACHOP
ListNonLegendUnEvoPkmn_early:	;any time
	db PONYTA
	db PORYGON
	db KABUTO
	db KRABBY
	db OMANYTE
	db KOFFING
	db FARFETCHD
	db DROWZEE
	db GOLDEEN
	db STARYU
	db TENTACOOL
	db EEVEE
	db EXEGGCUTE
	db GROWLITHE
	db SANDSHREW
	db SEEL
	db SHELLDER
	db DODUO
	db GRIMER
	db VOLTORB
	db BELLSPROUT
	db GEODUDE
	db HORSEA
	db MAGNEMITE
	db MANKEY
	db PIKACHU
	db POLIWAG
	db CLEFAIRY
	db ABRA
	db ODDISH
	db PSYDUCK
	db BULBASAUR
	db DRATINI
	db MEOWTH
	db SQUIRTLE
	db VENONAT
	db CHARMANDER
	db VULPIX
	db DITTO
	db PARAS
	db NIDORAN_F
	db EKANS
	db NIDORAN_M
	db SPEAROW
	db DIGLETT
	db JIGGLYPUFF
	db RATTATA
	db PIDGEY
	db ZUBAT
	db MAGIKARP
	db CATERPIE
	db WEEDLE
	db $00

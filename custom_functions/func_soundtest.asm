; NUM_MUSIC_TRACKS and the category boundaries are computed from the track lists below

DisplaySoundTestMenu:
	ld a, SFX_PRESS_AB
	call PlaySound
	call ClearScreen
	ld a, 1
	ld [hJoy7], a
	
;place the static strings for the screen
	coord hl, 4, 1
	ld de, SoundTitleText
	call PlaceString
	coord hl, 0, 10
	ld de, SoundChangeCategoryText
	call PlaceString
	coord hl, 0, 12
	ld de, SoundChangeText
	call PlaceString
	coord hl, 0, 14
	ld de, SoundPlayText
	call PlaceString
	coord hl, 0, 16
	ld de, SoundBackNextText
	call PlaceString
	coord hl, 16, 16
	ld de, SoundMenuSelect
	call PlaceString
;draw text box for the category
	coord hl, 0, 3
	ld b, 1
	ld c, 18
	call TextBoxBorder
;draw text box for the audio track
	coord hl, 0, 6
	ld b, 1
	ld c, 18
	call TextBoxBorder

;update to initial track in the list
	xor a
	ld [wWhichPokemon], a
	call .updatetrackname
	call .updatecategoryname
; fallthrough
.loop
	call Delay3
; fallthrough
.getJoypadStateLoop
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	bit BIT_B_BUTTON, b ; B button pressed?
	jr nz, .exitMenu
	bit BIT_SELECT, b
	jr nz, .exitMenu
	bit BIT_A_BUTTON, b ; A button pressed?
	jp nz, .play_selection
.checkDirectionKeys
	bit BIT_D_UP, b ; Up pressed?
	jr nz, .dec_category
	bit BIT_D_DOWN, b ; Down pressed?
	jr nz, .inc_category
	bit BIT_D_LEFT, b ; Left pressed?
	jr nz, .dec_track
	bit BIT_D_RIGHT, b ; Right pressed?
	jr nz, .inc_track
	jr .getJoypadStateLoop
.exitMenu
	xor a
	ld [hJoy7], a
	ld a, SFX_PRESS_AB
	call PlaySound
	call ClearScreen
	ret
	
.inc_track
	ld a, [wWhichPokemon]
	call .getcategory
	call .getcatend
	ld d, a
	ld a, [wWhichPokemon]
	inc a
	cp d
	jr c, .inc_track_next
	call .getcatstart
.inc_track_next
	ld [wWhichPokemon], a
	call .updatetrackname
	jr .loop
	
.dec_track
	ld a, [wWhichPokemon]
	call .getcategory
	call .getcatstart
	ld d, a
	ld a, [wWhichPokemon]
	cp d
	jr nz, .dec_track_do
	call .getcatend
	dec a
	jr .dec_track_store
.dec_track_do
	dec a
.dec_track_store
	ld [wWhichPokemon], a
	call .updatetrackname
	jr .loop

.inc_category
	ld a, [wWhichPokemon]
	call .getcategory
	ld a, NUM_SOUNDTEST_CATEGORIES-1
	cp c
	jr z, .inc_category_wrap
	inc c
	jr .inc_category_go
.inc_category_wrap
	ld c, 0
.inc_category_go
	call .getcatstart
	ld [wWhichPokemon], a
	call .updatetrackname
	call .updatecategoryname
	jp .loop

.dec_category
	ld a, [wWhichPokemon]
	call .getcategory
	ld a, c
	or a
	jr z, .dec_category_wrap
	dec c
	jr .dec_category_go
.dec_category_wrap
	ld c, NUM_SOUNDTEST_CATEGORIES-1
.dec_category_go
	call .getcatstart
	ld [wWhichPokemon], a
	call .updatetrackname
	call .updatecategoryname
	jp .loop
	
.play_selection
	ld hl, SoundTestTrackList
	ld a, [wWhichPokemon]
	ld b, 0
	ld c, a
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	inc hl
	inc hl
	
	ld a, [hli]
	ld c, a
	ld a, [hl]
	call PlayMusic

	jp .getJoypadStateLoop

.updatetrackname
	;blank track name
	coord hl, 1, 7
	ld de, SoundTestTextBlankTrack
	call PlaceString

	ld hl, SoundTestTrackList
	ld a, [wWhichPokemon]
	ld b, 0
	ld c, a
	sla c
	rl b
	sla c
	rl b
	add hl, bc

	ld a, [hli]	;read low nybble of track name address
	ld e, a
	ld a, [hli]	;read high nybble of track name address
	ld d, a

	;print track name
	coord hl, 1, 7
	call PlaceString
	ret

.updatecategoryname
	;blank category name
	coord hl, 1, 4
	ld de, SoundTestTextBlankTrack
	call PlaceString

	;find the category of the current track
	ld a, [wWhichPokemon]
	call .getcategory
	ld b, 0
	ld hl, SoundTestCategoryNames
	sla c
	rl b
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a

	;print category name
	coord hl, 1, 4
	call PlaceString
	ret

.getcategory
	;a = track index, returns c = category index
	ld hl, SoundTestCategoryEnds
	ld c, 0
.getcategory_loop
	cp [hl]
	jr c, .getcategory_done
	inc hl
	inc c
	jr .getcategory_loop
.getcategory_done
	ret

.getcatstart
	;c = category index, returns a = first track of the category
	ld hl, SoundTestCategoryEnds - 1
	ld b, 0
	add hl, bc
	ld a, [hl]
	ret

.getcatend
	;c = category index, returns a = end of the category (exclusive)
	ld hl, SoundTestCategoryEnds
	ld b, 0
	add hl, bc
	ld a, [hl]
	ret
	
SoundTitleText:
	db $E4, " Baladeur ", $E4, "@"
SoundChangeCategoryText:
	db $CC, $CD, "Changer Origine@"
SoundChangeText:
	db $CA, $CB, "Changer Piste@"
SoundPlayText:
	db $C8, $C9, "Jouer@"
SoundBackNextText:
	db $C6, $C7, "Retour@"
SoundMenuSelect:
	db $C0,$C1,$C2,$ED,"@"
SoundTestTextBlankTrack:
	db "                  @"

;sound test categories (same order as the track lists below)
SoundTestCategoryNames:
	dw .CategoryRougeBleue
	dw .CategoryJaune
	dw .CategoryAlpha
	dw .CategoryCristal
	dw .CategoryTCG
	dw .CategoryTCG2
	dw .CategoryPinball
NUM_SOUNDTEST_CATEGORIES EQU 7
ASSERT @ - SoundTestCategoryNames == NUM_SOUNDTEST_CATEGORIES * 2 ; keep in sync when adding a category

.CategoryRougeBleue: db "Rouge/Bleue@"
.CategoryJaune: db "Jaune@"
.CategoryAlpha: db "Beta@"
.CategoryCristal: db "Cristal@"
.CategoryTCG: db "TCG@"
.CategoryTCG2: db "TCG 2@"
.CategoryPinball: db "Pinball@"


SoundTestTrackList:
	dw Title_Music_PalletTown, (MUSIC_PALLET_TOWN << 8) | 0 ; Bank(Music_PalletTown)
	dw Title_Music_Pokecenter, (MUSIC_POKECENTER << 8) | 0 ; Bank(Music_Pokecenter)
	dw Title_Music_Gym, (MUSIC_GYM << 8) | 0 ; Bank(Music_Gym)
	dw Title_Music_Cities1, (MUSIC_CITIES1 << 8) | 0 ; Bank(Music_Cities1)
	dw Title_Music_Cities2, (MUSIC_CITIES2 << 8) | 0 ; Bank(Music_Cities2)
	dw Title_Music_Celadon, (MUSIC_CELADON << 8) | 0 ; Bank(Music_Celadon)
	dw Title_Music_Cinnabar, (MUSIC_CINNABAR << 8) | 0 ; Bank(Music_Cinnabar)
	dw Title_Music_Vermilion, (MUSIC_VERMILION << 8) | 0 ; Bank(Music_Vermilion)
	dw Title_Music_Lavender, (MUSIC_LAVENDER << 8) | 0 ; Bank(Music_Lavender)
	dw Title_Music_SSAnne, (MUSIC_SS_ANNE << 8) | 0 ; Bank(Music_SSAnne)
	dw Title_Music_MeetProfOak, (MUSIC_MEET_PROF_OAK << 8) | 0 ; Bank(Music_MeetProfOak)
	dw Title_Music_MeetRival, (MUSIC_MEET_RIVAL << 8) | 0 ; Bank(Music_MeetRival)
	dw Title_Music_MuseumGuy, (MUSIC_MUSEUM_GUY << 8) | 0 ; Bank(Music_MuseumGuy)
	dw Title_Music_SafariZone, (MUSIC_SAFARI_ZONE << 8) | 0 ; Bank(Music_SafariZone)
	dw Title_Music_PkmnHealed, (MUSIC_PKMN_HEALED << 8) | 0 ; Bank(Music_PkmnHealed)
	dw Title_Music_Routes1, (MUSIC_ROUTES1 << 8) | 0 ; Bank(Music_Routes1)
	dw Title_Music_Routes2, (MUSIC_ROUTES2 << 8) | 0 ; Bank(Music_Routes2)
	dw Title_Music_Routes3, (MUSIC_ROUTES3 << 8) | 0 ; Bank(Music_Routes3)
	dw Title_Music_Routes4, (MUSIC_ROUTES4 << 8) | 0 ; Bank(Music_Routes4)
	dw Title_Music_IndigoPlateau, (MUSIC_INDIGO_PLATEAU << 8) | 0 ; Bank(Music_IndigoPlateau)
	dw Title_Music_GymLeaderBattle, (MUSIC_GYM_LEADER_BATTLE << 8) | 0 ; Bank(Music_GymLeaderBattle)
	dw Title_Music_TrainerBattle, (MUSIC_TRAINER_BATTLE << 8) | 0 ; Bank(Music_TrainerBattle)
	dw Title_Music_WildBattle, (MUSIC_WILD_BATTLE << 8) | 0 ; Bank(Music_WildBattle)
	dw Title_Music_FinalBattle, (MUSIC_FINAL_BATTLE << 8) | 0 ; Bank(Music_FinalBattle)
	dw Title_Music_DefeatedTrainer, (MUSIC_DEFEATED_TRAINER << 8) | 0 ; Bank(Music_DefeatedTrainer)
	dw Title_Music_DefeatedWildMon, (MUSIC_DEFEATED_WILD_MON << 8) | 0 ; Bank(Music_DefeatedWildMon)
	dw Title_Music_DefeatedGymLeader, (MUSIC_DEFEATED_GYM_LEADER << 8) | 0 ; Bank(Music_DefeatedGymLeader)
	dw Title_Music_TitleScreen, (MUSIC_TITLE_SCREEN << 8) | 0 ; Bank(Music_TitleScreen)
	dw Title_Music_Credits, (MUSIC_CREDITS << 8) | 0 ; Bank(Music_Credits)
	dw Title_Music_HallOfFame, (MUSIC_INDIGO_HALL_OF_FAME << 8) | 0 ; Bank(Music_HallOfFame)
	dw Title_Music_OaksLab, (MUSIC_OAKS_LAB << 8) | 0 ; Bank(Music_OaksLab)
	dw Title_Music_JigglypuffSong, (MUSIC_JIGGLYPUFF_SONG << 8) | 0 ; Bank(Music_JigglypuffSong)
	dw Title_Music_BikeRiding, (MUSIC_BIKE_RIDING << 8) | 0 ; Bank(Music_BikeRiding)
	dw Title_Music_Surfing, (MUSIC_SURFING << 8) | 0 ; Bank(Music_Surfing)
	dw Title_Music_GameCorner, (MUSIC_CELADON_GAME_CORNER << 8) | 0 ; Bank(Music_GameCorner)
	dw Title_Music_IntroBattle, (MUSIC_INTRO_BATTLE << 8) | 0 ; Bank(Music_IntroBattle)
	dw Title_Music_Dungeon1, (MUSIC_DUNGEON1 << 8) | 0 ; Bank(Music_Dungeon1)
	dw Title_Music_Dungeon2, (MUSIC_DUNGEON2 << 8) | 0 ; Bank(Music_Dungeon2)
	dw Title_Music_Dungeon3, (MUSIC_DUNGEON3 << 8) | 0 ; Bank(Music_Dungeon3)
	dw Title_Music_CinnabarMansion, (MUSIC_CINNABAR_MANSION << 8) | 0 ; Bank(Music_CinnabarMansion)
	dw Title_Music_PokemonTower, (MUSIC_POKEMON_TOWER << 8) | 0 ; Bank(Music_PokemonTower)
	dw Title_Music_SilphCo, (MUSIC_SILPH_CO << 8) | 0 ; Bank(Music_SilphCo)
	dw Title_Music_MeetEvilTrainer, (MUSIC_MEET_EVIL_TRAINER << 8) | 0 ; Bank(Music_MeetEvilTrainer)
	dw Title_Music_MeetFemaleTrainer, (MUSIC_MEET_FEMALE_TRAINER << 8) | 0 ; Bank(Music_MeetFemaleTrainer)
	dw Title_Music_MeetMaleTrainer, (MUSIC_MEET_MALE_TRAINER << 8) | 0 ; Bank(Music_MeetMaleTrainer)
	
SoundTestTrackList_Yellow:
	dw Title_Music_SurfingPikachu, (MUSIC_SURFING_PIKACHU << 8) | 0 ; Bank(Music_SurfingPikachu)
	dw Title_Music_MeetJessieJames, (MUSIC_MEET_JESSIE_JAMES << 8) | 0 ; Bank(Music_MeetJessieJames)
	dw Title_Music_YellowIntro, (MUSIC_YELLOW_INTRO << 8) | 0 ; Bank(Music_YellowIntro)

SoundTestTrackList_Alpha:
	dw Title_Music_TradeSong, (MUSIC_TRADE_SONG << 8) | 0 ; Bank(Music_TradeSong)
	dw Title_Music_GiovanniSong, (MUSIC_GIOVANNI_SONG << 8) | 0 ; Bank(Music_GiovanniSong)
	dw Title_Music_BattleVictoryGuide, (MUSIC_BATTLE_VICTORY_GUIDE << 8) | 0 ; Bank(Music_BattleVictoryGuide)
	dw Title_Music_DiglettsCave, (MUSIC_DIGLETTS_CAVE << 8) | 0 ; Bank(Music_DiglettsCave)
	dw Title_Music_RestPallet, (MUSIC_REST_PALLET << 8) | 0 ; Bank(Music_RestPallet)
	dw Title_Music_Route3Early, (MUSIC_ROUTE_3_EARLY << 8) | 0 ; Bank(Music_Route3Early)

SoundTestTrackList_GS:
	dw Title_Music_GS_TITLE_SCREEN, (MUSIC_GSC_TITLE_SCREEN << 8) | 0
	dw Title_Music_GS_ROUTE1, (MUSIC_GSC_ROUTE1 << 8) | 0
	dw Title_Music_GS_ROUTE3, (MUSIC_GSC_ROUTE3 << 8) | 0
	dw Title_Music_GS_ROUTE12, (MUSIC_GSC_ROUTE12 << 8) | 0
	dw Title_Music_GS_MAGNET_TRAIN, (MUSIC_GSC_MAGNET_TRAIN << 8) | 0
	dw Title_Music_GS_KANTO_GYM_BATTLE, (MUSIC_GSC_KANTO_GYM_BATTLE << 8) | 0
	dw Title_Music_GS_KANTO_TRAINER_BATTLE, (MUSIC_GSC_KANTO_TRAINER_BATTLE << 8) | 0
	dw Title_Music_GS_KANTO_WILD_BATTLE, (MUSIC_GSC_KANTO_WILD_BATTLE << 8) | 0
	dw Title_Music_GS_POKEMON_CENTER, (MUSIC_GSC_POKEMON_CENTER << 8) | 0
	dw Title_Music_GS_LOOK_HIKER, (MUSIC_GSC_LOOK_HIKER << 8) | 0
	dw Title_Music_GS_LOOK_LASS, (MUSIC_GSC_LOOK_LASS << 8) | 0
	dw Title_Music_GS_LOOK_OFFICER, (MUSIC_GSC_LOOK_OFFICER << 8) | 0
	dw Title_Music_GS_HEAL_POKEMON, (MUSIC_GSC_HEAL_POKEMON << 8) | 0
	dw Title_Music_GS_LAVENDER_TOWN, (MUSIC_GSC_LAVENDER_TOWN << 8) | 0
	dw Title_Music_GS_ROUTE2, (MUSIC_GSC_ROUTE2 << 8) | 0
	dw Title_Music_GS_MT_MOON, (MUSIC_GSC_MT_MOON << 8) | 0
	dw Title_Music_GS_SHOW_ME_AROUND, (MUSIC_GSC_SHOW_ME_AROUND << 8) | 0
	dw Title_Music_GS_GAME_CORNER, (MUSIC_GSC_GAME_CORNER << 8) | 0
	dw Title_Music_GS_BICYCLE, (MUSIC_GSC_BICYCLE << 8) | 0
	dw Title_Music_GS_HALL_OF_FAME, (MUSIC_GSC_HALL_OF_FAME << 8) | 0
	dw Title_Music_GS_VIRIDIAN_CITY, (MUSIC_GSC_VIRIDIAN_CITY << 8) | 0
	dw Title_Music_GS_CELADON_CITY, (MUSIC_GSC_CELADON_CITY << 8) | 0
	dw Title_Music_GS_TRAINER_VICTORY, (MUSIC_GSC_TRAINER_VICTORY << 8) | 0
	dw Title_Music_GS_WILD_POKEMON_VICTORY, (MUSIC_GSC_WILD_POKEMON_VICTORY << 8) | 0
	dw Title_Music_GS_GYM_LEADER_VICTORY, (MUSIC_GSC_GYM_LEADER_VICTORY << 8) | 0
	dw Title_Music_GS_MT_MOON_SQUARE, (MUSIC_GSC_MT_MOON_SQUARE << 8) | 0
	dw Title_Music_GS_GYM, (MUSIC_GSC_GYM << 8) | 0
	dw Title_Music_GS_PALLET_TOWN, (MUSIC_GSC_PALLET_TOWN << 8) | 0
	dw Title_Music_GS_PROF_OAKS_POKEMON_TALK, (MUSIC_GSC_PROF_OAKS_POKEMON_TALK << 8) | 0
	dw Title_Music_GS_PROF_OAK, (MUSIC_GSC_PROF_OAK << 8) | 0
	dw Title_Music_GS_LOOK_RIVAL, (MUSIC_GSC_LOOK_RIVAL << 8) | 0
	dw Title_Music_GS_AFTER_THE_RIVAL_FIGHT, (MUSIC_GSC_AFTER_THE_RIVAL_FIGHT << 8) | 0
	dw Title_Music_GS_SURF, (MUSIC_GSC_SURF << 8) | 0
	dw Title_Music_GS_EVOLUTION, (MUSIC_GSC_EVOLUTION << 8) | 0
	dw Title_Music_GS_NATIONAL_PARK, (MUSIC_GSC_NATIONAL_PARK << 8) | 0
	dw Title_Music_GS_CREDITS, (MUSIC_GSC_CREDITS << 8) | 0
	dw Title_Music_GS_AZALEA_TOWN, (MUSIC_GSC_AZALEA_TOWN << 8) | 0
	dw Title_Music_GS_CHERRYGROVE_CITY, (MUSIC_GSC_CHERRYGROVE_CITY << 8) | 0
	dw Title_Music_GS_LOOK_KIMONO_GIRL, (MUSIC_GSC_LOOK_KIMONO_GIRL << 8) | 0
	dw Title_Music_GS_UNION_CAVE, (MUSIC_GSC_UNION_CAVE << 8) | 0
	dw Title_Music_GS_JOHTO_WILD_BATTLE, (MUSIC_GSC_JOHTO_WILD_BATTLE << 8) | 0
	dw Title_Music_GS_JOHTO_TRAINER_BATTLE, (MUSIC_GSC_JOHTO_TRAINER_BATTLE << 8) | 0
	dw Title_Music_GS_ROUTE30, (MUSIC_GSC_ROUTE30 << 8) | 0
	dw Title_Music_GS_ECRUTEAK_CITY, (MUSIC_GSC_ECRUTEAK_CITY << 8) | 0
	dw Title_Music_GS_VIOLET_CITY, (MUSIC_GSC_VIOLET_CITY << 8) | 0
	dw Title_Music_GS_JOHTO_GYM_BATTLE, (MUSIC_GSC_JOHTO_GYM_BATTLE << 8) | 0
	dw Title_Music_GS_CHAMPION_BATTLE, (MUSIC_GSC_CHAMPION_BATTLE << 8) | 0
	dw Title_Music_GS_RIVAL_BATTLE, (MUSIC_GSC_RIVAL_BATTLE << 8) | 0
	dw Title_Music_GS_ROCKET_BATTLE, (MUSIC_GSC_ROCKET_BATTLE << 8) | 0
	dw Title_Music_GS_ELMS_LAB, (MUSIC_GSC_ELMS_LAB << 8) | 0
	dw Title_Music_GS_DARK_CAVE, (MUSIC_GSC_DARK_CAVE << 8) | 0
	dw Title_Music_GS_ROUTE29, (MUSIC_GSC_ROUTE29 << 8) | 0
	dw Title_Music_GS_ROUTE36, (MUSIC_GSC_ROUTE36 << 8) | 0
	dw Title_Music_GS_S_S_AQUA, (MUSIC_GSC_S_S_AQUA << 8) | 0
	dw Title_Music_GS_LOOK_YOUNGSTER, (MUSIC_GSC_LOOK_YOUNGSTER << 8) | 0
	dw Title_Music_GS_LOOK_BEAUTY, (MUSIC_GSC_LOOK_BEAUTY << 8) | 0
	dw Title_Music_GS_LOOK_ROCKET, (MUSIC_GSC_LOOK_ROCKET << 8) | 0
	dw Title_Music_GS_LOOK_POKEMANIAC, (MUSIC_GSC_LOOK_POKEMANIAC << 8) | 0
	dw Title_Music_GS_LOOK_SAGE, (MUSIC_GSC_LOOK_SAGE << 8) | 0
	dw Title_Music_GS_NEW_BARK_TOWN, (MUSIC_GSC_NEW_BARK_TOWN << 8) | 0
	dw Title_Music_GS_GOLDENROD_CITY, (MUSIC_GSC_GOLDENROD_CITY << 8) | 0
	dw Title_Music_GS_VERMILION_CITY, (MUSIC_GSC_VERMILION_CITY << 8) | 0
	dw Title_Music_GS_POKEMON_CHANNEL, (MUSIC_GSC_POKEMON_CHANNEL << 8) | 0
	dw Title_Music_GS_POKE_FLUTE_CHANNEL, (MUSIC_GSC_POKE_FLUTE_CHANNEL << 8) | 0
	dw Title_Music_GS_TIN_TOWER, (MUSIC_GSC_TIN_TOWER << 8) | 0
	dw Title_Music_GS_SPROUT_TOWER, (MUSIC_GSC_SPROUT_TOWER << 8) | 0
	dw Title_Music_GS_BURNED_TOWER, (MUSIC_GSC_BURNED_TOWER << 8) | 0
	dw Title_Music_GS_LIGHTHOUSE, (MUSIC_GSC_LIGHTHOUSE << 8) | 0
	dw Title_Music_GS_LAKE_OF_RAGE, (MUSIC_GSC_LAKE_OF_RAGE << 8) | 0
	dw Title_Music_GS_INDIGO_PLATEAU, (MUSIC_GSC_INDIGO_PLATEAU << 8) | 0
	dw Title_Music_GS_ROUTE37, (MUSIC_GSC_ROUTE37 << 8) | 0
	dw Title_Music_GS_ROCKET_HIDEOUT, (MUSIC_GSC_ROCKET_HIDEOUT << 8) | 0
	dw Title_Music_GS_DRAGONS_DEN, (MUSIC_GSC_DRAGONS_DEN << 8) | 0
	dw Title_Music_GS_JOHTO_WILD_BATTLE_NIGHT, (MUSIC_GSC_JOHTO_WILD_BATTLE_NIGHT << 8) | 0
	dw Title_Music_GS_RUINS_OF_ALPH_RADIO, (MUSIC_GSC_RUINS_OF_ALPH_RADIO << 8) | 0
	dw Title_Music_GS_SUCCESSFUL_CAPTURE, (MUSIC_GSC_SUCCESSFUL_CAPTURE << 8) | 0
	dw Title_Music_GS_ROUTE26, (MUSIC_GSC_ROUTE26 << 8) | 0
	dw Title_Music_GS_MOM, (MUSIC_GSC_MOM << 8) | 0
	dw Title_Music_GS_VICTORY_ROAD, (MUSIC_GSC_VICTORY_ROAD << 8) | 0
	dw Title_Music_GS_POKEMON_LULLABY, (MUSIC_GSC_POKEMON_LULLABY << 8) | 0
	dw Title_Music_GS_POKEMON_MARCH, (MUSIC_GSC_POKEMON_MARCH << 8) | 0
	dw Title_Music_GS_GOLD_SILVER_OPENING, (MUSIC_GSC_GOLD_SILVER_OPENING << 8) | 0
	dw Title_Music_GS_GOLD_SILVER_OPENING2, (MUSIC_GSC_GOLD_SILVER_OPENING2 << 8) | 0
	dw Title_Music_GS_MAIN_MENU, (MUSIC_GSC_MAIN_MENU << 8) | 0
	dw Title_Music_GS_RUINS_OF_ALPH_INTERIOR, (MUSIC_GSC_RUINS_OF_ALPH_INTERIOR << 8) | 0
	dw Title_Music_GS_ROCKET_THEME, (MUSIC_GSC_ROCKET_THEME << 8) | 0
	dw Title_Music_GS_DANCING_HALL, (MUSIC_GSC_DANCING_HALL << 8) | 0
	dw Title_Music_GS_CONTEST_RESULTS, (MUSIC_GSC_CONTEST_RESULTS << 8) | 0
	dw Title_Music_GS_BUG_CATCHING_CONTEST, (MUSIC_GSC_BUG_CATCHING_CONTEST << 8) | 0
	dw Title_Music_GS_LAKE_OF_RAGE_ROCKET_RADIO, (MUSIC_GSC_LAKE_OF_RAGE_ROCKET_RADIO << 8) | 0
	dw Title_Music_GS_PRINTER, (MUSIC_GSC_PRINTER << 8) | 0
	dw Title_Music_GS_POST_CREDITS, (MUSIC_GSC_POST_CREDITS << 8) | 0
	dw Title_Music_GS_CLAIR, (MUSIC_GSC_CLAIR << 8) | 0
	dw Title_Music_GS_MOBILE_ADAPTER_MENU, (MUSIC_GSC_MOBILE_ADAPTER_MENU << 8) | 0
	dw Title_Music_GS_MOBILE_ADAPTER, (MUSIC_GSC_MOBILE_ADAPTER << 8) | 0
	dw Title_Music_GS_BUENAS_PASSWORD, (MUSIC_GSC_BUENAS_PASSWORD << 8) | 0
	dw Title_Music_GS_LOOK_MYSTICAL_MAN, (MUSIC_GSC_LOOK_MYSTICAL_MAN << 8) | 0
	dw Title_Music_GS_CRYSTAL_OPENING, (MUSIC_GSC_CRYSTAL_OPENING << 8) | 0
	dw Title_Music_GS_BATTLE_TOWER_THEME, (MUSIC_GSC_BATTLE_TOWER_THEME << 8) | 0
	dw Title_Music_GS_SUICUNE_BATTLE, (MUSIC_GSC_SUICUNE_BATTLE << 8) | 0
	dw Title_Music_GS_BATTLE_TOWER_LOBBY, (MUSIC_GSC_BATTLE_TOWER_LOBBY << 8) | 0
	dw Title_Music_GS_MOBILE_CENTER, (MUSIC_GSC_MOBILE_CENTER << 8) | 0

SoundTestTrackList_TCG:
	dw Title_Music_TCG_PauseMenu, (MUSIC_TCG_PAUSE_MENU << 8) | 0
	dw Title_Music_TCG_BOOSTER_PACK, (MUSIC_TCG_BOOSTER_PACK << 8) | 0
	dw Title_Music_TCG_CARD_POP, (MUSIC_TCG_CARD_POP << 8) | 0
	dw Title_Music_TCG_CHALLENGE_HALL, (MUSIC_TCG_CHALLENGE_HALL << 8) | 0
	dw Title_Music_TCG_CLUB1, (MUSIC_TCG_CLUB1 << 8) | 0
	dw Title_Music_TCG_CLUB2, (MUSIC_TCG_CLUB2 << 8) | 0
	dw Title_Music_TCG_CLUB3, (MUSIC_TCG_CLUB3 << 8) | 0
	dw Title_Music_TCG_CREDITS, (MUSIC_TCG_CREDITS << 8) | 0
	dw Title_Music_TCG_DECK_MACHINE, (MUSIC_TCG_DECK_MACHINE << 8) | 0
	dw Title_Music_TCG_DUEL_THEME1, (MUSIC_TCG_DUEL_THEME1 << 8) | 0
	dw Title_Music_TCG_DUEL_THEME2, (MUSIC_TCG_DUEL_THEME2 << 8) | 0
	dw Title_Music_TCG_DUEL_THEME3, (MUSIC_TCG_DUEL_THEME3 << 8) | 0
	dw Title_Music_TCG_HALL_OF_HONOR, (MUSIC_TCG_HALL_OF_HONOR << 8) | 0
	dw Title_Music_TCG_IMAKUNI, (MUSIC_TCG_IMAKUNI << 8) | 0
	dw Title_Music_TCG_MATCH_DRAW, (MUSIC_TCG_MATCH_DRAW << 8) | 0
	dw Title_Music_TCG_MATCH_LOSS, (MUSIC_TCG_MATCH_LOSS << 8) | 0
	dw Title_Music_TCG_MATCH_START1, (MUSIC_TCG_MATCH_START1 << 8) | 0
	dw Title_Music_TCG_MATCH_START2, (MUSIC_TCG_MATCH_START2 << 8) | 0
	dw Title_Music_TCG_MATCH_START3, (MUSIC_TCG_MATCH_START3 << 8) | 0
	dw Title_Music_TCG_MATCH_VICTORY, (MUSIC_TCG_MATCH_VICTORY << 8) | 0
	dw Title_Music_TCG_MEDAL, (MUSIC_TCG_MEDAL << 8) | 0
	dw Title_Music_TCG_OVERWORLD, (MUSIC_TCG_OVERWORLD << 8) | 0
	dw Title_Music_TCG_PC_MAIN_MENU, (MUSIC_TCG_PC_MAIN_MENU << 8) | 0
	dw Title_Music_TCG_POKEMON_DOME, (MUSIC_TCG_POKEMON_DOME << 8) | 0
	dw Title_Music_TCG_RONALD, (MUSIC_TCG_RONALD << 8) | 0
	dw Title_Music_TCG_TITLE_SCREEN, (MUSIC_TCG_TITLE_SCREEN << 8) | 0

SoundTestTrackList_TCG2:
	dw Title_Music_TCG2_CREDITS, (MUSIC_TCG2_CREDITS << 8) | 0
	dw Title_Music_TCG2_DITTY1, (MUSIC_TCG2_DITTY1 << 8) | 0
	dw Title_Music_TCG2_DITTY2, (MUSIC_TCG2_DITTY2 << 8) | 0
	dw Title_Music_TCG2_DITTY3, (MUSIC_TCG2_DITTY3 << 8) | 0
	dw Title_Music_TCG2_DITTY4, (MUSIC_TCG2_DITTY4 << 8) | 0
	dw Title_Music_TCG2_DITTY5, (MUSIC_TCG2_DITTY5 << 8) | 0
	dw Title_Music_TCG2_DITTY6, (MUSIC_TCG2_DITTY6 << 8) | 0
	dw Title_Music_TCG2_FORT1, (MUSIC_TCG2_FORT1 << 8) | 0
	dw Title_Music_TCG2_FORT2, (MUSIC_TCG2_FORT2 << 8) | 0
	dw Title_Music_TCG2_FORT3, (MUSIC_TCG2_FORT3 << 8) | 0
	dw Title_Music_TCG2_FORT4, (MUSIC_TCG2_FORT4 << 8) | 0
	dw Title_Music_TCG2_GAME_CORNER, (MUSIC_TCG2_GAME_CORNER << 8) | 0
	dw Title_Music_TCG2_GR_BLIMP, (MUSIC_TCG2_GR_BLIMP << 8) | 0
	dw Title_Music_TCG2_GR_CASTLE, (MUSIC_TCG2_GR_CASTLE << 8) | 0
	dw Title_Music_TCG2_GR_CHALLENGE_CUP, (MUSIC_TCG2_GR_CHALLENGE_CUP << 8) | 0
	dw Title_Music_TCG2_GR_DUEL_THEME1, (MUSIC_TCG2_GR_DUEL_THEME1 << 8) | 0
	dw Title_Music_TCG2_GR_DUEL_THEME2, (MUSIC_TCG2_GR_DUEL_THEME2 << 8) | 0
	dw Title_Music_TCG2_GR_DUEL_THEME3, (MUSIC_TCG2_GR_DUEL_THEME3 << 8) | 0
	dw Title_Music_TCG2_GR_OVERWORLD, (MUSIC_TCG2_GR_OVERWORLD << 8) | 0
	dw Title_Music_TCG2_HERE_COMES_GR, (MUSIC_TCG2_HERE_COMES_GR << 8) | 0
	dw Title_Music_TCG2_IMAKUNI2, (MUSIC_TCG2_IMAKUNI2 << 8) | 0
	dw Title_Music_TCG2_ISHIHARA, (MUSIC_TCG2_ISHIHARA << 8) | 0
	dw Title_Music_TCG2_TITLE_SCREEN, (MUSIC_TCG2_TITLE_SCREEN << 8) | 0

SoundTestTrackList_Pinball:
	dw Title_Music_PIN_BLUE_FIELD, (MUSIC_PIN_BLUE_FIELD << 8) | 0
	dw Title_Music_PIN_CATCH_EM_BLUE, (MUSIC_PIN_CATCH_EM_BLUE << 8) | 0
	dw Title_Music_PIN_CATCH_EM_RED, (MUSIC_PIN_CATCH_EM_RED << 8) | 0
	dw Title_Music_PIN_END_CREDITS, (MUSIC_PIN_END_CREDITS << 8) | 0
	dw Title_Music_PIN_FIELD_SELECT, (MUSIC_PIN_FIELD_SELECT << 8) | 0
	dw Title_Music_PIN_GAME_OVER, (MUSIC_PIN_GAME_OVER << 8) | 0
	dw Title_Music_PIN_GASTLY_GRAVE, (MUSIC_PIN_GASTLY_GRAVE << 8) | 0
	dw Title_Music_PIN_GENGAR_GRAVE, (MUSIC_PIN_GENGAR_GRAVE << 8) | 0
	dw Title_Music_PIN_HAUNTER_GRAVE, (MUSIC_PIN_HAUNTER_GRAVE << 8) | 0
	dw Title_Music_PIN_HI_SCORE, (MUSIC_PIN_HI_SCORE << 8) | 0
	dw Title_Music_PIN_HURRY_UP_BLUE, (MUSIC_PIN_HURRY_UP_BLUE << 8) | 0
	dw Title_Music_PIN_HURRY_UP_RED, (MUSIC_PIN_HURRY_UP_RED << 8) | 0
	dw Title_Music_PIN_MEOWTH_STAGE, (MUSIC_PIN_MEOWTH_STAGE << 8) | 0
	dw Title_Music_PIN_MEWTWO_STAGE, (MUSIC_PIN_MEWTWO_STAGE << 8) | 0
	dw Title_Music_PIN_NAME_ENTRY, (MUSIC_PIN_NAME_ENTRY << 8) | 0
	dw Title_Music_PIN_OPTIONS, (MUSIC_PIN_OPTIONS << 8) | 0
	dw Title_Music_PIN_POKEDEX, (MUSIC_PIN_POKEDEX << 8) | 0
	dw Title_Music_PIN_RED_FIELD, (MUSIC_PIN_RED_FIELD << 8) | 0
	dw Title_Music_PIN_SEEL_STAGE, (MUSIC_PIN_SEEL_STAGE << 8) | 0
	dw Title_Music_PIN_TITLE, (MUSIC_PIN_TITLE << 8) | 0
	dw Title_Music_PIN_WHACK_THE_DIGLETT, (MUSIC_PIN_WHACK_THE_DIGLETT << 8) | 0
	dw Title_Music_PIN_WHACK_THE_DUGTRIO, (MUSIC_PIN_WHACK_THE_DUGTRIO << 8) | 0
SoundTestTrackListEnd:

;category boundaries computed from the track lists above (4 bytes per entry)
SOUNDTEST_RB_END       EQU (SoundTestTrackList_Yellow - SoundTestTrackList) / 4
SOUNDTEST_YELLOW_END   EQU (SoundTestTrackList_Alpha - SoundTestTrackList) / 4
SOUNDTEST_ALPHA_END    EQU (SoundTestTrackList_GS - SoundTestTrackList) / 4
SOUNDTEST_GS_END       EQU (SoundTestTrackList_TCG - SoundTestTrackList) / 4
SOUNDTEST_TCG_END      EQU (SoundTestTrackList_TCG2 - SoundTestTrackList) / 4
SOUNDTEST_TCG2_END     EQU (SoundTestTrackList_Pinball - SoundTestTrackList) / 4
SOUNDTEST_PINBALL_END  EQU (SoundTestTrackListEnd - SoundTestTrackList) / 4

NUM_MUSIC_TRACKS EQU SOUNDTEST_PINBALL_END
ASSERT NUM_MUSIC_TRACKS <= $FF ; music ids must fit in one byte

; ends are cumulative boundaries, not per-category counts
ASSERT SOUNDTEST_RB_END < SOUNDTEST_YELLOW_END
ASSERT SOUNDTEST_YELLOW_END < SOUNDTEST_ALPHA_END
ASSERT SOUNDTEST_ALPHA_END < SOUNDTEST_GS_END
ASSERT SOUNDTEST_GS_END < SOUNDTEST_TCG_END
ASSERT SOUNDTEST_TCG_END < SOUNDTEST_TCG2_END
ASSERT SOUNDTEST_TCG2_END < SOUNDTEST_PINBALL_END

	db 0 ; category 0 start (read as SoundTestCategoryEnds - 1)
SoundTestCategoryEnds:
	db SOUNDTEST_RB_END, SOUNDTEST_YELLOW_END, SOUNDTEST_ALPHA_END
	db SOUNDTEST_GS_END, SOUNDTEST_TCG_END, SOUNDTEST_TCG2_END
	db SOUNDTEST_PINBALL_END
ASSERT @ - SoundTestCategoryEnds == NUM_SOUNDTEST_CATEGORIES ; keep in sync when adding a category


Title_Music_PalletTown: db "Pallet Town@"
Title_Music_Pokecenter: db "#mon Center@"
Title_Music_Gym: db "Gym@"
Title_Music_Cities1: db "City 1@"
Title_Music_Cities2: db "City 2@"
Title_Music_Celadon: db "Celadon City@"
Title_Music_Cinnabar: db "Cinnabar Island@"
Title_Music_Vermilion: db "Vermilion City@"
Title_Music_Lavender: db "Lavender Town@"
Title_Music_SSAnne: db "SS Anne@"
Title_Music_MeetProfOak: db "Prof. Oak@"
Title_Music_MeetRival: db "Rival@"
Title_Music_MuseumGuy: db "To The Museum@"
Title_Music_SafariZone: db "Safari Zone@"
Title_Music_PkmnHealed: db "#mon Healed@"
Title_Music_Routes1: db "Route Theme 1@"
Title_Music_Routes2: db "Route Theme 2@"
Title_Music_Routes3: db "Route Theme 3@"
Title_Music_Routes4: db "Route Theme 4@"
Title_Music_IndigoPlateau: db "Indigo Plateau@"
Title_Music_GymLeaderBattle: db "Leader Battle@"
Title_Music_TrainerBattle: db "Trainer Battle@"
Title_Music_WildBattle: db "Wild Battle@"
Title_Music_FinalBattle: db "Final Battle@"
Title_Music_DefeatedTrainer: db "Trainer Victory@"
Title_Music_DefeatedWildMon: db "Wild Victory@"
Title_Music_DefeatedGymLeader: db "Leader Victory@"
Title_Music_TitleScreen: db "Main Title@"
Title_Music_Credits: db "Credits@"
Title_Music_HallOfFame: db "Hall of Fame@"
Title_Music_OaksLab: db "Oak's Lab@"
Title_Music_JigglypuffSong: db "Jigglypuff's Song@"
Title_Music_BikeRiding: db "Bike Riding@"
Title_Music_Surfing: db "Surfing@"
Title_Music_GameCorner: db "Game Corner@"
Title_Music_IntroBattle: db "Title Intro@"
Title_Music_Dungeon1: db "Dungeon 1@"
Title_Music_Dungeon2: db "Dungeon 2@"
Title_Music_Dungeon3: db "Dungeon 3@"
Title_Music_CinnabarMansion: db "Cinnabar Mansion@"
Title_Music_PokemonTower: db "#mon Tower@"
Title_Music_SilphCo: db "Silph Co.@"
Title_Music_MeetEvilTrainer: db "Evil Trainer@"
Title_Music_MeetFemaleTrainer: db "Female Trainer@"
Title_Music_MeetMaleTrainer: db "Male Trainer@"
Title_Music_TradeSong: db "Trade Song@"
Title_Music_SurfingPikachu: db "Surfing Pikachu@"
Title_Music_MeetJessieJames: db "Meet Jessie James@"
Title_Music_GiovanniSong: db "Giovanni@"
Title_Music_YellowIntro: db "Yellow Intro@"
Title_Music_GBPrinter: db "GB Printer@"
Title_Music_BattleVictoryGuide: db "Victory Guide@"
Title_Music_DiglettsCave: db "Digletts Cave@"
Title_Music_RestPallet: db "Rest Pallet@"
Title_Music_Route3Early: db "Route 3 Early@"
Title_Music_TCG_PauseMenu: db "Pause Menu@"
Title_Music_GS_TITLE_SCREEN: db "Title Screen@"
Title_Music_GS_ROUTE1: db "Route 1@"
Title_Music_GS_ROUTE3: db "Route 3@"
Title_Music_GS_ROUTE12: db "Route 12@"
Title_Music_GS_MAGNET_TRAIN: db "Magnet Train@"
Title_Music_GS_KANTO_GYM_BATTLE: db "Kanto Gym@"
Title_Music_GS_KANTO_TRAINER_BATTLE: db "Kanto Trainer@"
Title_Music_GS_KANTO_WILD_BATTLE: db "Kanto Wild@"
Title_Music_GS_POKEMON_CENTER: db "#mon Center@"
Title_Music_GS_LOOK_HIKER: db "Look Hiker@"
Title_Music_GS_LOOK_LASS: db "Look Lass@"
Title_Music_GS_LOOK_OFFICER: db "Look Officer@"
Title_Music_GS_HEAL_POKEMON: db "Heal #mon@"
Title_Music_GS_LAVENDER_TOWN: db "Lavender@"
Title_Music_GS_ROUTE2: db "Route 2@"
Title_Music_GS_MT_MOON: db "Mt. Moon@"
Title_Music_GS_SHOW_ME_AROUND: db "Show Around@"
Title_Music_GS_GAME_CORNER: db "Game Corner@"
Title_Music_GS_BICYCLE: db "Bicycle@"
Title_Music_GS_HALL_OF_FAME: db "Hall of Fame@"
Title_Music_GS_VIRIDIAN_CITY: db "Viridian@"
Title_Music_GS_CELADON_CITY: db "Celadon@"
Title_Music_GS_TRAINER_VICTORY: db "Trainer Win@"
Title_Music_GS_WILD_POKEMON_VICTORY: db "Wild Win@"
Title_Music_GS_GYM_LEADER_VICTORY: db "Leader Win@"
Title_Music_GS_MT_MOON_SQUARE: db "Mt. Moon Sq.@"
Title_Music_GS_GYM: db "Gym@"
Title_Music_GS_PALLET_TOWN: db "Pallet Town@"
Title_Music_GS_PROF_OAKS_POKEMON_TALK: db "Oak's Talk@"
Title_Music_GS_PROF_OAK: db "Prof. Oak@"
Title_Music_GS_LOOK_RIVAL: db "Look Rival@"
Title_Music_GS_AFTER_THE_RIVAL_FIGHT: db "After Rival@"
Title_Music_GS_SURF: db "Surf@"
Title_Music_GS_EVOLUTION: db "Evolution@"
Title_Music_GS_NATIONAL_PARK: db "National Park@"
Title_Music_GS_CREDITS: db "Credits@"
Title_Music_GS_AZALEA_TOWN: db "Azalea Town@"
Title_Music_GS_CHERRYGROVE_CITY: db "Cherrygrove@"
Title_Music_GS_LOOK_KIMONO_GIRL: db "Kimono Girl@"
Title_Music_GS_UNION_CAVE: db "Union Cave@"
Title_Music_GS_JOHTO_WILD_BATTLE: db "Johto Wild@"
Title_Music_GS_JOHTO_TRAINER_BATTLE: db "Johto Trainer@"
Title_Music_GS_ROUTE30: db "Route 30@"
Title_Music_GS_ECRUTEAK_CITY: db "Ecruteak@"
Title_Music_GS_VIOLET_CITY: db "Violet City@"
Title_Music_GS_JOHTO_GYM_BATTLE: db "Johto Gym@"
Title_Music_GS_CHAMPION_BATTLE: db "Champion@"
Title_Music_GS_RIVAL_BATTLE: db "Rival Battle@"
Title_Music_GS_ROCKET_BATTLE: db "Rocket Battle@"
Title_Music_GS_ELMS_LAB: db "Elm's Lab@"
Title_Music_GS_DARK_CAVE: db "Dark Cave@"
Title_Music_GS_ROUTE29: db "Route 29@"
Title_Music_GS_ROUTE36: db "Route 36@"
Title_Music_GS_S_S_AQUA: db "S.S. Aqua@"
Title_Music_GS_LOOK_YOUNGSTER: db "Youngster@"
Title_Music_GS_LOOK_BEAUTY: db "Look Beauty@"
Title_Music_GS_LOOK_ROCKET: db "Look Rocket@"
Title_Music_GS_LOOK_POKEMANIAC: db "Pokemaniac@"
Title_Music_GS_LOOK_SAGE: db "Look Sage@"
Title_Music_GS_NEW_BARK_TOWN: db "New Bark Town@"
Title_Music_GS_GOLDENROD_CITY: db "Goldenrod@"
Title_Music_GS_VERMILION_CITY: db "Vermilion@"
Title_Music_GS_POKEMON_CHANNEL: db "#mon Channel@"
Title_Music_GS_POKE_FLUTE_CHANNEL: db "Pokeflute@"
Title_Music_GS_TIN_TOWER: db "Tin Tower@"
Title_Music_GS_SPROUT_TOWER: db "Sprout Tower@"
Title_Music_GS_BURNED_TOWER: db "Burned Tower@"
Title_Music_GS_LIGHTHOUSE: db "Lighthouse@"
Title_Music_GS_LAKE_OF_RAGE: db "Lake of Rage@"
Title_Music_GS_INDIGO_PLATEAU: db "Indigo Plat.@"
Title_Music_GS_ROUTE37: db "Route 37@"
Title_Music_GS_ROCKET_HIDEOUT: db "Hideout@"
Title_Music_GS_DRAGONS_DEN: db "Dragons Den@"
Title_Music_GS_JOHTO_WILD_BATTLE_NIGHT: db "Night Wild@"
Title_Music_GS_RUINS_OF_ALPH_RADIO: db "Ruins Radio@"
Title_Music_GS_SUCCESSFUL_CAPTURE: db "Capture@"
Title_Music_GS_ROUTE26: db "Route 26@"
Title_Music_GS_MOM: db "Mom@"
Title_Music_GS_VICTORY_ROAD: db "Victory Road@"
Title_Music_GS_POKEMON_LULLABY: db "Lullaby@"
Title_Music_GS_POKEMON_MARCH: db "March@"
Title_Music_GS_GOLD_SILVER_OPENING: db "Opening@"
Title_Music_GS_GOLD_SILVER_OPENING2: db "Opening 2@"
Title_Music_GS_MAIN_MENU: db "Main Menu@"
Title_Music_GS_RUINS_OF_ALPH_INTERIOR: db "Ruins Int.@"
Title_Music_GS_ROCKET_THEME: db "Rocket Theme@"
Title_Music_GS_DANCING_HALL: db "Dancing Hall@"
Title_Music_GS_CONTEST_RESULTS: db "Contest@"
Title_Music_GS_BUG_CATCHING_CONTEST: db "Bug Contest@"
Title_Music_GS_LAKE_OF_RAGE_ROCKET_RADIO: db "Rocket Radio@"
Title_Music_GS_PRINTER: db "Printer@"
Title_Music_GS_POST_CREDITS: db "Post Credits@"
Title_Music_GS_CLAIR: db "Clair@"
Title_Music_GS_MOBILE_ADAPTER_MENU: db "Mobile Menu@"
Title_Music_GS_MOBILE_ADAPTER: db "Mobile@"
Title_Music_GS_BUENAS_PASSWORD: db "Buenas@"
Title_Music_GS_LOOK_MYSTICAL_MAN: db "Mystical Man@"
Title_Music_GS_CRYSTAL_OPENING: db "Crystal Open@"
Title_Music_GS_BATTLE_TOWER_THEME: db "Battle Tower@"
Title_Music_GS_SUICUNE_BATTLE: db "Suicune@"
Title_Music_GS_BATTLE_TOWER_LOBBY: db "Tower Lobby@"
Title_Music_GS_MOBILE_CENTER: db "Mobile Center@"
Title_Music_TCG_BOOSTER_PACK: db "Booster Pack@"
Title_Music_TCG_CARD_POP: db "Card Pop@"
Title_Music_TCG_CHALLENGE_HALL: db "Challenge@"
Title_Music_TCG_CLUB1: db "Club 1@"
Title_Music_TCG_CLUB2: db "Club 2@"
Title_Music_TCG_CLUB3: db "Club 3@"
Title_Music_TCG_CREDITS: db "Credits@"
Title_Music_TCG_DECK_MACHINE: db "DeckMachine@"
Title_Music_TCG_DUEL_THEME1: db "Duel 1@"
Title_Music_TCG_DUEL_THEME2: db "Duel 2@"
Title_Music_TCG_DUEL_THEME3: db "Duel 3@"
Title_Music_TCG_HALL_OF_HONOR: db "Hall Honor@"
Title_Music_TCG_IMAKUNI: db "Imakuni@"
Title_Music_TCG_MATCH_DRAW: db "Match Draw@"
Title_Music_TCG_MATCH_LOSS: db "Match Loss@"
Title_Music_TCG_MATCH_START1: db "Match Start1@"
Title_Music_TCG_MATCH_START2: db "Match Start2@"
Title_Music_TCG_MATCH_START3: db "Match Start3@"
Title_Music_TCG_MATCH_VICTORY: db "Match Win@"
Title_Music_TCG_MEDAL: db "Medal@"
Title_Music_TCG_OVERWORLD: db "Overworld@"
Title_Music_TCG_PC_MAIN_MENU: db "PC Menu@"
Title_Music_TCG_POKEMON_DOME: db "#mon Dome@"
Title_Music_TCG_RONALD: db "Ronald@"
Title_Music_TCG_TITLE_SCREEN: db "Title Screen@"
Title_Music_TCG2_CREDITS: db "Credits@"
Title_Music_TCG2_DITTY1: db "Ditty 1@"
Title_Music_TCG2_DITTY2: db "Ditty 2@"
Title_Music_TCG2_DITTY3: db "Ditty 3@"
Title_Music_TCG2_DITTY4: db "Ditty 4@"
Title_Music_TCG2_DITTY5: db "Ditty 5@"
Title_Music_TCG2_DITTY6: db "Ditty 6@"
Title_Music_TCG2_FORT1: db "Fort 1@"
Title_Music_TCG2_FORT2: db "Fort 2@"
Title_Music_TCG2_FORT3: db "Fort 3@"
Title_Music_TCG2_FORT4: db "Fort 4@"
Title_Music_TCG2_GAME_CORNER: db "Game Corner@"
Title_Music_TCG2_GR_BLIMP: db "GR Blimp@"
Title_Music_TCG2_GR_CASTLE: db "GR Castle@"
Title_Music_TCG2_GR_CHALLENGE_CUP: db "GR Cup@"
Title_Music_TCG2_GR_DUEL_THEME1: db "GR Duel 1@"
Title_Music_TCG2_GR_DUEL_THEME2: db "GR Duel 2@"
Title_Music_TCG2_GR_DUEL_THEME3: db "GR Duel 3@"
Title_Music_TCG2_GR_OVERWORLD: db "GR World@"
Title_Music_TCG2_HERE_COMES_GR: db "Here GR@"
Title_Music_TCG2_IMAKUNI2: db "Imakuni@"
Title_Music_TCG2_ISHIHARA: db "Ishihara@"
Title_Music_TCG2_TITLE_SCREEN: db "Title@"
Title_Music_PIN_BLUE_FIELD: db "PB Blue Field@"
Title_Music_PIN_CATCH_EM_BLUE: db "PB CatchEm Blue@"
Title_Music_PIN_CATCH_EM_RED: db "PB CatchEm Red@"
Title_Music_PIN_END_CREDITS: db "PB End Credits@"
Title_Music_PIN_FIELD_SELECT: db "PB Field Select@"
Title_Music_PIN_GAME_OVER: db "PB Game Over@"
Title_Music_PIN_GASTLY_GRAVE: db "PB Gastly Grave@"
Title_Music_PIN_GENGAR_GRAVE: db "PB Gengar Grave@"
Title_Music_PIN_HAUNTER_GRAVE: db "PB Haunter Grave@"
Title_Music_PIN_HI_SCORE: db "PB HiScore@"
Title_Music_PIN_HURRY_UP_BLUE: db "PB HurryUp Blue@"
Title_Music_PIN_HURRY_UP_RED: db "PB HurryUp Red@"
Title_Music_PIN_MEOWTH_STAGE: db "PB Meowth Stage@"
Title_Music_PIN_MEWTWO_STAGE: db "PB Mewtwo Stage@"
Title_Music_PIN_NAME_ENTRY: db "PB Name Entry@"
Title_Music_PIN_OPTIONS: db "PB Options@"
Title_Music_PIN_POKEDEX: db "PB Pokedex@"
Title_Music_PIN_RED_FIELD: db "PB Red Field@"
Title_Music_PIN_SEEL_STAGE: db "PB Seel Stage@"
Title_Music_PIN_TITLE: db "PB Title@"
Title_Music_PIN_WHACK_THE_DIGLETT: db "PB Whack Diglett@"
Title_Music_PIN_WHACK_THE_DUGTRIO: db "PB Whack Dugtrio@"

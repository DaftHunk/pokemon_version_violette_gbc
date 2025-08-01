SetDebugNewGameParty: ; unreferenced except in _DEBUG
	ld de, DebugNewGameParty
.loop
	ld a, [de]
	cp -1
	ret z
	ld [wcf91], a
	inc de
	ld a, [de]
	ld [wCurEnemyLVL], a
	inc de
	call AddPartyMon
	jr .loop

DebugNewGameParty: ; unreferenced except in _DEBUG
	; Exeggutor is the only debug party member shared with Red, Green, and Japanese Blue.
	; "Tsunekazu Ishihara: Exeggutor is my favorite. That's because I was
	; always using this character while I was debugging the program."
	; From https://web.archive.org/web/20000607152840/http://pocket.ign.com/news/14973.html
	db MAGNETON, 100
	db EXEGGUTOR, 100
	db EEVEE, 100
	db MAROWRATH, 100
	db ZAPDOS, 100
	db MEW, 100
	; Test for trade
;	db BUTTERFREE, 56
;	db SPEAROW, 10
;	db RAICHU, 56
;	db NIDORAN_F, 56
;	db ABRA, 50
;	db NIDORINO, 80
;	db PIKACHU, 90
	; Test for tutor
;	db OMASTAR, 90
;	db AERODACTYL, 90
;	db SCYTHER, 90
;	db KABUTOPS, 90
;	db BLASTOISE, 90
;	db ELECTABUZZ, 90
;	db VENUSAUR, 90
;	db NINETALES, 90
;	db CHARIZARD, 90
	db -1 ; end

PrepareNewGameDebug: ; dummy except in _DEBUG
IF DEF(_DEBUG)
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a

	; Fly anywhere.
	dec a ; $ff (all bits)
	ld [wTownVisitedFlag], a
	ld [wTownVisitedFlag + 1], a

	; Get all badges except Earth Badge.
	ld a, $ff ^ (1 << 7)
	ld [wObtainedBadges], a

	call SetDebugNewGameParty

	; MEW gets four HM moves.
	ld hl, wPartyMon6Moves
	ld a, PSYCHIC_M
	ld [hli], a
	ld a, CUT
	ld [hli], a
	ld a, SURF
	ld [hli], a
	ld a, STRENGTH
	ld [hl], a
	ld hl, wPartyMon1PP
	ld a, 15
	ld [hli], a
	ld a, 30
	ld [hli], a
	ld a, 15
	ld [hli], a
	ld [hl], a

	; MAGNTETON gets Thunderbolt.
	ld hl, wPartyMon1Moves
	ld a, THUNDERBOLT
	ld [hl], a
	ld hl, wPartyMon1PP
	ld a, 15
	ld [hl], a

	; ONIX new attack test
	ld hl, wPartyMon4Moves
	ld a, SLUDGE_BOMB
	ld [hli], a
	ld a, METAL_CLAW
	ld [hli], a
	ld a, CRUNCH
	ld [hli], a
	ld a, IRON_TAIL
	ld [hl], a

	; EEVEE gets PURSUIT.
	ld hl, wPartyMon3Moves
	ld a, PURSUIT
	ld [hli], a
	ld a, FLASH_CANNON
	ld [hli], a
	ld a, SHADOW_BALL
	ld [hli], a
	ld a, DARK_PULSE
	ld [hl], a
	ld hl, wPartyMon5PP
	ld a, 30
	ld [hl], a

	; ZAPDOS gets Fly.
	ld hl, wPartyMon5Moves
	ld a, FLY
	ld [hli], a
	ld a, DRAGON_RUSH
	ld [hli], a
	ld a, BUG_BUZZ
	ld [hli], a
	ld a, X_SCISSOR
	ld [hl], a
	ld hl, wPartyMon5PP
	ld a, 15
	ld [hl], a

	; Get some debug items.
	ld hl, wNumBagItems
	ld de, DebugItemsList
.items_loop
	ld a, [de]
	cp -1
	jr z, .items_end
	ld [wcf91], a
	inc de
	ld a, [de]
	inc de
	ld [wItemQuantity], a
	call AddItemToInventory
	jr .items_loop
.items_end

	; Complete the Pokédex and Movedex
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned - 1
	call DebugSetPokedexEntries
	ld [hl], %01111111
;	ld [hl], %00001111
	ld hl, wPokedexSeen
	ld b, wPokedexSeenEnd - wPokedexSeen - 1
	call DebugSetPokedexEntries
	ld [hl], %01111111
	ld hl, wMovedexSeen
	ld b, wMovedexSeenEnd - wMovedexSeen
	call DebugSetPokedexEntries

	; Set tutorial events
	SetEvent EVENT_GOT_POKEDEX
	SetEvent EVENT_GOT_TOWN_MAP
	SetEvent EVENT_GENDER_CAUGHT_INDICATOR
;	SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS

;	SetEvent EVENT_NEW_GAME_PLUS
;	SetEvent EVENT_ENABLE_WILD_RANDOM_TIERS
;	SetEvent EVENT_ENABLE_WILD_RANDOM
;	SetEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION

	; Uncomment tp start in post game
;	SetEvent EVENT_ELITE_4_BEATEN
;	SetEvent EVENT_TRAINER_LVL_SCALING
;	SetEvent EVENT_ELITE_4_REMATCH_BEATEN
;	SetEvent EVENT_SS_ANNE_TOURNAMENT_BEATEN
;	SetEvent EVENT_GOT_MIST_STONE

;	SetEvent EVENT_BEAT_BROCK
;	SetEvent EVENT_BEAT_BROCK_REMATCH
;	SetEvent EVENT_BEAT_MISTY
;	SetEvent EVENT_BEAT_MISTY_REMATCH
;	SetEvent EVENT_BEAT_LT_SURGE
;	SetEvent EVENT_BEAT_LT_SURGE_REMATCH
;	SetEvent EVENT_BEAT_SABRINA
;	SetEvent EVENT_BEAT_SABRINA_REMATCH
;	SetEvent EVENT_BEAT_ERIKA
;	SetEvent EVENT_BEAT_ERIKA_REMATCH
;	SetEvent EVENT_BEAT_KOGA
;	SetEvent EVENT_BEAT_KOGA_REMATCH
;	SetEvent EVENT_BEAT_BLAINE
;	SetEvent EVENT_BEAT_BLAINE_REMATCH
;	SetEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
;	SetEvent EVENT_BEAT_GIOVANNI_REMATCH

	; Set special flags
;	ld a, [wBeatSpecial4Flags]
;	set 0, a
;	ld [wBeatSpecial4Flags], a
;	ld a, [wBeatSpecial4Flags]
;	set 1, a
;	ld [wBeatSpecial4Flags], a
;	ld a, [wBeatSpecial4Flags]
;	set 3, a
;	ld [wBeatSpecial4Flags], a
;	ld a, [wBeatSpecial4Flags]
;	set 4, a
;	ld [wBeatSpecial4Flags], a

	; Set Gym Rematch flags
;	ld a, [wBeatGymLeadersRematch]
;	set 0, a
;	ld [wBeatGymLeadersRematch], a
;	ld a, [wBeatGymLeadersRematch]
;	set 1, a
;	ld [wBeatGymLeadersRematch], a
;	ld a, [wBeatGymLeadersRematch]
;	set 2, a
;	ld [wBeatGymLeadersRematch], a
;	ld a, [wBeatGymLeadersRematch]
;	set 3, a
;	ld [wBeatGymLeadersRematch], a
;	ld a, [wBeatGymLeadersRematch]
;	set 4, a
;	ld [wBeatGymLeadersRematch], a
;	ld [wBeatGymLeadersRematch], a
;	ld a, [wBeatGymLeadersRematch]
;	set 5, a
;	ld [wBeatGymLeadersRematch], a
;	ld a, [wBeatGymLeadersRematch]
;	set 6, a
	
	; Force Shiny apparition
;	ld [wFontLoaded], a
;	ld a, [wFontLoaded]
;	set 7, a

	; Rival chose Squirtle,
	; Player chose Charmander.
	ld hl, wRivalStarter
	ld a, STARTER2
	ld [hli], a
	inc hl ; hl = wPlayerStarter
	ld a, STARTER1
	ld [hl], a

	ret

DebugSetPokedexEntries:
	ld a, %11111111
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

DebugItemsList:
	db MAX_REVIVE, 99
	db MAX_ELIXER, 99
	db BICYCLE, 1
	db FULL_RESTORE, 99
	db FULL_HEAL, 99
	db ESCAPE_ROPE, 99
	db RARE_CANDY, 99
	db MASTER_BALL, 99
	db FIRE_STONE, 1
	db LEAF_STONE, 1
	db WATER_STONE, 1
	db THUNDER_STONE, 1
	db MOON_STONE, 1
	db MIST_STONE, 1
	db METAL_COAT, 1
	db SECRET_KEY, 1
	db CARD_KEY, 1
	db S_S_TICKET, 1
	db LIFT_KEY, 1
	db SILPH_SCOPE, 1
	db POKE_DOLL, 1
	db POKE_FLUTE, 1
	db -1 ; end

DebugUnusedList:
	db -1 ; end
ELSE
	ret
ENDC

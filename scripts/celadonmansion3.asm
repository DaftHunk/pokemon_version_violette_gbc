CeladonMansion3Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion3TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText
	dw SurfboardText
	dw SurfboardNoRoomText

ProgrammerText:
	TX_FAR _ProgrammerText
	db "@"

GraphicArtistText:
	TX_FAR _GraphicArtistText
	db "@"

WriterText:
	TX_FAR _WriterText
	db "@"

DirectorText:
	TX_ASM

	call .checkCertificate

	CheckEvent EVENT_MASTER_POKEMON
	jr nz, .giveMasterCertificate

	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .giveChampionCertificate

	ld hl, .gameDesigner
	jr .done
.giveChampionCertificate
	ld hl, .championText
	jr .done
.giveMasterCertificate
	ld hl, .masterText
.done
	call PrintText
	jp TextScriptEnd

.gameDesigner
	TX_FAR _GameDesignerText
	db "@"	

.championText
	TX_FAR _ChampionText
	TX_BLINK	
	TX_ASM
	callab DisplayDiploma
	
	CheckEvent EVENT_GOT_DEX_DIPLOMA
	jr nz, .scriptEnd
	
	;dafthunk : Added award #53
	lb bc, SURFBOARD, 1
	call GiveItem
	jr nc, .bagFull

	SetEvent EVENT_GOT_DEX_DIPLOMA
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.scriptEnd
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.masterText
	TX_FAR _MasterText
	TX_BLINK	
	TX_ASM
	callab DisplayDiploma

	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.bagFull
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.checkCertificate
	ld hl, wBeatGymLeadersRematch
	ld b, $1
	call CountSetBits
	ld a, [wNumSetBits]
	cp 8 ;Check bit wBeatGymLeadersRematch = %11111111
	call nc, .checkGymLeaders

	ld hl, wBeatSpecial4Flags
	ld b, $1
	call CountSetBits
	ld a, [wNumSetBits]
	cp 4 ;Check bit wBeatSpecial4Flags = %00001111
	call nc, .checkSpecial4

	ld hl, wMovedexSeen
	ld b, wMovedexSeenEnd - wMovedexSeen
	call CountSetBits
	ld a, [wNumSetBits]
	cp NUM_ATTACKS
	call nc, .checkMovedex

	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp NUM_POKEMON - 1
	call nc, .checkPokedex

	CheckEvent EVENT_GYM_LEADERS_REMATCH_BEATEN
	ret z
	CheckEvent EVENT_ELITE_4_REMATCH_BEATEN
	ret z
	CheckEvent EVENT_SS_ANNE_TOURNAMENT_BEATEN
	ret z
	CheckEvent EVENT_GOT_MIST_STONE
	ret z
	CheckEvent EVENT_SPECIAL_4_BEATEN
	ret z
	CheckEvent EVENT_MOVEDEX_COMPLETED
	ret z
	CheckEvent EVENT_POKEDEX_COMPLETED
	ret z
	SetEvent EVENT_MASTER_POKEMON
	ret
.checkGymLeaders
	SetEvent EVENT_GYM_LEADERS_REMATCH_BEATEN
	ret
.checkSpecial4
	SetEvent EVENT_SPECIAL_4_BEATEN
	ret
.checkMovedex
	SetEvent EVENT_MOVEDEX_COMPLETED
	ret
.checkPokedex
	SetEvent EVENT_POKEDEX_COMPLETED
	ret

SurfboardText:
	TX_FAR _ReceivedSurfboard
	TX_SFX_ITEM_1
	TX_FAR _SurfboardText
	db "@"

SurfboardNoRoomText:
	TX_FAR _SurfboardNoRoomText
	db "@"

GameFreakPCText1:
	TX_FAR _CeladonMansion3Text5
	db "@"

GameFreakPCText2:
	TX_FAR _CeladonMansion3Text6
	db "@"

GameFreakPCText3:
	TX_FAR _CeladonMansion3Text7
	db "@"

GameFreakSignText:
	TX_FAR _CeladonMansion3Text8
	db "@"

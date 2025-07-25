SetDefaultNames:
	ld a, [wLetterPrintingDelayFlags]
	push af
	ld a, [wOptions]
	push af
	; Retrieve BIT_DEBUG_MODE set in DebugMenu for StartNewGameDebug.
	; BUG: StartNewGame carries over BIT_ALWAYS_ON_BIKE from previous save files,
	; which causes CheckForceBikeOrSurf to not return.
	; To fix this in debug builds, reset BIT_ALWAYS_ON_BIKE here or in StartNewGame.
	; In non-debug builds, the instructions can be removed.
	ld a, [wd732]
	push af
	ld a, [wGameplayOptions]	;joenote - preserve extra options
	push af
	ld hl, wPlayerName
	ld bc, wBoxDataEnd - wPlayerName
	xor a
	call FillMemory
	ld hl, wSpriteStateData1
	ld bc, $200
	xor a
	call FillMemory
	pop af
	ld [wGameplayOptions], a	;joenote - restore extra options
	pop af
	ld [wd732], a
	pop af
	ld [wOptions], a
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld a, [wOptionsInitialized]
	and a
	call z, InitOptions
	; These debug names are used for StartNewGameDebug.
	; TestBattle uses the debug names from DebugMenu.
	; A variant of this process is performed in PrepareTitleScreen.
	ld hl, DebugNewGamePlayerName
	ld de, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld hl, DebugNewGameRivalName
	ld de, wRivalName
	ld bc, NAME_LENGTH
	jp CopyData

OakSpeech:
	call ClearScreen
	call LoadTextBoxTilePatterns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do a new game plus when choosing New Game from main menu
;must have an intact save file detected
;must have beaten the elite 4
	ld a, [wGameplayOptions]
	bit 3, a
	jr z, .normalnewgame

	call DoNewGamePlus
	predef InitPlayerData2
	ld a, SFX_GET_ITEM_2
	call PlaySound
	call DisplayNewGamePlusInfo

	; Reset NG+ flag
	ld a, [wGameplayOptions]
	set 3, a
	ld [wGameplayOptions], a

	jr .newgamedone
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.normalnewgame
	call SetDefaultNames
	predef InitPlayerData2
.newgamedone
	call RunDefaultPaletteCommand	;gbcnote - reinitialize the default palette in case the pointers got cleared
;joenote - initialize hack version byte as well as...
	ld a, HACK_VERSION
	ld [wRomHackVersion], a
	predef SingleCPUSpeed	;...deactivate 2x speed das it may cause visual bugs during Oak's speech
	
;joenote - give option to play as a female trainer here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.askBoyGirl
	ld hl, AskIfGirlText
	call PrintText
	call BoyGirlChoice
	ld a, [hJoyHeld]
	bit BIT_B_BUTTON, A
	jr nz, .askBoyGirl
	ld a, [wCurrentMenuItem]
	ld b, a
	ld a, [wGameplayOptions]
	res 0, a
	or b
	ld [wGameplayOptions], a
	call ClearScreen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $FF
	call PlaySound ; stop music
	ld a, BANK(Music_Routes2)
	ld c, a
	ld a, MUSIC_ROUTES2
	call PlayMusic
	ld hl, wNumBoxItems
	ld a, POTION
	ld [wcf91], a
	ld a, 1
	ld [wItemQuantity], a
	call AddItemToInventory  ; give one potion
	
	SetEvent EVENT_AT_LEAST_ONE_CATCHED	;joenote - set a flag to indicate that a pokemon hasn't been caught yet
	SetEvent EVENT_POKEBALL_ACCESS	;joenote - nuzlocke: set a flag to indicate there is no access to pokeballs yet

	ld a, [wDefaultMap]
	ld [wDestinationMap], a
	call SpecialWarpIn
	xor a
	ld [hTilesetType], a
	ld a, [wd732]
	bit 1, a ; possibly a debug mode bit
	jp nz, .skipChoosingNames
	ld de, ProfOakPic
	lb bc, Bank(ProfOakPic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, OakSpeechText1
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
	ld a, NIDORINO
	ld [wd0b5], a
	ld [wcf91], a
	call GetMonHeader
	coord hl, 6, 4
	call LoadFlippedFrontSpriteByMonIndex
	;call MovePicLeft
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;gbcnote - Nidorino needs its pal
	ld a, %11100100
	ld [rBGP], a
	call UpdateGBCPal_BGP
	
	push af
	push bc
	push hl
	push de
	ld d, CONVERT_BGP
	ld e, 0
	callba TransferMonPal 
	pop de
	pop hl
	pop bc
	pop af
	
	call MovePicLeft_NoPalUpdate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, OakSpeechText2
	call PrintText
	call GBFadeOutToWhite
	call ClearScreen
;joenote - support female sprite
	ld de, RedPicFFront
	lb bc, BANK(RedPicFFront), $00
	ld a, [wGameplayOptions]
	bit 0, a	;check if girl
	jr nz, .donefemale_front
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
.donefemale_front	
	call IntroDisplayPicCenteredOrUpperRight
	call MovePicLeft
	ld hl, IntroducePlayerText
	call PrintText
	call ChoosePlayerName
	call GBFadeOutToWhite
	call ClearScreen
	ld de, Rival1Pic
	lb bc, Bank(Rival1Pic), $00
	call IntroDisplayPicCenteredOrUpperRight
	call FadeInIntroPic
	ld hl, IntroduceRivalText
	call PrintText
	call ChooseRivalName
.skipChoosingNames
	call GBFadeOutToWhite
	call ClearScreen
;joenote - support female sprite
	ld de, RedPicFFront
	lb bc, BANK(RedPicFFront), $00
	ld a, [wGameplayOptions]
	bit 0, a	;check if girl
	jr nz, .donefemale_front2
	ld de, RedPicFront
	lb bc, BANK(RedPicFront), $00
.donefemale_front2	
	call IntroDisplayPicCenteredOrUpperRight
	call GBFadeInFromWhite
	ld a, [wd72d]
	and a
	jr nz, .next
	ld hl, OakSpeechText3
	call PrintText
.next
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, SFX_SHRINK
	call PlaySound
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld c, 4
	call DelayFrames
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;joenote - support female trainer
	ld de, RedFSprite
	lb bc, BANK(RedFSprite), $0C
	ld a, [wGameplayOptions]
	bit 0, a	;check if girl
	jr nz, .sprite_next
	ld de, RedSprite
	lb bc, BANK(RedSprite), $0C
.sprite_next
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, vSprites
	call CopyVideoData
	ld de, ShrinkPic1
	lb bc, BANK(ShrinkPic1), $00
	call IntroDisplayPicCenteredOrUpperRight
	ld c, 4
	call DelayFrames
	ld de, ShrinkPic2
	lb bc, BANK(ShrinkPic2), $00
	call IntroDisplayPicCenteredOrUpperRight
	call ResetPlayerSpriteData
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(Music_PalletTown)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, 10
	ld [wAudioFadeOutControl], a
	ld a, $FF
	ld [wNewSoundID], a
	call PlaySound ; stop music
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	ld c, 20
	call DelayFrames
	coord hl, 6, 5
	ld b, 7
	ld c, 7
	call ClearScreenArea
	call LoadTextBoxTilePatterns
	ld a, 1
	ld [wUpdateSpritesEnabled], a
	ld c, 50
	call DelayFrames
	call GBFadeOutToWhite
	jp ClearScreen
OakSpeechText1:
	TX_FAR _OakSpeechText1
	db "@"
OakSpeechText2:
	TX_FAR _OakSpeechText2A
	TX_CRY_NIDORINO
	TX_FAR _OakSpeechText2B
	db "@"
IntroducePlayerText:
	TX_FAR _IntroducePlayerText
	db "@"
IntroduceRivalText:
	TX_FAR _IntroduceRivalText
	db "@"
OakSpeechText3:
	TX_FAR _OakSpeechText3
	db "@"

FadeInIntroPic:
	ld hl, IntroFadePalettes
	ld b, 6
.next
	ld a, [hli]
	ld [rBGP], a
	call UpdateGBCPal_BGP
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .next
	ret

IntroFadePalettes:
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100

MovePicLeft:
	ld a, %11100100
	ld [rBGP], a
	call UpdateGBCPal_BGP
MovePicLeft_NoPalUpdate: ;gbcnote - need the option to skip updating if needed
	ld a, 119
	ld [rWX], a
	call DelayFrame
.next
	call DelayFrame
	ld a, [rWX]
	sub 8
	cp $FF
	ret z
	ld [rWX], a
	jr .next

DisplayPicCenteredOrUpperRight:
	call GetPredefRegisters
IntroDisplayPicCenteredOrUpperRight:
; b = bank
; de = address of compressed pic
; c: 0 = centred, non-zero = upper-right
	push bc
	ld a, b
	call UncompressSpriteFromDE
	ld hl, sSpriteBuffer1
	ld de, sSpriteBuffer0
	ld bc, $310
	call CopyData
	ld de, vFrontPic
	call InterlaceMergeSpriteBuffers
	pop bc
	ld a, c
	and a
	coord hl, 15, 1
	jr nz, .next
	coord hl, 6, 4
.next
	xor a
	ld [hStartTileID], a
	predef_jump CopyUncompressedPicToTilemap


DoNewGamePlus: ;joenote - selective wram clearing for new game plus

	;skip clearing pokedex data at wMainDataStart
	ld hl, wPlayerName
	ld bc, wMainDataStart - wPlayerName
	xor a
	call FillMemory
	; 2427 keep wPokedexOwned, wPokedexSeen

	;skip clearing #of HoF teams
	ld hl, wNumBagItems
	ld bc, wNumHoFTeams - wNumBagItems
	xor a
	call FillMemory
	; 2438 keep wNumHoFTeams

	;skip Movedex
	ld hl, wUnusedD5A3
	ld bc, wMovedexSeen - wUnusedD5A3
	xor a
	call FillMemory
	; 2786 keep wMovedexSeen

	;skip Options
	ld hl, wTownVisitedFlag
	ld bc, wGameplayOptions - wTownVisitedFlag
	xor a
	call FillMemory
	; 3186 keep wGameplayOptions

	;skip clearing the play clock
	ld hl, wUnusedD722
	ld bc, wPlayTimeHours - wUnusedD722
	xor a
	call FillMemory
	; 3412 keep wPlayTimeHours, wPlayTimeMaxed, wPlayTimeMinutes, wPlayTimeSeconds, wPlayTimeFrames
	
	;end skip
	ld hl, wSafariZoneGameOver
	ld bc, wdeed - wSafariZoneGameOver
	xor a
	call FillMemory
	; 3453 end
	
	ret

AskIfGirlText::	;joenote - text to ask if female trainer
	TX_FAR _AskIfGirlText
	db "@"
	
BoyGirlChoice::	;joenote - added this
	call SaveScreenTilesToBuffer1
	ld a, BOY_GIRL_MENU
	ld [wTwoOptionMenuID], a
	coord hl, 11, 7
	ld bc, $80c ;dafthunk : moved cursor to the left 
	jp DisplayYesNoChoice

DebugNewGamePlayerName:
	db "Nintend@"

DebugNewGameRivalName:
	db "Sony@"

DisplayNewGamePlusInfo:
	xor a
	ld [wUpdateSpritesEnabled], a
	ld hl, wd730
	set 6, [hl]
	call DisableLCD
	ld hl, CircleTile
	ld de, vChars2 + $700
	ld bc, $0010
	ld a, BANK(CircleTile)
	call FarCopyData2
	coord hl, 0, 0
	lb bc, 16, 18
	predef Diploma_TextBoxBorder
	
	ld hl, NewGamePlusTextPointersAndCoords
	ld c, $4

.asm_56715
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, [hl]
	ld l, a
	call PlaceString
	pop hl
	inc hl
	pop bc
	dec c
	jr nz, .asm_56715

	call EnableLCD
	callba LoadTrainerInfoTextBoxTiles
	call WaitForTextScrollButtonPress
	ld hl, wd72e
	res 6, [hl]
	call ClearScreen
	call RunDefaultPaletteCommand
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	ld hl, wd730
	set 6, [hl]
	ret

NewGamePlusTextPointersAndCoords:
	dw NewGamePlusTitleText
	dwCoord 1, 1
	dw NewGamePlusDescription
	dwCoord 1, 4
	dw NewGamePlusEmptyText
	dwCoord 3, 5
	dw NewGamePlusInfo
	dwCoord 2, 6

NewGamePlusTitleText:
	db $70,"Nouvelle partie+",$70,"@"

NewGamePlusDescription:
	db "Sera gardé:@"

NewGamePlusEmptyText:
	db "@"

NewGamePlusInfo:
	db   "<BALL> Pokédex vu"
	next "<BALL> Pokédex pris"
	next "<BALL> Capadex"
	next "<BALL> Temps jeu"
	next "<BALL> Célébrités@"

DrawHP:
; Draws the HP bar in the stats screen
	call GetPredefRegisters
	ld a, $1
	jr DrawHP_

DrawHP2:
; Draws the HP bar in the party screen
	call GetPredefRegisters
	ld a, $2

DrawHP_:	
	ld [wHPBarType], a
	push hl
	ld a, [wLoadedMonHP]
	ld b, a
	ld a, [wLoadedMonHP + 1]
	ld c, a
	or b
	jr nz, .nonzeroHP
	xor a
	ld c, a
	ld e, a
	ld a, $6
	ld d, a
	jp .drawHPBarAndPrintFraction
.nonzeroHP
	ld a, [wLoadedMonMaxHP]
	ld d, a
	ld a, [wLoadedMonMaxHP + 1]
	ld e, a
	predef HPBarLength
	ld a, $6
	ld d, a
	ld c, a
.drawHPBarAndPrintFraction
	pop hl
	push de
	push hl
	push hl
	call DrawHPBar
	pop hl
	ld a, [hFlags_0xFFF6]
	bit 0, a
	jr z, .printFractionBelowBar
	ld bc, $9 ; right of bar
	jr .printFraction
.printFractionBelowBar
	ld bc, SCREEN_WIDTH + 1 ; below bar
.printFraction
	add hl, bc
	ld de, wLoadedMonHP
	lb bc, 2, 3
	call PrintNumber
	ld a, "/"
	ld [hli], a
	ld de, wLoadedMonMaxHP
	lb bc, 2, 3
	call PrintNumber
	pop hl
	pop de
	ret


; Predef 0x37
StatusScreen:
	call LoadMonData
	ld a, [wMonDataLocation]
	cp BOX_DATA
	jr c, .DontRecalculate
; mon is in a box or daycare
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
	ld [wCurEnemyLVL], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats ; Recalculate stats
.DontRecalculate
	ld hl, wd72c
	set 1, [hl]
	ld a, $33
	ld [rNR50], a ; Reduce the volume
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	call UpdateSprites
	call LoadHpBarAndStatusTilePatterns
	ld de, BattleHudTiles1  ; source
	ld hl, vChars2 + $6d0 ; dest
	lb bc, BANK(BattleHudTiles1), $03
	call CopyVideoDataDouble ; ·│ :L and halfarrow line end
	ld de, BattleHudTiles2
	ld hl, vChars2 + $780
	lb bc, BANK(BattleHudTiles2), $01
	call CopyVideoDataDouble ; │
	ld de, BattleHudTiles3
	ld hl, vChars2 + $760
	lb bc, BANK(BattleHudTiles3), $02
	call CopyVideoDataDouble ; ─┘
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	coord hl, 19, 1
	lb bc, 6, 10
	call DrawLineBox ; Draws the box around name, HP and status
	ld de, -6
	add hl, de
	ld [hl], "⠄" ; . after No ("." is a different one)
	dec hl
	ld [hl], "№"
	coord hl, 19, 9
	lb bc, 8, 6
	call DrawLineBox ; Draws the box around types, ID No. and OT
	coord hl, 10, 9
	ld de, Type1Text
	call PlaceString ; "TYPE1/"
	coord hl, 11, 3
	predef DrawHP
	
	;parse dv stats here so they can be grabbed later
	push de
	ld bc, SCREEN_WIDTH + 1
	add hl, bc
	call DVParse

	ld a, [wStatsToDisplay]
	bit 0, a
	ld a, [wGameplayOptions]
	bit 6, a
	jr z, .noblank
	push hl
	ld a, " "
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
.noblank
	ld de, wLoadedMonHPExp
	lb bc, 2, 5
	pop de
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - print gender symbol here
	CheckEvent EVENT_GENDER_CAUGHT_INDICATOR
	jr z, .nosymbol
	push de
	ld a, [wLoadedMonSpecies]
	ld d, a
	ld a, [wUnusedD722]
	ld e, a
	callba DetermineMonGender
	ld a, d
	pop de
	and a
	jr z, .nosymbol
	coord hl, 9, 3
	ld [hl], a
.nosymbol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, wStatusScreenHPBarColor
	call GetHealthBarColor
	ld b, SET_PAL_STATUS_SCREEN
	call RunPaletteCommand
	coord hl, 16, 6
	ld de, wLoadedMonStatus

	ld a, [wStatsToDisplay]
	bit 2, a
	jr nz, .printEV

	bit 1, a
	jr nz, .printIV

	call PrintStatusCondition
	jr nz, .StatusWritten
	coord hl, 16, 6

	; else regular
	ld de, OKText
	call PlaceString ; "OK"
	jr .StatusWritten
.printEV
	ld de, EVText
	call PlaceString ; "EV"
	jr .StatusWritten
.printIV
	ld de, IVText
	call PlaceString ; "IV"
	; fallthrough
.StatusWritten
	coord hl, 9, 6
	ld de, StatusText
	call PlaceString ; "STATUS/"
	coord hl, 14, 2
	call PrintLevel ; Pokémon level
	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	ld [wd0b5], a
	predef IndexToPokedex
	coord hl, 3, 7
	ld de, wPokedexNum
	lb bc, LEADING_ZEROES | 1, 3
	call PrintNumber ; Pokémon no.
	coord hl, 11, 10
	
	;joenote - get mon types directly from party data for status screen
	ld a, [wd0b5]
	push af
	xor a
	ld [wd0b5], a
	predef PrintMonType
	pop af
	ld [wd0b5], a

	ld hl, NamePointers2
	call .GetStringPointer
	ld d, h
	ld e, l
	coord hl, 9, 1
	call PlaceString ; Pokémon name
	ld hl, OTPointers
	call .GetStringPointer
	ld d, h
	ld e, l
	coord hl, 12, 16
	call PlaceString ; OT
	coord hl, 12, 14
	ld de, wLoadedMonOTID
	lb bc, LEADING_ZEROES | 2, 5
	call PrintNumber ; ID Number
	ld d, $0
	call PrintStatsBox
	call Delay3
	call GBPalNormal
	coord hl, 1, 0
	call LoadFlippedFrontSpriteByMonIndex ; draw Pokémon picture
	
	ld a, [wStatsToDisplay]
	bit 0, a
	jr z, .skipCry

	ld a, [wcf91]
	call PlayCry ; play Pokémon cry
.skipCry
	ld a, [wcf91]
	pop af
	ret

.GetStringPointer
	ld a, [wMonDataLocation]
	add a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMonDataLocation]
	cp DAYCARE_DATA
	ret z
	ld a, [wWhichPokemon]
	jp SkipFixedLengthTextEntries

OTPointers:
	dw wPartyMonOT
	dw wEnemyMonOT
	dw wBoxMonOT
	dw wDayCareMonOT

NamePointers2:
	dw wPartyMonNicks
	dw wEnemyMonNicks
	dw wBoxMonNicks
	dw wDayCareMonName

Type1Text:
	db "Type1/", $4e

Type2Text:
	db "Type2/", $4e

IDNoText:
	db "№", $73, "/", $4e

OTText:
	db   "Do/"
	next "@"

StatusText:
	db "Statut/@"

OKText:
	db "Ok@"

IVText:
	db "IV@"

EVText:
	db "EV@"

; Draws a line starting from hl high b and wide c
DrawLineBox:
	ld de, SCREEN_WIDTH ; New line
.PrintVerticalLine
	ld [hl], $78 ; │
	add hl, de
	dec b
	jr nz, .PrintVerticalLine
	ld [hl], $77 ; ┘
	dec hl
.PrintHorizLine
	ld [hl], $76 ; ─
	dec hl
	dec c
	jr nz, .PrintHorizLine
	ld [hl], $6f ; ← (halfarrow ending)
	ret

PrintStatsBox:
	ld a, d
	and a ; a is 0 from the status screen
	
	push af	;joenote - going to use this later
	
	jr nz, .DifferentBox
	coord hl, 0, 8
	ld b, 8
	ld c, 8
	call TextBoxBorder ; Draws the box
	coord hl, 1, 9 ; Start printing stats from here
	ld bc, $0019 ; Number offset
	jr .PrintStats
.DifferentBox
	coord hl, 9, 2
	ld b, 8
	ld c, 9
	call TextBoxBorder
	coord hl, 11, 3
	ld bc, $0018
.PrintStats
	push bc
	push hl
	ld de, StatsText
	call PlaceString
	pop hl
	pop bc
	add hl, bc
;joenote - print stat exp if select is held and on the status screen
	pop af
	jp nz, .doregular

	ld a, [wStatsToDisplay]
	bit BIT_SELECT, a

	jp z, .checkstart
	dec l	;shift alignment 2 tiles to the left
	dec l

	; ATK : load data into de
	ld de, wLoadedMonAttackExp
	ld a, [wLoadedMonAttackExp]
	ld d, a
	ld a, [wLoadedMonAttackExp + 1]
	ld e, a
	; calculate square root
	call GetSquareRoot
	srl b
	srl b ; /4
	; load value (big endian) into pointer, note that this may be a bad idea to use 
	xor a
	ld [wLoadedMonAttackExp], a
	ld a, b
	ld [wLoadedMonAttackExp + 1], a
	; restore b to value from lb bc, 2, 5
	ld de, wLoadedMonAttackExp
	coord hl, 4, 10
	lb bc, 2, 5
	call PrintStat

	; DEF : load data into de
	ld a, [wLoadedMonDefenseExp]
	ld d, a
	ld a, [wLoadedMonDefenseExp + 1]
	ld e, a
	; calculate square root
	call GetSquareRoot
	srl b
	srl b ; /4
	; load value (big endian) into pointer, note that this may be a bad idea to use 
	xor a
	ld [wLoadedMonDefenseExp], a
	ld a, b
	ld [wLoadedMonDefenseExp + 1], a
	; restore b to value from lb bc, 2, 5
	ld de, wLoadedMonDefenseExp
	coord hl, 4, 12
	lb bc, 2, 5
	call PrintStat

	; SPD : load data into de
	ld a, [wLoadedMonSpeedExp]
	ld d, a
	ld a, [wLoadedMonSpeedExp + 1]
	ld e, a
	; calculate square root
	call GetSquareRoot
	srl b
	srl b ; /4
	; load value (big endian) into pointer, note that this may be a bad idea to use 
	xor a
	ld [wLoadedMonSpeedExp], a
	ld a, b
	ld [wLoadedMonSpeedExp + 1], a
	; restore b to value from lb bc, 2, 5
	ld de, wLoadedMonSpeedExp
	coord hl, 4, 14
	lb bc, 2, 5
	call PrintStat

	; SPE : load data into de
	ld a, [wLoadedMonSpecialExp]
	ld d, a
	ld a, [wLoadedMonSpecialExp + 1]
	ld e, a
	; calculate square root
	call GetSquareRoot
	srl b
	srl b ; /4
	; load value (big endian) into pointer, note that this may be a bad idea to use 
	xor a
	ld [wLoadedMonSpecialExp], a
	ld a, b
	ld [wLoadedMonSpecialExp + 1], a
	; restore b to value from lb bc, 2, 5
	ld de, wLoadedMonSpecialExp
	coord hl, 4, 16
	lb bc, 2, 5

	jp PrintNumber
.checkstart	;joenote - print DVs
	bit BIT_START, a
	jr z, .doregular
	
	ld de, wUnusedD722
	lb bc, 1, 2
	call PrintStat
	ld de, wUnusedD722 + 1
	call PrintStat
	ld de, wUnusedD722 + 2
	call PrintStat
	ld de, wUnusedD722 + 3
	jp PrintNumber
.doregular
	ld de, wLoadedMonAttack
	lb bc, 2, 3
	call PrintStat
	ld de, wLoadedMonDefense
	call PrintStat
	ld de, wLoadedMonSpeed
	call PrintStat
	ld de, wLoadedMonSpecial	
	jp PrintNumber
PrintStat:
	push hl
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ret

StatsText:
	db   "Atq"
	next "Déf"
	next "Vit"
	next "Spé@"

StatusScreen2:
	ld a, [hTilesetType]
	push af
	xor a
	ld [hTilesetType], a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld bc, NUM_MOVES + 1
	ld hl, wMoves
	call FillMemory
	ld hl, wLoadedMonMoves
	ld de, wMoves
	ld bc, NUM_MOVES
	call CopyData
	callab FormatMovesString
	
	call PlaceTempFieldMove	;joenote - for field move slot
	
	coord hl, 9, 2
	lb bc, 5, 10
	call ClearScreenArea ; Clear under name
	coord hl, 19, 3
	ld [hl], $78
	coord hl, 0, 8
	ld b, 8
	ld c, 18
	call TextBoxBorder ; Draw move container
	coord hl, 2, 9
	ld de, wMovesString
	call PlaceString ; Print moves
	ld a, [wNumMovesMinusOne]
	inc a
	ld c, a
	ld a, $4
	sub c
	ld b, a ; Number of moves ?
	coord hl, 11, 10
	ld de, SCREEN_WIDTH * 2
	ld a, "<BOLD_P>"
	call StatusScreen_PrintPP ; Print "PP"
	ld a, b
	and a
	jr z, .InitPP
	ld c, a
	ld a, "-"
	call StatusScreen_PrintPP ; Fill the rest with --
.InitPP
	ld hl, wLoadedMonMoves
	coord de, 14, 10
	ld b, 0
.PrintPP
	ld a, [hli]
	and a
	jr z, .PPDone
	push bc
	push hl
	push de
	ld hl, wCurrentMenuItem
	ld a, [hl]
	push af
	ld a, b
	ld [hl], a
	push hl
	callab GetMaxPP
	pop hl
	pop af
	ld [hl], a
	pop de
	pop hl
	push hl
	ld bc, wPartyMon1PP - wPartyMon1Moves - 1
	add hl, bc
	ld a, [hl]
	and $3f
	ld [wStatusScreenCurrentPP], a
	ld h, d
	ld l, e
	push hl
	ld de, wStatusScreenCurrentPP
	lb bc, 1, 2
	call PrintNumber
	ld a, "/"
	ld [hli], a
	ld de, wMaxPP
	lb bc, 1, 2
	call PrintNumber
	pop hl
	ld de, SCREEN_WIDTH * 2
	add hl, de
	ld d, h
	ld e, l
	pop hl
	pop bc
	inc b
	ld a, b
	cp $4
	jr nz, .PrintPP
.PPDone
	coord hl, 9, 3
	ld de, StatusScreenExpText
	call PlaceString
	coord hl, 14, 6	;joenote - make things a little neater
	ld [hl], $70 ; 1-tile "to"
	ld a, [wLoadedMonLevel]
	push af
	cp MAX_LEVEL
	jr z, .Level100
	inc a
	ld [wLoadedMonLevel], a ; Increase temporarily if not 100
	inc hl
.Level100
	inc hl
	call PrintLevel
	pop af
	ld [wLoadedMonLevel], a
	ld de, wLoadedMonExp
	coord hl, 11, 4	;joenote - print 8 digit exp number
	lb bc, 3, 8 
	call PrintNumber ; exp
	call CalcExpToLevelUp
	ld de, wLoadedMonExp
	coord hl, 7, 6
	lb bc, 3, 7
	call PrintNumber ; exp needed to level up
	coord hl, 9, 0
	call StatusScreen_ClearName
	coord hl, 9, 1
	call StatusScreen_ClearName
	ld a, [wMonHIndex]
	ld [wPokedexNum], a
	call GetMonName
	coord hl, 9, 1
	call PlaceString
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	call Delay3
	pop af
	ret

CalcExpToLevelUp:
	ld a, [wLoadedMonLevel]
	cp MAX_LEVEL
	jr z, .atMaxLevel
	inc a
	ld d, a
	callab CalcExperience
	ld hl, wLoadedMonExp + 2
	ld a, [hExperience + 2]
	sub [hl]
	ld [hld], a
	ld a, [hExperience + 1]
	sbc [hl]
	ld [hld], a
	ld a, [hExperience]
	sbc [hl]
	ld [hld], a
	ret
.atMaxLevel
	ld hl, wLoadedMonExp
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

StatusScreenExpText:
	db   "Pts exp."
	next "Proch.niv.@"

StatusScreen_ClearName:
	ld bc, 10
	ld a, " "
	jp FillMemory

StatusScreen_PrintPP:
; print PP or -- c times, going down two rows each time
	ld [hli], a
	ld [hld], a
	add hl, de
	dec c
	jr nz, StatusScreen_PrintPP
	ret

;joenote - parse DV scores
DVParse:
	push hl
	push bc
	ld hl, wUnusedD722
	ld b, $00

	ld a, [wLoadedMonDVs]	;get attack dv
	swap a
	and $0F
	ld [hl], a
	inc hl
	and $01
	sla a
	sla a
	sla a
	or b
	ld b, a
	
	
	ld a, [wLoadedMonDVs]	;get defense dv
	and $0F
	ld [hl], a
	inc hl
	and $01
	sla a
	sla a
	or b
	ld b, a
	
	ld a, [wLoadedMonDVs + 1]	;get speed dv
	swap a
	and $0F
	ld [hl], a
	inc hl
	and $01
	sla a
	or b
	ld b, a
	
	ld a, [wLoadedMonDVs + 1]	;get special dv
	and $0F
	ld [hl], a
	inc hl
	and $01
	or b
	ld b, a

	ld [hl], b	;load hp dv
	
	pop bc
	pop hl
	ret
	
PlaceTempFieldMove:	;joenote - for field move slot
	ld a, [wMonDataLocation]
	cp PLAYER_PARTY_DATA
	ret nz
	
	ld a, [wWhichPokemon]
	ld c, a
	ld b,0
	ld hl, wTempFieldMoveSlots
	add hl, bc
	ld a, [hl]
	and a
	ret z

	ld [wd0b5], a
	ld a, BANK(MoveNames)
	ld [wPredefBank], a
	ld a, MOVE_NAME
	ld [wNameListType], a
	call GetName
	
	coord hl, $07, $07
	ld de, FieldMoveText
	call PlaceString

	coord hl, $0A, $07
	ld de, wcd6d
	call PlaceString
	
	ret

FieldMoveText:
	db "  →@"

StatsData:
	xor a
	ld [wStatsToDisplay], a

	ld a, [wStatsToDisplay]
	set 0, a
	ld [wStatsToDisplay], a
	ret
DVData:
	ld a, [wStatsToDisplay]
	res 0, a
	set 1, a
	ld [wStatsToDisplay], a
	ret
EVData:
	ld a, [wStatsToDisplay]
	set 2, a
	ld [wStatsToDisplay], a
	ret
;;;;;;;;;; PureRGBnote: ADDED: code that allows immediately backing out of the status menu with B from all status menus
StatusScreenOriginal:
	call StatsData

	ldh a, [hTilesetType]
	push af

	call StatusScreen
	ld b, A_BUTTON | B_BUTTON
	call PokedexStatusWaitForButtonPressLoop
	bit BIT_B_BUTTON, a
	jr nz, ExitStatusScreen

	call StatusScreen2
	ld b, A_BUTTON | B_BUTTON
	call PokedexStatusWaitForButtonPressLoop
	bit BIT_B_BUTTON, a
	jr nz, ExitStatusScreen

	call DVData
	call StatusScreen
	ld b, A_BUTTON | B_BUTTON
	call PokedexStatusWaitForButtonPressLoop
	bit BIT_B_BUTTON, a
	jr nz, ExitStatusScreen

	call EVData
	call StatusScreen
	ld b, A_BUTTON | B_BUTTON
	call PokedexStatusWaitForButtonPressLoop

ExitStatusScreen:
	pop af
	ldh [hTilesetType], a
	ld hl, wd72c
	res 1, [hl]
	ld a, $77
	ldh [rNR50], a
	call GBPalWhiteOut
	jp ClearScreen

.waitForInput
;;;;;;;;;;

;;;;;;;;;; PureRGBnote: ADDED: code that allows going up and down on the dpad
;;;;;;;;;; to next and previous party pokemon while in battle or in the start POKEMON menu.
StatusScreenLoop:
	ldh a, [hTilesetType]
	push af
.displayNextMon
	call StatsData
	call StatusScreen
	call PokemonStatusWaitForButtonPress
	bit BIT_D_UP, a
	jr nz, .prevMon
	bit BIT_D_DOWN, a
	jr nz, .nextMon
	bit BIT_B_BUTTON, a
	jr nz, .exitStatus

	call StatusScreen2
	call PokemonStatusWaitForButtonPress
	bit BIT_D_UP, a
	jr nz, .prevMon
	bit BIT_D_DOWN, a
	jr nz, .nextMon
	bit BIT_B_BUTTON, a
	jr nz, .exitStatus

	call DVData
	call StatusScreen
	call PokemonStatusWaitForButtonPress
	bit BIT_D_UP, a
	jr nz, .prevMon
	bit BIT_D_DOWN, a
	jr nz, .nextMon
	bit BIT_B_BUTTON, a
	jr nz, .exitStatus

	call EVData
	call StatusScreen
	call PokemonStatusWaitForButtonPress
	bit BIT_D_UP, a
	jr nz, .prevMon
	bit BIT_D_DOWN, a
	jr nz, .nextMon
.exitStatus
	jp ExitStatusScreen
.nextMon
	ld hl, wWhichPokemon
	inc [hl]
	ld hl, wPartyAndBillsPCSavedMenuItem
	inc [hl]
	jr .displayNextMon
.prevMon
	ld hl, wWhichPokemon
	dec [hl]
	ld hl, wPartyAndBillsPCSavedMenuItem
	dec [hl]
	jr .displayNextMon

PokemonStatusWaitForButtonPress:
.decideButtons
	ld a, A_BUTTON | B_BUTTON
	ld b, a
	ld a, [wWhichPokemon]
	and a
	jr z, .checkRight
	ld a, b
	or D_UP
	ld b, a
.checkRight
	ld a, [wPartyCount]
	dec a
	ld c, a
	ld a, [wWhichPokemon]
	cp c
	jr z, PokedexStatusWaitForButtonPressLoop
	ld a, b
	or D_DOWN
	ld b, a
PokedexStatusWaitForButtonPressLoop:
.waitForButtonPress
	push bc
	call JoypadLowSensitivity
	pop bc
	ldh a, [hJoy5]
	and b
	jr z, .waitForButtonPress
	ret
;;;;;;;;;;

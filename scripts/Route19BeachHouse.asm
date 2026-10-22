Route19BeachHouseScript:
	jp EnableAutoTextBoxDrawing


Route19BeachHouseTextPointers:
	dw Route19BeachHouseText_Fisher
	dw Route19BeachHouseText_Pikachu
	dw Route19BeachHouseText_Poster1
	dw Route19BeachHouseText_Poster2
	dw Route19BeachHouseText_Printer

Route19BeachHouseText_Fisher:
	TX_ASM
	; the minigame requires a Surfboard in the active bag
	ld hl, wBagItems
.itemLoop
	ld a, [hli]
	cp $ff
	jr z, .noSurfboard
	cp SURFBOARD
	jr z, .gotSurfBoard
	inc hl
	jr .itemLoop
.noSurfboard
	ld hl, Route19BeachHouseText_FisherBefore
	jr .displayText

.gotSurfBoard
	ld hl, Route19BeachHouseText_FisherAfter

	; TODO Check for 3000 score

	ld a, [wPartyMon1Species]
	cp PIKACHU
	jp z, PikachuTutor
	cp RAICHU
	jp z, PikachuTutor
	cp GOROCHU
	jp z, PikachuTutor
	; fallthrough
.displayText
	call PrintText
	jp TextScriptEnd

PikachuTutor:
	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	ld a, SURF
	call .learnmove
	ret

.textStart
	text "Okay man!"
	line "Monte sur la"
	cont "planche, on va"
	cont "t'apprendre à"
	cont "enchaîner"
	cont "les flips!"
	prompt
	db "@"

.learnmove
	ld [wMoveNum], a
	ld [wPokedexNum],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b

	ld a, [wPokedexNum]
	push af
	ld a, [wPartyMon1Species]
	ld [wPokedexNum], a
	call GetMonName
	pop af
	ld [wPokedexNum], a
	
	callba CheckIfMoveIsKnown
	jr c, .moveKnown

	ld hl, wStatusFlags7
	set 6, [hl]
	push hl		;make it so the move-forget list covers up sprites
	predef LearnMove
	pop hl
	res 6, [hl]
	ld a, b
	and a
	ret z
.finish
	ret
.moveKnown
	jp TextScriptEnd

Route19BeachHouseText_FisherBefore:
	TX_FAR _Route19BeachHouseText_FisherBefore
	db "@"

Route19BeachHouseText_FisherAfter:
	TX_FAR _Route19BeachHouseText_FisherAfter
	db "@"

Route19BeachHouseText_Pikachu:
	TX_ASM
	ld hl, .wantToSurfText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .startMinigame

	ld hl, .noSurfText
	call PrintText
	jp TextScriptEnd

.startMinigame
	; the minigame requires a Surfboard in the active bag
	ld hl, wBagItems
.itemLoop
	ld a, [hli]
	cp $ff
	jr z, .noSurfboard
	cp SURFBOARD
	jr z, .hasSurfboard
	inc hl
	jr .itemLoop
.noSurfboard
	ld hl, .noSurfboardText
	call PrintText
	jp TextScriptEnd
.hasSurfboard
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	callba PikachusBeach
	; the minigame reload path restores the map, but not the dialogue window
	callba DisplayTextIDInit
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.wantToSurfText
	text "Dave: Pika pi?"
	prompt
	db "@"
.yesSurfText
	text "Dave: Pikaaan!"
	prompt
	db "@"
.noSurfText
	text "Dave: PIKA CHU."
	done
	db "@"
.noSurfboardText
	text "Dave: PIKA CHU."
	line "Il pointe le"
	cont "doigt vers les"
	cont "Planches de Surf."
	done
	db "@"

Route19BeachHouseText_Poster1:
	TX_FAR _Route19BeachHouseText_Poster1
	db "@"

Route19BeachHouseText_Poster2:
	TX_FAR _Route19BeachHouseText_Poster2
	db "@"

Route19BeachHouseText_Printer:
	TX_ASM
	ld hl, .wantToPrintText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .printScore

	xor a
	ld [wUpdateSpritesEnabled], a
	callba DisplaySurfingMinigameHighScoreScreen
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.printScore
	; TODO Print

	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.wantToPrintText
	text "Imprimer le"
	line "score?"
	prompt
	db "@"

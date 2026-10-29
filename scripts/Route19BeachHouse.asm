Route19BeachHouseScript:
	jp EnableAutoTextBoxDrawing


Route19BeachHouseTextPointers:
	dw Route19BeachHouseText_Fisher
	dw Route19BeachHouseText_Pikachu
	dw Route19BeachHouseSign_Poster1
	dw Route19BeachHouseSign_Poster2
	dw Route19BeachHouseSign_Printer
	dw Route19BeachHouseSign_Shelves

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
	ld hl, Route19BeachHouseText_FisherGreeting
	jr .displayText

.gotSurfBoard
	ld hl, .madeHighScore

	; the move tutor requires a Pikachu's Beach high score of 3000+
	; (2-byte packed BCD: +1 holds the thousands/hundreds byte,
	; so that byte being >= $30 means a score of at least 3000)
	ld a, [wSurfingMinigameHiScore + 1]
	cp $30
	jr c, .scoreTooLow

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

.scoreTooLow
	ld hl, .scoreTooLowText
	jr .displayText

.scoreTooLowText
	text "Yo comment k'ça"
	line "va? Délire!!!"
	cont "Toi aussi t'es"
	cont "Surfeur!"

	para "Tu as donc"
	line "le droit de"
	cont "surfer avec"
	cont "le DAVE!"

	para "Réussi à faire un"
	line "score de 3000 et"
	cont "j'enseignerai la"
	cont "voie du Surf à"
	cont "ton Pikachu, man!"
	done
	db "@"

.madeHighScore
	text "Yo comment k'ça"
	line "va? Mais nan!!!"
	cont "T'es un vrai"
	cont "dompteur de"
	cont "rouleau!"

	para "T'es l'un des"
	line "nôtres maintenant"
	cont "mon gars!"

	para "Ramène moi ton"
	line "Pikachu ou ton"
	cont "Raichu et le"
	cont "Dave lui montrera"
	cont "la voie du Surf!"
	done
	db "@"

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

Route19BeachHouseText_FisherGreeting:
	TX_FAR _Route19BeachHouseText_FisherGreeting
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
	ld hl, .byeSurfText
	call PrintText
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
.byeSurfText
	text "Dave: Pika!"
	done
	db "@"
.noSurfboardText
	text "Dave: PIKA CHU."
	line "Il pointe le"
	cont "doigt vers les"
	cont "Planches de Surf."
	done
	db "@"

Route19BeachHouseSign_Poster1:
	TX_FAR _Route19BeachHouseSign_Poster1
	db "@"

Route19BeachHouseSign_Poster2:
	TX_FAR _Route19BeachHouseSign_Poster2
	db "@"

Route19BeachHouseSign_Printer:
	TX_ASM
	;display the PC-style power-on text, then open the printer menu
	ld hl, .turnedOnPrinterText
	call PrintText
	; open the GB Printer menu, then redraw the map view
	xor a
	ld [wUpdateSpritesEnabled], a
	callba OpenPrinterMenu
	callba ReloadMapAfterPrinter
	ld a, $1
	ld [wUpdateSpritesEnabled], a
	;the menu is the whole interaction: close the dialogue box right
	;away instead of waiting for one more button press (mirrors the
	;NON branch above)
	ld a, 1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

;shown above the printer menu, like the "allume le PC" texts
.turnedOnPrinterText
	text "<PLAYER> allume"
	line "l'imprimante."
	prompt
	db "@"

Route19BeachHouseSign_Shelves:
	TX_FAR _Route19BeachHouseSign_Shelves
	db "@"

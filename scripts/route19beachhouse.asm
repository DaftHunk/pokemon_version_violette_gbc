Route19BeachHouseScript:
	jp EnableAutoTextBoxDrawing


Route19BeachHouseTextPointers:
	dw Route19BeachHouseFisherText
	dw Route19BeachHousePikachuText
	dw Route19BeachHousePoster1Text
	dw Route19BeachHousePoster2Text
	dw Route19BeachHousePCText

Route19BeachHouseFisherText:
	TX_ASM
	CheckEvent EVENT_GOT_DEX_DIPLOMA
	jr nz, .gotSurfBoard
	; else
	ld hl, Route19BeachHouseFisherBeforeText
	jr .displayText
.gotSurfBoard
	ld hl, Route19BeachHouseFisherAfterText

	ld a, [wPartyMon1Species]
	cp PIKACHU
	jr z, PikachuTutor
	; fallthrough
.displayText
	call PrintText
	jp TextScriptEnd

Route19BeachHouseFisherBeforeText:
	TX_FAR _Route19BeachHouseFisherBeforeText
	db "@"

Route19BeachHouseFisherAfterText:
	TX_FAR _Route19BeachHouseFisherAfterText
	db "@"

Route19BeachHousePikachuText:
	TX_FAR _Route19BeachHousePikachuText
	db "@"

Route19BeachHousePoster1Text:
	TX_FAR _Route19BeachHousePoster1Text
	db "@"

Route19BeachHousePoster2Text:
	TX_FAR _Route19BeachHousePoster2Text
	db "@"

Route19BeachHousePCText:
	TX_FAR _Route19BeachHousePCText
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
	jr c, .finish

	ld hl, wFlags_D733
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

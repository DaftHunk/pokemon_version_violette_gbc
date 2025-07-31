Route16HouseScript:
	jp EnableAutoTextBoxDrawing

Route16HouseTextPointers:
	dw Route16HouseText1
	dw Route16HouseText2

Route16HouseText1:
	TX_ASM
	CheckEvent EVENT_GOT_HM02
	ld hl, HM02ExplanationText
	jr nz, .asm_13616
	ld hl, Route16HouseText3
	call PrintText
	lb bc, HM02_FLY, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_HM02
	ld hl, ReceivedHM02Text
	jr .asm_13616
.BagFull
	ld hl, HM02NoRoomText
.asm_13616
	call PrintText
	jp TextScriptEnd

Route16HouseText3:
	TX_FAR _Route16HouseText3
	db "@"

ReceivedHM02Text:
	TX_FAR _ReceivedHM02Text
	TX_SFX_KEY_ITEM
	db "@"

HM02ExplanationText:
	TX_FAR _HM02ExplanationText
	db "@"

HM02NoRoomText:
	TX_FAR _HM02NoRoomText
	db "@"

Route16HouseText2:
	TX_ASM
	ld hl, Route16HouseText_1e652
	call PrintText
	ld a, FEAROW
	call DisplayPokedex
	call CheckFearowTutor
	jp TextScriptEnd

Route16HouseText_1e652:
	TX_FAR _Route16HouseText_1e652
	db "@"

;joenote - place a pidgeot or pidgeotto at the top of your party
;then talk to the fearow
;your pokemon will learn drill peck
CheckFearowTutor:
	ld a, [wPartyMon1Species]
	cp PIDGEOTTO
	jr z, .next
	cp PIDGEOT
	jr z, .next
	ret
.next
	call .printTextStart

	xor a
	ld [wWhichPokemon], a

	ld a, DRILL_PECK
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
	jr c, .printTextEnd

	ld hl, wFlags_D733
	set 6, [hl]
	push hl		;make it so the move-forget list covers up sprites
	predef LearnMove
	pop hl
	res 6, [hl]
	ld a, b
	and a
	ret z
.printTextEnd
	ld hl, .textEnd
	call PrintText
	ret
.textEnd
	text "Vrivri s'élance"
	line "joyeusement dans"
	cont "tous les sens!"
	done
	db "@"
.printTextStart
	ld hl, .textStart
	call PrintText
	ret
.textStart
	text "Vrivri et votre"
	line "#mon jouent"
	cont "ensemble!"

	para "Tiens? On dirait"
	line "qu'elle veut lui"
	cont "montrer quelque"
	cont "chose..."
	done
	db "@"

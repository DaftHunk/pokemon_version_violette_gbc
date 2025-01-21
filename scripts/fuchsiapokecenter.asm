FuchsiaPokecenterScript:
	call Serial_TryEstablishingExternallyClockedConnection
	jp EnableAutoTextBoxDrawing
	ld de, FuchsiaPokecenterScriptPointers
	ld a, [wFuchsiaPokecenterCurScript]
	call ExecuteCurMapScriptInTable
	ld [wFuchsiaPokecenterCurScript], a
	ret

FuchsiaPokecenterScriptPointers:
	dw FuchsiaPokecenterScript0
	dw JoyPostBattleScript

FuchsiaPokecenterTextPointers:
	dw FuchsiaPokecenterNurseText
	dw FuchsiaPokecenterText2
	dw FuchsiaPokecenterText3
	dw FuchsiaTradeNurseText
	dw NurseJoyAfterBattleText

FuchsiaPokecenterScript0:
	ret

JoyPostBattleScript:
	ld a, [wIsInBattle]
	inc a
	jr z, .skip	; Kick out if the player lost.
	SetEvent EVENT_BEAT_NURSE_JOY
	call JoyPostBattleScript
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.skip
	call FuchsiaPokecenterScript0
	ld [wFuchsiaPokecenterCurScript], a
	ld [wCurMapScript], a
	ret
NurseJoyAfterBattleText:
	TX_FAR _NurseJoyAfterBattleText
	db "@"

FuchsiaPokecenterNurseText:
	TX_ASM
	callab DisplayPokemonCenterDialogue_
	CheckEvent EVENT_908
	jr z, .done
	CheckEvent EVENT_BEAT_NURSE_JOY
	jr nz, .NotFirstBattle
	callab NewPageButtonPressCheck
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld hl, NurseJoyPreBattleText
.continue
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, NurseJoyAcceptedText
	call PrintText
	call Delay3
	ld a, OPP_JOY
	ld [wCurOpponent], a
	ld a, 1
	ld [wTrainerNo], a
	ld a, $1 ; new script
	ld [wFuchsiaPokecenterCurScript], a
	ld [wCurMapScript], a
	jr .done
.refused
	ld hl, NurseJoyRefusedText
	call PrintText
.done
	jp TextScriptEnd
.NotFirstBattle
	callab NewPageButtonPressCheck
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld hl, NurseJoyPreBattleText2
	jr .continue
NurseJoyPreBattleText:
	TX_FAR _NurseJoyBattleText
	db "@"
NurseJoyRefusedText:
	TX_FAR _NurseJoyRefusedText
	db "@"
NurseJoyAcceptedText:
	TX_FAR _NurseJoyAcceptedText
	db "@"
NurseJoyPreBattleText2:
	TX_FAR _NurseJoyBattleText2
	db "@"

FuchsiaPokecenterText2:
	TX_FAR _FuchsiaPokecenterText1
	db "@"

FuchsiaPokecenterText3:
	TX_FAR _FuchsiaPokecenterText3
	db "@"

FuchsiaTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

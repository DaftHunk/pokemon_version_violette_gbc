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

FuchsiaPokecenterTextPointers:
	dw FuchsiaPokecenterNurseText
	dw FuchsiaPokecenterText2
	dw FuchsiaPokecenterText3
	dw FuchsiaTradeNurseText

FuchsiaPokecenterScript0:
	ret

FuchsiaPokecenterNurseText:
	TX_ASM
	callab DisplayPokemonCenterDialogue_
	CheckEvent EVENT_ELITE_4_BEATEN	;has elite 4 been beaten?
	jr z, .done

	callab NewPageButtonPressCheck
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a

	CheckEvent EVENT_BEAT_NURSE_JOY
	jr nz, .rematch

	ld hl, NurseJoyPreBattleText
	jr .joyDuel
.rematch
	ld hl, NurseJoyPreBattleText2
	jr .joyDuel
.joyDuel
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .refused
	ld hl, NurseJoyAcceptedText
	call PrintText
	; set battle flags
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	; set battle opponent
	call Delay3
	ld a, OPP_JOY
	ld [wCurOpponent], a
	; set team
	ld a, $1
	ld [wTrainerNo], a
	; set after battle script
	ld a, $0 ; new script
	ld [wFuchsiaPokecenterCurScript], a
	ld [wCurMapScript], a
	SetEvent EVENT_BEAT_NURSE_JOY
	;set the special trainer flag
	ld a, [wBeatGymFlags]
	set 3, a
	ld [wBeatGymFlags], a
	; after battle
	ld hl, NurseJoyAfterBattleText
	call SaveEndBattleTextPointers
	jr .done
.refused
	ld hl, NurseJoyRefusedText
	call PrintText
.done
	jp TextScriptEnd

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

NurseJoyAfterBattleText:
	TX_FAR _NurseJoyAfterBattleText
	db "@"

FuchsiaPokecenterText2:
	TX_FAR _FuchsiaPokecenterText1
	db "@"

FuchsiaPokecenterText3:
	TX_FAR _FuchsiaPokecenterText3
	db "@"

FuchsiaTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

LoreleiScript:
	call LoreleiShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld hl, LoreleiTrainerHeader0
	ld de, LoreleiScriptPointers
	ld a, [wLoreleiCurScript]
	call ExecuteCurMapScriptInTable
	ld [wLoreleiCurScript], a
	ret

LoreleiShowOrHideExitBlock:
; Blocks or clears the exit to the next room.
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, wBeatLorelei
	set 1, [hl]
	CheckEvent EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	jr z, .blockExitToNextRoom
	ld a, $5
	jr .setExitBlock
.blockExitToNextRoom
	ld a, $24
.setExitBlock
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

ResetLoreleiScript:
	xor a
	ld [wLoreleiCurScript], a
	ret

LoreleiScriptPointers:
	dw LoreleiScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw LoreleiScript2
	dw LoreleiScript3
	dw LoreleiScript4

LoreleiScript4:
	ret

LoreleiScriptWalkIntoRoom:
; Walk six steps upward.
	ld hl, wSimulatedJoypadStatesEnd
	ld a, D_UP
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $6
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wLoreleiCurScript], a
	ld [wCurMapScript], a
	ret

LoreleiScript0:
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .elite4Rematch
	jr .continueScript
.elite4Rematch
	ld a, HS_LORELEI_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_LORELEI_2
	ld [wMissableObjectIndex], a
	predef ShowObject2
	jr .continueScript
.continueScript
	ld hl, LoreleiEntranceCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, [wCoordIndex]
	cp $3  ; Is player standing one tile above the exit?
	jr c, .stopPlayerFromLeaving
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_LORELEIS_ROOM
	jr z, LoreleiScriptWalkIntoRoom
.stopPlayerFromLeaving
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID  ; "Don't run away!"
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wLoreleiCurScript], a
	ld [wCurMapScript], a
	ret

LoreleiEntranceCoords:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

LoreleiScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [wLoreleiCurScript], a
	ld [wCurMapScript], a
	ret

LoreleiScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetLoreleiScript

	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .elite4Rematch

	ld a, $1
	jp .endBattle
.elite4Rematch
	ld a, $2
	; fallthrough
.endBattle
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
;;;;;;;;;; PureRGBnote: ADDED: sound effect for the doors opening
	ld a, SFX_GO_INSIDE
	call PlaySound
	ret
;;;;;;;;;;

LoreleiTextPointers:
	dw LoreleiText1
	dw LoreleiText2
	dw LoreleiDontRunAwayText

LoreleiTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	dw LoreleiBeforeBattleText ; TextBeforeBattle
	dw LoreleiAfterBattleText ; TextAfterBattle
	dw LoreleiEndBattleText ; TextEndBattle
	dw LoreleiEndBattleText ; TextEndBattle
LoreleiTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	dw RematchLoreleiBeforeBattleText ; TextBeforeBattle
	dw RematchLoreleiAfterBattleText ; TextAfterBattle
	dw RematchLoreleiEndBattleText ; TextEndBattle
	dw RematchLoreleiEndBattleText ; TextEndBattle

	db $ff

LoreleiText1:
	TX_ASM
	ld hl, LoreleiTrainerHeader0
	ld a, 8
	ld [wGymLeaderNo], a	;joenote - use gym leader music
	call TalkToTrainer
	jp TextScriptEnd

LoreleiText2:
	TX_ASM
	ld hl, LoreleiTrainerHeader1
	ld a, 8
	ld [wGymLeaderNo], a	;joenote - use gym leader music
	call TalkToTrainer
	jp TextScriptEnd

LoreleiBeforeBattleText:
	TX_FAR _LoreleiBeforeBattleText
	db "@"

LoreleiEndBattleText:
	TX_FAR _LoreleiEndBattleText
	db "@"

LoreleiAfterBattleText:
	TX_FAR _LoreleiAfterBattleText
	db "@"

RematchLoreleiBeforeBattleText:
	TX_FAR _RematchLoreleiBeforeBattleText
	db "@"

RematchLoreleiEndBattleText:
	TX_FAR _RematchLoreleiEndBattleText
	db "@"

RematchLoreleiAfterBattleText:
	TX_FAR _RematchLoreleiAfterBattleText
	db "@"

LoreleiDontRunAwayText:
	TX_FAR _LoreleiDontRunAwayText
	db "@"

BrunoScript:
	call BrunoShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld hl, BrunoTrainerHeader0
	ld de, BrunoScriptPointers
	ld a, [wBrunoCurScript]
	call ExecuteCurMapScriptInTable
	ld [wBrunoCurScript], a
	ret

BrunoShowOrHideExitBlock:
; Blocks or clears the exit to the next room.
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	jr z, .blockExitToNextRoom
	ld a, $5
	jp .setExitBlock
.blockExitToNextRoom
	ld a, $24
.setExitBlock
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

ResetBrunoScript:
	xor a
	ld [wBrunoCurScript], a
	ret

BrunoScriptPointers:
	dw BrunoScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw BrunoScript2
	dw BrunoScript3
	dw BrunoScript4

BrunoScript4:
	ret

BrunoScriptWalkIntoRoom:
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
	ld [wBrunoCurScript], a
	ld [wCurMapScript], a
	ret

BrunoScript0:
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .elite4Rematch
	jr .continueScript
.elite4Rematch
	ld a, HS_BRUNO_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BRUNO_2
	ld [wMissableObjectIndex], a
	predef ShowObject2
	jr .continueScript
.continueScript
	ld hl, BrunoEntranceCoords
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
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_BRUNOS_ROOM
	jr z, BrunoScriptWalkIntoRoom
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
	ld [wBrunoCurScript], a
	ld [wCurMapScript], a
	ret

BrunoEntranceCoords:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

BrunoScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [wBrunoCurScript], a
	ld [wCurMapScript], a
	ret

BrunoScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetBrunoScript
	
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .elite4Rematch
	
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID
.elite4Rematch
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

BrunoTextPointers:
	dw BrunoText1
	dw BrunoText2
	dw BrunoDontRunAwayText

BrunoTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	dw BrunoBeforeBattleText ; TextBeforeBattle
	dw BrunoAfterBattleText ; TextAfterBattle
	dw BrunoEndBattleText ; TextEndBattle
	dw BrunoEndBattleText ; TextEndBattle
BrunoTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_BRUNOS_ROOM_TRAINER_0
	dw RematchBrunoBeforeBattleText ; TextBeforeBattle
	dw RematchBrunoAfterBattleText ; TextAfterBattle
	dw RematchBrunoEndBattleText ; TextEndBattle
	dw RematchBrunoEndBattleText ; TextEndBattle

	db $ff

BrunoText1:
	TX_ASM
	ld hl, BrunoTrainerHeader0
	ld a, 8
	ld [wGymLeaderNo], a	;joenote - use gym leader music
	call TalkToTrainer
	jp TextScriptEnd

BrunoText2:
	TX_ASM
	ld hl, BrunoTrainerHeader1
	ld a, 8
	ld [wGymLeaderNo], a	;joenote - use gym leader music
	call TalkToTrainer
	jp TextScriptEnd

BrunoBeforeBattleText:
	TX_FAR _BrunoBeforeBattleText
	db "@"

BrunoEndBattleText:
	TX_FAR _BrunoEndBattleText
	db "@"

BrunoAfterBattleText:
	TX_FAR _BrunoAfterBattleText
	db "@"

RematchBrunoBeforeBattleText:
	TX_FAR _RematchBrunoBeforeBattleText
	db "@"

RematchBrunoEndBattleText:
	TX_FAR _RematchBrunoEndBattleText
	db "@"

RematchBrunoAfterBattleText:
	TX_FAR _RematchBrunoAfterBattleText
	db "@"

BrunoDontRunAwayText:
	TX_FAR _BrunoDontRunAwayText
	db "@"

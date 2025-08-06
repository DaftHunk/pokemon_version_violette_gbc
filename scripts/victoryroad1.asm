VictoryRoad1Script:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	call nz, .next
	call EnableAutoTextBoxDrawing
	ld hl, VictoryRoad1TrainerHeader0
	ld de, VictoryRoad1ScriptPointers
	ld a, [wVictoryRoad1CurScript]
	call ExecuteCurMapScriptInTable
	ld [wVictoryRoad1CurScript], a
	ret
.next
	CheckEvent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	ret z
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; wispnote - If the switch is activated place the boulder in switch's coordinates.
; Sprite05 indexes the boulder, and ($11, $0D) are the swtich's coordinates.
	ld hl, Sprite09MapY
	ld a, $0D
	add 4; wispnote - We need to offset coordinates by 4
	ld [hl], a
	ld hl, Sprite09MapX
	ld a, $11
	add 4; wispnote - We need to offset coordinates by 4
	ld [hl], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $1d
	ld [wNewTileBlockID], a
	lb bc, 6, 4
	predef_jump ReplaceTileBlock

VictoryRoad1ScriptPointers:
	dw VictoryRoad1Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

VictoryRoad1Script0:
	ld a, [wFlags_0xcd60]
	bit 1, a
	ret nz ; PureRGBnote: ADDED: if a boulder animation is playing forget doing this, helps reduce lag
	CheckEvent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	jp nz, CheckFightingMapTrainers
	ld hl, CoordsData_5da5c
	call CheckBoulderCoords
	jp nc, CheckFightingMapTrainers
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	SetEvent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
;;;;;;;;;; PureRGBnote: ADDED: sound effect when boulder presses switch
	; fall through
BoulderOnButton:
	ld a, SFX_TELEPORT_ENTER_2
	call PlaySound
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	ret
;;;;;;;;;;

CoordsData_5da5c:
	db $0D,$11,$FF

VictoryRoad1TextPointers:
	dw VictoryRoad1Text1
	dw VictoryRoad1Text2
	dw VictoryRoad1Text3
	dw VictoryRoad1Text4
	dw VictoryRoad1Text5
	dw VictoryRoad1Text6
	dw PickUpItemText
	dw PickUpItemText
	dw BoulderText
	dw BoulderText
	dw BoulderText

VictoryRoad1TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_0
	dw VictoryRoad1BattleText1 ; TextBeforeBattle
	dw VictoryRoad1AfterBattleText1 ; TextAfterBattle
	dw VictoryRoad1EndBattleText1 ; TextEndBattle
	dw VictoryRoad1EndBattleText1 ; TextEndBattle

VictoryRoad1TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_1
	dw VictoryRoad1BattleText2 ; TextBeforeBattle
	dw VictoryRoad1AfterBattleText2 ; TextAfterBattle
	dw VictoryRoad1EndBattleText2 ; TextEndBattle
	dw VictoryRoad1EndBattleText2 ; TextEndBattle

VictoryRoad1TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_2
	dw VictoryRoad1FBugCatcherBattleText ; TextBeforeBattle
	dw VictoryRoad1FBugCatcherAfterBattleText ; TextAfterBattle
	dw VictoryRoad1FBugCatcherEndBattleText ; TextEndBattle
	dw VictoryRoad1FBugCatcherEndBattleText ; TextEndBattle

VictoryRoad1TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_3
	dw VictoryRoad1FBeautyBattleText ; TextBeforeBattle
	dw VictoryRoad1FBeautyAfterBattleText ; TextAfterBattle
	dw VictoryRoad1FBeautyEndBattleText ; TextEndBattle
	dw VictoryRoad1FBeautyEndBattleText ; TextEndBattle

VictoryRoad1TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_4
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_4
	dw VictoryRoad1FBurglarBattleText ; TextBeforeBattle
	dw VictoryRoad1FBurglarAfterBattleText ; TextAfterBattle
	dw VictoryRoad1FBurglarEndBattleText ; TextEndBattle
	dw VictoryRoad1FBurglarEndBattleText ; TextEndBattle

VictoryRoad1TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_5
	dw VictoryRoad1FSuperNerdBattleText ; TextBeforeBattle
	dw VictoryRoad1FSuperNerdAfterBattleText ; TextAfterBattle
	dw VictoryRoad1FSuperNerdEndBattleText ; TextEndBattle
	dw VictoryRoad1FSuperNerdEndBattleText ; TextEndBattle

	db $ff

VictoryRoad1Text1:
	TX_ASM
	ld hl, VictoryRoad1TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1Text2:
	TX_ASM
	ld hl, VictoryRoad1TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1Text3:
	TX_ASM
	ld hl, VictoryRoad1TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1Text4:
	TX_ASM
	ld hl, VictoryRoad1TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1Text5:
	TX_ASM
	ld hl, VictoryRoad1TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1Text6:
	TX_ASM
	ld hl, VictoryRoad1TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1BattleText1:
	TX_FAR _VictoryRoad1BattleText1
	db "@"

VictoryRoad1EndBattleText1:
	TX_FAR _VictoryRoad1EndBattleText1
	db "@"

VictoryRoad1AfterBattleText1:
	TX_FAR _VictoryRoad1AfterBattleText1
	db "@"

VictoryRoad1BattleText2:
	TX_FAR _VictoryRoad1BattleText2
	db "@"

VictoryRoad1EndBattleText2:
	TX_FAR _VictoryRoad1EndBattleText2
	db "@"

VictoryRoad1AfterBattleText2:
	TX_FAR _VictoryRoad1AfterBattleText2
	db "@"

VictoryRoad1FBugCatcherBattleText:
	TX_FAR _VictoryRoad1FBugCatcherBattleText
	db "@"

VictoryRoad1FBugCatcherEndBattleText:
	TX_FAR _VictoryRoad1FBugCatcherEndBattleText
	db "@"

VictoryRoad1FBugCatcherAfterBattleText:
	TX_FAR _VictoryRoad1FBugCatcherAfterBattleText
	db "@"

VictoryRoad1FBeautyBattleText:
	TX_FAR _VictoryRoad1FBeautyBattleText
	db "@"

VictoryRoad1FBeautyEndBattleText:
	TX_FAR _VictoryRoad1FBeautyEndBattleText
	db "@"

VictoryRoad1FBeautyAfterBattleText:
	TX_FAR _VictoryRoad1FBeautyAfterBattleText
	db "@"

VictoryRoad1FBurglarBattleText:
	TX_FAR _VictoryRoad1FBurglarBattleText
	db "@"

VictoryRoad1FBurglarEndBattleText:
	TX_FAR _VictoryRoad1FBurglarEndBattleText
	db "@"

VictoryRoad1FBurglarAfterBattleText:
	TX_FAR _VictoryRoad1FBurglarAfterBattleText
	db "@"

VictoryRoad1FSuperNerdBattleText:
	TX_FAR _VictoryRoad1FSuperNerdBattleText
	db "@"

VictoryRoad1FSuperNerdEndBattleText:
	TX_FAR _VictoryRoad1FSuperNerdEndBattleText
	db "@"

VictoryRoad1FSuperNerdAfterBattleText:
	TX_FAR _VictoryRoad1FSuperNerdAfterBattleText
	db "@"

ViridianForestScript:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianForestTrainerHeader0
	ld de, ViridianForestScriptPointers
	ld a, [wViridianForestCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianForestCurScript], a
	ret

ViridianForestScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

ViridianForestTextPointers:
	dw ViridianForestText1
	dw ViridianForestText2
	dw ViridianForestText3
	dw ViridianForestText4
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw ViridianForestText8
	dw ViridianForestText5
	dw ViridianForestText9
	dw ViridianForestText10
	dw ViridianForestText11
	dw ViridianForestText12
	dw ViridianForestText13
	dw ViridianForestText14

ViridianForestTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_0
	dw ViridianForestBattleText1 ; TextBeforeBattle
	dw ViridianForestAfterBattleText1 ; TextAfterBattle
	dw ViridianForestEndBattleText1 ; TextEndBattle
	dw ViridianForestEndBattleText1 ; TextEndBattle

ViridianForestTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_1
	dw ViridianForestBattleText2 ; TextBeforeBattle
	dw ViridianForestAfterBattleText2 ; TextAfterBattle
	dw ViridianForestEndBattleText2 ; TextEndBattle
	dw ViridianForestEndBattleText2 ; TextEndBattle

ViridianForestTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_2
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_2
	dw ViridianForestBattleText3 ; TextBeforeBattle
	dw ViridianForestAfterBattleText3 ; TextAfterBattle
	dw ViridianForestEndBattleText3 ; TextEndBattle
	dw ViridianForestEndBattleText3 ; TextEndBattle

ViridianForestTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_3
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_3
	dw ViridianForestBattleText4 ; TextBeforeBattle
	dw ViridianForestAfterBattleText4 ; TextAfterBattle
	dw ViridianForestEndBattleText4 ; TextEndBattle
	dw ViridianForestEndBattleText4 ; TextEndBattle

	db $ff

ViridianForestText1:
	TX_FAR _ViridianForestText1
	db "@"

ViridianForestText2:
	TX_ASM
	ld hl, ViridianForestTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText3:
	TX_ASM
	ld hl, ViridianForestTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText4:
	TX_ASM
	ld hl, ViridianForestTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestText5:
	TX_ASM
	ld hl, ViridianForestTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

ViridianForestBattleText1:
	TX_FAR _ViridianForestBattleText1
	db "@"

ViridianForestEndBattleText1:
	TX_FAR _ViridianForestEndBattleText1
	db "@"

ViridianForestAfterBattleText1:
	TX_FAR _ViridianFrstAfterBattleText1
	db "@"

ViridianForestBattleText2:
	TX_FAR _ViridianForestBattleText2
	db "@"

ViridianForestEndBattleText2:
	TX_FAR _ViridianForestEndBattleText2
	db "@"

ViridianForestAfterBattleText2:
	TX_FAR _ViridianFrstAfterBattleText2
	db "@"

ViridianForestBattleText3:
	TX_FAR _ViridianForestBattleText3
	db "@"

ViridianForestEndBattleText3:
	TX_FAR _ViridianForestEndBattleText3
	db "@"

ViridianForestAfterBattleText3:
	TX_FAR _ViridianFrstAfterBattleText3
	db "@"

ViridianForestText8:
	TX_FAR _ViridianForestText8
	db "@"

ViridianForestBattleText4:
	TX_FAR _ViridianForestBattleText4
	db "@"

ViridianForestEndBattleText4:
	TX_FAR _ViridianForestEndBattleText4
	db "@"

ViridianForestAfterBattleText4:
	TX_FAR _ViridianForestAfterBattleText4
	db "@"

ViridianForestText9:
	TX_FAR _ViridianForestText9
	db "@"

ViridianForestText10:
	TX_FAR _ViridianForestText10
	db "@"

ViridianForestText11:
	TX_FAR _ViridianForestText11
	db "@"

ViridianForestText12:
	TX_FAR _ViridianForestText12
	db "@"

ViridianForestText13:
	TX_FAR _ViridianForestText13
	db "@"

ViridianForestText14:
	TX_FAR _ViridianForestText14
	db "@"

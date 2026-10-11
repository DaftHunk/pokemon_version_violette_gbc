Route10Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route10TrainerHeader0
	ld de, Route10ScriptPointers
	ld a, [wRoute10CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute10CurScript], a
	ret

Route10ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route10TextPointers:
	dw Route10Text1
	dw Route10Text2
	dw PokeCenterSignText
	dw Route10SignText1
	dw Route10SignText2

Route10TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_10_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_10_TRAINER_0
	dw Route10BattleText1 ; TextBeforeBattle
	dw Route10AfterBattleText1 ; TextAfterBattle
	dw Route10EndBattleText1 ; TextEndBattle
	dw Route10EndBattleText1 ; TextEndBattle

Route10TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_10_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_10_TRAINER_1
	dw Route10BattleText2 ; TextBeforeBattle
	dw Route10AfterBattleText2 ; TextAfterBattle
	dw Route10EndBattleText2 ; TextEndBattle
	dw Route10EndBattleText2 ; TextEndBattle

	db $ff

Route10Text1:
	TX_ASM
	ld hl, Route10TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText1:
	TX_FAR _Route10BattleText1
	db "@"

Route10EndBattleText1:
	TX_FAR _Route10EndBattleText1
	db "@"

Route10AfterBattleText1:
	TX_FAR _Route10AfterBattleText1
	db "@"

Route10Text2:
	TX_ASM
	ld hl, Route10TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText2:
	TX_FAR _Route10BattleText2
	db "@"

Route10EndBattleText2:
	TX_FAR _Route10EndBattleText2
	db "@"

Route10AfterBattleText2:
	TX_FAR _Route10AfterBattleText2
	db "@"

Route10SignText1:
	TX_FAR _Route10SignText1
	db "@"

Route10SignText2:
	TX_FAR _Route10SignText2
	db "@"

VolcanoB1FScript:
	call EnableAutoTextBoxDrawing
	ld hl, VolcanoB1FTrainerHeader0
	ld de, VolcanoB1FScriptPointers
	ld a, [wVolcanoB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVolcanoB1FCurScript], a
	ret

VolcanoB1FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

VolcanoB1FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VOLCANO_B1F_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VOLCANO_B1F_TRAINER_0
	dw VolcanoB1FText0_Battle ; TextBeforeBattle
	dw VolcanoB1FText0_AfterBattle ; TextAfterBattle
	dw VolcanoB1FText0_EndBattle ; TextEndBattle
	dw VolcanoB1FText0_EndBattle ; TextEndBattle

VolcanoB1FTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VOLCANO_B1F_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VOLCANO_B1F_TRAINER_1
	dw VolcanoB1FText1_Battle ; TextBeforeBattle
	dw VolcanoB1FText1_AfterBattle ; TextAfterBattle
	dw VolcanoB1FText1_EndBattle ; TextEndBattle
	dw VolcanoB1FText1_EndBattle ; TextEndBattle

db $ff

VolcanoB1FTextPointers:
    dw VolcanoB1FText_Trainer0
	dw VolcanoB1FText_Trainer1
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

VolcanoB1FText_Trainer0:
	TX_ASM
	ld hl, VolcanoB1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VolcanoB1FText0_Battle:
	TX_FAR _VolcanoB1FText0_Battle
	db "@"

VolcanoB1FText0_EndBattle:
	TX_FAR _VolcanoB1FText0_EndBattle
	db "@"

VolcanoB1FText0_AfterBattle:
	TX_FAR _VolcanoB1FText0_AfterBattle
	db "@"

VolcanoB1FText_Trainer1:
	TX_ASM
	ld hl, VolcanoB1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VolcanoB1FText1_Battle:
	TX_FAR _VolcanoB1FText1_Battle
	db "@"

VolcanoB1FText1_EndBattle:
	TX_FAR _VolcanoB1FText1_EndBattle
	db "@"

VolcanoB1FText1_AfterBattle:
	TX_FAR _VolcanoB1FText1_AfterBattle
	db "@"

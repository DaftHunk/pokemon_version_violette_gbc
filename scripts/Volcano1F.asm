Volcano1FScript:
	call EnableAutoTextBoxDrawing
	ld hl, Volcano1FTrainerHeader0
	ld de, Volcano1FScriptPointers
	ld a, [wVolcano1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVolcano1FCurScript], a
	ret

Volcano1FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Volcano1FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VOLCANO_1F_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VOLCANO_1F_TRAINER_0
	dw Volcano1FText0_Battle ; TextBeforeBattle
	dw Volcano1FText0_AfterBattle ; TextAfterBattle
	dw Volcano1FText0_EndBattle ; TextEndBattle
	dw Volcano1FText0_EndBattle ; TextEndBattle

Volcano1FTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VOLCANO_1F_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VOLCANO_1F_TRAINER_1
	dw Volcano1FText1_Battle ; TextBeforeBattle
	dw Volcano1FText1_AfterBattle ; TextAfterBattle
	dw Volcano1FText1_EndBattle ; TextEndBattle
	dw Volcano1FText1_EndBattle ; TextEndBattle

Volcano1FTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VOLCANO_1F_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VOLCANO_1F_TRAINER_2
	dw Volcano1FText2_Battle ; TextBeforeBattle
	dw Volcano1FText2_AfterBattle ; TextAfterBattle
	dw Volcano1FText2_EndBattle ; TextEndBattle
	dw Volcano1FText2_EndBattle ; TextEndBattle

db $ff

Volcano1FTextPointers:
    dw Volcano1FText_Trainer0
	dw Volcano1FText_Trainer1
	dw Volcano1FText_Trainer2
	dw PickUpItemText
	dw PickUpItemText

Volcano1FText_Trainer0:
	TX_ASM
	ld hl, Volcano1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Volcano1FText0_Battle:
	TX_FAR _Volcano1FText0_Battle
	db "@"

Volcano1FText0_EndBattle:
	TX_FAR _Volcano1FText0_EndBattle
	db "@"

Volcano1FText0_AfterBattle:
	TX_FAR _Volcano1FText0_AfterBattle
	db "@"

Volcano1FText_Trainer1:
	TX_ASM
	ld hl, Volcano1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Volcano1FText1_Battle:
	TX_FAR _Volcano1FText1_Battle
	db "@"

Volcano1FText1_EndBattle:
	TX_FAR _Volcano1FText1_EndBattle
	db "@"

Volcano1FText1_AfterBattle:
	TX_FAR _Volcano1FText1_AfterBattle
	db "@"

Volcano1FText_Trainer2:
	TX_ASM
	ld hl, Volcano1FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Volcano1FText2_Battle:
	TX_FAR _Volcano1FText2_Battle
	db "@"

Volcano1FText2_EndBattle:
	TX_FAR _Volcano1FText2_EndBattle
	db "@"

Volcano1FText2_AfterBattle:
	TX_FAR _Volcano1FText2_AfterBattle
	db "@"

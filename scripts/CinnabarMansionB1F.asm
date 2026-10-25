MansionB1FScript:
	call MansionB1FScript_523cf
	call EnableAutoTextBoxDrawing
	ld hl, MansionB1FTrainerHeader0
	ld de, MansionB1FScriptPointers
	ld a, [wMansionB1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMansionB1FCurScript], a
	ret

MansionB1FScript_523cf:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .asm_523ff
	ld a, $e
	ld bc, $80d
	call Mansion2FScript_5202f
	ld a, $e
	ld bc, $b06
	call Mansion2FScript_5202f
	ld a, $5f
	ld bc, $304
	call Mansion2FScript_5202f
	ld a, $54
	ld bc, $808
	call Mansion2FScript_5202f
	ret
.asm_523ff
	ld a, $2d
	ld bc, $80d
	call Mansion2FScript_5202f
	ld a, $5f
	ld bc, $b06
	call Mansion2FScript_5202f
	ld a, $e
	ld bc, $304
	call Mansion2FScript_5202f
	ld a, $e
	ld bc, $808
	call Mansion2FScript_5202f
	ret

MansionB1FScript_Switches:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ld [hJoyHeld], a
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

MansionB1FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

MansionB1FTextPointers:
	dw MansionB1FText1
	dw MansionB1FText2
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw MansionB1FText7
	dw PickUpItemText
	dw Mansion3FText6

MansionB1FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CINNABAR_MANSION_B1F_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CINNABAR_MANSION_B1F_TRAINER_0
	dw MansionB1FBattleText1 ; TextBeforeBattle
	dw MansionB1FAfterBattleText1 ; TextAfterBattle
	dw MansionB1FEndBattleText1 ; TextEndBattle
	dw MansionB1FEndBattleText1 ; TextEndBattle

MansionB1FTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_CINNABAR_MANSION_B1F_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CINNABAR_MANSION_B1F_TRAINER_1
	dw MansionB1FBattleText2 ; TextBeforeBattle
	dw MansionB1FAfterBattleText2 ; TextAfterBattle
	dw MansionB1FEndBattleText2 ; TextEndBattle
	dw MansionB1FEndBattleText2 ; TextEndBattle

	db $ff

MansionB1FText1:
	TX_ASM
	ld hl, MansionB1FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

MansionB1FText2:
	TX_ASM
	ld hl, MansionB1FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

MansionB1FBattleText1:
	TX_FAR _MansionB1FBattleText1
	db "@"

MansionB1FEndBattleText1:
	TX_FAR _MansionB1FEndBattleText1
	db "@"

MansionB1FAfterBattleText1:
	TX_FAR _MansionB1FAfterBattleText1
	db "@"

MansionB1FBattleText2:
	TX_FAR _MansionB1FBattleText2
	db "@"

MansionB1FEndBattleText2:
	TX_FAR _MansionB1FEndBattleText2
	db "@"

MansionB1FAfterBattleText2:
	TX_FAR _MansionB1FAfterBattleText2
	db "@"

MansionB1FText7:
	TX_FAR _MansionB1FText7
	db "@"

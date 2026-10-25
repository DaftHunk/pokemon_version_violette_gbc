Mansion2FScript:
	call Mansion2FScript_51fee
	call EnableAutoTextBoxDrawing
	ld hl, Mansion2FTrainerHeader0
	ld de, Mansion2FScriptPointers
	ld a, [wMansion2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMansion2FCurScript], a
	ret

Mansion2FScript_51fee:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .asm_52016
	ld a, $e
	lb bc, 2, 4
	call Mansion2FScript_5202f
	ld a, $54
	lb bc, 4, 9
	call Mansion2FScript_5202f
	ld a, $5f
	lb bc, 11, 3
	call Mansion2FScript_5202f
	ret
.asm_52016
	ld a, $5f
	lb bc, 2, 4
	call Mansion2FScript_5202f
	ld a, $e
	lb bc, 4, 9
	call Mansion2FScript_5202f
	ld a, $e
	lb bc, 11, 3
	call Mansion2FScript_5202f
	ret

Mansion2FScript_5202f:
	ld [wNewTileBlockID], a
	predef_jump ReplaceTileBlock

Mansion2FScript_Switches:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ld [hJoyHeld], a
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

Mansion2FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Mansion2FTextPointers:
	dw Mansion2FText1
	dw PickUpItemText
	dw Mansion2FText3
	dw Mansion2FText4
	dw Mansion2FText5

Mansion2FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CINNABAR_MANSION_2F_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CINNABAR_MANSION_2F_TRAINER_0
	dw Mansion2FBattleText1 ; TextBeforeBattle
	dw Mansion2FAfterBattleText1 ; TextAfterBattle
	dw Mansion2FEndBattleText1 ; TextEndBattle
	dw Mansion2FEndBattleText1 ; TextEndBattle

	db $ff

Mansion2FText1:
	TX_ASM
	ld hl, Mansion2FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Mansion2FBattleText1:
	TX_FAR _Mansion2FBattleText1
	db "@"

Mansion2FEndBattleText1:
	TX_FAR _Mansion2FEndBattleText1
	db "@"

Mansion2FAfterBattleText1:
	TX_FAR _Mansion2FAfterBattleText1
	db "@"

Mansion2FText3:
	TX_FAR _Mansion2FText3
	db "@"

Mansion2FText4:
	TX_FAR _Mansion2FText4
	db "@"

Mansion3FText6:
Mansion2FText5:
	TX_ASM
	ld hl, Mansion2FText_520c2
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_520b9
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld hl, Mansion2FText_520c7
	call PrintText
	ld a, SFX_GO_INSIDE
	call PlaySound
	CheckAndSetEvent EVENT_MANSION_SWITCH_ON
	jr z, .asm_520bf
	ResetEventReuseHL EVENT_MANSION_SWITCH_ON
	jr .asm_520bf
.asm_520b9
	ld hl, Mansion2FText_520cc
	call PrintText
.asm_520bf
	jp TextScriptEnd

Mansion2FText_520c2:
	TX_FAR _Mansion2FText_520c2
	db "@"

Mansion2FText_520c7:
	TX_FAR _Mansion2FText_520c7
	db "@"

Mansion2FText_520cc:
	TX_FAR _Mansion2FText_520cc
	db "@"

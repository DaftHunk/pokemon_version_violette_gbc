Mansion3FScript:
	call Mansion3FScript_52204
	call EnableAutoTextBoxDrawing
	ld hl, Mansion3FTrainerHeader0
	ld de, Mansion3FScriptPointers
	ld a, [wMansion3FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMansion3FCurScript], a
	ret

Mansion3FScript_52204:
	ld hl, wCurrentMapScriptFlags
	bit BIT_CUR_MAP_LOADED_1, [hl]
	res BIT_CUR_MAP_LOADED_1, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .asm_52224
	ld a, $e
	ld bc, $207
	call Mansion2FScript_5202f
	ld a, $5f
	ld bc, $507
	call Mansion2FScript_5202f
	ret
.asm_52224
	ld a, $5f
	ld bc, $207
	call Mansion2FScript_5202f
	ld a, $e
	ld bc, $507
	call Mansion2FScript_5202f
	ret

Mansion3FScriptPointers:
	dw Mansion3FScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Mansion3FScript0:
	ld hl, CoordsData_52254
	call Mansion3FScript_5225b
	ld a, [wWhichDungeonWarp]
	and a
	jp z, CheckFightingMapTrainers
	cp $3
	ld a, $a5
	jr nz, .asm_52250
	ld a, $d6
.asm_52250
	ld [wDungeonWarpDestinationMap], a
	ret

CoordsData_52254:
	db $0E,$10
	db $0E,$11
	db $0E,$13
	db $FF

Mansion3FScript_5225b:
	xor a
	ld [wWhichDungeonWarp], a
	ld a, [wStatusFlags3]
	bit 4, a
	ret nz
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wCoordIndex]
	ld [wWhichDungeonWarp], a
	ld hl, wStatusFlags3
	set 4, [hl]
	ld hl, wStatusFlags6
	set 4, [hl]
	ret

Mansion3FScript_Switches:
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ld [hJoyHeld], a
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

Mansion3FTextPointers:
	dw Mansion3FText1
	dw Mansion3FText2
	dw PickUpItemText
	dw PickUpItemText
	dw Mansion3FText5
	dw Mansion3FText6

Mansion3FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CINNABAR_MANSION_3F_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CINNABAR_MANSION_3F_TRAINER_0
	dw Mansion3FBattleText1 ; TextBeforeBattle
	dw Mansion3FAfterBattleText1 ; TextAfterBattle
	dw Mansion3FEndBattleText1 ; TextEndBattle
	dw Mansion3FEndBattleText1 ; TextEndBattle

Mansion3FTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_CINNABAR_MANSION_3F_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CINNABAR_MANSION_3F_TRAINER_1
	dw Mansion3FBattleText2 ; TextBeforeBattle
	dw Mansion3FAfterBattleText2 ; TextAfterBattle
	dw Mansion3FEndBattleText2 ; TextEndBattle
	dw Mansion3FEndBattleText2 ; TextEndBattle

	db $ff

Mansion3FText1:
	TX_ASM
	ld hl, Mansion3FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Mansion3FText2:
	TX_ASM
	ld hl, Mansion3FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Mansion3FBattleText1:
	TX_FAR _Mansion3FBattleText1
	db "@"

Mansion3FEndBattleText1:
	TX_FAR _Mansion3FEndBattleText1
	db "@"

Mansion3FAfterBattleText1:
	TX_FAR _Mansion3FAfterBattleText1
	db "@"

Mansion3FBattleText2:
	TX_FAR _Mansion3FBattleText2
	db "@"

Mansion3FEndBattleText2:
	TX_FAR _Mansion3FEndBattleText2
	db "@"

Mansion3FAfterBattleText2:
	TX_FAR _Mansion3FAfterBattleText2
	db "@"

Mansion3FText5:
	TX_FAR _Mansion3FText5
	db "@"

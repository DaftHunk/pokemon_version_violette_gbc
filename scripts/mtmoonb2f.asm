MtMoonB2FScript:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonB2FTrainerHeader0
	ld de, MtMoonB2FScriptPointers
	ld a, [wMtMoonB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonB2FCurScript], a
;joenote - Intent here is probably to keep encounters from ruining the moment of choosing your fossil prize
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	ret z
	ld hl, CoordsData_49d37
	call ArePlayerCoordsInArray
	jr nc, .asm_49d31

	;joenote - this is fixes a bug.
	ld hl, wd732
	bit 3, [hl]
	jr nz, .asm_49d31
	;If a fly warp his happening (dig, teleport, escape rope, etc) clear the no-battle bit.
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	jr nz, .asm_49d31	;let's keep encounters on once the big moment is over
	ld hl, wd72e
	set 4, [hl]
	ret
.asm_49d31
	ld hl, wd72e
	res 4, [hl]
	ret

CoordsData_49d37:
	db $05,$0B
	db $05,$0C
	db $05,$0D
	db $05,$0E
	db $06,$0B
	db $06,$0C
	db $06,$0D
	db $06,$0E
	db $07,$0B
	db $07,$0C
	db $07,$0D
	db $07,$0E
	db $08,$0B
	db $08,$0C
	db $08,$0D
	db $08,$0E
	db $FF

MtMoonB2FScript_49d58:
	xor a
	ld [wJoyIgnore], a
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB2FScriptPointers:
	dw MtMoonB2FScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw MtMoonB2FScript3
	dw MtMoonB2FScript4
	dw MtMoonB2FScript5

MtMoonB2FScript0:
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jp nz, MtMoonB2FScript_49d91
	ld a, [wYCoord]
	cp $8
	jp nz, MtMoonB2FScript_49d91
	ld a, [wXCoord]
	cp $d
	jp nz, MtMoonB2FScript_49d91
	xor a
	ld [hJoyHeld], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

MtMoonB2FScript_49d91:
	jp CheckFightingMapTrainers

MtMoonB2FScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoonB2FScript_49d58
	call UpdateSprites
	call Delay3
	SetEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB2FScript4:
	ld a, $1
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld hl, CoordsData_49dea
	call ArePlayerCoordsInArray
	jr c, .asm_49dd7
	ld hl, CoordsData_49df1
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	ld de, MovementData_49df9
	jr .asm_49dda
.asm_49dd7
	ld de, MovementData_49df8
.asm_49dda
	ld a, $1
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, $5
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

CoordsData_49dea:
	db $07,$0C
	db $06,$0B
	db $05,$0C
	db $FF

CoordsData_49df1:
	db $07,$0D
	db $06,$0E
	db $05,$0E
	db $FF

MovementData_49df8:
	db NPC_MOVEMENT_RIGHT

MovementData_49df9:
	db NPC_MOVEMENT_UP,$FF

MtMoonB2FScript5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr z, .asm_49e1d
	ld a, HS_MT_MOON_B2F_FOSSIL_2
	jr .asm_49e1f
.asm_49e1d
	ld a, HS_MT_MOON_B2F_FOSSIL_1
.asm_49e1f
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB2FTextPointers:
	dw MtMoonB2FText1
	dw MtMoonB2FText2
	dw MtMoonB2FText3
	dw MtMoonB2FText4
	dw MtMoonB2FText5
	dw MtMoonB2FText6
	dw MtMoonB2FText7
	dw PickUpItemText
	dw PickUpItemText
	dw MtMoonB2FText_49f99

MtMoonB2FTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_MT_MOON_B2F_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_B2F_TRAINER_0
	dw MtMoonB2FBattleText2 ; TextBeforeBattle
	dw MtMoonB2FAfterBattleText2 ; TextAfterBattle
	dw MtMoonB2FEndBattleText2 ; TextEndBattle
	dw MtMoonB2FEndBattleText2 ; TextEndBattle

MtMoonB2FTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_MT_MOON_B2F_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_B2F_TRAINER_1
	dw MtMoonB2FBattleText3 ; TextBeforeBattle
	dw MtMoonB2FAfterBattleText3 ; TextAfterBattle
	dw MtMoonB2FEndBattleText3 ; TextEndBattle
	dw MtMoonB2FEndBattleText3 ; TextEndBattle

MtMoonB2FTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_MT_MOON_B2F_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_B2F_TRAINER_2
	dw MtMoonB2FBattleText4 ; TextBeforeBattle
	dw MtMoonB2FAfterBattleText4 ; TextAfterBattle
	dw MtMoonB2FEndBattleText4 ; TextEndBattle
	dw MtMoonB2FEndBattleText4 ; TextEndBattle

MtMoonB2FTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_MT_MOON_B2F_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MT_MOON_B2F_TRAINER_3
	dw MtMoonB2FBattleText5 ; TextBeforeBattle
	dw MtMoonB2FAfterBattleText5 ; TextAfterBattle
	dw MtMoonB2FEndBattleText5 ; TextEndBattle
	dw MtMoonB2FEndBattleText5 ; TextEndBattle

	db $ff

MtMoonB2FText1:
	TX_ASM
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jr z, .asm_49e8d
	and $c0
	jr nz, .asm_49eb8
	ld hl, MtMoonB2FText_49f8f
	call PrintText
	jr .asm_49ebe
.asm_49e8d
	ld hl, MtMoonB2FText_49f85
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, MtMoonB2FText_49f8a
	ld de, MtMoonB2FText_49f8a
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	jr .asm_49ebe
.asm_49eb8
;;;;;;;joenote - have a rematch?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .norematch
	ld hl, wd72e
	res 4, [hl]
	jr .asm_49e8d
.norematch
;;;;;;;
	ld hl, MtMoonB2FText_49f94
	call PrintText
.asm_49ebe
	jp TextScriptEnd

MtMoonB2FText2:
	TX_ASM
	ld hl, MtMoonB2FTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB2FText3:
	TX_ASM
	ld hl, MtMoonB2FTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB2FText4:
	TX_ASM
	ld hl, MtMoonB2FTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB2FText5:
	TX_ASM
	ld hl, MtMoonB2FTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

MtMoonB2FText6:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MtMoonB2FText_49f24
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_49f21
	lb bc, DOME_FOSSIL, 1
	call GiveItem
	jp nc, MtMoonB2FScript_49f76
	call MtMoonB2FScript_49f69
	ld a, HS_MT_MOON_B2F_FOSSIL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_DOME_FOSSIL
	ld a, $4
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
.asm_49f21
	jp TextScriptEnd

MtMoonB2FText_49f24:
	TX_FAR _MtMoonB2FText_49f24
	db "@"

MtMoonB2FText7:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MtMoonB2FText_49f64
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_49f61
	lb bc, HELIX_FOSSIL, 1
	call GiveItem
	jp nc, MtMoonB2FScript_49f76
	call MtMoonB2FScript_49f69
	ld a, HS_MT_MOON_B2F_FOSSIL_2
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_HELIX_FOSSIL
	ld a, $4
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
.asm_49f61
	jp TextScriptEnd

MtMoonB2FText_49f64:
	TX_FAR _MtMoonB2FText_49f64
	db "@"

MtMoonB2FScript_49f69:
	ld hl, MtMoonB2FText_49f6f
	jp PrintText

MtMoonB2FText_49f6f:
	TX_FAR _MtMoonB2FText_49f6f
	TX_SFX_KEY_ITEM
	TX_WAIT
	db "@"

MtMoonB2FScript_49f76:
	ld hl, MtMoonB2FText_49f7f
	call PrintText
	jp TextScriptEnd

MtMoonB2FText_49f7f:
	TX_FAR _MtMoonB2FText_49f7f
	TX_WAIT
	db "@"

MtMoonB2FText_49f85:
	TX_FAR _MtMoonB2FText_49f85
	db "@"

MtMoonB2FText_49f8a:
	TX_FAR _MtMoonB2FText_49f8a
	db "@"

MtMoonB2FText_49f8f:
	TX_FAR _MtMoonB2FText_49f8f
	db "@"

MtMoonB2FText_49f94:
	TX_FAR _MtMoonB2FText_49f94
	db "@"

MtMoonB2FText_49f99:
	TX_FAR _MtMoonB2FText_49f99
	TX_SFX_KEY_ITEM
	db "@"

MtMoonB2FBattleText2:
	TX_FAR _MtMoonB2FBattleText2
	db "@"

MtMoonB2FEndBattleText2:
	TX_FAR _MtMoonB2FEndBattleText2
	db "@"

MtMoonB2FAfterBattleText2:
	TX_FAR _MtMoonB2FAfterBattleText2
	db "@"

MtMoonB2FBattleText3:
	TX_FAR _MtMoonB2FBattleText3
	db "@"

MtMoonB2FEndBattleText3:
	TX_FAR _MtMoonB2FEndBattleText3
	db "@"

MtMoonB2FAfterBattleText3:
	TX_FAR _MtMoonB2FAfterBattleText3
	db "@"

MtMoonB2FBattleText4:
	TX_FAR _MtMoonB2FBattleText4
	db "@"

MtMoonB2FEndBattleText4:
	TX_FAR _MtMoonB2FEndBattleText4
	db "@"

MtMoonB2FAfterBattleText4:
	TX_FAR _MtMoonB2FAfterBattleText4
	db "@"

MtMoonB2FBattleText5:
	TX_FAR _MtMoonB2FBattleText5
	db "@"

MtMoonB2FEndBattleText5:
	TX_FAR _MtMoonB2FEndBattleText5
	db "@"

MtMoonB2FAfterBattleText5:
	TX_FAR _MtMoonB2FAfterBattleText5
	db "@"

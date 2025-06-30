RivalScript:
	call EnableAutoTextBoxDrawing
	ld hl, RivalScriptPointers
	ld a, [wRivalCurScript]
	jp CallFunctionInTable

ResetRivalScript:
	xor a
	ld [wJoyIgnore], a
	ld [wRivalCurScript], a
	ret

RivalScriptPointers:
	dw RivalScript0
	dw RivalScript1
	dw RivalScript2
	dw RivalScript3
	dw RivalScript4
	dw RivalScript5
	dw RivalScript6
	dw RivalScript7
	dw RivalScript8
	dw RivalScript9
	dw RivalScript10

RivalScript0:
	ret

RivalScript1:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RivalEntrance_RLEMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $2
	ld [wRivalCurScript], a
	ret

RivalEntrance_RLEMovement:
	db D_UP,1
	db D_RIGHT,1
	db D_UP,3
	db $ff

RivalScript2:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld a, 9
	ld [wGymLeaderNo], a	;joenote - manually set final battle music
	ld hl, wFlags_D733
	set 5, [hl]	;joenote - set a flag to tell the battle engine that this is the final boss
	ld hl, wOptions
	res 7, [hl]  ; Turn on battle animations to make the battle feel more epic.
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3

	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, RivalDefeatedText
	ld de, RivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL3
	ld [wCurOpponent], a
	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotStarter2
	ld a, $1
	jr .saveTrainerId
.NotStarter2
	cp STARTER3
	jr nz, .NotStarter3
	ld a, $2
	jr .saveTrainerId
.NotStarter3
	ld a, $3
	jr .saveTrainerId
.leaderFightAfterElite4
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, RematchRivalDefeatedText
	ld de, RivalVictoryText
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL3
	ld [wCurOpponent], a
	ld a, $4
	jr .saveTrainerId
.saveTrainerId
	ld [wTrainerNo], a

	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wRivalCurScript], a
	ret

RivalScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetRivalScript
	call UpdateSprites
	SetEvent EVENT_BEAT_CHAMPION_RIVAL
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call RivalScript_760c8
	ld a, $1
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld a, $4
	ld [wRivalCurScript], a
	ret

RivalScript4:
	callba Music_Cities1AlternateTempo
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call RivalScript_760c8
	ld a, $2
	ld [H_SPRITEINDEX], a
	call SetSpriteMovementBytesToFF
	ld de, OakEntranceAfterVictoryMovement
	ld a, $2
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject2
	ld a, $5
	ld [wRivalCurScript], a
	ret

OakEntranceAfterVictoryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

RivalScript5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_LEFT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $2
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call RivalScript_760c8
	ld a, $6
	ld [wRivalCurScript], a
	ret

RivalScript6:
	ld a, $2
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_RIGHT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call RivalScript_760c8
	ld a, $7
	ld [wRivalCurScript], a
	ret

RivalScript7:
	ld a, $2
	ld [H_SPRITEINDEX], a
	xor a ; SPRITE_FACING_DOWN
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call RivalScript_760c8
	ld de, OakExitRivalRoomMovement
	ld a, $2
	ld [H_SPRITEINDEX], a
	call MoveSprite
	ld a, $8
	ld [wRivalCurScript], a
	ret

OakExitRivalRoomMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db $FF

RivalScript8:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $9
	ld [wRivalCurScript], a
	ret

RivalScript9:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, WalkToHallOfFame_RLEMovment
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $a
	ld [wRivalCurScript], a
	ret

WalkToHallOfFame_RLEMovment:
	db D_UP,4
	db D_LEFT,1
	db $ff

RivalScript10:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wRivalCurScript], a
	ret

RivalScript_760c8:
	ld a, $f0
	ld [wJoyIgnore], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

RivalTextPointers:
	dw RivalMainText
	dw OakCallOutroText
	dw OakOutroText
	dw OakRivalOutroText
	dw OakFollowOutroText

RivalMainText:
	TX_ASM

	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	jr nz, .afterBattle

	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .introRemath

	jr .introBattle
.introBattle
	ld hl, RivalChampionIntroText
	jr .printText
.introRemath
	ld hl, RematchRivalChampionIntroText
	jr .printText
.afterBattle
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .afterRemath

	ld hl, RivalText_AfterBattle
	jr .printText
.afterRemath
	ld hl, RematchRivalText_AfterCombatText
	jr .printText
.printText
	call PrintText
	jp TextScriptEnd

RivalChampionIntroText:
	TX_FAR _RivalChampionIntroText
	db "@"

RivalDefeatedText:
	TX_FAR _RivalDefeatedText
	db "@"

RivalVictoryText:
	TX_FAR _RivalVictoryText
	db "@"

RivalText_AfterBattle:
	TX_FAR _RivalText_AfterBattle
	db "@"

RematchRivalChampionIntroText:
	TX_FAR _RematchRivalChampionIntroText
	db "@"

RematchRivalDefeatedText:
	TX_FAR _RematchRivalDefeatedText
	db "@"

RematchRivalText_AfterCombatText:
	TX_FAR _RematchRivalText_AfterCombatText
	db "@"

OakCallOutroText:
	TX_FAR _OakCallOutroText
	db "@"

OakOutroText:
	TX_ASM
	ld a, [wPlayerStarter]
	ld [wPokedexNum], a
	call GetMonName

	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .afterRemath
	; else
	ld hl, .oakCongratOutroText
	jr .printText
.afterRemath
	ld hl, .rematchOakCongratOutroText
	; fallthrough
.printText
	call PrintText
	jp TextScriptEnd

.oakCongratOutroText:
	TX_FAR _OakCongratOutroText
	db "@"
.rematchOakCongratOutroText:
	TX_FAR _RematchOakCongratOutroText
	db "@"

OakRivalOutroText:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .afterRemath
	; else
	ld hl, .oakRivalOutroText
	jr .printText
.afterRemath
	ld hl, .rematchOakRivalOutroText
	; fallthrough
.printText
	call PrintText
	jp TextScriptEnd

.oakRivalOutroText
	TX_FAR _OakRivalOutroText
	db "@"
.rematchOakRivalOutroText
	TX_FAR _RematchOakRivalOutroText
	db "@"

OakFollowOutroText:
	TX_FAR _OakFollowOutroText
	db "@"

FightingDojoScript:
	call EnableAutoTextBoxDrawing
	ld hl, FightingDojoTrainerHeader0
	ld de, FightingDojoScriptPointers
	ld a, [wFightingDojoCurScript]
	call ExecuteCurMapScriptInTable
	ld [wFightingDojoCurScript], a
	ret

FightingDojoScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	ret

FightingDojoScriptPointers:
	dw FightingDojoScript_Main
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw FightingDojoScript_AfterBattle

FightingDojoScript_Main:
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	ret nz
	call CheckFightingMapTrainers
	ld a, [wTrainerHeaderFlagBit]
	and a
	ret nz
	CheckEvent EVENT_BEAT_KOICHI
	ret nz
	xor a
	ld [hJoyHeld], a
	ld [wcf0d], a
	ld a, [wYCoord]
	cp $3
	ret nz
	ld a, [wXCoord]
	cp $4
	ret nz
	ld a, $1
	ld [wcf0d], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_LEFT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ret

FightingDojoScript_AfterBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, FightingDojoScript_Reset
	ld a, [wcf0d]
	and a
	jr z, .choosePokemon
	; are we in rematch ?
	CheckEvent EVENT_BEAT_KOICHI
	jr nz, .chooseRematchPokemon
	; else
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_LEFT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
; fallthrough
.choosePokemon
	ld a, $f0
	ld [wJoyIgnore], a
	SetEventRange EVENT_BEAT_KOICHI, EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	ld a, $8
	jr .endScript

.chooseRematchPokemon
	ld a, $f0
	ld [wJoyIgnore], a
	SetEvent EVENT_BEAT_KOICHI_REMATCH
	ld a, $9
; fallthrough
.endScript
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	ret

FightingDojoTextPointers:
	dw FightingDojoText1
	dw FightingDojoText2
	dw FightingDojoText3
	dw FightingDojoText4
	dw FightingDojoText5
	dw FightingDojoText_Hitmonlee
	dw FightingDojoText_Hitmonchan
	dw FightingDojoText_KoichiChoosePokemon
	dw FightingDojoText_RematchKoichiChoosePokemon

FightingDojoTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_0
	dw FightingDojoBattleText1 ; TextBeforeBattle
	dw FightingDojoAfterBattleText1 ; TextAfterBattle
	dw FightingDojoEndBattleText1 ; TextEndBattle
	dw FightingDojoEndBattleText1 ; TextEndBattle

FightingDojoTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	dw FightingDojoBattleText2 ; TextBeforeBattle
	dw FightingDojoAfterBattleText2 ; TextAfterBattle
	dw FightingDojoEndBattleText2 ; TextEndBattle
	dw FightingDojoEndBattleText2 ; TextEndBattle

FightingDojoTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_2
	dw FightingDojoBattleText3 ; TextBeforeBattle
	dw FightingDojoAfterBattleText3 ; TextAfterBattle
	dw FightingDojoEndBattleText3 ; TextEndBattle
	dw FightingDojoEndBattleText3 ; TextEndBattle

FightingDojoTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	dw FightingDojoBattleText4 ; TextBeforeBattle
	dw FightingDojoAfterBattleText4 ; TextAfterBattle
	dw FightingDojoEndBattleText4 ; TextEndBattle
	dw FightingDojoEndBattleText4 ; TextEndBattle

	db $ff

FightingDojoText1:
	TX_ASM
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	jp nz, .continue1
	CheckEventReuseA EVENT_BEAT_KOICHI
	jp nz, .continue2

	ld hl, FightingDojoText_KoichiBattle
	call PrintText
	ld hl, wStatusFlags3
	set 6, [hl]
	set 7, [hl]
	ld hl, FightingDojoText_KoichiEndBattle
	ld de, FightingDojoText_KoichiEndBattle
	call SaveEndBattleTextPointers
	
	ld a, $8
	ld [wGymLeaderNo], a
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
;;;;joenote - added for rematch to skip choosing prize
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	jr .endScript
.continue1
;;;;;;;joenote - have a rematch with karate master?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .rematch
	ld hl, FightingDojoText_KoichiAfterBattle
	call PrintText
	jr .endScript
.continue2
	ld hl, FightingDojoText_KoichiChoosePokemon
	call PrintText
.endScript
	jp TextScriptEnd
.rematch
	ld hl, FightingDojoText_RematchKoichiBattle
	call PrintText
	ld hl, wStatusFlags3
	set 6, [hl]
	set 7, [hl]
	ld hl, FightingDojoText_RematchKoichiEndBattle
	ld de, FightingDojoText_RematchKoichiEndBattle
	call SaveEndBattleTextPointers
	
	ld a, $8
	ld [wGymLeaderNo], a
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters

	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	
	ld a, $3
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	jr .endScript


FightingDojoText_KoichiBattle:
	TX_FAR _FightingDojoText_KoichiBattle
	db "@"

FightingDojoText_KoichiEndBattle:
	TX_FAR _FightingDojoText_KoichiEndBattle
	db "@"

FightingDojoText_KoichiChoosePokemon:
	TX_FAR _FightingDojoText_KoichiChoosePokemon
	db "@"

FightingDojoText_RematchKoichiBattle:
	TX_FAR _FightingDojoText_RematchKoichiBattle
	db "@"

FightingDojoText_RematchKoichiEndBattle:
	TX_FAR _FightingDojoText_RematchKoichiEndBattle
	db "@"

FightingDojoText_RematchKoichiChoosePokemon:
	TX_FAR _FightingDojoText_RematchKoichiChoosePokemon
	db "@"

FightingDojoText_KoichiAfterBattle:
	TX_FAR _FightingDojoText_KoichiAfterBattle
	db "@"

FightingDojoText2:
	TX_ASM
	ld hl, FightingDojoTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText1:
	TX_FAR _FightingDojoBattleText1
	db "@"

FightingDojoEndBattleText1:
	TX_FAR _FightingDojoEndBattleText1
	db "@"

FightingDojoAfterBattleText1:
	TX_FAR _FightingDojoAfterBattleText1
	db "@"

FightingDojoText3:
	TX_ASM
	ld hl, FightingDojoTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText2:
	TX_FAR _FightingDojoBattleText2
	db "@"

FightingDojoEndBattleText2:
	TX_FAR _FightingDojoEndBattleText2
	db "@"

FightingDojoAfterBattleText2:
	TX_FAR _FightingDojoAfterBattleText2
	db "@"

FightingDojoText4:
	TX_ASM
	ld hl, FightingDojoTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText3:
	TX_FAR _FightingDojoBattleText3
	db "@"

FightingDojoEndBattleText3:
	TX_FAR _FightingDojoEndBattleText3
	db "@"

FightingDojoAfterBattleText3:
	TX_FAR _FightingDojoAfterBattleText3
	db "@"

FightingDojoText5:
	TX_ASM
	ld hl, FightingDojoTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText4:
	TX_FAR _FightingDojoBattleText4
	db "@"

FightingDojoEndBattleText4:
	TX_FAR _FightingDojoEndBattleText4
	db "@"

FightingDojoAfterBattleText4:
	TX_FAR _FightingDojoAfterBattleText4
	db "@"

FightingDojoText_Hitmonlee:
; Hitmonlee Poké Ball
	TX_ASM
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, .GetMon
	; If rematch is done, offer the second one
	CheckEvent EVENT_BEAT_KOICHI_REMATCH
	jr nz, .GetMon
	; else
	ld hl, OtherHitmonText
	call PrintText
	jr .done
.GetMon
	ld a, HITMONLEE
	call DisplayPokedex
	ld hl, WantHitmonleeText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	ld a, [wcf91]
	ld b, a
	ld c, 35
	call GivePokemon
	jr nc, .done

	; once Poké Ball is taken, hide sprite
	ld a, HS_FIGHTING_DOJO_GIFT_1
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvents EVENT_GOT_HITMONLEE, EVENT_DEFEATED_FIGHTING_DOJO
.done
	jp TextScriptEnd

WantHitmonleeText:
	TX_FAR _WantHitmonleeText
	db "@"

FightingDojoText_Hitmonchan:
; Hitmonchan Poké Ball
	TX_ASM
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, .GetMon
	; If rematch is done, offer the second one
	CheckEvent EVENT_BEAT_KOICHI_REMATCH
	jr nz, .GetMon
	; else
	ld hl, OtherHitmonText
	call PrintText
	jr .done
.GetMon
	ld a, HITMONCHAN
	call DisplayPokedex
	ld hl, WantHitmonchanText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	ld a, [wcf91]
	ld b, a
	ld c, 35
	call GivePokemon
	jr nc, .done
	SetEvents EVENT_GOT_HITMONCHAN, EVENT_DEFEATED_FIGHTING_DOJO

	; once Poké Ball is taken, hide sprite
	ld a, HS_FIGHTING_DOJO_GIFT_2
	ld [wMissableObjectIndex], a
	predef HideObject
.done
	jp TextScriptEnd

WantHitmonchanText:
	TX_FAR _WantHitmonchanText
	db "@"

OtherHitmonText:
	TX_FAR _OtherHitmonText
	db "@"

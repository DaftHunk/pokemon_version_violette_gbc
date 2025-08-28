CinnabarGymScript:
	call CinnabarGymScript_75759
	call EnableAutoTextBoxDrawing
	ld hl, CinnabarGymScriptPointers
	ld a, [wCinnabarGymCurScript]
	jp CallFunctionInTable

CinnabarGymScript_75759:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, CinnabarGymScript_Header
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, UpdateCinnabarGymGateTileBlocks
	ResetEvent EVENT_2A7
	ret
CinnabarGymScript_Header:
	ld hl, Gym7CityName
	ld de, Gym7LeaderName
	jp LoadGymLeaderAndCityName

Gym7CityName:
	db "Cramois'Ile@"
Gym7LeaderName:
	db "Auguste@"

CinnabarGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ld [wOpponentAfterWrongAnswer], a
	ret

CinnabarGymScript_757a0:
	ld a, [hSpriteIndexOrTextID]
	ld [wTrainerHeaderFlagBit], a
	ret

CinnabarGymScriptPointers:
	dw CinnabarGymScript_MapTrainers
	dw CinnabarGymScript_DisplayText
	dw CinnabarGymScript_EndTrainerBattle
	dw CinnabarGymScript_Battle

CinnabarGymScript_MapTrainers:
	ld a, [wOpponentAfterWrongAnswer]
	and a
	ret z
	ld [H_SPRITEINDEX], a
	cp $4
	jr nz, .asm_757c3
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld de, MovementData_757d7
	jr .asm_757cb
.asm_757c3
	ld de, MovementData_757da
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
.asm_757cb
	call MoveSprite
	ld a, $1
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ret

MovementData_757d7:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db $FF

MovementData_757da:
	db NPC_MOVEMENT_LEFT
	db $FF

CinnabarGymScript_DisplayText:
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, [wOpponentAfterWrongAnswer]
	ld [wTrainerHeaderFlagBit], a
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

CinnabarGymFlagAction:
	predef_jump FlagActionPredef

CinnabarGymScript_EndTrainerBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CinnabarGymScript_Reset
	ld a, [wTrainerHeaderFlagBit]
	ld [$ffdb], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call CinnabarGymFlagAction
	ld a, c
	and a
	jr nz, .asm_7581b
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
.asm_7581b
	ld a, [wTrainerHeaderFlagBit]
	ld [$ffdb], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call CinnabarGymFlagAction
	ld a, [wTrainerHeaderFlagBit]
	sub $2
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	call CinnabarGymFlagAction
	call UpdateCinnabarGymGateTileBlocks
	xor a
	ld [wJoyIgnore], a
	ld [wOpponentAfterWrongAnswer], a
	ld a, $0
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ret

CinnabarGymScript_Battle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CinnabarGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a
CinnabarGymScript_GiveTM:
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BLAINE
	lb bc, TM38_FIRE_BLAST, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM38
	jr .endScript
.bagFull
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 6, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CINNABAR_GYM_TRAINER_0, EVENT_BEAT_CINNABAR_GYM_TRAINER_6

	ld hl, wCurrentMapScriptFlags
	set 5, [hl]

	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .next ; no levelcaps
	; else
	; display new level cap to the player
	callfar GetLevelCap
	ld a, $d
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.next
	jp CinnabarGymScript_Reset

CinnabarGymTextPointers:
	dw CinnabarGymText_Blaine
	dw CinnabarGymText2
	dw CinnabarGymText3
	dw CinnabarGymText4
	dw CinnabarGymText5
	dw CinnabarGymText6
	dw CinnabarGymText7
	dw CinnabarGymText8
	dw CinnabarGymText_Guide
	dw BlaineBadgeText
	dw ReceivedTM38Text
	dw TM38NoRoomText
	dw CinnabarGymText_LevelCap

CinnabarGymScript_758b7:
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
;;;;joenote - rematches should not advance map script pointer
	CheckEvent EVENT_GOT_TM38
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wSpriteIndex]
	cp $1
	jr z, .asm_758d4
	ld a, $2
	jr .endScript
.asm_758d4
	ld a, $3
.endScript
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

CinnabarGymText_Blaine:
	TX_ASM
	CheckEvent EVENT_BEAT_BLAINE
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM38
	jr nz, .askForRematch
	call z, CinnabarGymScript_GiveTM
	call DisableWaitingAfterTextDisplay
	jp TextScriptEnd
.askForRematch
;;;;;;;joenote - have a rematch with gym leader?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .leaderFight
;;;;;;;
	CheckEitherEventSet EVENT_NEW_GAME_PLUS, EVENT_BEAT_BLAINE_REMATCH
	jp nz, CharizardTutor

	ld hl, BlaineFireBlastText
	call PrintText
	jp TextScriptEnd
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, BlaineBattleText
	call PrintText
	ld hl, BlaineEndBattleText
	ld de, BlaineEndBattleText
	call SaveEndBattleTextPointers
	ld a, $7
	ld [wGymLeaderNo], a
	jp CinnabarGymScript_758b7
.leaderFightAfterElite4
	ld hl, CinnabarGymText_RematchPreBattle
	call PrintText

	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CinnabarGymText_RematchEndBattle
	ld de, CinnabarGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $7
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	jp TextScriptEnd

BlaineBattleText:
	TX_FAR _BlaineBattleText
	db "@"

BlaineEndBattleText:
	TX_FAR _BlaineEndBattleText
	;joenote - now plays an unused item sfx for getting a badge
	TX_SFX_KEY_ITEM ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	TX_WAIT
	db "@"

BlaineFireBlastText:
	TX_ASM
	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .next ; no levelcaps
	; else
	; display new level cap to the player
	callfar GetLevelCap
	ld hl, CinnabarGymText_LevelCapWait
	call PrintText
.next
	ld hl, .LeaderAfterBattle
	call PrintText
	jp TextScriptEnd
.LeaderAfterBattle
	TX_FAR _BlaineFireBlastText
	db "@"

CinnabarGymText_LevelCapWait:
	TX_FAR _DisplayLevelCap
	TX_WAIT
	db "@"

CinnabarGymText_LevelCap:
	TX_FAR _DisplayLevelCap
	db "@"

BlaineBadgeText:
	TX_FAR _BlaineBadgeText
	db "@"

ReceivedTM38Text:
	TX_FAR _ReceivedTM38Text
	TX_SFX_ITEM_1
	TX_FAR _TM38ExplanationText
	db "@"

TM38NoRoomText:
	TX_FAR _TM38NoRoomText
	db "@"

CinnabarGymText_RematchPreBattle:
	TX_FAR _CinnabarGymText_RematchPreBattle
	db "@"

CinnabarGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_BLAINE_REMATCH
	ld hl, wBeatGymLeadersRematch
	set 6, [hl]
	
	ld hl, .cinnabarGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.cinnabarGymText_RematchEndBattle
	TX_FAR _CinnabarGymText_RematchEndBattle
	db "@"

CinnabarGymText2:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	jr nz, .asm_46bb4
.cinnabar_rematch0
	ld hl, CinnabarGymText_7595f
	call PrintText
	ld hl, CinnabarGymText_75964
	ld de, CinnabarGymText_75964
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_46bb4
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch0_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch0
.rematch0_end
;;;;;;;
	ld hl, CinnabarGymText_75969
	call PrintText
	jp TextScriptEnd

CinnabarGymText_7595f:
	TX_FAR _CinnabarGymText_7595f
	db "@"

CinnabarGymText_75964:
	TX_FAR _CinnabarGymText_75964
	db "@"

CinnabarGymText_75969:
	TX_FAR _CinnabarGymText_75969
	db "@"

CinnabarGymText3:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_1
	jr nz, .asm_4b406
.cinnabar_rematch1
	ld hl, CinnabarGymText_75994
	call PrintText
	ld hl, CinnabarGymText_75999
	ld de, CinnabarGymText_75999
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_4b406
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch1_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch1
.rematch1_end
;;;;;;;
	ld hl, CinnabarGymText_7599e
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75994:
	TX_FAR _CinnabarGymText_75994
	db "@"

CinnabarGymText_75999:
	TX_FAR _CinnabarGymText_75999
	db "@"

CinnabarGymText_7599e:
	TX_FAR _CinnabarGymText_7599e
	db "@"

CinnabarGymText4:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_2
	jr nz, .asm_c0673
.cinnabar_rematch2
	ld hl, CinnabarGymText_759c9
	call PrintText
	ld hl, CinnabarGymText_759ce
	ld de, CinnabarGymText_759ce
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_c0673
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch2_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch2
.rematch2_end
;;;;;;;
	ld hl, CinnabarGymText_759d3
	call PrintText
	jp TextScriptEnd

CinnabarGymText_759c9:
	TX_FAR _CinnabarGymText_759c9
	db "@"

CinnabarGymText_759ce:
	TX_FAR _CinnabarGymText_759ce
	db "@"

CinnabarGymText_759d3:
	TX_FAR _CinnabarGymText_759d3
	db "@"

CinnabarGymText5:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_3
	jr nz, .asm_5cfd7
.cinnabar_rematch3
	ld hl, CinnabarGymText_759fe
	call PrintText
	ld hl, CinnabarGymText_75a03
	ld de, CinnabarGymText_75a03
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_5cfd7
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch3_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch3
.rematch3_end
;;;;;;;
	ld hl, CinnabarGymText_75a08
	call PrintText
	jp TextScriptEnd

CinnabarGymText_759fe:
	TX_FAR _CinnabarGymText_759fe
	db "@"

CinnabarGymText_75a03:
	TX_FAR _CinnabarGymText_75a03
	db "@"

CinnabarGymText_75a08:
	TX_FAR _CinnabarGymText_75a08
	db "@"

CinnabarGymText6:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_4
	jr nz, .asm_776b4
.cinnabar_rematch4
	ld hl, CinnabarGymText_75a33
	call PrintText
	ld hl, CinnabarGymText_75a38
	ld de, CinnabarGymText_75a38
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_776b4
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch4_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch4
.rematch4_end
;;;;;;;
	ld hl, CinnabarGymText_75a3d
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75a33:
	TX_FAR _CinnabarGymText_75a33
	db "@"

CinnabarGymText_75a38:
	TX_FAR _CinnabarGymText_75a38
	db "@"

CinnabarGymText_75a3d:
	TX_FAR _CinnabarGymText_75a3d
	db "@"

CinnabarGymText7:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_5
	jr nz, .asm_2f755
.cinnabar_rematch5
	ld hl, CinnabarGymText_75a68
	call PrintText
	ld hl, CinnabarGymText_75a6d
	ld de, CinnabarGymText_75a6d
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_2f755
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch5_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch5
.rematch5_end
;;;;;;;
	ld hl, CinnabarGymText_75a72
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75a68:
	TX_FAR _CinnabarGymText_75a68
	db "@"

CinnabarGymText_75a6d:
	TX_FAR _CinnabarGymText_75a6d
	db "@"

CinnabarGymText_75a72:
	TX_FAR _CinnabarGymText_75a72
	db "@"

CinnabarGymText8:
	TX_ASM
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	jr nz, .asm_d87be
.cinnabar_rematch6
	ld hl, CinnabarGymText_75a9d
	call PrintText
	ld hl, CinnabarGymText_75aa2
	ld de, CinnabarGymText_75aa2
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_d87be
;;;;;;;joenote - have a rematch with trainer
	CheckEvent EVENT_GOT_TM38
	jr z, .rematch6_end
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cinnabar_rematch6
.rematch6_end
;;;;;;;
	ld hl, CinnabarGymText_75aa7
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75a9d:
	TX_FAR _CinnabarGymText_75a9d
	db "@"

CinnabarGymText_75aa2:
	TX_FAR _CinnabarGymText_75aa2
	db "@"

CinnabarGymText_75aa7:
	TX_FAR _CinnabarGymText_75aa7
	db "@"

CinnabarGymText_Guide:
	TX_ASM
	CheckEvent EVENT_BEAT_BLAINE
	jr nz, .arenaVictory
	ld hl, CinnabarGymText_GuideTip
	jr .endScript
.arenaVictory
	ld hl, CinnabarGymText_GuideVictory
.endScript
	call PrintText
	jp TextScriptEnd

CinnabarGymText_GuideTip:
	TX_FAR _CinnabarGymText_GuideTip
	db "@"

CinnabarGymText_GuideVictory:
	TX_FAR _CinnabarGymText_GuideVictory
	db "@"

CharizardTutor:
	ld a, [wPartyMon1Species]
	cp CHARIZARD
	jr nz, .displayBring

	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	call GBFadeOutToBlack
	ld a, DRAGON
	ld [wPartyMon1Type2], a

	ld a, SFX_GET_ITEM_2
	call PlaySound
	call WaitForSoundToFinish
	call GBFadeInFromBlack
	ld hl, .textAfter
	jr .textEnd
.displayBring
	ld hl, .textBring
	; fallthrough
.textEnd
	call PrintText
	jp TextScriptEnd
.textBring
	text "Amène-moi ton"
	line "Dracaufeu que je"
	cont "vois si je peux"
	cont "rendre son nom"
	cont "plus pertinent!"
	done
	db "@"
.textStart
	text "Quel panache!"
	line "Ton Dracaufeu est"
	cont "un digne repré-"
	cont "sentant de la"
	cont "race Draconique!"
	prompt
	db "@"
.textAfter
	text "Dracaufeu est"
	line "maintenant"
	cont "Feu/Dragon!"
	done
	db "@"

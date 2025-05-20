VermilionGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	push hl
	call nz, VermilionGymScript_Header
	pop hl
	bit 6, [hl]
	res 6, [hl]
	call nz, VermilionGymScript_DoorPuzzle
	call EnableAutoTextBoxDrawing
	ld hl, VermilionGymTrainerHeader0
	ld de, VermilionGymScriptPointers
	ld a, [wVermilionGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVermilionGymCurScript], a
	ret

VermilionGymScript_Header:
	ld hl, Gym3CityName
	ld de, Gym3LeaderName
	jp LoadGymLeaderAndCityName

Gym3CityName:
	db "Carmin sur mer@"

Gym3LeaderName:
	db "Major Bob@"

VermilionGymScript_DoorPuzzle:
	CheckEvent EVENT_2ND_LOCK_OPENED
	jr nz, .doorSFX
	ld a, $24
	jr .openDoor
.doorSFX
	ld a, SFX_GO_INSIDE
	call PlaySound
	ld a, $5
.openDoor
	ld [wNewTileBlockID], a
	lb bc, 2, 2
	predef_jump ReplaceTileBlock

VermilionGymScript_Reset:
	xor a
	ld [wJoyIgnore], a
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
	ret

VermilionGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw VermilionGymScript_Battle

VermilionGymScript_Battle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, VermilionGymScript_Reset
	ld a, $f0
	ld [wJoyIgnore], a

VermilionGymScript_GiveTM:
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_LT_SURGE
	lb bc, TM24_THUNDERBOLT, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $7
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM24
	jr .endScript
.bagFull
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 2, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VERMILION_GYM_TRAINER_0, EVENT_BEAT_VERMILION_GYM_TRAINER_2

	jp VermilionGymScript_Reset

VermilionGymTextPointers:
	dw VermilionGymText_MajorBob
	dw VermilionGymText_Trainer0
	dw VermilionGymText_Trainer1
	dw VermilionGymText_Trainer2
	dw VermilionGymText_Guide
	dw VermilionGymText_Badge
	dw VermilionGymText_ReceivedTM
	dw VermilionGymText_BagFull

VermilionGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VERMILION_GYM_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VERMILION_GYM_TRAINER_0
	dw VermilionGymText_Trainer0PreBattle ; TextBeforeBattle
	dw VermilionGymText_Trainer0AfterBattle ; TextAfterBattle
	dw VermilionGymText_Trainer0EndBattle ; TextEndBattle
	dw VermilionGymText_Trainer0EndBattle ; TextEndBattle

VermilionGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VERMILION_GYM_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VERMILION_GYM_TRAINER_1
	dw VermilionGymText_Trainer1PreBattle ; TextBeforeBattle
	dw VermilionGymText_Trainer1AfterBattle ; TextAfterBattle
	dw VermilionGymText_Trainer1EndBattle ; TextEndBattle
	dw VermilionGymText_Trainer1EndBattle ; TextEndBattle

VermilionGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VERMILION_GYM_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VERMILION_GYM_TRAINER_2
	dw VermilionGymText_Trainer2PreBattle ; TextBeforeBattle
	dw VermilionGymText_Trainer2AfterBattle ; TextAfterBattle
	dw VermilionGymText_Trainer2EndBattle ; TextEndBattle
	dw VermilionGymText_Trainer2EndBattle ; TextEndBattle

	db $ff

VermilionGymText_MajorBob:
	TX_ASM
	CheckEvent EVENT_BEAT_LT_SURGE
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM24
	jr nz, .askForRematch
	call z, VermilionGymScript_GiveTM
	call DisableWaitingAfterTextDisplay
	jp .endScript
.askForRematch
;;;;;;;joenote - have a rematch with gym leader?
	ld hl, RematchTrainerText
	call PrintText
	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .leaderFight
;;;;;;;
	CheckEvent EVENT_BEAT_LT_SURGE_REMATCH
	call nz, PikachuTutor

	ld hl, VermilionGymText_LeaderAfterBattle
	call PrintText
	jr .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, VermilionGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, VermilionGymText_LeaderEndBattle
	ld de, VermilionGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $3
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ld [hJoyHeld], a
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM24
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
	jr .endScript
.leaderFightAfterElite4
	ld hl, VermilionGymText_RematchPreBattle
	call PrintText

	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, VermilionGymText_RematchEndBattle
	ld de, VermilionGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $3
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, 2	;get the right roster
	ld [wTrainerNo], a
	xor a
	ld [hJoyHeld], a
	jr .endScript
.endScript
	jp TextScriptEnd

VermilionGymText_LeaderPreBattle:
	TX_FAR _VermilionGymText_LeaderPreBattle
	db "@"

VermilionGymText_LeaderAfterBattle:
	TX_FAR _VermilionGymText_LeaderAfterBattle
	db "@"

VermilionGymText_Badge:
	TX_FAR _VermilionGymText_Badge
	db "@"

VermilionGymText_ReceivedTM:
	TX_FAR _VermilionGymText_ReceivedTM
	;TX_SFX_KEY_ITEM	;joenote - wrong SFX played
	TX_SFX_ITEM_1
	TX_FAR _VermilionGymText_TMExplanation
	db "@"

VermilionGymText_BagFull:
	TX_FAR _VermilionGymText_BagFull
	db "@"

VermilionGymText_LeaderEndBattle:
	TX_FAR _VermilionGymText_LeaderEndBattle
	TX_SFX_KEY_ITEM	;joenote - play an unused sfx instead (triggered by playing GET_KEY_ITEM in battle)
	db "@"

VermilionGymText_RematchPreBattle:
	TX_FAR _VermilionGymText_RematchPreBattle
	db "@"

VermilionGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_LT_SURGE_REMATCH
	ld hl, wBeatGymLeadersRematch
	set 2, [hl]
	
	ld hl, .vermilionGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.vermilionGymText_RematchEndBattle
	TX_FAR _VermilionGymText_RematchEndBattle
	db "@"

VermilionGymText_Trainer0:
	TX_ASM
	ld hl, VermilionGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VermilionGymText_Trainer0PreBattle:
	TX_FAR _VermilionGymText_Trainer0PreBattle
	db "@"

VermilionGymText_Trainer0EndBattle:
	TX_FAR _VermilionGymText_Trainer0EndBattle
	db "@"

VermilionGymText_Trainer0AfterBattle:
	TX_FAR _VermilionGymText_Trainer0AfterBattle
	db "@"

VermilionGymText_Trainer1:
	TX_ASM
	ld hl, VermilionGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VermilionGymText_Trainer1PreBattle:
	TX_FAR _VermilionGymText_Trainer1PreBattle
	db "@"

VermilionGymText_Trainer1EndBattle:
	TX_FAR _VermilionGymText_Trainer1EndBattle
	db "@"

VermilionGymText_Trainer1AfterBattle:
	TX_FAR _VermilionGymText_Trainer1AfterBattle
	db "@"

VermilionGymText_Trainer2:
	TX_ASM
	ld hl, VermilionGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

VermilionGymText_Trainer2PreBattle:
	TX_FAR _VermilionGymText_Trainer2PreBattle
	db "@"

VermilionGymText_Trainer2EndBattle:
	TX_FAR _VermilionGymText_Trainer2EndBattle
	db "@"

VermilionGymText_Trainer2AfterBattle:
	TX_FAR _VermilionGymText_Trainer2AfterBattle
	db "@"

VermilionGymText_Guide:
	TX_ASM
	ld a, [wObtainedBadges]
	bit 2, a
	jr nz, .arenaVictory
	ld hl, VermilionGymText_GuideTip
	call PrintText
	jr .endScript
.arenaVictory
	ld hl, VermilionGymText_GuideVictory
	call PrintText
.endScript
	jp TextScriptEnd

VermilionGymText_GuideTip:
	TX_FAR _VermilionGymText_GuideTip
	db "@"

VermilionGymText_GuideVictory:
	TX_FAR _VermilionGymText_GuideVictory
	db "@"

PikachuTutor:
	ld a, [wPartyMon1Species]
	cp PIKACHU
	ret nz

	xor a
	ld [wWhichPokemon], a

	ld hl, .textStart
	call PrintText

	ld a, SURF
	call .learnmove
	ret
.textStart
	text "Ton Pikachu est"
	line "très spécial!"

	para "Il fait parti de"
	line "ceux qui peuvent"
	cont "apprendre Surf!"
	prompt
	db "@"
.learnmove
	ld [wMoveNum], a
	ld [wPokedexNum],a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b


	ld a, [wPokedexNum]
	push af
	ld a, [wPartyMon1Species]
	ld [wPokedexNum], a
	call GetMonName
	pop af
	ld [wPokedexNum], a
	
	callba CheckIfMoveIsKnown
	jr c, .finish

	ld hl, wFlags_D733
	set 6, [hl]
	push hl		;make it so the move-forget list covers up sprites
	predef LearnMove
	pop hl
	res 6, [hl]
	ld a, b
	and a
	ret z
.finish
	ret

PewterGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, PewterGymScript_Header
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeader0
	ld de, PewterGymScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

PewterGymScript_Header:
	ld hl, Gym1CityName
	ld de, Gym1LeaderName
	jp LoadGymLeaderAndCityName

Gym1CityName:
	db "Argenta@"

Gym1LeaderName:
	db "Pierre@"

PewterGymScriptReset:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PewterGymScriptBattle

PewterGymScriptBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymScriptReset
	ld a, $f0
	ld [wJoyIgnore], a

PewterGymScriptGiveTM:
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb bc, TM34_BIDE, 1
	call GiveItem
	jr nc, .bagFull
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr .endScript
.bagFull
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.endScript
	ld hl, wObtainedBadges
	set 0, [hl]

	ld a, HS_GYM_GUY
	ld [wMissableObjectIndex], a
	predef HideObject

	;if the first route 22 rival battle was skipped, clear the events and hide the associated npc
	;joenote - have to have this if the battle was skipped
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymScriptReset

PewterGymTextPointers:
	dw PewterGymText_Brock
	dw PewterGymText_Trainer0
	dw PewterGymText_Guide
	dw PewterGymText_Wait
	dw PewterGymText_ReceivedTM
	dw PewterGymText_BagFull

PewterGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_PEWTER_GYM_TRAINER_0
	db ($5 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_PEWTER_GYM_TRAINER_0
	dw PewterGymText_Trainer0PreBattle ; TextBeforeBattle
	dw PewterGymText_Trainer0AfterBattle ; TextAfterBattle
	dw PewterGymText_Trainer0EndBattle ; TextEndBattle
	dw PewterGymText_Trainer0EndBattle ; TextEndBattle

	db $ff

PewterGymText_Brock:
	TX_ASM
	CheckEvent EVENT_BEAT_BROCK
	jr z, .leaderFight
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .askForRematch
	call z, PewterGymScriptGiveTM
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
	CheckEitherEventSet EVENT_NEW_GAME_PLUS, EVENT_BEAT_BROCK_REMATCH
	jp nz, FossilTutor

	ld hl, PewterGymText_LeaderAfterBattle
	call PrintText
	jp .endScript
.leaderFight
	CheckEvent EVENT_ELITE_4_BEATEN
	jr nz, .leaderFightAfterElite4

	ld hl, PewterGymText_LeaderPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_LeaderEndBattle
	ld de, PewterGymText_LeaderEndBattle
	call SaveEndBattleTextPointers
	ld a, $1
	ld [wGymLeaderNo], a
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	xor a
	ld [hJoyHeld], a
;;;;joenote - added for rematch to skip gym leader tm
	CheckEvent EVENT_GOT_TM34
	jp nz, TextScriptEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, $3
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	jr .endScript
.leaderFightAfterElite4
	ld hl, PewterGymText_RematchPreBattle
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_RematchEndBattle
	ld de, PewterGymText_RematchEndBattle
	call SaveEndBattleTextPointers
	ld a, $1
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

PewterGymText_LeaderPreBattle:
	TX_FAR _PewterGymText_LeaderPreBattle
	db "@"

PewterGymText_LeaderAfterBattle:
	TX_FAR _PewterGymText_LeaderAfterBattle
	db "@"

PewterGymText_Wait:
	TX_FAR _PewterGymText_Wait
	db "@"

PewterGymText_ReceivedTM:
	TX_FAR _PewterGymText_ReceivedTM
	TX_SFX_ITEM_1
	TX_FAR _PewterGymText_TMExplanation
	db "@"

PewterGymText_BagFull:
	TX_FAR _PewterGymText_BagFull
	db "@"

PewterGymText_LeaderEndBattle:
	TX_FAR _PewterGymText_LeaderEndBattle
	;TX_SFX_LEVEL_UP ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	TX_SFX_KEY_ITEM	;joenote - play an unused sfx instead (triggered by playing GET_KEY_ITEM in battle)
	TX_FAR _PewterGymText_Badge
	db "@"

PewterGymText_Trainer0:
	TX_ASM
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PewterGymText_Trainer0PreBattle:
	TX_FAR _PewterGymText_Trainer0PreBattle
	db "@"

PewterGymText_Trainer0EndBattle:
	TX_FAR _PewterGymText_Trainer0EndBattle
	db "@"

PewterGymText_Trainer0AfterBattle:
	TX_FAR _PewterGymText_Trainer0AfterBattle
	db "@"

PewterGymText_RematchPreBattle:
	TX_FAR _PewterGymText_RematchPreBattle
	db "@"

PewterGymText_RematchEndBattle:
	TX_ASM
	SetEvent EVENT_BEAT_BROCK_REMATCH
	ld hl, wBeatGymLeadersRematch
	set 0, [hl]

	ld hl, .pewterGymText_RematchEndBattle
	call PrintText
	jp TextScriptEnd
.pewterGymText_RematchEndBattle
	TX_FAR _PewterGymText_RematchEndBattle
	db "@"

PewterGymText_Guide:
	TX_ASM
	ld a, [wObtainedBadges]
	bit 0, a
	jr nz, .arenaVictory
	ld hl, PewterGymText_GuideAsk
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .noAnswer
	ld hl, PewterGymText_GuideYes
	call PrintText
	jr .tellTip
.noAnswer
	ld hl, PewterGymText_GuideNo
	call PrintText
.tellTip
	ld hl, PewterGymText_GuideTip
	call PrintText
	jr .endScript
.arenaVictory
	ld hl, PewterGymText_GuideEnd
	call PrintText
.endScript
	jp TextScriptEnd

PewterGymText_GuideAsk:
	TX_FAR _PewterGymText_GuideAsk
	db "@"

PewterGymText_GuideYes:
	TX_FAR _PewterGymText_GuideYes
	db "@"

PewterGymText_GuideTip:
	TX_FAR _PewterGymText_GuideTip
	db "@"

PewterGymText_GuideNo:
	TX_FAR _PewterGymText_GuideNo
	db "@"

PewterGymText_GuideEnd:
	TX_FAR _PewterGymText_GuideEnd
	db "@"

FossilTutor:
	ld a, [wPartyMon1Species]
	cp OMASTAR
	ld a, DARK_PULSE
	jp z, .next
	ld a, [wPartyMon1Species]
	cp KABUTOPS
	ld a, METAL_CLAW
	jp z, .next
	ld a, [wPartyMon1Species]
	cp AERODACTYL
	ld a, SKULL_BASH
	jr z, .next
	jr .displayBring
.next
	ld [wMoveNum], a
	ld [wPokedexNum],a
	xor a
	ld [wWhichPokemon], a
	call GetMoveName
	call CopyStringToCF4B ; copy name to wcf4b

	ld hl, .textStart
	call PrintText

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
	push hl ;make it so the move-forget list covers up sprites
	predef LearnMove
	pop hl
	res 6, [hl]
	ld a, b
	and a
	; fallthrough
.finish
	jp TextScriptEnd
.displayBring
	ld hl, .textBring
	call PrintText
	jp TextScriptEnd
.textBring
	text "En récompense, je"
	line "peux réapprendre"
	cont "à tes #mons"
	cont "fossiles évolués"
	cont "des attaques qu'"
	cont "ils avaient oub-"
	cont "lié au cours des"
	cont "âges!"

	para "Revient me voir"
	line "avec eux si ça"
	cont "t'intéresse."
	done
	db "@"
.textStart
	text "Grâce aux progrès"
	line "de la recherche"
	cont "menée avec le"
	cont "musée, je peux"
	cont "aider ton #mon"
	cont "à retrouver une"
	cont "attaque venant"
	cont "de son passé."
	prompt
	db "@"
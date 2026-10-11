SafariZoneSecretHouseScript:
	jp EnableAutoTextBoxDrawing

SafariZoneSecretHouseTextPointers:
	dw SafariZoneSecretHouseText_Main
	dw SafariZoneSecretHouseText_Chief

SafariZoneSecretHouseText_Main:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN	;has elite 4 been beaten?
	jr nz, .e4_beaten

	CheckEvent EVENT_GOT_HM03
	jr nz, .hmExplanation

	ld hl, SecretHouseText_Greeting
	call PrintText
	lb bc, HM03_SURF, 1
	call GiveItem
	jr nc, .BagFull

	SetEvent EVENT_GOT_HM03
	ld hl, SecretHouseText_ReceivedHM03	
	jr .endScript
.BagFull
	ld hl, SecretHouseText_HM03NoRoom
	jr .endScript
.hmExplanation
	ld hl, SecretHouseText_HM03Explanation
	jr .endScript
.e4_beaten
	ld hl, SecretHouseText_PostLeagueGreeting
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd

SafariZoneSecretHouseText_Chief:
	TX_ASM
;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - chief battle
	CheckEvent EVENT_ELITE_4_BEATEN	;has elite 4 been beaten?
	jr z, .no_e4_beaten		;kick out if e4 not beaten

	ld hl, SecretHouseText_ChiefChallenge	;else ask if you want to challenge
	call PrintText	;print the challenge text
	call YesNoChoice	;prompt a yes/no choice

	ld a, [wCurrentMenuItem]	;load the player choice
	and a	;check the player choice
	jr nz, .no_e4_beaten	;kick out if no chosen

	;otherwise begin loading battle
	ld hl, SecretHouseText_ChiefPreBattle	;load pre battle text
	call PrintText	;print the pre battle text
	ld hl, wStatusFlags3;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	ld hl, SecretHouseText_ChiefPostBattle	;load text for when you win
	ld de, SecretHouseText_ChiefPostBattle	;load text for when you lose
	call SaveEndBattleTextPointers	;save the win/lose text

	ld a, $8
	ld [wGymLeaderNo], a	;set bgm to gym leader music
	ld a, OPP_CHIEF	;load the trainer type
	ld [wCurOpponent], a	;set as the current opponent
	ld a, 1	;get the right roster
	ld [wTrainerNo], a

	xor a
	ld [hJoyHeld], a
	jp TextScriptEnd
.no_e4_beaten
;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, SecretHouseText_ChiefBye
	call PrintText
	jp TextScriptEnd

SecretHouseText_Greeting:
	TX_FAR _SecretHouseText_Greeting
	db "@"

SecretHouseText_PostLeagueGreeting:
	TX_FAR _SecretHouseText_PostLeagueGreeting
	db "@"

SecretHouseText_ReceivedHM03:
	TX_FAR _SecretHouseText_ReceivedHM03
	TX_SFX_ITEM_1
	db "@"

SecretHouseText_HM03Explanation:
	TX_FAR _SecretHouseText_HM03Explanation
	db "@"

SecretHouseText_HM03NoRoom:
	TX_FAR _SecretHouseText_HM03NoRoom
	db "@"

SecretHouseText_ChiefChallenge:
	TX_FAR _SecretHouseText_ChiefChallenge
	db "@"

SecretHouseText_ChiefPreBattle:
	TX_FAR _SecretHouseText_ChiefPreBattle
	db "@"

SecretHouseText_ChiefPostBattle:
	TX_FAR _SecretHouseText_ChiefPostBattle
	db "@"

SecretHouseText_ChiefBye:
	TX_FAR _SecretHouseText_ChiefBye
	db "@"

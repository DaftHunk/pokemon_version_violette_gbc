
;joenote - adding scripts for random trainer battle

UndergroundPathWEScript:
	call CheckLostRandBattle
	call CheckWinstreak
	jp EnableAutoTextBoxDrawing

UndergroundPathWETextPointers:
	dw RandTrainerText1
	dw PickUpItemText

CheckLostRandBattle:
	ld a, [wIsInBattle]
	cp $ff
	ret nz
	ld a, HS_UNDPATHWE_MGENE
	ld [wMissableObjectIndex], a
	predef HideObject
	xor a
	ld [wUnusedD5A3], a
	ret

CheckWinstreak:
	ld a, [wUnusedD5A3]
	cp $5
	ret c
	ld a, HS_UNDPATHWE_MGENE
	ld [wMissableObjectIndex], a
	predef ShowObject
	xor a
	ld [wUnusedD5A3], a
	ret
	
RandTrainerText1:
	TX_ASM
	ld hl, RandTrainerIntro
	CheckEvent EVENT_ELITE_4_BEATEN	;has elite 4 been beaten?
	jr nz, .ready	;jump if beaten
	ld hl, RandTrainerNotReady
	call PrintText
	jr .textend
.ready
	call PrintText
	call ManualTextScroll
	ld hl, RandTrainerChallenge
	call PrintText
	call YesNoChoice	;prompt a yes/no choice
	ld a, [wCurrentMenuItem]	;load the player choice
	and a	;check the player choice
	jr nz, .goodbye	;if no, jump
	;otherwise begin loading battle
	SetEvent EVENT_90A
	ld hl, RandTrainerPre
	call PrintText
	ld hl, wd72d;set the bits for triggering battle
	set 6, [hl]	;
	set 7, [hl]	;
	ld hl, RandTrainerPost	;load text for when you win
	ld de, RandTrainerPost	;load text for when you lose
	call SaveEndBattleTextPointers	;save the win/lose text
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	callba GetRandTrainer
	;call EngageMapTrainer
	call InitBattleEnemyParameters
	;ld a, $09	;load 9 into the gym leader value to play final battle music 
	;ld [wGymLeaderNo], a
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;increment victory counter for the random trainer
	ld a, [wUnusedD5A3]
	inc a
	ld [wUnusedD5A3], a
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	xor a
	ld [hJoyHeld], a
	jr .textend
.goodbye
	ld hl, RandTrainerBye
	call PrintText
.textend
	jp TextScriptEnd
	
	
RandTrainerNotReady:
	TX_FAR _RandTrainerNotReady
	db "@"
RandTrainerIntro:
	TX_FAR _RandTrainerIntro
	db "@"
RandTrainerChallenge:
	TX_FAR _RandTrainerChallenge
	db "@"
RandTrainerBye:
	TX_FAR _RandTrainerBye
	db "@"
RandTrainerPre:
	TX_FAR _RandTrainerPre
	db "@"
RandTrainerPost:
	TX_FAR _RandTrainerPost
	db "@"
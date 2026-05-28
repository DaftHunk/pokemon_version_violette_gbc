VermilionCityScript:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, VermilionCityScript_197cb
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, VermilionCityScript_197c0
	ld hl, VermilionCityScriptPointers
	ld a, [wVermilionCityCurScript]
	jp CallFunctionInTable

VermilionCityScript_197c0:
;joenote - changed this so that both switches are determined at the same time
	callba DetermineVermilionGymSwitches
	ret

VermilionCityScript_197cb:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, $2
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScriptPointers:
	dw VermilionCityScript0
	dw VermilionCityScript1
	dw VermilionCityScript2
	dw VermilionCityScript3
	dw VermilionCityScript4

VermilionCityScript0:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - remove the pkmn blocking the gym if HM01 has been obtained
	CheckEvent EVENT_GOT_HM01
	jr z, .end 	;skip out if not
	;else remove the blocking sprite
	ld a, HS_VERMILION_PKMN
	ld [wMissableObjectIndex], a
	callba IsObjectHidden2
	ld a, [$ffe5]
	and a
	jr nz, .end
	predef HideObject
.end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wSpriteStateData1 + 9]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, CoordsData_19823
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ld [hJoyHeld], a
	ld [wcf0d], a
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_ELITE_4_BEATEN ;joenote - override the blocking guy if you beat the elite 4
	jr nz, .displayReturn3	;joenote - jump...
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_19810
.displayReturn3	;joenote - ...to here
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.asm_19810
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wVermilionCityCurScript], a
	ret

CoordsData_19823:
	db $1e,$12
	db $ff

VermilionCityScript4:
	ld hl, CoordsData_19823
	call ArePlayerCoordsInArray
	ret c
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	call DelayFrames
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityTextPointers:
	dw VermilionCityJennyText
	dw VermilionCityText_SSAnneStatusHint
	dw VermilionCityText_Main
	dw VermilionCityText_NPCMachoc
	dw VermilionCityText_MachocCry
	dw VermilionCityText_NPCSSAnne
	dw VermilionCityText_PokemonBlock
	dw VermilionCityText_PoliceAlert
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText_FanClub
	dw VermilionCityText_Gym
	dw VermilionCityText_Docks
	dw VermilionCityText_Town;joenote - moved this to position 14

VermilionCityJennyText:
	TX_ASM
	ld hl, VermilionCityJennyBattleText
	call PrintText
	; set battle flags
	ld hl, wStatusFlags3
	set 6, [hl]
	set 7, [hl]
	; set battle opponent
	call Delay3
	ld a, OPP_JENNY
	ld [wCurOpponent], a
	; set team
	ld a, $1
	ld [wTrainerNo], a
	; set after battle script
	ld a, $0
	ld [wVermilionCityCurScript], a
	; after battle
	ld hl, VermilionCityJennyEndBattleText
	call SaveEndBattleTextPointers
	jp TextScriptEnd
.alreadyBeaten
	ld hl, VermilionCityJennyAfterBattleText
	call PrintText
	jp TextScriptEnd

VermilionCityJennyBattleText:
	TX_FAR _VermilionJennyBattleText1
	db "@"

VermilionCityJennyEndBattleText:
	TX_FAR _VermilionJennyEndBattleText1
	db "@"

VermilionCityJennyAfterBattleText:
	TX_FAR _VermilionJennyAfterBattleText1
	db "@"

VermilionCityText_SSAnneStatusHint:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN ;joenote - add text for SS ANNE returning
	jr nz, .displayReturn
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .displayGone
	ld hl, VermilionCityText_SSAnneSeen
	call PrintText
	jr .endScript
.displayReturn	;joenote - add text for SS ANNE returning
	ld hl, VermilionCityText_SSAnneReturn
	call PrintText
	jr .endScript
.displayGone
	ld hl, VermilionCityText_SSAnneGone
	call PrintText
.endScript
	jp TextScriptEnd

VermilionCityText_SSAnneSeen:
	TX_FAR _VermilionCityText_SSAnneSeen
	db "@"

VermilionCityText_SSAnneGone:
	TX_FAR _VermilionCityText_SSAnneGone
	db "@"

VermilionCityText_SSAnneReturn:	;joenote - add text for SS ANNE returning
	TX_FAR _VermilionCityText_SSAnneReturn
	db "@"

VermilionCityText_Main:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN ;joenote - override the blocking guy if you beat the elite 4
	jr nz, .displayReturn2	;joenote - jump...
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_198f6
.displayReturn2	;joenote - ... to here 
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_RIGHT
	jr z, .asm_198c8
	ld hl, VermilionCityCoords1
	call ArePlayerCoordsInArray
	jr nc, .asm_198d0
.asm_198c8
	ld hl, VermilionCityText_SSAnneWelcome
	call PrintText
	jr .asm_198fc
.asm_198d0
	ld hl, VermilionCityText_SSAnneWelcomeTicket
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .asm_198e9
	ld hl, VermilionCityText_SSAnneNoTicket
	call PrintText
	jr .asm_198fc
.asm_198e9
	ld hl, VermilionCityText_SSAnneFlashedTicket
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .asm_198fc
.asm_198f6
	ld hl, VermilionCityText_SSAnneNotHere
	call PrintText
.asm_198fc
	jp TextScriptEnd

VermilionCityCoords1:
	db $1d,$13
	db $1f,$13
	db $ff

VermilionCityText_SSAnneWelcome:
	TX_FAR _VermilionCityText_SSAnneWelcome
	db "@"

VermilionCityText_SSAnneWelcomeTicket:
	TX_FAR _VermilionCityText_SSAnneWelcomeTicket
	db "@"

VermilionCityText_SSAnneFlashedTicket:
	TX_FAR _VermilionCityText_SSAnneFlashedTicket
	db "@"

VermilionCityText_SSAnneNoTicket:
	TX_FAR _VermilionCityText_SSAnneNoTicket
	db "@"

VermilionCityText_SSAnneNotHere:
	TX_FAR _VermilionCityText_SSAnneNotHere
	db "@"

VermilionCityText_NPCMachoc:
	TX_FAR _VermilionCityText_NPCMachoc
	db "@"

VermilionCityText_MachocCry:
	TX_FAR _VermilionCityText_MachocCry
	TX_ASM
	ld a, MACHOP
	call DisplayPokedex
	ld hl, VermilionCityText_Machoc
	call PrintText
	jp TextScriptEnd

VermilionCityText_Machoc:
	TX_FAR _VermilionCityText_Machoc
	db "@"

VermilionCityText_NPCSSAnne:
	TX_FAR _VermilionCityText_NPCSSAnne
	db "@"

VermilionCityText_Town:
	TX_FAR _VermilionCityText_Town
	db "@"

VermilionCityText_PoliceAlert:
	TX_FAR _VermilionCityText_PoliceAlert
	db "@"

VermilionCityText_FanClub:
	TX_FAR _VermilionCityText_FanClub
	db "@"

VermilionCityText_Gym:
	TX_FAR _VermilionCityText_Gym
	db "@"

VermilionCityText_Docks:
	TX_FAR _VermilionCityText_Docks
	db "@"

VermilionCityText_PokemonBlock:
	TX_FAR _VermilionCityText_PokemonBlock
	db "@"
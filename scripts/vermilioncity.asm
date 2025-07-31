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
	jr nz, .ssane_returns3	;joenote - jump...
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_19810
.ssane_returns3	;joenote - ...to here
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
	dw VermilionCityText2
	dw VermilionCityText3
	dw VermilionCityText4
	dw VermilionCityText5
	dw VermilionCityText6
	dw VermilionPKMNText
	dw VermilionCityText8
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText11
	dw VermilionCityText12
	dw VermilionCityText13
	dw VermilionCityText7;joenote - moved this to position 14

VermilionCityJennyText:
	TX_ASM
	ld hl, VermilionCityJennyBattleText
	call PrintText
	; set battle flags
	ld hl, wd72d
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

VermilionCityText2:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN ;joenote - add text for SS ANNE returning
	jr nz, .ssane_returns				;
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_1989e
	ld hl, VermilionCityText_198a7
	call PrintText
	jr .asm_198a4
.ssane_returns	;joenote - add text for SS ANNE returning
	ld hl, VermilionCityText_annereturns
	call PrintText
	jr .asm_198a4
.asm_1989e
	ld hl, VermilionCityText_198ac
	call PrintText
.asm_198a4
	jp TextScriptEnd

VermilionCityText_198a7:
	TX_FAR _VermilionCityText_198a7
	db "@"

VermilionCityText_198ac:
	TX_FAR _VermilionCityText_198ac
	db "@"

VermilionCityText_annereturns:	;joenote - add text for SS ANNE returning
	TX_FAR _VermilionCityText_annereturns
	db "@"

VermilionCityText3:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN ;joenote - override the blocking guy if you beat the elite 4
	jr nz, .ssane_returns2	;joenote - jump...
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_198f6
.ssane_returns2	;joenote - ... to here 
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_RIGHT
	jr z, .asm_198c8
	ld hl, VermilionCityCoords1
	call ArePlayerCoordsInArray
	jr nc, .asm_198d0
.asm_198c8
	ld hl, SSAnneWelcomeText4
	call PrintText
	jr .asm_198fc
.asm_198d0
	ld hl, SSAnneWelcomeText9
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .asm_198e9
	ld hl, SSAnneNoTicketText
	call PrintText
	jr .asm_198fc
.asm_198e9
	ld hl, SSAnneFlashedTicketText
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .asm_198fc
.asm_198f6
	ld hl, SSAnneNotHereText
	call PrintText
.asm_198fc
	jp TextScriptEnd

VermilionCityCoords1:
	db $1d,$13
	db $1f,$13
	db $ff

SSAnneWelcomeText4:
	TX_FAR _SSAnneWelcomeText4
	db "@"

SSAnneWelcomeText9:
	TX_FAR _SSAnneWelcomeText9
	db "@"

SSAnneFlashedTicketText:
	TX_FAR _SSAnneFlashedTicketText
	db "@"

SSAnneNoTicketText:
	TX_FAR _SSAnneNoTicketText
	db "@"

SSAnneNotHereText:
	TX_FAR _SSAnneNotHereText
	db "@"

VermilionCityText4:
	TX_FAR _VermilionCityText4
	db "@"

VermilionCityText5:
	TX_FAR _VermilionCityText5
	TX_ASM
	ld a, MACHOP
	call DisplayPokedex
	ld hl, VermilionCityText14
	call PrintText
	jp TextScriptEnd

VermilionCityText14:
	TX_FAR _VermilionCityText14
	db "@"

VermilionCityText6:
	TX_FAR _VermilionCityText6
	db "@"

VermilionCityText7:
	TX_FAR _VermilionCityText7
	db "@"

VermilionCityText8:
	TX_FAR _VermilionCityText8
	db "@"

VermilionCityText11:
	TX_FAR _VermilionCityText11
	db "@"

VermilionCityText12:
	TX_FAR _VermilionCityText12
	db "@"

VermilionCityText13:
	TX_FAR _VermilionCityText13
	db "@"

VermilionPKMNText:
	TX_FAR _VermilionPKMNText
	db "@"
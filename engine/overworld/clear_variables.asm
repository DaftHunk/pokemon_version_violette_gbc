ClearVariablesOnEnterMap:
	ld a, SCREEN_HEIGHT_PIXELS
	ld [hWY], a
	ld [rWY], a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - if bit 7 of wTempBattleFlag is set, then just got done winning a battle. do not zero out wTempBattleFlag.
	ld a, [wTempBattleFlag]
	bit 7, a
	res 7, a
	jr nz, .skip_clear
	xor a
.skip_clear
	ld [wTempBattleFlag], a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld [wStepCounter], a
	ld [wLoneAttackNo], a	;wLoneAttackNo is the same address as wGymLeaderNo
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ld [hJoyHeld], a
	ld [wActionResultOrTookBattleTurn], a
	;ld [wTempBattleFlag], a
	ld hl, wCardKeyDoorY
	ld [hli], a
	ld [hl], a
	ld hl, wWhichTrade
	ld bc, wStandingOnWarpPadOrHole - wWhichTrade
	call FillMemory
	ret

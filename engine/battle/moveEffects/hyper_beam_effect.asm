HyperBeamEffect_:
	callba _HandleHyperbeamClause	;joenote - handle hyper beam clause
	ret nz
	ld hl, wPlayerBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .hyperBeamEffect
	ld hl, wEnemyBattleStatus2
.hyperBeamEffect
	set NEEDS_TO_RECHARGE, [hl] ; mon now needs to recharge
	ret

ClearHyperBeam_:	;for whoever's turn it is, clear their opponent's hyperbeam status
	push hl
	ld hl, wEnemyBattleStatus2
	ld a, [H_WHOSETURN]
	and a
	jr z, .playerTurn
	ld hl, wPlayerBattleStatus2
.playerTurn
	res NEEDS_TO_RECHARGE, [hl] ; mon no longer needs to recharge
	pop hl
	ret
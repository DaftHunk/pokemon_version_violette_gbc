TrappingEffect_:
;joenote - make it so the effect won't take hold if target has type immunity
	ld hl, wUnusedC000
	set 3, [hl]
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .trappingEffect
	ld hl, wUnusedC000
	res 3, [hl]
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.trappingEffect
	bit USING_TRAPPING_MOVE, [hl]
	ret nz
	
	push hl
	push bc
	push de
	callab AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl
	ld a, [wTypeEffectiveness]
	and a
	ret z
	
	;call ClearHyperBeam ; since this effect is called before testing whether the move will hit,
                        ; the target won't need to recharge even if the trapping move missed
						;joenote - will do this later under ApplyAttackToEnemy/Player functions
	set USING_TRAPPING_MOVE, [hl] ; mon is now using a trapping move

;;;;;;;;;;;;;;;;; PureRGB - NEW: trapping moves do 2-3 turns maximum but a bit more damage to compensate.	
.reroll
	callab BattleRandom
	and %11
	cp %11
	jr z, .reroll ; only want 3 possible results, not 4
	and a ; 2/3 chance for 2 attacks (results 01 and 11), 1/3 chance for 3 (result 0)
	ld a, 2
	jr nz, .setTrappingCounter
	ld a, 3
.setTrappingCounter
	dec a
;;;;;;;;;;;;;;;;;
	ld [de], a
;joenote - have the trapping effect user get its speed temporarily reduced until stats get recalculated
;	callba ReduceSpeed
;joenote - increment a trapping spam counter that checks for consecutive usage of trapping moves
	inc hl
	inc hl	;now points to xBattleStatus3
	ld a, [hl]
	add TRAPPING_COUNT_BIT
	ld [hl], a	;else increment the consecutive use counter
	ret
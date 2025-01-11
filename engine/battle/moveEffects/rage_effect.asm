RageEffect_:	;joenote - modified to last 2 to 3 turns
	ld hl, wPlayerBattleStatus2
	ld bc, wPlayerNumAttacksLeft
	ld a, [H_WHOSETURN]
	and a
	jr z, .player
	ld hl, wEnemyBattleStatus2
	ld bc, wEnemyNumAttacksLeft
.player
	set USING_RAGE, [hl] ; mon is now in "rage" mode
	callab BattleRandom
	and $1
	inc a
	inc a
	ld [bc], a ; set Rage counter to 2 or 3 at random
	ret
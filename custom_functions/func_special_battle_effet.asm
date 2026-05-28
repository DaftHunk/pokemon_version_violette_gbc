; Credit PureRGB ADDED: function used in some special battles where some effect happens each turn.
; like in the volcano, each turn you have a non fire/rock/water pokemon out they will get burned if they aren't burned.
CheckPerTurnSpecialBattleEffect::
	ld a, [wCurMapTileset]
	cp VOLCANO
	jp z, .volcanoPlayerSide
    ret
.volcanoPlayerSide
	; in the volcano, the player pokemon is burned if it's not FIRE, WATER or ROCK
	ld a, [wBattleMonType1]

	cp FIRE
	ret z    
	cp WATER
	ret z
	cp ROCK
	ret z

	ld a, [wBattleMonType2]

	cp FIRE
	ret z
	cp WATER
	ret z
	cp ROCK
	ret z

	ld a, [wBattleMonStatus]
	and a
	ret nz ; don't do anything if already has a status

    ldh a, [H_WHOSETURN]
	push af
    ld a, 1
	ldh [H_WHOSETURN], a ; force enemy turn so player's stats are lowered

	ld hl, VolcanoTooHot
	call PrintText

    callfar BurnPokemon
	callfar ReadPlayerMonCurHPAndStatus

    pop af
	ldh [H_WHOSETURN], a
	ret

CheckPerTurnSpecialEnemyEffect::
	ld a, [wCurMapTileset]
	cp VOLCANO
	jp z, .volcanoEnemySide
    ret
.volcanoEnemySide
	; in the volcano, the enemy pokemon is burned if it's not FIRE, WATER or ROCK
	ld a, [wEnemyMonType1]

	cp FIRE
	ret z
	cp WATER
	ret z
	cp ROCK
	ret z

	ld a, [wEnemyMonType2]

	cp FIRE
	ret z
	cp WATER
	ret z
	cp ROCK
	ret z

	ld a, [wEnemyMonStatus]
	and a
	ret nz ; don't do anything if already has a status

    ldh a, [H_WHOSETURN]
	push af
    ld a, 0
	ldh [H_WHOSETURN], a ; force player turn so enemy's stats are lowered

	ld hl, VolcanoTooHot
	call PrintText

    callfar BurnEnemyMon
	callfar ReadPlayerMonCurHPAndStatus

    pop af
	ldh [H_WHOSETURN], a
	ret

VolcanoTooHot:
	TX_FAR _VolcanoBattleBurnText
	db "@"

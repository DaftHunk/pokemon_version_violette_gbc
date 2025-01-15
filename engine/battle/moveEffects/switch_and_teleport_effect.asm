SwitchAndTeleportEffect_:
	ld a, [H_WHOSETURN]
	and a
	jr nz, .handleEnemy
	ld a, [wIsInBattle]
	dec a
	jr nz, .notWildBattle1
	ld a, [wCurEnemyLVL]
	ld b, a
	ld a, [wBattleMonLevel]
	cp b ; is the player's level greater than the enemy's level?
	jr nc, .playerMoveWasSuccessful ; if so, teleport will always succeed
	add b
	ld c, a
	inc c ; c = sum of player level and enemy level
.rejectionSampleLoop1
	call BattleRandom
	cp c ; get a random number between 0 and c
	jr nc, .rejectionSampleLoop1
	srl b
	srl b  ; b = enemyLevel / 4
	cp b ; is rand[0, playerLevel + enemyLevel) >= (enemyLevel / 4)?
	jr nc, .playerMoveWasSuccessful ; if so, allow teleporting
	ld c, 50
	call DelayFrames
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp .failed
.playerMoveWasSuccessful
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wPlayerMoveNum]
	jr .playAnimAndPrintText
.notWildBattle1
	ld c, 50
	call DelayFrames
	ld hl, IsUnaffectedText
    ld b, BANK(IsUnaffectedText)
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintText
	jp .failed
.handleEnemy
	ld a, [wIsInBattle]
	dec a
	jr nz, .notWildBattle2
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wCurEnemyLVL]
	cp b
	jr nc, .enemyMoveWasSuccessful
	add b
	ld c, a
	inc c
.rejectionSampleLoop2
	call BattleRandom
	cp c
	jr nc, .rejectionSampleLoop2
	srl b
	srl b
	cp b
	jr nc, .enemyMoveWasSuccessful
	ld c, 50
	call DelayFrames
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp .failed
.enemyMoveWasSuccessful
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wEnemyMoveNum]
	jr .playAnimAndPrintText
.notWildBattle2
	ld c, 50
	call DelayFrames
	ld hl, IsUnaffectedText
    ld b, BANK(IsUnaffectedText)
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintText
	jpab ConditionalPrintButItFailed
.playAnimAndPrintText
	push af
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
	pop af
	ld hl, RanFromBattleText
    ld b, BANK(RanFromBattleText)
	cp TELEPORT
	jr z, .printText
	ld hl, RanAwayScaredText
    ld b, BANK(RanAwayScaredText)
	cp ROAR
	jr z, .printText
	ld hl, WasBlownAwayText
    ld b, BANK(WasBlownAwayText)

.printText
	jpab PrintText

.failed
	ld hl, PrintButItFailedText_
	jp BankswitchEtoF
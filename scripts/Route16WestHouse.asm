Route16WestHouseScript:
	call EnableAutoTextBoxDrawing
	jp Route16WestHouseCannotAccessCheck

Route16WestHouseCannotAccessCheck:
	; Area to check
	ld a, [wYCoord]
	cp $1
	ret nz
	ld a, [wXCoord]
	cp $7
	; If not here return
	ret nz
	; Else display text
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	; Reset current input
	xor a
	ld [hJoyHeld], a

	; Move player away
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_LEFT
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData1 + 9], a
	ld [wJoyIgnore], a

	ret

Route16WestHouseTextPointers:
	dw Route16WestHouseTextLetter
	dw Route16WestHouseTextStairs

Route16WestHouseTextLetter:
	TX_FAR _Route16WestHouseTextLetter
	db "@"

Route16WestHouseTextStairs:
	TX_FAR _Route16WestHouseTextStairs
	db "@"

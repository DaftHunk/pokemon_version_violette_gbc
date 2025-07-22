Route16WestScript:
	call EnableAutoTextBoxDrawing
	jp Route16WestCannotAccessCheck

Route16WestCannotAccessCheck:
	; Unlock door after Elite 4
	CheckEvent EVENT_ELITE_4_BEATEN
	ret nz

	; Area to check
	ld a, [wYCoord]
	cp $1A
	ret nz
	ld a, [wXCoord]
	cp $11
	; If not here return
	ret nz
	; Else display text
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID

	; Reset current input
	xor a
	ld [hJoyHeld], a

	; Move player away
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData1 + 9], a
	ld [wJoyIgnore], a

	ret

Route16WestTextPointers:
	dw Route16WestTextClosed
	dw Route16WestTextTomb
	dw Route16WestTextSign

Route16WestTextClosed:
	TX_FAR _Route16WestTextClosed
	db "@"

Route16WestTextTomb:
	TX_FAR _Route16WestTextTomb
	db "@"

Route16WestTextSign:
	TX_FAR _Route16WestTextSign
	db "@"

PrintStrengthTxt:
	ld hl, wd728
	set 0, [hl]
	ld hl, UsedStrengthText
	call PrintText
	ld hl, CanMoveBouldersText
	jp PrintText

UsedStrengthText:
	TX_FAR _UsedStrengthText
	TX_ASM
	ld a, [wcf91]
	call PlayCry
	call Delay3
	jp TextScriptEnd

CanMoveBouldersText:
	TX_FAR _CanMoveBouldersText
	db "@"

IsSurfingAllowed:
; Returns whether surfing is allowed in bit 1 of wd728.
; Surfing isn't allowed on the Cycling Road or in the lowest level of the
; Seafoam Islands before the current has been slowed with boulders.
	ld hl, wd728
	set 1, [hl]
	ld a, [wd732]
	bit 5, a
	jr nz, .forcedToRideBike
	ld a, [wCurMap]
	cp SEAFOAM_ISLANDS_B4F
	ret nz
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret z
	ld hl, CoordsData_cdf7
	call ArePlayerCoordsInArray
	ret nc
	ld hl, wd728
	res 1, [hl]
	
	;run alternate code if coming here from the overworld hotkey function
	ld a, [wActionResultOrTookBattleTurn]
	and a
	jr nz, .alt_fastcurrent
	
	ld hl, CurrentTooFastText
	jp PrintText
.forcedToRideBike
	ld hl, wd728
	res 1, [hl]
	ld hl, CyclingIsFunText
	jp PrintText
.alt_fastcurrent
	;initialize a text box without drawing anything special. makes this show up with surf hotkeys
	ld a, 1
	ld [wAutoTextBoxDrawingControl], a
	callba DisplayTextIDInit

	ld hl, CurrentTooFastText
	call PrintText
	
	;use $ff value loaded into hSpriteIndexOrTextID to make DisplayTextID display nothing and close any text
	ld a, $FF
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

	
CoordsData_cdf7:
	db $0B,$07,$FF

CurrentTooFastText:
	TX_FAR _CurrentTooFastText
	db "@"

CyclingIsFunText:
	TX_FAR _CyclingIsFunText
	db "@"

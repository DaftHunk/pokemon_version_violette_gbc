PrintWaitingText:
	coord hl, 3, 8
	ld b, 2
	ld c, 12
	ld a, [wIsInBattle]
	and a
	jr z, .trade
; battle
	call TextBoxBorder
	jr .border_done
.trade
	call CableClub_TextBoxBorder
.border_done
	coord hl, 4, 10
	ld de, WaitingText
	call PlaceString
	ld c, 50
	jp DelayFrames

WaitingText:
	db "Un moment...@"

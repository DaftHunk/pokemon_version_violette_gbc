RedsHouse2FScript:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2FScriptPointers
	ld a, [wRedsHouse2CurScript]
	jp CallFunctionInTable

RedsHouse2FScriptPointers:
	dw RedsHouse2FScript0
	dw RedsHouse2FScript1

RedsHouse2FScript0:
	xor a
	ld [hJoyHeld], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, 1
	ld [wRedsHouse2CurScript], a
	ret

RedsHouse2FScript1:
	ret

RedsHouse2FTextPointers:
	dw RedsHouse2FText_Outro

RedsHouse2FText_Outro:
	TX_ASM

	ld hl, .outroAskText
	call PrintText

	call YesNoChoice
	; load the player choice
	ld a, [wCurrentMenuItem]
	; check the player choice
	and a
	; kick out if no chosen
	jr nz, .outroNo
	; overwise it's yes
	jpab ReplayPostGameVideo
.outroNo
	ld hl, .outroNoText
	call PrintText
	jp TextScriptEnd
.outroNoText
	text "C'est non."
	done
	db "@"
.outroAskText
	text "Coupe de la Ligue"
	line "#mon"

	para "Décerné à:"
	line "<PLAYER>"

	para "En regardant de"
	line "plus près, vous"
	cont "voyez que le nom"
	cont "de <RIVAL> a"
	cont "été effacé à la"
	cont "va-vite..."

	para "Revoir la scène"
	line "post-Ligue?"
	done
	db "@"

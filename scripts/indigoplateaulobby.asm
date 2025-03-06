IndigoPlateauLobbyScript:
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	; wispnote - This event was probably ment to be reset on Route 23.
	; ResetEvent EVENT_VICTORY_ROAD_1F_BOULDER_ON_SWITCH
	ld hl, wBeatLorelei
	bit 1, [hl]
	res 1, [hl]
	ret z
	; Elite 4 events
	ResetEventRange ELITE4_EVENTS_START, EVENT_LANCES_ROOM_LOCK_DOOR
	ret

IndigoPlateauLobbyTextPointers:
	dw IndigoHealNurseText
	dw IndigoPlateauLobbyText2
	dw IndigoPlateauLobbyText3
	dw IndigoCashierText
	dw IndigoTradeNurseText

IndigoHealNurseText:
	TX_POKECENTER_NURSE

IndigoPlateauLobbyText2:
	TX_ASM
	CheckEvent EVENT_ELITE_4_BEATEN ;joenote - add text for after beating the elite 4
	ld hl, IndigoPlateauLobbyText2_normal
	jr z, .print
	ld hl, IndigoPlateauLobbyText2_ALT
.print	
	call PrintText
	jp TextScriptEnd
	
IndigoPlateauLobbyText2_normal:
	TX_FAR _IndigoPlateauLobbyText2
	db "@"

IndigoPlateauLobbyText3:
	TX_FAR _IndigoPlateauLobbyText3
	db "@"

IndigoTradeNurseText:
	TX_CABLE_CLUB_RECEPTIONIST

IndigoPlateauLobbyText2_ALT:
	text "Yo! Champion"
	line "d'hier et"
	cont "d'aujourd'hui!"

	para "A la Ligue #mon"
	line "tu vas devoir"
	cont "affronter le"
	cont "Conseil des 4"
	cont "à la suite."

	para "Si tu perds, tu"
	line "devras recommencer"
	cont "à zéro!"
	cont "Bref tu connais."
	cont "Alors vas y!"
	done
	db "@"

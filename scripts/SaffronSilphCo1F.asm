SilphCo1Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_BEAT_SAFFRON_SILPH_CO_GIOVANNI
	ret z
	CheckAndSetEvent EVENT_SAFFRON_SILPH_CO_RECEPTIONIST_AT_DESK
	ret nz
	ld a, HS_SAFFRON_SILPH_CO_1F_RECEPTIONIST
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

SilphCo1TextPointers:
	dw SilphCo1Text1

SilphCo1Text1:
	TX_FAR _SilphCo1Text1
	db "@"

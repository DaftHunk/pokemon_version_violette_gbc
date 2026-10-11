FuchsiaCityScript:
	jp EnableAutoTextBoxDrawing

FuchsiaCityTextPointers:
	dw FuchsiaCityText_DidYouKnow
	dw FuchsiaCityText_SafariExplain
	dw FuchsiaCityNicoText
	dw FuchsiaCityText_FakeVoltorb
	dw FuchsiaCityText_Pokemon
	dw FuchsiaCityText_Pokemon
	dw FuchsiaCityText_Pokemon
	dw FuchsiaCityText_Pokemon
	dw FuchsiaCityText_Pokemon
	dw FuchsiaCityText_Pokemon
	dw FuchsiaCityText_Town
	dw FuchsiaCityText_Museum
	dw FuchsiaCityText_Safari
	dw MartSignText
	dw PokeCenterSignText
	dw FuchsiaCityText_Warden
	dw FuchsiaCityText_Zoo
	dw FuchsiaCityText_Gym
	dw FuchsiaCityText_DisplayChansey
	dw FuchsiaCityText_DisplayVoltorb
	dw FuchsiaCityText_DisplayKangaskhan
	dw FuchsiaCityText_DisplaySlowpoke
	dw FuchsiaCityText_DisplayLapras
	dw FuchsiaCityText_DisplayFossile

FuchsiaCityText_DidYouKnow:
	TX_FAR _FuchsiaCityText_DidYouKnow
	db "@"

FuchsiaCityText_SafariExplain:
	TX_FAR _FuchsiaCityText_SafariExplain
	db "@"

FuchsiaCityNicoText:
	TX_ASM
	ld hl, FuchsiaCityText_NicoSearch
	
	CheckEvent EVENT_JULIA_MEET
	jr nz, .nicoJoinJulia
	; else
	call PrintText
	jr .endScript
.nicoJoinJulia
	ld hl, FuchsiaCityText_NicoFound
	call PrintText

	call GBFadeOutToBlack
	ld a, HS_FUCHSIA_CITY_NICO
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SAFARI_ZONE_CENTER_REST_NICO
	ld [wMissableObjectIndex], a
	predef ShowObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack

	SetEvent EVENT_JULIA_AND_NICO_REUNITED
	; fallthrough
.endScript
	jp TextScriptEnd

FuchsiaCityText_NicoSearch:
	TX_FAR _FuchsiaCityText_NicoSearch
	db "@"

FuchsiaCityText_FakeVoltorb:
	TX_FAR _FuchsiaCityText_FakeVoltorb
	db "@"

FuchsiaCityText_Pokemon:
	TX_FAR _FuchsiaCityText_Pokemon
	db "@"

FuchsiaCityText_Town:
	TX_FAR _FuchsiaCityText_Town
	db "@"

FuchsiaCityText_Museum:
	TX_FAR _FuchsiaCityText_Museum
	db "@"

FuchsiaCityText_Safari:
	TX_FAR _FuchsiaCityText_Safari
	db "@"

FuchsiaCityText_Warden:
	TX_FAR _FuchsiaCityText_Warden
	db "@"

FuchsiaCityText_Zoo:
	TX_FAR _FuchsiaCityText_Zoo
	db "@"

FuchsiaCityText_Gym:
	TX_FAR _FuchsiaCityText_Gym
	db "@"

FuchsiaCityText_DisplayChansey:
	TX_ASM
	ld hl, .fuchsiaCityText_ZooChansey
	call PrintText
	ld a, CHANSEY
	call DisplayPokedex
	jp TextScriptEnd

.fuchsiaCityText_ZooChansey
	TX_FAR _FuchsiaCityText_ZooChansey
	db "@"

FuchsiaCityText_DisplayVoltorb:
	TX_ASM
	ld hl, .fuchsiaCityText_ZooVoltorb
	call PrintText
	ld a, VOLTORB
	call DisplayPokedex
	jp TextScriptEnd

.fuchsiaCityText_ZooVoltorb
	TX_FAR FuchsiaCityText_ZooVoltorb
	db "@"

FuchsiaCityText_DisplayKangaskhan:
	TX_ASM
	ld hl, .fuchsiaCityText_ZooKangaskhan
	call PrintText
	ld a, KANGASKHAN
	call DisplayPokedex
	jp TextScriptEnd

.fuchsiaCityText_ZooKangaskhan
	TX_FAR _FuchsiaCityText_ZooKangaskhan
	db "@"

FuchsiaCityText_DisplaySlowpoke:
	TX_ASM
	ld hl, .fuchsiaCityText_ZooSlowpoke
	call PrintText
	ld a, SLOWPOKE
	call DisplayPokedex
	jp TextScriptEnd

.fuchsiaCityText_ZooSlowpoke
	TX_FAR _FuchsiaCityText_ZooSlowpoke
	db "@"

FuchsiaCityText_DisplayLapras:
	TX_ASM
	ld hl, .fuchsiaCityText_ZooLapras
	call PrintText
	ld a, LAPRAS
	call DisplayPokedex
	jp TextScriptEnd

.fuchsiaCityText_ZooLapras
	TX_FAR _FuchsiaCityText_ZooLapras
	db "@"

FuchsiaCityText_DisplayFossile:
	TX_ASM
	; If player get Omanyte show Kabuto
	CheckEventReuseA EVENT_GOT_HELIX_FOSSIL
	jr nz, .displayKabuto
	; Else show Omanyte
	ld hl, .fuchsiaCityText_ZooOmanyte
	call PrintText
	ld a, OMANYTE
	jr .displayDex
.displayKabuto
	ld hl, .fuchsiaCityText_ZooKabuto
	call PrintText
	ld a, KABUTO
; fallthough
.displayDex
	call DisplayPokedex
.endScript
	jp TextScriptEnd

.fuchsiaCityText_ZooOmanyte
	TX_FAR _FuchsiaCityText_ZooOmanyte
	db "@"

.fuchsiaCityText_ZooKabuto
	TX_FAR _FuchsiaCityText_ZooKabuto
	db "@"

FuchsiaCityText_NicoFound:
	TX_FAR _FuchsiaCityText_NicoFound
	db "@"

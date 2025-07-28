DisplayExtraOptionMenu:
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, 1 ;cursor Y coordinate
	ld [wTopMenuItemY], a
	ld a, 1 ;cursor X coordinate
	ld [wTopMenuItemX], a

	ld a, 1
	ld [wLetterPrintingDelayFlags], a	;no delay
	ld a, $01
	ld [H_AUTOBGTRANSFERENABLED], a ; enable auto background transfer

;draw text box border for lite options
	coord hl, 0, 0
	ld b, 5
	ld c, 18
	call TextBoxBorder
;draw text box border for master options
	coord hl, 0, 7
	ld b, 4
	ld c, 18
	call TextBoxBorder

	call PlaceExtraOptionStrings
	
	call PlaceSoundSetting	;joenote - display the sound setting
	call Show60FPSSetting	;60fps - display current setting
	call ShowLaglessTextSetting	;joenote - display marker for lagless text or not
	call ShowGammaSetting
	call ShowEnhancedGBCSetting
	
	call ShowHardModeSetting	;joenote - display marker for hard mode or not
	call ShowNuzlocke
	call ShowRandomTrainers
	call ShowRandomWild

	call Delay3
.loop
	call PlaceMenuCursor

.getJoypadStateLoop
	call JoypadLowSensitivity
	ld a, [hJoy5]
	ld b, a
	bit BIT_B_BUTTON, b ; B button pressed?
	jp nz, .exitMenu
	bit BIT_START, b ; Start button pressed?
	jp nz, .exitMenu
	bit BIT_SELECT, b ; Select button pressed?
	jp nz, .displaySoundTestMenu
	bit BIT_A_BUTTON, b ; A button pressed?
	jr nz, .cursor_section
	jr .checkDirectionKeys	;jump if d-pad pressed
.cursor_section
	ld a, [wTopMenuItemY]
	cp $1 ; cursor over audio?
	jr z, .cursorAudio
	cp $2 ; cursor over FPS?
	jr z, .cursorFPS
	cp $3 ; cursor over instant text?
	jr z, .cursorInstText
	cp $4 ;cursor over gamma shader?
	jr z, .cursorGamma
	cp $5 ;cursor over enhanced gbc?
    jr z, .cursorEnhGBC
	cp $8 ; cursor over hard mode?
	jr z, .cursorHardMode
	cp $9 ; cursor over nuzlocke?
	jr z, .cursorNuzlocke
	cp $0a ; cursor over random trainers?
	jr z, .cursorRandomTrainers
	cp $0b ; cursor over random wild?
	jr z, .cursorRandomWild
	cp $10 ; is the cursor on Back?
	jp z, .exitMenu
	jr .getJoypadStateLoop

.displaySoundTestMenu
	jpab DisplaySoundTestMenu
	
.cursorAudio
	call CycleSoundSetting
	jr .getJoypadStateLoop
.cursorFPS
	call Toggle60FPSSetting
	jr .getJoypadStateLoop
.cursorInstText
	call ToggleLaglessText
	jr .getJoypadStateLoop
.cursorGamma
	call ToggleGammaShader
	jr .getJoypadStateLoop
.cursorEnhGBC
	call ToggleEnhancedGBCColors
	jr .getJoypadStateLoop
.cursorHardMode
	call ToggleHardMode
	jr .getJoypadStateLoop
.cursorNuzlocke
	call ToggleNuzlocke
	jr .getJoypadStateLoop
.cursorRandomTrainers
	call ToggleRandomTrainers
	jr .getJoypadStateLoop
.cursorRandomWild
	call ToggleRandomWild
	jr .getJoypadStateLoop

.checkDirectionKeys
	ld a, [wTopMenuItemY]
	bit BIT_D_DOWN, b ; Down pressed?
	jr nz, .downPressed
	bit BIT_D_UP, b ; Up pressed?
	jr nz, .upPressed
	bit BIT_D_LEFT, b ; Left pressed?
	jr nz, .cursor_section
	bit BIT_D_RIGHT, b ; Right pressed?
	jr nz, .cursor_section
	jp .getJoypadStateLoop
.downPressed
	cp 16
	ld b, -15
	jr z, .updateMenuVariables
	cp 5
	ld b, 3
	jr z, .updateMenuVariables
	cp 11
	ld b, 5
	jr z, .updateMenuVariables
	;else
	ld b, 1
	jr .updateMenuVariables
.upPressed
	cp 1
	ld b, 15
	jr z, .updateMenuVariables
	cp 8
	ld b, -3
	jr z, .updateMenuVariables
	cp 16
	ld b, -5
	jr z, .updateMenuVariables
	;else
	ld b, -1
.updateMenuVariables
	add b
	ld [wTopMenuItemY], a
	ld a, 1
	ld [wTopMenuItemX], a
	call PlaceExtraOptionStrings
	jp .loop

.exitMenu
	ld a, SFX_PRESS_AB
	call PlaySound
	call ClearScreen
	ret


PlaceExtraOptionStrings:
;place audio text
	coord hl, 1, 1
	ld de, TextAudio
	call PlaceString
	
;place 60fps text
	coord hl, 1, 2
	ld de, TextFPS
	call PlaceString
	
;place instant text
	coord hl, 1, 3
	ld de, TextInstant
	call PlaceString

;place gamma shader text
	coord hl, 1, 4
	ld de, TextGamma
	call PlaceString

;place enhanced GBC color text
	coord hl, 1, 5
	ld de, TextEnhancedGBC
	call PlaceString

;place hard mode text
	coord hl, 1, 8
	ld de, TextHardMode
	call PlaceString

;place nuzlocke text
	coord hl, 1, 9
	ld de, TextNuzlocke
	call PlaceString

;place random trainers text
	coord hl, 1, 10
	ld de, TextRandomTrainer
	call PlaceString

;place random wild text
	coord hl, 1, 11
	ld de, TextRandomWild
	call PlaceString

;place back text
	coord hl, 1, 16
	ld de, TextBack
	call PlaceString

	ret


;joenote - show the sound setting on the menu
CycleSoundSetting:	;joenote - cycle through mono, earphone 1, 2, and 3
	ld a, [wOptions]
	push bc
	ld b, a
	ld c, a
	
	ld a, (SOUND_STEREO_BITS ^ $FF)
	and b
	ld b, a
	
	ld a, c
	and SOUND_STEREO_BITS
	swap a
	inc a
	swap a
	and SOUND_STEREO_BITS
	or b
	pop bc
	ld [wOptions], a
	;fall through
PlaceSoundSetting:
	ld hl, OptionMenuSoundText
	ld a, [wOptions]
	and SOUND_STEREO_BITS
	swap a
.loop
	and a
	jr z, .done
	dec a
	inc hl
	inc hl
	jr .loop
.done
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, $A, $1
	call PlaceString
	ret
OptionMenuSoundText:
	dw OptionMenuMono
	dw OptionMenuEar1
	dw OptionMenuEar2
	dw OptionMenuEar3
OptionMenuMono:
	db "     Mono@"
OptionMenuEar1:
	db "Ecouteur1@"
OptionMenuEar2:
	db "Ecouteur2@"
OptionMenuEar3:
	db "Ecouteur3@"


;60fps - show the fps setting on the menu when activated
Toggle60FPSSetting:
	ld a, [wGameplayOptions]
	xor %00010000
	ld [wGameplayOptions], a
	;fall through
Show60FPSSetting:
	ld hl, OptionMenuFPSText
	ld a, [wGameplayOptions]
	bit 4, a
	jr nz, .done
	inc hl
	inc hl
.done
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, $11, $2
	call PlaceString
	ret
OptionMenuFPSText:
	dw OptionMenu60FPS
	dw OptionMenu30FPS
OptionMenu60FPS:
	db "60@"
OptionMenu30FPS:
	db "30@"

	
;joenote - for lagless text option
ToggleLaglessText:
	ld a, [wOptions]
	and %11111001
	xor TEXT_DELAY_FAST
	ld [wOptions], a
	;fall through
ShowLaglessTextSetting:
	ld hl, OptionMenuOnOffText
	ld a, [wOptions]
	and TEXT_DELAY_BITS
	jr z, .print
	inc hl
	inc hl
.print
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, $10, $03
	call PlaceString
	ret

;joenote - for toggling the color correction
ToggleGammaShader:
	ld a, [hGBC]
	and a
	ret z	;do nothing if on dmg or sgb
	xor %00000011
	ld [hGBC], a

	ld a, [wGameplayOptions]
	xor %00100000
	ld [wGameplayOptions], a
	bit 5, a
;GBCNote - RunDefaultPaletteCommand which messes up enhanced GBC colors
;set a flag for prevent this from happening
	ld hl, hFlagsFFFA
	set 5, [hl]
	call RunDefaultPaletteCommand
	ld hl, hFlagsFFFA
	res 5, [hl]
	;fall through
ShowGammaSetting:
	ld hl, OptionMenuOnOffText
	ld a, [hGBC]
	cp 2
	jr z, .print
	inc hl
	inc hl
.print
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, $10, $4
	call PlaceString
	ret


;joenote - for enhanced GBC colors option
ToggleEnhancedGBCColors:
	ld a, [hGBC]
	and a
	ret z	;do nothing if on dmg or sgb
	ld a, [wGameplayOptions]
	xor ENH_GBC_COLORS
	ld [wGameplayOptions], a
	call RunDefaultPaletteCommand
	;fall through
ShowEnhancedGBCSetting:
	ld hl, OptionMenuOnOffText
	ld a, [hGBC]
	and a
	jr z, .off
	ld a, [wGameplayOptions]
	bit BIT_ENH_GBC_COLORS, a
	jr nz, .print
.off
	inc hl
	inc hl
.print
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, $10, $5
	call PlaceString
	ret


;joenote - for hard mode option
ToggleHardMode:
	ld a, [wOptions]
	xor BATTLE_HARD_MODE
	ld [wOptions], a
	;fall through
ShowHardModeSetting:
	ld hl, OptionMenuOnOffText
	ld a, [wOptions]
	bit BIT_BATTLE_HARD, a
	jr nz, .print
	inc hl
	inc hl
.print
	ld e, [hl]
	inc hl
	ld d, [hl]
	coord hl, $10, $8
	call PlaceString
	ret


;joenote - show /toggle nuzlocke mode
ToggleNuzlocke:
	ld a, [wGameplayOptions]
	xor %01000000
	ld [wGameplayOptions], a
	bit 6, a
	;fall through
ShowNuzlocke:
	ld de, OptionMenuTextOFF
	ld a, [wGameplayOptions]	;check if nuzlocke is active
	bit 6, a
	jr z, .print
	ld de, OptionMenuTextON
.print
	coord hl, $10, $9
	call PlaceString
	ret

;joenote - show /toggle random trainers
ToggleRandomTrainers:
	CheckEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
	jr nz, .setOff
	; else fallthough
.setOn
	SetEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
	jr ShowRandomTrainers
.setOff
	ResetEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
	;fall through
ShowRandomTrainers:
	ld de, OptionMenuTextOFF
	CheckEvent EVENT_ENABLE_NORMAL_TRAINER_RANDOMIZATION
	jr z, .print
	ld de, OptionMenuTextON
.print
	coord hl, $10, $0A
	call PlaceString
	ret

;joenote - show /toggle random wilderness
ToggleRandomWild:
	; is wild random disabled 
	CheckEvent EVENT_ENABLE_WILD_RANDOM
	jr z, .setTiers ; from off to tiers
	; else is wild random tiers disabled
	CheckEvent EVENT_ENABLE_WILD_RANDOM_TIERS
	jr nz, .setChaos ; from tiers to chaos
	; else from chaos to off
.setOff
	ResetEvent EVENT_ENABLE_WILD_RANDOM
	ResetEvent EVENT_ENABLE_WILD_RANDOM_TIERS
	jr ShowRandomWild
.setTiers
	SetEvent EVENT_ENABLE_WILD_RANDOM
	SetEvent EVENT_ENABLE_WILD_RANDOM_TIERS
	jr ShowRandomWild
.setChaos
	SetEvent EVENT_ENABLE_WILD_RANDOM
	ResetEvent EVENT_ENABLE_WILD_RANDOM_TIERS
	;fall through
ShowRandomWild:
	ld de, OptionMenuRandomWildOff
	CheckEvent EVENT_ENABLE_WILD_RANDOM
	jr z, .print
	ld de, OptionMenuRandomWillTier
	CheckEvent EVENT_ENABLE_WILD_RANDOM_TIERS
	jr nz, .print
	ld de, OptionMenuRandomWildChaos
	;fall through
.print
	coord hl, $0E, $0B
	call PlaceString
	ret

OptionMenuRandomWildOff:
	db "  Non@"
OptionMenuRandomWillTier:
	db "Tiers@"
OptionMenuRandomWildChaos:
	db "Chaos@"


TextAudio:
	db " Audio@"
TextFPS:
	db " FPS@"
TextInstant:
	db " Texte inst.@"
TextHardMode:
	db " Mode diffi.@"
TextGamma:
	db " Gamma@"
TextEnhancedGBC:
	db " Palette comp.@"
TextBack:
	db " Retour   Select",$E3,$ED,"@"

TextNuzlocke:
	db " Nuzlocke@"
TextRandomTrainer:
	db " Dres. aléa.@"
TextRandomWild:
	db " <PK><MN> aléa.@"
	
OptionMenuOnOffText:
	dw OptionMenuTextON
	dw OptionMenuTextOFF
OptionMenuTextON:
	db "Oui@"
OptionMenuTextOFF:
	db "Non@"

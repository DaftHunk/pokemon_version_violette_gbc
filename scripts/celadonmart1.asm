CeladonMart1Script:
	jp EnableAutoTextBoxDrawing

CeladonMart1TextPointers:
	dw CeladonMart1Text1
	dw CeladonMart1Text2
	dw CeladonMart1Text3
	dw CeladonMart1Text_Phone

CeladonMart1Text1:
	TX_FAR _CeladonMart1Text1
	db "@"

CeladonMart1Text2:
	TX_FAR _CeladonMart1Text2
	db "@"

CeladonMart1Text3:
	TX_FAR _CeladonMart1Text3
	db "@"

CeladonMart1Text_Phone:
	TX_ASM
	ld hl, .askCall
	call PrintText

	; ask for call
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .answerNo
	; else

	ld a, $FF
	call PlaySound

	ld hl, .startCall
	call PrintText

	call DialPhone

	ld a, SFX_SNARE_3
	call PlaySoundWaitForCurrent
	ld c, 5
	call DelayFrames
	ld a, $FF
	call PlaySound
	ld a, SFX_SNARE_8
	call PlaySound

	ld c, BANK(Music_PalletTown)
	ld a, MUSIC_PALLET_TOWN
	call PlayMusic

	ld hl, .momCall
	call PrintText

	ld a, SFX_SNARE_3
	call PlaySoundWaitForCurrent
	ld c, 5
	call DelayFrames
	ld a, $FF
	call PlaySound
	ld a, SFX_SNARE_8
	call PlaySound
	ld hl, .stopCall
	call PrintText
	call PlayDefaultMusic
	
	jp TextScriptEnd

.answerNo
	ld hl, .quitCall
	call PrintText
	jp TextScriptEnd

.quitCall
	text "Vous reposez le"
	line "combiné."
	done
	db "@"

.askCall
	text "Appeler Maman?"
	done
	db "@"

.startCall
	text "C'est parti!"
	line "Composition..."
	done
	db "@"

.momCall
	text "Allo?"
	line "Oh je suis si"
	cont "contente que tu"
	cont "ais pensé à"
	cont "m'appeler!"

	para "Ils ont parlé de"
	line "toi à la télé!"
	cont "Je suis si fière"
	cont "de toi <PLAYER>!"

	para "Chen est là aussi"
	line "il te passe le"
	cont "bonjour!"

	para "N'oublie pas de"
	line "brosser les dents"
	cont "et reviens nous"
	cont "nous voir dès"
	cont "que tu peux!"

	para "Gros bisous,"
	line "je t'aime!"
	prompt
	db "@"

.stopCall
	text "Crac!"
	done
	db "@"

; Credit PureRGB
DialPhone:
	; dial
	ld b, 4
.loopdial
	ld a, SFX_SWITCH
	call PlaySound
	dec b
	jr z, .donedial
	ld c, 20
	call DelayFrames
	jr .loopdial
.donedial
	ld c, 50
	call DelayFrames

	; call outgoing sounds 
	call Random
	and %11 ; 0-3 rings
	ld b, a
	jr nz, .loop
	inc b ; if it's 0, increase it to 2
	inc b ; 50% of the time we'll get 2 rings
.loop
	push bc
	ld b, 60
.loop2
	push bc
	ld a, SFX_TURN_OFF_PC
	call PlaySound
	ld c, 2
	call DelayFrames
	pop bc
	dec b
	jr nz, .loop2
	pop bc
	dec b
	jr z, .doneOutgoing
	ld a, $FF
	call PlaySound
	ld c, 120
	call DelayFrames
	jr .loop
.doneOutgoing
	; phone gets picked up
	ld a, $FF
	call PlaySound
	ld c, 10
	call DelayFrames
	ld a, SFX_SNARE_1
	call PlaySound
	ld c, 5
	call DelayFrames
	ld a, $FF
	call PlaySound
	ld a, SFX_TRIANGLE_1
	call PlaySound
	ld c, 10
	call DelayFrames
	ret

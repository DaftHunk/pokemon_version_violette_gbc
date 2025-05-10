;joenote - add secret cave for mist_stone with associated warps
DiglettsCaveScript:
	jp EnableAutoTextBoxDrawing

DiglettsCaveTextPointers:
;	db "@"
	dw Mist_Stone_Text
	dw BoulderText
	
Mist_Stone_Text:
	TX_ASM
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a

	ld hl, _TXTBookDesc
	call PrintText
	call .choice
	jr nz, .end
	
	ld hl, _TXTBookP1
	call PrintText
	call .choice
	jr nz, .end
	
	ld hl, _TXTBookP2
	call PrintText
	call .choice
	jr nz, .end

	ld hl, _TXTBookP3
	call PrintText
	call .choice
	jr nz, .end
	
	ld hl, _TXTBookP4
	call PrintText

	CheckEvent EVENT_GOT_SACHA_STONE
	jr nz, .end

	lb bc, MOON_STONE, 1
	call GiveItem
	ld hl, _TXTBag
	jr nc, .next	;jump if not enough room in bag

	SetEvent EVENT_GOT_SACHA_STONE
	ld hl, _TXTSacha_Stone
	call PrintText
	ld a, SFX_GET_ITEM_1
	call PlaySound 
	call WaitForSoundToFinish
	jr .end

.next
	call PrintText
.end
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld [hJoyHeld], a
	jp TextScriptEnd
.choice
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	ret
	
_TXTBookDesc:
	text "Ce journal est"
	line "pourri par la"
	cont "brume épaisse"
	cont "de cette cave."

	para "Certaines parties"
	line "sont encore"
	cont "lisibles. Essayer"
	cont "de les lire?"
	done
	db "@"

_TXTBookP1:
	text "C'est ma Salle"
	line "Secrète. Elle a"
	cont "été creusée par"
	cont "un groupe de"
	cont "Taupiqueur."

	para "En lire plus?"
	done
	db "@"

_TXTBookP2:
	text "J'ai entendu dire"
	line "que Léo a un"
	cont "Jardin Secret"
	cont "derrière"
	cont "sa maison."
	
	para "Mais il ne l'a"
	line "jamais confirmé"
	cont "ou démenti."
	
	para "Peut-être que si"
	line "je lui montre"
	cont "une nouvelle"
	cont "espèce de"
	cont "#mon..."
	
	para "Continuer à lire?"
	done
	db "@"
	
_TXTBookP3:
	text "Il parait que la"
	line "Pierre Brume peut"
	cont "libérer le"
	cont "potentiel caché"
	cont "d'un #mon."
	
	para "Où la trouver?"
	line "Peut-être ici,"
	cont "dans cet endroit."
	
	para "L'air brumeux de"
	line "cette cave"
	cont "devrait fournir"
	cont "les bonnes"
	cont "conditions."
	
	para "Vous trouvez une"
	line "note griffonnée,"
	cont "la lire?"
	done
	db "@"

_TXTBookP4:
	text "J'ai trouvé la"
	line "Pierre! Merci"
	cont "pour l'info!"

	para "PS: j'ai laissé"
	line "un petit cadeau"
	cont "en remerciement."
	cont "Sacha."
	prompt
	db "@"

_TXTSacha_Stone:
	text "Vous recevez la"
	line "Pierre Lune!@@"
	db "@"

_TXTBag:
	text "Votre sac"
	line "est plein."
	done
	db "@"

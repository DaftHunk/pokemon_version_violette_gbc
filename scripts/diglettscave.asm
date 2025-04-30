;joenote - add secret cave for mist_stone with associated warps
DiglettsCaveScript:
	jp EnableAutoTextBoxDrawing

DiglettsCaveTextPointers:
;	db "@"
	dw Mist_Stone_Text
	dw BoulderText
	
Mist_Stone_Text:
	TX_ASM

	CheckEvent EVENT_GOT_MIST_STONE
	jr nz, .read_book
	
	CheckEvent EVENT_MIST_STONE
	jr z, .read_book
	
.mist_stone
	;give MIST_STONE item
	lb bc, MIST_STONE, 1
	call GiveItem
	ld hl, _TXTBag
	jr nc, .next	;jump if not enough room in bag
	SetEvent EVENT_GOT_MIST_STONE
	ld hl, _TXTMist_Stone
	call PrintText
	ld a, SFX_GET_ITEM_1
	call PlaySound 
	call WaitForSoundToFinish
	jr .end

.read_book		
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
	
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, _TXTBookP3
.next
	call PrintText
.end
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
	line "que Bill a un"
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
	line "cette cave devrait"
	cont "fournir les bonnes"
	cont "conditions."
	done
	db "@"
	
_TXTMist_Stone:
	text "Sous le journal"
	line "moisi se trouve"
	cont "une petite"
	cont "crevasse dans"
	cont "le sol."
	
	para "Un objet brille"
	line "faiblement à"
	cont "l'intérieur."
	
	para "Vous recevez la"
	line "Pierre Brume!@@"
	db "@"
	
_TXTBag:
	text "Il y a quelque"
	line "chose ici"
	cont "mais votre sac"
	cont "est plein."
	done
	db "@"

_CeladonMartRoofText_484ee::
	text "Quelle boisson"
	line "lui offrir?"
	done

_CeladonMartRoofText_484f3::
	text "Ouais ouais!"

	para "DE L'EAU!"

	para "C'est cool!"

	para "Tiens...c'est"
	line "pour toi!@@"
	_CeladonMartRoofText_484f9::
	text "<PLAYER> reçoit"
	line "@"
	TX_RAM wcf4b
	text "!@@"

_CeladonMartRoofText_484fe::
	db $0
	para "@"
	TX_RAM wcf4b
	text ":"
	line "Laser Glace!"

	para "Cette attaque"
	line "pourra geler"
	cont "l'ennemi!@@"
	
_CeladonMartRoofText_48504::
	text "Ouaiiis!"

	para "Du Soda Cool!"

	para "Merciiii!"

	para "Tiens, prends ça!@@"
	
_CeladonMartRoofText_4850a::
	text "<PLAYER> reçoit"
	line "@"
	TX_RAM wcf4b
	text "!@@"

_CeladonMartRoofText_4850f::
	db $0
	para "@"
	;TX_RAM wcf4b
	;text ":"	;joenote - don't dynamically call the name as it just messes up the text borders
	text "CT48:"
;	line "EBOULEMENT!"	;joenote - this is inaccurate in gen 1, and Yellow removes this text.
;
;	para "Cette attaque"
;	line "peut faire peur"
;	cont "à l'ennemi!@@"
	line "Eboulement!@@"
	
_CeladonMartRoofText_48515::
	text "Ouaiiis!"

	para "D'la Limonade!"

	para "Top top top!"

	para "V'là pour toi!@@"
	
_ReceivedTM49Text::
	text "<PLAYER> reçoit:"
	line "CT49!@@"

_CeladonMartRoofText_48520::
	db $0
	para "CT49..."
	line "Triplattaque!@@"

_CeladonMartRoofText_48526::
	text "Plus de place!@@"

_CeladonMartRoofText_4852c::
	text "Heu..."
	line "Non merci."
	cont "A pu soif!@@"

_CeladonMartRoofText1::
	text "Ma soeur est"
	line "dresseur. Tu le"
	cont "crois, ça?"

	para "Mais c'est une"
	line "p'tite peste!"
	cont "Elle m'agace!"
	done

_CeladonMartRoofText_48598::
	text "N'ai soif!"
	line "Ne veux boire!"
	done

_CeladonMartRoofText4::
	text "N'ai soif!"
	line "Ne veux boire!"
	done

_CeladonMartRoofText6::
	text "Dernier Etage:"
	line "Distributeurs"
	done

_VendingMachineText1::
	text "Un distributeur!"
	line "Que choisir?"
	prompt

_VendingMachineText4::
	text "Oups! Pas assez"
	line "d'argent!"
	done

_VendingMachineText5::
	text "Et hop!"
	line "@"
	TX_RAM wcf4b
	text "!"
	done

_VendingMachineText6::
	text "L'inventaire est"
	line "plein!"
	done

_VendingMachineText7::
	text "Pas soif!"
	done

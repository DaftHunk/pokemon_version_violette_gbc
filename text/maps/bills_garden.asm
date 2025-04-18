;Joenote - setting up the Red battle
; dafthunk : Replaced with Sacha
_BillsGarden_SachaGreet::
	text "Salut! Je suis"
	line "Sacha du Bourg"
	cont "Palette!"

    para "Ah toi aussi tu"
    line "viens de là-bas?"

    para "Donc tu as eu"
    line "un des Pokémons"
    cont "du Prof.Chen!"

    para "Euh, oui je suis"
    line "le fameux"
    cont "retardataire."
    
    para "Bref, en tout cas,"
	line "j'étais sur la"
	cont "route pour"
    cont "affronter à nou-"
	cont "veau la ligue"
    cont "mais j'ai vu un"
    cont "magnifique oiseau"
    cont "dans le ciel."

    para "Je suis sûr de"
    line "l'avoir déjà vu"
    cont "quelque part!"
	prompt

_BillsGarden_SachaBattle::
	text "Ah toi aussi il"
    line "t'intéresse?"
	cont "Alors accepte"
	cont "mon défi!"

	para "Je te préviens,"
	line "ma stratégie"
	cont "est sans faille!"
	prompt
	
_BillsGarden_SachaPrebattle::
	text "Pikachu, je"
	line "te choisis!"
	done
	
_BillsGarden_SachaAfterBattle::
	text "..."
	line "Un jour je serai"
	cont "le meilleur"
	cont "dresseur!"
	prompt

_BillsGarden_SachaDecline::
	text "Pas de soucis,"
	line "je comprends."
	done

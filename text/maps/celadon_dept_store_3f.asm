_TM18PreReceiveText::
	text "J'ai fini!!!!"
	line "J'ai fini"
	cont "#mon!!!!"

	para "Pas toi? Yahaha!"
	line "Prends donc ceci,"
	cont "petit!"
	prompt

_ReceivedTM18Text::
	text "<PLAYER> reçoit"
	line "@"
	TX_RAM wcf4b
	text "!@@"

_TM18ExplanationText::
	text "CT18: RIPOSTE!"
	line "Bon allez..."
	cont "Bonne chance!"
	
	para "It meets NORMAL"
	line "or FIGHTING moves"
	cont "with 2x damage!"
	done

_TM18NoRoomText::
	text "Ton sac est plein"
	line "à craquer!"
	done

_CeladonMart3Text2::
	text "Tous les #mon"
	line "capturés ont un"
	cont "numéro d'immatri-"
	cont "culation et un"
	cont "nom de DO"
	cont "(Dresseur"
	cont "d'Origine)!"
	done

IF DEF(_JPTXT)	;joenote - this was changed in the localization for some reason
_CeladonMart3Text3::
	text "Ouaiiis!"

	para "Mon pote va"
	line "m'échanger son"
	cont "Kangourex contre"
	cont "mon Spectrum!"
	done

_CeladonMart3Text4::
	text "Viens, mon doux"
	line "Spectrum!"

	para "Je suis fou de"
	line "Spectrum!"

	para "... ...Hein?"

	para "Spectrum s'est"
	line "transformé en un"
	cont "autre #mon!"
	done
ELSE
_CeladonMart3Text3::
	text "Ouaiiis!"

	para "Mon pote va"
	line "m'échanger son"
	cont "Kangourex contre"
	cont "mon Gravalanch!"
	done

_CeladonMart3Text4::
	text "Cool! Un"
	line "Gravalanch!"

	para "J'adore les"
	line "Gravalanch!"

	para "Qu...Hein??"

	para "Gravalanch se"
	line "transforme en un"
	cont "autre #mon!"
	done
ENDC

_CeladonMart3Text5::
	text "Le numéro d'imma-"
	line "triculation d'un"
	cont "#mon sert à"
	cont "l'identifier lors"
	cont "d'un échange!"
	done

_CeladonMart3Text6::
	text "Une SUPER"
	line "NINTENDO!"
	done

_CeladonMart3Text7::
	text "Un RPG! Cool..."
	line "Mais trop dur!"
	done

_CeladonMart3Text9::
	text "Un jeu de sport!"
	line "Vive le foot!"
	done

_CeladonMart3Text11::
	text "Quatre lignes!"
	line "En un seul coup!"
	done

_CeladonMart3Text13::
	text "Kan contre Ryo!"
	line "Hadoh Ken!"
	done

_CeladonMart3Text14::
	text "2ème: JEUX VIDEO"
	done

_CeladonMart3Text15::
IF DEF(_JPTXT)
	text "Rouge et Vert!"
ELSE
	text "Rouge et Bleu!"
ENDC
	line "Deux #mon!"
	done

_CeladonMart3Blocker::
	text "This vendor will"
	line "be open after the"
	cont "#mon League"
	cont "Championship."
	
	para "Come back to buy"
	line "rare new items"
	cont "from SILPH CO."
	
	para "Phew!"
	line "It is really hot"
	cont "in this costume."
	done
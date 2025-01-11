_DaisyInitialText::
	text "Salut <PLAYER>!"
	line "<RIVAL> est dans"
	cont "le labo de pépé! "
	done

_DaisyOfferMapText::
	text "Tu dois faire une"
	line "course pour pépé?"
	cont "Prends ceci,"
	cont "ça peut servir!"
	prompt

_GotMapText::
	text "<PLAYER> obtient:"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_DaisyBagFullText::
	text "Votre inventaire"
	line "est plein."
	done

_DaisyUseMapText::
	text "Utilise la CARTE"
	line "pour connaître ta"
	cont "position."
	done

_BluesHouseText2::
	text "Les #MON sont"
	line "vivants! Une fois"
	cont "fatigués, ils"
	cont "doivent se"
	cont "reposer!"
	done

IF DEF(_JPTXT)
_BluesHouseText3::
	text "A map of Kanto!"
	line "...... Wouldn't"
	cont "it be nice if you"
	cont "could have it?"
	done
ELSE
_BluesHouseText3::
	text "C'est une carte!"
	line "Ca peut être"
	cont "utile!"
	done
ENDC

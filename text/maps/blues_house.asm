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
	text "Utilise la Carte"
	line "pour connaître ta"
	cont "position."
	done

_BluesHouseText2::
	text "Les #mon sont"
	line "vivants! Une fois"
	cont "fatigués, ils"
	cont "doivent se"
	cont "reposer!"
	done

_BluesHouseText3::
	text "Une carte de"
	line "Kanto! Ca serait"
	cont "cool de l'avoir,"
	cont "non?"
	done

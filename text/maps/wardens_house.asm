_WardenGibberishText1::
	text "Gardien: Hif fuff"
	line "hefifou!"

	para "Ha fof ha fif eu"
	line "hafahi ho. Heff"
	cont "hi fwi!"
	done

_WardenGibberishText2::
	text "Ah hahee ho hoo!"
	line "Eef ee hafahi ho!"
	done

_WardenGibberishText3::
	text "Ha? Hai fou heh"
	line "ha hoo ih haheh!"
	done

_WardenTeethText1::
	text "<PLAYER> donne la"
	line "Dent d'or au"
	cont "Gardien!@"
	text_end

_WardenTeethText2::
	text_start

	para "Le Gardien peut"
	line "remettre son"
	cont "dentier!"
	prompt

_WardenThankYouText::
	text "Gardien: Merci,"
	line "gamin! C'est un"
	cont "peu dur de me"
	cont "faire comprendre."

	para "J'pouvais plus"
	line "travailler!"
	cont "Quelle horreur!"
	cont "Tiens, voilà pour"
	cont "te remercier."

;joenote - add hotkey info
	para "Appuie sur SELECT"
	line "face à un rocher"
	cont "pour l'activer."	
	prompt

_ReceivedHM04Text::
	text "<PLAYER> reçoit"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_HM04ExplanationText::
	text "Gardien: CS04..."
	line "Force!"

	para "Tes #mon"
	line "pourront déplacer"
	cont "des rochers."

	para "Au fait, as-tu"
	line "trouvé la Cabane"
	cont "Secrète dans le"
	cont "Parc Safari?"

	para "Trouve-la et"
	line "gagne une CS!"

	para "On raconte que"
	line "cette CS est... "
	cont "Surf!"
	done

_HM04NoRoomText::
	text "Ton sac est"
	line "plein!"
	done

_FuchsiaHouse2Text_75176::
	text "Photos et"
	line "fossiles de"
	cont "#mon."
	done

_FuchsiaHouse2Text_7517b::
	text "Tout plein de"
	line "trucs #mon!"
	done

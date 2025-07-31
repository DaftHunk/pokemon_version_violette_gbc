_TM35PreReceiveText::
	text "Tiens tiens!"
	line "Je viens de créer"
	cont "une CT sympa!"

	para "Elle provoque des"
	line "trucs étranges!"
	prompt

_ReceivedTM35Text::
	text "<PLAYER> reçoit:"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_TM35ExplanationText::
	text "Tik-Tak-Tik-Tak!"
	line "C'est le bruit du"
	cont "Métronome!"

	para "Cette technique"
	line "fait de la purée"
	cont "avec le cerveau"
	cont "d'un #mon et le"
	cont "force à utiliser"
	cont "des techniques"
	cont "inconnues!"
	done

_TM35NoRoomText::
	text "Votre inventaire"
	line "est plein!"
	done

_Lab3Text2::
	text "Evoli évolue en"
	line "3 #mon de"
	cont "type différent."
	done

_Lab3Text3::
	text "Il y a un e-mail!"

	para "..."

	para "Les 3 #mon"
	line "légendaires sont:"
	cont "Artikodin,"
	cont "Electhor et"
	cont "Sulfura."

	para "On ne sait rien"
	line "d'eux."

	para "Nous allons"
	line "explorer les"
	cont "grottes près de"
	cont "Azuria."

	para "De: L'équipe de"
	line "Recherche #mon"

	para "..."
	done

_Lab3Text5::
	text "Un tuyau à ambre!"
	done

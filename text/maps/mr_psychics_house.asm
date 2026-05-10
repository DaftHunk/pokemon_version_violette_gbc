_TM46PreReceiveText::
	text "...Chut! Pas un"
	line "mot!"

	para "Tu veux ça?"
	prompt

_ReceivedTM46Text::
	text "<PLAYER> obtient:"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_TM46ExplanationText::
	text "CT46: Vibrobscur!"

	para "Cette attaque"
	line "peut foutre la"
	cont "pétoche à sa"
	cont "cible!"
	done

_TM46NoRoomText::
	text "Ton inventaire"
	line "est plein!"
	done

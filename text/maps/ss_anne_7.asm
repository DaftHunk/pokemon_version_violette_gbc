_SSAnne7RubText::
	text "Capitaine: Blorf."
	line "J'suis pas bien."
	cont "Beurp..."

	para "<PLAYER> masse"
	line "le dos du"
	cont "Capitaine!"

	para "Scratch..."
	line "Scratch...@"
	text_end

_ReceivingHM01Text::
	text "Capitaine: Merci"
	line "moussaillon!"
	cont "Ça va beaucoup"
	cont "mieux..."

	para "Mille sabords!"
	line "Tu veux voir"
	cont "la technique"
	cont "Coupe?"

	para "Je pourrais te la"
	line "montrer, mais"
	cont "j'suis malade."

	para "Je sais!"
	line "Prends ça!"

	para "C'est la technique"
	line "Coupe."
	cont "Enseigne-la à"
	cont "tes #mon!"
	
;joenote - add hotkey info
	para "Appuyer sur SELECT"
	line "devant un buisson"
	cont "pour l'utiliser."	
	prompt

_ReceivedHM01Text::
	text "<PLAYER> obtient"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_SSAnne7Text_61932::
	text "Capitaine: Haaaa!"

	para "Maintenant que"
	line "je suis guéri, on"
	cont "va lever l'ancre!"
	done

_HM01NoRoomText::
	text "Ha zut! Tu n'as"
	line "plus de place"
	cont "pour cet objet!"
	done

_SSAnne7Text2::
	text "Quoi?!?"
	line "Il a mangé ça???"
	done

_SSAnne7Text3::
	text "Comment guérir"
	line "le mal de mer..."
	cont "Le Capitaine lit"
	cont "ce manuel!"
	done

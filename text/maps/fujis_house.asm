_LavenderHouse1Text_1d8d1::
	text "Ce sacré M.Fuji"
	line "n'est pas là."
	cont "Où est-il?"
	done

_LavenderHouse1Text_1d8d6::
	text "M.Fuji a prié"
	line "pour le repos de"
	cont "la mère de"
	cont "Osselait."
	done

_LavenderHouse1Text_1d8f4::
	text "Voici la maison"
	line "de M.Fuji."

	para "C'est vraiment un"
	line "chic type!"

	para "Il est à la"
	line "recherche des"
	cont "#mon orphelins"
	cont "et abandonnés!"
	done

_LavenderHouse1Text_1d8f9::
	text "C'est si doux!"
	line "Faire un câlin à"
	cont "un #mon,"
	cont "c'est chou!"
	done

_LavenderHouse1Text3::
	text "Psykokwak: Kwak!@"
	text_end

_LavenderHouse1Text4::
	text "Nidorino: Nido!@"
	text_end

_LavenderHouse1Text_1d94c::
	text "M.Fuji: <PLAYER>."

	para "Ta quête pour"
	line "compléter ton"
	cont "#dex échouera"
	cont "si tu n'aimes pas"
	cont "tes #mon."

	para "Je crois que ceci"
	line "te sera utile."
	prompt

_ReceivedFluteText::
	text "<PLAYER> obtient:"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_FluteExplanationText::
	text_start

	para "En jouant de la"
	line "#Flute, les"
	cont "#mon endormis"
	cont "se réveilleront."

	para "Elle marche sur"
	line "tous les #mon."
	done

_FluteNoRoomText::
	text "Votre inventaire"
	line "est plein!"
	done

_MrFujiAfterFluteText::
	text "M.Fuji: Ma Flute"
	line "t'a été utile?"
	done

_LavenderHouse1Text6::
	text "Grand concours de"
	line "dessin de"
	cont "#mon!"

	para "Le formulaire"
	line "d'inscription"
	cont "est..."

	para "...Hein? Il a"
	line "disparu!"
	done
;;;;;;;;;;;;;;;;;;;;;;joenote - adding text for fuji battle
_FujiText_challenge::
	text "Do you challenge"
	line "M.Fuji to a"
	cont "#mon battle?"
	done

_FujiText_prebattle::
	text "So you know about"
	line "my former life as"
	cont "a scientist."
	
	para "Then you also"
	line "know why I quit."
	
	para "The gene splicing"
	line "data, samples,"
	cont "test subjects..."
	
	para "All was cast into"
	line "the waters of an"
	cont "UNKNOWN DUNGEON"
	
	para "I'd advise you to"
	line "stay away from"
	cont "there and leave"
	cont "the past buried."
	done

_FujiTextVictorySpeech::
	text "Hmm..."
	line "I'm a bit worried."
	
	para "The test DITTOS"
	line "might still be"
	cont "replicating."
	
	para "Who knows what"
	line "kind of #mon"
	cont "they might have"
	cont "cloned themselves"
	cont "into?"

	para "Go if you must."
	line "Maybe it's you"
	cont "who can help fix"
	cont "past mistakes."

	para "SILPH's Chef is"
	line "an old friend, so"
	cont "battle him too."
	prompt
	
_FujiTextMewtwo::
	text "That Mewtwo you"
	line "have with you..."
	
	para "...Such an angry"
	line "disposition. Yet"
	cont "you have soothed"
	cont "its wrath."
	
	para "You must possess"
	line "a great love for"
	cont "your #mon."
	
	para "Take this. I have"
	line "no reason to keep"
	cont "holding onto it."
	prompt

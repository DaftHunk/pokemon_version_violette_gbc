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
	text "M.Fuji: Tu veux me"
	line "défier dans un"
	cont "duel #mon?"
	done

_FujiText_prebattle::
	text "Alors tu connais"
	line "mon passé de"
	cont "scientifique."
	
	para "Tu dois savoir"
	line "pourquoi je"
	cont "suis parti."
	
	para "Les données sur le"
	line "génome, les échan-"
	cont "tillons, les su-"
	cont "jets de tests..."
	
	para "Tout ce travail"
	line "jeté dans les eaux"
	cont "de la Caverne"
	cont "Azurée."
	
	para "Je te conseille de"
	line "rester loin de ce"
	cont "lieu et de laisser"
	cont "le passé enfoui."
	done

_FujiTextVictorySpeech::
	text "Hmm..."
	line "Je suis un peu"
	cont "inquiet..."
	
	para "Les sujets de test"
	line "Métamorph doivent"
	cont "toujours se"
	cont "répliquer."
	
	para "Qui sait en quel"
	line "type de #mon"
	cont "ils ont fini par"
	cont "se cloner?"

	para "Vas-y si tu le"
	line "dois. Peut-être"
	cont "que tu pourras"
	cont "arranger mes err-"
	cont "eurs du passé."

	para "Le PDG de la Syl-"
	line "phe est un vieil"
	cont "ami, tu devrais"
	cont "aussi lui rendre"
	cont "visite."
	prompt
	
_FujiTextMewtwo::
	text "Ce Mewtwo que tu"
	line "as avec toi..."
	
	para "...Possède une"
	line "telle haine."
	cont "Pourtant, tu"
	cont "sembles avoir"
	cont "apaisé sa colère."

	para "Tu dois avoir"
	line "un grand amour"
	cont "envers tes"
	cont "#mon."
	
	para "Prends ça. Je n'"
	line "ai aucune raison"
	cont "de le garder."
	prompt

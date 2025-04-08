_LanceBeforeBattleText::
	text "Ah! Enfin..."
	line "J'ai entendu"
	cont "parler de toi, "
	cont "<PLAYER>!"

	para "Je règne sur le"
	line "Conseil des 4!"
	cont "Mon nom est Peter"
	cont "le dresseur de"
	cont "dragons!"

	para "Les dragons sont"
	line "des #mon"
	cont "mystiques!"

	para "Les capturer et"
	line "les entraîner est"
	cont "difficile mais"
	cont "leurs pouvoirs"
	cont "sont supérieurs!"

	para "Ils sont presque"
	line "invincibles!"

	para "Le glas de la"
	line "défaite et de la"
	cont "honte sonne pour"
	cont "toi..."

	para "L'entends-tu?"
	done

_LanceEndBattleText::
	text "Incroyable!"

	para "Tu as bien mérité"
	line "le titre de..."
	cont "Maître #mon!"
	prompt

_LanceAfterBattleText::
	text "Comment mes"
	line "dragons ont-ils"
	cont "pu succomber à"
	cont "tes attaques,"
	cont "<PLAYER>?"

	para "Tu es désormais"
	line "champion de la"
	cont "Ligue #mon!"

	para "Enfin..."
	line "Pas tout à fait."
	cont "Une épreuve doit"
	cont "encore t'être"
	cont "imposée..."

	para "Un grand dresseur"
	line "t'attend. Son nom"
	cont "est..."

	para "<RIVAL>!"
	line "Il a vaincu le"
	cont "Conseil des 4"
	cont "avant toi!"

	para "Il est le vrai"
	line "champion #mon!@"
	text_end

_RematchLanceBeforeBattleText::
	text "Depuis notre der-"
	line "nière rencontre,"
	cont "je suis parti m'"
	cont "entrainer à Johto."

	para "Il parait qu'un"
	line "Léviator rouge au-"
	cont "rait été aperçu!"

	para "C'est une nouvelle"
	line "aussi exitante qu'"
	cont "inquiètante..."

	para "Bref, trêve de"
	line "grivoiserie, tu"
	cont "es ici pour te"
	cont "battre n'est-ce"
	cont "pas?"

	para "Alors en garde!"
	done

_RematchLanceEndBattleText::
	text "Incroyable!"
	line "Tu mérites ton"
	cont "rang en effet."
	prompt

_RematchLanceAfterBattleText::
	text "..."
	line "Tu vas rire mais"
	cont "<RIVAL> a"
	cont "profité de ton"
	cont "absence pour pr-"
	cont "endre sa revanche."

	para "Il t'attend à"
	line "côté <PLAYER>.@"
	text_end

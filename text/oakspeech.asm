_OakSpeechText1::
	text "Bien le bonjour!"
	line "Bienvenue dans le"
	cont "monde magique des"
	cont "#mon!"

	para "Mon nom est Chen!"
	line "Les gens souvent"
	cont "m'appellent le"
	cont "Prof #mon!"
	prompt

_OakSpeechText2A::
	text "Ce monde est"
	line "peuplé de"
	cont "créatures du nom"
	cont "de #mon!@@"

_OakSpeechText2B::
	text $51,"Pour certains,"
	line "les #mon sont"
	cont "des animaux"
	cont "domestiques, pour"
	cont "d'autres, ils"
	cont "sont un moyen de"
	cont "combattre."

	para "Pour ma part..."

	para "L'étude des"
	line "#mon est"
	cont "ma profession."
	prompt

_IntroducePlayerText::
	text "Tout d'abord,"
	line "quel est ton nom?"
	prompt

_IntroduceRivalText::
	text "Voici mon petit-"
	line "fils. Il est ton"
	cont "rival depuis sa"
	cont "toute jeunesse."

	para "...Heu..."
	line "C'est quoi donc"
	cont "son nom déjà?"
	prompt

_OakSpeechText3::
	text "<PLAYER>!"

	para "Ta quête des"
	line "#mon est sur"
	cont "le point de"
	cont "commencer!"

	para "Un tout nouveau"
	line "monde de rêves,"
	cont "d'aventures et"
	cont "de #mon"
	cont "t'attend! Dingue!"
	done

;joenote - ask if female trainer
_AskIfGirlText::
	text "Es-tu un garçon"
	line "ou une fille?"
	done

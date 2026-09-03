_SecretHouseText_Greeting::
	text "Ah! Quand même!"

	para "Tu es le premier"
	line "à découvrir la"
	cont "Cabane Secrète!"

	para "J'avais peur que"
	line "personne ne gagne"
	cont "notre prix."

	para "Félicitations!"
	line "Tu as gagné!"

;joenote - add hotkey info
	para "Appuie sur SELECT"
	line "devant de l'eau"
	cont "pour l'utiliser."	
	prompt

_SecretHouseText_PostLeagueGreeting::
	text "Oh! Tu es de"
	line "retour?"

	para "Merci de venir"
	line "passer me voir!"

	para "Pour te remercier"
	line "je vais te dire"
	cont "un petit secret."

	para "Avant, ce lieu"
	line "était un labo-"
	cont "ratoire secret!"
	done

_SecretHouseText_ReceivedHM03::
	text "<PLAYER> obtient:"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_SecretHouseText_HM03Explanation::
	text "CS03 est Surf!"

	para "Un #mon pourra"
	line "te faire naviguer"
	cont "sur les flots!"

	para "En plus, cette CS"
	line "peut s'utiliser à"
	cont "l'infini!"

	para "T'en as de la"
	line "chance, mon p'tit"
	cont "bouchon!"
	done

_SecretHouseText_HM03NoRoom::
	text "Heu... Tu n'as"
	line "pas assez de"
	cont "place!"
	done

;;;;;;;;;;;;;;;;;;;;;;joenote - adding text for Chief battle
_SecretHouseText_ChiefChallenge::
	text "Tu veux me défier"
	line "en duel #mon?"
	done

_SecretHouseText_ChiefPreBattle::
	text "Eh bien! Qui t'as"
	line "dit que"
	cont "j'entraînais"
	cont "des #mon?"
	
	para "C'est vrai. Je"
	line "suis accro au"
	cont "Parc Safari."
	
	para "J'y vais depuis"
	line "que j'ai à peu"
	cont "prêt ton âge."
	
	para "Cependant je suis"
	line "de plus en plus"
	cont "occupé par"
	cont "l'entreprise."

	para "Mais ça ne"
	line "m'empèche pas de"
	cont "trouver le temps"
	cont "pour m'amuser!"
	done

_SecretHouseText_ChiefPostBattle::
	text "Ah!"
	line "Le bon temps!"

	para "Rien ne vaut un"
	line "bon duel #mon"
	cont "pour décompresser,"
	cont "n'est-ce pas?"
	
	para "Durant mes safaris"
	line "j'ai rencontré"
	cont "une autre"
	cont "Championne en"
	cont "devenir qui"
	cont "travaille à"
	cont "Parmanie."
	
	para "Elle serait peut-"
	line "être aussi"
	cont "intéressée par"
	cont "un duel."
	prompt

_SecretHouseText_ChiefBye::
	text "Bon Safari!"
	done

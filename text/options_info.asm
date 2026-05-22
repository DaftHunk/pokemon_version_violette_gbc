
_DisplayTextSpeedInfoText::
	text "Détermine la"
 	line "vitesse du texte,"
	cont "3 étant le plus"
	cont "rapide."
 	prompt
	
_DisplayBattleAnimationInfoText::
	text "Afficher les"
 	line "animations en"
	cont "combat?"
 	prompt

_DisplayBattleStyleInfoText::
	text "Choix: demande de"
 	line "changer de #-"
	cont "mon après les KO."
	cont "Rend le jeu plus"
	cont "facile."

	para "Défini: vous êtes"
	line "soumis aux mêmes"
	cont "règles que votre"
	cont "adversaire."
 	prompt

_DisplayAudioInfoText::
	text "Choix du type de"
 	line "sortie audio."

	para "A noter que la"
	line "Stéréo peut"
	cont "rendre bizarre."
 	prompt

_DisplayFPSInfoText::
	text "Permet de passer"
 	line "entre 30 et 60"
	cont "FPS."
 	prompt

_DisplayInstantTextText::
	text "Rend les textes"
 	line "instantanés."

	para "Peut faire sauter"
	line "certains effets"
	cont "sonores."
 	prompt
	
_DisplayGammaInfoText::
	text "Désature les"
 	line "couleurs afin de"
	cont "corriger"
	cont "l'affichage sur"
	cont "certains"
	cont "émulateurs comme"
	cont "mGBA."

	para "Ne s'applique"
	line "qu'en jeu,"
	cont "l'intro n'est"
	cont "pas modifiée."
 	prompt
	
_DisplayEnhancedGBCInfoText::
	text "Active la palette"
 	line "de couleur GBC"
	cont "complète."

	para "Désactivée, les"
	line "couleurs suivent"
	cont "les limites du"
	cont "jeu original."
 	prompt
	
_DisplayLevelCapInfoText::
	text "Active la limite"
 	line "de niveau maximum"
	cont "en fonction du"
	cont "nombre de Badge."

	para "Désactiver cette"
	line "option rend le"
	cont "jeu plus simple."
 	prompt
	
_DisplayHardModeInfoText::
	text "Ajoute des règles"
 	line "de difficulé"
	cont "supplémentaires:"

	para "-Dresseurs plus"
	line "durs, surtout"
	cont "après la Ligue"

	para "-IVs des ennemis"
	line "plus élevés"
    
	para "-EVs des ennemis"
	line "toujours au max"
	cont "de leur niveau"

	para "-Bonus de Badge"
	line "désactivés contre"
	cont "les dresseurs"

	para "-L'IA est un peu"
	line "plus intelligente"

	para "-Impossible de"
	line "faire Rappel en"
	cont "combat"

	para "-Objets X 2x"
	line "plus efficace"

	para "-Style de combat"
	line "Défini forcé"
 	prompt
	
_DisplayNuzlockeInfoText::
	text "Défi Nuzlocke:"
 	line "mode de jeu très"
	cont "difficile avec"
    cont "ces contraintes:"

    para "-Un #mon KO est"
    line "mort (Gelé, 1pv"
    cont "définitivement)"

    para "-Capture du 1er"
    line "#mon sauvage"
    cont "croisé de chaque"
    cont "zone uniquement"
    cont "(Le logo <PK> sera"
    cont "affiché)"

    para "-Débute dès"
    line "l'accès aux 1ère"
    cont "#balls"

    para "-Obligation de"
    line "renommer les"
    cont "#mon"
 	prompt
	
_DisplayRandomTrainersInfoText::
	text "Rend les équipes"
 	line "des dresseurs"
	cont "lambda aléatoires"
    cont "en gardant la"
    cont "même rareté."
 	prompt
	
_DisplayRandomWildInfoText::
	text "Mélange la liste"
 	line "des rencontres"
    cont "sauvages non"
    cont "statiques."
	
    para "-Tiers: garde"
    line "le même niveau"
    cont "de rareté"

    para "-Chaos: aléatoire"
    line "complet (très"
    cont "déséquilibré)"
 	prompt
	
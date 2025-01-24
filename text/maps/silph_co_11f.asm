_SilphCoPresidentText::
	text "PDG: Merci d'avoir"
	line "sauvé la Sylphe!"

	para "Je n'oublierai"
	line "jamais ton"
	cont "haut fait!"

	para "Tu mérites une"
	line "récompense!"

	para "L'argent n'est"
	line "pas un problème"
	cont "pour moi!"

	para "Tiens... Je crois"
	line "que ceci te fera"
	cont "plaisir!"
	prompt

_ReceivedSilphCoMasterBallText::
	text "<PLAYER> obtient:"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_SilphCo10Text_6231c::
	text "PDG: Tu ne peux"
	line "acheter ceci"
	cont "nulle part!"

	para "C'est notre"
	line "prototype secret:"
	cont "la MASTER BALL!"

	para "Elle pourra"
	line "attraper n'importe"
	cont "quel #mon!"

	para "Alors utilise-la"
	line "avec sagesse."
	done

_SilphCoMasterBallNoRoomText::
	text "Tu n'as pas assez"
	line "de place sur toi."
	done

_SilphCo11Text2::
	text "Secrétaire: Merci"
	line "de nous avoir"
	cont "tous sauvés!"

	para "Ton courage est"
	line "exemplaire."
	done

_SilphCo11Text3::
	text "Ah, <PLAYER>!"
	line "Une fois encore"
	cont "nos routes se"
	cont "croisent..."

	para "Le PDG et moi-"
	line "même discutons"
	cont "d'une affaire"
	cont "très importante."

	para "Viens pas t'mêler"
	line "de tout ça, mon"
	cont "bonhomme..."

	para "Dégage ou..."
	line "Déguste!"
	done

_SilphCo10Text_62330::
	text "Arrgh!!"
	line "Encore perdu!?"
	prompt

_SilphCo10Text_62335::
	text "NOoOoOoOon!"
	line "Notre invasion de"
	cont "la Sylphe est"
	cont "fichue!"

	para "Mais la Team"
	line "Rocket est"
	cont "invincible!"

	para "<PLAYER>! N'oublie"
	line "jamais que tous"
	cont "les #mon sont"
	cont "pour la Team"
	cont "Rocket!"

	para "Je pars, mais..."
	line "Ma vengeance te"
	cont "fera bobo!"
	done

_SilphCo11BattleText1::
	text "Holà toi!"
	line "Pas bouger!"
	done

_SilphCo11EndBattleText1::
	text "Non..."
	line "Pitié!"
	prompt

_SilphCo11AfterBattleText1::
	text "Tu cherches"
	line "l'embrouille?"
	done

_SilphCo11BattleText2::
	text "Halte! As-tu un"
	line "rendez-vous en"
	cont "règle avec mon"
	cont "chef?"
	done

_SilphCo11EndBattleText2::
	text "Gaah!"
	line "Cassé la tête!"
	prompt

_SilphCo11AfterBattleText2::
	text "Prends garde..."
	line "Les #mon de"
	cont "mon chef sont"
	cont "terribles!"
	done

_SilphCo10Text_6237b::
	text "Des #mon sur"
	line "le moniteur!"
	done

;;;;;;;;;;;;;;;;;;;;;;joenote - adding text for Chief battle
; mina : traduction svp jusqu'à la fin
_ChiefText_challenge::
	text "Do you challenge"
	line "him to a #mon"
	cont "battle?"
	done

_ChiefText_prebattle::
	text "Oh my! Who told"
	line "you that I train"
	cont "#mon?"
	
	para "It's true. I'm a"
	line "big Safari ZONE"
	cont "addict."
	
	para "Been so since I"
	line "was around your"
	cont "age, actually."
	
	para "Though, now I'm"
	line "mostly busy with"
	cont "the company."
	
	para "Doesn't mean I"
	line "don't find time"
	cont "for some fun!"
	done

_ChiefTextVictorySpeech::
	text "Ah!"
	line "Good times!"
	
	para "Nothing like a"
	line "#mon battle"
	cont "to unwind, eh?"
	
	para "I heard another"
	line "CHAMP was at the"
	cont "VERMILION dock."
	
	para "She might want"
	line "to have a battle"
	cont "with you."
	prompt
	
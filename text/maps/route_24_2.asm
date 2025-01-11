_Route24BattleText1::
	text "Je t'ai vu!"
	done

	_Route24EndBattleText1::
	text "Oh!"
	line "J'ai vu ma"
	cont "défaite!"
	prompt

_Route24AfterBattleText1::
	text "Je me cache, les"
	line "gens sur le pont"
	cont "me font peur!"
	done

_Route24BattleText2::
	text "OK! J'suis le 5!"
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	line "Cette fois, je"
	cont "serai ton"
	cont "partenaire."
ELSE
	line "J'vais te broyer!"
ENDC
	done

_Route24EndBattleText2::
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	text "Ouah!"
	line "Tu es trop"
	cont "sauvage pour moi!"
ELSE
	text "Ah!"
	line "Purée!"
ENDC
	prompt

_Route24AfterBattleText2::
	text "Pas de regrets,"
	line "j'ai fait de mon"
	cont "mieux!"
	done

_Route24BattleText3::
	text "Je suis la 4ème!"
	line "T'en veux encore?"
	done

_Route24EndBattleText3::
	text "Tu..."
	line "...m'as battue!"
	prompt

_Route24AfterBattleText3::
	text "J'ai participé,"
	line "et j'ai perdu!"
	done

_Route24BattleText4::
	text "Je suis le 3ème!"
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	line "Je ne finirai pas"
	cont "si rapidement!"
ELSE
	line "C'est pas gagné!"
ENDC
	done

_Route24EndBattleText4::
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	text "Pouah!"
	line "Je ne peux plus"
	cont "tenir."
ELSE
	text "Oh!"
	line "Tu m'as écrasé!"
ENDC
	prompt

_Route24AfterBattleText4::
	text "J'ai fait de mon"
	line "mieux!"
	done

_Route24BattleText5::
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	line "Je suis prête à"
	cont "y aller à fond!"
ELSE
	text "Je suis la 2ème!"
	line "Ca rigole plus!"
ENDC
	done

_Route24EndBattleText5::
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	text "C'était"
	line "incroyable."
ELSE
	text "Ben..."
	line "Tu m'as battue?"
ENDC
	prompt

_Route24AfterBattleText5::
	text "J'ai fait de mon"
	line "mieux!"
	cont "Aucun regrets!"	;joenote - girls are supposed to be slightly different
	done

_Route24BattleText6::
	text "Voici le PONT"
	line "PEPITE!"
	cont "5 dresseurs"
	cont "défendent ce"
	cont "pont! Bats-nous"
IF DEF(_JPTXT)	;joenote - dirty joke lost in translation
	cont "et gagne une"
	cont "surprise du sac"
	cont "de pépites!"
ELSE
	cont "et tu seras"
	cont "super content!"
ENDC

	para "Tu crois pouvoir"
	line "y arriver?"
	done

_Route24EndBattleText6::
	text "Haha!"
	line "Bien joué!"
	prompt

_Route24AfterBattleText6::
	text "J'ai fait de mon"
	line "mieux. Si si!"
	cont "C'est vrai!"
	done

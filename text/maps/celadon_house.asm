_CeladonHouseText1::
	text "Yahahaha!"
	line "Triple 7!!!"
	cont "Par ici l'pognon!"
	done

_CeladonHouseText2::
	text "CHEF!"

	para "2000 #MON ont"
	line "été envoyés comme"
	cont "prix de casino!"
	done

_CeladonHouseText3::
	text "Ne touche pas au"
	line "bouton sur le"
	cont "poster du CASINO!"

	para "Hein? Mais non"
	line "j'l'ai pas dit!"
	done

_CeladonHouseTextChiefIntro::	;joenote - adding text for selling pokemon
	text "Hehehe! The slots"
	line "just reel in the"
	cont "dough, big time!"
	
	para "But I'll run out"
	line "of prize #MON"
	cont "without the BOSS."
	
	para "Hey kid! Nice"
	line "@"
	TX_RAM wcd6d
	db $0
	cont "ya got there."

	para "I'll give you"
	line "¥@"
	TX_BCD hItemPrice, 3 | LEADING_ZEROES | LEFT_ALIGN
	text " for it!"
	done
	
_CeladonHouseTextChiefDone::
	text "Later kid."
	done
	
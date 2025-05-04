_CeladonHouseText1::
	text "Yahahaha!"
	line "Triple 7!!!"
	cont "Par ici l'pognon!"
	done

_CeladonHouseText2::
	text "CHEF!"

	para "2000 #mon ont"
	line "été envoyés comme"
	cont "prix de casino!"
	done

_CeladonHouseText3::
	text "Ne touche pas au"
	line "bouton sur le"
	cont "poster du Casino!"

	para "Hein? Mais non"
	line "j'l'ai pas dit!"
	done

_CeladonHouseTextChiefIntro::	;joenote - adding text for selling pokemon
	text "Héhé! Les mach-"
	line "ines à sous sont"
	cont "de vrais aspirat-"
	cont "eurs à pognons."
	
	para "Mais j'vais vite"
	line "manquer d'lots"
	cont "#mon sans"
	cont "l'Boss."
	
	para "Hey gamin!"
	line "Joli @"
	TX_RAM wcd6d
	db $0
	cont "qu't'as là."

	para "J't'en donne"
	line "¥@"
	TX_BCD hItemPrice, 3 | LEADING_ZEROES | LEFT_ALIGN
	text " !"
	done
	
_CeladonHouseTextChiefDone::
	text "A plus, gamin."
	done
	
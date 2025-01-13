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
	text "Héhé! Les machines"
	line "à sous sont de"
	cont "vrais aspirateurs"
	cont "à pognons."
	
	para "Mais j'vais vite"
	line "manquer d'lots"
	cont "#mon sans l'Boss."
	
	para "Hey gamin! Joli"
	line "@"
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
	
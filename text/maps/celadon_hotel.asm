_CeladonHotelText1::
	text "Des #mon quoi?"
	line "C'est un hôtel"
	cont "ici..."

	para "Et c'est complet."
	done

_CeladonHotelText2::
	text "Je suis en"
	line "vacances avec mon"
	cont "frère et mon"
	cont "petit ami."

	para "Céladopole est"
	line "si belle!"
	done

_CeladonHotelText3::
	text "Mais pourquoi y'a"
	line "son frère?"
	done

;joenote - adding text for the coin guy
_CeladonHotelCoinGuyText_intro::
	text "Je suis plein de"
	line "Jetons mais voir"
	cont "les #mon est"
	cont "ma seule"
	cont "convoitise."
	
	para "Montre moi un beau"
	line "@"
	TX_RAM wcd6d
	db $0
	cont "et je te donnerai" 
	cont "une récompense."
	prompt

_CeladonHotelCoinGuyText_needcase::
	text "Oh, n'oublie pas"
	line "ta Boîte Jeton."
	done

_CeladonHotelCoinGuyText_recieved::
	text "Ah, je vois que tu"
	line "en as une!"
	
	para "Voilà "
	line "@"
	TX_BCD hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " Jetons!"
	done
	
_CeladonHotelCoinGuyText_PC::
	text "Utilise le PC dans"
	line "ce coin si tu en"
	cont "as besoin."
	done

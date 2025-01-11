_CeladonHotelText1::
	text "Des #MON quoi?"
	line "C'est un hôtel"
	cont "ici..."

	para "Et c'est complet."
	done

_CeladonHotelText2::
	text "Je suis en"
	line "vacances avec mon"
	cont "frère et mon"
	cont "petit ami."

	para "CELADOPOLE est"
	line "si belle!"
	done

_CeladonHotelText3::
	text "Mais pourquoi y'a"
	line "son frère?"
	done
;joenote - adding text for the coin guy

_CeladonHotelCoinGuyText_intro::
	text "I'm flushed with"
	line "COINS, yet seeing"
	cont "#MON is what I"
	cont "covet."
	
	para "Show me a fine"
	line "@"
	TX_RAM wcd6d
	db $0
	cont "and I will give a" 
	cont "nice reward."
	prompt

_CeladonHotelCoinGuyText_needcase::
	text "Oh, remember to"
	line "bring a COIN CASE."
	done

_CeladonHotelCoinGuyText_recieved::
	text "Oh, I see that you"
	line "have one!"
	
	para "I'll give you"
	line "@"
	TX_BCD hCoins, 2 | LEADING_ZEROES | LEFT_ALIGN
	text " coins!"
	done
	
_CeladonHotelCoinGuyText_PC::
	text "Use the PC over in"
	line "the corner if you"
	cont "need it."
	done

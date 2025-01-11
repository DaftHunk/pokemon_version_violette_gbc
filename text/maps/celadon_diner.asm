_CeladonDinerText1::
	text "Salut!"

	para "On fait une"
	line "p'tite pause."
	done

_CeladonDinerText2::
	text "Mes #mon sont"
	line "faibles alors je"
	cont "vais souvent"
	cont "acheter des"
	cont "accélérateurs."
	done

_CeladonDinerText3::
	text "Pssst! Il y a un"
	line "truc sous le"
	cont "Casino."
	done

_CeladonDinerText4::
	text "Miam..."

	para "Le type à cette"
	line "table a tout"
	cont "perdu..."
	done

_CeladonDinerText_491a7::
	text "Vas-y! Rigole!"

	para "J'ai plus une"
	line "thune!"

	para "C'est marrant,"
	line "hein? Pfff..."
	cont "Je te hais!"

	para "Prends ça tiens!"
	line "Et surtout, perds"
	cont "tout ton blé!"
	prompt

_ReceivedCoinCaseText::
	text "<PLAYER> reçoit"
	line "@"
	text_ram wStringBuffer
	text "!@"
	text_end

_CoinCaseNoRoomText::
	text "T'as plus de"
	line "place!"
	done

_CeladonDinerText_491b7::
	text "Faut qu'j'me"
	line "refasse..."
	done
;joenote - add text for catch-up exp boost
_CeladonDiner_EXPCatchUpON::
	text "This spicy KETCHUP"
	line "helps me CATCH-UP"
	cont "with my studies."
	
	para "It can also make"
	line "weaker #mon"
	cont "gain more EXP."
	cont "Want to try it?"
	done
	
_CeladonDiner_EXPCatchUpOFF::
	text "Too spicy for you?"
	line "Or all caught-up?"
	
	para "I can undo the"
	line "effect with some"
	cont "MILK. Sound good?"
	done
	
_CeladonDiner_AideQ_done::
	text "Okay, it's done."
	done
	
_CeladonDiner_AideQ_reject::
	text "No? Very well."
	line "See me again if"
	cont "you change your"
	cont "mind later."
	done

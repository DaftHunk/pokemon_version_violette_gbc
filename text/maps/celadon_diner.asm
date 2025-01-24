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
	text "Cette sauce Maggi"
	line "est Maggistrale"
	cont "pour mes études."
	
	para "Elle permet"
	line "aux #mon plus"
	cont "faibles de donner"
	cont "plus d'exp."
	cont "Tu veux essayer?"
	done
	
_CeladonDiner_EXPCatchUpOFF::
	text "C'est trop salé à"
	line "ton goût?"
	
	para "Je peux en annuler"
	line "les effets avec du"
	cont "Sucre, ça te va?"
	done
	
_CeladonDiner_AideQ_done::
	text "Okay, c'est fait."
	done
	
_CeladonDiner_AideQ_reject::
	text "Non? Très bien."
	line "Reviens me voir"
	cont "si tu changes"
	cont "d'avis."
	done

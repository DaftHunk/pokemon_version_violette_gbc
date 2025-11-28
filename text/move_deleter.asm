_MoveDeleterGreetingText::
	text "Maman dit que"
	line "j'oublie"
	cont "tellement tout"
	cont "que c'en est"
	cont "contagieux..."
	
	para "Tu veux qu'un"
	line "#mon oublie"
	cont "une technique?"

	done

_MoveDeleterSaidYesText::
	text "Quel #mon"
	line "doit oublier"
	cont "une technique?"
	prompt

_MoveDeleterWhichMoveText::
	text "Quelle technique"
	line "doit-il oublier?"
	done

_MoveDeleterConfirmText::
	text "Lui faire oublier"
	line "@"
	TX_RAM wcf4b
	text "?"
	prompt

_MoveDeleterForgotText::
	text "@"
	TX_RAM wcf4b
	text " a été"
	line "oublié!"
	prompt

_MoveDeleterByeText::
	text "Reviens me rendre"
	line "visite!"
	done

_MoveDeleterOneMoveText::
	text "Le #mon n'a"
	line "qu'une technique."
	cont "Choisir un autre?"
	done

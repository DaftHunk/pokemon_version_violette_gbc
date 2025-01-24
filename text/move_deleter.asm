; mina : au twavail floflo
_MoveDeleterGreetingText::
	text "Mom says I'm so"
	line "forgetful that it"
	cont "is contagious."
	
	para "Want me to make a"
	line "#mon forget a"
	cont "move?"
	done

_MoveDeleterSaidYesText::
	text "Which #mon"
	line "should forget a"
	cont "move?"
	prompt

_MoveDeleterWhichMoveText::
	text "Which move should"
	line "it forget, then?"
	done

_MoveDeleterConfirmText::
	text "Make it forget"
	line "@"
	TX_RAM wcf4b
	text "?"
	prompt

_MoveDeleterForgotText::
	text "@"
	TX_RAM wcf4b
	text " was"
	line "forgotten!"
	prompt

_MoveDeleterByeText::
	text "Come visit me"
	line "again!"
	done

_MoveDeleterOneMoveText::
	text "That #mon"
	line "has one move."
	cont "Pick another?"
	done

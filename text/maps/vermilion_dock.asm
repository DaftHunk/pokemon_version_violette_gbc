_VermilionDockText1::
	text_start
	done

_VermilionDockSeigaIntro::
	text "My name is SEIGA."
	line "Though my friends"
IF (DEF(_GREEN) || DEF(_REDJP) || DEF(_BLUEJP))
	cont "call me BLUE."
ELSE
	cont "call me GREEN."
ENDC
	
	para "I'm CHAMP of the"
	line "Orange Islands"
	cont "#MON LEAGUE."

	para "I'm currently on a"
	line "victory vacation"
	cont "on the S.S.ANNE."
	
	para "Oh...This truck?"
	line "I think it's just"
	cont "a silly in-joke."
	done

_VermilionDockSeigaChallenge::
	text "You know, I heard"
	line "about you on the"
	cont "radio. Congrats!"
	
	para "How about a"
	line "friendly battle"
	cont "between CHAMPS?"
	
	para "If you win, I'll"
	line "tell you a secret"
	cont "about this truck."
	done

_VermilionDockSeigaBye::
	text "Nice seeing you."
	line "Come by and visit"
	cont "me again."
	done
	
_VermilionDockSeigaPre::
	text "Here I come!"
	done
	
_VermilionDockSeigaDefeat::
	text "Nice battle!"
	line "But better luck"
	cont "next time."
	prompt

_VermilionDockSeigaVictory::
	text "A"
	line "#MON was well-"
	cont "hidden under the"
	cont "truck."
	
	para "It cried MEW!"
	line "and flew towards"
	cont "Cerulean City."
	
	para "My locator traced"
	line "it to some cave,"
	cont "but the signal"
	cont "was lost when it"
	cont "went to a lower"
	cont "level."
	
	para "Your 'DEX is much"
	line "more advanced"
	cont "than my locator."
	
	para "Maybe the #MON"
	line "will appear when"
	cont "it's upgraded"
	cont "with a diploma."
	prompt
	
_Lab4Text_75dc6::
	text "Salut!"

	para "Je suis un"
	line "scientifique très"
	cont "sérieux!"

	para "J'étudie les"
	line "fossiles anciens"
	cont "de #mon!"

	para "Toi! Là!"
	line "T'aurais pas un"
	cont "fossile pour moi?"
	prompt

_Lab4Text_75dcb::
	text "Non? C'est bien"
	line "dommage!"
	done

_Lab4Text_75dd0::
	text "Ça va prendre du"
	line "temps!"

	para "Va te promener"
	line "pendant que je"
	cont "bosse!"
	done

_Lab4Text_75dd5::
	text "Ben alors! Où"
	line "étais-tu passé?"

	para "Ton fossile est"
	line "VIVANT!"

	para "Il ressemble à un"
	line "@"
	text_ram wStringBuffer
	text "!"
	prompt

_Lab4Text_610ae::
	text "Oh! C'est un"
	line "@"
	text_ram wcd6d
	text "!"

	para "C'est un fossile"
	line "de @"
	text_ram wStringBuffer
	text ","
	cont "un #mon qui a"
	cont "disparu!"

	para "Ma machine à"
	line "réanimer va faire"
	cont "revivre cet"
	cont "ancien #mon!"
	done

_Lab4Text_610b3::
	text "Tu te grouilles,"
	line "file-moi ça!"

	para "<PLAYER> donne:"
	line "@"
	text_ram wcd6d
	text "!"
	prompt

_Lab4Text_610b8::
	text "Ça va prendre un"
	line "peu de temps!"

	para "Traîne pas dans"
	line "mes pattes, va"
	cont "faire un tour!"
	done

_Lab4Text_610bd::
	text "Argayahhaha!"
	line "Tu reviendras!"
	done

;joenote - text for cloning guy
_Lab4Text_Clone0::
	text "Une analyse du"
	line "carré de Punnett"
	cont "pour 200¥, ça"
	cont "t'intéresse?"
	done
	
_Lab4Text_Clone1::
	text "Séquence du gene:"
	line "@"
;	TX_NUM hDexRatingNumMonsOwned, 1, 3
;	text " #mon owned"
	TX_NUM wBuffer, 1, 2
	text " @"
	TX_NUM wBuffer+1, 1, 2
	text " @"
	TX_NUM wBuffer+2, 1, 2
	text " @"
	TX_NUM wBuffer+3, 1, 2
	text " Okay?" 
	done

_Lab4Text_Clone2::
	text "C'est 10000¥ pour"
	line "cloner ces gènes."
	cont "Toujours inté-"
	cont "ressé?"
	done

_Lab4Text_Clone3::
	text "Reviens plus tard"
	line "pendant que nous"
	cont "travaillons sur"
	cont "la gestation."
	done

_Lab4Text_Clone4::
	text "Ton tout nouveau"
	line "#mon est prêt!"
	prompt

_Lab4Text_MachineUsed::
	text "Nos machines sont"
	line "complètement"
	cont "opérationnelles."
	done

_Lab4Text_Bye::
	text "A plus tard."
	done

_Lab4Text_NoMoney::
	text "Tu n'as pas assez"
	line "d'argent."
	done	

_Lab4Text_Party::
	text "Reviens quand ton"
	line "équipe contiendra"
	cont "2 à 5 #mon."
	done	

_Lab4Text_Legend::
	text "Nos ordinateurs"
	line "ne peuvent anal-"
	cont "yser ton premier"
	cont "#mon."
	
	para "C'est au-delà de"
	line "nos capacités."
	done	

_Lab4Text_Book0::
	text "Le lire?"
	done
	
_Lab4Text_Book1A::
	text "Clones modifiés"
	prompt
_Lab4Text_Book1B::
	text "Créé un clone du"
	line "premier #mon"
	cont "avec l'ADN du"
	cont "second #mon."

	para "Une analyse du"
	line "carré de Punnet"
	cont "sur chaque gène et"
	cont "permet de prédire"
	cont "et d'approuver la"
	cont "séquence avant la"
	cont "gestation."
	done
 
_Lab4Text_Book2A::
	text "Gènes #mon"
	prompt
_Lab4Text_Book2B::
	text "Tous les #mon"
	line "ont des Valeurs"
	cont "Determinées qui"
	cont "agissent comme"
	cont "des gènes."

	para "Tous les #mon"
	line "ont 2 gènes:"
	cont "A et B."
	cont "Chaque gène a 2"
	cont "allèles: Hi / Lo."
	cont "Cela forme une"
	cont "séquence de gène"
	cont "des #mon."

	para "Les séquences de"
	line "gène sont dans"
	cont "cet ordre:"

	para "Gène-A Hi allèle,"
	line "Gène-A Lo allèle,"
	cont "Gène-B Hi allèle,"
	cont "Gène-B Lo allèle."

	para "Ils affectent re-"
	line "spectivement:" 
	cont "Attack, Défense,"
	cont "Vitesse et Spé-"
	cont "cial."
	done

_Lab4Text_Book3A::
	text "Mêler ADN #mon"
	prompt
_Lab4Text_Book3B::
	text "Le carré de Pun-"
	line "net mêle 2 gènes"
	cont "A et 2 gènes B."

	para "Les allèles Hi"
	line "sont toujours av-"
	cont "ant une allèle Lo"
	cont "dans un quadrant."
	cont "2 allèles Hi ou 2"
	cont "allèles Lo dans" 
	cont "un quadrant ont"
	cont "1 chance sur 2"
	cont "de changer de"
	cont "position."

	para "Ainsi vous pouvez"
	line "prédire tous les"
	cont "résultats possi-"
	cont "les de combiner"
	cont "les gènes."
	done
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
	text "Ca va prendre du"
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
	text "Ca va prendre un"
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
	text "A Punnett Square"
	line "analysis is ¥200."
	cont "You interested?"
	done
	
_Lab4Text_Clone1::
	text "Gene sequence:"
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
	text "To clone these"
	line "genes is ¥10000."
	cont "Still interested?"
	done

_Lab4Text_Clone3::
	text "Come back after a"
	line "bit while we work"
	cont "on gestation."
	done

_Lab4Text_Clone4::
	text "Your brand new"
	line "#mon is all"
	cont "ready to go!"
	prompt

_Lab4Text_MachineUsed::
	text "Our machines are"
	line "at full capacity."
	done

_Lab4Text_Bye::
	text "Maybe later."
	done

_Lab4Text_NoMoney::
	text "You don't have"
	line "enough money."
	done	

_Lab4Text_Party::
	text "Come back when"
	line "your team is"
	cont "2 to 5 #mon."
	done	

_Lab4Text_Legend::
	text "Our computers"
	line "can't analyze"
	cont "the #mon in"
	cont "your top spot."
	
	para "It's beyond our"
	line "capabilities."
	done	

_Lab4Text_Book0::
	text "Read it?"
	done
	
_Lab4Text_Book1A::
	text "MODIFIED CLONES"
	prompt
_Lab4Text_Book1B::
	text "This creates a"
	line "gene-spliced"
	cont "clone of your 1st"
	cont "spot #mon with"
	cont "DNA from your 2nd"
	cont "spot #mon."

	para "A Punnet Square"
	line "analysis is done"
	cont "on each gene,"
	cont "and a predicted"
	cont "gene sequence is"
	cont "approved prior to"
	cont "gestation."
	done

_Lab4Text_Book2A::
	text "#mon GENES"
	prompt
_Lab4Text_Book2B::
	text "All Pokemon have"
	line "DETERMINED VALUES"
	cont "that effectively"
	cont "act as genes."

	para "Every Pokemon has"
	line "2 genes: A and B."
	cont "Each gene has 2"
	cont "alleles: Hi / Lo."
	cont "This forms a gene"
	cont "sequence notation"
	cont "for each Pokemon."

	para "Gene sequences"
	line "are ordered from"
	cont "left to right as:"

	para "Gene-A Hi allele,"
	line "Gene-A Lo allele,"
	cont "Gene-B Hi allele,"
	cont "Gene-B Lo allele."

	para "Respectively they"
	line "affect ATTACK," 
	cont "DEFENSE, SPEED,"
	cont "and SPECIAL in"
	cont "that order."
	done

_Lab4Text_Book3A::
	text "MIXING #mon DNA"
	prompt
_Lab4Text_Book3B::

	text "Punnet Squares"
	line "mix two A genes"
	cont "or two B genes."

	para "A Hi allele is"
	line "always before a"
	cont "Lo allele within"
	cont "a quadrant. 2 Hi"
	cont "alleles or 2 Lo"
	cont "alleles within a" 
	cont "quadrant have a"
	cont "1-in-2 chance to"
	cont "swap positions."

	para "This way you can"
	line "predict all the"
	cont "possible outcomes"
	cont "of combining two"
	cont "genes together."
	done
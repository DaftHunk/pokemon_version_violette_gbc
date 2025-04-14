ColosseumObject:
	db $e ; border block

	db 0 ; warps

	db 0 ; signs

;	joenote - add a new object for re-selecting clauses
	db 2 ; objects
	object SPRITE_RED, 2, 2, STAY, 0, 1 ; person
	object SPRITE_CLIPBOARD, 6, 0, STAY, NONE, 2 ; person

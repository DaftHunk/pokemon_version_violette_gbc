db DEX_CHARIZARD_S ; pokedex id
db 78 ; base hp
db 84 ; base attack
db 78 ; base defense
db 100 ; base speed
db 85 ; base special
db FIRE ; species type 1
db DRAGON ; species type 2
db 45 ; catch rate
db 209 ; base exp yield
INCBIN "gfx/pokemon/front/charizard.pic",0,1 ; 77, sprite dimensions
dw CharizardPicFront
dw CharizardPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
;	db 0 ; padding
	db BANK(CharizardPicFront)
	assert BANK(CharizardPicFront) == BANK(CharizardPicBack)


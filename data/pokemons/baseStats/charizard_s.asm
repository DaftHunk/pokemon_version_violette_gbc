db DEX_CHARIZARD_S ; pokedex id
db 100 ; base hp
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
; 1 -> 8
	tmlearn 0
; 9 -> 16
	tmlearn 0
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn 0
; 33 -> 40
	tmlearn 0
; 41 -> 48
	tmlearn 0
; 49 -> 56
	tmlearn 0
;   db 0 ; padding
	db BANK(CharizardPicFront)
	assert BANK(CharizardPicFront) == BANK(CharizardPicBack)


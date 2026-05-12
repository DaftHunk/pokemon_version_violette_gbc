db DEX_MAGMAR_S ; pokedex id
db 100 ; base hp
db 95 ; base attack
db 57 ; base defense
db 93 ; base speed
db 95 ; base special
db FIRE ; species type 1
db ROCK ; species type 2
db 45 ; catch rate
db 167 ; base exp yield
INCBIN "gfx/pokemon/front/magmar.pic",0,1 ; 66, sprite dimensions
dw MagmarPicFront
dw MagmarPicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 0 ; growth rate
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
	db BANK(MagmarPicFront)
	assert BANK(MagmarPicFront) == BANK(MagmarPicBack)


db DEX_SCIZOR_S; pokedex id
db 100 ; base hp
db 130 ; base attack
db 100 ; base defense
db 65 ; base speed
db 70 ; base special
db GHOST ; species type 1
db STEEL ; species type 2
db 25 ; catch rate
db 200 ; base exp yield
INCBIN "gfx/pokemon/front/scizor.pic",0,1 ; 77, sprite dimensions
dw ScizorPicFront
dw ScizorPicBack
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
	db BANK(ScizorPicFront)
	assert BANK(ScizorPicFront) == BANK(ScizorPicBack)


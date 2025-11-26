db DEX_METAPOD ; pokedex id
db 50 ; base hp
db 20 ; base attack
db 55 ; base defense
db 30 ; base speed
db 25 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 120 ; catch rate
db 72 ; base exp yield
INCBIN "gfx/pokemon/front/metapod.pic",0,1 ; 55, sprite dimensions
dw MetapodPicFront
dw MetapodPicBack
; attacks known at lvl 0
db HARDEN
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
	db BANK(MetapodPicFront)
	assert BANK(MetapodPicFront) == BANK(MetapodPicBack)


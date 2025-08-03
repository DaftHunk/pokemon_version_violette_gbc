db DEX_VENUSAUR_S ; pokedex id
db 80 ; base hp
db 82 ; base attack
db 83 ; base defense
db 80 ; base speed
db 100 ; base special
db GRASS ; species type 1
db DARK ; species type 2
db 45 ; catch rate
db 208 ; base exp yield
INCBIN "gfx/pokemon/front/venusaur.pic",0,1 ; 77, sprite dimensions
dw VenusaurPicFront
dw VenusaurPicBack
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
	db BANK(VenusaurPicFront)
	assert BANK(VenusaurPicFront) == BANK(VenusaurPicBack)


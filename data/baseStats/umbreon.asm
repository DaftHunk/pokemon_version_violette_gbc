db DEX_UMBREON ; pokedex id
db 95 ; base hp
db 65 ; base attack
db 110 ; base defense
db 65 ; base speed
db 110 ; base special
db DARK ; species type 1
db DARK ; species type 2
db 45 ; catch rate
db 197 ; base exp yield
INCBIN "gfx/pokemon/front/umbreon.pic",0,1 ; 66, sprite dimensions
dw UmbreonPicFront
dw UmbreonPicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 7
	tmlearn 9,10,11,16,17
	tmlearn 29
	tmlearn 30,32
	tmlearn 34,40
	tmlearn 43,46
	tmlearn 52,56
;	db 0 ; padding
	db BANK(UmbreonPicFront)
	assert BANK(UmbreonPicFront) == BANK(UmbreonPicBack)


db DEX_KOFFING ; pokedex id
db 40 ; base hp
db 65 ; base attack
db 95 ; base defense
db 35 ; base speed
db 60 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 114 ; base exp yield
INCBIN "gfx/pokemon/front/koffing.pic",0,1 ; 66, sprite dimensions
dw KoffingPicFront
dw KoffingPicBack
; attacks known at lvl 0
db POISON_GAS
db TACKLE
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC
	tmlearn 0
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm38_FIRE_BLAST
	tmlearn tm44_REST, tm47_EXPLOSION
	tmlearn tm50_SUBSTITUTE
;	db 0 ; padding
	db BANK(KoffingPicFront)
	assert BANK(KoffingPicFront) == BANK(KoffingPicBack)


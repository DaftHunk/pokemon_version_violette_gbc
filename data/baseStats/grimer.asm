db DEX_GRIMER ; pokedex id
db 80 ; base hp
db 80 ; base attack
db 50 ; base defense
db 25 ; base speed
db 40 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 90 ; base exp yield
INCBIN "gfx/pokemon/front/grimer.pic",0,1 ; 55, sprite dimensions
dw GrimerPicFront
dw GrimerPicBack
; attacks known at lvl 0
db POUND
db POISON_GAS
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
	tmlearn 0
	tmlearn tm20_RAGE, tm21_MEGA_DRAIN, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm38_FIRE_BLAST
	tmlearn tm44_REST, tm47_EXPLOSION
	tmlearn tm50_SUBSTITUTE
;	db 0 ; padding
	db BANK(GrimerPicFront)
	assert BANK(GrimerPicFront) == BANK(GrimerPicBack)


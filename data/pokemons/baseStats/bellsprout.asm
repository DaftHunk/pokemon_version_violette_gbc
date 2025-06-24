db DEX_BELLSPROUT ; pokedex id
db 50 ; base hp
db 75 ; base attack
db 35 ; base defense
db 40 ; base speed
db 70 ; base special
db GRASS ; species type 1
db POISON ; species type 2
db 255 ; catch rate
db 84 ; base exp yield
INCBIN "gfx/pokemon/front/bellsprout.pic",0,1 ; 55, sprite dimensions
dw BellsproutPicFront
dw BellsproutPicBack
; attacks known at lvl 0
db VINE_WHIP
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE, tm21_MEGA_DRAIN, tm22_SOLARBEAM
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm05_FLASH
;	db 0 ; padding
	db BANK(BellsproutPicFront)
	assert BANK(BellsproutPicFront) == BANK(BellsproutPicBack)


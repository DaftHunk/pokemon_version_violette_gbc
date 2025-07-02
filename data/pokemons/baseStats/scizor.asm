db DEX_SCIZOR; pokedex id
db 70 ; base hp
db 130 ; base attack
db 100 ; base defense
db 65 ; base speed
db 70 ; base special
db BUG ; species type 1
db STEEL ; species type 2
db 25 ; catch rate
db 200 ; base exp yield
INCBIN "gfx/pokemon/front/scizor.pic",0,1 ; 77, sprite dimensions
dw ScizorPicFront
dw ScizorPicBack
; attacks known at lvl 0
db QUICK_ATTACK
db LEER
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm09_TAKE_DOWN
	tmlearn tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM, tm34_BIDE, tm39_SWIFT
	tmlearn tm40_SKULL_BASH, tm44_REST
	tmlearn tm50_SUBSTITUTE
	tmlearn hm01_CUT, HM04_STRENGTH
;	db 0 ; padding
	db BANK(ScizorPicFront)
	assert BANK(ScizorPicFront) == BANK(ScizorPicBack)


db DEX_PIDGEOT ; pokedex id
db 83 ; base hp
db 80 ; base attack
db 75 ; base defense
db 91 ; base speed
db 70 ; base special
db FLYING ; species type 1
db FLYING ; species type 2
db 45 ; catch rate
db 172 ; base exp yield
INCBIN "gfx/pokemon/front/pidgeot.pic",0,1 ; 77, sprite dimensions
dw PidgeotPicFront
dw PidgeotPicBack
; attacks known at lvl 0
db TACKLE
db SAND_ATTACK
db GUST
db QUICK_ATTACK
db 3 ; growth rate
; learnset
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
	tmlearn tm43_SKY_ATTACK, tm44_REST
	tmlearn tm50_SUBSTITUTE, hm02_FLY
;	db 0 ; padding
	db BANK(PidgeotPicFront)
	assert BANK(PidgeotPicFront) == BANK(PidgeotPicBack)


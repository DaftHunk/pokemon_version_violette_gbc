db DEX_PIDGEY ; pokedex id
db 40 ; base hp
db 45 ; base attack
db 40 ; base defense
db 56 ; base speed
db 35 ; base special
db FLYING ; species type 1
db FLYING ; species type 2
db 255 ; catch rate
db 55 ; base exp yield
INCBIN "gfx/pokemon/front/pidgey.pic",0,1 ; 55, sprite dimensions
dw PidgeyPicFront
dw PidgeyPicBack
; attacks known at lvl 0
db GUST
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm39_SWIFT
	tmlearn tm43_SKY_ATTACK, tm44_REST
	tmlearn tm50_SUBSTITUTE, hm02_FLY
;	db 0 ; padding
	db BANK(PidgeyPicFront)
	assert BANK(PidgeyPicFront) == BANK(PidgeyPicBack)


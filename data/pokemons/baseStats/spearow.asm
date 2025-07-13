db DEX_SPEAROW ; pokedex id
db 40 ; base hp
db 60 ; base attack
db 30 ; base defense
db 70 ; base speed
db 31 ; base special
db FLYING ; species type 1
db FLYING ; species type 2
db 255 ; catch rate
db 58 ; base exp yield
INCBIN "gfx/pokemon/front/spearow.pic",0,1 ; 55, sprite dimensions
dw SpearowPicFront
dw SpearowPicBack
; attacks known at lvl 0
db PECK
db GROWL
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm39_SWIFT
	tmlearn tm43_SKY_ATTACK, tm44_REST
	tmlearn tm50_SUBSTITUTE, hm02_FLY
;	db 0 ; padding
	db BANK(SpearowPicFront)
	assert BANK(SpearowPicFront) == BANK(SpearowPicBack)


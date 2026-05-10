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
; 1 -> 8
	tmlearn tm02_RAZOR_WIND, tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm39_SWIFT
; 41 -> 48
	tmlearn tm43_SKY_ATTACK, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm02_FLY
;   db 0 ; padding
	db BANK(SpearowPicFront)
	assert BANK(SpearowPicFront) == BANK(SpearowPicBack)


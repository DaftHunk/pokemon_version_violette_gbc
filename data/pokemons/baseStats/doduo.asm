db DEX_DODUO ; pokedex id
db 35 ; base hp
db 85 ; base attack
db 45 ; base defense
db 75 ; base speed
db 35 ; base special
db NORMAL ; species type 1
db FLYING ; species type 2
db 190 ; catch rate
db 96 ; base exp yield
INCBIN "gfx/pokemon/front/doduo.pic",0,1 ; 55, sprite dimensions
dw DoduoPicFront
dw DoduoPicBack
; attacks known at lvl 0
db PECK
db GROWL
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm43_SKY_ATTACK, tm44_REST
; 49 -> 56
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm02_FLY
;   db 0 ; padding
	db BANK(DoduoPicFront)
	assert BANK(DoduoPicFront) == BANK(DoduoPicBack)


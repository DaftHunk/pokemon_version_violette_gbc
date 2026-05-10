db DEX_HOUNDOOM ; pokedex id
db 75 ; base hp
db 90 ; base attack
db 50 ; base defense
db 95 ; base speed
db 110 ; base special
db DARK ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 175 ; base exp yield
INCBIN "gfx/pokemon/front/houndoom.pic",0,1 ; 55, sprite dimensions
dw HoundoomPicFront
dw HoundoomPicBack
; attacks known at lvl 0
db EMBER
db ROAR
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm23_DRAGON_RAGE
; 25 -> 32
	tmlearn tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(HoundoomPicFront)
	assert BANK(HoundoomPicFront) == BANK(HoundoomPicBack)


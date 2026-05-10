db DEX_KABUTO ; pokedex id
db 30 ; base hp
db 80 ; base attack
db 90 ; base defense
db 55 ; base speed
db 45 ; base special
db ROCK ; species type 1
db BUG ; species type 2
db 45 ; catch rate
db 119 ; base exp yield
INCBIN "gfx/pokemon/front/kabuto.pic",0,1 ; 55, sprite dimensions
dw KabutoPicFront
dw KabutoPicBack
; attacks known at lvl 0
db SCRATCH
db HARDEN
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN,
; 17 -> 24
	tmlearn tm28_DIG
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm03_SURF
;   db 0 ; padding
	db BANK(KabutoPicFront)
	assert BANK(KabutoPicFront) == BANK(KabutoPicBack)


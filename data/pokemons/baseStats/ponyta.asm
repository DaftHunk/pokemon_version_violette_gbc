db DEX_PONYTA ; pokedex id
db 50 ; base hp
db 85 ; base attack
db 55 ; base defense
db 100 ; base speed
db 65 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 190 ; catch rate
db 152 ; base exp yield
INCBIN "gfx/pokemon/front/ponyta.pic",0,1 ; 66, sprite dimensions
dw PonytaPicFront
dw PonytaPicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(PonytaPicFront)
	assert BANK(PonytaPicFront) == BANK(PonytaPicBack)


db DEX_LARVITAR ; pokedex id
db 50 ; base hp
db 64 ; base attack
db 50 ; base defense
db 41 ; base speed
db 47 ; base special
db ROCK ; species type 1
db GROUND ; species type 2
db 45 ; catch rate
db 67 ; base exp yield
INCBIN "gfx/pokemon/front/larvitar.pic",0,1 ; 55, sprite dimensions
dw LarvitarPicFront
dw LarvitarPicBack
; attacks known at lvl 0
db BITE
db LEER
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
	tmlearn tm44_REST, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;	db 0 ; padding
	db BANK(LarvitarPicFront)
	assert BANK(LarvitarPicFront) == BANK(LarvitarPicBack)


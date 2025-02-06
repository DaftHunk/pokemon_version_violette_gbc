db DEX_LAPRAS ; pokedex id
db 130 ; base hp
db 85 ; base attack
db 80 ; base defense
db 60 ; base speed
db 95 ; base special
db WATER ; species type 1
db ICE ; species type 2
db 45 ; catch rate
db 219 ; base exp yield
INCBIN "gfx/pokemon/front/lapras.pic",0,1 ; 77, sprite dimensions
dw LaprasPicFront
dw LaprasPicBack
; attacks known at lvl 0
db WATER_GUN
db GROWL
db SING
db 0
db 5 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
	tmlearn tm20_RAGE, tm22_SOLARBEAM, tm23_DRAGON_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm40_SKULL_BASH
	tmlearn tm44_REST, tm46_PSYWAVE
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH
;	db 0 ; padding
	db BANK(LaprasPicFront)
	assert BANK(LaprasPicFront) == BANK(LaprasPicBack)


db DEX_TAUROS ; pokedex id
db 75 ; base hp
db 100 ; base attack
db 95 ; base defense
db 110 ; base speed
db 70 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 211 ; base exp yield
INCBIN "gfx/pokemon/front/tauros.pic",0,1 ; 77, sprite dimensions
dw TaurosPicFront
dw TaurosPicBack
; attacks known at lvl 0
db TACKLE
db 0
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm27_FISSURE, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm38_FIRE_BLAST, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm03_SURF, hm04_STRENGTH
;	db 0 ; padding
	db BANK(TaurosPicFront)
	assert BANK(TaurosPicFront) == BANK(TaurosPicBack)


db DEX_VENUSAUR ; pokedex id
db 80 ; base hp
db 82 ; base attack
db 83 ; base defense
db 80 ; base speed
db 100 ; base special
db GRASS ; species type 1
db POISON ; species type 2
db 45 ; catch rate
db 208 ; base exp yield
INCBIN "gfx/pokemon/front/venusaur.pic",0,1 ; 77, sprite dimensions
dw VenusaurPicFront
dw VenusaurPicBack
; attacks known at lvl 0
db TACKLE
db GROWL
db LEECH_SEED
db VINE_WHIP
db 3 ; growth rate
; learnset
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm20_RAGE, tm21_MEGA_DRAIN, tm22_SOLARBEAM
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH, hm05_FLASH
;	db 0 ; padding
	db BANK(VenusaurPicFront)
	assert BANK(VenusaurPicFront) == BANK(VenusaurPicBack)


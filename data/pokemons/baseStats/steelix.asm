db DEX_STEELIX ; pokedex id
db 75 ; base hp
db 90 ; base attack
db 200 ; base defense
db 30 ; base speed
db 60 ; base special
db STEEL ; species type 1
db GROUND ; species type 2
db 25 ; catch rate
db 196 ; base exp yield
INCBIN "gfx/pokemon/front/steelix.pic",0,1 ; 77, sprite dimensions
dw SteelixPicFront
dw SteelixPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM, tm09_TAKE_DOWN
	tmlearn tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE, tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM, tm34_BIDE, tm36_SELFDESTRUCT
	tmlearn tm40_SKULL_BASH, tm44_REST, tm47_EXPLOSION, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE
	tmlearn HM01_CUT, hm04_STRENGTH
;	db 0 ; padding
	db BANK(SteelixPicFront)
	assert BANK(SteelixPicFront) == BANK(SteelixPicBack)


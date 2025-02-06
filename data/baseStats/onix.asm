db DEX_ONIX ; pokedex id
db 75 ; base hp
db 80 ; base attack
db 160 ; base defense
db 85 ; base speed
db 65 ; base special
db ROCK ; species type 1
db GROUND ; species type 2
db 45 ; catch rate
db 108 ; base exp yield
INCBIN "gfx/pokemon/front/onix.pic",0,1 ; 77, sprite dimensions
dw OnixPicFront
dw OnixPicBack
; attacks known at lvl 0
db TACKLE
db SCREECH
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm40_SKULL_BASH
	tmlearn tm44_REST, tm47_EXPLOSION, tm48_ROCK_SLIDE
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;	db 0 ; padding
	db BANK(OnixPicFront)
	assert BANK(OnixPicFront) == BANK(OnixPicBack)


db DEX_FLAREON ; pokedex id
db 65 ; base hp
db 130 ; base attack
db 60 ; base defense
db 65 ; base speed
db 110 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 198 ; base exp yield
INCBIN "gfx/pokemon/front/flareon.pic",0,1 ; 66, sprite dimensions
dw FlareonPicFront
dw FlareonPicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;	db 0 ; padding
	db BANK(FlareonPicFront)
	assert BANK(FlareonPicFront) == BANK(FlareonPicBack)


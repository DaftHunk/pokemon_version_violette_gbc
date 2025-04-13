db DEX_UMBREON ; pokedex id
db 95 ; base hp
db 65 ; base attack
db 110 ; base defense
db 65 ; base speed
db 110 ; base special
db DARK ; species type 1
db DARK ; species type 2
db 45 ; catch rate
db 197 ; base exp yield
INCBIN "gfx/pokemon/front/umbreon.pic",0,1 ; 66, sprite dimensions
dw UmbreonPicFront
dw UmbreonPicBack
; attacks known at lvl 0
db TACKLE
db TAIL_WHIP
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM, tm09_TAKE_DOWN
	tmlearn tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
	tmlearn tm20_RAGE
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM, tm33_REFLECT, tm34_BIDE, tm39_SWIFT
	tmlearn tm40_SKULL_BASH, tm44_REST
	tmlearn tm50_SUBSTITUTE
	tmlearn hm03_SURF
;	db 0 ; padding
	db BANK(UmbreonPicFront)
	assert BANK(UmbreonPicFront) == BANK(UmbreonPicBack)


db DEX_NIDORAN_F ; pokedex id
db 55 ; base hp
db 47 ; base attack
db 52 ; base defense
db 41 ; base speed
db 40 ; base special
db POISON ; species type 1
db POISON ; species type 2
db 235 ; catch rate
db 59 ; base exp yield
INCBIN "gfx/pokemon/front/nidoranf.pic",0,1 ; 55, sprite dimensions
dw NidoranFPicFront
dw NidoranFPicBack
; attacks known at lvl 0
db GROWL
db TACKLE
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm14_BLIZZARD
	tmlearn tm20_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm04_STRENGTH
;	db 0 ; padding
	db BANK(NidoranFPicFront)
	assert BANK(NidoranFPicFront) == BANK(NidoranFPicBack)


db DEX_CLOYSTER ; pokedex id
db 50 ; base hp
db 95 ; base attack
db 180 ; base defense
db 70 ; base speed
db 85 ; base special
db WATER ; species type 1
db ICE ; species type 2
db 60 ; catch rate
db 203 ; base exp yield
INCBIN "gfx/pokemon/front/cloyster.pic",0,1 ; 77, sprite dimensions
dw CloysterPicFront
dw CloysterPicBack
; attacks known at lvl 0
db WITHDRAW
db SUPERSONIC
db AURORA_BEAM
db 0
db 5 ; growth rate
; learnset
	tmlearn tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM
	tmlearn tm20_RAGE
	tmlearn tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm36_SELFDESTRUCT, tm39_SWIFT
	tmlearn tm44_REST, tm47_EXPLOSION
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm03_SURF
;	db 0 ; padding
	db BANK(CloysterPicFront)
	assert BANK(CloysterPicFront) == BANK(CloysterPicBack)


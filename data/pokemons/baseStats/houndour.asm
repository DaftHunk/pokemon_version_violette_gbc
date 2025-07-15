db DEX_HOUNDOUR ; pokedex id
db 45 ; base hp
db 60 ; base attack
db 30 ; base defense
db 65 ; base speed
db 75 ; base special
db DARK ; species type 1
db FIRE ; species type 2
db 120 ; catch rate
db 66 ; base exp yield
INCBIN "gfx/pokemon/front/houndour.pic",0,1 ; 55, sprite dimensions
dw HoundourPicFront
dw HoundourPicBack
; attacks known at lvl 0
db EMBER
db ROAR
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE, tm23_DRAGON_RAGE
	tmlearn tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE
;	db 0 ; padding
	db BANK(HoundourPicFront)
	assert BANK(HoundourPicFront) == BANK(HoundourPicBack)


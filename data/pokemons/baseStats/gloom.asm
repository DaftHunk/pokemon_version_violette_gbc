db DEX_GLOOM ; pokedex id
db 70 ; base hp
db 65 ; base attack
db 70 ; base defense
db 40 ; base speed
db 85 ; base special
db GRASS ; species type 1
db POISON ; species type 2
db 120 ; catch rate
db 132 ; base exp yield
INCBIN "gfx/pokemon/front/gloom.pic",0,1 ; 66, sprite dimensions
dw GloomPicFront
dw GloomPicBack
; attacks known at lvl 0
db ABSORB
db POISONPOWDER
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm03_SWORDS_DANCE, tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE, tm21_MEGA_DRAIN, tm22_SOLARBEAM
	tmlearn tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB
	tmlearn tm44_REST
	tmlearn tm50_SUBSTITUTE, hm01_CUT, hm05_FLASH
;	db 0 ; padding
	db BANK(GloomPicFront)
	assert BANK(GloomPicFront) == BANK(GloomPicBack)


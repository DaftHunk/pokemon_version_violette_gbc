db DEX_EXEGGCUTE ; pokedex id
db 60 ; base hp
db 40 ; base attack
db 80 ; base defense
db 40 ; base speed
db 60 ; base special
db GRASS ; species type 1
db PSYCHIC ; species type 2
db 90 ; catch rate
db 98 ; base exp yield
INCBIN "gfx/pokemon/front/exeggcute.pic",0,1 ; 77, sprite dimensions
dw ExeggcutePicFront
dw ExeggcutePicBack
; attacks known at lvl 0
db STUN_SPORE
db LEECH_SEED
db 0
db 0
db 5 ; growth rate
; learnset
	tmlearn tm06_TOXIC
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
	tmlearn tm20_RAGE
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB
	tmlearn tm44_REST, tm46_PSYWAVE, tm47_EXPLOSION
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH, hm05_FLASH
;	db 0 ; padding
	db BANK(ExeggcutePicFront)
	assert BANK(ExeggcutePicFront) == BANK(ExeggcutePicBack)


db DEX_GASTLY ; pokedex id
db 30 ; base hp
db 35 ; base attack
db 30 ; base defense
db 80 ; base speed
db 100 ; base special
db GHOST ; species type 1
db GHOST ; species type 2
db 190 ; catch rate
db 95 ; base exp yield
INCBIN "gfx/pokemon/front/gastly.pic",0,1 ; 77, sprite dimensions
dw GastlyPicFront
dw GastlyPicBack
; attacks known at lvl 0
db LICK
db HYPNOSIS
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn tm06_TOXIC
	tmlearn 0
	tmlearn tm20_RAGE, tm21_MEGA_DRAIN, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB
	tmlearn tm42_DREAM_EATER, tm44_REST, tm46_PSYWAVE, tm47_EXPLOSION
	tmlearn tm50_SUBSTITUTE
;	db 0 ; padding
	db BANK(GastlyPicFront)
	assert BANK(GastlyPicFront) == BANK(GastlyPicBack)


db DEX_VENONAT ; pokedex id
db 60 ; base hp
db 55 ; base attack
db 50 ; base defense
db 45 ; base speed
db 40 ; base special
db BUG ; species type 1
db POISON ; species type 2
db 190 ; catch rate
db 75 ; base exp yield
INCBIN "gfx/pokemon/front/venonat.pic",0,1 ; 55, sprite dimensions
dw VenonatPicFront
dw VenonatPicBack
; attacks known at lvl 0
db TACKLE
db DISABLE
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm37_SLUDGE_BOMB
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;   db 0 ; padding
	db BANK(VenonatPicFront)
	assert BANK(VenonatPicFront) == BANK(VenonatPicBack)


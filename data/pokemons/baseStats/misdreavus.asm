db DEX_MISDREAVUS ; pokedex id
db 60 ; base hp
db 60 ; base attack
db 60 ; base defense
db 85 ; base speed
db 85 ; base special
db GHOST ; species type 1
db GHOST ; species type 2
db 45 ; catch rate
db 147 ; base exp yield
INCBIN "gfx/pokemon/front/misdreavus.pic",0,1 ; 77, sprite dimensions
dw MisdreavusPicFront
dw MisdreavusPicBack
; attacks known at lvl 0
db GROWL
db PSYWAVE
db 0
db 0
db 4 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC
; 9 -> 16
	tmlearn 0
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm24_THUNDERBOLT
; 25 -> 32
	tmlearn tm25_THUNDER, tm29_PSYCHIC_M, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm39_SWIFT
; 41 -> 48
	tmlearn tm42_SHADOW_BALL, tm44_REST, tm46_DARK_PULSE, tm47_EXPLOSION
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm05_FLASH
;   db 0 ; padding
	db BANK(MisdreavusPicFront)
	assert BANK(MisdreavusPicFront) == BANK(MisdreavusPicBack)


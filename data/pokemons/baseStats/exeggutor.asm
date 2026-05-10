db DEX_EXEGGUTOR ; pokedex id
db 95 ; base hp
db 95 ; base attack
db 85 ; base defense
db 55 ; base speed
db 125 ; base special
db GRASS ; species type 1
db PSYCHIC ; species type 2
db 45 ; catch rate
db 212 ; base exp yield
INCBIN "gfx/pokemon/front/exeggutor.pic",0,1 ; 77, sprite dimensions
dw ExeggutorPicFront
dw ExeggutorPicBack
; attacks known at lvl 0
db BARRAGE
db HYPNOSIS
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm21_MEGA_DRAIN, tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB
; 41 -> 48
	tmlearn tm41_GIGA_DRAIN, tm44_REST, tm47_EXPLOSION
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH, hm05_FLASH
;   db 0 ; padding
	db BANK(ExeggutorPicFront)
	assert BANK(ExeggutorPicFront) == BANK(ExeggutorPicBack)


db DEX_MAGCARGO ; pokedex id
db 60 ; base hp
db 50 ; base attack
db 120 ; base defense
db 30 ; base speed
db 90 ; base special
db FIRE ; species type 1
db ROCK ; species type 2
db 75 ; catch rate
db 154 ; base exp yield
INCBIN "gfx/pokemon/front/magcargo.pic",0,1 ; 77, sprite dimensions
dw MagcargoPicFront
dw MagcargoPicBack
; attacks known at lvl 0
db EMBER
db ROCK_THROW
db SMOG
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm15_HYPER_BEAM
; 17 -> 24
	tmlearn tm22_SOLARBEAM
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm36_SELFDESTRUCT, tm38_FIRE_BLAST
; 41 -> 48
	tmlearn tm44_REST, tm47_EXPLOSION, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm04_STRENGTH
;   db 0 ; padding
	db BANK(MagcargoPicFront)
	assert BANK(MagcargoPicFront) == BANK(MagcargoPicBack)


db DEX_SLUGMA ; pokedex id
db 40 ; base hp
db 40 ; base attack
db 40 ; base defense
db 20 ; base speed
db 70 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 190 ; catch rate
db 78 ; base exp yield
INCBIN "gfx/pokemon/front/slugma.pic",0,1 ; 55, sprite dimensions
dw SlugmaPicFront
dw SlugmaPicBack
; attacks known at lvl 0
db SMOG
db 0
db 0
db 0
db 5 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm04_FLAMETHROWER, tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm33_REFLECT, tm34_BIDE, tm36_SELFDESTRUCT, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE
;   db 0 ; padding
	db BANK(SlugmaPicFront)
	assert BANK(SlugmaPicFront) == BANK(SlugmaPicBack)


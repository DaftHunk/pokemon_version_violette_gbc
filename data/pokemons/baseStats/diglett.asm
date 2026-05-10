db DEX_DIGLETT ; pokedex id
db 10 ; base hp
db 70 ; base attack
db 25 ; base defense
db 95 ; base speed
db 45 ; base special
db GROUND ; species type 1
db GROUND ; species type 2
db 255 ; catch rate
db 81 ; base exp yield
INCBIN "gfx/pokemon/front/diglett.pic",0,1 ; 55, sprite dimensions
dw DiglettPicFront
dw DiglettPicBack
; attacks known at lvl 0
db SCRATCH
db 0
db 0
db 0
db 0 ; growth rate
; learnset
; 1 -> 8
	tmlearn tm06_TOXIC, tm08_BODY_SLAM
; 9 -> 16
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE
; 17 -> 24
	tmlearn 0
; 25 -> 32
	tmlearn tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm31_MIMIC, tm32_DOUBLE_TEAM
; 33 -> 40
	tmlearn tm34_BIDE, tm37_SLUDGE_BOMB
; 41 -> 48
	tmlearn tm44_REST, tm48_ROCK_SLIDE
; 49 -> 56
	tmlearn tm50_SUBSTITUTE, hm01_CUT	;joenote - can learn CUT from Yellow
;   db 0 ; padding
	db BANK(DiglettPicFront)
	assert BANK(DiglettPicFront) == BANK(DiglettPicBack)


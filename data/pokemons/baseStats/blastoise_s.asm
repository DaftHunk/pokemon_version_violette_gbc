db DEX_BLASTOISE_S ; pokedex id
db 79 ; base hp
db 83 ; base attack
db 100 ; base defense
db 78 ; base speed
db 85 ; base special
db WATER ; species type 1
db STEEL ; species type 2
db 45 ; catch rate
db 210 ; base exp yield
INCBIN "gfx/pokemon/front/blastoise.pic",0,1 ; 77, sprite dimensions
dw BlastoisePicFront
dw BlastoisePicBack
; attacks known at lvl 0
db 0
db 0
db 0
db 0
db 3 ; growth rate
; learnset
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
	tmlearn 0
;	db 0 ; padding
	db BANK(BlastoisePicFront)
	assert BANK(BlastoisePicFront) == BANK(BlastoisePicBack)


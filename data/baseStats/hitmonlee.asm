db DEX_HITMONLEE ; pokedex id
db 65 ; base hp
db 120 ; base attack
db 70 ; base defense
db 93 ; base speed
db 60 ; base special
db FIGHTING ; species type 1
db FIGHTING ; species type 2
db 45 ; catch rate
db 139 ; base exp yield
INCBIN HITMONLEE_FR,0,1 ; 77, sprite dimensions
dw HitmonleePicFront
dw HitmonleePicBack
; attacks known at lvl 0
db DOUBLE_KICK
db MEDITATE
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10
	tmlearn 17,18,19,20
	tmlearn 31,32
	tmlearn 34,35,39,40
	tmlearn 44
	tmlearn 50,54
;	db 0 ; padding
	db BANK(HitmonleePicFront)
	assert BANK(HitmonleePicFront) == BANK(HitmonleePicBack)


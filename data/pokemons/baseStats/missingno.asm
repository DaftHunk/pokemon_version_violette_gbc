MissingnoBaseStats:
db MISSINGNO_B5 ; pokedex id
db 128 ; base hp
db 128 ; base attack
db 128 ; base defense
db 128 ; base speed
db 128 ; base special
db BIRD ; species type 1
db NORMAL ; species type 2
db 1 ; catch rate
db 255 ; base exp yield
INCBIN "gfx/pokemon/other/missingno.pic",0,1 ; $77, sprite dimensions
dw MissingnoPic
dw OldManPic	;use old man for back pic as a placeholder
; attacks known at lvl 0
db WATER_GUN
db SKY_ATTACK
db BIND
db PAY_DAY
db 3 ; growth rate
; learnset
	tmlearn tm01_MEGA_PUNCH, tm02_RAZOR_WIND, tm03_SWORDS_DANCE, tm04_FLAMETHROWER, tm05_MEGA_KICK, tm06_TOXIC, tm07_HORN_DRILL, tm08_BODY_SLAM
	tmlearn tm09_TAKE_DOWN, tm10_DOUBLE_EDGE, tm11_BUBBLEBEAM, tm12_WATER_GUN, tm13_ICE_BEAM, tm14_BLIZZARD, tm15_HYPER_BEAM, tm16_PAY_DAY
	tmlearn tm17_SUBMISSION, tm18_COUNTER, tm19_SEISMIC_TOSS, tm20_RAGE, tm21_MEGA_DRAIN, tm22_SOLARBEAM, tm23_DRAGON_RAGE, tm24_THUNDERBOLT
	tmlearn tm25_THUNDER, tm26_EARTHQUAKE, tm27_FISSURE, tm28_DIG, tm29_PSYCHIC_M, tm30_TELEPORT, tm31_MIMIC, tm32_DOUBLE_TEAM
	tmlearn tm33_REFLECT, tm34_BIDE, tm35_METRONOME, tm36_SELFDESTRUCT, tm37_SLUDGE_BOMB, tm38_FIRE_BLAST, tm39_SWIFT, tm40_SKULL_BASH
	tmlearn tm41_SOFTBOILED, tm42_DREAM_EATER, tm43_SKY_ATTACK, tm44_REST, tm45_THUNDER_WAVE, tm46_PSYWAVE, tm47_EXPLOSION, tm48_ROCK_SLIDE
	tmlearn tm49_TRI_ATTACK, tm50_SUBSTITUTE, hm01_CUT, hm02_FLY, hm03_SURF, hm04_STRENGTH, hm05_FLASH, 56
;	db 0 ; padding
	db BANK(MissingnoPic)
	assert BANK(MissingnoPic) == BANK(OldManPic)

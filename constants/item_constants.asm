const_value = 1

	const MASTER_BALL   ; $01
	const ULTRA_BALL    ; $02
	const GREAT_BALL    ; $03
	const POKE_BALL     ; $04
	const TOWN_MAP      ; $05
	const BICYCLE       ; $06
	const SURFBOARD     ; $07
	const SAFARI_BALL   ; $08
	const POKEDEX       ; $09
	const MOON_STONE    ; $0A
	const ANTIDOTE      ; $0B
	const BURN_HEAL     ; $0C
	const ICE_HEAL      ; $0D
	const AWAKENING     ; $0E
	const PARLYZ_HEAL   ; $0F
	const FULL_RESTORE  ; $10
	const MAX_POTION    ; $11
	const HYPER_POTION  ; $12
	const SUPER_POTION  ; $13
	const POTION        ; $14
	const BOULDERBADGE  ; $15
	const CASCADEBADGE  ; $16
SAFARI_BAIT           EQU $15 ; overload
SAFARI_ROCK           EQU $16 ; overload
	const THUNDERBADGE  ; $17
	const RAINBOWBADGE  ; $18
	const SOULBADGE     ; $19
	const MARSHBADGE    ; $1A
	const VOLCANOBADGE  ; $1B
	const EARTHBADGE    ; $1C
	const ESCAPE_ROPE   ; $1D
	const REPEL         ; $1E
	const OLD_AMBER     ; $1F
	const FIRE_STONE    ; $20
	const THUNDER_STONE ; $21
	const WATER_STONE   ; $22
	const HP_UP         ; $23
	const PROTEIN       ; $24
	const IRON          ; $25
	const CARBOS        ; $26
	const CALCIUM       ; $27
	const RARE_CANDY    ; $28
	const DOME_FOSSIL   ; $29
	const HELIX_FOSSIL  ; $2A
	const SECRET_KEY    ; $2B
;	const UNUSED_ITEM    ; $2C "?????"
	const MIST_STONE	; $2C	joenote - custom item
	const BIKE_VOUCHER  ; $2D
	const X_ACCURACY    ; $2E
	const LEAF_STONE    ; $2F
	const CARD_KEY      ; $30
	const NUGGET        ; $31
	;const PP_UP_2       ; $32	unused pp_up
	const M_GENE		; $32	joenote - custom item
	const POKE_DOLL     ; $33
	const FULL_HEAL     ; $34
	const REVIVE        ; $35
	const MAX_REVIVE    ; $36
	const GUARD_SPEC    ; $37
	const SUPER_REPEL   ; $38
	const MAX_REPEL     ; $39
	const DIRE_HIT      ; $3A
	const COIN          ; $3B
	const FRESH_WATER   ; $3C
	const SODA_POP      ; $3D
	const LEMONADE      ; $3E
	const S_S_TICKET    ; $3F
	const GOLD_TEETH    ; $40
	const X_ATTACK      ; $41
	const X_DEFEND      ; $42
	const X_SPEED       ; $43
	const X_SPECIAL     ; $44
	const COIN_CASE     ; $45
	const OAKS_PARCEL   ; $46
	const ITEMFINDER    ; $47
	const SILPH_SCOPE   ; $48
	const POKE_FLUTE    ; $49
	const LIFT_KEY      ; $4A
	const EXP_ALL       ; $4B
	const OLD_ROD       ; $4C
	const GOOD_ROD      ; $4D
	const SUPER_ROD     ; $4E
	const PP_UP         ; $4F
	const ETHER         ; $50
	const MAX_ETHER     ; $51
	const ELIXER        ; $52
	const MAX_ELIXER    ; $53
	const FLOOR_B2F     ; $54
	const FLOOR_B1F     ; $55
	const FLOOR_1F      ; $56
	const FLOOR_2F      ; $57
	const FLOOR_3F      ; $58
	const FLOOR_4F      ; $59
	const FLOOR_5F      ; $5A
	const FLOOR_6F      ; $5B
	const FLOOR_7F      ; $5C
	const FLOOR_8F      ; $5D
	const FLOOR_9F      ; $5E
	const FLOOR_10F     ; $5F
	const FLOOR_11F     ; $60
	const FLOOR_B4F     ; $61
	const METAL_COAT    ; $62 ;dafthunk #19 

const_value = $C4

	const HM01_CUT          ; $C4
	const HM02_FLY          ; $C5
	const HM03_SURF         ; $C6
	const HM04_STRENGTH     ; $C7
	const HM05_FLASH        ; $C8
	const TM01_MEGA_PUNCH   ; $C9
	const TM02_RAZOR_WIND   ; $CA
	const TM03_SWORDS_DANCE ; $CB
	const TM04_FLAMETHROWER ; $CC
	const TM05_MEGA_KICK    ; $CD
	const TM06_TOXIC        ; $CE
	const TM07_HORN_DRILL   ; $CF
	const TM08_BODY_SLAM    ; $D0
	const TM09_TAKE_DOWN    ; $D1
	const TM10_DOUBLE_EDGE  ; $D2
	const TM11_BUBBLEBEAM   ; $D3
	const TM12_WATER_GUN    ; $D4
	const TM13_ICE_BEAM     ; $D5
	const TM14_BLIZZARD     ; $D6
	const TM15_HYPER_BEAM   ; $D7
	const TM16_PAY_DAY      ; $D8
	const TM17_SUBMISSION   ; $D9
	const TM18_COUNTER      ; $DA
	const TM19_SEISMIC_TOSS ; $DB
	const TM20_RAGE         ; $DC
	const TM21_MEGA_DRAIN   ; $DD
	const TM22_SOLARBEAM    ; $DE
	const TM23_DRAGON_RAGE  ; $DF
	const TM24_THUNDERBOLT  ; $E0
	const TM25_THUNDER      ; $E1
	const TM26_EARTHQUAKE   ; $E2
	const TM27_FISSURE      ; $E3
	const TM28_DIG          ; $E4
	const TM29_PSYCHIC_M    ; $E5
	const TM30_TELEPORT     ; $E6
	const TM31_MIMIC        ; $E7
	const TM32_DOUBLE_TEAM  ; $E8
	const TM33_REFLECT      ; $E9
	const TM34_BIDE         ; $EA
	const TM35_METRONOME    ; $EB
	const TM36_SELFDESTRUCT ; $EC
	const TM37_SLUDGE_BOMB  ; $ED
	const TM38_FIRE_BLAST   ; $EE
	const TM39_SWIFT        ; $EF
	const TM40_SKULL_BASH   ; $F0
	const TM41_SOFTBOILED   ; $F1
	const TM42_DREAM_EATER  ; $F2
	const TM43_SKY_ATTACK   ; $F3
	const TM44_REST         ; $F4
	const TM45_THUNDER_WAVE ; $F5
	const TM46_PSYWAVE      ; $F6
	const TM47_EXPLOSION    ; $F7
	const TM48_ROCK_SLIDE   ; $F8
	const TM49_TRI_ATTACK   ; $F9
	const TM50_SUBSTITUTE   ; $FA

; dafthunk : to increase readability in base_stats
tm01_MEGA_PUNCH   EQU 01 ; $C9
tm02_RAZOR_WIND   EQU 02 ; $CA
tm03_SWORDS_DANCE EQU 03 ; $CB
tm04_FLAMETHROWER EQU 04 ; $CC
tm05_MEGA_KICK    EQU 05 ; $CD
tm06_TOXIC        EQU 06 ; $CE
tm07_HORN_DRILL   EQU 07 ; $CF
tm08_BODY_SLAM    EQU 08 ; $D0
tm09_TAKE_DOWN    EQU 09 ; $D1
tm10_DOUBLE_EDGE  EQU 10 ; $D2
tm11_BUBBLEBEAM   EQU 11 ; $D3
tm12_WATER_GUN    EQU 12 ; $D4
tm13_ICE_BEAM     EQU 13 ; $D5
tm14_BLIZZARD     EQU 14 ; $D6
tm15_HYPER_BEAM   EQU 15 ; $D7
tm16_PAY_DAY      EQU 16 ; $D8
tm17_SUBMISSION   EQU 17 ; $D9
tm18_COUNTER      EQU 18 ; $DA
tm19_SEISMIC_TOSS EQU 19 ; $DB
tm20_RAGE         EQU 20 ; $DC
tm21_MEGA_DRAIN   EQU 21 ; $DD
tm22_SOLARBEAM    EQU 22 ; $DE
tm23_DRAGON_RAGE  EQU 23 ; $DF
tm24_THUNDERBOLT  EQU 24 ; $E0
tm25_THUNDER      EQU 25 ; $E1
tm26_EARTHQUAKE   EQU 26 ; $E2
tm27_FISSURE      EQU 27 ; $E3
tm28_DIG          EQU 28 ; $E4
tm29_PSYCHIC_M    EQU 29 ; $E5
tm30_TELEPORT     EQU 30 ; $E6
tm31_MIMIC        EQU 31 ; $E7
tm32_DOUBLE_TEAM  EQU 32 ; $E8
tm33_REFLECT      EQU 33 ; $E9
tm34_BIDE         EQU 34 ; $EA
tm35_METRONOME    EQU 35 ; $EB
tm36_SELFDESTRUCT EQU 36 ; $EC
tm37_SLUDGE_BOMB  EQU 37 ; $ED
tm38_FIRE_BLAST   EQU 38 ; $EE
tm39_SWIFT        EQU 39 ; $EF
tm40_SKULL_BASH   EQU 40 ; $F0
tm41_SOFTBOILED   EQU 41 ; $F1
tm42_DREAM_EATER  EQU 42 ; $F2
tm43_SKY_ATTACK   EQU 43 ; $F3
tm44_REST         EQU 44 ; $F4
tm45_THUNDER_WAVE EQU 45 ; $F5
tm46_PSYWAVE      EQU 46 ; $F6
tm47_EXPLOSION    EQU 47 ; $F7
tm48_ROCK_SLIDE   EQU 48 ; $F8
tm49_TRI_ATTACK   EQU 49 ; $F9
tm50_SUBSTITUTE   EQU 50 ; $FA

hm01_CUT          EQU 51 ; $C4
hm02_FLY          EQU 52 ; $C5
hm03_SURF         EQU 53 ; $C6
hm04_STRENGTH     EQU 54 ; $C7
hm05_FLASH        EQU 55 ; $C8

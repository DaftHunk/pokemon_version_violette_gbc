; wOptions
DEF TEXT_DELAY_FAST   		EQU %00000001	; 1
DEF TEXT_DELAY_MEDIUM 		EQU %00000011	; 3
DEF TEXT_DELAY_SLOW   		EQU %00000101 	; 5
DEF TEXT_DELAY_BITS	  		EQU %00000111 	; bits 0 to 2
DEF BIT_BATTLE_HARD  		EQU 3		  	; bit 3
DEF BATTLE_HARD_MODE  		EQU %00001000	; bit 3
DEF SOUND_STEREO_BITS		EQU %00110000 	; bits 4 to 5
DEF BIT_BATTLE_SHIFT  		EQU 6		 	; bit 6
DEF BIT_BATTLE_ANIMATION 	EQU 7		 	; bit 7
DEF BIT_GAMEPLAY_NUZLOCKE   EQU 6

; wGameplayOptions
DEF BIT_BATTLE_NOSWITCH		EQU 3		  	; bit 3
DEF BATTLE_NOSWITCH  		EQU %00001000	; bit 3
DEF BIT_ENH_GBC_COLORS		EQU 7		  	; bit 7
DEF ENH_GBC_COLORS  		EQU %10000000	; bit 7

DEF TILE_WIDTH EQU 8 ; pixels
DEF LEN_1BPP_TILE EQU 1 * TILE_WIDTH ; bytes
DEF LEN_2BPP_TILE EQU 2 * TILE_WIDTH ; bytes

;;;;;;;;;; PureRGBnote: ADDED: pokedex flags
	const_def
	const BIT_POKEDEX_DATA_DISPLAY_TYPE    ; 0
	const BIT_POKEDEX_WHICH_SPRITE_SHOWING ; 1 
	const BIT_VIEWING_POKEDEX              ; 2
;;;;;;;;;;

; wMiscFlags
; wMiscFlagsDef:
	const_def
	const BIT_SEEN_BY_TRAINER      ; 0
	const BIT_BOULDER_DUST         ; 1
	const BIT_TURNING              ; 2
	const BIT_USING_GENERIC_PC     ; 3
	const BIT_NO_SPRITE_UPDATES    ; 4
	const BIT_NO_MENU_BUTTON_SOUND ; 5
	const BIT_TRIED_PUSH_BOULDER   ; 6
	const BIT_PUSHED_BOULDER       ; 7

; wAutoTextBoxDrawingControl
DEF BIT_NO_AUTO_TEXT_BOX EQU 0

; wTextPredefFlag
DEF BIT_TEXT_PREDEF EQU 0

; wFontLoaded
    const_def
	const BIT_DISABLE_NPC_MOVEMENT ; 0
	const BIT_AI_SENT_POKEMON_1    ; 1
	const BIT_AI_SENT_POKEMON_2    ; 2
	const BIT_AI_SENT_POKEMON_3    ; 3
	const BIT_AI_SENT_POKEMON_4    ; 4
	const BIT_AI_SENT_POKEMON_5    ; 5
	const BIT_AI_SENT_POKEMON_6    ; 6
	const BIT_FORCE_SHINY          ; 7

; wCurrentMapScriptFlags
	const_def 3
	const BIT_MAP_LOADED_AFTER_BATTLE ; 3
	const BIT_CROSSED_MAP_CONNECTION ; 4
	const BIT_CUR_MAP_LOADED_1 ; 5
	const BIT_CUR_MAP_LOADED_2 ; 6
	const BIT_CUR_MAP_USED_ELEVATOR ; 7

; wLetterPrintingDelayFlags
	const_def
	const BIT_FAST_TEXT_DELAY ; 0
	const BIT_TEXT_NO_DELAY   ; 1

; wObtainedBadges
	const_def
	const BIT_BOULDERBADGE ; 0
	const BIT_CASCADEBADGE ; 1
	const BIT_THUNDERBADGE ; 2
	const BIT_RAINBOWBADGE ; 3
	const BIT_SOULBADGE    ; 4
	const BIT_MARSHBADGE   ; 5
	const BIT_VOLCANOBADGE ; 6
	const BIT_EARTHBADGE   ; 7

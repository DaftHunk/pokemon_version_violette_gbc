
; text macros
text   EQUS "db $00," ; Start writing text.
next   EQUS "db $4e," ; Move a line down.
line   EQUS "db $4f," ; Start writing at the bottom line.
para   EQUS "db $51," ; Start a new paragraph.
cont   EQUS "db $55," ; Scroll to the next line.
autocont   EQUS "db $4C," ; Auto-Scroll to the next line.
done   EQUS "db $57"  ; End a text box.
prompt EQUS "db $58"  ; Prompt the player to end a text box (initiating some other event).

page   EQUS "db $49,"     ; Start a new Pokedex page.
dex    EQUS "db $5f, $50" ; End a Pokedex entry.

wStringBuffer EQUS "wcf4b" ; Alias for french text

MACRO text_start ; Alias for french text
	db $00
ENDM

MACRO TX_RAM
; prints text to screen
; \1: RAM address to read from
	db $01
	dw \1
ENDM

MACRO text_ram ; Alias for french text
	TX_RAM \1
ENDM

MACRO TX_BCD
; \1: RAM address to read from
; \2: number of bytes + print flags
	db $02
	dw \1
	db \2
ENDM

MACRO text_bcd ; Alias for french text
	TX_BCD \1, \2
ENDM

; TX_MOVE   EQUS "db $03"
; TX_BOX    EQUS "db $04"
TX_LINE    EQUS "db $05"
TX_BLINK   EQUS "db $06"
TX_SCROLL  EQUS "db $07"
TX_ASM     EQUS "db $08"

MACRO TX_NUM
; print a big-endian decimal number.
; \1: address to read from
; \2: number of bytes to read
; \3: number of digits to display
	db $09
	dw \1
	db \2 << 4 | \3
ENDM

MACRO text_decimal ; Alias for french text
	TX_NUM \1, \2, \3
ENDM

TX_DELAY              EQUS "db $0a"
TX_SFX_ITEM_1         EQUS "db $0b"
TX_SFX_LEVEL_UP       EQUS "db $0b"
;TX_ELLIPSES          EQUS "db $0c"
TX_WAIT               EQUS "db $0d"
;TX_SFX_DEX_RATING    EQUS "db $0e"
TX_SFX_ITEM_2         EQUS "db $10"
TX_SFX_KEY_ITEM       EQUS "db $11"
TX_SFX_CAUGHT_MON     EQUS "db $12"
TX_SFX_DEX_PAGE_ADDED EQUS "db $13"
TX_CRY_NIDORINO       EQUS "db $14"
TX_CRY_PIDGEOT        EQUS "db $15"
;TX_CRY_DEWGONG       EQUS "db $16"

MACRO TX_FAR
	db $17
	dw \1
	db BANK(\1)
ENDM

TX_VENDING_MACHINE         EQUS "db $f5"
TX_CABLE_CLUB_RECEPTIONIST EQUS "db $f6"
TX_PRIZE_VENDOR            EQUS "db $f7"
TX_POKECENTER_PC           EQUS "db $f9"
TX_PLAYERS_PC              EQUS "db $fc"
TX_BILLS_PC                EQUS "db $fd"

MACRO TX_MART
	db $FE, _NARG
	REPT _NARG
	db \1
	SHIFT
	ENDR
	db $FF
ENDM

TX_POKECENTER_NURSE        EQUS "db $ff"

MACRO text_end ; Alias for french text
	db $50
ENDM

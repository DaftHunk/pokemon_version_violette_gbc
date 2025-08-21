TextBoxBorder::
; Draw a c×b text box at hl.

	; top row
	push hl
	ld a, "┌"
	ld [hli], a
	inc a ; ─
	call NPlaceChar
	inc a ; ┐
	ld [hl], a
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de

	; middle rows
.next
	push hl
	ld a, "│"
	ld [hli], a
	ld a, " "
	call NPlaceChar
	ld [hl], "│"
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .next

	; bottom row
	ld a, "└"
	ld [hli], a
	ld a, "─"
	call NPlaceChar
	ld [hl], "┘"
	ret

NPlaceChar::
; Place char a c times.
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

PlaceString::
	push hl
PlaceNextChar::
	ld a, [de]

	cp "@"
	jr nz, LineFeedText
	ld b, h
	ld c, l
	pop hl
	ret

LineFeedText::
	;joenote - add Rangi's line-feed implementation
	cp "<LF>"
	jr z, .line_feed
	
	cp $4E ; next
	jr nz, .lineText
	ld bc, 2 * SCREEN_WIDTH
	ld a, [hFlags_0xFFF6]
	bit 2, a
	jr z, .ok
.line_feed
	ld bc, SCREEN_WIDTH
.ok
	pop hl
	add hl, bc
	push hl
	jp PlaceNextChar_inc

.lineText
	cp $4F ; line
	jr nz, .next3
	pop hl
	coord hl, 1, 16
	push hl
	jp PlaceNextChar_inc

.next3 ; Check against a dictionary
MACRO dict
if \1 == 0
	and a
else
	cp \1
endc
	jp z, \2
ENDM

	dict $00, ErrorChar ; error
	dict $4C, AutoContChar ; autocont
	dict $4B, ContChar ; cont_
	dict $51, Paragraph ; para
	dict $48, MultiButtonPageChar ; Bage
	dict $49, PageChar ; page
	dict $52, PlayerChar ; player
	dict $53, RivalChar ; rival
	dict $54, PokeChar ; POKé
	dict $5B, PCChar ; PC
	dict $5E, RocketChar ; ROCKET
	dict $5C, TMChar ; TM
	dict $5D, TrainerChar ; TRAINER
	dict $55, ContText ; cont
	dict $57, DoneText ; done
	dict $58, PromptText ; prompt
	dict $4A, PKMNChar ; PKMN
	dict $5F, PlaceDexEnd ; dex
	dict $59, TargetChar ; TARGET
	dict $5A, UserChar ; USER

	ld [hli], a
	call PrintLetterDelay
PlaceNextChar_inc::
	inc de
	jp PlaceNextChar

ErrorChar::
	ld b, h
	ld c, l
	pop hl
	ld de, ErrorCharText
	dec de
	ret

ErrorCharText:: ; “%d ERROR.”
	TX_FAR _ErrorCharText
	db "@"

PlayerChar:: ; player’s name
	push de
	ld de, wPlayerName
	jr FinishDTE

RivalChar:: ; rival’s name
	push de
	ld de, wRivalName
	jr FinishDTE

TrainerChar:: ; TRAINER
	push de
	ld de, TeamCharText
	jr FinishDTE

TMChar:: ; TM
	push de
	ld de, TMCharText
	jr FinishDTE

PCChar:: ; PC
	push de
	ld de, PCCharText
	jr FinishDTE

RocketChar:: ; ROCKET
	push de
	ld de, RocketCharText
	jr FinishDTE

PokeChar:: ; POKé
	push de
	ld de, PokeCharText
	jr FinishDTE

PKMNChar:: ; PKMN
	push de
	ld de, PokemonText
	jr FinishDTE

TargetChar::
; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
; (like UserChar but flipped)
	ld a, [H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

UserChar::
; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
	ld a, [H_WHOSETURN]
MonsterNameCharsCommon::
	push de
	and a
	jr nz, .Enemy
	ld de, wBattleMonNick ; player active monster name
	jr FinishDTE

.Enemy
	; print “Enemy ”
	ld de, OpponentText
	call PlaceString
	ld h, b
	ld l, c
	ld de, wEnemyMonNick ; enemy active monster name

FinishDTE::
	call PlaceString
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

TMCharText::
	db "CT@"
TeamCharText::
	db "Dres.@"
PCCharText::
	db "PC@"
RocketCharText::
	db "Rocket@"
PokeCharText::
	db "Poké@"
OpponentText::
	db "@ ennemi"
PokemonText::
	db $E1,$E2,"@" ; PKMN

ContText::
	push de
	ld b, h
	ld c, l
	ld hl, ContTextText
	call TextCommandProcessor
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

ContTextText::
; equivalent to ContChar
	TX_FAR _ContTextText
	db "@"

PlaceDexEnd::
; ends a Pokédex entry
	ld [hl], "."
	pop hl
	ret

PromptText:: ; prompt
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, .ok
	ld a, "▼"
	Coorda 18, 16
.ok
	call ProtectedDelay3
	call ManualTextScroll
	ld a, " "
	Coorda 18, 16
DoneText:: ; done
	pop hl
	ld de, PromptTextText
	dec de
	ret

PromptTextText::
	db "@"

Paragraph:: ; para
	push de
	ld a, "▼"
	Coorda 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 13
	lb bc, 4, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	coord hl, 1, 14
	jp PlaceNextChar_inc

PageChar::
	push de
	ld a, "▼"
	Coorda 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	coord hl, 1, 10
	lb bc, 7, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	pop hl
	coord hl, 1, 11
	push hl
	jp PlaceNextChar_inc

;;;;;;;;; PureRGBnote: ADDED: new text command that allows multiple buttons to be watched while waiting on a text prompt 
MultiButtonPageChar::
	push de
	callfar TextCommandPromptMultiButton
	; d = what to do after this
	ld a, d
	and a
	jr nz, .exit
	pop de
	pop hl
	coord hl, 1, 11
	push hl
	jp PlaceNextChar_inc
.exit
	pop de
	jp DoneText
;;;;;;;;;

ContChar::
	ld a, "▼"
	Coorda 18, 16
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a, " "
	Coorda 18, 16
	jr AutoContChar.nodelay
AutoContChar::	;auto-continue
	ld c, 30			;joenote - added a frame delay when just doing auto-continue
	call DelayFrames
.nodelay
	push de
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	coord hl, 1, 16
	pop de
	jp PlaceNextChar_inc

; move both rows of text in the normal text box up one row
; always called twice in a row
; first time, copy the two rows of text to the "in between" rows that are usually emtpy
; second time, copy the bottom row of text into the top row of text
ScrollTextUpOneLine::
	coord hl, 0, 14 ; top row of text
	coord de, 0, 13 ; empty line above text
	ld b, SCREEN_WIDTH * 3
.copyText
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyText
	coord hl, 1, 16
	ld a, " "
	ld b, SCREEN_WIDTH - 2
.clearText
	ld [hli], a
	dec b
	jr nz, .clearText

	; wait five frames
	ld b, 5
.WaitFrame
	call DelayFrame
	dec b
	jr nz, .WaitFrame

	ret

ProtectedDelay3::
	push bc
	call Delay3
	pop bc
	ret

TextCommandProcessor::
	ld a, [wLetterPrintingDelayFlags]
	push af
	set 1, a
	ld e, a
	ld a, [hClearLetterPrintingDelayFlags]
	xor e
	ld [wLetterPrintingDelayFlags], a
	ld a, c
	ld [wTextDest], a
	ld a, b
	ld [wTextDest + 1], a

NextTextCommand::
	ld a, [hli]
	cp "@" ; terminator
	jr nz, .doTextCommand
.NoNextTextCommand:
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret
.doTextCommand
	push hl
	cp $17
	jp z, TextCommand17
	cp $10
	jp nc, TextCommand_SOUND ; if a != 0x17 and a >= 0xE, go to command 0xB
; if a < 0xE, use a jump table
	ld hl, TextCommandJumpTable
	push bc
	add a
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; draw box
; 04AAAABBCC
; AAAA = address of upper left corner
; BB = height
; CC = width
TextCommand_BOX::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld h, d
	ld l, e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

TextCommand_START_storeFlags:
	ld a, [wLetterPrintingDelayFlags]
	push af
	jr TextCommand_START_noPop

; place string inline
; 00{string}
TextCommand_START::
	pop hl
TextCommand_START_noPop::
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
	ld h, d
	ld l, e
	inc hl
	jr NextTextCommand

; place string from RAM
; 01AAAA
; AAAA = address of string
TextCommand_RAM::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	jr NextTextCommand

; print BCD number
; 02AAAABB
; AAAA = address of BCD number
; BB
; bits 0-4 = length in bytes
; bits 5-7 = unknown flags
TextCommand_BCD::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld c, a
	call PrintBCDNumber
	ld b, h
	ld c, l
	pop hl
	jr NextTextCommand

; PureRGBnote: ADDED: jump to a different address in the same text bank so we can reuse text
TextCommand_JUMP::
	pop hl
	hl_deref
	push hl
	jr TextCommand_START

; PureRGBnote: ADDED: call different text in the same bank then come back
TextCommand_CALL::
	pop hl
	push hl
	hl_deref
	ResetFlag EVENT_INTERRUPTED_TEXT
	call TextCommand_START_storeFlags
	ld b, h
	ld c, l
	pop hl
	CheckEvent EVENT_INTERRUPTED_TEXT
	jp nz, NextTextCommand.NoNextTextCommand
	; inc hl twice to increment past the TX_CALL address
	inc hl
	inc hl
	jp TextCommand_START_noPop ; assumes after returning from call we will do additional text


; repoint destination address
; 03AAAA
; AAAA = new destination address
TextCommand_MOVE::
	pop hl
	ld a, [hli]
	ld [wTextDest], a
	ld c, a
	ld a, [hli]
	ld [wTextDest + 1], a
	ld b, a
	jp NextTextCommand

; repoint destination to second line of dialogue text box
; 05
; (no arguments)
TextCommand_LOW::
	pop hl
	coord bc, 1, 16 ; address of second line of dialogue text box
	jp NextTextCommand

; blink arrow and wait for A or B to be pressed
; 06
; (no arguments)
TextCommand_PROMPT_BUTTON::
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, TextCommand_WAIT_BUTTON 
	ld a, "▼"
	Coorda 18, 16 ; place down arrow in lower right corner of dialogue text box
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
	ld a, " "
	Coorda 18, 16 ; overwrite down arrow with blank space
	pop hl
	jp NextTextCommand

; scroll text up one line
; 07
; (no arguments)
TextCommand_SCROLL::
	ld a, " "
	Coorda 18, 16 ; place blank space in lower right corner of dialogue text box
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	pop hl
	coord bc, 1, 16 ; address of second line of dialogue text box
	jp NextTextCommand

; execute asm inline
; 08{code}
TextCommand_START_ASM::
	pop hl
	ld de, NextTextCommand
	push de ; return address
	jp hl

; print decimal number (converted from binary number)
; 09AAAABB
; AAAA = address of number
; BB
; bits 0-3 = how many digits to display
; bits 4-7 = how long the number is in bytes
TextCommand_NUM::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $0f
	ld c, a
	ld a, b
	and $f0
	swap a
	set BIT_LEFT_ALIGN,a
	ld b, a
	call PrintNumber
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

; wait half a second if the user doesn't hold A or B
; 0A
; (no arguments)
TextCommand_PAUSE::
	push bc
	call Joypad
	ld a, [hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr nz, .skipDelay
	ld c, 30
	call DelayFrames
.skipDelay
	pop bc
	pop hl
	jp NextTextCommand

; plays sounds
; this actually handles various command ID's, not just 0B
; (no arguments)
TextCommand_SOUND::	;joenote - modified to make SFX_GET_KEY_ITEM play a previously unused sound effect in battle (for getting a badge)
	pop hl
	push bc
	dec hl
	ld a, [hli]
	ld b, a ; b = command number that got us here
	push hl
	ld hl, TextCommandSounds
.loop
	ld a, [hli]
	cp b
	jr z, .matchFound
	inc hl
	jr .loop
.matchFound
	cp $14
	jr z, .pokemonCry
	cp $15
	jr z, .pokemonCry
	cp $16
	jr z, .pokemonCry
	cp $11
	jr z, .keyitem
.playnormally
	ld a, [wOptions]
	and TEXT_DELAY_BITS
	ld a, [hl]
	call PlaySound
	call WaitForSoundToFinish
.finishnormally
	pop hl
	pop bc
	jp NextTextCommand
.pokemonCry
	push de
	ld a, [hl]
	call PlayCry
	pop de
	pop hl
	pop bc
	jp NextTextCommand
.keyitem
	push de
	ld a, [wAudioROMBank]
	cp BANK(Audio2_PlaySound)
	pop de
	jr nz, .playnormally	;don't do anything special if we're not in audio bank 2
	push de
	callba Music_GetKeyItemInBattle
.musicWaitLoop ; wait for music to finish playing
	ld a, [wChannelSoundIDs + Ch6]
	and a ; music off?
	jr nz, .musicWaitLoop
	pop de
	jr .finishnormally
	

; format: text command ID, sound ID or cry ID
TextCommandSounds::
	db $0B, SFX_GET_ITEM_1 ; actually plays SFX_LEVEL_UP when the battle music engine is loaded
	db $12, SFX_CAUGHT_MON
	db $0E, SFX_POKEDEX_RATING ; unused?
	db $0F, SFX_GET_ITEM_1 ; unused?
	db $10, SFX_GET_ITEM_2
	db $11, SFX_GET_KEY_ITEM
	db $13, SFX_DEX_PAGE_ADDED
	db $14, NIDORINO ; used in OakSpeech	(joenote - corrected from Nidorina)
	db $15, PIDGEOT  ; used in SaffronCityText12
	db $16, DEWGONG  ; unused?

; wait for A or B to be pressed
; 0D
; (no arguments)
TextCommand_WAIT_BUTTON ::
	push bc
	call ManualTextScroll ; wait for A or B to be pressed
	pop bc
	pop hl
	jp NextTextCommand

; process text commands in another ROM bank
; 17AAAABB
; AAAA = address of text commands
; BB = bank
TextCommand17::
	pop hl
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	push hl
	ld l, e
	ld h, d
	call TextCommandProcessor
	pop hl
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	jp NextTextCommand

NewPageButtonPressCheck::
.waitForButtonPressLetGo
	call Joypad
	ldh a, [hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr nz, .waitForButtonPressLetGo
.waitForButtonPress
	call Joypad
	ldh a, [hJoyHeld]
	and A_BUTTON | B_BUTTON
	jr z, .waitForButtonPress
	ret

TextCommandJumpTable::
; entries correspond to TX_* constants (see macros/text_macros.asm)
	dw TextCommand_START         ; TX_START
	dw TextCommand_RAM           ; TX_RAM
	dw TextCommand_BCD           ; TX_BCD
	dw TextCommand_MOVE          ; TX_MOVE
	dw TextCommand_BOX           ; TX_BOX
	dw TextCommand_LOW           ; TX_LINE
	dw TextCommand_PROMPT_BUTTON ; TX_BLINK
IF DEF(_DEBUG)
	dw DoneText                    ; TX_SCROLL
ELSE
	dw TextCommand_SCROLL        ; TX_SCROLL
ENDC
	dw TextCommand_START_ASM     ; TX_ASM
	dw TextCommand_NUM           ; TX_NUM
	dw TextCommand_PAUSE         ; TX_DELAY
	dw TextCommand_SOUND         ; TX_SFX_ITEM_1 (also handles other TX_SOUND_* commands)
	dw TextCommand_WAIT_BUTTON   ; TX_WAIT
	dw TextCommand_JUMP          ; TX_JUMP
	dw TextCommand_CALL          ; TX_CALL
	; greater TX_* constants are handled directly by NextTextCommand 

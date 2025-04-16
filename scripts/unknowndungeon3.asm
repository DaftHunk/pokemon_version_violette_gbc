UnknownDungeon3Script:
	call EnableAutoTextBoxDrawing
	ld hl, MewtwoTrainerHeader
	ld de, .ScriptPointers
	ld a, [wUnknownDungeon3CurScript]
	call ExecuteCurMapScriptInTable
	ld [wUnknownDungeon3CurScript], a

	CheckEvent EVENT_GOT_DEX_DIPLOMA	
	ret z	;return if you don't have diploma
	CheckEvent EVENT_MEW_TEXT	
	ret nz	;return if mew notification is deactivated
	ld a, $3
	ld [wUnknownDungeon3CurScript], a

	ret

.ScriptPointers
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw MewNotifyScript

UnknownDungeon3TextPointers:
	dw MewtwoText
	dw PickUpItemText
	dw PickUpItemText

MewtwoTrainerHeader:
	dbEventFlagBit EVENT_BEAT_MEWTWO
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_MEWTWO
	dw MewtwoBattleText ; TextBeforeBattle
	dw MewtwoBattleText ; TextAfterBattle
	dw MewtwoBattleText ; TextEndBattle
	dw MewtwoBattleText ; TextEndBattle

	db $ff

MewtwoText:
	TX_ASM
	ld hl, MewtwoTrainerHeader
	;make the shiny attract cheat work on static wild encounters
	push hl
	push bc
	callba ShinyAttractFunction
	pop bc
	pop hl
	call TalkToTrainer
	jp TextScriptEnd

MewtwoBattleText:
	TX_FAR _MewtwoBattleText
	TX_ASM
	ld a, MEWTWO
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

;joenote - mew notifications
MewNotifyScript:
	push bc
	;initialize a text box without drawing anything special
	ld a, 1
	ld [wAutoTextBoxDrawingControl], a
	callba DisplayTextIDInit
	pop bc
	
	ld hl, MewUnavailableText
	CheckEvent EVENT_ENCOUTERED_MEW	;has mew been encountered before?
	jr nz, .print
	ld hl, MewAvailableText
.print
	call PrintText
	;use $ff value loaded into hSpriteIndexOrTextID to make DisplayTextID display nothing and close any text
	ld a, $FF
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	
	SetEvent EVENT_MEW_TEXT	;deactivate mew notification
	xor a
	ld [wCurMapScript], a
	ret
MewAvailableText:
	TX_FAR _MewAvailableText
	db "@"
MewUnavailableText:
	TX_FAR _MewUnavailableText
	db "@"
SSAnne1Script:
	call EnableAutoTextBoxDrawing
	ret

SSAnne1TextPointers:
	dw SSAnne1Text1
	dw SSAnne1Text2

SSAnne1Text1:
	TX_ASM

	ld hl, SSAnne1Text_BeforeHeal
	call PrintText

	call GBFadeOutToWhite
	call ReloadMapData
	predef HealParty

	ld c, 0 ; BANK(Music_RestPallet)
;TODO
;	ld a, MUSIC_REST_PALLET
	call PlayMusic

	ld c, $AA
	call DelayFrames

	call GBFadeInFromWhite
	call PlayDefaultMusic

	ld hl, SSAnne1Text_AfterHeal
	call PrintText
	jp TextScriptEnd

SSAnne1Text2:
	TX_FAR _SSAnne1Text2
	db "@"

SSAnne1Text_BeforeHeal:
	TX_FAR _SSAnne1Text_BeforeHeal
	db "@"

SSAnne1Text_AfterHeal:
	TX_FAR _SSAnne1Text_AfterHeal
	db "@"
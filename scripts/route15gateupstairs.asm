Route15GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route15GateUpstairsTextPointers:
	dw Route15GateUpstairsText1
	dw Route15GateUpstairsText

Route15GateUpstairsText1:
	TX_ASM
	CheckEvent EVENT_GOT_EXP_ALL
	jr nz, .asm_49683
	ld a, 50 ; pokemon needed
	ld [hOaksAideRequirement], a
	ld a, EXP_ALL ; oak's aide reward
	ld [hOaksAideRewardItem], a
	ld [wPokedexNum], a
	call GetItemName
	ld hl, wcd6d
	ld de, wOaksAideRewardItemName
	ld bc, ITEM_NAME_LENGTH
	call CopyData
	predef OaksAideScript
	ld a, [hOaksAideResult]
	cp $1
	jr nz, .asm_49689
	SetEvent EVENT_GOT_EXP_ALL
.asm_49683
	ld hl, Route15GateUpstairsText_4968c
	call PrintText
.asm_49689
	jp TextScriptEnd

Route15GateUpstairsText_4968c:
	TX_FAR _Route15GateUpstairsText_4968c
	db "@"

Route15GateUpstairsText:
	TX_ASM
	ld hl, Route15UpstairsText
	jp GateUpstairsScript_PrintIfFacingUp

Route15UpstairsText:
	TX_FAR _Route15UpstairsBinocularsText
	db "@"

Route22GateUpstairsScript:
	jp EnableAutoTextBoxDrawing

Route22GateUpstairsTextPointers:
	dw Route22GateUpstairsText_Assistant
	dw Route22GateUpstairsText_Cup
	dw Route22GateUpstairsText_Cup
	dw Route22GateUpstairsText_Champion
	dw Route22GateUpstairsText_Champion
	dw Route22GateUpstairsText_Binoculars

Route22GateUpstairsText_Assistant:
	TX_ASM
	CheckEvent EVENT_GOT_EXP_CATCH_UP
	jr nz, .itemGiven

	ld a, 75 ; pokemon needed
	ld [hOaksAideRequirement], a
	; check for Nuzzlocke
	ld a, [wGameplayOptions]
	bit BIT_GAMEPLAY_NUZLOCKE, a
	jr z, .next

	; if Nuzzlocke enabled decrease to 10 mons
	ld a, 10 ; pokemon needed
	ld [hOaksAideRequirement], a
	; fallthrough
.next
	ld a, EXP_CATCH_UP ; oak's aide reward
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
	jr nz, .endScript
	
	SetEvent EVENT_GOT_EXP_CATCH_UP
.itemGiven
	ld hl, Route22GateUpstairsText_ExpCatchUp
	call PrintText
.endScript
	jp TextScriptEnd

Route22GateUpstairsText_ExpCatchUp:
	TX_FAR _Route22GateUpstairsText_ExpCatchUp
	db "@"

Route22GateUpstairsText_Cup:
	TX_FAR _Route22GateUpstairsText_Cup
	db "@"

Route22GateUpstairsText_Champion:
	TX_FAR _Route22GateUpstairsText_Champion
	db "@"

Route22GateUpstairsText_Binoculars:
	TX_FAR _Route22GateUpstairsText_Binoculars
	db "@"

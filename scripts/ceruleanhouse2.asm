CeruleanBadgeHouseScript:
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	dec a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

CeruleanBadgeHouseTextPointers:
	dw CeruleanBadgeHouseMainText
	dw CeruleanBadgeHouseLevelCapText
	dw CeruleanBadgeHouseText_CurrentCap

CeruleanBadgeHouseMainText:
	TX_ASM
	ld hl, CeruleanBadgeHouseText_Greet
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
.badgeLoop
	ld hl, CeruleanBadgeHouseText_Ask
	call PrintText
	ld hl, BadgeItemList
	call LoadItemList
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld [wMenuItemToSwap], a
	ld a, SPECIALLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jr c, .endScript
	ld hl, TextPointers_Badges
	ld a, [wcf91]
	sub $15
	add a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	jr .badgeLoop
.endScript
	xor a
	ld [wListScrollOffset], a
	ld hl, CeruleanBadgeHouseText_Later
	call PrintText
	jp TextScriptEnd

BadgeItemList:
	db $8,BOULDERBADGE,CASCADEBADGE,THUNDERBADGE,RAINBOWBADGE,SOULBADGE,MARSHBADGE,VOLCANOBADGE,EARTHBADGE,$FF

CeruleanBadgeHouseText_Greet:
	TX_FAR _CeruleanBadgeHouseText_Greet
	db "@"

CeruleanBadgeHouseText_Ask:
	TX_FAR _CeruleanBadgeHouseText_Ask
	db "@"

CeruleanBadgeHouseText_Later:
	TX_FAR _CeruleanBadgeHouseText_Later
	db "@"

TextPointers_Badges:
	dw CeruleanBadgeHouseText_Boulder
	dw CeruleanBadgeHouseText_Cascade
	dw CeruleanBadgeHouseText_Thunder
	dw CeruleanBadgeHouseText_Rainbow
	dw CeruleanBadgeHouseText_Soul
	dw CeruleanBadgeHouseText_Marsh
	dw CeruleanBadgeHouseText_Volcano
	dw CeruleanBadgeHouseText_Earth

CeruleanBadgeHouseText_Boulder:
	TX_FAR _CeruleanBadgeHouseText_Boulder
	db "@"

CeruleanBadgeHouseText_Cascade:
	TX_FAR _CeruleanBadgeHouseText_Cascade
	db "@"

CeruleanBadgeHouseText_Thunder:
	TX_FAR _CeruleanBadgeHouseText_Thunder
	db "@"

CeruleanBadgeHouseText_Rainbow:
	TX_FAR _CeruleanBadgeHouseText_Rainbow
	db "@"

CeruleanBadgeHouseText_Soul:
	TX_FAR _CeruleanBadgeHouseText_Soul
	db "@"

CeruleanBadgeHouseText_Marsh:
	TX_FAR _CeruleanBadgeHouseText_Marsh
	db "@"

CeruleanBadgeHouseText_Volcano:
	TX_FAR _CeruleanBadgeHouseText_Volcano
	db "@"

CeruleanBadgeHouseText_Earth:
	TX_FAR _CeruleanBadgeHouseText_Earth
	db "@"

CeruleanBadgeHouseLevelCapText:
	TX_ASM

	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .noLevelCap ; no levelcaps
	; else
	ld hl, CeruleanBadgeHouseText_LevelCap
	jr .endScript
.noLevelCap
	ld hl, CeruleanBadgeHouseText_Obedience
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd

CeruleanBadgeHouseText_Obedience:
	TX_FAR _CeruleanBadgeHouseText_Obedience
	db "@"

CeruleanBadgeHouseText_LevelCap:
	TX_FAR _CeruleanBadgeHouseText_LevelCap
	db "@"

CeruleanBadgeHouseText_CurrentCap:
	TX_ASM

	callfar GetLevelCap
	
	ld a, [wMoreGameplayOptions]
	bit 0, a
	jr z, .noLevelCap ; no levelcaps
	; else
	ld hl, CeruleanBadgeHouseText_CurrentLevelCap
	jr .endScript
.noLevelCap
	ld hl, CeruleanBadgeHouseText_CurrentObedience
	; fallthrough
.endScript
	call PrintText
	jp TextScriptEnd

CeruleanBadgeHouseText_CurrentObedience:
	TX_FAR _DisplayObedience
	db "@"

CeruleanBadgeHouseText_CurrentLevelCap:
	TX_FAR _DisplayLevelCap
	db "@"

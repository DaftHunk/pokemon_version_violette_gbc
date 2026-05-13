Route23Script:
	call Route23Script_511e9
	call EnableAutoTextBoxDrawing
	ld hl, Route23ScriptPointers
	ld a, [wRoute23CurScript]
	jp CallFunctionInTable

Route23Script_511e9:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z

	CheckEvent EVENT_DISABLED_VICTORY_ROAD_RESET
	ret nz
	; falltrough

Route23Script_TrainerReset:
; Victory Road trainers are now reseted everytime you go out
	ResetEventRange EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_0, EVENT_BEAT_VICTORY_ROAD_1F_TRAINER_5
	ResetEventRange EVENT_BEAT_VICTORY_ROAD_2_TRAINER_0, EVENT_BEAT_VICTORY_ROAD_2_TRAINER_4
	ResetEventRange EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_0, EVENT_BEAT_VICTORY_ROAD_3F_TRAINER_3
	ret

Route23ScriptPointers:
	dw Route23Script0
	dw Route23Script1
	dw Route23Script2

Route23Script0:
	ld hl, YCoordsData_51255
	ld a, [wYCoord]
	ld b, a
	ld e, $0
	EventFlagBit c, EVENT_PASSED_EARTHBADGE_CHECK + 1, EVENT_PASSED_CASCADEBADGE_CHECK
.asm_51224
	ld a, [hli]
	cp $ff
	ret z
	inc e
	dec c
	cp b
	jr nz, .asm_51224
	cp $23
	jr nz, .asm_51237
	ld a, [wXCoord]
	cp $e
	ret nc
.asm_51237
	ld a, e
	ld [hSpriteIndexOrTextID], a
	ld a, c
	ld [wWhichBadge], a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_PASSED_CASCADEBADGE_CHECK
	predef FlagActionPredef
	ld a, c
	and a
	ret nz
	call Route23Script_5125d
	call DisplayTextID
	xor a
	ld [hJoyHeld], a
	ret

YCoordsData_51255:
	db $25,$38,$46,$5A,$69,$77,$88,$FF

Route23Script_5125d:
	ld hl, BadgeTextPointers
	ld a, [wWhichBadge]
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wcd6d
.copyTextLoop
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .copyTextLoop
	ret

BadgeTextPointers:
	dw CascadeBadgeText
	dw ThunderBadgeText
	dw RainbowBadgeText
	dw SoulBadgeText
	dw MarshBadgeText
	dw VolcanoBadgeText
	dw EarthBadgeText

EarthBadgeText:
	db "Badge Terre@"

VolcanoBadgeText:
	db "Badge Volcan@"

MarshBadgeText:
	db "Badge Marais@"

SoulBadgeText:
	db "Badge Ame@"

RainbowBadgeText:
	db "Badge Prisme@"

ThunderBadgeText:
	db "Badge Foudre@"

CascadeBadgeText:
	db "BadgeCascade@"

Route23Script_512d8:
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData1 + 9], a
	ld [wJoyIgnore], a
	jp StartSimulatingJoypadStates

Route23Script1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
Route23Script2:
	ld a, $0
	ld [wRoute23CurScript], a
	ret

Route23TextPointers:
	dw Route23Text1
	dw Route23Text2
	dw Route23Text3
	dw Route23Text4
	dw Route23Text5
	dw Route23Text6
	dw Route23Text7
	dw Route23Text_VictoryRoadGuide
	dw Route23Text8

Route23Text1:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_EARTHBADGE_CHECK, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Text2:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_VOLCANOBADGE_CHECK, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Text3:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_MARSHBADGE_CHECK, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Text4:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_SOULBADGE_CHECK, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Text5:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_RAINBOWBADGE_CHECK, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Text6:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_THUNDERBADGE_CHECK, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Text7:
	TX_ASM
	EventFlagBit a, EVENT_PASSED_CASCADEBADGE_CHECK
	call Route23Script_51346
	jp TextScriptEnd

Route23Script_51346:
	ld [wWhichBadge], a
	call Route23Script_5125d
	ld a, [wWhichBadge]
	inc a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wObtainedBadges
	predef FlagActionPredef
	ld a, c
	and a
	jr nz, .asm_5136e
	ld hl, VictoryRoadGuardText1
	call PrintText
	call Route23Script_512d8
	ld a, $1
	ld [wRoute23CurScript], a
	ret
.asm_5136e
	ld hl, VictoryRoadGuardText2
	call PrintText
	ld a, [wWhichBadge]
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_PASSED_CASCADEBADGE_CHECK
	predef FlagActionPredef
	ld a, $2
	ld [wRoute23CurScript], a
	ret

Route23Script_51388:
	ld hl, VictoryRoadGuardText2
	jp PrintText

VictoryRoadGuardText1:
	TX_FAR _VictoryRoadGuardText1
	TX_ASM
	ld a, SFX_DENIED
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jp TextScriptEnd

VictoryRoadGuardText2:
	TX_FAR _VictoryRoadGuardText2
	TX_SFX_ITEM_1
	TX_FAR _VictoryRoadGuardText_513a3
	db "@"

Route23Text_VictoryRoadGuide:
	TX_ASM

	ld hl, .victoryRoadGuideText
	call PrintText

	call NoYesChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .answerNo

	ResetEvent EVENT_DISABLED_VICTORY_ROAD_RESET
	ld hl, .victoryRoadGuideTextEnabled
	jp .endScript

.answerNo
	SetEvent EVENT_DISABLED_VICTORY_ROAD_RESET
	call Route23Script_TrainerReset
	ld hl, .victoryRoadGuideTextDisabled
	jp .endScript

.victoryRoadGuideText
	text "Futur Champion!"
	line "Voici le dernier"
	cont "défi avant la"
	cont "Ligue!"

	para "Te voici devant"
	line "la légendaire"
	cont "Route Victoire!"

	para "Tu y trouveras"
	line "l'élite des"
	cont "dresseurs et en"
	cont "cas de sortie ils"
	cont "t'affronteront"
	cont "à nouveau!"

	para "Il te faudra"
	line "trouver le chemin"
	cont "le plus efficace"
	cont "pour en affronter"
	cont "le moins possible"
	cont "et surmonter"
	cont "l'épreuve en"
	cont "un passage!"

	para "Un conseil?"

	para "Les rochers posés"
	line "sur les plaques"
	cont "de pression ne"
	cont "seront pas remis"
	cont "à leur places."

	para "Ce défi n'est pas"
	line "à ton goût?"
	cont "Je peux dire aux"
	cont "de ne pas te"
	cont "réaffronter si tu"
	cont "le souhaites."
	done
	db "@"

.victoryRoadGuideTextEnabled
	text "Parfait! Fais le"
	line "plein de soins"
	cont "et bonne chance!"
	done
	db "@"

.victoryRoadGuideTextDisabled
	text "Comme tu voudras,"
	line "tu n'auras pas à"
	cont "battre à nouveau."
	done
	db "@"

.endScript
	call PrintText
	jp TextScriptEnd

Route23Text8:
	TX_FAR _Route23Text8
	db "@"

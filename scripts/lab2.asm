Lab2Script:
	jp EnableAutoTextBoxDrawing

Lab2TextPointers:
	dw Lab2Text1
	dw Lab2Text2
	dw Lab2Text3

Lab2Text1:
	TX_ASM
	CheckBothEventsSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	jr z, .showAlreadyBoughtText;already bought fossils
	CheckEvent EVENT_908	;has elite 4 been beaten?
	jr nz, .recognizeChampion
	ld hl, Lab2TextFossile
	call PrintText
	jp .textEnd
.showAlreadyBoughtText
	ld hl, Lab2TextFossile2
	call PrintText
	jp .textEnd
.recognizeChampion
	ld hl, Lab2TextFossileChampion
	call PrintText
	call ManualTextScroll
	CheckEvent EVENT_GOT_DOME_FOSSIL
	;if player choose dome ask for helix
	jr nz, .displayHelixText
	;otherwise ask for dome
	ld hl, Lab2TextFossileDome
	call PrintText
	call ManualTextScroll
	jr .askForBuyingFossile
.displayHelixText
	ld hl, Lab2TextFossileHelix
	call PrintText
	jr .askForBuyingFossile
.askForBuyingFossile
	;prompt a yes/no choice
	call YesNoChoice
	;load the player choice
	ld a, [wCurrentMenuItem]
	;check the player choice
	and a
	jr nz, .textNo	;if no, jump
	;otherwise charge 10000 money
	ld [hMoney], a	
	ld [hMoney + 2], a
	ld a, $A0
	ld [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	; not enough money
	ld hl, MoveRelearnerNotEnoughMoneyText
	ld hl, Lab2TextFossileNoMoney
	call PrintText
	jr .textEnd
.textNo
	ld hl, Lab2TextFossileNo
	call PrintText
	jr .textEnd
.enoughMoney
	CheckEvent EVENT_GOT_DOME_FOSSIL
	;if player choose dome give helix
	jr nz, .giveHelix
	;otherwise give dome
	lb bc, DOME_FOSSIL, 1
	call GiveItem
	jr nc, .bagFull
	SetEvent EVENT_GOT_DOME_FOSSIL
	jr .takeMoneyAndThanks
.giveHelix
	lb bc, HELIX_FOSSIL, 1
	call GiveItem
	jr nc, .bagFull
	SetEvent EVENT_GOT_HELIX_FOSSIL
.takeMoneyAndThanks
	; Charge 10000 money
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a	
	ld a, $A0
	ld [wPriceTemp + 1], a	
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld hl, Lab2TextFossileYes
	call PrintText
	jr .textEnd
.bagFull
	ld hl, Lab2TextFossileBagFull
	call PrintText
	jr .textEnd
.textEnd
	jp TextScriptEnd

Lab2TextFossile:
	TX_FAR _Lab2TextFossile
	db "@"
Lab2TextFossile2:
	TX_FAR _Lab2TextFossile2
	db "@"
Lab2TextFossileChampion:
	TX_FAR _Lab2TextFossileChampion
	db "@"
Lab2TextFossileDome:
	TX_FAR _Lab2TextFossileDome
	db "@"
Lab2TextFossileHelix:
	TX_FAR _Lab2TextFossileHelix
	db "@"
Lab2TextFossileYes:
	TX_FAR _Lab2TextFossileYes
	db "@"
Lab2TextFossileNo:
	TX_FAR _Lab2TextFossileNo
	db "@"
Lab2TextFossileNoMoney:
	TX_FAR _Lab2TextFossileNoMoney
	db "@"
Lab2TextFossileBagFull:
	TX_FAR _Lab2TextFossileBagFull
	db "@"

Lab2Text2:
	TX_ASM
	ld a, $7
	ld [wWhichTrade], a
	jr Lab2DoTrade

Lab2Text3:
	TX_ASM
	ld a, $8
	ld [wWhichTrade], a
Lab2DoTrade:
	predef DoInGameTradeDialogue
	jp TextScriptEnd

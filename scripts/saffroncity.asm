SaffronCityScript:
	jp EnableAutoTextBoxDrawing

SaffronCityTextPointers:
	dw SaffronCityText_NPCRocket1
	dw SaffronCityText_NPCRocket2
	dw SaffronCityText_NPCRocket3
	dw SaffronCityText_NPCRocket4
	dw SaffronCityText_NPCRocket5
	dw SaffronCityText_NPCRocket6
	dw SaffronCityText_NPCRocket7
	dw SaffronCityText_NPCRocketCongrat
	dw SaffronCityText_NPCRocketGone
	dw SaffronCityText_NPCPeopleComeBack
	dw SaffronCityText_BirdGuy
	dw SaffronCityText_Bird
	dw SaffronCityText_GiovanniFlee
	dw SaffronCityText_RocketGuard
	dw SaffronCityText_RocketGuardSleep
	dw SaffronCityText_Town
	dw SaffronCityText_Dojo
	dw SaffronCityText_Gym
	dw MartSignText
	dw SaffronCityText_TipTotalHeal
	dw SaffronCityText_TipCatch
	dw SaffronCityText_SylphSarl
	dw PokeCenterSignText
	dw SaffronCityText_MrPsyHouse
	dw SaffronCityText_SylphPromo

SaffronCityText_NPCRocket1:
	TX_FAR _SaffronCityText_NPCRocket1
	db "@"

SaffronCityText_NPCRocket2:
	TX_FAR _SaffronCityText_NPCRocket2
	db "@"

SaffronCityText_NPCRocket3:
	TX_FAR _SaffronCityText_NPCRocket3
	db "@"

SaffronCityText_NPCRocket4:
	TX_FAR _SaffronCityText_NPCRocket4
	db "@"

SaffronCityText_NPCRocket5:
	TX_FAR _SaffronCityText_NPCRocket5
	db "@"

SaffronCityText_NPCRocket6:
	TX_FAR _SaffronCityText_NPCRocket6
	db "@"

SaffronCityText_NPCRocket7:
	TX_FAR _SaffronCityText_NPCRocket7
	db "@"

SaffronCityText_NPCRocketCongrat:
	TX_FAR _SaffronCityText_NPCRocketCongrat
	db "@"

SaffronCityText_NPCRocketGone:
	TX_FAR _SaffronCityText_NPCRocketGone
	db "@"

SaffronCityText_NPCPeopleComeBack:
	TX_FAR _SaffronCityText_NPCPeopleComeBack
	db "@"

SaffronCityText_BirdGuy:
	TX_FAR _SaffronCityText_BirdGuy
	db "@"

SaffronCityText_Bird:
	TX_FAR _SaffronCityText_Bird
	TX_ASM
	ld a, PIDGEOT
	call DisplayPokedex
	jp TextScriptEnd

SaffronCityText_GiovanniFlee:
	TX_FAR _SaffronCityText_GiovanniFlee
	db "@"

SaffronCityText_RocketGuard:
	TX_FAR _SaffronCityText_RocketGuard
	db "@"

SaffronCityText_RocketGuardSleep:
	TX_FAR _SaffronCityText_RocketGuardSleep
	db "@"

SaffronCityText_Town:
	TX_FAR _SaffronCityText_Town
	db "@"

SaffronCityText_Dojo:
	TX_FAR _SaffronCityText_Dojo
	db "@"

SaffronCityText_Gym:
	TX_FAR _SaffronCityText_Gym
	db "@"

SaffronCityText_TipTotalHeal:
	TX_FAR _SaffronCityText_TipTotalHeal
	db "@"

SaffronCityText_TipCatch:
	TX_FAR _SaffronCityText_TipCatch
	db "@"

SaffronCityText_SylphSarl:
	TX_FAR _SaffronCityText_SylphSarl
	db "@"

SaffronCityText_MrPsyHouse:
	TX_FAR _SaffronCityText_MrPsyHouse
	db "@"

SaffronCityText_SylphPromo:
	TX_FAR _SaffronCityText_SylphPromo
	db "@"

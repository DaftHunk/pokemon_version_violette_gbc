Volcano1FScript:
	call EnableAutoTextBoxDrawing
	ld a, [wVolcanoCurScript]
	ld hl, Volcano1FScriptPointers
	jp CallFunctionInTable

Volcano1FScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw Volcano1FScript_Main

Volcano1FScript_Main:
	ret

Volcano1FTextPointers:
    dw Volcano1FText_1

Volcano1FText_1:
	db "@"	

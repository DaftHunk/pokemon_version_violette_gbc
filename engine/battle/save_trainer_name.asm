SaveTrainerName:
	ld hl, TrainerNamePointers
	ld a, [wTrainerClass]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wcd6d
.CopyCharacter
	ld a, [hli]
	ld [de], a
	inc de
	cp "@"
	jr nz, .CopyCharacter
	ret

TrainerNamePointers:
; what is the point of these?
	dw YoungsterName
	dw BugCatcherName
	dw LassName
	dw wTrainerName
	dw JrTrainerMName
	dw JrTrainerFName
	dw PokemaniacName
	dw SuperNerdName
	dw wTrainerName
	dw wTrainerName
	dw BurglarName
	dw EngineerName
	dw JugglerXName
	dw wTrainerName
	dw SwimmerName
	dw wTrainerName
	dw wTrainerName
	dw BeautyName
	dw wTrainerName
	dw RockerName
	dw JugglerName
	dw wTrainerName
	dw wTrainerName
	dw BlackbeltName
	dw wTrainerName
	dw ProfOakName
	dw ChiefName
	dw ScientistName
	dw wTrainerName
	dw RocketName
	dw CooltrainerMName
	dw CooltrainerFName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw wTrainerName
	dw JanineName
	dw JennyName
	dw JoyName
	dw JessieJamesName
	dw MFujiName
	dw SachaName

YoungsterName:
	db "Gamin@"
BugCatcherName:
	db "Scout@"
LassName:
	db "Fillette@"
JrTrainerMName:
	db "Dresseur jr♂@"
JrTrainerFName:
	db "Dresseur jr♀@"
PokemaniacName:
	db "#Maniac@"
SuperNerdName:
	db "Intéllo@"
BurglarName:
	db "Pillard@"
EngineerName:
	db "Mécano@"
JugglerXName:
	db "Jongleur@"
SwimmerName:
	db "Nageur@"
BeautyName:
	db "Canon@"
RockerName:
	db "Rocker@"
JugglerName:
	db "Jongleur@"
BlackbeltName:
	db "Karatéka@"
ProfOakName:
	db "Prof.Chen@"
ChiefName:
	db "Chef@"
ScientistName:
	db "Scientifique@"
RocketName:
	db "Rocket@"
CooltrainerMName:
	db "TopDresseur♂@"
CooltrainerFName:
	db "TopDresseur♀@"
JanineName:
	db "Janine@"
JennyName:
	db "Agent Jenny@"
JoyName:
	db "Inf. Joelle@"
JessieJamesName:
	db "Jessie James@"
MFujiName:
	db "M.Fuji@"
SachaName:
	db "Sacha@"
ViridianSchoolScript:
	jp EnableAutoTextBoxDrawing

ViridianSchoolTextPointers:
	dw ViridianSchoolText1
	dw ViridianSchoolText2
	dw ViridianSchoolText3 ;joenote - added more text

ViridianSchoolText1:
	TX_FAR _ViridianSchoolText1
	db "@"

ViridianSchoolText2:
	TX_FAR _ViridianSchoolText2
	db "@"

ViridianSchoolText3:
	TX_FAR _ViridianSchoolText3
	db "@"
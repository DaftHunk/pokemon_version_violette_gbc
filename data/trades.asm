TradeMons:
; givemonster, getmonster, textstring, nickname (11 bytes), 14 bytes total
IF DEF(_ENCBLUEJP)
	db RHYDON,		KANGASKHAN,	0, "RODAN@@@@@@"
	db JIGGLYPUFF,	MR_MIME,   	0, "MASARU@@@@@"
	db BUTTERFREE,	BEEDRILL,  	2, "CHIKUCHIKU@";japanese onomatopoeia for a needle-like type of prickling pain
	db GROWLITHE,	KRABBY,     0, "DORAKU@@@@@";reference to the Kani Dōraku japanese restaraunt chain
	db PIDGEY,		FARFETCHD, 	2, "AKKA@@@@@@@"
	db PERSIAN,		TAUROS, 	0, "GYUTA@@@@@@"
	db MACHOKE,		HAUNTER,	1, "GHOSUKE@@@@"
	db KADABRA,		GRAVELER,	1, "SABURO@@@@@"
	db SEEL,		SLOWPOKE,	2, "OSCAR@@@@@@"
	db RATTATA,		POLIWAG,	2, "POLI-TAN@@@"
;unused localization names for blue-jp trades per 
;https://tcrf.net/Development:Pok%C3%A9mon_Red_and_Blue/Localization#Pok%C3%A9mon_Nicknames
;	FLUFFY
;	MYMO
;	<beedrill has no localized name>
;	VALERIE
;	SWANNY
;	JIMBO
;	MICHELLE
;	JENNY
;	SHANE
;	WAGSTER
ELIF DEF(_ENCBLUEGREEN)
	db NIDORINO,  NIDORINA, 0,"BIBICHE@@@@"
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@"
	db BUTTERFREE,BEEDRILL, 2,"CHIKUCHIKU@"
	db PONYTA,    SEEL,     0,"BIBI@@@@@@@"
	db SPEAROW,   FARFETCHD,2,"JULIO@@@@@@"
	db SLOWBRO,   LICKITUNG,0,"GLAVIOTEUR@"
	db POLIWHIRL, JYNX,     1,"NINI@@@@@@@"
	db RAICHU,    ELECTRODE,1,"KOURJUS@@@@"
	db VENONAT,   TANGELA,  2,"BIGOUDI@@@@"
;	db NIDORAN_M, NIDORAN_F,2,"FABI@@@@@@@"	;joenote - this was probably accidentally swapped by the localization team
	db NIDORAN_F, NIDORAN_M,2,"FABI@@@@@@@"

ELIF DEF(_ENCRED)	;joenote - swap the sexes of the Nidos for red version and alter the beedrill trade
	db NIDORINA,  NIDORINO, 0,"BIBICHE@@@@"
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@"
	db BEEDRILL, BUTTERFREE,2,"CHIKUCHIKU@"
	db PONYTA,    SEEL,     0,"BIBI@@@@@@@"
	db SPEAROW,   FARFETCHD,2,"JULIO@@@@@@"
	db SLOWBRO,   LICKITUNG,0,"GLAVIOTEUR@"
	db POLIWHIRL, JYNX,     1,"NINI@@@@@@@"
	db RAICHU,    ELECTRODE,1,"KOURJUS@@@@"
	db VENONAT,   TANGELA,  2,"BIGOUDI@@@@"
	db NIDORAN_M, NIDORAN_F,2,"FABI@@@@@@@"


ELSE ;default to use if there is a compiler tag issue
	db NIDORINO,  NIDORINA, 0,"BIBICHE@@@@"
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@"
	db BUTTERFREE,BEEDRILL, 2,"CHIKUCHIKU@"
	db PONYTA,    SEEL,     0,"BIBI@@@@@@@"
	db SPEAROW,   FARFETCHD,2,"JULIO@@@@@@"
	db SLOWBRO,   LICKITUNG,0,"GLAVIOTEUR@"
	db POLIWHIRL, JYNX,     1,"NINI@@@@@@@"
	db RAICHU,    ELECTRODE,1,"KOURJUS@@@@"
	db VENONAT,   TANGELA,  2,"BIGOUDI@@@@"
	db NIDORAN_M, NIDORAN_F,2,"FABI@@@@@@@"
ENDC
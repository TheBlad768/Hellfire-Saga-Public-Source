; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_OptionsText:	dc.w	SME_Temp_10-Map_OptionsText
			dc.w	SME_Temp_1E-Map_OptionsText
			dc.w	SME_Temp_2C-Map_OptionsText
			dc.w	SME_Temp_3A-Map_OptionsText

Map_OptionsText2:	dc.w	SME_Temp_48-Map_OptionsText2
			dc.w	SME_Temp_50-Map_OptionsText2

Map_OptionsText3:	dc.w	SME_Temp_58-Map_OptionsText3
			dc.w	SME_Temp_60-Map_OptionsText3

SME_Temp_10:
		dc.b 0, 2
		dc.b $F0, $E, 0, 0, $FF, $F8
		dc.b $F0, $A, 0, $C, 0, $18

SME_Temp_1E:	dc.b 0, 2
		dc.b $F0, $E, 0, $15, $FF, $EF
		dc.b $F0, $E, 0, $21, 0, $F

SME_Temp_2C:	dc.b 0, 2
		dc.b $F0, $E, 0, $2D, 0, 6
		dc.b $F0, 2, 0, $39, 0, $26

SME_Temp_3A:	dc.b 0, 2
		dc.b $F0, $E, 0, $3C, $FF, $F0
		dc.b $F0, $E, 0, $48, 0, $10

SME_Temp_48:	dc.b 0, 1
		dc.b $F0, $A, 0, $54, $FF, $F0

SME_Temp_50:	dc.b 0, 1
		dc.b $F0, $E, 0, $5D, $FF, $E9

SME_Temp_58:	dc.b 0, 1
		dc.b $F0, $A, 0, $15, $FF, $F0

SME_Temp_60:	dc.b 0, 1
		dc.b $F0, $E, 0, $69, $FF, $E9

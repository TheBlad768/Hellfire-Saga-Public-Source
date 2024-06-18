; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_CZ1ZP:	
		dc.w SME_CZ1ZP_A-SME_CZ1ZP, SME_CZ1ZP_1E-SME_CZ1ZP	
		dc.w SME_CZ1ZP_38-SME_CZ1ZP, SME_CZ1ZP_46-SME_CZ1ZP	
		dc.w SME_CZ1ZP_4E-SME_CZ1ZP	
SME_CZ1ZP_A:	dc.b 0, 3	
		dc.b $E3, 9, 0, $18, $FF, $F7	
		dc.b $F3, $D, 0, $1E, $FF, $EF	
		dc.b 3, 5, 0, $26, $FF, $FF	
SME_CZ1ZP_1E:	dc.b 0, 4	
		dc.b $E3, 9, 0, $2A, $FF, $F8	
		dc.b $F3, $D, 0, $30, $FF, $F0	
		dc.b 3, 5, 0, $38, 0, 0	
		dc.b $B, 0, 0, $3C, $FF, $F8	
SME_CZ1ZP_38:	dc.b 0, 2	
		dc.b $F9, 5, 0, $12, $FF, $FD	
		dc.b 3, 4, 0, $16, $FF, $FD	
SME_CZ1ZP_46:	dc.b 0, 1	
		dc.b $F3, $A, 0, 0, $FF, $F8	
SME_CZ1ZP_4E:	dc.b 0, 1	
		dc.b $F3, $A, 0, 9, $FF, $F8	
		even
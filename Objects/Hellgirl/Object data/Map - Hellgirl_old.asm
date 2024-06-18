; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_fMWF3:
		dc.w SME_fMWF3_C-SME_fMWF3, SME_fMWF3_2C-SME_fMWF3	
		dc.w SME_fMWF3_4C-SME_fMWF3, SME_fMWF3_72-SME_fMWF3	
		dc.w SME_fMWF3_98-SME_fMWF3, SME_fMWF3_A0-SME_fMWF3	
SME_fMWF3_C:	dc.b 0, 5	
		dc.b $E0, 8, 0, 0, $FF, $F8	
		dc.b $E8, 8, 0, 3, $FF, $F8	
		dc.b $F0, 8, 0, 6, $FF, $F8	
		dc.b $F8, 8, 0, 9, $FF, $F8	
		dc.b 0, 8, 0, $C, $FF, $F8	
SME_fMWF3_2C:	dc.b 0, 5	
		dc.b $E0, 8, 0, $F, $FF, $F8	
		dc.b $E8, 8, 0, $12, $FF, $F8	
		dc.b $F0, 8, 0, $15, $FF, $F8	
		dc.b $F8, 8, 0, $18, $FF, $F8	
		dc.b 0, 8, 0, $1B, $FF, $F8	
SME_fMWF3_4C:	dc.b 0, 6	
		dc.b $E0, $C, 0, $1E, $FF, $F0	
		dc.b $E8, $C, 0, $22, $FF, $F0	
		dc.b $F0, $C, 0, $26, $FF, $F0	
		dc.b $F8, $C, 0, $2A, $FF, $F0	
		dc.b 0, $C, 0, $2E, $FF, $F0	
		dc.b 8, $C, 0, $32, $FF, $F0	
SME_fMWF3_72:	dc.b 0, 6	
		dc.b $E0, $C, 0, $36, $FF, $F0	
		dc.b $E8, $C, 0, $3A, $FF, $F0	
		dc.b $F0, $C, 0, $3E, $FF, $F0	
		dc.b $F8, $C, 0, $42, $FF, $F0	
		dc.b 0, $C, 0, $46, $FF, $F0	
		dc.b 8, $C, 0, $4A, $FF, $F0	
SME_fMWF3_98:	dc.b 0, 1	
		dc.b $F0, 5, 0, $4E, $FF, $F8	
SME_fMWF3_A0:	dc.b 0, 3
		dc.b $F0, 0, 0, $52, $FF, $F8	
		dc.b $F8, 0, 0, $4F, $FF, $F8	
		dc.b $F0, 1, 0, $50, 0, 0	
		even
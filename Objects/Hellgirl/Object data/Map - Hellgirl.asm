; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_fMWF3:
		dc.w SME_fMWF3_E-SME_fMWF3, SME_fMWF3_22-SME_fMWF3	
		dc.w SME_fMWF3_5A-SME_fMWF3, SME_fMWF3_6E-SME_fMWF3	
		dc.w SME_fMWF3_88-SME_fMWF3, SME_fMWF3_90-SME_fMWF3	
		dc.w SME_fMWF3_A4-SME_fMWF3	
SME_fMWF3_E:	dc.b 0, 3	
		dc.b $E0, $B, 0, $16, $FF, $F8	
		dc.b 0, 8, 0, $22, $FF, $F8	
		dc.b 8, 4, 0, $25, $FF, $F8	
SME_fMWF3_22:	dc.b 0, 9	
		dc.b $E0, 0, 0, $16, $FF, $F8	
		dc.b $E0, 0, 0, $1A, 0, 0	
		dc.b $E0, 0, 0, $1E, 0, 8	
		dc.b $E8, 0, 0, $17, $FF, $F8	
		dc.b $E8, 0, 0, $1B, 0, 0	
		dc.b $E8, 0, 0, $1F, 0, 8	
		dc.b $F0, 9, 0, $27, $FF, $F8	
		dc.b 0, 8, 0, $22, $FF, $F8	
		dc.b 8, 4, 0, $25, $FF, $F8	
SME_fMWF3_5A:	dc.b 0, 3	
		dc.b $E0, $B, 0, 5, $FF, $F8	
		dc.b 0, 8, 0, $11, $FF, $F8	
		dc.b 8, 4, 0, $14, $FF, $F8	
SME_fMWF3_6E:	dc.b 0, 4	
		dc.b $E0, 2, 0, 5, $FF, $F8	
		dc.b $E0, 2, 0, 9, 0, 0	
		dc.b $E0, 2, 0, $D, 0, 8	
		dc.b $F8, $A, 0, $2D, $FF, $F8	
SME_fMWF3_88:	dc.b 0, 1	
		dc.b $F0, 5, 0, 0, $FF, $F8	
SME_fMWF3_90:	dc.b 0, 3	
		dc.b $F0, 0, 0, $39, $FF, $F8	
		dc.b $F8, 0, 0, $36, $FF, $F8	
		dc.b $F0, 1, 0, $37, 0, 0	
SME_fMWF3_A4:	dc.b 0, 3
		dc.b $F0, 0, 0, 4, $FF, $F8	
		dc.b $F8, 0, 0, 1, $FF, $F8	
		dc.b $F0, 1, 0, 2, 0, 0	
		even
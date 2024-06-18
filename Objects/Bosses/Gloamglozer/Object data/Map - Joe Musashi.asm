; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_zezPu:	
		dc.w SME_zezPu_A-SME_zezPu, SME_zezPu_24-SME_zezPu	
		dc.w SME_zezPu_32-SME_zezPu, SME_zezPu_4C-SME_zezPu	
		dc.w SME_zezPu_66-SME_zezPu	
SME_zezPu_A:	dc.b 0, 4	
		dc.b $D4, $F, 0, 0, $FF, $F0	
		dc.b $D4, $F, 0, $10, 0, $10	
		dc.b $F4, $E, 0, $20, $FF, $F0	
		dc.b $F4, $E, 0, $2C, 0, $10	
SME_zezPu_24:	dc.b 0, 2	
		dc.b $D4, $F, 0, $38, 0, 0	
		dc.b $F4, $E, 0, $48, 0, 0	
SME_zezPu_32:	dc.b 0, 4	
		dc.b $D4, $F, 0, $54, $FF, $F0	
		dc.b $D4, $F, 0, $64, 0, $10	
		dc.b $F4, $E, 0, $74, $FF, $F0	
		dc.b $F4, $E, 0, $80, 0, $10	
SME_zezPu_4C:	dc.b 0, 4	
		dc.b $E4, $F, 0, $8C, $FF, $F0	
		dc.b $E4, $B, 0, $9C, 0, $10	
		dc.b 4, $C, 0, $A8, $FF, $F0	
		dc.b 4, 8, 0, $AC, 0, $10	
SME_zezPu_66:	dc.b 0, 0	
		even
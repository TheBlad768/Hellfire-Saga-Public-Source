; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_Pm5R3:
		dc.w SME_Pm5R3_A-SME_Pm5R3, SME_Pm5R3_18-SME_Pm5R3	
		dc.w SME_Pm5R3_26-SME_Pm5R3, SME_Pm5R3_34-SME_Pm5R3	
		dc.w SME_Pm5R3_48-SME_Pm5R3	
SME_Pm5R3_A:	dc.b 0, 2	
		dc.b $E4, $F, 0, 0, $FF, $F0	
		dc.b $E4, 3, 0, $10, 0, $10	
SME_Pm5R3_18:	dc.b 0, 2	
		dc.b $E4, $F, 0, $14, $FF, $F0	
		dc.b $E4, 3, 0, $24, 0, $10	
SME_Pm5R3_26:	dc.b 0, 2	
		dc.b $DC, $B, 0, $28, $FF, $F0	
		dc.b $FC, 8, 0, $34, $FF, $F0	
SME_Pm5R3_34:	dc.b 0, 3	
		dc.b $D4, $B, 0, $37, $FF, $F0	
		dc.b $F4, 8, 0, $43, $FF, $F0	
		dc.b $FC, 8, 0, $46, $FF, $F0	
SME_Pm5R3_48:	dc.b 0, 0
		even
; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_SAE0M:
		dc.w SME_SAE0M_4-SME_SAE0M, SME_SAE0M_C-SME_SAE0M	
SME_SAE0M_4:	dc.b 0, 1	
		dc.b $F4, $E, 0, $C, $FF, $F0	
SME_SAE0M_C:	dc.b 0, 1
		dc.b $F4, $E, 0, 0, $FF, $F0	
		even
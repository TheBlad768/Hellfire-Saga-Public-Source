; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_uvwMe:
		dc.w SME_uvwMe_8-SME_uvwMe, SME_uvwMe_16-SME_uvwMe	
		dc.w SME_uvwMe_36-SME_uvwMe, SME_uvwMe_3E-SME_uvwMe	
SME_uvwMe_8:	dc.b 0, 2	
		dc.b $F0, 4, 8, 0, $FF, $FC	
		dc.b $F8, $F, 8, 2, $FF, $F4	
SME_uvwMe_16:	dc.b 0, 5	
		dc.b $E8, 9, 0, $12, $FF, $FC	
		dc.b $F8, $B, 0, $18, $FF, $FC	
		dc.b $F8, 0, 0, $24, $FF, $F4	
		dc.b 0, 0, 0, $25, $FF, $F4	
		dc.b $F0, 0, 0, $26, $FF, $F4	
SME_uvwMe_36:	dc.b 0, 1	
		dc.b $F0, $F, 0, $27, $FF, $F4	
SME_uvwMe_3E:	dc.b 0, 2
		dc.b $F8, 1, 0, $37, $FF, $FA	
		dc.b $F8, 1, 0, $39, 0, 2	
		even
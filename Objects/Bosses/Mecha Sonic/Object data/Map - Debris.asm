; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_Debris:
		dc.w Map_Debris_E-Map_Debris, Map_Debris_16-Map_Debris	
		dc.w Map_Debris_1E-Map_Debris, Map_Debris_26-Map_Debris	
		dc.w Map_Debris_2E-Map_Debris, Map_Debris_36-Map_Debris	
		dc.w Map_Debris_3E-Map_Debris	
Map_Debris_E:	dc.b 0, 1	
		dc.b $E0, 0, 0, 0, $FF, $F8	
Map_Debris_16:	dc.b 0, 1	
		dc.b $EC, 3, 0, 1, $FF, $F8	
Map_Debris_1E:	dc.b 0, 1	
		dc.b $FC, 5, 0, 5, $FF, $F4	
Map_Debris_26:	dc.b 0, 1	
		dc.b $FC, 9, 0, 9, $FF, $F0	
Map_Debris_2E:	dc.b 0, 1	
		dc.b $E4, $B, 0, $F, $FF, $F0	
Map_Debris_36:	dc.b 0, 1	
		dc.b $E4, $B, 0, $1B, $FF, $F0	
Map_Debris_3E:	dc.b 0, 1
		dc.b $E4, $B, 0, $27, $FF, $F0	
		even
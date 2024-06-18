; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_MSkull:
		dc.w Map_MSkull_E-Map_MSkull, Map_MSkull_16-Map_MSkull	
		dc.w Map_MSkull_1E-Map_MSkull, Map_MSkull_26-Map_MSkull	
		dc.w Map_MSkull_2E-Map_MSkull, Map_MSkull_36-Map_MSkull	
		dc.w Map_MSkull_38-Map_MSkull	
Map_MSkull_E:	dc.b 0, 1	
		dc.b $E8, $A, 0, 0, $FF, $F0	
Map_MSkull_16:	dc.b 0, 1	
		dc.b $EC, 5, 0, 9, $FF, $F4	
Map_MSkull_1E:	dc.b 0, 1	
		dc.b $EC, 5, 8, 9, $FF, $F4	
Map_MSkull_26:	dc.b 0, 1	
		dc.b $EC, 5, $18, 9, $FF, $F4	
Map_MSkull_2E:	dc.b 0, 1	
		dc.b $EC, 5, $10, 9, $FF, $F4	
Map_MSkull_36:	dc.b 0, 0	
Map_MSkull_38:	dc.b 0, 1
		dc.b $EB, 0, 0, $D, $FF, $F8	
		even
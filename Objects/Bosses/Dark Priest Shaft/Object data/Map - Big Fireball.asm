; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_BigFireball:
		dc.w Map_BigFireball_A-Map_BigFireball, Map_BigFireball_1E-Map_BigFireball	
		dc.w Map_BigFireball_32-Map_BigFireball, Map_BigFireball_46-Map_BigFireball	
		dc.w Map_BigFireball_54-Map_BigFireball	
Map_BigFireball_A:	dc.b 0, 3	
		dc.b $E0, $D, 0, 0, $FF, $F8	
		dc.b $F0, $D, 0, 8, $FF, $F0	
		dc.b 0, 8, 0, $10, $FF, $F0	
Map_BigFireball_1E:	dc.b 0, 3	
		dc.b $E0, $D, 0, $13, $FF, $F8	
		dc.b $F0, $D, 0, $1B, $FF, $F0	
		dc.b 0, 8, 0, $23, $FF, $F0	
Map_BigFireball_32:	dc.b 0, 3	
		dc.b $E0, $D, 0, $26, $FF, $F8	
		dc.b $F0, $D, 0, $2E, $FF, $F0	
		dc.b 0, 8, 0, $36, $FF, $F0	
Map_BigFireball_46:	dc.b 0, 2	
		dc.b $F0, $E, 0, $39, $FF, $F0	
		dc.b $F0, 6, 0, $45, 0, $10	
Map_BigFireball_54:	dc.b 0, 2
		dc.b $F0, $E, 0, $4B, $FF, $F0	
		dc.b $F0, 6, 0, $57, 0, $10	
		even
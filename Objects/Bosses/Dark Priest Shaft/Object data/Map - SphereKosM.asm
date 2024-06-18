; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_Sphere:
		dc.w Map_Sphere_14-Map_Sphere, Map_Sphere_1C-Map_Sphere	
		dc.w Map_Sphere_24-Map_Sphere, Map_Sphere_2C-Map_Sphere	
		dc.w Map_Sphere_34-Map_Sphere, Map_Sphere_3C-Map_Sphere	
		dc.w Map_Sphere_4A-Map_Sphere, Map_Sphere_58-Map_Sphere	
		dc.w Map_Sphere_66-Map_Sphere, Map_Sphere_6E-Map_Sphere	
Map_Sphere_14:	dc.b 0, 1	
		dc.b 6, 5, 0, 1, $FF, $F3	
Map_Sphere_1C:	dc.b 0, 1	
		dc.b 1, $A, 0, 5, $FF, $F0	
Map_Sphere_24:	dc.b 0, 1	
		dc.b 1, $A, 0, $E, $FF, $F0	
Map_Sphere_2C:	dc.b 0, 1	
		dc.b 1, $A, 8, 5, $FF, $F0	
Map_Sphere_34:	dc.b 0, 1	
		dc.b 1, $A, 8, $E, $FF, $F0	
Map_Sphere_3C:	dc.b 0, 2	
		dc.b $F1, $B, 0, $17, $FF, $F0	
		dc.b $11, 8, 0, $23, $FF, $F0	
Map_Sphere_4A:	dc.b 0, 2	
		dc.b $F1, $B, 0, $26, $FF, $F0	
		dc.b $11, 8, 0, $32, $FF, $F0	
Map_Sphere_58:	dc.b 0, 2	
		dc.b $F1, $B, 0, $35, $FF, $EE	
		dc.b $11, 8, 0, $41, $FF, $EE	
Map_Sphere_66:	dc.b 0, 1	
		dc.b $F9, $F, 0, $44, $FF, $F0	
Map_Sphere_6E:	dc.b 0, 1
		dc.b $F9, $F, 0, $54, $FF, $F0	
		even
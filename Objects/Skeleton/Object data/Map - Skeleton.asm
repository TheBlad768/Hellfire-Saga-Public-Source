; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

Map_Skeleton:
		dc.w Map_Skeleton_A-Map_Skeleton, Map_Skeleton_1E-Map_Skeleton	
		dc.w Map_Skeleton_38-Map_Skeleton, Map_Skeleton_46-Map_Skeleton	
		dc.w Map_Skeleton_4E-Map_Skeleton	
Map_Skeleton_A:	dc.b 0, 3	
		dc.b $D3, 9, 0, 0, $FF, $F7	
		dc.b $E3, $D, 0, 6, $FF, $EF	
		dc.b $F3, 5, 0, $E, $FF, $FF	
Map_Skeleton_1E:	dc.b 0, 4	
		dc.b $D3, 9, 0, 0, $FF, $F8	
		dc.b $E3, $D, 0, 6, $FF, $F0	
		dc.b $F3, 5, 0, $E, 0, 0	
		dc.b $FB, 0, 0, $12, $FF, $F8	
Map_Skeleton_38:	dc.b 0, 2	
		dc.b $F1, 5, 0, 0, $FF, $FD	
		dc.b $FB, 4, 0, 4, $FF, $FD	
Map_Skeleton_46:	dc.b 0, 1	
		dc.b $EB, $A, 0, 0, $FF, $F8	
Map_Skeleton_4E:	dc.b 0, 1
		dc.b $EB, $A, 0, 0, $FF, $F8	
		even
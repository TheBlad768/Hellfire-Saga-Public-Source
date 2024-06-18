Map_Letterboxing:
		dc.w Map_Letterboxing_2-Map_Letterboxing	; 0
		dc.w Map_Letterboxing_2-Map_Letterboxing	; 1
Map_Letterboxing_2:
		dc.w 10
		dc.b $E0, $E, 0, 0, $FF, $80
		dc.b $E0, $E, 0, 0, $FF, $A0
		dc.b $E0, $E, 0, 0, $FF, $C0
		dc.b $E0, $E, 0, 0, $FF, $E0
		dc.b $E0, $E, 0, 0, 0, 0
		dc.b $E0, $E, 0, 0, 0, $20
		dc.b $E0, $E, 0, 0, 0, $40
		dc.b $E0, $E, 0, 0, 0, $60
		dc.b $E0, $E, 0, 0, 0, $80
		dc.b $E0, $E, 0, 0, 0, $A0
	even
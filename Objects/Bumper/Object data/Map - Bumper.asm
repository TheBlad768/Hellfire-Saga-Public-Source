Map_Bump:
Map_Bump_0: 	dc.w Map_Bump_4-Map_Bump
Map_Bump_2: 	dc.w Map_Bump_12-Map_Bump
Map_Bump_4: 	dc.b $0, $2
	dc.b $F0, $7, $60, $0, $FF, $F0
	dc.b $F0, $7, $68, $0, $0, $0
Map_Bump_12: 	dc.b $0, $2
	dc.b $F0, $7, $40, $8, $FF, $F0
	dc.b $F0, $7, $48, $8, $0, $0
	even
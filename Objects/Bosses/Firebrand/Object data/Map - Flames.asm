Map_Flames:
Map_Flames_0: 	dc.w Map_Flames_C-Map_Flames
Map_Flames_2: 	dc.w Map_Flames_E-Map_Flames
Map_Flames_4: 	dc.w Map_Flames_16-Map_Flames
Map_Flames_6: 	dc.w Map_Flames_1E-Map_Flames
Map_Flames_8: 	dc.w Map_Flames_26-Map_Flames
Map_Flames_A: 	dc.w Map_Flames_2E-Map_Flames
Map_Flames_C: 	dc.b $0, $0
Map_Flames_E: 	dc.b $0, $1
	dc.b $FC, $6, $60, $0, $FF, $F8
Map_Flames_16: 	dc.b $0, $1
	dc.b $FC, $6, $60, $6, $FF, $F8
Map_Flames_1E: 	dc.b $0, $1
	dc.b $FC, $6, $60, $C, $FF, $F8
Map_Flames_26: 	dc.b $0, $1
	dc.b $FC, $6, $60, $12, $FF, $F8
Map_Flames_2E: 	dc.b $0, $1
	dc.b $FC, $6, $60, $18, $FF, $F8
	even
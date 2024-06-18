SME_WmmBn:
SME_WmmBn_0: 	dc.w SME_WmmBn_A-SME_WmmBn
SME_WmmBn_2: 	dc.w SME_WmmBn_24-SME_WmmBn
SME_WmmBn_4: 	dc.w SME_WmmBn_3E-SME_WmmBn
SME_WmmBn_6: 	dc.w SME_WmmBn_58-SME_WmmBn
SME_WmmBn_8: 	dc.w SME_WmmBn_60-SME_WmmBn
SME_WmmBn_A: 	dc.b $0, $4
	dc.b $E0, $F, $0, $0, $FF, $E8
	dc.b $0, $C, $0, $10, $FF, $E8
	dc.b $E0, $3, $0, $14, $0, $8
	dc.b $0, $0, $0, $18, $0, $8
SME_WmmBn_24: 	dc.b $0, $4
	dc.b $E0, $F, $0, $1D, $FF, $E8
	dc.b $0, $C, $0, $2D, $FF, $E8
	dc.b $E0, $3, $0, $31, $0, $8
	dc.b $0, $0, $0, $35, $0, $8
SME_WmmBn_3E: 	dc.b $0, $4
	dc.b $E0, $F, $0, $36, $FF, $E8
	dc.b $0, $E, $0, $46, $FF, $E8
	dc.b $E0, $3, $0, $52, $0, $8
	dc.b $0, $2, $0, $56, $0, $8
SME_WmmBn_58: 	dc.b $0, $1
	dc.b $F0, $E, $0, $64, $FF, $E8
SME_WmmBn_60: 	dc.b $0, $6
	dc.b $E0, $0, $0, $58, $FF, $E8
	dc.b $E0, $0, $0, $59, $FF, $F0
	dc.b $E0, $0, $0, $5A, $FF, $F8
	dc.b $E8, $0, $0, $5B, $FF, $E8
	dc.b $E8, $4, $0, $5C, $FF, $F0
	dc.b $F0, $9, $0, $5E, $FF, $E8
	even
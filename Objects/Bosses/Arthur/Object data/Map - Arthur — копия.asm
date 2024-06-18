; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_ltp1p:	
		dc.w SME_ltp1p_16-SME_ltp1p, SME_ltp1p_30-SME_ltp1p	
		dc.w SME_ltp1p_4A-SME_ltp1p, SME_ltp1p_64-SME_ltp1p	
		dc.w SME_ltp1p_7E-SME_ltp1p, SME_ltp1p_98-SME_ltp1p	
		dc.w SME_ltp1p_B2-SME_ltp1p, SME_ltp1p_CC-SME_ltp1p	
		dc.w SME_ltp1p_E6-SME_ltp1p, SME_ltp1p_F4-SME_ltp1p	
		dc.w SME_ltp1p_10E-SME_ltp1p	
SME_ltp1p_16:	dc.b 0, 4	
		dc.b $E0, $F, 0, 0, $FF, $F0	
		dc.b $E0, 3, 0, $10, 0, $10	
		dc.b 0, $D, 0, $14, $FF, $F0	
		dc.b 0, 1, 0, $1C, 0, $10	
SME_ltp1p_30:	dc.b 0, 4	
		dc.b $E0, $F, 1, $2B, $FF, $F0	
		dc.b $E0, 3, 1, $3B, 0, $10	
		dc.b 0, $D, 1, $3F, $FF, $F0	
		dc.b 0, 1, 1, $47, 0, $10	
SME_ltp1p_4A:	dc.b 0, 4	
		dc.b $E0, $F, 1, $49, $FF, $E8	
		dc.b 0, $D, 1, $59, $FF, $E8	
		dc.b $E0, 7, 1, $61, 0, 8	
		dc.b 0, 5, 1, $69, 0, 8	
SME_ltp1p_64:	dc.b 0, 4	
		dc.b $E8, $F, 0, $1E, $FF, $E8	
		dc.b $E8, 7, 0, $2E, 0, 8	
		dc.b 8, $C, 0, $36, $FF, $E8	
		dc.b 8, 4, 0, $3A, 0, 8	
SME_ltp1p_7E:	dc.b 0, 4	
		dc.b $E0, $F, 0, $3C, $FF, $E0	
		dc.b $E0, $B, 0, $4C, 0, 0	
		dc.b 0, $C, 0, $58, $FF, $E0	
		dc.b 0, 8, 0, $5C, 0, 0	
SME_ltp1p_98:	dc.b 0, 4	
		dc.b $E0, $F, 0, $5F, $FF, $E0	
		dc.b 0, $D, 0, $6F, $FF, $E0	
		dc.b $E0, 7, 0, $77, 0, 0	
		dc.b 0, 5, 0, $7F, 0, 0	
SME_ltp1p_B2:	dc.b 0, 4	
		dc.b $E0, $F, 0, $83, $FF, $E0	
		dc.b 0, $D, 0, $93, $FF, $E0	
		dc.b $E0, 7, 0, $9B, 0, 0	
		dc.b 0, 5, 0, $A3, 0, 0	
SME_ltp1p_CC:	dc.b 0, 4	
		dc.b $E0, $F, 0, $A7, $FF, $E0	
		dc.b 0, $D, 0, $B7, $FF, $E0	
		dc.b $E0, 7, 0, $BF, 0, 0	
		dc.b 0, 5, 0, $C7, 0, 0	
SME_ltp1p_E6:	dc.b 0, 2	
		dc.b $E0, $F, 0, $CB, $FF, $E8	
		dc.b 0, $D, 0, $DB, $FF, $E8	
SME_ltp1p_F4:	dc.b 0, 4	
		dc.b $E0, $F, 0, $E3, $FF, $E0	
		dc.b 0, $D, 0, $F3, $FF, $E0	
		dc.b $E0, 7, 0, $FB, 0, 0	
		dc.b 0, 5, 1, 3, 0, 0	
SME_ltp1p_10E:	dc.b 0, 4	
		dc.b $E0, $F, 1, 7, $FF, $E0	
		dc.b 0, $D, 1, $17, $FF, $E0	
		dc.b $E0, 7, 1, $1F, 0, 0	
		dc.b 0, 5, 1, $27, 0, 0	
		even
; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_LaTNO:
		dc.w SME_LaTNO_E-SME_LaTNO, SME_LaTNO_2E-SME_LaTNO	
		dc.w SME_LaTNO_54-SME_LaTNO, SME_LaTNO_A4-SME_LaTNO	
		dc.w SME_LaTNO_D0-SME_LaTNO, SME_LaTNO_EA-SME_LaTNO	
		dc.w SME_LaTNO_F2-SME_LaTNO	
SME_LaTNO_E:	dc.b 0, 5	
		dc.b $F0, $E, 0, 0, $FF, $F0	
		dc.b $F8, 1, 0, $C, 0, $10	
		dc.b 0, 0, 0, $E, 0, $18	
		dc.b 8, $E, 0, $F, 0, 8	
		dc.b 8, $E, 0, $1B, $FF, $E8	
SME_LaTNO_2E:	dc.b 0, 6	
		dc.b $F0, $E, 0, $8D, $FF, $F0	
		dc.b $F8, 1, 0, $99, 0, $10	
		dc.b 0, 0, 0, $9B, 0, $18	
		dc.b 8, $E, 0, $9C, 0, 8	
		dc.b 8, $E, 0, $A8, $FF, $E8	
		dc.b 4, 0, 0, $1B, $FF, $E8	
SME_LaTNO_54:	dc.b 0, $D	
		dc.b $10, $D, 0, $27, $FF, $F8	
		dc.b $10, 5, 0, $2F, 0, $18	
		dc.b $18, 0, 0, $33, $FF, $F0	
		dc.b $F0, $E, 0, 0, $FF, $F0	
		dc.b $F8, 1, 0, $C, 0, $10	
		dc.b 0, 0, 0, $E, 0, $18	
		dc.b 8, 0, 0, $18, 0, $20	
		dc.b 8, 6, 0, $1B, $FF, $E8	
		dc.b 8, 0, 0, $21, $FF, $F8	
		dc.b 8, 0, 0, $24, 0, 0	
		dc.b 8, 0, 0, $15, 0, $18	
		dc.b 8, 0, 0, $12, 0, $10	
		dc.b 8, 0, 0, $F, 0, 8	
SME_LaTNO_A4:	dc.b 0, 7	
		dc.b $F0, $D, 0, $5C, $FF, $F0	
		dc.b $F0, 1, 0, $64, 0, $10	
		dc.b $F8, 4, 0, $5C, 0, $18	
		dc.b 0, $E, 0, $66, $FF, $E8	
		dc.b 0, $E, 0, $72, 0, 8	
		dc.b $18, $C, 0, $7E, $FF, $F0	
		dc.b $18, 8, 0, $82, 0, $10	
SME_LaTNO_D0:	dc.b 0, 4	
		dc.b $F8, $F, 0, $34, $FF, $E8	
		dc.b $F8, $F, 0, $44, 0, 8	
		dc.b $18, $C, 0, $54, $FF, $E8	
		dc.b $18, $C, 0, $58, 0, 8	
SME_LaTNO_EA:	dc.b 0, 1	
		dc.b $FD, 5, 0, $85, 0, 0	
SME_LaTNO_F2:	dc.b 0, 1
		dc.b $FD, 5, 0, $89, 0, 0	
		even
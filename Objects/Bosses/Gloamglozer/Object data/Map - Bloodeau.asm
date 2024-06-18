; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 3 & Knuckles format
; --------------------------------------------------------------------------------

SME_Wl_Mf:
		dc.w SME_Wl_Mf_10-SME_Wl_Mf, SME_Wl_Mf_2A-SME_Wl_Mf	
		dc.w SME_Wl_Mf_56-SME_Wl_Mf, SME_Wl_Mf_70-SME_Wl_Mf	
		dc.w SME_Wl_Mf_A2-SME_Wl_Mf, SME_Wl_Mf_AA-SME_Wl_Mf	
		dc.w SME_Wl_Mf_AC-SME_Wl_Mf, SME_Wl_Mf_CC-SME_Wl_Mf	
SME_Wl_Mf_10:	dc.b 0, 4	
		dc.b $E2, $D, 0, 0, $FF, $F0	
		dc.b $F2, $F, 0, 8, $FF, $E0	
		dc.b $F2, $F, 0, $18, 0, 0	
		dc.b $12, 5, 0, $28, $FF, $F8	
SME_Wl_Mf_2A:	dc.b 0, 7	
		dc.b $E2, $D, 0, $55, $FF, $EC	
		dc.b $F2, $F, 0, $5D, $FF, $DC	
		dc.b $F2, $F, 0, $6D, $FF, $FC	
		dc.b $F2, 2, 0, $2C, 0, $1C	
		dc.b $EA, 0, 8, $56, 0, $C	
		dc.b $12, 1, 0, $2A, 0, 0	
		dc.b $12, 0, 0, $28, $FF, $F8	
SME_Wl_Mf_56:	dc.b 0, 4	
		dc.b $E2, $D, 0, $7D, $FF, $F1	
		dc.b $F2, $F, 0, $85, $FF, $E1	
		dc.b $F2, $F, 0, $95, 0, 1	
		dc.b $12, 5, 0, $A5, $FF, $F9	
SME_Wl_Mf_70:	dc.b 0, 8	
		dc.b $CA, 7, 0, $30, $FF, $F0	
		dc.b $EA, 7, 0, $38, $FF, $F0	
		dc.b $A, 4, 0, $40, $FF, $F0	
		dc.b $12, 9, 0, $42, $FF, $E8	
		dc.b $CA, 7, 8, $30, 0, 0	
		dc.b $EA, 7, 8, $38, 0, 0	
		dc.b $A, 4, 8, $40, 0, 0	
		dc.b $12, 9, 8, $42, 0, 0	
SME_Wl_Mf_A2:	dc.b 0, 1	
		dc.b $FA, 5, 0, $48, $FF, $F8	
SME_Wl_Mf_AA:	dc.b 0, 0	
SME_Wl_Mf_AC:	dc.b 0, 5	
		dc.b $FA, 0, 0, $4C, 0, 0	
		dc.b 2, 0, 0, $4D, 0, 0	
		dc.b $A, 0, 0, $4E, 0, 0	
		dc.b 2, 0, 0, $4F, 0, 8	
		dc.b 2, 0, 0, $50, $FF, $F8	
SME_Wl_Mf_CC:	dc.b 0, 1
		dc.b $FF, 5, 0, $51, 0, 0	
		even
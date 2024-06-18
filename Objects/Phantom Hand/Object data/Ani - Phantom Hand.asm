Ani_PhHand:
		dc.w PhHand_Mov-Ani_PhHand
		dc.w PhHand_Att-Ani_PhHand
		dc.w PhHand_Att2-Ani_PhHand
PhHand_Mov:	dc.b 6, 0, 1, 2, $FF, 0
PhHand_Att:	dc.b 2, 3, 4, $FF, 0
PhHand_Att2:	dc.b 7, 5, 6, $FE, 1, 0
	even
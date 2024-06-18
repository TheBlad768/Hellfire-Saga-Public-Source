Ani_Centipede:
	dc.w NBodyStand-Ani_Centipede
	dc.w NBodyAngry-Ani_Centipede
	dc.w NLegsStand-Ani_Centipede
	dc.w NLegsMove-Ani_Centipede
	dc.w NLegsJump-Ani_Centipede
	dc.w NStone-Ani_Centipede
	dc.w NStoneWarning-Ani_Centipede
	dc.w NEnWave-Ani_Centipede
	dc.w NBodyAngry2-Ani_Centipede
NBodyStand: dc.b 0, 0, $FF, 0
NBodyAngry: dc.b 0, 1, $FF, 0
NLegsStand: dc.b 0, 2, $FF, 0
NLegsMove: dc.b 3, 2, 3, 2, 4, $FF, 0
NLegsJump: dc.b 8, 3, 5, $FE, 1
NStone: dc.b 0, 6, $FF, 0
NStoneWarning: dc.b 2, 7, 8, $FF, 0
NEnWave: dc.b 0, 9, $FF
NBodyAngry2: dc.b 8, 1, $FD, 0
	even
Ani_Eggman:
		dc.w EggWaitSonic-Ani_Eggman
		dc.w EggLaugh-Ani_Eggman
		dc.w EggCombatStand-Ani_Eggman
		dc.w EggCast-Ani_Eggman
		dc.w EggJump-Ani_Eggman
		dc.w EggHurt-Ani_Eggman
		dc.w EggReadyForFase2-Ani_Eggman
		dc.w EggFireball-Ani_Eggman
		dc.w EggStone-Ani_Eggman
		dc.w EggMiniFire-Ani_Eggman
		dc.w EggBomb-Ani_Eggman
		dc.w EggMonol1-Ani_Eggman
		dc.w EggMonol2-Ani_Eggman
		dc.w EggMonol3-Ani_Eggman
		dc.w EggMonol4-Ani_Eggman
		dc.w EggEnBa-Ani_Eggman

EggWaitSonic:		dc.b 0, 0, $FF, 0
EggLaugh:		dc.b 4, 1, 2, $FF, 0
EggCombatStand: 	dc.b 6, 3, 4, $FF, 0
EggCast:		dc.b 6, 5, 6, $FF
EggJump:		dc.b 0, 7, $FF, 0
EggHurt:		dc.b 0, 8, $FF, 0
EggReadyForFase2:  	dc.b 3, 8, 9, $FE, 1
EggFireball:  	        dc.b 4, $A, $B, $FF, 0
EggStone:  	        dc.b 3, $C, $D, $C, $E, $FF
EggMiniFire:  	        dc.b 3, $F, $10, $11, $12, $FF
EggBomb:  	        dc.b 0, $13, $FF, 0
EggMonol1:		dc.b $78, $14, $FD, $C
EggMonol2:		dc.b $78, $15, $FD, $D
EggMonol3:		dc.b $78, $16, $FD, $E, 0
EggMonol4:		dc.b 6, $17, $18, $FF, 0
EggEnBa:		dc.b 2, $19, $18, $FF
	even
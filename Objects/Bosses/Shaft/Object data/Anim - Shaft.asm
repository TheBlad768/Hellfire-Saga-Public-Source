Ani_Shaft:
		dc.w Ani_Shaft_Stand-Ani_Shaft
		dc.w Ani_Shaft_Start-Ani_Shaft
		dc.w Ani_Shaft_Wait-Ani_Shaft
Ani_Shaft_Stand:	dc.b $F, 0, $FF
Ani_Shaft_Start:	dc.b	6, 1, 2, 3, 4, 5, 6, 7, 8, 9, $A, $FE, 3
Ani_Shaft_Wait:	dc.b $F, 0, $FF
	even
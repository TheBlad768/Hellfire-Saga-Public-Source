Ani_Crow:
		dc.w Ani_Crow_Wait-Ani_Crow
		dc.w Ani_Crow_Fly-Ani_Crow
		dc.w Ani_Crow_FlyWait-Ani_Crow
		dc.w Ani_Crow_Fly2-Ani_Crow
Ani_Crow_Wait:		dc.b 0, $3C, 1, $C, 0, $37, 2, $78, 0, $1E, 1, $A, 0, $C, 1, $A, 0, $3C, 2, $78		; $A2, $A3, $A2, $A4, $A2, $A3, $A2, $A3, $A2, $A4
					dc.b $FF
Ani_Crow_Fly:		dc.b 3, 8, 4, 8, 6, 8, 5, 8, $FF
Ani_Crow_FlyWait:	dc.b 2, 6, 3, 6, $FF
Ani_Crow_Fly2:		dc.b 3, 3, 4, 3, 6, 3, 5, 3, $FF
	even
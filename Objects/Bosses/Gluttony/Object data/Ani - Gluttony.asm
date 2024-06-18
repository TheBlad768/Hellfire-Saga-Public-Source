Ani_Gluttony:
		dc.w Glut_Run-Ani_Gluttony
		dc.w Glut_Spew-Ani_Gluttony
		dc.w Glut_Vomit-Ani_Gluttony
		dc.w Glut_Stay-Ani_Gluttony
Glut_Run:		dc.b 4, 0, 1, 2, 1, $FF
Glut_Spew:		dc.b 5, 3, 4, $FE, 1
Glut_Vomit:		dc.b 1, 5, 6, $FF, 0
Glut_Stay:		dc.b 0, 1, $FF, 0
	even
Ani_Honey:
		dc.w Honey_Idle-Ani_Honey
		dc.w Honey_Intro-Ani_Honey
		dc.w Honey_Fly-Ani_Honey
		dc.w Honey_Warning-Ani_Honey
		dc.w Honey_Arrows1-Ani_Honey
		dc.w Honey_Arrows2-Ani_Honey
		dc.w Honey_Arrows3-Ani_Honey
		dc.w Honey_Bomb1-Ani_Honey
Honey_Idle:	dc.b 0, 0, $FF, 0
Honey_Intro:	dc.b 8, 0, 1, 2, $FE, 1
Honey_Fly: 	dc.b 0, 3, $FF, 0
Honey_Warning:	dc.b 0, 7, $FF, 0
Honey_Arrows1:	dc.b 0, 6, $FF, 0
Honey_Arrows2:	dc.b 0, 5, $FF, 0
Honey_Arrows3:	dc.b 0, 4, $FF, 0
Honey_Bomb1:	dc.b 4, 8, 9, $A, 9, $FF
	even
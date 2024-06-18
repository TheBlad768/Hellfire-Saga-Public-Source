Ani_Bat:
		dc.w Ani_Bat_Fly-Ani_Bat
		dc.w Ani_Bat_Wait-Ani_Bat
Ani_Bat_Fly:		dc.b 1, 8, 0, 8, 2, 8, 4, 6, 5, 4, 3, 6, $FF, 0		; $128, $127, $129, $12E, $12F, $12A
Ani_Bat_Wait:	dc.b 6, $F, $FF, 0
	even
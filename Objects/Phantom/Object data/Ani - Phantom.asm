Ani_Phantom:
		dc.w byte_Hideo-Ani_Phantom
		dc.w byte_Appear-Ani_Phantom
		dc.w byte_Walk-Ani_Phantom
		dc.w byte_Disappear-Ani_Phantom
		dc.w byte_Disappear2-Ani_Phantom

byte_Hideo:             dc.b 0, 0, $FF, 0
byte_Appear:	        dc.b 4, 0, 1, 0, 2, $FD, 2
byte_Walk:	        dc.b 6, 4, 5, 3, $FF
byte_Disappear:	        dc.b 2, 0, 3, 0, 2, 0, 1, 0, $FD, 4
byte_Disappear2:	dc.b 0, 0, $FF, 0
	even
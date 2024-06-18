Ani_EvilEye:
		dc.w EvilEyeFly-Ani_EvilEye		; 0
		dc.w EvilEyeTurn-Ani_EvilEye		; 1
		dc.w EvilEyeTurnBack-Ani_EvilEye		; 2
		dc.w EvilEyeThunder1-Ani_EvilEye		; 3
		dc.w EvilEyeThunder2-Ani_EvilEye		; 4
		dc.w EvilEyeStone-Ani_EvilEye		; 5
		dc.w EvilEyeStoneFlash-Ani_EvilEye		; 5

EvilEyeFly:		dc.b 0, 0, $FF
EvilEyeTurn:		dc.b 8, 1, 8, 9, 8, 2, 2, $FE, 1
EvilEyeTurnBack:	dc.b 6, 1, $FD, 0
EvilEyeThunder1:	dc.b 9, 3, 6, 4, 6, 5, 6, $FF
EvilEyeThunder2:	dc.b 3, 3, 4, 5, $FF, 0
EvilEyeStone:		dc.b 0, 7, $FF, 0
EvilEyeStoneFlash:	dc.b 3, 7, 6, $FF
	even
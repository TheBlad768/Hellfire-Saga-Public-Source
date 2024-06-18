Ani_Heartless:
		dc.w byte_HeartlessIdle-Ani_Heartless
		dc.w byte_HeartlessSpringJump-Ani_Heartless
		dc.w byte_HeartlessFireDash-Ani_Heartless
		dc.w byte_HeartlessSpinRoll-Ani_Heartless
		dc.w byte_HeartlessFold-Ani_Heartless
		dc.w byte_HeartlessUnfoldOnEarth-Ani_Heartless
		dc.w byte_HeartlessUnfoldInAir-Ani_Heartless
		dc.w byte_HeartlessFloatUp-Ani_Heartless
		dc.w byte_HeartlessFireDashPrepare-Ani_Heartless
		dc.w byte_HeartlessRipHeartInAir-Ani_Heartless
		dc.w byte_HeartlessMegamixFall-Ani_Heartless
		dc.w byte_HeartlessFoldFire-Ani_Heartless
byte_HeartlessIdle:		dc.b 0, 0, $FF, 0
byte_HeartlessSpringJump:	dc.b 5, 3, 2, 1, $FE, 1, 0
byte_HeartlessFireDash:   	dc.b 1, $B, $E, $F, $FF, 0
byte_HeartlessSpinRoll:   	dc.b 1, 4, 5, 4, 6, 4, 7, 4, 8, $FF
byte_HeartlessFold:             dc.b 2, 2, 3, $FD, 3, 0
byte_HeartlessUnfoldOnEarth:    dc.b 2, $A, $D, $FD, 0, 0
byte_HeartlessUnfoldInAir:      dc.b 3, 3, 2, $FD, $A, 0
byte_HeartlessFloatUp:		dc.b 0, 1, $FF, 0
byte_HeartlessFireDashPrepare:  dc.b 2, 5, $E, 6, $F, 4, $FF, 0
byte_HeartlessRipHeartInAir:    dc.b 2, 3, 2, 2, 3, $FD, 3, 0
byte_HeartlessMegamixFall:      dc.b 0, $C, $FF, 0
byte_HeartlessFoldFire:         dc.b 2, 2, 3, $FD, 2, 0
	even
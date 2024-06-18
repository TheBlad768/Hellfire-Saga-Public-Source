Ani_Firebrand:
		dc.w FireIdle-Ani_Firebrand
		dc.w FireFly-Ani_Firebrand
		dc.w FireAttack-Ani_Firebrand
		dc.w FlameIdle-Ani_Firebrand
		dc.w FlameWarning-Ani_Firebrand
FireIdle:	dc.b 4, 0, 1, 2, 3, $FF
FireFly:	dc.b 4, 4, 5, 6, 7, 8, 9, $FF
FireAttack:	dc.b 3, $A, $B, $C, $FD, 0
FlameIdle:	dc.b 2, 1, 2, 3, 4, 5, $FF
FlameWarning:	dc.b 0, 0, $FF, 0
	even
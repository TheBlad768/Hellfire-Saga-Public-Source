Ani_Death:
		dc.w Idle-Ani_Death
		dc.w StepMake-Ani_Death
		dc.w Dead-Ani_Death
		dc.w Attack1-Ani_Death
		dc.w Attack2-Ani_Death
		dc.w Attack3-Ani_Death
		dc.w Attack4-Ani_Death
		dc.w Attack5-Ani_Death
		dc.w Jump-Ani_Death
		dc.w Spin-Ani_Death
		dc.w Throw-Ani_Death
Idle:			dc.b 0, 0, $FF, 0
StepMake:		dc.b 9, 0, 1, 0, 1, 0, $FD, 0
Dead:		        dc.b 0, 2, $FF, 0
Attack1:		dc.b 6, 3, $FD, 4
Attack2:		dc.b 6, 4, $FD, 5
Attack3:		dc.b 6, 5, $FD, 6
Attack4:		dc.b 6, 6, $FD, 7
Attack5:		dc.b 6, 7, 8, $FD, 0
Jump:   		dc.b 0, 9, $FF, 0
Spin:   		dc.b 2, $A, $B, $FF, 0
Throw:   		dc.b 4, 9, 9, $FD, 9, 0
		even
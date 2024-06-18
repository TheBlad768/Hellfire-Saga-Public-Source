Ani_Death:
		dc.w Cast1-Ani_Death
		dc.w Cast2-Ani_Death
		dc.w FlyWithScythe-Ani_Death
		dc.w AttackWithScythe-Ani_Death
		dc.w DeathDefeated-Ani_Death
		dc.w Idle-Ani_Death
		dc.w Cast3-Ani_Death
		dc.w AttackWithScythe2-Ani_Death
		dc.w FlyWithScythe2-Ani_Death
Cast1:			dc.b 8, 0, 1, $FD, 1
Cast2:			dc.b 4, 2, 3, $FF, 0
FlyWithScythe:		dc.b 4, 4, 5, $FF, 0
AttackWithScythe:  	dc.b 3, 6, 6, $FD, 7
DeathDefeated:		dc.b 9, 7, 8, $FE, 1
Idle:			dc.b 0, 0, 0, $FF, 0
Cast3:			dc.b 8, 1, $FD, 1
AttackWithScythe2:  	dc.b 3, 6, 6, $FF, 0
FlyWithScythe2:		dc.b 4, 4, 5, $FF, 0
		even
Ani_DeathScythe:
		dc.w FlyAround-Ani_DeathScythe
		dc.w Spinning-Ani_DeathScythe
		dc.w Stuck-Ani_DeathScythe
		dc.w AimFlash-Ani_DeathScythe
		dc.w Skull1-Ani_DeathScythe
		dc.w Skull2-Ani_DeathScythe
		dc.w Falx-Ani_DeathScythe
		dc.w Exclam-Ani_DeathScythe
FlyAround:	dc.b 3, 6, 0, 1, 2, 3, $FE, 4
Spinning:	dc.b 1, 4, 5, 6, 7, 8, 9, $A, $B, $FF, 0
Stuck:		dc.b 0, 7, $FF, 0
AimFlash:	dc.b 4, $C, $D, $FF, 0
Skull1:		dc.b 5, $E, $F, $10, $11, $12, $13, $FD, 5
Skull2:		dc.b 6, $14, $15, $FE, 1
Falx:		dc.b 2, $16, $17, $18, $19, $FF, 0
Exclam:		dc.b 0, $1A, $FF, 0
		even
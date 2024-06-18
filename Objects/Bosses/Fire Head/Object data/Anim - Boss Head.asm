Ani_BossFireHead:
		dc.w .BossFireHead_Intro-Ani_BossFireHead
		dc.w .BossFireHead_Start-Ani_BossFireHead
		dc.w .BossFireHead_Attack-Ani_BossFireHead
		dc.w .BossFireHead_AfterAttack-Ani_BossFireHead
		dc.w .BossFireHead_Defeated-Ani_BossFireHead
.BossFireHead_Intro:			dc.b 0, $F, $FF
.BossFireHead_Start:			dc.b 1, $F, $FF
.BossFireHead_Attack: 		dc.b 2, 7, 3, $F, $FE, 1
.BossFireHead_AfterAttack: 	dc.b 3, 7, 2, 3, 1, $F, $FE, 1
.BossFireHead_Defeated:		dc.b 4, $F, $FF
	even
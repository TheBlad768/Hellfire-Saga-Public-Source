Ani_GreatAxeLord_Axe:
		dc.w Ani_GreatAxeLord_Axe_Wait-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Walk-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Walk2-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Attack-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Attack2-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Jump-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Jump2-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Jump2-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Jump3-Ani_GreatAxeLord_Axe
		dc.w Ani_GreatAxeLord_Axe_Jump2-Ani_GreatAxeLord_Axe
Ani_GreatAxeLord_Axe_Wait:		dc.b $14, $F, $FF
Ani_GreatAxeLord_Axe_Walk:		dc.b $16, 4, $17, $10, $16, 4, $15, $C, $FE, 1		; $8CC(16), $8CF(17), $8CC(16), $8CB(15), $8CF(17), $8CB(15)
Ani_GreatAxeLord_Axe_Walk2:		dc.b $15, $F, $FF
Ani_GreatAxeLord_Axe_Attack:	dc.b $18, $B, $19, $B, $FE, 1
Ani_GreatAxeLord_Axe_Attack2:	dc.b $1A, $F, $FF
Ani_GreatAxeLord_Axe_Jump:		dc.b $1B, $17, $1C, $17, $FE, 1
Ani_GreatAxeLord_Axe_Jump2:	dc.b $1C, $B, $FF
Ani_GreatAxeLord_Axe_Jump3:	dc.b $18, $F, $FF
	even
Ani_RedGuardian:
		dc.w RedGuardian_Up-Ani_RedGuardian
		dc.w RedGuardian_Down-Ani_RedGuardian
		dc.w RedGuardian_Protect-Ani_RedGuardian
RedGuardian_Up:	dc.b 1, 1, 2, $FE, 1, 0
RedGuardian_Down:	dc.b 1, 1, 0, $FE, 1, 0
RedGuardian_Protect:	dc.b 0, 1, $FF, 0
	even
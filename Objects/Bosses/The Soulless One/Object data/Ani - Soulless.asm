Ani_Soulless:
		dc.w byte_Idle-Ani_Soulless
		dc.w byte_Flying-Ani_Soulless
		dc.w byte_CrouchSpin-Ani_Soulless
		dc.w byte_Uncrouch-Ani_Soulless
		dc.w byte_SpinDash-Ani_Soulless
		dc.w byte_Rolling-Ani_Soulless
		dc.w byte_Ring-Ani_Soulless
                dc.w byte_FlyingForward-Ani_Soulless
                dc.w byte_FoldSpin-Ani_Soulless
                dc.w byte_CrouchJump-Ani_Soulless
byte_Idle:		dc.b 0, 0, $FF, 0
byte_Flying:		dc.b 5, $A, 1, $FE, 1, 0
byte_CrouchSpin:        dc.b 2, 2, 3, $FD, 4
byte_Uncrouch:          dc.b 2, 3, 2, $FD, 0
byte_SpinDash:		dc.b 1, $F, $10, $F, $11, $F, $12, $FF, 0
byte_Rolling:		dc.b 3, 4, 8, 5, 8, 6, 8, 7, 8, $FF, 0
byte_Ring:		dc.b 0, 9, $FF, 0
byte_FlyingForward:     dc.b 5, $A, 1, $B, $C, $FE, 1, 0
byte_FoldSpin:          dc.b 2, $D, $E, $FD, 5
byte_CrouchJump:        dc.b 2, 2, 3, $FD, 5
	even
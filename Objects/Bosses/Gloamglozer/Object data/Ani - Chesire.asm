Ani_ChesireFantom:
		dc.w ChesireIdle-Ani_ChesireFantom
		dc.w ChesireBallIdle-Ani_ChesireFantom
		dc.w ChesireFlash-Ani_ChesireFantom
		dc.w ChesireBallWarn-Ani_ChesireFantom
		dc.w ChesireBallDust-Ani_ChesireFantom
		dc.w ChesireLock-Ani_ChesireFantom
		dc.w ChesireBallHint-Ani_ChesireFantom
		dc.w ChesireChain-Ani_ChesireFantom
		dc.w ChesireChainFire-Ani_ChesireFantom
		dc.w ChesireBallStay-Ani_ChesireFantom
		dc.w ChesireBallHint_Safe-Ani_ChesireFantom

ChesireIdle:		dc.b 0, 0, $FF, 0
ChesireBallIdle:	dc.b 4, 1, 3, $FF
ChesireFlash:		dc.b 0, 5, $FF, 0
ChesireBallWarn:	dc.b 2, 4, 5, $FF
ChesireBallDust:	dc.b 2, 6, 7, 8, 5, $FE, 1, 0
ChesireLock:		dc.b 0, 9, $FF, 0
ChesireBallHint:	dc.b 2, 1, 2, $FF
ChesireBallHint_Safe:	dc.b $7F, 2, $FF
ChesireChain:		dc.b 0, $A, $FF, 0
ChesireChainFire:	dc.b 5, $B, $C, $FF
ChesireBallStay:	dc.b 0, 1, $FF, 0
		even

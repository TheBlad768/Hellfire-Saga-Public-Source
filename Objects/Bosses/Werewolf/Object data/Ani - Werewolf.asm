Ani_Werewolf:
	dc.w	WStand-Ani_Werewolf	;0
	dc.w	WWalk-Ani_Werewolf	;1
	dc.w	WJump-Ani_Werewolf	;2
	dc.w	MoveWallVerti-Ani_Werewolf ;3
	dc.w	MoveWallHoriz-Ani_Werewolf ;4
	dc.w	MoveWallVertiD-Ani_Werewolf ;5
	dc.w	WCutDown-Ani_Werewolf	;6
	dc.w	WFall-Ani_Werewolf	;7
	dc.w	WerWarn-Ani_Werewolf	;8
WStand:	dc.b 0, 0, $FF, 0
WWalk:	dc.b 4, 0, 1, $FF, 0
WJump:	dc.b 0, 2, 3, 4, 5, $FF
MoveWallVerti:	dc.b 5, 6, 7, $FF, 0
MoveWallHoriz:	dc.b 5, 8, 9, $FF, 0
MoveWallVertiD:	dc.b 5, $A, $B, $FF, 0
WCutDown: dc.b	4, $C, $D, $FE, 1
WFall:	dc.b 0, $E, $FF, 0
WerWarn:	dc.b 3, $F, $10, $FF
	even
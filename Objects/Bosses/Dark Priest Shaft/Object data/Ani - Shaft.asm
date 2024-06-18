Ani_DPShaft:
	dc.w ShaftStandig-Ani_DPShaft	;0
	dc.w ShaftJump-Ani_DPShaft	;1
	dc.w ShaftLandig-Ani_DPShaft	;2
	dc.w ShaftFly-Ani_DPShaft	;3
	dc.w SphereIdle-Ani_DPShaft	;4
	dc.w SphereFire-Ani_DPShaft	;5
	dc.w SphereThunder-Ani_DPShaft	;6
	dc.w ShaftCast-Ani_DPShaft	;7
	dc.w ShaftSCZ21-ANI_DPShaft	;8
	dc.w ShaftSCZ22-ANI_DPShaft	;9
	dc.w ShaftGhost-ANI_DPShaft	;A
	dc.w ShaftLaunch-Ani_DPShaft	;B
	dc.w ShaftPreparing-Ani_DPShaft	;C
	dc.w ShaftUncast-Ani_DPShaft	;D
	dc.w ShaftLaunch2-Ani_DPShaft	;E
	dc.w ShaftStepback-Ani_DPShaft	;F
	dc.w ShaftAngryStand-Ani_DPShaft	;10
	dc.w ShaftSpark-Ani_DPShaft	;11
	dc.w ShaftDeath-Ani_DPShaft	;12

ShaftStandig: dc.b 0, 0, $FF, 0
ShaftJump: dc.b 0, 5, $FF, 0
ShaftLandig: dc.b 4, 4, 3, 2, 1, $FD, 0
ShaftFly: dc.b 4, $C, $D, $E, $D, $FF, 0
SphereIdle: dc.b 4, 9, $A, $B, $C, $D, $C, $B, $A, $FF, 0
SphereFire: dc.b 4, $E, $F, $10, $11, $FF, 0
SphereThunder: dc.b 1, $12, $13, $14, $FF
ShaftCast: dc.b 5, 5, 6, 7, 8, 9, $A, $B, $FE, 1
ShaftSCZ21: dc.b 0, $16, $FF
ShaftSCZ22: dc.b 6, $16, $17, $18, $FE, 1
ShaftGhost: dc.b 0, 0, $FF, 0
ShaftLaunch: dc.b 4, 1, 2, 3, 4, 5, $FE, 1, 0
ShaftPreparing: dc.b 9, 0, $FD, $B
ShaftUncast: dc.b 4, $B, $A, 9, 3, 2, 1, $FD, 0
ShaftLaunch2: dc.b 4, 1, 2, 3, 4, $FD, 7
ShaftStepback: dc.b 4, $F, $10, $11, $10, $F, $FD, 0
ShaftAngryStand: dc.b 0, 5, $FF, 0
ShaftSpark:     dc.b 2, 0, 1, 2, 3, 4, 5,  $FE, 1
ShaftDeath:     dc.b 8, $12, $13, $14, $15, $15, $15, $15, $16, $17, $FE, 1
	even
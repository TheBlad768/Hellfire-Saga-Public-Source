Ani_Grounder:
		dc.w Spawner_Idle-Ani_Grounder
		dc.w Spawner_Brick-Ani_Grounder
		dc.w Grounder_Idle-Ani_Grounder
		dc.w Grounder_Mov-Ani_Grounder
Spawner_Idle:	  dc.b 0, 0, $FF, 0
Spawner_Brick:    dc.b 0, 1, $FF, 0
Grounder_Idle:    dc.b 0, 2, $FF, 0
Grounder_Mov:    dc.b 3, 3, 4, $FF
	even
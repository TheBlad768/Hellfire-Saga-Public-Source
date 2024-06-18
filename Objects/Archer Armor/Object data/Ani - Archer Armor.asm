Ani_ArcherArmor:
	dc.w ArcherArmor_Move-Ani_ArcherArmor
	dc.w ArcherArmor_Shoot-Ani_ArcherArmor
	dc.w ArcherArmor_Shoot2-Ani_ArcherArmor
	dc.w ArcherArmor_Shoot3-Ani_ArcherArmor
	dc.w ArcherArmor_Arrow-Ani_ArcherArmor

ArcherArmor_Move:  dc.b 4, 0, 1, 2, 3, $FF
ArcherArmor_Shoot: dc.b 3, 4, 5, 6, $FD, 2
ArcherArmor_Shoot2: dc.b 4, 7, 7, $FD, 3, 0
ArcherArmor_Shoot3: dc.b 0, 8, $FF, 0
ArcherArmor_Arrow: dc.b 0, 9, $FF, 0
	even
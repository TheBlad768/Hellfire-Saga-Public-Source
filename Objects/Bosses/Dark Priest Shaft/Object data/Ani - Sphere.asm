Ani_Sphere:
	dc.w	Sphere_IIdle-Ani_Sphere
	dc.w	Sphere_Hyperboloid-Ani_Sphere
	dc.w	Sphere_Fireball-Ani_Sphere
	dc.w	Sphere_ThunderLauncher-Ani_Sphere
	dc.w	Sphere_Appear-Ani_Sphere

Sphere_IIdle:	dc.b	0, 0, $FF, 0
Sphere_Hyperboloid:	dc.b	4, 1, 2, 3, 4, $FF, 0
Sphere_Fireball:	dc.b	4, 5, 6, 7, $FF
Sphere_ThunderLauncher:	dc.b	2, 8, 9, $FF
Sphere_Appear:	dc.b	4, 5, 6, 7, 6, $FD, 0
	even
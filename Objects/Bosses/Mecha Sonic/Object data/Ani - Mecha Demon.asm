Ani_MechaDemon:
		dc.w byte_Float-Ani_MechaDemon
		dc.w byte_Fold-Ani_MechaDemon
		dc.w byte_Spin-Ani_MechaDemon
		dc.w byte_Unfold-Ani_MechaDemon
		dc.w byte_Bullet-Ani_MechaDemon
		dc.w byte_Cast-Ani_MechaDemon
		dc.w byte_MiniBullet-Ani_MechaDemon
		dc.w byte_Transformation-Ani_MechaDemon
		dc.w byte_RushToTransform-Ani_MechaDemon
		dc.w byte_Spark-Ani_MechaDemon
		dc.w byte_MStand-Ani_MechaDemon
		dc.w byte_MDefeated-Ani_MechaDemon
byte_Float:	        dc.b $F, 0, 5, 0, 6, $FF, 0
byte_Fold:	        dc.b 2, 0, 1, 2, 3, 4, $FE, 3
byte_Spin:	        dc.b 0, 2, 3, 4, $FF, 0
byte_Unfold:	        dc.b 2, 2, 3, 4, 1, 0, $FE, 1
byte_Bullet:	        dc.b 4, 9, $A, 8, $FF
byte_Cast:	        dc.b 2, 2, 3, 4, 1, 7, $FE, 1
byte_MiniBullet:	dc.b 0, 5, 7, $FF, 0
byte_Transformation:    dc.b 0, $B, $FF
byte_RushToTransform:	dc.b 0, 1, $FF, 0
byte_Spark:		dc.b 2, 0, 1, 2, 3, $FF
byte_MStand:	dc.b $F, 0, $FF
byte_MDefeated:	dc.b $F, $C, $FF
	even
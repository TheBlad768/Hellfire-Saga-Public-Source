
Obj4B_MakeSparks:
		subq.w	#1,$2E(a0)
		bpl.s	Obj4B_Rts
		move.w	#$A,$2E(a0)

		jsr	(SingleObjLoad2).w
		bne.s	Obj4B_Rts
		move.l	#Obj4B_Spark,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

Obj4B_Rts:
		rts

; =============== S U B R O U T I N E =======================================

Obj4B_Spark:
		move.l	#Map_Spark,obMap(a0)
		move.w	#$3AD,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#8/2,obHeight(a0)
		move.b	#8/2,obWidth(a0)
		move.w	#0,priority(a0)
		move.b	#9,obAnim(a0)

		move.l	#Obj4B_Spark_Move,address(a0)

		add.w	#5,obX(a0)
		add.w	#$1D,obY(a0)

		move.b	#0,$2E(a0)

		jsr	(RandomNumber).w
		andi.l	#$FF,d0
		jsr	(CalcSine).w
		asr.w	#1,d1
		add.w	d1,obX(a0)
		asr.w	#1,d0
		add.w	d0,obY(a0)
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d1
		add.w	d1,d1
		sub.w	d1,obVelX(a0)
		sub.w	d0,obVelY(a0)

Obj4B_Spark_Move:
		move.w	parent(a0),a1
		cmpi.w	#6,objoff_46(a1)
		beq.s	+
		addq.b	#1,$2E(a0)
		cmpi.b	#$3D,$2E(a0)
		bge.w	+
		jsr	(SpeedToPos).w
		lea	(Ani_MechaDemon).l,a1
		jsr	(AnimateSprite).w
		jsr	(DisplaySprite).w
		rts
+		move.l	#Go_Delete_Sprite,(a0)

Obj4B_Spark_rts:
		rts
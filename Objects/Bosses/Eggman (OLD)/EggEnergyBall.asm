Obj_EggEnergyBall:				; XREF: Obj1F_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_EggEnergyBall_Index(pc,d0.w),d1
		jsr	Obj_EggEnergyBall_Index(pc,d1.w)
		lea     Ani_Eggman(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================
Obj_EggEnergyBall_Index:
		dc.w Obj_EggEnergyBall_Main-Obj_EggEnergyBall_Index
		dc.w Obj_EggEnergyBall_Fall-Obj_EggEnergyBall_Index
		dc.w Obj_EggEnergyBall_GoUp-Obj_EggEnergyBall_Index
		dc.w Obj_EggEnergyBall_Fall2-Obj_EggEnergyBall_Index
		dc.w Obj_EggEnergyBall_GoUp3-Obj_EggEnergyBall_Index
		dc.w Obj_EggEnergyBall_Fall3-Obj_EggEnergyBall_Index
; ===========================================================================
Obj_EggEnergyBall_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#$F,obAnim(a0)

Obj_EggEnergyBall_Fall:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_EggEnergyBall_Return
                add.w d1,obY(a0)
		addq.b	#2,obRoutine(a0)

Obj_EggEnergyBall_GoUp:
                move.w	#-$600,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		addq.b	#2,obRoutine(a0)

Obj_EggEnergyBall_Fall2:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_EggEnergyBall_Return
                add.w d1,obY(a0)
		addq.b	#2,obRoutine(a0)

Obj_EggEnergyBall_GoUp3:
                move.w	#-$600,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		addq.b	#2,obRoutine(a0)

Obj_EggEnergyBall_Fall3:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_EggEnergyBall_Return
                add.w d1,obY(a0)
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.w	#1,obSubtype(a0)

Obj_EggEnergyBall_Return:
		rts
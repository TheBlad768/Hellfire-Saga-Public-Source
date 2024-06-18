Obj_SharpThingy:				; XREF: Obj1F_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_SharpThingy_Index(pc,d0.w),d1
		jsr	Obj_SharpThingy_Index(pc,d1.w)
		lea     (Ani_PrinPrinFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================
Obj_SharpThingy_Index:
		dc.w Obj_SharpThingy_Main-Obj_SharpThingy_Index
		dc.w Obj_SharpThingy_Fall-Obj_SharpThingy_Index
		dc.w Obj_SharpThingy_GoUp-Obj_SharpThingy_Index
		dc.w Obj_SharpThingy_Fall2-Obj_SharpThingy_Index
; ===========================================================================
Obj_SharpThingy_CheckPrinPrinDead:
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_48(a1)
		bne.w	Obj_SharpThingy_Return
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		rts

Obj_SharpThingy_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_9bWiM,obMap(a0)
		move.w	#$380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)

Obj_SharpThingy_Fall:
		jsr	(Obj_SharpThingy_CheckPrinPrinDead).l
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_SharpThingy_Return
                add.w d1,obY(a0)
		addq.b	#2,obRoutine(a0)

Obj_SharpThingy_GoUp:
                move.w	#-$500,obVelY(a0)
		addq.b	#2,obRoutine(a0)

Obj_SharpThingy_Fall2:
		jsr	(Obj_SharpThingy_CheckPrinPrinDead).l
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_SharpThingy_Return
                add.w d1,obY(a0)
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)

Obj_SharpThingy_Return:
		rts
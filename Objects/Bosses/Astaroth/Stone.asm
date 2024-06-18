Obj_AstStone:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_AstStone_Index(pc,d0.w),d1
		jsr	Obj_AstStone_Index(pc,d1.w)
		lea	Ani_Astaroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_AstStone_Index:
		dc.w Obj_AstStone_Main-Obj_AstStone_Index
		dc.w Obj_AstStone_FallNDel-Obj_AstStone_Index
; ---------------------------------------------------------------------------

Obj_AstStone_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Astaroth,obMap(a0)
		move.w	#$340,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$8B,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#4,obTimer(a0)
		move.b	#5,obAnim(a0)
		jmp	(Swing_Setup1).w

Obj_AstStone_FallNDel:
		cmpi.b  #$01,(Check_GluttonyDead).w
		beq.w	+
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		subq.b	#1,obTimer(a0)
		bpl.s	Obj_AstStone_Return
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	Obj_AstStone_Return
		move.w #$14,(Screen_Shaking_Flag).w
+               move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)
		move.w	#2,obSubtype(a0)

Obj_AstStone_Return:
		rts
; ==================================================================
Obj_AstWarnSt:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_AstWarnSt_Index(pc,d0.w),d1
		jsr	Obj_AstWarnSt_Index(pc,d1.w)
		lea	Ani_Astaroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_AstWarnSt_Index:
		dc.w Obj_AstWarnSt_Main-Obj_AstWarnSt_Index
		dc.w Obj_AstWarnSt_SumStone-Obj_AstWarnSt_Index
		dc.w Obj_AstWarnSt_Delete-Obj_AstWarnSt_Index
; ---------------------------------------------------------------------------

Obj_AstWarnSt_Main:
		move.l	#Map_Astaroth,obMap(a0)
		move.w	#$340,obGfx(a0)
		move.b	#6,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w  #60,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_AstWarnSt_SumStone:
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_49(a1)
		beq.w	+
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_AstWarnSt_Return
		jsr	(SingleObjLoad2).w
		bne.s	Obj_AstWarnSt_Return
		move.l	#Obj_AstStone,(a1)
		move.w	parent(a0),parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	(Camera_target_max_y_pos).w,obY(a1)
		sub.w	#$10,obY(a1)
+		addq.b	#2,routine(a0)

Obj_AstWarnSt_Delete:
		jmp	(DeleteObject).w

Obj_AstWarnSt_Return:
		rts
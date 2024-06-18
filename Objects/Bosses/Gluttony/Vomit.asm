; ===========================================================================
; Vomit of Gluttony, the green thingy
; ===========================================================================

Obj_Vomit:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj_Vomit_Index(pc,d0.w),d1
		jsr	Obj_Vomit_Index(pc,d1.w)
		lea	Ani_Gluttony(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================
Obj_Vomit_Index:
                dc.w Obj_Vomit_Main-Obj_Vomit_Index
                dc.w Obj_Vomit_Fall-Obj_Vomit_Index
                dc.w Obj_Vomit_SetAttr-Obj_Vomit_Index
		dc.w Obj_Vomit_Run-Obj_Vomit_Index
; ===========================================================================
Obj_Vomit_Main:
		addq.b	#2,routine_secondary(a0)
		move.l	#Map_Gluttony,obMap(a0)
		move.w	#$23A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		bset	#4,shield_reaction(a0)
		move.b	#2,obAnim(a0)

Obj_Vomit_Fall:
		cmpi.b  #$01,(Check_GluttonyDead).w
		beq.w	Obj_Vomit_Delete
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Vomit_Return
                add.w 	d1,obY(a0)
		addq.b	#2,routine_secondary(a0)

Obj_Vomit_SetAttr:
		move.w	#0,obVelY(a0)
		move.w	#$400,obVelX(a0)
		cmpi.b	#1,objoff_45(a0)	; facing left?
		beq.w	+	; if not, branch
		neg.w	obVelX(a0)
+		addq.b	#2,routine_secondary(a0)

Obj_Vomit_Run:
		cmpi.b  #$01,(Check_GluttonyDead).w
		beq.s	Obj_Vomit_Delete
		jsr	(SpeedToPos).w
		jsr 	(ChkObjOnScreen).w
		beq.w 	Obj_Vomit_Return

Obj_Vomit_Delete:
                jmp	(DeleteObject).w

Obj_Vomit_Return:
		rts

; ===========================================================================
; Vomit Special
; ===========================================================================

Obj_VomitGMZ4:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj_VomitGMZ4_Index(pc,d0.w),d1
		jsr	Obj_VomitGMZ4_Index(pc,d1.w)
		lea	Ani_Gluttony(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================
Obj_VomitGMZ4_Index:
                dc.w Obj_VomitGMZ4_Main-Obj_VomitGMZ4_Index
                dc.w Obj_VomitGMZ4_Fall-Obj_VomitGMZ4_Index
		dc.w Obj_VomitGMZ4_Run-Obj_VomitGMZ4_Index
; ===========================================================================
Obj_VomitGMZ4_Main:
		addq.b	#2,routine_secondary(a0)
		move.l	#SME_LaTNO,obMap(a0)
		move.w	#$403,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#2,obAnim(a0)

Obj_VomitGMZ4_Fall:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_VomitGMZ4_Return
                add.w 	d1,obY(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,routine_secondary(a0)

Obj_VomitGMZ4_Run:
		cmpi.b  #$01,(Check_GluttonyDead).w
		beq.s	Obj_VomitGMZ4_Delete
		jsr	(SpeedToPos).w
		jsr 	(ChkObjOnScreen).w
		beq.w 	Obj_VomitGMZ4_Return

Obj_VomitGMZ4_Delete:
                jmp	(DeleteObject).w

Obj_VomitGMZ4_Return:
		rts
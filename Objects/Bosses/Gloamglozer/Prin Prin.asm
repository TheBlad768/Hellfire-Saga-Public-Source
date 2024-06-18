; -----------------------------------------
; Prin Prin fantom form used by Gloamglozer
; -----------------------------------------

Obj_PrinPrinFantom:
	moveq   #0,d0
	move.b	obRoutine(a0),d0
	move.w  Obj_PrinPrinFantom_Index(pc,d0.w),d1
	jsr     Obj_PrinPrinFantom_Index(pc,d1.w)
	lea     (Ani_PrinPrinFantom).l,a1
	jsr     (AnimateSprite).w
        jmp     (Obj_GloamglozerForm_CheckReturnPal).l

Obj_PrinPrinFantom_Index:
	dc.w  Obj_PrinPrinFantom_Main-Obj_PrinPrinFantom_Index;0
	dc.w  Obj_PrinPrinFantom_Preparing-Obj_PrinPrinFantom_Index;2
	dc.w  Obj_PrinPrinFantom_Fall-Obj_PrinPrinFantom_Index;4
	dc.w  Obj_PrinPrinFantom_LoadFireShield-Obj_PrinPrinFantom_Index;4
	dc.w  Obj_PrinPrinFantom_RaiseUp-Obj_PrinPrinFantom_Index;6
	dc.w  Obj_PrinPrinFantom_Running-Obj_PrinPrinFantom_Index;8

Obj_PrinPrinFantom_CheckInCamera:
		move.w	(Camera_x_pos).w,d0
		addi.w	#$30,d0
		cmp.w	obX(a0),d0
		blt.s	+
		move.w	d0,obX(a0)
		rts

+		move.w	(Camera_x_pos).w,d0
		addi.w	#$F8,d0
		cmp.w	obX(a0),d0
		bcc.s	+
		move.w	d0,obX(a0)
+		rts

Obj_PrinPrinFantom_Main:
		addq.b	#2,obRoutine(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#$10,subtype(a1)
		move.l	#Pal_PrinPrin,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
                move.w	#16-1,$38(a1)
+               move.w  parent3(a0),parent(a0)
		move.l	#SME_9bWiM,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#9,obHeight(a0)
		move.b	#6,obWidth(a0)
		move.b	#9,x_radius(a0)
		move.b	#6,y_radius(a0)
		move.b  #0,obAnim(a0)
		move.b	#0,objoff_48(a0)
		move.b	#$3C,obTimer(a0)
		jsr	(Obj_PrinPrinFantom_CheckInCamera).l
		jsr	(Find_Sonic).w
		cmpi.w	#$180,d2
		bcc.w	Obj_PrinPrinFantom_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		move.b	#1,objoff_46(a0)					; NOV: Fixed a naming issue

Obj_PrinPrinFantom_Preparing:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_PrinPrinFantom_Return
		jsr	(SingleObjLoad2).w
		bne.w	Obj_PrinPrinFantom_Return
		move.l	#Obj_Explosion,(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

		move.b	#$3C,obTimer(a0)
		addq.b  #2,obRoutine(a0);

Obj_PrinPrinFantom_Fall:
		jsr     (ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_PrinPrinFantom_Return
                add.w	d1,obY(a0)
		move.b  #1,obAnim(a0)
		move.w	#40,obTimer(a0)
		addq.b  #2,obRoutine(a0);

Obj_PrinPrinFantom_LoadFireShield:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_PrinPrinFantom_Return

		lea	ChildObjDat_PrinPrinFantom_FireBllCirc(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.w	obStatus(a0),obStatus(a1)
+
		addq.b  #2,obRoutine(a0);
		move.b	#$3C,obTimer(a0)
		samp	sfx_Fire_Shield

Obj_PrinPrinFantom_RaiseUp:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_PrinPrinFantom_Return

		move.w	#162,obTimer(a0)
		move.b  #2,obAnim(a0)
		move.w 	#$300,obVelX(a0);
		move.w 	#0,obVelY(a0);
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		addq.b  #2,obRoutine(a0);

Obj_PrinPrinFantom_Running:
		jsr     (SpeedToPos).w
		jsr	(Obj_PrinPrinFantom_RunOnScr_Left).l
		jsr	(Obj_PrinPrinFantom_RunOnScr_Right).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_PrinPrinFantom_Return
                move.l  #Delete_Current_Sprite,(a0)
                bset	#7,obStatus(a0)
		move.w  parent(a0),a1
		move.b	#1,objoff_48(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		subi.w	#$20,obY(a1)
		rts

Obj_PrinPrinFantom_RunOnScr_Left:
		move.w	(Camera_x_pos).w,d0
		add.w	#$10,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_PrinPrinFantom_Return
		bchg    #0,obStatus(a0)
		neg.w	obVelX(a0)
		rts

Obj_PrinPrinFantom_RunOnScr_Right:
		move.w	(Camera_x_pos).w,d0
		add.w	#$120,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_PrinPrinFantom_Return
		bchg    #0,obStatus(a0)
		neg.w	obVelX(a0)

Obj_PrinPrinFantom_Return:
		rts
; ===========================================================================

Obj_PrinPrinFantom_FireBllCirc:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)
		move.l	#SME_9bWiM,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$8B,obColType(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#4,obAnim(a0)
		move.w	#8,obTimer(a0)
		move.l	#PrinPrinFantom_FireBllCirc_Circular,(a0)

PrinPrinFantom_FireBllCirc_Circular:
		cmpi.b	#30,objoff_3A(a0)
		bcc.s	+
		addq.b	#1,objoff_3A(a0)
+		subi.b	#$A,$3C(a0)			; Радиус.
		jsr	(MoveSprite_Circular).w	; эюащение.
                lea	(Ani_PrinPrinFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).w
; ===========================================================================

ChildObjDat_PrinPrinFantom_FireBllCirc:
		dc.w 4-1
		dc.l Obj_PrinPrinFantom_FireBllCirc

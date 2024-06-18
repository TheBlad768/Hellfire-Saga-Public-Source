; ---------------------------------------------------------------------------
; Count Bloodeau form used by Gloamglozer
; ---------------------------------------------------------------------------

Obj_BloodeauFantom:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_BloodeauFantom_Index(pc,d0.w),d1
		jsr	Obj_BloodeauFantom_Index(pc,d1.w)
		lea	(Ani_BloodeauFantom).l,a1
		jsr	(AnimateSprite).w
                jmp     (Obj_GloamglozerForm_CheckReturnPal).l
; ===========================================================================
Obj_BloodeauFantom_Index:
		dc.w Obj_BloodeauFantom_Main-Obj_BloodeauFantom_Index
		dc.w Obj_BloodeauFantom_FlyDown-Obj_BloodeauFantom_Index
		dc.w Obj_BloodeauFantom_ThrowCrosses-Obj_BloodeauFantom_Index
		dc.w Obj_BloodeauFantom_FlyToSide-Obj_BloodeauFantom_Index
; ===========================================================================

Obj_BloodeauFantom_Main:
		addq.b	#2,obRoutine(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#$F,subtype(a1)
		move.l	#Pal_Bloodeau,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
                move.w	#16-1,$38(a1)
+		move.l	#SME_Wl_Mf,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#6,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#6,y_radius(a0)
		move.w	#$400,obVelY(a0)
		move.w	#0,obVelX(a0)

Obj_BloodeauFantom_FlyDown:
		tst.w	Seizure_flag.w			; check if photosensitivity
		bne.s	.noafterimage			; if so, no after image
		jsr	(Obj_Produce_AfterImage).l

.noafterimage
		jsr	(SpeedToPos).w
		sub.w	#$19,obVelY(a0)
		cmpi.w	#$19,obVelY(a0)
		bcc.w	Obj_BloodeauFantom_Return
		addq.b	#2,obRoutine(a0)
		move.w	#0,obVelY(a0)
		move.w	#49,obTimer(a0)
		jsr	(Swing_Setup_Hellgirl).w

Obj_BloodeauFantom_ThrowCrosses:
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_BloodeauFantom_Return
		addq.b	#2,obRoutine(a0)
		move.b	#1,obAnim(a0)
		jsr	(Create_New_Sprite).w
		bne.s	Obj_BloodeauFantom_FlyToSide
		move.l	#Obj_BldCross,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#1,obSubtype(a1)
		move.w	a0,parent(a1)
		jsr	(Create_New_Sprite).w
		bne.s	Obj_BloodeauFantom_FlyToSide
		move.l	#Obj_BldCross,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#$200,obVelX(a1)
		jsr	(Create_New_Sprite).w
		bne.s	Obj_BloodeauFantom_FlyToSide
		move.l	#Obj_BldCross,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$200,obVelX(a1)


Obj_BloodeauFantom_FlyToSide:
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		cmpi.b	#1,objoff_48(a0)
		bne.w	Obj_BloodeauFantom_Return

		jsr	(Create_New_Sprite).w
		bne.s	.delete
		move.l	#Obj_BldWarnTmb,(a1)
		jsr	(RandomNumber).w
                andi.w	#$7B,d0
                addi.w	#$10,d0
                move.w	(v_screenposx).w,d1 ; Copy camera Xpos into d0
                add.w	d0,d1
                move.w	d1,obX(a1)
		move.w	(Camera_y_pos).w,d0
		add.w	#$20,d0
		move.w	d0,obY(a1)
		move.l	obMap(a0),obMap(a1)

		jsr	(Create_New_Sprite).w
		bne.s	.delete
		move.l	#Obj_BldWarnTmb,(a1)
		jsr	(RandomNumber).w
                andi.w	#$68,d0
                addi.w	#$B0,d0
                move.w (v_screenposx).w,d1 ; Copy camera Xpos into d0
                add.w	d0,d1
                move.w	d1,obX(a1)
		move.w	(Camera_y_pos).w,d0
		add.w	#$20,d0
		move.w	d0,obY(a1)
		move.l	obMap(a0),obMap(a1)

.delete
                move.l  #Delete_Current_Sprite,(a0)
                bset	#7,obStatus(a0)
		move.w	parent3(a0),a1
		move.w	#160,obTimer(a1)
		move.b	#1,objoff_48(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		subi.w	#$A,obY(a1)


Obj_BloodeauFantom_Return:
		rts
; ===========================================================================

loc_BloodWay:
		rts

Obj_Bloodeau_Tombs:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_Bloodeau_Tombs_Index(pc,d0.w),d1
		jsr	Obj_Bloodeau_Tombs_Index(pc,d1.w)
		lea	(Ani_BloodeauFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_Bloodeau_Tombs_Index:
		dc.w Obj_Bloodeau_Tombs_Main-Obj_Bloodeau_Tombs_Index
		dc.w Obj_Bloodeau_Tombs_Fall-Obj_Bloodeau_Tombs_Index
		dc.w Obj_Bloodeau_Tombs_RaiseUp-Obj_Bloodeau_Tombs_Index

Obj_Bloodeau_Tombs_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_Wl_Mf,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$20,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$20,y_radius(a0)
		move.b	#$8C,obColType(a0)
		move.b	#2,obAnim(a0)

Obj_Bloodeau_Tombs_Fall:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Bloodeau_Tombs_Return
		add.w	d1,obY(a0)
		move.w	#-$A00,obVelY(a0)
		sfx	sfx_Raid
		move.w	#$18,(Screen_Shaking_Flag).w

		lea	(Player_1).w,a1

		btst	#Status_InAir,status(a1)	;
		bne.w	+				;
		cmpi.b	#id_Hurt,anim(a1)
		beq.w	+				;
		move.b	#id_Roll,anim(a1)
		move.w	#-$800,y_vel(a1)
		clr.b	spin_dash_flag(a1)					
		bset	#Status_InAir,status(a1)

+		addq.b	#2,obRoutine(a0)

Obj_Bloodeau_Tombs_RaiseUp:
		cmpi.w	#1,(Screen_Shaking_Flag).w
		bcc.w	Obj_Bloodeau_Tombs_Return
		move.b	#0,obColType(a0)
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.s	Obj_Bloodeau_Tombs_Return
		move.l	#Go_Delete_Sprite,(a0)

Obj_Bloodeau_Tombs_Return:
		rts
; ==================================================================

Obj_BldWarnTmb:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_BldWarnTmb_Index(pc,d0.w),d1
		jsr	Obj_BldWarnTmb_Index(pc,d1.w)
		cmpi.l	#SME_Wl_Mf,obMap(a0)
		bne.s	.chesani
		lea	(Ani_BloodeauFantom).l,a1
		bra.s	.contani

.chesani:
		lea	(Ani_ChesireFantom).l,a1

.contani:
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_BldWarnTmb_Index:
		dc.w Obj_BldWarnTmb_Main-Obj_BldWarnTmb_Index
		dc.w Obj_BldWarnTmb_SumStone-Obj_BldWarnTmb_Index
		dc.w Obj_BldWarnTmb_Delete-Obj_BldWarnTmb_Index
; ---------------------------------------------------------------------------

Obj_BldWarnTmb_Main:
		move.w	#$380,obGfx(a0)
		move.b	#$84,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$80,priority(a0)
		move.w  #60,obTimer(a0)
		addq.b	#2,routine(a0)
		move.b	#3,obAnim(a0)

Obj_BldWarnTmb_SumStone:
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_BldWarnTmb_Return
		cmpi.l	#SME_Wl_Mf,obMap(a0)
		bne.s	+
		jsr	(SingleObjLoad2).w
		bne.s	Obj_BldWarnTmb_Return
		move.l	#Obj_Bloodeau_Tombs,(a1)
		move.w	obX(a0),obX(a1)
		move.w	(Camera_y_pos).w,d0
		sub.w	#$20,d0
		move.w	d0,obY(a1)
+		addq.b	#2,routine(a0)

Obj_BldWarnTmb_Delete:
		move.l	#Go_Delete_Sprite,(a0)

Obj_BldWarnTmb_Return:
		rts

; ==================================================================
Obj_BldCross:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_BldCross_Index(pc,d0.w),d1
		jsr	Obj_BldCross_Index(pc,d1.w)
		lea	(Ani_BloodeauFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_BldCross_Index:
		dc.w Obj_BldCross_Main-Obj_BldCross_Index
		dc.w Obj_BldCross_MoveDown-Obj_BldCross_Index
; ---------------------------------------------------------------------------

Obj_BldCross_Main:
		move.l	#SME_Wl_Mf,obMap(a0)
		move.w	#$380,obGfx(a0)
		move.b	#$9A,obColType(a0)
		move.b	#4,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.w	#$400,obVelY(a0)
		addq.b	#2,routine(a0)

Obj_BldCross_MoveDown:
		sub.w	#$10,obVelY(a0)
		jsr	(Obj_Werewolf_LookOnSonic).l
		jsr	(Find_SonicTails).w
		move.w	#$400,d0
		move.w	#$40,d1
		jsr	(Chase_ObjectXOnly).w
		jsr	(MoveSprite2).w
		cmpi.w	#$10,obVelY(a0)
		bcc.w	Obj_BldCross_Return
		cmpi.w	#1,obSubtype(a0)
		bne.s	Obj_BlsCross_Delete
		move.w	parent(a0),a1
		move.b	#1,objoff_48(a1)

Obj_BlsCross_Delete:
		move.l	#Go_Delete_Sprite,(a0)

Obj_BldCross_Return:
		rts


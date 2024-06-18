Obj_ChesireFantom:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_ChesireFantom_Index(pc,d0.w),d1
		jsr	Obj_ChesireFantom_Index(pc,d1.w)
		lea	(Ani_ChesireFantom).l,a1
		jsr	(AnimateSprite).w
                jmp     (Obj_GloamglozerForm_CheckReturnPal).l

Obj_ChesireFantom_Index:
		dc.w Obj_ChesireFantom_Main-Obj_ChesireFantom_Index
		dc.w Obj_ChesireFantom_FlyDown-Obj_ChesireFantom_Index
		dc.w Obj_ChesireFantom_FollowSonic-Obj_ChesireFantom_Index
		dc.w Obj_ChesireFantom_FollowSonic2-Obj_ChesireFantom_Index
		dc.w Obj_ChesireFantom_GloamReveal-Obj_ChesireFantom_Index

Obj_ChesireFantom_Main:
		addq.b	#2,obRoutine(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#$A,subtype(a1)
		move.l	#Pal_Chesire,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
		move.w	#16-1,$38(a1)
+		move.l	#SME_IEpix,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#6,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#6,y_radius(a0)
		move.w	#$400,obVelY(a0)
		move.w	#0,obVelX(a0)
		move.b	#1,objoff_48(a0)

Obj_ChesireFantom_FlyDown:
		tst.w	Seizure_flag.w			; check if photosensitivity
		bne.s	.noafterimage			; if so, no after image
		jsr	(Obj_Produce_AfterImage).l

.noafterimage
		jsr	(SpeedToPos).w
		sub.w	#$10,obVelY(a0)
		cmpi.w	#$10,obVelY(a0)
		bcc.w	Obj_ChesireFantom_Return
		addq.b	#2,obRoutine(a0)
		move.w	#0,obVelY(a0)
		move.w	#300,obTimer(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireFantom_Return
		move.l	#Obj_ChesireBall,(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		sub.w	#$20,obX(a1)
		move.w	#$16C,obY(a1)
		move.w	a0,parent(a1)
		move.w	a1,parent2(a0)

		jsr	(Swing_Setup_Hellgirl).w

Obj_ChesireFantom_FollowSonic:
		move.w	(Camera_x_pos).w,d0
		add.w	#$9A,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		jsr	(Obj_ChesireFantom_CheckBallKick).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_ChesireFantom_Return
		bset	#7,obStatus(a0)
		move.b	#1,objoff_48(a0)
		move.l	#Obj_Explosion,(a0)
		clr.b	routine(a0)
		move.w  parent3(a0),a1
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#1,objoff_3E(a1)
		move.w	#-$800,obVelY(a1)
		move.w	#10,obTimer(a1)
		move.b	#1,objoff_48(a1)
		rts

Obj_ChesireFantom_FollowSonic2:
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_ChesireFantom_Return
		move.l	#Go_Delete_Sprite,(a0)
		rts

Obj_ChesireFantom_CheckBallKick:
		move.w	parent2(a0),a1
		cmpi.w	#1,obSubtype(a1)
		bne.w	Obj_ChesireFantom_Return

		lea	obDartsum_CheckXY(pc),a2				; Данные для проверки позиции
		jsr	(Check_InMyRange).w
		beq.w	Obj_ChesireFantom_Return
		move.b	#8,obRoutine(a0)
		rts

Obj_ChesireFantom_GloamReveal:
		move.l	#Delete_Current_Sprite,(a0)
		bset	#7,obStatus(a0)
		move.b	#1,objoff_48(a0)
		move.l  #Obj_Explosion,(a0)
		clr.b   routine(a0)
		move.w	parent3(a0),a1
		move.b	#1,objoff_48(a1)
		move.w	#90,obTimer(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		rts

Obj_ChesireFantom_Return:
		rts

; -----------------------------------
; chesire's toy - bowling ball
; ----------------------------------

Obj_ChesireBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_ChesireBall_Index(pc,d0.w),d1
		jsr	Obj_ChesireBall_Index(pc,d1.w)
		lea	(Ani_ChesireFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_ChesireBall_Index:
	dc.w  Obj_ChesireBall_Main-Obj_ChesireBall_Index
	dc.w  Obj_ChesireBall_Fall-Obj_ChesireBall_Index
	dc.w  Obj_ChesireBall_Preparing-Obj_ChesireBall_Index
	dc.w  Obj_ChesireBall_Running-Obj_ChesireBall_Index


Obj_ChesireBall_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_IEpix,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b  #1,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.w	#0,obSubtype(a0)
		move.b	#$9A,obColType(a0)
		move.b	#9,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#9,x_radius(a0)
		move.b	#9,y_radius(a0)
		move.w	#1,objoff_46(a0)					; NOV: Fixed a naming issue

		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_BldWarnTmb,(a1)
		move.w  (Camera_x_pos).w,obX(a1)
		add.w	#$20,obX(a1)
		move.w	#$15A,obY(a1)
		move.l	obMap(a0),obMap(a1)

		jsr	(RandomNumber).w
		andi.w	#1,d0
		beq.s	+
		add.w	#$100,obX(a1)
		add.w	#$178,obX(a0)

+		jsr	(Find_Sonic).w
		cmpi.w	#$180,d2
		bcc.w	Obj_ChesireBall_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.w	Obj_ChesireBall_Return
		bclr	#0,obStatus(a0)
		rts

Obj_ChesireBall_Fall:
		jsr     (ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_ChesireBall_Return
		add.w	d1,obY(a0)
		move.w	#120,obTimer(a0)
		addq.b  #2,obRoutine(a0)

Obj_ChesireBall_Preparing:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_ChesireBall_Return
		move.w  #$780,obVelX(a0)
		move.w 	#0,obVelY(a0);
		btst	#0,obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		addq.b  #2,obRoutine(a0);

Obj_ChesireBall_Running:
		jsr	(Obj_ChesireBall_CheckItIsTimeToDie).l
		jsr	(SpeedToPos).w
		cmpi.w	#1,obSubtype(a0)
		beq.s	.runleftright
		jsr	(Obj_ChesireBall_CreateDust).l
		jsr	(Obj_ChesireBall_ChkSonicPump).l

.runleftright:
                cmpi.b  #1,objoff_3E(a0)
                beq.s   .chase
                jsr	(Obj_ChesireBall_RunOnScr_Left).l
		jmp	(Obj_ChesireBall_RunOnScr_Right).l

.chase:
                jmp     (Obj_ChesireBall_100percentHit).l

Obj_ChesireBall_RunOnScr_Left:
		move.w	(Camera_x_pos).w,d0
		sub.w	#$50,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_ChesireBall_Return
		bchg	#0,obStatus(a0)
                bsr.s   Obj_ChesireBall_ChangeMovingRules
		rts

Obj_ChesireBall_RunOnScr_Right:
		move.w	(Camera_x_pos).w,d0
		add.w	#$180,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_ChesireBall_Return
		bchg	#0,obStatus(a0)

Obj_ChesireBall_ChangeMovingRules:
		neg.w	obVelX(a0)
		cmpi.w	#1,obSubtype(a0)
		bne.w	Obj_ChesireBall_Return
                move.b  #1,objoff_3E(a0)
                rts

Obj_ChesireBall_100percentHit:
                move.w	parent(a0),a1
		jsr	(Find_OtherObject).w
		move.w	#$3B0,d0
		moveq	#$50,d1
		jmp	(Chase_Object).w

Obj_ChesireBall_NewYVel:
		cmpi.w	#1,obSubtype(a0)
		bne.w	Obj_ChesireBall_Return
		move.w	parent2(a0),a1
		move.w	obY(a1),d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a0)
		rts

Obj_ChesireBall_ChkSonicPump:
		lea	(Player_1).w,a1
		lea	obDartsum_CheckXY(pc),a2
		jsr	(Check_InMyRange).w
		beq.w	Obj_ChesireFantom_Return
		btst	#Status_InAir,status(a1)
		bne.w	Obj_ChesireBall_Return

		cmpi.b	#id_Roll,anim(a1)
		bne.w	Obj_ChesireBall_Return

		cmpi.w	#$300,ground_vel(a1)
		bcc.s	.sendfly
		cmpi.w	#-$300,ground_vel(a1)
		blt.s	.sendfly
		bra.w	.lacricium

.sendfly:
		sfx	sfx_KnucklesKick
		move.w	#1,obSubtype(a0)
		move.w 	#-$A00,obVelX(a0)
		move.w	#-$240,obVelY(a0)
		move.b	#0,obColType(a0)
		btst	#0,obStatus(a0)
		bne.s	Obj_ChesireBall_Return
		neg.w	obVelX(a0)

.lacricium:
		rts
; ---------------------------------------------------------------------------

Obj_ChesireBall_CreateDust:
		move.w	(V_int_run_count+2).w,d0
		andi.w	#3,d0
		bne.s	+
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_BallDust,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
+		rts
; ---------------------------------------------------------------------------

Obj_ChesireBall_CheckItIsTimeToDie:
		move.w	parent(a0),a1
		cmpi.b	#1,objoff_48(a1)
		bne.s	+
		move.l  #Obj_Explosion,(a0)
		clr.b   routine(a0)
+		rts
; ---------------------------------------------------------------------------

Obj_ChesireBall_Return:
		rts
; ---------------------------------------------------------------------------

Obj_BallDust:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_BallDust_Index(pc,d0.w),d1
		jsr	Obj_BallDust_Index(pc,d1.w)
		lea	(Ani_ChesireFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_BallDust_Index:
		dc.w  Obj_BallDust_Main-Obj_BallDust_Index
		dc.w  Obj_BallDust_ChkDel-Obj_BallDust_Index
; ---------------------------------------------------------------------------

Obj_BallDust_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_IEpix,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b  #4,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.w	#-$100,obVelY(a0)
		move.w	#10,obTimer(a0)

Obj_BallDust_ChkDel:
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.s	+
		move.l	#Go_Delete_Sprite,(a0)
+		rts
; ---------------------------------------------------------------------------

obDartsum_CheckXY:	; Размер координат 4x4(Размер спрайта ?x?)
		dc.w -32
		dc.w 64
		dc.w -32
		dc.w 64

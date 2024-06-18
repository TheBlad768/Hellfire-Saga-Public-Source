Obj_ChesireLock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_ChesireLock_Index(pc,d0.w),d1
		jsr	Obj_ChesireLock_Index(pc,d1.w)
		lea	(Ani_ChesireFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_ChesireLock_Index:
		dc.w Obj_ChesireLock_Main-Obj_ChesireLock_Index
		dc.w Obj_ChesireLock_CheckBallKick-Obj_ChesireLock_Index
		dc.w Obj_ChesireLock_GloamReveal-Obj_ChesireLock_Index


Obj_ChesireLock_Main:
		move.l	#SME_IEpix,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#5,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#48/2,obHeight(a0)
		move.b	#48/2,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#6,y_radius(a0)
		move.b	#0,objoff_48(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return		;
		move.l	#Obj_ChesireChain,(a1)
		move.w	#$2380,obGfx(a1)
		move.w	#4,obSubtype(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,obParent(a1)
		move.w	a0,obParent2(a1)
		move.w	a1,d1
		move.w	obX(a0),obX(a1)
		add.w	#$20,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#7,obAnim(a1)
		move.b	#1,objoff_46(a1)


		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return
		move.l	#Obj_ChesireChain,(a1)
		move.w	#$2380,obGfx(a1)
		move.w	#4,obSubtype(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,obParent(a1)
		move.w	d1,obParent2(a1)
		move.w	a1,d1
		move.w	obX(a0),obX(a1)
		sub.w	#$20,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#7,obAnim(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return		;
		move.l	#Obj_ChesireChain,(a1)
		move.w	#$2380,obGfx(a1)
		move.w	#3,obSubtype(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,obParent(a1)
		move.w	d1,obParent2(a1)
		move.w	a1,d1
		move.w	obX(a0),obX(a1)
		add.w	#$30,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#7,obAnim(a1)


		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return
		move.l	#Obj_ChesireChain,(a1)
		move.w	#$2380,obGfx(a1)
		move.w	#3,obSubtype(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,obParent(a1)
		move.w	d1,obParent2(a1)
		move.w	a1,d1
		move.w	obX(a0),obX(a1)
		sub.w	#$30,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#7,obAnim(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return		;
		move.l	#Obj_ChesireChain,(a1)
		move.w	#$380,obGfx(a1)
		move.w	#2,obSubtype(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,obParent(a1)
		move.w	d1,obParent2(a1)
		move.w	a1,d1
		move.w	obX(a0),obX(a1)
		add.w	#$40,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#8,obAnim(a1)


		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return
		move.l	#Obj_ChesireChain,(a1)
		move.w	#$380,obGfx(a1)
		move.w	#2,obSubtype(a1)
		move.w	obStatus(a0),obStatus(a1)
		move.w	a0,obParent(a1)
		move.w	d1,obParent2(a1)
		move.w	a1,d1
		move.w	obX(a0),obX(a1)
		sub.w	#$40,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#8,obAnim(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_ChesireLock_Return
		move.l	#Obj_LockBall,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),d0
		sub.w	#$80,d0
		move.w	d0,obY(a1)
		move.w	a0,parent(a1)
		move.w	a1,parent2(a0)
		addq.b	#2,obRoutine(a0)
		jsr	(Swing_Setup1).w

Obj_ChesireLock_CheckBallKick:
		jsr	(Swing_UpAndDown_Slow).w
		jsr	(SpeedToPos).w
		move.w	parent2(a0),a1
		lea	obLDartsum_CheckXY(pc),a2				; Данные для проверки позиции
		jsr	(Check_InMyRange).w
		beq.w	Obj_ChesireLock_Return
		cmpi.b	#1,obAnim(a1)
		bne.w	Obj_ChesireLock_Return
		addq.b	#2,obRoutine(a0)
		move.w	obVelX(a1),obVelX(a0)
		move.w	obVelY(a1),obVelY(a0)
		fadeout
		move.b	#1,objoff_48(a0)
		rts

Obj_ChesireLock_GloamReveal:
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.w	Obj_ChesireLock_Return
		move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)

Obj_ChesireLock_Return:
		rts

; -----------------------------------
; chesire's toy - bowling ball
; ----------------------------------

Obj_LockBall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_LockBall_Index(pc,d0.w),d1
		jsr	Obj_LockBall_Index(pc,d1.w)
		lea	(Ani_ChesireFantom).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_LockBall_Index:
	dc.w  Obj_LockBall_Main-Obj_LockBall_Index
	dc.w  Obj_LockBall_Check-Obj_LockBall_Index
	dc.w  Obj_LockBall_Wait-Obj_LockBall_Index
	dc.w  Obj_LockBall_Fall-Obj_LockBall_Index
	dc.w  Obj_LockBall_Bounce-Obj_LockBall_Index
	dc.w  Obj_LockBall_Waiting-Obj_LockBall_Index
	dc.w  Obj_LockBall_Flying-Obj_LockBall_Index


Obj_LockBall_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_IEpix,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b  #9,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#2*$80,obPriority(a0)
		move.w	#0,obSubtype(a0)
	;	move.b	#$9A,obColType(a0)
		move.b	#9,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.b	#9,x_radius(a0)
		move.b	#9,y_radius(a0)

Obj_LockBall_Check:
                cmpi.w	#$2C0,(Camera_min_X_pos).w
		bne.w	Obj_LockBall_Return
		addq.b  #2,obRoutine(a0)
		move.w	#$2F,$2E(a0)

Obj_LockBall_Wait:
		subq.w	#1,$2E(a0)
		bpl.w	Obj_LockBall_Return
		addq.b  #2,obRoutine(a0)

Obj_LockBall_Fall:
		jsr	(ObjectFall).w
		tst.w	y_vel(a0)
		bmi.w	Obj_LockBall_Return
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_LockBall_Return
                add.w	d1,obY(a0)
		addq.b	#2,obRoutine(a0)

Obj_LockBall_Bounce:
		jsr	(MoveSprite).w
		move.w	y_vel(a0),d0
		bmi.w	Obj_LockBall_Return
		cmpi.w	#$180,d0
		blo.s	Obj_LockBall_Bounce_Done
		asr.w	d0
		neg.w	d0
		move.w	d0,y_vel(a0)
		subq.b	#2,obRoutine(a0)
		sfx	sfx_KnucklesKick
		rts
; ---------------------------------------------------------------------------

Obj_LockBall_Bounce_Done:
		addq.b	#2,obRoutine(a0)
		move.w	#4*$80,obPriority(a0)

		move.b	#6,obAnim(a0)
		tst.w	Seizure_flag.w			; check if photosensitivity
		beq.s	Obj_LockBall_Waiting		; branch if no
		move.b	#10,obAnim(a0)

Obj_LockBall_Waiting:
		lea	(Player_1).w,a1
		lea	obLDartsum_CheckXY(pc),a2
		jsr	(Check_InMyRange).w
		beq.w	Obj_LockBall_Return
		jsr	(Check_PlayerAttack).l
		beq.w	Obj_LockBall_Return
		tst.w	y_vel(a1)
		bmi.w	Obj_LockBall_Return

		move.w	ground_vel(a1),d0
		beq.w	Obj_LockBall_Return
		bpl.s	+
		neg.w	d0
+		cmpi.w	#$600,d0
		blo.s	Obj_LockBall_BounceAway
		sfx	sfx_KnucklesKick
		move.b	obStatus(a1),obStatus(a0)
		addq.b  #2,obRoutine(a0)
		move.w	#1,obSubtype(a0)
		move.b  #1,obAnim(a0)
		move.w 	#-$A00,obVelX(a0);
		move.w	#-$240,obVelY(a0)
		move.b	#0,obColType(a0)
		btst	#0,obStatus(a0)
		bne.w	Obj_LockBall_Return
		neg.w	obVelX(a0)
		rts
; ---------------------------------------------------------------------------

Obj_LockBall_Flying:
		jsr	(SpeedToPos).w
		jsr	(Obj_ChesireBall_CheckItIsTimeToDie).l
                cmpi.b  #1,objoff_3E(a0)
                beq.s   .chase
		jsr	(Obj_ChesireBall_RunOnScr_Left).l
		jmp	(Obj_ChesireBall_RunOnScr_Right).l

.chase:
                jmp     (Obj_ChesireBall_100percentHit).l

Obj_LockBall_BounceAway:
		lea	(Player_1).w,a1
		move.w	$10(a0),d1
		move.w	$14(a0),d2
		sub.w	$10(a1),d1
		sub.w	$14(a1),d2
		jsr	(GetArcTan).w
		move.b	(Level_frame_counter).w,d1
		andi.w	#3,d1
		add.w	d1,d0
		jsr	(GetSineCosine).w
		muls.w	#-$600,d1
		asr.l	#8,d1
		move.w	d1,$18(a1)
		muls.w	#-$600,d0
		asr.l	#8,d0
		move.w	d0,$1A(a1)
		bset	#1,$2A(a1)
		bclr	#4,$2A(a1)
		bclr	#5,$2A(a1)
		clr.b	$40(a1)
		sfx	sfx_KnucklesKick

Obj_LockBall_Return:
		rts

; ===========================================================================

Obj_ChesireChain:
		move.l	#SME_IEpix,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$C,obHeight(a0)
		move.b	#$C,obWidth(a0)
		move.b	#$C,x_radius(a0)
		move.b	#$C,y_radius(a0)
		move.l	#Obj_ChesireChain_Move,(a0)
		rts

Obj_ChesireChain_WaveMotion:
		move.w	obParent(a0),a1
		move.w	obY(a1),d0
		sub.w	obY(a0),d0
		move.w	obSubtype(a0),d1
		asl.w	d1,d0
		move.w	d0,obVelY(a0)
		cmpi.b	#1,objoff_48(a1)
		bne.s	+
		clr.w	obParent(a0)
		clr.w	obParent2(a0)
		move.l	#Obj_ChesireChain_Fall,(a0)
+		rts

Obj_ChesireChain_Move:
		lea	(Ani_ChesireFantom).l,a1
		jsr	(Animate_Sprite).w
		jsr	(Obj_ChesireChain_WaveMotion).l
		jsr	(SpeedToPos).w
		jmp	(Draw_Sprite).w

Obj_ChesireChain_Fall:
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.w	++
		cmpi.b	#1,objoff_46(a0)
		bne.w	+
		move.w	#1,(Grounder_Alive).w
		fadeout					; fade out music
+		move.l	#Go_Delete_Sprite,(a0)
		rts

+		jmp	(Draw_Sprite).w

Obj_ChesireChain_Return:
		rts

; ---------------------------------------------------------------------------

obLDartsum_CheckXY:	; Размер координат 4x4(Размер спрайта ?x?)
		dc.w -32
		dc.w 64
		dc.w -32
		dc.w 64

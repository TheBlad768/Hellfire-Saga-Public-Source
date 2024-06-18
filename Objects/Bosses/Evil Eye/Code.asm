Obj_EvilEye:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_EvilEye_Index(pc,d0.w),d1
		jsr	Obj_EvilEye_Index(pc,d1.w)
		bsr.w	Obj_EvilEye_Process
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		jmp	(Obj_EvilEye_Display).l
; ===========================================================================

Obj_EvilEye_Index:
		dc.w Obj_EvilEye_Main-Obj_EvilEye_Index		; 0
		dc.w Obj_EvilEye_FlyOut-Obj_EvilEye_Index		; 2
		dc.w Obj_EvilEye_MoveLeft-Obj_EvilEye_Index		; 4
		dc.w Obj_EvilEye_MoveRight-Obj_EvilEye_Index		; 6
		dc.w Obj_EvilEye_ChangeGravitation1-Obj_EvilEye_Index		; 8
		dc.w Obj_EvilEye_ChangeGravitation11-Obj_EvilEye_Index
		dc.w Obj_EvilEye_ChangeGravitation2-Obj_EvilEye_Index
		dc.w Obj_EvilEye_ChangeGravitation201-Obj_EvilEye_Index
		dc.w Obj_EvilEye_ChangeGravitation3-Obj_EvilEye_Index
; ===========================================================================

Obj_EvilEye_Process:
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$33(a0)
		bne.s	.whatizit
		move.b	#$3C,$33(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit:
		moveq	#0,d0
		btst	#0,$33(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$33(a0)
		bne.s	.lacricium
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		bra.w	.lacricium

.gone:
	      	lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		move.w	#1,(Check_dead).w
		clr.w	(EvilEye_Event).w
		clr.w   (EvilEye_GravityEvent).w
		clr.b	GravityAngle.w			; toggle reverse gravity
		move.l	#Go_Delete_Sprite,(a0)

.lacricium:
		rts
; ===========================================================================
Obj_EvilEye_Display:
		move.b	$33(a0),d0
		beq.s	Obj_EvilEye_Animate
		lsr.b	#3,d0
		bcc.w	Obj_EvilEye_Return

Obj_EvilEye_Animate:
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================
Obj_EbilEye_ControlYSpd:
		move.w	obY(a0),d0
		sub.w	(Camera_y_pos).w,d0
		move.w	objoff_30(a0),d1

		cmp.w	d1,d0
		blt.w	+
		move.w	objoff_1C(a0),d1

		cmp.w	d1,d0
		bcc.w	++
		bra.w	Obj_EvilEye_Return
+	 	move.b	#1,objoff_46(a0)
		rts

+		clr.b	objoff_46(a0)
		rts


Obj_EbilEye_GainSpd:
		cmpi.b	#0,objoff_46(a0)
		beq.w	Obj_EbilEye_LoseSpd
		cmpi.w	#$200,obVelY(a0)
		bge.w	Obj_EvilEye_Return
		add.w	#$40,obVelY(a0)
		bra.w	Obj_EvilEye_Return

Obj_EbilEye_LoseSpd:
		cmpi.w	#-$200,obVelY(a0)
		ble.w	Obj_EvilEye_Return
		sub.w	#$40,obVelY(a0)
		bra.w	Obj_EvilEye_Return

Obj_EbilEye_Atk:
		sub.w	#1,obTimer(a0)
		bpl.w	+
		move.w	#18,obTimer(a0)
		move.b	routine(a0),objoff_44(a0)
		move.w	#1,(EvilEye_Event).w
		move.w	#0,obVelX(a0)
		move.b	#1,obAnim(a0)
		move.b	#8,routine(a0)
+		rts

Obj_EvilEye_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$C,obColType(a0)
		move.b	#$18,obHeight(a0)
		move.b	#$18,obWidth(a0)
		move.b	#$18,x_radius(a0)
		move.b	#$18,y_radius(a0)
		move.w	#-$400,obVelX(a0)
		move.w	#90,obTimer(a0)
		move.b	#$10,objoff_30(a0)

		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_EvilEye_HP(pc,d0.w),$29(a0)

		move.w	#-$600,obVelX(a0)
		move.b	#0,objoff_3E(a0)
		move.w	#0,(Grounder_Alive).w
		rts
; ---------------------------------------------------------------------------

Obj_EvilEye_HP:
		dc.b 12/2	; Easy
		dc.b 12		; Normal
		dc.b 12+6	; Hard
		dc.b 12+2	; Maniac
; ---------------------------------------------------------------------------

Obj_EvilEye_FlyOut:
		jsr	(Obj_EbilEye_Atk).l
		jsr	(SpeedToPos).w
		move.w	(Camera_x_pos).w,d0
		add.w	#$138,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w`	Obj_EvilEye_Return
		move.w	#90,obTimer(a0)
		move.w	#0,obVelX(a0)
		move.w	#$60,objoff_30(a0)
		move.w	#$80,objoff_1C(a0)
		addq.b	#2,routine(a0)

Obj_EvilEye_MoveLeft:
		jsr	(Obj_EbilEye_Atk).l
		jsr	(Obj_EbilEye_ControlYSpd).l
		jsr	(Obj_EbilEye_GainSpd).l
		cmpi.w	#-$200,obVelX(a0)
		ble.s	+
		sub.w	#$20,obVelX(a0)
+		jsr	(SpeedToPos).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$3F,d0
		bge.w	Obj_EvilEye_Return
		bchg	#0,obStatus(a0)
                addq.b	#2,routine(a0)


Obj_EvilEye_MoveRight:
		jsr	(Obj_EbilEye_Atk).l
		jsr	(Obj_EbilEye_ControlYSpd).l
		jsr	(Obj_EbilEye_GainSpd).l
		cmpi.w	#$200,obVelX(a0)
		bge.s	+
		add.w	#$20,obVelX(a0)
+		jsr	(SpeedToPos).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$F8,d0
		ble.w	Obj_EvilEye_Return
		bchg	#0,obStatus(a0)
                subq.b	#2,routine(a0)

Obj_EvilEye_ChangeGravitation1:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_EvilEye_Return
		cmpi.b	#0,objoff_3E(a0)
		beq.s	.fuckup
		lea	(Player_1).w,a1
		cmpi.b	#id_SpinDash,obAnim(a1)			; is Sonic Spin Dashing?
		bne.w	.skipdashcheck
		clr.b	spin_dash_flag(a1)
		clr.w	ground_vel(a1)

.skipdashcheck:
		bset	#7,object_control(a1)
		btst 	#1,$2A(a1)
		bne.s 	.rts
	;	clr.b	spin_dash_flag(a1)
		bclr 	#7,object_control(a1)
		move.w   #1,(EvilEye_GravityEvent).w
		add.b	#$80,GravityAngle.w		; toggle reverse gravity
		bpl.s	.abcd
		add.w	#$14,objoff_30(a0)
		add.w	#$14,objoff_1C(a0)
		bra.w	.cont

.abcd:
		sub.w	#$14,objoff_30(a0)
		sub.w	#$14,objoff_1C(a0)

.cont:
                addq.b	#2,routine(a0)
		rts

.fuckup:
                addq.b	#4,routine(a0)

.rts:
		rts

Obj_EvilEye_ChangeGravitation11:
		lea	(Player_1).w,a1
		tst.w	y_vel(a1)
		bne.w	+
		move.b	#id_Roll,anim(a1)
		rts
+               addq.b	#2,routine(a0)

Obj_EvilEye_ChangeGravitation2:
		lea	(Player_1).w,a1
		cmpi.b	#id_Roll,anim(a1)
		beq.s	.return
		cmpi.b	#id_Hurt,anim(a1)
		beq.s	.return
		move.w	#59,obTimer(a0)
		clr.w   (EvilEye_GravityEvent).w
                addq.b	#2,routine(a0)

.return:
		rts

Obj_EvilEye_ChangeGravitation201:
		sub.w	#1,obTimer(a0)
		bpl.w	.return
		move.w	#180,obTimer(a0)
                addq.b	#2,routine(a0)
		cmpi.b	#0,objoff_3E(a0)
		beq.w	.spawnmultistones
		cmpi.b	#1,objoff_3E(a0)
		beq.w	.spawnthunder
		cmpi.b	#2,objoff_3E(a0)
		beq.w	.spawnclones

.return:
		rts

.spawnthunder:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEye_Return
		move.l	#Obj_EvilEyeThunder,(a1)
		move.w	(Player_1+obX).w,obX(a1)
		move.w	(Camera_min_Y_pos).w,d0
		add.w	#$26,d0
		move.w	d0,obY(a1)
		add.b	#1,objoff_3E(a0)
		bra.w	Obj_EvilEye_Return

.spawnstones:
		add.b	#1,objoff_3E(a0)
		sfx	sfx_BreakBridge
		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEye_Return
		move.l	#Obj_EvilEyeStone,(a1)
		jsr	(RandomNumber).w
		andi.w	#296,d0
		add.w	(Camera_x_pos).w,d0
		move.w	d0,obX(a1)
		move.w	#-$600,obVelY(a1)
		move.w	(Camera_y_pos).w,d0
		add.w	#$F4,d0
		move.w	d0,obY(a1)
		bra.w	Obj_EvilEye_Return

.spawnmultistones:
		add.b	#1,objoff_3E(a0)
		cmpi.w	#1,(Grounder_Alive).w
		bne.s	.spawn
		move.w	#0,(Grounder_Alive).w
		move.w	#0,(EvilEye_StonesDeleted).w
		bra.w	Obj_EvilEye_Return

.spawn:
		move.w	#0,(EvilEye_StonesDeleted).w
		move.w	#1,(Grounder_Alive).w
		sfx	sfx_BreakBridge

		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEyeStone2_Return
		move.l	#Obj_EvilEyeStone2,(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		add.w	#$10,obX(a1)
		move.w	(Camera_y_pos).w,obY(a1)
		add.w	#$C0,obY(a1)
		move.b	#1,obSubtype(a1)


		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEyeStone2_Return
		move.l	#Obj_EvilEyeStone2,(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		add.w	#$40,obX(a1)
		move.w	(Camera_y_pos).w,obY(a1)
		add.w	#$C0,obY(a1)
		move.b	#2,obSubtype(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEyeStone2_Return
		move.l	#Obj_EvilEyeStone2,(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		add.w	#$80,obX(a1)
		move.w	(Camera_y_pos).w,obY(a1)
		add.w	#$C0,obY(a1)
		move.b	#3,obSubtype(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEyeStone2_Return
		move.l	#Obj_EvilEyeStone2,(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_x_pos).w,obX(a1)
		add.w	#$A0,obX(a1)
		move.w	(Camera_y_pos).w,obY(a1)
		add.w	#$C0,obY(a1)
		move.b	#4,obSubtype(a1)

		bra.w	Obj_EvilEye_Return

.spawnclones:
		clr.b	objoff_3E(a0)
		sfx	sfx_BreakBridge
		move.w	#2,(EvilEye_Event).w
		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEye_Return
		move.l	#Obj_EvilEyeClone,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Camera_y_pos).w,objoff_1C(a1)
		add.w	#$C0,objoff_1C(a1)
		move.w	#$400,obVelY(a1)
		bchg	#0,obStatus(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEye_Return
		move.l	#Obj_EvilEyeClone,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	(Camera_y_pos).w,objoff_1C(a1)
		add.w	#$20,objoff_1C(a1)
		move.w	#1,objoff_48(a1)
		move.w	obY(a0),d0
		move.w	#-$400,obVelY(a1)
		bchg	#0,obStatus(a1)

Obj_EvilEye_ChangeGravitation3:
		tst.w	(EvilEye_Event).w
		bne.w	Obj_EvilEye_Return
		move.b	#2,obAnim(a0)
		clr.w	obVelY(a0)
		move.b	objoff_44(a0),routine(a0)

Obj_EvilEye_Return:
		rts

Obj_EvilEyeStuff_CheckPapaDead:
		cmpi.w	#1,(Check_dead).w
		bne.s	+
		move.l  #Go_Delete_Sprite,(a0)
+		rts

Obj_EvilEyeThunder:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_EvilEyeThunder_Index(pc,d0.w),d1
		jsr	Obj_EvilEyeThunder_Index(pc,d1.w)
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		jmp	(Obj_EvilEyeeThunder_Display).l

Obj_EvilEyeThunder_Index:
		dc.w Obj_EvilEyeThunder_Main-Obj_EvilEyeThunder_Index
		dc.w Obj_EvilEyeThunder_TurnOnCol-Obj_EvilEyeThunder_Index
		dc.w Obj_EvilEyeThunder_LoadAnother-Obj_EvilEyeThunder_Index

Obj_EvilEyeeThunder_Display:
		move.w	objoff_46(a0),d0
		beq.s	Obj_EvilEyeeThunder_Animate
		lsr.b	#3,d0
		bcc.w	Obj_EvilEyeThunder_Return

Obj_EvilEyeeThunder_Animate:
		jmp	(Draw_And_Touch_Sprite).w

Obj_EvilEyeThunder_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obAnim(a0)
		move.w	#45,objoff_46(a0)
		bset	#Status_LtngShield,shield_reaction(a0)

		move.w	(Camera_y_pos).w,d0
		add.w	#$C0,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_EvilEyeThunder_Return

		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEyeThunder_Return
		move.l	#Obj_EvilEyeThunder,(a1)
		move.b	#1,objoff_3B(a0)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$20,obY(a1)
		move.w	obTimer(a0),obTimer(a1)


Obj_EvilEyeThunder_TurnOnCol:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		cmpi.b	#id_Hurt,Player_1+anim.w		; set player to the hurting animation
		beq.w	Obj_EvilEyeThunder_Delete
		sub.w	#1,objoff_46(a0)
		bpl.w	Obj_EvilEyeThunder_Return
		sfx	sfx_Signal
		move.w	#45,d0;obTimer(a0)
	;	move.b  obSubtype(a0),d1
	;	mulu.w	#6,d1
	;	sub.w	d1,d0
		move.w	d0,obTimer(a0)
		move.b	#$8A,obColType(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeThunder_LoadAnother:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		cmpi.b	#id_Hurt,Player_1+anim.w		; set player to the hurting animation
		beq.w	Obj_EvilEyeThunder_Delete
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_EvilEyeThunder_Return
		cmpi.b	#4,obSubtype(a0)
		beq.w	Obj_EvilEyeThunder_Delete
		add.b	#1,obSubtype(a0)
		clr.b	obColType(a0)
		move.w	#60,d0;objoff_46(a0)
		move.b  obSubtype(a0),d1
		mulu.w	#10,d1
		sub.w	d1,d0
		move.w	d0,objoff_46(a0)
		tst.b	objoff_3B(a0)
		beq.w	.newx
		move.w	(Player_1+obX).w,obX(a0)
		bra.w	.switchback

.newx:
		move.w	parent(a0),a1
		move.w	obX(a1),obX(a0)

.switchback:
		move.b	#2,routine(a0)
		rts

Obj_EvilEyeThunder_Delete:
		clr.w	(EvilEye_Event).w
		move.l  #Go_Delete_Sprite,(a0)


Obj_EvilEyeThunder_Return:
		rts

Obj_EvilEyeStone:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_EvilEyeStone_Index(pc,d0.w),d1
		jsr	Obj_EvilEyeStone_Index(pc,d1.w)
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_EvilEyeStone_Index:
		dc.w Obj_EvilEyeStone_Main-Obj_EvilEyeStone_Index
		dc.w Obj_EvilEyeStone_Move-Obj_EvilEyeStone_Index
		dc.w Obj_EvilEyeStone_Delt-Obj_EvilEyeStone_Index
		dc.w Obj_EvilEyeStone_Delt2-Obj_EvilEyeStone_Index

Obj_EvilEyeStone_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#5,obAnim(a0)
		move.b	#$9A,obColType(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)
		move.w	#30,obTimer(a0)

Obj_EvilEyeStone_Move:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_EvilEyeStone_Return
		cmpi.b	#6,obSubtype(a0)
		beq.w	+
		jsr	(SingleObjLoad2).w
		bne.w	Obj_EvilEyeStone_Return
		move.l	#Obj_EvilEyeStone,(a1)
		jsr	(RandomNumber).w
		andi.w	#296,d0
		add.w	(Camera_x_pos).w,d0
		move.w	d0,obX(a1)
		move.w	obVelY(a0),obVelY(a1)
		move.w	obY(a0),obY(a1)
		move.w	#30,obTimer(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		add.b	#1,obSubtype(a1)
+		addq.b	#2,routine(a0)

Obj_EvilEyeStone_Delt:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(SpeedToPos).w
		move.w	obY(a0),d0
		sub.w	(Camera_y_pos).w,d0
		cmpi.w	#$20,d0
		bcc.s	Obj_EvilEyeStone_Return
		addq.b	#2,routine(a0)
		move.b	#6,obAnim(a0)
		sfx	sfx_Pump
		move.w	#-$100,obVelY(a0)
		clr.b	obColType(a0)

Obj_EvilEyeStone_Delt2:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(ObjectFall).w
		jsr	(ChkObjOnScreen).w
		beq.w	Obj_EvilEyeStone_Return
		cmpi.b	#5,obSubtype(a0)
		ble.s	+
		clr.w	(EvilEye_Event).w
+		move.l  #Go_Delete_Sprite,(a0)

Obj_EvilEyeStone_Return:
		rts


Obj_EvilEyeStone3:
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#5,obAnim(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)
		move.w	#180,obTimer(a0)
		move.b	#0,objoff_3A(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)
		move.b	#$9A,obColType(a0)
		move.l	#Obj_EvilEyeStone3_Circular,(a0)

Obj_EvilEyeStone3_Circular:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		cmpi.b	#42,objoff_3A(a0)
		bcc.s	+
		addq.b	#2,objoff_3A(a0)
+		addi.b	#8,$3C(a0)			; ������.
		jsr	(MoveSprite_Circular).w	; ��������.
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		sub.w	#1,obTimer(a0)
		bpl.w	++
		cmpi.w	#1,(Grounder_Alive).w
		beq.w	++
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone4,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$100,obVelY(a1)
		tst.b	GravityAngle.w
		bpl.s	+
		neg.w	obVelY(a1)

+		move.l	#Go_Delete_Sprite,(a0)
+		jmp	(Draw_And_Touch_Sprite).w

Obj_EvilEyeStone2:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_EvilEyeStone2_Index(pc,d0.w),d1
		jsr	Obj_EvilEyeStone2_Index(pc,d1.w)
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_EvilEyeStone2_Index:
		dc.w Obj_EvilEyeStone2_Main-Obj_EvilEyeStone2_Index
		dc.w Obj_EvilEyeStone2_Wait-Obj_EvilEyeStone2_Index
		dc.w Obj_EvilEyeStone2_Move-Obj_EvilEyeStone2_Index

Obj_EvilEyeStone2_TimeToDie:
		move.w	parent3(a0),a1
		lea	obDatum2_Egg_CheckXY(pc),a2
		jsr	(Check_InMyRange).w
		beq.w	Obj_EvilEyeStone2_Return
		add.w	#1,(EvilEye_StonesDeleted).w
		cmpi.w	#4,(EvilEye_StonesDeleted).w
		bne.w	Obj_EvilEye2_Delete

		sfx	sfx_LaserBeam

		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#0,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)

+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#1,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)


+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#2,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)


+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#3,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)

+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#4,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)

+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#5,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)

+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#6,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)

+		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_EvilEyeStone3,(a1)
		move.b	#7,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w	objoff_30(a0),obX(a1)
		move.w	objoff_1C(a0),obY(a1)

+		clr.w	(EvilEye_Event).w

Obj_EvilEye2_Delete:
		move.l #Go_Delete_Sprite,(a0)
		rts

Obj_EvilEyeStone2_Main:
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#6,obAnim(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)
		addq.b	#2,routine(a0)
		move.w	parent3(a0),a1
		move.w	obX(a1),objoff_30(a0)
		move.w	obY(a1),objoff_1C(a0)
		rts

Obj_EvilEyeStone2_Wait:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_EvilEyeStone2_Return
		move.b	#5,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeStone2_Move:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(Obj_EvilEyeStone2_TimeToDie).l
		move.w	parent3(a0),a1
		jsr	(Find_OtherObject).w
		move.w	#$300,d0
		moveq	#$70,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w

Obj_EvilEyeStone2_Return:
		rts

Obj_EvilEyeStone4:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_EvilEyeStone4_Index(pc,d0.w),d1
		jsr	Obj_EvilEyeStone4_Index(pc,d1.w)
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

Obj_EvilEyeStone4_Index:
		dc.w Obj_EvilEyeStone4_Main-Obj_EvilEyeStone4_Index
		dc.w Obj_EvilEyeStone4_Move0-Obj_EvilEyeStone4_Index
		dc.w Obj_EvilEyeStone4_Move-Obj_EvilEyeStone4_Index
		dc.w Obj_EvilEyeStone4_Move2-Obj_EvilEyeStone4_Index

Obj_EvilEyeStone4_Main:
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#5,obAnim(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)
		move.b	#$9A,obColType(a0)
		move.w	#$10,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeStone4_Move0:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_EvilEyeStone4_Return
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#3,d0
		move.w	d0,obVelX(a0)
	;	move.w	#$300,obVelY(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeStone4_Move:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(ObjectFall).w
		jsr	(ChkObjOnScreen).w
		bne.w	+
		cmpi.w	#$17A,obY(a0)
		bge.w	+
	;	cmpi.w	#$D3,obY(a0)
	;	ble.w	+
		rts
+		clr.w	obVelX(a0)
		clr.b	obColType(a0)
		move.w	#-$200,obVelY(a0)
		sfx	sfx_Pump
		move.b	#6,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeStone4_Move2:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(ObjectFall).w
		jsr	(ChkObjOnScreen).w
		beq.s	Obj_EvilEyeStone4_Return
		clr.w	(EvilEye_Event).w
		move.l  #Go_Delete_Sprite,(a0)

Obj_EvilEyeStone4_Return:
		rts

Obj_EvilEyeClone:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_EvilEyeClone_Index(pc,d0.w),d1
		jsr	Obj_EvilEyeClone_Index(pc,d1.w)
		lea	(Ani_EvilEye).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================

Obj_EvilEyeClone_Index:
		dc.w Obj_EvilEyeClone_Main-Obj_EvilEyeClone_Index
		dc.w Obj_EvilEyeClone_WaitUntil-Obj_EvilEyeClone_Index
		dc.w Obj_EvilEyeClone_Move-Obj_EvilEyeClone_Index		;

Obj_EvilEyeClone_PalSwitch:
		cmpi.b	#1,objoff_3B(a0)
		beq.s	.up
		sub.w	#$2000,obGfx(a0)
		move.b	#1,objoff_3B(a0)
		bra.s	.ret

.up:
		add.w	#$2000,obGfx(a0)
		move.b	#0,objoff_3B(a0)

.ret:
		rts


Obj_EvilEyeClone_Main:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		move.b	#1,objoff_3B(a0)
		move.l	#Map_EvilEye,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$16,obHeight(a0)
		move.b	#$16,obWidth(a0)
		move.b	#$16,x_radius(a0)
		move.b	#$16,y_radius(a0)
		move.w	#30,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeClone_WaitUntil:
		jsr	(Obj_EvilEyeClone_LookOnSonic).l
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(Obj_EvilEyeClone_PalSwitch).l
		jsr	(SpeedToPos).w
		tst.w	objoff_48(a0)
		bne.s	+
		move.w	obY(a0),d0
		move.w	objoff_1C(a0),d1
		cmp.w	d0,d1
		ble.w	EvilEye_SetSpd
		rts
+		move.w	obY(a0),d0
		move.w	objoff_1C(a0),d1
		cmp.w	d0,d1
		bge.w	EvilEye_SetSpd
		rts

EvilEye_SetSpd:
		move.w	#-$500,obVelX(a0)
		tst.w	obStatus(a0)
		bne.s	+
		neg.w	obVelX(a0)
+		clr.w	obVelY(a0)
		move.b	#$8C,obColType(a0)
		bchg	#0,obStatus(a0)
		addq.b	#2,routine(a0)

Obj_EvilEyeClone_Move:
		jsr	(Obj_EvilEyeStuff_CheckPapaDead).l
		jsr	(Obj_EvilEyeClone_PalSwitch).l
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.s	Obj_EvilEyeClone_Return
		sub.w	#1,(EvilEye_Event).w
		move.l  #Go_Delete_Sprite,(a0)

Obj_EvilEyeClone_Return:
		rts

Obj_EvilEyeClone_LookOnSonic:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	+
		bclr	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bset	#0,obStatus(a0)
+		rts

obDatum2_Egg_CheckXY:	; ������ ��������� 4x4(������ ������� ?x?)
		dc.w -15
		dc.w 30
		dc.w -15
		dc.w 30

		include "Objects/Bosses/Evil Eye/Object data/Ani - Evil Eye.asm"
		include "Objects/Bosses/Evil Eye/Object data/Map - Evil Eye.asm"

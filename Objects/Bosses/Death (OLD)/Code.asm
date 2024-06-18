; ---------------------------------------------------------------------------
; TEST SCZ BOSS (maybe it will be death...)
; ---------------------------------------------------------------------------
Obj_Death:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Death_Index(pc,d0.w),d1
		jsr	Obj_Death_Index(pc,d1.w)
		jsr	Obj_Death_Process
		lea	(Ani_Death).l,a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_Death(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Obj_Death_AnimScan).l
; ============================================================================
Obj_Death_Index:
		dc.w Obj_Death_Main-Obj_Death_Index			; 0
		dc.w Obj_Death_IntroComingDown-Obj_Death_Index		;2
		dc.w Obj_Death_IntroComingRight-Obj_Death_Index		;4
		dc.w Obj_Death_WaitTillAimDisappear-Obj_Death_Index	;6
		dc.w Obj_Death_FlyLeftWithScythe-Obj_Death_Index	;8
		dc.w Obj_Death_FlyLeftAttack-Obj_Death_Index		;A
		dc.w Obj_Death_FlyRightWithScythe-Obj_Death_Index	;C
		dc.w Obj_Death_FlyRightAttack-Obj_Death_Index		;E
		dc.w Obj_Death_ThrowScytheCrescent-Obj_Death_Index	;10
		dc.w Obj_Death_Return-Obj_Death_Index			;1C
		dc.w Obj_Death_SummonScytheSpin-Obj_Death_Index		;1E
		dc.w Obj_Death_Retreat-Obj_Death_Index			;20
		dc.w Obj_Death_SpawnSkulls-Obj_Death_Index		;22
		dc.w Obj_Death_NewIteration-Obj_Death_Index		;
; ===========================================================================

Obj_Death_Process:
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$4B,$1C(a0)
		move.b	#0,obColType(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$1C(a0)
		bne.s	.lacricium
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		bra.w	.lacricium


.gone:
		move.b  #$01,(Check_GluttonyDead).w
		move.w	#1,(AstarothCompleted).w
		samp	sfx_AstarothDeath
		jsr	(Obj_KillBloodCreate).l
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.contg
		move.b	#8,$2C(a1)

.contg:
		move.l	#loc_85088,(a0)

.lacricium:
		rts
; ===========================================================================

Obj_Death_AnimScan:
		cmpi.b	#$16,routine(a0)
		beq.w	Obj_Death_PalTransfuse
		cmpi.b	#$1E,routine(a0)
		beq.w	Obj_Death_PalTransfuse
		btst   	#6,$2A(a0)
		bne.s  	+
		moveq	#0,d0
		move.b 	obAnim(a0),d0
		move.b 	Obj_Death_Data_Collision(pc,d0.w),d1
		move.b 	d1,obColType(a0)
+	        move.b	$1C(a0),d0
		beq.s	+
		lsr.b	#3,d0
		bcc.w	Obj_Death_Return
+		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------
Obj_Death_Data_Collision:
		dc.b  $C
		dc.b  $C
		dc.b  $12
		dc.b  $92
		dc.b  $C
		dc.b  $C
		dc.b  $C
		dc.b  $12
		dc.b  $92
		dc.b  $92

Obj_Death_ProduceDI:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		jsr	(SingleObjLoad).w
		bne.s	+
		move.l	#Obj_Death_Shadow,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
+		rts

Obj_Death_PalTransfuse:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#$14,d0
		bne.w	.return
		cmpi.b	#2,objoff_47(a0)
		beq.s	.clear
		add.b	#1,objoff_47(a0)
		bra.s	.loadpal

.clear:
		clr.b	objoff_47(a0)

.loadpal:	
		cmpi.b	#0,objoff_47(a0)
		beq.s	.orange
		cmpi.b	#1,objoff_47(a0)
		beq.w	.green
		bra.w	.return

.orange:
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#7,subtype(a1)
		move.l	#Pal_Death,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
		move.w	#16-1,$38(a1)
		bra.s	.return

.green:
		jsr	(Create_New_Sprite).w
		bne.s	.return
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#7,subtype(a1)
		move.l	#Pal_DeathGreen,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
		move.w	#16-1,$38(a1)

.return:
		jmp	(Draw_Sprite).w
; ===========================================================================
Obj_Death_HP:
		dc.b 10/2	; Easy
		dc.b 10		; Normal
		dc.b 10+6	; Hard
		dc.b 10+6	; Maniac

Obj_Death_Main:
		lea	ObjDat4_Death(pc),a1
		jsr	SetUp_ObjAttributes
		st	$3A(a0)					; set current frame as invalid
  		move.b	#0,obSubtype(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	Obj_Death_HP(pc,d0.w),$29(a0)
		move.w	#$300,obVelY(a0)
		move.w	#$200,obVelX(a0)
		bchg	#0,obStatus(a0)
		move.b	#2,obAnim(a0)

Obj_Death_IntroComingDown:
		jsr	(MoveSprite2).w
		sub.w	#$10,obVelY(a0)
		add.w	#$B,obVelX(a0)
		cmpi.w	#$400,obVelX(a0)
		blt.w	Obj_Death_Return
		clr.w	obVelY(a0)
		addq.b	#2,obRoutine(a0)

Obj_Death_IntroComingRight:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(MoveSprite2).w
		move.w	(Camera_x_pos).w,d0
		add.w	#$198,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Death_Return
		clr.w   obVelX(a0)
		clr.w   obVelY(a0)

		sfx	sfx_Switch,0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
		move.b	#$10,subtype(a1)			; Jump|Art ID nibble
		move.w	#$11F,$42(a1)			; Xpos
		move.w	#$90,$44(a1)			; Ypos
		move.w	#$5A,$2E(a1)			; Timer
		move.w	#$8400,art_tile(a1)			; VRAM

		move.w	#$5A,obTimer(a0)
		bchg	#0,obStatus(a0)
		addq.b	#2,obRoutine(a0)

Obj_Death_WaitTillAimDisappear:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Death_Return
		move.w	#$3C,obTimer(a0)
		move.b	#8,obAnim(a0)
		move.w	(Camera_y_pos).w,d0
		add.w	#$90,d0
		move.w	d0,obY(a0)
		move.w  #-$600,obVelX(a0)
		addq.b	#2,obRoutine(a0)

Obj_Death_FlyLeftWithScythe:
		jsr	(Obj_Produce_AfterImage).l
		jsr	(Find_Sonic).w
		move.w	#$100,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectYOnly).l
		jsr	(MoveSprite2).w
		move.w	obX(a0),d0
		move.w	(Player_1+obX).w,d1
		add.w	#$F,d1
		cmp.w	d0,d1
		blt.w  	Obj_Death_Return
		move.b	#3,obAnim(a0)
		samp	sfx_WalkingArmorAtk
		addq.b	#2,obRoutine(a0)

Obj_Death_FlyLeftAttack:
		sub.w	#2,obVelX(a0)
		jsr	(Obj_Produce_AfterImage).l
		sub.w	#2,obVelY(a0)
		jsr	(MoveSprite2).w
		move.w	(Camera_x_pos).w,d0
		sub.w	#$28,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_Death_Return
		addq.b	#2,obRoutine(a0)
		clr.w	obVelY(a0)
		neg.w   obVelX(a0)
		move.b	#8,obAnim(a0)

		sfx	sfx_Switch,0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
		move.b	#$10,subtype(a1)			; Jump|Art ID nibble
		move.w	#$20,$42(a1)			; Xpos
		move.w	#$90,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$8400,art_tile(a1)			; VRAM
		move.w	(Camera_y_pos).w,d0
		add.w	#$90,d0
		move.w	d0,obY(a0)

		move.w	#$3C,obTimer(a0)
		bchg	#0,obStatus(a0)

Obj_Death_FlyRightWithScythe:
		cmpi.w	#0,obTimer(a0)
		beq.s	+
		sub.w	#1,obTimer(a0)
		rts
+		jsr	(Obj_Produce_AfterImage).l
		jsr	(Find_Sonic).w
		move.w	#$100,d0
		moveq	#$10,d1
		jsr	(Chase_ObjectYOnly).l
		jsr	(MoveSprite2).w
		move.w	obX(a0),d0
		move.w	(Player_1+obX).w,d1
		sub.w	#$F,d1
		cmp.w	d0,d1
		bcc.w  	Obj_Death_Return
		move.b	#3,obAnim(a0)
		samp	sfx_WalkingArmorAtk
		addq.b	#2,obRoutine(a0)

Obj_Death_FlyRightAttack:
		add.w	#2,obVelX(a0)
		jsr	(Obj_Produce_AfterImage).l
		sub.w	#2,obVelY(a0)
		jsr	(MoveSprite2).w
		move.w	(Camera_x_pos).w,d0
		add.w	#$198,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Death_Return
		clr.w   obVelX(a0)
		clr.w   obVelY(a0)
		move.w	#$3C,obTimer(a0)
		move.w	(Camera_min_x_pos).w,objoff_12(a0)
		clr.w	obVelY(a0)
		move.w	(Camera_y_pos).w,d0
		add.w	#$9F,d0
		move.w	d0,obY(a0)
		clr.w	objoff_16(a0)
		move.b	#5,obAnim(a0)

		move.w  #-$400,obVelX(a0)

		move.w	(Camera_y_pos).w,d0
		add.w	#$60,d0
		move.w	d0,obY(a0)
		bchg	#0,obStatus(a0)

	;	jsr	(SingleObjLoad2).w
	;	bne.w	Obj_Death_Return
	;	move.l	#Obj_DeathAim,(a1)
	;	move.b	#7,obAnim(a1)
	;	move.w	(Camera_x_pos).w,d0
	;	add.w	#$11C,d0
	;	move.w	d0,objoff_12(a1)
	;	move.w	(Camera_y_pos).w,d0
	;	add.w	#$70,d0
	;	move.w	d0,objoff_16(a1)
	;	move.w	#$3C,obTimer(a1)
		sfx	sfx_Switch,0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
		move.b	#$10,subtype(a1)			; Jump|Art ID nibble
		move.w	#$11C,$42(a1)			; Xpos
		move.w	#$60,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$8400,art_tile(a1)			; VRAM

		move.w	#$3C,obTimer(a0)
		addq.b	#2,obRoutine(a0)

Obj_Death_ThrowScytheCrescent:
		cmpi.w	#0,obTimer(a0)
		beq.s	+
		sub.w	#1,obTimer(a0)
		rts
+		jsr	(MoveSprite2).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w`	#$11C,d0
		bcc.w	Obj_Death_Return
		clr.w	objoff_12(a0)
		clr.w	obVelY(a0)
		clr.w	obVelX(a0)
		move.b	#6,obAnim(a0)

		move.w	(Player_1+obX).w,d0
		move.w	d0,objoff_12(a0)

		move.w	#$3C,obTimer(a0)
		clr.w	(Scythes_Throwed).w

		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheSpinFall,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$100,obVelY(a1)
		sub.w	#$2F,obY(a1)
		move.w	objoff_12(a0),objoff_12(a1)
		move.w	a0,parent3(a1)
		addq.b	#2,obRoutine(a0)
		rts

Obj_Death_SummonScytheSpin:
		;sub.w	#1,obTimer(a0)
		;bpl.w	Obj_Death_Return

		;cmpi.b	#5,objoff_45(a0)
		;bcc.w	+

		;jsr	(SingleObjLoad2).w
		;bne.w	Obj_Death_Return
		;move.l	#Obj_DeathAim,(a1)
		;move.b	#1,obAnim(a1)
		;move.w	#1,obSubtype(a1)
		;move.w  (Player_1+obX).w,obX(a1)
		;move.w	(Camera_min_y_pos).w,d0
		;add.w	#$DF,d0
		;move.w	d0,obY(a1)
		;move.w  #-$800,obVelY(a1)
		;move.w	#$5A,obTimer(a1)

;+		move.w	#$5A,obTimer(a0)
		;add.b	#1,objoff_45(a0)
		cmpi.w	#4,(Scythes_Throwed).w
		blt.w	Obj_Death_Return
		move.w  #$100,obVelX(a0)
		addq.b	#2,obRoutine(a0)

Obj_Death_Retreat:
		add.w   #8,obVelX(a0)
		jsr	(Obj_Produce_AfterImage).l
		jsr	(MoveSprite2).w
		move.w	(Camera_x_pos).w,d0
		add.w	#$198,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Death_Return
		clr.w   obVelX(a0)
		clr.w   obVelY(a0)
		move.w	#$B1,obTimer(a0)
		clr.w	objoff_16(a0)
		addq.b	#2,obRoutine(a0)

		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathAim,(a1)
		move.w  a0,parent3(a1)
		move.b	#3,obAnim(a1)
		move.w	#2,obSubtype(a1)
		move.w	(Camera_x_pos).w,d0
		add.w	#$AF,d0
		move.w	d0,obX(a1)
		move.w	(Camera_y_pos).w,d0
		add.w	#$60,d0
		move.w	d0,obY(a1)
		move.b	#$F,objoff_49(a1)
		move.b	#$2D,objoff_48(a1)
		move.w	#$168,obTimer(a1)
		move.w	#$168,obTimer(a0)

Obj_Death_SpawnSkulls:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Death_Return
		clr.w	objoff_16(a0)
		clr.w	objoff_12(a0)

		move.w	#$3C,obTimer(a0)
		addq.b	#2,obRoutine(a0)

Obj_Death_NewIteration:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Death_Return
		move.w	#$3C,obTimer(a0)
	;	jsr	(SingleObjLoad2).w
	;	bne.w	Obj_Death_Return
	;	move.l	#Obj_DeathAim,(a1)
	;	move.b	#7,obAnim(a1)
	;	move.w	(Camera_x_pos).w,d0
	;	add.w	#$11F,d0
	;	move.w	d0,objoff_12(a1)
	;	move.w	(Camera_y_pos).w,d0
	;	add.w	#$B0,d0
	;	move.w	d0,objoff_16(a1)
	;	move.w	#$3C,obTimer(a1)

		sfx	sfx_Switch,0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
		move.b	#$10,subtype(a1)			; Jump|Art ID nibble
		move.w	#$11F,$42(a1)			; Xpos
		move.w	#$90,$44(a1)			; Ypos
		move.w	#$3C,$2E(a1)			; Timer
		move.w	#$8400,art_tile(a1)			; VRAM
		clr.b	objoff_47(a0)
		clr.b	$1C(a0)

		jsr	(Create_New_Sprite).w
		bne.s	Obj_Death_Return
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#2,subtype(a1)
		move.l	#Pal_Death,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
		move.w	#16-1,$38(a1)

		move.b	#6,obRoutine(a0)

Obj_Death_Return:
		rts

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON
; ---------------------------------------------------------------------------
Obj_DeathScytheSpin:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScytheSpin_Index(pc,d0.w),d1
		jsr	Obj_DeathScytheSpin_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_DeathScytheSpin_Display).l

Obj_DeathScytheSpin_Index:
		dc.w Obj_DeathScytheSpin_Main-Obj_DeathScytheSpin_Index
		dc.w Obj_DeathScytheSpin_PopUp-Obj_DeathScytheSpin_Index
		dc.w Obj_DeathScytheSpin_FallDown-Obj_DeathScytheSpin_Index
		dc.w Obj_DeathScytheSpin_Stuck-Obj_DeathScytheSpin_Index

Obj_DeathScytheSpin_Display:
		cmpi.b	#6,routine(a0)
		bne.s	+
		move.b	obTimer(a0),d0
		lsr.b	#3,d0
		bcc.w	Obj_DeathScytheSpin_Return
+  		jmp	(Child_DrawTouch_Sprite).w


Obj_DeathScytheSpin_Main:
		move.w	#-$700,obVelY(a0)
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8410,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$2E|$80,obColType(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)
		move.b	#1,obAnim(a0)

Obj_DeathScytheSpin_PopUp:
		jsr	(ObjectFall).w
		move.w	obVelY(a0),d0
		cmpi.w	#-$100,d0
		blt.w	Obj_DeathScytheSpin_Return
		addq.b	#2,routine(a0)
		rts

Obj_DeathScytheSpin_FallDown:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_DeathScytheSpin_Return
		add.w	#$1A,obY(a0)
		clr.b	obColType(a0)
		move.b	#2,obAnim(a0)
		move.w	#$410,obGfx(a0)
		move.b	#$12,obTimer(a0)

		cmpi.w  #3,(Scythes_Throwed).w
                bcc.s   +
		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathAim,(a1)
		move.w	parent3(a0),parent3(a1)
		move.b	#1,obAnim(a1)
		move.w	#1,obSubtype(a1)
		move.w  (Player_1+obX).w,obX(a1)
		move.w	(Camera_max_y_pos).w,d0
		add.w	#$DF,d0
		move.w	d0,obY(a1)
		move.w  #-$600,obVelY(a1)
		move.w	#$3C,obTimer(a1)

+		addq.b	#2,routine(a0)

Obj_DeathScytheSpin_Stuck:
		sub.b	#1,obTimer(a0)
		bpl.s	Obj_DeathScytheSpin_Return
		move.b	#$2E|$80,obColType(a0)
		sfx	sfx_BreakBridge
		add.w	#1,(Scythes_Throwed).w
		move.l	#Go_Delete_Sprite,address(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		lea	ChildObjDat_DeathRadiusExplosion(pc),a2
		jmp	(CreateChild6_Simple).w


Obj_DeathScytheSpin_Return:
		rts

ChildObjDat_DEZExplosion22:
		dc.w 1-1
		dc.l Obj_DEZExplosion

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON 3
; ---------------------------------------------------------------------------
Obj_DeathAim:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathAim_Index(pc,d0.w),d1
		jsr	Obj_DeathAim_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_DeathAim_Display).l

Obj_DeathAim_Index:
		dc.w Obj_DeathAim_Main-Obj_DeathAim_Index
		dc.w Obj_DeathAim_TickTock-Obj_DeathAim_Index

Obj_DeathAim_Display:
		move.w	obTimer(a0),d0
		lsr.w	#3,d0
		bcc.w	+
		jmp	(Child_Draw_Sprite).w
+		rts

Obj_DeathAim_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$410,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)


		cmpi.w	#1,obSubtype(a0)
		beq.w	+

		sfx	sfx_Switch,0

+		cmpi.w	#3,obSubtype(a0)
		bne.w	+
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.w	Obj_Death_Return
		move.b	#$02,subtype(a1)			; Jump|Art ID nibble
		move.w	#-4,$42(a1)			; Xpos
		move.w	#0,$44(a1)			; Ypos
		move.w	#$8400,art_tile(a1)			; VRAM
		move.w	obTimer(a0),d0			; \
		move.w	d0,$2E(a1)			; / Timer
+		rts

Obj_DeathAim_TickTock:
		cmpi.w	#1,obSubtype(a0)
		beq.w	Obj_DeathAim_OtherXway
		cmpi.w	#2,obSubtype(a0)
		beq.w	Obj_DeathAim_FollowSonic
		move.w	objoff_12(a0),obX(a0)
		move.w	objoff_16(a0),obY(a0)
		bra.w	Obj_DeathAim_TikTokContinue

Obj_DeathAim_OtherXway:
		jsr	(ObjectFall).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DeathAim_Return

		samp	sfx_WalkingArmorAtk
		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathScytheSpin,(a1)
		move.w  parent3(a0),parent3(a1)
		move.w	obX(a0),obX(a1)
		move.w	(Camera_max_y_pos).w,d0
		add.w	#$DF,d0
		move.w	d0,obY(a1)
		move.l	#loc_85088,(a0)
		rts

Obj_DeathAim_FollowSonic:
		cmpi.b	#0,objoff_49(a0)
		beq.s	+
		sub.b	#1,objoff_49(a0)
		bpl.w	Obj_DeathAim_TikTokContinue
		rts
+		jsr	(MoveSprite2).w
		sub.b	#1,objoff_48(a0)
		bpl.w	Obj_DeathAim_TikTokContinue

		jsr	(SingleObjLoad).w
		bne.w	Obj_DeathAim_Return
		move.l	#Obj_DeathSkull,(a1)
		move.b  #0,obSubtype(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obX(a0),d1
		move.w	(Player_1+obX).w,d0
		sub.w	d1,d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		move.w	(Camera_y_pos).w,d0
		add.w	#$CF,d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a1)

		jsr	(RandomNumber).w
		andi.w	#$FF,d0
		add.w	#$180,d0
		move.w	d0,obVelX(a0)

		jsr	(RandomNumber).w
		andi.w	#$30,d0
		add.w	#$30,d0
		move.w	d0,obVelY(a0)

		move.w	obX(a0),d0
	
		move.w	(Camera_x_pos).w,d1
		add.w	#$97,d1

		cmp.w	d1,d0
		blt.s	+
		neg.w	obVelX(a0)
+		move.w	obY(a0),d0
		sub.w	(Camera_y_pos).w,d0
		cmpi.w	#$6F,d0
		blt.s	+
		neg.w	obVelY(a0)
+		move.b	#$2D,objoff_48(a0)
		move.b	#$F,objoff_49(a0)


Obj_DeathAim_TikTokContinue:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DeathAim_Return

.delete:
		move.l	#loc_85088,(a0)

Obj_DeathAim_Return:
		rts

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON 4
; ---------------------------------------------------------------------------

Obj_DeathScytheSpinFall:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathScytheSpinFall_Index(pc,d0.w),d1
		jsr	Obj_DeathScytheSpinFall_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_DeathScytheSpinFall_Display).l

Obj_DeathScytheSpinFall_Index:
		dc.w Obj_DeathScytheSpinFall_Main-Obj_DeathScytheSpinFall_Index
		dc.w Obj_DeathScytheSpinFall_Fall-Obj_DeathScytheSpinFall_Index

Obj_DeathScytheSpinFall_Display:
		move.w	obTimer(a0),d0
		lsr.w	#3,d0
		bcc.w	Obj_DeathScytheSpinFall_Return
		jmp	(Child_Draw_Sprite).w


Obj_DeathScytheSpinFall_Main:
		addq.b	#2,routine(a0)
		move.b	#$FF,obTimer(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8410,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$24,obHeight(a0)
		move.b	#$24,obWidth(a0)
		move.b	#$24,x_radius(a0)
		move.b	#$24,y_radius(a0)
		move.b	#1,obAnim(a0)

Obj_DeathScytheSpinFall_Fall:
		add.w	#1,obTimer(a0)
		jsr	(ObjectFall).w
		jsr	(ChkObjOnScreen).w
		beq.s	Obj_DeathScytheSpinFall_Return
		move.w	parent3(a0),a1
		addq.b	#2,routine(a1)
		sfx	sfx_Switch,0
		jsr	(SingleObjLoad).w
		bne.w	Obj_Death_Return
		move.l	#Obj_DeathAim,(a1)
		move.b	#1,obAnim(a1)
		move.w	#1,obSubtype(a1)
		move.w	parent3(a0),parent3(a1)
		move.w  (Player_1+obX).w,obX(a1)
		move.w	(Camera_max_y_pos).w,d0
		add.w	#$DF,d0
		move.w	d0,obY(a1)
		move.w  #-$600,obVelY(a1)
		move.w	#$4B,obTimer(a1)

		move.l	#loc_85088,(a0)

Obj_DeathScytheSpinFall_Return:
		rts

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON 5
; ---------------------------------------------------------------------------
Obj_DeathSkull:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_DeathSkull_Index(pc,d0.w),d1
		jsr	Obj_DeathSkull_Index(pc,d1.w)
		lea	Ani_DeathScythe(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite).w

Obj_DeathSkull_Index:
		dc.w Obj_DeathSkull_Main-Obj_DeathSkull_Index
		dc.w Obj_DeathSkull_Fly1-Obj_DeathSkull_Index
		dc.w Obj_DeathSkull_Fly2-Obj_DeathSkull_Index

Obj_DeathSkull_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$410,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#4,obAnim(a0)

Obj_DeathSkull_Fly1:
		jsr	(MoveSprite2).w
		cmpi.b	#5,obAnim(a0)
		bne.s	Obj_DeathSkull_Return
		move.w	#$8410,obGfx(a0)
		move.w	#$12,obTimer(a0)
		move.b	#$8C,obColType(a0)
		addq.b	#2,routine(a0)

Obj_DeathSkull_Fly2:
		jsr	(MoveSprite2).w
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_DeathSkull_Return
		sfx	sfx_BreakBridge
		lea	ChildObjDat_DeathRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#loc_85088,(a0)

Obj_DeathSkull_Return:
		rts

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON 6
; ---------------------------------------------------------------------------

Obj_DeathRadiusExplosion:
		moveq	#0,d2
		move.w	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_DeathRadiusExplosion_GetVelocity,address(a1)
		move.l	#Map_Explosion,mappings(a1)
		move.w	#$85A8,art_tile(a1)
		tst.b	$40(a0)
		beq.s	+
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$85A8,art_tile(a1)
+		move.b	#4,render_flags(a1)
		move.w	#$80,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	#$8B,obColType(a0)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d2,angle(a1)
		move.b	#3,anim_frame_timer(a1)
		addi.w	#$20,d2
		dbf	d1,-
+		bra.s	DeathExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DeathRadiusExplosion_GetVelocity:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$200,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		move.l	#Obj_DeathRadiusExplosion_Anim,address(a0)

Obj_DeathRadiusExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.s	DeathExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DeathExplosion_Delete:
		move.l	#Delete_Current_Sprite,address(a0)
		rts

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON 7
; ---------------------------------------------------------------------------
Obj_Death_Shadow:
		bset    #0,obStatus(a0)
		move.l 	#Map_Death,obMap(a0)
		move.w 	#$23D0,obGfx(a0)
		move.b 	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)
		move.w	#8,obTimer(a0)
		move.l  #Obj_Death_Shadow_Delete,(a0)

Obj_Death_Shadow_Delete:
		move.w	parent3(a0),a1
		cmpi.b	#8,routine(a1)
		beq.s	+
		cmpi.b	#$A,routine(a1)
		beq.s	+
		cmpi.b	#$12,routine(a1)
		beq.s	+
		cmpi.b	#$1A,routine(a1)
		beq.s	+
		cmpi.b	#$20,routine(a1)
		beq.s	+
		lea	(Ani_Death).l,a1
		jsr    	(AnimateSprite).w
+		move.w	parent3(a0),a1
		move.w	obFrame(a1),obFrame(a0)
		move.w	obStatus(a1),obStatus(a0)
		jsr	(Obj_Death_Shadow_Display).l
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_Death_Shadow_Return
		move.l	#Delete_Current_Sprite,address(a0)

Obj_Death_Shadow_Display:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#3,d0
		bne.s	Obj_Death_Shadow_Return
		jmp	(Draw_Sprite).w

Obj_Death_Shadow_Return:
		rts

; ---------------------------------------------------------------------------
; TEST SCZ BOSS'S WEAPON 8
; ---------------------------------------------------------------------------
Obj_Falx:
		move.l	#Map_Scythe,obMap(a0)
		move.w	#$8410,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$8E,obColType(a0)
		move.b	#6,obAnim(a0)

	;	moveq	#0,d0
	;	move.b	objoff_48(a0),d0
	;	lsl.b	#5,d0
	;	move.b	d0,$3C(a0)

		move.l  #Obj_Falx_Rotate,(a0)

Obj_Falx_Rotate:
		cmpi.b	#42,objoff_3A(a0)
		bcc.s	.rotate
		addq.b	#2,objoff_3A(a0)

.rotate:
		lea	(Ani_DeathScythe).l,a1
		jsr	(AnimateSprite).w

		cmpi.b	#42,objoff_3A(a0)
		blt.s	.move
		move.w	parent3(a0),a1
		cmpi.b	#$1E,routine(a1)
		bne.s	.delete
		move.b	objoff_45(a1),d0
		mulu.w	#4,d0
		addi.b	d0,$3C(a0)			; ������.

.move:
		jsr	(MoveSprite_Circular).w	; ��������.
		jmp	(Draw_And_Touch_Sprite).w
		rts

.delete:
		move.l	#Obj_Explosion,(a0)
		rts

DPLCPtr_Death:	dc.l ArtUnc_Death>>1, DPLC_Death

ObjDat4_Death:
		dc.l Map_Death			; Mapping
		dc.w $23D0			; VRAM
		dc.w $300			; Priority
		dc.b 38/2			; Width	(64/2)
		dc.b 38/2			; Height(64/2)
		dc.b 0				; Frame
		dc.b $C				; Collision

Obj_DeathScytheCrescent_CheckXY:	; ������ ��������� 4x4(������ ������� ?x?)
		dc.w -32
		dc.w 64
		dc.w -32
		dc.w 64

ChildObjDat_DeathRadiusExplosion:
		dc.w 1-1
		dc.l Obj_DeathRadiusExplosion

		include "Objects/Bosses/Death/Object data/Ani - Death.asm"
		include "Objects/Bosses/Death/Object data/Map - Death.asm"
		include "Objects/Bosses/Death/Object data/Ani - Scythe.asm"
		include "Objects/Bosses/Death/Object data/Map - Scythe.asm"
		include "Objects/Bosses/Death/Object data/DPLC - Death.asm"
; ---------------------------------------------------------------------------
; Honey the Hell girl,boss in SCZ1
; ---------------------------------------------------------------------------

Obj_Honey:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_Index(pc,d0.w),d1
		jsr	Obj_Honey_Index(pc,d1.w)
		bsr.w	Obj_Honey_Process
		lea	(Ani_Honey).l,a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Honey_Display).l
; ===========================================================================

Obj_Honey_Index:
		dc.w Obj_Honey_Main-Obj_Honey_Index		;0
		dc.w Obj_Honey_CheckIntro-Obj_Honey_Index	;2
		dc.w Obj_Honey_AfterJump-Obj_Honey_Index	;4
		dc.w Obj_Honey_CastShadow-Obj_Honey_Index	;6
		dc.w Obj_Honey_Return-Obj_Honey_Index		;8
		dc.w Obj_Honey_PrepareToTakeOff-Obj_Honey_Index	;A
		dc.w Obj_Honey_MoveLeft-Obj_Honey_Index		;C
		dc.w Obj_Honey_MoveRight-Obj_Honey_Index	;E
		dc.w Obj_Honey_TakeOff-Obj_Honey_Index		;10
		dc.w Obj_Honey_SetWarning-Obj_Honey_Index	;12
		dc.w Obj_Honey_WaitWarning-Obj_Honey_Index	;14
		dc.w Obj_Honey_FireHeartMissiles-Obj_Honey_Index	;16
		dc.w Obj_Honey_NextRound-Obj_Honey_Index		;18
		dc.w Obj_Honey_SlowDown-Obj_Honey_Index		;1A
		dc.w Obj_Honey_WaitIntro-Obj_Honey_Index	;1C
		dc.w Obj_Honey_WaitDeathLeave-Obj_Honey_Index	;1E
		dc.w Obj_Honey_WaitDeathLeave2-Obj_Honey_Index	;20
; ===========================================================================
; Special piece of code that controls boss's tactical retreat when she got hurt during 3rd attack

Obj_Honey_Retreat:
		moveq	#0,d0
		move.b	objoff_31(a0),d0
		move.w	Obj_Honey_Retreat_Index(pc,d0.w),d1
		jmp	Obj_Honey_Retreat_Index(pc,d1.w)

Obj_Honey_Retreat_Index:
		dc.w Obj_Honey_Retreat_Return-Obj_Honey_Retreat_Index
		dc.w Obj_Honey_Retreat_MoveUp-Obj_Honey_Retreat_Index
		dc.w Obj_Honey_Retreat_Timer-Obj_Honey_Retreat_Index
		dc.w Obj_Honey_Retreat_MoveDown-Obj_Honey_Retreat_Index

Obj_Honey_Retreat_MoveUp:
		move.w	obY(a0),d0
		sub.w	(Camera_target_max_y_pos).w,d0
		cmpi.w	#$18,d0
		bcc.w	Obj_HoneyShadow_Return
		move.w	#$F0,obTimer(a0)
		clr.w	obVelY(a0)
		addq.b	#2,objoff_31(a0)

Obj_Honey_Retreat_Timer:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Honey_Retreat_Return
		move.w	#$80,obVelY(a0)
		addq.b	#2,objoff_31(a0)

Obj_Honey_Retreat_MoveDown:
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$38,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Honey_Return
		move.b	#0,objoff_31(a0)

Obj_Honey_Retreat_Return:
		jsr 	(Swing_UpAndDown).w
		rts
; ===========================================================================

Obj_Honey_Display:
		move.b	$33(a0),d0
		beq.s	Obj_Honey_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Honey_Display_RTS

Obj_Honey_Animate:
		jmp	(Draw_And_Touch_Sprite).w

Obj_Honey_Display_RTS:
		rts
; ===========================================================================

Obj_Honey_Process:
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.w   .gone
		tst.b   $33(a0)
		bne.s   .whatizit
		move.b  #$78,$33(a0)
		samp	sfx_HoneyHurt
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)
		cmpi.b	#$A,routine(a0)
		beq.s	.setretreatment
		cmpi.b	#$C,routine(a0)
		beq.s	.setretreatment
		cmpi.b	#$E,routine(a0)
		beq.s	.setretreatment
		bra.s	.whatizit

.setretreatment:
		move.b	#2,objoff_31(a0)
		move.w	#-$80,obVelY(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$33(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b  #1,$33(a0)
		bne.s   .lacricium
		bclr    #6,$2A(a0)
		move.b  $25(a0),$28(a0)
		bra.s	.lacricium

.gone:
		bset	#7,status(a0)
		lea 	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr 	(CreateChild6_Simple).w
		bne.s	.lacricium
		st	$40(a1)
		samp	sfx_HoneyDeath
		jsr	(Obj_HurtBloodCreate).l
		move.l	#Go_Delete_Sprite,(a0)
		move.b	#$1E,(Dynamic_resize_routine).w

.lacricium:
		rts

; ===========================================================================
Obj_Honey_HP:
		dc.b 10/2	; Easy
		dc.b 10		; Normal
		dc.b 10+6	; Hard
		dc.b 10+2	; Maniac

Obj_Honey_Main:
		addq.b	#2,routine(a0)
		move.w	#$2308,obGfx(a0)
		move.l	#Map_Honey,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$23,obColType(a0)
		move.b	#$1C,obHeight(a0)
		move.b	#$18,obWidth(a0)
		move.b	#$0C,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.w	#$300,obVelX(a0)
		move.w	#$800,obVelY(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	Obj_Honey_HP(pc,d0.w),$29(a0)
		clr.b	shield_reaction(a0)

Obj_Honey_CheckIntro:
		sub.w	#$2C,obVelY(a0)
		jsr	(SpeedToPos).w
		move.w	obX(a0),d0
		move.w	(v_player+obX).w,d1
		sub.w	#$40,d1
		cmp.w	d1,d0
		blt.w	Obj_Honey_Return
		jsr	(Restore_PlayerControl).w
		move.w	#btnC<<8+btnC,(Ctrl_1_logical).w
		addq.b	#2,routine(a0)
		rts


Obj_Honey_AfterJump:
		clr.b	(Ctrl_1_pressed_logical).w
		sub.w	#$2C,obVelY(a0)
		jsr	(SpeedToPos).w
		move.w	(Camera_min_X_pos).w,d0
		addi.w	#$C0,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Honey_Return
		clr.w	(Ctrl_1_logical).w
		move.b	#$1A,routine(a0)

Obj_Honey_SlowDown:
		sub.w	#$10,obVelX(a0)
		add.w	#$10,obVelY(a0)
		jsr	(SpeedToPos).w
		tst.w	obVelX(a0)
		bne.w	Obj_Honey_Return
		clr.w	obVelY(a0)
		lea	(Player_1).w,a1
		move.b	#$81,object_control(a1)
		move.w	#id_Wait2<<8,anim(a1)
		bclr	#Status_Facing,status(a1)
		jsr	(Stop_Object).w
		move.b	#1,obAnim(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr     (Swing_Setup_Hellgirl).w
		addq.b	#2,routine(a0)

Obj_Honey_WaitIntro:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		cmpi.b	#$1C,(Dynamic_resize_routine)
		bne.w	Obj_Honey_Return
		addq.b	#2,routine(a0)

Obj_Honey_WaitDeathLeave:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		jsr	(Obj_Eggman_LookOnSonic).l
		move.w	#$3C,obTimer(a0)
		move.b	#6,routine(a0)
		music	mus_Boss1
		command	cmd_FadeReset
		cmpi.w	#2,(AstarothCompleted).w
                bne.w   Obj_Honey_Return
                jsr     Restore_PlayerControl
		sf	(Level_end_flag).w
		sf	(Black_Stretch_flag).w
		sf	(Ctrl_1_locked).w
		sf	(NoPause_flag).w
		move.b	#1,(HUD_State).w

Obj_Honey_CastShadow:
		move.b  #$4,(Hyper_Sonic_flash_timer).w
		sfx	sfx_Boom,0
		addq.b	#2,routine(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_Return
		move.l	#Obj_HoneyShadow,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent(a1)
		move.w	(Camera_target_max_Y_pos).w,d0
		sub.w	#$3E,d0
		move.w	d0,obY(a0)
		move.b	#0,obAnim(a0)
		rts

Obj_Honey_WaitDeathLeave2:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		jsr	(Obj_Eggman_LookOnSonic).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Honey_Return
		move.w	#$3C,obTimer(a0)
		move.b	#6,routine(a0)
		; Without music. Don't play music a second time
		rts


Obj_Honey_PrepareToTakeOff:
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Honey_Return
		move.w	#$3C,obTimer(a0)
		jsr	(RandomNumber).w
		andi.w	#$3C,d0
		add.w	d0,obTimer(a0)
		move.b	#4,objoff_48(a0)
		move.b	#0,objoff_49(a0)
		move.w	(Camera_x_pos).w,d0
		add.w	#$94,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.s	.moveright
		bset	#0,obStatus(a0)
		addq.b	#4,routine(a0)
		rts

.moveright:
		bclr	#0,obStatus(a0)
		addq.b	#2,routine(a0)
		rts

Obj_Honey_MoveLeft:
		jsr	(Obj_Honey_Retreat).l
		jsr	(SpeedToPos).w
		jsr	(Obj_Honey_CheckNextFase).l
		cmpi.w	#-$180,obVelX(a0)
		bgt.s	+
		move.b	#2,obAnim(a0)
		cmpi.b	#1,objoff_48(a0)
		blt.s	+
		cmpi.b	#2,objoff_30(a0)
		beq.s	+
		move.b	#2,objoff_30(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_Return
		move.l	#Obj_Honey_WarningBomb,(a1)
		move.w	a0,parent(a1)
+		cmpi.w	#-$280,obVelX(a0)
		blt.s	+
		sub.w	#$10,obVelX(a0)
+		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$18,d0
		bcc.w	Obj_Honey_Return
		bchg	#0,obStatus(a0)
		move.b	#0,obAnim(a0)
		move.w	#-$180,obVelX(a0)
		move.b	#$E,routine(a0)
		jsr	(Obj_Honey_FireBombMissiles).l
		bra.w	Obj_Honey_Return

Obj_Honey_MoveRight:
		jsr	(Obj_Honey_Retreat).l
		jsr	(SpeedToPos).w
		jsr	(Obj_Honey_CheckNextFase).l
		cmpi.w	#$180,obVelX(a0)
		blt.s	+
		move.b	#2,obAnim(a0)
		cmpi.b	#1,objoff_48(a0)
		blt.s	+
		cmpi.b	#2,objoff_30(a0)
		beq.s	+
		move.b	#2,objoff_30(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_Return
		move.l	#Obj_Honey_WarningBomb,(a1)
		move.w	a0,parent(a1)
+		cmpi.w	#$280,obVelX(a0)
		bgt.s	+
		add.w	#$10,obVelX(a0)
+		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$120,d0
		blt.w	Obj_Honey_Return
		bchg	#0,obStatus(a0)
		move.b	#0,obAnim(a0)
		move.w	#$180,obVelX(a0)
		move.b	#$C,routine(a0)
		jsr	(Obj_Honey_FireBombMissiles).l
		bra.w	Obj_Honey_Return

Obj_Honey_CheckNextFase:
		cmpi.b	#0,objoff_48(a0)
		bne.w	Obj_Honey_Return
		move.w	#$400,obVelY(a0)
		move.w	#$180,obVelX(a0)
		move.b	#2,obAnim(a0)
		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	+			; if not, branch
		neg.w	obVelX(a0)
+		move.b	#$10,routine(a0)
		move.b	#0,objoff_31(a0)
		move.b	#0,objoff_30(a0)
		bra.w	Obj_Honey_Return

Obj_Honey_FireBombMissiles:
		cmpi.b	#2,objoff_49(a0)
		bgt.w	Obj_Honey_Return
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_Return
		move.l	#Obj_Honey_BombMissile,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.w	a0,parent(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a1),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		sfx	sfx_FireShield
		add.b	#1,objoff_49(a0)
		bra.w	Obj_Honey_Return

Obj_Honey_TakeOff:
		jsr	(SpeedToPos).w
		sub.w	#$40,obVelY(a0)
		move.w	(Camera_target_max_y_pos).w,d0
		sub.w	#$28,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_Honey_Return
		move.b	#3,objoff_49(a0)
		addq.b	#2,routine(a0)

Obj_Honey_SetWarning:
		cmpi.b	#0,objoff_49(a0)
		beq.w	.gonext
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_Return
		move.l	#Obj_Honey_WarningWave,(a1)
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$20,d0
		move.w	d0,obY(a1)
		move.w	obX(a1),obX(a0)
		move.w	a1,parent(a0)
		move.w	#$3C,obTimer(a1)
		move.w	a0,parent(a1)
		addq.b	#2,routine(a0)
		rts

.gonext:
		move.w	#$200,obVelY(a0)
		clr.w	obVelX(a0)
		move.b	#0,obAnim(a0)
		addq.b	#6,routine(a0)
		rts

Obj_Honey_WaitWarning:
		move.w	parent(a0),a1
		move.w	(Player_1+obX).w,obX(a1)
		cmpi.b	#0,objoff_48(a0)
		beq.s	+
		addq.b	#2,routine(a0)
		move.w	#$F,obTimer(a0) ;
+		rts

Obj_Honey_FireHeartMissiles:
		cmpi.b	#0,objoff_48(a0)
		beq.s	.returnback
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Honey_Return
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_Return
		move.l	#Obj_Honey_LoveMissile,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		sub.b	#1,objoff_48(a0)
		move.w	#$F,obTimer(a0)
		rts

.returnback:
		subq.b	#4,routine(a0)
		rts


Obj_Honey_NextRound:
		jsr	(SpeedToPos).w
		move.w	(Camera_target_max_y_pos).w,d0
		add.w	#$20,d0
		move.w	obY(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Honey_Return
		clr.w	obVelY(a0)
		move.w	#$3C,obTimer(a0)
		clr.w	obVelY(a0)
		jsr     (Swing_Setup_Hellgirl).w
		move.b	#$20,routine(a0)


Obj_Honey_Return:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Honey the Hell girl shadow
; ---------------------------------------------------------------------------
Obj_HoneyShadow:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_HoneyShadow_Index(pc,d0.w),d1
		jsr	Obj_HoneyShadow_Index(pc,d1.w)
		lea	(Ani_Honey).l,a1
		jmp	(AnimateSprite).w

; ===========================================================================

Obj_HoneyShadow_Index:
		dc.w Obj_HoneyShadow_Main-Obj_HoneyShadow_Index
		dc.w Obj_HoneyShadow_ChaseSonic-Obj_HoneyShadow_Index
		dc.w Obj_HoneyShadow_WaitUntilSonicOnGround-Obj_HoneyShadow_Index
		dc.w Obj_HoneyShadow_TikTak-Obj_HoneyShadow_Index
		dc.w Obj_HoneyShadow_JumpOut-Obj_HoneyShadow_Index
		dc.w Obj_HoneyShadow_FlyUp-Obj_HoneyShadow_Index
; ===========================================================================
Obj_HoneyShadow_Display:
		move.w	v_framecount.w,d0
		lsr.w	#3,d0
		bcc.w	Obj_HoneyShadow_Return
		jmp	(Draw_Sprite).w

Obj_HoneyShadow_PlaySwitchSound:
		move.w	v_framecount.w,d0
		cmpi.b	#5,obAnim(a0)
		beq.w	.faster
		cmpi.b	#6,obAnim(a0)
		beq.s	.fastest
		lsr.w	#4,d0
		bcc.w	Obj_HoneyShadow_Return
		bra.s	.dostuff

.faster:
		lsr.w	#2,d0
		bcc.w	Obj_HoneyShadow_Return
		bra.s	.dostuff

.fastest:
		lsr.w	#1,d0
		bcc.w	Obj_HoneyShadow_Return

.dostuff:
		sfx	sfx_Switch,0
		jmp	(Draw_Sprite).w
; ===========================================================================
Obj_HoneyShadow_Main:
		move.l	#Map_Honey,obMap(a0)
		move.w	#$2308,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)
		move.w	#$5A,obTimer(a0)
		addq.b	#2,routine(a0)

Obj_HoneyShadow_ChaseSonic:
		sub.w	#1,obTimer(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(Obj_HoneyShadow_Display).l
		jsr	(Find_SonicTails).w
		move.w	#$400,d0
		moveq	#$30,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w
		cmpi.w	#0,obTimer(a0)
		beq.w	.jump
		lea	(Player_1).w,a1
		lea	Obj_HoneyShadow_CheckXY(pc),a2				; ������ ��� �������� �������
		jsr	(Check_InMyRange).w
		beq.w	Obj_HoneyShadow_Return

.jump:
		move.w	#$280,priority(a0)
		addq.b	#2,routine(a0)

Obj_HoneyShadow_WaitUntilSonicOnGround:
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		bne.w	Obj_HoneyShadow_Return
		move.w	(Player_1+obX).w,obX(a0)
		move.w	(Player_1+obY).w,obY(a0)
		move.w	#$7A,obTimer(a0)
		move.b	#3,objoff_48(a0)
		addq.b	#2,routine(a0)
		move.b  #$4,(Hyper_Sonic_flash_timer).w
		sfx	sfx_Boom,0
		move.w	#2*$80,obPriority(a0)
		bclr	#0,obStatus(a0)
		move.b	#4,obAnim(a0)

		jsr	(RandomNumber).w
		andi.b	#4,d0
		lea	(Obj_Honey_LoveShield_ExtraAngle).l,a1
                move.b (a1,d0.w),objoff_3B(a0)



		moveq	#9-1,d5			; create 7 loveballs
		moveq	#0,d6			; first subtype
		moveq	#5,d4			; next object subtype offset
		move.l	#Obj_Honey_LoveShield,d3	; object to create

.create:
		jsr	SingleObjLoad2
		bne.w	Obj_HoneyShadow_Return
		move.l	d3,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	objoff_3B(a0),objoff_3B(a1)
		move.w	a0,parent3(a1)
		cmpi.b	#0,d6
		bne.w	.cont
		move.w	a1,parent3(a0)

.cont:
		move.b	d6,obSubtype(a1)	; save subtype
		add.b	d4,d6			; get next subtype to view
		dbf	d5,.create		; create next object

Obj_HoneyShadow_TikTak:
		jsr	(Obj_HoneyShadow_PlaySwitchSound).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_HoneyShadow_Return
		sub.b	#1,objoff_48(a0)
		cmpi.b	#0,objoff_48(a0)
		beq.s	.gonext
		move.w	#$3C,obTimer(a0)
		bra.w	Obj_HoneyShadow_Return

.gonext:
		addq.b	#2,routine(a0)
		bra.w	Obj_HoneyShadow_Return

Obj_HoneyShadow_JumpOut:
		jmp	(Obj_HoneyShadow_PlaySwitchSound).l

Obj_HoneyShadow_FlyUp:
		jsr	(Obj_HoneyShadow_Display).l
		jsr	(SpeedToPos).w
		move.w	obY(a0),d0
		sub.w	(Camera_target_max_y_pos).w,d0
		cmpi.w	#$38,d0
		bcc.w	Obj_HoneyShadow_Return

		move.w	parent(a0),a1
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addq.b	#2,routine(a1)

		move.l	#Delete_Current_Sprite,address(a0)


Obj_HoneyShadow_Return:
		rts

; ===========================================================================
Obj_Honey_LoveShield_ExtraAngle:
		dc.b	$41
		dc.b	$42
		dc.b	$44
		dc.b	$46
		dc.b	$48
		dc.b	$4A
; ===========================================================================
; ---------------------------------------------------------------------------
; Honey the Hell girl s love shield
; ---------------------------------------------------------------------------
Obj_Honey_LoveShield:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_LoveShield_Index(pc,d0.w),d1
		jsr	Obj_Honey_LoveShield_Index(pc,d1.w)
		lea     (Ani_Hellgirl).l,a1
		jmp	(AnimateSprite).w

; ===========================================================================

Obj_Honey_LoveShield_Index:
		dc.w Obj_Honey_LoveShield_Main-Obj_Honey_LoveShield_Index
		dc.w Obj_Honey_LoveShield_IncreaseRadius-Obj_Honey_LoveShield_Index
		dc.w Obj_Honey_LoveShield_IncreaseRadius2-Obj_Honey_LoveShield_Index
		dc.w Obj_Honey_LoveShield_RotateAround-Obj_Honey_LoveShield_Index
		dc.w Obj_Honey_LoveShield_DegrateTheRadius-Obj_Honey_LoveShield_Index
; ===========================================================================

Obj_Honey_LoveShield_Main:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$375,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#4,obAnim(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.b	#2,d0
		move.b	d0,$3C(a0)
		move.b	objoff_3B(a0),d1
		add.b	d1,$3C(a0)
		move.b	#$87,obColType(a0)
		addq.b	#2,routine(a0)

Obj_Honey_LoveShield_IncreaseRadius:
		move.w	parent3(a0),a1
		move.w	(Player_1+obX).w,obX(a1)
		jsr	(Obj_HoneyShadow_Display).l
		jsr     (MoveSprite_Circular).w
		addq.b	#4,$3C(a0)
		addq.b	#1,objoff_3A(a0)

		cmpi.b	#$5A,objoff_3A(a0)
		blt.w	Obj_Honey_LoveShield_Return
		addq.b	#2,routine(a0)

Obj_Honey_LoveShield_IncreaseRadius2:
		jsr	(Draw_And_Touch_Sprite).w
		jsr     (MoveSprite_Circular).w
		addq.b	#3,$3C(a0)
		addq.b	#3,objoff_3A(a0)
		cmpi.b	#$70,objoff_3A(a0)
		blt.w	Obj_Honey_LoveShield_Return
		move.w	parent3(a0),a1
		move.b	#5,obAnim(a1)
		addq.b	#2,routine(a0)


Obj_Honey_LoveShield_RotateAround:
		jsr	(Draw_And_Touch_Sprite).w
		addq.b	#2,$3C(a0)
		jsr     (MoveSprite_Circular).w
		move.w	parent3(a0),a1
		cmpi.b	#8,routine(a1)
		bne.w	Obj_Honey_LoveShield_Return
		move.w	parent3(a0),a1
		move.b	#6,obAnim(a1)
		addq.b	#2,routine(a0)

Obj_Honey_LoveShield_DegrateTheRadius:
		jsr	(Draw_And_Touch_Sprite).w
		jsr     (MoveSprite_Circular).w
		subq.b	#4,objoff_3A(a0)
		cmpi.b	#4,objoff_3A(a0)
		bcc.s	Obj_Honey_LoveShield_Return
		move.w	parent3(a0),a1
		move.w	#-$200,obVelY(a1)
		clr.w	obVelX(a1)
		move.b	#$A,routine(a1)
		move.b	#0,obAnim(a1)
		move.w	#3*$80,obPriority(a1)
		move.l  #Go_Delete_Sprite,(a0)
		cmpi.b	#0,obSubtype(a0)
		bne.s	Obj_Honey_LoveShield_Return
		sfx	sfx_Bomb
		lea 	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr 	(CreateChild6_Simple).w
		bne.s	Obj_Honey_LoveShield_Return
		st	$40(a1)

Obj_Honey_LoveShield_Return:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Honey the Hell girl s heart missile
; ---------------------------------------------------------------------------
Obj_Honey_LoveMissile:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_LoveMissile_Index(pc,d0.w),d1
		jsr	Obj_Honey_LoveMissile_Index(pc,d1.w)
		lea     (Ani_Hellgirl).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================

Obj_Honey_LoveMissile_Index:
		dc.w Obj_Honey_LoveMissile_Main-Obj_Honey_LoveMissile_Index
		dc.w Obj_Honey_LoveMissile_Fall-Obj_Honey_LoveMissile_Index
; ===========================================================================

Obj_Honey_LoveMissile_Main:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$375,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#4,obAnim(a0)

		move.w	#$100,d0
		move.w	d0,$3A(a0)
		move.w	d0,x_vel(a0)
		move.w	#$18,$3C(a0)
		bclr	#3,$38(a0)

		move.b	#$87,obColType(a0)
		move.w	#$400,obVelY(a0)
		addq.b	#2,routine(a0)

Obj_Honey_LoveMissile_Fall:
		jsr	(Swing_LeftAndRight).w
		jsr	(SpeedToPos).w
	;	jsr	ObjHitFloor
	;	tst.w	d1				; is object above the ground?
	;	bpl.w	Obj_Honey_LoveMissile_Return			; if yes, branch
	;	add.w	d1,obY(a0)			; match	object's position with the floor
		cmpi.w	#$546,obY(a0)
		blt.s	Obj_Honey_LoveMissile_Return
		lea	ChildObjDat_MechaSonicCastExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		sfx	sfx_BreakBridge
		move.l  #Go_Delete_Sprite,(a0)

Obj_Honey_LoveMissile_Return:
		rts


; ===========================================================================
; ---------------------------------------------------------------------------
; Honey the Hell girl s heart missile with bomb functionality
; ---------------------------------------------------------------------------
Obj_Honey_BombMissile:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_BombMissile_Index(pc,d0.w),d1
		jsr	Obj_Honey_BombMissile_Index(pc,d1.w)
		lea     (Ani_Honey).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================

Obj_Honey_BombMissile_Index:
		dc.w Obj_Honey_BombMissile_Main-Obj_Honey_BombMissile_Index
		dc.w Obj_Honey_BombMissile_Fall-Obj_Honey_BombMissile_Index
		dc.w Obj_Honey_BombMissile_Explose-Obj_Honey_BombMissile_Index
; ===========================================================================
Obj_Honey_BombMissile_Display:
		cmpi.b	#0,objoff_48(a0)
		bne.s	+
		move.w	v_framecount.w,d0
		lsr.w	#1,d0
		bcc.w	Obj_HoneyShadow_Return
		jmp	(Draw_Sprite).w
+		jmp	(Draw_And_Touch_Sprite).w

Obj_Honey_BombMissile_Main:
		move.l	#Map_Honey,obMap(a0)
		move.w	#$2308,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#7,obAnim(a0)
		move.b	#$86,obColType(a0)
		move.b	#0,objoff_48(a0)
		move.b	objoff_48(a0),d0
		lea	(Obj_Honey_BombMissile_Speeds).l,a1
                move.w (a1,d0.w),obVelY(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Honey_BombMissile_Return
		move.l	#Obj_Honey_BombMissile_LoveShield,(a1)
		move.w	a0,parent3(a1)
		move.b	#$0F,objoff_3E(a1)
		move.b	#$08,$3C(a1)
	;	jsr	(SingleObjLoad2).w
	;	bne.w	Obj_Honey_BombMissile_Return
	;	move.l	#Obj_Honey_BombMissile_LoveShield,(a1)
	;	move.w	a0,parent3(a1)
	;	move.b	#$F0,objoff_3E(a1)
	;	move.b	#$F7,$3C(a1)

		addq.b	#2,routine(a0)

Obj_Honey_BombMissile_Fall:
		move.w	parent(a0),a1
		btst	#7,status(a1)
		bne.w	Obj_Honey_BombMissile_EXPLODE
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$10,d0
		bgt.s	.checkright
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
		bra.s	.action

.checkright:
		cmpi.w	#$128,d0
		blt.s	.action
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)

.action:
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Honey_BombMissile_Return
		add.w	d1,obY(a0)
		addq.b	#2,objoff_48(a0)
		cmpi.b	#8,objoff_48(a0)
		beq.w	.explose
		move.b	objoff_48(a0),d0
		lea	(Obj_Honey_BombMissile_Speeds).l,a1
                move.w (a1,d0.w),obVelY(a0)
		move.w	obVelX(a0),d0
	;	btst	#0,obStatus(a0)		; is boss facing left?
	;	bne.w	.subspd			; if not, branch
		cmpi.w	#1,d0
		bgt.s	.subspd
		neg.w	d0
		lsr.w	#1,d0
		add.w	d0,obVelX(a0)
		bra.s	.switchsound

.subspd:
		lsr.w	#1,d0
		sub.w	d0,obVelX(a0)

.switchsound:
		sfx	sfx_Switch,0
		rts

.explose:
		addq.b	#2,routine(a0)
		rts

Obj_Honey_BombMissile_Explose:
		move.w	parent(a0),a1
		sub.b	#1,objoff_48(a1)
		sub.b	#1,objoff_49(a1)
		move.w	#$14,(Screen_Shaking_Flag).w

Obj_Honey_BombMissile_EXPLODE:
		sfx	sfx_BreakBridge
		lea	ChildObjDat_DEZExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#Go_Delete_Sprite,address(a0)

Obj_Honey_BombMissile_Return:
		rts

Obj_Honey_BombMissile_Speeds:
		dc.w	-$380
		dc.w	-$280
		dc.w	-$1B0
		dc.w	-$100
		dc.w	0
; ===========================================================================
; ---------------------------------------------------------------------------
; Honey the Hell girl s heart rotating around bomb
; ---------------------------------------------------------------------------
Obj_Honey_BombMissile_LoveShield:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_BombMissile_LoveShield_Index(pc,d0.w),d1
		jsr	Obj_Honey_BombMissile_LoveShield_Index(pc,d1.w)
		lea     (Ani_Hellgirl).l,a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Honey_BombMissile_LoveShield_Display).l

; ===========================================================================

Obj_Honey_BombMissile_LoveShield_Index:
		dc.w Obj_Honey_BombMissile_LoveShield_Main-Obj_Honey_BombMissile_LoveShield_Index
		dc.w Obj_Honey_LoveShield_BombMissile_Rotate-Obj_Honey_BombMissile_LoveShield_Index
		dc.w Obj_Honey_LoveShield_BombMissile_Delete-Obj_Honey_BombMissile_LoveShield_Index
; ===========================================================================
Obj_Honey_BombMissile_LoveShield_Display:
		move.w	v_framecount.w,d0
		lsr.w	#8,d0
		bcc.w	.rotate
		move.w	parent3(a0),a1
		move.w	obY(a1),d0
		sub.w	obY(a0),d0
		bmi.s	.setrender
		move.w	#4*$80,obPriority(a0)
		bra.s	.rotate

.setrender:
		move.w	#2*$80,obPriority(a0)
.rotate:
		jmp	(Child_Draw_Sprite).w

Obj_Honey_BombMissile_LoveShield_Main:
		move.l	#SME_fMWF3,obMap(a0)
		move.w	#$375,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#2*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#5,obAnim(a0)
		move.b	#$10,objoff_3A(a0)
		move.b	#$87,obColType(a0)
		addq.b	#2,routine(a0)

Obj_Honey_LoveShield_BombMissile_Rotate:
		addi.b	#4,$3C(a0)
		jsr	(MoveSprite_Circular_XanBie).l	; ��������.
		move.w	parent3(a0),a1
		cmpi.b	#$20,routine(a1)
		bne.s	Obj_Honey_LoveShield_BombMissile_Return
		addq.b	#2,routine(a0)

Obj_Honey_LoveShield_BombMissile_Delete:
		move.l	#Go_Delete_Sprite,address(a0)

Obj_Honey_LoveShield_BombMissile_Return:
		rts
; ---------------------------------------------------------------------------
; Honey the Hell girl s warning 1
; ---------------------------------------------------------------------------
Obj_Honey_WarningWave:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_WarningWave_Index(pc,d0.w),d1
		jsr	Obj_Honey_WarningWave_Index(pc,d1.w)
		lea     (Ani_Honey).l,a1
		jsr	(AnimateSprite).w
		move.w	v_framecount.w,d0
		lsr.w	#3,d0
		bcc.w	Obj_Honey_WarningWave_Return
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_Honey_WarningWave_Index:
		dc.w Obj_Honey_WarningWave_Main-Obj_Honey_WarningWave_Index
		dc.w Obj_Honey_WarningWave_Delete-Obj_Honey_WarningWave_Index
; ---------------------------------------------------------------------------

Obj_Honey_WarningWave_Main:
		move.l	#Map_Honey,obMap(a0)
		move.w	#$2308,obGfx(a0)
		move.b	#3,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		sfx	sfx_Switch,0
		addq.b	#2,routine(a0)

Obj_Honey_WarningWave_Delete:
		;move.w	(Player_1+obX).w,obX(a0)
		sub.w	#1,obTimer(a0)
		bpl.s	Obj_Honey_WarningWave_Return

		jsr	(Create_New_Sprite3).w
		bne.s	.naturlich
		move.l	#Obj_DEZExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$859C,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	#-$100,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)

.naturlich:
		sfx	sfx_Bomb
		move.w	parent(a0),a1
		sub.b	#1,objoff_49(a1)
		move.w	obX(a0),obX(a1)
		move.b	#5,objoff_48(a1)
		move.l  #Go_Delete_Sprite,(a0)

Obj_Honey_WarningWave_Return:
		rts
; ==================================================================
; ---------------------------------------------------------------------------
; Honey the Hell girl s warning 2
; ---------------------------------------------------------------------------
Obj_Honey_WarningBomb:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_WarningBomb_Index(pc,d0.w),d1
		jsr	Obj_Honey_WarningBomb_Index(pc,d1.w)
		lea     (Ani_Honey).l,a1
		jsr	(AnimateSprite).w
		move.w	v_framecount.w,d0
		lsr.w	#3,d0
		bcc.w	Obj_Honey_WarningBomb_Return
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

Obj_Honey_WarningBomb_Index:
		dc.w Obj_Honey_WarningBomb_Main-Obj_Honey_WarningBomb_Index
		dc.w Obj_Honey_WarningBomb_Process-Obj_Honey_WarningBomb_Index
; ---------------------------------------------------------------------------

Obj_Honey_WarningBomb_Main:
		move.l	#Map_Honey,obMap(a0)
		move.w	#$2308,obGfx(a0)
		move.b	#3,obAnim(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		addq.b	#2,routine(a0)

Obj_Honey_WarningBomb_Process:
		move.w	parent(a0),a1
		cmpi.b	#$10,routine(a1)
		beq.s	Obj_Honey_WarningBomb_Delete
		move.w	(Player_1+obX).w,d0
		add.w	obX(a1),d0
		lsr.w	#1,d0
		move.w	d0,obX(a0)
		move.w	(Camera_target_max_y_pos).w,obY(a0)
		add.w	#$40,obY(a0)
		move.w	parent(a0),a1
		cmpi.b	#0,obAnim(a1)
		bne.s	Obj_Honey_WarningBomb_Return

Obj_Honey_WarningBomb_Delete:
		move.w	parent(a0),a1
		move.b	#0,objoff_30(a1)
		move.l  #Go_Delete_Sprite,(a0)

Obj_Honey_WarningBomb_Return:
		rts
; ==================================================================

Obj_HoneyShadow_CheckXY:	; ������ ��������� 4x4(������ ������� ?x?)
		dc.w -32
		dc.w 64
		dc.w -32
		dc.w 64

Obj_BombMissile_CheckXY:
		dc.w -16
		dc.w 32
		dc.w -16
		dc.w 32

		include "Objects/Bosses/Honey/Object data/Ani - Honey.asm"
		include "Objects/Bosses/Honey/Object data/Map - Honey.asm"
; ---------------------------------------------------------------------------
; Firebrand
; ---------------------------------------------------------------------------

Obj_Firebrand:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Firebrand_Index(pc,d0.w),d1
		jsr	Obj_Firebrand_Index(pc,d1.w)
		jsr  	(Obj_Firebrand_Process).l
		lea    	Ani_Firebrand(pc),a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_Firebrand(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Obj_Firebrand_Display).l
; ===========================================================================

Obj_Firebrand_Index:
		dc.w Obj_Firebrand_Main-Obj_Firebrand_Index
		dc.w Obj_Firebrand_Intro1-Obj_Firebrand_Index
		dc.w Obj_Firebrand_Move-Obj_Firebrand_Index
		dc.w Obj_Firebrand_Attack-Obj_Firebrand_Index
; ===========================================================================
Obj_Firebrand_Display:
		move.b	$33(a0),d0
		beq.s	Obj_Firebrand_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Firebrand_Return

Obj_Firebrand_Animate:
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================
Obj_Firebrand_Process:
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $33(a0)
		bne.s   .whatizit
		move.b  #$3C,$33(a0)
		samp	sfx_FireHurt
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)

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
	      	lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		samp	sfx_FireDeath
		jsr	(Obj_HurtBloodCreate).l
		move.l	#Go_Delete_Sprite,(a0)
		addq.b	#2,(Dynamic_resize_routine).w

.lacricium:
		rts

; ===========================================================================
Obj_Firebrand_XMove:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	.moveleft		; if not, branch

.moveright:
		cmpi.w	#$200,obVelX(a0)
		bgt.s	.return
		add.w	#$80,obVelX(a0)
		bra.w	.return

.moveleft:
		cmpi.w	#-$200,obVelX(a0)
		blt.w	.return
		sub.w	#$80,obVelX(a0)

.return:
		rts

; ---------------------------------------------------------------------------
Obj_Firebrand_XStop:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	.moveleft		; if not, branch

.moveright:
		cmpi.w	#$40,obVelX(a0)
		blt.s	.clrani
		sub.w	#$40,obVelX(a0)
		bra.w	.return

.moveleft:
		cmpi.w	#-$40,obVelX(a0)
		bgt.w	.clrani
		add.w	#$40,obVelX(a0)
		bra.s	.return

.clrani:
		move.b	#0,obAnim(a0)


.return:
		rts
; ---------------------------------------------------------------------------

Obj_Firebrand_YMoveUp:
		;jsr	(Obj_Firebrand_LookOnSonic).l
		jsr	(SpeedToPos).w
		cmpi.w	#-$200,obVelY(a0)
		blt.s	.return
		sub.w	#$40,obVelY(a0)

.return:
		rts

Obj_Firebrand_YMoveDown:
		;jsr	(Obj_Firebrand_LookOnSonic).l
		jsr	(SpeedToPos).w
		cmpi.w	#$200,obVelY(a0)
		bgt.s	.return
		add.w	#$40,obVelY(a0)

.return:
		rts

; ===========================================================================
Obj_Firebrand_ChkSonic:
		jsr	(Find_Sonic).w
  		cmpi.w	#$10,d2
            	bcc.w	Obj_Firebrand_Return
		move.w	#$1E,obTimer(a0)
		addq.b	#2,objoff_31(a0)

; ===========================================================================
Obj_Firebrand_LookOnSonic:
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Firebrand_Return
		bclr	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bset	#0,obStatus(a0)
+		rts
; ===========================================================================

Obj_Firebrand_HP:
		dc.b 8/2	; Easy
		dc.b 8		; Normal
		dc.b 8+6	; Hard
		dc.b 8+2	; Maniac

Obj_Firebrand_Main:
		lea	ObjDat4_Firebrand(pc),a1
		jsr	SetUp_ObjAttributes
		bchg	#0,obStatus(a0)
		move.b	#1,obAnim(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	Obj_Firebrand_HP(pc,d0.w),$29(a0)
		jmp     (Swing_Setup_Hellgirl).w

Obj_Firebrand_Intro1:
		jsr	(Obj_Firebrand_XMove).l
		move.w	obX(a0),d0
		sub.w	(Camera_min_x_pos).w,d0
		cmpi.w	#$110,d0
		bgt.w	Obj_Firebrand_Return
		move.w	#$5A,obTimer(a0)
		move.b	#0,obAnim(a0)
		clr.w	obVelX(a0)
		addq.b	#2,routine(a0)

; ---------------------------------------------------------------------------

Obj_Firebrand_Move:
		moveq	#0,d0
		move.b	objoff_31(a0),d0
		move.w	Obj_Firebrand_MoveIndex(pc,d0.w),d1
		jmp	Obj_Firebrand_MoveIndex(pc,d1.w)

Obj_Firebrand_MoveIndex:
		dc.w Obj_Firebrand_Wait-Obj_Firebrand_MoveIndex
		dc.w Obj_Firebrand_FlyDown-Obj_Firebrand_MoveIndex
		dc.w Obj_Firebrand_Wait2-Obj_Firebrand_MoveIndex
	;	dc.w Obj_Firebrand_MoveTowardsSonic-Obj_Firebrand_MoveIndex
	;	dc.w Obj_Firebrand_StopTowardsSonic-Obj_Firebrand_MoveIndex
	;	dc.w Obj_Firebrand_Wait-Obj_Firebrand_MoveIndex
	;	dc.w Obj_Firebrand_FlyUp-Obj_Firebrand_MoveIndex
	;	dc.w Obj_Firebrand_Wait3-Obj_Firebrand_MoveIndex
		dc.w Obj_Firebrand_MoveOppSide-Obj_Firebrand_MoveIndex
		dc.w Obj_Firebrand_Wait-Obj_Firebrand_MoveIndex
		dc.w Obj_Firebrand_FlyUp-Obj_Firebrand_MoveIndex

Obj_Firebrand_Wait:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	.return
		addq.b	#2,objoff_31(a0)

.return:
		rts


Obj_Firebrand_FlyDown:
		jsr	(Obj_Firebrand_YMoveDown).l
		move.w	obY(a0),d0
		sub.w	(Camera_target_max_y_pos).w,d0
		cmpi.w	#$48,d0
		blt.w	Obj_Firebrand_Return
		move.w	#8,obTimer(a0)
		clr.w	obVelY(a0)
		addq.b	#2,objoff_31(a0)
		rts

Obj_Firebrand_Wait2:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		;jsr	(Obj_Firebrand_LookOnSonic).l
		sub.w	#1,obTimer(a0)
		bpl.w	.return
		move.b	#1,obAnim(a0)
		addq.b	#2,objoff_31(a0)

.return:
		rts

Obj_Firebrand_Wait3:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		jsr	(Obj_Firebrand_LookOnSonic).l
		sub.w	#1,obTimer(a0)
		bpl.w	.return
		move.b	#1,obAnim(a0)
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$94,d0
		blt.s	.setotherdir
		bset	#0,obStatus(a0)
		bra.s	.cont

.setotherdir:
		bclr	#0,obStatus(a0)

.cont:
		addq.b	#2,objoff_31(a0)

.return:
		rts

Obj_Firebrand_MoveTowardsSonic:
		jsr	(Obj_Firebrand_ChkSonic).l
		jsr	(Obj_Firebrand_XMove).l
		rts

Obj_Firebrand_StopTowardsSonic:
		jsr	(Obj_Firebrand_XStop).l
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Firebrand_Return
		clr.w	obVelX(a0)
		move.b	#0,obAnim(a0)
		move.w	#8,obTimer(a0)
		addq.b	#2,objoff_31(a0)

Obj_Firebrand_FlyUp:
		jsr	(Obj_Firebrand_YMoveUp).l
		move.w	obY(a0),d0
		sub.w	(Camera_target_max_y_pos).w,d0
		cmpi.w	#$20,d0
		bgt.w	Obj_Firebrand_Return
		move.w	#$1E,obTimer(a0)
		clr.w	obVelY(a0)
		;addq.b	#2,objoff_31(a0)
		move.b	#0,objoff_31(a0)
		addq.b	#2,routine(a0)
		rts

Obj_Firebrand_MoveOppSide:
		jsr	(Obj_Firebrand_XMove).l
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		btst	#0,obStatus(a0)
		bne.s	.other
		cmpi.w	#$118,d0
		bgt.s	.action
		rts

.other:
		cmpi.w	#$20,d0
		blt.s	.action
		rts

.action:
		clr.w	obVelX(a0)
		move.b	#0,obAnim(a0)
		move.w	#$5A,obTimer(a0)
		move.w	#$3C,obTimer(a0)
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$94,d0
		blt.s	.setotherdir
		bset	#0,obStatus(a0)
		bra.s	.cont

.setotherdir:
		bclr	#0,obStatus(a0)

.cont:
		addq.b	#2,objoff_31(a0)

; ---------------------------------------------------------------------------

Obj_Firebrand_Attack:
		moveq	#0,d0
		move.b	objoff_34(a0),d0
		move.w	Obj_Firebrand_AttackIndex(pc,d0.w),d1
		jmp	Obj_Firebrand_AttackIndex(pc,d1.w)

Obj_Firebrand_AttackIndex:
		dc.w Obj_Firebrand_MZStyle-Obj_Firebrand_AttackIndex
		dc.w Obj_Firebrand_ThrowAxis-Obj_Firebrand_AttackIndex
		dc.w Obj_Firebrand_WaitingForAxisEnd-Obj_Firebrand_AttackIndex
		dc.w Obj_Firebrand_FireSnake-Obj_Firebrand_AttackIndex

Obj_Firebrand_MZStyle:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	.return
		cmpi.b	#3,objoff_48(a0)
		beq.s	.allover
		move.w	#$78,obTimer(a0)
		move.b	#2,obAnim(a0)
		sfx	sfx_FireAttack

		jsr	(SingleObjLoad2).w
		bne.s	.return
		move.l	#Obj_Firebrand_Flame,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		sub.w	#$F,obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a1),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)

		add.b	#1,objoff_48(a0)
		bra.s	.return

.allover:
		clr.b	objoff_48(a0)
		move.w	#$3C,obTimer(a0)
		subq.b	#2,routine(a0)
		addq.b	#2,objoff_34(a0)

.return:
		rts

Obj_Firebrand_ThrowAxis:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	.return
		clr.b	objoff_49(a0)
		move.b	#2,obAnim(a0)
		sfx	sfx_FireAttack

		jsr	(SingleObjLoad2).w
		bne.s	.return
		move.l	#Obj_Firebrand_FlameAxis,(a1)
		move.w	a0,parent3(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		sub.w	#$F,obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		addq.b	#2,objoff_34(a0)

.return:
		rts

Obj_Firebrand_WaitingForAxisEnd:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w

.return:
		rts

Obj_Firebrand_FireSnake:
		jsr 	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Firebrand_TailedStyle_Return
		move.b	#2,obAnim(a0)
		sfx	sfx_FireAttack

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Firebrand_Return
		move.l	#Obj_Firebrand_FlameSnake,(a1)
		move.w	a0,parent3(a1)
		move.b	#0,obSubtype(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		sub.w	#$F,obY(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a1),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		move.w	#30,$3E(a1)
		move.b	#4,objoff_34(a0)

Obj_Firebrand_TailedStyle_Return:
		rts


; ---------------------------------------------------------------------------

Obj_Firebrand_Return:
		rts

Obj_Firebrand_Flame_SFX:
		jsr	(AnimateSprite).w
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#$1F,d0
		bne.w	.return
                samp	sfx_MechaDemon

.return:
                rts

; ---------------------------------------------------------------------------
; Firebrand's fireball 1
; ---------------------------------------------------------------------------
Obj_Firebrand_Flame:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Firebrand_Flame_Index(pc,d0.w),d1
		jsr	Obj_Firebrand_Flame_Index(pc,d1.w)
		lea	Ani_Firebrand(pc),a1
                jsr     (Obj_Firebrand_Flame_SFX).l
		jmp	(Child_DrawTouch_Sprite_Firebrand).w

Obj_Firebrand_Flame_Index:
		dc.w Obj_Firebrand_Flame_Main-Obj_Firebrand_Flame_Index
		dc.w Obj_Firebrand_Flame_Fall-Obj_Firebrand_Flame_Index
		dc.w Obj_Firebrand_Flame_Timer-Obj_Firebrand_Flame_Index
		dc.w Obj_Firebrand_Flame_Move-Obj_Firebrand_Flame_Index

Obj_Firebrand_Flame_Main:
		move.l	#Map_Flames,obMap(a0)
		move.w	#$23C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$34|$80,obColType(a0)
		move.b	#3,obAnim(a0)
		addq.b	#2,routine(a0)

Obj_Firebrand_Flame_Fall:
		jsr	(Obj_Firebrand_ProduceExplosions).l
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Firebrand_Flame_Return
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		clr.w	obVelX(a0)

		cmpi.b	#0,obSubtype(a0)
		bne.w	+
		addq.b	#2,routine(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Firebrand_Flame_Return
		move.l	#Obj_Firebrand_Flame,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#1,obSubtype(a1)
		move.w	#7,obTimer(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Firebrand_Flame_Return
		move.l	#Obj_Firebrand_Flame,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#2,obSubtype(a1)
		move.w	#$10,obTimer(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Firebrand_Flame_Return
		move.l	#Obj_Firebrand_Flame,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#3,obSubtype(a1)
		move.w	#$18,obTimer(a1)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_Firebrand_Flame_Return
		move.l	#Obj_Firebrand_Flame,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	#4,obSubtype(a1)
		move.w	#$20,obTimer(a1)
		rts
+		addq.b	#2,routine(a0)


Obj_Firebrand_Flame_Timer:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Firebrand_Flame_Return
		addq.b	#2,routine(a0)
		rts

Obj_Firebrand_Flame_Move:
		jsr	(Obj_Firebrand_CreateExplosion_FlameTail).l
		jsr	(SpeedToPos).w
		btst	#0,obStatus(a0)		; is boss facing left?
		bne.w	.moveleft		; if not, branch

.moveright:
		cmpi.w	#$200,obVelX(a0)
		bgt.s	.return
		add.w	#$40,obVelX(a0)
		bra.w	.return

.moveleft:
		cmpi.w	#-$200,obVelX(a0)
		blt.w	.return
		sub.w	#$40,obVelX(a0)

.return:
		jsr 	(ChkObjOnScreen).w
		beq.w	Obj_Firebrand_Flame_Return

Obj_Firebrand_Flame_Delete:
		move.l	#Go_Delete_Sprite,address(a0)

Obj_Firebrand_Flame_Return:
		rts

; ---------------------------------------------------------------------------
Obj_Firebrand_ProduceExplosions:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#6,d0
		bne.w	Obj_Firebrand_ProduceExplosions_Return
		bra.s	Obj_Firebrand_CreateExplosion

Obj_Firebrand_CreateExplosion_FlameTail:
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#6,d0
		bne.w	Obj_Firebrand_ProduceExplosions_Return
		add.b	#1,objoff_34(a0)
		cmp.b	#6,objoff_34(a0)
		blt.s	+
		clr.b	objoff_34(a0)
+		move.b	objoff_34(a0),d0
		move.b	obSubtype(a0),d1
		cmp.b	d0,d1
		bne.w	Obj_Firebrand_ProduceExplosions_Return

Obj_Firebrand_CreateExplosion:
		jsr	(Create_New_Sprite3).w
		bne.w	Obj_Firebrand_ProduceExplosions_Return
		move.l	#Obj_DEZExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		cmpi.w	#$100,(Current_zone_and_act).w
		beq.w	.gfxscz1
		cmpi.w	#$101,(Current_zone_and_act).w
		beq.w	.gfxscz2
		move.w	#$81D0,art_tile(a1)
		bra.s	.cont

.gfxscz1:
		move.w	#$8230,art_tile(a1)
		bra.s	.cont

.gfxscz2:
		move.w	#$8410,art_tile(a1)

.cont
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	obVelX(a0),d0
		neg.w	d0
		move.w	d0,x_vel(a1)
		move.w	obVelY(a0),d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)

Obj_Firebrand_ProduceExplosions_Return:
		rts

; ---------------------------------------------------------------------------
; Firebrand's fireball axis
; ---------------------------------------------------------------------------
Obj_Firebrand_FlameAxis:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Firebrand_FlameAxis_Index(pc,d0.w),d1
		jsr	Obj_Firebrand_FlameAxis_Index(pc,d1.w)
		lea	Ani_Firebrand(pc),a1
		jsr	(AnimateSprite).w
                jsr     (Obj_Firebrand_Flame_SFX).l
		jmp	(Child_DrawTouch_Sprite_Firebrand).w

Obj_Firebrand_FlameAxis_Index:
		dc.w Obj_Firebrand_FlameAxis_Main-Obj_Firebrand_FlameAxis_Index
		dc.w Obj_Firebrand_FlameAxis_ToCenter-Obj_Firebrand_FlameAxis_Index
		dc.w Obj_Firebrand_FlameAxis_WaitForShield-Obj_Firebrand_FlameAxis_Index
		dc.w Obj_Firebrand_FlameAxis_MoveLeft-Obj_Firebrand_FlameAxis_Index
		dc.w Obj_Firebrand_FlameAxis_MoveRight-Obj_Firebrand_FlameAxis_Index

Obj_Firebrand_FlameAxis_Main:
		move.l	#Map_Flames,obMap(a0)
		move.w	#$23C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$34|$80,obColType(a0)
		move.b	#3,obAnim(a0)
		move.w	#-$200,obVelX(a0)
		move.w	#$100,obVelY(a0)
		addq.b	#2,routine(a0)
		btst	#0,obStatus(a0)		; is object facing left?
		bne.w	Obj_Firebrand_FlameAxis_Return		; if not, branch
		neg.w	obVelX(a0)

Obj_Firebrand_FlameAxis_ToCenter:
		jsr	(Obj_Firebrand_ProduceExplosions).l
		jsr	(SpeedToPos).w
		move.w	obY(a0),d0
		sub.w	(Camera_target_max_y_pos).w,d0
		cmpi.w	#$50,d0
		blt.w	Obj_Firebrand_FlameAxis_Return
		move.w	#600,obTimer(a0)
		clr.w	obVelY(a0)

		jsr	SingleObjLoad2
		bne.w	Obj_Firebrand_FlameAxis_Return
		move.l	#Obj_Firebrand_FlameAxisShield,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#2,obSubtype(a1)
		move.w	a0,parent3(a1)
		move.b	#$62,objoff_48(a1)

		jsr	SingleObjLoad2
		bne.w	Obj_Firebrand_FlameAxis_Return
		move.l	#Obj_Firebrand_FlameAxisShield,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#6,obSubtype(a1)
		move.w	a0,parent3(a1)
		move.b	#$62,objoff_48(a1)


		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
		move.b	#2,objoff_48(a0)
		jsr     (Swing_Setup1).w
		addq.b	#2,routine(a0)

Obj_Firebrand_FlameAxis_WaitForShield:
		jsr	(Swing_UpAndDown_Slow).w
		jsr	(SpeedToPos).w
		cmpi.b	#0,objoff_48(a0)
		bgt.w	Obj_Firebrand_FlameAxis_Return
		clr.b	obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Firebrand_FlameAxis_MoveLeft:
		jsr	(Swing_UpAndDown_Slow).w
		sub.w	#1,obTimer(a0)
		bpl.w	+
		move.w	parent3(a0),a1
		move.w	#$3C,obTimer(a1)
		move.b	#4,routine(a1)
		addq.b	#2,objoff_34(a1)
		jsr	(Obj_Firebrand_CreateExplosion).l
		move.l	#Go_Delete_Sprite,address(a0)
		rts
+		cmpi.w	#-$200,obVelX(a0)
		blt.s	+
		move.w	obVelX(a0),d0
		sub.w	#$20,d0
		move.w	d0,obVelX(a0)
+		jsr	(SpeedToPos).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$42,d0
		bcc.w	Obj_Firebrand_FlameAxis_Return
		addq.b	#2,routine(a0)

Obj_Firebrand_FlameAxis_MoveRight:
		jsr	(Swing_UpAndDown_Slow).w
		sub.w	#1,obTimer(a0)
		bpl.w	+
		move.w	parent3(a0),a1
		move.w	#$3C,obTimer(a1)
		move.b	#4,routine(a1)
		addq.b	#2,objoff_34(a1)
		jsr	(Obj_Firebrand_CreateExplosion).l
		move.l	#Go_Delete_Sprite,address(a0)
		rts
+		cmpi.w	#$200,obVelX(a0)
		bgt.s	+
		move.w	obVelX(a0),d0
		add.w	#$20,d0
		move.w	d0,obVelX(a0)
+		jsr	(SpeedToPos).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$F6,d0
		blt.w	Obj_Firebrand_FlameAxis_Return
		subq.b	#2,routine(a0)
		bchg	#0,$2A(a0)

Obj_Firebrand_FlameAxis_Return:
		rts

; ---------------------------------------------------------------------------
; Fireballs that rotate around axis
; ---------------------------------------------------------------------------
Obj_Firebrand_FlameAxisShield:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Firebrand_FlameAxisShield_Index(pc,d0.w),d1
		jsr	Obj_Firebrand_FlameAxisShield_Index(pc,d1.w)

		jsr	(Obj_Firebrand_ProduceExplosions).l

		lea	Ani_Firebrand(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Child_DrawTouch_Sprite_Firebrand).w

Obj_Firebrand_FlameAxisShield_Index:
		dc.w Obj_Firebrand_FlameAxisShield_Main-Obj_Firebrand_FlameAxisShield_Index
		dc.w Obj_Firebrand_FlameAxisShield_IncreaseRadius-Obj_Firebrand_FlameAxisShield_Index
		dc.w Obj_Firebrand_FlameAxisShield_WaitForOthers-Obj_Firebrand_FlameAxisShield_Index
		dc.w Obj_Firebrand_FlameAxisShield_Rotate-Obj_Firebrand_FlameAxisShield_Index

Obj_Firebrand_FlameAxisShield_Main:
		move.l	#Map_Flames,obMap(a0)
		move.w	#$23C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$34|$80,obColType(a0)
		move.b	#3,obAnim(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)
		addq.b	#2,routine(a0)

Obj_Firebrand_FlameAxisShield_IncreaseRadius:
		jsr     (MoveSprite_Circular).w
		addq.b	#1,objoff_3A(a0)
		move.b	objoff_48(a0),d0
		move.b	objoff_3A(a0),d1
		cmp.b	d0,d1
		blt.w	Obj_Firebrand_FlameAxisShield_Return
		move.w	parent3(a0),a1
		sub.b	#1,objoff_48(a1)
		addq.b	#2,routine(a0)

Obj_Firebrand_FlameAxisShield_WaitForOthers:
		jsr     (MoveSprite_Circular).w
		move.w	parent3(a0),a1
		cmpi.b	#0,objoff_48(a1)
		bne.w	Obj_Firebrand_FlameAxisShield_Return
		move.b	#0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Firebrand_FlameAxisShield_Rotate:
		jsr	(Obj_Firebrand_CreateExplosion_FlameTail).l
		addq.b	#1,$3C(a0)
		jsr     (MoveSprite_Circular).w
	;	move.w	parent3(a0),a1
	;	cmpi.b	#0,routine(a1)
	;	bne.w	Obj_Firebrand_FlameAxisShield_Return
	;	move.l	#Go_Delete_Sprite,address(a0)

Obj_Firebrand_FlameAxisShield_Return:
		rts

; ---------------------------------------------------------------------------
; Flame snake that jumps
; ---------------------------------------------------------------------------
Obj_Firebrand_FlameSnake:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Firebrand_FlameSnake_Index(pc,d0.w),d1
		jsr	Obj_Firebrand_FlameSnake_Index(pc,d1.w)
		lea	Ani_Firebrand(pc),a1
		jsr	(AnimateSprite).w
                jsr     (Obj_Firebrand_Flame_SFX).l
		jmp	(Child_DrawTouch_Sprite_Firebrand).l

Obj_Firebrand_FlameSnake_Index:
		dc.w Obj_Firebrand_FlameSnake_Main-Obj_Firebrand_FlameSnake_Index
		dc.w Obj_Firebrand_FlameSnake_Fall-Obj_Firebrand_FlameSnake_Index
		dc.w Obj_Firebrand_FlameSnake_Jump-Obj_Firebrand_FlameSnake_Index

Obj_Firebrand_FlameSnake_Main:
		move.l	#Map_Flames,obMap(a0)
		move.w	#$23C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$12,obHeight(a0)
		move.b	#$12,obWidth(a0)
		move.b	#$12,x_radius(a0)
		move.b	#$12,y_radius(a0)
		move.b	#$34|$80,obColType(a0)
		move.b	#3,obAnim(a0)
		move.w	$3E(a0),d0
		move.w	d0,obTimer(a0)
		move.b	obSubtype(a0),objoff_49(a0)
		add.b	#1,objoff_49(a0)
		addq.b	#2,routine(a0)

		cmpi.b	#5,obSubtype(a0)
		beq.w	Obj_Firebrand_FlameSnake_Return
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Firebrand_FlameSnake_Return
		move.l	#Obj_Firebrand_FlameSnake,(a1)
		move.w	a0,parent3(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		add.b	#1,obSubtype(a1)
		move.w	$3E(a0),$3E(a1)
		add.w	#1,$3E(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obVelX(a0),obVelX(a1)

Obj_Firebrand_FlameSnake_Fall:
		cmpi.b	#0,objoff_48(a0)
		bne.s	+
		sub.b	#1,objoff_49(a0)
		bpl.w	Obj_Firebrand_FlameSnake_Return
+		jsr	(Obj_Firebrand_CreateExplosion_FlameTail).l
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Firebrand_FlameSnake_Return
		add.w	d1,obY(a0)

		cmpi.b	#5,objoff_48(a0)
		bcc.w	Obj_Firebrand_FlameSnake_Delete
		addq.b	#2,routine(a0)
	;	cmpi.b	#0,objoff_48(a0)
	;	bne.s	+
		rts

Obj_Firebrand_FlameSnake_Jump:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Firebrand_FlameSnake_Return
		move.w	$3E(a0),d0
		move.w	d0,obTimer(a0)
		move.w	#-$600,obVelY(a0)

		cmpi.b	#0,obSubtype(a0)
		bne.s	.othermethod
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		bra.s	.cont

.othermethod:
		move.w	parent3(a0),a1
		move.w	obVelX(a1),obVelX(a0)

.cont:
		add.b	#1,objoff_48(a0)
		subq.b	#2,routine(a0)
		rts

Obj_Firebrand_FlameSnake_Delete:
		cmpi.b	#0,obSubtype(a0)
		beq.s	.sendsignal
		bra.s	.delete

.sendsignal:
		move.w	parent3(a0),a1
		move.w	#$78,obTimer(a1)
		move.b	#4,routine(a1)
		clr.b	objoff_34(a1)

.delete:
		jsr	(Obj_Firebrand_CreateExplosion).l
		move.l	#Go_Delete_Sprite,address(a0)


Obj_Firebrand_FlameSnake_Return:
		rts
; ---------------------------------------------------------------------------
ObjDat4_Firebrand:
		dc.l Map_Firebrand		; Mapping
		dc.w $2380			; VRAM
		dc.w $200			; Priority
		dc.b 26/2			; Width	(64/2)
		dc.b 16/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $23			; Collision


DPLCPtr_Firebrand:	dc.l ArtUnc_Firebrand>>1, DPLC_Firebrand
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Firebrand/Object data/Ani - Firebrand.asm"
		include "Objects/Bosses/Firebrand/Object data/Map - Firebrand.asm"
		include "Objects/Bosses/Firebrand/Object data/DPLC - Firebrand.asm"
		include "Objects/Bosses/Firebrand/Object data/Map - Flames.asm"
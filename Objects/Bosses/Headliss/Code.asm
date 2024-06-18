; ---------------------------------------------------------------------------
; Serpent Headliss, FDZ2 boss
; ---------------------------------------------------------------------------

Obj_Headliss:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Headliss_Index(pc,d0.w),d1
		jsr	Obj_Headliss_Index(pc,d1.w)
		bsr.w	Obj_Headliss_Process
		lea	Ani_Headliss(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Headliss_Display).l
; ===========================================================================
Obj_Headliss_Index:
		dc.w Obj_Headliss_Main-Obj_Headliss_Index
		dc.w Obj_Headliss_GoDown-Obj_Headliss_Index
		dc.w Obj_Headliss_WaitForAction-Obj_Headliss_Index
		dc.w Obj_Headliss_MoveLeft-Obj_Headliss_Index
		dc.w Obj_Headliss_MoveRight-Obj_Headliss_Index
Obj_Headliss_HP:
		dc.b 10/2
		dc.b 10
		dc.b 10+6
		dc.b 10+2
; ===========================================================================

Obj_Headliss_Main:
		addq.b	#2,routine(a0)
		move.l	#SME_WmmBn,obMap(a0)
		move.w	#$23A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$C,obColType(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$1F,y_radius(a0)
		move.w	#0,(HeadlissIsFeal).w
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Headliss_HP(pc,d0.w),$29(a0)

		move.w	#$300,obVelY(a0)
		move.b	#0,objoff_49(a0)
		move.b	#8,objoff_47(a0)
		lea	ChildObjDat_HSegm(pc),a2
		jmp	(CreateChild8_TreeListRepeated).l
; ===========================================================================
Obj_Headliss_Display:
		move.b	$1C(a0),d0
		beq.s	Obj_Headliss_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Headliss_Return

Obj_Headliss_Animate:
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================
Obj_Headliss_GainSpd:
		cmpi.w	#$280,obVelX(a0)
		bgt.s	+
		move.w	obVelX(a0),d0
		add.w	#$10,d0
		move.w	d0,obVelX(a0)
+		rts


Obj_Headliss_LoseSpd:
		cmpi.w	#-$280,obVelX(a0)
		blt.s	+
		move.w	obVelX(a0),d0
		sub.w	#$10,d0
		move.w	d0,obVelX(a0)
+		rts
; ===========================================================================
Obj_Headliss_AttackBegin:
		cmpi.b	#1,objoff_49(a0)
		beq.s	Obj_Headliss_AttackAction
		subq.w	#1,objoff_46(a0)					; NOV: Fixed a naming issue
		bpl.w	Obj_Headliss_Return
		move.w	#110,objoff_46(a0)					; NOV: Fixed a naming issue
		move.b	#4,obAnim(a0)
		move.b	#1,objoff_49(a0)
		rts

Obj_Headliss_AttackAction:
		jsr	(Obj_Headliss_TeethClicking).l
		cmpi.b	#1,obAnim(a0)
		bne.s	+
		samp	sfx_HeadlissAtk
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Feal2,(a1)
		move.w	obY(a0),obY(a1)
		move.w	obX(a0),obX(a1)
		add.w	#$C,obX(a1)				; NAT: Add a slight horizontal offset to x-position to look better

		move.w	(Player_1+obX).w,d0
		sub.w	obX(a1),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		move.b	#0,objoff_49(a0)
+		rts

Obj_Headliss_Attack2:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Headliss_Return
		move.w	#60,obTimer(a0)
		cmpi.w	#0,(HeadlissIsFeal).w
		bne.w	+
		jsr	(SingleObjLoad2).w
		bne.w   Obj_Headliss_Return
		move.l	#Obj_HAxt,(a1)
		move.w	(Camera_x_pos).w,d0
		add.w	#$147,d0
		move.w	d0,obX(a1)
		jsr	(RandomNumber).w
		andi.w	#$50,d0
		addi.w	#$1A0,d0
		move.w	d0,obY(a1)
		move.w	#-$600,obVelX(a1)
+		rts

Obj_Headliss_TeethClicking:
		sub.b	#1,objoff_47(a0)
		bpl.s	+
		move.b	#8,objoff_47(a0)
		sfx	sfx_SpikeMove
+		rts
; ===========================================================================

Obj_Headliss_Process:
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$5A,$1C(a0)
		samp	sfx_KnucklesKick
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

.lacricium:
		rts
; ===========================================================================

.gone:
		move.b	#$01,(Check_dead).w
		addq.b	#2,(BackgroundEvent_routine).w
		bclr	#7,status(a0)
		move.w	#$300,x_vel(a0)
		move.w	#-$C0,y_vel(a0)
		move.l	#Obj_Headliss_EndDraw,(a0)

Obj_Headliss_EndDraw:
		btst	#2,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_DialogueFirebrand_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#32/2,$3A(a1)
		move.b	#32/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		sfx	sfx_BreakBridge
		move.b	#1,(Hyper_Sonic_flash_timer).w
+		lea	Ani_Headliss(pc),a1
		jsr	(AnimateSprite).w
		jsr	(MoveSprite2).w
		jsr	(Sprite_CheckDeleteXY).w
		btst	#7,status(a0)
		beq.s	Obj_Headliss_EndReturn
		addq.b	#2,(Dynamic_resize_routine).w
		lea	(Pal_FDZ).l,a1
		jmp	(PalLoad_Line1).w

Obj_Headliss_EndReturn:
		rts
; ===========================================================================

		lea	(Pal_FDZ).l,a1
		jsr	(PalLoad_Line1).w
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.contg
		move.b	#8,$2C(a1)

.contg:
		lea	(Pal_FDZ).l,a1
		jsr	(PalLoad_Line1).w
		jsr	(Obj_KillBloodCreate).l
		move.l	#Go_Delete_Sprite,(a0)
		rts
; ===========================================================================

Obj_Headliss_GoDown:
		jsr  (SpeedToPos).w
		cmpi.w	#$188,obY(a0)
		blt.w	Obj_Headliss_Return
		music	mus_Boss1
		command	cmd_FadeReset

		addq.b	#2,routine(a0)
		move.w	#0,obVelY(a0)
		move.w	#30,obTimer(a0)
		jmp	(Swing_Setup_AxeGhost).w

Obj_Headliss_WaitForAction:
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Headliss_Return
		addq.b	#2,routine(a0)
		move.b  #$4,(Hyper_Sonic_flash_timer).w
		samp	sfx_Teleport
		move.w	#59,obTimer(a0)
		move.w	#89,objoff_46(a0)					; NOV: Fixed a naming issue
		move.w	#$400,obVelX(a0)

Obj_Headliss_MoveLeft:
		jsr	(Obj_Headliss_AttackBegin).l
		jsr	(Obj_Headliss_Attack2).l
		jsr	(Obj_Headliss_LoseSpd).l
		jsr	(SpeedToPos).w
		jsr	(Swing_UpAndDown).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$62,d0
		bcc.w	Obj_Headliss_Return
		addq.b	#2,routine(a0)
		bchg	#0,$2A(a0)

Obj_Headliss_MoveRight:
		jsr	(Obj_Headliss_AttackBegin).l
		jsr	(Obj_Headliss_Attack2).l
		jsr	(Obj_Headliss_GainSpd).l
		jsr	(SpeedToPos).w
		jsr	(Swing_UpAndDown).w
		move.w	obX(a0),d0
		sub.w	(Camera_x_pos).w,d0
		cmpi.w	#$D6,d0
		blt.w	Obj_Headliss_Return
		subq.b	#2,routine(a0)
		bchg	#0,$2A(a0)

Obj_Headliss_Return:
		rts
; ---------------------------------------------------------------------------
; Serpent Headliss, FDZ2 boss (Cut-Scene)
; ---------------------------------------------------------------------------

Obj_HeadlissCutScene:
		move.l	#SME_WmmBn,obMap(a0)
		move.w	#$23A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$C,obColType(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.l	#HeadlissCutScene_Fall,(a0)
		lea	ChildObjDat_HSegm(pc),a2
		jsr	(CreateChild8_TreeListRepeated).l

HeadlissCutScene_Fall:
		jsr	(MoveSprite).w
		jsr	(ObjCheckFloorDist).w
		tst.w	d1
		bpl.w	HeadlissCutScene_Draw
		add.w	d1,y_pos(a0)
		move.l	#Go_Delete_Sprite,(a0)
		addq.b	#2,(Dynamic_resize_routine).w
		move.b	#4,(Hyper_Sonic_flash_timer).w
		st	(Screen_shaking_flag).w
		sfx	sfx_BreakBridge
		lea	ChildObjDat_DialogueFirebrand_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	HeadlissCutScene_Draw
		move.w	#$578,$30(a1)
		move.b	#32/2,$3A(a1)
		move.b	#32/2,$3B(a1)
		move.w	#$100,$3C(a1)

HeadlissCutScene_Draw:
		lea	Ani_Headliss(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteXY).w
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Headliss/Object data/Ani - Headliss.asm"
		include "Objects/Bosses/Headliss/Object data/Map - Headliss.asm"

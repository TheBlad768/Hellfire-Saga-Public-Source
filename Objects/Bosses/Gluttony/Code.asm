Obj_Gluttony:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Gluttony_Index(pc,d0.w),d1
		jsr	Obj_Gluttony_Index(pc,d1.w)
		bsr.w	Obj_Gluttony_Process
		lea	Ani_Gluttony(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Gluttony_Display).l
; ===========================================================================
Obj_Gluttony_Index:
		dc.w Obj_Gluttony_Main-Obj_Gluttony_Index
		dc.w Obj_Gluttony_Start-Obj_Gluttony_Index
		dc.w Obj_Gluttony_GetReady-Obj_Gluttony_Index
		dc.w Obj_Gluttony_Move-Obj_Gluttony_Index
		dc.w Obj_Gluttony_Spew-Obj_Gluttony_Index
Obj_Gluttony_HP:
		dc.b 6/2
		dc.b 6
		dc.b 6+2
		dc.b 6+2
; ===========================================================================

Obj_Gluttony_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Gluttony,obMap(a0)
		move.w	#$23A0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$C,obColType(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$1F,y_radius(a0)

		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Gluttony_HP(pc,d0.w),$29(a0)

		move.w	#-$300,obVelX(a0)
		move.w	#150,objoff_46(a0)				; NOV: Fixed a naming issue
		move.b	#1,objoff_49(a0)
                rts
; ===========================================================================

Obj_Gluttony_Display:
		move.b	$1C(a0),d0
		beq.s	Obj_Gluttony_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Gluttony_Return

Obj_Gluttony_Animate:
		jmp	(Draw_And_Touch_Sprite).w


; ===========================================================================

Obj_Gluttony_CountDown:
		subq.w	#1,objoff_46(a0)				; NOV: Fixed a naming issue
		bpl.s	++
		move.w	#5,objoff_46(a0)
		move.b	#0,objoff_48(a0)
		move.b  #1,obAnim(a0)
		move.b	#0,objoff_45(a0)
                move.w (Player_1+$10).w,d0
                sub.w   $10(a0),d0
                cmpi.w  #1,d0
                blt.s   +
		move.b	#1,objoff_45(a0)
+		move.b	#8,routine(a0)
+		rts

Obj_Gluttony_Spewing:
		subq.w	#1,objoff_46(a0)				; NOV: Fixed a naming issue
		bpl.s	+
		move.w	#5,objoff_46(a0)				; NOV: Fixed a naming issue
		add.b	#1,objoff_48(a0)
		sfx	sfx_LavaBall
		jsr	(SingleObjLoad2).w
		bne.w   Obj_Gluttony_Return
                move.l	#Obj_Vomit,(a1)
		move.w	obY(a0),obY(a1)
		add.w	#$8,obY(a1)
		move.w	obX(a0),obX(a1)
		move.b	objoff_45(a0),objoff_45(a1)
+		rts

; ===========================================================================

Obj_Gluttony_Process:
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $1C(a0)
		bne.s   .whatizit
		move.b  #$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b  #1,$1C(a0)
		bne.s    .lacricium
		bclr     #6,$2A(a0)
		move.b   $25(a0),$28(a0)
		bra.w	.lacricium


.gone:
		move.b  #$01,(Check_GluttonyDead).w
		move.w	#1,(AstarothCompleted).w
		samp	sfx_GluttonyDeath
		jsr	(Obj_KillBloodCreate).l
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.contg
		move.b	#8,$2C(a1)

.contg:
		move.l #Delete_Current_Sprite,(a0)


.lacricium:
		rts

; ===========================================================================
Obj_Gluttony_DiffTest:
		jsr	(MoveSprite2).w
		cmpi.b	#1,objoff_33(a0)
		beq.w	.rightdiff

.leftdiff:
		cmpi.w	#-$300,obVelX(a0)
		blt.s	.return
		move.w	obVelX(a0),d0
		sub.w	#$70,d0
		move.w	d0,obVelX(a0)
                rts


.rightdiff:
		cmpi.w	#$300,obVelX(a0)
		bgt.s	.return
		move.w	obVelX(a0),d0
		add.w	#$70,d0
		move.w	d0,obVelX(a0)

.return:
		rts

Obj_Gluttony_StayInCameraLeft:
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$10,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.s	+
		move.b	#1,objoff_33(a0)
		bset	#0,obStatus(a0)
+		rts

Obj_Gluttony_StayInCameraRight:
		move.w	(Camera_min_X_pos).w,d0
		add.w	#$120,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.s	+
		move.b	#0,objoff_33(a0)
		bclr	#0,obStatus(a0)
+		rts

Obj_Gluttony_Start:
		jsr	(SpeedToPos).w
		move.w	(Camera_min_X_pos).w,d0
		add.w	#$110,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.s	+
		addq.b	#2,routine(a0)
+		rts

Obj_Gluttony_GetReady:
		addq.b	#2,routine(a0)
		rts


Obj_Gluttony_Move:
		jsr	(Obj_Gluttony_DiffTest).l
		jsr	(Obj_Gluttony_CountDown).l
		jsr	(Obj_Gluttony_StayInCameraLeft).l
		jsr	(Obj_Gluttony_StayInCameraRight).l
		rts

Obj_Gluttony_Spew:
		jsr	(Obj_Gluttony_Spewing).l
		cmpi.b	#9,objoff_48(a0)
		blt.w	Obj_Gluttony_Return
		move.b  #0,obAnim(a0)
		move.w	#150,objoff_46(a0)					; NOV: Fixed a naming issue
		subq.b	#2,routine(a0)

Obj_Gluttony_Return:
		rts
; ===========================================================================

Obj_GBORD:
                move.w  #0,obGfx(a0)
		move.l	#SME__C8I2,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.l	#Obj_GBORD_Fly,(a0)

Obj_GBORD_Fly:
		rts




		include "Objects/Bosses/Gluttony/Object data/Ani - Gluttony.asm"
		include "Objects/Bosses/Gluttony/Object data/Map - Gluttony.asm"
		include "Objects/Bosses/Gluttony/Object data/Map - Gluttony2.asm"
		include "Objects/Bosses/Gluttony/Vomit.asm"

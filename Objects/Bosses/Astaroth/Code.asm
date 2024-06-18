; ---------------------------------------------------------------------------
; Astaroth, the great demon king that would be killed in FDZ3
; ---------------------------------------------------------------------------

Obj_Astaroth:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Astaroth_Index(pc,d0.w),d1
		jsr	Obj_Astaroth_Index(pc,d1.w)
		bsr.w	Obj_Astaroth_Process
		lea	Ani_Astaroth(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Obj_Astaroth_Display).l
; ===========================================================================
Obj_Astaroth_Index:
		dc.w Obj_Astaroth_Main-Obj_Astaroth_Index			; 0
		dc.w Obj_Astaroth_FacingLeft_MoveLeft-Obj_Astaroth_Index	; 2
		dc.w Obj_Astaroth_FacingLeft_Stay1-Obj_Astaroth_Index		; 4
		dc.w Obj_Astaroth_FacingLeft_MoveRight-Obj_Astaroth_Index	; 6
		dc.w Obj_Astaroth_FacingLeft_Stay2-Obj_Astaroth_Index		; 8
		dc.w Obj_Astaroth_FacingRight_MoveLeft-Obj_Astaroth_Index	; A
		dc.w Obj_Astaroth_FacingRight_Stay1-Obj_Astaroth_Index		; C
		dc.w Obj_Astaroth_FacingRight_MoveRight-Obj_Astaroth_Index	; E
		dc.w Obj_Astaroth_FacingRight_Stay2-Obj_Astaroth_Index		; 10
		dc.w Obj_Astaroth_BreathFire-Obj_Astaroth_Index			; 12
Obj_Astaroth_HP:
		dc.b 8/2
		dc.b 8
		dc.b 8+2
		dc.b 8+2
; ===========================================================================

Obj_Astaroth_Main:
		addq.b	#2,routine(a0)
		move.l	#Map_Astaroth,obMap(a0)
		move.w	#$2340,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$F,obColType(a0)
		move.b	#$1F,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$1F,x_radius(a0)
		move.b	#$1F,y_radius(a0)

		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Astaroth_HP(pc,d0.w),$29(a0)

		move.w	#-$200,obVelX(a0)
		move.w	#300,objoff_46(a0)					; NOV: Fixed a naming issue
		move.b	#1,objoff_3B(a0)
		rts
; ===========================================================================

Obj_Astaroth_Display:
		move.b	$1C(a0),d0
		beq.s	Obj_Astaroth_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Astaroth_Return

Obj_Astaroth_Animate:
		jmp	(Draw_And_Touch_Sprite).w


; ===========================================================================

Obj_Astaroth_CountDown:
		subq.w	#1,objoff_46(a0)					; NOV: Fixed a naming issue
		bpl.w	Obj_Astaroth_Return
		move.b	#1,obAnim(a0)
		move.b	#$3C,obTimer(a0)
		move.w	#9,objoff_46(a0)					; NOV: Fixed a naming issue
		move.b	routine(a0),obSubtype(a0)
		move.b	#5,objoff_49(a0)
		move.b	#$12,routine(a0)
		rts

Obj_Astaroth_Firee:
		subq.w	#1,objoff_46(a0)					; NOV: Fixed a naming issue
		bpl.w	Obj_Astaroth_Return
		move.w	#4,objoff_46(a0)					; NOV: Fixed a naming issue
		add.w	#2,objoff_16(a0)
		sfx	sfx_LavaBall
		jsr	(SingleObjLoad2).w
		bne.w   Obj_Astaroth_Return
                move.l	#Obj_AstFire,(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.w	#$1D6,obY(a1)
		move.w	obX(a0),obX(a1)
		move.w	#39,obTimer(a1)
		move.w	objoff_16(a0),d0
		mulu.w	#2,d0
		add.w	d0,obTimer(a1)

; ===========================================================================

Obj_Astaroth_Process:
		tst.b   $28(a0)
		bne.w   .lacricium
		tst.b   $29(a0)
		beq.w   .gone
		tst.b   $1C(a0)
		bne.w   .whatizit
		move.b  #$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)

		move.w	#$14,(Screen_Shaking_Flag).w

		jsr	(SingleObjLoad2).w
		bne.w   Obj_Astaroth_Return
                move.l	#Obj_AstWarnSt,(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).w
                andi.w	#$FF,d0
                addi.w	#$10,d0
                move.w	(v_screenposx).w,d1 ; Copy camera Xpos into d0
                add.w	d0,d1
                move.w	d1,obX(a1)

		jsr	(SingleObjLoad2).w
		bne.w   Obj_Astaroth_Return
                move.l	#Obj_AstWarnSt,(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).w
                andi.w	#$FF,d0
                addi.w	#$10,d0
                move.w	(v_screenposx).w,d1 ; Copy camera Xpos into d0
                add.w	d0,d1
                move.w	d1,obX(a1)

		jsr	(SingleObjLoad2).w
		bne.w   Obj_Astaroth_Return
                move.l	#Obj_AstWarnSt,(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).w
                andi.w	#$FF,d0
                addi.w	#$10,d0
                move.w	(v_screenposx).w,d1 ; Copy camera Xpos into d0
                add.w	d0,d1
                move.w	d1,obX(a1)

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b  #1,$1C(a0)
		bne.w    .lacricium
		bclr     #6,$2A(a0)
		move.b   $25(a0),$28(a0)
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
		move.l	#Go_Delete_Sprite,(a0)

.lacricium:
		rts
; ===========================================================================

Obj_Astaroth_FacingLeft_MoveLeft:
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(Obj_Astaroth_CountDown).l
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$AB,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_Astaroth_Return
		move.b	#$1D,obTimer(a0)
		move.b	#4,obAnim(a0)
		move.b	#4,routine(a0)
		rts

Obj_Astaroth_FacingLeft_Stay1:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Astaroth_Return
		move.b	#0,obAnim(a0)
		btst	#0,obStatus(a0)	; facing left?
		bne.w	+	; if not, branch
		neg.w	obVelX(a0)
		move.b	#6,routine(a0)
		rts

+		move.b	#$A,routine(a0)
		rts

Obj_Astaroth_FacingLeft_MoveRight:
		jsr	(Obj_Astaroth_CountDown).l
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$11C,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Astaroth_Return
		move.b	#$1D,obTimer(a0)
		move.b	#8,routine(a0)
		move.b	#4,obAnim(a0)
		rts

Obj_Astaroth_FacingLeft_Stay2:
		subq.b	#1,obTimer(a0)
		bpl.s	+
		move.b	#0,obAnim(a0)
		move.b	#2,routine(a0)
		neg.w	obVelX(a0)
+		rts

Obj_Astaroth_FacingRight_MoveLeft:
		jsr	(Obj_Astaroth_CountDown).l
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$3A,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_Astaroth_Return
		move.b	#$1D,obTimer(a0)
		move.b	#4,obAnim(a0)
		move.b	#$C,routine(a0)
		rts

Obj_Astaroth_FacingRight_Stay1:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Astaroth_Return
		move.b	#0,obAnim(a0)
		neg.w	obVelX(a0)
		addq.b	#2,routine(a0)

Obj_Astaroth_FacingRight_MoveRight:
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(Obj_Astaroth_CountDown).l
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$AB,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Astaroth_Return
		move.b	#$1D,obTimer(a0)
		move.b	#4,obAnim(a0)
		move.b	#$10,routine(a0)
		rts

Obj_Astaroth_FacingRight_Stay2:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Astaroth_Return
		move.b	#0,obAnim(a0)
		btst	#0,obStatus(a0)	; facing left?
		bne.w	+	; if not, branch
		move.b	#6,routine(a0)
		rts
+		move.b	#$A,routine(a0)
		neg.w	obVelX(a0)
		rts

Obj_Astaroth_BreathFire:
		jsr	(Obj_Eggman_LookOnSonic).l
		jsr	(Obj_Astaroth_Firee).l
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_Astaroth_Return
		move.w	#180,objoff_46(a0)					; NOV: Fixed a naming issue
		move.b	#0,obAnim(a0)
		clr.w	objoff_16(a0)
		move.b	obSubtype(a0),routine(a0)
		rts


Obj_Astaroth_Return:
		rts
; ===========================================================================



		include "Objects/Bosses/Astaroth/Object data/Ani - Astaroth.asm"
		include "Objects/Bosses/Astaroth/Object data/Map - Astaroth.asm"
		include "Objects/Bosses/Astaroth/Fire.asm"
		include "Objects/Bosses/Astaroth/Stone.asm"

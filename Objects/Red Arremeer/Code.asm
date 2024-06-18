; ---------------------------------------------------------------------------
; Red Arremeer (special badnik meeted in FDZ3 near megaboss area)
; ---------------------------------------------------------------------------

Obj_RedArremeer:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_RedArremeer_Index(pc,d0.w),d1
		jsr	Obj_RedArremeer_Index(pc,d1.w)
		bsr.w	Obj_RedArremeer_Process
		lea	Ani_Firebrand(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ===========================================================================
Obj_RedArremeer_Index:
		dc.w Obj_RedArremeer_Main-Obj_RedArremeer_Index
		dc.w Obj_RedArremeer_SetAttributes-Obj_RedArremeer_Index
		dc.w Obj_RedArremeer_ChkSonic-Obj_RedArremeer_Index
		dc.w Obj_RedArremeer_FlyUp-Obj_RedArremeer_Index
		dc.w Obj_RedArremeer_Dead-Obj_RedArremeer_Index
; ===========================================================================

Obj_RedArremeer_Main:
		addq.b	#2,routine(a0)
		move.l	#SME_pnN5c,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$23,obColType(a0)
		move.b	#$10,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.b	#20,objoff_46(a0)
		move.b	#4,$29(a0)
; ===========================================================================

Obj_RedArremeer_Process:
		tst.b	$28(a0)
		bne.s	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b  #$20,$1C(a0)
		samp	sfx_FireHurt
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		move.b	#1,obAnim(a0)
		subq.b	#1,$1C(a0)
		bne.s	.lacricium
		move.b	#0,obAnim(a0)
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		bra.s	.lacricium

.gone:
		move.b	#8,routine(a0)

.lacricium:
		rts

; ===========================================================================

Obj_RedArremeer_SetAttributes:
		cmpi.b  #1,(Firebrand_InterlPassed).w
		beq.s	+
		move.w	#-$200,obVelX(a0)
		move.w	#$200,obVelY(a0)
		addq.b	#2,routine(a0)
		rts

+		jmp	(DeleteObject).w

Obj_RedArremeer_ChkSonic:
		jsr	(SpeedToPos).w
		subq.w	#5,obVelY(a0)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		neg.w	d0
		cmpi.w	#$6A,d0
		bcc.w	Obj_RedArremeer_Return
		addq.b	#2,routine(a0)
		move.w	#-$100,obVelX(a0)
		move.b	#0,obAnim(a0)
		cmpi.b	#0,obSubtype(a0)
		beq.w	+
		jsr	(SingleObjLoad).w
		bne.w	Obj_RedArremeer_Return
		move.l	#Obj_Fire_Missile,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$100,obVelX(a1)
		move.w	#-$500,obVelY(a1)
		sfx	sfx_FireAttack

+		cmpi.b	#1,obSubtype(a0)
		beq.w	+
		bchg	#0,obStatus(a0)
		move.w	#$200,obVelX(a0)
		move.w	#-$400,obVelY(a0)
		rts

+		move.w	#0,obVelX(a0)
		move.w	#-$500,obVelY(a0)

Obj_RedArremeer_FlyUp:
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.w	Obj_RedArremeer_Return
		jmp	(DeleteObject).w

Obj_RedArremeer_Dead:
		moveq	#100,d0
		jsr	(AddPoints).l	; add 1000 points
		samp	sfx_FireDeath
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	Obj_RedArremeer_Return
		move.b	#8,$2C(a1)
		jsr	(Obj_KillBloodCreate).l

Obj_RedArremeer_Return:
		rts
; ===========================================================================

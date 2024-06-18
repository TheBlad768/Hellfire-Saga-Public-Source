; ---------------------------------------------------------------------------
; Honey the Hell girl, miniboss in SCZ1
; ---------------------------------------------------------------------------

Obj_Honey:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Honey_Index(pc,d0.w),d1
		jsr	Obj_Honey_Index(pc,d1.w)
		jmp	(Obj_Honey_Display).l
; ===========================================================================

Obj_Honey_Index:
		dc.w Obj_Honey_Main-Obj_Honey_Index
		dc.w Obj_Honey_ShipMain-Obj_Honey_Index
; ===========================================================================

Obj_Honey_Main:
		addq.b	#2,routine(a0)
		move.l	#SME_XIrUq,obMap(a0)
		move.w	#$3D0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$23,obColType(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)						; set touch response
		move.w  obX(a0),obX(a0)					; copy X-pos to secondary X-pos
		move.w	obY(a0),obY(a0)					; copy Y-pos to secondary Y-pos
		move.b  #6,$29(a0) 					; Honey has little hp

Obj_Honey_ShipMain:
		moveq	#0,d0
		move.b	routine_secondary(a0),d0
		move.w	Obj_Honey_ShipIndex(pc,d0.w),d1
		jsr	Obj_Honey_ShipIndex(pc,d1.w)
		bsr.w	Obj_Honey_ShipProcess
		lea	(Ani_Honey).l,a1
		jmp	(AnimateSprite).w
; ===========================================================================

Obj_Honey_ShipIndex:
		dc.w Obj_Honey_MoveLeft-Obj_Honey_ShipIndex ; 0
		dc.w Obj_Honey_MoveRight-Obj_Honey_ShipIndex ; 2
		dc.w Obj_Honey_MoveLeftFire-Obj_Honey_ShipIndex ;4
		dc.w Obj_Honey_MoveRightFire-Obj_Honey_ShipIndex ;6
		dc.w Obj_Honey_FlyLeft-Obj_Honey_ShipIndex ;8
		dc.w Obj_Honey_FlyRight-Obj_Honey_ShipIndex ; $A
		dc.w Obj_Honey_Dead-Obj_Honey_ShipIndex ; $C

; ===========================================================================

Obj_Honey_Display:
		move.b	$1C(a0),d0
		beq.s	Obj_Honey_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Honey_Display_RTS

Obj_Honey_Animate:
		jmp	(Draw_And_Touch_Sprite).w

Obj_Honey_Display_RTS:
		rts
; ===========================================================================

Obj_Honey_ShipProcess:
		tst.b   $28(a0)
		bne.s   .lacricium
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $1C(a0)
		bne.s   .whatizit
		move.b  #$20,$1C(a0)
		;move.b	#0,obColType(a0)
		samp	sfx_HoneyHurt
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b  #1,$1C(a0)
		bne.s   .lacricium
		;move.b	#23,obColType(a0)
		bclr    #6,$2A(a0)
		move.b  $25(a0),$28(a0)
		bra.s	.lacricium

.gone:
		move.b	#$C,routine_secondary(a0)

.lacricium:
		rts

; ===========================================================================

Obj_Honey_Attack:
		subq.b	#1,obTimer(a0)
		bpl.s	loc_HoneyRage
		move.b	#10,obTimer(a0)
		jsr     (RandomNumber).w
		andi.b  #10,d0
		addi.b  d0,obTimer(a0)
		jsr	(SingleObjLoad2).w
		bne.s	loc_HoneyRage
		move.l	#Obj_Love_Bullet2,(a1)	; load missile object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w 	#-$300,obVelY(a1);

loc_HoneyRage:
		rts
; ===========================================================================

Obj_Honey_MoveLeft:
		move.w  #$2B7,obY(a0);
		move.b	#0,obAnim(a0)
		move.w	#-$500,obVelX(a0)
		move.w	#0,obVelY(a0)
		jsr	(SpeedToPos).w
		cmpi.w	#$2230,obX(a0)			; has the ship reached $338 on Y-axis?
		bcc.w	Obj_Honey_Return 	; if not, branch
		bchg	#0,obStatus(a0)
		addq.b	#2,routine_secondary(a0)				; goto next routine

Obj_Honey_MoveRight:
		move.w	#$500,obVelX(a0)
		jsr	(SpeedToPos).w
		cmpi.w	#$2450,obX(a0)			;
		blt.w	Obj_Honey_Return 	; if not, branch
		bchg	#0,obStatus(a0)
		move.w	#0,obVelY(a0)
		move.b	#$9A,obColType(a0)
		move.b	#1,obAnim(a0)
		addq.b	#2,routine_secondary(a0)

Obj_Honey_MoveLeftFire:
		move.w	#-$500,obVelX(a0)
		move.w	#0,obVelY(a0)
		jsr	(SpeedToPos).w
		cmpi.w	#$2230,obX(a0)			; has the ship reached $338 on Y-axis?
		bcc.w	Obj_Honey_Return 	; if not, branch
		bchg	#0,obStatus(a0)
		addq.b	#2,routine_secondary(a0)				; goto next routine

Obj_Honey_MoveRightFire:
		move.w	#$500,obVelX(a0)
		jsr	(SpeedToPos).w
		cmpi.w	#$2450,obX(a0)			;
		blt.w	Obj_Honey_Return 	; if not, branch
		bchg	#0,obStatus(a0)
		move.w	#0,obVelY(a0)
		move.w  #$236,obY(a0);
		move.b	#2,obAnim(a0)
		move.b	#5,obTimer(a0)
		addq.b	#2,routine_secondary(a0)

Obj_Honey_FlyLeft:
		move.w	#-$580,obVelX(a0)
		move.w	#0,obVelY(a0)
		jsr	(SpeedToPos).w
		bsr.w   Obj_Honey_Attack
		cmpi.w	#$2240,obX(a0)			; has the ship reached $338 on Y-axis?
		bcc.w	Obj_Honey_Return 	; if not, branch
		bchg	#0,obStatus(a0)
		addq.b	#2,routine_secondary(a0)

Obj_Honey_FlyRight:
		move.w	#$580,obVelX(a0)
		jsr	(SpeedToPos).w
		bsr.w   Obj_Honey_Attack
		cmpi.w	#$2440,obX(a0)			;
		blt.w	Obj_Honey_Return 	; if not, branch
		move.b	#$F,obColType(a0)
		bchg	#0,obStatus(a0)
		move.w	#0,obVelY(a0)
		move.b	#0,routine_secondary(a0)
		bra.w	Obj_Honey_Return

Obj_Honey_Dead:
		moveq	#100,d0
		jsr	(AddPoints).l	; add 1000 points
		samp	sfx_HoneyDeath
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	loc_bloodisha
		move.b	#8,$2C(a1)

loc_bloodisha:
		jsr	(Obj_HurtBloodCreate).l
		fadeout
                jmp	(Obj_EndSignControl).l

Obj_Honey_Return:
		rts

; ===========================================================================





		include "Objects/Bosses/Honey/Object data/Ani - Honey.asm"
		include "Objects/Bosses/Honey/Object data/Map - Honey.asm"

; ===========================================================================
; Feal (badnik)
; ===========================================================================
; mostest kawaiiest
Obj_Feal:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Feal_Index(pc,d0.w),d1
		jsr	Obj_Feal_Index(pc,d1.w)
		bsr.w	Obj_Feal_process
		lea	(Ani_Feal).l,a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

Obj_Feal_Index:
		dc.w Obj_Feal_Main-Obj_Feal_Index	; 0
		dc.w Obj_Feal_Jump-Obj_Feal_Index	; 4
		dc.w Obj_Feal_Fall-Obj_Feal_Index	; 2
		dc.w Obj_Feal_Dead-Obj_Feal_Index	; 6
; ---------------------------------------------------------------------------

Obj_Feal_CorrectAni:
		cmpi.w  #0,obVelY(a0)
		bpl.s   +
		move.b	#0,obAnim(a0)
		rts
+		move.b	#1,obAnim(a0)
		rts

Obj_Feal_Main:
		move.b	#$5,obColType(a0)
		move.l	#SME_SAE0M,obMap(a0)
		cmpi.w	#$001,(Current_zone_and_act).w
		beq.s	.fdz2gfx
		cmpi.w	#$002,(Current_zone_and_act).w
		beq.s	.fdz3gfx
		cmpi.w	#$100,(Current_zone_and_act).w
		beq.w	.scz1gfx
		cmpi.w	#$203,(Current_zone_and_act).w
		beq.w	.gmz4gfx
		cmpi.w	#$400,(Current_zone_and_act).w
		beq.w	.creditsgfx
		move.w	#$470,obGfx(a0)
		bra.w	.contload

.creditsgfx:
		move.w	#(VRAM_CreditsFeal/$20),obGfx(a0)	; MJ: pattern index for credits
		sf.b	obColType(a0)				; MJ: set no collision
		bra.s	.contload

.fdz2gfx:
		move.w	#$3E8,obGfx(a0)
		bra.s	.contload

.fdz3gfx:
		move.w	#$38B,obGfx(a0)
		bra.s	.contload

.scz1gfx:
		move.w	#$3D9,obGfx(a0)
		bra.s	.contload

.gmz4gfx:
		move.w	#$403,obGfx(a0)

.contload:
+		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$0C,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$0C,y_radius(a0)
		move.b	#0,obAnim(a0)
		move.b  #1,$29(a0)
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	+
                add.w	d1,obY(a0)
+		cmpi.w	#$201,(Current_zone_and_act).w
		beq.w	+
		addq.b	#2,routine(a0)
		rts

+		addq.b	#4,routine(a0)
		rts

Obj_Feal_process:
		cmpi.b  #1,(Lust_Dead).w
		beq.s	.gone
		cmpi.b	#6,routine(a0)
		bcc.w	.lacricium
		tst.b   $29(a0)
		bne.s	.lacricium

.gone:
		move.b	#6,routine(a0)

.lacricium:
		rts

Obj_Feal_Jump:
                jsr	(Obj_Feal_CorrectAni).l
		jsr	(Find_Sonic).w
		cmpi.w	#$120,d2
		bcc.w	Obj_Feal_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		addq.b	#2,routine(a0)
		move.w	#-$100,obVelX(a0)
	        btst    #0,$2A(a0)
	        beq.s    +
	        neg.w    obVelX(a0)
+		jsr	(Find_Sonic).w
		cmpi.w	#$40,d2
		bcc.w	+
		move.w	#-$400,obVelY(a0)
		rts
+		move.w	#-$200,obVelY(a0)

Obj_Feal_Fall:  
                jsr	(Obj_Feal_CorrectAni).l
		jsr	(Obj_Feal_CheckWalls).l
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Feal_Return
                add.w d1,obY(a0)
		subq.b	#2,routine(a0)  
		move.w	#$3C,obTimer(a0)
		clr.l	obVelX(a0)
		bra.w   Obj_Feal_Return

Obj_Feal_Dead:
                samp	sfx_WeaselDeath
		jsr	(Obj_HurtBloodCreate).l
                move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)

Obj_Feal_Return:
		rts

Obj_Feal_CheckWalls:
		moveq	#4,d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	+
		add.w	d1,obX(a0)
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
		rts
+		moveq	#4,d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	+
		add.w	d1,obX(a0)
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
+		rts
; ---------------------------------------------------------------------------

		include "Objects/Feal/Object data/Ani - Feal.asm"
		include "Objects/Feal/Object data/Map - Feal.asm"

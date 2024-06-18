; ---------------------------------------------------------------------------
; Fly (Weasel in SCZ)
; ---------------------------------------------------------------------------

Obj_Fly:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Fly_Index(pc,d0.w),d1
		jsr	Fly_Index(pc,d1.w)
		bsr.w	Fly_process
		lea	Ani_Fly(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w
; ---------------------------------------------------------------------------

Fly_Index:
		dc.w Fly_Main-Fly_Index	; 0
		dc.w Fly_Move-Fly_Index	; 2

; ---------------------------------------------------------------------------

Fly_Main:
		addq.b	#2,routine(a0)

		cmpi.w	#$0300,(Current_zone).w			; MJ: is this DDZ?
		beq.s	.continueload				; MJ: if so, skip (events routine will set it)

		cmpi.w	#$102,(Current_zone_and_act).w
		beq.w	.loadgdxscz
		cmpi.w	#$001,(Current_zone_and_act).w
		beq.s	.altgfx
		move.w	#$A370,obGfx(a0)
		move.l	#SME_4wiHA,obMap(a0)
		bra.s	.continueload

.loadgdxscz:
		move.w	#$845F,obGfx(a0)
		move.l	#SME_K0BGh,obMap(a0)

.altgfx:
		move.w	#$A3E8,obGfx(a0)
		move.l	#SME_4wiHA,obMap(a0)

.continueload
		move.b	#4,obRender(a0)
		move.b	#$B,obColType(a0)
		move.w	#2*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#2,obWidth(a0)
		move.b	#4,x_radius(a0)
		move.b	#2,y_radius(a0)
		move.b	#0,obAnim(a0)
		move.b  #1,$29(a0)

; ---------------------------------------------------------------------------

Fly_process:
		cmpi.b  #1,(Lust_Dead).w
		beq.w	Fly_gone
		tst.b   $29(a0)
		beq.s   Fly_gone
		bra.w   Fly_Return

Fly_gone:
		cmpi.w	#$102,(Current_zone_and_act).w
		bne.s	.continuedeath
		jsr	(Obj_HurtBloodCreate).l

.continuedeath:
		move.l	#Obj_Explosion,(a0)
                clr.b   routine(a0)

; ---------------------------------------------------------------------------
Fly_Move:
		cmpi.w	#$0300,(Current_zone).w			; MJ: is this DDZ?
		bne.s	.NoDDZ					; MJ: if not, continue normally
		tst.b	(RDD_Worm+WmHeadMode).l			; MJ: has the worm boss been destroyed?
		bpl.s	.NoDDZ					; MJ: if not, continue
		sf.b	routine(a0)				; MJ: reset routine counter
		addq.w	#$04,sp					; MJ: skip return address
		lea	(Obj_Explosion).l,a1			; MJ: change fly to an explosion
		move.l	a1,(a0)					; MJ: ''
		jmp	(a1)					; MJ: run explosion routine

	.NoDDZ:
                jsr	(Find_Sonic).w
		cmpi.w	#$F0,d2
		bcc.s	Fly_Move2
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	Fly_Move2
		bclr	#0,obStatus(a0)

Fly_Move2:
		cmpi.w	#$102,(Current_zone_and_act).w
		beq.s	.weaselfastermove
		jsr	(Find_SonicTails).w
		move.w	#$100,d0
		moveq	#$10,d1
		bra.s	.setallshit

.weaselfastermove:
		jsr	(Find_SonicTails).w
		move.w	#$150,d0
		moveq	#$10,d1

.setallshit:
		jsr	(Chase_Object).w
		jmp	(MoveSprite2).w

; ---------------------------------------------------------------------------

Fly_Return:
		rts


		include "Objects/Fly/Object data/Ani - Fly.asm"
		include "Objects/Fly/Object data/Map - Fly.asm"
		include "Objects/Fly/Object data/Map - Weasel.asm"
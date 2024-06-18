; ---------------------------------------------------------------------------
; Ghost
; ---------------------------------------------------------------------------

Obj_Ghost:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Ghost_Index(pc,d0.w),d1
		jsr	Obj_Ghost_Index(pc,d1.w)
		bsr.w	Obj_Ghost_Process
		lea	Ani_Ghost(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Sprite_CheckDeleteTouch).w

; ===========================================================================
Obj_Ghost_Index:
		dc.w	Obj_Ghost_Main-Obj_Ghost_Index
		dc.w	Obj_Ghost_Move-Obj_Ghost_Index
		dc.w	Obj_Ghost_Dead-Obj_Ghost_Index
; ===========================================================================

Obj_Ghost_Main:
		addq.b	#2,routine(a0)
		move.l	#SME_Pm5R3,obMap(a0)
		move.w	#$2C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$C,obColType(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.b  #0,obAnim(a0)
		move.b  #1,$29(a0)
		move.b	#$A,obTimer(a0)					; NOV: Fixed a naming issue
		bchg	#0,obStatus(a0)	; change object's orientation
		rts
; ===========================================================================

Obj_Ghost_Process:
		tst.b   $29(a0)
		beq.s   Obj_Ghost_gone
		rts

Obj_Ghost_gone:
                move.b	#0,obColType(a0)
                move.b  #1,obAnim(a0)
		move.b	#4,routine(a0)
		rts

; ===========================================================================

Obj_Ghost_Move:
                jsr	(Find_Sonic).w
		cmpi.w	#$F0,d2
		bcc.s	Obj_Ghost_Move2
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	Obj_Ghost_Move2
		bclr	#0,obStatus(a0)

Obj_Ghost_Move2:
		jsr	(Find_SonicTails).w
		cmpi.w	#1,obSubtype(a0)
		beq.s 	.bigger
		move.w	#$190,d0
		bra.s	.cont

.bigger:
		move.w	#$200,d0

.cont:
		moveq	#$10,d1
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w
		rts
; ===========================================================================

Obj_Ghost_Dead:
		subq.b	#1,obTimer(a0)					; NOV: Fixed a naming issue
		bpl.s	Obj_Ghost_Return
		move.l #loc_85088,(a0)

Obj_Ghost_Return:
		rts

; ============================================================================
		include "Objects/Ghost/Object data/Ani - Ghost.asm"
		include "Objects/Ghost/Object data/Map - Ghost.asm"



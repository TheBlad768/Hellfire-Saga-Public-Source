; ---------------------------------------------------------------------------
; Words that appear shortly before Hellgirl/Lust's death
; ---------------------------------------------------------------------------

Obj_Monologue2:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_Monologue2_Index(pc,d0.w),d1
		jmp	Obj_Monologue2_Index(pc,d1.w)
; ===========================================================================
Obj_Monologue2_Index:
		dc.w Obj_Monologue2_Main-Obj_Monologue2_Index
		dc.w Obj_Monologue2_5time-Obj_Monologue2_Index
		dc.w Obj_Monologue2_6time-Obj_Monologue2_Index
; ===========================================================================

Obj_Monologue2_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_Wsm4w,obMap(a0)
		move.w	#$560,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#4,obAnim(a0)
		move.w	#120,obTimer(a0)
; ===========================================================================


Obj_Monologue2_5time:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Monologue2_Animate
		move.w	#120,obTimer(a0)
		addq.b	#2,obRoutine(a0)
		
Obj_Monologue2_6time:
		move.b	#5,obAnim(a0)
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Monologue2_Animate
                jmp	(DeleteObject).w

; ===========================================================================

Obj_Monologue2_Animate:
		lea	(Ani_Monologue).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ============================================================================

; ---------------------------------------------------------------------------
; Words that appear when Mecha Sonic transforms in Mecha Devil
; ---------------------------------------------------------------------------

Obj_Mecha_Monologue2:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_Mecha_Monologue2_Index(pc,d0.w),d1
		jmp	Obj_Mecha_Monologue2_Index(pc,d1.w)
; ===========================================================================
Obj_Mecha_Monologue2_Index:
		dc.w Obj_Mecha_Monologue2_Main-Obj_Mecha_Monologue2_Index
		dc.w Obj_Mecha_Monologue2_1time-Obj_Mecha_Monologue2_Index
; ===========================================================================

Obj_Mecha_Monologue2_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_U0CZJ,obMap(a0)
		move.w	#$560,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#2,obAnim(a0)
		move.w	#180,obTimer(a0)
; ===========================================================================


Obj_Mecha_Monologue2_1time:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Monologue2_Animate
                jmp	(DeleteObject).w

; ===========================================================================

Obj_Mecha_Monologue2_Animate:
		lea	(Ani_Mecha_Monologue).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ============================================================================
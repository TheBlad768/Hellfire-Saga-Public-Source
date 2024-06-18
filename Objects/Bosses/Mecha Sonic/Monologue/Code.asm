; ---------------------------------------------------------------------------
; Words that appear in start of Mecha Sonic battle
; ---------------------------------------------------------------------------

Obj_Mecha_Monologue:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_Mecha_Monologue_Index(pc,d0.w),d1
		jmp	Obj_Mecha_Monologue_Index(pc,d1.w)
; ===========================================================================
Obj_Mecha_Monologue_Index:
		dc.w Obj_Mecha_Monologue_Main-Obj_Mecha_Monologue_Index
		dc.w Obj_Mecha_Monologue_1time-Obj_Mecha_Monologue_Index
		dc.w Obj_Mecha_Monologue_2time-Obj_Mecha_Monologue_Index
; ===========================================================================

Obj_Mecha_Monologue_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#SME_U0CZJ,obMap(a0)
		move.w	#$4C0,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#0,obAnim(a0)
		move.w	#90,obTimer(a0)
; ===========================================================================


Obj_Mecha_Monologue_1time:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Monologue_Animate
		move.b	#1,obAnim(a0)
		move.w	#90,obTimer(a0)
		addq.b	#2,obRoutine(a0)


Obj_Mecha_Monologue_2time:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_Monologue_Animate
                jmp	(DeleteObject).w

; ===========================================================================

Obj_Mecha_Monologue_Animate:
		lea	(Ani_Mecha_Monologue).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ============================================================================


		include "Objects/Bosses/Mecha Sonic/Monologue/Object data/Ani.asm"
		include "Objects/Bosses/Mecha Sonic/Monologue/Object data/Map.asm"

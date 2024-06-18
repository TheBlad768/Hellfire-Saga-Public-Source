; ---------------------------------------------------------------------------
;
; ---------------------------------------------------------------------------

Obj_EggMonologue:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_EggMonologue_Index(pc,d0.w),d1
		jmp	Obj_EggMonologue_Index(pc,d1.w)
; ===========================================================================
Obj_EggMonologue_Index:
		dc.w Obj_EggMonologue_Main-Obj_EggMonologue_Index
		dc.w Obj_EggMonologue_Loop-Obj_EggMonologue_Index
; ===========================================================================

Obj_EggMonologue_Main:
		addq.b	#2,obRoutine(a0)
		move.l	#Map_EggmanBoss,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$B,obAnim(a0)
		move.w	#480,obTimer(a0)
; ===========================================================================


Obj_EggMonologue_Loop:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_EggMonologue_Animate
                jmp	(DeleteObject).w

; ===========================================================================

Obj_EggMonologue_Animate:
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ============================================================================

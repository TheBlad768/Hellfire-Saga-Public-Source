; ---------------------------------------------------------------------------
; Little hit
; ---------------------------------------------------------------------------

Obj_DialogueGloam:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_DialogueGloam_Index(pc,d0.w),d1
		jsr	Obj_DialogueGloam_Index(pc,d1.w)
		lea	(Ani_DialogueGloam).l,a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w
; ===========================================================================
Obj_DialogueGloam_Index:
		dc.w Obj_DialogueGloam_Main-Obj_DialogueGloam_Index
		dc.w Obj_DialogueGloam_Delete-Obj_DialogueGloam_Index
; ===========================================================================

Obj_DialogueGloam_Main:
		move.w	#160,obTimer(a0)
		move.l	#Map_LittleHit,obMap(a0)
		move.w	#$400,obGfx(a0)
		move.b	#$84,render_flags(a0)
		move.b	#$10,width_pixels(a0)
		move.w	#$80,priority(a0)
		addq.b	#2,obRoutine(a0)

		move.w	Seizure_flag.w,d0			; if in photosensitivity mode
		and.w	#1,d0					; then use non-flashing animation
		move.b	d0,anim(a0)
; ===========================================================================


Obj_DialogueGloam_Delete:
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DialogueGloam_Animate
		move.l	#Go_Delete_Sprite,(a0)

; ===========================================================================

Obj_DialogueGloam_Animate:
		rts
; ============================================================================



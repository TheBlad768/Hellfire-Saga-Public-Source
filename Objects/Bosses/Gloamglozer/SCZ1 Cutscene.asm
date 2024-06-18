; ---------------------------------------------------------------------------
; Death during the SCZ1 pre-boss cutscene
; ---------------------------------------------------------------------------

Obj_SCZ1Death:

		; load palette
		lea	(Pal_DeathIntro).l,a1
		lea	(Normal_palette_line_4).w,a2
		jsr	(PalLoad_Line16).w

		st	objoff_3A(a0)									; reset DPLC frame
		move.l	#Map_DeathIntro,mappings(a0)
		move.w	#$648B,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#3*$80,priority(a0)
		move.w	#bytes_to_word(72/2,72/2),height_pixels(a0)		; set height and width
		move.l	#.swing,address(a0)

.swing

;		move.b	angle(a0),d0
;		addq.b	#2,angle(a0)
;		jsr	(GetSineCosine).w
;		asr.w	#2,d0
;		move.w	d0,y_vel(a0)

		cmpi.b	#$1C,(Dynamic_resize_routine).w
		bne.s	.draw
		move.l	#.check,address(a0)

.check
		cmpi.w	#$400,y_pos(a0)
		blt.s		.delete
		subi.l	#word_to_long($10,$18),x_vel(a0)

.move
		jsr	(MoveSprite2).w

.draw
		lea	Ani_DeathIntro(pc),a1
		jsr	(Animate_Sprite).w
		lea	DPLCPtr_DeathIntro(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

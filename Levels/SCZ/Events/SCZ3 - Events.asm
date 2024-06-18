; ---------------------------------------------------------------------------
; SCZ3 events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

SCZ3_BackgroundEvent:

		; scroll FG only
		lea	(H_scroll_buffer).w,a1
		move.w	(Camera_X_pos_copy).w,d0
		neg.w	d0
		moveq	#bytesToXcnt(224,8),d1

.loop
	rept 8
		move.w	d0,(a1)
		addq.w	#4,a1		; skip FBG
	endr
		dbf	d1,.loop

		bsr.s	SCZ3_BackgroundEvent_Resize
		jmp	(ShakeScreen_Setup).w

; =============== S U B R O U T I N E =======================================

SCZ3_BackgroundEvent_Resize:
		moveq	#0,d0
		move.b	(Background_event_routine).w,d0
		beq.s	.return

		jmp	.index-2(pc,d0.w)
; ---------------------------------------------------------------------------

.index
		bra.s	.speedup		; 2
		bra.s	.scroll		; 4
		bra.s	.slowdown	; 6
		bra.s	.fixscreen	; 8
; ---------------------------------------------------------------------------

.speedup
		addq.w	#8,(FGHscroll_shift).w
		cmpi.w	#$200,(FGHscroll_shift).w
		bne.s	.scroll
		addq.b	#2,(Background_event_routine).w

.scroll
		bra.s	FGScroll_DeformationExtra
; ---------------------------------------------------------------------------

.slowdown
		subq.w	#4,(FGHscroll_shift).w
		cmpi.w	#$100,(FGHscroll_shift).w
		bne.s	.scroll
		addq.b	#2,(Background_event_routine).w

.fixscreen
		move.w	#$1FF,d2	; 512 pixels
		move.w	(FGHscroll_shift+2).w,d0
		and.w	d2,d0
		move.w	(Camera_X_pos).w,d1
		and.w	d2,d1
		cmp.w	d0,d1
		bne.s	.scroll

		clr.b	(Background_event_routine).w
		clr.w	(FGHscroll_shift).w
		clr.l	(FGHscroll_shift+2).w

.return
		rts

; =============== S U B R O U T I N E =======================================

FGScroll_DeformationExtra:
		move.w	(FGHscroll_shift).w,d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(FGHscroll_shift+2).w

FGScroll_DeformationExtra2:
		lea	(H_scroll_buffer).w,a1
		move.w	(FGHscroll_shift+2).w,d0
		neg.w	d0
		moveq	#bytesToXcnt(224,8),d1

.loop
	rept	8
		move.w	(a1),d2
		add.w	d0,d2
		move.w	d2,(a1)
		addq.w	#4,a1		; skip FBG
	endr
		dbf	d1,.loop
		rts

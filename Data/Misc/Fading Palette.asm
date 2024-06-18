
; =============== S U B R O U T I N E =======================================

Pal_FadeTo:
PaletteFadeIn:
Pal_FadeFromBlack:
		jsr	Pal_FillBlack(pc)

Pal_FadeToColour:
		move.w	#$3F,(Palette_fade_info).w
		move.w	#$15,d4

-		move.b	#VintID_Fade,(V_int_routine).w
		bsr.w	Wait_VSync
		bsr.s	Pal_FromBlack
		dbf	d4,-
		rts
; End of function Pal_FadeFromBlack

; =============== S U B R O U T I N E =======================================

Pal_FadeIn:
Pal_FromBlack:
FadeIn_FromBlack:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		lea	(Target_palette).w,a1
		move.b	(Palette_fade_info).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(Palette_fade_count).w,d0

-		bsr.s	Pal_AddColor
		dbf	d0,-
		tst.b	(Water_flag).w
		beq.s	+
		moveq	#0,d0
		lea	(Water_palette).w,a0
		lea	(Target_water_palette).w,a1
		move.b	(Palette_fade_info).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(Palette_fade_count).w,d0

-		bsr.s	Pal_AddColor
		dbf	d0,-
+		rts
; End of function Pal_FromBlack

; =============== S U B R O U T I N E =======================================

Pal_AddColor:
	cmpi.w	#$0400,(Current_Zone).w
	beq.s	Pal_AddCredits
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	+++
		move.w	d3,d1
		addi.w	#$200,d1
		cmp.w	d2,d1
		bhi.s	+
		move.w	d1,(a0)+
		rts
+		move.w	d3,d1
		addi.w	#$20,d1
		cmp.w	d2,d1
		bhi.s	+
		move.w	d1,(a0)+
		rts
+		addq.w	#2,(a0)+
		rts
+		addq.w	#2,a0
		rts


Pal_AddCredits:
		movem.l	d0/d4,-(sp)
	subi.w	#7*2,d4
	bpl.s	.NoStop
	moveq	#$00,d4

	.NoStop:
	add.b	d4,d4
		move.b	(a1)+,d2
		move.b	(a0)+,d3
	cmp.b	d4,d2
	bmi.s	.NoBlue2
		cmp.b	d2,d3
		beq.s	.NoBlue2
		addq.b	#$02,-$01(a0)

	.NoBlue2:
		move.b	(a1)+,d2
		move.b	(a0),d3
		move.w	#$00E0,d1
		move.w	d1,d0
		and.b	d2,d1
		and.b	d3,d0
		sub.b	d1,d2
		sub.b	d0,d3

	cmp.b	d4,d2
	bmi.s	.NoRed2
		cmp.b	d2,d3
		beq.s	.NoRed2
		addq.b	#$02,d3

	.NoRed2:
	lsl.w	#$04,d4
	cmp.w	d4,d1
	bmi.s	.NoGreen2
		cmp.b	d1,d0
		beq.s	.NoGreen2
		addi.b	#$20,d0

	.NoGreen2:
		or.b	d0,d3
		move.b	d3,(a0)+
		movem.l	(sp)+,d0/d4
		rts

	.NoCol:
		addq.w	#$02,a0
		addq.w	#$02,a1
		movem.l	(sp)+,d0/d4
		rts

; End of function Pal_AddColor

; =============== S U B R O U T I N E =======================================

Pal_FillBlack:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	(Palette_fade_info).w,d0
		adda.w	d0,a0
		moveq	#0,d1
		move.b	(Palette_fade_count).w,d0

-		move.w	d1,(a0)+
		tst.b	(Water_flag).w
		beq.s	+
		move.w	d1,-$82(a0)
+		dbf	d0,-
		rts
; End of function Pal_FillBlack

; =============== S U B R O U T I N E =======================================

Pal_FadeFrom:
PaletteFadeOut:
Pal_FadeToBlack:
		move.w	#$3F,(Palette_fade_info).w
		move.w	#$15,d4

-		move.b	#VintID_Fade,(V_int_routine).w
		bsr.w	Wait_VSync
		bsr.s	Pal_ToBlack
		dbf	d4,-
		rts
; End of function Pal_FadeToBlack

; =============== S U B R O U T I N E =======================================

Pal_ToBlack:
Pal_FadeOut:
FadeOut_ToBlack:
		moveq	#0,d0
		lea	(Normal_palette).w,a0
		move.b	(Palette_fade_info).w,d0
		adda.w	d0,a0
		move.b	(Palette_fade_count).w,d0

-		bsr.s	Pal_DecColor
		dbf	d0,-
		moveq	#0,d0
		lea	(Water_palette).w,a0
		move.b	(Palette_fade_info).w,d0
		adda.w	d0,a0
		move.b	(Palette_fade_count).w,d0

-		bsr.s	Pal_DecColor
		dbf	d0,-
		rts
; End of function Pal_ToBlack

; =============== S U B R O U T I N E =======================================

Pal_DecColor:
		move.w	(a0),d2
		beq.s	+++
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	+
		subq.w	#2,(a0)+
		rts
+		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	+
		subi.w	#$20,(a0)+
		rts
+		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	+
		subi.w	#$200,(a0)+
		rts
+		addq.w	#2,a0
		rts
; End of function Pal_DecColor

; =============== S U B R O U T I N E =======================================

Pal_SmoothToPalette:

.process
		move.w	(a1),d1			; palette RAM (to)
		move.w	(a2)+,d2			; palette pointer (from)
		move.w	d1,d3			; copy color from RAM to d3
		move.w	d2,d4			; copy color from pointer to d4

		; get red
		andi.w	#cRed,d3		; get only red color from RAM
		andi.w	#cRed,d4		; get only red color from pointer
		cmp.w	d3,d4			; has red reached threshold level?
		beq.s	.getgreen			; if yes, branch
		blo.s		.decred			; "

		; add red
		andi.w	#$FF0,d1		; clear red color in RAM
		addq.w	#2,d3			; increase red value
		or.w	d3,d1				; set color
		bra.s	.getgreen			; "
; ---------------------------------------------------------------------------

.decred
		andi.w	#$FF0,d1		; clear red color in RAM
		subq.w	#2,d3			; decrease red value
		or.w	d3,d1				; set color

.getgreen
		move.w	d1,d3			; copy color from RAM to d3
		move.w	d2,d4			; copy color from pointer to d4
		andi.w	#cGreen,d3		; get only green color from RAM
		andi.w	#cGreen,d4		; get only green color from pointer
		cmp.w	d3,d4			; has green reached threshold level?
		beq.s	.getblue			; if yes, branch
		blo.s		.decgreen		; "

		; add green
		andi.w	#$F0F,d1		; clear green color in RAM
		addi.w	#$20,d3			; increase green value
		or.w	d3,d1				; set color
		bra.s	.getblue			; "
; ---------------------------------------------------------------------------

.decgreen
		andi.w	#$F0F,d1		; clear green color in RAM
		subi.w	#$20,d3			; decrease green value
		or.w	d3,d1				; set color

.getblue
		move.w	d1,d3			; copy color from RAM to d3
		move.w	d2,d4			; copy color from pointer to d4
		andi.w	#cBlue,d3		; get only blue color from RAM
		andi.w	#cBlue,d4		; get only blue color from pointer
		cmp.w	d3,d4			; has blue reached threshold level?
		beq.s	.setcolor			; if yes, branch
		blo.s		.decblue			; "

		; add blue
		andi.w	#$FF,d1			; clear blue color in RAM
		addi.w	#$200,d3		; increase blue value
		or.w	d3,d1				; set color
		bra.s	.setcolor			; "
; ---------------------------------------------------------------------------

.decblue
		andi.w	#$FF,d1			; clear blue color in RAM
		subi.w	#$200,d3		; decrease blue value
		or.w	d3,d1				; set color

.setcolor
		move.w	d1,(a1)+			; set color to RAM
		dbf	d0,.process			; "
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to blend a palette (similar to Pal_SmoothToPalette but with a
; fractional controller) - MarkeyJester
; --- input -----------------------------------------------------------------
; d0.w = palette size dbf counter
; d1.w = blend amount
; a0.l = palette 1 (0000)
; a1.l = palette 2 (0100)
; a2.l = destination palette buffer
; --- output ----------------------------------------------------------------
; d1.w = capped blend amount
; ---------------------------------------------------------------------------
; Note, must load or test d1 directly before calling, example:
;
;		lea	(Target_palette).w,a0				; load source palette 1 (0000)
;		lea	(Newest_palette).l,a1				; load source palette 2 (0100)
;		lea	(Normal_palette).w,a2				; load destination palette buffer
;		moveq	#($80/2)-1,d0					; palette size
;		move.w	(Pal_BlendAmount).w,d1				; load blend amount
;		jsr	(Pal_BlendPalette).w				; blend the palette
;		move.w	d1,(Pal_BlendAmount).w				; update blend amount (if capped)
; ---------------------------------------------------------------------------

Pal_BlendPalette:
		bgt.s	.NoMin						; if the palette isn't 8000 to FFFF/0000, continue
		clr.w	d1						; keep at lowest 0000
	.Doa0:	move.w	(a0)+,(a2)+					; copy palette
		dbf	d0,.Doa0					; repeat until done
		rts							; return

	.NoMin:
		cmpi.w	#$0100,d1					; is it at maximum or above?
		blo.s	.NoMax						; if not, continue
		move.w	#$0100,d1					; force to maximum
	.Doa1:	move.w	(a1)+,(a2)+					; copy palette
		dbf	d0,.Doa1					; repeat until done
		rts							; return

	.NoMax:
		moveq	#$0E,d2						; load blue
		and.b	(a0)+,d2					; ''
		moveq	#$0E,d3						; ''
		and.b	(a1)+,d3					; ''
		sub.w	d2,d3						; get distance to blue
		muls.w	d1,d3						; get precise position
		asr.w	#$08,d3						; remove x100
		add.w	d2,d3						; add base back
		move.b	d3,(a2)+					; save blue

		moveq	#$00,d2						; load green and red (source 1)
		move.b	(a0)+,d2					; ''
		moveq	#$0E,d4						; get only red
		and.b	d2,d4						; ''
		sub.b	d4,d2						; get only green

		moveq	#$00,d3						; load green and red (source 2)
		move.b	(a1)+,d3					; ''
		moveq	#$0E,d5						; get only red
		and.b	d3,d5						; ''
		sub.b	d5,d3						; get only green

		sub.w	d2,d3						; get distance to green
		muls.w	d1,d3						; get precise position
		asr.w	#$08,d3						; remove x100
		add.w	d2,d3						; add base back

		sub.w	d4,d5						; get distance to red
		muls.w	d1,d5						; get precise position
		asr.w	#$08,d5						; remove x100
		add.w	d4,d5						; add base back

		andi.w	#$00E0,d3					; remove fraction where red is
		or.b	d5,d3						; add red to green
		move.b	d3,(a2)+					; save red and green

		dbf	d0,.NoMax					; repeat for all colours
		rts							; return

; ===========================================================================




















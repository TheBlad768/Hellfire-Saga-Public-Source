; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine calculate the distance between two points on a 360 degree radius
; --- input -----------------------------------------------------------------
; d1.w = X distance
; d2.w = Y distance
; --- output ----------------------------------------------------------------
; d0.w = 360 distance
; ---------------------------------------------------------------------------

CalcDist:
		movem.l	d1-d2,-(sp)					; store distances
		moveq	#$00,d0						; load X position with cleared upper word
		move.w	d1,d0						; ''
		bpl.s	.PosX						; if positive already, continue
		neg.w	d0						; convert to positive

	.PosX:
		moveq	#$00,d1						; load Y position with cleared upper word
		move.w	d2,d1						; ''
		bpl.s	.PosY						; if positive already, continue
		neg.w	d1						; convert to positive

	.PosY:
		cmp.w	d1,d0						; is Y further away than X?
		bhi.s	.LargerY					; if so, use Y as divider
		exg.l	d1,d0						; use X as divider instead

	.LargerY:
		lsl.l	#$08,d1						; convert distance from "0 - divider" to "0 - $100"
		tst.w	d0						; cannot divide by 0...
		beq.s	.ZeroDiv					; ''
		divu.w	d0,d1						; ''

	.ZeroDiv:
		add.w	d1,d1						; multiply by size of word element
		lsl.l	#$08,d0						; convert divider from "0 - divider" to "0 - 360 distance"
		divu.w	.SineConvert(pc,d1.w),d0			; ''
		movem.l	(sp)+,d1-d2					; restore distances
		rts							; return

	.SineConvert:
		dc.w	$0100,$0100,$0100,$0100,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF
		dc.w	$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FF,$00FE,$00FE,$00FE,$00FE,$00FE,$00FE,$00FE,$00FE,$00FE
		dc.w	$00FE,$00FE,$00FE,$00FD,$00FD,$00FD,$00FD,$00FD,$00FD,$00FD,$00FC,$00FC,$00FC,$00FC,$00FC,$00FC
		dc.w	$00FB,$00FB,$00FB,$00FB,$00FB,$00FB,$00FB,$00F9,$00F9,$00F9,$00F9,$00F9,$00F9,$00F8,$00F8,$00F8
		dc.w	$00F8,$00F8,$00F8,$00F8,$00F6,$00F6,$00F6,$00F6,$00F6,$00F6,$00F6,$00F4,$00F4,$00F4,$00F4,$00F4
		dc.w	$00F4,$00F4,$00F3,$00F3,$00F3,$00F3,$00F3,$00F3,$00F3,$00F1,$00F1,$00F1,$00F1,$00F1,$00F1,$00F1
		dc.w	$00EE,$00EE,$00EE,$00EE,$00EE,$00EE,$00EE,$00EC,$00EC,$00EC,$00EC,$00EC,$00EC,$00EC,$00EA,$00EA
		dc.w	$00EA,$00EA,$00EA,$00EA,$00EA,$00EA,$00E7,$00E7,$00E7,$00E7,$00E7,$00E7,$00E7,$00E4,$00E4,$00E4
		dc.w	$00E4,$00E4,$00E4,$00E4,$00E4,$00E1,$00E1,$00E1,$00E1,$00E1,$00E1,$00E1,$00E1,$00DE,$00DE,$00DE
		dc.w	$00DE,$00DE,$00DE,$00DE,$00DE,$00DE,$00DB,$00DB,$00DB,$00DB,$00DB,$00DB,$00DB,$00DB,$00D8,$00D8
		dc.w	$00D8,$00D8,$00D8,$00D8,$00D8,$00D8,$00D8,$00D4,$00D4,$00D4,$00D4,$00D4,$00D4,$00D4,$00D4,$00D4
		dc.w	$00D1,$00D1,$00D1,$00D1,$00D1,$00D1,$00D1,$00D1,$00D1,$00D1,$00CD,$00CD,$00CD,$00CD,$00CD,$00CD
		dc.w	$00CD,$00CD,$00CD,$00C9,$00C9,$00C9,$00C9,$00C9,$00C9,$00C9,$00C9,$00C9,$00C9,$00C5,$00C5,$00C5
		dc.w	$00C5,$00C5,$00C5,$00C5,$00C5,$00C5,$00C5,$00C5,$00C1,$00C1,$00C1,$00C1,$00C1,$00C1,$00C1,$00C1
		dc.w	$00C1,$00C1,$00C1,$00BD,$00BD,$00BD,$00BD,$00BD,$00BD,$00BD,$00BD,$00BD,$00BD,$00BD,$00B9,$00B9
		dc.w	$00B9,$00B9,$00B9,$00B9,$00B9,$00B9,$00B9,$00B9,$00B9,$00B9,$00B5,$00B5,$00B5,$00B5,$00B5,$00B5
		dc.w	$00B5

; ===========================================================================
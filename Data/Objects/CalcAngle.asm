; -------------------------------------------------------------------------
; 2-argument arctangent (angle between (0,0) and (x,y))
; Based on http://codebase64.org/doku.php?id=base:8bit_atan2_8-bit_angle
; New version by Ralakimus (devon)
; -------------------------------------------------------------------------
; PARAMETERS:
; d1.w - X value
; d2.w - Y value
; RETURNS:
; d0.b - 2-argument arctangent value (angle between (0,0) and (x,y))
; -------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CalcAngle:
GetArcTan:
		moveq	#0,d0							; Default to bottom right quadrant
		tst.w	d1								; Is the X value negative?
		beq.s	CalcAngle_XZero					; If the X value is zero, branch
		bpl.s	CalcAngle_CheckY					; If not, branch
		neg.w	d1								; If so, get the absolute value
		moveq	#4,d0							; Shift to left quadrant

CalcAngle_CheckY:
		tst.w	d2								; Is the Y value negative?
		beq.s	CalcAngle_YZero					; If the Y value is zero, branch
		bpl.s	CalcAngle_CheckOctet				; If not, branch
		neg.w	d2								; If so, get the absolute value
		addq.b	#2,d0							; Shift to top quadrant

CalcAngle_CheckOctet:
		cmp.w	d2,d1							; Are we horizontally closer to the center?
		bhs.s	CalcAngle_Divide					; If not, branch
		exg	d1,d2								; If so, divide Y from X instead
		addq.b	#1,d0							; Use octant that's horizontally closer to the center

CalcAngle_Divide:
		move.w	d1,-(sp)							; Shrink X and Y down into bytes
		moveq	#0,d3
		move.b	(sp)+,d3
		move.b	WordShiftTable(pc,d3.w),d3
		lsr.w	d3,d1
		lsr.w	d3,d2
		lea	LogarithmTable(pc),a2					; Perform logarithmic division
		move.b	(a2,d2.w),d2
		sub.b	(a2,d1.w),d2
		bne.s	CalcAngle_GetAtan2Val
		move.w	#$FF,d2							; Edge case where X and Y values are too close for the division to handle

CalcAngle_GetAtan2Val:
		lea	ArcTanTable(pc),a2					; Get atan2 value
		move.b	(a2,d2.w),d2
		move.b	OctantAdjust(pc,d0.w),d0
		eor.b	d2,d0
		rts
; -------------------------------------------------------------------------

CalcAngle_YZero:
		tst.b	d0								; Was the X value negated?
		beq.s	CalcAngle_End				; If not, branch (d0 is already 0, so no need to set it again on branch)
		moveq	#-$80,d0					; 180 degrees

CalcAngle_End:
		rts
; -------------------------------------------------------------------------

CalcAngle_XZero:
		tst.w	d2							; Is the Y value negative?
		bmi.s	CalcAngle_XZeroYNeg			; If so, branch
		moveq	#$40,d0						; 90 degrees
		rts
; -------------------------------------------------------------------------

CalcAngle_XZeroYNeg:
		moveq	#-$40,d0					; 270 degrees
		rts
; -------------------------------------------------------------------------

OctantAdjust:
		dc.b %00000000						; +X, +Y, |X|>|Y|
		dc.b %00111111						; +X, +Y, |X|<|Y|
		dc.b %11111111						; +X, -Y, |X|>|Y|
		dc.b %11000000						; +X, -Y, |X|<|Y|
		dc.b %01111111						; -X, +Y, |X|>|Y|
		dc.b %01000000						; -X, +Y, |X|<|Y|
		dc.b %10000000						; -X, -Y, |X|>|Y|
		dc.b %10111111						; -X, -Y, |X|<|Y|
; -------------------------------------------------------------------------

WordShiftTable:	binclude "Misc Data/Angle/WordShift.bin"
	even
LogarithmTable:	binclude "Misc Data/Angle/Logarithmic.bin"	; log base 2
	even
ArcTanTable:		binclude "Misc Data/Angle/Arctan.bin"	; 2-argument
	even

; ===========================================================================
; ---------------------------------------------------------------------------
; Access to the new calc angle subroutine whilst preserving the registers
; from the original...
; ---------------------------------------------------------------------------

CalcAngle_NEW:
		movem.l	d1-d3/a2,-(sp)					; store registers
		bsr.w	CalcAngle					; calculate the sinewave position
		move.b	d0,d1						; clear upper part of register
		moveq	#$00,d0						; ''
		move.b	d1,d0						; '' (keep in d0)
		movem.l	(sp)+,d1-d3/a2					; restore registers
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Old CalcAngle subroutine, the new one doesn't have the exact same return
; parameters as the old one, registers are not preserved, and the upper parts
; of d0 are not cleared, and some other minor qualities to the angle value
; seem different (not sure how to explain...)
; ---------------------------------------------------------------------------
; input:
; d1 = x-axis distance
; d2 = y-axis distance
; output:
; d0 = angle
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

CalcAngle_OLD:
GetArcTan_OLD:
		movem.l	d3-d4,-(sp)
		moveq	#0,d3
		moveq	#0,d4
		move.w	d1,d3
		move.w	d2,d4
		or.w	d3,d4
		beq.s	GetArcTan_Zero_OLD	; special case when both x and y are zero
		move.w	d2,d4
		tst.w	d3
		bpl.s	+
		neg.w	d3
+		tst.w	d4
		bpl.s	+
		neg.w	d4
+		cmp.w	d3,d4
		bhs.s	+	; if |y| >= |x|
		lsl.l	#8,d4
		divu.w	d3,d4
		moveq	#0,d0
		move.b	ArcTanTable_O(pc,d4.w),d0
		bra.s	++
+		lsl.l	#8,d3
		divu.w	d4,d3
		moveq	#$40,d0
		sub.b	ArcTanTable_O(pc,d3.w),d0	; arctan(y/x) = 90 - arctan(x/y)
+		tst.w	d1
		bpl.s	+
		neg.w	d0
		addi.w	#$80,d0		; place angle in appropriate quadrant
+		tst.w	d2
		bpl.s	+
		neg.w	d0
		addi.w	#$100,d0	; place angle in appropriate quadrant
+		movem.l	(sp)+,d3-d4
		rts
; ---------------------------------------------------------------------------

GetArcTan_Zero_OLD:
		moveq	#$40,d0		; angle = 90 degrees
		movem.l	(sp)+,d3-d4
		rts
; End of function GetArcTan
; ---------------------------------------------------------------------------

ArcTanTable_O:	dc.b	$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02
		dc.b	$03,$03,$03,$03,$03,$03,$03,$04,$04,$04,$04,$04,$04,$05,$05,$05
		dc.b	$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$07
		dc.b	$08,$08,$08,$08,$08,$08,$08,$09,$09,$09,$09,$09,$09,$0A,$0A,$0A
		dc.b	$0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C,$0C
		dc.b	$0C,$0C,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0E,$0E,$0E,$0E,$0E,$0E,$0E
		dc.b	$0F,$0F,$0F,$0F,$0F,$0F,$0F,$10,$10,$10,$10,$10,$10,$10,$11,$11
		dc.b	$11,$11,$11,$11,$11,$11,$12,$12,$12,$12,$12,$12,$12,$13,$13,$13
		dc.b	$13,$13,$13,$13,$13,$14,$14,$14,$14,$14,$14,$14,$14,$15,$15,$15
		dc.b	$15,$15,$15,$15,$15,$15,$16,$16,$16,$16,$16,$16,$16,$16,$17,$17
		dc.b	$17,$17,$17,$17,$17,$17,$17,$18,$18,$18,$18,$18,$18,$18,$18,$18
		dc.b	$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$1A,$1A,$1A,$1A,$1A,$1A
		dc.b	$1A,$1A,$1A,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1C,$1C,$1C
		dc.b	$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
		dc.b	$1D,$1D,$1D,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1F,$1F
		dc.b	$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$20,$20,$20,$20,$20,$20
		dc.b	$20,$00

; =============== S U B R O U T I N E =======================================

ShakeScreen_Setup:
		moveq	#0,d1
		move.w	(Screen_shaking_flag).w,d0
		beq.s	++
		bmi.s	+
		subq.w	#1,d0
		move.w	d0,(Screen_shaking_flag).w
		cmpi.w	#$14,d0
		bhs.s	+
		move.b	ScreenShakeArray(pc,d0.w),d1
		ext.w	d1
		bra.s	++
; ---------------------------------------------------------------------------
+		move.w	(Level_frame_counter).w,d0
		andi.w	#$3F,d0
		move.b	ScreenShakeArray2(pc,d0.w),d1
+		move.w	d1,(Screen_shaking_flag+2).w
		rts

; =============== S U B R O U T I N E =======================================

ScreenShakeArray:
		dc.b   1, -1,  1, -1,  2, -2,  2, -2,  3, -3,  3, -3,  4, -4,  4, -4
		dc.b   5, -5,  5, -5
ScreenShakeArray2:
		dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0
		dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3
		dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0
		dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to wobble the screen up and down - MarkeyJester
; ---------------------------------------------------------------------------

WobbleScreen:
		moveq	#$00,d0						; load wobble amount
		move.b	(ScreenWobble).w,d0				; ''
		beq.s	.NoWobble					; if there's no wobble amount, branch
		moveq	#$00,d1						; load timer
		move.b	(Level_frame_counter+1).w,d1			; ''
		lsl.b	#$06,d1						; increase speed
		add.w	d1,d1						; multiply by word size
		addi.w	#SineTable,d1					; add sine table address
		movea.w	d1,a0						; set sinewave address
		muls.w	(a0),d0						; multiply wobble amount by sine position
		asr.l	#$08,d0						; remove x$100
		asr.w	#$02,d0						; reduce a bit more
		subq.b	#$01,(ScreenWobble).w				; decrease wobble time
		bne.s	.NoFinish					; if not finished, branch
		moveq	#$00,d0						; force position to 0

	.NoFinish:
		move.w	d0,(Screen_shaking_flag+2).w			; save as shaking position

	.NoWobble:
		rts							; return

; ===========================================================================
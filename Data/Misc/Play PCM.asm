; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to play a PCM sample from 68k side
; --- input -----------------------------------------------------------------
; a0.l = Sample start address
; d1.l = Sample size
; ---------------------------------------------------------------------------

PlayPCM:
		move.w	sr,-(sp)					; store sr
		move.w	#$2700,sr					; disable interrupts
		stopZ80
		lea	($A04000).l,a1					; load YM2612 port
		lea	$01(a1),a2
		move.w	#$C0B6,d0					; speakers for FM6 on
		bsr.s	.WriteYM2					; ''
		move.w	#$802A,d0					; set address to DAC port
		bsr.s	.WriteYM1					; ''
		move.w	#$802B,d0					; enable DAC
		bsr.s	.WriteYM1					; ''
		bsr.s	.WaitYM						; wait for YM
		move.b	#$2A,(a1)					; set address to DAC port
		bsr.s	.WaitYM						; wait for YM
		bsr.s	.PlayPCM					; play the sample
		startZ80
		move.w	(sp)+,sr					; restore sr
		rts							; return (finish)

	; --- Flushing a sample ---

	.NextUpper:
		swap	d1						; get lower word size

	.PlayPCM:
		move.b	(a0)+,(a2)					; save to DAC port
		move.w	d2,d0						; delay/speed
		dbf	d0,*						; ''
		dbf	d1,.PlayPCM					; repeat for lower word size
		swap	d1						; get upper word size
		dbf	d1,.NextUpper					; repeat for upper word size
		rts							; return (finished)

	; --- Writing to part 1 ---

	.WriteYM1:
		bsr.s	.WaitYM						; wait for YM
		move.b	d0,(a1)						; set address
		lsr.w	#$08,d0						; get data
		bsr.s	.WaitYM						; wait for YM
		move.b	d0,(a2)						; set data
		rts							; done...

	; --- Writing to part 2 ---

	.WriteYM2:
		bsr.s	.WaitYM						; wait for YM
		move.b	d0,$02(a1)					; set address
		lsr.w	#$08,d0						; get data
		bsr.s	.WaitYM						; wait for YM
		move.b	d0,$02(a2)					; set data
		rts							; done...

	; --- Waiting for YM2612 to not be busy ---

	.WaitYM:
		nop							; delay a bit (give YM time to acknowledge ...
		nop							; '' ...there might be data in the port)
		nop							; ''
		tst.b	(a1)						; load busy flag
		bmi.s	*-2						; if busy, wait...
		rts							; return (ready!)

; ===========================================================================
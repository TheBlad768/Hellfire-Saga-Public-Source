; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to initialise the sound chips and then fractal
; ---------------------------------------------------------------------------
; tl,dr; Fractal doesn't reset the PSG channels.
;
; ...extra tl,dr; Aurora put all common subroutines in ROM 000000 - 007FFF
; for optimal reasons, but adding in extra chip setup code shifts some of it
; into 008000+, and thus .w needs to be changed for a lot of calls.
;
; ...but it's too many calls to have to go sorting through, so bollocks to that...
; ---------------------------------------------------------------------------

InitSound:
		move.b	#$9F,($C00011).l				; mute PSG 1
		move.b	#$BF,($C00011).l				; mute PSG 2
		move.b	#$DF,($C00011).l				; mute PSG 3
		move.b	#$FF,($C00011).l				; mute PSG 4
		jmp	dFractalInit					; initialise fractal

; ===========================================================================
; ---------------------------------------------------------------------------
; Forcing YM2612 mute on request
; ---------------------------------------------------------------------------
; Fractal doesn't mute the channels properly when a new music track is requested
; probably an oversight, or there's a valid reason, we'll probably never know...
;
; This will force the release rate to max, set key off, and set panning to normal.
; ---------------------------------------------------------------------------

dForceMuteYM2612:
		tst.b	(ForceMuteYM2612).w				; does the YM2612 need muting?
		bne.s	.Mute						; if so, run code...
		rts							; return (no mute)

	.Mute:
		sf.b	(ForceMuteYM2612).w				; clear flag

		move.w	sr,-(sp)					; store sr
		move.w	#$2700,sr					; disable interrupts
		move.w	#$0100,($A11100).l				; request Z80 stop
		btst	#$00,($A11100).l				; has the Z80 stopped?
		bne.s	*-8						; if not, loop until it has

		lea	($A04000).l,a1					; load YM2612 address port
		lea	$01(a1),a2					; load YM2612 data port

		moveq	#$00,d3						; clear upper word of d3
		moveq	#$06-1,d0					; number of registers to process

	.NextChannel:

	; --- Release Rate to Max ---

		moveq	#$30,d1						; load channel register value for release rate
		moveq	#(.End-.Env)-1,d4				; number of ADSR
		move.b	.ChanPart(pc,d0.w),d3				; load part
		add.b	.ChanReg(pc,d0.w),d1				; get channel register of release rate
		lea	.Env(pc),a0					; get envolope list

	.NextEnv:
		moveq	#$04-1,d5					; number of operators
		move.b	(a0)+,d2					; load operator value

	.NextOp:
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d1,(a1,d3.w)					; set address to operator's release rate
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d2,(a2,d3.w)					; set release rate to instant
		addq.b	#$04,d1						; advance to next operator
		dbf	d5,.NextOp					; repeat for all operators
		dbf	d4,.NextEnv					; repeat for all envolope/ADSR values

	; --- Speakers to Both ---

		addi.b	#$B4-$A0,d1					; advance to panning register
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d1,(a1,d3.w)					; set address to panning of channel
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$C0,(a2,d3.w)					; force channel panning to both speakers

	; --- Key off all operators ---

		move.b	.ChanAlt(pc,d0.w),d1				; load register ID
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$28,(a1)					; set address to key on/off
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d1,(a2)						; request keys off
		dbf	d0,.NextChannel					; repeat for all 6 channels

	; --- Restore for Dual-PCM ---

		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$2A,(a1)					; set it to DAC port
		bsr.s	.ResetBuffer					; reset the entire buffer

		move.w	#$0000,($A11100).l				; request Z80 start
		move.w	(sp)+,sr					; restore sr
		rts							; return

  .ChanPart:	dc.b	$00,$00,$00					; part 4000/4001
		dc.b	$02,$02,$02					; part 4002/4003

  .ChanReg:	dc.b	$00,$01,$02					; FM 1 2 3
		dc.b	$00,$01,$02					; FM 4 5 6

	.WaitYM: ; nops not required, as a "bsr/jsr" is slow enough...
		tst.b	(a1)						; load busy flag
		bmi.s	*-2						; if busy, wait...
		rts							; return (ready!)

  .ChanAlt:	dc.b	$00,$01,$02					; FM 1 2 3
		dc.b	$04,$05,$06					; FM 4 5 6

	.Env:	dc.b	%00000000					; 30 -DDD MMMM = Detune (DT1) and Multiple (MUL)
		dc.b	%01111111					; 40 -TTT TTTT = Total Level (TL)
		dc.b	%00000000					; 50 RR-A AAAA = Rate Scaling (RS) and Attack Rate (AR)
		dc.b	%00011111					; 60 A--D DDDD = Amplitude Modulation and Decay Rate 1
		dc.b	%00011111					; 70 ---D DDDD = Decay Rate 2
		dc.b	%00001111					; 80 DDDD RRRR = Secondary Amplitude and Release Rate
		dc.b	%00000000					; 90 ---- SSSS = Proprietary (SSG-EG)
	.End:	even

	; --- YM Buffers ---
	; This section will force the YM buffers to all be FF
	; ------------------

	.ResetBuffer:
		lea	($A01200).l,a0					; load buffer 1
		move.b	($A00E62).l,d0					; get buffer Dual-PCM is reading from
		btst.l	#$00,d0						; ''
		beq.s	.Buffer1					; if Dual PCM is reading from buffer 1, branch
		lea	($A01900).l,a0					; load buffer 2 instead

	.Buffer1:
		moveq	#-1,d0						; prepare end of buffer value
		moveq	#-$80,d1					; prepare PCM mute
		moveq	#$2A,d2						; prepare DAC address
		rept	($1900-$1200)/3
		move.b	d0,(a0)+					; set end of list
		move.b	d1,(a0)+					; set data
		move.b	d2,(a0)+					; set address
		endm
		rts							; return

; ===========================================================================
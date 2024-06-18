; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup 68k stereo PCM playback - MarkeyJester
; ---------------------------------------------------------------------------

PlayPCM_StereoInit:
		move.w	sr,-(sp)					; store sr
		move.w	#$2700,sr					; disable interrupts
		move.w	#$0100,($A11100).l				; request Z80 stop
		btst	#$00,($A11100).l				; has the Z80 stopped?
		bne.s	*-8						; if not, loop until it has
		move.w	#$0000,($A11200).l				; request Z80 reset (ON)
		moveq	#$7F,d0						; set repeat times
		dbf	d0,*						; no way of checking for reset, so a manual delay is necessary
		move.w	#$0100,($A11200).l				; request Z80 reset (OFF)

		lea	($A04000).l,a1					; load YM2612 address port
		lea	$01(a1),a2					; load YM2612 data port

		bsr.w	PS_SetupOp_All					; setup all operators
		bsr.w	PS_SetupFr_All					; setup all frequencies of all channels
		move.w	(sp)+,sr					; restore sr
		rts							; return (finished)

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to play a PCM sample from 68k side in stereo - MarkeyJester
; --- input -----------------------------------------------------------------
; a0.l = Sample start address
; d1.l = Sample size
; d2.b = Pitch/Delay
; ---------------------------------------------------------------------------

PlayPCM_Stereo:
		move.w	sr,-(sp)					; store sr
		move.w	#$2700,sr					; disable interrupts

		lea	($A04000).l,a1					; load YM2612 address port
		lea	$01(a1),a2					; load YM2612 data port
		lea	$02(a1),a3					; load part 2 versions...
		lea	$03(a1),a4					; ''

		lea	PS_Conv1(pc),a5
		lea	PS_Conv2(pc),a6
		moveq	#$00,d0

	; Actual volume position table:

		lsr.l	#$01,d1						; reduce size by 2 (two bytes per sample, L/R)
		swap	d1

	.NextHigh:
		swap	d1

	.NextLow:

		move.b	(a0)+,d0
		nop
		nop
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a5,d0.w),(a2)
		nop
		nop
		move.b	#$41,(a1)
		nop
		nop
		move.b	(a6,d0.w),(a2)
		nop
		nop
		move.b	(a0)+,d0
		move.b	#$40,(a3)
		nop
		nop
		move.b	(a5,d0.w),(a4)
		nop
		nop
		move.b	#$41,(a3)
		nop
		nop
		move.b	(a6,d0.w),(a4)

		move.w	d2,d3
		dbf	d3,*

		dbf	d1,.NextLow
		swap	d1
		dbf	d1,.NextHigh

		move.w	(sp)+,sr					; restore sr
		rts							; return (finished)

; ---------------------------------------------------------------------------
; Subroutine to wait for the YM2612
; ---------------------------------------------------------------------------

PS_WaitYM:	; nops not required, as a "bsr/jsr" is slow enough...
		tst.b	(a1)						; load busy flag
		bmi.s	*-2						; if busy, wait...
		rts							; return (ready!)

; ===========================================================================
; ---------------------------------------------------------------------------
; Setting up ALL operators of ALL channels
; ---------------------------------------------------------------------------

PS_SetupOp_All:
		move.l	d2,-(sp)					; store d2
		moveq	#$05,d0						; prepare FM6
	.Chan:	moveq	#$03,d2						; prepare operator 4
	.Op:	bsr.s	PS_SetupOp					; setup operator/channel
		dbf	d2,.Op						; go down an operator and repeat for all operators
		dbf	d0,.Chan					; go down a channel and repeat for all channels
		move.l	(sp)+,d2					; restore d2
		rts							; return

; ---------------------------------------------------------------------------
; Setting up an operator
; --- input -----------------------------------------------------------------
; d0.w = Channel number
; d2.b = Operator number
; ---------------------------------------------------------------------------

PS_SetupOp:
		movem.l	d0-d2/a0,-(sp)					; store registers
		add.b	d2,d2						; get operator slot
		add.b	d2,d2						; ''
		addi.b	#$30,d2						; start from 30 (Detune/Multiple)
		moveq	#(.End-.Env)-1,d1				; number of envolope register writes to perform
		lea	.Env(pc),a0					; envolope list
		add.b	PS_ChanReg(pc,d0.w),d2				; add correct channel reg ID
		move.b	PS_ChanPart(pc,d0.w),d0				; load correct YM2612 part

	.NextEnvolope:
		bsr.s	PS_WaitYM					; wait for YM chip
		move.b	d2,(a1,d0.w)					; set address
		bsr.s	PS_WaitYM					; wait for YM chip
		move.b	(a0)+,(a2,d0.w)					; set data
		addi.b	#$10,d2						; advance to next register
		dbf	d1,.NextEnvolope				; repeat for all envelopes
		movem.l	(sp)+,d0-d2/a0					; restore registers
		rts							; return

	.Env:	dc.b	%00000000					; 30 -DDD MMMM = Detune (DT1) and Multiple (MUL)
		dc.b	%01111111					; 40 -TTT TTTT = Total Level (TL)
		dc.b	%00011111					; 50 RR-A AAAA = Rate Scaling (RS) and Attack Rate (AR)
		dc.b	%00000000					; 60 A--D DDDD = Amplitude Modulation and Decay Rate 1
		dc.b	%00000000					; 70 ---D DDDD = Decay Rate 2
		dc.b	%00001111					; 80 DDDD RRRR = Secondary Amplitude and Release Rate
		dc.b	%00000000					; 90 ---- SSSS = Proprietary (SSG-EG)
	.End:

; ---------------------------------------------------------------------------
; YM2612 Register/Address ID's
; ---------------------------------------------------------------------------

PS_ChanReg:	dc.b	$00,$01,$02					; FM 1 2 3
		dc.b	$00,$01,$02					; FM 4 5 6

PS_ChanAlt:	dc.b	$00,$01,$02					; FM 1 2 3
		dc.b	$04,$05,$06					; FM 4 5 6

PS_ChanPart:	dc.b	$00,$00,$00					; part 4000/4001
		dc.b	$02,$02,$02					; part 4002/4003

		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Setting up frequencies for all channels correctly
; ---------------------------------------------------------------------------

PS_SetupFr_All:
		movem.l	d2/a0/a3,-(sp)					; store registers
		moveq	#$05,d0						; set FM channel
		lea	.Pan(pc),a0					; load panning list
		lea	.Sine(pc),a3					; load sinewave delay timer list
	.Next:	move.l	(a3)+,d4					; load frequency delay timer for sinewave position
		move.b	(a0)+,d2					; load panning to use
		bsr.w	PS_SetupFrequ					; setup the channel correctly
		dbf	d0,.Next					; go down a channel and repeat until all channels are done
		movem.l	(sp)+,d2/a0/a3					; restore registers
		rts							; return

	.Pan:	dc.b	$00						; FM 6 no pan (mute)
		dc.b	$40						; FM 5 no pan (mute)
		dc.b	$40						; FM 4 pan right
		dc.b	$00						; FM 3 no pan (mute)
		dc.b	$80						; FM 2 no pan (mute)
		dc.b	$80						; FM 1 pan left

	; 00042000	is the frequency for quarter of a turn	(Max pos)
	; 000A0000	is the frequency for 3 quarters		(Max neg)

	.Sine:	dc.l	$00000000					; FM 6
		dc.l	$000A0000					; FM 5
		dc.l	$00042000					; FM 4
		dc.l	$00000000					; FM 3
		dc.l	$000A0000					; FM 2
		dc.l	$00042000					; FM 1

; ---------------------------------------------------------------------------
; Setting up a frequency of a channel correctly
; --- input -----------------------------------------------------------------
; d0.w = Channel number
; d2.b = Panning
; d4.l = Sinewave delay timer
; ---------------------------------------------------------------------------

PS_SetupFrequ:
		movem.l	d0-d3,-(sp)					; store registers
		move.b	d2,d1						; store panning in d1
		moveq	#-($100-$B0),d2					; prepare to start from Feedback/Algorithm
		add.b	PS_ChanReg(pc,d0.w),d2				; load register ID
		move.b	PS_ChanAlt(pc,d0.w),d3				; load correct alternate register ID
		move.b	PS_ChanPart(pc,d0.w),d0				; load YM2612 part

	; Key off

		bsr.w	.WaitYM						; wait for YM2612
		move.b	#$28,(a1)					; set to FM key
		bsr.w	.WaitYM						; wait for YM2612
		move.b	d3,(a2)						; turn all four keys off

	; Algorithm

		bsr.w	.WaitYM						; wait for YM2612
		move.b	d2,(a1,d0.w)					; set to alogrithm/feedback
		bsr.w	.WaitYM						; wait for YM2612
		move.b	#$07,(a2,d0.w)					; set algorithm to all operators as sinewaves (no feedback)

	; Panning

		addq.b	#$04,d2						; advance to panning
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d2,(a1,d0.w)					; set to panning
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d1,(a2,d0.w)					; set panning speaker

	; Frequency

		subi.b	#$10,d2						; advance to frequency high byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d2,(a1,d0.w)					; set to frequency high byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$00,(a2,d0.w)					; set frequency high byte

		subq.b	#$04,d2						; advance to frequency low byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d2,(a1,d0.w)					; set to frequency low byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$40,(a2,d0.w)					; set frequency low byte

	; Key on

		ori.b	#%11110000,d3					; prepare all keys on
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$28,(a1)					; set to FM key
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d3,(a2)						; turn all four keys off

	; Delay for sinewave
	; This is perfectly timed such that the sinewave reaches its peak
	; before forcing frequency to 0, this time is for frequency of 0040
	; and is accurate enough for BlastEm, Regen, Gens (Movie Test), and Kega
	; Don't know about hardware though it has a dc return to 0 filter, so
	; it'd be hard to check.

		swap	d4

	.WaitSine:
		swap	d4
		dbf	d4,*
		swap	d4
		dbf	d4,.WaitSine

	; Stop frequency

		addi.b	#$04,d2						; advance to frequency high byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d2,(a1,d0.w)					; set to frequency high byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$00,(a2,d0.w)					; set frequency high byte

		subq.b	#$04,d2						; advance to frequency low byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	d2,(a1,d0.w)					; set to frequency low byte
		bsr.s	.WaitYM						; wait for YM2612
		move.b	#$00,(a2,d0.w)					; set frequency low byte

		movem.l	(sp)+,d0-d3					; restore registers
		rts							; return

	.WaitYM:	; nops not required, as a "bsr/jsr" is slow enough...
		tst.b	(a1)						; load busy flag
		bmi.s	*-2						; if busy, wait...
		rts							; return (ready!)

; ===========================================================================
; ---------------------------------------------------------------------------
; YM2612 inverse exponential TL conversion tables
; ---------------------------------------------------------------------------

	; This version works the best as far as Hellfire team claims, it's
	; louder at least, so perhaps that's contributing towards bias
	; ala the loudness wars, either way, using this method...

PS_Conv2:	dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00
		dc.b	$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02
		dc.b	$02,$02,$02,$02,$03,$03,$03,$03,$03,$03,$03,$03,$03,$04,$04,$04
		dc.b	$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$06,$06,$06,$06
		dc.b	$06,$06,$07,$07,$07,$07,$07,$07,$07,$08,$08,$08,$08,$08,$09,$09
		dc.b	$09,$09,$09,$0A,$0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C
		dc.b	$0D,$0D,$0D,$0D,$0E,$0E,$0E,$0F,$0F,$0F,$10,$10,$10,$11,$11,$12
		dc.b	$12,$13,$13,$14,$14,$15,$15,$15,$16,$16,$17,$18,$19,$1A,$1A,$1B
		dc.b	$1D,$1E,$1F,$21,$22,$23,$25,$26,$27,$29,$2B,$2E,$33,$3B

PS_Conv1:	dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
		dc.b	$7F,    $3B,$33,$2E,$2B,$29,$27,$26,$25,$23,$22,$21,$1F,$1E,$1D
		dc.b	$1B,$1A,$1A,$19,$18,$17,$16,$16,$15,$15,$15,$14,$14,$13,$13,$12
		dc.b	$12,$11,$11,$10,$10,$10,$0F,$0F,$0F,$0E,$0E,$0E,$0D,$0D,$0D,$0D
		dc.b	$0C,$0C,$0C,$0B,$0B,$0B,$0B,$0B,$0A,$0A,$0A,$0A,$0A,$09,$09,$09
		dc.b	$09,$09,$08,$08,$08,$08,$08,$07,$07,$07,$07,$07,$07,$07,$06,$06
		dc.b	$06,$06,$06,$06,$05,$05,$05,$05,$05,$05,$05,$04,$04,$04,$04,$04

		dc.b	$04,$04,$04,$03,$03,$03,$03,$03,$03,$03,$03,$03,$02,$02,$02,$02
		dc.b	$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b	$00

; Old and more "expected" set of conversion values, which don't seem to produce
; the sound, probably because of the ladder effect, or the TL logarithm, who knows...

;PS_Conv2:	dc.b	$00,$00
;		dc.b	$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02
;		dc.b	$02,$02,$02,$02,$03,$03,$03,$03,$03,$03,$03,$03,$03,$04,$04,$04
;		dc.b	$04,$04,$04,$04,$04,$05,$05,$05,$05,$05,$05,$05,$06,$06,$06,$06
;		dc.b	$06,$06,$07,$07,$07,$07,$07,$07,$07,$08,$08,$08,$08,$08,$09,$09
;		dc.b	$09,$09,$09,$0A,$0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C
;		dc.b	$0D,$0D,$0D,$0D,$0E,$0E,$0E,$0F,$0F,$0F,$10,$10,$10,$11,$11,$12
;		dc.b	$12,$13,$13,$14,$14,$15,$15,$15,$16,$16,$17,$18,$19,$1A,$1A,$1B
;		dc.b	$1D,$1E,$1F,$21,$22,$23,$25,$26,$27,$29,$2B,$2E,$33,$3B
;
;PS_Conv1:	dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;		dc.b	$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F
;
;		dc.b	$7F,    $3B,$33,$2E,$2B,$29,$27,$26,$25,$23,$22,$21,$1F,$1E,$1D
;		dc.b	$1B,$1A,$1A,$19,$18,$17,$16,$16,$15,$15,$15,$14,$14,$13,$13,$12
;		dc.b	$12,$11,$11,$10,$10,$10,$0F,$0F,$0F,$0E,$0E,$0E,$0D,$0D,$0D,$0D
;		dc.b	$0C,$0C,$0C,$0B,$0B,$0B,$0B,$0B,$0A,$0A,$0A,$0A,$0A,$09,$09,$09
;		dc.b	$09,$09,$08,$08,$08,$08,$08,$07,$07,$07,$07,$07,$07,$07,$06,$06
;		dc.b	$06,$06,$06,$06,$05,$05,$05,$05,$05,$05,$05,$04,$04,$04,$04,$04
;		dc.b	$04,$04,$04,$03,$03,$03,$03,$03,$03,$03,$03,$03,$02,$02,$02,$02
;		dc.b	$02,$02,$02,$02,$02,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00
;		dc.b	$00

	; The TL output (at least according to BlastEm, can't test on hardware right now).
	;	dc.b	$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	;	dc.b	$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	;	dc.b	$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	;	dc.b	$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80
	;	dc.b	$80,$80,$80,$80,$82,$82,$82,$82,$82,$82,$82,$82,$83,$83,$83,$83
	;	dc.b	$83,$84,$84,$84,$85,$85,$86,$86,$87,$88,$89,$89,$8A,$8B,$8C,$8C
	;	dc.b	$8D,$8E,$8F,$8F,$90,$91,$93,$94,$95,$96,$98,$9B,$9D,$9F,$A1,$A3
	;	dc.b	$A6,$A9,$AC,$B0,$B3,$B8,$BD,$C2,$C7,$CE,$D4,$DB,$E3,$EC,$F5,$FF

; ===========================================================================
; ===========================================================================
; ---------------------------------------------------------------------------
; Devil's Descent Events
; ---------------------------------------------------------------------------

DDZ_BackgroundInit:
		jsr	DDZ_DeformFG				; perform scrolling
		jsr	(InitFGCam).w				; get FG parameters at proper registers
		jsr	(RedrawPMap_Full).w			; (1 cam) refresh plane (full)
		jsr	(InitBGCam).w				; get BG parameters at proper registers
		jmp	(RedrawPMap_Full).w			; (1 cam) refresh plane (full)

; ---------------------------------------------------------------------------
; Scroll events
; ---------------------------------------------------------------------------

DDZ_BackgroundEvent:
		bsr.w	DDZ_DeformFG				; scroll foreground
		bsr.w	DDZ_RotateBG				; scroll background in rotation fashion
		jsr	WobbleScreen				; allow the screen to wobble
DDZ_BE_Return:	rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Background rotation scrolling
; ---------------------------------------------------------------------------
SKEW_MULTSHIFTX = 7
SKEW_MULTSHIFTY = SKEW_MULTSHIFTX+1
; ---------------------------------------------------------------------------

DDZ_RotateBG:
		tst.b	(RDD_Worm+WmShow).l			; is the worm showing?
		beq.s	DDZ_BE_Return				; if not, branch

	; --- Angle ---

		moveq	#-$40,d0				; prepare 90 degree bit angle reverse
		moveq	#$00,d6					; clear d0
		move.b	(RDD_Worm+WmAngle).l,d6			; load angle of worm head
	ext.w	d6
	;	add.b	d0,d6					; reverse opposing corners (wanna swap left 90 degrees with negative version of sine values)
	;	eor.b	d0,d6					; ''
	;	add.w	d6,d6					; multiply by size of word element
	;	addi.w	#(SineTable+$80)&$FFFF,d6		; advance to correct sinewave element slot
	;	movea.w	d6,a0					; set address of element
	;	move.w	(a0),d6					; load sine position
	;	bpl.s	.Valid					; if we're rotated up to 90 degrees right, branch
	;	addi.w	#$0200,d6				; setup to reverse (does the same as add 100 then neg, the sub 100 neg below will do the rest)

	;.Valid:
	;	subi.w	#$0100,d6				; reverse
	;	neg.w	d6					; ''

	; --- Positions ---

		moveq	#$00,d5					; clear upper word
		move.w	(RDD_Worm+WmDispY).l,d5			; load worm Y position
		sub.w	(Camera_Y_pos).w,d5			; minus camera Y position
		move.w	(RDD_Worm+WmHeight).l,d0		; load worm height HALF
		move.w	d0,d1					; keep a copy
		add.w	d1,d1					; get full height
		addi.w	#224,d1					; add height of screen
		add.w	d5,d0					; account for worm being partially off-screen above
		cmp.w	d1,d0					; is the worm off-screen fully?
		bhs.w	.Offscreen				; if so, skip rotation skew rendering

		moveq	#$00,d4					; clear upper word
		move.w	(RDD_Worm+WmDispX).l,d4			; load worm X position
		sub.w	(Camera_X_pos).w,d4			; minus camera X position
		move.w	(RDD_Worm+WmWidth).l,d0			; load worm width HALF
		move.w	d0,d1					; keep a copy
		add.w	d1,d1					; get full width
		moveq	#$10/2,d2				; prepare slice slot width (VSRAM slot)
		add.w	d1,d2					; add to width
		addi.w	#320,d1					; add width of screen
		add.w	d4,d0					; account for worm being partially off-screen left
		cmp.w	d1,d0					; is the worm off-screen fully?
		bhs.w	.Offscreen				; if so, skip rotation skew rendering
		sub.w	d2,d0					; move left boundary right by width of worm and slice width
		sub.w	d2,d1					; move right boundary left by width of worm and slice width
		sub.w	d2,d1					; ''
		cmp.w	d1,d0					; is the worm head touching the edges of the screen within a slice width?
		shs.b	(RDD_SlicePriority).l			; set -1 slice priority correctly depending on position

	; --- H-Scroll ---

		lea	(RDD_HScrollBG).l,a1			; load BG H-scroll table

		move.l	d6,d0					; load sine position
		muls.w	d5,d0					; multiply by Y position (number of scanlines before reaching centre of worm head)
		neg.l	d0					; start negative (to the left
		asl.l	#SKEW_MULTSHIFTX,d0			; align quotient

		move.l	d6,d2					; load skew amount
		ext.l	d2					; extend to long-word
		asl.l	#SKEW_MULTSHIFTX-1,d2			; align quotient (but divide by 2 has H-scroll middle needs to not be 0)
		add.l	d2,d0					; add half already
		add.l	d2,d2					; finish aligning quotient

		move.w	(RDD_Worm+WmWidth).l,d1			; load head width
		neg.w	d1					; subtract from X position
		add.w	d4,d1					; ''
		swap	d1					; align for QQQQ.FFFF
		add.l	d1,d0					; move scanlines to correct X position
	;	move.w	#224-1,d7				; number of scanlines to do
		bsr.w	.NextScrollH				; render H-scroll

	; --- Masking Y wrap ---
	; Because I cannot expand the plane height without interfering
	; with the project's engine, this routine will force the H-Scroll
	; positions off-screen at the top if the head to overlapping the
	; bottom and vis versa.
	; ----------------------

		move.w	(RDD_Worm+WmWidth).l,d2			; load width of head
		add.w	d2,d2					; '' (full width)
		neg.w	d2					; reverse left off-screen instead of right
		move.w	d2,d1					; put on both words
		swap	d2					; ''
		move.w	d1,d2					; ''

		move.w	(RDD_Worm+WmHeight).l,d0		; load height of head
		moveq	#-1,d7					; get size to clear
		add.w	d0,d7					; ''
		subi.w	#(256-224)/2,d7				; minus thickness of void space around the screen
		neg.w	d0					; prepare subtraction
		move.w	d0,d3					; remove height from position
		add.w	d5,d3					; ''
		add.w	d0,d0					; get full height
		move.w	d0,d1					; store a copy for H-scroll table address
	;	addi.w	#224,d0					; add height of screen (screen - head height = size of screen head is fully on)
	addi.w	#256/2,d0				; add half height of plane (if the head is below top half of plane area)
		lea	(RDD_HScrollBG).l,a1			; load BG H-scroll table
		cmp.w	d0,d3					; is the worm head fully on-screen?
		blo.s	.InRange				; if so, branch
		bpl.s	.ClearTop				; worm has gone just below the screen
		add.w	d1,d1					; advance to bottom of H-scroll table (as worm has gone just above the screen instead)
		addi.w	#((256-224)*2)&$FFFE,d1			; account for thickness of voice space around the screen
		addi.w	#$1C0,d1				; ''
		adda.w	d1,a1					; ''

	.ClearTop:
		move.l	d2,(a1)+				; clear top/bottom of H-scroll table (height of worm)
		dbf	d7,.ClearTop				; repeat until height of worm is clear

	.InRange:

	; --- V-Scroll ---

		lea	(RDD_VScrollBG).l,a1			; load BG H-scroll table

		move.l	d6,d0					; load sine postion
		move.w	d4,d1					; load X position
		muls.w	#(224/2),d1				; convert from 320 to 224
		divs.w	#(320/2),d1				; ''
		muls.w	d1,d0					; multiply sine by X position (number of slots before reaching centre of worm head)
		neg.l	d0					; start negative (on the top)
		asl.l	#SKEW_MULTSHIFTY,d0			; align quotient

		move.l	d6,d2					; load skew amount
		muls.w	#(224/2)/((320/$10)/2),d2		; correct for V-scroll
		asl.l	#SKEW_MULTSHIFTY-1,d2			; align quotient (but divide by 2 has V-scroll middle needs to not be 0)
		add.l	d2,d0					; add half already
		add.l	d2,d2					; finish aligning quotient

		move.w	(RDD_Worm+WmHeight).l,d1		; load head height
		neg.w	d1					; subtract from Y position
		add.w	d5,d1					; ''
		subi.w	#(DDZ_WORM_PLANEPOS/$80)*8,d1		; adjust for render position on plane where the art is
		swap	d1					; align for QQQQ.FFFF
		sub.l	d1,d0					; move scanlines to correct Y position
	;	move.w	#(320/$10)-1,d7				; number of slots to do
		bsr.w	.NextScrollV				; render V-scroll poisitions
		cmpi.w	#320/2,d4				; is the ship on the right of the screen?
		bge.s	.NoFixLeft				; if so, continue
		move.w	(RDD_VScrollBG).l,(RDD_VScrollBG+$26).l	; set far right (-1) postion the same as left
	;move.w	#-1,(RDD_VScrollFG+$26).l	; the entire Y position will be FFFF...

	.NoFixLeft:
		rts						; return

	;.NextScroll:
	;	move.l	d0,d1		; 4			; get quotient
	;	swap	d1		; 4			; ''
	;	move.w	d1,(a1)+	; 8			; save to H-scroll table
	;	add.l	d2,d0		; 8			; skew for next scanline
	;	dbf	d7,.NextScroll				; repeat for all scanlines/slots
	;	rts						; return



	.OffScreen:
		sf.b	(RDD_SlicePriority).l			; set -1 slice priority to FG
		move.w	(RDD_Worm+WmWidth).l,d0			; load head width
		add.w	d0,d0					; get full width
		neg.w	d0					; reverse left instead of right
		move.w	d0,d1					; set both words such that the ship is off-screen
		swap	d0					; ''
		move.w	d1,d0					; ''
		lea	(RDD_HScrollBG).l,a1			; load BG H-scroll table
		moveq	#((224/4)/4)-1,d7			; number of scanlines

	.FloodScroll:
		rept	4
		move.l	d0,(a1)+				; flood positions to hide the worm
		endm
		dbf	d7,.FloodScroll				; repeat until done

		moveq	#$00,d0					; no V-scroll
		lea	(RDD_VScrollBG).l,a1			; load BG V-scroll table
		rept	($28/4)
		move.l	d0,(a1)+				; flood positions to hide the worm
		endm
		rts						; return

	.NextScrollV:
	move.l	d2,d3
	swap	d3
	move.l	d0,d1
	swap	d1
	rept	(320/$10)
		add.w	d2,d0		; 4
		addx.w	d3,d1		; 4
		move.w	d1,(a1)+	; 8
	endm
		rts

	.NextScrollH:
	move.l	d2,d3
	swap	d3
	move.l	d0,d1
	swap	d1
	rept	224-$2E	; Don't need to scroll the floor area for the boss...
		add.w	d2,d0		; 4
		addx.w	d3,d1		; 4
		move.w	d1,(a1)+	; 8
	endm
		rts


; ===========================================================================
; ---------------------------------------------------------------------------
; Foreground (level) scrolling
; ---------------------------------------------------------------------------

DDZ_DeformFG:
		tst.b	(RDD_SliceVScroll).l			; is level in sliced V-scroll mode?
		beq.s	.NoSliceV				; if not, skip
		move.w	(V_scroll_value).w,d0			; load FG V-scroll
		move.w	d0,d1					; '' to both words
		swap	d0					; ''
		move.w	d1,d0					; ''
		lea	(RDD_VScrollFG).l,a1			; load FG H-scroll table
		rept	($28/4)
		move.l	d0,(a1)+				; flood positions to hide the worm
		endm

	.NoSliceV:

	; --- Top ---

		lea	(RDD_HScrollFG).l,a1			; load FG H-scroll table
		move.w	(v_screenposx).w,d0			; load X position for FG
		neg.w	d0					; reverse direction for H-scroll table
		move.w	d0,d1					; copy to both words
		swap	d0					; ''
		move.w	d1,d0					; ''
		move.w	#(($90/2)-1)+1,d4			; number of scanlines

	.NextTop:
		move.l	d0,(a1)+				; set top machine scroll position
		dbf	d4,.NextTop				; repeat for all scanlines

	; --- Mist ---

		subi.l	#$00004000,(v_deformtablebuffer).w	; let mist flow backwards
		move.l	(v_deformtablebuffer).w,d1		; load mist quotient
		move.w	(v_deformtablebuffer).w,d1		; ''
		rept	($20/2)
		move.l	d1,(a1)+				; write mist scanlines
		endm

	; --- Floor top scanlines ---

		moveq	#$09-1,d4				; number of scanlines for skewing

		clr.w	d0					; clear fraction
		move.l	d0,d1					; get percentage of position
		asr.l	#$04,d1					; ''

	.NextSkew:
		add.l	d1,d0					; change position
		move.l	d0,(a1)					; write scanline
		addq.w	#$02,a1					; advance to next scanline
		dbf	d4,.NextSkew				; repeat for skew lines

	; --- Floor segments ---

		add.l	d1,d0					; change position
		moveq	#$04-1,d4				; size of segment
		bsr.s	.DoSegment				; write segment

		add.l	d1,d0					; change position
		moveq	#$03-1,d4				; size of segment
		bsr.s	.DoSegment				; write segment

		asr.l	#$01,d1					; change speed
		add.l	d1,d0					; change position
		moveq	#($20-1)-1,d4				; size of segment

	.DoSegment:
		move.l	d0,d2					; get only the quotient
		swap	d2					; ''

	.NextSegment:
		move.w	d2,(a1)+				; write scanline segment
		dbf	d4,.NextSegment				; repeat for segment size
		rts						; return

; ===========================================================================






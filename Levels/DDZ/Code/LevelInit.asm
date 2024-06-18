; ===========================================================================
; ---------------------------------------------------------------------------
; Level init subroutine to call if zone is DDZ
; ---------------------------------------------------------------------------

Level_InitDDZ:
		move.l	#VBlank_DDZ,(V_int_addr).w			; set to use unique V-blank routine
		move.l	#NullRTE,(H_int_addr).w				; set no H-blank routine (for now)

	; --- Clearing RAM section ---

		moveq	#$00,d0						; clear d0
		lea	(RDD_RAM).l,a1					; load Sock RAM section to clear
		move.w	#((RDD_RAM_End-RDD_RAM)/4)-1,d1			; number of long-words to clear

	.ClearRAM:
		move.l	d0,(a1)+					; clear RAM
		dbf	d1,.ClearRAM					; repeat for entire RAM section

	; --- Setting up ---

		sf.b	(ScreenWobble).w				; set no screen wobble

		st.b	(RDD_PentShow).l				; set to show the pentagram
		st.b	(RDD_CandlesShow).l				; set to show the candles
		st.b	(RDD_EggIntroShow).l				; set to show eggman intro sprites
		sf.b	(RDD_PentAngle).l				; reset pentagram angle
		st.b	(RDD_PentAngPrev).l				; force pentagram to render first frame
		move.w	#$0020*3,(RDD_PentScale).l			; set initial scale amount
		move.w	#$0180,(RDD_PentSpeed).l

		lea	($C00004).l,a6					; load VDP control port

		lea	(Plc_EggIntro).l,a1				; load PLC list
		adda.w	6*2(a1),a1					; advance to cover frame
		move.l	#ArtUnc_EggmanIntro/2,d2			; set source art address
		move.l	#$40200000|VDD_EggCoverIntroArt,d3		; set VRAM address to dump to
		bsr.w	TransferDPLC					; perform the transfer

		moveq	#$01,d0						; load width of mappings in tiles
		add.b	(Map_WormHead+$00).l,d0				; ''
		add.w	d0,d0						; convert to pixel width (but divide by 2 for half width)
		add.w	d0,d0						; ''
		move.w	d0,(RDD_Worm+WmWidth).l				; store width for later
	;	moveq	#$01,d0						; load height of mappings in tiles
	;	add.b	(Map_WormHead+$01).l,d0				; ''
	;	add.w	d0,d0						; convert to pixel height (but divide by 2 for half height)
	;	add.w	d0,d0						; ''
	;	move.w	d0,(RDD_Worm+WmHeight).l			; store height for later
		move.w	#DDZ_WORM_HEIGHT/2,(RDD_Worm+WmHeight).l	; set the height of the worm for later

		move.b	#60*2,(RDD_Worm+WmBeamCharge).l			; setup charge time

		move.w	#60*2,(RDD_ExplodeTimer).l			; set delay time to run explosions when boss is defeated
		move.b	#-4,(RDD_VortexFrame).l				; reset vortex frame ID

		rts							; return

; ===========================================================================
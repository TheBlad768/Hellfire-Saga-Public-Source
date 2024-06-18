; ---------------------------------------------------------------------------
; Palette cycling routine loading subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Animate_Palette:
	cmpi.w	#$0400,(Current_Zone).w
	bne.s	.NoCredits
	moveq	#$03,d0
	and.w	(Level_frame_counter).w,d0
	bne.s	AnPal_None

	.NoCredits:
		tst.w	(Palette_fade_timer).w
		bmi.s	AnPal_None
		beq.s	AnPal_Load
		subq.w	#1,(Palette_fade_timer).w
		bne.s	.NoFinish					; MJ: if timer isn't finished, branch
		cmpi.b	#$04,(Current_Zone).w				; MJ: is this the credits?
		bne.s	.NoRestore					; MJ: if not, skip background blanking
		cmpi.w	#(CreditsLineRender_End-CreditsLineRender)/$20,(CreditsLine_Amount).w ; has the render effect finished?
		blo.s	.NoFinish					; MJ: if so, skip blanking
		lea	(CreditsLetters).l,a0				; MJ: clear letter space
		moveq	#$00,d0						; ''
		move.w	#(($2000/4)/4)-1,d1				; '' size of clear

	.Clear:
		move.l	d0,(a0)+					; ''
		move.l	d0,(a0)+					; ''
		move.l	d0,(a0)+					; ''
		move.l	d0,(a0)+					; ''
		dbf	d1,.Clear					; ''
		st.b	(CreditsLetters+CreShape).l			; force last piece on first entry
		st.b	(CreditsText_Ready).w				; allow sprites to show
		move.l	#CRE_RT_Start,(CreditsRoutine).w		; MJ: set to show the message

	.NoFinish:
		move.w	(Palette_fade_timer).w,d4			; MJ: load timer as d4 fade counter
		jsr	(Pal_FromBlack).w
		cmpi.b	#$04,(Current_Zone).w				; MJ: is this the credits?
		bne.s	.NoRestore					; MJ: if not, skip background blanking
		cmpi.w	#(CreditsLineRender_End-CreditsLineRender)/$20,(CreditsLine_Amount).w ; has the render effect finished?
		bge.s	.NoRestore					; MJ: if so, skip blanking
		lea	(Normal_palette+$6A).w,a1			; MJ: keep these colours black
		moveq	#$00,d0						; ''
		move.l	d0,(a1)+					; ''
		move.l	d0,(a1)+					; ''
		move.l	d0,(a1)+					; ''
		move.l	d0,(a1)+					; ''
		move.l	d0,(a1)+					; ''

	.NoRestore:
		rts
; ---------------------------------------------------------------------------

AnPal_None:
		rts
; ---------------------------------------------------------------------------

AnPal_Load:
		movea.l	(Level_data_addr_RAM.AnPal).w,a0
		jmp	(a0)

; =============== S U B R O U T I N E =======================================
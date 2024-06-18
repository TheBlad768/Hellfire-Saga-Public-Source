; ===========================================================================
; ---------------------------------------------------------------------------
; Example external sound driver function
; ---------------------------------------------------------------------------

dFractalExtra:
		moveq	#0,d4					; clear update flags
		btst	#dxbShoes,dxFlags.w			; check if speed shoes is active
		beq.s	.checkvol				; branch if not

		moveq	#$FFFFFF80,d0				; load max value to d0
		moveq	#4,d1					; load offset to d1
		btst	#dxbShoesOn,dxFlags.w			; check if enabling shoes
		bne.s	.shoescalc				; branch if yes
		moveq	#-4,d1					; negate direction
		moveq	#0,d0					; set max amount

.shoescalc
		move.b	dxShoesIndex.w,d4			; load index to d4
		cmp.b	d4,d0					; check if index matches
		beq.s	.resetshoes				; branch if yes

		add.b	d1,d4					; offset the index by amount
		move.b	d4,dxShoesIndex.w			; save index back

		add.w	d4,d4					; *2
		add.w	d4,d4					; *4
		add.w	#$1000,d4				; add base tempo
		move.w	d4,dxShoesTempo.w			; save as speed shoes tempo

		moveq	#$20,d4					; set tempo bit
		bra.s	.checkvol

.resetshoes
		bclr	#dxbShoes,dxFlags.w			; reset slide
; ---------------------------------------------------------------------------

.checkvol
		move.w	dxFadeOff.w,d0				; load fade offset to d0
		beq.s	.checkuw				; branch if no fade in/out
		tas	d4					; set volume bit

		add.w	d0,dxFadeVol.w				; add to fade volume
		bpl.s	.checkuw				; if still positive, do not cap volume

		tst.w	d0					; check fade direction
		spl	d0					; if fading out, d0 = $FF
		and.b	#$7F,d0					; d0 = 0 or $7F
		move.b	d0,dxFadeVol.w				; reset high byte of fade volume to max
		clr.w	dxFadeOff.w				; reset fading flag
; ---------------------------------------------------------------------------

.checkuw
		tst.b	dxFlags.w				; check if underwater fade is active
		beq.w	.checkflags				; branch if not

		moveq	#$30,d0					; load max value to d0
		moveq	#4,d1					; load offset to d1
		btst	#dxbUnderwaterOn,dxFlags.w		; check if enabling underwater mpde
		bne.s	.uwcalc					; branch if yes
		moveq	#-4,d1					; negate direction
		moveq	#0,d0					; set max amount

.uwcalc
		moveq	#0,d2
		move.b	dxWaterIndex.w,d2			; load index to d2
		cmp.b	d2,d0					; check if index matches
		beq.s	.checkuwmod				; branch if yes

		add.b	d1,d2					; offset the index by amount
		move.b	d2,dxWaterIndex.w			; save index back

		move.w	d2,d1					; copy value to d1
		add.w	d1,d1					; *2
		add.w	d2,d1					; *3
		lsr.w	#2,d2					; /4
		sub.w	d2,d1					; *2.125
		move.w	d1,dxWaterTempo.w			; save underwater tempo offset

		move.b	d2,dxWaterVolPSG.w			; save underwater volume offset
		lsr.w	#1,d2					; /8
		move.b	d2,dxWaterVol.w				; save underwater volume offset

		bclr	#dxbUnderwaterCmd,dxFlags.w		; reset underwater command flag
		beq.s	.notset					; branch if it wasnt set
		jsr	dPlayCmd_UnderwaterOff			; disable underwater mode
		clr.w	dxWaterFrac.w				; reset fraction
		or.b	#$40,d4					; update fraction as well

.notset
		or.b	#$A0,d4					; add tempo and volume update flags
		move.b	#$40,dxWaterVibIx.w			; reset phase
		bra.s	.checkflags
; ---------------------------------------------------------------------------

.checkuwmod
		tst.w	d0					; check max amount
		bne.s	.douwmod				; branch if fully slided on
		bclr	#dxbUnderwater,dxFlags.w		; reset slide
		bra.s	.checkflags

.douwmod
		or.b	#$40,d4					; update fraction
		bset	#dxbUnderwaterCmd,dxFlags.w		; set underwater command flag
		bne.s	.wasset					; branch if it was already set
		jsr	dPlayCmd_UnderwaterOn			; enable underwater mode

.wasset
		lea	($200*vsSine)+dVibLUTs,a0		; load sine table to a0
		moveq	#0,d0
		move.b	dxWaterVibIx.w,d0			; load index to d0
		add.w	d0,d0					; *2 for words
		move.b	(a0,d0.w),d0				; load LUT value

		add.b	#$35,dxWaterVibIx.w			; go to next index
		ext.w	d0					; sign-extend d0
		asr.w	#2,d0					; /4
		move.w	d0,dxWaterFrac.w			; save into fraction value
; ---------------------------------------------------------------------------

.checkflags
		add.b	d4,d4					; shift bit7 to carry (check for volume update)
		bcc.s	.checkfrac				; branch if no

		moveq	#$7E,d0					; load mask to d0
		and.b	dxFadeVol.w,d0				; AND fade volume with d0
		lea	dVibLUTs+($200*vsSine)+$82,a0		; load sine table to a0, offset to get the peak to centre part
		move.b	(a0,d0.w),d1				; load the sine to d0 (high bits only, this gets us $7F..$00 value)

		moveq	#$7F,d0					; load max volume to d0
		sub.b	d1,d0					; subtract the vib LUT value from it

		move.w	d0,d1					; copy to d1
		add.b	dxWaterVolPSG.w,d1			; add PSG volume to d1
		add.b	dxWaterVol.w,d0				; add volume to d0
		jsr	dUpdateMasterVol			; update master volume
		bra.s	.checkfrac
; ---------------------------------------------------------------------------

.loadLUT
		rts
; ---------------------------------------------------------------------------

.checkfrac
		add.b	d4,d4					; shift bit6 to carry (check for fraction update)
		bcc.s	.checktempo				; branch if no
	clr.w	d0					; temp lol
		sub.w	dxWaterFrac.w,d0			; subtract water fraction offset
		jsr	dUpdateMasterFrac			; update master fractiom
; ---------------------------------------------------------------------------

.checktempo
		add.b	d4,d4					; shift bit5 to carry (check for tempo update)
		bcc.s	.rts					; branch if no
		move.w	dxShoesTempo.w,d0			; load speed shoes tempo offset
		sub.w	dxWaterTempo.w,d0			; subtract underwater tempo offset
		jmp	dUpdateMasterTempo			; update master tempo

.rts
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Commands for fades
; ---------------------------------------------------------------------------

dxFadeInCmd:
		move.w	#-$220,dxFadeOff.w			; update fade speed
		rts

dxFadeOutCmd:
		move.w	#$220,dxFadeOff.w			; update fade speed
		rts

dxFadeResetCmd:
		st	dxFadeOff.w				; force update fade
		clr.w	dxFadeVol.w				; reset fadeout volume
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Commands for speed shoes
; ---------------------------------------------------------------------------

dxShoesOnCmd:
		or.b	#1<<dxbShoesOn|1<<dxbShoes,dxFlags.w	; enable speed shoes
		rts

dxShoesOffCmd:
		bclr	#dxbShoesOn,dxFlags.w			; set speed shoes as off
		bset	#dxbShoes,dxFlags.w			; enable speed shoes slide
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Reset command
; ---------------------------------------------------------------------------

dxReset:
		bsr.s	dxShoesOffCmd				; reset speed shoes
		move.w	#$1000,dxShoesTempo.w			; reset speed shoes tempo

		clr.w	dxFadeOff.w				; reset fade offset
		clr.b	dxShoesIndex.w				; reset shoes index
		clr.b	dxFlags.w				; reset all flags
		clr.w	dxFadeVol.w				; reset fadeout volume

		pea	dPlayCmd_Reset				; run Fractal reset function after the next routine
	; reset underwater mode

; ===========================================================================
; ---------------------------------------------------------------------------
; Commands for underwater mode
; ---------------------------------------------------------------------------

dxUnderwaterOffCmd:
		bclr	#dxbUnderwaterOn,dxFlags.w		; set underwater mode as off
		bset	#dxbUnderwater,dxFlags.w		; enable underwater mode slide
		rts

dxUnderwaterOnCmd:
		or.b	#1<<dxbUnderwaterOn|1<<dxbUnderwater,dxFlags.w; enable underwater mode
		rts

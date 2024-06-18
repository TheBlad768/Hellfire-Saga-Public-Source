; ===========================================================================
; ---------------------------------------------------------------------------
; Process SFX PSG channels
; ---------------------------------------------------------------------------

dAMPSdoPSGSFX:
		moveq	#SFX_PSG-((FEATURE_PSG4<>0)&1)-1,d0; get total number of SFX PSG channels to d0
	if FEATURE_PSGADSR
		lea	mADSRSFX-adSize.w,a3	; load PSG ADSR data to a3
	endif

dAMPSnextPSGSFX:
	if FEATURE_PSGADSR
		addq.w	#adSize,a3		; add ADSR size to a3
	endif
		add.w	#cSizeSFX,a1		; go to the next channel
		move.b	cExtraFlags(a1),mExtraFlags.w; copy flags to extra flags

		tst.b	(a1)			; check if channel is running a tracker
		bpl.w	.next			; if not, branch
		subq.b	#1,cDuration(a1)	; decrease note duration
		beq.w	.update			; if timed out, update channel

	dCalcFreq				; calculate channel base frequency
	dModPorta .endm, -1, -1			; run modulation + portamento code
		bsr.w	dUpdateFreqPSG3		; if frequency needs changing, do it

.endm
		jsr	dEnvelopePSG_SFX(pc)	; run envelope program

.next
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextPSGSFX	; make sure to run all the channels
		jmp	dAMPSdoPSG4SFX(pc)	; after that, check tracker and end loop
; ---------------------------------------------------------------------------

.update
		and.b	#$FF-(1<<cfbFreqFrz)-(1<<cfbRest),(a1); clear rest and frequency freeze flags
	dDoTracker				; process tracker
		tst.b	d1			; check if note is being played
		bpl.s	.timer			; if not, it must be a timer. Branch

	dGetFreqPSG				; get PSG frequency
		move.b	(a2)+,d1		; check if next byte is a timer
		bpl.s	.timer			; if yes, handle it
		subq.w	#1,a2			; else, undo the increment
		bra.s	.pcnote			; do not calculate duration

.timer
		move.b	d1,cLastDur(a1)		; save as the new duration
; ---------------------------------------------------------------------------

.pcnote
	dProcNote 1, 1				; reset necessary channel memory
		bsr.w	dUpdateFreqPSG		; update hardware frequency
		jsr	dEnvelopePSG_SFX(pc)	; run envelope program

	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextPSGSFX	; make sure to run all the channels

	; continue to check tracker and end loop
; ===========================================================================
; ---------------------------------------------------------------------------
; Music PSG channel loop
; ---------------------------------------------------------------------------

dAMPSdoPSG4SFX:
	if FEATURE_PSG4
		if FEATURE_PSGADSR
			addq.w	#adSize,a3	; add ADSR size to a3
		endif
		add.w	#cSizeSFX,a1		; go to the next channel

		tst.b	(a1)			; check if channel is running a tracker
		bpl.w	dCheckTracker		; if not, branch
		subq.b	#1,cDuration(a1)	; decrease note duration
		beq.s	.update			; if timed out, update channel

		jsr	dEnvelopePSG(pc)	; run envelope program

.next
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		jmp	dCheckTracker(pc)	; after that, process SFX DAC channels
; ---------------------------------------------------------------------------

.update
		and.b	#$FF-(1<<cfbFreqFrz)-(1<<cfbRest),(a1); clear rest and frequency freeze flags
	dDoTracker	4			; process tracker
		tst.b	d1			; check if note is being played
		bpl.s	.timer			; if not, it must be a timer. branch

	if safe=1
		AMPS_Debug_NotePSG4
	endif

		add.b	d1,d1			; double and delete msb
		lea	dNotesPSG4(pc),a4	; load notes table to a4
		jsr	(a4,d1.w)		; execute specific code for note

		move.b	(a2)+,d1		; check if next byte is a timer
		bpl.s	.timer			; if yes, handle it
		subq.w	#1,a2			; else, undo the increment
		bra.s	.pcnote			; do not calculate duration

.timer
		move.b	d1,cLastDur(a1)		; save as the new duration
; ---------------------------------------------------------------------------

.pcnote
	dProcNote 1, 4				; reset necessary channel memory
		jsr	dEnvelopePSG(pc)	; run envelope program

	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
	endif

	; continue to check tracker and end loop
; ===========================================================================
; ---------------------------------------------------------------------------
; End channel loop and check if tracker debugger should be opened
; ---------------------------------------------------------------------------

dCheckTracker:
	if safe=1
		tst.b	msChktracker.w		; check if tracker debugger flag was set
		beq.s	.rts			; if not, skip
		clr.b	msChktracker.w		; clear that flag
		AMPS_Debug_ChkTracker		; run debugger
	endif
.rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Music PSG channel loop
; ---------------------------------------------------------------------------

dAMPSdoPSG:
		moveq	#Mus_PSG-((FEATURE_PSG4<>0)&1)-1,d0; get total number of music PSG channels to d0
	if FEATURE_PSGADSR
		lea	mADSR-adSize.w,a3	; load PSG ADSR SFX data to a3
	endif

dAMPSnextPSG:
	if FEATURE_PSGADSR
		addq.w	#adSize,a3		; add ADSR size to a3
	endif
		add.w	#cSize,a1		; go to the next channel
		move.b	mMusicFlags.w,mExtraFlags.w; copy music flags to extra flags

		tst.b	(a1)			; check if channel is running a tracker
		bpl.w	.next			; if not, branch
		subq.b	#1,cDuration(a1)	; decrease note duration
		beq.w	.update			; if timed out, update channel

	dGatePSG				; handle PSG-specific gate behavior
	dCalcFreq				; calculate channel base frequency
	dModPorta .endm, -1, -1			; run modulation + portamento code
		bsr.w	dUpdateFreqPSG2		; if frequency needs changing, do it

.endm
		jsr	dEnvelopePSG(pc)	; run envelope program

.next
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextPSG		; make sure to run all the PSG channels

	if FEATURE_PSG4
		jmp	dAMPSdoPSG4(pc)		; after that, process PSG4 channel
	else
		jmp	dAMPSdoSFX(pc)		; after that, process SFX DAC channels
	endif
; ---------------------------------------------------------------------------

.update
		and.b	#$FF-(1<<cfbFreqFrz)-(1<<cfbRest),(a1); clear rest and frequency freeze flags
	dDoTracker				; process tracker
		tst.b	d1			; check if note is being played
		bpl.s	.timer			; if not, it must be a timer. branch

	dGetFreqPSG				; get PSG frequency
		move.b	(a2)+,d1		; check if next byte is a timer
		bpl.s	.timer			; if yes, handle it
		subq.w	#1,a2			; else, undo the increment
		bra.s	.pcnote			; do not calculate duration

.timer
		move.b	d1,cLastDur(a1)		; save as the new duration
; ---------------------------------------------------------------------------

.pcnote
	dProcNote 0, 1				; reset necessary channel memory
	if FEATURE_PSG4
		jsr	dUpdateFreqPSG(pc)	; update hardware frequency
	else
		bsr.s	dUpdateFreqPSG		; update hardware frequency
	endif

		jsr	dEnvelopePSG(pc)	; run envelope program
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextPSG		; make sure to run all the PSG channels

	if FEATURE_PSG4=0
		jmp	dAMPSdoSFX(pc)		; after that, process SFX DAC channels
	else
; ===========================================================================
; ---------------------------------------------------------------------------
; Music PSG channel loop
; ---------------------------------------------------------------------------

dAMPSdoPSG4:
	if FEATURE_PSGADSR
		addq.w	#adSize,a3		; add ADSR size to a3
	endif
		add.w	#cSize,a1		; go to the next channel
		move.b	mMusicFlags.w,mExtraFlags.w; copy music flags to extra flags

		tst.b	(a1)			; check if channel is running a tracker
		bpl.w	dAMPSdoSFX		; if not, branch
		subq.b	#1,cDuration(a1)	; decrease note duration
		beq.s	.update			; if timed out, update channel

	dGatePSG	dAMPSdoSFX		; handle PSG-specific gate behavior
		jsr	dEnvelopePSG(pc)	; run envelope program

.next
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		jmp	dAMPSdoSFX(pc)		; after that, process SFX DAC channels
; ---------------------------------------------------------------------------

.update
		and.b	#$FF-(1<<cfbFreqFrz),(a1); clear frequency freeze flag
	dDoTracker	4			; process tracker
		tst.b	d1			; check if note is being played
		bpl.s	.timer			; if not, it must be a timer. Branch

	if safe=1
		AMPS_Debug_NotePSG4
	endif

		add.b	d1,d1			; double d1
		lea	dNotesPSG4(pc),a4	; load notes table to a4
		jsr	(a4,d1.w)		; execute specific code for note

		move.b	(a2)+,d1		; check if next byte is a timer
		bpl.s	.timer			; if yes, handle it
		subq.w	#1,a2			; else, undo the increment
		bra.s	.pcnote			; do not calculate duration

.timer
		move.b	d1,cLastDur(a1)		; save as the new duration
; ---------------------------------------------------------------------------

.pcnote
	dProcNote 0, 4				; reset necessary channel memory
		jsr	dEnvelopePSG(pc)	; run envelope program

	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		jmp	dAMPSdoSFX(pc)		; after that, process SFX DAC channels
; ===========================================================================
; ---------------------------------------------------------------------------
; note commands for PSG4
; ---------------------------------------------------------------------------

dNotesPSG4:
		bra.w	.rest			; $80 - Rest note
		moveq	#signextendB($E0),d1
		bra.s	.noiset			; $82 - Noise mode $E0
		moveq	#signextendB($E1),d1
		bra.s	.noiset			; $84 - Noise mode $E1
		moveq	#signextendB($E2),d1
		bra.s	.noiset			; $86 - Noise mode $E2
		moveq	#signextendB($E3),d1
		bra.s	.noiset			; $88 - Noise mode $E3
		moveq	#signextendB($E4),d1
		bra.s	.noiset			; $8A - Noise mode $E4
		moveq	#signextendB($E5),d1
		bra.s	.noiset			; $8C - Noise mode $E5
		moveq	#signextendB($E6),d1
		bra.s	.noiset			; $8E - Noise mode $E6
		moveq	#signextendB($E7),d1
;		bra.s	.noiset			; $90 - Noise mode $E7
; ---------------------------------------------------------------------------

.noiset
		bclr	#cfbRest,(a1)		; clear rest flag
		move.b	d1,cStatPSG4(a1)	; save status
		btst	#cfbInt,(a1)		; is channel interrupted by sfx?
		bne.s	.rts			; if so, skip
		move.b	d1,dPSG			; send command to PSG port

.rts
		rts
; ---------------------------------------------------------------------------

.rest
		or.b	#(1<<cfbRest)|(1<<cfbVol),(a1); set channel to resting and request a volume update (update on next note-on)
		move.w	#-1,cFreq(a1)		; set invalid PSG frequency

	if FEATURE_PSGADSR=0
		jmp	dMutePSGmus(pc)		; mute PSG channel
	endif
; ---------------------------------------------------------------------------
	endif

	if FEATURE_PSGADSR
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for keying off PSG
;
; input:
;   a1 - Channel to operate on
;   a3 - Channel ADSR data
;   a4 - Used to reference phase table
; thrash:
;   d3 - Used to calculate the volume command
; ---------------------------------------------------------------------------

dKeyOffPSG:
		bset	#cfbVol,(a1)		; force volume update

dKeyOffPSG2:
		tst.b	cADSR(a1)		; check if ADSR is 0
		bne.s	.normal			; if so, there is an exception
		move.b	#$7F,(a3)		; forcibly mute ADSR
		move.w	#$4000,d1		; set volume to mute

.normal
		moveq	#admMask,d3		; prapre only the mode bits
		and.b	adFlags(a3),d3		; get mode bits from flags

		lea	dPhaseTableADSR(pc),a4	; load phase table to a4
		move.b	2(a4,d3.w),adFlags(a3)	; load new flags from table
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Write PSG frequency to hardware
;
; input:
;   a1 - Channel to operate on
; thrash:
;   d2 - Used for frequency calculations
;   d5-d6 - Used for temporary values
; ---------------------------------------------------------------------------

dUpdateFreqPSG:
		move.w	cFreq(a1),d2		; get channel base frequency to d2
		bpl.s	dUpdateFreqPSG4		; if it was not rest frequency, branch
		bset	#cfbRest,(a1)		; set channel resting flag

	if FEATURE_PSGADSR
		bra.s	dKeyOffPSG	; TODO: why tf is this needed???
	else
		rts
	endif
; ---------------------------------------------------------------------------

dUpdateFreqPSG4:
	if FEATURE_MODENV
		jsr	dModEnvProg(pc)		; process modulation envelope
	endif

		btst	#cfbFreqFrz,(a1)	; check if frequency is frozen
		bne.s	dUpdateFreqPSG2		; if yes, do not add these frequencies in
		move.b	cDetune(a1),d6		; load detune value to d6
		ext.w	d6			; extend to word
		add.w	d6,d2			; add to channel base frequency to d2

	if FEATURE_MODULATION
		tst.b	cModSpeed(a1)		; check if channel is modulating
		beq.s	dUpdateFreqPSG2		; if not, branch
		add.w	cModFreq(a1),d2		; add modulation frequency offset to d2
	endif
; ---------------------------------------------------------------------------

dUpdateFreqPSG2:
		btst	#cfbInt,(a1)		; is channel interrupted by sfx?
		bne.s	locret_UpdateFreqPSG	; if so, skip

dUpdateFreqPSG3:
	if FEATURE_SOUNDTEST
		move.w	d2,cChipFreq(a1)	; save frequency to chip
	endif

		btst	#cfbRest,(a1)		; is this channel resting
		bne.s	locret_UpdateFreqPSG	; if so, skip

		move.b	cType(a1),d6		; load channel type value to d6
		cmpi.b	#ctPSG4,d6		; check if this channel is in PSG4 mode
		bne.s	.notPSG4		; if not, branch
		moveq	#signextendB(ctPSG3),d6		; load PSG3 type value instead

.notPSG4
		move.w	d2,d5			; copy frequency to d5
		andi.b	#$F,d5			; get the low nibble of it
		or.b	d5,d6			; combine with channel type
; ---------------------------------------------------------------------------
; Note about the and instruction below: If this instruction is
; not commented out, the instashield SFX will not sound correct.
; This instruction was removed in Sonic 3K because of this, but
; this can cause issues when values overflow the valid range of
; PSG frequency. This may cause erroneous behavior if not anded,
; but will also make the instashield SFX not sound correctly.
; Comment out the instruction with caution, if you are planning
; to port said sound effect to this driver. This has not caused
; any issues for me, and if you are careful you can avoid any
; such case, but beware of this issue!
; ---------------------------------------------------------------------------

		lsr.w	#4,d2			; get the 2 higher nibbles of frequency
	if FEATURE_SAFE_PSGFREQ
		andi.b	#$3F,d2			; clear any extra bits that aren't valid
	endif
		move.b	d6,dPSG.l		; write frequency low nibble and latch channel
		move.b	d2,dPSG.l		; write frequency high nibbles to PSG

locret_UpdateFreqPSG:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for running envelope programs
;
; input:
;   a1 - Channel to operate on
; thrash:
;   d1 - Used for volume calculations
;   d4 - Used by volume envelope code
;   a2 - Used for envelope data address
; ---------------------------------------------------------------------------

dEnvelopePSG_SFX:
	if FEATURE_SFX_MASTERVOL=0
		if FEATURE_PSGADSR=0
			btst	#cfbRest,(a1)		; check if channel is resting
			bne.s	locret_UpdateFreqPSG	; if is, do not update anything
		endif

		btst	#cfbDisabl,(a1)		; check if channel is disabled
		bne.s	dEnvelopePSG_Dis	; if is, branch

		move.b	cVolume(a1),d1		; load channel volume to d1
		ext.w	d1			; extend to a word
		bra.s	dEnvelopePSG2		; do not add master volume
	endif
; ---------------------------------------------------------------------------

dEnvelopePSG_Dis:
		move.w	#$4000,d1		; set volume to max (muted)
		bra.s	dEnvelopePSG2		; process all effects
; ---------------------------------------------------------------------------

dEnvelopePSG:
	if FEATURE_PSGADSR=0
		btst	#cfbRest,(a1)		; check if channel is resting
		bne.s	locret_UpdateFreqPSG	; if is, do not update anything
	endif

		btst	#cfbDisabl,(a1)		; check if channel is disabled
		bne.s	dEnvelopePSG_Dis	; if is, branch

		move.b	mMasterVolPSG.w,d1	; load PSG master volume to d1
		ext.w	d1			; extend to word

		move.b	cVolume(a1),d4		; load channel volume to d4
		ext.w	d4			; extend to word
		add.w	d4,d1			; add channel volume to d1
; ---------------------------------------------------------------------------

dEnvelopePSG2:
	if FEATURE_PSGADSR
		jsr	dProcessADSR(pc)	; process ADSR
	endif

		moveq	#0,d4
		move.b	cVolEnv(a1),d4		; load volume envelope ID to d4
		beq.s	.ckflag			; if 0, check if volume update was needed

		jsr	dVolEnvProg(pc)		; run the envelope program
	if FEATURE_PSGADSR=0
		bne.s	dUpdateVolPSG		; if it was necessary to update volume, do so
	endif

.ckflag
	if FEATURE_PSGADSR=0
		btst	#cfbVol,(a1)		; test volume update flag
		beq.s	locret_UpdVolPSG	; branch if no volume update was requested
	endif

	; continue to update PSG volume
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for updating PSG volume to hardware
;
; input:
;   a1 - Channel to operate on
;   d1 - Target volume
; thrash:
;   d1 - Used by volume calculations
; ---------------------------------------------------------------------------

dUpdateVolPSG:
		bclr	#cfbVol,(a1)		; clear volume update flag
		btst	#cfbInt,(a1)		; is channel interrupted by sfx?
		bne.s	locret_UpdVolPSG	; if is, do not update

	if FEATURE_PSGADSR=0
		btst	#cfbRest,(a1)		; is this channel resting
		bne.s	locret_UpdVolPSG	; if is, do not update
		btst	#mfbHold,mExtraFlags.w	; check if note is held
		beq.s	.send			; if not, update volume

		cmp.w	#mSFXDAC1,a1		; check if this is a SFX channel
		bhs.s	.send			; if so, update volume
		tst.b	cGateMain(a1)		; check if gate is active
		beq.s	.send			; if not, update volume
		tst.b	cGateCur(a1)		; is note stopped already?
		beq.s	locret_UpdVolPSG	; if is, do not update
	endif
; ---------------------------------------------------------------------------

.send
	if FEATURE_UNDERWATER
		btst	#mfbWater,mExtraFlags.w	; check if underwater mode is enabled
		sne	d2			; if yes, set d2
		and.w	#$10,d2			; get $10 or $00
		add.w	d2,d1			; add it to volume
	endif

.uwdone
		cmp.w	#$7F,d1			; check if volume is out of range
		bls.s	.nocap			; if not, branch
		spl	d1			; if positive (above $7F), set to $FF. Otherwise, set to $00
		lsr.b	#1,d1			; shift value down by 1 bit ($FF -> $7F)

.nocap
	if FEATURE_SOUNDTEST
		move.b	d1,cChipVol(a1)		; save volume to chip
	endif

		lsr.b	#3,d1			; divide volume by 8
		or.b	cType(a1),d1		; combine channel type value with volume
		or.b	#$10,d1			; set volume update bit
		move.b	d1,dPSG.l		; write volume command to PSG port

locret_UpdVolPSG:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for hardware muting a PSG channel
;
; input:
;   a1 - Channel to operate on
; thrash:
;   d3 - Used to calculate the volume command
; ---------------------------------------------------------------------------

dMutePSGmus:
	if FEATURE_PSGADSR
		move.w	#$7F00|adpRelease,(a3)	; forcibly mute ADSR
	endif

		btst	#cfbInt,(a1)		; check if this is a SFX channel
		bne.s	locret_MutePSG		; if yes, do not update

dMutePSGsfx:
	if FEATURE_PSGADSR
		move.w	#$7F00|adpRelease,(a3)	; forcibly mute ADSR
	endif

		moveq	#$1F,d3			; prepare volume update to mute value to d3
		or.b	cType(a1),d3		; combine channel type value with d3
		move.b	d3,dPSG.l		; write volume command to PSG port

locret_MutePSG:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Note to PSG frequency conversion table
; ---------------------------------------------------------------------------

	if FEATURE_SOUNDTEST
		dc.w  $0800	; <- added for sound test
	endif

;	dc.w	C     C#    D     Eb    E     F     F#    G     G#    A     Bb    B
dFreqPSG:dc.w $03FF,$03FF,$03FF,$03FF,$03FF,$03FF,$03FF,$03FF,$03FF,$03F7,$03BE,$0388; Octave 2 - (81 - 8C)
	dc.w  $0356,$0326,$02F9,$02CE,$02A5,$0280,$025C,$023A,$021A,$01FB,$01DF,$01C4; Octave 3 - (8D - 98)
	dc.w  $01AB,$0193,$017D,$0167,$0153,$0140,$012E,$011D,$010D,$00FE,$00EF,$00E2; Octave 4 - (99 - A4)
	dc.w  $00D6,$00C9,$00BE,$00B4,$00A9,$00A0,$0097,$008F,$0087,$007F,$0078,$0071; Octave 5 - (A5 - B0)
	dc.w  $006B,$0065,$005F,$005A,$0055,$0050,$004B,$0047,$0043,$0040,$003C,$0039; Octave 6 - (B1 - BC)
	dc.w  $0036,$0033,$0030,$002D,$002B,$0028,$0026,$0024,$0022,$0020,$001F,$001D; Octave 7 - (BD - C8)
	dc.w  $001B,$001A,$0018,$0017,$0016,$0015,$0013,$0012,$0011		     ; Octave 8 - (B9 - D1)
	dc.w  $0000								     ; Note (D2)
dFreqPSG_:

	if FEATURE_SOUNDTEST
		dc.w  $F000	; <- added for sound test
	endif

	if safe=1				; in safe mode, we have extra debug data
.x :=		$100|((dFreqPSG_-dFreqPSG)/2)	; to check if we played an invalid note
		rept $80-((dFreqPSG_-dFreqPSG)/2); and if so, tell us which note it was
			dc.w .x
.x :=			.x+$101
		endm
	endif
; ---------------------------------------------------------------------------

; ===========================================================================
; ---------------------------------------------------------------------------
; Hardware mute all FM channels
;
; thrash:
;   all - Because I am too lazy to enumerate them
; ---------------------------------------------------------------------------

dMuteFM:
		moveq	#$28,d6			; YM address: Key on/off
		moveq	#%00000010,d3		; turn keys off, and start from YM channel 3
	stopZ80
	CheckCue				; check that cue is valid

.noteoff
		move.b	d3,d1			; copy value into d1
	WriteYM1	d6, d1			; write part 1 to YM
		addq.b	#4,d1			; set this to part 2 channel
	WriteYM1	d6, d1			; write part 2 to YM
		dbf	d3,.noteoff		; loop for all 3 channel groups
; ---------------------------------------------------------------------------
; The following code will set release rate to maximum. This is to
; make sure all channels stop decaying the note and go to maximum
; attentuation immediately. It should prevent the previous song from
; making any noise after its played. The following code will also set
; all Total Level operators to maximum (mute)
; ---------------------------------------------------------------------------

.muteFM
		moveq	#$10-1,d5		; prepare the value for going to next channel to d5
		moveq	#$40,d6			; YM command: Total Level Operator 1
		moveq	#$7F,d1			; set total level to $7F (silent)
		moveq	#signextendB($80),d2			; YM address: Release Rate Operator 1
		moveq	#3-1,d4			; prepare 3 groups of channels to d4

.chloop
		moveq	#4-1,d3			; prepare 4 operator writes per channel to d3

.oploop
	WriteYM1	d6, d1			; write part 1 to YM
	WriteYM2	d6, d1			; write part 2 to YM
		addq.w	#4,d6			; go to next Total Level operator (1 2 3 4)

	WriteYM1	d2, #$F			; write part 1 to YM
	WriteYM2	d2, #$F			; write part 2 to YM
		addq.w	#4,d2			; go to next Release Rate operator (1 2 3 4)
		dbf	d3,.oploop		; repeat for each operator
; ---------------------------------------------------------------------------

		sub.b	d5,d6			; go to next FM channel
		sub.b	d5,d2			; go to next FM channel
		dbf	d4,.chloop		; repeat for each channel
	;	st	(a0)			; write end marker
	startZ80

locret_MuteFM:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for updating Total Levels for FM channel
;
; input:
;   a1 - Channel to operate on
;   a3 - Address to TL modulation data
; thrash:
;   a2 - Used maybe for TL modulation
;   a4 - Used for envelope data address
;   a5 - Used to store stack location
;   d1 - Used for volume calculations
;   d2 - Used to store the right TL modulation address
;   d3 - Used as a loop counter for TL's
;   d4 - Used (maybe) for envelope calculations, other various uses
;   d5 - Used for TL calculations
;   d6 - Used for modulator offset
; ---------------------------------------------------------------------------

dUpdateVolFM_SFX:
	if FEATURE_SFX_MASTERVOL=0
		if FEATURE_DACFMVOLENV
			btst	#cfbRest,(a1)	; check if channel is resting
			bne.s	locret_MuteFM	; if is, do not update anything
		endif

		btst	#cfbDisabl,(a1)		; check if channel is disabled
		bne.s	dUpdateVolFM_Dis	; if is, branch

		move.b	cVolume(a1),d1		; load FM channel volume to d1
		ext.w	d1			; extend it to word
		bra.s	dUpdateVolFM3		; do NOT add the master volume!
	endif
; ---------------------------------------------------------------------------

dUpdateVolFM_Dis:
		move.w	#$4000,d1		; set volume to max (muted)
		bra.s	dUpdateVolFM3		; process all effects
; ---------------------------------------------------------------------------

dUpdateVolFM:
	if FEATURE_DACFMVOLENV
		btst	#cfbRest,(a1)		; check if channel is resting
		bne.s	locret_MuteFM		; if is, do not update anything
	endif

		btst	#cfbDisabl,(a1)		; check if channel is disabled
		bne.s	dUpdateVolFM_Dis	; if is, branch

		move.b	mMasterVolFM.w,d1	; load FM master volume to d1
		ext.w	d1			; extend to word

		move.b	cVolume(a1),d4		; load channel volume to d4
		ext.w	d4			; extend to word
		add.w	d4,d1			; add channel volume to d1

dUpdateVolFM3:
	if FEATURE_DACFMVOLENV
		moveq	#0,d4
		move.b	cVolEnv(a1),d4		; load volume envelope ID to d4
		beq.s	.ckflag			; if 0, check if volume update was needed

		jsr	dVolEnvProg(pc)		; run the envelope program
		bne.s	dUpdateVolFM2		; if it was necessary to update volume, do so

.ckflag
		btst	#cfbVol,(a1)		; test volume update flag
		beq.s	locret_MuteFM		; branch if no volume update was requested
	endif
; ---------------------------------------------------------------------------

dUpdateVolFM2:
	if FEATURE_DACFMVOLENV
		bclr	#cfbVol,(a1)		; clear volume update flag
	endif
		btst	#cfbInt,(a1)		; is the channel interrupted by SFX?
		bne.s	locret_MuteFM		; if yes, do not update

		moveq	#0,d4
		move.b	cVoice(a1),d4		; load FM voice ID of the channel to d4
	dCALC_BANK	0			; get the voice bank address to a4
	dCALC_VOICE				; get address of the specific voice to a4

	if FEATURE_UNDERWATER
		clr.w	d6			; clear d6 (so no underwater by default)

		btst	#mfbWater,mExtraFlags.w	; check if underwater mode is enabled
		beq.s	.uwdone			; if not, skip
		move.b	(a4),d4			; load algorithm and feedback to d4
		and.w	#7,d4			; mask out everything but the algorithm

		lea	dUnderwaterTbl(pc),a5	; get underwater table to a5
		move.b	(a5,d4.w),d4		; get the value from table
		move.b	d4,d6			; copy to d6
		and.w	#7,d4			; mask out extra stuff
		add.w	d4,d1			; add algorithm to Total Level carrier offset

.uwdone
	endif

		add.w	#VoiceTL,a4		; go to the Total Level offset of the voice
	if FEATURE_MODTL
		move.w	a3,d2			; save the TL data to d2
	endif

	if FEATURE_SOUNDTEST
		move.w	d1,d5			; copy to d5
		cmp.w	#$7F,d5			; check if volume is out of range
		bls.s	.nocapx			; if not, branch
		spl	d5			; if positive (above $7F), set to $FF. Otherwise, set to $00
		and.b	#$7F,d5			; keep in range for the sound test

.nocapx
		move.b	d5,cChipVol(a1)		; save volume to chip
	endif

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		bne.w	.dosm			; if yes, do special code
	endif

		moveq	#4-1,d3			; prepare 4 operators to d3
		move.l	sp,a5			; copy stack pointer to a5
		subq.l	#4,sp			; reserve some space in the stack
; ---------------------------------------------------------------------------

.tlloop
		move.b	(a4)+,d5		; get Total Level value from voice to d5
		ext.w	d5			; extend to word
		bpl.s	.noslot			; if slot operator bit was not set, branch

		and.w	#$7F,d5			; get rid of sign bit (ugh)
		add.w	d1,d5			; add carrier offset to loaded value
	if FEATURE_UNDERWATER
		bra.s	.slot
	endif

.noslot
	if FEATURE_UNDERWATER
		add.w	d6,d5			; add modulator offset to loaded value
	endif

.slot
	if FEATURE_MODTL
		move.b	toVol(a3),d4		; load volume offset to d4
		ext.w	d4			; extend to word
		add.w	d4,d5			; add to volume in d5

		jsr	dModulateTL(pc)		; do TL modulation on this channel
		add.w	#toSize,a3		; go to next operator
	endif

		cmp.w	#$7F,d5			; check if volume is out of range
		bls.s	.nocap			; if not, branch
		spl	d5			; if positive (above $7F), set to $FF. Otherwise, set to $00

.nocap
		move.b	d5,-(a5)		; write total level to stack
		dbf	d3,.tlloop		; repeat for each Total Level operator
; ---------------------------------------------------------------------------

	CheckCue				; check that YM cue is valid
	InitChYM				; prepare to write to channel
	stopZ80

	WriteChYM	#$4C, (a5)+		; Total Level: Load operator 4 from stack
	WriteChYM	#$44, (a5)+		; Total Level: Load operator 2 from stack
	WriteChYM	#$48, (a5)+		; Total Level: Load operator 3 from stack
	WriteChYM	#$40, (a5)+		; Total Level: Load operator 1 from stack

	;	st	(a0)			; write end marker
	startZ80
		move.l	a5,sp			; restore stack pointer
	if FEATURE_MODTL
		move.w	d2,a3			; load TL data back from d2
	endif

	if safe=1
		AMPS_Debug_UpdVolFM		; check if the voice was valid
	endif
		rts
; ---------------------------------------------------------------------------

	if FEATURE_FM3SM
.dosm
		move.b	cType(a1),d3		; get type bits to d3
		and.w	#3,d3			; only get the op id
		add.w	d3,a4			; get the appropriate TL byte

		move.b	(a4)+,d5		; get Total Level value from voice to d5
		ext.w	d5			; extend to word
		bpl.s	.smnoslot		; if slot operator bit was not set, branch

		and.w	#$7F,d5			; get rid of sign bit (ugh)
		add.w	d1,d5			; add carrier offset to loaded value
	if FEATURE_UNDERWATER
		bra.s	.smslot
	endif

.smnoslot
	if FEATURE_UNDERWATER
		add.w	d6,d5			; add modulator offset to loaded value
	endif

.smslot
	if FEATURE_MODTL
		move.w	d3,d4			; copy value to d4
		add.w	d4,d4			; double offset
		move.w	dModTLFM3(pc,d4.w),a3	; load the RAM address to use

		move.b	toVol(a3),d4		; load volume offset to d4
		ext.w	d4			; extend to word
		add.w	d4,d5			; add to volume in d5
		jsr	dModulateTL(pc)		; do TL modulation on this channel
	endif

		cmp.w	#$80,d5			; check if volume is out of range
		bls.s	.nocap2			; if not, branch
		spl	d5			; if positive (above $7F), set to $FF. Otherwise, set to $00

.nocap2
	CheckCue				; check that YM cue is valid
	stopZ80
	WriteYM1	dOpTLFM3(pc,d3.w), d5	; Total Level: Load correct operator
	;	st	(a0)			; write end marker
	startZ80

	if FEATURE_MODTL
		move.w	d2,a3			; load TL data back from d2
	endif

	if safe=1
		eor.w	#3,d3			; invert slot num
		add.w	d3,a4			; go to end of voice
		AMPS_Debug_UpdVolFM		; check if the voice was valid
	endif
	endif

locret_VolFM:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; RAM addresses for FM3 TL modulation
; ---------------------------------------------------------------------------
	if FEATURE_MODTL
dModTLFM3:	dc.w mTL+tFM3, mTL+tFM3+toSize
		dc.w mTL+tFM3+(toSize*2), mTL+tFM3+(toSize*3)
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; YM2612 register update list
; ---------------------------------------------------------------------------

dOpTLFM3:	dc.b $42, $4A, $46, $4E		; Total Level for FM3 operators
dOpTLFM:	dc.b $40, $48, $44, $4C		; Total Level
dAMSEn_Ops:	dc.b $60, $68, $64, $6C		; Decay 1 Rate
; ===========================================================================
; ---------------------------------------------------------------------------
; values for underwater mode update
; ---------------------------------------------------------------------------

	if FEATURE_UNDERWATER
dUnderwaterTbl:	dc.b $08, $08, $08, $08, $0A, $0E, $0E, $0F
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Process SFX FM channels
; ---------------------------------------------------------------------------

dAMPSdoFMSFX:
	if FEATURE_MODTL
		lea	mTLSFX-toSize4.w,a3	; load SFX FM3 TL modulation data to a3
	endif
		moveq	#SFX_FM-1,d0		; get total number of SFX FM channels to d0

dAMPSnextFMSFX:
	if FEATURE_MODTL
		add.w	#toSize4,a3		; go to the TL data
	endif
		add.w	#cSizeSFX,a1		; go to the next channel
		move.b	cExtraFlags(a1),mExtraFlags.w; copy flags to extra flags

		tst.b	(a1)			; check if channel is running a tracker
		bpl.w	.next			; if not, branch
		subq.b	#1,cDuration(a1)	; decrease note duration
		beq.w	.update			; if timed out, update channel

	dCalcFreq				; calculate channel base frequency
	dModPorta dAMPSdoPSGSFX, dAMPSnextFMSFX, 1; run modulation + portamento code
		bsr.w	dUpdateFreqFM3		; send FM frequency to hardware

	if FEATURE_DACFMVOLENV=0
		bclr	#cfbVol,(a1)		; check if volume update is needed and clear bit
		beq.s	.next			; if not, skip
	endif
		jsr	dUpdateVolFM_SFX(pc)	; update FM volume

.next
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextFMSFX	; make sure to run all the FM channels
		jmp	dAMPSdoPSGSFX(pc)	; after that, process SFX PSG channels
; ---------------------------------------------------------------------------

.update
		and.b	#$FF-(1<<cfbFreqFrz)-(1<<cfbRest),(a1); clear rest and frequency freeze flags
	dDoTracker				; process tracker
		jsr	dKeyOffFM2(pc)		; send key-off command to YM

		tst.b	d1			; check if note is being played
		bpl.s	.timer			; if not, it must be a timer. branch
		bsr.w	dGetFreqFM		; get frequency

		move.b	(a2)+,d1		; check next byte
		bpl.s	.timer			; if positive, process a timer too
		subq.w	#1,a2			; if not, then return back
		bra.s	.pcnote			; do some extra clearing

.timer
		move.b	d1,cLastDur(a1)		; save as the new duration
; ---------------------------------------------------------------------------

.pcnote
	dProcNote 1, 0				; reset necessary channel memory
		bsr.w	dUpdateFreqFM		; send FM frequency to hardware
	dKeyOnFM 1				; send key-on command to YM

	if FEATURE_DACFMVOLENV=0
		bclr	#cfbVol,(a1)		; check if volume update is needed and clear bit
		beq.s	.noupdate		; if not, branch
	endif
		jsr	dUpdateVolFM_SFX(pc)	; update FM volume

.noupdate
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextFMSFX	; make sure to run all the FM channels
		jmp	dAMPSdoPSGSFX(pc)	; after that, process SFX PSG channels
; ===========================================================================
; ---------------------------------------------------------------------------
; Process music FM channels
; ---------------------------------------------------------------------------

dAMPSdoFM:
		move.b	mFM3keyMask.w,mFM3OffMask.w; reset FM3 key off mask
		moveq	#Mus_FM-1,d0		; get total number of music FM channels to d0
	if FEATURE_MODTL
		lea	mTL-toSize4.w,a3	; load FM1 TL modulation data to a3
	endif

dAMPSnextFM:
		add.w	#cSize,a1		; go to the next channel
		move.b	mMusicFlags.w,mExtraFlags.w; copy music flags to extra flags

	if FEATURE_MODTL
		if FEATURE_FM3SM		; TODO: Terrible code ahead! =(
			cmp.w	#mFM3op1,a1	; check if this is FM3 op1 or lesser
			ble.s	.doadd		; if not, add
			cmp.w	#mFM4,a1	; check if this is FM4 or greater
			blt.s	.proc		; if not, skip

		; FM4 specific
			btst	#ctbFM3sm,mFM3+cType.w	; is FM3 in special mode?
			beq.s	.proc			; if not, proceed normally
			move.b	mFM3keyMask.w,mFM3OffMask.w; reset FM3 key off mask
			jsr	dKeyUpdateFM3(pc)	; go enable FM3SM key

.doadd
		endif

		add.w	#toSize4,a3		; go to the TL data

	elseif FEATURE_FM3SM
		cmp.w	#mFM4,a1		; check if this is FM4 channel now
		bne.s	.proc			; if not, do not do FM3 special mode key behavior

		btst	#ctbFM3sm,mFM3+cType.w	; is FM3 in special mode?
		beq.s	.proc			; if not, proceed normally
		move.b	mFM3keyMask.w,mFM3OffMask.w; reset FM3 key off mask
		jsr	dKeyUpdateFM3(pc)	; go enable FM3SM key
	endif
; ---------------------------------------------------------------------------

.proc
		tst.b	(a1)			; check if channel is running a tracker
		bpl.w	.next			; if not, branch
		subq.b	#1,cDuration(a1)	; decrease note duration
		beq.w	.update			; if timed out, update channel

	dGateFM					; handle FM-specific gate behavior
	dCalcFreq				; calculate channel base frequency
	dModPorta dAMPSdoPSG, dAMPSnextFM, 0	; run modulation + portamento code
		bsr.w	dUpdateFreqFM2		; send FM frequency to hardware

	if FEATURE_DACFMVOLENV=0
		bclr	#cfbVol,(a1)		; check if volume update is needed and clear bit
		beq.s	.next			; if not, skip
	endif
		jsr	dUpdateVolFM(pc)	; update FM volume

.next
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextFM		; make sure to run all the FM channels
		jmp	dAMPSdoPSG(pc)		; after that, process music PSG channels
; ---------------------------------------------------------------------------

.update
		and.b	#$FF-(1<<cfbFreqFrz)-(1<<cfbRest),(a1); clear rest and frequency freeze flags
	dDoTracker				; process tracker
		jsr	dKeyOffFM(pc)		; send key-off command to YM

		tst.b	d1			; check if note is being played
		bpl.s	.timer			; if not, it must be a timer. Branch
		bsr.w	dGetFreqFM		; get frequency

		move.b	(a2)+,d1		; check next byte
		bpl.s	.timer			; if positive, process a timer too
		subq.w	#1,a2			; if not, then return back
		bra.s	.pcnote			; do some extra clearing

.timer
		move.b	d1,cLastDur(a1)		; save as the new duration
; ---------------------------------------------------------------------------

.pcnote
	dProcNote 0, 0				; reset necessary channel memory
		bsr.s	dUpdateFreqFM		; send FM frequency to hardware
	dKeyOnFM				; send key-on command to YM

	if FEATURE_DACFMVOLENV=0
		bclr	#cfbVol,(a1)		; check if volume update is needed and clear bit
		beq.s	.noupdate		; if not, branch
	endif
		jsr	dUpdateVolFM(pc)	; update FM volume

.noupdate
	if FEATURE_SOUNDTEST
		move.b	mExtraFlags.w,cTrackFlags(a1); store flags to channel
	endif
		dbf	d0,dAMPSnextFM		; make sure to run all the FM channels
		jmp	dAMPSdoPSG(pc)		; after that, process music PSG channels
; ===========================================================================
; ---------------------------------------------------------------------------
; Write FM frequency to Dual PCM YMCue
;
; input:
;   a1 - Channel address
; thrash:
;   a2 - Sample data address
;   d2 - Sample pitch
;   d3-d6 - Temporary values
; ---------------------------------------------------------------------------

dUpdateFreqFM:
		move.w	cFreq(a1),d2		; load channel base frequency to d2
		bne.s	.norest			; if 0, this channel should be resting
		bset	#cfbRest,(a1)		; set channel resting flag
		rts
; ---------------------------------------------------------------------------

.norest
	if FEATURE_MODENV
		jsr	dModEnvProg(pc)		; process modulation envelope
	endif

		btst	#cfbFreqFrz,(a1)	; check if frequency is frozen
		bne.s	dUpdateFreqFM2		; if yes, do not add these frequencies in
		move.b	cDetune(a1),d3		; load detune value to d3
		ext.w	d3			; extend to word
		add.w	d3,d2			; add to channel base frequency to d2

	if FEATURE_MODULATION
		tst.b	cModSpeed(a1)		; check if channel is modulating
		beq.s	dUpdateFreqFM2		; if not, branch
		add.w	cModFreq(a1),d2		; add channel modulation frequency offset to d2
	endif
; ---------------------------------------------------------------------------

dUpdateFreqFM2:
		btst	#cfbInt,(a1)		; is the channel interrupted by SFX?
		bne.w	locret_UpdFreqFM	; if is, do not update frequency

dUpdateFreqFM3:
	if FEATURE_SOUNDTEST
		move.w	d2,cChipFreq(a1)	; save frequency to chip
	endif

		btst	#cfbRest,(a1)		; is this channel resting
	if FEATURE_FM3SM
		bne.s	.rts			; if is, skip
	else
		bne.s	locret_UpdFreqFM	; if is, skip
	endif

		move.w	d2,d3			; copy frequency to d3
		lsr.w	#8,d3			; shift upper byte into lower byte
	CheckCue				; check that YM cue is valid

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.s	.nosm			; if not, proceed normally
		moveq	#3,d4			; prepare operator mask
		and.b	cType(a1),d4		; load channel type to d4

	stopZ80
	WriteYM1	.smfreqm(pc,d4.w), d3	; Frequency MSB & Octave
	WriteYM1	.smfreql(pc,d4.w), d2	; Frequency LSB
	;	st	(a0)			; write end marker
	startZ80

.rts
		rts

.smfreql	dc.b $A9, $AA, $A8, $A2		; registers for FM3 frequency MSB
.smfreqm	dc.b $AD, $AE, $AC, $A6		; registers for FM3 frequency LSB
	endif
; ---------------------------------------------------------------------------

.nosm
	InitChYM				; prepare to write to channel
	stopZ80
	WriteChYM	#$A4, d3		; Frequency MSB & Octave
	WriteChYM	#$A0, d2		; Frequency LSB
	;	st	(a0)			; write end marker
	startZ80

locret_UpdFreqFM:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Process a note in FM channel (enable resting or get frequency)
;
; input:
;   a1 - Channel address
;   d1 - Note read from tracker
; thrash:
;   a4 - FM frequency table
; ---------------------------------------------------------------------------

dGetFreqFM:
		subi.b	#$80,d1			; sub $80 from the note (notes start at $80)
		bne.s	.norest			; branch if note wasnt $80 (rest)
		bset	#cfbRest,(a1)		; set channel resting flag
		clr.w	cFreq(a1)		; set base frequency to 0
		rts
; ---------------------------------------------------------------------------

.norest
		add.b	cPitch(a1),d1		; add pitch offset to note
		andi.w	#$7F,d1			; keep within $80 notes
		add.w	d1,d1			; double offset (each entry is a word)

		lea	dFreqFM(pc),a4		; load FM frequency table to a1
		move.w	(a4,d1.w),cFreq(a1)	; load and save the requested frequency

	if safe=1
		AMPS_Debug_NoteFM		; check if the note was valid
	endif

locret_GetFreqFM:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for doing keying-off FM channel
;
; input:
;   a1 - Channel address
; thrash:
;   d3-d4 - Used to store values
; ---------------------------------------------------------------------------

dOffTableSM:	dc.b $E2, $D2, $B2, $72

dKeyOffFM:
		btst	#cfbInt,(a1)		; check if overridden by sfx
		bne.s	locret_GetFreqFM	; if so, do not note off

dKeyOffFM2:
		btst	#mfbHold,mExtraFlags.w	; check if note is held
		bne.s	locret_GetFreqFM	; if so, do not note off

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.w	dKeyOffFM3		; if not, do normal code

		moveq	#3,d3			; prepare AND mask to d3
		and.b	cType(a1),d3		; AND with channel type
		move.b	dOffTableSM(pc,d3.w),d3	; load the mask value to d3
		and.b	d3,mFM3OffMask.w	; mask key of this channel

dKeyUpdateFM3:
	dKeySetFM3				; run code for enabling FM3 special mode operators
		rts

dKeyOffFM3:
	endif
; ---------------------------------------------------------------------------

		move.b	cType(a1),d3		; load channel type value to d3
		moveq	#$28,d4			; load key on/off to d4

	stopZ80
	CheckCue				; check that cue is valid
	WriteYM1	d4, d3			; key on: turn all operators off for channel
	WriteYM1	d4, d3			; the reason we do this, is to work around some YM2612 bug or quirk
	WriteYM1	d4, d3			; if you key off and key on too quickly, the sound is somewhat wrong
	WriteYM1	d4, d3			; this was noticeable on few SFX, particularly the death SFX
	;	st	(a0)			; I am not sure why it works, but I am gonna be honest, I don't care enough to find out
	startZ80

.rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Note to FM frequency conversion table
; ---------------------------------------------------------------------------
;	dc.w   C     C#    D     Eb    E     F     F#    G     G#    A     Bb    B
dFreqFM:dc.w								       $025E; Octave-1 - (80)
	dc.w $0284,$02AB,$02D3,$02FE,$032D,$035C,$038F,$03C5,$03FF,$043C,$047C,$0A5E; Octave 0 - (81 - 8C)
	dc.w $0A84,$0AAB,$0AD3,$0AFE,$0B2D,$0B5C,$0B8F,$0BC5,$0BFF,$0C3C,$0C7C,$125E; Octave 1 - (8D - 98)
	dc.w $1284,$12AB,$12D3,$12FE,$132D,$135C,$138F,$13C5,$13FF,$143C,$147C,$1A5E; Octave 2 - (99 - A4)
	dc.w $1A84,$1AAB,$1AD3,$1AFE,$1B2D,$1B5C,$1B8F,$1BC5,$1BFF,$1C3C,$1C7C,$225E; Octave 3 - (A5 - B0)
	dc.w $2284,$22AB,$22D3,$22FE,$232D,$235C,$238F,$23C5,$23FF,$243C,$247C,$2A5E; Octave 4 - (B1 - BC)
	dc.w $2A84,$2AAB,$2AD3,$2AFE,$2B2D,$2B5C,$2B8F,$2BC5,$2BFF,$2C3C,$2C7C,$325E; Octave 5 - (BD - C8)
	dc.w $3284,$32AB,$32D3,$32FE,$332D,$335C,$338F,$33C5,$33FF,$343C,$347C,$3A5E; Octave 6 - (c9 - D4)
	dc.w $3A84,$3AAB,$3AD3,$3AFE,$3B2D,$3B5C,$3B8F,$3BC5,$3BFF,$3C3C,$3C7C	    ; Octave 7 - (D5 - DF)
dFreqFM_:

	if safe=1				; in safe mode, we have extra debug data
.x :=		$100|((dFreqFM_-dFreqFM)/2)	; to check if we played an invalid note
		rept $80-((dFreqFM_-dFreqFM)/2)	; and if so, tell us which note it was
			dc.w .x
.x :=			.x+$101
		endm
	endif
; ---------------------------------------------------------------------------

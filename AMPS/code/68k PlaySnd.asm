; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for pausing the sound driver
;
; thrash:
;   d4 - Various values
;   d5 - YM command values
;   d6 - dbf counters and key off channel
;   a4 - Used by other routines
;   a5 - Used by other routines
; ---------------------------------------------------------------------------

dPlaySnd_Pause:
		bset	#mfbPaused,mFlags.w	; pause music
		bne.w	locret_MuteDAC		; if was already paused, skip
; ---------------------------------------------------------------------------
; The following code will set channel panning to none for all FM channels.
; This will ensure they are muted while we are pausing.
; ---------------------------------------------------------------------------

		moveq	#3-1,d6			; 3 channels per YM2616 "part"
		moveq	#signextendB($B4),d5			; YM address: Panning and LFO
		moveq	#2,d4			; prepare part 2 value
	CheckCue				; check that cue is correct
	stopZ80

.muteFM
		clr.b	(a0)+			; write to part 1
		clr.b	(a0)+			; pan to neither speaker and remove LFO
		move.b	d5,(a0)+		; YM address: Panning and LFO

		move.b	d4,(a0)+		; write to part 2
		clr.b	(a0)+			; pan to neither speaker and remove LFO
		move.b	d5,(a0)+		; YM address: Panning and LFO

		addq.b	#1,d5			; go to next FM channel
		dbf	d6,.muteFM		; write each 3 channels per part
; ---------------------------------------------------------------------------
; The following code will key off all FM channels. There is a special
; behavior in that, we must write all channels into part 1, and we
; control the channel we are writing in the data portion.
; 4 bits are reserved for which operators are active (in this case,
; none), and 3 bits are reserved for the channel we want to affect
; ---------------------------------------------------------------------------

		moveq	#$28,d5			; YM address: Key on/off
		moveq	#%00000010,d6		; turn keys off, and start from YM channel 3

.note
		move.b	d6,d4			; copy value into d4
	WriteYM1	d5, d4			; write part 1 to YM
		addq.b	#4,d4			; set this to part 2 channel

	WriteYM1	d5, d4			; write part 2 to YM
		dbf	d6,.note		; loop for all 3 channel groups
	;	st	(a0)			; write end marker
	startZ80

		jsr	dMutePSG(pc)		; mute all PSG channels
	; continue to mute all DAC channels
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for muting all DAC channels
;
; thrash:
;   a4 - Destination Z80 address
;   a5 - Source data address
; ---------------------------------------------------------------------------

dMuteDAC:
	StopZ80					; wait for Z80 to stop
		lea	SampleList(pc),a5	; load address for the stop sample data into a2
		lea	dZ80+PCM1_Sample.l,a4	; load addresses for PCM 1 sample to a1

	rept 12
		move.b	(a5)+,(a4)+		; send sample data to Dual PCM
	endm

		lea	SampleList(pc),a5	; load address for the stop sample data into a2
		lea	dZ80+PCM2_Sample.l,a4	; load addresses for PCM 2 sample to a1

	rept 12
		move.b	(a5)+,(a4)+		; send sample data to Dual PCM
	endm

		move.b	#$CA,dZ80+PCM1_NewRET.l	; activate sample switch (change instruction)
		move.b	#$CA,dZ80+PCM2_NewRET.l	; activate sample switch (change instruction)
	StartZ80				; enable Z80 execution

locret_MuteDAC:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for unpausing the sound driver
;
; thrash:
;   d0 - channel count
;   d3 - channel size
;   d4 - YM register calculation
;   d5 - channel type
;   d6 - channel part
;   a1 - channel used for operations
; ---------------------------------------------------------------------------

dPlaySnd_Unpause:
		bclr	#mfbPaused,mFlags.w	; unpause music
		beq.s	locret_MuteDAC		; if was already unpaused, skip
; ---------------------------------------------------------------------------
; The following code will reset the panning values for each running
; channel. It also makes sure that the channel is not interrupted
; by sound effects, and that each running sound effect channel gets
; updated. We do not handle key on's, since that could potentially
; cause issues if notes are half-done. The next time tracker plays
; notes, they start being audible again
; ---------------------------------------------------------------------------

		lea	mFM1.w,a1		; start from FM1 channel
		moveq	#Mus_FM-1,d0		; load the number of music FM channels to d0
		moveq	#cSize,d3		; get the size of each music channel to d3

	CheckCue				; check that we have a valid YM cue
	stopZ80

.musloop
		tst.b	(a1)			; check if the channel is running a tracker
		bpl.s	.skipmus		; if not, do not update
		btst	#cfbInt,(a1)		; is the channel interrupted by SFX?
		bne.s	.skipmus		; if is, skip updating

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.s	.nosm			; if not, do normal code
	WriteYM1	#$B6, mFM3op1+cPanning.w; Panning and LFO: FM3, read from channel
		bra.s	.skipmus

.nosm
	endif
; ---------------------------------------------------------------------------

	InitChYM				; prepare to write to YM
	WriteChYM	#$B4, cPanning(a1)	; Panning and LFO: read from channel

.skipmus
		adda.w	d3,a1			; go to next channel
		dbf	d0,.musloop		; repeat for all music FM channels
; ---------------------------------------------------------------------------

		lea	mSFXFM2.w,a1		; start from SFX FM1 channel
		moveq	#SFX_FM-1,d0		; load the number of SFX FM channels to d4
		moveq	#cSizeSFX,d3		; get the size of each SFX channel to d3

.sfxloop
		tst.b	(a1)			; check if the channel is running a tracker
		bpl.s	.skipsfx		; if not, do not update
	InitChYM				; prepare to write to YM
	WriteChYM	#$B4, cPanning(a1)	; Panning and LFO: read from channel

.skipsfx
		adda.w  d3,a1			; go to next channel
		dbf     d0,.sfxloop		; repeat for all SFX FM channels
; ---------------------------------------------------------------------------
; Since the DAC channels have OR based panning behavior, we need this
; piece of code to update its panning correctly
; ---------------------------------------------------------------------------

		move.b	mDAC1+cPanning.w,d4	; read panning value from music DAC1
		btst	#cfbInt,mDAC1+cFlags.w	; check if music DAC1 is interrupted by SFX
		beq.s	.nodacsfx		; if not, use music DAC1 panning
		move.b	mSFXDAC1+cPanning.w,d4	; read panning value from SFX DAC1

.nodacsfx
		or.b	mDAC2+cPanning.w,d4	; or the panning value from music DAC2
	WriteYM2	#$B6, d4		; Panning & LFO
	;	st	(a0)			; write end marker
	startZ80

locret_Unpause:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to play any queued music tracks, sound effects or commands
;
; thrash:
;   d1 - sound ID
;   a4 - queue address
;   all - other routines thrash pretty much every register except a0
; ---------------------------------------------------------------------------

dPlaySnd:
		lea	mQueue.w,a4		; get address to the sound queue
		moveq	#0,d1
		move.b	(a4)+,d1		; get sound ID for this slot
		bne.s	.found			; if nonzero, a sound is queued
		move.b	(a4)+,d1		; get sound ID for this slot
		bne.s	.found			; if nonzero, a sound is queued
		move.b	(a4)+,d1		; get sound ID for this slot
		beq.s	locret_Unpause		; if 0, no sounds were queued, return

.found
	if safe=1
		AMPS_Debug_SoundID		; check if the sound ID is valid
	endif
		clr.b	-1(a4)			; clear the slot we are processing

		cmpi.b	#SFXoff,d1		; check if this sound was a sound effect
		bhs.w	dPlaySnd_SFX		; if so, handle it
		cmpi.b	#MusOff,d1		; check if this sound was a command
		blo.w	dPlaySnd_Comm		; if so, handle it
	; it was a music, handle it below
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to play a queued music track
;
; thrash:
;   d0 - Loop counter for each channel
;   d6 - Size of each channel
;   a1 - Current sound channel address that is being processed
;   a2 - Current address into the tracker data
;   a3 - Used for channel address calculation
;   a4 - Type values arrays
;   d6 - Temporarily used to hold the speed shoes tempo
;   all - other dregisters are gonna be used too
; ---------------------------------------------------------------------------

dPlaySnd_Music:
; ---------------------------------------------------------------------------
; To save few cycles, we don't directly substract the music offset from
; the ID, and instead offset the table position. In practice this will
; have the same effect, but saves us 8 cycles overall
; ---------------------------------------------------------------------------

.index =	MusicIndex-(MusOff*4)		; effin ASS
		lea	.index(pc),a2		; get music pointer table with an offset
		add.w	d1,d1			; quadruple music ID
		add.w	d1,d1			; since each entry is 4 bytes in size

		move.b	(a2,d1.w),d6		; load speed shoes tempo from the unused 8 bits into d6
		ext.w	d6			; extend to word
		move.w	d6,-(sp)		; store in stack :(
		movea.l	(a2,d1.w),a2		; get music header pointer from the table

	if safe=1
		move.l	a2,d2			; copy pointer to d0
		and.l	#$FFFFFF,d2		; clearing the upper 8 bits allows the debugger
		move.l	d2,a2			; to show the address correctly. Move ptr back to a2
		AMPS_Debug_PlayTrackMus		; check if this was valid music
	endif
; ---------------------------------------------------------------------------
; The following code will 'back up' every song by copying its data to
; another memory location. There is another piece of code that will copy
; it back once the song ends. This will do proper restoration of the
; channels into hardware! The 6th bit of tick multiplier is used to
; determine whether to back up or not
; ---------------------------------------------------------------------------

	if FEATURE_BACKUP
		btst	#6,(a2)			; check if this song should cause the last one to be backed up
		beq.s	.clrback		; if not, skip
		bset	#mfbBacked,mFlags.w	; check if song was backed up (and if not, set the bit)
		bne.s	.noback			; if yes, preserved the backed up song

		move.l	mTempoMain.w,mBackTempoMain.w; backup tempo settings
		move.l	mTempo.w,mBackTempo.w	; ''
		move.l	mVctMus.w,mBackVctMus.w	; backup voice table address

		lea	mBackUpArea.w,a4	; load source address to a4
		lea	mBackUpLoc.w,a3		; load destination address to a3
		move.w	#(mSFXDAC1-mBackUpArea)/4-1,d3; load backup size to d3

.backup
		move.l	(a4)+,(a3)+		; back up data for every channel
		dbf	d3,.backup		; loop for each longword

	if (mSFXDAC1-mBackUpArea)&2
		move.w	(a4)+,(a3)+		; back up data for every channel
	endif

		mvnbt	d3, cfbInt, cfbVol	; each other bit except interrupted and volume update bits

.ch :=		mBackDAC1			; start at backup DAC1
		rept Mus_Ch			; do for all music channels
			and.b	d3,.ch.w	; remove the interrupted by sfx bit
.ch :=			.ch+cSize		; go to next channel
		endm
		bra.s	.noback

.clrback
		bclr	#mfbBacked,mFlags.w	; set as no song backed up

.noback
	endif
; ---------------------------------------------------------------------------

		jsr	dStopMusic(pc)		; mute hardware and reset all driver memory
		jsr	dResetVolume(pc)	; reset volumes and end any fades
		move.b	#0,mMusicFlags.w	; set default music flags

		btst	#mfbBlockUW,(a2)	; check if underwater mode was blocked
		beq.s	.nouwd			; if not, skip
		or.b	#1<<mfbBlockUW,mMusicFlags.w; disable underwater mode
		bra.s	.nouwo			; do not enable

.nouwd
		btst	#mfbWater,mFlags.w	; check if underwater mode is enabled
		beq.s	.nouwo			; branch if no
		or.b	#1<<mfbWater,mMusicFlags.w; set underwater mode as enabled

.nouwo
		and.b	#$FF-(1<<mfbNoPAL),mFlags.w; enable PAL fix
		move.w	(a2)+,d3		; load song tempo to d3
		bpl.s	.noPAL			; branch if the loaded value was positive
		or.b	#1<<mfbNoPAL,mFlags.w	; disable PAL fix

.noPAL
		and.w	#$0FFF,d3		; clear extra bits
		move.w	d3,d6			; copy to d6
		add.w	(sp)+,d6		; add stored tempo from stack
		move.w	d6,mTempoSpeed.w	; save d6 as speed tempo
		move.w	d3,mTempoMain.w		; save d3 as regular tempo

		btst	#mfbSpeed,mFlags.w	; check if speed shoes flag was set
		beq.s	.tempogot		; if not, use main tempo
		move.w	d6,d3			; load speed shoes tempo to d3 instead

.tempogot
		move.w	d3,mTempo.w		; save as the current tempo
		move.w	d3,mTempoAcc.w		; copy into the accumulator/counter
; ---------------------------------------------------------------------------
; If the 7th bit (msb) of tick multiplier is set, PAL fix gets disabled.
; I know, very weird place to put it, but we dont have much free room
; in the song header
; ---------------------------------------------------------------------------

		moveq	#0,d4			; clear d4
		move.b	(a2),d4			; load the PSG channel count to d4
		addq.w	#2,a2			; go to DAC1 data section

		mvbit	d2, cfbRun, cfbVol	; prepare running tracker and volume flags into d2
		moveq	#signextendB($C0),d1			; prepare panning value of centre to d1
		move.w	#$100,d3		; prepare default DAC frequency

		moveq	#cSize,d6		; prepare channel size to d6
		moveq	#1,d5			; prepare duration of 0 frames to d5
; ---------------------------------------------------------------------------

		lea	mDAC1.w,a1		; start from DAC1 channel
		lea	dDACtypeVals(pc),a4	; prepare DAC (and FM) type value list into a4
		moveq	#2-1,d0			; always run for 2 DAC channels

.loopDAC
		move.b	d2,(a1)			; save channel flags
		move.b	(a4)+,cType(a1)		; load channel type from list
		move.b	d6,cStack(a1)		; reset channel stack pointer
		move.b	d1,cPanning(a1)		; reset panning to centre
		move.b	d5,cDuration(a1)	; reset channel duration
		move.w	d3,cFreq(a1)		; reset channel base frequency

		move.l	a2,a3			; load music header position to a3
		add.w	(a2)+,a3		; add tracker offset to a3
		move.l	a3,cData(a1)		; save as the tracker address of the channel
	if safe=1
		AMPS_Debug_PlayTrackMus2 DAC	; make sure the tracker address is valid
	endif

		move.b	(a2)+,cVolume(a1)	; load channel volume
		move.b	(a2)+,cSample(a1)	; load channel sample ID
		beq.s	.sampmode		; if 0, we are in sample mode
		bset	#cfbMode,(a1)		; if not 0, enable pitch mode

.sampmode
		add.w	d6,a1			; go to the next channel
		dbf	d0,.loopDAC		; repeat for all DAC channels
; ---------------------------------------------------------------------------

		move.b	-9(a2),d0		; load the FM channel count to d0
	if safe=1
		bmi.w	.doPSG			; if no FM channels are loaded, branch
	else
		bmi.s	.doPSG			; if no FM channels are loaded, branch
	endif

		ext.w	d0			; convert byte to word (because of dbf)
		mvbit	d2, cfbRun, cfbRest	; prepare running tracker and channel rest flags to d2

.loopFM
	if FEATURE_FM3SM
		cmp.w	#mFM3op3,a1		; is this FM3op3?
		bne.s	.nosm			; if not, skip
		add.w	#3*cSize,a1		; skip all FM3 special mode channels

.nosm
	endif

		move.b	d2,(a1)			; save channel flags
		move.b	(a4)+,cType(a1)		; load channel type from list
		move.b	d6,cStack(a1)		; reset channel stack pointer
		move.b	d1,cPanning(a1)		; reset panning to centre
		move.b	d5,cDuration(a1)	; reset channel duration

		move.l	a2,a3			; load music header position to a3
		add.w	(a2)+,a3		; add tracker offset to a3
		move.l	a3,cData(a1)		; save as the tracker address of the channel
	if safe=1
		AMPS_Debug_PlayTrackMus2 FM	; make sure the tracker address is valid
	endif

		move.w	(a2)+,cPitch(a1)	; load pitch offset and channel volume
		adda.w	d6,a1			; go to the next channel
		dbf	d0,.loopFM		; repeat for all FM channels
; ---------------------------------------------------------------------------
; The reason why we delay PSG by 1 extra frame, is because of Dual PCM.
; It adds a delay of 1 frame to DAC and FM due to the YMCue, and PCM
; buffering to avoid quality loss from DMA's. This means that, since PSG
; is controlled by the 68000, we would be off by a single frame without
; this fix
; ---------------------------------------------------------------------------

.doPSG
		tst.b	d4			; check how many PSG channels there are
	if safe=1
		bmi.w	.finish			; if no PSG channels are loaded, branch
	else
		bmi.s	.finish			; if no PSG channels are loaded, branch
	endif

		mvbit	d2, cfbRun, cfbVol, cfbRest; prepare running tracker, resting and volume flags into d2
		moveq	#2,d5			; prepare duration of 1 frames to d5
		lea	dPSGtypeVals(pc),a4	; prepare PSG type value list into a4
		lea	mPSG1.w,a1		; start from PSG1 channel

.loopPSG
		move.b	d2,(a1)			; save channel flags
		move.b	(a4)+,cType(a1)		; load channel type from list
		move.b	d6,cStack(a1)		; reset channel stack pointer
		move.b	d5,cDuration(a1)	; reset channel duration

		move.l	a2,a3			; load music header position to a3
		add.w	(a2)+,a3		; add tracker offset to a3
		move.l	a3,cData(a1)		; save as the tracker address of the channel
	if safe=1
		AMPS_Debug_PlayTrackMus2 PSG	; make sure the tracker address is valid
	endif

		move.w	(a2)+,cPitch(a1)	; load pitch offset and channel volume
		move.b	(a2)+,cDetune(a1)	; load detune offset
		move.b	(a2)+,cVolEnv(a1)	; load volume envelope ID
		adda.w	d6,a1			; go to the next channel
		dbf	d4,.loopPSG		; repeat for all PSG channels
; ---------------------------------------------------------------------------
; Unlike SMPS, AMPS does not have pointer to the voice table of
; a song. This may be limiting for some songs, but this allows AMPS
; to save 2 bytes for each music and sound effect file. This line
; of code sets the music voice table address at the end of the header
; ---------------------------------------------------------------------------

.finish
		move.l	a2,mVctMus.w		; set voice table address to a2
; ---------------------------------------------------------------------------
; Now follows initializing FM6 to be ready for PCM streaming,
; and resetting the PCM filter for Dual PCM. Simply, this just
; clears some YM registers.
; ---------------------------------------------------------------------------

	if FEATURE_FM6
		tst.b	mFM6.w			; check if FM6 is used by music
		bmi.s	.yesFM6			; if so, do NOT initialize FM6 to mute
	endif

		moveq	#$7F, d3		; set total level to $7F (silent)
	CheckCue				; check that cue is valid
	stopZ80

	WriteYM1	#$28, #6		; Key on/off: FM6, all operators off
	WriteYM2	#$42, d3		; Total Level Operator 1 (FM3/6)
	WriteYM2	#$4A, d3		; Total Level Operator 2 (FM3/6)
	WriteYM2	#$46, d3		; Total Level Operator 3 (FM3/6)
	WriteYM2	#$4E, d3		; Total Level Operator 4 (FM3/6)

	WriteYM2	#$B6, #$C0		; Panning and LFO (FM3/6): centre
	;	st	(a0)			; write end marker
	startZ80

.yesFM6
		moveq	#(fLog>>$0F)&$FF,d4	; use logarithmic filter
		jmp	dSetFilter(pc)		; set filter
; ===========================================================================
; ---------------------------------------------------------------------------
; Type values for different channels. Used for playing music
; ---------------------------------------------------------------------------

dDACtypeVals:	dc.b ctDAC1, ctDAC2
dFMtypeVals:	dc.b ctFM1, ctFM2, ctFM3, ctFM4, ctFM5
	if FEATURE_FM6
		dc.b ctFM6
	endif
dPSGtypeVals:	dc.b ctPSG1, ctPSG2, ctPSG3
	if FEATURE_PSG4
		dc.b ctPSG4
	endif
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to play a queued sound effect
;
; thrash:
;   d0 - Loop counter for each channel
;   d6 - Size of each channel
;   a1 - Current sound channel address that is being processed
;   a2 - Current address into the tracker data
;   a3 - Used for channel address calculation
;   a4 - Type values arrays
;   d6 - Temporarily used to hold the speed shoes tempo
;   all - other dregisters are gonna be used too
; ---------------------------------------------------------------------------

locret_PlaySnd:
		rts

dPlaySnd_SFX:
	if FEATURE_BACKUP&FEATURE_BACKUPNOSFX
		btst	#mfbBacked,mFlags.w	; check if a song has been queued
		bne.s	locret_PlaySnd		; branch if so
	endif
; ---------------------------------------------------------------------------
; To save few cycles, we don't directly substract the SFX offset from
; the ID, and instead offset the table position. In practice this will
; have the same effect, but saves us 8 cycles overall.
; ---------------------------------------------------------------------------

.index =	SoundIndex-(SFXoff*4)		; effin ASS
		lea	.index(pc),a1		; get sfx pointer table with an offset to a4
		add.w	d1,d1			; quadruple sfx ID
		add.w	d1,d1			; since each entry is 4 bytes in size
		movea.l	(a1,d1.w),a2		; get SFX header pointer from the table
; ---------------------------------------------------------------------------
; This implements a system where the sound effect swaps every time its
; played. This in particular needed with Sonic 1 to 3K, where the ring SFX
; would every time change the panning by playing a different SFX ID. AMPS
; extends this system to support any number of SFX following this same system.
; ---------------------------------------------------------------------------

		btst	#0,(a1,d1.w)		; check if sound effect has swapping behaviour
		beq.s	.noswap			; if not, skip
		bchg	#mfbSwap,mFlags.w	; swap th flag and check if it was set
		beq.s	.noswap			; if was not, do not swap sound effect
		addq.w	#4,d1			; go to next SFX
		movea.l	(a1,d1.w),a2		; get the next SFX pointer from the table

.noswap
	if safe=1
		move.l	a2,d2			; copy pointer to d2
		and.l	#$FFFFFF,d2		; clearing the upper 8 bits allows the debugger
		move.l	d2,a2			; to show the address correctly. Move ptr back to a2
		AMPS_Debug_PlayTrackSFX		; check if this was valid sound effect
	endif
; ---------------------------------------------------------------------------
; Continous SFX is a very special type of sound effect. Unlike other
; sound effects, when a continous SFX is played, it will run a loop
; again, until it is no longer queued. This is very useful for sound
; effects that need to be queued very often, but that really do not
; sound good when restarted (plus, it requires more CPU time, anyway).
; Even the Marble Zone block pushing sound effect had similar behavior,
; but the code was not quite as matured as this here. Only one continous
; SFX may be running at once, however, there is no code to enforce this.
; It may lead to problems where incorrect channels are kept running.
; Please be careful with this!
;
; Note: Playing any other SFX will prevent continous sfx from continuing
; (until played again). This was made because if you had a continous sfx
; stop due to another SFX, it would actually break all continous sfx with
; the same ID. Since there is no way to show any sfx is continous when
; its running, there is no way to fix this without doing it this way. If
; this breaks anything significant, let me know and I'll tackle this
; problem once again.
; ---------------------------------------------------------------------------

		moveq	#0,d6			; prepare extra flags to none
		btst	#mfbBlockUW,(a1,d1.w)	; check if disable underwater is set
		beq.s	.nouwd			; branch if not
		moveq	#1<<mfbBlockUW,d6	; set underwater mode as blocked
		bra.s	.nouwo

.nouwd
		btst	#mfbWater,mFlags.w	; check if underwater mode is enabled
		beq.s	.nouwo			; branch if no
		moveq	#1<<mfbWater,d6		; set underwater mode as enabled
; ---------------------------------------------------------------------------

.nouwo
		tst.b	(a1,d1.w)		; check if this sound effect is continously looping
		bpl.s	.nocont			; if not, skip
		clr.b	mContCtr.w		; reset continous sfx counter

		lsr.w	#2,d1			; get actual SFX ID
		cmp.b	mContLast.w,d1		; check if the last continous SFX had the same ID
		bne.s	.setcont		; if not, play as a new sound effect anyway
		move.b	1(a2),mContCtr.w	; copy the number of channels as the new continous loop counter
		addq.b	#1,mContCtr.w		; increment by 1, since num of channels is -1 the actual channel count
		rts
; ---------------------------------------------------------------------------

.nocont
		moveq	#0,d1			; clear last continous sfx

.setcont
		move.b	d1,mContLast.w		; save new continous SFX ID
		lea	dSFXoverList(pc),a5	; load quick reference to the SFX override list to a5
		lea	dSFXoffList(pc),a4	; load quick reference to the SFX channel list to a4

		moveq	#0,d1			; reset channel count
		move.b	d6,d1			; store flags in d1.w
; ---------------------------------------------------------------------------
; The reason why we delay PSG by 1 extra frame, is because of Dual PCM.
; It adds a delay of 1 frame to DAC and FM due to the YMCue, and PCM
; buffering to avoid quality loss from DMA's. This means that, since PSG
; is controlled by the 68000, we would be off by a single frame without
; this fix.
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	(a2)+,d2		; load sound effect priority to d2
		move.b	(a2)+,d0		; load number of SFX channels to d0

.loopSFX
		moveq	#0,d3
		move.b	1(a2),d3		; load sound effect channel type to d3
		move.b	d3,d5			; copy type to d5
		bmi.w	.chPSG			; if channel is a PSG channel, branch

		and.w	#$07,d3			; get only the necessary bits to d3
		add.w	d3,d3			; double offset (each entry is 1 word in size)

		move.w	(a4,d3.w),a1		; get the SFX channel we are trying to load to
		cmp.b	cPrio(a1),d2		; check if this sound effect has higher priority
		blo.s	.skip			; if not, we can not override it

		move.w	(a5,d3.w),a3		; get the music channel we should override
		bset	#cfbInt,(a3)		; override music channel with sound effect
		moveq	#1,d4			; prepare duration of 0 frames to d4
		bra.w	.clearCh
; ---------------------------------------------------------------------------

	if FEATURE_FM3SM
		cmp.w	#mFM3op1,a3		; are we overriding FM3op1?
		beq.s	.nofm3			; if not, skip
		bset	#cfbInt,mFM3op3.w	; override FM3op3 too
		bset	#cfbInt,mFM3op2.w	; override FM3op2 too
		bset	#cfbInt,mFM3op4.w	; override FM3op4 too
	dSetFM3SM	#$00			; disable FM3 special mode

.nofm3
	endif
		moveq	#1,d4			; prepare duration of 0 frames to d4
		bra.s	.clearCh
; ---------------------------------------------------------------------------

.skip
		addq.l	#6,a2			; skip this sound effect channel
		dbf	d0,.loopSFX		; repeat for each requested channel

		swap	d1			; get chan count to d1.w
		tst.w	d1			; check if any channel was loaded
		bne.s	.rts			; if was, branch
		clr.b	mContLast.w		; reset continous sfx counter (prevent ghost-loading)

.rts
		rts
; ---------------------------------------------------------------------------

.chPSG
		lsr.w	#4,d3			; make it easier to reference the right offset in the table
		move.w	4(a4,d3.w),a1		; get the SFX channel we are trying to load to
		cmp.b	cPrio(a1),d2		; check if this sound effect has higher priority
		blo.s	.skip			; if not, we can not override it

	if FEATURE_PSGADSR
		lea	dSFXADSRtbl-8(pc),a3	; get PSG ADSR table address to a3
		move.w	(a3,d3.w),a3		; load the PSG ADSR entry this channel uses
		move.w	#$7F00|admImm|adpRelease,(a3); set to default value
	endif

		move.w	4(a5,d3.w),a3		; get the music channel we should override
		bset	#cfbInt,(a3)		; override music channel with sound effect
		moveq	#2,d4			; prepare duration of 1 frames to d4

		ori.b	#$1F,d5			; add volume update and max volume to channel type
		move.b	d5,dPSG.l		; send volume mute command to PSG

		cmpi.b	#ctPSG3|$1F,d5		; check if we sent command about PSG3
		bne.s	.clearCh		; if not, skip
		move.b	#ctPSG4|$1F,dPSG.l	; send volume mute command for PSG4 to PSG

	if FEATURE_PSG4
		bset	#cfbInt,mPSG4+cFlags.w	; override music PSG4 too
	endif
; ---------------------------------------------------------------------------

.clearCh
		move.w	a1,a3			; copy sound effect channel RAM pointer to a3

	rept cSizeSFX/4				; repeat by the number of long words for channel data
		clr.l	(a3)+			; clear 4 bytes of channel data
	endm

	if cSizeSFX&2
		clr.w	(a3)+			; if channel size can not be divided by 4, clear extra word
	endif
; ---------------------------------------------------------------------------

		move.l	(a2)+,(a1)		; load channel flags, type, pitch offset and channel volume
		move.b	d2,cPrio(a1)		; set channel priority
		move.b	d4,cDuration(a1)	; reset channel duration

		move.l	a2,a3			; load music header position to a3
		add.w	(a2)+,a3		; add tracker offset to a3
		move.l	a3,cData(a1)		; save as the tracker address of the channel
	if safe=1
		AMPS_Debug_PlayTrackSFX2	; make sure the tracker address is valid
	endif

		move.b	mFlags.w,d3		; load flags value to d3
		and.b	#1<<mfbWater,d3		; get only underwater flags (copy it)
		or.b	d1,d3			; OR any other necessary flags from d1.w
		move.b	d3,cExtraFlags(a1)	; save extra flags value

		swap	d1			; get chan count to d1.w
		addq.w	#1,d1			; set channel as loaded
		swap	d1			; get flags to d1.w

		tst.b	d5			; check if this channel is a PSG channel
		bmi.s	.loop			; if is, skip over this
		moveq	#signextendB($C0),d3			; set panning to centre
		move.b	d3,cPanning(a1)		; save to channel memory too

	CheckCue				; check that YM cue is valid
	InitChYM				; prepare to write to channel
	stopZ80
	WriteChYM	#$B4, d3		; Panning and LFO: centre
	;	st	(a0)			; write end marker
	startZ80

		cmpa.w	#mSFXDAC1,a1		; check if this channel is a DAC channel
		bne.s	.fm			; if not, branch
		move.w	#$100,cFreq(a1)		; DAC default frequency is $100, NOT $000

.loop
		dbf	d0,.loopSFX		; repeat for each requested channel
		rts
; ---------------------------------------------------------------------------
; The instant release for FM channels behavior was not in the Sonic 1
; SMPS driver by default, but it has been added since it fixes an
; issue with YM2612, where sometimes subsequent sound effect activations
; would sound different over time. This fix will help to mitigate that.
; ---------------------------------------------------------------------------

.fm
		moveq	#$F,d3			; set to release note instantly
	CheckCue				; check that YM cue is valid
	InitChYM				; prepare to write to channel
	stopZ80

	WriteYM1	#$28, cType(a1)		; Key on/off: all operators off
	WriteChYM	#$80, d3		; Release Rate Operator 1
	WriteChYM	#$88, d3		; Release Rate Operator 2
	WriteChYM	#$84, d3		; Release Rate Operator 3
	WriteChYM	#$8C, d3		; Release Rate Operator 4

	;	st	(a0)			; write end marker
	startZ80
		dbf	d0,.loopSFX		; repeat for each requested channel
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; pointers for music channels SFX can override and addresses of SFX channels
; ---------------------------------------------------------------------------

	if FEATURE_PSGADSR
dSFXADSRtbl:
		dc.w mADSRSFX+aSFXPSG1		; SFX PSG1
		dc.w mADSRSFX+aSFXPSG2		; SFX PSG2
		dc.w mADSRSFX+aSFXPSG3		; SFX PSG3
		if FEATURE_PSG4
			dc.w mADSRSFX+aSFXPSG4	; SFX PSG4
		else
			dc.w mADSRSFX+aSFXPSG3	; SFX PSG4
		endif
	endif
; ---------------------------------------------------------------------------

dSFXoffList:
		dc.w 0				; null
		dc.w mSFXFM2			; SFX FM2
		dc.w 0				; null
		dc.w mSFXDAC1			; SFX DAC1
		dc.w mSFXFM4			; SFX FM4
		dc.w mSFXFM5			; SFX FM5
		dc.w mSFXPSG1			; SFX PSG1
		dc.w mSFXPSG2			; SFX PSG2
		dc.w mSFXPSG3			; SFX PSG3
	if FEATURE_PSG4
		dc.w mSFXPSG4			; SFX PSG4
	else
		dc.w mSFXPSG3			; SFX PSG4
	endif
; ---------------------------------------------------------------------------

dSFXoverList:
		dc.w 0				; FM1
		dc.w mFM2			; FM2
		dc.w 0				; FM3
		dc.w mDAC1			; DAC1
		dc.w mFM4			; FM4
		dc.w mFM5			; FM5
		dc.w mPSG1			; PSG1
		dc.w mPSG2			; PSG2
		dc.w mPSG3			; PSG3
	if FEATURE_PSG4
		dc.w mPSG4			; PSG4
	else
		dc.w mPSG3			; PSG4
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Play queued command
;
; input:
;   d1 - Sound ID
; ---------------------------------------------------------------------------

dPlaySnd_Comm:
	if safe=1
		AMPS_Debug_PlayCmd		; check if the command is valid
	endif

		add.w	d1,d1			; quadruple ID
		add.w	d1,d1			; because each entry is 1 long word
		jmp	dSoundCommands-4(pc,d1.w); jump to appropriate command handler

; ---------------------------------------------------------------------------
dSoundCommands:
		bra.w	dPlaySnd_Reset		; 01 - Reset underwater and speed shoes flags, update volume
		bra.w	dPlaySnd_FadeOut	; 02 - Initialize a music fade out
		bra.w	dPlaySnd_Stop		; 03 - Stop all music
		bra.w	dPlaySnd_ShoesOn	; 04 - Enable speed shoes mode
		bra.w	dPlaySnd_ShoesOff	; 05 - Disable speed shoes mode
		bra.w	dPlaySnd_ToWater	; 06 - Enable underwater mode
		bra.w	dPlaySnd_OutWater	; 07 - Disable underwater mode
		bra.w	dPlaySnd_Pause		; 08 - Pause the sound driver
		bra.w	dPlaySnd_Unpause	; 09 - Unpause the sound driver
		bra.w	dPlaySnd_StopSFX	; 0A - Stop all sfx
dSoundCommands_End:
; ===========================================================================
; ---------------------------------------------------------------------------
; Commands for what to do after a volume fade
; ---------------------------------------------------------------------------

dFadeCommands:
		rts				; 80 - Do nothing
		rts
.stop		bra.s	dPlaySnd_Stop		; 84 - Stop all music
		rts
.resv		bra.w	dResetVolume		; 88 - Reset volume and update
		bsr.s	.resv			; 8C - Stop music playing and reset volume
		bra.s	.stop
; ===========================================================================
; ---------------------------------------------------------------------------
; Stop SFX from playing and restore interrupted channels correctly
; ---------------------------------------------------------------------------

dPlaySnd_StopSFX:
		moveq	#SFX_Ch-1,d0		; load num of SFX channels to d0
		lea	mSFXDAC1.w,a1		; start from SFX DAC 1

.loop
		tst.b	(a1)			; check if this channel is running a tracker
		bpl.s	.notrack		; if not, skip
		jsr	dcStop(pc)		; run the tracker stop command
		nop				; required because the address may be modified by dcStop

.notrack
		add.w	#cSizeSFX,a1		; go to next channel
		dbf	d0,.loop		; repeat for each channel

	if FEATURE_PSGADSR
		dResetADSR	a4, d6, 2	; reset ADSR data for PSG SFX
	endif
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Stop music and SFX from playing (This code clears SFX RAM also)
; ---------------------------------------------------------------------------

dPlaySnd_Stop:
	if FEATURE_BACKUP
		bclr	#mfbBacked,mFlags.w	; reset backed up song bit
	endif

;		lea	mSFXDAC1.w,a4		; prepare SFX DAC 1 to start clearing from
;	dCLEAR_MEM	mChannelEnd-mSFXDAC1, 16; clear this block of memory with 16 byts per loop

	; continue straight to stopping music
; ===========================================================================
; ---------------------------------------------------------------------------
; Stop music and SFX from playing (This code clears SFX RAM also)
;
; thrash:
;   all - Basically all registers
; ---------------------------------------------------------------------------

dStopMusic:
	dSetFM3SM	#$00			; disable FM3 special mode

		lea	mVctMus.w,a4		; load driver RAM start to a4
		move.b	mMasterVolDAC.w,d5	; load DAC master volume to d5
	dCLEAR_MEM	mChannelEnd-mVctMus, 32	; clear this block of memory with 32 bytes per loop

	if FEATURE_PSGADSR
		dResetADSR	a4, d6, 3	; reset ADSR data for PSG
	endif

	if safe=1
		clr.b	msChktracker.w		; if in safe mode, also clear the check tracker variable!
	endif
; ---------------------------------------------------------------------------

		move.b	d5,mMasterVolDAC.w	; save DAC master volume
		jsr	dMuteFM(pc)		; hardware mute FM
		jsr	dMuteDAC(pc)		; hardware mute DAC
	; continue straight to hardware muting PSG
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for muting all PSG channels
;
; thrash:
;   a4 - PSG address
; ---------------------------------------------------------------------------

dMutePSG:
		lea	dPSG.l,a4		; load PSG data port address to a4
		move.b	#ctPSG1|$1F,(a4)	; send volume mute command for PSG1
		move.b	#ctPSG2|$1F,(a4)	; send volume mute command for PSG2
		move.b	#ctPSG3|$1F,(a4)	; send volume mute command for PSG3
		move.b	#ctPSG4|$1F,(a4)	; send volume mute command for PSG4
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for resetting master volumes, filters and disabling fading
;
; thrash:
;   a4 - Used by other function
;   d4 - Lowest byte gets cleared.
;   d5 - Used by other function
;   d6 - Used for or-ing volume
; ---------------------------------------------------------------------------

dResetVolume:
		clr.l	mFadeAddr.w		; stop fading program and reset FM master volume
		clr.b	mMasterVolPSG.w		; reset PSG master volume
		clr.b	mMasterVolDAC.w		; reset DAC master volume
		moveq	#(fLog>>$0F)&$FF,d4	; use logarithmic filter
		jsr	dSetFilter(pc)		; load filter instructions
; ---------------------------------------------------------------------------

dUpdateVolumeAll:
		bsr.w	dReqVolUpFM		; request FM volume update
		or.b	d6,mSFXDAC1.w		; request update for SFX DAC1 channel

.ch :=	mDAC1					; start at DAC1
	rept Mus_DAC				; loop through all music DAC channels
		or.b	d6,.ch.w		; request channel volume update
.ch :=		.ch+cSize			; go to next channel
	endm

.ch :=	mPSG1					; start at PSG1
	rept Mus_PSG				; loop through all music PSG channels
		or.b	d6,.ch.w		; request channel volume update
.ch :=		.ch+cSize			; go to next channel
	endm

.ch :=	mSFXPSG1				; start at SFX PSG1
	rept SFX_PSG				; loop through all SFX PSG channels
		or.b	d6,.ch.w		; request channel volume update
.ch :=		.ch+cSizeSFX			; go to next channel
	endm
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Reset music flags (underwater mode and tempo mode)
; ---------------------------------------------------------------------------

dPlaySnd_Reset:
	if FEATURE_BACKUP
		bclr	#mfbBacked,mFlags.w	; reset backed up song bit
	endif

	if FEATURE_UNDERWATER
		bsr.s	dPlaySnd_OutWater	; reset underwater flag and request volume update
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Disable speed shoes mode
; ---------------------------------------------------------------------------

dPlaySnd_ShoesOff:
		bclr	#mfbSpeed,mFlags.w	; disable speed shoes flag
		move.w	mTempoMain.w,mTempoAcc.w; set tempo accumulator/counter to normal
		move.w	mTempoMain.w,mTempo.w	; set main tempor to normal

	if FEATURE_BACKUP
		move.w	mBackTempoMain.w,mBackTempoAcc.w; do the same for backup tempos
		move.w	mBackTempoMain.w,mBackTempo.w
	endif
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Enable Underwater mode
; ---------------------------------------------------------------------------

dPlaySnd_ToWater:
	if FEATURE_UNDERWATER
		bset	#mfbWater,mFlags.w	; enable underwater mode
		bsr.s	dReqVolUpFM		; request FM volume update
		bra.s	dPlaySnd_UpdateUW	; update underwater status
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Disable Underwater mode
; ---------------------------------------------------------------------------

dPlaySnd_OutWater:
	if FEATURE_UNDERWATER
		bclr	#mfbWater,mFlags.w	; disable underwater mode
		bsr.s	dReqVolUpFM		; request FM volume update
; ---------------------------------------------------------------------------

dPlaySnd_UpdateUW:
		btst	#mfbWater,mFlags.w	; check if underwater mode is active
		bne.s	dPlaySnd_UpdateEnableUW	; if enabled, run the code to enable to
		moveq	#~(1<<mfbWater),d6	; prepare update value to d6
		and.b	d6,mMusicFlags.w	; disable underwater mode for music

.ch :=		mSFXFM2+cExtraFlags		; start at SFX FM3
		rept SFX_FM			; loop through all SFX FM channels
			and.b	d6,.ch.w	; disable underwater mode for sfx
.ch :=			.ch+cSizeSFX		; go to next channel
		endm
	else
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; force volume update on all FM channels
;
; thrash:
;   d6 - Used for quickly or'ing the value
; ---------------------------------------------------------------------------

dReqVolUpFM:
		moveq	#1<<cfbVol,d6		; prepare volume update flag to d0

.ch :=	mSFXFM2					; start at SFX FM3
	rept SFX_FM				; loop through all SFX FM channels
		or.b	d6,.ch.w		; request channel volume update
.ch :=		.ch+cSizeSFX			; go to next channel
	endm
; ---------------------------------------------------------------------------

dReqVolUpMusicFM:
		moveq	#1<<cfbVol,d6		; prepare volume update flag to d0

.ch :=	mFM1					; start at FM1
	rept Mus_FM				; loop through all music FM channels
		or.b	d6,.ch.w		; request channel volume update
.ch :=		.ch+cSize			; go to next channel
	endm

locret_ReqVolUp:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Enable underwater mode thing
; ---------------------------------------------------------------------------

	if FEATURE_UNDERWATER
dPlaySnd_UpdateEnableUW:
		moveq	#~(1<<mfbWater),d6	; prepare disable value to d6
		moveq	#1<<mfbWater,d5		; prepare enable value to d5
		and.b	d6,mMusicFlags.w	; disable underwater mode for music

		btst	#mfbBlockUW,mMusicFlags.w; check if underwater mode is blocked
		bne.s	.nomus			; branch if disabled
		or.b	d5,mMusicFlags.w	; enable underwater mode for music

.nomus
.ch :=	mSFXFM2+cExtraFlags			; start at SFX FM3
	rept SFX_FM				; loop through all SFX FM channels
		and.b	d6,.ch.w		; disable underwater mode for sfx

		btst	#mfbBlockUW,.ch.w	; check if underwater mode is blocked
		bne.s	.nono			; if so, skip
		or.b	d5,.ch.w		; enable underwater mode for sfx

.nono
.ch :=		.ch+cSizeSFX			; go to next channel
	endm
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Enable speed shoes mode
; ---------------------------------------------------------------------------

dPlaySnd_ShoesOn:
		bset	#mfbSpeed,mFlags.w	; enable speed shoes flag
		move.w	mTempoSpeed.w,mTempoAcc.w; set tempo accumulator/counter to speed shoes
		move.w	mTempoSpeed.w,mTempo.w	; set main tempor to speed shoes

	if FEATURE_BACKUP
		move.w	mBackTempoSpeed.w,mBackTempoAcc.w; do the same for backup tempos
		move.w	mBackTempoSpeed.w,mBackTempo.w
	endif
		rts
; ---------------------------------------------------------------------------

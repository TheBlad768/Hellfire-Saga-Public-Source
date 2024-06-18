; ===========================================================================
; ---------------------------------------------------------------------------
; Routine to execute tracker commands
;
; The reason we use add.b instead of add.w, is to get rid of some bits that
; would make this kind of arbitary jumping way more complex than it needs to be.
; What do we win by doing this? Why, 8 cycles per command! Thats... Not a lot,
; but it may be helpful with speed anyway.
; ---------------------------------------------------------------------------

dCommands:
		add.b	d1,d1			; quadruple command ID
		add.b	d1,d1			; since each entry is 4 bytes large

		btst	#cfbCond,(a1)		; check if condition state
		bne.w	.falsecomm		; branch if false
.cunt = 	.comm-$80			; AS is ASS
		jmp	.cunt(pc,d1.w)		; jump to appropriate handler
; ===========================================================================
; ---------------------------------------------------------------------------
; Command handlers for normal execution
; ---------------------------------------------------------------------------

.comm
		bra.w	dcPan			; E0 - Panning, AMS, FMS (PANAFMS - PAFMS_PAN)
		bra.w	dcsDetune		; E1 - Set channel frequency displacement to xx (DETUNE_SET)
		bra.w	dcaDetune		; E2 - Add xx to channel frequency displacement (DETUNE)
		bra.w	dcsTransp		; E3 - Set channel pitch to xx (TRANSPOSE - TRNSP_SET)
		bra.w	dcaTransp		; E4 - Add xx to channel pitch (TRANSPOSE - TRNSP_ADD)
		bra.w	dcsPortaFreqNote	; E5 - Set portamento target frequency to note xx (PORTAMENTO_FREQ - FREQ_NOTE)
		bra.w	dcFqFz			; E6 - Freeze frequency for the next note (FREQ_FREEZE)
		bra.w	dcHold			; E7 - Do not allow note on/off for next note (HOLD)
		bra.w	dcVoice			; E8 - Set Voice/sample/ADSR to xx (INSTRUMENT - INS_C_FM / INS_C_DAC / INS_C_ADSR)
		bra.w	dcsTempoShoes		; E9 - Set music speed shoes tempo to xx (TEMPO - TEMPO_SET_SPEED)
		bra.w	dcsTempo		; EA - Set music tempo to xx (TEMPO - TEMPO_SET)
		bra.w	dcSampDAC		; EB - Use sample DAC mode (DAC_MODE - DACM_SAMP)
		bra.w	dcPitchDAC		; EC - Use pitch DAC mode (DAC_MODE - DACM_NOTE)
		bra.w	dcaVolume		; ED - Add xx to channel volume (VOLUME - VOL_CN_FM / VOL_CN_PSG / VOL_CN_DAC)
		bra.w	dcsVolume		; EE - Set channel volume to xx (VOLUME - VOL_CN_ABS)
		bra.w	dcsLFO			; EF - Set LFO (SET_LFO - LFO_AMSEN)
		bra.w	dcMod68K		; F0 - Modulation (MOD_SETUP)
		bra.w	dcPortamento		; F1 - Portamento enable/disable flag (PORTAMENTO)
		bra.w	dcVolEnv		; F2 - Set volume envelope to xx (INSTRUMENT - INS_C_PSG) (FM_VOLENV / DAC_VOLENV)
		bra.w	dcModEnv		; F3 - Set modulation envelope to xx (MOD_ENV - MENV_GEN)
		bra.w	dcComplexTL		; F4 - Setup TL modulation for all operators according to parameter value (TL_MOD - MOD_COMPLEX)
		bra.w	dcStop			; F5 - End of channel (TRK_END - TEND_STD)
		bra.w	dcJump			; F6 - Jump to xxxx (GOTO)
		bra.w	dcLoop			; F7 - Loop back to zzzz yy times, xx being the loop index (LOOP)
		bra.w	dcCall			; F8 - Call pattern at xxxx, saving return point (GOSUB)
		bra.w	dcReturn		; F9 - Return (RETURN)
		bra.w	dcsComm			; FA - Set communications byte yy to xx (SET_COMM - SPECIAL)
		bra.w	dcCond			; FB - Get comms byte y, and compare zz using condition x (COMM_CONDITION)
		bra.w	dcResetCond		; FC - Reset condition (COMM_RESET)
		bra.w	dcGate			; FD - Stop note after xx frames (NOTE_STOP - NSTOP_NORMAL)
		bra.w	dcYM			; FE - YM command (YMCMD)
						; FF - META
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine to execute tracker meta and false condition commands
; ---------------------------------------------------------------------------

.metacall
		move.b	(a2)+,d1		; get next command byte
		jmp	.meta(pc,d1.w)		; jump to appropriate meta handler

.falsecomm
.fuck = 	.false-$80			; AS is ASS
		jmp	.fuck(pc,d1.w)		; jump to appropriate handler (false command)
; ===========================================================================
; ---------------------------------------------------------------------------
; Command handlers for meta commands
; ---------------------------------------------------------------------------

.meta
		bra.w	dcModOn			; FF 00 - Turn on Modulation (MOD_SET - MODS_ON)
		bra.w	dcModOff		; FF 04 - Turn off Modulation (MOD_SET - MODS_OFF)
		bra.w	dcsFreq			; FF 08 - Set channel frequency to xxxx (CHFREQ_SET)
		bra.w	dcsFreqNote		; FF 0C - Set channel frequency to note xx (CHFREQ_SET - FREQ_NOTE)
		bra.w	dcSpRev			; FF 10 - Increment spindash rev counter (SPINDASH_REV - SDREV_INC)
		bra.w	dcSpReset		; FF 14 - Reset spindash rev counter (SPINDASH_REV - SDREV_RESET)
		bra.w	dcaTempoShoes		; FF 18 - Add xx to music speed tempo (TEMPO - TEMPO_ADD_SPEED)
		bra.w	dcaTempo		; FF 1C - Add xx to music tempo (TEMPO - TEMPO_ADD)
		bra.w	dcCondReg		; FF 20 - Get RAM table offset by y, and chk zz with cond x (COMM_CONDITION - COMM_SPEC)
		bra.w	dcSound			; FF 24 - Play another music/sfx (SND_CMD)
		bra.w	dcsModFreq		; FF 28 - Set modulation frequency to xxxx (MOD_SET - MODS_FREQ)
		bra.w	dcsModReset		; FF 2C - Reset modulation data (MOD_SET - MODS_RESET)
		bra.w	dcSpecFM3		; FF 30 - Enable FM3 special mode (SPC_FM3)
		bra.w	dcFilter		; FF 34 - Set DAC filter bank. (DAC_FILTER)
		bra.w	dcBackup		; FF 38 - Load the last song from back-up (FADE_IN_SONG)
		bra.w	dcNoisePSG		; FF 3C - PSG4 mode to xx (PSG_NOISE - PNOIS_AMPS)
		bra.w	dcCSMOn			; FF 40 - Enable CSM mode with settings (SPC_FM3 - CSM_ON)
		bra.w	dcCSMOff		; FF 44 - Disable CSM mode (SPC_FM3 - CSM_OFF)
		bra.w	dcsModeADSR		; FF 48 - Set ADSR mode and restart ADSR instrument (ADSR - ADSR_MODE)
		bra.w	dcCont			; FF 4C - Do a continuous SFX loop (CONT_SFX)

	if FEATURE_MODTL
tlmod	macro name
	bra.w	name_1				; jump for operator 1
	bra.w	name_2				; jump for operator 2
	bra.w	name_3				; jump for operator 3
	bra.w	name_4				; jump for operator 4
    endm

		tlmod	dcModOffTL		; FF 5x - Turn off TL Modulation for operator x (TL_MOD - MODS_OFF)
		tlmod	dcModOnTL		; FF 6x - Turn on TL Modulation for operator x (TL_MOD - MODS_ON)
		tlmod	dcModTL			; FF 7x - Modulation for operator x (TL_MOD - MOD_SETUP)
		tlmod	dcVolEnvTL		; FF 8y - Set TL volume envelope to xx for operator y (TL_MOD - FM_VOLENV)
		tlmod	dcaVolTL		; FF 9y - Add xx to volume for operator y (TL_MOD - VOL_ADD_TL)
		tlmod	dcsVolTL		; FF Ay - Set volume to xx for operator y (TL_MOD - VOL_SET_TL)
	endif

		bra.w	dcsPortaFreq		; FF B0 - Set portamento target frequency to xxxx (PORTAMENTO_FREQ)
		bra.w	dcKeyOff		; FF B4 - Key off an FM channel without using a rest note (FM_KEYOFF)

	if safe=1
		bra.w	dcFreeze		; FF B8 - Freeze CPU. Debug flag (DEBUG_STOP_CPU)
		bra.w	dcTracker		; FF BC - Bring up tracker debugger at end of frame. Debug flag (DEBUG_PRINT_TRACKER)
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Command handlers for false condition execution
; ---------------------------------------------------------------------------

dcskip	macro amount
	if amount==0
		rts
	else
		addq.w	#amount,a2
	endif
	rts
   endm

.false
		dcskip	1			; E0 - Panning, AMS, FMS (PANAFMS - PAFMS_PAN)
		dcskip	1			; E1 - Set channel frequency displacement to xx (DETUNE_SET)
		dcskip	1			; E2 - Add xx to channel frequency displacement (DETUNE)
		dcskip	1			; E3 - Set channel pitch to xx (TRANSPOSE - TRNSP_SET)
		dcskip	1			; E4 - Add xx to channel pitch (TRANSPOSE - TRNSP_ADD)
		dcskip	1			; E5 -
		bra.w	dcFqFz			; E6 - Freeze frequency for the next note (FREQ_FREEZE)
		bra.w	dcHold			; E7 - Do not allow note on/off for next note (HOLD)
		dcskip	1			; E8 - Set Voice/sample/ADSR to xx (INSTRUMENT - INS_C_FM / INS_C_DAC / INS_C_ADSR)
		dcskip	1			; E9 - Set music speed shoes tempo to xx (TEMPO - TEMPO_SET_SPEED)
		dcskip	1			; EA - Set music tempo to xx (TEMPO - TEMPO_SET)
		dcskip	0			; EB - Use sample DAC mode (DAC_MODE - DACM_SAMP)
		dcskip	0			; EC - Use pitch DAC mode (DAC_MODE - DACM_NOTE)
		dcskip	1			; ED - Add xx to channel volume (VOLUME - VOL_CN_FM / VOL_CN_PSG / VOL_CN_DAC)
		dcskip	1			; EE - Set channel volume to xx (VOLUME - VOL_CN_ABS)
		dcskip	1			; EF - Set LFO (SET_LFO - LFO_AMSEN)
		dcskip	4			; F0 - Modulation (MOD_SETUP)
		dcskip	1			; F1 - Portamento enable/disable flag (PORTAMENTO)
		dcskip	1			; F2 - Set volume envelope to xx (INSTRUMENT - INS_C_PSG) (FM_VOLENV / DAC_VOLENV)
		dcskip	1			; F3 - Set modulation envelope to xx (MOD_ENV - MENV_GEN)
		bra.w	dcComplexTL		; F4 - Setup TL modulation for all operators according to parameter value (TL_MOD - MOD_COMPLEX)
		dcskip	0			; F5 - End of channel (TRK_END - TEND_STD)
		dcskip	2			; F6 - Jump to xxxx (GOTO)
		dcskip	4			; F7 - Loop back to zzzz yy times, xx being the loop index (LOOP)
		dcskip	2			; F8 - Call pattern at xxxx, saving return point (GOSUB)
		dcskip	0			; F9 - Return (RETURN)
		bra.w	dcsComm			; FA - Set communications byte yy to xx (SET_COMM - SPECIAL)
		bra.w	dcCond			; FB - Get comms byte y, and compare zz using condition x (COMM_CONDITION)
		bra.w	dcResetCond		; FC - Reset condition (COND_RESET)
		dcskip	1			; FD - Stop note after xx frames (NOTE_STOP - NSTOP_NORMAL
		dcskip	1			; FE - YM command (YMCMD)
		bra.w	.metacall		; FF - META
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for handling spindash revving
; The way spindash revving works, is it actually just increments a counter
; each time, and this counter is added into the channel pitch offset.
; ---------------------------------------------------------------------------

dcSpRev:
		move.b	mSpindash.w,d3		; load spindash rev counter to d3
		add.b	d3,cPitch(a1)		; add d3 to channel pitch offset

		cmp.b	#$C-1,d3		; check if this is the max pitch offset
		bhs.s	.rts			; if yes, skip
		addq.b	#1,mSpindash.w		; increment spindash rev counter

.rts
		rts
; ---------------------------------------------------------------------------

dcSpReset:
		clr.b	mSpindash.w		; reset spindash rev counter
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for changing channel panning
; ---------------------------------------------------------------------------

dcPan:
	if safe=1
		AMPS_Debug_dcPan		; check if this channel can pan
	endif

	; WARNING: FM6 is not properly implemented, so panning for FM6 WILL
	; break DAC channels and SFX DAC channels. Please be careful!

		moveq	#$37,d3			; prepare bits to keep
		and.b	cPanning(a1),d3		; and with channel LFO settings
		or.b	(a2)+,d3		; OR panning value
		move.b	d3,cPanning(a1)		; save as channel panning

		btst	#ctbDAC,cType(a1)	; check if this is a DAC channel
		bne.s	.dac			; if yes, branch
		btst	#cfbInt,(a1)		; check if interrupted by SFX
		bne.s	.rts			; if yes, do not update

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.s	.nosm			; if not, do normal code
	WriteYM1	#$B6, d3		; Panning and LFO: FM3

		move.b	d3,mFM3op1+cPanning.w	; copy panning to op1
		rts
; ---------------------------------------------------------------------------

.nosm
	endif

	CheckCue				; check that YM cue is valid
	InitChYM				; prepare to write to channel-specific YM channel
	stopZ80
	WriteChYM	#$B4, d3		; Panning & LFO
	;	st	(a0)			; write end marker
	startZ80

.rts
		rts
; ---------------------------------------------------------------------------
; Since the DAC channels have OR based panning behavior, we need this
; piece of code to update its panning
; ---------------------------------------------------------------------------

.dac
		move.b	mDAC1+cPanning.w,d3	; read panning value from music DAC1
		btst	#cfbInt,mDAC1+cFlags.w	; check if music DAC1 is interrupted by SFX
		beq.s	.nodacsfx		; if not, use music DAC1 panning
		move.b	mSFXDAC1+cPanning.w,d3	; read panning value from SFX DAC1

.nodacsfx
		or.b	mDAC2+cPanning.w,d3	; OR the panning value from music DAC2
	CheckCue				; check that YM cue is valid
	stopZ80
	WriteYM2	#$B6, d3		; Panning & LFO
	;	st	(a0)			; write end marker
	startZ80
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for changing detune offset
; ---------------------------------------------------------------------------

dcaDetune:
		move.b	(a2)+,d3		; load detune offset from tracker
		add.b	d3,cDetune(a1)		; Add to channel detune
		rts
; ---------------------------------------------------------------------------

dcsDetune:
		move.b	(a2)+,cDetune(a1)	; load detune offset from tracker to channel
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for changing channel volume
; ---------------------------------------------------------------------------

dcaVolume:
		move.b	(a2)+,d3		; load volume from tracker
		add.b	d3,cVolume(a1)		; add to channel volume
		bset	#cfbVol,(a1)		; set volume update flag
		rts
; ---------------------------------------------------------------------------

dcsVolume:
		move.b	(a2)+,cVolume(a1)	; load volume from tracker to channel
		bset	#cfbVol,(a1)		; set volume update flag
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting DAC to sample mode and resetting frequency
; ---------------------------------------------------------------------------

dcSampDAC:
		move.w	#$100,cFreq(a1)		; reset to default base frequency
		bclr	#cfbMode,(a1)		; enable sample mode
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting DAC to pitch mode
; ---------------------------------------------------------------------------

dcPitchDAC:
		bset	#cfbMode,(a1)		; enable pitch mode
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for enabling or disabling the hold flag
; ---------------------------------------------------------------------------

dcHold:
		bchg	#mfbHold,mExtraFlags.w	; flip the channel hold flag
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for enabling or disabling the frequency freeze flag
; ---------------------------------------------------------------------------

dcFqFz:
		bchg	#cfbFreqFrz,(a1)	; flip the channel frequency freeze flag
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for enabling or disabling note gate
; ---------------------------------------------------------------------------

dcGate:
	if safe=1
		AMPS_Debug_dcGate		; check if this channel has gate support
	endif

		move.b	(a2),cGateMain(a1)	; load note gate from tracker to channel
		move.b	(a2)+,cGateCur(a1)	; ''
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for changing channel pitch
; ---------------------------------------------------------------------------

dcaTransp:
		move.b	(a2)+,d3		; load pitch offset from tracker
		add.b	d3,cPitch(a1)		; add to channel pitch
		rts
; ---------------------------------------------------------------------------

dcsTransp:
		move.b	(a2)+,cPitch(a1)	; load pitch offset from tracker to channel
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for tempo control
; ---------------------------------------------------------------------------

dcsTempoShoes:
	dREAD_WORD	a2, d3			; load tempo value from tracker
		move.w	d3,mTempoSpeed.w	; save as the speed shoes tempo
		btst	#mfbSpeed,mFlags.w	; check if speed shoes mode is active
		bne.s	dcsTempoCur		; if is, load as current tempo too
		rts
; ---------------------------------------------------------------------------

dcsTempo:
	dREAD_WORD	a2, d3			; load tempo value from tracker
		move.w	d3,mTempoMain.w		; save as the main tempo
		btst	#mfbSpeed,mFlags.w	; check if speed shoes mode is active
		bne.s	locret_Tempo		; if not, load as current tempo too

dcsTempoCur:
		move.w	d3,mTempo.w		; save as current tempo

locret_Tempo:
		rts
; ---------------------------------------------------------------------------

dcaTempoShoes:
		move.b	(a2)+,d3		; load tempo value from tracker
		ext.w	d3			; extend to word
		add.w	d3,mTempoSpeed.w	; add to the speed shoes tempo

		btst	#mfbSpeed,mFlags.w	; check if speed shoes mode is active
		bne.s	dcaTempoCur		; if is, add to current tempo too
		rts
; ---------------------------------------------------------------------------

dcaTempo:
		move.b	(a2)+,d3		; load tempo value from tracker
		ext.w	d3			; extend to word
		add.w	d3,mTempoMain.w		; add to the main tempo

		btst	#mfbSpeed,mFlags.w	; check if speed shoes mode is active
		bne.s	locret_Tempo		; if not, add to current tempo too

dcaTempoCur:
		add.w	d3,mTempo.w		; add to current tempo
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for enabling or disabling PSG4 noise mode
; ---------------------------------------------------------------------------

dcNoisePSG:
		move.b	(a2)+,d3		; load PSG4 status to d3
	if safe=1
		AMPS_Debug_dcNoisePSG		; check if this is a PSG3 channel
	endif

		move.b	d3,cStatPSG4(a1)	; save status
		beq.s	.psg3			; if disabling PSG4 mode, branch
		move.b	#ctPSG4,cType(a1)	; make PSG3 act on behalf of PSG4
		move.b	d3,dPSG			; send command to PSG port
		rts
; ---------------------------------------------------------------------------

.psg3
		move.b	#ctPSG3,cType(a1)	; make PSG3 not act on behalf of PSG4
		move.b	#ctPSG4|$1F,dPSG	; send PSG4 mute command to PSG
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for playing another sound
; ---------------------------------------------------------------------------

dcSound:
		move.b	(a2)+,mQueue.w		; load sound ID from tracker to sound queue

Return_dcSound:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting DAC filter bank
; ---------------------------------------------------------------------------

dcFilter:
		move.b	(a2)+,d4		; load filter bank number from tracker
		jmp	dSetFilter(pc)		; update filter bank instructions to Z80 RAM
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for writing a YM command to YMCue
; ---------------------------------------------------------------------------

dcYM:
		move.b	(a2)+,d3		; load YM address from tracker to d3
		move.b	(a2)+,d1		; get command value from tracker to d1
		btst	#cfbInt,(a1)		; is this channel overridden by SFX?
		bne.s	Return_dcSound		; if so, skip

	CheckCue				; check that cue is valid
		cmp.b	#$30,d3			; is this register 00-2F?
		blo.s	.pt1			; if so, write to part 1 always

		move.b	d3,d4			; copy address to d4
		sub.b	#$A8,d4			; align $A8 with 0
		cmp.b	#$08,d4			; is this register A8-AF?
		blo.s	.pt1			; if so, write to part 1 always

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		bne.s	.dosm			; if yes, do special code
	endif

	InitChYM				; prepare to write to YM channel
	stopZ80
	WriteChYM	d3, d1			; write to the channel
	;	st	(a0)			; write end marker
	startZ80
		rts
; ---------------------------------------------------------------------------

	if FEATURE_FM3SM
.dosm
		addq.b	#2,d3			; set to FM3 command
	endif
; ---------------------------------------------------------------------------

.pt1
	stopZ80
	WriteYM1	d3, d1			; write register to YM1
	;	st	(a0)			; write end marker
	startZ80
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting channel base frequency
; ---------------------------------------------------------------------------

dcsFreq:
		move.b	(a2)+,cFreq(a1)		; load base frequency from tracker to channel
		move.b	(a2)+,cFreq+1(a1)	; ''

	if safe=1
		btst	#ctbDAC,cType(a1)	; check if this is a DAC channel
		bne.s	.rts			; if so, branch
		AMPS_Debug_dcInvalid		; this command should be only used with DAC channels
	endif
.rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting channel base frequency from the note table
; ---------------------------------------------------------------------------

dcsFreqNote:
		moveq	#0,d4
		move.b	(a2)+,d4		; load note from tracker to d4
		add.b	cPitch(a1),d4		; add pitch offset to note
		add.w	d4,d4			; double offset (each entry is a word)

		lea	dFreqDAC(pc),a4		; load DAC frequency table to a4
		move.w	(a4,d4.w),cFreq(a1)	; load and save the requested frequency

	if safe=1
		btst	#ctbDAC,cType(a1)	; check if this is a DAC channel
		bne.s	.rts			; if so, branch
		AMPS_Debug_dcInvalid		; this command should be only used with DAC channels
	endif
.rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting portamento frequency target
; ---------------------------------------------------------------------------

dcsPortaFreq:
		move.b	(a2)+,cPortaTarget(a1)	; load base frequency from tracker to channel
		move.b	(a2)+,cPortaTarget+1(a1); ''
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting portamento frequency target from the note table
; ---------------------------------------------------------------------------

dcsPortaFreqNote:
		lea	dFreqPSG(pc),a4		; load PSG frequency table to a4
		tst.b	cType(a1)		; check if this is a PSG channel
		bmi.s	.freqgot		; if yes, branch

		lea	dFreqFM(pc),a4		; load FM frequency table to a4
		btst	#ctbDAC,cType(a1)	; check if this is a DAC channel
		beq.s	.freqgot		; if not, branch
		lea	dFreqDAc(pc),a4		; load DAC frequency table to a4
; ---------------------------------------------------------------------------

.freqgot
		moveq	#0,d4
		move.b	(a2)+,d4		; load note from tracker to d4
		add.b	cPitch(a1),d4		; add pitch offset to note
		add.w	d4,d4			; double offset (each entry is a word)

		move.w	(a4,d4.w),cPortaTarget(a1); load and save the requested frequency
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for doing a continous SFX loop
; ---------------------------------------------------------------------------

dcCont:
		subq.b	#1,mContCtr.w		; decrease continous loop counter
		bpl.s	dcJump			; if positive, jump to routine
		clr.b	mContLast.w		; clear continous SFX ID
		addq.w	#2,a2			; skip over jump offset
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for calling a tracker routine
; ---------------------------------------------------------------------------

dcCall:
	if safe=1
		AMPS_Debug_dcCall1		; check if this channel supports the stack
	endif

		moveq	#0,d4
		move.b	cStack(a1),d4		; get channel stack pointer
		subq.b	#4,d4			; allocate space for another routine

	if safe=1
		AMPS_Debug_dcCall2		; check if we overflowed the space
	endif

		move.l	a2,(a1,d4.w)		; save current address in stack
		move.b	d4,cStack(a1)		; save stack pointer
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for jumping to another tracker routine
; ---------------------------------------------------------------------------

dcJump:
	dREAD_WORD a2, d4			; read a word from tracker to d4
		adda.w	d4,a2			; offset tracker address by d4
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for handling loops
; ---------------------------------------------------------------------------

dcLoop:
		moveq	#0,d4
		move.b	(a2)+,d4		; load loop index from tracker to d4

	if safe=1
		AMPS_Debug_dcLoop		; check if loop index is valid
	endif

		tst.b	cLoop(a1,d4.w)		; check the loop counter
		bne.s	.loopok			; if nonzero, branch
		move.b	2(a2),cLoop(a1,d4.w)	; reload loop counter
		bra.s	dcJump			; jump to routine
; ---------------------------------------------------------------------------

.loopok
		subq.b	#1,cLoop(a1,d4.w)	; decrease loop counter
		bne.s	dcJump			; if not 0, jump to routine
		addq.w	#3,a2			; skip over jump offset
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for returning from tracker routine
; ---------------------------------------------------------------------------

dcReturn:
	if safe=1
		AMPS_Debug_dcReturn1		; check if this channel supports the stack
	endif

		moveq	#4,d3			; deallocate stack space
		add.b	cStack(a1),d3		; add the channel stack pointer to d3
		move.b	d3,cStack(a1)		; save stack pointer

		movea.l	-4(a1,d3.w),a2		; load the address to return to
		addq.w	#2,a2			; skip the call address parameter

	if safe=1
		AMPS_Debug_dcReturn2		; check if we underflowed the space
	endif
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for initializing portamento
; ---------------------------------------------------------------------------

dcPortamento:
	if FEATURE_PORTAMENTO
		bset	#mfbPortaSet,mExtraFlags.w; do not reset portamento (even if this disables portamento, its safe to ignore reset!)
		move.b	(a2)+,cPortaDisp(a1)	; load the portamento displacement value
		move.b	(a2)+,cPortaDisp+1(a1)	; load the portamento displacement value

		tst.w	cPortaDisp(a1)		; check resulting displacement
		bne.s	.rts			; if non-zero, branch
		clr.w	cPortaTarget(a1)	; clear portamento target

.rts
		rts

	elseif safe=1
		AMPS_Debug_dcPortamento		; display an error if disabled
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for initializing modulation
; ---------------------------------------------------------------------------

dcMod68K:
	if FEATURE_MODULATION
		tst.b	cModSpeed(a1)		; check if modulation is active
		bne.s	.noreset		; if is, then do not reset offset
		clr.w	cModFreq(a1)		; reset modulation offset

.noreset
		move.l	a2,cMod(a1)		; set modulation data address
		move.b	(a2)+,cModSpeed(a1)	; copy speed

		move.b	(a2)+,d1		; get number of steps
		lsr.b	#1,d1			; halve it
		bne.s	.set			; if result is not 0, branch
		moveq	#1,d1			; use 1 is the initial count, not 0!

.set
		move.b	d1,cModCount(a1)	; save as the current number of steps
		move.b	(a2)+,cModStep(a1)	; copy step offset
		move.b	(a2)+,cModDelay(a1)	; copy delay
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for enabling and disabling modulation
; ---------------------------------------------------------------------------

dcModOn:
	if FEATURE_MODULATION
		tst.b	cModSpeed(a1)		; check if already enabled
		bne.s	.rts			; if so, do not mess with the settings
		move.b	#1,cModSpeed(a1)	; enable modulation (step immediately)

.rts
		rts
	endif

dcModOff:
	if FEATURE_MODULATION
		clr.b	cModSpeed(a1)		; disable modulation
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting modulation frequency
; ---------------------------------------------------------------------------

dcsModFreq:
	if FEATURE_MODULATION
		move.b	(a2)+,cModFreq(a1)	; load modulating frequency from tracker to channel
		move.b	(a2)+,cModFreq+1(a1)	; ''
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for resetting modulation
; ---------------------------------------------------------------------------

dcsModReset:
	if FEATURE_MODULATION
		clr.w	cModFreq(a1)		; clear frequency offset
		tst.b	cModSpeed(a1)		; check if enabled
		beq.s	.rts			; if not, do not load settings

		move.l	cMod(a1),a4		; get modulation data address
		move.b	(a4)+,cModSpeed(a1)	; copy speed

		move.b	(a4)+,d4		; get number of steps
		lsr.b	#1,d4			; halve it
		move.b	d4,cModCount(a1)	; save as the current number of steps

		move.b	(a4)+,cModStep(a1)	; copy step offset
		move.b	(a4)+,cModDelay(a1)	; copy delay

.rts
		rts

	elseif safe=1
		AMPS_Debug_dcModulate		; display an error if disabled
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for initializing special FM3 mode
; ---------------------------------------------------------------------------

dcSpecFM3:
	if FEATURE_FM3SM
	dREAD_WORD	a2,d1			; load the address of op2
		tst.w	d1			; check if 0
		bne.s	.enable			; if not, enable FM3 special mode

		move.b	#ctFM3,mFM3op1+cType.w	; set FM3 type back to FM3
	dSetFM3SM	#$00			; disable FM3 special mode

		lea	mFM3op3.w,a4		; clear starting from FM3 op 3
	dCLEAR_MEM	mFM4-mFM3op3, 16	; til FM3 op 4
		rts

.enable
		move.b	#ctFM3op1,mFM3op1+cType.w; set FM3 type to FM3 special mode operator 1
		move.b	#$F0|ctFM3,mFM3keyMask.w; set key mask to enable all registers

		moveq	#$40,d3			; prepare FM3 enable to d3
		move.b	d3,mStatFM3.w		; set that as FM3 status
	dSetFM3SM	d3			; enable FM3 special mode

copychFM3SM	macro ch, type
	move.w	#((1<<cfbRun)|(1<<cfbVol)|(1<<cfbRest))<<8|type,ch+cFlags.w; enable channel tracker and set type
	move.l	a4,ch+cData.w			; save data address

	move.b	#cSize,ch+cStack.w		; set stack address
	move.b	#1,ch+cDuration.w		; set duration to expire next frame

	move.b	mFM3op1+cDetune.w,ch+cDetune.w	; copy detune
	move.w	mFM3op1+cPitch.w,ch+cPitch.w	; copy transposition and volume
	move.b	mFM3op1+cVoice.w,ch+cVoice.w	; copy voice (DOES NOT UPDATE IT!!)
	move.b	mFM3op1+cLastDur.w,ch+cLastDur.w; copy last duration
	move.w	mFM3op1+cFreq.w,ch+cFreq.w	; copy frequency
	move.w	mFM3op1+cGateCur.w,ch+cGateCur.w; copy note gate
    endm

    		move.l	a2,a4			; copy tracker address to a4
		add.w	d1,a4			; add offset to address
	copychFM3SM	mFM3op3, ctFM3op3

	dREAD_WORD	a2,d1			; load offset to d1
    		move.l	a2,a4			; copy tracker address to a4
		add.w	d1,a4			; add offset to address
	copychFM3SM	mFM3op2, ctFM3op2

	dREAD_WORD	a2,d1			; load offset to d1
    		move.l	a2,a4			; copy tracker address to a4
		add.w	d1,a4			; add offset to address
	copychFM3SM	mFM3op4, ctFM3op4
		rts

	elseif safe=1
		AMPS_Debug_dcSpecFM3		; this is an invalid command
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting volume envelope ID
; ---------------------------------------------------------------------------

dcVolEnv:
	if (FEATURE_DACFMVOLENV=0)&(safe=1)
		AMPS_Debug_dcVolEnv		; display an error if an invalid channel attempts to load a volume envelope
	endif

		move.b	(a2)+,cVolEnv(a1)	; load the volume envelope ID
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting modulation envelope ID
; ---------------------------------------------------------------------------

dcModEnv:
	if FEATURE_MODENV
		move.b	(a2)+,cModEnv(a1)	; load the modulation envelope ID
		rts

	elseif safe=1
		AMPS_Debug_dcModEnv		; display an error if disabled
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting the ADSR mode bits
; ---------------------------------------------------------------------------

dcsModeADSR:
	if FEATURE_PSGADSR
		tst.b	cType(a1)		; check if this is a PSG channel
		bpl.s	.error			; if not, error
		move.b	(a2)+,(a3)		; set new mode
		rts

.error
		illegal

	elseif safe=1
		illegal
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for keying off the current (FM) channel
; ---------------------------------------------------------------------------

dcKeyOff:
		cmp.b	#1<<ctbDAC,cType(a1)	; check if this is a FM channel
		bhs.s	.error			; if any other channel type, ignore
		bset	#mfbNoKey,mExtraFlags.w	; no key enable
		btst	#cfbInt,(a1)		; check if overridden by sfx
		bne.s	.rts			; if so, do not note off

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		bne.s	.fm3sm			; if yes, run special update code!
	endif
		jmp	dKeyOffFM3(pc)		; key off this channel now
; ---------------------------------------------------------------------------

.error
		illegal
; ---------------------------------------------------------------------------

	if FEATURE_FM3SM
.fm3sm
		; no FM3 special mode support yet
	endif

.rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for loading a backed up track
; ---------------------------------------------------------------------------

dcBackup:
	if FEATURE_BACKUP
		addq.l	#4,sp			; stop the other channels from playing
		btst	#mfbBacked,mFlags.w	; check if there is a backed up track
		beq.w	dPlaySnd_Stop		; if not, just stop all music instead.
		jsr	dPlaySnd_Stop(pc)	; gotta do it anyway tho but continue below
; ---------------------------------------------------------------------------
; The reason we do fade in right here instead of later, is so we can update
; the FM voices with correct volume, no need to update volume later
; ---------------------------------------------------------------------------

		lea	dFadeInDataLog(pc),a4	; prepare stock fade in program to a4
		jsr	dLoadFade(pc)		; initiate fade in

		move.l	mBackTempoMain.w,mTempoMain.w; restore tempo settings
		move.l	mBackTempo.w,mTempo.w	; restore tempo settings
		move.l	mBackVctMus.w,mVctMus.w	; restore voice table address

		lea	mBackUpLoc.w,a4		; load source address to a4
		lea	mBackUpArea.w,a3	; load destination address to a3
		move.w	#(mSFXDAC1-mBackUpArea)/4-1,d4; load backup size to d4

.backup
		move.l	(a4),(a3)+		; restore data for each channel
		clr.l	(a4)+			; clear back-up RAM
		dbf	d4,.backup		; loop for each longword

	if (mSFXDAC1-mDAC1)&2
		move.w	(a4),(a3)+		; restore data for each channel
		clr.w	(a4)+			; clear back-up RAM
	endif
; ---------------------------------------------------------------------------
; We clear the PCM 1 & 2 volume tables to 0 to prevent any sound being
; accidentally generated. This costs a bit of CPU time but ensures that
; the volume is forced to minimum and there is no chance any wrong noise
; plays before fade in starts
; ---------------------------------------------------------------------------

		lea	dZ80+PCM_Volume1.l,a4	; get Z80 volume table to a4
		moveq	#($200/16)-1,d3		; get repeat count to d3 (clear both tables!)
		moveq	#0,d4			; prepare 0
	stopZ80

.volloop
	rept 16					; clear 1 byte at a time
		move.b	d4,(a4)+		; but! Clear 16 bytes per loop!
	endm					; this actually saves some cycles
		dbf	d3,.volloop		; loop for all bytes

		moveq	#$7F,d3			; prepare max volume to d2
		move.b	d3,dZ80+PCM1_VolumeCur+1.l; set PCM1 volume as mute
		move.b	d3,dZ80+PCM2_VolumeCur+1.l; set PCM2 volume as mute
	startZ80
; ---------------------------------------------------------------------------
; Special logic to handle PSG4
; ---------------------------------------------------------------------------

		move.b	#ctPSG4|$1F,dPSG.l	; mute PSG4
	if FEATURE_PSG4
		tst.b	mPSG4.w			; check if PSG4 is running
		bpl.s	.cpsg3			; if not, skip
		move.b	mPSG4+cStatPSG4.w,dPSG.l; update PSG4 status to PSG port
		bset	#cfbVol,mPSG4+cFlags.w	; set volume update flag
		bra.s	.dofm

.cpsg3
	endif

		cmp.b	#ctPSG4,mPSG3+cType.w	; check if PSG3 channel is in PSG4 mode
		bne.s	.dofm			; if not, skip
		move.b	mPSG3+cStatPSG4.w,dPSG.l; update PSG4 status to PSG port
		bset	#cfbVol,mPSG4+cFlags.w	; set volume update flag
; ---------------------------------------------------------------------------
; The FM instruments need to be updated! Since this process includes volume
; updates, they do not need to be done later...
; ---------------------------------------------------------------------------

.dofm
		lea	mFM1.w,a1		; start at music FM1
		moveq	#Mus_FM-1,d0		; load FM channel count to d0
	if FEATURE_MODTL
		lea	mTL-toSize4.w,a3	; load FM1 TL modulation data to a3
	endif

.fmloop
		tst.b	(a1)			; check if channel is running
		bpl.s	.nofm			; if not, skip it

		moveq	#0,d4
		move.b	cVoice(a1),d4		; load FM voice ID of the channel to d4
		bsr.s	dUpdateVoiceFM		; update FM voice for each channel

.nofm
	if FEATURE_MODTL
		if FEATURE_FM3SM		; TODO: Terrible code ahead! =(
			cmp.w	#mFM3op3,a1	; check if this is FM3 op3 or greater
			ble.s	.doadd		; if not, branch
			cmp.w	#mFM4,a1	; check if this is FM4 or greater
			ble.s	.dontadd	; if not, skip

.doadd
		endif

		add.w	#toSize4,a3		; go to the TL data
.dontadd
	endif
		add.w	#cSize,a1		; advance to next channel
		dbf	d0,.fmloop		; loop for all FM channels

	elseif safe=1
		AMPS_Debug_dcBackup
	endif

locret_Backup:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for changing voice, volume envelope or sample
; ---------------------------------------------------------------------------

dcVoice:
		moveq	#0,d4
		move.b	(a2)+,d4		; load voice/sample/volume envelope from tracker to d1
		move.b	d4,cVoice(a1)		; save to channel

		tst.b	cType(a1)		; check if this is a PSG channel
	if FEATURE_PSGADSR
		bpl.s	.noPSG			; branch if not

		lsl.w	#3,d4			; multiply offset by 8
		lea	dBankADSR(pc),a4	; load ADSR bank address to a4
		bset	#cfbVol,(a1)		; force volume update

		move.w	#$7F00,d5		; prepare d5 with the volume
		move.b	(a4,d4.w),d5		; load the mode to d5
		move.w	d5,(a3)			; save volume and flags to ADSR
		rts

.noPSG
	else
		bmi.s	locret_Backup		; if is, skip
	endif

		btst	#ctbDAC,cType(a1)	; check if this is a DAC channel
		bne.s	locret_Backup		; if is, skip
		btst	#cfbInt,(a1)		; check if channel is interrupted by SFX
		bne.s	locret_Backup		; if is, skip

	; continue to send FM voice
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for sending the FM voice to YM2612
; This routine is speed optimized in a way that allows Dual PCM
; to only be stopped for as long as it must be. This will waste
; some cycles for 68000, but it will help improve DAC quality
; ---------------------------------------------------------------------------
;
; input:
;   a1 - Channel to operate on
;   a3 - Address to TL modulation data
;   d4 - Voice ID to use
; thrash:
;   a2 - Used maybe for TL modulation
;   a4 - Used for voice data address
;   a5 - Used to write data to stack so we can write it to Z80 later
;   a6 - TL volume address
;   d1 - Used for dbf counters
;   d2 - Used to store the channel type
;   d3 - Used to calculate registers
;   d4 - Used to store feedback&algorithm
;   d5 - Used for TL calculations
;   d6 - Used for modulator offset
; ---------------------------------------------------------------------------

dWriteReg	macro	offset, reg
._x :=		offset
	if "reg"<>""
		move.b	(a4)+,(a5)+		; write value to buffer
		moveq	#signextendB(reg),d3			; load register to d3
		or.b	d2,d3			; add channel offset to register
		move.b	d3,(a5)+		; write register to buffer

		if offset>1
			addq.w	#offset-1,a4	; offset a4 by specific amount
		endif

		shift				; shift the next argument to view
		shift				; ''
		dWriteReg ._x, ALLARGS		; get the next argument
	endif
    endm
; ---------------------------------------------------------------------------

dUpdateVoiceFM:
		move.l	a2,-(sp)		; save the tracker address to stack
	if FEATURE_MODTL
		move.w	a3,d6			; save the TL data to stack
		swap	d6			; swap to upper word
	endif

	dCALC_BANK	0			; get the voice table address to a4
	dCALC_VOICE				; get address of the specific voice to a4

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		bne.w	dUpdateVoiceFM3		; if yes, run special update code!
	endif
; ---------------------------------------------------------------------------

		sub.w	#(VoiceRegs+1)*2,sp	; prepapre space in the stack
		move.l	sp,a5			; copy pointer to the free space to a5

		move.b	cType(a1),d2		; load channel type to d2
		and.b	#3,d2			; keep in range

		move.b	(a4)+,d4		; load feedback and algorithm to d4
		move.b	d4,(a5)+		; save it to free space
		moveq	#signextendB($B0),d3			; YM command: Algorithm & FeedBack
		or.b	d2,d3			; add channel offset to register
		move.b	d3,(a5)+		; write register to buffer

	dWriteReg	0, $30, $38, $34, $3C	; Detune, Multiple
	dWriteReg	0, $50, $58, $54, $5C	; Rate Scale, Attack Rate
	dWriteReg	0, $60, $68, $64, $6C	; Decay 1 Rate
	dWriteReg	0, $70, $78, $74, $7C	; Decay 2 Rate
	dWriteReg	0, $80, $88, $84, $8C	; Decay 1 level, Release Rate
	dWriteReg	0, $90, $98, $94, $9C	; SSG-EG
; ---------------------------------------------------------------------------

		move.w	#$4000,d3		; set volume to muted
		moveq	#4-1,d1			; prepare 4 operators to d1
		btst	#cfbDisabl,(a1)		; check if channel is disabled
		bne.s	.disabled		; if is, branch

		move.b	cVolume(a1),d3		; load FM channel volume to d3
		ext.w	d3			; extend to word

.disabled

	if FEATURE_SFX_MASTERVOL=0
		cmpa.w	#mSFXDAC1,a1		; is this a SFX channel
		bhs.s	.noover			; if so, do not add master volume!
	endif

		move.b	mMasterVolFM.w,d6	; load master FM volume to d6
		ext.w	d6			; extend to word
		add.w	d6,d3			; add to volume

.noover
	if FEATURE_UNDERWATER
		clr.w	d6			; no underwater 4 u

		btst	#mfbWater,mExtraFlags.w	; check if underwater mode is enabled
		beq.s	.uwdone			; if not, skip
		lea	dUnderwaterTbl(pc),a6	; get underwater table to a6

		and.w	#7,d4			; mask out everything but the algorithm
		move.b	(a6,d4.w),d4		; get the value from table
		move.b	d4,d6			; copy to d6
		and.w	#7,d4			; mask out extra stuff
		add.w	d4,d3			; add algorithm to Total Level carrier offset

.uwdone
	endif
; ---------------------------------------------------------------------------

		lea	dOpTLFM(pc),a6		; load TL registers to a6

.tlloop
		move.b	(a4)+,d5		; get Total Level value from voice to d5
		ext.w	d5			; extend to word
		bpl.s	.noslot			; if slot operator bit was not set, branch

		and.w	#$7F,d5			; get rid of sign bit (ugh)
		add.w	d3,d5			; add carrier offset to loaded value
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
	endif

		cmp.w	#$80,d5			; check if volume is out of range
		bls.s	.nocap			; if not, branch
		spl	d5			; if positive (above $7F), set to $FF. Otherwise, set to $00

.nocap
		move.b	d5,(a5)+		; save the Total Level value
		move.b	(a6)+,d4		; load register to d4
		or.b	d2,d4			; add channel offset to register
		move.b	d4,(a5)+		; write register to buffer

	if FEATURE_MODTL
		add.w	#toSize,a3		; go to next operator
	endif
		dbf	d1,.tlloop		; repeat for each Total Level operator

	if safe=1
		AMPS_Debug_UpdVoiceFM		; check if the voice was valid
	endif
; ---------------------------------------------------------------------------

		move.b	cPanning(a1),(a5)+	; copy panning value to free space
		moveq	#signextendB($B4),d3			; YM command: Panning & LFO
		or.b	d2,d3			; add channel offset to register
		move.b	d3,(a5)+		; write register to buffer

		move.b	cType(a1),d2		; load FM channel type to d2
		lsr.b	#1,d2			; halve part value
		and.b	#2,d2			; clear extra bits away

.ptok
		move.l	sp,a5			; copy free space pointer to a5 again
	if safe=1
		AMPS_Debug_CuePtr 0		; make sure cue is valid
	endif
	StopZ80					; wait for Z80 to stop

.write
	rept VoiceRegs+1
		move.b	d2,(a0)+		; select YM port to access (4000 or 4002)
		move.b	(a5)+,(a0)+		; write values
		move.b	(a5)+,(a0)+		; write registers
	endm

	;	st	(a0)			; mark as end of the cue
	StartZ80				; enable Z80 execution
		move.l	a5,sp			; fix stack pointer

	if FEATURE_MODTL
		swap	d6			; swap to lower word
		move.w	d6,a3			; load TL data back from stack
	endif

		bclr	#cfbVol,(a1)		; reset volume update request flag
		move.l	(sp)+,a2		; load the tracker address from stack
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine for sending the FM voice to YM2612
;
; input:
;   a1 - Channel to operate on
;   a3 - Address to TL modulation data
;   a4 - Voice data address
;   d4 - Voice ID to use
; thrash:
;   a2 - Used maybe for TL modulation
;   a5 - Used to write data to stack so we can write it to Z80 later
;   a6 - TL volume address
;   d1 - Used to store channel type
;   d2 - Used to store the channel type
;   d3 - Used to calculate registers
;   d4 - Used to store feedback&algorithm
;   d5 - Used for TL calculations
;   d6 - Used for modulator offset
; ---------------------------------------------------------------------------

	if FEATURE_FM3SM
dUpdVcFM3tbl:	dc.b 2, $A, 6, $E		; table to translate cType to operator offset
; ---------------------------------------------------------------------------

dUpdateVoiceFM3:
		sub.w	#(VoiceRegsSM+1)*2,sp	; prepapre space in the stack
		move.l	sp,a5			; copy pointer to the free space to a5

		move.b	(a4)+,d4		; load feedback and algorithm to d4
		move.b	d4,(a5)+		; save it to free space

		move.b	cType(a1),d2		; load channel type to d2
		and.w	#3,d2			; keep in range
		add.w	d2,a4			; get the appropriate op byte

	if FEATURE_MODTL
		move.w	d2,d1			; copy value to d1
	endif
		move.b	dUpdVcFM3tbl(pc,d2.w),d2; load the right offset from table

		moveq	#signextendB($B0),d3			; YM command: Algorithm & FeedBack
		or.b	d2,d3			; add channel offset to register
		move.b	d3,(a5)+		; write register to buffer

	dWriteReg	4, $30, $50, $60	; Detune, Multiple - Rate Scale, Attack Rate - Decay 1 Rate
	dWriteReg	4, $70, $80, $90	; Decay 2 Rate - Decay 1 level, Release Rate - SSG-EG
; ---------------------------------------------------------------------------

	if FEATURE_MODTL
		add.w	d1,d1			; double offset
		lea	dModTLFM3(pc),a3	; prepare table to a3
		move.w	(a3,d1.w),a3		; load the RAM address to use
	endif

		move.w	#$4000,d3		; set volume to muted
		btst	#cfbDisabl,(a1)		; check if channel is disabled
		bne.s	.disabled		; if is, branch

		move.b	cVolume(a1),d3		; load FM channel volume to d3
		ext.w	d3			; extend to word

.disabled

;	if FEATURE_SFX_MASTERVOL=0
;		cmpa.w	#mSFXDAC1,a1		; is this a SFX channel
;		bhs.s	.noover			; if so, do not add master volume!
;	endif

		move.b	mMasterVolFM.w,d6	; load master FM volume to d6
		ext.w	d6			; extend to word
		add.w	d6,d3			; add to volume

.noover
	if FEATURE_UNDERWATER
		clr.w	d6			; no underwater 4 u

		btst	#mfbWater,mExtraFlags.w	; check if underwater mode is enabled
		beq.s	.uwdone			; if not, skip
		lea	dUnderwaterTbl(pc),a6	; get underwater table to a6

		and.w	#7,d4			; mask out everything but the algorithm
		move.b	(a6,d4.w),d4		; get the value from table
		move.b	d4,d6			; copy to d6
		and.w	#7,d4			; mask out extra stuff
		add.w	d4,d3			; add algorithm to Total Level carrier offset

.uwdone
	endif
; ---------------------------------------------------------------------------

		move.b	(a4)+,d5		; get Total Level value from voice to d5
		ext.w	d5			; extend to word
		bpl.s	.noslot			; if slot operator bit was not set, branch

		and.w	#$7F,d5			; get rid of sign bit (ugh)
		add.w	d3,d5			; add carrier offset to loaded value
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
	endif

		cmp.w	#$80,d5			; check if volume is out of range
		bls.s	.nocap			; if not, branch
		spl	d5			; if positive (above $7F), set to $FF. Otherwise, set to $00

.nocap
		move.b	d5,(a5)+		; save the Total Level value
		moveq	#$40,d3			; load TL operator 1 value to d3
		or.b	d2,d3			; add channel offset to register
		move.b	d3,(a5)+		; write register to buffer

	if safe=1
		move.b	cType(a1),d3		; load channel type to d3
		and.w	#3,d3			; get only channel offset
		eor.w	#3,d3			; swap bits (add remaining space)
		add.w	d3,a4			; align voice
		AMPS_Debug_UpdVoiceFM		; check if the voice was valid
	endif
; ---------------------------------------------------------------------------

		move.b	mFM3op1+cPanning.w,(a5)+; copy panning value to free space
		move.b	#$B4+2,(a5)+		; write register to buffer
		move.l	sp,a5			; copy free space pointer to a5 again

	if safe=1
		AMPS_Debug_CuePtr 0		; make sure cue is valid
	endif
	StopZ80					; wait for Z80 to stop

.write
	rept VoiceRegsSM+1
		clr.b	(a0)+			; select YM port to access (4000 or 4002)
		move.b	(a5)+,(a0)+		; write values
		move.b	(a5)+,(a0)+		; write registers
	endm

	;	st	(a0)			; mark as end of the cue
	StartZ80				; enable Z80 execution
		move.l	a5,sp			; fix stack pointer
		bclr	#cfbVol,(a1)		; reset volume update request flag
		move.l	(sp)+,a2		; load the tracker address from stack

	if FEATURE_MODTL
		swap	d6			; swap to lower word
		move.w	d6,a3			; load TL data back from stack
	endif
		rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for stopping the current channel
; ---------------------------------------------------------------------------

dcStop:
		and.b	#$FF-(1<<mfbHold),mExtraFlags.w; clear note hold flag
		and.b	#$FF-(1<<cfbRun),(a1)	; clear running tracker flag
	dStopChannel	-1			; stop channel operation

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.s	.nosm			; if not, do normal code
		jsr	dKeyOffFM(pc)		; key on FM channels
	dSetFM3SM	mStatFM3.w		; enable FM3 special mode
		bra.s	.exit

.nosm
	endif
; ---------------------------------------------------------------------------

		cmpa.w	#mSFXFM2,a1		; check if this is a SFX channel
		blo.s	.exit			; if not, skip all this
		clr.b	cPrio(a1)		; clear channel priority

		lea	dSFXoverList(pc),a4	; load quick reference to the SFX override list to a4
		moveq	#0,d3
		move.b	cType(a1),d3		; load channel type to d3
		bmi.s	.psg			; if this is a PSG channel, branch
		move.w	a1,-(sp)		; push channel pointer

		and.w	#$07,d3			; get only the necessary bits to d3
		add.w	d3,d3			; double offset (each entry is 1 word in size)
		move.w	(a4,d3.w),a1		; get the SFX channel we were overriding

.nextfm3
		tst.b	(a1)			; check if that channel is running a tracker
		bpl.s	.fixch			; if not, branch
; ---------------------------------------------------------------------------

		bset	#cfbVol,(a1)		; set update volume flag (cleared by dUpdateVoiceFM)
		bclr	#cfbInt,(a1)		; reset sfx override flag
		btst	#ctbDAC,cType(a1)	; check if the channel is a DAC channel
		bne.s	.fixch			; if yes, skip

		bset	#cfbRest,(a1)		; set channel resting flag
		moveq	#0,d4
		move.b	cVoice(a1),d4		; load FM voice ID of the channel to d4
		jsr	dUpdateVoiceFM(pc)	; send FM voice for this channel

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.s	.fixch			; if not, do normal code
		add.w	#cSize,a1		; go to next operator
		bra.s	.nextfm3		; enable it too!
	endif

.fixch
		move.w	(sp)+,a1		; pop the current channel

.exit
		addq.l	#2,(sp)			; go to next channel immediately (this skips a bra.s instruction)
		rts
; ---------------------------------------------------------------------------

.psg
	if FEATURE_PSG4
		cmp.w	#mSFXPSG3,a1		; check if this was SFX PSG3 channel
		bne.s	.nopsg3			; if not, branch
		tst.b	mPSG4+cFlags.w		; check if PSG4 is active
		bpl.s	.cxpsg3			; if not, check PSG3

		bclr	#cfbInt,mPSG3+cFlags.w	; channel is not interrupted anymore
		bset	#cfbRest,mPSG3+cFlags.w	; set channel resting

	if FEATURE_PSGADSR
		move.b	#$7F,mADSR+aPSG3.w	; set to max volume
		or.b	#adpRelease,mADSR+aPSG3+admAttRel.w; force release
		move.b	#$7F,mADSR+aPSG4.w	; set to max volume
		or.b	#adpRelease,mADSR+aPSG4+admAttRel.w; force release
	else
		move.b	#ctPSG3|$1F,dPSG.l	; mute PSG3 channel too
	endif

		lea	mPSG4.w,a4		; use PSG4 as primary channel
		bra.s	.unintpsg		; uninterrupt channel

.cxpsg3
		move.w	#ctPSG3,d3		; use PSG3 as primary channel

.nopsg3
	endif
; ---------------------------------------------------------------------------

		lsr.b	#4,d3			; make it easier to reference the right offset in the table
		movea.w	4(a4,d3.w),a4		; get the SFX channel we were overriding
		tst.b	(a4)			; check if that channel is running a tracker
		bpl.s	.exit			; if not, branch

	if FEATURE_PSGADSR
		move.w	a1,-(sp)		; push channel pointer
		lea	dMusADSRtbl-8(pc),a1	; get PSG ADSR table address to a1
		move.w	(a1,d3.w),a1		; load the PSG ADSR entry this channel uses

		move.b	#$7F,(a1)+		; set to max volume
		or.b	#adpRelease,(a1)	; force release
		move.w	(sp)+,a1		; pop the current channel
	endif

.unintpsg
		bclr	#cfbInt,(a4)		; channel is not interrupted anymore
		bset	#cfbRest,(a4)		; set channel resting

		cmp.b	#ctPSG4,cType(a4)	; check if this channel is in PSG4 mode
		bne.s	.exit			; if not, skip
		tst.b	cStatPSG4(a4)		; check if PSG4 status is set
		beq.s	.exit			; if not, it is dangerous to update PSG
		move.b	cStatPSG4(a4),dPSG.l	; update PSG4 status to PSG port
		bra.s	.exit
; ---------------------------------------------------------------------------

	if FEATURE_PSGADSR
dMusADSRtbl:
		dc.w mADSR+aPSG1		; PSG1
		dc.w mADSR+aPSG2		; PSG2
		dc.w mADSR+aPSG3		; PSG3
		if FEATURE_PSG4
			dc.w mADSR+aPSG4	; PSG4
		else
			dc.w mADSR+aPSG3	; PSG4
		endif
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for enabling LFO
;
; input:
;   a1 - Channel to operate on
; thrash:
;   a2 - Used for envelope data address
;   a5 - Used to temporarily use stack for saving LFO values
;   d1 - Used to store YM address
;   d2 - Used as dbf counter
;   d3 - Used to detect enabled operators
;   d4 - Various uses
;   d5 - Used for channel calculation
;   d6 - Used for channel calculation
; ---------------------------------------------------------------------------

dcsLFO:
		moveq	#0,d4
		move.b	cVoice(a1),d4		; load FM voice ID of the channel to d4
	dCALC_BANK	9			; get the voice table address to a4
	dCALC_VOICE				; get address of the specific voice to a4

		move.b	(a2),d3			; load LFO enable operators to d3
	CheckCue				; check that cue is valid
		btst	#cfbInt,(a1)		; check if channel is interrupted
		bne.w	.skipLFO		; if so, skip loading LFO

		move.l	sp,a5			; copy stack pointer to a5
		subq.l	#4,sp			; reserve some space in the stack

	rept 4
		moveq	#0,d5			; prepare d5 as clear (for roxr)
		add.b	d3,d3			; check if AMS is enabled for this channel
		roxr.b	#$01,d5			; if yes, rotate carry bit into bit7 (value of $80)

		move.b	(a4)+,d4		; get Decay 1 Level value from voice to d4
		or.b	d5,d4			; or the AMS enable value
		move.b	d4,-(a5)		; save in stack
	endm

		moveq	#0,d6			; clear d6 to prepare FM3SM channel
		moveq	#2,d5			; set to channel 3
		btst	#ctbFM3sm,cType(a1)	; check if this is FM3 special mode
		bne.s	.gotch			; if so, branch
	InitChYM				; prepare to write Channel-specific YM registers

.gotch
	stopZ80
	WriteChYM	#$6C, (a5)+		; Decay 1 level: Decay 1 + AMS enable bit for operator 4
	WriteChYM	#$64, (a5)+		; Decay 1 level: Decay 1 + AMS enable bit for operator 2
	WriteChYM	#$68, (a5)+		; Decay 1 level: Decay 1 + AMS enable bit for operator 3
	WriteChYM	#$60, (a5)+		; Decay 1 level: Decay 1 + AMS enable bit for operator 1
		move.l	a5,sp			; restore stack pointer
		bra.s	.cont
; ---------------------------------------------------------------------------

.skipLFO
	InitChYM				; prepare to write Channel-specific YM registers
	stopZ80

.cont
	WriteYM1	#$22, (a2)+		; LFO: LFO frequency and enable
		move.b	(a2)+,d3		; load AMS, FMS & Panning from tracker

	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)	; is this FM3 in special mode?
		beq.s	.nosm			; if not, do normal code
		move.b	d3,mFM3op1+cPanning.w	; save to FM3op1

		btst	#cfbInt,(a1)		; check if channel is interrupted
		bne.s	.skipPan		; if so, skip panning
	WriteYM1	#$B6, d3		; Panning & LFO: FM3, AMS + FMS + Panning

	;	st	(a0)			; write end marker
	startZ80
		rts
	endif
; ---------------------------------------------------------------------------

.nosm
		move.b	d3,cPanning(a1)		; save to channel panning

		btst	#cfbInt,(a1)		; check if channel is interrupted
		bne.s	.skipPan		; if so, skip panning
	WriteChYM	#$B4, d3		; Panning & LFO: AMS + FMS + Panning

.skipPan
	;	st	(a0)			; write end marker
	startZ80
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for enabling and disabling CSM mode
; ---------------------------------------------------------------------------

	if FEATURE_FM3SM
dcCSMOn:
		moveq	#signextendB($81),d3	; prepare CSM enable value to d3
		move.b	d3,mStatFM3.w		; set FM3 status

		move.b	(a2)+,d5		; load first byte into d5
		moveq	#3,d4			; need to AND the input value
		and.b	d5,d4			; and with d4

		and.b	#$F0,d5			; get only keymask
		or.b	#ctFM3,d5		; always enable FM3 channel mode
		move.b	d5,mFM3keyMask.w	; save as key mask

	CheckCue				; check that cue is valid
	stopZ80
	WriteYM1	#$24, (a2)+		; load Timer A msb's
	WriteYM1	#$25, d4		; load Timer A lsb's
	WriteYM1	#$27, d3		; channel 3 Mode & Timer Control: enable FM3 CSM mode and Timer A
	;	st	(a0)			; write end marker
	startZ80
		rts
; ---------------------------------------------------------------------------

dcCSMOff:
		move.b	(a2)+,mFM3keyMask.w	; load FM3 key mask
		moveq	#0,d4			; prepare 0 in d4
		moveq	#$40,d3			; prepare FM3 enabled to d3
		move.b	d3,mStatFM3.w		; set FM3 status

	CheckCue				; check that cue is valid
	stopZ80
	WriteYM1	#$27, d3		; channel 3 Mode & Timer Control: enable FM3 mode and disable Timer A
	WriteYM1	#$24, d4		; Load Timer A msb's
	WriteYM1	#$25, d4		; Load Timer A lsb's
	;	st	(a0)			; write end marker
	startZ80
		rts
; ---------------------------------------------------------------------------

	elseif safe=1
dcCSMOn:
dcCSMOff:
		AMPS_Debug_dcSpecFM3
	endif

	if FEATURE_MODTL
; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for making it easier to create these routines below
; ---------------------------------------------------------------------------

tlmodrt		macro update, name
name_1:	label *		; <--- because ASS is a great assembler I had to hack it together like this lel
	if update<>0
		pea	dcUpdateTL(pc)		; update TL modulation flags last
	endif
		move.l	a3,a4			; just copy the pointer to a4
		bra.s	name_Normal

name_2:	label *
	if update<>0
		pea	dcUpdateTL(pc)		; update TL modulation flags last
	endif
		lea	toSize(a3),a4		; copy pointer for operator 2 to a4
		bra.s	name_Normal

name_3:	label *
	if update<>0
		pea	dcUpdateTL(pc)		; update TL modulation flags last
	endif
		lea	toSize*2(a3),a4		; copy pointer for operator 3 to a4
		bra.s	name_Normal

name_4:	label *
	if update<>0
		pea	dcUpdateTL(pc)		; update TL modulation flags last
	endif
		lea	toSize*3(a3),a4		; copy pointer for operator 4 to a4

name_Normal:	label *
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for initializing modulation
; ---------------------------------------------------------------------------

	tlmodrt	0, dcModTL			; generate call structure to this routine
		move.l	a2,toMod(a4)		; set modulation data address
		move.b	(a2)+,toModSpeed(a4)	; load modulation speed from tracker to channel

		move.b	(a2)+,d3		; load modulation step count from tracker to d3
		lsr.b	#1,d3			; halve it
		move.b	d3,toModCount(a4)	; save as modulation step count to channel

		move.b	(a2)+,toModStep(a4)	; load modulation step offset from tracker to channel
		move.b	(a2)+,toModDelay(a4)	; load modulation delay from tracker to channel
		bra.s	dcModOnTL_Normal	; continue to enable modulation
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for enabling modulation
; ---------------------------------------------------------------------------

	tlmodrt	0, dcModOnTL			; generate call structure to this routine
		or.b	#$81,(a4)		; set modulation as enabled and operator active
		or.b	#$40,(a3)		; also enable whole system as operational
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker commands for disabling modulation
; ---------------------------------------------------------------------------

	tlmodrt	1, dcModOffTL			; generate call structure to this routine
		and.b	#$FE,(a3)		; set modulation as disabled
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for adding volume
; ---------------------------------------------------------------------------

	tlmodrt	1, dcaVolTL			; generate call structure to this routine
		move.b	(a2)+,d3		; load volume to d3
		add.b	d3,toVol(a3)		; add d3 to volume
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting volume
; ---------------------------------------------------------------------------

	tlmodrt	1, dcsVolTL			; generate call structure to this routine
		move.b	(a2)+,toVol(a3)		; set volume to xx
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for setting volume envelope ID
; ---------------------------------------------------------------------------

	tlmodrt	1, dcVolEnvTL			; generate call structure to this routine
		move.b	(a2)+,toVolEnv(a3)	; set volume envelope ID
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for resetting TL volume envelope
; ---------------------------------------------------------------------------

dcResetVolEnvTL:
		clr.b	toVolEnv(a3)		; reset volume envelope ID

dcComplexRts:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for processing complex TL settings
; ---------------------------------------------------------------------------

dcComplexTL:
		move.b	(a2)+,d5		; load settings value to d5
		move.b	d5,d4			; copy it to d4
		and.w	#$F0,d5			; get only the mode to use

		and.w	#$F,d4			; get only the bits for operators
		beq.s	dcComplexRts		; if none are set, avoid any strange problems
		lea	-toSize(a3),a4		; get the TL list to use
		moveq	#4-1,d6			; set repeat count
; ---------------------------------------------------------------------------

.operator
		add.w	#toSize,a4		; get the next TL data to use
		btst	d6,d4			; check if operator is enabled
		beq.s	.disabled		; if not, skip

		lea	dcComplexTable(pc,d5.w),a5; get complex table data to a5
		move.w	(a5)+,d3		; get offset to the routine to run
		jsr	-2(a5,d3.w)		; run first routine
		move.w	(a5)+,d3		; get offset to the routine to run
		jsr	-4(a5,d3.w)		; run second routine

.disabled
		dbf	d6,.operator		; loop for each operator
		tst.b	(a5)			; check if we should run extra code
		beq.s	dcComplexRts		; branch if not
; ===========================================================================
; ---------------------------------------------------------------------------
; Routine for updating TL modulation status to be accurate
; ---------------------------------------------------------------------------

dcUpdateTL:
		and.b	#$3F,(a3)		; reset TL modulation enabled bits
		moveq	#$00,d5			; set default state as disabled
		moveq	#4-1,d6			; repeat for 4 channels

		move.l	a3,a4			; copy pointer to a4
		moveq	#toSize,d4		; load channel size to d4
; ---------------------------------------------------------------------------

.chloop
		and.b	#$7F,(a4)		; set as active
		btst	#0,(a4)			; check if modulation is active
		bne.s	.chactive		; if so, branch
		tst.b	toVolEnv(a4)		; check if volume envelope is enabled
		beq.s	.chinactive		; branch if not

.chactive
		moveq	#$40,d5			; set TL modulation as fully active
		or.b	#$80,(a4)		; set operator as active

.chinactive
		add.w	d4,(a4)			; go to next channel
		dbf	d6,.chloop		; loop for each channel
		or.b	d5,(a3)			; or the active bit value to first operator
		rts
; ---------------------------------------------------------------------------

dccte		macro extra, first, second
	dc.w *-first, *-second
	dc.b extra, 0, extra, 0
    endm

dcComplexTable:
	dccte	0, dcResetVolEnvTL, dcModOnTL_Normal	; %0000: Setup modulation and reset volume envelope
	dccte	0, dcModOnTL_Normal, dcComplexRts	; %0001: Setup modulation
	dccte	1, dcVolEnvTL_Normal, dcComplexRts	; %0010: Setup volume envelope
	dccte	1, dcVolEnvTL_Normal, dcModOnTL_Normal	; %0011: Setup modulation and volume envelope
	dccte	1, dcModOffTL_Normal, dcComplexRts	; %0100: Disable modulation
	dccte	0, dcModOnTL_Normal, dcComplexRts	; %0101: Enable modulation
	dccte	1, dcResetVolEnvTL, dcModOffTL_Normal	; %0110: Disable modulation and reset volume envelope
	dccte	0, dcResetVolEnvTL, dcModOnTL_Normal	; %0111: Enable modulation and reset volume envelope
	dccte	1, dcVolEnvTL_Normal, dcModOffTL_Normal	; %1000; Setup volume envelope and disable modulation
	dccte	0, dcVolEnvTL_Normal, dcModOnTL_Normal	; %1001; Setup volume envelope and enable modulation
	dccte	0, dcaVolTL_Normal, dcComplexRts	; %1010; Add volume
	dccte	0, dcsVolTL_Normal, dcComplexRts	; %1011; Set volume

	else
dcComplexTL:
		illegal
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for resetting condition
; ---------------------------------------------------------------------------

dcResetCond:
		bclr	#cfbCond,(a1)		; reset condition flag
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for writing to communications flags
; ---------------------------------------------------------------------------

dcsComm:
		lea	mComm.w,a4		; get communications array to a4
		moveq	#0,d3
		move.b	(a2)+,d3		; load byte number to write from tracker
		move.b	(a2)+,(a4,d3.w)		; load vaue from tracker to communications byte
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; RAM addresses for special condition code
; ---------------------------------------------------------------------------

dcCondRegTable:
	dc.w ConsoleRegion, mFlags	; 0
	dc.w 0, 0			; 2
	dc.w 0, 0			; 4
	dc.w 0, 0			; 6
	dc.w 0, 0			; 8
	dc.w 0, 0			; $A
	dc.w 0, 0			; $C
	dc.w 0, cType			; $E
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for checking special RAM addresses
; ---------------------------------------------------------------------------

dcCondReg:
		move.b	(a2)+,d3		; get value from tracker
		move.b	d3,d4			; copy to d4

		and.w	#$F,d3			; get RAM table offset to d3
		add.w	d3,d3			; double it (each entry is 1 word)
		move.w	dcCondRegTable(pc,d3.w),d3; get data to read from
		bmi.s	.gotit			; branch if if was a RAM address
		add.w	a1,d3			; else it was a channel offset

.gotit
		move.w	d3,a4			; get the desired address from d3 to a4
		move.b	(a4),d3			; read byte from it
		bra.s	dcCondCom
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker command for checking communications bytes
; ---------------------------------------------------------------------------

dcCondJump	macro x
	x	.false
	rts
     endm

dcCond:
		lea	mComm.w,a4		; get communications array to a4
		move.b	(a2)+,d3		; load condition and offset from tracker to d3
		move.b	d3,d4			; copy to d4
		and.w	#$F,d3			; get offset only
		move.b	(a4,d3.w),d3		; load value from communcations byte to d3

dcCondCom:
		bclr	#cfbCond,(a1)		; set condition to true
		and.w	#$F0,d4			; get condition value only
		lsr.w	#2,d4			; shift 2 bits down (each entry is 4 bytes large)
		cmp.b	(a2)+,d3		; check value against tracker byte
		jmp	.cond(pc,d4.w)		; handle conditional code
; ===========================================================================
; ---------------------------------------------------------------------------
; Code for setting the condition flag
; ---------------------------------------------------------------------------

.false
		bset	#cfbCond,(a1)		; set condition to false
; ---------------------------------------------------------------------------

.cond
	rts			; T
	rts
	dcCondJump bra.s	; F
	dcCondJump bls.s	; HI
	dcCondJump bhi.s	; LS
	dcCondJump blo.s	; HS/CC
	dcCondJump bhs.s	; LO/CS
	dcCondJump beq.s	; NE
	dcCondJump bne.s	; EQ
	dcCondJump bvs.s	; VC
	dcCondJump bvc.s	; VS
	dcCondJump bmi.s	; PL
	dcCondJump bpl.s	; MI
	dcCondJump blt.s	; GE
	dcCondJump bge.s	; LT
	dcCondJump ble.s	; GT
	dcCondJump bgt.s	; LE
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker debug command for freezing the CPU
; ---------------------------------------------------------------------------

	if safe=1
dcFreeze:
		bra.w	*			; trap CPU here
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker debug command for debugging tracker data
; ---------------------------------------------------------------------------

dcTracker:
		st	msChktracker.w		; set debug flag
		rts
	endif
; ---------------------------------------------------------------------------

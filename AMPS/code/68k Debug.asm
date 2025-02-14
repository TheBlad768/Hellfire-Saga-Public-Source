	if safe=1	; all of this code is only required in safe mode!
		ifndef isAMPS
			warning "Not using custom debugger macro definition! All features may not work."
		endif
; ===========================================================================
; ---------------------------------------------------------------------------
; write channel string to console
; ---------------------------------------------------------------------------

	if isAMPS		; check if Vladik's debugger is active
AMPS_Debug_GetChannel	macro
	cmp.w	#mPSG1,a1
	bne.s	.cpsg2
	Console.Write "PSG1"
	bra.w	.end

.cpsg2
	cmp.w	#mPSG2,a1
	bne.s	.cpsg3
	Console.Write "PSG2"
	bra.w	.end

.cpsg3
	cmp.w	#mPSG3,a1
	bne.s	.cpsgs1
	Console.Write "PSG3"
	bra.w	.end

.cpsgs1
	cmp.w	#mSFXPSG1,a1
	bne.s	.cpsgs2
	Console.Write "SFX PSG1"
	bra.w	.end

.cpsgs2
	cmp.w	#mSFXPSG2,a1
	bne.s	.cpsgs3
	Console.Write "SFX PSG2"
	bra.w	.end

.cpsgs3
	cmp.w	#mSFXPSG3,a1
	bne.s	.cdacs1
	Console.Write "SFX PSG3"
	bra.w	.end

.cdacs1
	cmp.w	#mSFXDAC1,a1
	bne.s	.cdac1
	Console.Write "SFX DAC1"
	bra.w	.end

.cdac1
	cmp.w	#mDAC1,a1
	bne.s	.cdac2
	Console.Write "DAC1"
	bra.w	.end

.cdac2
	cmp.w	#mDAC2,a1
	bne.s	.cfm1
	Console.Write "DAC2"
	bra.w	.end

.cfm1
	cmp.w	#mFM1,a1
	bne.s	.cfm2
	Console.Write "FM1"
	bra.w	.end

.cfm2
	cmp.w	#mFM2,a1
	bne.s	.cfm3
	Console.Write "FM2"
	bra.w	.end

.cfm3
	cmp.w	#mFM3,a1
	bne.s	.cfm4
	if FEATURE_FM3SM
		btst	#ctbFM3sm,cType(a1)
		bne.s	.ctfm3op1
	endif
	Console.Write "FM3"
	bra.w	.end

	if FEATURE_FM3SM
.ctfm3op1
		Console.Write "FM3o1"
		bra.w	.end
	endif

.cfm4
	cmp.w	#mFM4,a1
	bne.s	.cfm5
	Console.Write "FM4"
	bra.w	.end

.cfm5
	cmp.w	#mFM5,a1
	bne.s	.ctfm3op2
	Console.Write "FM5"
	bra.w	.end

.ctfm3op2
	if FEATURE_FM3SM
		cmp.w	#mFM3op2,a1
		bne.s	.ctfm3op3
		Console.Write "FM3o2"
		bra.w	.end

.ctfm3op3
		cmp.w	#mFM3op3,a1
		bne.s	.ctfm3op4
		Console.Write "FM3o3"
		bra.w	.end

.ctfm3op4
		cmp.w	#mFM3op4,a1
		bne.s	.cfms3
		Console.Write "FM3o4"
		bra.w	.end
	endif

.cfms3
	cmp.w	#mSFXFM2,a1
	bne.s	.cfms4
	Console.Write "SFX FM2"
	rts

.cfms4
	cmp.w	#mSFXFM4,a1
	bne.s	.cfms5
	Console.Write "SFX FM4"
	bra.s	.end

.cfms5
	cmp.w	#mSFXFM5,a1
	beq.s	.cfms5_

.addr
	Console.Write "%<pal2>%<.l a1>"
	rts

.cfms5_
	Console.Write "SFX FM5"
.end
	endm
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Channel console code
; ---------------------------------------------------------------------------

	if isAMPS		; check if Vladik's debugger is active
AMPS_Debug_Console_Channel:
	Console.WriteLine "  %<pal0>d0: %<pal2>%<.l d0>  %<pal0>a0: %<pal2>%<.l a0>"
	Console.WriteLine "  %<pal0>d1: %<pal2>%<.l d1>  %<pal0>a1: %<pal2>%<.l a1>"
	Console.WriteLine "  %<pal0>d2: %<pal2>%<.l d2>  %<pal0>a2: %<pal2>%<.l a2>"
	Console.WriteLine "  %<pal0>d3: %<pal2>%<.l d3>  %<pal0>a3: %<pal2>%<.l a3>"
	Console.WriteLine "  %<pal0>d4: %<pal2>%<.l d4>  %<pal0>a4: %<pal2>%<.l a4>"
	Console.WriteLine "  %<pal0>d5: %<pal2>%<.l d5>  %<pal0>a5: %<pal2>%<.l a5>"
	Console.WriteLine "  %<pal0>d6: %<pal2>%<.l d6>  %<pal0>a6: %<pal2>%<.l a6>"
	Console.WriteLine "  %<pal0>d7: %<pal2>%<.l d7>  %<pal0>sp: %<pal2>%<.l a7>"
	Console.BreakLine

	Console.Write "%<pal1>Channel: %<pal0>"
	AMPS_Debug_GetChannel
	Console.BreakLine
	Console.WriteLine "%<pal1>Addr: %<pal0>%<.l a2 sym|split>%<pal2>%<symdisp>"

; fmt: flag, type, pan, det, pitch, vol, sample/voice, dur, lastdur, freq

; some AS is ASS code here!
	move.b	cType(a1),d0
	move.b	cPanning(a1),d1
	Console.Write	  "%<pal1>CH: %<pal2>%<.b (a1)> %<.b d0> %<.b d1> "

	move.b	cDetune(a1),d0
	move.b	cPitch(a1),d1
	move.b	cVolume(a1),d2
	Console.Write	  "%<.b d0> %<.b d1> %<.b d2> "

	move.b	cSample(a1),d0
	move.b	cDuration(a1),d1
	move.b	cLastDur(a1),d2
	move.w	cFreq(a1),d3
	Console.Write	  "%<.b d0> %<.b d1> %<.b d2> %<.w d3> "
	Console.BreakLine

	if 0=1
	if FEATURE_MODULATION
		move.l	cMod(a1),d0
		Console.WriteLine "%<pal1>Mod: %<pal0>%<.l d0 sym|split>%<pal2>%<symdisp>"

		move.b	cModDelay(a1),d0
		move.w	cModFreq(a1),d1
		move.b	cModSpeed(a1),d2
		move.b	cModStep(a1),d3
		move.b	cModCount(a1),d4
		Console.Write	  "%<pal1>Mod Data: %<pal2>%<.b d0> %<.w d1> %<.b d2> %<.b d3> %<.b d4>"
		Console.BreakLine
	endif

	if FEATURE_PORTAMENTO
		move.b	cPortaDisp(a1),d0
		move.w	cPortaTarget(a1),d1
		Console.WriteLine "%<pal1>Porta: %<pal2>%<.b d0> %<.w d1>"
		Console.BreakLine
	endif

	if FEATURE_DACFMVOLENV
		move.b	cVolEnv(a1),d0
		move.b	cEnvPos(a1),d1
		Console.WriteLine "%<pal1>VolEnv: %<pal2>%<.b d0> %<pal2>%<.b d1>"
		if FEATURE_MODENV=0
			Console.BreakLine
		endif
	endif

	if FEATURE_MODENV
		move.b	cModEnv(a1),d0
		move.b	cModEnvPos(a1),d1
		move.b	cModEnvSens(a1),d2
		Console.WriteLine "%<pal1>ModEnv: %<pal2>%<.b d0> %<.b d1>%<.b d2>"
		Console.BreakLine
	endif

	move.b	cLoop(a1),d0
	move.b	cLoop+1(a1),d1
	move.b	cLoop+2(a1),d2
	Console.Write "%<pal1>Loop: %<pal2>%<.b d0> %<.b d1> %<.b d2> "
	endif

	cmp.w	#mSFXDAC1,a1
	bhs.w	.rts
	moveq	#0,d0
	move.b	cStack(a1),d0

	if 0=1
	move.b	cGateCur(a1),d2
	move.b	cGateMain(a1),d1
	Console.WriteLine "%<.b d2> %<.b d1>"
	Console.WriteLine "%<pal1>Stack: %<pal2>%<.b d0>"
	endif

	move.w	a1,d1
	add.w	#cSize,d1
	add.w	d0,a1

.loop
	cmp.w	a1,d1
	bls.s	.rts
	Console.WriteLine "%<pal0>%<.l (a1) sym|split>%<pal2>%<symdisp>"
	tst.l	(a1)+
	bra.s	.loop

.rts
	rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Generic console code
; ---------------------------------------------------------------------------

	if isAMPS		; check if Vladik's debugger is active
AMPS_Debug_Console_Main:
	Console.WriteLine "  %<pal0>d0: %<pal2>%<.l d0>  %<pal0>a0: %<pal2>%<.l a0>"
	Console.WriteLine "  %<pal0>d1: %<pal2>%<.l d1>  %<pal0>a1: %<pal2>%<.l a1>"
	Console.WriteLine "  %<pal0>d2: %<pal2>%<.l d2>  %<pal0>a2: %<pal2>%<.l a2>"
	Console.WriteLine "  %<pal0>d3: %<pal2>%<.l d3>  %<pal0>a3: %<pal2>%<.l a3>"
	Console.WriteLine "  %<pal0>d4: %<pal2>%<.l d4>  %<pal0>a4: %<pal2>%<.l a4>"
	Console.WriteLine "  %<pal0>d5: %<pal2>%<.l d5>  %<pal0>a5: %<pal2>%<.l a5>"
	Console.WriteLine "  %<pal0>d6: %<pal2>%<.l d6>  %<pal0>a6: %<pal2>%<.l a6>"
	Console.WriteLine "  %<pal0>d7: %<pal2>%<.l d7>  %<pal0>sp: %<pal2>%<.l a7>"
	Console.BreakLine

	move.l	mVctMus.w,d0
	Console.WriteLine "%<pal1>PatMus: %<pal0>%<.l d0 sym|split>%<pal2>%<symdisp>"

	move.b	mFlags.w,d0
	move.b	mCtrPal.w,d1
	Console.Write	  "%<pal1>Misc:   %<pal2>%<.b d0> %<.b d1> "

	move.b	mSpindash.w,d0
	move.b	mContCtr.w,d1
	move.b	mContLast.w,d2
	Console.WriteLine "%<.b d0> %<.b d1> %<.b d2>"

	move.w	mTempoMain.w,d0
	move.w	mTempoSpeed.w,d1
	move.w	mTempo.w,d2
	move.w	mTempoAcc.w,d3
	Console.WriteLine "%<pal1>Tempo:  %<pal2>%<.w d0> %<.w d1> %<.w d2> %<.w d3>"

	move.b	mMasterVolFM.w,d0
	move.b	mMasterVolDAC.w,d1
	move.b	mMasterVolPSG.w,d2
	Console.WriteLine "%<pal1>Volume: %<pal2>%<.b d0> %<.b d1> %<.b d2>"

	move.l	mVctMus.w,d0
	Console.WriteLine "%<pal1>Fade:   %<pal0>%<.l d0 sym|split>%<pal2>%<symdisp>"

	move.b	mQueue.w,d0
	move.b	mQueue+1.w,d1
	move.b	mQueue+2.w,d2
	Console.WriteLine "%<pal1>Queue:  %<pal2>%<.b d0> %<.b d1> %<.b d2>"

	move.b	mComm.w,d0
	move.b	mComm+1.w,d1
	move.b	mComm+2.w,d2
	Console.Write	  "%<pal1>Comm:   %<pal2>%<.b d0> %<.b d1> %<.b d2> "
	move.b	mComm+3.w,d0
	move.b	mComm+4.w,d1
	move.b	mComm+5.w,d2
	Console.Write	  "%<.b d0> %<.b d1> %<.b d2> "
	move.b	mComm+6.w,d0
	move.b	mComm+7.w,d1
	Console.WriteLine "%<.b d0> %<.b d1>"

.rts
	rts
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Invalid fade command handler
; ---------------------------------------------------------------------------

AMPS_Debug_FadeCmd	macro
	cmp.b	#fLast,d2	; check against max
	bhs.s	.fail		; if in range, branch
	cmp.b	#$80,d2		; check against min
	blo.s	.fail		; if too little, bra
	btst	#1,d2		; check if bit1 set
	bne.s	.fail		; if is, branch
	btst	#0,d2		; check if even
	beq.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_FadeCmd
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_FadeCmd:
		RaiseError2 "Invalid Fade command: %<.b d2>", AMPS_Debug_Console_Main
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Invalid volume envelope handler
; ---------------------------------------------------------------------------

AMPS_Debug_VolEnvID	macro
	cmp.b	#(VolEnvs_End-VolEnvs)/4,d4	; check against max
	bls.s	.ok			; if in range, branch

	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_VolEnvID
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_VolEnvID:
		RaiseError2 "Volume envelope ID out of range: %<.b d4>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Invalid volume envelope command handler
; ---------------------------------------------------------------------------

AMPS_Debug_VolEnvCmd	macro
	btst	#0,d4		; check if even
	beq.s	.ok		; if is, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError2 "Invalid volume envelope command: %<.b d4>", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Invalid modulation envelope handler
; ---------------------------------------------------------------------------

AMPS_Debug_ModEnvID	macro
	cmp.b	#(ModEnvs_End-ModEnvs)/4,d4	; check against max
	bls.s	.ok			; if in range, branch

	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_ModEnvID
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_ModEnvID:
		RaiseError2 "Modulation envelope ID out of range: %<.b d4>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; PSG note check
; ---------------------------------------------------------------------------

AMPS_Debug_NotePSG	macro
	cmp.b	#dFreqPSG_-dFreqPSG,d1; check against max
	blo.s	.ok		; if too little, bra

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_NotePSG
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_NotePSG:
		lsr.w	#1,d1	; get real note
		RaiseError2 "Invalid PSG note: %<.b d1>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; PSG4 note check
; ---------------------------------------------------------------------------

AMPS_Debug_NotePSG4	macro
	btst	#0,d1		; check if bit0 is set
	bne.s	.fail		; if so, then this is an issue
	cmp.b	#n4Last,d1	; check against max
	blo.s	.ok		; if too little, bra

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_NotePSG4
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_NotePSG4:
		RaiseError2 "Invalid PSG4 note: %<.b d1>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; FM note check
; ---------------------------------------------------------------------------

AMPS_Debug_NoteFM	macro
	cmp.b	#dFreqFM_-dFreqFM,d1; check against max
	blo.s	.ok		; if too little, bra

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_NoteFM
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_NoteFM:
		lsr.w	#1,d1	; get real note
		RaiseError2 "Invalid FM note: %<.b d1>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; DAC frequency check
; ---------------------------------------------------------------------------

AMPS_Debug_FreqDAC	macro
	cmp.w	#MaxPitch,d2	; check if frequency is too large
	bgt.s	.fail		; if so, branch
	cmp.w	#-MaxPitch,d2	; check if frequency is too small
	bge.s	.ok		; if not, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_FreqDAC
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_FreqDAC:
		RaiseError "Out of range DAC frequency: %<.w d2>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Invalid tracker command handlers
; ---------------------------------------------------------------------------

AMPS_Debug_dcInvalid	macro
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Invalid command detected!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for disabled features - portamento
; ---------------------------------------------------------------------------

AMPS_Debug_dcPortamento	macro
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Portamento feature is disabled. Set FEATURE_PORTAMENTO to 1 to enable.", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for disabled features - modulation
; ---------------------------------------------------------------------------

AMPS_Debug_dcModulate	macro
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_dcModulate
	else
		bra.w	*
	endif
    endm

	if FEATURE_MODULATION=0
	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_dcModulate:
		RaiseError "Modulation feature is disabled. Set FEATURE_MODULATION to 1 to enable.", AMPS_Debug_Console_Channel
	endif
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for special case of FEATURE_DACFMVOLENV in dcVoice
; ---------------------------------------------------------------------------

AMPS_Debug_dcVoiceEnv	macro
	tst.b	cType(a1)	; check if this is a PSG channel
	bpl.s	.ok		; if not, skip

	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_dcVoiceEnv
	else
		bra.w	*
	endif

.ok
    endm

	if FEATURE_DACFMVOLENV
	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_dcVoiceEnv:
		RaiseError "You can not use sVoice for PSG channelwhen FEATURE_DACFMVOLENV is set to 1. Please use sVolEnv instead.", AMPS_Debug_Console_Channel
	endif
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for disabled features - volume envelopes
; ---------------------------------------------------------------------------

AMPS_Debug_dcVolEnv	macro
	tst.b	cType(a1)	; check if this is a PSG channel
	bmi.s	.ok		; if is, skip

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Volume envelopes are disabled for DAC and FM channels. Set FEATURE_DACFMVOLENV to 1 to enable.", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for disabled features - modulation envelopes
; ---------------------------------------------------------------------------

AMPS_Debug_dcModEnv	macro
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Modulation envelopes are disabled. Set FEATURE_MODENV to 1 to enable.", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for disabled features - modulation
; ---------------------------------------------------------------------------

AMPS_Debug_dcBackup	macro
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_dcBackup
	else
		bra.w	*
	endif
    endm

	if FEATURE_BACKUP=0
	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_dcBackup:
		RaiseError "Backup feature is disabled. Set FEATURE_BACKUP to 1 to enable.", AMPS_Debug_Console_Channel
	endif
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Handler for disabled features - Special FM 3
; ---------------------------------------------------------------------------

AMPS_Debug_dcSpecFM3	macro
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_dcSpecFM3
	else
		bra.w	*
	endif
    endm

	if FEATURE_FM3SM=0
	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_dcSpecFM3:
		RaiseError "FM3 Special Mode feature is disabled. Set FEATURE_FM3SM to 1 to enable.", AMPS_Debug_Console_Channel
	endif
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; PSG on sPan handler
; ---------------------------------------------------------------------------

AMPS_Debug_dcPan	macro
	if FEATURE_FM6
;		cmp.w	#mFM6,a1; check if this is FM6
;		beq.s	.fail	; if so, branch
	endif

	tst.b	cType(a1)	; check for PSG channel
	bpl.s	.ok		; if no, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sPan on a PSG channel!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.fail
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sPan on FM6 channel!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; NoisePSG command on an invalid channel handler
; ---------------------------------------------------------------------------

AMPS_Debug_dcNoisePSG	macro
	beq.s	.ckch		; branch if value is 0
	cmp.b	#snPeri10,d3	; check if the value is below valid range
	blo.s	.fail		; branch if yes
	cmp.b	#snWhitePSG3,d3	; check if the value is above valid range
	bls.s	.ckch		; branch if not

.fail
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sNoisePSG with an invalid value: %<.b d3>", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ckch
	cmp.b	#ctPSG3,cType(a1); check if this is PSG3 or PSG4 channel
	bhs.s	.ok		; if not, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sNoisePSG on an invalid channel!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Timeout command on SFX channel handler
; ---------------------------------------------------------------------------

AMPS_Debug_dcGate	macro
	cmp.w	#mSFXDAC1,a1	; check for SFX channel
	blo.s	.ok		; if no, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sGate on a SFX channel!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif
.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Call command handlers
; ---------------------------------------------------------------------------

AMPS_Debug_dcCall1	macro
	cmp.w	#mSFXDAC1,a1	; check for SFX channel
	blo.s	.ok1		; if no, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sCall on a SFX channel!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok1
    endm

AMPS_Debug_dcCall2	macro
	cmp.b	#cGateCur,d4	; check for invalid stack address
	bhi.s	.ok2		; if no, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sCall stack too deep!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok2
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Loop command handler
; ---------------------------------------------------------------------------

AMPS_Debug_dcLoop	macro
	cmp.b	#cSizeSFX-cLoop,d4	; check for invalid call number
	bhi.s	.fail			; if is, branch
	cmp.w	#mSFXDAC1,a1		; check for SFX channel
	blo.s	.nock			; if no, branch
	cmp.b	#cPrio-cLoop,d4		; check if cPrio
	beq.s	.fail			; if so, branch

.nock
	if FEATURE_DACFMVOLENV
		bra.s	.ok		; no need to check others
	else
		cmp.b	#$C0,cType(a1)	; check if PSG3 or PSG4
		blo.s	.ok		; if no, branch
		cmp.b	#cStatPSG4-cLoop,d4; check if cStatPSG4
		bne.s	.ok		; if no, branch
	endif

.fail
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sLoop ID %<.b d4> is invalid!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Return command handlers
; ---------------------------------------------------------------------------

AMPS_Debug_dcReturn1	macro
	cmp.w	#mSFXDAC1,a1	; check for SFX channel
	blo.s	.ok1		; if no, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sRet on a SFX channel!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok1
    endm

AMPS_Debug_dcReturn2	macro
	cmp.b	#cSize,d3	; check for invalid stack address
	bls.s	.ok2		; if no, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "sRet stack too shallow!", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok2
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Update FM voice handler
; ---------------------------------------------------------------------------

AMPS_Debug_UpdVoiceFM	macro
	cmp.b	#'N',(a4)+	; check if this is valid voice
	bne.s	.fail		; if not, branch
	cmp.w	#'AT',(a4)+	; check if this is valid voice
	beq.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		move.b	cVoice(a1),d4
		RaiseError "FM voice Update invalid voice: %<.b d4>", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Update FM Volume handler
; ---------------------------------------------------------------------------

AMPS_Debug_UpdVolFM	macro
	cmp.b	#'N',(a4)+	; check if this is valid voice
	bne.s	.fail		; if not, branch
	cmp.w	#'AT',(a4)+	; check if this is valid voice
	beq.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_UpdVolFM
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_UpdVolFM:
		move.b	cVoice(a1),d4
		RaiseError2 "FM Volume Update invalid voice: %<.b d4>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Invalid cue handler
; ---------------------------------------------------------------------------

AMPS_Debug_CuePtr	macro id
	cmp.l	#$A00000+YM_Buffer1,a0	; check against min
	blo.s	.fail			; if not in range, branch
	cmp.l	#$A00000+YM_BufferEnd,a0; check against max
	blo.s	.ok			; if in range, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_CuePtr{"id"}
	else
		bra.w	*
	endif

.ok
    endm

	if isAMPS		; check if Vladik's debugger is active
AMPS_DebugR_CuePtrGen:
		RaiseError2 "CUE invalid at macro: %<.l a0>", AMPS_Debug_Console_Channel
AMPS_DebugR_CuePtr0:
		RaiseError2 "CUE invalid at dUpdateVoiceFM: %<.l a0>", AMPS_Debug_Console_Channel
AMPS_DebugR_CuePtr3:
		RaiseError2 "CUE invalid at UpdateAMPS: %<.l a0>", AMPS_Debug_Console_Channel
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Play Command handler
; ---------------------------------------------------------------------------

AMPS_Debug_PlayCmd	macro
	cmp.b	#(dSoundCommands_End-dSoundCommands)/4,d1; check if this is valid command
	bls.s	.ok		; if is, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Invalid command in queue: %<.b d1>", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Sound ID check
; ---------------------------------------------------------------------------

AMPS_Debug_SoundID	macro
	cmp.b	#SFXlast,d1	; check if this is a valid sound id
	blo.s	.ok		; if yes, branch

	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Sound ID %<.b d1> is not a valid sound!", AMPS_Debug_Console_Main
	else
		bra.w	*
	endif

.ok
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker address handlers
; ---------------------------------------------------------------------------

AMPS_Debug_PlayTrackMus	macro
	cmp.l	#musaddr,d2	; check if this is valid tracker
	blo.s	.fail		; if no, branch
	cmp.l	#musend,d2	; check if this is valid tracker
	blo.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		lsr.w	#2,d1	; get actual ID
		RaiseError "Invalid tracker at Music %<.b d1>: %<.l d2>%<endl>%<.l d2 sym>", AMPS_Debug_Console_Main
	else
		bra.w	*
	endif

.ok
    endm

AMPS_Debug_PlayTrackMus2	macro ch
	swap	d2		; make some space to store stuff
	move.w	d1,d2		; store this thing away
	move.l	a3,d1		; load the target address

	and.l	#$FFFFFF,d1	; remove high byte
	cmp.l	#musaddr,d1	; check if this is valid tracker
	blo.s	.fail		; if no, branch
	cmp.l	#dacaddr,d1	; check if this is valid tracker
	blo.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Invalid tracker at Music ch: %<.l d1>%<endl>%<.l d1 sym>", AMPS_Debug_Console_Main
	else
		bra.w	*
	endif

.ok
	move.w	d2,d1		; get the value back
	swap	d2		; also this one as well
    endm

AMPS_Debug_PlayTrackSFX		macro
	cmp.l	#sfxaddr,d2	; check if this is valid tracker
	blo.s	.fail		; if no, branch
	cmp.l	#musaddr,d2	; check if this is valid tracker
	blo.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		lsr.w	#2,d1	; get actual ID
		RaiseError "Invalid tracker at SFX %<.b d1>: %<.l d2>%<endl>%<.l d2 sym>", AMPS_Debug_Console_Main
	else
		bra.w	*
	endif
.ok
    endm

AMPS_Debug_PlayTrackSFX2	macro
	move.l	a3,d4
	and.l	#$FFFFFF,d4	; remove high byte
	cmp.l	#sfxaddr,d4	; check if this is valid tracker
	blo.s	.fail		; if no, branch
	cmp.l	#musaddr,d4	; check if this is valid tracker
	blo.s	.ok		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Invalid tracker at SFX ch: %<.l d4>%<endl>%<.l d4 sym>", AMPS_Debug_Console_Main
	else
		bra.w	*
	endif

.ok
    endm

AMPS_Debug_TrackUpd	macro
	move.l	a2,d1		; copy to d1
	and.l	#$FFFFFF,d1	; remove high byte
	cmp.l	#sfxaddr,d1	; check if this is valid tracker
	blo.s	.fail		; if no, branch
	cmp.l	#dacaddr,d1	; check if this is valid tracker
	blo.s	.data		; if is, branch

.fail
	if isAMPS		; check if Vladik's debugger is active
		RaiseError "Invalid tracker address: %<.l a2>%<endl>%<.l a2 sym>", AMPS_Debug_Console_Channel
	else
		bra.w	*
	endif
    endm
; ===========================================================================
; ---------------------------------------------------------------------------
; Tracker debugger handler and console code
; ---------------------------------------------------------------------------

AMPS_Debug_ChkTracker	macro
.fail
	if isAMPS		; check if Vladik's debugger is active
		jsr	AMPS_DebugR_ChkTracker
	else
		bra.w	*
	endif
    endm

AMPS_DebugR_ChkTracker:
	ifndef isAMPS		; if not custom version
		moveq	#0,d7
		Console.Run AMPS_DebugR_ChkTracker2

	else
		jsr	AMPS_Debug_CalcMax(pc)
		swap	d7			; swap d7 words

.loop
		move.l	d7,$FF0000		; save stuff in RAM
		Console.Run AMPS_DebugR_ChkTracker2, NAT
		move.l	$FF0000,d7		; get stuff back

.nodraw
		moveq	#-1,d6
		dbf	d6,*			; delay a lot

	; implement reading control data
		lea	$A10003,a1
		move.b	#0,(a1)			; set TH low
		or.l	d0,d0			; delay
		move.b	#$40,(a1)		; set TH high
		or.l	d0,d0			; delay
		move.b	(a1),d0			; get dpad stat

		move.w	d7,d5			; copy to d5
		btst	#0,d0			; check if up held
		bne.s	.ckd			; if not ,branch

		subq.w	#1,d7			; move up
		bpl.s	.ckd			; if positive, branch
		clr.w	d7			; else force to 0

.ckd
		btst	#1,d0			; check if down held
		bne.s	.ckdraw			; if not ,branch

		swap	d7
		move.w	d7,d6			; copy high word to d6
		swap	d7

		cmp.w	d6,d7			; check if we can move up
		bge.s	.ckdraw			; if not, branch
		addq.w	#1,d7			; move down

.ckdraw
		cmp.w	d7,d5			; check if we need to redraw
		beq.s	.nodraw			; if not, branch
		bra.w	.loop
	endif

AMPS_Debug_CalcMax:
		moveq	#28,d6		; max lines count
		moveq	#10-1,d7	; run for 10 chs
		moveq	#cSize,d5	; prepare size
		lea	mPSG3.w,a5	; start at PSG3

.chkloop
		tst.w	d6		; check if we have no lines left
	;	ble.s	.rts		; if so, we found it
		subq.w	#3,d6		; we need at least 3 lines
		bmi.s	.add		; if not enough lines, branch

		move.w	a5,d1		; copy ch to d1
		add.w	#cSize,d1	; go to end of it

		moveq	#0,d0
		move.b	cStack(a5),d0	; get stack to d0
		lea	(a5,d0.w),a6	; and get first element to a6

.stack
		cmp.w	a6,d1		; check if stack is dry now
		bhi.s	.inc		; if not, branch

		sub.w	d5,a5		; sub ch size
		dbf	d7,.chkloop	; loop for all chans
		bra.s	.add

.inc
		addq.w	#4,a6		; go to next long
		subq.w	#1,d6		; sub 1 line
		bpl.s	.stack		; if lines left, branch

.add
		addq.w	#1,d7		; increase ch by 1
.rts
		rts

AMPS_DebugR_ChkTracker_Ch:
		subq.w	#1,d7		; sub 1 from offset
		bpl.w	++		; branch if positive
		tst.w	d6		; check if we need to render anymore
		bmi.w	++		; if not, branch

; fmt: <addr> lstdur, dur, freq, sample, loop0, loop1, loop2
		jsr	(a0)
	move.b	cLastDur(a5),d0
	move.b	cDuration(a5),d1
	move.w	cFreq(a5),d2
	Console.Write	  ": %<pal2>%<.w a5> %<.b d0> %<.b d1> %<.w d2>"

	move.b	cSample(a5),d0
	move.b	cLoop(a5),d1
	move.b	cLoop+1(a5),d2
	move.b	cLoop+2(a5),d3
	Console.WriteLine " %<.b d0> %<.b d1> %<.b d2> %<.b d3>"

	move.l	cData(a5),d0
	Console.WriteLine " %<pal1>Addr: %<pal0>%<.l d0 sym|split>%<pal2>%<symdisp>"

		subq.w	#2,d6		; sub those 2 lines from stuff
		bmi.w	++		; if drawn all, branch
		move.w	a5,d1		; copy ch to d1
		add.w	d5,d1		; go to end of it

		moveq	#0,d0
		move.b	cStack(a5),d0	; get stack to d0
		lea	(a5,d0.w),a6	; and get first element to a6

		cmp.w	a6,d1		; check if stack is dry
		bls.s	+		; if is, branch
	Console.WriteLine " %<pal1>Stack:%<pal0>%<.l (a6) sym|split>%<pal2>%<symdisp>"
		tst.l	(a6)+		; AS HACK
		subq.w	#1,d6		; sub a line
		bmi.s	++		; if drawn all, branch

-
		cmp.w	a6,d1		; check if we printed full stack
		bls.s	+		; if not though, branch
	Console.WriteLine "   %<pal0>%<.l (a6) sym|split>%<pal2>%<symdisp>"
		tst.l	(a6)+		; AS HACK
		subq.w	#1,d6		; sub a line
		bpl.s	-		; if we havent drawn all, branch

+
	Console.BreakLine
		subq.w	#1,d6		; sub a line
+
		add.w	d5,a5		; go to next ch
		rts

AMPS_DebugR_ChkTracker2:
		moveq	#40-1,d6
		moveq	#cSize,d5
		lea	mDAC1.w,a5


		lea	AMPS_DebugR_ChDAC1(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChDAC2(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)

		lea	AMPS_DebugR_ChFM1(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChFM2(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChFM3(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChFM4(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChFM5(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)

		lea	AMPS_DebugR_ChPSG1(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChPSG2(pc),a0
		jsr	AMPS_DebugR_ChkTracker_Ch(pc)
		lea	AMPS_DebugR_ChPSG3(pc),a0
		jmp	AMPS_DebugR_ChkTracker_Ch(pc)

AMPS_DebugR_ChDAC1:
	Console.Write " %<pal0>DAC1"
		rts

AMPS_DebugR_ChDAC2:
	Console.Write " %<pal0>DAC2"
		rts

AMPS_DebugR_ChFM1:
	Console.Write " %<pal0> FM1"
		rts

AMPS_DebugR_ChFM2:
	Console.Write " %<pal0> FM2"
		rts

AMPS_DebugR_ChFM3:
	Console.Write " %<pal0> FM3"
		rts

AMPS_DebugR_ChFM4:
	Console.Write " %<pal0> FM4"
		rts

AMPS_DebugR_ChFM5:
	Console.Write " %<pal0> FM5"
		rts

AMPS_DebugR_ChPSG1:
	Console.Write " %<pal0>PSG1"
		rts

AMPS_DebugR_ChPSG2:
	Console.Write " %<pal0>PSG2"
		rts

AMPS_DebugR_ChPSG3:
	Console.Write " %<pal0>PSG3"
		rts
	endif

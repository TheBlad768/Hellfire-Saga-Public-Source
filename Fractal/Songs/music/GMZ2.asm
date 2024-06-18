; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Clock_Voice
	sHeaderSamples	Clock_Samples
	sHeaderVibrato	Clock_Vib
	sHeaderEnvelope	Clock_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$E0
	sChannel	DAC1, Clock_DAC1
	sChannel	FM1, Clock_FM1
	sChannel	FM2, Clock_FM4
	sChannel	FM3, Clock_FM2
	sChannel	FM4, Clock_FM3
	sChannel	FM5, Clock_FM5
	sChannel	PSG1, Clock_PSG2
	sChannel	PSG2, Clock_PSG1
	sChannel	PSG3, Clock_PSG3
	sChannel	PSG4, Clock_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Clock_Voice:
	sNewVoice	v00
	sAlgorithm	$03
	sFeedback	$05
	sDetune		$03, $05, $05, $05
	sMultiple	$0E, $00, $01, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1B, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0E, $04
	sDecay2Rate	$07, $01, $01, $01
	sDecay1Level	$05, $0F, $05, $07
	sReleaseRate	$04, $06, $05, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $17, $1C, $0C
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$02
	sFeedback	$02
	sDetune		$00, $03, $00, $05
	sMultiple	$04, $01, $02, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$13, $1F, $13, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $04, $02, $04
	sDecay2Rate	$1D, $03, $0E, $03
	sDecay1Level	$06, $02, $02, $02
	sReleaseRate	$02, $05, $03, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$24, $22, $16, $0F
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$03, $00, $00, $00
	sMultiple	$02, $00, $00, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$06, $07, $09, $03
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$07, $06, $05, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$11, $18, $1B, $08
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$02
	sFeedback	$05
	sDetune		$05, $01, $00, $00
	sMultiple	$01, $03, $06, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $19, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0B, $0B, $0B, $09
	sDecay2Rate	$06, $06, $0A, $06
	sDecay1Level	$02, $02, $06, $02
	sReleaseRate	$04, $05, $04, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$22, $24, $26, $06
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$03, $07, $05, $02
	sMultiple	$0E, $0A, $03, $07
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $0A, $1F, $1F
	sDecay2Rate	$01, $01, $09, $09
	sDecay1Level	$02, $02, $00, $00
	sReleaseRate	$03, $03, $05, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $18, $14, $14
	sFinishVoice

	sNewVoice	v05
	sAlgorithm	$00
	sFeedback	$05
	sDetune		$03, $00, $00, $00
	sMultiple	$01, $02, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1B, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $05, $00, $03
	sDecay2Rate	$01, $01, $00, $00
	sDecay1Level	$01, $01, $00, $01
	sReleaseRate	$00, $00, $00, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$12, $18, $12, $05
	sFinishVoice

	sNewVoice	v06
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$02, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$13, $1B, $0F, $11
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$03, $07, $0B, $03
	sDecay2Rate	$00, $04, $00, $00
	sDecay1Level	$02, $00, $07, $01
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$18, $18, $1A, $0C
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Clock_Samples:
	sNewSample	Kick
	sSampFreq	$0100
	sSampStart	dsKick, deKick
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Snare
	sSampFreq	$0100
	sSampStart	dsSnare, deSnare
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Crash3
	sSampFreq	$0100
	sSampStart	dsCrash, deCrash
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	MidTimpani
	sSampFreq	$0130
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Timpani8
	sSampFreq	$0120
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	LowTimpani
	sSampFreq	$00E0
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	VLowTimpani
	sSampFreq	$00C0
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Clock_Vib:
	sVibrato FM2,		$0C, $00, $4000, $002E, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Clock_Env:
	sEnvelope v01,		Clock_Env_v01
	sEnvelope v02,		Clock_Env_v02
	sEnvelope v03,		Clock_Env_v03
	sEnvelope v06,		Clock_Env_v06
; ---------------------------------------------------------------------------

Clock_Env_v01:
	sEnv		delay=$03,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Clock_Env_v02:
	sEnv		delay=$01,	$00, $10, $20, $30, $40, $7F
	seMute
; ---------------------------------------------------------------------------

Clock_Env_v03:
	sEnv		delay=$02,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Clock_Env_v06:
	sEnv		delay=$03,	$18, $10, $10, $08
	seHold		$00

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Clock_DAC1:
	sPan		center
	sNote		nRst, $88E

	sCall		$03, Clock_Loop01
	sSample		Kick
	sNote		$0F
	sNote		$05
	sNote		$05
	sNote		$05
	sSample		Snare
	sNote		$17
	sSample		Kick
	sNote		$06

Clock_Jump00:
	sNote		nRst, $01
	sCall		$03, Clock_Loop01
	sSample		Kick
	sNote		$0F
	sNote		$08
	sNote		$07

	sCall		$04, Clock_Loop03
	sSample		Snare
	sNote		$17
	sSample		Kick
	sNote		$07
	sNote		$0F

	sCall		$07, Clock_Loop04
	sNote		$05
	sNote		$05
	sNote		$05
	sSample		Snare
	sNote		$0F
	sNote		$0F
	sSample		Crash3
	sNote		$0F
	sCall		$01, Clock_Loop05
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$17
	sNote		$07
	sNote		$08
	sNote		$07
	sSample		Crash3
	sNote		$0F

	sCall		$02, Clock_Loop05
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$0F

	sCall		$03, Clock_Loop05
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$0F
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$07
	sNote		$08
	sNote		$07
	sSample		Crash3
	sNote		$0F
	sSample		Snare
	sNote		$0F
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$16
	sSample		Snare
	sNote		$0F
	sSample		Crash3
	sNote		$0F
	sSample		Snare
	sNote		$0F
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sSample		Crash3
	sNote		$0F
	sSample		Snare
	sNote		$08
	sNote		$07
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$08
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sNote		$08
	sNote		$0F
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Timpani8
	sNote		$04
	sNote		$04
	sSample		MidTimpani
	sNote		$03
	sNote		$04
	sSample		LowTimpani
	sNote		$04
	sNote		$04
	sSample		VLowTimpani
	sNote		$03
	sNote		$04
	sSample		Crash3
	sNote		$0F
	sSample		Snare
	sNote		$0F
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$16
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sSample		Snare
	sNote		$07
	sNote		$0F
	sNote		$0F
	sNote		$08
	sNote		$0F
	sNote		$07
	sNote		$0F
	sNote		$0F
	sNote		$08
	sNote		$07
	sSample		Crash3
	sNote		$7F
	sNote		nRst, $71

	sCall		$03, Clock_Loop01
	sSample		Kick
	sNote		$0F
	sNote		$05
	sNote		$05
	sNote		$05
	sSample		Snare
	sNote		$17
	sSample		Kick
	sNote		$07
	sJump		Clock_Jump00

Clock_Loop01:
	sSample		Kick
	sNote		nSample, $0F
	sNote		$0F
	sSample		Snare
	sNote		$1E
	sRet

Clock_Loop03:
	sSample		Snare
	sNote		$1E
	sSample		Kick
	sNote		$0F
	sNote		$0F
	sRet

Clock_Loop04:
	sNote		$0F
	sSample		Snare
	sNote		$1E
	sSample		Kick
	sNote		$0F
	sRet

Clock_Loop05:
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$08
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Clock_FM1:
	sNote		nRst, $96
	sFrac		-$0C00
	sVoice		v04
	sVol		$06
	sPan		center
	sCall		$02, Clock_Loop43
	sNote		nAs2, $1E
	sCall		$02, Clock_Loop44
	sVol		$07
	sNote		$1E
	sVol		$07
	sNote		$1E
	sVol		$06
	sNote		$96
	sVol		-$14

	sNote		nA2, $1E
	sVol		$07
	sNote		$1E
	sVol		$07
	sNote		$1E
	sVol		$06
	sNote		$96
	sVol		-$15

	sNote		nRst, $168
	sFrac		$0C00
	sVoice		v00
	sCall		$20, Clock_Loop46

Clock_Jump05:
	sCall		$10, Clock_Loop46
	sCall		$04, Clock_Loop47
	sCall		$04, Clock_Loop48
	sCall		$08, Clock_Loop49
	sCall		$10, Clock_Loop46
	sCall		$04, Clock_Loop47
	sCall		$04, Clock_Loop4C
	sCall		$08, Clock_Loop49
	sCall		$08, Clock_Loop46

	sNote		nG2, $08
	sNote		nA2, $07
	sNote		nAs2, $08
	sNote		nG2, $07
	sNote		nA2, $08
	sNote		nAs2, $07
	sNote		nC3, $08
	sNote		nA2, $07
	sNote		nAs2, $08
	sNote		nC3, $07
	sNote		nD3, $08
	sNote		nAs2, $07
	sNote		nC3, $08
	sNote		nD3, $07
	sNote		nDs3, $08
	sNote		nC3, $07

	sVol		-$02
	sCall		$0D, Clock_Loop4F
	sNote		nA2, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06
	sNote		nRst, $01
	sVol		-$06
	sNote		nAs2, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06
	sNote		nRst, $01
	sVol		-$06
	sNote		nC3, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06

	sCall		$03, Clock_Loop50
	sCall		$05, Clock_Loop51
	sCall		$04, Clock_Loop52
	sCall		$02, Clock_Loop53

	sNote		nRst, $09
	sVol		-$06
	sNote		nD3, $15
	sNote		nRst, $01

	sCall		$0D, Clock_Loop4F
	sNote		nA2, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06
	sNote		nRst, $01
	sVol		-$06
	sNote		nAs2, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06
	sNote		nRst, $01
	sVol		-$06
	sNote		nC3, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06

	sCall		$03, Clock_Loop50
	sCall		$05, Clock_Loop51
	sCall		$04, Clock_Loop52
	sCall		$04, Clock_Loop53

	sNote		nRst, $01
	sVol		-$04
	sCall		$02, Clock_Loop59
	sCall		$02, Clock_Loop5A
	sNote		nD3, $08
	sNote		nRst, $07
	sNote		nD3, $08
	sNote		nRst, $07
	sNote		nDs3, $08
	sNote		nRst, $07
	sNote		nC3, $05
	sNote		nRst, $03
	sNote		nC3, $07
	sNote		nRst, $08
	sNote		nCs3, $05
	sNote		nRst, $02
	sNote		nCs3, $08
	sNote		nRst, $0F
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nD2, $0F

	sCall		$20, Clock_Loop46
	sNote		nRst, $01
	sJump		Clock_Jump05

Clock_Loop43:
	sNote		nA2, $1E
	sVol		$07
	sNote		$1E
	sVol		$07
	sNote		$1E
	sVol		$06
	sNote		$96
	sVol		-$14
	sRet

Clock_Loop44:
	sVol		$07
	sNote		$1E
	sVol		$07
	sNote		$1E
	sVol		$06
	sNote		$96
	sVol		-$14
	sNote		nC3, $1E
	sRet

Clock_Loop46:
	sNote		nG2, $09
	sNote		nRst, $06
	sRet

Clock_Loop47:
	sNote		nDs2, $09
	sNote		nRst, $06
	sRet

Clock_Loop48:
	sNote		nFs2, $09
	sNote		nRst, $06
	sRet

Clock_Loop49:
	sNote		nD2, $09
	sNote		nRst, $06
	sRet

Clock_Loop4C:
	sNote		nE2, $09
	sNote		nRst, $06
	sRet

Clock_Loop4F:
	sNote		nG2, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nG2, $06
	sNote		nRst, $01
	sVol		-$06
	sRet

Clock_Loop50:
	sNote		nRst, $01
	sVol		-$06
	sNote		nDs3, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nDs3, $06
	sRet

Clock_Loop51:
	sNote		nRst, $01
	sVol		-$06
	sNote		nC3, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nC3, $06
	sRet

Clock_Loop52:
	sNote		nRst, $01
	sVol		-$06
	sNote		nA2, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nA2, $06
	sRet

Clock_Loop53:
	sNote		nRst, $01
	sVol		-$06
	sNote		nD3, $06
	sNote		nRst, $02
	sVol		$06
	sNote		nD3, $06
	sRet

Clock_Loop59:
	sNote		nG3, $08
	sNote		nRst, $07
	sNote		nG3, $08
	sNote		nRst, $07
	sNote		nGs3, $08
	sNote		nRst, $07
	sNote		nF3, $05
	sNote		nRst, $03
	sNote		nF3, $07
	sNote		nRst, $08
	sNote		nFs3, $05
	sNote		nRst, $02
	sNote		nFs3, $0E
	sNote		nRst, $01
	sRet

Clock_Loop5A:
	sNote		nG3, $08
	sNote		nRst, $07
	sNote		nG3, $08
	sNote		nRst, $07
	sNote		nGs3, $08
	sNote		nRst, $07
	sNote		nF3, $05
	sNote		nRst, $03
	sNote		nF3, $07
	sNote		nRst, $08
	sNote		nFs3, $05
	sNote		nRst, $02
	sNote		nFs3, $08
	sNote		nRst, $07
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Clock_FM2:
	sNote		nRst, $762
	sVoice		v02
	sPan		center
	sVol		$0A
	sVibratoSet	FM2

	sFrac		-$0028		; ssDetune $FA
	sNote		nCs5, $01
	sFrac		-$0009		; ssDetune $F8
	sNote		sHold, nD5, $03
	sFrac		$0025		; ssDetune $FE
	sNote		sHold, $22
	sFrac		-$0006		; ssDetune $FD
	sNote		sHold, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		sHold, $04
	sFrac		-$0007		; ssDetune $FB
	sNote		sHold, $04
	sFrac		-$000C		; ssDetune $F9
	sNote		sHold, $01
	sFrac		-$004B		; ssDetune $ED
	sNote		sHold, $03
	sFrac		$00A1		; ssDetune $07
	sNote		sHold, nCs5, $01
	sFrac		-$0060		; ssDetune $F8
	sNote		sHold, $02
	sFrac		$009A		; ssDetune $0F
	sNote		sHold, nC5
	sFrac		-$005F		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0006		; ssDetune $00

	sCall		$08, Clock_Loop41
	sNote		nRst, $167
	sVol		-$06
	sVoice		v01

Clock_Jump04:
	sVol		-$03
	sNote		nRst, $01
	sNote		nD4, $0F
	sNote		nRst, $08
	sNote		nAs4, $1E
	sNote		nRst, $07
	sNote		nA4, $0F
	sNote		nRst, $08
	sNote		nCs4, $1E
	sNote		nRst, $07
	sNote		nC4, $0F
	sNote		nRst, $08
	sNote		nGs4, $1E
	sNote		nRst, $07
	sNote		nG4, $0F
	sNote		nRst, $08
	sNote		nAs3, $1E
	sNote		nRst, $07
	sNote		nAs3, $0F
	sNote		nRst, $08
	sNote		nG4, $1E
	sNote		nRst, $07
	sNote		nFs4, $0F
	sNote		nRst, $08
	sNote		nCs4, $15
	sNote		nRst, $01
	sNote		nDs4, $0E
	sNote		nRst, $01
	sNote		nD4, $77
	sNote		nRst, $01
	sNote		nD4, $0F
	sNote		nRst, $08
	sNote		nD5, $1E
	sNote		nRst, $07
	sNote		nCs5, $0F
	sNote		nRst, $08
	sNote		nE4, $1E
	sNote		nRst, $07
	sNote		nDs4, $0F
	sNote		nRst, $08
	sNote		nC5, $1E
	sNote		nRst, $07
	sNote		nAs4, $0F
	sNote		nRst, $08
	sNote		nD4, $1E
	sNote		nRst, $07
	sNote		nC4, $15
	sNote		nRst, $02
	sNote		nD4, $0F
	sNote		nRst, $07
	sNote		nDs4, $0E
	sNote		nRst, $01
	sNote		nG4, $15
	sNote		nRst, $02
	sNote		nAs4, $0F
	sNote		nRst, $07
	sNote		nA4, $0E
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nFs4, $06
	sNote		nRst, $02
	sNote		nE4, $06
	sNote		nRst, $01
	sNote		nFs4, $35
	sNote		nRst, $07
	sNote		nG4, $5E
	sNote		nA4, $04
	sNote		nAs4, $03
	sNote		nC5, $04
	sNote		nD5
	sNote		nE5
	sNote		nF5, $03
	sNote		nFs5, $04
	sVol		$02
	sNote		nG5, $77

	sVoice		v05
	sLFO		3.98hz
	sAMSFMS		0db, 10%
	sNote		nRst, $01
	sVol		$04
	sNote		nD5, $0E
	sNote		nRst, $01
	sNote		nC5, $05
	sNote		nRst, $03
	sVol		$02
	sNote		nAs4, $07
	sVol		$05
	sNote		nC5, $08
	sVol		-$07
	sNote		nD5, $05
	sNote		nRst, $02
	sNote		nC5, $2C
	sNote		nRst, $01
	sVol		$02
	sNote		nA4, $1D
	sNote		nRst, $01
	sVol		-$02
	sNote		nC5, $0E
	sNote		nRst, $01
	sVol		$02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nA4, $07
	sVol		$05
	sNote		nAs4, $08
	sVol		-$07
	sNote		nC5, $05
	sNote		nRst, $02
	sVol		$02
	sNote		nAs4, $2C
	sNote		nRst, $01
	sNote		nG4, $1D
	sNote		nRst, $01
	sVol		-$02
	sNote		nG5, $0E
	sNote		nRst, $01
	sNote		nF5, $05
	sNote		nRst, $03
	sVol		$02
	sNote		nDs5, $07
	sVol		$05
	sNote		nF5, $08
	sVol		-$07
	sNote		nD5, $05
	sNote		nRst, $02
	sNote		nDs5, $2C
	sNote		nRst, $01
	sNote		nC5, $1D
	sNote		nRst, $01
	sNote		nCs5, $1D
	sNote		nRst, $01
	sVol		$07
	sNote		nCs5, $08
	sVol		-$07
	sNote		nA4, $06
	sNote		nRst, $01
	sNote		nCs5, $06
	sNote		nRst, $02
	sNote		nE5, $06
	sNote		nRst, $01
	sNote		nG5, $1D
	sNote		nRst, $01
	sNote		nFs5, $1D
	sNote		nRst, $01
	sNote		nG5, $7F
	sNote		sHold, $53
	sNote		nRst, $1E
	sNote		nD5, $0E
	sNote		nRst, $01
	sNote		nC5, $05
	sNote		nRst, $03
	sVol		$02
	sNote		nAs4, $07
	sVol		$05
	sNote		nC5, $08
	sVol		-$07
	sNote		nD5, $05
	sNote		nRst, $02
	sNote		nC5, $2C
	sNote		nRst, $01
	sVol		$02
	sNote		nG4, $1D
	sNote		nRst, $01
	sNote		nAs4, $2C
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $06
	sNote		nRst, $01
	sNote		nA4, $13
	sNote		nRst, $0A

	sVoice		v06
	sAMSFMS		0db, 10%
	sNote		$01
	sVol		-$04
	sNote		nD5, $06
	sNote		nRst, $02
	sNote		nE5, $06
	sNote		nRst, $01
	sNote		nF5, $06
	sNote		nRst, $02
	sNote		nFs5, $06
	sNote		nRst, $01

	sCall		$05, Clock_Loop42
	sNote		nRst, $08
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nC5, $06
	sNote		nRst, $02
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nAs4, $06
	sNote		nRst, $02
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nA4, $06
	sNote		nRst, $02
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nAs4, $06
	sNote		nRst, $02
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nG4, $06
	sNote		nRst, $02
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nA4, $06
	sNote		nRst, $02
	sNote		nD5, $06
	sNote		nRst, $01
	sNote		nD3, $0E

	sVoice		v01
	sNote		nRst, $1E1
	sVol		-$01
	sJump		Clock_Jump04

Clock_Loop41:
	sNote		sHold, nD5, $01
	sFrac		-$002B		; ssDetune $F9
	sNote		sHold, $02
	sFrac		-$004B		; ssDetune $ED
	sNote		sHold, $02
	sFrac		$00A1		; ssDetune $07
	sNote		sHold, nCs5, $01
	sFrac		-$0060		; ssDetune $F8
	sNote		sHold, $03
	sFrac		$009A		; ssDetune $0F
	sNote		sHold, nC5, $01
	sFrac		-$005F		; ssDetune $01
	sNote		sHold, $05
	sFrac		-$0006		; ssDetune $00
	sRet

Clock_Loop42:
	sNote		nG5, $08
	sNote		nRst, $07
	sNote		nG5, $08
	sNote		nRst, $07
	sNote		nGs5, $08
	sNote		nRst, $07
	sNote		nF5, $06
	sNote		nRst, $02
	sNote		nF5, $07
	sNote		nRst, $08
	sNote		nFs5, $06
	sNote		nRst, $01
	sNote		nFs5, $08
	sNote		nRst, $07
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Clock_FM3:
	sNote		nRst, $76D
	sVibratoSet	FM2
	sFrac		-$0018
	sVoice		v02
	sPan		center
	sVol		$0E

	sFrac		-$0043		; ssDetune $F6
	sNote		nCs5, $01
	sFrac		-$0007		; ssDetune $F4
	sNote		sHold, nD5, $02
	sFrac		$0025		; ssDetune $FA
	sNote		sHold, $22
	sFrac		-$0006		; ssDetune $F9
	sNote		sHold, $04
	sFrac		-$0006		; ssDetune $F8
	sNote		sHold, $04
	sFrac		-$0007		; ssDetune $F7
	sNote		sHold, $03
	sFrac		-$000C		; ssDetune $F5
	sNote		sHold, $02
	sFrac		-$004B		; ssDetune $E9
	sNote		sHold, $02
	sFrac		$00A1		; ssDetune $3
	sNote		sHold, nCs5, $01
	sFrac		-$0062		; ssDetune $F4
	sNote		sHold, $03
	sFrac		$009A		; ssDetune $0B
	sNote		sHold, nC5, $01
	sFrac		-$0054		; ssDetune -$3
	sNote		sHold, $03
	sFrac		$000A		; ssDetune $00

	sCall		$08, Clock_Loop3E
	sNote		nRst, $15C
	sVol		-$06

Clock_Jump03:
	sNote		nRst, $0C

	sFrac		-$0018
	sVoice		v01
	sVol		-$03
	sNote		nD4, $0F
	sNote		nRst, $08
	sNote		nAs4, $1E
	sNote		nRst, $07
	sNote		nA4, $0F
	sNote		nRst, $08
	sNote		nCs4, $1E
	sNote		nRst, $07
	sNote		nC4, $0F
	sNote		nRst, $08
	sNote		nGs4, $1E
	sNote		nRst, $07
	sNote		nG4, $0F
	sNote		nRst, $08
	sNote		nAs3, $1E
	sNote		nRst, $07
	sNote		nAs3, $0F
	sNote		nRst, $08
	sNote		nG4, $1E
	sNote		nRst, $07
	sNote		nFs4, $0F
	sNote		nRst, $08
	sNote		nCs4, $15
	sNote		nRst, $01
	sNote		nDs4, $0E
	sNote		nRst, $01
	sNote		nD4, $77
	sNote		nRst, $01
	sNote		nD4, $0F
	sNote		nRst, $08
	sNote		nD5, $1E
	sNote		nRst, $07
	sNote		nCs5, $0F
	sNote		nRst, $08
	sNote		nE4, $1E
	sNote		nRst, $07
	sNote		nDs4, $0F
	sNote		nRst, $08
	sNote		nC5, $1E
	sNote		nRst, $07
	sNote		nAs4, $0F
	sNote		nRst, $08
	sNote		nD4, $1E
	sNote		nRst, $07
	sNote		nC4, $16
	sNote		nRst, $01
	sNote		nD4, $0F
	sNote		nRst, $07
	sNote		nDs4, $0E
	sNote		nRst, $01
	sNote		nG4, $16
	sNote		nRst, $01
	sNote		nAs4, $0F
	sNote		nRst, $07
	sNote		nA4, $0E
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nFs4, $07
	sNote		nRst, $01
	sNote		nE4, $06
	sNote		nRst, $01
	sNote		nFs4, $35
	sNote		nRst, $07
	sNote		nG4, $5E
	sNote		nA4, $04
	sNote		nAs4
	sNote		nC5, $03
	sNote		nD5, $04
	sNote		nE5
	sNote		nF5
	sNote		nFs5, $03
	sVol		$02
	sNote		nG5, $77
	sNote		nRst, $01

	sVoice		v05
	sLFO		3.98hz
	sAMSFMS		0db, 10%
	sVol		$03
	sNote		nD5, $0E
	sNote		nRst, $01
	sNote		nC5, $05
	sNote		nRst, $03
	sVol		$03
	sNote		nAs4, $07
	sVol		$05
	sNote		nC5, $08
	sVol		$F8
	sNote		nD5, $05
	sNote		nRst, $02
	sNote		nC5, $2C
	sNote		nRst, $01
	sVol		$03
	sNote		nA4, $1D
	sNote		nRst, $01
	sVol		-$03
	sNote		nC5, $0E
	sNote		nRst, $01
	sVol		$03
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nA4, $07
	sVol		$05
	sNote		nAs4, $08
	sVol		$F8
	sNote		nC5, $05
	sNote		nRst, $02
	sVol		$03
	sNote		nAs4, $2C
	sNote		nRst, $01
	sNote		nG4, $1D
	sNote		nRst, $01
	sVol		-$03
	sNote		nG5, $0E
	sNote		nRst, $01
	sNote		nF5, $05
	sNote		nRst, $03
	sVol		$03
	sNote		nDs5, $07
	sVol		$05
	sNote		nF5, $08
	sVol		$F8
	sNote		nD5, $05
	sNote		nRst, $02
	sNote		nDs5, $2C
	sNote		nRst, $01
	sNote		nC5, $1D
	sNote		nRst, $01
	sNote		nCs5, $1D
	sNote		nRst, $01
	sVol		$08
	sNote		nCs5, $08
	sVol		$F8
	sNote		nA4, $06
	sNote		nRst, $01
	sNote		nCs5, $07
	sNote		nRst, $01
	sNote		nE5, $06
	sNote		nRst, $01
	sNote		nG5, $1D
	sNote		nRst, $01
	sNote		nFs5, $1D
	sNote		nRst, $01
	sNote		nG5, $7F
	sNote		sHold, $53
	sNote		nRst, $1E
	sNote		nD5, $0E
	sNote		nRst, $01
	sNote		nC5, $05
	sNote		nRst, $03
	sVol		$03
	sNote		nAs4, $07
	sVol		$05
	sNote		nC5, $08
	sVol		$F8
	sNote		nD5, $05
	sNote		nRst, $02
	sNote		nC5, $2C
	sNote		nRst, $01
	sVol		$03
	sNote		nG4, $1D
	sNote		nRst, $01
	sNote		nAs4, $2C
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $06
	sNote		nRst, $01
	sNote		nA4, $13
	sVol		-$04
	sNote		nD4, $06
	sNote		nRst, $02
	sNote		nE4, $06
	sNote		nRst, $01
	sFrac		$0018

	sLFO		off
	sVoice		v06
	sNote		nF4, $06
	sNote		nRst, $02
	sNote		nFs4, $06
	sNote		nRst, $01

	sCall		$04, Clock_Loop3F
	sNote		nG4, $08
	sNote		nRst, $07
	sNote		nG4, $08
	sNote		nRst, $07
	sNote		nGs4, $08
	sNote		nRst, $07
	sNote		nF4, $06
	sNote		nRst, $02
	sNote		nF4, $07
	sNote		nRst, $08
	sNote		nFs4, $06
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $0F
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nC4, $06
	sNote		nRst, $02
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nRst, $02
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $02
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nRst, $02
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $02
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $02
	sNote		nD4, $06
	sNote		nRst, $01
	sNote		nD4, $0E

	sVoice		v01
	sNote		nRst, $1E1
	sVol		-$01
	sJump		Clock_Jump03

Clock_Loop3E:
	sFrac		-$0018		; ssDetune $FC
	sNote		sHold, nD5, $01
	sFrac		-$002C		; ssDetune $F5
	sNote		sHold, $01
	sFrac		-$004B		; ssDetune $E9
	sNote		sHold, $03
	sFrac		$00A1		; ssDetune $3
	sNote		sHold, nCs5, $01
	sFrac		-$0062		; ssDetune $F4
	sNote		sHold, $02
	sFrac		$009A		; ssDetune $0B
	sNote		sHold, nC5
	sFrac		-$0054		; ssDetune -$3
	sNote		sHold, $05
	sFrac		$000A		; ssDetune $00
	sRet

Clock_Loop3F:
	sNote		nG4, $08
	sNote		nRst, $07
	sNote		nG4, $08
	sNote		nRst, $07
	sNote		nGs4, $08
	sNote		nRst, $07
	sNote		nF4, $06
	sNote		nRst, $02
	sNote		nF4, $07
	sNote		nRst, $08
	sNote		nFs4, $06
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $07
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Clock_FM4:
	sNote		nRst, $01
	sVibratoSet	FM2
	sFrac		-$0C00
	sVoice		v03
	sVol		$0E
	sPan		center

	sNote		$1E
	sNote		nD6, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nB5, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nC6, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nC6, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nB5, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nC6, $07
	sVol		$0C
	sNote		$07
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $07
	sVol		$0C
	sNote		$07

	sCall		$02, Clock_Loop22
	sCall		$04, Clock_Loop23
	sCall		$04, Clock_Loop24
	sCall		$04, Clock_Loop25
	sCall		$04, Clock_Loop26
	sCall		$02, Clock_Loop27
	sCall		$02, Clock_Loop28

	sVol		-$0C
	sNote		nG6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nF6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nG6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nDs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nD6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nDs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nG5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nDs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nG5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nF5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nG5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs4, $06

	sCall		$04, Clock_Loop29
	sVol		$0C
	sNote		$08
	sNote		nRst, $01

	sFrac		$0C00
	sVoice		v02
	sVol		-$12
	sNote		nG2
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0C
	sFrac		$0004		; ssDetune $00
	sNote		nD3, $08
	sFrac		$002F		; ssDetune $08
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$00D6		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nD3
	sFrac		-$0053		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$0044		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00BA		; ssDetune $13
	sNote		sHold, nCs3
	sFrac		-$0076		; ssDetune $00
	sNote		nG2, $11

	sVol		-$02
	sFrac		$0056		; ssDetune $18
	sNote		nAs2, $01
	sFrac		-$007A		; ssDetune $F6
	sNote		sHold, nB2
	sFrac		$002B		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F8
	sNote		sHold, nC3
	sFrac		$0019		; ssDetune $FF
	sNote		sHold, $08
	sNote		sHold, nGs2, $02
	sFrac		$0003		; ssDetune $00
	sVol		$02

	sNote		nG2, $0F
	sNote		$01
	sFrac		$0023		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0032		; ssDetune $13
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $E4
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $00
	sNote		sHold, $0A
	sFrac		-$007D		; ssDetune $E5
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $F4
	sNote		sHold, nFs2
	sFrac		$0041		; ssDetune $01
	sNote		sHold, nF2
	sFrac		$003B		; ssDetune $0C
	sNote		sHold, nE2
	sFrac		-$0002		; ssDetune $0B
	sNote		sHold, nDs2
	sFrac		-$00C0		; ssDetune $EA
	sNote		sHold, $01
	sFrac		$0082		; ssDetune $00
	sNote		nG2

	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02
	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00

	sVol		-$02
	sNote		nE3, $01
	sFrac		$0055		; ssDetune $10
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		$005A		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0028		; ssDetune $09
	sNote		sHold, $01
	sFrac		$0041		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$004B		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0053		; ssDetune $F7
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$00D5		; ssDetune $10
	sNote		sHold, nE3
	sFrac		-$00AF		; ssDetune $EF
	sNote		sHold, nF3
	sFrac		$0073		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0055		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$006E		; ssDetune $00

	sNote		nE3, $0D
	sFrac		$0040		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		-$001B		; ssDetune $EB
	sNote		sHold, $01
	sFrac		$007A		; ssDetune $02
	sNote		sHold, nE3
	sFrac		$0045		; ssDetune $0E
	sNote		sHold, nDs3
	sFrac		-$0090		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$0021		; ssDetune $0D
	sNote		sHold, nE3
	sFrac		-$0022		; ssDetune $07
	sNote		sHold, nF3
	sFrac		-$0023		; ssDetune $00

	sNote		nC3, $0F
	sVol		$02
	sNote		nG2, $10
	sFrac		$004F		; ssDetune $11
	sNote		sHold, nFs2, $01
	sFrac		-$0013		; ssDetune $0C
	sNote		sHold, nF2
	sFrac		-$0012		; ssDetune $08
	sNote		sHold, nE2
	sFrac		-$0014		; ssDetune $04
	sNote		sHold, nDs2
	sFrac		-$0067		; ssDetune $F3
	sNote		sHold, nD2
	sFrac		-$0014		; ssDetune $F1
	sNote		sHold, nCs2
	sFrac		$0065		; ssDetune $00

	sNote		nG2
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02
	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0C
	sFrac		$0004		; ssDetune $00
	sNote		nD3, $08
	sFrac		$002F		; ssDetune $08
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$00D6		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nD3
	sFrac		-$0053		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$0044		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00BA		; ssDetune $13
	sNote		sHold, nCs3
	sFrac		-$0076		; ssDetune $00
	sNote		nG2, $11
	sVol		-$02

	sFrac		$0056		; ssDetune $18
	sNote		nAs2, $01
	sFrac		-$007A		; ssDetune $F6
	sNote		sHold, nB2
	sFrac		$002B		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F8
	sNote		sHold, nC3
	sFrac		$0019		; ssDetune $FF
	sNote		sHold, $08
	sNote		sHold, nGs2, $02
	sFrac		$0003		; ssDetune $00

	sVol		$02
	sNote		nG2, $0F
	sNote		$01
	sFrac		$0023		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0032		; ssDetune $13
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $E4
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $00
	sNote		sHold, $0A
	sFrac		-$007D		; ssDetune $E5
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $F4
	sNote		sHold, nFs2
	sFrac		$0041		; ssDetune $01
	sNote		sHold, nF2
	sFrac		$003B		; ssDetune $0C
	sNote		sHold, nE2
	sFrac		-$0002		; ssDetune $0B
	sNote		sHold, nDs2
	sFrac		-$00C0		; ssDetune $EA
	sNote		sHold, $01
	sFrac		$0082		; ssDetune $00

	sNote		nG2
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02
	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$0055		; ssDetune $10
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		$005A		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0028		; ssDetune $09
	sNote		sHold, $01
	sFrac		$0041		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$004B		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0053		; ssDetune $F7
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$00D5		; ssDetune $10
	sNote		sHold, nE3
	sFrac		-$00AF		; ssDetune $EF
	sNote		sHold, nF3
	sFrac		$0073		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0055		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$006E		; ssDetune $00

	sNote		nE3, $0D
	sFrac		$0040		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		-$001B		; ssDetune $EB
	sNote		sHold, $01
	sFrac		$007A		; ssDetune $02
	sNote		sHold, nE3
	sFrac		$0045		; ssDetune $0E
	sNote		sHold, nDs3
	sFrac		-$0090		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$0021		; ssDetune $0D
	sNote		sHold, nE3
	sFrac		-$0022		; ssDetune $07
	sNote		sHold, nF3
	sFrac		-$0023		; ssDetune $00

	sNote		nC3, $0F
	sVol		$02
	sNote		nG2, $10
	sFrac		$004F		; ssDetune $11
	sNote		sHold, nFs2, $01
	sFrac		-$0013		; ssDetune $0C
	sNote		sHold, nF2
	sFrac		-$0012		; ssDetune $08
	sNote		sHold, nE2
	sFrac		-$0014		; ssDetune $04
	sNote		sHold, nDs2
	sFrac		-$0067		; ssDetune $F3
	sNote		sHold, nD2
	sFrac		-$0014		; ssDetune $F1

Clock_Jump02:
	sNote		sHold, nCs2, $01
	sVol		$03
	sFrac		$0065		; ssDetune $00

	sCall		$02, Clock_Loop2B
	sNote		nGs3, $0D
	sNote		nRst, $02
	sNote		nGs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2C
	sNote		nG3, $0D
	sNote		nRst, $02
	sNote		nG3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2A
	sNote		nDs3, $0D
	sNote		nRst, $02
	sNote		nDs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2E
	sNote		nFs3, $0D
	sNote		nRst, $02
	sNote		nFs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2F
	sCall		$02, Clock_Loop31

	sNote		nG3, $0D
	sNote		nRst, $02
	sNote		nG3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2A
	sNote		nCs4, $0D
	sNote		nRst, $02
	sNote		nCs4, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop33
	sNote		nC3, $0D
	sNote		nRst, $02
	sNote		nC3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop34
	sNote		nAs2, $0D
	sNote		nRst, $02
	sNote		nAs2, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop35
	sNote		nC4, $0D
	sNote		nRst, $02
	sNote		nC4, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop36
	sNote		nAs3, $0D
	sNote		nRst, $02
	sNote		nAs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop37
	sNote		nG3, $0D
	sNote		nRst, $02
	sNote		nG3, $0D
	sNote		nRst, $02
	sNote		nG3, $04
	sNote		nRst, $0B
	sNote		nA3, $0D
	sNote		nRst, $02
	sNote		nA3, $0D
	sNote		nRst, $02
	sCall		$03, Clock_Loop30

	sVol		-$03
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nG2, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nA2, $06

	sCall		$02, Clock_Loop39
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nDs3, $06
	sNote		nRst, $01
	sNote		nF3, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $02
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $02
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nRst, $02
	sNote		nD3
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nAs3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $02
	sNote		nD3
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nF3, $06
	sNote		nRst, $02
	sNote		nD3
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nF3, $06
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $02
	sNote		nD3
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $02
	sNote		nD3
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $02
	sNote		nAs2
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nG2, $06
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $02
	sNote		nAs2
	sNote		nRst, $05
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nAs2, $03
	sNote		nRst, $05

	sCall		$02, Clock_Loop3A
	sNote		nC3
	sNote		nRst, $05
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nC3, $03
	sNote		nRst, $05
	sNote		nC3, $06
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $02
	sNote		nC3, $06
	sNote		nRst, $01
	sNote		nE3, $06
	sNote		nRst, $02
	sNote		nCs3
	sNote		nRst, $05
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nCs3, $03
	sNote		nRst, $05
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nE3, $06
	sNote		nRst, $02
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nRst, $02
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nE3, $06
	sNote		nRst, $02
	sNote		nAs3, $06
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $02
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $02
	sNote		nC3, $06
	sNote		nRst, $01

	sVoice		v05
	sVol		$04
	sNote		nAs4, $0E
	sNote		nRst, $01
	sNote		nA4, $06
	sNote		nRst, $02
	sNote		nG4, $06
	sNote		nRst, $09
	sNote		nAs4, $06
	sNote		nRst, $01
	sNote		nA4, $2C
	sNote		nRst, $01
	sNote		nE4, $1D
	sNote		nRst, $01
	sNote		nGs4, $0E
	sNote		nRst, $01
	sNote		nG4, $06
	sNote		nRst, $02
	sNote		nF4, $06
	sNote		nRst, $09
	sNote		nGs4, $06
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nD4, $1D
	sNote		nRst, $01
	sVol		$03
	sNote		nAs4, $0E
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $07
	sNote		nRst, $08
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nA4, $2C
	sNote		nRst, $01
	sNote		nE4, $1D
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nE4, $06
	sNote		nRst, $01
	sNote		nFs4, $17
	sNote		nRst, $25

	sVol		-$07
	sCall		$01, Clock_FM4_00
	sVoice		v02
	sNote		nG2, $01
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0C
	sFrac		$0004		; ssDetune $00
	sNote		nD3, $08
	sFrac		$002F		; ssDetune $08
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$00D6		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nD3
	sFrac		-$0053		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$0044		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00BA		; ssDetune $13
	sNote		sHold, nCs3
	sFrac		-$0076		; ssDetune $00
	sNote		nG2, $11
	sVol		-$02

	sFrac		$0056		; ssDetune $18
	sNote		nAs2, $01
	sFrac		-$007A		; ssDetune $F6
	sNote		sHold, nB2
	sFrac		$002B		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F8
	sNote		sHold, nC3
	sFrac		$0019		; ssDetune $FF
	sNote		sHold, $08
	sNote		sHold, nGs2, $02
	sFrac		$0003		; ssDetune $00

	sVol		$02
	sNote		nG2, $0F
	sNote		$01
	sFrac		$0023		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0032		; ssDetune $13
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $E4
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $00
	sNote		sHold, $0A
	sFrac		-$007D		; ssDetune $E5
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $F4
	sNote		sHold, nFs2
	sFrac		$0041		; ssDetune $01
	sNote		sHold, nF2
	sFrac		$003B		; ssDetune $0C
	sNote		sHold, nE2
	sFrac		-$0002		; ssDetune $0B
	sNote		sHold, nDs2
	sFrac		-$00C0		; ssDetune $EA
	sNote		sHold, $01
	sFrac		$0082		; ssDetune $00

	sNote		nG2
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02
	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$0055		; ssDetune $10
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		$005A		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0028		; ssDetune $09
	sNote		sHold, $01
	sFrac		$0041		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$004B		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0053		; ssDetune $F7
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$00D5		; ssDetune $10
	sNote		sHold, nE3
	sFrac		-$00AF		; ssDetune $EF
	sNote		sHold, nF3
	sFrac		$0073		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0055		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$006E		; ssDetune $00

	sNote		nE3, $0D
	sFrac		$0040		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		-$001B		; ssDetune $EB
	sNote		sHold, $01
	sFrac		$007A		; ssDetune $02
	sNote		sHold, nE3
	sFrac		$0045		; ssDetune $0E
	sNote		sHold, nDs3
	sFrac		-$0090		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$0021		; ssDetune $0D
	sNote		sHold, nE3
	sFrac		-$0022		; ssDetune $07
	sNote		sHold, nF3
	sFrac		-$0023		; ssDetune $00

	sNote		nC3, $0F
	sVol		$02
	sNote		nG2, $10
	sFrac		$004F		; ssDetune $11
	sNote		sHold, nFs2, $01
	sFrac		-$0013		; ssDetune $0C
	sNote		sHold, nF2
	sFrac		-$0012		; ssDetune $08
	sNote		sHold, nE2
	sFrac		-$0014		; ssDetune $04
	sNote		sHold, nDs2
	sFrac		-$0067		; ssDetune $F3
	sNote		sHold, nD2
	sFrac		-$0014		; ssDetune $F1
	sNote		sHold, nCs2
	sFrac		$0065		; ssDetune $00

	sNote		nG2
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0C
	sFrac		$0004		; ssDetune $00
	sNote		nD3, $08
	sFrac		$002F		; ssDetune $08
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$00D6		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nD3
	sFrac		-$0053		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$0044		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00BA		; ssDetune $13
	sNote		sHold, nCs3
	sFrac		-$0076		; ssDetune $00
	sNote		nG2, $11
	sVol		-$02

	sFrac		$0056		; ssDetune $18
	sNote		nAs2, $01
	sFrac		-$007A		; ssDetune $F6
	sNote		sHold, nB2
	sFrac		$002B		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F8
	sNote		sHold, nC3
	sFrac		$0019		; ssDetune $FF
	sNote		sHold, $08
	sNote		sHold, nGs2, $02
	sFrac		$0003		; ssDetune $00

	sVol		$02
	sNote		nG2, $0F
	sNote		$01
	sFrac		$0023		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0032		; ssDetune $13
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $E4
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $00
	sNote		sHold, $0A
	sFrac		-$007D		; ssDetune $E5
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $F4
	sNote		sHold, nFs2
	sFrac		$0041		; ssDetune $01
	sNote		sHold, nF2
	sFrac		$003B		; ssDetune $0C
	sNote		sHold, nE2
	sFrac		-$0002		; ssDetune $0B
	sNote		sHold, nDs2
	sFrac		-$00C0		; ssDetune $EA
	sNote		sHold, $01
	sFrac		$0082		; ssDetune $00

	sNote		nG2
	sNote		nRst, $07
	sNote		nG2, $03
	sNote		nRst, $04
	sVol		-$02
	sNote		nD3, $08
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$0055		; ssDetune $10
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		$005A		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0028		; ssDetune $09
	sNote		sHold, $01
	sFrac		$0041		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$004B		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0053		; ssDetune $F7
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$00D5		; ssDetune $10
	sNote		sHold, nE3
	sFrac		-$00AF		; ssDetune $EF
	sNote		sHold, nF3
	sFrac		$0073		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0055		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$006E		; ssDetune $00

	sNote		nE3, $0D
	sFrac		$0040		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $F0
	sNote		sHold, nF3
	sFrac		-$001B		; ssDetune $EB
	sNote		sHold, $01
	sFrac		$007A		; ssDetune $02
	sNote		sHold, nE3
	sFrac		$0045		; ssDetune $0E
	sNote		sHold, nDs3
	sFrac		-$0090		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$0021		; ssDetune $0D
	sNote		sHold, nE3
	sFrac		-$0022		; ssDetune $07
	sNote		sHold, nF3
	sFrac		-$0023		; ssDetune $00
	sNote		nC3, $0F
	sVol		$02

	sNote		nG2, $10
	sFrac		$004F		; ssDetune $11
	sNote		sHold, nFs2, $01
	sFrac		-$0013		; ssDetune $0C
	sNote		sHold, nF2
	sFrac		-$0012		; ssDetune $08
	sNote		sHold, nE2
	sFrac		-$0014		; ssDetune $04
	sNote		sHold, nDs2
	sFrac		-$0067		; ssDetune $F3
	sNote		sHold, nD2
	sFrac		-$0014		; ssDetune $F1
	sNote		sHold, nCs2
	sJump		Clock_Jump02

Clock_FM4_00:
	sVoice		v02
	sCall		$02, Clock_Loop3B
	sCall		$02, Clock_Loop3C

	sNote		nD3, $08
	sNote		nRst, $07
	sNote		nD3, $08
	sNote		nRst, $07
	sNote		nDs3, $08
	sNote		nRst, $07
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nC3, $07
	sNote		nRst, $08
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $0F
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nD2, $0F
	sRet

Clock_Loop22:
	sVol		-$0C
	sNote		nC6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nB5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nC6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop23:
	sVol		-$0C
	sNote		nB5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nB5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nFs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop24:
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nF5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop25:
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nGs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nE5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop26:
	sVol		-$0C
	sNote		nDs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nD6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nDs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nC6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop27:
	sVol		-$0C
	sNote		nD6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nCs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nD6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop28:
	sVol		-$0C
	sNote		nFs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nE6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nFs6, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sRet

Clock_Loop29:
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nA5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nAs5, $06
	sVol		$0C
	sNote		$08
	sNote		nRst, $01
	sVol		-$0C
	sNote		nG5, $06
	sRet

Clock_Loop2B:
	sNote		nG3, $0D
	sNote		nRst, $02
	sNote		nG3, $0D
	sNote		nRst, $02
	sCall		$02, Clock_Loop2A
	sRet

Clock_Loop2A:
	sNote		nG2, $03
	sNote		nRst, $05
	sNote		nG2, $02
	sNote		nRst, $05
	sRet

Clock_Loop2C:
	sNote		nGs2, $03
	sNote		nRst, $05
	sNote		nGs2, $02
	sNote		nRst, $05
	sRet

Clock_Loop2E:
	sNote		nDs2, $03
	sNote		nRst, $05
	sNote		nDs2, $02
	sNote		nRst, $05
	sRet

Clock_Loop2F:
	sNote		nFs2, $03
	sNote		nRst, $05
	sNote		nFs2, $02
	sNote		nRst, $05
	sRet

Clock_Loop31:
	sNote		nA3, $0D
	sNote		nRst, $02
	sNote		nA3, $0D
	sNote		nRst, $02
	sCall		$02, Clock_Loop30
	sRet

Clock_Loop30:
	sNote		nA2, $03
	sNote		nRst, $05
	sNote		nA2, $02
	sNote		nRst, $05
	sRet

Clock_Loop33:
	sNote		nCs3, $03
	sNote		nRst, $05
	sNote		nCs3, $02
	sNote		nRst, $05
	sRet

Clock_Loop34:
	sNote		nC2, $03
	sNote		nRst, $05
	sNote		nC2, $02
	sNote		nRst, $05
	sRet

Clock_Loop35:
	sNote		nAs1, $03
	sNote		nRst, $05
	sNote		nAs1, $02
	sNote		nRst, $05
	sRet

Clock_Loop36:
	sNote		nC3, $03
	sNote		nRst, $05
	sNote		nC3, $02
	sNote		nRst, $05
	sRet

Clock_Loop37:
	sNote		nAs2, $03
	sNote		nRst, $05
	sNote		nAs2, $02
	sNote		nRst, $05
	sRet

Clock_Loop39:
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $02
	sNote		nC3, $06
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $02
	sNote		nC3, $06
	sRet

Clock_Loop3A:
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $02
	sRet

Clock_Loop3B:
	sNote		nG3, $08
	sNote		nRst, $07
	sNote		nG3, $08
	sNote		nRst, $07
	sNote		nGs3, $08
	sNote		nRst, $07
	sNote		nF3, $06
	sNote		nRst, $02
	sNote		nF3, $07
	sNote		nRst, $08
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $07
	sRet

Clock_Loop3C:
	sNote		nD3, $08
	sNote		nRst, $07
	sNote		nD3, $08
	sNote		nRst, $07
	sNote		nDs3, $08
	sNote		nRst, $07
	sNote		nC3, $06
	sNote		nRst, $02
	sNote		nC3, $07
	sNote		nRst, $08
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $07
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Clock_FM5:
	sNote		nRst, $08
	sVibratoSet	FM2
	sFrac		-$0C00
	sVoice		v03
	sVol		$12
	sPan		right

	sNote		$1F
	sNote		nD6, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nB5, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nC6, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nC6, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nB5, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nC6, $06
	sVol		$0B
	sNote		$08
	sNote		nRst, $01
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$08

	sCall		$02, Clock_Loop08
	sCall		$04, Clock_Loop09
	sCall		$04, Clock_Loop0A
	sCall		$04, Clock_Loop0B
	sCall		$04, Clock_Loop0C
	sCall		$02, Clock_Loop0D
	sCall		$02, Clock_Loop0E

	sVol		-$0B
	sNote		nG6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nF6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nG6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nDs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nD6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nDs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nG5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nDs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nG5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nF5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nG5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs4, $06

	sCall		$04, Clock_Loop0F
	sVol		$0B
	sNote		$07
	sNote		nRst, $02

	sFrac		$0C00
	sVoice		v02
	sVol		-$0E
	sNote		nG2, $01
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0D
	sFrac		$0004		; ssDetune $00
	sNote		nD3, $07
	sFrac		$0005		; ssDetune $01
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AC		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00D6		; ssDetune $12
	sNote		sHold, nD3
	sFrac		-$0042		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0041		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$0045		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $0C
	sNote		sHold, nCs3
	sFrac		-$004A		; ssDetune $00
	sNote		nG2, $10
	sVol		-$02

	sFrac		$0019		; ssDetune $07
	sNote		nAs2, $01
	sFrac		$005A		; ssDetune $20
	sNote		sHold, $01
	sFrac		-$0088		; ssDetune $FA
	sNote		sHold, nB2
	sFrac		$003B		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F4
	sNote		sHold, nC3
	sFrac		$0027		; ssDetune $FF
	sNote		sHold, $09
	sNote		sHold, nGs2, $01
	sFrac		$0003		; ssDetune $00
	sVol		$02

	sNote		nG2, $0F
	sNote		$01
	sFrac		$0008		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $1A
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $EB
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$0031		; ssDetune $00

	sNote		sHold, $0A
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		$0000		; ssDetune $0D
	sNote		sHold, nF2
	sFrac		-$00C1		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$0042		; ssDetune $F5
	sNote		sHold, nE2
	sFrac		$003E		; ssDetune $00
	sNote		sHold, nDs2
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD2
	sFrac		-$003B		; ssDetune $00
	sNote		nG2
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0056		; ssDetune $15
	sNote		sHold, $01
	sFrac		-$008A		; ssDetune $FB
	sNote		sHold, nF3
	sFrac		$001F		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0069		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$0019		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$004F		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$0094		; ssDetune $0E
	sNote		sHold, nE3
	sFrac		-$00BF		; ssDetune $EA
	sNote		sHold, nF3
	sFrac		$005B		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$0051		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $E9
	sNote		sHold, nFs3
	sFrac		$0073		; ssDetune $00

	sNote		nE3, $0C
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0036		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF3
	sFrac		$003A		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$0075		; ssDetune $0A
	sNote		sHold, nE3
	sFrac		-$008A		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$0071		; ssDetune $05
	sNote		sHold, nDs3
	sFrac		-$0045		; ssDetune $F9
	sNote		sHold, $01
	sFrac		$0024		; ssDetune $FF
	sNote		sHold, nE3
	sFrac		-$0025		; ssDetune $F8
	sNote		sHold, nF3
	sFrac		$002A		; ssDetune $00
	sNote		nC3, $0F
	sVol		$02

	sNote		nG2, $11
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, nFs2, $01
	sFrac		-$006B		; ssDetune $E9
	sNote		sHold, nF2
	sFrac		$00EB		; ssDetune $14
	sNote		sHold, nDs2
	sFrac		-$0012		; ssDetune $10
	sNote		sHold, nD2
	sFrac		-$000E		; ssDetune $0D
	sNote		sHold, nCs2
	sFrac		-$000E		; ssDetune $0A
	sNote		sHold, nC2
	sFrac		-$0043		; ssDetune $00
	sNote		nG2
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0D
	sFrac		$0004		; ssDetune $00
	sNote		nD3, $07
	sFrac		$0005		; ssDetune $01
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AC		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00D6		; ssDetune $12
	sNote		sHold, nD3
	sFrac		-$0042		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0041		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$0045		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $0C
	sNote		sHold, nCs3
	sFrac		-$004A		; ssDetune $00
	sNote		nG2, $10
	sVol		-$02

	sFrac		$0019		; ssDetune $07
	sNote		nAs2, $01
	sFrac		$005A		; ssDetune $20
	sNote		sHold, $01
	sFrac		-$0088		; ssDetune $FA
	sNote		sHold, nB2
	sFrac		$003B		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F4
	sNote		sHold, nC3
	sFrac		$0027		; ssDetune $FF
	sNote		sHold, $09
	sNote		sHold, nGs2, $01
	sFrac		$0003		; ssDetune $00
	sVol		$02
	sNote		nG2, $0F
	sNote		$01
	sFrac		$0008		; ssDetune $02

	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $1A
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $EB
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$0031		; ssDetune $00
	sNote		sHold, $0A
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		$0000		; ssDetune $0D
	sNote		sHold, nF2
	sFrac		-$00C1		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$0042		; ssDetune $F5
	sNote		sHold, nE2
	sFrac		$003E		; ssDetune $00
	sNote		sHold, nDs2
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD2
	sFrac		-$003B		; ssDetune $00
	sNote		nG2
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0056		; ssDetune $15
	sNote		sHold, $01
	sFrac		-$008A		; ssDetune $FB
	sNote		sHold, nF3
	sFrac		$001F		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0069		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$0019		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$004F		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$0094		; ssDetune $0E
	sNote		sHold, nE3
	sFrac		-$00BF		; ssDetune $EA
	sNote		sHold, nF3
	sFrac		$005B		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$0051		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $E9
	sNote		sHold, nFs3
	sFrac		$0073		; ssDetune $00
	sNote		nE3, $0C
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0036		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF3
	sFrac		$003A		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$0075		; ssDetune $0A
	sNote		sHold, nE3
	sFrac		-$008A		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$0071		; ssDetune $05
	sNote		sHold, nDs3
	sFrac		-$0045		; ssDetune $F9
	sNote		sHold, $01
	sFrac		$0024		; ssDetune $FF
	sNote		sHold, nE3
	sFrac		-$0025		; ssDetune $F8
	sNote		sHold, nF3
	sFrac		$002A		; ssDetune $00
	sNote		nC3, $0F
	sVol		$02

	sNote		nG2, $0F

Clock_Jump01:
	sVol		-$07
	sNote		nD3, $0D
	sNote		nRst, $02
	sNote		nD3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop10
	sNote		nE3, $0D
	sNote		nRst, $02
	sNote		nE3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop11

	sNote		nC3, $0D
	sNote		nRst, $02
	sNote		nC3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop34
	sCall		$02, Clock_Loop14
	sNote		nCs3, $0D
	sNote		nRst, $02
	sNote		nCs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop15
	sCall		$03, Clock_Loop17
	sNote		nE3, $0D
	sNote		nRst, $02
	sNote		nE3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop11
	sNote		nDs3, $0D
	sNote		nRst, $02
	sNote		nDs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2E
	sNote		nD3, $0D
	sNote		nRst, $02
	sNote		nD3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop10
	sNote		nDs3, $0D
	sNote		nRst, $02
	sNote		nDs3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop2E
	sNote		nE3, $0D
	sNote		nRst, $02
	sNote		nE3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop11
	sNote		nD3, $0D
	sNote		nRst, $02
	sNote		nD3, $0D
	sNote		nRst, $02
	sNote		nD2, $04
	sNote		nRst, $0B
	sNote		nC3, $0D
	sNote		nRst, $02
	sNote		nD3, $0D
	sNote		nRst, $02

	sCall		$02, Clock_Loop10
	sNote		nD2, $03
	sNote		nRst, $05
	sNote		nD2, $02
	sNote		nRst, $10
	sVol		$07
	sNote		nG2, $07
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nAs2, $07
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $01
	sNote		nA2, $07
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nC3, $07
	sNote		nRst, $01
	sNote		nA2, $06

	sCall		$02, Clock_Loop1E
	sNote		nRst, $01
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nDs3, $06
	sNote		nRst, $01
	sNote		nF3, $07
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nDs3, $07
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nG3, $07
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nAs3, $07
	sNote		nRst, $01
	sNote		nD3, $02
	sNote		nRst, $05
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nA3, $07
	sNote		nRst, $01
	sNote		nD3, $02
	sNote		nRst, $05
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nF3, $07
	sNote		nRst, $01
	sNote		nD3, $02
	sNote		nRst, $05
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nF3, $06
	sNote		nRst, $01
	sNote		nA3, $07
	sNote		nRst, $01
	sNote		nD3, $02
	sNote		nRst, $05
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nG3, $07
	sNote		nRst, $01
	sNote		nD3, $02
	sNote		nRst, $05
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $05
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nG3, $07
	sNote		nRst, $01
	sNote		nAs2, $02
	sNote		nRst, $05
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $01
	sNote		nDs3, $07
	sNote		nRst, $01
	sNote		nAs2, $02
	sNote		nRst, $05
	sNote		nAs2, $07
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nAs2, $03
	sNote		nRst, $05

	sCall		$02, Clock_Loop1F
	sNote		nC3, $02
	sNote		nRst, $05
	sNote		nC3, $07
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nC3, $03
	sNote		nRst, $05
	sNote		nC3, $06
	sNote		nRst, $01
	sNote		nDs3, $07
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $01
	sNote		nE3, $07
	sNote		nRst, $01
	sNote		nCs3, $02
	sNote		nRst, $05
	sNote		nCs3, $07
	sNote		nRst, $01
	sNote		nG3, $06
	sNote		nRst, $01
	sNote		nCs3, $03
	sNote		nRst, $05
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nE3, $07
	sNote		nRst, $01
	sNote		nA3, $06
	sNote		nRst, $01
	sNote		nAs3, $07
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nE3, $07
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nRst, $01
	sNote		nA3, $07
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nDs3, $07
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $01

	sVoice		v05
	sVol		$04
	sNote		nAs4, $0E
	sNote		nRst, $01
	sNote		nA4, $07
	sNote		nRst, $01
	sNote		nG4, $06
	sNote		nRst, $09
	sNote		nAs4, $06
	sNote		nRst, $01
	sNote		nA4, $2C
	sNote		nRst, $01
	sNote		nE4, $1D
	sNote		nRst, $01
	sNote		nGs4, $0E
	sNote		nRst, $01
	sNote		nG4, $07
	sNote		nRst, $01
	sNote		nF4, $06
	sNote		nRst, $09
	sNote		nGs4, $06
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nD4, $1D
	sNote		nRst, $01
	sVol		$05
	sNote		nAs4, $0E
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $07
	sNote		nRst, $08
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nA4, $2C
	sNote		nRst, $01
	sNote		nE4, $1D
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nE4, $06
	sNote		nRst, $01
	sNote		nFs4, $17
	sNote		nRst, $22

	sVol		-$09
	sCall		$01, Clock_FM4_00

	sVoice		v02
	sNote		nG2, $01
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02
	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0D
	sFrac		$0004		; ssDetune $00

	sNote		nD3, $07
	sFrac		$0005		; ssDetune $01
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AC		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00D6		; ssDetune $12
	sNote		sHold, nD3
	sFrac		-$0042		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0041		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$0045		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $0C
	sNote		sHold, nCs3
	sFrac		-$004A		; ssDetune $00
	sNote		nG2, $10
	sVol		-$02

	sFrac		$0019		; ssDetune $07
	sNote		nAs2, $01
	sFrac		$005A		; ssDetune $20
	sNote		sHold, $01
	sFrac		-$0088		; ssDetune $FA
	sNote		sHold, nB2
	sFrac		$003B		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F4
	sNote		sHold, nC3
	sFrac		$0027		; ssDetune $FF
	sNote		sHold, $09
	sNote		sHold, nGs2, $01
	sFrac		$0003		; ssDetune $00
	sVol		$02

	sNote		nG2, $0F
	sNote		$01
	sFrac		$0008		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $1A
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $EB
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$0031		; ssDetune $00
	sNote		sHold, $0A
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		$0000		; ssDetune $0D
	sNote		sHold, nF2
	sFrac		-$00C1		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$0042		; ssDetune $F5
	sNote		sHold, nE2
	sFrac		$003E		; ssDetune $00
	sNote		sHold, nDs2
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD2
	sFrac		-$003B		; ssDetune $00
	sNote		nG2
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0056		; ssDetune $15
	sNote		sHold, $01
	sFrac		-$008A		; ssDetune $FB
	sNote		sHold, nF3
	sFrac		$001F		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0069		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$0019		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$004F		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$0094		; ssDetune $0E
	sNote		sHold, nE3
	sFrac		-$00BF		; ssDetune $EA
	sNote		sHold, nF3
	sFrac		$005B		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$0051		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $E9
	sNote		sHold, nFs3
	sFrac		$0073		; ssDetune $00

	sNote		nE3, $0C
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0036		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF3
	sFrac		$003A		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$0075		; ssDetune $0A
	sNote		sHold, nE3
	sFrac		-$008A		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$0071		; ssDetune $05
	sNote		sHold, nDs3
	sFrac		-$0045		; ssDetune $F9
	sNote		sHold, $01
	sFrac		$0024		; ssDetune $FF
	sNote		sHold, nE3
	sFrac		-$0025		; ssDetune $F8
	sNote		sHold, nF3
	sFrac		$002A		; ssDetune $00

	sNote		nC3, $0F
	sVol		$02
	sNote		nG2, $11
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, nFs2, $01
	sFrac		-$006B		; ssDetune $E9
	sNote		sHold, nF2
	sFrac		$00EB		; ssDetune $14
	sNote		sHold, nDs2
	sFrac		-$0012		; ssDetune $10
	sNote		sHold, nD2
	sFrac		-$000E		; ssDetune $0D
	sNote		sHold, nCs2
	sFrac		-$000E		; ssDetune $0A
	sNote		sHold, nC2
	sFrac		-$0043		; ssDetune $00
	sNote		nG2
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0D
	sFrac		$0004		; ssDetune $00

	sNote		nD3, $07
	sFrac		$0005		; ssDetune $01
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AC		; ssDetune $EE
	sNote		sHold, nDs3
	sFrac		$00D6		; ssDetune $12
	sNote		sHold, nD3
	sFrac		-$0042		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0041		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$0045		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $0C
	sNote		sHold, nCs3
	sFrac		-$004A		; ssDetune $00
	sNote		nG2, $10
	sVol		-$02

	sFrac		$0019		; ssDetune $07
	sNote		nAs2, $01
	sFrac		$005A		; ssDetune $20
	sNote		sHold, $01
	sFrac		-$0088		; ssDetune $FA
	sNote		sHold, nB2
	sFrac		$003B		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $F4
	sNote		sHold, nC3
	sFrac		$0027		; ssDetune $FF
	sNote		sHold, $09
	sNote		sHold, nGs2, $01
	sFrac		$0003		; ssDetune $00
	sVol		$02

	sNote		nG2, $0F
	sNote		$01
	sFrac		$0008		; ssDetune $02
	sNote		sHold, $01
	sFrac		$002D		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $1A
	sNote		sHold, $01
	sFrac		-$00D2		; ssDetune $EB
	sNote		sHold, nGs2
	sFrac		$002D		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$0031		; ssDetune $00
	sNote		sHold, $0A
	sNote		sHold, nG2, $01
	sFrac		$0041		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		$0000		; ssDetune $0D
	sNote		sHold, nF2
	sFrac		-$00C1		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$0042		; ssDetune $F5
	sNote		sHold, nE2
	sFrac		$003E		; ssDetune $00
	sNote		sHold, nDs2
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD2
	sFrac		-$003B		; ssDetune $00
	sNote		nG2
	sNote		nRst, $06
	sNote		nG2, $04
	sNote		nRst
	sVol		-$02
	sNote		nD3, $07
	sVol		$02

	sNote		nGs2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nG2, $0E
	sFrac		$0004		; ssDetune $00
	sVol		-$02

	sNote		nE3, $01
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0056		; ssDetune $15
	sNote		sHold, $01
	sFrac		-$008A		; ssDetune $FB
	sNote		sHold, nF3
	sFrac		$001F		; ssDetune $01
	sNote		sHold, $09
	sFrac		$0069		; ssDetune $16
	sNote		sHold, $02
	sFrac		-$0019		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$0050		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$004F		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$0094		; ssDetune $0E
	sNote		sHold, nE3
	sFrac		-$00BF		; ssDetune $EA
	sNote		sHold, nF3
	sFrac		$005B		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$0051		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00AA		; ssDetune $E9
	sNote		sHold, nFs3
	sFrac		$0073		; ssDetune $00

	sNote		nE3, $0C
	sFrac		$001A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0036		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF3
	sFrac		$003A		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$0075		; ssDetune $0A
	sNote		sHold, nE3
	sFrac		-$008A		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$0071		; ssDetune $05
	sNote		sHold, nDs3
	sFrac		-$0045		; ssDetune $F9
	sNote		sHold, $01
	sFrac		$0024		; ssDetune $FF
	sNote		sHold, nE3
	sFrac		-$0025		; ssDetune $F8
	sNote		sHold, nF3
	sFrac		$002A		; ssDetune $00
	sNote		nC3, $0F
	sVol		$02

	sNote		nG2, $10
	sJump		Clock_Jump01

Clock_Loop1F:
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nDs3, $07
	sNote		nRst, $01
	sRet

Clock_Loop08:
	sVol		-$0B
	sNote		nC6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nB5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nC6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop09:
	sVol		-$0B
	sNote		nB5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nB5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nFs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop0A:
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nF5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop0B:
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nGs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nE5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop0C:
	sVol		-$0B
	sNote		nDs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nD6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nDs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nC6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop0D:
	sVol		-$0B
	sNote		nD6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nCs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nD6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop0E:
	sVol		-$0B
	sNote		nFs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nE6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nFs6, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sRet

Clock_Loop0F:
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nA5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nAs5, $06
	sVol		$0B
	sNote		$07
	sNote		nRst, $02
	sVol		-$0B
	sNote		nG5, $06
	sRet

Clock_Loop10:
	sNote		nD2, $03
	sNote		nRst, $05
	sNote		nD2, $02
	sNote		nRst, $05
	sRet

Clock_Loop11:
	sNote		nE2, $03
	sNote		nRst, $05
	sNote		nE2, $02
	sNote		nRst, $05
	sRet

Clock_Loop14:
	sNote		nAs2, $0D
	sNote		nRst, $02
	sNote		nAs2, $0D
	sNote		nRst, $02
	sCall		$02, Clock_Loop35
	sRet

Clock_Loop15:
	sNote		nCs2, $03
	sNote		nRst, $05
	sNote		nCs2, $02
	sNote		nRst, $05
	sRet

Clock_Loop17:
	sNote		nD3, $0D
	sNote		nRst, $02
	sNote		nD3, $0D
	sNote		nRst, $02
	sCall		$02, Clock_Loop10
	sRet

Clock_Loop1E:
	sNote		nRst, $01
	sNote		nAs2, $07
	sNote		nRst, $01
	sNote		nC3, $06
	sNote		nRst, $01
	sNote		nD3, $07
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nC3, $07
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nDs3, $07
	sNote		nRst, $01
	sNote		nC3, $06
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 and PSG2 data
; ---------------------------------------------------------------------------

Clock_PSG2:
	sNote		nCut, $0C
	sVol		$10
	sFrac		$0020

Clock_PSG1:
	sNote		nCut, $26
	sVol		$18
	sFrac		$0C00
	sVolEnv		v06

	sNote		nA0, $06
	sNote		nCut, $01
	sNote		nE1, $06
	sNote		nCut, $02
	sNote		nC2, $D9
	sNote		nCut, $08
	sNote		nA0, $06
	sNote		nCut, $01
	sNote		nFs1, $06
	sNote		nCut, $02
	sNote		nB1, $D9
	sNote		nCut, $08
	sNote		nA0, $06
	sNote		nCut, $01
	sNote		nF1, $06
	sNote		nCut, $02
	sNote		nAs1, $D9
	sNote		nCut, $08
	sNote		nA0, $06
	sNote		nCut, $01
	sNote		nE1, $06
	sNote		nCut, $02
	sNote		nA1, $D9
	sNote		nCut, $08
	sNote		nC1, $06
	sNote		nCut, $01
	sNote		nG1, $06
	sNote		nCut, $02
	sNote		nDs2, $D9
	sNote		nCut, $08
	sNote		nC1, $06
	sNote		nCut, $01
	sNote		nA1, $06
	sNote		nCut, $02
	sNote		nD2, $D9
	sNote		nCut, $08
	sNote		nC1, $06
	sNote		nCut, $01
	sNote		nAs1, $06
	sNote		nCut, $02
	sNote		nDs2, $D9
	sNote		nCut, $08
	sNote		nG0, $06
	sNote		nCut, $01
	sNote		nD1, $06
	sNote		nCut, $02
	sNote		nAs1, $D9

	sVolEnv		v03
	sVol		$08
	sCall		$09, Clock_Loop84

Clock_Jump08:
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nGs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nF2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nGs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nGs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nDs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nFs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nFs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs1, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nFs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nE2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nFs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nGs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nFs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nE2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nFs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nCs3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nCs3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nE2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nC3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nB2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nC3, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nDs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nDs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nE2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06

	sCall		$02, Clock_Loop86
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs1, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG1, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01

	sVol		-$10
	sNote		nG1, $06
	sNote		nCut, $02
	sNote		nA1, $06
	sNote		nCut, $01
	sNote		nAs1, $06
	sNote		nCut, $02
	sNote		nG1, $06
	sNote		nCut, $01
	sNote		nA1, $06
	sNote		nCut, $02
	sNote		nAs1, $06
	sNote		nCut, $01
	sNote		nC2, $06
	sNote		nCut, $02
	sNote		nA1, $06
	sNote		nCut, $01
	sNote		nAs1, $06
	sNote		nCut, $02
	sNote		nC2, $06
	sNote		nCut, $01
	sNote		nD2, $06
	sNote		nCut, $02
	sNote		nAs1, $06
	sNote		nCut, $01
	sVol		-$08
	sNote		nC2, $06
	sNote		nCut, $02
	sNote		nD2, $06
	sNote		nCut, $01
	sNote		nDs2, $06
	sNote		nCut, $02
	sNote		nC2, $06
	sNote		nCut, $01
	sNote		nD2, $06
	sNote		nCut, $02
	sNote		nDs2, $06
	sNote		nCut, $01
	sNote		nF2, $06
	sNote		nCut, $02
	sNote		nD2, $06
	sNote		nCut, $01
	sNote		nDs2, $06
	sNote		nCut, $02
	sNote		nF2, $06
	sNote		nCut, $01
	sNote		nG2, $06
	sNote		nCut, $02
	sNote		nA2, $06
	sNote		nCut, $01
	sVol		-$08
	sNote		nAs2, $15
	sNote		nCut, $02
	sNote		nAs2, $15
	sNote		nCut, $01
	sNote		nA2, $15
	sNote		nCut, $02
	sNote		nF2, $15
	sNote		nCut, $01
	sNote		nC2, $0E
	sNote		nCut, $01
	sNote		nF2, $0E
	sNote		nCut, $01
	sNote		nA2, $15
	sNote		nCut, $02
	sNote		nA2, $15
	sNote		nCut, $01
	sNote		nG2, $15
	sNote		nCut, $02
	sNote		nD2, $15
	sNote		nCut, $01
	sNote		nAs1, $0E
	sNote		nCut, $01
	sNote		nD2, $0E
	sNote		nCut, $01
	sNote		nDs2, $15
	sNote		nCut, $02
	sNote		nAs1, $15
	sNote		nCut, $01
	sNote		nG2, $15
	sNote		nCut, $02
	sNote		nDs2, $15
	sNote		nCut, $01
	sNote		nC2, $0E
	sNote		nCut, $01
	sNote		nDs2, $0E
	sNote		nCut, $01
	sNote		nE2, $15
	sNote		nCut, $02
	sNote		nCs2, $15
	sNote		nCut, $01
	sNote		nG2, $0E
	sNote		nCut, $01
	sNote		nAs2, $1D
	sNote		nCut, $01
	sNote		nA2, $1D
	sNote		nCut, $01

	sVol		$08
	sCall		$02, Clock_Loop87
	sCall		$02, Clock_Loop88
	sCall		$02, Clock_Loop89
	sCall		$02, Clock_Loop8A

	sNote		nD3, $06
	sNote		nCut, $02
	sNote		nC3, $06
	sNote		nCut, $01
	sNote		nD3, $06
	sNote		nCut, $02
	sVol		-$08
	sNote		nG2, $06
	sNote		nCut, $01
	sVol		-$10
	sNote		nG3, $06
	sNote		nCut, $02
	sNote		nFs3, $06
	sNote		nCut, $01
	sNote		nG3, $06
	sNote		nCut, $02
	sVol		$10
	sNote		nAs2, $06
	sNote		nCut, $01
	sVol		-$10
	sNote		nDs3, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nDs3, $06

	sCall		$02, Clock_Loop8B
	sNote		nCut, $02
	sVol		$10
	sNote		nA2, $06
	sNote		nCut, $01
	sVol		-$10
	sNote		nE3, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nE3, $06
	sCall		$02, Clock_Loop8C

	sNote		nCut, $02
	sVol		$10
	sNote		nA2, $06
	sNote		nCut, $01
	sVol		-$08

	sCall		$04, Clock_Loop8D
	sNote		nG3, $08
	sNote		nCut, $07
	sNote		nG3, $08
	sNote		nCut, $07
	sNote		nGs3, $08
	sNote		nCut, $07
	sNote		nF3, $06
	sNote		nCut, $02
	sNote		nF3, $07
	sNote		nCut, $08
	sNote		nFs3, $06
	sNote		nCut, $01
	sNote		nFs3, $08
	sNote		nCut, $0F
	sVol		$08
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nC3, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nAs2, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sVol		$08
	sNote		nA2, $06
	sNote		nCut, $02
	sVol		-$08
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nAs2, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nG2, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sVol		$08
	sNote		nA2, $06
	sNote		nCut, $02
	sVol		-$08
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nD2, $0F

	sNote		nCut, $1E1
	sVol		-$08
	sCall		$01, Clock_Loop84
	sJump		Clock_Jump08

Clock_Loop84:
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nAs2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sRet

Clock_Loop86:
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nD2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nG2, $06
	sVol		$28
	sNote		$08
	sNote		nCut, $01
	sVol		-$28
	sNote		nA2, $06
	sRet

Clock_Loop87:
	sNote		nD3, $06
	sNote		nCut, $02
	sNote		nCs3, $06
	sNote		nCut, $01
	sNote		nD3, $06
	sNote		nCut, $02
	sNote		nG2, $06
	sNote		nCut, $01
	sRet

Clock_Loop88:
	sNote		nCs3, $06
	sNote		nCut, $02
	sNote		nC3, $06
	sNote		nCut, $01
	sNote		nCs3, $06
	sNote		nCut, $02
	sNote		nE2, $06
	sNote		nCut, $01
	sRet

Clock_Loop89:
	sNote		nC3, $06
	sNote		nCut, $02
	sNote		nB2, $06
	sNote		nCut, $01
	sNote		nC3, $06
	sNote		nCut, $02
	sNote		nDs2, $06
	sNote		nCut, $01
	sRet

Clock_Loop8A:
	sNote		nAs2, $06
	sNote		nCut, $02
	sNote		nA2, $06
	sNote		nCut, $01
	sNote		nAs2, $06
	sNote		nCut, $02
	sNote		nD2, $06
	sNote		nCut, $01
	sRet

Clock_Loop8B:
	sNote		nCut, $02
	sVol		$10
	sNote		nG2, $06
	sNote		nCut, $01
	sVol		-$10
	sNote		nE3, $06
	sNote		nCut, $02
	sNote		nD3, $06
	sNote		nCut, $01
	sNote		nE3, $06
	sRet

Clock_Loop8C:
	sNote		nCut, $02
	sVol		$10
	sNote		nA2, $06
	sNote		nCut, $01
	sVol		-$10
	sNote		nFs3, $06
	sNote		nCut, $02
	sNote		nE3, $06
	sNote		nCut, $01
	sNote		nFs3, $06
	sRet

Clock_Loop8D:
	sNote		nG3, $08
	sNote		nCut, $07
	sNote		nG3, $08
	sNote		nCut, $07
	sNote		nGs3, $08
	sNote		nCut, $07
	sNote		nF3, $06
	sNote		nCut, $02
	sNote		nF3, $07
	sNote		nCut, $08
	sNote		nFs3, $06
	sNote		nCut, $01
	sNote		nFs3, $08
	sNote		nCut, $07
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

Clock_PSG3:
	sNote		nCut, $3C
	sVol		$7F
	sCall		$1F, Clock_Loop5C
	sNote		$1E
	sCall		$03, Clock_Loop5D
	sNote		$17
	sNote		$07
	sCall		$03, Clock_Loop5D
	sNote		$17
	sNote		$07
	sCall		$03, Clock_Loop5D
	sNote		$17
	sNote		$07
	sCall		$03, Clock_Loop5D
	sNote		$17
	sNote		$07

Clock_Jump06:
	sCall		$03, Clock_Loop5D
	sNote		$17
	sNote		$07
	sCall		$07, Clock_Loop5D
	sCall		$02, Clock_Loop63
	sCall		$04, Clock_Loop5D
	sCall		$03, Clock_Loop63
	sCall		$04, Clock_Loop5D
	sCall		$01, Clock_Loop63
	sCall		$03, Clock_Loop67

	sNote		$0F
	sNote		$08
	sNote		$07
	sNote		$08
	sNote		nD6, $16
	sNote		nHiHat, $08
	sCall		$02, Clock_Loop68
	sNote		nD6, $07
	sNote		nHiHat, $08

	sCall		$03, Clock_Loop68
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68

	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$02, Clock_Loop68

	sNote		$07
	sNote		$08
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68

	sNote		nD6, $07
	sCall		$02, Clock_Loop6D

	sNote		$08
	sNote		$07
	sNote		$08
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68

	sNote		nD6, $07
	sCall		$03, Clock_Loop6D
	sNote		$08
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68
	sNote		nD6, $07
	sCall		$03, Clock_Loop6D
	sNote		$08
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68
	sNote		nD6, $07
	sCall		$03, Clock_Loop6D
	sNote		$08
	sNote		nD6, $07
	sCall		$03, Clock_Loop6D
	sNote		$08
	sNote		nD6, $07
	sNote		nHiHat, $08
	sCall		$03, Clock_Loop68
	sNote		nD6, $16

	sCall		$02, Clock_Loop76
	sCall		$02, Clock_Loop77
	sCall		$02, Clock_Loop78

	sNote		$17
	sNote		$16
	sNote		$2D
	sCall		$01, Clock_Loop76
	sNote		$78
	sNote		$17

	sCall		$06, Clock_Loop79
	sNote		nHiHat, $07
	sNote		$17
	sNote		$07

	sCall		$07, Clock_Loop5D
	sNote		$17
	sNote		$07
	sNote		sHold, $01
	sJump		Clock_Jump06

Clock_Loop5D:
	sNote		nD6, $17
	sNote		nHiHat, $07
	sRet

Clock_Loop63:
	sNote		$17
	sNote		$07
	sNote		nD6, $17
	sNote		nHiHat, $07
	sRet

Clock_Loop67:
	sNote		nHiHat, $0F
	sNote		$08
	sNote		$07
	sNote		$08
	sNote		nD6, $07
	sNote		nHiHat, $0F
	sRet

Clock_Loop68:
	sNote		$07
	sNote		$08
	sRet

Clock_Loop6D:
	sNote		nHiHat, $08
	sNote		$07
	sRet

Clock_Loop76:
	sNote		nHiHat, $08
	sNote		$07
	sNote		nD6, $0F
	sNote		$0F
	sCall		$01, Clock_Loop77
	sNote		$0F
	sRet

Clock_Loop77:
	sNote		nHiHat, $08
	sNote		$07
	sNote		$08
	sNote		nD6, $07
	sRet

Clock_Loop78:
	sNote		nHiHat, $08
	sNote		nD6, $07
	sRet

Clock_Loop79:
	sNote		nHiHat, $07
	sNote		nD6, $17
	sRet

Clock_Loop5C:
	sNote		nHiHat, $3C
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG4 data
; ---------------------------------------------------------------------------

Clock_PSG4:
	sNote		nCut, $3C
	sVol		$10
	sVolEnv		v02
	sCall		$1F, Clock_L5C

	sNote		$1E
	sCall		$03, Clock_L5D

	sNote		$17
	sNote		$07
	sCall		$03, Clock_L5D
	sNote		$17
	sNote		$07
	sCall		$03, Clock_L5D
	sNote		$17
	sNote		$07
	sCall		$03, Clock_L5D
	sNote		$17
	sNote		$07

Clock_J06:
	sCall		$03, Clock_L5D
	sNote		$17
	sNote		$07
	sCall		$07, Clock_L5D
	sCall		$02, Clock_L63
	sCall		$04, Clock_L5D
	sCall		$03, Clock_L65
	sCall		$04, Clock_L5D

	sNote		$17
	sNote		$07
	sCall		$01, Clock_L5D
	sVolEnv		v01
	sNote		$1E
	sVolEnv		v02

	sCall		$03, Clock_L67
	sNote		$0F
	sNote		$08
	sNote		$07
	sNote		$08
	sVolEnv		v01
	sNote		$16
	sVolEnv		v02
	sNote		$08
	sCall		$01, Clock_L68
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sVolEnv		v02
	sNote		$08

	sCall		$02, Clock_L68
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sCall		$01, Clock_L68

	sCall		$02, Clock_L69
	sVolEnv		v01
	sNote		$07
	sNote		$08
	sVolEnv		v02

	sCall		$02, Clock_L69
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sNote		$08
	sVolEnv		v02
	sNote		$07
	sNote		$08
	sCall		$01, Clock_L68
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sVolEnv		v02
	sNote		$08

	sCall		$02, Clock_L68
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sCall		$01, Clock_L68

	sCall		$02, Clock_L69
	sVolEnv		v01
	sNote		$07
	sCall		$02, Clock_L6D
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sCall		$01, Clock_L68

	sCall		$02, Clock_L69
	sVolEnv		v01
	sNote		$07

	sCall		$03, Clock_L6F
	sVolEnv		v01
	sNote		$08
	sNote		$07
	sVolEnv		v02
	sNote		$08

	sCall		$02, Clock_L68
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$07

	sCall		$03, Clock_L71
	sNote		$08
	sNote		$07
	sNote		$08

	sVolEnv		v02
	sCall		$03, Clock_L69
	sVolEnv		v01
	sNote		$07

	sCall		$03, Clock_L6F
	sVolEnv		v01
	sNote		$08
	sNote		$07

	sCall		$03, Clock_L6F
	sCall		$01, Clock_L78
	sVolEnv		v02
	sNote		$08

	sCall		$02, Clock_L68
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sNote		$16

	sCall		$02, Clock_L76
	sCall		$02, Clock_L77
	sCall		$02, Clock_L78

	sNote		$17
	sNote		$16
	sNote		$2D
	sCall		$01, Clock_L76
	sNote		$78
	sNote		$17

	sCall		$06, Clock_L79
	sVolEnv		v02
	sNote		$07
	sNote		$17
	sNote		$07

	sCall		$07, Clock_L5D

	sNote		$17
	sNote		$07
	sVolEnv		v01
	sNote		sHold, $01
	sJump		Clock_J06

Clock_L5C:
	sNote		nWhitePSG3, $3C
	sRet

Clock_L5D:
	sVolEnv		v01
	sNote		$17
	sVolEnv		v02
	sNote		$07
	sRet

Clock_L67:
	sNote		$0F
	sNote		$08
	sNote		$07
	sNote		$08
	sVolEnv		v01
	sNote		$07
	sVolEnv		v02
	sNote		$0F
	sRet

Clock_L68:
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sVolEnv		v02
	sRet

Clock_L69:
	sNote		$07
	sNote		$08
	sRet

Clock_L6D:
	sVolEnv		v01
	sNote		$08
	sVolEnv		v02
	sNote		$07
	sRet

Clock_L6F:
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sRet

Clock_L79:
	sVolEnv		v02
	sNote		$07
	sVolEnv		v01
	sNote		$17
	sRet

Clock_L71:
	sNote		$08
	sVolEnv		v02
	sNote		$07
	sVolEnv		v01
	sRet

Clock_L76:
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sNote		$0F
	sNote		$0F
	sCall		$01, Clock_L77
	sNote		$0F
	sRet

Clock_L77:
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sNote		$08
	sVolEnv		v01
	sNote		$07
	sRet

Clock_L78:
	sVolEnv		v02
	sNote		$08
	sVolEnv		v01
	sNote		$07
	sRet

Clock_L63:
	sNote		$17
	sNote		$07
	sCall		$01, Clock_L5D
	sRet

Clock_L65:
	sNote		$17
	sNote		$07
	sCall		$01, Clock_L5D
	sRet

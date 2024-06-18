; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	DNight_Voice
	sHeaderSamples	DNight_Samples
	sHeaderVibrato	DNight_Vib
	sHeaderEnvelope	DNight_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$CC
	sChannel	DAC1, DNight_DAC1
	sChannel	FM1, DNight_FM1
	sChannel	FM2, DNight_FM3
	sChannel	FM3, DNight_FM2
	sChannel	FM4, DNight_FM4
	sChannel	FM5, DNight_FM5
	sChannel	PSG1, DNight_PSG3
	sChannel	PSG2, DNight_PSG1
	sChannel	PSG3, DNight_PSG2
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

DNight_Voice:
	sNewVoice	v00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $05, $03, $00
	sMultiple	$02, $01, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $1F, $1F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $00, $00
	sReleaseRate	$02, $03, $05, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1B, $12, $08, $08
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$04, $00, $07, $01
	sMultiple	$02, $00, $00, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$1C, $1C, $1E, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$14, $06, $0D, $07
	sDecay2Rate	$05, $05, $05, $05
	sDecay1Level	$0E, $0D, $0D, $0D
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$28, $14, $1C, $04
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$06
	sFeedback	$02
	sDetune		$07, $03, $07, $03
	sMultiple	$06, $00, $04, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$05, $07, $07, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1E, $04, $05, $04
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$02, $02, $04, $02
	sRateScale	$02, $00, $00, $00
	sAttackRate	$13, $13, $18, $1B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $0A, $0A, $0B
	sDecay2Rate	$01, $01, $01, $01
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0A, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$11, $08, $08, $08
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$07, $03, $03, $04
	sMultiple	$0C, $06, $04, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$03, $04, $0B, $0B
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$01, $01, $02, $02
	sReleaseRate	$00, $00, $09, $09
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$26, $18, $08, $08
	sFinishVoice

	sNewVoice	v05
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$03, $00, $01, $03
	sMultiple	$03, $01, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $1A, $15, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$16, $00, $05, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$03, $00, $00, $00
	sReleaseRate	$03, $05, $05, $0B
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$12, $19, $1C, $04
	sFinishVoice

	sNewVoice	v06
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$03, $07, $03, $07
	sMultiple	$0E, $0E, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $11, $11
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $0A, $08, $08
	sDecay2Rate	$04, $04, $06, $06
	sDecay1Level	$05, $05, $06, $06
	sReleaseRate	$02, $02, $08, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1D, $1F, $08, $08
	sFinishVoice

	sNewVoice	v07
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$07, $00, $00, $01
	sMultiple	$0A, $04, $02, $02
	sRateScale	$03, $01, $01, $01
	sAttackRate	$1A, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$14, $01, $01, $01
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$07, $03, $08, $03
	sReleaseRate	$06, $05, $05, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $1C, $1E, $04
	sFinishVoice

	sNewVoice	v08
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$02, $04, $08, $06
	sRateScale	$00, $01, $00, $01
	sAttackRate	$1F, $1F, $10, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $0F, $0F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $01, $01
	sReleaseRate	$00, $00, $05, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$13, $19, $04, $04
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

DNight_Samples:
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

	sNewSample	HighTimpani
	sSampFreq	$0120
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Timpani
	sSampFreq	$0100
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

	sNewSample	Timpani7
	sSampFreq	$00A0
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

DNight_Vib:
	sVibrato FM15,		$10, $00, $2AA8, $0037, Triangle
	sVibrato PSG,		$08, $00, $2AA8,-$0020, Sine

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

DNight_Env:
	sEnvelope v05,		DNight_Env_v05
; ---------------------------------------------------------------------------

DNight_Env_v05:
	sEnv		delay=$0A,	$00
	sEnv		delay=$0E,	$08
	sEnv		delay=$08,	$10, $18
	seHold		$20

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

DNight_DAC1:
	sNote		nRst, $C0
	sPan		center
	sVol		$04

DNight_Jump00:
	sSample		Crash3
	sNote		nSample, $0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sSample		Kick

	sCall		$02, DNight_DAC1_00
	sNote		$0C
	sNote		$06
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$12
	sSample		Kick

	sCall		$02, DNight_Loop00
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		HighTimpani
	sNote		$03
	sNote		$03
	sSample		LowTimpani
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$03
	sNote		$03
	sSample		LowTimpani
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$12

	sCall		$02, DNight_Loop03
	sSample		Crash3
	sCall		$0E, DNight_Loop02
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06

	sCall		$0E, DNight_Loop00
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Crash3
	sNote		$06

	sCall		$06, DNight_Loop06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sSample		Crash3
	sNote		$06

	sCall		$06, DNight_Loop06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Crash3

	sCall		$06, DNight_Loop02
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$03
	sNote		$03
	sSample		VLowTimpani
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$03
	sNote		$03
	sSample		VLowTimpani
	sNote		$06
	sSample		Timpani7
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$06
	sJump		DNight_Jump00

DNight_Loop00:
	sNote		$0C
	sNote		$06
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sRet

DNight_DAC1_00:
	sCall		$0D, DNight_Loop00
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$03
	sNote		$03
	sSample		VLowTimpani
	sNote		$06
	sNote		$06
	sSample		MidTimpani
	sNote		$03
	sNote		$03
	sSample		VLowTimpani
	sNote		$06
	sSample		Timpani7
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Crash3

DNight_Loop02:
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sRet

DNight_Loop03:
	sSample		Crash3
	sCall		$0E, DNight_Loop02
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		HighTimpani
	sCall		$01, DNight_Loop03a
	sSample		MidTimpani
	sCall		$01, DNight_Loop03a
	sSample		LowTimpani

DNight_Loop03a:
	sNote		$03
	sNote		$03
	sSample		Kick
	sNote		$06
	sNote		$06
	sRet

DNight_Loop06:
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 and FM5 data
; ---------------------------------------------------------------------------

DNight_FM5:
	sNote		nRst, $09
	sPan		right
	sVol		$09
	sFrac		-$0014

	sVoice		v00
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_00

DNight_FM5_JMP:
	sVoice		v03
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_01
	sVoice		v05
	sVol		-$06
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_02
	sVoice		v06
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_03
	sVoice		v05
	sVol		-$07
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_02
	sVoice		v06
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_04
	sVoice		v07
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_05
	sVoice		v02
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_06
	sVoice		v08
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_07
	sVoice		v05
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_08
	sVoice		v02
	sAMSFMS		5.9db, 14%
	sCall		$01, DNight_FM1_09
	sJump		DNight_FM5_JMP
; ---------------------------------------------------------------------------

DNight_FM1:
	sLFO		3.98hz
	sPan		center
	sVol		$05

	sVoice		v00
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_00

DNight_FM1_JMP:
	sVoice		v03
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_01
	sVoice		v05
	sVol		-$06
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_02
	sVoice		v06
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_03
	sVoice		v05
	sVol		-$07
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_02
	sVoice		v06
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_04
	sVoice		v07
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_05
	sVoice		v02
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_06
	sVoice		v08
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_07
	sVoice		v05
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_08
	sVoice		v02
	sAMSFMS		11.8db, 14%
	sCall		$01, DNight_FM1_09
	sJump		DNight_FM1_JMP
; ---------------------------------------------------------------------------

DNight_FM1_00:
	sVibratoSet	FM15
	sNote		nC4, $05
	sNote		nRst, $01
	sNote		nDs4, $05
	sNote		nRst, $01
	sNote		nG4, $05
	sNote		nRst, $01
	sNote		nC5, $05
	sNote		nRst, $01
	sNote		nD5, $0B
	sNote		nRst, $01
	sNote		nF5, $0B
	sNote		nRst, $01
	sNote		nDs5, $0B
	sNote		nRst, $01
	sNote		nC5, $0B
	sNote		nRst, $01
	sNote		nD5, $0B
	sNote		nRst, $01
	sNote		nF5, $0B

	sCall		$02, DNight_Loop68
	sNote		nRst, $01
	sNote		nD5, $05
	sNote		nRst, $01
	sNote		nF5, $05
	sCall		$02, DNight_Loop69
	sNote		nRst, $01
	sNote		nAs4, $05
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sVol		$08
	sRet

DNight_FM1_01:
	sNote		nF4, $01
	sNote		nFs4
	sNote		nG4, $32
	sCall		$03, DNight_Loop6A

	sNote		nRst, $02
	sNote		nG4, $10
	sNote		nRst, $02
	sNote		nC4, $10
	sNote		nRst, $02
	sNote		nDs4, $10
	sNote		nRst, $02
	sNote		nE4, $01
	sNote		nF4, $0F
	sNote		nRst, $02
	sNote		nF4, $01
	sNote		nFs4
	sNote		nG4, $32
	sCall		$03, DNight_Loop6A

	sNote		nRst, $02
	sNote		nG4, $10
	sNote		nRst, $02
	sNote		nC4, $10
	sNote		nRst, $02
	sNote		nDs4, $10
	sNote		nRst, $02
	sNote		nFs4, $01
	sNote		nG4, $0F
	sNote		nRst, $02
	sNote		nGs4, $0A
	sNote		nRst, $02
	sNote		nAs4, $04
	sNote		nRst, $02
	sNote		nC5, $22
	sCall		$01, DNight_Loop6E
	sNote		nRst, $02
	sNote		nC5, $10
	sNote		nRst, $02
	sNote		nGs4, $10
	sNote		nRst, $02
	sNote		nAs4, $10
	sNote		nRst, $02
	sNote		nC5, $10
	sNote		nRst, $02
	sNote		nC5, $34
	sNote		nRst, $02
	sNote		nC5, $04
	sNote		nRst, $02
	sNote		nD5, $04
	sNote		nRst, $02
	sNote		nC5, $04
	sNote		nRst, $02
	sNote		nB4, $46
	sNote		nRst, $02
	sNote		nF4, $01
	sNote		nFs4
	sNote		nG4, $32
	sCall		$03, DNight_Loop6A

	sNote		nRst, $02
	sNote		nG4, $10
	sNote		nRst, $02
	sNote		nC4, $10
	sNote		nRst, $02
	sNote		nDs4, $10
	sNote		nRst, $02
	sNote		nE4, $01
	sNote		nF4, $0F
	sNote		nRst, $02
	sNote		nF4, $01
	sNote		nFs4
	sNote		nG4, $32
	sCall		$03, DNight_Loop6A

	sNote		nRst, $02
	sNote		nG4, $10
	sNote		nRst, $02
	sNote		nC4, $10
	sNote		nRst, $02
	sNote		nDs4, $10
	sNote		nRst, $02
	sNote		nFs4, $01
	sNote		nG4, $0F

	sCall		$02, DNight_Loop6E
	sNote		nRst, $02
	sNote		nC5, $10
	sCall		$01, DNight_Loop6E
	sNote		nRst, $02
	sNote		nC5, $34
	sNote		nRst, $02
	sNote		nC5, $04
	sNote		nRst, $02
	sNote		nD5, $04
	sNote		nRst, $02
	sNote		nC5, $04
	sNote		nRst, $02
	sNote		nD5, $34
	sNote		nRst, $02
	sNote		nD5, $04
	sNote		nRst, $02
	sNote		nDs5, $04
	sNote		nRst, $02
	sNote		nF5, $04
	sNote		nRst, $02
	sNote		nG5, $46
	sNote		nRst, $02
	sRet

DNight_FM1_02:
	sCall		$02, DNight_Loop6F
	sNote		nC3
	sNote		nRst, $0F
	sRet

DNight_FM1_03:
	sVol		$07
	sNote		nDs3, $12
	sNote		nD3
	sNote		nAs2
	sRet

DNight_FM1_04:
	sVol		$08
	sNote		nC3, $12
	sNote		nD3
	sRet

DNight_FM1_05:
	sVol		-$06
	sNote		nC2, $06
	sNote		nDs2
	sNote		nG2
	sNote		nC3, $35
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nDs3, $05
	sNote		nRst, $01
	sNote		nF3, $0C
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01

	sVol		$05
	sNote		nG3, $05
	sNote		nRst, $01
	sVol		-$05

	sNote		nD3, $17
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nAs2, $05

	sCall		$02, DNight_Loop71
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nDs3, $05
	sNote		nRst, $01
	sNote		nDs3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nDs3, $05
	sNote		nRst, $01
	sNote		nG3, $35
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nC4, $3B
	sNote		nRst, $01
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nAs3, $06
	sNote		nC4, $05
	sNote		nRst, $01
	sVol		$05
	sNote		nC4, $05
	sNote		nRst, $01
	sVol		-$05
	sNote		nC4, $23
	sNote		nRst, $01
	sVol		$05
	sNote		nC4, $05
	sNote		nRst, $01
	sVol		-$05
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nC4, $05

	sCall		$03, DNight_Loop72
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sNote		nDs4, $05
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sNote		nD4, $35
	sNote		nRst, $01
	sRet

DNight_FM1_06:
	sVol		$05
	sNote		nD4, $05
	sNote		nRst, $01
	sNote		nDs4, $05
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sNote		nG4, $05
	sNote		nRst, $01
	sNote		nAs4, $05
	sNote		nRst, $01
	sNote		nC5, $05

	sCall		$06, DNight_Loop73
	sNote		nRst, $01
	sNote		nAs4, $05
	sNote		nRst, $01
	sNote		nC5, $05
	sNote		nRst, $01
	sNote		nDs5, $05
	sNote		nRst, $01
	sNote		nG5, $05
	sNote		nRst, $01
	sNote		nF5, $05
	sNote		nRst, $01
	sNote		nDs5, $05
	sNote		nRst, $01
	sNote		nAs5, $05
	sNote		nRst, $01
	sNote		nG5, $05
	sNote		nRst, $01
	sNote		nF5, $05
	sNote		nRst, $01
	sNote		nAs5, $02
	sNote		nRst, $01
	sNote		nC6, $02
	sNote		nRst, $01
	sNote		nAs5, $05
	sNote		nRst, $01
	sNote		nG5, $05
	sNote		nRst, $01
	sNote		nAs5, $05
	sNote		nRst, $01
	sNote		nC6, $05

	sNote		nRst, $01
	sNote		nD6, $05
	sCall		$02, DNight_Loop75
	sCall		$09, DNight_Loop76
	sNote		nRst, $01
	sNote		nF6, $05
	sNote		nRst, $01
	sNote		nG6, $05
	sNote		nRst, $01
	sNote		nAs6, $05
	sNote		nRst, $01
	sNote		nAs6, $02
	sNote		nRst, $01
	sNote		nC7, $02

	sCall		$02, DNight_Loop77
	sNote		nRst, $01
	sNote		nF6, $05
	sCall		$02, DNight_Loop78
	sNote		nRst, $01
	sNote		nG6, $05
	sNote		nRst, $01
	sNote		nF6, $05
	sNote		nRst, $01
	sNote		nD6, $05
	sNote		nRst, $01
	sNote		nAs5, $23
	sNote		nRst, $01
	sNote		nAs5, $05
	sNote		nRst, $01
	sNote		nC6, $05
	sNote		nRst, $01
	sNote		nD6, $05
	sNote		nRst, $01
	sNote		nDs6, $05
	sNote		nRst, $01
	sNote		nC6, $05
	sNote		nRst, $01
	sNote		nDs6, $05
	sNote		nRst, $01
	sNote		nG6, $05
	sNote		nRst, $01
	sNote		nF6, $05
	sNote		nRst, $01
	sNote		nDs6, $05
	sCall		$01, DNight_Loop77
	sNote		nRst, $01
	sNote		nF6, $05
	sCall		$01, DNight_Loop78
	sNote		nRst, $01
	sNote		nAs6, $29
	sNote		nRst, $01

	sVol		$02
	sNote		nAs6
	sNote		nRst
	sNote		nRst
	sNote		nFs6
	sNote		nRst
	sNote		nRst
	sNote		nD6
	sNote		nRst
	sNote		nRst
	sNote		nAs5
	sNote		nRst
	sNote		nRst
	sNote		nFs5
	sNote		nRst
	sNote		nRst
	sNote		nD5
	sNote		nRst
	sNote		nRst
	sNote		nAs4
	sNote		nRst
	sNote		nRst
	sNote		nFs4
	sNote		nRst
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nRst
	sNote		nAs3
	sNote		nRst
	sNote		nRst
	sRet

DNight_FM1_07:
	sVol		-$05
	sNote		nB2
	sCall		$02, DNight_Loop79
	sNote		nC3, $11
	sNote		nCs3, $01
	sNote		nD3, $11
	sNote		$01
	sNote		nDs3, $11
	sNote		nE3, $01
	sNote		nF3, $11
	sNote		nFs3, $01
	sNote		nG3, $35
	sNote		nB3, $01
	sNote		nC4, $05
	sNote		nFs3, $01
	sNote		nG3, $05
	sNote		nB3, $01
	sNote		nC4, $05
	sNote		nB3, $01
	sNote		nC4, $11
	sNote		nCs4, $01
	sNote		nD4, $11
	sNote		$01
	sNote		nDs4, $11
	sNote		nE4, $01
	sNote		nF4, $11
	sNote		nE4, $01
	sNote		nF4, $35
	sNote		nCs4, $01
	sNote		nD4, $05
	sNote		$01
	sNote		nDs4, $05
	sNote		nE4, $01
	sNote		nF4, $05
	sNote		nE4, $01
	sNote		nF4, $11
	sNote		nFs4, $01
	sNote		nG4, $11
	sNote		$01
	sNote		nGs4, $11
	sNote		nE4, $01
	sNote		nF4, $11
	sNote		nFs4, $01
	sNote		nG4, $35
	sNote		nFs4, $01
	sNote		nG4, $05
	sNote		nE4, $01
	sNote		nF4, $05
	sNote		nD4, $01
	sNote		nDs4, $05
	sNote		nE4, $01
	sNote		nF4, $23
	sNote		nFs4, $01
	sNote		nG4, $23

	sCall		$02, DNight_Loop7A
	sNote		nB2, $01
	sNote		nC3, $11
	sNote		nCs3, $01
	sNote		nD3, $11
	sNote		$01
	sNote		nDs3, $11
	sNote		nE3, $01
	sNote		nF3, $11
	sNote		nFs3, $01
	sNote		nG3, $35
	sNote		nB3, $01
	sNote		nC4, $05
	sNote		nFs3, $01
	sNote		nG3, $05
	sNote		nB3, $01
	sNote		nC4, $05
	sNote		nB3, $01
	sNote		nC4, $11
	sNote		nCs4, $01
	sNote		nD4, $11
	sNote		$01
	sNote		nDs4, $11
	sNote		nE4, $01
	sNote		nF4, $11
	sNote		nE4, $01
	sNote		nF4, $35
	sNote		nE4, $01
	sNote		nF4, $05
	sNote		nFs4, $01
	sNote		nG4, $05
	sNote		$01
	sNote		nGs4, $05
	sNote		nG4, $01
	sNote		nGs4, $11
	sNote		nFs4, $01
	sNote		nG4, $11
	sNote		nE4, $01
	sNote		nF4, $11
	sNote		nG4, $01
	sNote		nGs4, $11
	sNote		nFs4, $01
	sNote		nG4, $35
	sNote		nFs4, $01
	sNote		nG4, $05
	sNote		nE4, $01
	sNote		nF4, $05
	sNote		nD4, $01
	sNote		nDs4, $05
	sNote		nE4, $01
	sNote		nF4, $11
	sNote		nFs4, $01
	sNote		nG4, $11
	sNote		nGs4, $01
	sNote		nA4, $11
	sNote		nAs4, $01
	sNote		nB4, $11
	sRet

DNight_FM1_08:
	sVol		-$03
	sNote		nC3, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nC3, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nC3, $0B
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nAs2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nAs2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nAs2, $0B
	sNote		nRst, $01
	sNote		nAs2, $05
	sNote		nRst, $01
	sNote		nAs2, $05
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nGs2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nGs2, $0B
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01
	sNote		nF2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nF2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nF2, $0B
	sNote		nRst, $01
	sNote		nF2, $05
	sNote		nRst, $01
	sNote		nF2, $05
	sNote		nRst, $01

	sCall		$02, DNight_Loop7B
	sNote		nG2
	sNote		nAs2
	sNote		nG2
	sNote		nG3
	sNote		nF3
	sNote		nD3
	sNote		nG3
	sNote		nF3
	sNote		nD3
	sNote		nG3, $12
	sNote		nC3, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nC3, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nC3, $0B
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nAs2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nAs2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nAs2, $0B
	sNote		nRst, $01
	sNote		nAs2, $05
	sNote		nRst, $01
	sNote		nAs2, $05
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nGs2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nGs2, $0B
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01
	sNote		nF2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nF2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nF2, $0B
	sNote		nRst, $01
	sNote		nF2, $05
	sNote		nRst, $01
	sNote		nF2, $05
	sNote		nRst, $01

	sCall		$02, DNight_Loop7B
	sNote		nG2
	sNote		nAs2
	sNote		nG2
	sNote		nG3
	sNote		nF3
	sNote		nD3
	sNote		nG3
	sNote		nF3
	sNote		nD3
	sNote		nG3, $12
	sVol		$02
	sNote		nC4, $C6
	sNote		$12
	sRet

DNight_FM1_09:
	sVol		$04
	sNote		nC2, $06
	sNote		nD2
	sNote		nDs2
	sNote		nC3
	sNote		nD3
	sNote		nDs3
	sNote		nC4
	sNote		nD4
	sNote		nDs4
	sNote		nC5
	sNote		nD5
	sNote		nDs5

	sVol		-$01
	sRet

DNight_Loop68:
	sNote		nRst, $01
	sNote		nG5, $05
	sNote		nRst, $01
	sNote		nF5, $05
	sNote		nRst, $01
	sNote		nDs5, $05
	sRet

DNight_Loop69:
	sNote		nRst, $01
	sNote		nDs5, $05
	sNote		nRst, $01
	sNote		nD5, $05
	sNote		nRst, $01
	sNote		nC5, $05
	sRet

DNight_Loop6A:
	sNote		nRst, $02
	sNote		nF4, $04
	sRet

DNight_Loop6E:
	sNote		nRst, $02
	sNote		nGs4, $04
	sNote		nRst, $02
	sNote		nAs4, $04
	sNote		nRst, $02
	sNote		nC5, $04
	sRet

DNight_Loop6F:
	sNote		nC3, $03
	sNote		nRst
	sVol		$04
	sNote		nC3
	sNote		nRst
	sVol		-$04
	sNote		nC3, $09
	sNote		nRst, $03
	sVol		$04
	sNote		nG2
	sNote		nRst
	sVol		-$04
	sNote		nAs2
	sNote		nRst
	sRet

DNight_Loop71:
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nC3, $05
	sRet

DNight_Loop72:
	sNote		nRst, $01
	sNote		nG4, $05
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sNote		nDs4, $05
	sRet

DNight_Loop73:
	sNote		nRst, $01
	sNote		nAs4, $02
	sNote		nRst, $01
	sNote		nC5, $02
	sRet

DNight_Loop75:
	sNote		nRst, $01
	sNote		nDs6, $05
	sNote		nRst, $01
	sNote		nD6, $05
	sNote		nRst, $01
	sNote		nDs6, $05

	sNote		nRst, $01
	sNote		nC6, $05
	sNote		nRst, $01
	sNote		nD6, $05
	sNote		nRst, $01
	sNote		nDs6, $05
	sRet

DNight_Loop76:
	sNote		nRst, $01
	sNote		nD6, $02
	sNote		nRst, $01
	sNote		nF6, $02
	sRet

DNight_Loop77:
	sNote		nRst, $01
	sNote		nAs6, $05
	sNote		nRst, $01
	sNote		nG6, $05
	sRet

DNight_Loop78:
	sNote		nRst, $01
	sNote		nG6, $05
	sNote		nRst, $01
	sNote		nAs6, $05
	sNote		nRst, $01
	sNote		nC7, $05
	sRet

DNight_Loop79:
	sNote		nC3, $11
	sNote		nFs3, $01
	sNote		nG3, $05
	sNote		nE3, $01
	sNote		nF3, $05
	sNote		nD3, $01
	sNote		nDs3, $05
	sNote		nB2, $01
	sRet

DNight_Loop7A:
	sNote		nB2, $01
	sNote		nC3, $11
	sNote		nFs3, $01
	sNote		nG3, $05
	sNote		nE3, $01
	sNote		nF3, $05
	sNote		nD3, $01
	sNote		nDs3, $05
	sRet

DNight_Loop7B:
	sNote		nG2, $05
	sNote		nRst, $01

	sVol		$04
	sNote		nG2, $05
	sNote		nRst, $01
	sVol		-$04

	sNote		nG2, $05
	sNote		nRst, $01
	sNote		nAs2, $06
	sNote		nG2
	sNote		nAs2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

DNight_FM2:
	sVol		$07
	sVoice		v01
	sPan		center
	sNote		nC3, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nAs2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nGs2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nG2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nF2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nG2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nGs2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

	sNote		nAs2, $0C
	sVol		$03
	sNote		$06
	sVol		$05
	sNote		$06
	sVol		-$08

DNight_FM2_00:
	sCall		$04, DNight_Loop43
	sCall		$04, DNight_Loop44
	sCall		$04, DNight_Loop45
	sCall		$04, DNight_Loop46
	sCall		$04, DNight_Loop47
	sCall		$04, DNight_Loop44
	sCall		$04, DNight_Loop45
	sCall		$04, DNight_Loop46

	sVoice		v01
	sVol		-$02
	sCall		$02, DNight_Loop47

	sNote		nC3
	sNote		nRst, $0C

	sVoice		v06
	sVol		$0A
	sNote		nC3, $12
	sNote		nAs2
	sNote		nF2

	sVoice		v01
	sVol		-$0A
	sCall		$02, DNight_Loop43
	sNote		nC3
	sNote		nRst, $0C

	sVoice		v06
	sVol		$08
	sNote		nDs3, $12
	sNote		nF3
	sNote		nG3

	sVoice		v01
	sVol		-$08
	sCall		$02, DNight_Loop4D
	sCall		$02, DNight_Loop4E
	sCall		$02, DNight_Loop4F
	sCall		$02, DNight_Loop50
	sCall		$02, DNight_Loop51
	sCall		$02, DNight_Loop50
	sCall		$02, DNight_Loop4F
	sCall		$02, DNight_Loop4E
	sCall		$02, DNight_Loop55
	sCall		$02, DNight_Loop4E
	sCall		$02, DNight_Loop4F
	sCall		$02, DNight_Loop50
	sCall		$02, DNight_Loop51
	sCall		$02, DNight_Loop50
	sCall		$02, DNight_Loop4F
	sCall		$02, DNight_Loop4E
	sCall		$04, DNight_Loop5D
	sCall		$04, DNight_Loop5E
	sCall		$04, DNight_Loop5F
	sCall		$02, DNight_Loop60

	sNote		nD3
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		nG2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06

	sCall		$04, DNight_Loop5D
	sCall		$04, DNight_Loop5E
	sCall		$04, DNight_Loop5F
	sCall		$02, DNight_Loop60

	sNote		nD3
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		nG2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		nC3, $04
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nG2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nC3
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nAs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nF2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nAs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nGs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nDs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nGs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nF2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nC2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nF2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08

	sCall		$04, DNight_Loop65
	sNote		nC3, $04
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nG2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nC3
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nAs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nF2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nAs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nGs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nDs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nGs2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nF2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nC2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08
	sNote		nF2
	sVol		$04
	sNote		$04
	sVol		$04
	sNote		$04
	sVol		-$08

	sCall		$04, DNight_Loop65
	sCall		$08, DNight_Loop5D
	sVol		$02
	sJump		DNight_FM2_00

DNight_Loop43:
	sNote		nC3, $06
	sVol		$03
	sNote		$06
	sVol		-$03
	sNote		$0C
	sVol		$03
	sNote		nG2, $06
	sVol		-$03
	sNote		nAs2
	sRet

DNight_Loop44:
	sNote		nGs2
	sVol		$03
	sNote		$06
	sVol		-$03
	sNote		$0C
	sVol		$03
	sNote		nDs2, $06
	sVol		-$03
	sNote		nG2
	sRet

DNight_Loop45:
	sNote		nF2
	sVol		$03
	sNote		$06
	sVol		-$03
	sNote		$0C
	sVol		$03
	sNote		nC2, $06
	sVol		-$03
	sNote		nDs2
	sRet

DNight_Loop46:
	sNote		nG2
	sVol		$03
	sNote		$06
	sVol		-$03
	sNote		$0C
	sVol		$03
	sNote		nD2, $06
	sVol		-$03
	sNote		nF2
	sRet

DNight_Loop47:
	sNote		nC3
	sVol		$03
	sNote		$06
	sVol		-$03
	sNote		$0C
	sVol		$03
	sNote		nG2, $06
	sVol		-$03
	sNote		nAs2
	sRet

DNight_Loop4D:
	sNote		nC3, $06
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sRet

DNight_Loop4E:
	sNote		nAs2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sRet

DNight_Loop4F:
	sNote		nGs2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sRet

DNight_Loop50:
	sNote		nG2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sRet

DNight_Loop51:
	sNote		nF2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sRet

DNight_Loop55:
	sNote		nC3
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sRet

DNight_Loop5D:
	sNote		nC3
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		nG2, $06
	sVol		-$04
	sNote		nAs2
	sRet

DNight_Loop5E:
	sNote		nGs2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$0C
	sVol		$04
	sNote		nDs2, $06
	sVol		-$04
	sNote		nG2
	sRet

DNight_Loop5F:
	sNote		nAs2
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sVol		$04
	sNote		nF2
	sVol		-$04
	sNote		nGs2
	sRet

DNight_Loop60:
	sNote		nDs3
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sNote		nAs2
	sNote		nDs3
	sRet

DNight_Loop65:
	sNote		nG2, $06
	sVol		$04
	sNote		$06
	sVol		-$04
	sNote		$06
	sNote		$06
	sVol		$04
	sNote		nD2
	sVol		-$04
	sNote		nG2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

DNight_FM3:
	sVoice		v02
	sPan		left
	sVol		$11
	sNote		nDs4, $18
	sNote		nD4
	sNote		nC4
	sNote		nAs3
	sNote		nGs3, $48
	sNote		nAs3, $18
	sVol		-$05

DNight_Jump03:
	sVoice		v04
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $8E
	sNote		nFs1, $01
	sNote		nG1
	sNote		nGs1, $8E
	sNote		nDs2, $01
	sNote		nE2
	sNote		nF2, $8E
	sNote		$01
	sNote		nFs2
	sNote		nG2, $46
	sVol		-$02
	sNote		nDs2, $01
	sNote		nE2
	sNote		nF2, $04
	sNote		$01
	sNote		nFs2
	sNote		nG2, $04
	sVol		$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $04
	sVol		-$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $10
	sNote		nGs2, $01
	sNote		nA2
	sNote		nAs2, $04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $04
	sVol		$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $04
	sVol		-$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $10

	sVol		$02
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $8E
	sNote		nFs1, $01
	sNote		nG1
	sNote		nGs1, $8E
	sNote		nDs2, $01
	sNote		nE2
	sNote		nF2, $8E
	sNote		$01
	sNote		nFs2
	sNote		nG2, $46
	sVol		-$02
	sNote		nDs2, $01
	sNote		nE2
	sNote		nF2, $04
	sNote		$01
	sNote		nFs2
	sNote		nG2, $04
	sVol		$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $04
	sVol		-$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $10
	sNote		nGs2, $01
	sNote		nA2
	sNote		nAs2, $04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $04
	sVol		$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $04
	sVol		-$04
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $10
	sVol		$02
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $46
	sNote		nG1, $48
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $46
	sNote		nAs2, $01
	sNote		nB2
	sNote		nC3, $1C
	sNote		$2A

	sVoice		v05
	sVol		$01
	sNote		nC4, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nC4, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nC4, $02
	sNote		nRst, $04
	sNote		nC4, $08

	sCall		$05, DNight_Loop32
	sNote		nRst, $04
	sVol		$04
	sNote		nC4, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nC4, $02
	sNote		nRst, $04
	sNote		nAs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nAs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nAs3, $02
	sNote		nRst, $04
	sNote		nAs3, $08

	sCall		$07, DNight_Loop33
	sNote		nRst, $04
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sNote		nGs3, $08

	sCall		$07, DNight_Loop37
	sNote		nRst, $04
	sNote		nG3, $05
	sNote		nRst, $01
	sVol		$04
	sNote		nG3, $05
	sNote		nRst, $01
	sVol		-$04
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nD4, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01

	sNote		nF3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nF3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop35
	sNote		nF4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop35
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop36
	sNote		nG4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop36
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sNote		nGs3, $08

	sCall		$07, DNight_Loop37
	sNote		nRst, $04
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nF3, $05

	sCall		$02, DNight_Loop38
	sNote		nRst, $01
	sNote		nF4, $05
	sCall		$02, DNight_Loop39
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01

	sNote		nC4, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nC4, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nC4, $02
	sNote		nRst, $04
	sNote		nC4, $08

	sCall		$05, DNight_Loop32
	sNote		nRst, $04
	sVol		$04
	sNote		nC4, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nC4, $02
	sNote		nRst, $04
	sNote		nAs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nAs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nAs3, $02
	sNote		nRst, $04
	sNote		nAs3, $08

	sCall		$07, DNight_Loop33
	sNote		nRst, $04
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sNote		nGs3, $08

	sCall		$07, DNight_Loop37
	sNote		nRst, $04
	sNote		nG3, $05
	sNote		nRst, $01
	sVol		$04
	sNote		nG3, $05
	sNote		nRst, $01
	sVol		-$04
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nD4, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01
	sNote		nG3, $05
	sNote		nRst, $01

	sNote		nF3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nF3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop35
	sNote		nF4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop35
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop36
	sNote		nG4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop36
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nGs3, $02
	sNote		nRst, $04
	sNote		nGs3, $08

	sCall		$07, DNight_Loop37
	sNote		nRst, $04
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nF3, $05

	sCall		$02, DNight_Loop38
	sNote		nRst, $01
	sNote		nF4, $05
	sCall		$02, DNight_Loop39
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01

	sVoice		v04
	sVol		$03
	sNote		nAs2
	sNote		nB2
	sNote		nC3, $8E
	sNote		nFs2, $01
	sNote		nG2
	sNote		nGs2, $8E
	sNote		$01
	sNote		nA2
	sNote		nAs2, $8E
	sNote		nCs3, $01
	sNote		nD3
	sNote		nDs3, $46
	sNote		nC3, $01
	sNote		nCs3
	sNote		nD3, $22
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $22

	sNote		nAs2, $01
	sNote		nB2
	sNote		nC3, $8E
	sNote		nFs2, $01
	sNote		nG2
	sNote		nGs2, $8E
	sNote		$01
	sNote		nA2
	sNote		nAs2, $8E
	sNote		nCs3, $01
	sNote		nD3
	sNote		nDs3, $46
	sNote		nC3, $01
	sNote		nCs3
	sNote		nD3, $22
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $22
	sVol		-$04

	sCall		$02, DNight_Loop42
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $1E, sHold, $00
	sJump		DNight_Jump03

DNight_Loop32:
	sNote		nRst, $04
	sNote		nC4, $02
	sRet

DNight_Loop33:
	sNote		nRst, $04
	sNote		nAs3, $02
	sRet

DNight_Loop35:
	sNote		nF3, $02
	sNote		nRst, $04
	sRet

DNight_Loop36:
	sNote		nG3, $02
	sNote		nRst, $04
	sRet

DNight_Loop37:
	sNote		nRst, $04
	sNote		nGs3, $02
	sRet

DNight_Loop38:
	sNote		nRst, $01
	sNote		nAs3, $05
	sNote		nRst, $01
	sNote		nD4, $05
	sRet

DNight_Loop39:
	sNote		nRst, $01
	sNote		nD4, $05
	sNote		nRst, $01
	sNote		nAs3, $05
	sRet

DNight_Loop42:
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $22
	sNote		nGs1, $01
	sNote		nA1
	sNote		nAs1, $22
	sNote		nFs1, $01
	sNote		nG1
	sNote		nGs1, $22
	sNote		nDs1, $01
	sNote		nE1
	sNote		nF1, $22
	sNote		$01
	sNote		nFs1
	sNote		nG1, $46
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $46
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

DNight_FM4:
	sVoice		v02
	sPan		right
	sVol		$11
	sNote		nC4, $18
	sNote		nAs3
	sNote		nGs3
	sNote		nG3
	sVol		$06
	sNote		nDs3, $48
	sVol		-$06
	sNote		nF3, $18

	sVol		-$05
	sVoice		v04

DNight_Jump02:
	sNote		nF1, $01
	sNote		nFs1
	sNote		nG1, $8E
	sNote		nCs1, $01
	sNote		nD1
	sNote		nDs1, $8E
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $8E
	sNote		$01
	sNote		nCs2
	sNote		nD2, $46
	sVol		-$02
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $04
	sNote		$01
	sNote		nCs2
	sNote		nD2, $04
	sVol		$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $04
	sVol		-$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $10
	sNote		nDs2, $01
	sNote		nE2
	sNote		nF2, $04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $04
	sVol		$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $04
	sVol		-$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $10

	sVol		$02
	sNote		nF1, $01
	sNote		nFs1
	sNote		nG1, $8E
	sNote		nCs1, $01
	sNote		nD1
	sNote		nDs1, $8E
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $8E
	sNote		$01
	sNote		nCs2
	sNote		nD2, $46
	sVol		-$02
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $04
	sNote		$01
	sNote		nCs2
	sNote		nD2, $04
	sVol		$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $04
	sVol		-$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $10
	sNote		nDs2, $01
	sNote		nE2
	sNote		nF2, $04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $04
	sVol		$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $04
	sVol		-$04
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $10
	sVol		$02
	sNote		nF1, $01
	sNote		nFs1
	sNote		nG1, $46
	sNote		nD1, $48
	sNote		nF1, $01
	sNote		nFs1
	sNote		nG1, $46
	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $10
	sNote		nC3, $06
	sNote		nRst
	sNote		nG2, $2A

	sVoice		v05
	sVol		$03
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nG3, $02
	sNote		nRst, $04
	sNote		nG3, $08

	sCall		$05, DNight_Loop21
	sNote		nRst, $04
	sVol		$04
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nG3, $02
	sNote		nRst, $04
	sNote		nF3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nF3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nF3, $02
	sNote		nRst, $04
	sNote		nF3, $08

	sCall		$07, DNight_Loop22
	sNote		nRst, $04
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sNote		nDs3, $08

	sCall		$07, DNight_Loop23
	sNote		nRst, $04
	sNote		nD3, $05
	sNote		nRst, $01
	sVol		$04
	sNote		nD3, $05
	sNote		nRst, $01
	sVol		-$04
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nA3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01

	sNote		nC3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nC3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop24
	sNote		nC4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop24
	sNote		nD3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nD3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop25
	sNote		nD4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop25
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sNote		nDs3, $08

	sCall		$07, DNight_Loop23
	sNote		nRst, $04
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nC3, $05

	sCall		$02, DNight_Loop2F
	sNote		nRst, $01
	sNote		nC4, $05

	sCall		$02, DNight_Loop28
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01

	sNote		nG3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nG3, $02
	sNote		nRst, $04
	sNote		nG3, $08

	sCall		$05, DNight_Loop21
	sNote		nRst, $04
	sVol		$04
	sNote		nG3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nG3, $02
	sNote		nRst, $04
	sNote		nF3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nF3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nF3, $02
	sNote		nRst, $04
	sNote		nF3, $08

	sCall		$07, DNight_Loop22
	sNote		nRst, $04
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sNote		nDs3, $08

	sCall		$07, DNight_Loop23
	sNote		nRst, $04
	sNote		nD3, $05
	sNote		nRst, $01
	sVol		$04
	sNote		nD3, $05
	sNote		nRst, $01
	sVol		-$04
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nA3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01

	sNote		nC3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nC3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop24
	sNote		nC4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop24
	sNote		nD3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nD3, $02
	sNote		nRst, $04
	sVol		-$04

	sCall		$07, DNight_Loop25
	sNote		nD4, $02
	sNote		nRst, $04
	sCall		$02, DNight_Loop25
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sVol		-$04
	sNote		nDs3, $02
	sNote		nRst, $04
	sNote		nDs3, $08

	sCall		$07, DNight_Loop23
	sNote		nRst, $04
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nC3, $05

	sCall		$02, DNight_Loop2F
	sNote		nRst, $01
	sNote		nC4, $05

	sCall		$02, DNight_Loop28
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01

	sVoice		v04
	sVol		$01
	sNote		nF2
	sNote		nFs2
	sNote		nG2, $8E
	sNote		nCs2, $01
	sNote		nD2
	sNote		nDs2, $8E
	sNote		$01
	sNote		nE2
	sNote		nF2, $8E
	sNote		nGs2, $01
	sNote		nA2
	sNote		nAs2, $46
	sNote		nG2, $01
	sNote		nGs2
	sNote		nA2, $22
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $22

	sNote		nF2, $01
	sNote		nFs2
	sNote		nG2, $8E
	sNote		nCs2, $01
	sNote		nD2
	sNote		nDs2, $8E
	sNote		$01
	sNote		nE2
	sNote		nF2, $8E
	sNote		nGs2, $01
	sNote		nA2
	sNote		nAs2, $46
	sNote		nG2, $01
	sNote		nGs2
	sNote		nA2, $22
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $22
	sVol		-$04

	sCall		$02, DNight_Loop31
	sNote		nAs1, $01
	sNote		nB1
	sNote		nC2, $1E, sHold, $00
	sJump		DNight_Jump02

DNight_Loop21:
	sNote		nRst, $04
	sNote		nG3, $02
	sRet

DNight_Loop22:
	sNote		nRst, $04
	sNote		nF3, $02
	sRet

DNight_Loop23:
	sNote		nRst, $04
	sNote		nDs3, $02
	sRet

DNight_Loop24:
	sNote		nC3, $02
	sNote		nRst, $04
	sRet

DNight_Loop25:
	sNote		nD3, $02
	sNote		nRst, $04
	sRet

DNight_Loop2F:
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nA3, $05
	sRet

DNight_Loop28:
	sNote		nRst, $01
	sNote		nA3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sRet

DNight_Loop31:
	sNote		nF1, $01
	sNote		nFs1
	sNote		nG1, $22
	sNote		nDs1, $01
	sNote		nE1
	sNote		nF1, $22
	sNote		nCs1, $01
	sNote		nD1
	sNote		nDs1, $22
	sNote		nAs0, $01
	sNote		nB0
	sNote		nC1, $22
	sNote		$01
	sNote		nCs1
	sNote		nD1, $46
	sNote		nC2, $01
	sNote		nCs2
	sNote		nD2, $46
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

DNight_PSG1:
	sFrac		$0C00
	sVol		$10
	sVibratoSet	PSG
	sVolEnv		v05

	sNote		nDs1, $18
	sNote		nD1
	sNote		nC1
	sNote		nAs0
	sNote		nGs0, $48
	sNote		nAs0, $18

	sVol		$08

DNight_PSG1_00:
	sCall		$02, DNight_Loop94
	sVol		$18
	sNote		nC2, $36
	sNote		nC1, $5A
	sNote		nG1, $36
	sNote		nC2, $5A
	sVol		-$18

	sCall		$0C, DNight_Loop95
	sCall		$0C, DNight_Loop96
	sCall		$0C, DNight_Loop97
	sCall		$0C, DNight_Loop96
	sCall		$24, DNight_Loop95
	sCall		$0C, DNight_Loop96

	sNote		nCut, $09
	sVol		$10

	sNote		nC2, $36
	sNote		$06
	sNote		nD2
	sNote		nDs2
	sNote		nF2, $0C
	sNote		nC2, $06
	sNote		nG2
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		nD2, $18
	sNote		$06
	sNote		nC2
	sNote		nAs1
	sNote		nGs1
	sNote		nAs1
	sNote		nC2
	sNote		nGs1
	sNote		nAs1
	sNote		nC2
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nDs2
	sNote		nF2
	sNote		nDs2
	sNote		nG2, $36
	sNote		$06
	sNote		nAs2
	sNote		nG2
	sNote		nC3, $3C
	sNote		nAs2, $06
	sNote		nG2
	sNote		nAs2
	sNote		nC3
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		$24
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		nAs2
	sNote		nC3

	sCall		$03, DNight_Loop9B
	sNote		nF3
	sNote		nDs3
	sNote		nF3
	sNote		nD3, $3F
	sVol		-$18

	sCall		$02, DNight_Loop9C
	sCall		$02, DNight_Loop9D
	sVol		-$08
	sNote		nDs1, $7E
	sNote		nF1, $12
	sNote		nG1, $90
	sJump		DNight_PSG1_00

DNight_Loop94:
	sNote		nC1, $12
	sNote		nDs1, $06
	sNote		nC1
	sNote		nDs1
	sNote		nG1
	sNote		nDs1
	sNote		nG1
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nC2, $12
	sNote		nG1
	sNote		nC2
	sNote		nD2
	sNote		nDs2, $48
	sNote		nCut, $12
	sNote		nG1
	sNote		nC2
	sNote		nDs2
	sNote		nF2
	sNote		nF2, $06
	sNote		nC2
	sNote		nGs1
	sNote		nF1, $12
	sNote		$06
	sNote		nGs1
	sNote		nC2
	sNote		nF2, $48
	sNote		nG2, $12
	sNote		$06
	sNote		nD2
	sNote		nB1
	sNote		nG1, $12
	sNote		$06
	sNote		nB1
	sNote		nD2
	sNote		nG2, $24
	sNote		$06
	sNote		nD2
	sNote		nB1
	sNote		nG1, $12
	sRet

DNight_Loop95:
	sNote		nG1, $06
	sRet

DNight_Loop96:
	sNote		nF1
	sRet

DNight_Loop97:
	sNote		nDs1
	sRet

DNight_Loop9B:
	sNote		nG3
	sNote		nF3
	sNote		nDs3
	sRet

DNight_PSG1_01:
	sNote		nDs1, $06
	sNote		$06
	sNote		$06
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nC2
	sNote		nC2
	sNote		nC2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nDs2
	sNote		nDs2
	sNote		nDs2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nC2
	sNote		nC2
	sNote		nC2
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sRet

DNight_Loop9C:
	sCall		$02, DNight_PSG1_01

	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nDs2
	sNote		nDs2
	sNote		nDs2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sVol		$08
	sRet

DNight_Loop9D:
	sNote		nC2, $24
	sNote		nAs1
	sNote		nGs1
	sNote		nF1
	sNote		nG1, $48
	sNote		nG2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

DNight_PSG2:
	sVibratoSet	PSG
	sFrac		$0C00
	sVol		$20
	sVolEnv		v05

	sNote		nC1, $18
	sNote		nAs0
	sNote		nGs0
	sNote		nG0
	sVol		$10
	sNote		nDs0, $48
	sVol		-$10
	sNote		nF0, $18
	sFrac		$000E

DNight_Jump05:
	sNote		nCut, $09
	sVol		$18
	sNote		nC1, $12
	sNote		nDs1, $06
	sNote		nC1
	sNote		nDs1
	sNote		nG1
	sNote		nDs1
	sNote		nG1
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nC2, $12
	sNote		nG1
	sNote		nC2
	sNote		nD2
	sNote		nDs2, $48
	sNote		nCut, $12
	sNote		nG1
	sNote		nC2
	sNote		nDs2
	sNote		nF2
	sNote		nF2, $06
	sNote		nC2
	sNote		nGs1
	sNote		nF1, $12
	sNote		$06
	sNote		nGs1
	sNote		nC2
	sNote		nF2, $48
	sNote		nG2, $12
	sNote		$06
	sNote		nD2
	sNote		nB1
	sNote		nG1, $12
	sNote		$06
	sNote		nB1
	sNote		nD2
	sNote		nG2, $24
	sNote		$06
	sNote		nD2
	sNote		nB1
	sNote		nG1, $12
	sNote		nC1
	sNote		nDs1, $06
	sNote		nC1
	sNote		nDs1
	sNote		nG1
	sNote		nDs1
	sNote		nG1
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nC2, $12
	sNote		nG1
	sNote		nC2
	sNote		nD2
	sNote		nDs2, $48
	sNote		nCut, $12
	sNote		nG1
	sNote		nC2
	sNote		nDs2
	sNote		nF2
	sNote		nF2, $06
	sNote		nC2
	sNote		nGs1
	sNote		nF1, $12
	sNote		$06
	sNote		nGs1
	sNote		nC2
	sNote		nF2, $48
	sNote		nG2, $12
	sNote		$06
	sNote		nD2
	sNote		nB1
	sNote		nG1, $12
	sNote		$06
	sNote		nB1
	sNote		nD2
	sNote		nG2, $24
	sNote		$06
	sNote		nD2
	sNote		nB1
	sNote		nG1, $09
	sVol		$08
	sNote		nC2, $36
	sNote		nC1, $5A
	sNote		nG1, $36
	sNote		nC2, $5A
	sVol		-$18

	sCall		$02, DNight_PSG2_02
	sCall		$02, DNight_Loop91
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nDs2
	sNote		nDs2
	sNote		nDs2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2

	sVol		$08
	sCall		$02, DNight_Loop91

	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nDs2
	sNote		nDs2
	sNote		nDs2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nA2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2
	sNote		nB2

	sCall		$02, DNight_Loop93
	sNote		nDs1, $7E
	sNote		nF1, $12
	sNote		nG1, $90
	sVol		-$10
	sJump		DNight_Jump05

DNight_Loop91:
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nC2
	sNote		nC2
	sNote		nC2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nDs2
	sNote		nDs2
	sNote		nDs2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nC2
	sNote		nC2
	sNote		nC2
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sRet

DNight_Loop93:
	sNote		nG1, $24
	sNote		nF1
	sNote		nDs1
	sNote		nC1
	sNote		nD1, $48
	sNote		nD2
	sRet

DNight_Loop87:
	sNote		nDs1, $06
	sRet

DNight_Loop88:
	sNote		nD1
	sRet

DNight_Loop89:
	sNote		nC1
	sRet

DNight_PSG2_02:
	sCall		$0C, DNight_Loop87
	sCall		$0C, DNight_Loop88
	sCall		$0C, DNight_Loop89
	sCall		$0C, DNight_Loop88
	sCall		$0C, DNight_Loop89
	sCall		$0C, DNight_Loop88
	sCall		$0C, DNight_Loop87
	sCall		$0C, DNight_Loop88
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

DNight_PSG3:
	sFrac		$0C00
	sVol		$30
	sVibratoSet	PSG
	sVolEnv		v05
	sCall		$08, DNight_Loop7D
	sVol		$08

DNight_PSG3_00:
	sCall		$02, DNight_Loop7E
	sVol		$10
	sNote		nG1, $36
	sNote		nG0, $5A
	sNote		nC1, $36
	sNote		nG1, $5A
	sVol		-$18
	sNote		nDs2, $36
	sNote		$06
	sNote		nF2
	sNote		nG2
	sNote		nAs2, $12
	sNote		$06
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		nF2, $18
	sNote		$06
	sNote		nDs2
	sNote		nD2
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nDs2
	sNote		nF2
	sNote		nG2
	sNote		nG2
	sNote		nF2
	sNote		nG2
	sNote		nAs2, $36
	sNote		$06
	sNote		nD3
	sNote		nAs2
	sNote		nDs3, $3C
	sNote		nD3, $06
	sNote		nAs2
	sNote		nD3
	sNote		nDs3
	sNote		nCut
	sNote		nDs3, $24
	sNote		nCut, $06
	sNote		nD3
	sNote		nDs3

	sCall		$03, DNight_Loop7F
	sNote		nD3
	sNote		nC3
	sNote		nD3
	sNote		nAs2, $48
	sNote		nC2, $36
	sNote		$06
	sNote		nD2
	sNote		nDs2
	sNote		nF2, $0C
	sNote		nC2, $06
	sNote		nG2
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		nD2, $18
	sNote		$06
	sNote		nC2
	sNote		nAs1
	sNote		nGs1
	sNote		nAs1
	sNote		nC2
	sNote		nGs1
	sNote		nAs1
	sNote		nC2
	sNote		nC2
	sNote		nD2
	sNote		nDs2
	sNote		nDs2
	sNote		nF2
	sNote		nDs2
	sNote		nG2, $36
	sNote		$06
	sNote		nAs2
	sNote		nG2
	sNote		nC3, $3C
	sNote		nAs2, $06
	sNote		nG2
	sNote		nAs2
	sNote		nC3
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		$24
	sVol		$10
	sNote		$06
	sVol		-$10
	sNote		nAs2
	sNote		nC3

	sCall		$03, DNight_Loop80
	sNote		nF3
	sNote		nDs3
	sNote		nF3
	sNote		nD3, $48

	sVol		-$08
	sCall		$02, DNight_Loop81
	sNote		nF0
	sNote		nF0
	sNote		nF0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nG2
	sNote		nG2
	sNote		nG2
	sNote		nG2
	sNote		nG2
	sNote		nG2

	sVol		$08
	sCall		$02, DNight_Loop81
	sNote		nF0
	sNote		nF0
	sNote		nF0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nF1
	sNote		nF1
	sNote		nF1
	sNote		nD1
	sNote		nD1
	sNote		nD1
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nAs0
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nD2
	sNote		nG2
	sNote		nG2
	sNote		nG2
	sNote		nG2
	sNote		nG2
	sNote		nG2

	sCall		$04, DNight_Loop83
	sCall		$09, DNight_Loop84
	sCall		$04, DNight_Loop85
	sCall		$07, DNight_Loop84
	sNote		nC1, $7E
	sNote		nD1, $12
	sNote		nDs1, $90

	sVol		$08
	sJump		DNight_PSG3_00

DNight_Loop7D:
	sNote		nAs0, $02
	sNote		nCut, $04
	sNote		nAs0, $02
	sNote		nCut, $04
	sNote		nAs0, $0A
	sNote		nCut, $02
	sRet

DNight_Loop7E:
	sNote		nG0, $12
	sNote		nC1, $06
	sNote		nG0
	sNote		nC1
	sNote		nDs1
	sNote		nC1
	sNote		nDs1
	sNote		nG1
	sNote		nAs1
	sNote		nC2
	sNote		nG1, $12
	sNote		nDs1
	sNote		nG1
	sNote		nAs1
	sNote		nC2, $48
	sNote		nCut, $12
	sNote		nDs1
	sNote		nG1
	sNote		nC2
	sNote		nC2
	sNote		nC2, $06
	sNote		nGs1
	sNote		nF1
	sNote		nC1, $12
	sNote		$06
	sNote		nF1
	sNote		nGs1
	sNote		nC2, $48
	sNote		nD2, $12
	sNote		$06
	sNote		nB1
	sNote		nG1
	sNote		nD1, $12
	sNote		$06
	sNote		nG1
	sNote		nB1
	sNote		nD2, $24
	sNote		$06
	sNote		nB1
	sNote		nG1
	sNote		nD1, $12
	sRet

DNight_Loop7F:
	sNote		nDs3
	sNote		nD3
	sNote		nC3
	sRet

DNight_Loop80:
	sNote		nG3
	sNote		nF3
	sNote		nDs3
	sRet

DNight_Loop81:
	sNote		nC1, $06
	sNote		$06
	sNote		$06
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nC2
	sNote		nC2
	sNote		nC2
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nG1
	sNote		nDs1
	sNote		nDs1
	sNote		nDs1
	sRet

DNight_Loop83:
	sNote		nFs3, $12
	sVol		-$08
	sNote		$12
	sVol		$08
	sRet

DNight_Loop84:
	sNote		$12
	sRet

DNight_Loop85:
	sVol		-$08
	sNote		$12
	sVol		$08
	sNote		$12
	sRet

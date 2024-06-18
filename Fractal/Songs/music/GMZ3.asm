; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Chapel_Voice
	sHeaderSamples	Chapel_Samples
	sHeaderVibrato	Chapel_Vib
	sHeaderEnvelope	Chapel_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$DC
	sChannel	FM1, Chapel_FM1
	sChannel	FM2, Chapel_FM3
	sChannel	FM3, Chapel_FM2
	sChannel	FM4, Chapel_FM4
	sChannel	FM5, Chapel_FM5
	sChannel	FM6, Chapel_FM6
	sChannel	PSG1, Chapel_PSG1
	sChannel	PSG2, Chapel_PSG2
	sChannel	PSG3, Chapel_PSG3
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Chapel_Voice:
	sNewVoice	v00
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$03, $04, $00, $04
	sMultiple	$0C, $01, $0C, $03
	sRateScale	$00, $00, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $02, $0C, $09
	sDecay2Rate	$07, $07, $07, $07
	sDecay1Level	$0F, $03, $03, $03
	sReleaseRate	$07, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$26, $1E, $2D, $0A
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$01, $00, $01, $01
	sMultiple	$01, $01, $05, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$14, $14, $14, $0D
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $0D, $0B, $04
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $02, $05, $00
	sReleaseRate	$05, $06, $08, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $30, $12, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$06
	sDetune		$07, $03, $07, $03
	sMultiple	$02, $01, $04, $02
	sRateScale	$02, $02, $02, $02
	sAttackRate	$11, $12, $18, $1B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$03, $00, $00, $00
	sDecay2Rate	$02, $02, $00, $00
	sDecay1Level	$05, $00, $00, $00
	sReleaseRate	$0A, $0A, $0A, $0A
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $12, $0E, $0E
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Chapel_Samples:
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

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Chapel_Vib:
	sVibrato FM16,		$0C, $00, $2AA8, $0031, Triangle
	sVibrato FM45,		$10, $00, $5554, $0012, Triangle
	sVibrato PSG,		$00, $00, $2AA8,-$0015, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Chapel_Env:
	sEnvelope v06,		Chapel_Env_v06
; ---------------------------------------------------------------------------

Chapel_Env_v06:
	sEnv		delay=$03,	$18, $10, $10, $08
	seHold		$00

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 and FM6 data
; ---------------------------------------------------------------------------

Chapel_FM6:
	sNote		nRst, $12
	sFrac		-$0014
	sPan		left
	sVol		$0E
	sJump		Chapel_FM1_JMP

Chapel_FM1:
	sPan		center
	sVol		$08

Chapel_FM1_JMP:
	sVibratoSet	FM16
	sVoice		v00

Chapel_FM1_00:
	sCall		$02, Chapel_Loop49
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nF3, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nE3, $08

	sCall		$02, Chapel_Loop1B
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sCall		$01, Chapel_Loop47
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nD3, $08

	sCall		$02, Chapel_Loop4B
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sCall		$01, Chapel_Loop1F
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nF3, $08

	sCall		$01, Chapel_Loop4B
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nC4, $08

	sCall		$02, Chapel_Loop1F
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA3, $08

	sCall		$02, Chapel_Loop4D
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nA3, $08

	sCall		$02, Chapel_Loop21
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sCall		$01, Chapel_Loop4D
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nD3, $23
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nG3, $08

	sCall		$02, Chapel_Loop4F
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sCall		$01, Chapel_Loop50
	sNote		nRst, $01
	sNote		nC4, $08
	sCall		$01, Chapel_Loop1F
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nG4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nF4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nF4, $08

	sCall		$02, Chapel_Loop50
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD4, $08

	sCall		$02, Chapel_Loop51
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nD4, $08

	sCall		$02, Chapel_Loop52
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sCall		$01, Chapel_Loop51
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01
	sNote		nG3, $23
	sNote		nRst, $01

	sVoice		v01
	sVol		-$07
	sNote		nC3, $23
	sNote		nRst, $0A
	sVol		$03
	sNote		nDs3, $05
	sNote		nRst, $04
	sNote		nG3, $05
	sNote		nRst, $04
	sNote		nC4, $05
	sNote		nRst, $04
	sVol		-$01
	sNote		nDs4, $29
	sNote		nRst, $04
	sVol		$01
	sNote		nD4, $02
	sNote		nRst, $03
	sNote		nDs4
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nG4, $2C
	sNote		nRst, $01
	sNote		nG3, $03
	sNote		nRst, $06
	sNote		nC4, $03
	sNote		nRst, $06
	sNote		nDs4, $03
	sNote		nRst, $06
	sNote		nG4, $35
	sNote		nRst, $01
	sVol		$04
	sNote		nG4, $05
	sNote		nGs4, $03
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nB4, $03
	sNote		nRst, $01
	sVol		-$04
	sNote		nC5, $47
	sNote		nRst, $01
	sVol		$04

	sCall		$02, Chapel_Loop53
	sVol		-$04
	sNote		nDs5
	sNote		nRst, $03
	sNote		nC5, $02
	sNote		nRst
	sNote		nG4
	sNote		nRst, $03
	sNote		nDs4, $02
	sNote		nRst
	sNote		nC5
	sNote		nRst, $03
	sNote		nG4, $02
	sNote		nRst
	sNote		nDs4
	sNote		nRst, $03
	sNote		nC4, $02
	sNote		nRst
	sNote		nG4
	sNote		nRst, $03
	sNote		nDs4, $02
	sNote		nRst
	sNote		nC4
	sNote		nRst, $03
	sNote		nG3, $02
	sNote		nRst
	sVol		-$01
	sNote		nC3, $22
	sNote		nRst, $0B
	sVol		-$02
	sNote		nD3, $03
	sNote		nRst, $06
	sVol		$03
	sNote		nDs3, $03
	sNote		nRst, $06
	sNote		nF3, $03
	sNote		nRst, $06

	sVol		$08
	sCall		$04, Chapel_Loop54
	sNote		nG3, $05
	sNote		nRst, $04
	sVol		-$01
	sNote		nG3, $05
	sNote		nRst, $04
	sVol		-$02
	sNote		nG3, $05
	sNote		nRst, $04
	sNote		nG3, $05
	sNote		nRst, $04
	sNote		nC3, $02
	sNote		nRst, $03
	sVol		$03
	sNote		nDs3, $02
	sNote		nRst
	sNote		nG3
	sNote		nRst, $03
	sNote		nC4, $02
	sNote		nRst
	sNote		nC4
	sNote		nRst, $03
	sNote		nG3, $02
	sNote		nRst
	sNote		nDs3
	sNote		nRst, $03
	sNote		nC3, $02

	sCall		$02, Chapel_Loop55
	sNote		nRst
	sVol		-$03
	sNote		nC5
	sNote		nRst, $03
	sVol		$03
	sNote		nDs5, $02
	sNote		nRst
	sNote		nG5
	sNote		nRst, $03
	sNote		nC6, $02
	sNote		nRst
	sNote		nC6
	sNote		nRst, $03
	sNote		nG5, $02
	sNote		nRst
	sNote		nDs5
	sNote		nRst, $03
	sNote		nC5, $02
	sNote		nRst
	sVol		-$03
	sNote		nDs4, $03
	sNote		nRst, $06
	sNote		nD4, $03
	sNote		nRst, $06
	sNote		nC4, $03
	sNote		nRst, $06
	sNote		nAs3, $03
	sNote		nRst, $06
	sNote		nC4, $03
	sNote		nRst, $06
	sNote		nG3, $03
	sNote		nRst, $06
	sNote		nDs3, $03
	sNote		nRst, $06
	sNote		nC3, $03
	sNote		nRst, $06
	sNote		nG2, $08
	sNote		nRst, $01
	sVol		$03
	sNote		nC3, $3E
	sNote		nRst, $01
	sVol		$02

	sCall		$02, Chapel_Loop56
	sNote		nDs3, $11
	sCall		$02, Chapel_Loop57
	sNote		nRst, $01
	sNote		nG3, $11
	sCall		$02, Chapel_Loop58
	sNote		nRst, $01
	sNote		nDs4, $11

	sCall		$02, Chapel_Loop59
	sNote		nRst, $01
	sNote		nG4, $11
	sNote		nRst, $01
	sVol		-$02
	sNote		nC5, $8F
	sNote		nRst, $01

	sVoice		v00
	sVol		$04
	sJump		Chapel_FM1_00

Chapel_Loop46:
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sCall		$01, Chapel_Loop47
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nCs3, $08
	sRet

Chapel_Loop47:
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sRet

Chapel_Loop49:
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nF3, $08

	sCall		$02, Chapel_Loop46
	sCall		$01, Chapel_Loop47
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $01
	sNote		nF3, $08
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nF3, $08
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nE3, $08

	sCall		$02, Chapel_Loop47
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nF3, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nE3, $08

	sCall		$02, Chapel_Loop1B
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sRet

Chapel_Loop4B:
	sNote		nRst, $01
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nF3, $08
	sRet

Chapel_Loop4D:
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sRet

Chapel_Loop4F:
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sRet

Chapel_Loop50:
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sRet

Chapel_Loop51:
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sRet

Chapel_Loop52:
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sRet

Chapel_Loop53:
	sNote		nC5, $02
	sNote		nRst, $03
	sNote		nD5, $02
	sNote		nRst
	sRet

Chapel_Loop54:
	sNote		nG3, $05
	sNote		nRst, $04
	sVol		-$02
	sRet

Chapel_Loop55:
	sNote		nRst
	sVol		-$03
	sNote		nC4
	sNote		nRst, $03
	sVol		$03
	sNote		nDs4, $02
	sNote		nRst
	sNote		nG4
	sNote		nRst, $03
	sNote		nC5, $02
	sNote		nRst
	sNote		nC5
	sNote		nRst, $03
	sNote		nG4, $02
	sNote		nRst
	sNote		nDs4
	sNote		nRst, $03
	sNote		nC4, $02
	sRet

Chapel_Loop56:
	sNote		nC3, $03
	sNote		nRst, $02
	sNote		nD3, $03
	sNote		nRst, $01
	sRet

Chapel_Loop57:
	sNote		nRst, $01
	sNote		nDs3, $03
	sNote		nRst, $02
	sNote		nF3, $03
	sRet

Chapel_Loop58:
	sNote		nRst, $01
	sNote		nC4, $03
	sNote		nRst, $02
	sNote		nD4, $03
	sRet

Chapel_Loop59:
	sNote		nRst, $01
	sNote		nDs4, $03
	sNote		nRst, $02
	sNote		nF4, $03
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Chapel_FM2:
	sVoice		v00
	sPan		center
	sVol		$02

Chapel_FM2_00:
	sCall		$02, Chapel_Loop2D
	sNote		nGs1, $47
	sNote		nRst, $01
	sNote		nA1, $47
	sNote		nRst, $01
	sNote		nD1, $47
	sNote		nRst, $01
	sNote		nE1, $47
	sNote		nRst, $01
	sNote		nF1, $47
	sNote		nRst, $01
	sNote		nFs1, $47
	sNote		nRst, $01
	sNote		nG1, $47
	sNote		nRst, $01
	sNote		nDs1, $47
	sNote		nRst, $01
	sNote		nD1, $47
	sNote		nRst, $01
	sNote		nD1, $08
	sNote		nRst, $01
	sNote		nD2, $08
	sNote		nRst, $01
	sNote		nC2, $08
	sNote		nRst, $01
	sNote		nAs1, $08
	sNote		nRst, $01
	sNote		nA1, $08
	sNote		nRst, $01
	sNote		nG1, $08
	sNote		nRst, $01
	sNote		nFs1, $08
	sNote		nRst, $01
	sNote		nD1, $08
	sNote		nRst, $01
	sNote		nG1, $47
	sNote		nRst, $01
	sNote		nA1, $47
	sNote		nRst, $01
	sNote		nAs1, $47
	sNote		nRst, $01
	sNote		nB1, $47
	sNote		nRst, $01
	sNote		nC2, $47
	sNote		nRst, $01
	sNote		nGs1, $47
	sNote		nRst, $01
	sNote		nG1, $47
	sNote		nRst, $01

	sVoice		v02
	sVol		$02
	sCall		$02, Chapel_Loop2E
	sNote		nG1, $08
	sNote		nRst, $01
	sVol		$05
	sNote		nG1, $08
	sNote		nRst, $01

	sVoice		v02
	sVol		-$07
	sCall		$03, Chapel_Loop2F
	sCall		$02, Chapel_Loop30
	sCall		$07, Chapel_FM2_01

	sVol		$04
	sNote		nC1, $07
	sNote		nRst, $02

	sVoice		v00
	sVol		-$04
	sJump		Chapel_FM2_00

Chapel_Loop2D:
	sNote		nD1, $47
	sNote		nRst, $01
	sNote		nA1, $47
	sNote		nRst, $01
	sNote		nAs1, $47
	sNote		nRst, $01
	sNote		nA1, $47
	sNote		nRst, $01
	sNote		nGs1, $47
	sNote		nRst, $01
	sNote		nA1, $47
	sNote		nRst, $01
	sRet

Chapel_Loop2E:
	sNote		nG1, $08
	sNote		nRst, $01
	sVol		$05
	sNote		nG1, $08
	sNote		nRst, $01
	sVol		-$05
	sNote		nG1, $08
	sNote		nRst, $01
	sRet

Chapel_Loop2F:
	sNote		nC1, $07
	sNote		nRst, $02

Chapel_Loop31:
	sVol		$04
	sNote		nC1, $07
	sNote		nRst, $02
	sVol		-$04
	sNote		nC1, $07
	sNote		nRst, $02
	sRet

Chapel_Loop30:
	sVol		$04
	sNote		nC1, $07
	sNote		nRst, $02
	sVol		-$04
	sNote		nC1, $07
	sNote		nRst, $02
	sNote		nC1, $07
	sNote		nRst, $02
	sRet

Chapel_FM2_01:
	sCall		$02, Chapel_Loop31
	sCall		$02, Chapel_Loop2F
	sCall		$02, Chapel_Loop30
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Chapel_FM3:
	sVoice		v00
	sVol		$0E

Chapel_Jump02:
	sNote		nRst, $0E
	sPan		right
	sCall		$02, Chapel_Loop49

	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nF3, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nE3, $08

	sCall		$02, Chapel_Loop1B
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nE3, $08
	sCall		$01, Chapel_Loop47
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nD3, $08

	sCall		$02, Chapel_Loop4B
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sCall		$01, Chapel_Loop1F
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nF3, $08

	sCall		$01, Chapel_Loop4B
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nC4, $08

	sCall		$02, Chapel_Loop1F
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA3, $08

	sCall		$02, Chapel_Loop4D
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nA3, $08

	sCall		$02, Chapel_Loop21
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sCall		$01, Chapel_Loop4D
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nD3, $23
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nG3, $08

	sCall		$02, Chapel_Loop4F
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sCall		$01, Chapel_Loop50
	sNote		nRst, $01
	sNote		nC4, $08
	sCall		$01, Chapel_Loop1F
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nG4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nF4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nF4, $08

	sCall		$02, Chapel_Loop50
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD4, $08

	sCall		$02, Chapel_Loop51
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $01
	sNote		nD4, $08

	sCall		$02, Chapel_Loop52
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sCall		$01, Chapel_Loop51
	sNote		nRst, $01
	sNote		nG3, $08
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01
	sNote		nG3, $23
	sNote		nRst, $01

	sVoice		v01
	sVol		-$07
	sNote		nC3, $23
	sNote		nRst, $0A
	sVol		$03
	sNote		nDs3, $04
	sNote		nRst, $05
	sNote		nG3, $04
	sNote		nRst, $05
	sNote		nC4, $04
	sNote		nRst, $05
	sVol		-$02
	sNote		nDs4, $28
	sNote		nRst, $05
	sVol		$02
	sNote		nD4, $01
	sNote		nRst, $03
	sNote		nDs4, $04
	sNote		nRst, $01
	sNote		nD4, $08
	sNote		nRst, $01
	sNote		nC4, $07
	sNote		nRst, $02
	sNote		nG4, $2B
	sNote		nRst, $02
	sNote		nG3, $03
	sNote		nRst, $06
	sNote		nC4, $03
	sNote		nRst, $06
	sNote		nDs4, $03
	sNote		nRst, $06
	sNote		nG4, $34
	sNote		nRst, $02
	sVol		$04
	sNote		nG4, $04
	sNote		nGs4, $03
	sNote		nRst, $02
	sNote		nA4, $04
	sNote		nB4, $03
	sNote		nRst, $02
	sVol		-$04
	sNote		nC5, $46
	sNote		nRst, $02
	sVol		$04
	sNote		nC5
	sNote		nRst
	sNote		nD5
	sNote		nRst, $03
	sNote		nC5, $02
	sNote		nRst
	sNote		nD5
	sNote		nRst, $03
	sVol		-$04
	sNote		nDs5, $02
	sNote		nRst
	sNote		nC5
	sNote		nRst, $03
	sNote		nG4, $02
	sNote		nRst
	sNote		nDs4
	sNote		nRst, $03
	sNote		nC5, $02
	sNote		nRst
	sNote		nG4
	sNote		nRst, $03
	sNote		nDs4, $02
	sNote		nRst
	sNote		nC4
	sNote		nRst, $03
	sNote		nG4, $02
	sNote		nRst
	sNote		nDs4
	sNote		nRst, $03
	sNote		nC4, $02
	sNote		nRst
	sNote		nG3
	sNote		nRst, $03
	sVol		-$02
	sNote		nC3, $21
	sNote		nRst, $0C
	sVol		-$01
	sNote		nD3, $03
	sNote		nRst, $06
	sVol		$03
	sNote		nDs3, $03
	sNote		nRst, $06
	sNote		nF3, $03
	sNote		nRst, $06

	sVol		$0A
	sCall		$02, Chapel_Loop26
	sCall		$03, Chapel_Loop27
	sNote		nG3, $04
	sNote		nRst, $05
	sVol		-$01
	sNote		nG3, $04
	sNote		nRst, $05
	sNote		nG3, $04
	sNote		nRst, $05
	sNote		nC3, $02
	sNote		nRst
	sVol		$01
	sNote		nDs3
	sNote		nRst, $03
	sNote		nG3, $02
	sNote		nRst
	sNote		nC4
	sNote		nRst, $03
	sNote		nC4, $02
	sNote		nRst
	sNote		nG3
	sNote		nRst, $03
	sNote		nDs3, $02
	sNote		nRst
	sNote		nC3

	sCall		$02, Chapel_Loop28
	sNote		nRst, $03
	sVol		-$01
	sNote		nC5, $02
	sNote		nRst
	sVol		$01
	sNote		nDs5
	sNote		nRst, $03
	sNote		nG5, $02
	sNote		nRst
	sNote		nC6
	sNote		nRst, $03
	sNote		nC6, $02
	sNote		nRst
	sNote		nG5
	sNote		nRst, $03
	sNote		nDs5, $02
	sNote		nRst
	sNote		nC5
	sNote		nRst, $03
	sVol		-$01
	sNote		nDs4
	sNote		nRst, $06
	sNote		nD4, $03
	sNote		nRst, $06
	sNote		nC4, $03
	sNote		nRst, $06
	sNote		nAs3, $03
	sNote		nRst, $06
	sNote		nC4, $03
	sNote		nRst, $06
	sNote		nG3, $03
	sNote		nRst, $06
	sNote		nDs3, $03
	sNote		nRst, $06
	sNote		nC3, $03
	sNote		nRst, $06
	sNote		nG2, $08
	sNote		nRst, $01
	sVol		$03
	sNote		nC3, $3E
	sNote		nRst, $01
	sVol		$02

	sCall		$02, Chapel_Loop29
	sNote		nDs3, $10
	sCall		$02, Chapel_Loop2A
	sNote		nRst, $02
	sNote		nG3, $10
	sCall		$02, Chapel_Loop2B
	sNote		nRst, $02
	sNote		nDs4, $10
	sCall		$02, Chapel_Loop2C

	sNote		nRst, $02
	sNote		nG4, $10
	sNote		nRst, $02
	sVol		-$02
	sNote		nC5, $82

	sVol		$04
	sJump		Chapel_Jump02

Chapel_Loop1B:
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nD3, $08
	sRet

Chapel_Loop1F:
	sNote		nRst, $01
	sNote		nAs3, $08
	sNote		nRst, $01
	sNote		nA3, $08
	sRet

Chapel_Loop21:
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $01
	sNote		nG3, $08
	sRet

Chapel_Loop26:
	sNote		nG3, $04
	sNote		nRst, $05
	sVol		-$03
	sRet

Chapel_Loop27:
	sNote		nG3, $04
	sNote		nRst, $05
	sVol		-$02
	sRet

Chapel_Loop28:
	sNote		nRst, $03
	sVol		-$01
	sNote		nC4, $02
	sNote		nRst
	sVol		$01
	sNote		nDs4
	sNote		nRst, $03
	sNote		nG4, $02
	sNote		nRst
	sNote		nC5
	sNote		nRst, $03
	sNote		nC5, $02
	sNote		nRst
	sNote		nG4
	sNote		nRst, $03
	sNote		nDs4, $02
	sNote		nRst
	sNote		nC4
	sRet

Chapel_Loop29:
	sNote		nC3, $03
	sNote		nRst, $01
	sNote		nD3, $03
	sNote		nRst, $02
	sRet

Chapel_Loop2A:
	sNote		nRst, $02
	sNote		nDs3, $03
	sNote		nRst, $01
	sNote		nF3, $03
	sRet

Chapel_Loop2B:
	sNote		nRst, $02
	sNote		nC4, $03
	sNote		nRst, $01
	sNote		nD4, $03
	sRet

Chapel_Loop2C:
	sNote		nRst, $02
	sNote		nDs4, $03
	sNote		nRst, $01
	sNote		nF4, $03
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 and FM5 data
; ---------------------------------------------------------------------------

Chapel_FM5:
	sNote		nRst, $0E
	sVol		$0C
	sFrac		-$0018
	sJump		Chapel_FM4_00

Chapel_FM4:
	sVol		$06

Chapel_FM4_00:
	sPan		center
	sVibratoSet	FM45

Chapel_FM4_01:
	sVoice		v01
	sCall		$02, Chapel_Loop17

	sNote		nGs3, $46
	sNote		nRst, $02
	sNote		nA3, $46
	sNote		nRst, $02
	sVol		$02
	sNote		nD3, $22
	sNote		nRst, $02
	sNote		nA3, $22
	sNote		nRst, $02
	sNote		nD4, $22
	sNote		nRst, $02
	sNote		nE4, $22
	sNote		nRst, $02
	sNote		nF4, $46
	sNote		nRst, $02
	sNote		nFs4, $22
	sNote		nRst, $02
	sNote		nA4, $22
	sNote		nRst, $02
	sNote		nAs4, $22
	sNote		nRst, $02
	sNote		nG4, $22
	sNote		nRst, $02
	sNote		nAs4, $22
	sNote		nRst, $02
	sNote		nCs5, $22
	sNote		nRst, $02
	sNote		nD5, $46
	sNote		nRst, $02
	sNote		nD5, $46
	sNote		nRst, $02
	sNote		nG3, $22
	sNote		nRst, $02
	sNote		nD4, $22
	sNote		nRst, $02
	sNote		nG4, $22
	sNote		nRst, $02
	sNote		nA4, $22
	sNote		nRst, $02
	sNote		nAs4, $46
	sNote		nRst, $02
	sNote		nB4, $22
	sNote		nRst, $02
	sNote		nD5, $22
	sNote		nRst, $02
	sNote		nDs5, $22
	sNote		nRst, $02
	sNote		nC5, $22
	sNote		nRst, $02
	sNote		nDs5, $22
	sNote		nRst, $02
	sNote		nFs5, $22
	sNote		nRst, $02
	sNote		nG5, $46
	sNote		nRst, $02
	sNote		nG5, $46
	sNote		nRst, $02

	sVoice		v00
	sVol		$05
	sCall		$20, Chapel_Loop18
	sVol		-$07
	sJump		Chapel_FM4_01

Chapel_Loop17:
	sNote		nD3, $22
	sNote		nRst, $02
	sNote		nD3, $07
	sNote		nRst, $02
	sNote		nE3, $07
	sNote		nRst, $02
	sNote		nF3, $07
	sNote		nRst, $02
	sNote		nG3, $07
	sNote		nRst, $02
	sNote		nA3, $46
	sNote		nRst, $02
	sNote		nAs3, $22
	sNote		nRst, $02
	sNote		nAs3, $07
	sNote		nRst, $02
	sNote		nA3, $07
	sNote		nRst, $02
	sNote		nG3, $07
	sNote		nRst, $02
	sNote		nAs3, $07
	sNote		nRst, $02
	sNote		nA3, $46
	sNote		nRst, $02
	sNote		nGs3, $46
	sNote		nRst, $02
	sNote		nA3, $46
	sNote		nRst, $02
	sRet

Chapel_Loop18:
	sNote		nC4, $07
	sNote		nRst, $02
	sNote		nG3, $07
	sNote		nRst, $02
	sNote		nDs4, $07
	sNote		nRst, $02
	sNote		nG3, $07
	sNote		nRst, $02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Chapel_PSG1:
	sVibratoSet	PSG
	sFrac		$0C00
	sVol		$30
	sVolEnv		v06

Chapel_Jump05:
	sCall		$01, Chapel_PSG1_00
	sNote		$48
	sCall		$04, Chapel_Loop5C
	sJump		Chapel_Jump05

Chapel_PSG1_00:
	sNote		nD1, $48
	sNote		nA1
	sNote		nAs1
	sNote		nA1
	sNote		nGs1
	sNote		nA1
	sNote		nD2
	sNote		nA2
	sNote		nAs2
	sNote		nA2
	sNote		nGs2
	sNote		nA2
	sNote		nGs2
	sNote		nA2
	sNote		nD0, $24
	sNote		nA0
	sNote		nD1
	sNote		nE1
	sNote		nF1, $48
	sNote		nFs1, $24
	sNote		nA1
	sNote		nAs1
	sNote		nG1
	sNote		nAs1
	sNote		nCs2
	sNote		nD2, $48
	sNote		$48
	sNote		nG0, $24
	sNote		nD1
	sNote		nG1
	sNote		nA1
	sNote		nAs1, $48
	sNote		nB1, $24
	sNote		nD2
	sNote		nDs2
	sNote		nC2
	sNote		nDs2
	sNote		nFs2
	sNote		nG2, $48
	sRet

Chapel_Loop5C:
	sNote		nC2
	sNote		nAs1
	sNote		nA1
	sNote		nG1
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Chapel_PSG2:
	sFrac		$000E
	sFrac		$0C00
	sVol		$40
	sVibratoSet	PSG
	sVolEnv		v06

Chapel_Jump04:
	sNote		nCut, $0E
	sCall		$01, Chapel_PSG1_00
	sNote		$3A
	sCall		$04, Chapel_Loop5B
	sJump		Chapel_Jump04

Chapel_Loop5B:
	sNote		nG1, $48
	sNote		nF1
	sNote		nF1
	sNote		nDs1
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

Chapel_PSG3:
	sVibratoSet	PSG
	sFrac		$0C00
	sVol		$38
	sVolEnv		v06

Chapel_Jump03:
	sNote		nCut, $00, nCut, $B0

	sNote		nD1, $48
	sNote		nA1
	sNote		nAs1
	sNote		nA1
	sNote		nGs1
	sNote		nA1
	sNote		nGs1
	sNote		nA1
	sNote		nC0, $24
	sNote		nD0
	sNote		nA0, $48
	sNote		nD1
	sNote		nD1, $24
	sNote		nFs1
	sNote		nG1
	sNote		nD1
	sNote		nG1
	sNote		nAs1
	sNote		nA1, $48
	sNote		$48
	sNote		nD0, $24
	sNote		nG0
	sNote		nD1, $48
	sNote		nG1
	sNote		nG1, $24
	sNote		nB1
	sNote		nC2
	sNote		nG1
	sNote		nC2
	sNote		nDs2
	sNote		nD2, $48
	sNote		$48

	sCall		$04, Chapel_Loop5A
	sJump		Chapel_Jump03

Chapel_Loop5A:
	sNote		nDs1
	sNote		nD1
	sNote		nC1
	sNote		nAs0
	sRet


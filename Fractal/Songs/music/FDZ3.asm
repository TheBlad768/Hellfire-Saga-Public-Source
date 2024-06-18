; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Forest_Voice
	sHeaderSamples	Forest_Samples
	sHeaderVibrato	Forest_Vib
	sHeaderEnvelope	Forest_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FC
	sChannel	DAC1, Forest_DAC1
	sChannel	FM1, Forest_FM1
	sChannel	FM2, Forest_FM4
	sChannel	FM3, Forest_FM2
	sChannel	FM4, Forest_FM3
	sChannel	FM5, Forest_FM5
	sChannel	PSG1, Forest_PSG2
	sChannel	PSG2, Forest_PSG1
	sChannel	PSG3, Forest_PSG3
	sChannel	PSG4, Forest_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Forest_Voice:
	sNewVoice	v00
	sAlgorithm	$06
	sFeedback	$07
	sDetune		$00, $06, $06, $00
	sMultiple	$02, $01, $02, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0C, $1F, $0C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$09, $09, $09, $09
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$21, $10, $10, $10
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$06
	sFeedback	$03
	sDetune		$00, $00, $00, $00
	sMultiple	$0A, $02, $04, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $1A, $1A, $1A
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$06, $06, $06, $06
	sMultiple	$06, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $06
	sDecay2Rate	$07, $06, $06, $08
	sDecay1Level	$02, $01, $01, $0F
	sReleaseRate	$00, $00, $00, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$19, $13, $37, $0A
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$02, $02, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$04, $04, $04, $04
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0E
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1B, $28, $32, $0A
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$06, $03, $06, $03
	sMultiple	$01, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $01, $01
	sDecay1Level	$00, $00, $03, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $17, $14, $14
	sFinishVoice

	sNewVoice	v05
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
	sTotalLevel	$22, $24, $26, $0C
	sFinishVoice

	sNewVoice	v06
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $00, $01
	sRateScale	$02, $00, $01, $01
	sAttackRate	$0D, $15, $0F, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $0E, $08, $03
	sDecay2Rate	$04, $00, $00, $00
	sDecay1Level	$01, $01, $01, $02
	sReleaseRate	$05, $05, $05, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $0F, $1E, $0F
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Forest_Samples:
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

Forest_Vib:
	sVibrato FM2,		$00, $00, $2AA8, $0024, Triangle
	sVibrato FM4,		$00, $00, $2490, $0024, Triangle
	sVibrato PSG1,		$10, $00, $2AA8,-$000D, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Forest_Env:
	sEnvelope v02,		Forest_v02
	sEnvelope v03,		Forest_v03
	sEnvelope v05,		Forest_v05
; ---------------------------------------------------------------------------

Forest_v02:
	sEnv		delay=$01,	$00, $10, $20, $30, $40, $7F
	seMute
; ---------------------------------------------------------------------------

Forest_v03:
	sEnv		delay=$02,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Forest_v05:
	sEnv		delay=$0A,	$00
	sEnv		delay=$0E,	$08
	sEnv		delay=$08,	$10, $18
	seHold		$20

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Forest_DAC1:
	sNote		nRst, $01
	sVol		$04
	sPan		center

	sSample		Snare
	sNote		nSample, $01
	sNote		nRst, $07

	sSample		Snare
	sNote		nSample, $09
	sNote		$09
	sNote		$09
	sNote		$12

	sCall		$02, Forest_Loop00
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$09
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$0E
	sNote		$04
	sNote		$09
	sNote		$09
	sNote		$09
	sNote		$09

Forest_Jump00:
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$1B
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B

	sCall		$03, Forest_Loop01
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sSample		Kick

	sCall		$02, Forest_Loop02
	sCall		$03, Forest_Loop03
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$09
	sNote		$1B
	sNote		$09
	sNote		$09
	sNote		$12
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sNote		$12
	sNote		$12
	sNote		$05
	sNote		$04
	sNote		$09
	sNote		$09
	sNote		$09
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$1B
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09

	sCall		$03, Forest_Loop04
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$1B
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$1B
	sNote		$09
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$1B
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09

	sCall		$03, Forest_Loop04
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$09
	sNote		$1B
	sNote		$09
	sNote		$09
	sNote		$12
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$12
	sNote		$09
	sNote		$12
	sNote		$12
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$17
	sNote		$04
	sNote		$09
	sNote		$09
	sNote		$09
	sNote		$09
	sNote		$09

	sCall		$02, Forest_Loop06
	sNote		$09
	sNote		$09
	sNote		$1B
	sNote		$09
	sNote		$09
	sNote		$09
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$09
	sSample		Kick
	sNote		$09
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$09
	sNote		$09
	sJump		Forest_Jump00

Forest_Loop00:
	sNote		$09
	sNote		$09
	sNote		$09
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sRet

Forest_Loop01:
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sRet

Forest_Loop02:
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$09
	sRet

Forest_Loop03:
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$24
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sSample		Snare
	sNote		$12
	sRet

Forest_Loop04:
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$1B
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sRet

Forest_Loop06:
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$1B
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$1B
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$1B
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$1B
	sSample		Snare
	sNote		$09
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Forest_FM1:
	sNote		nRst, $FC
	sVoice		v02
	sPan		center
	sVol		$05

	sNote		nE3, $09
	sNote		nA2
	sNote		nD3
	sNote		nG2

Forest_FM1_00:
	sCall		$02, Forest_Loop0C
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2
	sNote		nA2, $09
	sNote		nG2, $1B
	sNote		nA2, $12
	sNote		$12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2, $09
	sNote		nG2
	sNote		nA2
	sNote		nD2, $1B
	sNote		nE2, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2
	sNote		nA2, $09
	sNote		nG2, $1B
	sNote		nA2, $12
	sNote		$12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2, $09
	sNote		nG2, $12
	sNote		nD3
	sNote		nAs2, $09
	sNote		$09
	sNote		nC3
	sNote		nG2, $12
	sNote		$12
	sNote		nF2
	sNote		nF2
	sNote		nG2, $09
	sNote		nF2
	sNote		nG2
	sNote		nC2, $1B
	sNote		nD2, $12
	sNote		nG2
	sNote		nG2
	sNote		nF2
	sNote		nF2
	sNote		nG2, $09
	sNote		nF2
	sNote		nG2
	sNote		nC3, $1B
	sNote		nAs2, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2, $0A
	sNote		nG2, $08
	sNote		nA2, $09
	sNote		nG2, $1B
	sNote		nA2, $12
	sNote		$12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2, $0A
	sNote		nG2, $08
	sNote		nA2, $09
	sNote		nD2, $1B
	sNote		nE2, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2
	sNote		nA2, $09
	sNote		nG2, $1B
	sNote		nA2, $12
	sNote		$12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2, $09
	sNote		nG2
	sNote		nA2
	sNote		nD2, $1B
	sNote		nE2, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2
	sNote		nA2, $09
	sNote		nG2, $1B
	sNote		nA2, $12
	sNote		$12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2, $09
	sNote		nG2, $12
	sNote		nD3
	sNote		nAs2, $09
	sNote		$09
	sNote		nC3
	sNote		nG2, $12
	sNote		$12
	sNote		nF2
	sNote		nF2
	sNote		nG2, $09
	sNote		nF2
	sNote		nG2
	sNote		nC2, $1B
	sNote		nD2, $12
	sNote		nG2
	sNote		nG2
	sNote		nF2
	sNote		nF2
	sNote		nG2, $09
	sNote		nF2
	sNote		nG2
	sNote		nC3, $1B
	sNote		nAs2, $12
	sNote		nA2, $09
	sNote		$09
	sNote		nA3, $1B
	sNote		nA2, $09
	sNote		$12
	sNote		$09
	sNote		$12
	sNote		$1B
	sNote		nA3, $12
	sNote		nA2, $09
	sNote		$1B
	sNote		$12
	sNote		$12
	sNote		$09
	sNote		nA3
	sNote		nA2
	sNote		nA2
	sNote		nE3
	sNote		nA3
	sNote		nG3
	sNote		nE3

	sCall		$02, Forest_Loop0E
	sNote		$09
	sNote		$09
	sNote		$1B
	sNote		nG2, $09
	sNote		$12
	sNote		nA2, $09
	sNote		nG2
	sNote		nA2
	sNote		nG2, $1B
	sNote		nA2, $12
	sNote		$09
	sNote		$1B
	sNote		nG2, $12
	sNote		$12
	sNote		nA2, $09
	sNote		nG2
	sNote		nA2
	sNote		nE3
	sNote		nA2
	sNote		nD3
	sNote		nG2
	sNote		nE2
	sJump		Forest_FM1_00

Forest_Loop0E:
	sNote		nD2, $12
	sNote		nA2, $09
	sNote		nD2
	sNote		nG2
	sNote		nD2
	sNote		nA2
	sNote		nD2, $1B
	sNote		nA2, $09
	sNote		nD2
	sNote		nG2, $12
	sNote		nA2
	sNote		nD2
	sNote		nA2, $09
	sNote		nD2
	sNote		nG2
	sNote		nD2
	sNote		nA2
	sNote		nC3, $1B
	sNote		nA2, $09
	sNote		nD2
	sNote		nG2
	sNote		nD2
	sNote		nA2
	sNote		nD2
	sCall		$01, Forest_Loop0D

Forest_Loop0D:
	sNote		nD2, $12
	sNote		nA2, $09
	sNote		nD2
	sNote		nG2
	sNote		nD2
	sNote		nA2
	sNote		nD2, $1B
	sNote		nA2, $09
	sNote		nD2
	sNote		nG2
	sNote		nD2
	sNote		nA2, $12
	sRet

Forest_Loop0C:
	sNote		nA2, $12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2
	sNote		nA2, $09
	sNote		nG2, $12
	sNote		$09
	sNote		nA2, $12
	sNote		$12
	sNote		$12
	sNote		nG2
	sNote		nG2
	sNote		nA2, $09
	sNote		nG2
	sNote		nA3
	sNote		nD3, $1B
	sNote		nE3, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2
	sNote		nA3, $09
	sNote		nG3, $1B
	sNote		nA3, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2, $09
	sNote		nG2, $12
	sNote		nD3
	sNote		nAs2, $09
	sNote		$09
	sNote		nC3
	sNote		nG2, $12
	sNote		$12
	sNote		nF2
	sNote		nF2
	sNote		nG2, $09
	sNote		nF2
	sNote		nG2
	sNote		nC2, $1B
	sNote		nD2, $12
	sNote		nG2
	sNote		nG2
	sNote		nF2
	sNote		nF2
	sNote		nG2, $09
	sNote		nF2
	sNote		nG2
	sNote		nC3, $1B
	sNote		nAs2, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2, $0A
	sNote		nG2, $08
	sNote		nA2, $09
	sNote		nG3, $1B
	sNote		nA3, $12
	sNote		nA2
	sNote		nA2
	sNote		nG2
	sNote		nG2
	sNote		nA2, $0A
	sNote		nG2, $08
	sNote		nA2, $09
	sNote		nD2, $1B
	sNote		nE2, $12
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Forest_FM2:
	sNote		nRst, $120
	sVibratoSet	FM2
	sPan		center
	sVol		$2D

Forest_Jump04:
	sNote		nRst, $480

	sVoice		v01
	sNote		nG4, $09
	sVol		-$0B
	sNote		nD5
	sVol		-$08
	sNote		nG4, $12
	sVol		-$0A
	sNote		nC5, $09
	sVol		-$04
	sNote		nG4
	sVol		-$03
	sNote		nD5, $12
	sVol		-$07

	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nG4, $09
	sNote		nC5
	sNote		nD5
	sNote		nG4
	sNote		nA4, $12
	sNote		nE5, $09
	sNote		nA4
	sNote		nD5
	sNote		nA4
	sNote		nE5
	sNote		nA4
	sNote		nE5
	sNote		nD5
	sNote		nA4
	sNote		nE5
	sNote		nA4, $12
	sNote		nD5, $09
	sNote		nA4
	sNote		nE5
	sNote		nA4
	sNote		nD5
	sNote		nE5
	sNote		nA4
	sNote		nD5
	sNote		nE5
	sNote		nA4
	sNote		nE5
	sNote		nA4
	sNote		nD5
	sNote		nA4
	sNote		nE5
	sNote		nD5
	sNote		nA4, $12
	sNote		nC5
	sNote		nG5, $09
	sNote		nC5
	sNote		nF5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5, $12
	sNote		nG5, $09
	sNote		nC5
	sNote		nF5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nC5, $09
	sNote		nG4
	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nG4, $09
	sNote		nC5
	sNote		nD5
	sNote		nG5

	sVol		$08
	sNote		nG4
	sNote		nC5
	sNote		nD5
	sNote		nG5
	sVol		$0D
	sNote		nG4
	sNote		nC5
	sNote		nD5
	sNote		nG5

	sVoice		v03
	sVol		-$15
	sNote		nC4, $24
	sNote		nE4, $1B
	sNote		nD4, $87
	sNote		nA3, $09
	sNote		nB3
	sNote		nC4, $00, sTie, $20
	sNote		nA3, $24
	sNote		nB3
	sNote		nC4
	sNote		nE4, $1B
	sNote		nD4, $87
	sNote		nA3, $09
	sNote		nB3
	sNote		nC4, $00, sTie, $20

	sVoice		v04
	sNote		nA3, $24
	sNote		nB3
	sNote		nC4
	sNote		nE4, $1B
	sNote		nD4, $87
	sNote		nA3, $09
	sNote		nB3
	sNote		nC4, $00, sTie, $20
	sNote		nB3, $24
	sNote		nC4
	sNote		nD4
	sNote		nE4, $1B
	sNote		nD4, $90
	sNote		nE4, $09

	sVoice		v05
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nC5, $09
	sNote		nG4
	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nA4, $09
	sNote		nF5
	sNote		nE5
	sNote		nC5
	sNote		nRst

	sVol		$07
	sNote		nA4
	sNote		nF5
	sNote		nE5
	sNote		nC5
	sVol		$0B
	sNote		nA4

	sVoice		v06
	sVol		-$12
	sNote		$09
	sNote		nD5
	sNote		nG5, $1B
	sNote		nF5
	sNote		nAs5, $12
	sNote		nA5, $6C
	sNote		nF5, $09
	sNote		nG5, $12
	sNote		nA5, $09
	sNote		nD5, $6C
	sNote		nE5, $09
	sNote		nF5, $12
	sNote		nA5, $09
	sNote		nD5, $75
	sNote		nF5, $09
	sNote		nE5
	sNote		nC5, $3F
	sNote		nE5, $09
	sNote		nD5
	sNote		nG5, $1B
	sNote		nF5
	sNote		nAs5, $12
	sNote		nA5, $6C
	sNote		nF5, $09
	sNote		nG5, $12
	sNote		nA5, $87
	sNote		nG5, $09
	sNote		nA5
	sNote		nC6, $48
	sNote		nAs5
	sNote		nG4, $09
	sNote		nD5
	sNote		nG4, $12
	sNote		nC5, $09
	sNote		nG4
	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nG4, $09
	sNote		nC5
	sNote		nD5
	sNote		nG5

	sVol		$2B
	sJump		Forest_Jump04

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Forest_FM3:
	sVoice		v01
	sPan		right
	sNote		nRst, $120

	sFrac		-$001E
	sVibratoSet	FM2
	sVol		$25

Forest_Jump03:
	sNote		nRst, $480

	sVoice		v01
	sNote		nG4, $1B
	sVol		-$0B
	sNote		nD5, $09
	sVol		-$03
	sNote		nG4, $12
	sVol		-$05
	sNote		nC5, $09
	sVol		-$03
	sNote		nG4
	sVol		-$07

	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nG4, $09
	sNote		nC5
	sNote		nD5
	sNote		nG4
	sNote		nA4, $12
	sNote		nE5, $09
	sNote		nA4
	sNote		nD5
	sNote		nA4
	sNote		nE5
	sNote		nA4
	sNote		nE5
	sNote		nD5
	sNote		nA4
	sNote		nE5
	sNote		nA4, $12
	sNote		nD5, $09
	sNote		nA4
	sNote		nE5
	sNote		nA4
	sNote		nD5
	sNote		nE5
	sNote		nA4
	sNote		nD5
	sNote		nE5
	sNote		nA4
	sNote		nE5
	sNote		nA4
	sNote		nD5
	sNote		nA4
	sNote		nE5
	sNote		nD5
	sNote		nA4, $12
	sNote		nC5
	sNote		nG5, $09
	sNote		nC5
	sNote		nF5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5, $12
	sNote		nG5, $09
	sNote		nC5
	sNote		nF5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nC5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG5
	sNote		nC5
	sNote		nF5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nC5, $09
	sNote		nG4
	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nG4, $09
	sNote		nC5
	sNote		nRst, $5A

	sVoice		v03
	sNote		nC4, $24
	sNote		nE4, $1B
	sNote		nD4, $87
	sNote		nA3, $09
	sNote		nB3
	sNote		nC4, $00, sTie, $20
	sNote		nA3, $24
	sNote		nB3
	sNote		nC4
	sNote		nE4, $1B
	sNote		nD4, $87
	sNote		nA3, $09
	sNote		nB3
	sNote		nC4, $00, sTie, $0E
	sNote		nRst, $09

	sVoice		v04
	sNote		nA3, $24
	sNote		nB3
	sNote		nC4
	sNote		nE4, $1B
	sNote		nD4, $87
	sNote		nA3, $09
	sNote		nB3
	sNote		nC4, $00, sTie, $20
	sNote		nB3, $24
	sNote		nC4
	sNote		nD4
	sNote		nE4, $1B
	sNote		nD4, $90

	sVoice		v05
	sNote		nG4, $1B
	sNote		nD5, $09
	sNote		nG4, $12
	sNote		nC5, $09
	sNote		nG4
	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nA4, $09
	sNote		nF5

	sVol		-$05
	sNote		nA4
	sNote		nF5
	sNote		nE5
	sNote		nC5
	sVol		$08
	sNote		nA4
	sNote		nF5
	sNote		nE5
	sNote		nC5
	sNote		nRst

	sVoice		v06
	sVol		-$03
	sNote		nA4
	sNote		nD5
	sNote		nG5, $1B
	sNote		nF5
	sNote		nAs5, $12
	sNote		nA5, $6C
	sNote		nF5, $09
	sNote		nG5, $12
	sNote		nA5, $09
	sNote		nD5, $6C
	sNote		nE5, $09
	sNote		nF5, $12
	sNote		nA5, $09
	sNote		nD5, $75
	sNote		nF5, $09
	sNote		nE5
	sNote		nC5, $3F
	sNote		nE5, $09
	sNote		nD5
	sNote		nG5, $1B
	sNote		nF5
	sNote		nAs5, $12
	sNote		nA5, $6C
	sNote		nF5, $09
	sNote		nG5, $12
	sNote		nA5, $87
	sNote		nG5, $09
	sNote		nA5
	sNote		nC6, $48
	sNote		nAs5, $2D
	sNote		nG4, $1B
	sNote		nD5, $09
	sNote		nG4, $12
	sNote		nC5, $09
	sNote		nG4
	sNote		nD5, $12
	sNote		$09
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nE5
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nG4
	sNote		nD5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nG4
	sNote		nD5
	sNote		nG4, $12
	sNote		nD5
	sNote		nG4, $09
	sNote		nC5

	sVol		$1D
	sJump		Forest_Jump03

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Forest_FM4:
	sNote		nRst, $120
	sPan		center
	sLFO		3.98hz
	sVibratoSet	FM4
	sVol		$06

Forest_Jump02:
	sVoice		v00
	sAMSFMS		0db, 10%
	sCall		$02, Forest_Loop08
	sCall		$02, Forest_Loop09

	sVoice		v04
	sAMSFMS		0db, 10%
	sNote		$6C
	sNote		nD4, $B4
	sNote		nE4, $90
	sNote		nF4, $90
	sNote		nA3, $6C
	sNote		nD4, $B4
	sNote		nE4, $90
	sNote		nDs4, $90

	sVol		-$01
	sNote		nA2, $A8
	sFrac		-$001E		; ssDetune $F9
	sNote		sHold, $06
	sFrac		-$0016		; ssDetune $F4
	sNote		sHold, $06
	sFrac		-$001F		; ssDetune $ED
	sNote		sHold, $06
	sFrac		-$0016		; ssDetune $E8
	sNote		sHold, $06
	sFrac		-$001F		; ssDetune $E1
	sNote		sHold, $06
	sFrac		$00F1		; ssDetune $18
	sNote		sHold, nGs2
	sFrac		-$0016		; ssDetune $13
	sNote		sHold, $06
	sFrac		-$001F		; ssDetune $0C
	sNote		sHold, $06
	sFrac		-$001A		; ssDetune $06
	sNote		sHold, $06
	sFrac		-$001A		; ssDetune $00
	sNote		sHold, $06
	sFrac		-$001A		; ssDetune $FA
	sNote		sHold, $06
	sFrac		-$0017		; ssDetune $F5
	sNote		sHold, $06
	sFrac		-$001B		; ssDetune $EF
	sNote		sHold, $06
	sFrac		-$001B		; ssDetune $E9
	sNote		sHold, $06
	sFrac		-$001B		; ssDetune $E3
	sNote		sHold, $06
	sFrac		$00E4		; ssDetune $16
	sNote		sHold, nG2
	sFrac		-$0016		; ssDetune $11
	sNote		sHold, $06
	sFrac		-$001B		; ssDetune $0B
	sNote		sHold, $06
	sFrac		-$0017		; ssDetune $06
	sNote		sHold, $06
	sFrac		-$001A		; ssDetune $00
	sNote		sHold, $06

	sVol		$01
	sJump		Forest_Jump02

Forest_Loop08:
	sNote		nF3, $FC
	sNote		nAs3, $24
	sNote		nA3, $FC
	sNote		nC4, $24
	sNote		nGs3, $120
	sNote		nA3, $120
	sRet

Forest_Loop09:
	sNote		nF3, $FC
	sNote		nAs3, $24
	sNote		nA3, $FC
	sNote		nC4, $24
	sNote		nG3, $120
	sNote		nA3, $120
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Forest_FM5:
	sNote		nRst, $120
	sVibratoSet	FM4
	sPan		left
	sFrac		-$001E
	sVol		$0A

Forest_Jump01:
	sNote		nRst, $09

	sVoice		v00
	sAMSFMS		0db, 10%
	sNote		nF3, $FC
	sNote		nAs3, $24
	sNote		nA3, $FC
	sNote		nC4, $24
	sNote		nGs3, $120
	sNote		nA3, $117

	sNote		nRst, $4EC
	sNote		nF3, $99
	sNote		nAs3, $24
	sNote		nA3, $FC
	sNote		nC4, $24
	sNote		nG3, $120
	sNote		nA3, $120
	sNote		nF3, $FC
	sNote		nAs3, $24
	sNote		nA3, $FC
	sNote		nC4, $24
	sNote		nG3, $117
	sNote		nRst, $1B0

	sVol		-$05
	sVoice		v04
	sAMSFMS		0db, 10%
	sNote		nAs3, $90
	sNote		nC4, $90
	sNote		nD4, $90
	sNote		nRst, $90
	sNote		nAs3, $90
	sNote		nC4, $90
	sNote		nG3, $90
	sNote		nRst, $120

	sVol		$05
	sJump		Forest_Jump01

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Forest_PSG1:
	sNote		nCut, $120
	sFrac		$0C00
	sVol		$10

Forest_Jump07:
	sNote		nCut, $900

	sVolEnv		v05
	sVibratoSet	PSG1
	sCall		$02, Forest_Loop15
	sNote		nCut, $360

	sVolEnv		v03
	sNote		nG1, $09
	sNote		nD2
	sNote		nG1, $12
	sNote		nC2, $09
	sNote		nG1
	sNote		nD2, $12
	sNote		$09
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nE2
	sNote		nG1
	sNote		nD2
	sNote		nG1
	sNote		nG1
	sNote		nD2
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nD2
	sNote		nG1, $12
	sNote		nD2
	sNote		nA1, $09
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sNote		nCut
	sVol		$18
	sNote		nA1
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sVol		$20
	sNote		nA1

	sNote		nCut, $56A
	sVol		-$38
	sJump		Forest_Jump07

Forest_Loop15:
	sNote		nA0, $24
	sNote		nB0
	sNote		nC1
	sNote		nE1, $1B
	sNote		nD1, $87
	sNote		nA0, $09
	sNote		nB0
	sNote		nC1, $120
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Forest_PSG2:
	sNote		nCut, $120
	sFrac		$0C00
	sVol		$20

Forest_Jump06:
	sNote		nCut, $912

	sFrac		$0008
	sVibratoSet	PSG1
	sVolEnv		v05

	sNote		nA0, $24
	sNote		nB0
	sNote		nC1
	sNote		nE1, $1B
	sNote		nD1, $87
	sNote		nA0, $09
	sNote		nB0
	sNote		nC1, $120
	sNote		nA0, $24
	sNote		nB0
	sNote		nC1
	sNote		nE1, $1B
	sNote		nD1, $87
	sNote		nA0, $09
	sNote		nB0
	sNote		nC1, $10E
	sNote		nCut, $360

	sVolEnv		v03
	sNote		nG1, $1B
	sNote		nD2, $09
	sNote		nG1, $12
	sNote		nC2, $09
	sNote		nG1
	sNote		nD2, $12
	sNote		$09
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nE2
	sNote		nG1
	sNote		nD2
	sNote		nG1
	sNote		nG1
	sNote		nD2
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nD2
	sNote		nG1, $12
	sNote		nD2
	sNote		nA1, $09
	sNote		nF2
	sVol		-$10
	sNote		nA1
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sVol		$18
	sNote		nA1
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sVol		$20
	sNote		nA1
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sNote		nCut, $1D4

	sVol		-$38
	sNote		nA1, $09
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sVol		$18
	sNote		nA1
	sNote		nF2
	sNote		nE2
	sNote		nC2
	sVol		$20
	sNote		nA1
	sNote		nF2
	sNote		nE2
	sNote		nC2

	sNote		nCut, $2F4
	sVol		-$28
	sJump		Forest_Jump06

; ===========================================================================
; ---------------------------------------------------------------------------
; Noise data
; ---------------------------------------------------------------------------

Forest_PSG4:
	sNote		nCut, $01
	sVolEnv		v02
	sVol		$10
	sNote		nWhitePSG3, $01
	sJump		Forest_PSG_Noise

Forest_PSG3:
	sNote		nCut, $01
	sNote		nHiHat, $01
	sVol		$7F

Forest_PSG_Noise:
	sNote		$10
	sNote		$12
	sNote		$09
	sNote		$09

	sCall		$07, Forest_Loop0F
	sNote		$09
	sNote		$09
	sNote		$12
	sNote		$12
	sNote		$12
	sNote		$12
	sNote		$09
	sNote		$1B

Forest_Jump05:
	sCall		$03, Forest_Loop10
	sNote		$48
	sNote		$48
	sNote		$63
	sNote		$12
	sNote		$75
	sNote		$1B
	sNote		$1B
	sNote		$990

	sNote		$6C
	sNote		$90
	sNote		$09
	sNote		$87
	sNote		$90
	sNote		$09
	sNote		$1B
	sNote		$6C
	sNote		$90
	sNote		$09
	sNote		$87
	sNote		$90
	sNote		$09
	sNote		$13B
	sJump		Forest_Jump05

Forest_Loop0F:
	sNote		$12
	sRet

Forest_Loop10:
	sNote		$48
	sNote		$48
	sNote		$63
	sNote		$12
	sNote		$75
	sNote		$1B
	sNote		$1B
	sNote		$6C
	sNote		$24
	sRet

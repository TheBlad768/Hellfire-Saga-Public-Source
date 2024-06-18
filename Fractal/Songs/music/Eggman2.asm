; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	ShadowMaster_Voice
	sHeaderSamples	ShadowMaster_Samples
	sHeaderVibrato	ShadowMaster_Vib
	sHeaderEnvelope	ShadowMaster_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$DC
	sChannel	DAC1, ShadowMaster_DAC1
	sChannel	FM1, ShadowMaster_FM1
	sChannel	FM2, ShadowMaster_FM3
	sChannel	FM3, ShadowMaster_FM2
	sChannel	FM4, ShadowMaster_FM4
	sChannel	FM5, ShadowMaster_FM5
	sChannel	PSG3, ShadowMaster_PSG3
	sChannel	PSG4, ShadowMaster_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

ShadowMaster_Voice:
	sNewVoice	v00
	sAlgorithm	$00
	sFeedback	$03
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $00, $00
	sRateScale	$02, $00, $03, $02
	sAttackRate	$1E, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $04, $06, $01
	sDecay2Rate	$08, $03, $0A, $05
	sDecay1Level	$0B, $03, $0B, $02
	sReleaseRate	$06, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2C, $14, $22, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$07
	sFeedback	$07
	sDetune		$01, $01, $00, $00
	sMultiple	$00, $02, $04, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0A, $09, $09, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0F, $02, $0A, $02
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $00, $00, $07
	sMultiple	$02, $02, $00, $03
	sRateScale	$02, $01, $03, $01
	sAttackRate	$1F, $0F, $1F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0F, $0F, $0F
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0E
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $17, $1F, $00
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $00, $04, $03
	sMultiple	$02, $00, $00, $01
	sRateScale	$01, $00, $01, $00
	sAttackRate	$1F, $3C, $1F, $2F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$01, $04, $02, $03
	sDecay2Rate	$02, $03, $02, $02
	sDecay1Level	$05, $05, $01, $01
	sReleaseRate	$0F, $0E, $0E, $0E
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$19, $0B, $14, $00
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$01, $01, $00, $00
	sMultiple	$02, $01, $02, $00
	sRateScale	$01, $01, $01, $01
	sAttackRate	$2D, $07, $07, $07
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$22, $04, $04, $04
	sFinishVoice

	sNewVoice	v05
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$05, $04, $01, $02
	sMultiple	$09, $0F, $01, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$15, $17, $1A, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$13, $04, $09, $08
	sDecay2Rate	$07, $03, $02, $12
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$09, $09, $09, $09
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2E, $7F, $7F, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

ShadowMaster_Samples:
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

ShadowMaster_Vib:
	sVibrato FM20,		$16, $00, $1C70, $002E, Triangle
	sVibrato FM21,		$24, $00, $2AA8, $0025, Triangle
	sVibrato FM30,		$16, $00, $2AA8, $0037, Triangle
	sVibrato FM31,		$24, $00, $5554, $0031, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

ShadowMaster_Env:
	sEnvelope v07,		ShadowMaster_Env_v07
	sEnvelope v09,		ShadowMaster_Env_v09
; ---------------------------------------------------------------------------

ShadowMaster_Env_v07:
	sEnv		delay=$06,	$00
	sEnv		delay=$05,	$08, $10
	sEnv		delay=$03,	$18, $20, $28
	sEnv		delay=$01,	$30
	seHold		$38
; ---------------------------------------------------------------------------

ShadowMaster_Env_v09:
	sEnv		$00, $08, $10, $18, $20, $28, $30, $38
	sEnv		$40, $48, $50, $58, $60, $68, $70
	seHold		$78

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

ShadowMaster_FM1:
	sVoice		v00
	sFrac		$0C00
	sVol		$11
	sPan		center
	sNote		nF1, $60
	sNote		nGs1, $12
	sNote		nAs1
	sNote		nFs1, $0C
	sNote		nRst, $30

ShadowMaster_FM1_00:
	sCall		$02, ShadowMaster_Loop09
	sCall		$01, ShadowMaster_Call0C
	sNote		nA1, $12
	sNote		nCs2
	sNote		nG2, $0C
	sCall		$01, ShadowMaster_Call0D
	sNote		nC2, $0C
	sNote		nC3
	sNote		nAs2, $06
	sNote		nA2
	sNote		nG2
	sNote		nE2
	sNote		nC2
	sNote		nC2
	sNote		nD2, $0C
	sNote		nE2
	sNote		nC2
	sNote		nB1, $12
	sNote		nAs1
	sNote		nB1
	sNote		nAs1
	sNote		nB1, $0C
	sNote		nCs2
	sCall		$01, ShadowMaster_Call0D
	sNote		nG2, $18
	sNote		nG3
	sNote		nF3, $06
	sNote		nF3
	sNote		nE3
	sNote		nD3
	sNote		nC3
	sNote		nAs2
	sNote		nA2
	sNote		nG2

	sCall		$03, ShadowMaster_Loop0A
	sNote		$12
	sNote		nG2
	sNote		nA2, $24
	sNote		nRst, $06
	sNote		nC2, $12

	sCall		$03, ShadowMaster_Loop0B
	sCall		$01, ShadowMaster_Call0E
	sNote		nGs1, $36
	sNote		nAs1, $30
	sNote		nB1
	sNote		nG2, $06
	sNote		nGs2
	sNote		nG2
	sNote		nF2
	sNote		nG2
	sNote		nF2
	sNote		nDs2
	sNote		nD2
	sJump		ShadowMaster_FM1_00

ShadowMaster_Loop0A:
	sNote		nA2, $12
	sNote		nG2
	sNote		nA2, $3C
	sRet

ShadowMaster_Loop09:
	sCall		$01, ShadowMaster_Call0C
	sNote		nD2, $12
	sNote		nE2
	sNote		nC2, $0C
	sRet

ShadowMaster_Call0C:
	sNote		nG1, $0C
	sNote		nG1
	sNote		nG1, $06
	sNote		nG1
	sNote		nG1
	sNote		nF1
	sNote		nG1

	sCall		$02, ShadowMaster_Loop16
	sNote		nAs1, $12
	sNote		nC2
	sNote		nF2, $0C
	sNote		nG2
	sNote		nG2
	sNote		nG2, $06
	sNote		nG2
	sNote		nG2, $0C
	sNote		nE2, $06
	sNote		nF2
	sNote		nF2
	sNote		nF2
	sNote		nE2
	sNote		nD2
	sNote		nC2, $0C
	sNote		nA1, $06
	sNote		nAs1, $0C
	sNote		nAs1
	sNote		nAs1
	sNote		nAs1, $06
	sRet

ShadowMaster_Loop16:
	sNote		nG1
	sNote		nG1, $0C
	sNote		$06
	sNote		nG1
	sNote		nG1, $0C
	sRet

ShadowMaster_Call0D:
	sNote		nD2, $18
	sNote		$06
	sNote		nE2
	sNote		nF2
	sNote		nG2
	sNote		nA2, $0C
	sNote		nF2
	sNote		nG2
	sNote		nD2
	sNote		nCs2, $18
	sNote		$06
	sNote		nD2
	sNote		nE2
	sNote		nF2
	sNote		nG2
	sNote		nG2
	sNote		nRst
	sNote		nA2
	sNote		nAs2
	sNote		nA2
	sNote		nG2
	sNote		nE2
	sRet

ShadowMaster_Call0E:
	sNote		nD2, $0C
	sNote		nD2
	sNote		nD2
	sNote		nD2, $06
	sNote		$0C
	sNote		$06
	sNote		nC2, $0C
	sNote		nAs1, $06
	sNote		nA1, $0C
	sRet

ShadowMaster_Loop0B:
	sCall		$01, ShadowMaster_Call0E
	sNote		nAs1, $12
	sNote		$0C
	sNote		$06
	sNote		nA1, $0C
	sNote		$06
	sNote		nRst
	sNote		nG1
	sNote		nRst
	sNote		nA1
	sNote		nRst
	sNote		nC2
	sNote		nRst
	sNote		nF2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

ShadowMaster_FM4:
	sFrac		-$0C00
	sPan		center
	sVol		$13
	sCall		$01, ShadowMaster_Call09

ShadowMaster_Jump03:
	sCall		$01, ShadowMaster_Call0A
	sNote		nAs5, $06
	sNote		nG5
	sNote		nGs5
	sNote		nF5
	sNote		nE5
	sNote		nCs6
	sNote		nC6
	sNote		nAs5

	sVoice		v04
	sNote		nA5, $60
	sNote		$60
	sNote		$60
	sNote		nF5, $12
	sNote		nF5
	sNote		nF5
	sNote		nF5
	sNote		nF5, $0C
	sNote		nG5
	sNote		nA5, $60
	sNote		$60
	sNote		nF5
	sCall		$01, ShadowMaster_Call0B
	sNote		nG5

	sVol		-$04
	sNote		nD6, $06
	sNote		nDs6
	sNote		nD6
	sNote		nC6
	sNote		nD6
	sNote		nC6
	sNote		nB5
	sNote		nF5
	sVol		$04
	sJump		ShadowMaster_Jump03

ShadowMaster_Call09:
	sVoice		v02
	sNote		nAs4, $06
	sNote		nGs4
	sNote		nAs4, $54
	sNote		nCs5, $24
	sNote		nB4, $0C
	sNote		nRst, $30
	sVol		$04
	sRet

ShadowMaster_Call0A:
	sVoice		v01
	sCall		$02, ShadowMaster_Loop15

	sNote		nG4, $60
	sNote		nGs4, $30
	sNote		nAs4, $12
	sNote		nC5
	sNote		nF5, $0C
	sNote		nG5, $60
	sNote		nF5, $12
	sNote		nE5
	sNote		nF5, $0C
	sRet

ShadowMaster_Loop15:
	sNote		nG4, $60
	sNote		nGs4, $30
	sNote		nAs4, $12
	sNote		nC5
	sNote		nF5, $0C
	sNote		nG5, $60
	sNote		nF5, $30
	sNote		nD5, $12
	sNote		nE5
	sNote		nC5, $0C
	sRet

ShadowMaster_Call0B:
	sCall		$03, ShadowMaster_FM4_00
	sFrac		-$0300
	sNote		nC6, $18
	sVol		-$04
	sNote		$0C
	sVol		-$06
	sNote		$24
	sNote		nRst, $06

	sVoice		v01
	sNote		nDs6, $01
	sNote		nD6
	sNote		nC6
	sNote		nB5
	sNote		nA5
	sNote		nG5
	sNote		nF5
	sNote		nE5
	sNote		nD5
	sNote		nC5
	sNote		nB4
	sNote		nA4
	sNote		nG4
	sNote		nF4
	sNote		nE4
	sNote		nD4
	sNote		nC4
	sNote		nB3
	sVol		$0A

	sCall		$03, ShadowMaster_Loop14
	sNote		nF5, $12
	sNote		$06
	sNote		nRst, $18
	sNote		nG5, $12
	sNote		nF5, $06
	sNote		nRst, $12
	sNote		nG5, $36
	sNote		$30
	sRet

ShadowMaster_FM4_00:
	sNote		nA5, $18
	sVol		-$03
	sNote		sHold, $18
	sVol		-$03
	sNote		sHold, $0C
	sVol		-$05
	sNote		sHold, $24
	sVol		$0B
	sFrac		$0100
	sRet

ShadowMaster_Loop14:
	sNote		nF5, $12
	sNote		$06
	sNote		nRst, $18
	sNote		nG5, $12
	sNote		nF5, $06
	sNote		nRst, $12
	sNote		nD5, $36
	sNote		nRst, $06
	sNote		nC5
	sNote		nRst
	sNote		nD5
	sNote		nRst
	sNote		nF5
	sNote		nRst
	sNote		nG5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

ShadowMaster_FM5:
	sFrac		-$1100
	sVol		$13
	sPan		left
	sCall		$01, ShadowMaster_Call09

ShadowMaster_Jump02:
	sCall		$01, ShadowMaster_Call0A
	sFrac		$0500
	sNote		nG5, $06
	sNote		nE5
	sNote		nF5
	sNote		nD5
	sNote		nCs5
	sNote		nAs5
	sNote		nA5
	sNote		nG5

	sVoice		v04
	sNote		nF5, $60
	sNote		$60
	sNote		$60
	sNote		nD5, $12
	sNote		nD5
	sNote		nD5
	sNote		nD5
	sNote		nD5, $0C
	sNote		nE5
	sNote		nF5, $60
	sNote		nF5
	sNote		nD5
	sFrac		-$0500

	sCall		$01, ShadowMaster_Call0B
	sFrac		$0500
	sVol		-$04
	sNote		nD5
	sNote		nB5, $06
	sNote		nC6
	sNote		nB5
	sNote		nGs5
	sNote		nB5
	sNote		nGs5
	sNote		nG5
	sNote		nD5

	sFrac		-$0500
	sVol		$04
	sJump		ShadowMaster_Jump02

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

ShadowMaster_FM2:
	sVol		$22
	sCall		$01, ShadowMaster_Call02
	sNote		nB3, $06

ShadowMaster_Jump01:
	sVibratoSet	FM20
	sCall		$01, ShadowMaster_Call03
	sCall		$01, ShadowMaster_Call04
	sNote		nG3, $2A
	sNote		nA3, $30

	sVoice		v01
	sCall		$01, ShadowMaster_Call08
	sNote		nA4
	sNote		nF4
	sNote		nD4
	sNote		nG4, $0C
	sNote		nE4, $06
	sNote		nC4
	sNote		nF4, $0C
	sNote		nD4, $06
	sNote		nF4
	sNote		nD4
	sNote		nF4
	sNote		nG4
	sNote		nA4
	sNote		nAs4

	sCall		$02, ShadowMaster_Loop08
	sNote		nD4
	sNote		nCs4
	sNote		nD4
	sNote		nE4
	sCall		$01, ShadowMaster_Call08
	sNote		nA4
	sNote		nG4
	sNote		nF4
	sNote		nE4
	sNote		nAs4
	sNote		nA4
	sNote		nG4
	sNote		nF4
	sNote		nC5
	sNote		nAs4
	sNote		nA4
	sNote		nG4
	sNote		nE5
	sNote		nCs5
	sNote		nAs4
	sNote		nG4

	sVoice		v02
	sNote		nA4, $12
	sNote		nG4
	sNote		nA4, $0C
	sCall		$01, ShadowMaster_Call05
	sNote		nE4, $06

	sVibratoSet	FM21
	sCall		$01, ShadowMaster_Call06
	sNote		nG5, $2A
	sCall		$01, ShadowMaster_Call07
	sNote		nGs5, $06
	sNote		nB5
	sNote		nG5
	sNote		nGs5
	sNote		nF5
	sNote		nG5
	sNote		nDs5
	sNote		nF5
	sNote		nD5
	sNote		nF5, $03
	sNote		nFs5
	sNote		nG5, $2A
	sJump		ShadowMaster_Jump01

ShadowMaster_Loop08:
	sNote		nF4, $06
	sNote		nD4
	sNote		nAs3
	sNote		nG4
	sNote		nE4
	sNote		nC4
	sRet

ShadowMaster_Call02:
	sVoice		v05
	sCall		$02, ShadowMaster_Loop13
	sVoice		v02
	sVol		$0E
	sNote		nG4, $02
	sNote		nGs4, $04
	sNote		nG4, $06
	sNote		nF4
	sNote		nD4
	sNote		nDs4
	sNote		nC4
	sNote		nF4
	sRet

ShadowMaster_Loop13:
	sPan		left
	sNote		nF4, $04
	sNote		nGs4
	sNote		nAs4
	sNote		nC5, $06
	sNote		nDs5
	sVol		-$05

	sPan		right
	sNote		nF4, $04
	sNote		nGs4
	sNote		nAs4
	sNote		nC5, $06
	sNote		nDs5
	sVol		-$05

	sPan		center
	sNote		nF4, $04
	sNote		nGs4
	sNote		nAs4
	sNote		nC5, $06
	sNote		nDs5
	sVol		-$05
	sRet

ShadowMaster_Call03:
	sVoice		v02
	sFrac		$0C00
	sCall		$07, ShadowMaster_Loop11

	sNote		nG2
	sNote		nAs2
	sNote		nC3
	sNote		nD3
	sNote		nF3
	sNote		nG3

	sFrac		$0C00
	sCall		$04, ShadowMaster_Loop11
	sFrac		-$1800
	sRet

ShadowMaster_Loop11:
	sNote		nG2, $04
	sNote		nAs2
	sNote		nC3
	sNote		nCs3
	sNote		nC3
	sNote		nAs2
	sRet

ShadowMaster_Call04:
	sNote		nG4, $12
	sNote		nF4, $06

	sNote		nF4, $05, nRst, $01
	sNote		nE4, $05, nRst, $01
	sNote		nE4, $05, nRst, $01
	sNote		nC4, $05, nRst, $01

	sNote		nD4, $06
	sNote		nC4
	sNote		nAs3
	sNote		nF3
	sNote		nG3
	sNote		nAs3
	sNote		nC4
	sNote		nD4
	sCall		$01, ShadowMaster_Call11

	sNote		nD5, $06
	sNote		nC5
	sNote		nD5, $3C
	sNote		nC5, $06
	sNote		nD5
	sNote		nF5
	sNote		nC5

	sNote		nD5, $05, nRst, $01
	sNote		nD5, $05, nRst, $01
	sNote		nCs5, $05, nRst, $01
	sNote		nCs5, $05, nRst, $01
	sNote		nC5, $05, nRst, $01
	sNote		nC5, $05, nRst, $01
	sNote		nAs4, $05, nRst, $01
	sNote		nAs4, $05, nRst, $01

	sNote		nF4, $06
	sNote		nE4, $0C
	sNote		nF4, $06
	sNote		nE4, $0C
	sNote		nAs4
	sCall		$01, ShadowMaster_Call11

	sNote		nF4, $06
	sNote		nE4, $2A
	sNote		nD4, $06
	sNote		nCs4
	sNote		nRst
	sNote		nC4
	sNote		nRst
	sNote		nAs3
	sNote		nRst
	sNote		nF3
	sNote		nRst
	sRet

ShadowMaster_Call08:
	sNote		nD4, $06
	sNote		nE4
	sNote		nF4
	sNote		nD4
	sNote		nE4
	sNote		nF4
	sNote		nG4
	sNote		nE4
	sNote		nF4
	sNote		nG4
	sNote		nA4
	sNote		nAs4
	sNote		nA4
	sNote		nG4
	sNote		nD4
	sNote		nE4
	sNote		nF4
	sNote		nG4
	sNote		nF4
	sNote		nE4
	sNote		nD4
	sNote		nCs4
	sNote		nD4
	sNote		nE4
	sNote		nF4
	sNote		nD4
	sNote		nG4
	sNote		nE4
	sNote		nA4
	sNote		nF4
	sNote		nAs4
	sNote		nG4
	sRet

ShadowMaster_Call05:
	sNote		nA4, $04
	sNote		nAs4
	sNote		nA4
	sNote		nG4, $06
	sNote		nF4
	sNote		nE4
	sNote		nD4
	sNote		nD4
	sRet

ShadowMaster_Call06:
	sNote		nA4, $12
	sNote		nG4
	sNote		nA4, $0C

	sCall		$02, ShadowMaster_Loop10
	sNote		nA4, $12
	sNote		nG4
	sNote		nA4, $0C

	sNote		nAs4, $05, nRst, $01
	sNote		nAs4, $05, nRst, $01
	sNote		nA4, $05, nRst, $01
	sNote		nA4, $05, nRst, $01
	sNote		nGs4, $05, nRst, $01
	sNote		nGs4, $05, nRst, $01
	sNote		nG4, $05, nRst, $01
	sNote		nG4, $05, nRst, $01

	sNote		nA4, $12
	sNote		nAs4
	sRet

ShadowMaster_Loop10:
	sNote		nE5, $06
	sNote		nF5
	sNote		nE5
	sNote		nG5
	sRet

ShadowMaster_Call07:
	sVoice		v03
	sCall		$03, ShadowMaster_Loop0F

	sNote		nE5
	sNote		nF5
	sNote		nC5
	sNote		nD5, $48
	sNote		nE5, $06
	sNote		nF5
	sNote		nRst
	sNote		nG5, $0C
	sNote		nGs5, $06
	sNote		nG5
	sNote		nF5
	sNote		nDs5
	sNote		nD5
	sNote		nF5
	sNote		nD5
	sNote		nDs5
	sNote		nD5
	sNote		nC5
	sNote		nF5
	sNote		nDs5
	sNote		nF5
	sNote		nG5
	sRet

ShadowMaster_Loop0F:
	sNote		nE5, $06
	sNote		nF5
	sNote		nC5
	sNote		nD5, $48
	sNote		nE5, $06
	sNote		nF5
	sNote		nG5
	sNote		nF5, $4E
	sNote		nRst, $06
	sRet

ShadowMaster_Call11:
	sNote		nG4, $30
	sNote		nF4, $10
	sNote		nAs4
	sNote		nF4
	sNote		nG4, $30
	sNote		nF4, $12
	sNote		nAs4
	sNote		nC5, $0C
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

ShadowMaster_FM3:
	sNote		nRst, $04
	sVol		$24
	sCall		$01, ShadowMaster_Call02
	sNote		nB3, $02
	sPan		right

ShadowMaster_Jump00:
	sVibratoSet	FM30
	sFrac		-$0500
	sCall		$01, ShadowMaster_Call03

	sFrac		$0500
	sNote		nRst, $04
	sCall		$01, ShadowMaster_Call04
	sNote		nG3, $26
	sNote		nE3, $30

	sNote		nRst, $168

	sVoice		v01
	sVol		-$02
	sNote		nF4, $06
	sNote		nE4
	sNote		nF4
	sNote		nG4
	sNote		nF4
	sNote		nG4
	sNote		nA4
	sNote		nF4
	sNote		nG4
	sNote		nA4
	sNote		nAs4
	sNote		nG4
	sNote		nA4
	sNote		nAs4
	sNote		nC5
	sNote		nCs5
	sNote		nD5
	sNote		nC5
	sNote		nG4
	sNote		nA4
	sNote		nA4
	sNote		nAs4
	sNote		nA4
	sNote		nG4
	sNote		nF4
	sNote		nE4
	sNote		nF4
	sNote		nG4
	sNote		nA4
	sNote		nF4
	sNote		nAs4
	sNote		nG4
	sNote		nCs5
	sNote		nA4
	sNote		nE5
	sNote		nCs5
	sNote		nC5
	sNote		nAs4
	sNote		nA4
	sNote		nG4
	sNote		nD5
	sNote		nC5
	sNote		nAs4
	sNote		nA4
	sNote		nE5
	sNote		nD5
	sNote		nC5
	sNote		nAs4
	sNote		nG5
	sNote		nE5
	sNote		nCs5
	sNote		nAs4

	sVoice		v02
	sNote		nE4, $12
	sNote		nD4
	sNote		nE4, $0C
	sVol		$02
	sNote		nRst, $04
	sCall		$01, ShadowMaster_Call05
	sNote		nE4, $02

	sVol		-$02
	sFrac		-$0500
	sVibratoSet	FM31
	sCall		$01, ShadowMaster_Call06
	sFrac		$0500

	sNote		nD5, $2A
	sNote		nRst, $04

	sVol		$02
	sFrac		$000D		; ssDetune $03
	sCall		$01, ShadowMaster_Call07
	sNote		nGs5, $02
	sFrac		-$000D		; ssDetune $00

	sVol		-$02
	sNote		nG5, $06
	sNote		nDs5
	sNote		nF5
	sNote		nD5
	sNote		nDs5
	sNote		nB4
	sNote		nD5
	sNote		nB4
	sNote		nD5, $03
	sNote		nD5
	sNote		nD5, $2A

	sVol		$02
	sJump		ShadowMaster_Jump00

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

ShadowMaster_PSG3:
	sVol		$7F
	sNote		nA6, $C0

ShadowMaster_PSG3_00:
	sCall		$06, ShadowMaster_Loop0C
	sNote		nHiHat, $120
	sNote		nA6, $60
	sNote		nHiHat, $120
	sNote		nA6, $180
	sCall		$03, ShadowMaster_Loop0E
	sNote		nA6, $0C
	sNote		nHiHat, $4E
	sNote		nA6, $1E
	sNote		nHiHat, $78
	sNote		nA6, $30
	sJump		ShadowMaster_PSG3_00

ShadowMaster_Loop0C:
	sNote		nA6, $0C
	sNote		nHiHat, $84
	sNote		nA6, $30
	sRet

ShadowMaster_Loop0E:
	sNote		nA6, $0C
	sNote		nHiHat, $B4
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG4 data
; ---------------------------------------------------------------------------

ShadowMaster_PSG4:
	sVol		$18
	sVolEnv		v09
	sNote		nWhitePSG3, $60
	sNote		$12
	sNote		$12
	sNote		$3C

ShadowMaster_PSG4_00:
	sCall		$06, ShadowMaster_L0C
	sCall		$01, ShadowMaster_Call10
	sNote		nWhitePSG3, $12
	sNote		$12
	sNote		$12
	sNote		$2A
	sCall		$01, ShadowMaster_Call10
	sCall		$04, ShadowMaster_L0D
	sCall		$03, ShadowMaster_L0E

	sVolEnv		v09
	sNote		nWhitePSG3, $0C

	sVolEnv		v07
	sNote		$18
	sNote		$18
	sNote		$1E

	sVolEnv		v09
	sNote		$1E

	sVolEnv		v07
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$18

	sVolEnv		v09
	sNote		$30
	sJump		ShadowMaster_PSG4_00

ShadowMaster_Call0F:
	sNote		nWhitePSG3, $0C
	sNote		$0C
	sVolEnv		v07
	sCall		$05, ShadowMaster_L18
	sRet

ShadowMaster_L18:
	sNote		nCut
	sNote		nWhitePSG3
	sRet

ShadowMaster_Call10:
	sVolEnv		v07
	sCall		$18, ShadowMaster_L17
	sVolEnv		v09
	sRet

ShadowMaster_L17:
	sNote		nWhitePSG3, $0C
	sRet

ShadowMaster_L0C:
	sCall		$01, ShadowMaster_Call0F
	sVolEnv		v09
	sNote		nWhitePSG3, $12
	sNote		$12
	sNote		$0C
	sRet

ShadowMaster_L0D:
	sNote		nWhitePSG3, $12
	sNote		$12
	sNote		$3C
	sRet

ShadowMaster_L0E:
	sCall		$01, ShadowMaster_Call0F
	sNote		nCut, $06
	sNote		nWhitePSG3, $03, nCut, $09
	sNote		nWhitePSG3, $03, nCut, $09
	sNote		nWhitePSG3, $03, nCut, $09
	sNote		nWhitePSG3, $03, nCut
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

ShadowMaster_DAC1:
	sPan		center
	sVol		$04
	sSample		Kick
	sNote		nSample, $04
	sNote		$04
	sNote		$04
	sNote		$06
	sNote		$4E
	sSample		Snare
	sNote		$12
	sNote		$12
	sNote		$24
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06

ShadowMaster_DAC1_00:
	sCall		$05, ShadowMaster_Loop00
	sCall		$01, ShadowMaster_Call00
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$0C

	sCall		$09, ShadowMaster_Loop01
	sCall		$03, ShadowMaster_Call00
	sCall		$04, ShadowMaster_Loop03

	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06

	sCall		$03, ShadowMaster_Call00
	sCall		$01, ShadowMaster_Call01
	sSample		Kick
	sNote		$06
	sNote		$0C
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sCall		$01, ShadowMaster_Call01
	sNote		$06
	sCall		$09, ShadowMaster_Loop05

	sSample		Kick
	sNote		$06
	sNote		$06
	sCall		$01, ShadowMaster_Call01
	sCall		$09, ShadowMaster_Loop01
	sCall		$01, ShadowMaster_Call01

	sNote		nRst, $0C
	sSample		Snare
	sNote		nSample, $06
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06

	sCall		$03, ShadowMaster_Loop07
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$0C
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$1E
	sNote		$06
	sSample		Kick
	sNote		$0C
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$0C
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$0C
	sJump		ShadowMaster_DAC1_00

ShadowMaster_Loop01:
	sNote		$06
	sRet

ShadowMaster_Loop05:
	sNote		$04
	sRet

ShadowMaster_Loop03:
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sRet

ShadowMaster_Loop00:
	sCall		$01, ShadowMaster_Call00
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$0C
	sNote		$12
	sNote		$12
	sNote		$06
	sNote		$06
	sRet

ShadowMaster_Call00:
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$0C
	sRet

ShadowMaster_Call01:
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$0C
	sRet

ShadowMaster_Loop07:
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$0C
	sNote		$0C
	sNote		$0C
	sNote		$06
	sRet

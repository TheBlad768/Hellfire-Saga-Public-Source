; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Boss3_Voice
	sHeaderSamples	Boss3_Samples
	sHeaderVibrato	Boss3_Vib
	sHeaderEnvelope	Boss3_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$CC
	sChannel	DAC1, Boss3_DAC1
	sChannel	FM1, Boss3_FM1
	sChannel	FM2, Boss3_FM3
	sChannel	FM3, Boss3_FM2
	sChannel	FM4, Boss3_FM4
	sChannel	FM5, Boss3_FM5
	sChannel	PSG1, Boss3_PSG2
	sChannel	PSG2, Boss3_PSG1
	sChannel	PSG3, Boss3_PSG3
	sChannel	PSG4, Boss3_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Boss3_Voice:
	sNewVoice	v00
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $03, $02, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$18, $15, $10, $14
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $03, $07, $02
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0A, $08, $2F, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $06
	sDecay2Rate	$07, $06, $06, $08
	sDecay1Level	$02, $01, $01, $0F
	sReleaseRate	$00, $00, $00, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$19, $13, $37, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $00, $00, $07
	sMultiple	$02, $02, $00, $03
	sRateScale	$02, $01, $02, $01
	sAttackRate	$1F, $0F, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0F, $0F, $0F
	sDecay2Rate	$04, $03, $04, $08
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $19, $1F, $00
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $00, $00, $07
	sMultiple	$02, $02, $00, $05
	sRateScale	$02, $01, $02, $01
	sAttackRate	$1F, $0F, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0F, $0F, $0F
	sDecay2Rate	$04, $03, $04, $0A
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$17, $19, $1F, $00
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$07, $03, $07, $03
	sMultiple	$04, $04, $04, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $01, $01
	sDecay1Level	$00, $00, $03, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$12, $17, $00, $00
	sFinishVoice

	sNewVoice	v05
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$05, $00, $00, $03
	sMultiple	$01, $02, $03, $03
	sRateScale	$01, $01, $02, $02
	sAttackRate	$1F, $1F, $14, $14
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $05, $05, $07
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$01, $01, $06, $0A
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $1E, $00, $00
	sFinishVoice

	sNewVoice	v06
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $00, $00, $07
	sMultiple	$02, $02, $00, $05
	sRateScale	$02, $01, $02, $01
	sAttackRate	$1F, $0F, $0F, $05
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0F, $0F, $0F
	sDecay2Rate	$04, $03, $04, $0A
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$17, $19, $1F, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Boss3_Samples:
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

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Boss3_Vib:
	sVibrato FM1,		$1B, $00, $2000, $0018, Triangle
	sVibrato FM3,		$1B, $00, $2AA8, $002A, Triangle
	sVibrato FM5,		$1B, $00, $4000, $0018, Triangle
	sVibrato PSG1,		$1F, $00, $8000, $000E, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Boss3_Env:
	sEnvelope v02,		Boss3_Env_v02
	sEnvelope v07,		Boss3_Env_v07
	sEnvelope v09,		Boss3_Env_v09
; ---------------------------------------------------------------------------

Boss3_Env_v02:
	sEnv		delay=$01,	$00, $10, $20, $30, $40, $7F
	seMute
; ---------------------------------------------------------------------------

Boss3_Env_v07:
	sEnv		delay=$06,	$00
	sEnv		delay=$05,	$08, $10
	sEnv		delay=$03,	$18, $20, $28
	sEnv		delay=$01,	$30
	seHold		$38
; ---------------------------------------------------------------------------

Boss3_Env_v09:
	sEnv		$00, $08, $10, $18, $20, $28, $30, $38
	sEnv		$40, $48, $50, $58, $60, $68, $70
	seHold		$78

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Boss3_FM1:
	sVoice		v06
	sPan		right
	sFrac		-$0C00
	sNote		nC2, $78

	sPan		right
	sVol		$18
	sVoice		v05
	sNote		nDs5, $06
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD3
	sNote		nF3
	sNote		nAs3
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF4
	sNote		nAs4

	sFrac		$0C00
	sPan		center
	sVol		-$04

Boss3_Jump03:
	sVibratoSet	FM1
	sVoice		v00
	sNote		nDs3, $01
	sNote		nF3
	sNote		nFs3
	sNote		nG3
	sNote		nGs3
	sNote		nA3
	sNote		nAs3
	sNote		nB3
	sNote		nC4
	sNote		nCs4
	sNote		nD4
	sNote		nC4, $31
	sNote		nAs3, $12
	sNote		nDs4, $2A
	sNote		nD4, $12
	sNote		nDs4
	sNote		nF4, $18
	sNote		nC4, $3C
	sNote		nGs5, $03
	sNote		nA5
	sNote		nF5, $06
	sNote		nRst
	sNote		nF5, $03
	sNote		nFs5
	sNote		nG5, $06
	sNote		nF5
	sNote		nF5
	sNote		nFs5
	sNote		nG5
	sNote		nF5
	sNote		nC5
	sNote		nG4, $0C
	sNote		nC5, $06
	sNote		nF4, $0C
	sNote		nC5, $06
	sNote		nDs4
	sNote		nC5
	sNote		nF4
	sNote		nG4, $3C
	sNote		nF4
	sNote		nG3, $01
	sNote		nGs3
	sNote		nA3
	sNote		nAs3
	sNote		nB3
	sNote		nC4
	sNote		nCs4
	sNote		nD4
	sNote		nDs4
	sNote		nE4
	sNote		nF4
	sNote		nDs4, $31
	sNote		nD4, $12
	sNote		nAs4, $2A
	sNote		nD5, $12
	sNote		nDs5
	sNote		nF5, $18
	sNote		nC5, $3C
	sNote		nGs5, $03
	sNote		nA5
	sNote		nF5, $06
	sNote		nRst
	sNote		nF5, $03
	sNote		nFs5
	sNote		nG5, $06
	sNote		nF5
	sNote		nF5
	sNote		nFs5
	sNote		nG5
	sNote		nF5
	sNote		nC5
	sNote		nG4, $0C
	sNote		nC5, $06
	sNote		nF4, $0C
	sNote		nC5, $06
	sNote		nDs4
	sNote		nC5
	sNote		nF4
	sNote		nFs4, $03
	sNote		nG4, $39
	sNote		nF4, $06
	sNote		nRst, $0C
	sNote		nAs4, $2A

	sVol		-$03
	sVoice		v02
	sNote		nG4, $03
	sNote		nC5
	sNote		nDs5, $06
	sNote		nG5
	sNote		nF5, $2A
	sNote		nAs5
	sNote		nA5, $0C
	sNote		nAs5, $06
	sNote		nA5
	sNote		nF5
	sNote		nC5, $30
	sNote		nCs5, $3C
	sNote		nC5, $12
	sNote		nG5, $2A
	sNote		nAs4, $12
	sNote		nG5, $2A
	sNote		nDs5, $06
	sNote		nD5
	sNote		nC5
	sNote		nD5
	sNote		nG5
	sNote		nAs4
	sNote		nDs5
	sNote		nD5
	sNote		nC5
	sNote		nD5
	sNote		nCs5
	sNote		nC5
	sNote		nAs4
	sNote		nCs5
	sNote		nF5
	sNote		nAs4
	sNote		nF5
	sNote		nGs4
	sNote		nCs5
	sNote		nF5
	sNote		nG4, $03
	sNote		nC5
	sNote		nDs5, $06
	sNote		nG5
	sNote		nF5, $2A
	sNote		nAs5
	sNote		nA5, $0C
	sNote		nAs5, $06
	sNote		nA5
	sNote		nF5
	sNote		nC5, $30
	sNote		nCs5, $3C
	sNote		nC5, $12
	sNote		nG5, $2A
	sNote		nAs4, $12
	sNote		nG5, $2A
	sNote		nDs5, $06
	sNote		nD5
	sNote		nC5
	sNote		nD5
	sNote		nG5
	sNote		nC5
	sNote		nG5
	sNote		nAs4
	sNote		nG5
	sNote		nAs4
	sNote		nCs5
	sNote		nC5
	sNote		nAs4
	sNote		nCs5
	sNote		nF5
	sNote		nAs4
	sNote		nF5
	sNote		nGs4
	sNote		nCs5
	sNote		nF5

	sVibratoOff
	sVol		$03
	sVoice		v05
	sCall		$02, Boss3_Loop0E
	sJump		Boss3_Jump03

Boss3_Loop0E:
	sNote		nC5, $06
	sNote		nDs5
	sNote		nG5
	sNote		nDs4
	sNote		nG4
	sNote		nC4
	sNote		nDs3
	sNote		nG3
	sNote		nDs3
	sNote		nG3
	sNote		nD5
	sNote		nF5
	sNote		nAs5
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF3
	sNote		nAs3
	sNote		nF3
	sNote		nD3
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF5
	sNote		nAs5
	sNote		nD5
	sNote		nF5
	sNote		nAs5
	sNote		nF5
	sNote		nAs5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Boss3_FM2:
	sVoice		v01
	sFrac		$0C00
	sVol		$0F
	sCall		$02, Boss3_Loop0A
	sCall		$02, Boss3_Loop0C

Boss3_Loop0C:
	sCall		$01, Boss3_FM2_02

Boss3_FM2_00:
	sCall		$01, Boss3_FM2_01
	sCall		$01, Boss3_FM2_02
	sCall		$01, Boss3_FM2_01
	sCall		$04, Boss3_Loop0A
	sNote		nGs1, $12
	sNote		nDs1
	sNote		nGs1, $0C
	sNote		nC2
	sNote		nAs1, $12
	sNote		nF1, $2A

	sCall		$02, Boss3_Loop0D
	sNote		nC1
	sNote		nRst, $0C
	sNote		nC1, $12
	sNote		$06
	sNote		nRst
	sNote		nC1
	sNote		nRst
	sNote		nD1
	sNote		nRst, $0C
	sNote		nD1, $12
	sNote		$06
	sNote		nRst
	sNote		nD1
	sNote		nRst
	sNote		nGs1, $12
	sNote		nDs1
	sNote		nGs1, $0C
	sNote		nC2
	sNote		nAs1, $12
	sNote		nF1
	sNote		nAs1, $0C
	sNote		nD2
	sNote		nC1, $06
	sNote		nRst, $0C
	sNote		nC1, $12
	sNote		$06
	sNote		nRst
	sNote		nC1
	sNote		nRst
	sNote		nD1
	sNote		nRst, $0C
	sNote		nD1, $12
	sNote		$06
	sNote		nRst
	sNote		nD1
	sNote		nRst
	sNote		nGs1, $12
	sNote		nDs1
	sNote		nGs1, $0C
	sNote		nC2
	sNote		nAs1, $12
	sNote		nF1
	sNote		nAs1, $0C
	sNote		nD2
	sJump		Boss3_FM2_00

Boss3_FM2_01:
	sCall		$04, Boss3_Loop0A
	sNote		nA1, $12
	sNote		nF1
	sNote		nC1, $0C
	sNote		nF1
	sNote		nA0, $12
	sNote		nF1
	sNote		nA1, $0C
	sNote		nC2
	sRet

Boss3_FM2_02:
	sNote		nGs1, $12
	sNote		nDs1
	sNote		nGs1, $0C
	sNote		nC2
	sNote		nAs1, $12
	sNote		nF1
	sNote		nAs1, $0C
	sNote		nD2
	sRet

Boss3_Loop0A:
	sNote		nC1, $12
	sNote		nDs1
	sNote		nC1, $0C
	sNote		nF1
	sRet

Boss3_Loop0D:
	sNote		nC1, $06
	sNote		nRst, $0C
	sNote		nC1, $12
	sNote		$06
	sNote		nRst
	sNote		nC1
	sNote		nRst
	sNote		nDs1
	sNote		nRst, $0C
	sNote		nDs1, $12
	sNote		$06
	sNote		nRst
	sNote		nDs1
	sNote		nRst
	sNote		nD1
	sNote		nRst, $0C
	sNote		nD1, $12
	sNote		$06
	sNote		nRst
	sNote		nD1
	sNote		nRst
	sNote		nCs1
	sNote		nRst, $0C
	sNote		nCs1, $12
	sNote		$06
	sNote		nRst
	sNote		nCs1
	sNote		nRst
	sNote		nC1, $03
	sNote		nC1
	sNote		nC1, $0C
	sNote		nC1
	sNote		nC1, $06
	sNote		nC1
	sNote		nRst
	sNote		nC1
	sNote		nRst
	sNote		nDs1, $03
	sNote		nDs1
	sNote		nDs1, $0C
	sNote		nDs1
	sNote		nDs1, $06
	sNote		nDs1
	sNote		nRst
	sNote		nDs1
	sNote		nRst
	sNote		nD1, $03
	sNote		nD1
	sNote		nD1, $0C
	sNote		nD2
	sNote		nD1, $06
	sNote		nD2
	sNote		nRst
	sNote		nD1
	sNote		nRst
	sNote		nCs1, $03
	sNote		nCs1
	sNote		nCs1, $0C
	sNote		nCs2
	sNote		nCs1, $06
	sNote		nCs2
	sNote		nRst
	sNote		nCs1
	sNote		nRst
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Boss3_FM3:
	sVoice		v06
	sPan		left
	sNote		nC1, $78

	sVol		$18
	sPan		right
	sVoice		v03
	sNote		$12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nD3, $12
	sNote		nD3
	sNote		nD3, $0C
	sNote		nD3

Boss3_Jump02:
	sVol		-$04
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nDs3, $12
	sNote		nDs3
	sNote		nDs3, $0C
	sNote		nDs3
	sNote		nAs2, $12
	sNote		nAs2
	sNote		nAs2, $0C
	sNote		nAs2
	sNote		nG2, $12
	sNote		nG2
	sNote		nG2, $0C
	sNote		nG2
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nA2, $12
	sNote		nA2
	sNote		nA2, $0C
	sNote		nA2
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nD3, $12
	sNote		nD3
	sNote		nD3, $0C
	sNote		nD3
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nDs3, $12
	sNote		nDs3
	sNote		nDs3, $0C
	sNote		nDs3
	sNote		nAs2, $12
	sNote		nAs2
	sNote		nAs2, $0C
	sNote		nAs2
	sNote		nG2, $12
	sNote		nG2
	sNote		nG2, $0C
	sNote		nG2
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nA2, $12
	sNote		nA2
	sNote		nA2, $0C
	sNote		nA2
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nD3, $12
	sNote		$2A

	sVol		$01
	sFrac		-$1800
	sVoice		v04
	sVibratoSet	FM3
	sPan		center
	sCall		$02, Boss3_Loop09
	sNote		nC4, $3C
	sNote		nD4, $3C
	sNote		nDs4, $3C
	sNote		nD4, $3C
	sNote		nC5, $3C
	sNote		nD5, $3C
	sNote		nDs5, $3C
	sNote		nF5, $3C

	sFrac		$1800
	sVol		$03
	sVoice		v03
	sPan		right
	sJump		Boss3_Jump02

Boss3_Loop09:
	sNote		nE2, $01
	sNote		nF2
	sNote		nFs2
	sNote		nG2
	sNote		nGs2
	sNote		nA2
	sNote		nAs2
	sNote		nB2
	sNote		nC3
	sNote		nCs3
	sNote		nD3
	sNote		nDs3, $31
	sNote		nG3, $2A
	sNote		nAs3, $12
	sNote		nA3, $0C
	sNote		nC4, $30
	sNote		nCs4, $3C
	sNote		nC3, $06
	sNote		nRst, $0C
	sNote		nG3, $2A
	sNote		nDs3, $06
	sNote		nRst, $0C
	sNote		nAs3, $2A
	sNote		nA3, $3C
	sNote		nGs3, $3C
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Boss3_FM4:
	sNote		nRst, $78
	sVoice		v03
	sVol		$18

	sNote		nDs3, $12
	sNote		nDs3
	sNote		nDs3, $0C
	sNote		nDs3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sVol		-$04

Boss3_Jump01:
	sNote		nG3, $12
	sNote		nG3
	sNote		nG3, $0C
	sNote		nG3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sNote		nD3, $12
	sNote		nD3
	sNote		nD3, $0C
	sNote		nD3
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nDs3, $12
	sNote		nDs3
	sNote		nDs3, $0C
	sNote		nDs3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sNote		nG3, $12
	sNote		nG3
	sNote		nG3, $0C
	sNote		nG3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sNote		nD3, $12
	sNote		nD3
	sNote		nD3, $0C
	sNote		nD3
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nDs3, $12
	sNote		nDs3
	sNote		nDs3, $0C
	sNote		nDs3
	sNote		nF3, $12
	sNote		$2A

	sVol		-$03
	sVoice		v02
	sNote		nD4, $03
	sNote		nG4
	sNote		nAs4, $06
	sNote		nD5
	sNote		nC5, $2A
	sNote		nF5
	sNote		nE5, $0C
	sNote		nF5, $06
	sNote		nE5
	sNote		nC5
	sNote		nG4, $30
	sNote		nGs4, $3C
	sNote		nG4, $12
	sNote		nD5, $2A
	sNote		nF4, $12
	sNote		nD5, $2A
	sNote		nAs4, $06
	sNote		nA4
	sNote		nG4
	sNote		nA4
	sNote		nD5
	sNote		nF4
	sNote		nAs4
	sNote		nA4
	sNote		nG4
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nF4
	sNote		nGs4
	sNote		nC5
	sNote		nF4
	sNote		nC5
	sNote		nDs4
	sNote		nGs4
	sNote		nC5
	sNote		nD4, $03
	sNote		nG4
	sNote		nAs4, $06
	sNote		nD5
	sNote		nC5, $2A
	sNote		nF5
	sNote		nE5, $0C
	sNote		nF5, $06
	sNote		nE5
	sNote		nC5
	sNote		nG4, $30
	sNote		nGs4, $3C
	sNote		nG4, $12
	sNote		nD5, $2A
	sNote		nF4, $12
	sNote		nD5, $2A
	sNote		nAs4, $06
	sNote		nA4
	sNote		nG4
	sNote		nA4
	sNote		nD5
	sNote		nG4
	sNote		nD5
	sNote		nF4
	sNote		nD5
	sNote		nF4
	sNote		nGs4
	sNote		nG4
	sNote		nF4
	sNote		nGs4
	sNote		nC5
	sNote		nF4
	sNote		nC5
	sNote		nDs4
	sNote		nGs4
	sNote		nC5

	sVol		$03
	sVoice		v03
	sCall		$02, Boss3_Loop08
	sJump		Boss3_Jump01

Boss3_Loop08:
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nAs2, $12
	sNote		nAs2
	sNote		nAs2, $0C
	sNote		nAs2
	sNote		nDs3, $12
	sNote		nDs3
	sNote		nDs3, $0C
	sNote		nDs3
	sNote		nF3, $12
	sNote		nF3
	sNote		nF3, $0C
	sNote		nF3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Boss3_FM5:
	sNote		nRst, $78
	sPan		left
	sFrac		-$0C00
	sVoice		v05
	sVol		$18

	sNote		$03
	sNote		nDs5, $06
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD3
	sNote		nF3
	sNote		nAs3
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF4
	sNote		nAs4, $03

	sFrac		$0C00
	sVibratoSet	FM5

Boss3_Jump00:
	sPan		left
	sVoice		v00

	sFrac		$0005		; ssDetune $01
	sNote		nRst, $0C
	sNote		nDs3, $06
	sNote		$01
	sNote		nF3
	sNote		nFs3
	sNote		nG3
	sNote		nGs3
	sNote		nA3
	sNote		nAs3
	sNote		nB3
	sNote		nC4
	sNote		nCs4
	sNote		nD4
	sNote		nC4, $31
	sNote		nAs3, $12
	sNote		nDs4, $2A
	sNote		nD4, $12
	sNote		nDs4
	sNote		nF4, $18
	sNote		nC4, $36
	sNote		nGs5, $03
	sNote		nA5
	sNote		nF5, $06
	sNote		nRst
	sNote		nF5, $03
	sNote		nFs5
	sNote		nG5, $06
	sNote		nF5
	sNote		nF5
	sNote		nFs5
	sNote		nG5
	sNote		nF5
	sNote		nC5
	sNote		nG4, $0C
	sNote		nC5, $06
	sNote		nF4, $0C
	sNote		nC5, $06
	sNote		nDs4
	sNote		nC5
	sNote		nF4
	sNote		nG4, $3C
	sNote		nF4, $42
	sNote		nG3, $01
	sNote		nGs3
	sNote		nA3
	sNote		nAs3
	sNote		nB3
	sNote		nC4
	sNote		nCs4
	sNote		nD4
	sNote		nDs4
	sNote		nE4
	sNote		nF4
	sNote		nDs4, $31
	sNote		nD4, $12
	sNote		nAs4, $2A
	sNote		nD5, $12
	sNote		nDs5
	sNote		nF5, $18
	sNote		nC5, $36
	sNote		nGs5, $03
	sNote		nA5
	sNote		nF5, $06
	sNote		nRst
	sNote		nF5, $03
	sNote		nFs5
	sNote		nG5, $06
	sNote		nF5
	sNote		nF5
	sNote		nFs5
	sNote		nG5
	sNote		nF5
	sNote		nC5
	sNote		nG4, $0C
	sNote		nC5, $06
	sNote		nF4, $0C
	sNote		nC5, $06
	sNote		nDs4
	sFrac		-$0005		; ssDetune $00

	sNote		nD4, $03
	sNote		nDs4, $39
	sNote		nD4, $06
	sNote		nRst, $0C
	sNote		nF4, $2A

	sVoice		v05
	sVol		$05
	sPan		center
	sCall		$02, Boss3_Loop06

	sVol		-$09
	sPan		right
	sVoice		v03
	sCall		$02, Boss3_Loop07
	sVol		$04
	sJump		Boss3_Jump00

Boss3_Loop06:
	sNote		nF3, $06
	sNote		nC4
	sNote		nF4
	sNote		nC5
	sNote		nF4
	sNote		nC4
	sNote		nF3
	sNote		nC4
	sNote		nF4
	sNote		nC4
	sNote		nAs3
	sNote		nF4
	sNote		nAs4
	sNote		nF5
	sNote		nAs4
	sNote		nF4
	sNote		nAs3
	sNote		nF4
	sNote		nAs4
	sNote		nF4
	sNote		nA3
	sNote		nD4
	sNote		nF4
	sNote		nA5
	sNote		nF4
	sNote		nD4
	sNote		nA3
	sNote		nD4
	sNote		nA4
	sNote		nD4
	sNote		nGs3
	sNote		nCs4
	sNote		nE4
	sNote		nGs5
	sNote		nE4
	sNote		nCs4
	sNote		nGs3
	sNote		nCs4
	sNote		nGs4
	sNote		nCs4
	sNote		nC5
	sNote		nG5
	sNote		nDs5
	sNote		nG5
	sNote		nG4
	sNote		nG5
	sNote		nDs4
	sNote		nG5
	sNote		nG4
	sNote		nG5
	sNote		nAs4
	sNote		nG5
	sNote		nDs5
	sNote		nG5
	sNote		nG4
	sNote		nG5
	sNote		nDs4
	sNote		nG5
	sNote		nG4
	sNote		nG5
	sNote		nA4
	sNote		nF5
	sNote		nDs5
	sNote		nF5
	sNote		nA4
	sNote		nF5
	sNote		nDs4
	sNote		nF5
	sNote		nA4
	sNote		nF5
	sNote		nGs3
	sNote		nCs4
	sNote		nF4
	sNote		nGs4
	sNote		nF4
	sNote		nCs4
	sNote		nGs3
	sNote		nCs4
	sNote		nF4
	sNote		nGs4
	sRet

Boss3_Loop07:
	sNote		nG2, $12
	sNote		nG2
	sNote		nG2, $0C
	sNote		nG2
	sNote		nF2, $12
	sNote		nF2
	sNote		nF2, $0C
	sNote		nF2
	sNote		nC3, $12
	sNote		nC3
	sNote		nC3, $0C
	sNote		nC3
	sNote		nD3, $12
	sNote		nD3
	sNote		nD3, $0C
	sNote		nD3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Boss3_PSG1:
	sNote		nCut, $78

	sVol		$38
	sFrac		-$1800
	sNote		nDs5, $06
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD3
	sNote		nF3
	sNote		nAs3
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF4
	sNote		nAs4

Boss3_Loop19:
	sNote		nCut, $3C0

	sVibratoSet	PSG1
	sVol		-$08
	sCall		$02, Boss3_Loop1A
	sVibratoOff
	sVol		-$10
	sCall		$02, Boss3_Loop1B
	sVol		$18
	sJump		Boss3_Loop19

Boss3_Loop1A:
	sNote		nG3, $3C
	sNote		nF3
	sNote		nD3
	sNote		nGs3
	sNote		nG3
	sNote		nF3
	sNote		nAs3
	sNote		nF3
	sRet

Boss3_Loop1B:
	sNote		nC5, $06
	sNote		nDs5
	sNote		nG5
	sNote		nDs4
	sNote		nG4
	sNote		nC4
	sNote		nDs3
	sNote		nG3
	sNote		nDs3
	sNote		nG3
	sNote		nD5
	sNote		nF5
	sNote		nAs5
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF3
	sNote		nAs3
	sNote		nF3
	sNote		nD3
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF5
	sNote		nAs5
	sNote		nD5
	sNote		nF5
	sNote		nAs5
	sNote		nF5
	sNote		nAs5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Boss3_PSG2:
	sNote		nCut, $7B
	sVol		$38
	sFrac		-$17C0		; ssDetune $01
	sNote		nDs5, $06
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD3
	sNote		nF3
	sNote		nAs3
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF4
	sNote		nAs4, $03
	sFrac		-$0040		; ssDetune $00

Boss3_Loop16:
	sNote		nCut, $3C0

	sVibratoSet	PSG1
	sVol		-$08
	sCall		$02, Boss3_Loop17
	sVibratoOff
	sVol		-$08
	sCall		$02, Boss3_Loop18
	sVol		$10
	sJump		Boss3_Loop16

Boss3_Loop17:
	sNote		nC4, $3C
	sNote		nAs3
	sNote		nA3
	sNote		nCs4
	sNote		nC4
	sNote		nDs4
	sNote		nD4
	sNote		nCs4
	sRet

Boss3_Loop18:
	sNote		nCut, $06
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs4
	sNote		nG4
	sNote		nC4
	sNote		nDs3
	sNote		nG3
	sNote		nDs3
	sNote		nG3
	sNote		nD5
	sNote		nF5
	sNote		nAs5
	sNote		nF4
	sNote		nAs4
	sNote		nD4
	sNote		nF3
	sNote		nAs3
	sNote		nF3
	sNote		nD3
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nC5
	sNote		nDs5
	sNote		nG5
	sNote		nDs5
	sNote		nC5
	sNote		nG4
	sNote		nDs5
	sNote		nD4
	sNote		nF4
	sNote		nAs4
	sNote		nF5
	sNote		nAs5
	sNote		nD5
	sNote		nF5
	sNote		nAs5
	sNote		nF5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

Boss3_PSG3:
	sNote		nCut, $78
	sVol		$7F

Boss3_Jump04:
	sCall		$02, Boss3_Loop0F
	sCall		$0F, Boss3_Loop10
	sNote		$12
	sNote		nG6, $2A
	sCall		$02, Boss3_Loop14
	sCall		$03, Boss3_Loop15
	sJump		Boss3_Jump04

Boss3_Loop0F:
	sNote		nG6, $12
	sNote		$12
	sNote		$0C
	sNote		$0C
	sRet

Boss3_Loop15:
	sNote		nCut, $12
	sNote		nG6, $2A

Boss3_Loop10:
	sNote		nHiHat, $12
	sNote		$12
	sNote		$0C
	sNote		$0C
	sRet

Boss3_Loop12:
	sNote		nCut, $12
	sNote		nG6, $2A
	sRet

Boss3_Loop13:
	sNote		nHiHat, $12
	sNote		$12
	sNote		$0C
	sNote		$06
	sNote		$06
	sRet

Boss3_Loop14:
	sNote		nCut, $12
	sNote		nG6, $2A
	sCall		$03, Boss3_Loop10
	sCall		$02, Boss3_Loop12
	sCall		$02, Boss3_Loop13
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG4 data
; ---------------------------------------------------------------------------

Boss3_PSG4:
	sNote		nCut, $78
	sVol		$20

Boss3_J04:
	sVolEnv		v09
	sCall		$02, Boss3_L0F
	sVolEnv		v07
	sCall		$0F, Boss3_L0F
	sNote		$12
	sVolEnv		v09
	sNote		$2A

	sCall		$02, Boss3_L14
	sCall		$03, Boss3_L15
	sJump		Boss3_J04

Boss3_L15:
	sNote		nCut, $12
	sVolEnv		v09
	sNote		nWhitePSG3, $2A
	sVolEnv		v02

Boss3_L0F:
	sNote		nWhitePSG3, $12
	sNote		$12
	sNote		$0C
	sNote		$0C
	sRet

Boss3_L12:
	sNote		nCut, $12
	sNote		nWhitePSG3, $2A
	sRet

Boss3_L13:
	sNote		$12
	sNote		$12
	sNote		$0C
	sNote		$06
	sNote		$06
	sRet

Boss3_L14:
	sNote		nCut, $12
	sVolEnv		v09
	sNote		nWhitePSG3, $2A

	sVolEnv		v02
	sCall		$03, Boss3_L0F
	sVolEnv		v09
	sCall		$02, Boss3_L12

	sVolEnv		v02
	sCall		$02, Boss3_L13
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Boss3_DAC1:
	sPan		center
	sVol		$04
	sSample		Snare
	sCall		$02, Boss3_Loop00

	sSample		Kick
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$09
	sNote		$12
	sNote		$0C
	sNote		$0C
	sNote		$06
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$0C

Boss3_DAC1_01:
	sSample		Snare
	sCall		$04, Boss3_Loop01

	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$0C

	sSample		Snare
	sCall		$04, Boss3_Loop01
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sNote		$06
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sNote		$12
	sNote		$12
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$0C

	sCall		$02, Boss3_DAC1_00
	sSample		Snare
	sCall		$06, Boss3_Loop01
	sSample		Kick
	sNote		$12
	sNote		$12
	sNote		$0C
	sNote		$0C
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$06
	sJump		Boss3_DAC1_01

Boss3_Loop00:
	sNote		nSample, $12
	sNote		$12
	sNote		$0C
	sNote		$0C
	sRet

Boss3_Loop01:
	sNote		$12
	sSample		Kick
	sNote		$12
	sSample		Snare
	sNote		$0C
	sNote		$0C
	sRet

Boss3_Loop03:
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sRet

Boss3_Loop04:
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$03
	sNote		$03
	sNote		$06
	sSample		Snare
	sNote		$06
	sRet

Boss3_DAC1_00:
	sCall		$03, Boss3_Loop03
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$0C
	sCall		$02, Boss3_Loop04
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sNote		$06
	sNote		$06
	sRet

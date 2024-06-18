; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Festival_Voice
	sHeaderSamples	Festival_Samples
	sHeaderVibrato	Festival_Vib
	sHeaderEnvelope	Festival_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$80
	sChannel	DAC1, Festival_DAC1
	sChannel	FM1, Festival_FM1
	sChannel	FM2, Festival_FM3
	sChannel	FM3, Festival_FM2
	sChannel	FM4, Festival_FM5
	sChannel	FM5, Festival_FM4
	sChannel	PSG1, Festival_PSG1
	sChannel	PSG2, Festival_PSG2
	sChannel	PSG3, Festival_PSG3
	sChannel	PSG4, Festival_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices
; ---------------------------------------------------------------------------

Festival_Voice:
	sNewVoice	v00
	sAlgorithm	$00
	sFeedback	$05
	sDetune		$03, $07, $05, $03
	sMultiple	$03, $00, $03, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1F, $1C, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$14, $01, $05, $01
	sDecay2Rate	$00, $00, $01, $1D
	sDecay1Level	$01, $01, $02, $0F
	sReleaseRate	$01, $00, $01, $09
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $12, $1B, $0C
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$05, $05, $05, $05
	sMultiple	$03, $01, $01, $01
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0E, $04
	sDecay2Rate	$04, $03, $03, $08
	sDecay1Level	$0F, $07, $03, $06
	sReleaseRate	$07, $04, $03, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1B, $10, $11, $0C
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$03, $05, $00, $00
	sMultiple	$03, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $1A, $13, $1B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $1F, $1F, $1F
	sDecay2Rate	$01, $01, $01, $01
	sDecay1Level	$03, $00, $00, $00
	sReleaseRate	$03, $03, $03, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $19, $1A, $0C
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $00, $00, $00
	sMultiple	$0F, $00, $03, $01
	sRateScale	$02, $02, $02, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $0B, $0C, $09
	sDecay2Rate	$08, $08, $08, $08
	sDecay1Level	$02, $02, $02, $01
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$13, $18, $36, $06
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Festival_Samples:
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

Festival_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Festival_Env:
	sEnvelope v01,		Festival_Env_v01
	sEnvelope v03,		Festival_Env_v03
; ---------------------------------------------------------------------------

Festival_Env_v01:
	sEnv		delay=$03,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Festival_Env_v03:
	sEnv		delay=$02,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Festival_DAC1:
	sNote		nRst, $01
	sPan		center
	sVol		$04

	sSample		Kick
	sNote		nSample, $2F
	sSample		Crash3
	sNote		$0C
	sNote		$0C
	sNote		$18
	sSample		Snare
	sNote		$18
	sNote		$18
	sNote		$0C
	sNote		$0C
	sNote		$0C
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$03
	sSample		Kick

Festival_Jump00:
	sCall		$60, Festival_DAC_00
	sSample		Crash3
	sNote		$3C
	sNote		$0C
	sNote		$30
	sSample		Kick
	sCall		$0A, Festival_DAC_00
	sJump		Festival_Jump00

Festival_DAC_00:
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$03
	sSample		Kick
	sNote		$03
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Festival_FM1:
	sNote		nRst, $60
	sVoice		v03
	sFrac		$0C00
	sVol		$08
	sPan		center
	sNote		nG1, $30
	sNote		nGs1
	sCall		$80, Festival_Loop13

Festival_FM1_Jump:
	sCall		$03, Festival_Loop16
	sCall		$18, Festival_Loop13
	sCall		$03, Festival_FM1_00
	sCall		$08, Festival_Loop13
	sCall		$08, Festival_Loop1F
	sCall		$03, Festival_FM1_01
	sCall		$08, Festival_Loop1E
	sCall		$10, Festival_Loop1F
	sCall		$10, Festival_Loop13
	sCall		$04, Festival_Loop22
	sCall		$70, Festival_Loop23
	sJump		Festival_FM1_Jump

Festival_Loop16:
	sCall		$08, Festival_Loop13
	sCall		$08, Festival_Loop18
	sRet

Festival_FM1_00:
	sCall		$08, Festival_Loop18
	sCall		$08, Festival_Loop13
	sRet

Festival_FM1_01:
	sCall		$08, Festival_Loop1E
	sCall		$18, Festival_Loop1F
	sRet

Festival_Loop22:
	sNote		nRst, $0C
	sCall		$10, Festival_Loop13
	sRet

Festival_Loop13:
	sNote		nG1

Festival_Loop23:
	sNote		$03
	sRet

Festival_Loop1F:
	sNote		nD2
	sRet

Festival_Loop1E:
	sNote		nDs2
	sRet

Festival_Loop18:
	sNote		nGs1
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Festival_FM2:
	sNote		nRst, $01
	sVoice		v02
	sVol		$04
	sPan		center

	sNote		nD5, $2F
	sNote		nG2, $06
	sNote		nRst
	sNote		nG2
	sNote		nRst
	sNote		nGs3, $21
	sNote		nG3, $09
	sNote		nE3, $06
	sNote		nDs3, $09
	sNote		nE3
	sNote		nF3, $06
	sNote		nGs3, $30
	sCall		$02, Festival_Loop0F

Festival_FM2_Jump:
	sCall		$03, Festival_Loop10
	sNote		nG3, $09
	sNote		nD4
	sNote		nG4, $0C
	sNote		nFs4, $06
	sNote		nDs4
	sNote		nGs3
	sCall		$03, Festival_Loop11

	sNote		nG4, $09
	sNote		nD5
	sNote		nG5, $0C
	sNote		nFs5, $06
	sNote		nDs5
	sNote		nGs4
	sNote		nD5, $18
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nD5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		nFs5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		$18
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nD5, $18
	sNote		nFs5
	sNote		nFs5
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nFs5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		nFs5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		nFs5, $18
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nD5, $30
	sNote		nRst, $78

	sCall		$02, Festival_Loop12
	sNote		nD5, $18
	sNote		nDs5
	sNote		nF5
	sNote		nDs5
	sNote		nD5
	sNote		nDs5
	sNote		nF5
	sNote		nC5, $03
	sNote		nB4
	sNote		nAs4
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nFs4
	sNote		nF4
	sNote		nG3, $06
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst
	sNote		nF4
	sNote		nRst
	sNote		nE4, $09
	sNote		nCs4
	sNote		nAs3, $06
	sNote		nG3
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst, $12
	sNote		nC5, $03
	sNote		nB4
	sNote		nAs4
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nFs4
	sNote		nF4
	sJump		Festival_FM2_Jump

Festival_Loop10:
	sNote		nD4, $18
	sNote		nDs4, $09
	sNote		$09
	sNote		nF4, $06
	sRet

Festival_Loop11:
	sNote		nD5, $18
	sNote		nDs5, $09
	sNote		$09
	sNote		nF5, $06
	sRet

Festival_Loop12:
	sNote		nG4, $04
	sNote		nRst, $02
	sNote		nD5, $04
	sNote		nRst, $02
	sNote		nG5, $04
	sNote		nRst, $02
	sNote		nFs5, $04
	sNote		nRst, $02
	sNote		nCs5, $09
	sNote		nF5
	sNote		nB4
	sNote		nE5
	sRet

Festival_Loop0F:
	sNote		nG3, $06
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst
	sNote		nF4
	sNote		nRst
	sNote		nE4, $09
	sNote		nCs4
	sNote		nAs3, $06
	sNote		nG3
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst, $12
	sNote		nC5, $03
	sNote		nB4
	sNote		nAs4
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nFs4
	sNote		nF4
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Festival_FM3:
	sNote		nRst, $30
	sVoice		v00
	sVol		$06
	sPan		left

	sNote		nG2, $06
	sNote		nRst
	sNote		nG2
	sNote		nRst
	sNote		nGs3, $21
	sNote		nG3, $09
	sNote		nE3, $06
	sNote		nDs3, $09
	sNote		nC3
	sNote		nB2, $06
	sNote		nGs2, $30
	sCall		$01, Festival_FM3_00

Festival_Jump03:
	sCall		$01, Festival_FM3_00
	sCall		$02, Festival_Loop0C
	sCall		$02, Festival_Loop0D
	sCall		$04, Festival_Loop0E

	sNote		nG2, $18
	sNote		nGs3, $30
	sNote		$18
	sNote		nG3, $12
	sNote		nRst, $03
	sNote		nF3
	sNote		nG3, $48
	sJump		Festival_Jump03

Festival_FM3_00:
	sNote		nG2, $06
	sNote		nRst
	sNote		nD3
	sNote		nRst
	sNote		nDs3, $09
	sNote		nG2
	sNote		nF3, $06
	sNote		nG2
	sNote		nRst
	sNote		nF3
	sNote		nRst
	sNote		nE3, $09
	sNote		nCs3
	sNote		nAs2, $06
	sNote		nG2
	sNote		nRst
	sNote		nD3
	sNote		nRst
	sNote		nDs3, $09
	sNote		nG2
	sNote		nF3, $06
	sNote		nG2
	sNote		nRst, $2A
	sRet

Festival_Loop0C:
	sNote		nG2, $18
	sNote		nGs2
	sNote		nG2
	sNote		nGs2
	sNote		nG2
	sNote		nGs2
	sNote		nG2, $30
	sRet

Festival_Loop0D:
	sNote		nD2, $18
	sNote		nDs2
	sNote		nD2, $30
	sNote		$18
	sNote		nDs2
	sNote		nA1, $09
	sNote		nD2
	sNote		nA2, $0C
	sNote		nFs2, $06
	sNote		nD2
	sNote		nC2
	sRet

Festival_Loop0E:
	sNote		nG1, $04
	sNote		nRst, $02
	sNote		nD2, $04
	sNote		nRst, $02
	sNote		nG2, $04
	sNote		nRst, $02
	sNote		nFs2, $04
	sNote		nRst, $02
	sNote		nCs2, $09
	sNote		nF2
	sNote		nB1
	sNote		nE2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Festival_FM4:
	sNote		nRst, $30
	sVoice		v01
	sPan		right
	sVol		$06

	sNote		nG2, $06
	sNote		nRst
	sNote		nG2
	sNote		nRst
	sNote		nGs3, $21
	sNote		nG3, $09
	sNote		nE3, $06
	sNote		nDs3, $09
	sNote		nC3
	sNote		nB2, $06
	sNote		nGs2, $30
	sCall		$02, Festival_Loop07

Festival_Jump02:
	sCall		$02, Festival_Loop08
	sCall		$02, Festival_Loop09
	sCall		$04, Festival_Loop0A

	sNote		nG2, $18
	sNote		nGs3, $30
	sNote		$18
	sNote		nG3, $12
	sNote		nRst, $03
	sNote		nF3
	sNote		nG3, $48
	sNote		nG2, $06
	sNote		nRst
	sNote		nD3
	sNote		nRst
	sNote		nDs3, $09
	sNote		nG2
	sNote		nF3, $06
	sNote		nG2
	sNote		nRst
	sNote		nF3
	sNote		nRst
	sNote		nE3, $09
	sNote		nCs3
	sNote		nAs2, $06
	sNote		nG2
	sNote		nRst
	sNote		nD3
	sNote		nRst
	sNote		nDs3, $09
	sNote		nG2
	sNote		nF3, $06
	sNote		nG2
	sNote		nRst, $2A
	sJump		Festival_Jump02

Festival_Loop07:
	sNote		nG2, $06
	sNote		nRst
	sNote		nD3
	sNote		nRst
	sNote		nDs3, $09
	sNote		nG2
	sNote		nF3, $06
	sNote		nG2
	sNote		nRst
	sNote		nF3
	sNote		nRst
	sNote		nE3, $09
	sNote		nCs3
	sNote		nAs2, $06
	sNote		nG2
	sNote		nRst
	sNote		nD3
	sNote		nRst
	sNote		nDs3, $09
	sNote		nG2
	sNote		nF3, $06
	sNote		nG2
	sNote		nRst, $2A
	sRet

Festival_Loop08:
	sNote		nG2, $18
	sNote		nGs2
	sNote		nG2
	sNote		nGs2
	sNote		nG2
	sNote		nGs2
	sNote		nG2, $30
	sRet

Festival_Loop09:
	sNote		nD2, $18
	sNote		nDs2
	sNote		nD2, $30
	sNote		$18
	sNote		nDs2
	sNote		nA1, $09
	sNote		nD2
	sNote		nA2, $0C
	sNote		nFs2, $06
	sNote		nD2
	sNote		nC2
	sRet

Festival_Loop0A:
	sNote		nG1, $04
	sNote		nRst, $02
	sNote		nD2, $04
	sNote		nRst, $02
	sNote		nG2, $04
	sNote		nRst, $02
	sNote		nFs2, $04
	sNote		nRst, $02
	sNote		nCs2, $09
	sNote		nF2
	sNote		nB1
	sNote		nE2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Festival_FM5:
	sNote		nRst, $08
	sVoice		v02
	sPan		right
	sFrac		-$0020
	sVol		$08

	sNote		nD5, $30
	sNote		nG2, $06
	sNote		nRst
	sNote		nG2
	sNote		nRst
	sNote		nGs3, $21
	sNote		nG3, $09
	sNote		nE3, $06
	sNote		nDs3, $09
	sNote		nE3
	sNote		nF3, $06
	sNote		nGs3, $30
	sNote		nG3, $06
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst
	sNote		nF4
	sNote		nRst
	sNote		nE4, $09
	sNote		nCs4
	sNote		nAs3, $06
	sNote		nG3
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst, $12

Festival_Jump01:
	sNote		nC5, $03
	sNote		nB4
	sNote		nAs4
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nFs4
	sNote		nF4
	sNote		nG3, $06
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst
	sNote		nF4
	sNote		nRst
	sNote		nE4, $09
	sNote		nCs4
	sNote		nAs3, $06
	sNote		nG3
	sNote		nRst
	sNote		nD4
	sNote		nRst
	sNote		nDs4, $09
	sNote		nG3
	sNote		nF4, $06
	sNote		nG3
	sNote		nRst, $12
	sNote		nC5, $03
	sNote		nB4
	sNote		nAs4
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nFs4
	sNote		nF4
	sCall		$03, Festival_Loop04

	sNote		nG3, $09
	sNote		nD4
	sNote		nG4, $0C
	sNote		nFs4, $06
	sNote		nDs4
	sNote		nGs3
	sCall		$03, Festival_Loop05

	sNote		nG4, $09
	sNote		nD5
	sNote		nG5, $0C
	sNote		nFs5, $06
	sNote		nDs5
	sNote		nGs4
	sNote		nD5, $18
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nD5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		nFs5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		$18
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nD5, $18
	sNote		nFs5
	sNote		nFs5
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nFs5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		nFs5, $09
	sNote		nDs5
	sNote		nD5, $06
	sNote		nFs5, $18
	sNote		nCs5, $09
	sNote		nA4
	sNote		nCs5, $06
	sNote		nD5, $30
	sNote		nRst, $78
	sCall		$02, Festival_Loop06

	sNote		nD5, $18
	sNote		nDs5
	sNote		nF5
	sNote		nDs5
	sNote		nD5
	sNote		nDs5
	sNote		nF5
	sJump		Festival_Jump01

Festival_Loop04:
	sNote		nD4, $18
	sNote		nDs4, $09
	sNote		$09
	sNote		nF4, $06
	sRet

Festival_Loop05:
	sNote		nD5, $18
	sNote		nDs5, $09
	sNote		$09
	sNote		nF5, $06
	sRet

Festival_Loop06:
	sNote		nG4, $04
	sNote		nRst, $02
	sNote		nD5, $04
	sNote		nRst, $02
	sNote		nG5, $04
	sNote		nRst, $02
	sNote		nFs5, $04
	sNote		nRst, $02
	sNote		nCs5, $09
	sNote		nF5
	sNote		nB4
	sNote		nE5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Festival_PSG1:
	sNote		nCut, $01
	sVol		$20
	sFrac		$0C00
	sVolEnv		v03
	sNote		nD2, $2F
	sNote		nCut, $00, $50
	sCall		$04, Festival_Loop28

Festival_Jump05:
	sNote		nCut, $3F0
	sNote		nD1, $18
	sNote		nDs1
	sNote		nF1
	sNote		nDs1
	sNote		nD1
	sNote		nDs1
	sNote		nF1
	sNote		nDs1
	sNote		nD1
	sNote		nDs1
	sNote		nF1, $30
	sNote		nD1, $18
	sNote		nDs1
	sNote		nF1
	sNote		nDs1
	sJump		Festival_Jump05

Festival_Loop28:
	sNote		nD1, $03
	sNote		nAs0
	sNote		nG0
	sNote		nAs0
	sNote		nD1
	sNote		nAs0
	sNote		nG0
	sNote		nAs0
	sNote		nDs1
	sNote		nC1
	sNote		nA0
	sNote		nC1
	sNote		nDs1
	sNote		nC1
	sNote		nA0
	sNote		nC1
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Festival_PSG2:
	sNote		nCut, $01
	sVol		$20
	sFrac		$0C00
	sVolEnv		v03
	sNote		nCs2, $2F
	sNote		nCut, $00, $51
	sVol		$30
	sCall		$03, Festival_Loop26

	sNote		nD1
	sNote		nAs0
	sNote		nG0
	sNote		nAs0
	sNote		nD1
	sNote		nAs0
	sNote		nG0
	sNote		nAs0
	sNote		nDs1
	sNote		nC1
	sNote		nA0
	sNote		nC1
	sNote		nDs1
	sNote		nC1
	sNote		nA0
	sNote		nC1, $02

Festival_Jump04:
	sNote		sTie, $01
	sNote		nCut, $3EF
	sVol		-$30

	sNote		nD2, $18
	sNote		nDs2
	sNote		nF2
	sNote		nDs2
	sNote		nD2
	sNote		nDs2
	sNote		nF2
	sNote		nDs2
	sNote		nD2
	sNote		nDs2
	sNote		nF2, $30
	sNote		nD2, $18
	sNote		nDs2
	sNote		nF2
	sNote		nDs2
	sVol		$30
	sJump		Festival_Jump04

Festival_Loop26:
	sNote		nD1, $03
	sNote		nAs0
	sNote		nG0
	sNote		nAs0
	sNote		nD1
	sNote		nAs0
	sNote		nG0
	sNote		nAs0
	sNote		nDs1
	sNote		nC1
	sNote		nA0
	sNote		nC1
	sNote		nDs1
	sNote		nC1
	sNote		nA0
	sNote		nC1
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Noise data
; ---------------------------------------------------------------------------

Festival_PSG3:
	sNote		nCut, $30
	sFrac		$0C00
	sVol		$7F
	sNote		nE5, $0C

Festival_PSG4_Jump:
	sNote		$0C
	sNote		$1F5

Festival_PSG3_Jump:
	sNote		sTie, $180
	sNote		$3C
	sNote		$0C
	sNote		$228
	sJump		Festival_PSG3_Jump

Festival_PSG4:
	sNote		nCut, $30
	sVol		$08
	sVolEnv		v01
	sNote		nWhitePSG3, $0C
	sJump		Festival_PSG4_Jump

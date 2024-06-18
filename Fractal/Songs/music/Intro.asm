; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	OpeningTheme_Voice
	sHeaderSamples	OpeningTheme_Samples
	sHeaderVibrato	OpeningTheme_Vib
	sHeaderEnvelope	OpeningTheme_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$100
	sChannel	FM1, OpeningTheme_FM1
	sChannel	FM2, OpeningTheme_FM3
	sChannel	FM3, OpeningTheme_FM2
	sChannel	FM4, OpeningTheme_FM4
	sChannel	FM5, OpeningTheme_FM5
	sChannel	FM6, OpeningTheme_FM6
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

OpeningTheme_Voice:
	sNewVoice	v00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$07, $03, $07, $03
	sMultiple	$01, $00, $02, $01
	sRateScale	$01, $01, $00, $01
	sAttackRate	$1D, $1E, $1C, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $03, $0A, $0C
	sDecay2Rate	$00, $00, $03, $03
	sDecay1Level	$04, $08, $08, $0A
	sReleaseRate	$00, $00, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $0A, $00, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $07, $00
	sMultiple	$06, $01, $03, $01
	sRateScale	$00, $01, $01, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$19, $04, $10, $0A
	sDecay2Rate	$01, $02, $01, $00
	sDecay1Level	$02, $0C, $0D, $0F
	sReleaseRate	$02, $02, $02, $03
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$4C, $25, $1A, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $03, $00
	sRateScale	$02, $01, $02, $01
	sAttackRate	$1F, $1B, $1C, $0D
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$06, $1F, $05, $03
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $00, $05, $00
	sReleaseRate	$01, $03, $05, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$21, $1F, $25, $00
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $02, $00, $03
	sMultiple	$01, $02, $03, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$12, $12, $12, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$01, $01, $01, $01
	sDecay2Rate	$01, $01, $01, $01
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$04, $04, $05, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$21, $21, $00, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

OpeningTheme_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

OpeningTheme_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

OpeningTheme_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

OpeningTheme_FM1:
	sVoice		v00
	sVol		$08
	sPan		center
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sVol		$07
	sNote		nC2, $09
	sNote		nRst, $02
	sVol		-$07
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $1F
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nF2, $09
	sNote		nRst, $02
	sNote		nA2, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sVol		$07
	sNote		nC2, $09
	sNote		nRst, $02
	sVol		-$07
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $1F
	sNote		nRst, $02
	sNote		nFs2, $09
	sNote		nRst, $02
	sNote		nA2, $09
	sNote		nRst, $02
	sNote		nC3, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02

OpeningTheme_Jump05:
	sNote		nC2, $14
	sNote		nRst, $01
	sNote		nC2, $0A
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $15
	sNote		nRst, $01
	sNote		nC2, $15

	sCall		$03, OpeningTheme_Loop0A
	sNote		nRst, $01
	sNote		nC2, $09
	sCall		$03, OpeningTheme_Loop0B

	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $15
	sNote		nRst, $01
	sVol		$07
	sNote		nC2, $0A
	sNote		nRst, $01
	sVol		-$07
	sNote		nC2, $0A
	sNote		nRst, $01
	sNote		nFs2, $0A
	sNote		nRst, $01
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $0A
	sNote		nRst, $01
	sNote		nC2, $15
	sNote		nRst, $02
	sNote		nC2, $14

	sCall		$04, OpeningTheme_Loop0C
	sCall		$03, OpeningTheme_Loop0B
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nD2, $14
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nD2, $09
	sNote		nRst, $02
	sNote		nDs2, $15
	sNote		nRst, $02
	sNote		nD2, $09
	sNote		nRst, $02
	sNote		nDs2, $0A
	sNote		nRst, $01
	sNote		nGs2, $15
	sNote		nRst, $02
	sNote		nGs2, $15
	sNote		nRst, $02
	sVol		$07
	sNote		nGs2, $09
	sNote		nRst, $02
	sVol		-$07
	sNote		nGs2, $0A
	sNote		nRst, $02
	sNote		nFs2, $14
	sNote		nRst, $02
	sNote		nF2, $15
	sNote		nRst, $02
	sNote		nFs2, $09
	sNote		nRst, $02
	sNote		nF2, $09
	sNote		nRst, $02
	sNote		nE2, $14
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nE2, $09
	sNote		nRst, $02
	sNote		nDs2, $14
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nDs2, $09
	sNote		nRst, $02
	sNote		nCs2, $14
	sNote		nRst, $02
	sNote		nDs2, $09
	sNote		nRst, $02
	sNote		nCs2, $09
	sNote		nRst, $03
	sNote		nC2, $14
	sNote		nRst, $02
	sNote		nCs2, $09
	sNote		nRst, $02
	sNote		nC2, $09
	sNote		nRst, $02
	sNote		nB1, $09
	sNote		nRst, $01
	sNote		nB1, $0A
	sNote		nRst, $01
	sNote		nB2, $15
	sNote		nRst, $01
	sNote		nAs2, $15
	sNote		nRst, $02
	sNote		nAs1, $14
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nAs2, $15
	sNote		nRst, $01
	sNote		nAs2, $15
	sNote		nRst, $02
	sNote		nAs1, $14
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $03
	sNote		nAs2, $08
	sNote		nRst, $03
	sNote		nAs2, $14
	sNote		nRst, $02
	sNote		nAs2, $14
	sNote		nRst, $02
	sNote		nAs1, $15
	sNote		nRst, $01
	sNote		nAs2, $0A
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nAs2, $14
	sNote		nRst, $02
	sNote		nAs2, $14
	sNote		nRst, $02
	sNote		nAs1, $15
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nAs2, $09
	sNote		nRst, $02
	sNote		nAs2, $14
	sNote		nRst, $02
	sNote		nC2, $14
	sNote		nRst, $03
	sJump		OpeningTheme_Jump05

OpeningTheme_Loop0A:
	sNote		nRst, $01
	sNote		nC2, $0A
	sRet

OpeningTheme_Loop0B:
	sNote		nRst, $02
	sNote		nC2, $14
	sRet

OpeningTheme_Loop0C:
	sNote		nRst, $02
	sNote		nC2, $09
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

OpeningTheme_FM2:
	sVoice		v01
	sVol		$10
	sPan		center
	sCall		$02, OpeningTheme_Loop07
	sCall		$02, OpeningTheme_Loop08

	sNote		nC5, $05
	sNote		nRst, $01
	sVol		$07
	sNote		sHold, nRst

	sCall		$02, OpeningTheme_Loop09
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nA5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nFs6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nA6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nC5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nA5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nFs6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nA6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		$F0
	sNote		nC5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nG5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG5
	sVol		$05
	sNote		nRst

OpeningTheme_Jump04:
	sVol		-$06
	sNote		nDs6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nG6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nC5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nG5, $03
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nG6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nA5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nF6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nA6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nA5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nF6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nA6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nG6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nAs6, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nC5, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nAs5, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nG6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nG6, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nAs6, $02
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nC5
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nC5, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		sHold, $01
	sNote		nA5, $03
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $03
	sVol		-$09
	sNote		nA5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nFs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nFs6, $01
	sNote		nRst
	sVol		$05
	sNote		sHold, $01
	sVol		-$06
	sNote		nA6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nA5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nFs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nFs6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nA6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nG5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nG6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nG5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nG6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nC5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nA5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nA6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nC5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nA5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nA5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nA6, $03
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, nRst
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nA6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nFs6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nFs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nAs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nC5, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nC5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nFs6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nFs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nD5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nD5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nFs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nFs6, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nDs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nFs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nFs6, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		sHold, $01
	sNote		nGs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nGs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nDs6
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nB6
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nB6, $01
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nDs7
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs7
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nGs5, $03
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nGs5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nB6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nB6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nDs7, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs7, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nGs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nGs5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nGs6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nGs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nB6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nB6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nD5, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nD5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nD6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nD6, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nGs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nGs6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nD7, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nD7, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nDs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nDs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nDs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nDs5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5, $01
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nFs6
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nFs6, $02
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nAs6
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6, $01
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nC5
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5, $01
	sNote		nRst
	sVol		$05
	sNote		sHold, $02
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nFs6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nFs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nB4, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nB4
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nGs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nGs5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nFs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nFs6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nAs6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs4
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF6, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nAs4
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nF5, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nF6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs4
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		sHold, $01
	sNote		sHold, nF6
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs4, $01
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nF5
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nF6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nAs4, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nD6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nD6
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs4
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nD6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nD6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$09
	sNote		nAs4, $02
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5, $01
	sVol		$05
	sNote		nRst, $02
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst, $01
	sVol		-$06
	sNote		nD6, $04
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nD6
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs4, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nAs4
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nF5, $03
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nF5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nAs5, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nAs5
	sVol		$05
	sNote		nRst
	sVol		-$06
	sNote		nD6, $04
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$09
	sNote		nD6
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nC5
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nC5, $01
	sVol		$05
	sNote		nRst, $03
	sVol		-$06
	sNote		nG5
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$09
	sNote		nG5, $01
	sNote		nRst
	sVol		$05
	sNote		sHold, $02
	sPan		center
	sJump		OpeningTheme_Jump04

OpeningTheme_Loop07:
	sNote		nC5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nG5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nDs6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nG6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sRet

OpeningTheme_Loop08:
	sNote		nC5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nA5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nF6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nA6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sRet

OpeningTheme_Loop09:
	sVol		$08
	sNote		sHold, $02
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nAs5, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nG6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nAs6, $05
	sVol		$07
	sNote		nRst, $02
	sVol		$08
	sNote		sHold, nRst
	sVol		$07
	sNote		sHold, nRst
	sVol		-$16
	sNote		nC5, $05
	sVol		$07
	sNote		nRst, $02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

OpeningTheme_FM3:
	sVoice		v01
	sVol		$14
	sPan		center
	sNote		nC5, $04
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$F1
	sNote		nC5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16
	sFrac		-$0009		; ssDetune $FE
	sNote		nG5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16
	sNote		nDs6, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16
	sNote		nG6, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sFrac		$0009		; ssDetune $00
	sVol	-$16
	sNote		nC5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16

	sFrac		-$0009		; ssDetune $FE
	sNote		nG5, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nDs6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nG6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sFrac		$0009		; ssDetune $00
	sVol	-$16
	sNote		nC5, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16

	sFrac		-$0008		; ssDetune $FE
	sNote		nA5, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nF6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nA6, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, nRst
	sFrac		$0008		; ssDetune $00
	sVol	-$16
	sNote		nC5, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16

	sFrac		-$0008		; ssDetune $FE
	sNote		nA5, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nF6, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $03
	sVol	$07
	sNote		sHold, $01
	sVol	-$16
	sNote		nA6, $05
	sNote		nRst, $01
	sVol	$07
	sNote		sHold, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, $01
	sFrac		$0008		; ssDetune $00
	sVol	-$16
	sNote		nC5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16

	sFrac		-$0008		; ssDetune $FE
	sNote		nAs5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16
	sNote		nG6, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16
	sNote		nAs6, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sFrac		$0008		; ssDetune $00
	sVol	-$16
	sNote		nC5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16

	sFrac		-$0008		; ssDetune $FE
	sNote		nAs5, $06
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, $01
	sVol	$07
	sNote		sHold, $02
	sVol	-$16
	sNote		nG6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nAs6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sFrac		$0008		; ssDetune $00
	sVol	-$16
	sNote		nC5, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16

	sFrac		-$0008		; ssDetune $FE
	sNote		nA5, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nFs6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nA6, $06
	sVol	$07
	sNote		nRst, $01
	sVol	$08
	sNote		sHold, $02
	sVol	$07
	sNote		sHold, nRst
	sFrac		$0008		; ssDetune $00
	sVol	-$16
	sNote		nC5, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16

	sFrac		-$0008		; ssDetune $FE
	sNote		nA5, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nFs6, $05
	sVol	$07
	sNote		nRst, $02
	sVol	$08
	sNote		sHold, nRst
	sVol	$07
	sNote		sHold, nRst
	sVol	-$16
	sNote		nA6
	sVol	$07
	sNote		nRst
	sFrac		$0008		; ssDetune $00

	sVoice		v02
	sVol		-$06

OpeningTheme_Jump03:
	sPan		left
	sNote		nDs5, $57
	sNote		nRst, $01
	sNote		nF5, $55
	sNote		nRst, $03
	sNote		nG5, $54
	sNote		nRst, $05
	sNote		nFs5
	sNote		sHold, nG5, $06
	sNote		sHold, nFs5, $05
	sNote		sHold, nG5

	sCall		$03, OpeningTheme_Loop03
	sNote		sHold, nFs5, $06
	sNote		sHold, nG5, $04
	sNote		nRst, $01
	sNote		nD5, $14
	sNote		nRst, $02
	sNote		nDs5, $54
	sNote		nRst, $04
	sNote		nF5, $57
	sNote		nRst, $02
	sNote		nFs5, $54
	sNote		nRst, $04

	sCall		$02, OpeningTheme_Loop04
	sNote		nF5, $06
	sCall		$02, OpeningTheme_Loop05
	sNote		sHold, nFs5, $06
	sNote		sHold, nF5, $05
	sNote		sHold, nFs5, $06
	sNote		sHold, nF5
	sNote		sHold, nFs5
	sNote		sHold, nF5, $05
	sNote		sHold, nFs5, $04
	sNote		nRst, $02
	sNote		nGs5, $DD
	sNote		nRst, $03
	sNote		nAs5, $56
	sNote		nRst, $02
	sNote		nB5, $14
	sNote		nRst, $01
	sNote		nAs5, $15
	sNote		nRst, $01
	sCall		$02, OpeningTheme_Loop06
	sJump		OpeningTheme_Jump03

OpeningTheme_Loop03:
	sNote		sHold, nFs5, $06
	sNote		sHold, nG5, $05
	sRet

OpeningTheme_Loop04:
	sNote		nF5, $0B, sHold
	sRet

OpeningTheme_Loop05:
	sNote		sHold, nFs5, $05
	sNote		sHold, nF5, $06
	sRet

OpeningTheme_Loop06:
	sNote		nAs5, $AF
	sNote		nRst, $04
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

OpeningTheme_FM4:
	sVoice		v02
	sVol		$15
	sPan		left
	sNote		nDs5, $54
	sNote		nRst, $04
	sNote		nF5, $54
	sNote		nRst, $04
	sNote		nG5, $54
	sNote		nRst, $04
	sNote		nFs5, $4D
	sNote		nRst, $0B

OpeningTheme_Jump02:
	sNote		nG5, $57
	sNote		nRst, $01
	sNote		nA5, $55
	sNote		nRst, $04
	sNote		nAs5, $54
	sNote		nRst, $04
	sNote		nA5, $05
	sNote		sHold, nAs5, $06
	sNote		sHold, nA5, $05
	sNote		sHold, nAs5

	sCall		$05, OpeningTheme_Loop00
	sNote		sHold, nA5, $06
	sNote		sHold, nAs5, $03
	sNote		nRst, $02
	sNote		nG5, $54
	sNote		nRst, $04
	sNote		nA5, $57
	sNote		nRst, $02
	sNote		nAs5, $54
	sNote		nRst, $04

	sCall		$02, OpeningTheme_Loop01
	sNote		sHold, nA5, $06
	sCall		$03, OpeningTheme_Loop02
	sNote		sHold, nAs5, $06
	sNote		sHold, nA5, $06
	sNote		sHold, nAs5
	sNote		sHold, nA5, $05
	sNote		sHold, nAs5, $04
	sNote		nRst, $02
	sNote		nB5, $85
	sNote		nRst, $02
	sNote		nD6, $2A
	sNote		nRst, $03
	sNote		nDs6, $82
	sNote		nRst, $02
	sNote		nD6, $14
	sNote		nRst, $01
	sNote		nDs6, $15
	sNote		nRst, $01
	sNote		nDs6, $AF
	sNote		nRst, $04
	sNote		nD6, $A7
	sNote		nRst, $0C
	sJump		OpeningTheme_Jump02

OpeningTheme_Loop00:
	sNote		sHold, nA5, $06
	sNote		sHold, nAs5, $05
	sRet

OpeningTheme_Loop01:
	sNote		nA5, $05
	sNote		sHold, nAs5, $06
	sRet

OpeningTheme_Loop02:
	sNote		sHold, nAs5, $06
	sNote		sHold, nA5, $05
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

OpeningTheme_FM5:
	sVoice		v02
	sVol		$19
	sPan		center
	sFrac		-$000B		; ssDetune $FE
	sNote		nDs5, $58
	sNote		nRst, $03
	sNote		nF5, $55
	sNote		nRst, $04
	sNote		nG5, $54
	sNote		nRst, $03
	sNote		nFs5, $4A
	sNote		nRst, $0B

	sVoice		v03
	sVol		$62
	sNote		nRst, $16

OpeningTheme_Jump01:
	sNote		nRst, $16
	sVol		-$6A
	sNote		nG4, $14
	sNote		nRst, $02

	sFrac		$000B		; ssDetune $00
	sNote		nC4, $3D
	sNote		nRst, $05

	sFrac		-$000C		; ssDetune $FE
	sNote		nD4, $08
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$0A
	sNote		nDs4, $08
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $02
	sVol		-$0A
	sNote		nF4, $3D
	sNote		nRst, $06
	sNote		nDs4
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nD4, $06
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sFrac		$000C		; ssDetune $00

	sNote		nC4, $5F
	sNote		nRst, $3A
	sFrac		-$0009		; ssDetune $FE
	sNote		nG4, $11
	sNote		nRst, $06
	sFrac		$0009		; ssDetune $00
	sNote		nC4, $3B
	sNote		nRst, $06

	sFrac		-$000C		; ssDetune $FE
	sNote		nD4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nDs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nF4, $3C
	sNote		nRst, $06
	sNote		nDs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nF4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nFs4, $6E
	sNote		nRst, $2F
	sNote		nDs5, $15
	sNote		nRst, $02
	sNote		nGs4, $3D
	sNote		nRst, $06
	sNote		nAs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A

	sFrac		-$0002		; ssDetune $FD
	sNote		nB4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A

	sFrac		$0002		; ssDetune $FE
	sNote		nAs4, $1F
	sNote		nRst, $02
	sNote		nGs4, $1C
	sNote		nRst, $06
	sNote		nFs4, $07
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nF4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nFs4, $3C
	sNote		nRst, $06
	sNote		nF4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$0A
	sNote		nDs4, $08
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$0A
	sNote		nD4, $20
	sNote		nRst, $02
	sNote		nDs4, $AE
	sNote		nRst, $04
	sNote		nD4
	sVol		$05
	sNote		nRst, $02
	sVol		-$05

	sFrac		$000C		; ssDetune $00
	sNote		nC4, $03
	sVol		$05
	sNote		nRst, $02
	sVol		-$05

	sFrac		-$000C		; ssDetune $FE
	sNote		nD4, $99
	sNote		nRst, $1A

	sVol		$6A
	sPan		center
	sFrac		$0001		; ssDetune $FE

	sJump		OpeningTheme_Jump01

; ===========================================================================
; ---------------------------------------------------------------------------
; FM6 data
; ---------------------------------------------------------------------------

OpeningTheme_FM6:
	sVoice		v02
	sVol		$16
	sPan		center
	sNote		nG4, $54
	sNote		nRst, $04
	sNote		nA4, $54
	sNote		nRst, $04
	sNote		nAs4, $54
	sNote		nRst, $04
	sNote		nA4, $4D
	sNote		nRst, $0B

	sVoice		v03
	sVol		$65
	sNote		nRst, $16

OpeningTheme_Jump00:
	sVol		-$6F
	sNote		nG4, $10
	sNote		nRst, $06
	sNote		nC4, $3D
	sNote		nRst, $05
	sNote		nD4, $08
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$0A
	sNote		nDs4, $08
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, $01
	sVol		-$0A
	sNote		nF4, $3D
	sNote		nRst, $06
	sNote		nDs4, $07
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nD4, $06
	sVol		$04
	sNote		nRst, $01
	sVol		$01
	sNote		sHold, nRst
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nC4, $5F
	sNote		nRst, $3A
	sNote		nG4, $11
	sNote		nRst, $06
	sNote		nC4, $3C
	sNote		nRst, $06
	sNote		nD4, $06
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nDs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nF4, $3D
	sNote		nRst, $06
	sNote		nDs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nF4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nFs4, $84
	sNote		nRst, $19
	sNote		nDs5, $10
	sNote		nRst, $06
	sNote		nGs4, $3E
	sNote		nRst, $06
	sNote		nAs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nB4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nAs4, $1F
	sNote		nRst, $03
	sNote		nGs4, $1B
	sNote		nRst, $06
	sNote		nFs4, $07
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nF4, $07
	sVol		$05
	sNote		nRst, $01
	sVol		$05
	sNote		sHold, $03
	sVol		-$0A
	sNote		nFs4, $3C
	sNote		nRst, $06
	sNote		nF4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nDs4, $07
	sVol		$05
	sNote		nRst, $02
	sVol		$05
	sNote		sHold, nRst
	sVol		-$0A
	sNote		nD4, $1F
	sNote		nRst, $01
	sNote		nDs4, $AF
	sNote		nRst, $04
	sNote		nD4
	sVol		$05
	sNote		nRst, $01
	sVol		-$05
	sNote		nC4, $04
	sVol		$05
	sNote		nRst, $02
	sVol		-$05
	sNote		nD4, $AF
	sNote		nRst, $1A

	sVol		$6F
	sPan		center
	sJump		OpeningTheme_Jump00

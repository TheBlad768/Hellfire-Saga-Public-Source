; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Invin_Voice
	sHeaderSamples	Invin_Samples
	sHeaderVibrato	Invin_Vib
	sHeaderEnvelope	Invin_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FE
	sChannel	FM1, Invin_FM1
	sChannel	FM2, Invin_FM3
	sChannel	FM3, Invin_FM2
	sChannel	FM4, Invin_FM4
	sChannel	FM5, Invin_FM5
	sChannel	FM6, Invin_FM6
	sChannel	PSG1, Invin_PSG1
	sChannel	PSG2, Invin_PSG2
	sChannel	PSG3, Invin_PSG3
	sChannel	PSG4, Invin_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Invin_Voice:
	sNewVoice	v00
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$00, $00, $01, $00
	sMultiple	$09, $01, $05, $02
	sRateScale	$02, $02, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$03, $03, $03, $06
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$09, $08, $09, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$25, $1F, $2F, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$00, $00, $07, $03
	sMultiple	$07, $01, $01, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $16, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $08, $00
	sTotalLevel	$2F, $1B, $08, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$06
	sFeedback	$07
	sDetune		$00, $03, $00, $07
	sMultiple	$02, $02, $01, $06
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $0E, $11, $00
	sDecay2Rate	$00, $07, $0A, $09
	sDecay1Level	$0F, $01, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$0C, $00, $00, $00
	sTotalLevel	$18, $0A, $00, $18
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Invin_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Invin_Vib:
	sVibrato FM6,		$00, $00, $2000, $0041, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Invin_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Invin_FM1:
	sVoice		v00
	sVol		$10
	sCall		$03, Invin_Loop06
	sStop

Invin_Loop06:
	sPan		center
	sNote		nC3, $20
	sPan		right
	sNote		sHold, nC3
	sPan		center
	sNote		nDs3
	sPan		right
	sNote		sHold, nDs3
	sPan		center
	sNote		nGs2
	sPan		right
	sNote		sHold, nGs2
	sPan		center
	sNote		nG3
	sPan		right
	sNote		sHold, nG3
	sPan		center
	sNote		nDs2
	sPan		right
	sNote		sHold, nDs2
	sPan		center
	sNote		nGs3
	sPan		right
	sNote		sHold, nGs3
	sPan		center
	sNote		nG2
	sPan		right
	sNote		sHold, nG2
	sPan		center
	sNote		nB3
	sPan		right
	sNote		sHold, nB3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Invin_FM2:
	sNote		nRst, $10
	sPan		center
	sVoice		v00
	sVol		$14
	sCall		$02, Invin_Loop04
	sCall		$0F, Invin_Loop05
	sNote		nG3, $10
	sStop

Invin_Loop04:
	sCall		$0F, Invin_Loop03
	sNote		nG3
	sRet

Invin_Loop03:
	sNote		nC4, $20
	sRet

Invin_Loop05:
	sNote		nC4
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Invin_FM3:
	sNote		nRst, $20
	sVoice		v00
	sVol		$10
	sCall		$02, Invin_Loop02
	sPan		center
	sNote		nG3
	sPan		left
	sNote		sHold, nG3
	sPan		center
	sNote		nD3
	sPan		left
	sNote		sHold, nD3
	sPan		center
	sNote		nAs3
	sPan		left
	sNote		sHold, nAs3
	sPan		center
	sNote		nF3
	sPan		left
	sNote		sHold, nF3
	sPan		center
	sNote		nAs3
	sPan		left
	sNote		sHold, nAs3
	sPan		center
	sNote		nG3
	sPan		left
	sNote		sHold, nG3
	sPan		center
	sNote		nD3
	sPan		left
	sNote		sHold, nD3
	sPan		center
	sNote		nB3
	sStop

Invin_Loop02:
	sPan		center
	sNote		nG3
	sPan		left
	sNote		sHold, nG3
	sPan		center
	sNote		nD3
	sPan		left
	sNote		sHold, nD3
	sPan		center
	sNote		nAs3
	sPan		left
	sNote		sHold, nAs3
	sPan		center
	sNote		nF3
	sPan		left
	sNote		sHold, nF3
	sPan		center
	sNote		nAs3
	sPan		left
	sNote		sHold, nAs3
	sPan		center
	sNote		nG3
	sPan		left
	sNote		sHold, nG3
	sPan		center
	sNote		nD3
	sPan		left
	sNote		sHold, nD3
	sPan		center
	sNote		nB3
	sPan		left
	sNote		sHold, nB3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Invin_FM4:
	sNote		nRst, $08
	sVoice		v00
	sVol		$18
	sPan		right
	sCall		$02, Invin_Loop01
	sNote		nC3
	sNote		nC4
	sNote		nG3
	sNote		nC4
	sNote		nDs3
	sNote		nC4
	sNote		nD3
	sNote		nC4
	sNote		nGs2
	sNote		nC4
	sNote		nAs3
	sNote		nC4
	sNote		nG3
	sNote		nC4
	sNote		nF3
	sNote		nC4
	sNote		nDs2
	sNote		nC4
	sNote		nAs3
	sNote		nC4
	sNote		nGs3
	sNote		nC4
	sNote		nG3
	sNote		nC4
	sNote		nG2
	sNote		nC4
	sNote		nD3
	sNote		nC4
	sNote		nB3
	sNote		nC4
	sNote		nB3
	sNote		nG3, $08
	sStop

Invin_Loop01:
	sNote		nC3, $10
	sNote		nC4
	sNote		nG3
	sNote		nC4
	sNote		nDs3
	sNote		nC4
	sNote		nD3
	sNote		nC4
	sNote		nGs2
	sNote		nC4
	sNote		nAs3
	sNote		nC4
	sNote		nG3
	sNote		nC4
	sNote		nF3
	sNote		nC4
	sNote		nDs2
	sNote		nC4
	sNote		nAs3
	sNote		nC4
	sNote		nGs3
	sNote		nC4
	sNote		nG3
	sNote		nC4
	sNote		nG2
	sNote		nC4
	sNote		nD3
	sNote		nC4
	sNote		nB3
	sNote		nC4
	sNote		nB3
	sNote		nG3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Invin_FM5:
	sVoice		v01
	sPan		center
	sCall		$03, Invin_Loop00
	sStop

Invin_Loop00:
	sNote		nC2, $80
	sNote		nGs1, $80
	sNote		nDs1, $80
	sNote		nG1, $80
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM6 data
; ---------------------------------------------------------------------------

Invin_FM6:
	sNote		nRst, $00, nRst, $00
	sVoice		v02
	sVol		$0D
	sVibratoSet	FM6
	sPan		center
	sNote		nG5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nDs5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nDs5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nDs5
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD5
	sPan		left
	sNote		sHold, nD5
	sPan		center
	sNote		nC5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG4
	sPan		left
	sNote		sHold, nG4
	sPan		center
	sNote		nF4
	sPan		left
	sNote		sHold, nF4
	sPan		center
	sNote		nAs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nAs4
	sPan		left
	sNote		sHold, nAs4
	sPan		center
	sNote		nG4
	sPan		left
	sNote		sHold, nG4
	sPan		center
	sNote		nB4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nB5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD6
	sPan		left
	sNote		sHold, nD6
	sPan		center
	sNote		nB5
	sPan		left
	sNote		sHold, nB5
	sPan		center
	sNote		nG5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nDs5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nDs5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nDs5
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD5
	sPan		left
	sNote		sHold, nD5
	sPan		center
	sNote		nC5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG4
	sPan		left
	sNote		sHold, nG4
	sPan		center
	sNote		nF4
	sPan		left
	sNote		sHold, nF4
	sPan		center
	sNote		nAs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nGs4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nAs4
	sPan		left
	sNote		sHold, nAs4
	sPan		center
	sNote		nG4
	sPan		left
	sNote		sHold, nG4
	sPan		center
	sNote		nB4, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nG5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nB5, $10
	sPan		left
	sNote		sHold, $08
	sPan		center
	sNote		nD6
	sPan		left
	sNote		sHold, nD6
	sPan		center
	sNote		nB5
	sPan		left
	sNote		sHold, nB5
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Invin_PSG1:
	sNote		nCut, $00, nCut, $00, nCut, $04
	sVol		$78
	sFrac		$0C00
	sCall		$06, Invin_Loop13

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sCall		$06, Invin_Loop14

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sFrac		$0006
	sCall		$06, Invin_Loop15

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sCall		$06, Invin_Loop16

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $09
	sVol		$38
	sFrac		-$0006
	sCall		$0B, Invin_Loop17

	sNote		$61
	sNote		nCut, $09
	sVol		$58
	sCall		$0B, Invin_Loop18

	sNote		$61
	sNote		nCut, $09
	sVol		$58
	sCall		$0B, Invin_Loop18

	sNote		$61
	sNote		nCut, $09
	sVol		$58
	sCall		$0B, Invin_Loop1A

	sNote		$61
	sStop

Invin_Loop13:
	sNote		nC2, $04
	sVol		-$08
	sRet

Invin_Loop14:
	sNote		nGs1
	sVol		-$08
	sRet

Invin_Loop15:
	sNote		nDs1
	sVol		-$08
	sRet

Invin_Loop16:
	sNote		nB1
	sVol		-$08
	sRet

Invin_Loop17:
	sNote		nC2, $02
	sVol		-$08
	sRet

Invin_Loop18:
	sNote		nDs2, $02
	sVol		-$08
	sRet

Invin_Loop1A:
	sNote		nD2, $02
	sVol		-$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Invin_PSG2:
	sNote		nCut, $04
	sVol		$78
	sFrac		$0C00
	sCall		$06, Invin_Loop08

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sCall		$06, Invin_Loop09

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sFrac		$0009
	sCall		$06, Invin_Loop0A

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sFrac		-$0009
	sCall		$06, Invin_Loop0B

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sCall		$06, Invin_Loop08

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sCall		$06, Invin_Loop09

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sFrac		$0009
	sCall		$06, Invin_Loop0E

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $04
	sVol		$38
	sFrac		-$0009
	sCall		$06, Invin_Loop0B

	sNote		$03
	sVol		-$08
	sNote		$61

	sNote		nCut, $09
	sVol		$38
	sCall		$0B, Invin_Loop10

	sNote		$21
	sNote		nAs2, $20
	sNote		nDs2

	sNote		nCut, $09
	sVol		$58
	sCall		$0B, Invin_Loop11

	sNote		$21
	sNote		nG2, $10
	sNote		nGs2
	sNote		nG2
	sNote		nF2

	sNote		nCut, $09
	sVol		$58
	sCall		$0B, Invin_Loop12

	sNote		$11
	sNote		nGs2, $08
	sNote		nAs2
	sNote		nC3, $10
	sNote		nD3
	sNote		nDs3
	sNote		nAs2
	sNote		nB2
	sNote		nDs2

	sFrac		$0005
	sNote		nB1
	sNote		nDs1
	sNote		nD0, $08
	sNote		nDs0
	sNote		nG0
	sNote		nB0
	sFrac		-$0005

	sNote		nD1

	sFrac		$0006
	sNote		nDs1
	sFrac		-$0006

	sNote		nG1

	sFrac		$000A
	sNote		nB1
	sStop

Invin_Loop08:
	sNote		nG2
	sVol		-$08
	sRet

Invin_Loop09:
	sNote		nC2
	sVol		-$08
	sRet

Invin_Loop0A:
	sNote		nAs1
	sVol		-$08
	sRet

Invin_Loop0B:
	sNote		nD2
	sVol		-$08
	sRet

Invin_Loop0E:
	sNote		nAs1
	sVol		-$08
	sRet

Invin_Loop10:
	sNote		nG2, $02
	sVol		-$08
	sRet

Invin_Loop11:
	sNote		nGs2, $02
	sVol		-$08
	sRet

Invin_Loop12:
	sNote		nAs2, $02
	sVol		-$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

Invin_PSG3:
	sVol		$7F
	sFrac		$0C00
	sNote		nA5, $08
	sCall		$02, Invin_Loop07
	sCall		$01, Invin_PSG3_00
	sStop

Invin_Loop07:
	sCall		$01, Invin_PSG3_00
	sNote		nA3
	sRet

Invin_PSG3_00:
	sNote		nAs3
	sNote		nB3
	sFrac		-$002A		; ssDetune $FF
	sNote		nC4
	sNote		nCs4
	sFrac		$002A		; ssDetune $00
	sNote		nD4
	sNote		nDs4
	sFrac		-$0033		; ssDetune $FF
	sNote		nE4
	sFrac		$0033		; ssDetune $00
	sNote		nF4
	sNote		nFs4
	sNote		nG4
	sNote		nGs4
	sNote		nA4
	sFrac		-$0040		; ssDetune $FF
	sNote		nAs4
	sNote		nB4
	sFrac		$0040		; ssDetune $00
	sNote		nC5, $28
	sFrac		-$0055		; ssDetune $FF
	sNote		nB4, $08
	sFrac		$0055		; ssDetune $00
	sNote		nA4
	sNote		nG4
	sNote		nF4
	sFrac		-$0033		; ssDetune $FF
	sNote		nE4
	sFrac		$0033		; ssDetune $00
	sNote		nD4
	sFrac		-$002A		; ssDetune $FF
	sNote		nC4
	sFrac		$002A		; ssDetune $00
	sNote		nB3
	sNote		nA3
	sNote		nG3
	sNote		nF3
	sNote		nE3, $48
	sNote		nA3, $08
	sNote		nAs3
	sNote		nB3
	sFrac		-$002A		; ssDetune $FF
	sNote		nC4
	sNote		nCs4
	sFrac		$002A		; ssDetune $00
	sNote		nD4
	sNote		nDs4
	sFrac		-$0033		; ssDetune $FF
	sNote		nE4
	sFrac		$0033		; ssDetune $00
	sNote		nF4
	sNote		nFs4
	sNote		nG4
	sNote		nGs4
	sNote		nA4
	sFrac		-$0040		; ssDetune $FF
	sNote		nAs4
	sNote		nB4
	sFrac		$0040		; ssDetune $00
	sNote		nC5
	sFrac		-$0055		; ssDetune $FF
	sNote		nB4
	sNote		nAs4
	sFrac		$0055		; ssDetune $00
	sNote		nA4
	sNote		nGs4
	sNote		nG4
	sNote		nF4
	sFrac		-$0033		; ssDetune $FF
	sNote		nE4
	sFrac		$0033		; ssDetune $00
	sNote		nG3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG4 data
; ---------------------------------------------------------------------------

Invin_PSG4:
	sVol		$20
	sNote		nWhitePSG3, $08
	sCall		$01, Invin_PSG4_01
	sCall		$19, Invin_PSG4_08
	sCall		$01, Invin_PSG4_01
	sCall		$19, Invin_PSG4_08
	sCall		$01, Invin_PSG4_01
	sCall		$18, Invin_PSG4_08
	sStop

Invin_PSG4_01:
	sCall		$0E, Invin_PSG4_08
	sNote		$28
	sCall		$0B, Invin_PSG4_08
	sNote		$48
	sRet

Invin_PSG4_08:
	sNote		$08
	sRet

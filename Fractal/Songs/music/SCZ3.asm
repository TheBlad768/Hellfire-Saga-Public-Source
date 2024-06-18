; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Stage72_Voice
	sHeaderSamples	Stage72_Samples
	sHeaderVibrato	Stage72_Vib
	sHeaderEnvelope	Stage72_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FC
	sChannel	FM1, Stage72_FM1
	sChannel	FM2, Stage72_FM3
	sChannel	FM3, Stage72_FM2
	sChannel	FM4, Stage72_FM4
	sChannel	FM5, Stage72_FM5
	sChannel	FM6, Stage72_FM6
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Stage72_Voice:
	sNewVoice	v00
	sAlgorithm	$03
	sFeedback	$06
	sDetune		$00, $00, $0F, $00
	sMultiple	$01, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $0A, $07, $09
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$02, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $17, $1C, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $0F, $01, $02
	sMultiple	$0A, $02, $02, $02
	sRateScale	$02, $02, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $04, $03, $03
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $05, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1D, $16, $06, $0A
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$01
	sDetune		$0E, $0A, $01, $0D
	sMultiple	$02, $01, $04, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0B, $0B, $0B, $0B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$22, $22, $04, $04
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Stage72_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Stage72_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Stage72_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Stage72_FM4:
	sNote		nRst, $04
	sPan		left
	sFrac		$0019
	sVoice		v01
	sVol		$15
	sJump		Stage72_Call01

Stage72_FM5:
	sNote		nRst, $05
	sPan		right
	sFrac		$000F
	sVoice		v01
	sVol		$15
	sJump		Stage72_Call01

Stage72_FM1:
	sPan		center
	sVoice		v01
	sVol		$10

Stage72_Call01:
	sNote		nE4, $08
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nAs4
	sNote		nB3
	sNote		nG3
	sNote		nB4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nA3
	sNote		nFs3
	sNote		nDs4
	sNote		nA3
	sNote		nF3
	sNote		nFs4
	sNote		nA3
	sNote		nFs3
	sNote		nF4
	sNote		nA3
	sNote		nF3
	sNote		nC5
	sNote		nA3
	sNote		nFs3
	sNote		nA4
	sNote		nA3
	sNote		nF3
	sNote		nDs5
	sNote		nA3
	sNote		nF3
	sNote		nC5
	sNote		nA3
	sNote		nF3
	sNote		nB4
	sNote		nB3
	sNote		nG3
	sNote		nAs4
	sNote		nB3
	sNote		nG3
	sNote		nA4
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nA3
	sNote		nFs3
	sNote		nDs4
	sNote		nA3
	sNote		nFs3
	sNote		nFs4
	sNote		nA3
	sNote		nFs3
	sNote		nF4
	sNote		nA3
	sNote		nF3
	sNote		nC5
	sNote		nA3
	sNote		nFs3
	sNote		nA4
	sNote		nA3
	sNote		nF3
	sNote		nDs5
	sNote		nA3
	sNote		nF3
	sNote		nC5
	sNote		nA3
	sNote		nF3

	sCall		$04, Stage72_Loop0A
	sNote		nB3
	sNote		nG3
	sNote		nE3
	sNote		nAs3
	sNote		nG3
	sNote		nE3
	sNote		nB3
	sNote		nG3
	sNote		nE3
	sNote		nE4
	sNote		nG3
	sNote		nE3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nA4
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nG3
	sNote		nE3
	sNote		nAs3
	sNote		nG3
	sNote		nE3
	sNote		nB3
	sNote		nG3
	sNote		nE3
	sNote		nE4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nD4
	sNote		nB3
	sNote		nG3
	sNote		nE4
	sNote		nB3
	sNote		nG3
	sNote		nB4
	sNote		nB3
	sNote		nG3
	sNote		nAs4
	sNote		nB3
	sNote		nG3
	sNote		nA4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sNote		nG4
	sNote		nB3
	sNote		nG3
	sNote		nDs4
	sNote		nB3
	sNote		nG3
	sNote		nFs4
	sNote		nB3
	sNote		nG3
	sJump		Stage72_Call01

Stage72_Loop0A:
	sNote		nB4
	sNote		nB3
	sNote		nG3
	sNote		nAs3
	sNote		nG3
	sNote		nE3
	sNote		nB3
	sNote		nG3
	sNote		nE3
	sNote		nFs3
	sNote		nE3
	sNote		nF3
	sNote		nG3
	sNote		nE3
	sNote		nG3
	sNote		nAs3
	sNote		nG3
	sNote		nAs3
	sNote		nB3
	sNote		nE3
	sNote		nFs3
	sNote		nG3
	sNote		nFs3
	sNote		nG3
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Stage72_FM2:
	sVoice		v00
	sPan		center
	sVol		$10
	sFrac		-$0C00

Stage72_FM2_00:
	sCall		$02, Stage72_FM2_01
	sCall		$04, Stage72_Loop03
	sCall		$04, Stage72_Loop04
	sCall		$04, Stage72_Loop05
	sCall		$04, Stage72_Loop06
	sCall		$04, Stage72_Loop07
	sCall		$04, Stage72_Loop03
	sCall		$03, Stage72_Loop07

	sNote		nC2, $30
	sNote		nE2, $60
	sNote		nDs2
	sJump		Stage72_FM2_00

Stage72_FM2_01:
	sNote		nE2, $B8
	sNote		$08
	sNote		nGs2, $B8
	sNote		$08
	sRet

Stage72_Loop03:
	sNote		nE2, $18
	sNote		nE3
	sRet

Stage72_Loop04:
	sNote		nDs2, $18
	sNote		nDs3
	sRet

Stage72_Loop05:
	sNote		nD2, $18
	sNote		nD3
	sRet

Stage72_Loop06:
	sNote		nCs2, $18
	sNote		nCs3
	sRet

Stage72_Loop07:
	sNote		nC2, $18
	sNote		nC3
	sRet


; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Stage72_FM6:
	sNote		nRst, $03
	sVoice		v02
	sPan		left
	sFrac		$000F
	sVol		$10
	sJump		Stage72_Call00

Stage72_FM3:
	sVoice		v02
	sPan		center
	sVol		$10

Stage72_Call00:
	sNote		nE3, $18
	sNote		nG3
	sNote		nAs3
	sNote		nB3
	sNote		nFs3
	sNote		nG3
	sNote		nDs3
	sNote		nFs3
	sNote		nE3, $18
	sNote		nDs3
	sNote		nFs3
	sNote		nF3
	sNote		nC4
	sNote		nA3
	sNote		nDs4
	sNote		nC4
	sNote		nB3, $18
	sNote		nAs3
	sNote		nA3
	sNote		nG3
	sNote		nFs3
	sNote		nG3
	sNote		nDs3
	sNote		nFs3
	sNote		nE3, $18
	sNote		nDs3
	sNote		nFs3
	sNote		nF3
	sNote		nC4
	sNote		nA3
	sNote		nDs4
	sNote		nC4

	sCall		$0F, Stage72_Loop00
	sNote		sHold, nB3, $06
	sVol		-$0F
	sCall		$03, Stage72_Loop01

	sNote		nRst, $18
	sNote		nG3
	sNote		nB3
	sNote		nAs3
	sNote		nB3
	sNote		nE4
	sNote		nDs4
	sNote		nG4
	sNote		nFs4
	sNote		nG4
	sNote		nB4
	sNote		nFs4
	sNote		nRst, $240
	sJump		Stage72_Call00

Stage72_Loop00:
	sNote		nB3, $06
	sVol		$01
	sRet

Stage72_Loop01:
	sNote		nRst, $18
	sNote		nG3
	sNote		nB3
	sNote		nAs3
	sNote		nG3, $60
	sRet

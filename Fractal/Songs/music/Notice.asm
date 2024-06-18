; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	StageClear2_Voice
	sHeaderSamples	StageClear2_Samples
	sHeaderVibrato	StageClear2_Vib
	sHeaderEnvelope	StageClear2_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FE
	sChannel	FM1, StageClear2_FM1
	sChannel	FM2, StageClear2_FM3
	sChannel	FM3, StageClear2_FM2
	sChannel	FM4, StageClear2_FM4
	sChannel	FM5, StageClear2_FM5
	sChannel	FM6, StageClear2_FM6
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

StageClear2_Voice:
	sNewVoice	v00
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $01, $02
	sMultiple	$04, $02, $04, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1A, $1A, $1A, $1A
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $04, $0C, $0D
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $04, $04
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2B, $16, $06, $0A
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$06
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $01, $01, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $0A, $07, $09
	sDecay2Rate	$00, $01, $01, $01
	sDecay1Level	$02, $03, $03, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $00, $00, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$01
	sDetune		$06, $02, $01, $05
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0B, $0B, $0B, $0B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $08, $08
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$22, $22, $04, $04
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

StageClear2_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

StageClear2_Vib:
	sVibrato FM1,		$21, $00, $1998, $0013, Triangle
	sVibrato FM5,		$11, $00, $0A3C, $002E, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

StageClear2_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

StageClear2_FM1:
	sNote		nRst, $02
	sVoice		v00
	sPan		center
	sVol		$10
	sVibratoSet	FM1

	sNote		nB3, $46
	sNote		nB4, $07
	sNote		$07
	sNote		nA4
	sNote		nA4
	sNote		nG4
	sNote		nG4
	sNote		nFs4
	sNote		nB3
	sNote		nFs4
	sNote		nB3
	sNote		nG4
	sNote		nB3
	sNote		nFs4
	sNote		nB3
	sNote		nA4
	sNote		nB3
	sNote		nA4
	sNote		nB3
	sNote		nG4
	sNote		nB3
	sNote		nFs4
	sNote		nG4
	sNote		nE4, $70
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

StageClear2_FM2:
	sVoice		v01
	sPan		center
	sVol		$13
	sVibratoSet	FM1

	sNote		nE2, $38
	sNote		nB2
	sNote		nFs2
	sNote		nB1
	sNote		nE2, $09
	sNote		nB1, $0A
	sNote		nE1, $5D
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

StageClear2_FM3:
	sVoice		v02
	sPan		center
	sVol		$10
	sVibratoSet	FM1

	sNote		nE3, $70
	sNote		nFs3, $1C
	sNote		$1C
	sNote		nA3
	sNote		nG3, $07
	sNote		nFs3
	sNote		nDs3
	sNote		nB2
	sNote		nE3, $70
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

StageClear2_FM4:
	sNote		nRst, $04
	sVoice		v00
	sPan		left
	sVol		$12
	sVibratoSet	FM1
	sFrac		$000B

	sNote		nB3, $46
	sNote		nB4, $07
	sNote		$07
	sNote		nA4
	sNote		nA4
	sNote		nG4
	sNote		nG4
	sNote		nFs4
	sNote		nB3
	sNote		nFs4
	sNote		nB3
	sNote		nG4
	sNote		nB3
	sNote		nFs4
	sNote		nB3
	sNote		nA4
	sNote		nB3
	sNote		nA4
	sNote		nB3
	sNote		nG4
	sNote		nB3
	sNote		nFs4
	sNote		nG4
	sNote		nE4, $70
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

StageClear2_FM5:
	sNote		nRst, $0C
	sVoice		v02
	sPan		center
	sVol		$15
	sVibratoSet	FM5
	sFrac		$0020

	sNote		nE3, $70
	sNote		nFs3, $1C
	sNote		$1C
	sNote		nA3
	sNote		nG3, $07
	sNote		nFs3
	sNote		nDs3
	sNote		nB2
	sNote		nE3, $70
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM6 data
; ---------------------------------------------------------------------------

StageClear2_FM6:
	sNote		nRst, $05
	sVoice		v00
	sPan		right
	sVol		$12
	sVibratoSet	FM1
	sFrac		-$001C

	sNote		nB3, $46
	sNote		nB4, $07
	sNote		$07
	sNote		nA4
	sNote		nA4
	sNote		nG4
	sNote		nG4
	sNote		nFs4
	sNote		nB3
	sNote		nFs4
	sNote		nB3
	sNote		nG4
	sNote		nB3
	sNote		nFs4
	sNote		nB3
	sNote		nA4
	sNote		nB3
	sNote		nA4
	sNote		nB3
	sNote		nG4
	sNote		nB3
	sNote		nFs4
	sNote		nG4
	sNote		nE4, $70
	sStop

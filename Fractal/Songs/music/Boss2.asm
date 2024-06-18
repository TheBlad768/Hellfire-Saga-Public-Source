; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Options_Voice
	sHeaderSamples	Options_Samples
	sHeaderVibrato	Options_Vib
	sHeaderEnvelope	Options_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FE
	sChannel	FM1, Options_FM1
	sChannel	FM2, Options_FM3
	sChannel	FM3, Options_FM2
	sChannel	FM4, Options_FM4
	sChannel	FM5, Options_FM5
	sChannel	FM6, Options_FM6
	sChannel	PSG1, Options_PSG1
	sChannel	PSG2, Options_PSG2
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Options_Voice:
	sNewVoice	v00
	sAlgorithm	$06
	sFeedback	$07
	sDetune		$05, $05, $00, $03
	sMultiple	$07, $01, $02, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$17, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $01, $02, $01
	sDecay2Rate	$00, $01, $01, $01
	sDecay1Level	$06, $01, $01, $01
	sReleaseRate	$05, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $00, $0A, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$03
	sFeedback	$04
	sDetune		$03, $05, $03, $05
	sMultiple	$00, $01, $00, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$17, $17, $17, $17
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $03, $03, $07
	sDecay2Rate	$04, $02, $04, $00
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$18, $18, $18, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$04
	sDetune		$03, $05, $05, $03
	sMultiple	$08, $06, $08, $06
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0B, $0B, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0B, $07
	sDecay2Rate	$08, $08, $00, $00
	sDecay1Level	$08, $08, $01, $01
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$20, $20, $00, $00
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $00, $00, $00
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$13, $0F, $0F, $17
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$06, $17, $0B, $0B
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $00
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $1E, $20, $00
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$04
	sFeedback	$04
	sDetune		$03, $05, $05, $03
	sMultiple	$08, $06, $08, $06
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0B, $0B, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0B, $07
	sDecay2Rate	$08, $08, $00, $00
	sDecay1Level	$01, $01, $01, $00
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$20, $20, $00, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Options_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Options_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Options_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Options_FM1:
	sVoice		v00
	sVol		$19
	sPan		left

Options_FM1_00:
	sNote		nD4, $04
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nC4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nC4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nC4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nC4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $04
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $04
	sNote		nRst, $03
	sNote		nC4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nC4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nC4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nC4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sVol		$01
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $04
	sNote		nRst, $03
	sVol		$01
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sVol		$01
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sVol		$01
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sVol		$01
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nA4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $03
	sVol		$01
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4
	sNote		sHold, $03
	sNote		nRst, $03
	sVol		$01
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nD4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4
	sNote		sHold, $03
	sNote		nRst
	sNote		nA4, $05
	sNote		nRst, $02
	sVol		$01
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sVol		$01
	sNote		nA4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nA4, $04
	sNote		nRst, $03
	sVol		-$09

	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nCs4, $04
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nFs4, $04
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nE4, $04
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nDs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst

	sVol		$01
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sVol		$01
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $03
	sVol		$01
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sVol		$01
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sVol		$01
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sVol		$01
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nF4, $04
	sNote		nRst, $03
	sVol		$01
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nDs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sVol		$01
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst
	sVol		$01
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sVol		-$09

	sNote		nD4, $01
	sJump		Options_FM1_00

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Options_FM2:
	sVoice		v01
	sVol		$0E
	sPan		center

Options_FM2_00:
	sNote		nD2, $59
	sNote		sHold, $57
	sNote		nRst, $02
	sNote		nC2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nD2, $5A
	sNote		sHold, $57
	sNote		nRst, $02

	sCall		$02, Options_Loop14
	sNote		nC2, $5A
	sNote		sHold, $57
	sNote		nRst, $02
	sNote		nD2, $26
	sVol		$01
	sNote		sHold, $25
	sVol		$01
	sNote		sHold, nD2
	sVol		$01
	sNote		sHold, $26
	sVol		$01
	sNote		sHold, $1B
	sNote		nRst, $03
	sNote		sHold, nD2, $07
	sVol		$01
	sNote		sHold, $26
	sVol		$01
	sNote		sHold, $25
	sVol		$01
	sNote		sHold, $25
	sVol		$01
	sNote		sHold, $26
	sVol		$01
	sNote		sHold, $14
	sNote		nRst, $02
	sVol		-$05
	sNote		nDs2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nCs2, $59

	sCall		$02, Options_Loop15
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nDs2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nCs2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nDs2, $25

	sVol		$01
	sNote		sHold, nDs2
	sVol		$01
	sNote		sHold, $26
	sVol		$01
	sNote		sHold, $25
	sVol		$01
	sNote		sHold, $1B
	sNote		nRst, $03
	sNote		sHold, nDs2, $07
	sVol		$01
	sNote		sHold, $26
	sVol		$01
	sNote		sHold, $25
	sVol		$01
	sNote		sHold, $25
	sVol		$01
	sNote		sHold, $26
	sVol		$01
	sNote		sHold, $14
	sNote		nRst, $03

	sVoice		v00
	sVol		-$0D
	sJump		Options_FM2_00

Options_Loop14:
	sNote		nC2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nD2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sRet

Options_Loop15:
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nDs2, $5A
	sNote		sHold, $57
	sNote		nRst, $02
	sNote		nCs2, $5A
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Options_FM3:
	sVoice		v02
	sVol		$16
	sPan		center

Options_FM3_00:
	sNote		nD2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nC2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nD2, $5A
	sNote		sHold, $57
	sNote		nRst, $02
	sNote		nC2, $5A
	sNote		sHold, $57
	sNote		nRst, $03

	sVoice		v03
	sVol		-$04
	sNote		nD3, $57
	sNote		nRst, $03
	sNote		nE3, $2A
	sNote		nRst, $02
	sNote		nF3, $2A
	sNote		nRst, $03
	sNote		nDs3, $57
	sNote		nRst, $03
	sNote		nC3, $57
	sNote		nRst, $03
	sNote		nD3, $57
	sNote		nRst, $02
	sNote		nE3, $2A
	sNote		nRst, $03
	sNote		nF3, $2A
	sNote		nRst, $03
	sNote		nDs3, $57
	sNote		nRst, $03
	sNote		nC3, $2A
	sNote		nRst, $03
	sNote		nDs3, $0C
	sNote		nRst, $02
	sNote		nD3, $0D
	sNote		nRst, $02
	sNote		nC3, $0D
	sNote		nRst, $03
	sNote		nD3, $18

	sCall		$08, Options_Loop11
	sVol		$01
	sNote		sHold, $18
	sCall		$04, Options_Loop11
	sVol		$01
	sNote		sHold, $08
	sNote		nRst, $03

	sVoice		v02
	sVol		-$0A
	sNote		nDs2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nCs2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nDs2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nCs2, $59
	sNote		sHold, $57
	sNote		nRst, $03

	sVoice		v03
	sVol		-$04
	sNote		nDs3, $57
	sNote		nRst, $03
	sNote		nF3, $2A
	sNote		nRst, $02
	sNote		nFs3, $2B
	sNote		nRst, $02
	sNote		nE3, $57
	sNote		nRst, $03
	sNote		nCs3, $57
	sNote		nRst, $03
	sNote		nDs3, $57
	sNote		nRst, $03
	sNote		nF3, $2A
	sNote		nRst, $02
	sNote		nFs3, $2A
	sNote		nRst, $03
	sNote		nE3, $57
	sNote		nRst, $03
	sNote		nGs3, $23
	sNote		nRst, $02
	sNote		nA3, $03
	sNote		nRst, $01
	sNote		nAs3, $02
	sNote		nRst
	sNote		nB3, $2A
	sNote		nRst, $03
	sNote		nAs3, $18

	sCall		$0B, Options_Loop11
	sVol		$01
	sNote		sHold, $18
	sVol		$01
	sNote		sHold, $19
	sVol		$01
	sNote		sHold, $08
	sNote		nRst, $03

	sVoice		v00
	sVol		-$0A
	sJump		Options_FM3_00

Options_Loop11:
	sVol		$01
	sNote		sHold, $19
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Options_FM4:
	sVoice		v02
	sVol		$14
	sPan		center

Options_FM4_00:
	sNote		nRst, $0A

	sFrac		$001D		; ssDetune $05
	sNote		nD2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nC2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sNote		nD2, $5A
	sNote		sHold, $57
	sNote		nRst, $02
	sNote		nC2, $5A
	sNote		sHold, $57
	sNote		nRst, $03

	sVoice		v03
	sVol		-$04
	sNote		nD3, $57
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nE3, $2A
	sNote		nRst, $02
	sNote		nF3, $2B
	sNote		nRst, $02
	sNote		nDs3, $57
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $05
	sNote		nC3, $57
	sNote		nRst, $03
	sNote		nD3, $57
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nE3, $2B
	sNote		nRst, $02
	sNote		nF3, $2A
	sNote		nRst, $03
	sNote		nDs3, $57
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $05
	sNote		nC3, $2A
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $06
	sNote		nDs3, $0C
	sNote		nRst, $03
	sFrac		-$0005		; ssDetune $05
	sNote		nD3, $0C
	sNote		nRst, $03
	sNote		nC3, $0C
	sNote		nRst, $03
	sNote		nD3, $18

	sCall		$0B, Options_Loop11
	sVol		$01
	sNote		sHold, $18
	sVol		$01
	sNote		sHold, $19
	sVol		$01
	sNote		sHold, $08

	sNote		nRst, $03
	sVoice		v02
	sVol		-$0A

	sFrac		$0005		; ssDetune $06
	sNote		nDs2, $59
	sNote		sHold, $57
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $05
	sNote		nCs2, $59
	sNote		sHold, $58
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs2, $5A
	sNote		sHold, $57
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $05
	sNote		nCs2, $59
	sNote		sHold, $57

	sNote		nRst, $03
	sVoice		v03
	sVol		-$04

	sFrac		$0003		; ssDetune $06
	sNote		nDs3, $57
	sNote		nRst, $03
	sNote		nF3, $2A
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $07
	sNote		nFs3, $2A
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE3, $58
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $05
	sNote		nCs3, $57
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs3, $57
	sNote		nRst, $03
	sNote		nF3, $2A
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $07
	sNote		nFs3, $2B
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE3, $57
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs3, $23
	sNote		nRst, $02
	sNote		nA3, $03
	sNote		nRst, $01
	sFrac		-$0003		; ssDetune $09
	sNote		nAs3, $02
	sNote		nRst
	sNote		nB3, $2A
	sNote		nRst, $03
	sNote		nAs3, $19

	sVol		$01
	sNote		sHold, nAs3
	sVol		$01
	sNote		sHold, $18

	sCall		$0A, Options_Loop11
	sVol		$01
	sNote		sHold, $18
	sFrac		-$0020		; ssDetune $00

	sVoice		v00
	sVol		-$09
	sJump		Options_FM4_00

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Options_FM5:
	sVoice		v00
	sVol		$19
	sPan		right

Options_FM5_00:
	sFrac		-$0012		; ssDetune $FD
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $04
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0011		; ssDetune $00

	sNote		nC4, $04
	sNote		nRst, $03
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$000D		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05

	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nD4, $05

	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $04
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $04
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0011		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$000D		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05

	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05

	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $04
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0011		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nF4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$000D		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $02
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05

	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05

	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $04
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $04
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0011		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nG4, $04
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$000D		; ssDetune $00

	sNote		nC4, $05
	sNote		nRst, $02
	sFrac		-$000D		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nF4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nDs4, $05
	sNote		nRst, $02
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $04
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $04
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $04
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0006		; ssDetune $FE
	sNote		nE4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $04
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03

	sVol		$01
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FD
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nF4, $04
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0001		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $04
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nA4, $05
	sNote		nRst, $02

	sVol		-$09
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $04
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05

	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05

	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $04
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $FE
	sNote		nCs4, $04
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $04
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05

	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05

	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $04
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $04
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05

	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05

	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $04
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $FE
	sNote		nCs4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FE
	sNote		nE4, $05

	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0006		; ssDetune $FC
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		$0006		; ssDetune $FD
	sNote		nDs4, $05

	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4
	sNote		sHold, $03
	sNote		nRst, $03

	sVol		$01
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sNote		nGs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nAs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02

	sVol		$01
	sNote		nGs4, $05
	sNote		nRst, $03
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $FD
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $FC
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03

	sVol		$01
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sNote		nGs4, $05
	sNote		nRst, $02
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nFs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		-$0001		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $FD
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $FC
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0010		; ssDetune $00

	sVoice		v00
	sVol		-$09
	sJump		Options_FM5_00

; ===========================================================================
; ---------------------------------------------------------------------------
; FM6 data
; ---------------------------------------------------------------------------

Options_FM6:
	sVol		$23

Options_FM6_00:
	sNote		nRst, $0A
	sVoice		v00
	sPan		center

	sFrac		$001D		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $03
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00
	sNote		nRst, $03
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $04
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $05
	sNote		nC4, $04
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $04
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $02
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00
	sNote		nRst, $02
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $02
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00
	sNote		nRst, $02
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $05
	sNote		nC4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $02
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00
	sNote		nRst, $02
	sFrac		$001F		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $05
	sNote		nD4, $05
	sFrac		-$001D		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $04
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $04
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0000		; ssDetune $06
	sNote		nE4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $05
	sNote		nD4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4
	sNote		sHold, $03
	sNote		nRst

	sVol		$01
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $04
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0000		; ssDetune $08
	sNote		nA4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $05
	sNote		nD4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $07
	sNote		nG4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0002		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $06
	sNote		nE4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $08
	sNote		nA4, $05
	sNote		nRst, $03

	sVol		-$09
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $04
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $05
	sNote		nCs4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $06
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $05
	sNote		nCs4, $04
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sFrac		-$0020		; ssDetune $00

	sNote		nRst, $03
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00
	sNote		nRst, $03
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $03
	sFrac		$0020		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $05
	sNote		nCs4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $05
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sFrac		-$0020		; ssDetune $00

	sNote		nRst, $03
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00
	sNote		nRst, $03
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $04
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $05
	sNote		nCs4, $04
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0004		; ssDetune $05
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sFrac		-$0020		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00
	sNote		nRst, $02
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $05
	sNote		nCs4, $05
	sNote		nRst, $03
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0004		; ssDetune $05
	sNote		nCs4, $05
	sNote		nRst, $02
	sFrac		$0004		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		$0001		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $06
	sNote		nE4, $05
	sFrac		-$0020		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00
	sNote		nRst, $02
	sFrac		$0023		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0001		; ssDetune $06
	sNote		nDs4, $05
	sFrac		-$0022		; ssDetune $00

	sNote		nRst, $02
	sFrac		$0020		; ssDetune $09
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $04
	sNote		nRst, $03

	sVol		$01
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0003		; ssDetune $08
	sNote		nGs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0000		; ssDetune $07
	sNote		nFs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $03

	sVol		$01
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $03
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02

	sVol		$01
	sNote		sHold, $01
	sFrac		$0002		; ssDetune $09
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0002		; ssDetune $06
	sNote		nDs4, $05
	sNote		nRst, $02
	sFrac		-$0002		; ssDetune $09
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $05
	sNote		nRst, $02
	sFrac		$0002		; ssDetune $09
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03

	sVol		$01
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02
	sFrac		$0000		; ssDetune $09
	sNote		nAs4
	sNote		sHold, $03
	sNote		nRst, $03
	sFrac		$0003		; ssDetune $08
	sNote		nGs4, $05
	sNote		nRst, $02
	sFrac		-$0003		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		$0000		; ssDetune $07
	sNote		nFs4, $05
	sNote		nRst, $02

	sVol		$01
	sFrac		$0000		; ssDetune $09
	sNote		nAs4, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $06
	sNote		nF4, $04
	sFrac		-$001E		; ssDetune $00

	sVol		-$09
	sJump		Options_FM6_00

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Options_PSG1:
	sVol		$38
	sFrac		$0C00

Options_PSG1_00:
	sFrac		$0005		; ssDetune $01
	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sNote		nCut, $03
	sVol		$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sFrac		$0008		; ssDetune $02
	sNote		nC1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nC1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sFrac		-$0008		; ssDetune $01
	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sFrac		$0008		; ssDetune $02
	sNote		nC1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $04
	sNote		nC1, $07
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sFrac		-$0008		; ssDetune $01
	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $02
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sFrac		$0008		; ssDetune $02
	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $04
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sFrac		-$0008		; ssDetune $01
	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sFrac		$0008		; ssDetune $02
	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nC1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nC1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nC1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sNote		nC1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nC1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sFrac		-$0008		; ssDetune $01
	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $03
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$03
	sNote		nCut, $02
	sNote		nD1, $07
	sVol		$08
	sNote		$06
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sVol		-$18

	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sNote		nD1, $04
	sVol		$08
	sNote		$05
	sVol		$08
	sNote		$03
	sNote		nCut, $02
	sVol		-$10
	sNote		nD1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $07
	sVol		$08
	sNote		$06
	sNote		nCut, $02
	sVol		$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nD1, $05
	sVol		$08
	sNote		$04
	sVol		$08
	sNote		$03
	sNote		nCut
	sNote		nD1, $06
	sVol		$08
	sNote		nD1
	sNote		nCut, $03
	sVol		-$08
	sNote		nD1, $06
	sVol		$08
	sNote		nD1
	sNote		nCut, $03
	sVol		-$10
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sNote		nD1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sVol		-$10
	sNote		nD1, $05
	sVol		$08
	sNote		nD1
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $06
	sVol		$08
	sNote		nD1
	sNote		nCut, $03
	sNote		nD1
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nCut
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nD1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nD1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nD1, $07
	sVol		$08
	sNote		$06
	sNote		nCut, $03
	sVol		-$28

	sNote		nDs1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nCs1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sNote		nCs1, $07
	sVol		$08
	sNote		$04
	sNote		nCut
	sVol		-$08
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $02
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut
	sVol		-$08
	sNote		nCs1, $07
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nCs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nCs1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nCs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nCs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nCut
	sNote		nDs1, $06
	sVol		$08
	sNote		nDs1
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sNote		nDs1, $04
	sVol		$08
	sNote		$05
	sVol		$08
	sNote		$03
	sNote		nCut
	sVol		-$10
	sNote		nDs1
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $07
	sVol		$08
	sNote		$06
	sNote		nCut, $02
	sVol		$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$05
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $05
	sVol		$08
	sNote		$04
	sVol		$08
	sNote		nDs1
	sNote		nCut, $02
	sNote		nDs1, $06
	sVol		$08
	sNote		nDs1
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $06
	sVol		$08
	sNote		nDs1
	sNote		nCut, $03
	sVol		-$10
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sNote		nDs1, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nCut
	sVol		-$10
	sNote		nDs1, $05
	sVol		$08
	sNote		nDs1
	sVol		$08
	sNote		$03
	sNote		nCut, $02
	sVol		-$18

	sNote		nDs1, $06
	sVol		$08
	sNote		nDs1
	sNote		nCut, $03
	sNote		nDs1
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nCut
	sVol		-$08
	sNote		nDs1, $08
	sVol		$08
	sNote		$04
	sNote		nCut, $03
	sVol		-$18

	sNote		nDs1, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nCut, $03
	sNote		nDs1, $07
	sVol		$08
	sNote		$05
	sNote		nCut, $03
	sVol		-$08
	sNote		nDs1, $06
	sVol		$08
	sNote		nDs1
	sVol		-$28

	sFrac		-$0005		; ssDetune $00
	sNote		nCut, $03
	sJump		Options_PSG1_00

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Options_PSG2:
	sVol		$38
	sFrac		$0C00

Options_PSG2_00:
	sFrac		$000C		; ssDetune $03
	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sNote		nRst, $03
	sVol		$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nG0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nG0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nG0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $04
	sNote		nG0, $07
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst, $03
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $02
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $04
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nG0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nG0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst, $03
	sNote		nG0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nG0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nRst, $02
	sNote		nA0, $07
	sVol		$08
	sNote		$06
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sVol		-$18

	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sNote		nA0, $04
	sVol		$08
	sNote		$05
	sVol		$08
	sNote		$03
	sNote		nRst, $02
	sVol		-$10
	sNote		nA0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $07
	sVol		$08
	sNote		$06
	sNote		nRst, $02
	sVol		$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nA0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $05
	sVol		$08
	sNote		$04
	sVol		$08
	sNote		$03
	sNote		nRst
	sNote		nA0, $06
	sVol		$08
	sNote		nA0
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $06
	sVol		$08
	sNote		nA0
	sNote		nRst, $03
	sVol		-$10
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sNote		nA0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sVol		-$10
	sNote		nA0, $05
	sVol		$08
	sNote		nA0
	sVol		$08
	sNote		$03
	sNote		nRst, $02
	sVol		-$18

	sNote		nA0, $06
	sVol		$08
	sNote		nA0
	sNote		nRst, $03
	sNote		nA0
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nRst
	sVol		-$08
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nA0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nA0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nA0, $06
	sVol		$08
	sNote		nA0
	sNote		nRst, $03
	sVol		-$28

	sFrac		-$0005		; ssDetune $02
	sNote		nAs0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sFrac		$0006		; ssDetune $03
	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nGs0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sFrac		-$0006		; ssDetune $02
	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst, $03
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sFrac		$0006		; ssDetune $03
	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst, $03
	sNote		nGs0, $08
	sVol		$08
	sNote		$03
	sNote		nRst, $04
	sVol		-$08
	sNote		nGs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sFrac		-$0006		; ssDetune $02
	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sFrac		$0006		; ssDetune $03
	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sFrac		-$0006		; ssDetune $02
	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst, $03
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $02
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sFrac		$0006		; ssDetune $03
	sNote		nGs0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst
	sVol		-$08
	sNote		nGs0, $07
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nGs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nGs0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nGs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nGs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sFrac		-$0006		; ssDetune $02
	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nRst
	sNote		nAs0, $06
	sVol		$08
	sNote		nAs0
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $04
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sNote		nAs0, $04
	sVol		$08
	sNote		$05
	sVol		$08
	sNote		$03
	sNote		nRst
	sVol		-$10
	sNote		nAs0
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $07
	sVol		$08
	sNote		$06
	sNote		nRst, $02
	sVol		$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$05
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $05
	sVol		$08
	sNote		$04
	sVol		$08
	sNote		nAs0
	sNote		nRst, $02
	sNote		nAs0, $06
	sVol		$08
	sNote		nAs0
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $06
	sVol		$08
	sNote		nAs0
	sNote		nRst, $03
	sVol		-$10
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sNote		nAs0, $05
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$02
	sNote		nRst
	sVol		-$10
	sNote		nAs0, $05
	sVol		$08
	sNote		nAs0
	sVol		$08
	sNote		$03
	sNote		nRst, $02
	sVol		-$18

	sNote		nAs0, $06
	sVol		$08
	sNote		$07
	sNote		nRst, $02
	sNote		nAs0, $03
	sVol		$08
	sNote		$06
	sVol		$08
	sNote		$03
	sNote		nRst
	sVol		-$08
	sNote		nAs0, $08
	sVol		$08
	sNote		$04
	sNote		nRst, $03
	sVol		-$18

	sNote		nAs0, $04
	sVol		$08
	sNote		$07
	sVol		$08
	sNote		$01
	sNote		nRst, $03
	sNote		nAs0, $07
	sVol		$08
	sNote		$05
	sNote		nRst, $03
	sVol		-$08
	sNote		nAs0, $06
	sVol		$08
	sNote		nAs0
	sVol		-$28

	sFrac		-$0007		; ssDetune $00
	sNote		nRst, $03
	sJump		Options_PSG2_00

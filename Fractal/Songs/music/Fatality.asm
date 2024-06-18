; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Snd_FatalityUMK3_Voice
	sHeaderSamples	Snd_FatalityUMK3_Samples
	sHeaderVibrato	Snd_FatalityUMK3_Vib
	sHeaderEnvelope	Snd_FatalityUMK3_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$56
	sChannel	FM1, Snd_FatalityUMK3_FM1
	sChannel	FM2, Snd_FatalityUMK3_FM3
	sChannel	FM3, Snd_FatalityUMK3_FM2
	sChannel	FM4, Snd_FatalityUMK3_FM4
	sChannel	FM5, Snd_FatalityUMK3_FM5
	sChannel	PSG1, Snd_FatalityUMK3_PSG1
	sChannel	PSG2, Snd_FatalityUMK3_PSG2
	sChannelEnd

	sSong		music index=$01 flags= tempo=$56
	sChannel	FM1, Snd_FatalityEndUMK3_FM1
	sChannel	FM2, Snd_FatalityEndUMK3_FM3
	sChannel	FM3, Snd_FatalityEndUMK3_FM2
	sChannel	FM4, Snd_FatalityEndUMK3_FM4
	sChannel	PSG1, Snd_FatalityEndUMK3_PSG1
	sChannel	PSG2, Snd_FatalityEndUMK3_PSG2
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_Voice:
	sNewVoice	v00
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$07, $07, $03, $04
	sMultiple	$01, $01, $01, $01
	sRateScale	$01, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $1F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$09, $00, $09, $00
	sReleaseRate	$08, $09, $0A, $0C
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $1A, $1B, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$02, $02, $03, $03
	sMultiple	$01, $00, $01, $02
	sRateScale	$02, $02, $02, $02
	sAttackRate	$0F, $0C, $1B, $14
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$01, $00, $05, $02
	sDecay2Rate	$00, $02, $00, $00
	sDecay1Level	$01, $01, $04, $03
	sReleaseRate	$05, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$15, $1E, $13, $07
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$04
	sDetune		$07, $03, $03, $07
	sMultiple	$0D, $0D, $05, $05
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$01, $01, $0D, $0D
	sDecay2Rate	$10, $10, $12, $12
	sDecay1Level	$0F, $0F, $03, $03
	sReleaseRate	$05, $05, $08, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $13, $13
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$07
	sFeedback	$02
	sDetune		$01, $06, $07, $07
	sMultiple	$01, $01, $01, $01
	sRateScale	$03, $00, $00, $00
	sAttackRate	$11, $19, $1D, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $00, $00, $0F
	sDecay2Rate	$08, $1F, $18, $1F
	sDecay1Level	$00, $00, $00, $09
	sReleaseRate	$06, $0F, $0F, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$02, $04, $00, $00
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $07, $04, $04
	sMultiple	$01, $03, $02, $02
	sRateScale	$01, $01, $01, $01
	sAttackRate	$1D, $1D, $1D, $0B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $1F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$02, $03, $03, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$22, $27, $1F, $0A
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_FM1:
	sVol		$0C
	sVoice		v00
	sPan		center
	sNote		nC1, $02
	sNote		nRst, $01
	sNote		nFs1, $02
	sNote		nRst, $01
	sNote		nDs1, $1E
	sStop

Snd_FatalityEndUMK3_FM1:
	sVol		$0C
	sVoice		v00
	sPan		center
	sNote		nA1, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_FM2:
	sVol		$11
	sVoice		v01
	sPan		center
	sNote		nC3, $02
	sNote		nRst, $01
	sNote		nFs3, $02
	sNote		nRst, $01
	sNote		nDs3, $1E
	sStop

Snd_FatalityEndUMK3_FM2:
	sVol		$11
	sVoice		v01
	sPan		center
	sNote		nA2, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_FM3:
	sVol		$0C
	sVoice		v02
	sPan		center
	sNote		nC1, $03
	sNote		nFs1
	sNote		nDs1, $06
	sStop

Snd_FatalityEndUMK3_FM3:
	sVol		$0C
	sVoice		v02
	sPan		center
	sNote		nA0, $0C
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_FM4:
	sVol		$1E
	sVoice		v03
	sPan		center
	sNote		nC3, $03
	sNote		nFs2
	sNote		nC3, $01
	sVol		$02
	sNote		sHold, $01
	sNote		$01
	sVol		$0F
	sNote		sHold, $01
	sNote		$02
	sNote		$02
	sNote		$01
	sNote		$02
	sVol		-$02
	sNote		$01
	sNote		$02
	sVol		-$02
	sNote		$01
	sNote		$01
	sVol		-$02
	sNote		sHold, $01
	sNote		$01
	sVol		-$02
	sNote		$02
	sVol		-$02
	sNote		$01
	sNote		$02
	sVol		-$02
	sNote		$01
	sNote		$01
	sVol		-$03
	sNote		sHold, $01
	sNote		$01
	sVol		-$05
	sNote		$02
	sNote		$01
	sStop

Snd_FatalityEndUMK3_FM4:
	sVol		$1B
	sVoice		v03
	sPan		center
	sNote		nA2, $02
	sNote		$02
	sNote		$01
	sVol		$05
	sNote		sHold, $01
	sNote		$01
	sVol		$05
	sNote		sHold, $01
	sVol		$05

	sCall		$06, Snd_FatalityEndUMK3_Loop00
	sCall		$02, Snd_FatalityEndUMK3_Loop01

	sNote		$01
	sNote		$02
	sNote		$01
	sStop

Snd_FatalityEndUMK3_Loop00:
	sNote		$01
	sNote		$02
	sRet

Snd_FatalityEndUMK3_Loop01:
	sNote		$01
	sNote		$01
	sVol		-$02
	sNote		sHold, $01
	sNote		$01
	sVol		-$02
	sNote		$02
	sVol		-$02
	sNote		$01
	sNote		$02
	sVol		-$02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_FM5:
	sVol		$2F
	sVoice		v04
	sPan		center
	sNote		nC5, $02
	sNote		nRst, $01
	sNote		nFs5, $02
	sNote		nRst, $01
	sNote		nC7, $02
	sNote		$01
	sNote		$02
	sNote		$01

	sCall		$03, Snd_FatalityUMK3_Loop00
	sNote		$02
	sVol		-$01
	sNote		$01
	sVol		-$01
	sNote		$02
	sVol		-$01
	sNote		$01
	sStop

Snd_FatalityUMK3_Loop00:
	sNote		$02
	sVol		-$01
	sNote		$01
	sVol		-$01
	sNote		$02
	sVol		-$01
	sNote		$01
	sVol		-$02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_PSG1:
	sVol		$08
	sNote		nC1, $02
	sNote		nCut, $01
	sNote		nFs1, $02
	sNote		nCut, $01
	sNote		nDs1, $1E
	sStop

Snd_FatalityEndUMK3_PSG1:
	sVol		$18
	sNote		nA1, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Snd_FatalityUMK3_PSG2:
	sNote		nCut, $02
	sVol		$18
	sFrac		-$0007		; ssDetune $FE
	sNote		nC1
	sNote		nCut, $01
	sNote		nFs1, $02
	sNote		nCut, $01
	sNote		nDs1, $1E
	sStop

Snd_FatalityEndUMK3_PSG2:
	sNote		nCut, $02
	sVol		$38
	sFrac		-$0004		; ssDetune $FF
	sNote		nA1, $30
	sStop


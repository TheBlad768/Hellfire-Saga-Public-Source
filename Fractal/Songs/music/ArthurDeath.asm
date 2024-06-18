; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Snd_GameOver_Voice
	sHeaderSamples	Snd_GameOver_Samples
	sHeaderVibrato	Snd_GameOver_Vib
	sHeaderEnvelope	Snd_GameOver_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FE
	sChannel	FM1, Snd_GameOver_FM1
	sChannel	FM2, Snd_GameOver_FM3
	sChannel	FM3, Snd_GameOver_FM2
	sChannel	FM4, Snd_GameOver_FM5
	sChannel	FM5, Snd_GameOver_FM4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Snd_GameOver_Voice:
	sNewVoice	v00
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$06, $01, $00, $00
	sMultiple	$0A, $01, $0A, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$14, $0F, $14, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $02, $08, $08
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0A, $01, $01, $01
	sReleaseRate	$06, $06, $06, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $28, $2D, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0E, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $00, $00, $00
	sReleaseRate	$03, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1D, $00, $00, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Snd_GameOver_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Snd_GameOver_Vib:
	sVibrato FM1,		$00, $00, $2000, $0094, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Snd_GameOver_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Snd_GameOver_FM1:
	sVoice		v00
	sVol		$07
	sPan		center
	sNote		nC4, $02
	sNote		nRst
	sNote		nC4, $03
	sNote		nRst, $01
	sVol		$02
	sNote		nC4, $06
	sNote		nRst, $03
	sNote		nE4, $06
	sNote		nRst, $02
	sNote		nDs4, $06
	sNote		nRst, $03
	sNote		nB3, $06
	sNote		nRst, $03
	sNote		nD4, $11
	sVibratoSet	FM1
	sNote		sHold, $34
	sVibratoOff
	sNote		sHold, $09
	sNote		sHold, nCs4, $01
	sVol		$01
	sNote		sHold, nC4, $02
	sVol		$01
	sNote		sHold, nB3, $01
	sVol		$01
	sNote		sHold, nAs3, $02
	sNote		nRst
	sVol		$09
	sNote		nD4, $09
	sNote		sHold, nCs4, $02
	sVol		$01
	sNote		sHold, nC4, $01
	sVol		$01
	sNote		sHold, nB3
	sVol		$01
	sNote		sHold, nAs3, $02
	sNote		nRst, $03
	sVol		$09
	sNote		nD4, $08
	sNote		sHold, nCs4, $02
	sVol		$01
	sNote		sHold, nC4, $01
	sVol		$01
	sNote		sHold, nB3, $02
	sVol		$01
	sNote		sHold, nAs3, $01
	sNote		nRst, $03
	sVol		$09
	sNote		nD4, $09
	sNote		sHold, nCs4, $01
	sVol		$01
	sNote		sHold, nC4
	sVol		$01
	sNote		sHold, nB3, $02
	sVol		$01
	sNote		sHold, nAs3, $01
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Snd_GameOver_FM2:
	sVoice		v00
	sVol		$0D
	sPan		center
	sNote		nC4, $05
	sNote		nRst, $03
	sNote		nC4
	sNote		nRst, $01
	sNote		nC4, $03
	sNote		nRst, $02
	sVol		$02
	sNote		nC4, $06
	sNote		nRst, $03
	sFrac		-$000B		; ssDetune $FE
	sNote		nE4, $05
	sNote		nRst, $04
	sNote		nDs4, $05
	sNote		nRst, $03
	sFrac		$0001		; ssDetune $FD
	sNote		nB3, $05
	sNote		nRst, $03
	sFrac		-$0002		; ssDetune $FE
	sNote		nD4, $4E
	sNote		sHold, nCs4, $02
	sVol		$01
	sFrac		$000C		; ssDetune $00
	sNote		sHold, nC4, $01
	sVol		$01
	sFrac		-$000A		; ssDetune $FD
	sNote		sHold, nB3, $02
	sFrac		$000A		; ssDetune $0

	sCall		$02, Snd_GameOver_Loop02
	sVol		$01
	sFrac		-$0008		; ssDetune $FE
	sNote		sHold, nAs3, $02
	sStop

Snd_GameOver_Loop02:
	sVol		$01
	sFrac		-$0008		; ssDetune $FE
	sNote		sHold, nAs3, $01
	sNote		nRst, $03
	sVol		$09
	sNote		nD4, $09
	sNote		sHold, nCs4, $01
	sVol		$01
	sFrac		$0008		; ssDetune $00
	sNote		sHold, nC4, $02
	sVol		$01
	sFrac		-$000A		; ssDetune $FD
	sNote		sHold, nB3, $01
	sFrac		$000A		; ssDetune $00
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Snd_GameOver_FM3:
	sVoice		v00
	sVol		$19
	sPan		left
	sNote		nFs6, $29
	sVol		$05
	sNote		nRst, $02
	sVol		-$05
	sNote		nF6, $7A
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Snd_GameOver_FM4:
	sVoice		v00
	sVol		$19
	sPan		left
	sNote		nC5, $29
	sVol		$05
	sNote		nRst, $02
	sVol		-$05
	sNote		nB4, $7A
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Snd_GameOver_FM5:
	sVoice		v01
	sVol		$14
	sPan		center
	sNote		nC3, $2B
	sVol		$07
	sNote		sHold, $45
	sVol		$05
	sNote		sHold, $3D
	sStop

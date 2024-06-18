; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Special_Voice
	sHeaderSamples	Special_Samples
	sHeaderVibrato	Special_Vib
	sHeaderEnvelope	Special_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Special_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Special_Voice:
	sNewVoice	EnterSS
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $05, $01
	sRateScale	$01, $00, $01, $01
	sAttackRate	$01, $1B, $09, $0B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$09, $09, $06, $08
	sDecay2Rate	$01, $02, $03, $A9
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$29, $23, $27, $02
	sFinishVoice

	sNewVoice	Error
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $0C, $17, $04
	sFinishVoice

	sNewVoice	BigRing1
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $05, $03
	sMultiple	$00, $04, $0C, $00
	sRateScale	$02, $02, $02, $03
	sAttackRate	$1E, $0C, $08, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay2Rate	$08, $08, $08, $08
	sDecay1Level	$0B, $0B, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$24, $04, $1C, $00
	sFinishVoice

	sNewVoice	BigRing2
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $05, $03
	sMultiple	$00, $04, $0C, $00
	sRateScale	$02, $02, $02, $03
	sAttackRate	$1E, $0C, $08, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay2Rate	$08, $08, $08, $08
	sDecay1Level	$0B, $0B, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$24, $04, $2C, $00
	sFinishVoice

	sNewVoice	BigRing3
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $07, $07, $04
	sMultiple	$07, $07, $02, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay2Rate	$00, $00, $0B, $0B
	sDecay1Level	$01, $01, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$13, $13, $01, $08
	sFinishVoice

	sNewVoice	Diamonds
	sAlgorithm	$04
	sFeedback	$03
	sDetune		$02, $00, $00, $00
	sMultiple	$0E, $0F, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$18, $14, $0F, $0E
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$20, $22, $00, $07
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Special_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Special_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; Diamonds
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	FM5, Diamonds_FM5
	sChannelEnd

Diamonds_FM5:
	sVoice		Diamonds
	sPan		center
	sNote		nA3, $08
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Action Block
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=v priority=$80
	sChannel	PSG2, ActionBlock_PSG2
	sChannelEnd

ActionBlock_PSG2:
	sPortaTarget	nC0, $00
	sPortaSpeed	$0120
	sNote		nCs2, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Big Ring
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=v priority=$80
	sChannel	FM5, BigRing_FM5
	sChannel	FM4, BigRing_FM4
	sChannelEnd

BigRing_FM5:
	sNote		nRst, $0A
	sVoice		BigRing3
	sPan		center
	sVol		$13
	sCall		$05, .loop

	sNote		nFs5, $07
	sPortaTarget	nC0, $00
	sPortaSpeed	$0018
	sNote		sTie, $10
	sStop

.loop:
	sNote		nFs5, $06
	sRet

BigRing_FM4:
	sVoice		BigRing2
	sPan		center
	sNote		nRst, $01
	sNote		nA3, $08
	sVoice		BigRing1
	sNote		sTie, nGs4, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Error
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, Error_FM5
	sChannelEnd

Error_FM5:
	sVoice		Error
	sPan		center
	sNote		nB3, $06
	sNote		nRst, $06
	sNote		nB3, $18
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Enter Special Stage
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	FM5, EnterSS_FM5
	sChannelEnd

EnterSS_FM5:
	sVoice		EnterSS
	sPan		center
	sNote		nDs6, $02
	sNote		sTie, nF6
	sNote		sTie, nDs6, $01
	sCall		$10, .loop
	sStop

.loop:
	sNote		sTie, nCs6, $02
	sNote		sTie, nDs6, $01
	sNote		sTie, nF6, $02
	sNote		sTie, nDs6, $01
	sRet

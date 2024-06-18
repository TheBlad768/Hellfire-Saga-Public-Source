; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Ring_Voice
	sHeaderSamples	Ring_Samples
	sHeaderVibrato	Ring_Vib
	sHeaderEnvelope	Ring_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Ring_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Ring_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Ring_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Ring_Voice:
	sNewVoice	Rings
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $07, $07, $04
	sMultiple	$07, $07, $02, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0A, $0D
	sDecay1Level	$01, $01, $00, $00
	sDecay2Rate	$00, $00, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$A3, $A3, $00, $00
	sFinishVoice

	sNewVoice	Register1
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$03, $03, $02, $06
	sRateScale	$00, $00, $00, $02
	sAttackRate	$18, $1A, $1A, $16
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$17, $0A, $0E, $10
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $39, $28, $00
	sFinishVoice

	sNewVoice	Register2
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $18, $1A, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$17, $1A, $11, $0E
	sDecay2Rate	$00, $14, $0F, $10
	sDecay1Level	$01, $09, $09, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$07, $26, $08, $14
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; RingRight
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, RingRight_FM5
	sChannelEnd

RingRight_FM5:
	sPan		right
	sJump		RingLeft_Main

; ===========================================================================
; ---------------------------------------------------------------------------
; RingLeft
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	FM4, RingLeft_FM4
	sChannelEnd

RingLeft_FM4:
	sPan		left

RingLeft_Main:
	sVol		$05
	sVoice		Rings
	sNote		nE5, $05
	sNote		nG5
	sNote		nC6, $1B
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; RingLoss
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=v priority=$80
	sChannel	FM4, RingLoss_FM4
	sChannel	FM5, RingLoss_FM5
	sChannelEnd

RingLoss_FM4:
	sVoice		Rings
	sVol		$05
	sPan		center
	sNote		nA5, $02, $05, $05, $05, $05, $05, $05, $3A
	sStop

RingLoss_FM5:
	sVoice		Rings
	sVol		$08
	sPan		center
	sNote		nRst, $02
	sNote		nG5, $02, $05, $15, $02, $05, $32
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Register
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=v priority=$80
	sChannel	FM2, Register_FM2
	sChannel	FM4, Register_FM4
	sChannel	FM5, Register_FM5
	sChannelEnd

Register_FM5:
	sVoice		Register1
	sPan		center
	sNote		nA0, $08
	sNote		nRst, $02
	sNote		nA0, $08
	sStop

Register_FM4:
	sVoice		Rings
	sPan		center
	sNote		nRst, $12
	sNote		nA5, $55
	sStop

Register_FM2:
	sVoice		Register2
	sPan		center
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		$04
	sNote		$05
	sNote		$04
	sStop

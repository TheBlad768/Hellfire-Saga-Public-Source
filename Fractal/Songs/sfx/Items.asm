; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Items_Voice
	sHeaderSamples	Items_Samples
	sHeaderVibrato	Items_Vib
	sHeaderEnvelope	Items_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Items_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Items_Voice:
	sNewVoice	Spring1
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$06, $00, $05, $01
	sRateScale	$03, $02, $03, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $06
	sDecay2Rate	$07, $06, $06, $08
	sDecay1Level	$02, $01, $01, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $13, $30, $00
	sFinishVoice

	sNewVoice	Spring2
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$03, $03, $03, $03
	sMultiple	$01, $00, $03, $01
	sRateScale	$02, $02, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $09, $06, $06
	sDecay2Rate	$07, $06, $06, $08
	sDecay1Level	$02, $01, $01, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$19, $11, $23, $00
	sFinishVoice

	sNewVoice	SpikeBall
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$02, $01, $01, $09
	sMultiple	$01, $07, $06, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $13, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $05, $10, $12
	sDecay2Rate	$05, $01, $02, $03
	sDecay1Level	$02, $05, $04, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $1F, $08, $00
	sFinishVoice

	sNewVoice	PushBlock
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay2Rate	$06, $06, $0F, $02
	sDecay1Level	$01, $04, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0F, $0E, $0E, $06
	sFinishVoice

	sNewVoice	LavaBall
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$02, $00, $03, $05
	sRateScale	$00, $00, $00, $00
	sAttackRate	$12, $0F, $11, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay2Rate	$06, $06, $0F, $02
	sDecay1Level	$01, $04, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2F, $0E, $1A, $00
	sFinishVoice

	sNewVoice	Bumper1
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$05, $0A, $01, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$16, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $11, $11, $11
	sDecay1Level	$04, $03, $03, $03
	sDecay2Rate	$09, $06, $0A, $0A
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $2B, $00, $00
	sFinishVoice

	sNewVoice	Bumper2
	sAlgorithm	$05
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0C, $0C, $0C
	sDecay1Level	$01, $05, $05, $05
	sDecay2Rate	$12, $08, $08, $08
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$07, $02, $02, $02
	sFinishVoice

	sNewVoice	Basaran
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$08, $08, $08, $08
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $00, $03
	sFinishVoice

	sNewVoice	Bomb
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $00
	sDecay2Rate	$0B, $10, $1F, $0F
	sDecay1Level	$01, $04, $02, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $04, $07, $00
	sFinishVoice

	sNewVoice	Explosion4
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $03, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $03, $03, $01
	sAttackRate	$15, $1C, $11, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $0F, $04, $0C
	sDecay2Rate	$0D, $0A, $00, $07
	sDecay1Level	$00, $05, $0F, $08
	sReleaseRate	$0F, $09, $03, $02
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0D, $0F, $00, $00
	sFinishVoice

	sNewVoice	Explosion5
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$01, $07, $00, $07
	sMultiple	$06, $06, $06, $06
	sRateScale	$02, $00, $01, $00
	sAttackRate	$19, $1F, $19, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $07, $07, $08
	sDecay2Rate	$0F, $00, $00, $00
	sDecay1Level	$0F, $0E, $0F, $0F
	sReleaseRate	$06, $04, $05, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$02, $3B, $00, $00
	sFinishVoice

	sNewVoice	Explosion6
	sAlgorithm	$02
	sFeedback	$00
	sDetune		$03, $06, $04, $00
	sMultiple	$00, $00, $01, $00
	sRateScale	$03, $02, $03, $02
	sAttackRate	$17, $11, $09, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $0A, $00, $05
	sDecay2Rate	$00, $00, $00, $05
	sDecay1Level	$0E, $0C, $05, $08
	sReleaseRate	$07, $0C, $05, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$07, $00, $14, $00
	sFinishVoice

	sNewVoice	Explosion7
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $1E, $1E, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$02, $00, $00, $00
	sReleaseRate	$00, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0A, $00, $00, $00
	sFinishVoice

	sNewVoice	Explosion8
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $03, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $03, $03, $01
	sAttackRate	$1E, $1C, $11, $1E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$08, $0F, $04, $0C
	sDecay2Rate	$0D, $0A, $00, $07
	sDecay1Level	$00, $05, $0F, $08
	sReleaseRate	$0F, $09, $03, $02
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0A, $0F, $00, $00
	sFinishVoice

	sNewVoice	BreakWall
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay2Rate	$0B, $10, $1F, $05
	sDecay1Level	$01, $04, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $04, $07, $00
	sFinishVoice

	sNewVoice	BreakItem
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $03, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$19, $19, $12, $0E
	sDecay2Rate	$05, $00, $12, $0F
	sDecay1Level	$00, $0F, $07, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $00, $00
	sFinishVoice

	sNewVoice	BreakBridge
	sAlgorithm	$01
	sFeedback	$06
	sDetune		$04, $00, $0F, $00
	sMultiple	$0B, $00, $02, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0F, $1F, $0F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0B, $07, $03, $0A
	sDecay2Rate	$10, $16, $0B, $0A
	sDecay1Level	$0F, $0F, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$50, $10, $07, $00
	sFinishVoice

	sNewVoice	Flipper
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$01, $01, $07, $03
	sMultiple	$02, $00, $07, $00
	sRateScale	$01, $01, $01, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0A, $00, $01
	sDecay2Rate	$0A, $0A, $0D, $0D
	sDecay1Level	$04, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$13, $07, $07, $07
	sFinishVoice

	sNewVoice	Electric
	sAlgorithm	$03
	sFeedback	$00
	sDetune		$01, $01, $01, $01
	sMultiple	$02, $03, $00, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$02, $0F, $02, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$05, $36, $10, $09
	sFinishVoice

	sNewVoice	Chain
	sAlgorithm	$00
	sFeedback	$05
	sDetune		$02, $03, $05, $02
	sMultiple	$0F, $07, $0F, $0B
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $15, $15, $13
	sDecay2Rate	$13, $0D, $0C, $10
	sDecay1Level	$02, $03, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $1F, $10, $00
	sFinishVoice

	sNewVoice	Gloop
	sAlgorithm	$07
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$03, $02, $02, $04
	sRateScale	$01, $01, $01, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $1A, $11, $0A
	sDecay2Rate	$09, $0A, $0A, $0A
	sDecay1Level	$04, $03, $03, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$7F, $00, $00, $23
	sFinishVoice

	sNewVoice	GloopDrop
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$03, $01, $03, $01
	sMultiple	$03, $07, $04, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0F, $0D, $1B, $17
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $04, $02, $0B
	sDecay2Rate	$08, $00, $08, $09
	sDecay1Level	$06, $05, $04, $06
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$05, $08, $00, $08
	sFinishVoice

	sNewVoice	SlotMachine
	sAlgorithm	$04
	sFeedback	$02
	sDetune		$02, $03, $03, $01
	sMultiple	$05, $06, $03, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $1C, $18, $13
	sDecay2Rate	$0B, $0D, $08, $09
	sDecay1Level	$00, $08, $09, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$24, $12, $05, $08
	sFinishVoice

	sNewVoice	LaunchSpring
	sAlgorithm	$04
	sFeedback	$06
	sDetune		$00, $01, $07, $00
	sMultiple	$0C, $00, $03, $0C
	sRateScale	$02, $02, $03, $03
	sAttackRate	$0F, $0C, $1F, $15
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$06, $00, $02, $01
	sDecay2Rate	$02, $0A, $04, $08
	sDecay1Level	$0B, $0B, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $08, $00, $00
	sFinishVoice

	sNewVoice	LidPop
	sAlgorithm	$07
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$03, $02, $03, $00
	sRateScale	$03, $01, $01, $00
	sAttackRate	$1F, $0F, $0F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $14, $11, $0E
	sDecay2Rate	$1A, $0A, $03, $0D
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$03, $07, $07, $00
	sFinishVoice

	sNewVoice	Zapper
	sAlgorithm	$03
	sFeedback	$00
	sDetune		$01, $01, $01, $01
	sMultiple	$02, $03, $00, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$02, $0F, $02, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$06, $34, $10, $07
	sFinishVoice

	sNewVoice	Door
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $0F, $16, $0F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $0F, $0A, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $0A, $00, $00
	sFinishVoice

	sNewVoice	TinyBumper
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$05, $0A, $01, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$16, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $11, $11, $11
	sDecay2Rate	$09, $06, $0A, $0A
	sDecay1Level	$04, $03, $03, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$17, $20, $07, $07
	sFinishVoice

	sNewVoice	LargeBumper1
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$03, $03, $04, $07
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0A, $01, $0D
	sDecay2Rate	$00, $01, $01, $0C
	sDecay1Level	$00, $02, $0C, $0F
	sReleaseRate	$00, $03, $03, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$08, $07, $1C, $03
	sFinishVoice

	sNewVoice	Elevator
	sAlgorithm	$05
	sFeedback	$01
	sDetune		$00, $00, $00, $0E
	sMultiple	$06, $00, $00, $05
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$27, $0E, $0E, $0E
	sFinishVoice

	sNewVoice	SpikeRing
	sAlgorithm	$02
	sFeedback	$00
	sDetune		$02, $00, $00, $00
	sMultiple	$00, $0E, $0F, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $1F
	sDecay2Rate	$0F, $0E, $0F, $0E
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2E, $00, $20, $00
	sFinishVoice

	sNewVoice	ArrowFire
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$0F, $0F, $0F, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $00, $00
	sFinishVoice

	sNewVoice	Fire
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$01, $00, $00, $00
	sMultiple	$02, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$01, $0E, $14, $0E
	sFinishVoice

	sNewVoice	Stomp1
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $09, $0A, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay2Rate	$0B, $10, $1F, $05
	sDecay1Level	$01, $04, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $04, $07, $0A
	sFinishVoice

	sNewVoice	Stomp2
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $05, $18, $10
	sDecay2Rate	$0B, $10, $1F, $10
	sDecay1Level	$01, $01, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0D, $01, $00, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Items_Vib:
	sVibrato Spring,	$03, $00, $0B80, $0A00, Triangle
	sVibrato Bomb,		$01, $00, $8000, $0028, Triangle
	sVibrato BreakWall_1,	$01, $00, $2490,-$05AA, Triangle
	sVibrato BreakWall_2,	$03, $00, $2AA8, $01A6, Triangle
	sVibrato BreakItem,	$03, $00, $1000, $059C, Triangle
	sVibrato BreakBridge_1,	$03, $00, $1C70, $0260, Triangle
	sVibrato BreakBridge_2,	$03, $00, $1C70, $0380, Triangle
	sVibrato Smash_PSG3,	$02, $00, $1C70,-$0FEB, Triangle
	sVibrato Smash_FM5,	$04, $00, $2AA8, $01A6, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Items_Env:
	sEnvelope v01,		Items_Env_v01
	sEnvelope v04,		Items_Env_v04
	sEnvelope v06,		Items_Env_v06
	sEnvelope v09,		Items_Env_v09
; ---------------------------------------------------------------------------

Items_Env_v01:
	sEnv		delay=$03,	$10, $18, $20, $28, $30, $38, $40
	seHold		$48
; ---------------------------------------------------------------------------

Items_Env_v04:
	sEnv		$00, $00, $10, $18, $20, $20, $28, $28
	sEnv		$28
	seHold		$30
; ---------------------------------------------------------------------------

Items_Env_v06:
	sEnv		delay=$03,	$18, $10, $08
	seHold		$00
; ---------------------------------------------------------------------------

Items_Env_v09:
	sEnv		$00, $08, $10, $18, $20, $28, $30, $38
	sEnv		$40, $48, $50, $58, $60, $68, $70
	seHold		$78
; ===========================================================================
; ---------------------------------------------------------------------------
; Fire
; ---------------------------------------------------------------------------

	sSong		sfx index=$23 flags=v priority=$80
	sChannel	FM4, Fire_FM4
	sChannel	PSG3, Fire_PSG3
	sChannel	PSG4, Fire_PSG4
	sChannelEnd

Fire_FM4:
	sVoice		Fire
	sPan		center
	sNote		nE0, $40
	sCall		$0A, .loop4
	sStop

.loop4
	sNote		sTie, $04
	sVol		$04
	sRet

Fire_PSG3:
	sVol		$7F
	sNote		nD4, $68
	sStop

Fire_PSG4:
	sNote		nWhitePSG3, $40
	sCall		$10, .loopn
	sStop

.loopn
	sNote		sTie, $02
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Flame
; ---------------------------------------------------------------------------

	sSong		sfx index=$22 flags=v priority=$80
	sChannel	FM5, Flame_FM5
	sChannel	PSG3, Flame_PSG3
	sChannel	PSG4, Flame_PSG4
	sChannelEnd

Flame_FM5:
	sVoice		LavaBall
	sPan		center
	sNote		      freq(FM5. $02D3), $01
	sNote		sTie, freq(FM5. $0313), $01
	sNote		sTie, freq(FM5. $0343), $01
	sNote		sTie, freq(FM5. $0393), $01
	sNote		sTie, freq(FM5. $03D3), $01
	sNote		sTie, freq(FM5. $0413), $01
	sNote		      freq(FM5. $032D), $01
	sNote		sTie, freq(FM5. $036D), $01
	sStop

Flame_PSG3:
	sNote		nCut, $0A
	sVol		$7F
	sNote		nD4, $45
	sStop

Flame_PSG4:
	sNote		nCut, $0A
	sNote		nWhitePSG3, $25
	sCall		$10, .loop
	sStop

.loop
	sNote		sTie, $02
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; ArrowFire
; ---------------------------------------------------------------------------

	sSong		sfx index=$21 flags=v priority=$80
	sChannel	FM5, ArrowFire_FM5
	sChannelEnd

ArrowFire_FM5:
	sVoice		ArrowFire
	sPan		center
	sNote		nC3, $01
	sCall		$05, .loop
	sStop

.loop
	sNote		sTie, $01
	sVol		$02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; ArrowStick
; ---------------------------------------------------------------------------

	sSong		sfx index=$20 flags=v priority=$80
	sChannel	FM5, ArrowStick_FM5
	sChannelEnd

ArrowStick_FM5:
	sVoice		Chain
	sPan		center
	sNote		nDs5, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; SpikeRing
; ---------------------------------------------------------------------------

	sSong		sfx index=$1F flags=v priority=$80
	sChannel	FM5, SpikeRing_FM5
	sChannelEnd

SpikeRing_FM5:
	sVoice		SpikeRing
	sPan		center
	sNote		nF3, $07
	sNote		nF4, $15
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Elevator
; ---------------------------------------------------------------------------

	sSong		sfx index=$1E flags=v priority=$80
	sChannel	FM5, Elevator_FM5
	sChannelEnd

Elevator_FM5:
	sVoice		Elevator
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	$0064
	sNote		nFs2, $1C
	sPortaSpeed	$0000

	sCall		$09, .loop1
	sCall		$08, .loop2
	sStop

.Loop1
	sNote		sTie, nF3, $05
	sRet

.Loop2
	sNote		sTie, $04
	sVol		$02
	sNote		sTie, $04
	sVol		$02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; LargeBumper
; ---------------------------------------------------------------------------

	sSong		sfx index=$1D flags=v priority=$80
	sChannel	FM5, LargeBumper_FM5
	sChannel	FM4, LargeBumper_FM4

	sChannelEnd

LargeBumper_FM5:
	sVoice		LargeBumper1
	sPan		center
	sNote		nF4, $14
	sNote		nRst, $08
	sStop

LargeBumper_FM4:
	sVoice		LargeBumper1
	sPan		center
	sFrac		$0040
	sNote		nE4, $14
	sNote		nRst, $08
	sStop

LargeBumper_FM2:
	sVoice		Bumper2
	sPan		center
	sNote		nCs2, $03
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; TinyBumper
; ---------------------------------------------------------------------------

	sSong		sfx index=$1C flags=v priority=$80
	sChannel	FM5, TinyBumper_FM5
	sChannelEnd

TinyBumper_FM5:
	sVoice		TinyBumper
	sPan		center
	sNote		nD4, $06, $15
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; DrawBridgeMove
; ---------------------------------------------------------------------------

	sSong		sfx index=$1B flags=v priority=$80
	sChannel	PSG3, DrawBridgeMove_PSG3
	sChannel	PSG4, DrawBridgeMove_PSG4
	sChannelEnd

DrawBridgeMove_PSG3:
	sVol		$7F
	sNote		nFs2, $0A
	sNote		nG2, $0A
	sNote		nB2, $0A
	sNote		nFs3, $0A
	sNote		nG3, $0A
	sNote		nB3, $08
	sNote		nFs4, $08
	sNote		nG4, $08
	sNote		nB4, $08
	sStop

DrawBridgeMove_PSG4:
	sVolEnv		v06
	sNote		nWhitePSG3, $0A
	sNote		$0A
	sNote		$0A
	sNote		$0A
	sNote		$0A
	sNote		$08
	sNote		$08
	sNote		$08
	sNote		$08
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; DrawBridgeDown
; ---------------------------------------------------------------------------

	sSong		sfx index=$1A flags=v priority=$80
	sChannel	FM5, DrawBridgeDown_FM5
	sChannel	PSG3, DrawBridgeDown_PSG3
	sChannel	PSG4, DrawBridgeDown_PSG4
	sChannelEnd

DrawBridgeDown_FM5:
	sVoice		Door
	sPan		center
	sNote		nD1, $03
	sNote		nDs2, $06
	sNote		nF1, $08
	sStop

DrawBridgeDown_PSG3:
	sVol		$7F
	sNote		nHiHat, $11
	sStop

DrawBridgeDown_PSG4:
	sVolEnv		v04
	sNote		nWhitePSG3, $03, $06, $08
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Door
; ---------------------------------------------------------------------------

	sSong		sfx index=$19 flags=v priority=$80
	sChannel	FM5, Door_FM5
	sChannelEnd

Door_FM5:
	sVoice		Door
	sPan		center
	sNote		nD1, $04
	sNote		nRst, $04
	sNote		nG1, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; QuickDoor
; ---------------------------------------------------------------------------

	sSong		sfx index=$18 flags=v priority=$80
	sChannel	FM5, QuickDoor_FM5
	sChannelEnd

QuickDoor_FM5:
	sVoice		Door
	sPan		center
	sNote		nD1, $04
	sNote		nC2, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Zapper
; ---------------------------------------------------------------------------

	sSong		sfx index=$17 flags=v priority=$80
	sChannel	FM5, Zapper_FM5
	sChannelEnd

Zapper_FM5:
	sVoice		Zapper
	sPan		center
	sNote		nD3, $04
	sCall		$04, .loop
	sStop

.loop
	sNote		nRst, $01
	sNote		nDs3, $04
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; LidPop
; ---------------------------------------------------------------------------

	sSong		sfx index=$16 flags=v priority=$80
	sChannel	FM5, LidPop_FM5
	sChannel	PSG3, LidPop_PSG3
	sChannel	PSG4, LidPop_PSG4
	sChannelEnd

LidPop_FM5:
	sVoice		LidPop
	sPan		center
	sNote		nF4, $15
	sStop

LidPop_PSG3:
	sVol		$7F
	sNote		nA6, $03
	sNote		sTie, nGs6
	sNote		sTie, nG6
	sNote		sTie, nFs6
	sNote		sTie, nF6
	sNote		sTie, nE6
	sNote		sTie, nDs6
	sStop

LidPop_PSG4:
	sVol		$30
	sVolEnv		v04
	sNote		nWhitePSG3, $15
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; LaunchSpring - kinda broken
; ---------------------------------------------------------------------------

	sSong		sfx index=$15 flags=v priority=$80
	sChannel	FM5, LaunchSpring_FM5
	sChannelEnd

LaunchSpring_FM5:
	sVoice		LaunchSpring
	sPan		center
	sNote		nC3, $05

	sPortaTarget	nC0, $00
	sPortaSpeed	-$00C0
	sNote		nFs5, $02
	sCall		$11, .loop
	sStop

.loop
	sVol		$01
	sNote		sTie, $02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; SlotMachine
; ---------------------------------------------------------------------------

	sSong		sfx index=$06 flags=v priority=$80
	sChannel	FM5, SlotMachine_FM5
	sChannel	FM4, SlotMachine_FM4
	sChannelEnd

SlotMachine_FM5:
	sNote		nRst, $02
	sFrac		$000E

SlotMachine_FM4:
	sVoice		SlotMachine
	sPan		center
	sNote		nG5, $16
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; GloopDrop
; ---------------------------------------------------------------------------

	sSong		sfx index=$14 flags=v priority=$80
	sChannel	FM5, GloopDrop_FM5
	sChannel	PSG3, GloopDrop_PSG3
	sChannel	PSG4, GloopDrop_PSG4
	sChannelEnd

GloopDrop_FM5:
	sVoice		GloopDrop
	sPan		center
	sNote		nRst, $01
	sNote		nCs0, $02, $02, $02, $30
	sStop

GloopDrop_PSG3:
	sVol		$7F
	sNote		nHiHat, $36
	sStop

GloopDrop_PSG4:
	sVolEnv		v09
	sNote		nWhitePSG3, $36
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Gloop
; ---------------------------------------------------------------------------

	sSong		sfx index=$13 flags=vc priority=$80
	sChannel	FM5, Gloop_FM5
	sChannelEnd

Gloop_FM5:
	sVoice		Gloop
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	$0178

.cont
	sNote		nF3, $06
	sCont		.cont
	sNote		sTie, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Stomp
; ---------------------------------------------------------------------------

	sSong		sfx index=$24 flags=v priority=$80
	sChannel	FM5, Stomp_FM5
	sChannel	FM4, Stomp_FM4
	sChannelEnd

Stomp_FM5:
	sVoice		Stomp1
	sCall		$04, .loop5
	sStop

.loop5
	sNote		freq(FM5. $238F), $01, sTie
	sNote		freq(FM5. $23EF), $01, sTie
	sRet

Stomp_FM4:
	sNote		nRst, $08
	sVoice		Stomp2
	sNote		nDs0, $22
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Chain
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	FM5, Chain_FM5
	sChannelEnd

Chain_FM5:
	sVoice		Chain
	sPan		center
	sNote		nCs5, $05
	sNote		nRst, $04
	sNote		nCs5, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Electricity
; ---------------------------------------------------------------------------

	sSong		sfx index=$12 flags=v priority=$80
	sChannel	FM5, Electricity_FM5
	sChannelEnd

Electricity_FM5:
	sVoice		Electric
	sPan		center
	sNote		nA3, $05
	sNote		nRst, $01
	sNote		nA3, $09
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Smash
; ---------------------------------------------------------------------------

	sSong		sfx index=$11 flags=v priority=$80
	sChannel	FM5, Smash_FM5
	sChannel	PSG3, Smash_PSG3
	sChannel	PSG4, Smash_PSG4
	sChannelEnd

Smash_FM5:
	sVoice		BreakWall
	sPan		center
	sVibratoSet	Smash_FM5
	sCall		$06, .loop5
	sStop

.loop5
	sNote		nC0, $18
	sVol		$0A
	sRet

Smash_PSG3:
	sVol		$7F
	sVibratoSet	Smash_PSG3
	sNote		nB4, $78
	sStop

Smash_PSG4:
	sCall		$05, .loop4
	sStop

.loop4
	sNote		nWhitePSG3, $18, sTie
	sVol		$18
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Flipper
; ---------------------------------------------------------------------------

	sSong		sfx index=$10 flags=v priority=$80
	sChannel	FM5, Flipper_FM5
	sChannelEnd

Flipper_FM5:
	sVoice		Flipper
	sNote		nD2, $01
	sPortaTarget	nC0, $00
	sPortaSpeed	$0024
	sNote		sTie, $02
	sPortaSpeed	$0000
	sNote		nAs2, $01
	sPortaSpeed	$0018
	sNote		sTie, $24
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; BreakBridge
; ---------------------------------------------------------------------------

	sSong		sfx index=$0F flags=v priority=$80
	sChannel	FM4, BreakBridge_FM4
	sChannel	FM5, BreakBridge_FM5
	sChannel	PSG3, BreakBridge_PSG3
	sChannel	PSG4, BreakBridge_PSG4
	sChannelEnd

BreakBridge_FM5:
	sNote		nRst, $03
	sVol		$03
	sVibratoSet	BreakBridge_2
	sJump		BreakBridge_FMA

BreakBridge_FM4:
	sVibratoSet	BreakBridge_1
	sFrac		$1F00

BreakBridge_FMA:
	sVoice		BreakBridge
	sPan		center
	sNote		nD0, $22
	sStop

BreakBridge_PSG3:
	sVol		$7F
	sPortaTarget	nC0, $00
	sPortaSpeed	-$0242
	sCall		$03, BreakBridge_Loop00
	sStop

BreakBridge_Loop00:
	sNote		nGs6, $0F
	sRet

BreakBridge_PSG4:
	sCall		$03, BreakBridge_Loop01
	sStop

BreakBridge_Loop01:
	sNote		nWhitePSG3, $0F
	sVol		$58
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; BreakItem
; ---------------------------------------------------------------------------

	sSong		sfx index=$0E flags=v priority=$80
	sChannel	FM5, BreakItem_FM5
	sChannel	PSG3, BreakItem_PSG3
	sChannel	PSG4, BreakItem_PSG4
	sChannelEnd

BreakItem_FM5:
	sVoice		BreakItem
	sVibratoSet	BreakItem
	sPan		center
	sNote		nA4, $16
	sStop

BreakItem_PSG3:
	sVol		$7F
	sNote		nB4, $1B
	sStop

BreakItem_PSG4:
	sVolEnv		v01
	sNote		nWhitePSG3, $1B
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; BreakWall
; ---------------------------------------------------------------------------

	sSong		sfx index=$0D flags=v priority=$80

	sChannel	FM4, BreakWall_FM4
	sChannel	FM5, BreakWall_FM5
	sChannel	PSG3, BreakWall_PSG3
	sChannel	PSG4, BreakWall_PSG4
	sChannelEnd

BreakWall_FM2:
	sNote		nRst, $02
	sPan		right
	sFrac		$1000
	sJump		BreakWall_FMA

BreakWall_FM5:
	sNote		nRst, $01
	sPan		left
	sFrac		$1000
	sJump		BreakWall_FMA

BreakWall_FM4:
	sPan		center

BreakWall_FMA:
	sVoice		BreakWall
	sVibratoSet	BreakWall_2
	sCall		$06, BreakWall_Loop01
	sStop

BreakWall_Loop01:
	sNote		nC0, $18
	sVol		$0A
	sRet

BreakWall_PSG3:
	sVol		$7F
	sVibratoSet	BreakWall_1
	sCall		$05, BreakWall_Loop00
	sStop

BreakWall_Loop00:
	sNote		nB5, $18, sHold
	sRet

BreakWall_PSG4:
	sCall		$05, BreakWall_Loop02
	sStop

BreakWall_Loop02:
	sNote		nWhitePSG3, $18
	sVol		$18
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Explosion
; ---------------------------------------------------------------------------

	sSong		sfx index=$0C flags=v priority=$80
	sChannel	FM5, Explosion_FM5
	sChannelEnd

Explosion_FM5:
	sVol		$34
	sPan		center
	sVoice		Explosion4
	sVol		$D0
	sNote		nA2, $06
	sNote		nRst, $01
	sVol		$05
	sNote		nA2
	sNote		nRst
	sVoice		Explosion5
	sVol		$F9
	sNote		nD5
	sNote		nRst
	sNote		nB4
	sNote		nRst
	sVol		$04
	sNote		nAs4
	sNote		nRst
	sVoice		Explosion6
	sVol		$FB
	sNote		nA2, $04
	sNote		nRst, $01
	sVol		$02
	sNote		nGs2
	sNote		nRst, $02
	sVoice		Explosion4
	sVol		$FF
	sNote		nDs2
	sNote		nRst, $01
	sVoice		Explosion7
	sVol		$02

	sNote		nD1, $04
	sFrac		-$0023		; ssDetune $FA
	sNote		sHold, nDs1, $01
	sFrac		$005B		; ssDetune $09
	sNote		sHold, nCs1
	sFrac		-$0097		; ssDetune $F0
	sNote		sHold, nDs1
	sFrac		$00CF		; ssDetune $12
	sNote		sHold, nCs1
	sNote		sHold, nD1
	sFrac		-$00BA		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$004A		; ssDetune $00

	sNote		nRst, $04

	sNote		nD1
	sFrac		$001D		; ssDetune $05
	sNote		sHold, $01
	sFrac		-$005B		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$0097		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00CF		; ssDetune $ED
	sNote		sHold, $01
	sNote		sHold, nDs1
	sFrac		$00BA		; ssDetune $0B
	sNote		sHold, nCs1
	sFrac		-$0044		; ssDetune $00

	sNote		nRst, $03

	sNote		nDs1, $04
	sNote		sHold, nE1, $01
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD1
	sFrac		-$0073		; ssDetune $F6
	sNote		sHold, nE1
	sFrac		$0038		; ssDetune $00

	sNote		nRst, $02

	sNote		nD3, $04
	sFrac		$001D		; ssDetune $05
	sNote		sHold, $01
	sFrac		-$005B		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$003E		; ssDetune $00

	sNote		nRst, $02

	sNote		nFs1, $04
	sFrac		-$0020		; ssDetune $F9
	sNote		sHold, nG1, $01
	sFrac		$003E		; ssDetune $06
	sNote		sHold, nF1
	sFrac		-$007B		; ssDetune $EC
	sNote		sHold, nG1
	sFrac		$00B7		; ssDetune $12
	sNote		sHold, nF1
	sFrac		$000C		; ssDetune $16
	sNote		sHold, nFs1
	sFrac		-$00B6		; ssDetune $F0
	sNote		sHold, $01
	sFrac		$0079		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$003D		; ssDetune $FC
	sNote		sHold, $02
	sFrac		$003D		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$0079		; ssDetune $F0
	sNote		sHold, $01
	sFrac		$00B6		; ssDetune $16
	sNote		sHold, $01
	sFrac		-$000C		; ssDetune $12
	sNote		sHold, nF1
	sFrac		-$00B7		; ssDetune $EC
	sNote		sHold, nG1
	sFrac		$007B		; ssDetune $06
	sNote		sHold, nF1
	sFrac		-$003E		; ssDetune $F9
	sNote		sHold, nG1
	sFrac		$0020		; ssDetune $00
	sNote		sHold, nF1
	sFrac		-$003C		; ssDetune $F3
	sNote		sHold, nG1
	sFrac		$0078		; ssDetune $0C
	sNote		sHold, nF1
	sFrac		-$00B5		; ssDetune $E6
	sNote		sHold, nG1
	sFrac		$000B		; ssDetune $EA
	sNote		sHold, nFs1
	sFrac		$00B3		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$0077		; ssDetune $F6

	sNote		sHold, $01
	sNote		nRst, $08
	sVoice		Explosion4
	sVol		$01
	sNote		sHold, $02
	sFrac		$0032		; ssDetune $00

	sNote		nCs2, $01
	sNote		nRst
	sNote		nDs2
	sNote		nRst
	sNote		nCs2, $02
	sNote		nRst, $01
	sNote		nDs2
	sNote		nRst
	sNote		nCs2
	sNote		nRst, $02
	sNote		nDs2, $01
	sNote		nRst
	sNote		nCs2
	sNote		nRst, $02
	sNote		nDs2
	sNote		nRst, $01

	sCall		$02, Explosion_Loop01
	sNote		nCs2
	sNote		nRst, $03
	sNote		nDs2, $02
	sNote		nRst, $01
	sNote		nCs2, $02
	sNote		nRst
	sNote		nDs2
	sNote		nRst
	sNote		nCs2, $01
	sNote		nRst, $03
	sNote		nDs2, $02
	sNote		nRst, $01
	sNote		nCs2
	sNote		nRst, $02
	sVoice		Explosion8
	sNote		sHold, $01
	sVoice		Explosion7
	sVol		$02
	sNote		nD1, $02
	sNote		nRst
	sNote		nD2, $01
	sNote		nRst, $03
	sNote		nG1, $02

	sCall		$02, Explosion_Loop02
	sNote		nRst
	sVol		$09
	sNote		nD2, $03
	sNote		nRst, $02
	sNote		nG1, $01
	sNote		nRst, $02
	sVol		$09
	sNote		nD2
	sNote		nRst
	sNote		nG1
	sNote		nRst, $01
	sVol		$09
	sNote		nD2, $02
	sNote		nRst, $03
	sNote		nG1, $01
	sStop

Explosion_Loop02:
	sNote		nRst, $01
	sVol		$09
	sNote		nD2, $02
	sNote		nRst, $03
	sNote		nG1, $01
	sRet

Explosion_Loop01:
	sNote		nCs2
	sNote		nRst, $03
	sNote		nDs2, $02
	sNote		nRst, $01
	sNote		nCs2, $02
	sNote		nRst
	sNote		nDs2
	sNote		nRst
	sCall		$01,Explosion_Loop00

Explosion_Loop00:
	sNote		nCs2, $01
	sNote		nRst, $02
	sNote		nDs2, $03
	sNote		nRst, $01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Bomb
; ---------------------------------------------------------------------------

	sSong		sfx index=$0B flags=v priority=$80
	sChannel	FM5, Bomb_FM5
	sChannelEnd

Bomb_FM5:
	sVoice		Bomb
	sVibratoSet	Bomb
	sPan		center
	sNote		nC0, $1A
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Basaran
; ---------------------------------------------------------------------------

	sSong		sfx index=$09 flags=v priority=$80
	sChannel	FM5, Basaran_FM5
	sChannelEnd

Basaran_FM5:
	sVoice		Basaran
	sPan		center
	sNote		nG1, $05
	sNote		nRst, $05
	sNote		nG1, $04
	sNote		nRst, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Bumper
; ---------------------------------------------------------------------------

	sSong		sfx index=$08 flags=v priority=$80
	sChannel	FM4, Bumper_FM4
	sChannel	FM5, Bumper_FM5
	sChannelEnd

Bumper_FM5:
	sVoice		Bumper1
	sPan		center
	sFrac		-$800		; lowered pitch with the -8 here, change back to 0 for original sound
	sNote		nA4, $20
	sStop

Bumper_FM4:
	sVoice		Bumper2
	sPan		center
	sFrac		-$800		; lowered pitch with the -8 here, change back to 0 for original sound
	sNote		nCs2, $03
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; LavaBall
; ---------------------------------------------------------------------------

	sSong		sfx index=$07 flags=v priority=$80
	sChannel	FM5, LavaBall_FM5
	sChannel	PSG3, LavaBall_PSG3
	sChannel	PSG4, LavaBall_PSG4
	sChannelEnd

LavaBall_FM5:
	sVoice		LavaBall
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	$013C
	sNote		nD0, $06
	sNote		nE0, $02
	sStop

LavaBall_PSG3:
	sVol		$7F
	sNote		nCut, $0A
	sNote		nHiHat, $21
	sStop

LavaBall_PSG4:
	sNote		nCut, $0A
	sNote		nWhitePSG3, $01
	sCall		$10, LavaBall_Loop00
	sStop

LavaBall_Loop00:
	sNote		sTie, $02
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PushBlock
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=v priority=$80
	sChannel	FM4, PushBlock_FM4
	sChannelEnd

PushBlock_FM4:
	sVoice		PushBlock
	sPan		center
	sNote		nD1, $07
	sNote		nRst, $02
	sNote		nD1, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; CutDown
; ---------------------------------------------------------------------------

	sSong		sfx index=$0A flags=v priority=$80
	sChannel	PSG3, CutDown_PSG3
	sChannel	PSG4, CutDown_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; SpikeMove
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=v priority=$80
	sChannel	PSG3, SpikeMove_PSG3
	sChannel	PSG4, SpikeMove_PSG4
	sChannelEnd

CutDown_PSG3:
SpikeMove_PSG3:
	sVol		$7F
	sNote		freq(PSG3. $016), $01
	sNote		freq(PSG3. $006), $01
	sNote		freq(PSG3. $3F6), $01
	sNote		freq(PSG3. $3E6), $01
	sNote		freq(PSG3. $3D6), $01
	sNote		freq(PSG3. $3E6), $01
	sNote		freq(PSG3. $3F6), $01
	sNote		freq(PSG3. $000), $0C
	sStop

CutDown_PSG4:
	sVol		$18

SpikeMove_PSG4:
	sNote		nWhitePSG3, $07
	sCall		$0C, SpikeMove_Loop01
	sStop

SpikeMove_Loop01:
	sNote		$01
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; SpikeBall
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=vc priority=$80
	sChannel	FM4, SpikeBall_FM4
	sChannelEnd

SpikeBall_FM4:
	sVoice		SpikeBall
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	-$140

SpikeBall_Loop01:
	sCall		$02, SpikeBall_Loop00
	sVol		-$20
	sCont		SpikeBall_Loop01
	sStop

SpikeBall_Loop00:
	sNote		nAs1, $0D
	sVol		$10
	sNote		nAs1, $0D
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Spring
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, Spring_FM5
	sChannelEnd

Spring_FM5:
	sNote		nRst, $01
	sVoice		Spring1
	sVol		$02
	sPan		center
	sVibratoSet	Spring
	sNote		nB3, $0A
	sVibratoOff

	sVoice		Spring2
	sCall		$19, Spring_Loop00
	sStop

Spring_Loop00:
	sNote		nC5, $02, sHold
	sVol		$01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Switch
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	PSG4, Switch_PSG4
	sChannel	PSG3, Switch_PSG3
	sChannelEnd

Switch_PSG3:
	sNote		nAs5, $02
	sStop

Switch_PSG4:
	sNote		nCut, $02
	sStop

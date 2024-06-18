; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	LowPriority_Voice
	sHeaderSamples	LowPriority_Samples
	sHeaderVibrato	LowPriority_Vib
	sHeaderEnvelope	LowPriority_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

LowPriority_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

LowPriority_Voice:
	sNewVoice	Shake
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $0F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $09, $18, $02
	sDecay2Rate	$06, $06, $0F, $02
	sDecay1Level	$01, $04, $00, $02
	sReleaseRate	$0F, $0F, $07, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0F, $0E, $0E, $06
	sFinishVoice

	sNewVoice	ScreenShake
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

	sNewVoice	SpecialRumble
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$01, $01, $03, $03
	sMultiple	$01, $03, $01, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0A, $1F, $0F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate 	$05, $09, $18, $02
	sDecay2Rate	$06, $06, $0F, $02
	sDecay1Level	$00, $04, $00, $02
	sReleaseRate	$0F, $0F, $07, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$07, $0E, $0E, $0C
	sFinishVoice

	sNewVoice	Helicopter
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$03, $04, $04, $05
	sMultiple	$00, $04, $00, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $00, $13, $15
	sDecay2Rate	$1F, $00, $1F, $1A
	sDecay1Level	$07, $00, $07, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$02, $28, $05, $05
	sFinishVoice

	sNewVoice	Rumble
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
	sTotalLevel	$0F, $0E, $1A, $00
	sFinishVoice

	sNewVoice	Rumble2
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$03, $03, $05, $03
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0E, $19, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $12, $15, $09
	sDecay2Rate	$0A, $09, $1D, $06
	sDecay1Level	$0E, $00, $00, $01
	sReleaseRate	$08, $03, $0A, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$07, $00, $00, $00
	sFinishVoice

	sNewVoice	Saw
	sAlgorithm	$03
	sFeedback	$00
	sDetune		$01, $01, $01, $01
	sMultiple	$0F, $0F, $05, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$02, $0F, $02, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0B, $01, $16, $07
	sFinishVoice

	sNewVoice	TrackLift
	sAlgorithm	$04
	sFeedback	$04
	sDetune		$02, $00, $00, $00
	sMultiple	$0A, $02, $05, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1A, $1F, $10, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $1F, $1F, $1F
	sDecay2Rate	$0C, $0D, $11, $11
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0C, $09, $09, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $04, $00, $00
	sFinishVoice

	sNewVoice	LavaFall
	sAlgorithm	$03
	sFeedback	$06
	sDetune		$01, $01, $01, $01
	sMultiple	$01, $00, $00, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$05, $04, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $05, $01, $00
	sDecay2Rate	$10, $08, $09, $00
	sDecay1Level	$00, $00, $00, $01
	sReleaseRate	$06, $01, $03, $0A
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$8B, $10, $01, $0C
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

LowPriority_Vib:
	sVibrato Rumble,	$01, $00, $1554, $01C0, Triangle
	sVibrato Rumble2,	$01, $00, $1C70, $05F7, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

LowPriority_Env:
	sEnvelope v03,		LowPriority_Env_v03
	sEnvelope v06,		LowPriority_Env_v06
; ---------------------------------------------------------------------------

LowPriority_Env_v03:
	sEnv		delay=$02,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

LowPriority_Env_v06:
	sEnv		delay=$03,	$18, $10, $08
	seHold		$00

; ===========================================================================
; ---------------------------------------------------------------------------
; LavaFall
; ---------------------------------------------------------------------------

	sSong		sfx index=$0A flags=vc priority=$80
	sChannel	FM4, LavaFall_FM4
	sChannel	FM5, LavaFall_FM2
	sChannelEnd

LavaFall_FM4:
	sNote		nRst, $04
	sVol		$04

LavaFall_FM2:
	sVoice		LavaFall
	sPan		center

LavaFall_loop:
	sNote		      freq(FM4. $033B), $01
	sNote		sTie, freq(FM4. $02E7), $01
	sNote		sTie, freq(FM4. $0293), $01
	sNote		sTie, freq(FM4. $023F), $01
	sNote		sTie, freq(FM4. $01EB), $01
	sNote		sTie, freq(FM4. $0197), $01
	sNote		sTie, freq(FM4. $0143), $01
	sNote		sTie, freq(FM4. $00EF), $01

	sNote		      freq(FM4. $02D9), $01
	sNote		sTie, freq(FM4. $0285), $01
	sNote		sTie, freq(FM4. $0231), $01
	sNote		sTie, freq(FM4. $01DD), $01
	sNote		sTie, freq(FM4. $0189), $01
	sNote		sTie, freq(FM4. $0135), $01
	sNote		sTie, freq(FM4. $00E1), $01
	sNote		sTie, freq(FM4. $008D), $01
	sCont		LavaFall_loop
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; TrackLift
; ---------------------------------------------------------------------------

	sSong		sfx index=$09 flags=v priority=$80
	sChannel	FM5, TrackLift_FM5
	sChannelEnd

TrackLift_FM5:
	sVoice		TrackLift
	sPan		center
	sNote		nDs7, $02
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Saw
; ---------------------------------------------------------------------------

	sSong		sfx index=$08 flags=vc priority=$80
	sChannel	FM5, Saw_FM5
	sChannelEnd

Saw_FM5:
	sVoice		Saw
	sPan		center

.cont
	sNote		freq(FM5. $3B5C), $08
	sCont		.cont
	sCall		$1B, .loop
	sStop

.loop
	sNote		freq(FM5. $3B5C), $02
	sVol		$01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Helicopter
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=vc priority=$80
	sChannel	FM5, Helicopter_FM2
	sChannelEnd

Helicopter_FM2:
	sVoice		Helicopter
	sPan		center

.cont
	sCall		$02, .loop1
	sCont		.cont
	sCall		$1A, .loop2
	sStop

.loop2
	sVol		$01

.loop1
	sNote		nE2, $02
	sNote		$01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Leaves
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	PSG3, Leaves_PSG3
	sChannel	PSG4, Leaves_PSG4
	sChannelEnd

Leaves_PSG3:
	sVol		$7F
	sNote		nHiHat, $29
	sStop

Leaves_PSG4:
	sVolEnv		v03
	sNote		nWhitePSG3, $03
	sVolEnv		v06
	sNote		nWhitePSG3, $04
	sVol		$10
	sNote		nWhitePSG3, $02
	sVolEnv		v03
	sVol		-$10
	sNote		nWhitePSG3, $08
	sNote		nWhitePSG3, $18
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; OilSlide
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=vc priority=$80
	sChannel	PSG3, OilSlide_PSG3
	sChannel	PSG4, OilSlide_PSG4
	sChannelEnd

OilSlide_PSG3:
	sVol		$7F

.cont
	sNote		nHiHat, $05
	sCont		.cont
	sNote		nHiHat, $18
	sStop

OilSlide_PSG4:
.cont
	sNote		nWhitePSG3, $05
	sCont		.cont
	sCall		$08, .loop
	sStop


.loop
	sNote		sTie, $03
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; SpecialRumble
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=vc priority=$80
	sChannel	FM4, SpecialRumble_FM4
	sChannel	FM5, SpecialRumble_FM2
	sChannelEnd

SpecialRumble_FM4:
	sVoice		SpecialRumble
	sPan		center
	sJump		SpecialRumble_jump

SpecialRumble_FM2:
	sVoice		SpecialRumble
	sPan		center

SpecialRumble_loop:
	; this sound effect is totally fucked. Sorry not sorry
	sNote		freq(FM4. $032D), $03
	sNote		freq(FM4. $0284), $07
	sVol		$00
	sNote		freq(FM4. $043C), $0A
	sVol		$00
	sNote		freq(FM4. $0AFE), $07

SpecialRumble_jump:
	sNote		freq(FM4. $03FF), $08
	sVol		$00
	sNote		freq(FM4. $047C), $08
	sVol		$00
	sCont		SpecialRumble_loop
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; ScreenShake
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM4, ScreenShake_FM4
	sChannelEnd

ScreenShake_FM4:
	sVoice		ScreenShake
	sPan		center
	sNote		nD1, $07
	sNote		nRst, $02
	sNote		nD1, $06
	sNote		nRst
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Shake
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=vc priority=$80
	sChannel	FM5, Shake_FM2
	sChannel	FM4, Shake_FM4
	sChannelEnd

Shake_FM2:
	sVoice		Shake
	sPan		center
	sNote		nAs0, $05
	sJump		Shake_Loop00		; saves us a bit of CPU time

Shake_FM4:
	sVoice		Shake
	sPan		center

Shake_Loop00:
	sNote		nGs0, $09
	sNote		nAs0, $07
	sNote		nGs0, $09
	sNote		nAs0, $07
	sCont		Shake_Loop00
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Rumble2
; ---------------------------------------------------------------------------

	sSong		sfx index=$07 flags=v priority=$80
	sChannel	FM4, Rumble2_FM4
	sChannelEnd

Rumble2_FM4:
	sVoice		Rumble2
	sVibratoSet	Rumble2
	sVol		$04
	sNote		nCs0, $06
	sNote		nE0, $08
	sNote		nD0, $01
	sNote		nCs0, $05
	sNote		nF0, $06
	sNote		nGs0, $03
	sNote		nCs0, $08
	sNote		nG0, $04
	sNote		nCs0, $06
	sVol		$02
	sNote		nE0, $08
	sVol		$02
	sNote		nD0, $01
	sVol		$02
	sNote		nCs0, $05
	sVol		$02
	sNote		nF0, $06
	sVol		$02
	sNote		nGs0, $03
	sVol		$02
	sNote		nCs0, $08
	sVol		$02
	sNote		nG0, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Rumble
; ---------------------------------------------------------------------------

	sSong		sfx index=$06 flags=v priority=$80
	sChannel	FM4, Rumble_FM5
	sChannelEnd

Rumble_FM5:
	sVoice		Rumble
	sVibratoSet	Rumble
	sCall		$08, .loop1
	sCall		$09, .loop2
	sStop

.loop1
	sNote		nAs0, $0A
	sRet

.loop2
	sNote		nAs0, $10
	sVol		$03
	sRet

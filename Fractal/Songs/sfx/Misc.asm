; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Misc_Voice
	sHeaderSamples	Misc_Samples
	sHeaderVibrato	Misc_Vib
	sHeaderEnvelope	Misc_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Misc_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Misc_Voice:
	sNewVoice	Start
	sAlgorithm	$07
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$06, $02, $0C, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1C, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $0B, $0E, $0B
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$07, $05, $07, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$15, $10, $21, $10
	sFinishVoice

	sNewVoice	Transform
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$01, $00, $01, $01
	sMultiple	$0F, $04, $0F, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $18, $1F, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $0C, $16, $00
	sDecay2Rate	$02, $02, $02, $02
	sDecay1Level	$02, $0F, $02, $03
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$42, $11, $16, $08
	sFinishVoice

	sNewVoice	Lamppost
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
	sTotalLevel	$17, $20, $01, $01
	sFinishVoice

	sNewVoice	Signpost2P
	sAlgorithm	$07
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$0A, $0C, $0C, $0C
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2D, $12, $12, $03
	sFinishVoice

	sNewVoice	Continue
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
	sTotalLevel	$24, $10, $05, $06
	sFinishVoice

	sNewVoice	Bonus
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$00, $00, $03, $00
	sMultiple	$0A, $05, $01, $02
	sRateScale	$01, $01, $01, $01
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $16, $14, $0C
	sDecay2Rate	$00, $00, $04, $00
	sDecay1Level	$01, $0D, $06, $0F
	sReleaseRate	$0F, $08, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$03, $00, $25, $00
	sFinishVoice

	sNewVoice	Swap1
	sAlgorithm	$00
	sFeedback	$00
	sDetune		$05, $03, $00, $03
	sMultiple	$03, $00, $03, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$00, $00, $00, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0F, $06, $23, $00
	sFinishVoice

	sNewVoice	Swap2
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$07, $03, $03, $07
	sMultiple	$02, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$14, $14, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$02, $02, $08, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$35, $14, $00, $00
	sFinishVoice

	sNewVoice	Sparkle
	sAlgorithm	$07
	sFeedback	$00
	sDetune		$07, $03, $03, $07
	sMultiple	$03, $03, $03, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0F, $19, $14, $1A
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $0A, $0A, $0A
	sDecay2Rate	$0A, $0A, $0A, $0A
	sDecay1Level	$05, $05, $05, $05
	sReleaseRate	$07, $07, $07, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $1C, $1C, $1C
	sFinishVoice

	sNewVoice	PlatformKnock
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$00, $07, $00, $03
	sMultiple	$09, $00, $00, $00
	sRateScale	$00, $00, $03, $00
	sAttackRate	$1C, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $12, $0B, $0F
	sDecay2Rate	$0C, $0D, $00, $0D
	sDecay1Level	$00, $02, $0F, $0F
	sReleaseRate	$07, $0F, $0A, $0A
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $29, $00, $00
	sFinishVoice

	sNewVoice	Lazer
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $03, $03, $02
	sMultiple	$09, $04, $04, $08
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $16, $16, $16
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $04
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$15, $06, $06, $04
	sFinishVoice

	sNewVoice	LazerFloor
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$03, $03, $04, $07
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $0A, $01, $07
	sDecay2Rate	$00, $01, $01, $03
	sDecay1Level	$00, $02, $0C, $04
	sReleaseRate	$00, $03, $03, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$08, $07, $1C, $05
	sFinishVoice

	sNewVoice	PigmanWalk
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$00, $01, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0C, $1F, $11, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $11, $0E, $04
	sDecay2Rate	$1B, $09, $13, $13
	sDecay1Level	$01, $04, $01, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $05, $00, $09
	sFinishVoice

	sNewVoice	SegaKick
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$03, $01, $00, $01
	sMultiple	$02, $00, $02, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $1F, $1F, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$16, $19, $1E, $1F
	sDecay2Rate	$03, $00, $0B, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0D, $0E
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$18, $00, $01, $05
	sFinishVoice

	sNewVoice	Pump
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $11, $00
	sDecay2Rate	$00, $00, $00, $09
	sDecay1Level	$00, $0F, $0F, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$03, $1A, $10, $00
	sFinishVoice

	sNewVoice	Piff
	sAlgorithm	$06
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $04, $05, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $16, $1F, $16
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $11, $13, $10
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $08, $08, $08
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Misc_Vib:
	sVibrato PigmanWalk,	$00, $00, $8000, $0028, Triangle
	sVibrato Transform,	$01, $00, $2AA8,-$0068, Triangle
	sVibrato Signpost2P,	$01, $00, $0E00, $0580, Triangle
	sVibrato Bonus,		$01, $00, $0590, $0780, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Misc_Env:
	sEnvelope v03,		Misc_Env_v03
	sEnvelope v04,		Misc_Env_v04
; ---------------------------------------------------------------------------

Misc_Env_v03:
	sEnv		delay=$02,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Misc_Env_v04:
	sEnv		$00, $00, $10, $18, $20, $20, $28, $28
	sEnv		$28
	seHold		$30

; ===========================================================================
; ---------------------------------------------------------------------------
; Piff
; ---------------------------------------------------------------------------

	sSong		sfx index=$13 flags=v priority=$80
	sChannel	FM5, Piff_FM5
	sChannelEnd

Piff_FM5:
	sVoice		Piff
	sPortaTarget	nC0, $00
	sPortaSpeed	-$00DD
	sPan		center
	sNote		nDs3, $09
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Pump
; ---------------------------------------------------------------------------

	sSong		sfx index=$12 flags=v priority=$80
	sChannel	FM5, Pump_FM5
	sChannelEnd

Pump_FM5:
	sVoice		Pump
	sPan		center
	sNote		nD1, $10
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; SegaKick
; ---------------------------------------------------------------------------

	sSong		sfx index=$11 flags=v priority=$80
	sChannel	FM5, SegaKick_FM5
	sChannelEnd

SegaKick_FM5:
	sVoice		SegaKick
	sPan		center
	sPortaTarget	nC7, $00
	sPortaSpeed	$15A
	sNote		nC0, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; PigmanWalk
; ---------------------------------------------------------------------------

	sSong		sfx index=$10 flags=v priority=$80
	sChannel	FM5, PigmanWalk_FM5
	sChannelEnd

PigmanWalk_FM5:
	sVoice		PigmanWalk
	sVibratoSet	PigmanWalk
	sPan		center

	sNote		nC0, $0B
	sNote		$0B
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; LazerFloor
; ---------------------------------------------------------------------------

	sSong		sfx index=$0F flags=v priority=$80
	sChannel	FM4, LazerFloor_FM4
	sChannelEnd

LazerFloor_FM4:
	sVoice		LazerFloor
	sPan		center
	sNote		nC0, $04
	sNote		nRst, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; LargeLazer
; ---------------------------------------------------------------------------

	sSong		sfx index=$0E flags=v priority=$80
	sChannel	FM4, LargeLazer_FM4
	sChannel	FM5, LargeLazer_FM5
	sChannel	PSG3, LargeLazer_PSG3
	sChannel	PSG4, LargeLazer_PSG4
	sChannelEnd

LargeLazer_FM4:
	sNote		nRst, $02
	sFrac		$0008
	sVol		$12

LargeLazer_FM5:
	sVoice		Lazer
	sPan		center
	sVol		$0D
	sFrac		$0004
	sNote		nAs7, $06
	sVol		-$0C
	sNote		sTie, $06
	sVol		-$0C
	sNote		sTie, $12
	sVol		$0C
	sNote		sTie, $06
	sVol		$0C
	sNote		sTie, $06
	sStop

LargeLazer_PSG3:
	sVol		$7F
	sNote		nA6, $04
	sNote		nDs6
	sNote		nA5
	sNote		nDs5
	sNote		nA4, $10
	sStop

LargeLazer_PSG4:
	sNote		nWhitePSG3, $14
	sVol		$08
	sNote		$04
	sVol		$08
	sNote		$04
	sVol		$08
	sNote		$04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Lazer
; ---------------------------------------------------------------------------

	sSong		sfx index=$0D flags=v priority=$80
	sChannel	FM5, Lazer_FM5
	sChannelEnd

Lazer_FM5:
	sVoice		Lazer
	sPan		center
	sFrac		$0004
	sNote		nAs7, $14
	sVol		$18
	sNote		$06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; PlatformKnock
; ---------------------------------------------------------------------------

	sSong		sfx index=$0C flags=v priority=$80
	sChannel	FM5, PlatformKnock_FM5
	sChannelEnd

PlatformKnock_FM5:
	sVoice		PlatformKnock
	sPan		center
	sNote		nCs6, $15
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Sparkle
; ---------------------------------------------------------------------------

	sSong		sfx index=$0B flags=v priority=$80
	sChannel	FM4, Sparkle_FM4
	sChannelEnd

Sparkle_FM4:
	sVoice		Sparkle
	sPan		center
	sNote		nE6, $05
	sNote		nG6, $05
	sNote		nC7, $2B
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Beep
; ---------------------------------------------------------------------------

	sSong		sfx index=$0A flags=v priority=$80
	sChannel	PSG1, Beep_PSG1
	sChannelEnd

Beep_PSG1:
	sVolEnv		v04
	sVol		$18
	sNote		nD5, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Swap
; ---------------------------------------------------------------------------

	sSong		sfx index=$09 flags=v priority=$80
	sChannel	FM4, Swap_FM4
	sChannel	FM5, Swap_FM5
	sChannel	PSG2, Swap_PSG2
	sChannel	PSG3, Swap_PSG3
	sChannel	PSG4, Swap_PSG4
	sChannelEnd

Swap_FM4:
	sFrac		$3A

Swap_FM5:
	sVol		$10
	sVoice		Swap2
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	-$00A0
	sNote		nDs5, $24
	sPortaSpeed	$0000

	sVoice		Swap1
	sVol		-$10
	sCall		$20, .loop45
	sStop

.loop45
	sNote		nAs4, $02, sTie
	sVol		$02
	sFrac		$0100
	sRet

Swap_PSG2:
	sNote		nCut, $16
	sVolEnv		v03
	sCall		$05, .loop2_1
	sCall		$07, .loop2_2
	sStop

.loop2_1
	sNote		nD6, $04
	sNote		nE6
	sNote		nFs6
	sVol		$08
	sFrac		-$0100
	sRet

.loop2_2
	sNote		nD6, $04
	sNote		nE6
	sNote		nFs6
	sVol		$08
	sFrac		$0100
	sRet

Swap_PSG3:
	sNote		nCut, $07
	sVol		$7F
	sPortaSpeed	-$0090
	sNote		nAs5, $8D
	sStop

Swap_PSG4:
	sNote		nCut, $07
	sNote		nWhitePSG3, $1D
	sCall		$10, .loop4
	sStop

.loop4
	sNote		sTie, $07
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Bonus
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=v priority=$80
	sChannel	FM5, Bonus_FM5
	sChannelEnd

Bonus_FM5:
	sVoice		Bonus
	sPan		center
	sVibratoSet	Bonus
	sNote		nAs5, $1A
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Continue
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	FM5, Continue_FM5
	sChannel	FM4, Continue_FM4
	sChannel	FM2, Continue_FM2
	sChannelEnd

Continue_FM2:
	sVoice		Continue
	sPan		center
	sNote		nC5, $07
	sNote		nE5
	sNote		nG5
	sNote		nD5
	sNote		nF5
	sNote		nA5
	sNote		nE5
	sNote		nG5
	sNote		nB5
	sNote		nF5
	sNote		nA5
	sNote		nC6
	sCall		$08, .loop1
	sStop

.loop1
	sNote		nG5, $07
	sNote		nB5
	sNote		nD6
	sVol		$05
	sRet

Continue_FM4:
	sNote		nRst, $07
	sVoice		Continue
	sPan		center
	sFrac		$0018
	sNote		nE5, $15
	sNote		nF5
	sNote		nG5
	sNote		nA5
	sCall		$08, .loop2
	sStop

.loop2
	sNote		nB5, $15
	sVol		$05
	sRet

Continue_FM5:
	sVoice		Continue
	sPan		center
	sFrac		$0018
	sNote		nC5, $15
	sNote		nD5
	sNote		nE5
	sNote		nF5
	sCall		$08, .loop3
	sStop

.loop3
	sNote		nG5, $15
	sVol		$05
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Signpost 2P
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, Signpost2P_FM5
	sChannelEnd

Signpost2P_FM5:
	sVoice		Signpost2P
	sVibratoSet	Signpost2P
	sPan		center
	sNote		nDs2, $28
	sVol		$04
	sNote		sTie, $14
	sVol		$04
	sNote		sTie, $14
	sVol		$04
	sNote		sTie, $0A
	sVol		$04
	sNote		sTie, $0A
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Signpost
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	PSG2, Signpost_PSG2
	sChannelEnd

Signpost_PSG2:
	sVolEnv		v03
	sCall		$05, Signpost_Loop00
	sCall		$07, Signpost_Loop01
	sStop

Signpost_Loop00:
	sNote		nD6, $04
	sNote		nE6
	sNote		nFs6
	sVol		$08
	sFrac		-$0100
	sRet

Signpost_Loop01:
	sNote		nD6
	sNote		nE6
	sNote		nFs6
	sVol		$08
	sFrac		$0100
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Lamppost
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=v priority=$80
	sChannel	FM5, Lamppost_FM5
	sChannelEnd

Lamppost_FM5:
	sVoice		Lamppost
	sPan		center
	sNote		nC5, $06
	sNote		nA4, $16
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Transform
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=v priority=$80
	sChannel	FM4, Transform_FM4
	sChannel	FM5, Transform_FM5
	sChannelEnd

Transform_FM4:
	sNote		nRst, $03
	sVol		$07
	sFrac		-$07

Transform_FM5:
	sVoice		Transform
	sVibratoSet	Transform
	sPan		center
	sCall		$05, .loop
	sStop

.loop
	sNote		nCs3, $13
	sVol		$14
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

	sSong		sfx index=$14 flags=v priority=$80
	sChannel	FM4, Start_FM4
	sChannel	FM5, Start_FM5
	sChannelEnd

Start_FM4:
	sVol		$08

Start_FM5:
	sVoice		Start
	sPan		center
	sCall		$02, Start_Loop00
	sStop

Start_Loop00:
	sNote		nB5, $02
	sNote		nFs5, $02
	sNote		nC5, $02
	sVol		$03
	sRet

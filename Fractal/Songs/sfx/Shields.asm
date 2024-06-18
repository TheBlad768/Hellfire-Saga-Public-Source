; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Shields_Voice
	sHeaderSamples	Shields_Samples
	sHeaderVibrato	Shields_Vib
	sHeaderEnvelope	Shields_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Shields_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Shields_Voice:
	sNewVoice	LightShield
	sAlgorithm	$06
	sFeedback	$06
	sDetune		$00, $00, $01, $00
	sMultiple	$07, $0E, $00, $0C
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $0D, $0D, $0E
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$17, $00, $00, $00
	sFinishVoice

	sNewVoice	LightAttack
	sAlgorithm	$03
	sFeedback	$00
	sDetune		$03, $07, $00, $00
	sMultiple	$02, $00, $04, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$00, $0C, $0D, $0B
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$08, $10, $0D, $05
	sFinishVoice

	sNewVoice	BubbleShield
	sAlgorithm	$05
	sFeedback	$00
	sDetune		$01, $02, $00, $03
	sMultiple	$01, $03, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0B, $0E, $0C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $04, $00, $00
	sDecay2Rate	$08, $09, $06, $0B
	sDecay1Level	$0F, $0B, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$09, $0A, $0A, $0A
	sFinishVoice

	sNewVoice	BubbleAttack
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$00, $02, $00, $02
	sMultiple	$02, $02, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0B, $0B, $00, $00
	sDecay2Rate	$00, $00, $0E, $0E
	sDecay1Level	$0F, $0F, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$14, $14, $00, $00
	sFinishVoice

	sNewVoice	FireShield
	sAlgorithm	$04
	sFeedback	$01
	sDetune		$00, $03, $02, $03
	sMultiple	$01, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $0E, $0C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $04, $00, $00
	sDecay2Rate	$08, $08, $12, $0C
	sDecay1Level	$0F, $0B, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$03, $0D, $00, $00
	sFinishVoice

	sNewVoice	BlueShield
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$00, $01, $00, $03
	sMultiple	$05, $03, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0B, $10, $1C, $0D
	sAmpMod	$00, $00, $00, $00
	sDecay1Rate	$00, $04, $00, $00
	sDecay2Rate	$00, $00, $00, $0C
	sDecay1Level	$00, $01, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0B, $0C, $17, $04
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Shields_Vib:
	sVibrato BubbleAttack,	$03, $00, $0400, $0800, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Shields_Env:
	sEnvelope v17,		Shields_Env_v17
; ---------------------------------------------------------------------------

Shields_Env_v17:
	sEnv		delay=$01,	$08, $00
	sEnv		delay=$03,	$00, $08, $10
	sEnv		delay=$04,	$18
	sEnv		delay=$03,	$20
	seHold		$28

; ===========================================================================
; ---------------------------------------------------------------------------
; FireAttack
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=v priority=$80
	sChannel	PSG3, FireAttack_PSG3
	sChannel	PSG4, FireAttack_PSG4
	sChannelEnd

FireAttack_PSG3:
	sVol		$7F
	sNote		nD4, $35
	sStop

FireAttack_PSG4:
	sNote		nWhitePSG3, $15
	sCall		$10, FireAttack_Loop01
	sStop

FireAttack_Loop01:
	sNote		sHold, $02
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FireShield
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	FM5, FireShield_FM5
	sChannelEnd

FireShield_FM5:
	sVoice		FireShield
	sPan		center
	sNote		nAs0, $05
	sNote		sHold, nB0, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; BubbleAttack
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=v priority=$80
	sChannel	FM5, BubbleAttack_FM5
	sChannelEnd

BubbleAttack_FM5:
	sVoice		BubbleAttack
	sVibratoSet	BubbleAttack
	sPan		center
	sNote		nF1, $20
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; BubbleShield
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=v priority=$80
	sChannel	FM5, BubbleShield_FM5
	sChannelEnd

BubbleShield_FM5:
	sVoice		BubbleShield
	sPan		center
	sFrac		-$0A00
	sNote		nAs2, $05
	sNote		sHold, nB2, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; LightAttack
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, LightAttack_FM5
	sChannelEnd

LightAttack_FM5:
	sVoice		LightAttack
	sPan		center
	sNote		nDs3, $1B
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; LightShield
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	FM5, LightShield_FM5
	sChannelEnd

LightShield_FM5:
	sVoice		LightShield
	sPan		center
	sNote		nGs3, $05
	sNote		sHold, nA3, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; BlueShield
; ---------------------------------------------------------------------------

	sSong		sfx index=$11 flags=v priority=$80
	sChannel	FM5, BlueShield_FM5
	sChannelEnd

BlueShield_FM5:
	sVoice		BlueShield
	sPan		center
	sFrac		-$0400
	sNote		nAs2, $05
	sNote		sHold, nB2, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; InstaShield
; ---------------------------------------------------------------------------

	sSong		sfx index=$10 flags=v priority=$80
	sChannel	PSG3, InstaShield_PSG3
	sChannel	PSG4, InstaShield_PSG4
	sChannelEnd

InstaShield_PSG3:
	sVol		$7F
	sNote		nD1, $04

	; NOTE: This is a completely broken modulation in SMPS. Using special freq() function to calculate the accurate
	; frequency offsets for Fractal
	sNote		freq(PSG3. $011), $01
	sNote		freq(PSG3. $017)
	sNote		freq(PSG3. $01D)
	sNote		freq(PSG3. $023)
	sNote		freq(PSG3. $01D)
	sNote		freq(PSG3. $017)
	sNote		freq(PSG3. $011)
	sNote		freq(PSG3. $00B)
	sNote		freq(PSG3. $005)
	sNote		freq(PSG3. $00F)
	sNote		freq(PSG3. $009)
	sNote		freq(PSG3. $00F)
	sNote		freq(PSG3. $005)
	sNote		freq(PSG3. $00B)
	sNote		freq(PSG3. $011)
	sNote		freq(PSG3. $017)
	sStop

InstaShield_PSG4:
	sVolEnv		v17
	sNote		nWhitePSG3, $04
	sNote		$10
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Player_Voice
	sHeaderSamples	Player_Samples
	sHeaderVibrato	Player_Vib
	sHeaderEnvelope	Player_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Player_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Player_Voice:
	sNewVoice	Death
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$03, $03, $03, $03
	sMultiple	$00, $00, $00, $00
	sRateScale	$02, $03, $03, $03
	sAttackRate	$1E, $1C, $18, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $04, $0A, $05
	sDecay2Rate	$08, $08, $08, $08
	sDecay1Level	$0B, $0B, $0B, $0B
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$14, $14, $3C, $00
	sFinishVoice

	sNewVoice	Drown
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$01, $00, $01, $00
	sMultiple	$04, $04, $0A, $09
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0E, $11, $10, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $03, $15, $06
	sDecay2Rate	$16, $09, $0E, $10
	sDecay1Level	$02, $04, $02, $04
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2F, $12, $12, $00
	sFinishVoice

	sNewVoice	DrownDing
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

	sNewVoice	HitSpikes
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$03, $03, $03, $03
	sMultiple	$0C, $00, $09, $01
	sRateScale	$03, $00, $00, $03
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$04, $04, $05, $01
	sDecay2Rate	$04, $04, $04, $02
	sDecay1Level	$0F, $01, $00, $0A
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$29, $0F, $20, $00
	sFinishVoice

	sNewVoice	HitBoss
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

	sNewVoice	Grab
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $01, $01, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1A, $12, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $1F, $00, $00
	sDecay1Level	$0F, $0F, $00, $00
	sDecay2Rate	$09, $0A, $13, $12
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $00, $00
	sFinishVoice

	sNewVoice	KnucklesKick
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

	sNewVoice	Roll
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $04, $00
	sMultiple	$00, $02, $04, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $15
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $1F, $00
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$8D, $A8, $00, $00
	sFinishVoice

	sNewVoice	Splash
	sAlgorithm	$00
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $02, $03, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$19, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$12, $14, $11, $0F
	sDecay2Rate	$0A, $0A, $00, $0D
	sDecay1Level	$0F, $0F, $0F, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$22, $27, $07, $03
	sFinishVoice

	sNewVoice	Teleport
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$09, $00, $03, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $0C, $0C, $0C
	sDecay1Level	$01, $04, $02, $02
	sDecay2Rate	$0B, $10, $1F, $05
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$09, $12, $04, $0E
	sFinishVoice

	sNewVoice	Spindash
	sAlgorithm	$04
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $03, $0C, $09
	sRateScale	$02, $02, $02, $03
	sAttackRate	$1F, $0C, $0F, $15
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$80, $9C, $00, $00
	sFinishVoice

	sNewVoice	Bubble
	sAlgorithm	$05
	sFeedback	$06
	sDetune		$00, $00, $00, $00
	sMultiple	$05, $08, $09, $07
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $0D, $0D, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $03, $15, $06
	sDecay1Level	$02, $01, $02, $01
	sDecay2Rate	$16, $09, $0E, $10
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$15, $12, $12, $00
	sFinishVoice

	sNewVoice	Flying
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $12, $0D, $14
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $1F, $00, $00
	sDecay1Level	$0F, $0F, $00, $00
	sDecay2Rate	$09, $0A, $13, $12
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $2B, $0B
	sFinishVoice

	sNewVoice	GlideLand
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $0A, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $15, $16, $0F
	sDecay1Level	$00, $0F, $0A, $0F
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $04, $00, $00
	sFinishVoice

	sNewVoice	Thump
	sAlgorithm	$00
	sFeedback	$04
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $11, $00
	sDecay1Level	$00, $0F, $0F, $00
	sDecay2Rate	$00, $00, $00, $09
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$03, $1A, $10, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Player_Vib:
	sVibrato Roll,		$03, $00, $01BB, $0600, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Player_Env:
	sEnvelope v07,		Player_Env_v07
; ---------------------------------------------------------------------------

Player_Env_v07:
	sEnv		delay=$06,	$00
	sEnv		delay=$05,	$08, $10
	sEnv		delay=$03,	$18, $20, $28
	sEnv		delay=$01,	$30
	seHold		$38

; ===========================================================================
; ---------------------------------------------------------------------------
; Thump
; ---------------------------------------------------------------------------

	sSong		sfx index=$11 flags=v priority=$80
	sChannel	FM5, Thump_FM5
	sChannelEnd

Thump_FM5:
	sVoice		Thump
	sPan		center
	sNote		nD1, $10
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Ground Sliding
; ---------------------------------------------------------------------------

	sSong		sfx index=$10 flags=v priority=$80
	sChannel	PSG3, GroundSlide_PSG3
	sChannel	PSG4, GroundSlide_PSG4
	sChannelEnd

GroundSlide_PSG3:
	sVol		$7F
	sNote		freq(PSG3. $002), $01
	sNote		freq(PSG3. $003)
	sNote		freq(PSG3. $004)
	sNote		freq(PSG3. $005)
	sNote		freq(PSG3. $006)
	sNote		freq(PSG3. $007)
	sNote		freq(PSG3. $008)
	sNote		freq(PSG3. $009)
	sNote		freq(PSG3. $013)
	sNote		freq(PSG3. $014)
	sNote		freq(PSG3. $015)
	sNote		freq(PSG3. $016)
	sNote		freq(PSG3. $017)
	sNote		freq(PSG3. $018), $02
	sStop

GroundSlide_PSG4:
	sVol		$18
	sNote		nWhitePSG3, $09
	sVol		$20
	sNote		$06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Glide Landing
; ---------------------------------------------------------------------------

	sSong		sfx index=$0F flags=v priority=$80
	sChannel	FM5, GlideLand_FM5
	sChannelEnd

GlideLand_FM5:
	sVoice		GlideLand
	sPan		center
	sNote		nG2, $03
	sNote		nB2, $07
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Flying Tired
; ---------------------------------------------------------------------------

	sSong		sfx index=$0E flags=v priority=$80
	sChannel	FM5, FlyTired_FM5
	sChannelEnd

FlyTired_FM5:
	sVoice		Flying
	sPan		center
	sNote		nAs1, $08, $08
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Flying
; ---------------------------------------------------------------------------

	sSong		sfx index=$0D flags=v priority=$80
	sChannel	FM5, Flying_FM5
	sChannelEnd

Flying_FM5:
	sVoice		Flying
	sPan		center
	sNote		nD3, $06, $06, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Bubble
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=v priority=$80
	sChannel	FM5, Bubble_FM5
	sChannelEnd

Bubble_FM5:
	sVoice		Bubble
	sPan		center
	sPortaTarget	nC0, $00
	sNote		nDs4, $01
	sPortaSpeed	$00B0
	sNote		sTie, $06
	sPortaSpeed	$0000
	sNote		nRst, $06
	sNote		nAs4, $01
	sPortaSpeed	$00D8
	sNote		sTie, $07
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Teleport
; ---------------------------------------------------------------------------

	sSong		sfx index=$0C flags=v priority=$80
	sChannel	FM5, Teleport_FM5
	sChannel	PSG3, Teleport_PSG3
	sChannel	PSG4, Teleport_PSG4
	sChannelEnd

Teleport_FM5:
	sSpinReset
	sVoice		Teleport
	sPan		center
	sPortaSpeed	-$0145
	sPortaTarget	nC0, $00
	sNote		nGs7, $07
	sStop

Teleport_PSG3:
	sNote		nCut, $07
	sVol		$7F
	sPortaSpeed	-$0080
	sPortaTarget	nC0, $00
	sNote		nAs5, $4F
	sStop

Teleport_PSG4:
	sNote		nCut, $07
	sVolEnv		v07
	sNote		nWhitePSG3, $4F
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Spindash
; ---------------------------------------------------------------------------

	sSong		sfx index=$0B flags=v priority=$80
	sChannel	FM5, Spindash_FM5
	sChannelEnd

Spindash_FM5:
	sSpinRev
	sVoice		Spindash
	sPan		center

	sPortaTarget	nC6, $18
	sPortaSpeed	$0081
	sNote		nC5, $1A
	sCall		$18, .loop
	sSpinReset
	sStop

.loop
	sNote		sHold, $02
	sVol		$02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Splash
; ---------------------------------------------------------------------------

	sSong		sfx index=$0A flags=v priority=$80
	sChannel	FM5, Splash_FM5
	sChannel	PSG3, Splash_PSG3
	sChannel	PSG4, Splash_PSG4
	sChannelEnd

Splash_FM5:
	sVoice		Splash
	sPan		center
	sNote		nCs3, $14
	sStop

Splash_PSG3:
	sVol		$7F
	sNote		nF6, $05
	sNote		nA6, $6E
	sStop

Splash_PSG4:
	sNote		nWhitePSG3, $05
	sNote		$05
	sCall		$0F, Splash_Loop00
	sStop

Splash_Loop00:
	sNote		sHold, $07
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Skid
; ---------------------------------------------------------------------------

	sSong		sfx index=$09 flags=v priority=$80
	sChannel	PSG2, Skid_PSG2
	sChannel	PSG1, Skid_PSG1
	sChannelEnd

Skid_PSG1:
	sNote		nCut, $01
	sNote		nGs3
	sNote		nCut
	sNote		nGs3
	sNote		nCut, $03
	sCall		$0B, Skid_Loop00
	sStop

Skid_Loop00:
	sNote		nGs3, $01
	sNote		nCut, $01
	sRet

Skid_PSG2:
	sNote		nAs3, $01
	sNote		nCut
	sNote		nAs3
	sNote		nCut, $03
	sCall		$0B, Skid_Loop01
	sStop

Skid_Loop01:
	sNote		nAs3, $01
	sNote		nCut, $01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Roll
; ---------------------------------------------------------------------------

	sSong		sfx index=$08 flags=v priority=$80
	sChannel	FM4, Roll_FM4
	sChannelEnd

Roll_FM4:
	sNote		nRst, $01
	sPan		center
	sVol		$05
	sVoice		Roll
	sVibratoSet	Roll
	sNote		nCs7, $25
	sVibratoOff
	sCall		$2A, .loop
	sStop

.loop
	sNote		sHold
	sVol		$01
	sNote		nG7, $02
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; KnucklesKick
; ---------------------------------------------------------------------------

	sSong		sfx index=$07 flags=v priority=$80
	sChannel	FM5, KnucklesKick_FM5
	sChannelEnd

KnucklesKick_FM5:
	sVoice		KnucklesKick
	sPan		center
	sNote		nC0, $05
	sNote		nD0
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Grab
; ---------------------------------------------------------------------------

	sSong		sfx index=$06 flags=v priority=$80
	sChannel	FM5, Grab_FM5
	sChannelEnd

Grab_FM5:
	sVoice		Grab
	sPan		center
	sNote		nA2, $06
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; HitSpikes
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	FM5, HitSpikes_FM5
	sChannelEnd

HitSpikes_FM5:
	sVoice		HitSpikes
	sPortaTarget	nC0, $00
	sPortaSpeed	$0050
	sPan		center
	sNote		nE5, $05
	sNote		nC6, $25
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Death
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=vu priority=$80
	sChannel	FM5, DrownDing_FM5
	sChannelEnd

DrownDing_FM5:
	sVoice		DrownDing
	sPan		center
	sNote		nA5, $08
	sNote		nA5, $25
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Drown
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=vu priority=$80
	sChannel	FM4, Drown_FM4
	sChannel	FM5, Drown_FM5
	sChannelEnd

Drown_FM5:
	sVol		$02
	sVoice		Drown
	sPan		center
	sCall		$0A, Drown_Loop01
	sStop

Drown_Loop01:
	sCall		$02, .loopB1
	sVol		$03
	sRet

.loopB1
	sNote		      freq(FM5. $0C43), $01
	sNote		sTie, freq(FM5. $0BC6), $01
	sNote		sTie, freq(FM5. $0B49), $01
	sNote		sTie, freq(FM5. $0ACC), $01
	sNote		sTie, freq(FM5. $0A4F), $01
	sRet

Drown_FM4:
	sNote		nRst, $06
	sVol		$04
	sVoice		Drown
	sPan		center
	sCall		$0A, Drown_Loop00
	sStop

Drown_Loop00:
	sCall		$02, .loopC2
	sNote		sTie, freq(FM4. $14AF), $01
	sVol		$03
	sRet

.loopC2
	sNote		      freq(FM4. $12F3), $01
	sNote		sTie, freq(FM4. $1362), $01
	sNote		sTie, freq(FM4. $13D1), $01
	sNote		sTie, freq(FM4. $1440), $01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Death
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, Death_FM5
	sChannelEnd

Death_FM5:
	sVoice		Death
	sPan		center
	sNote		nB2, $07
	sNote		sHold, nGs2, $01
	sCall		$2E, Death_Loop00
	sStop

Death_Loop00:
	sVol		$01
	sNote		$01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Jump
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	PSG1, Jump_PSG1
	sChannelEnd

Jump_PSG1:
	sSpinReset
	sNote		nF2, $05
	sNote		nAs2, $02
	sPortaSpeed	$00F9
	sPortaTarget	nE4, $80
	sNote		sTie, $13
	sStop

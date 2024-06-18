; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	BigBoss_Voice
	sHeaderSamples	BigBoss_Samples
	sHeaderVibrato	BigBoss_Vib
	sHeaderEnvelope	BigBoss_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FC
	sChannel	DAC1, BigBoss_DAC1
	sChannel	FM1, BigBoss_FM1
	sChannel	FM2, BigBoss_FM4
	sChannel	FM3, BigBoss_FM2
	sChannel	FM4, BigBoss_FM3
	sChannel	FM5, BigBoss_FM5
	sChannel	PSG1, BigBoss_PSG2
	sChannel	PSG2, BigBoss_PSG1
	sChannel	PSG3, BigBoss_PSG3
	sChannel	PSG4, BigBoss_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

BigBoss_Voice:
	sNewVoice	v00
	sAlgorithm	$03
	sFeedback	$05
	sDetune		$03, $05, $05, $05
	sMultiple	$0E, $00, $01, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1B, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0E, $04
	sDecay2Rate	$07, $01, $01, $01
	sDecay1Level	$05, $0F, $05, $07
	sReleaseRate	$04, $06, $05, $04
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $17, $1C, $0C
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$00
	sFeedback	$05
	sDetune		$03, $07, $05, $03
	sMultiple	$03, $00, $03, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1F, $1C, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$14, $01, $05, $01
	sDecay2Rate	$00, $00, $01, $1D
	sDecay1Level	$01, $01, $02, $0F
	sReleaseRate	$01, $00, $01, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $12, $1B, $0C
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$05, $05, $05, $05
	sMultiple	$03, $01, $01, $01
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0E, $04
	sDecay2Rate	$04, $03, $03, $08
	sDecay1Level	$0F, $07, $03, $06
	sReleaseRate	$07, $01, $01, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1B, $10, $11, $0C
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$03, $05, $00, $00
	sMultiple	$03, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$10, $1A, $13, $1B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $1F, $1F, $1F
	sDecay2Rate	$01, $01, $01, $01
	sDecay1Level	$03, $00, $00, $00
	sReleaseRate	$03, $03, $03, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $19, $1A, $05
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$00
	sFeedback	$05
	sDetune		$03, $07, $05, $03
	sMultiple	$03, $00, $03, $00
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1F, $1C, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$14, $01, $05, $01
	sDecay2Rate	$00, $00, $01, $1D
	sDecay1Level	$01, $01, $02, $0F
	sReleaseRate	$01, $00, $01, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $12, $1B, $0F
	sFinishVoice

	sNewVoice	v05
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$05, $05, $05, $05
	sMultiple	$03, $01, $01, $01
	sRateScale	$03, $00, $03, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $07, $0E, $04
	sDecay2Rate	$04, $03, $03, $08
	sDecay1Level	$0F, $07, $03, $06
	sReleaseRate	$07, $01, $01, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1B, $10, $11, $0F
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

BigBoss_Samples:
	sNewSample	Kick
	sSampFreq	$0100
	sSampStart	dsKick, deKick
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Snare
	sSampFreq	$0100
	sSampStart	dsSnare, deSnare
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Crash3
	sSampFreq	$0100
	sSampStart	dsCrash, deCrash
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Timpani7
	sSampFreq	$00A0
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

BigBoss_Vib:
	sVibrato FM2,		$16, $00, $2490, $0062, Triangle
	sVibrato PSG1,		$00, $00, $2AA8,-$0020, Sine

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

BigBoss_Env:
	sEnvelope v02,		BigBoss_Env_v02
	sEnvelope v05,		BigBoss_Env_v05
; ---------------------------------------------------------------------------

BigBoss_Env_v02:
	sEnv		delay=$01,	$00, $10, $20, $30, $40
	seMute
; ---------------------------------------------------------------------------

BigBoss_Env_v05:
	sEnv		delay=$0A,	$00
	sEnv		delay=$0E,	$08
	sEnv		delay=$08,	$10, $18
	seHold		$20

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

BigBoss_DAC1:
	sPan		center
	sVol		$04

BigBoss_Jump00:
	sNote		nRst, $01
	sSample		Crash3
	sNote		nSample, $11
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$1B
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$12
	sNote		$09
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$12
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Kick
	sNote		$1B
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$09

	sCall		$03, BigBoss_Loop00
	sSample		Crash3
	sNote		$1B
	sSample		Snare
	sNote		$09
	sNote		$05
	sNote		$04
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$05
	sNote		$04
	sNote		$09

	sCall		$03, BigBoss_Loop00
	sSample		Crash3
	sNote		$1B
	sSample		Snare
	sNote		$09
	sNote		$05
	sNote		$04
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$05
	sNote		$04
	sNote		$12

	sCall		$07, BigBoss_Loop02
	sNote		$09
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$09

	sCall		$06, BigBoss_Loop02
	sNote		$09
	sNote		$09
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$12
	sNote		$09
	sNote		$09
	sNote		$12
	sNote		$09
	sNote		$12
	sNote		$05
	sNote		$04
	sNote		$09
	sNote		$09
	sNote		$09
	sJump		BigBoss_Jump00

BigBoss_Loop00:
	sSample		Crash3
	sNote		$1B
	sSample		Snare
	sNote		$09
	sNote		$05
	sNote		$04
	sSample		Kick
	sNote		$09
	sSample		Snare
	sNote		$09
	sSample		Timpani7
	sNote		$09
	sRet

BigBoss_Loop02:
	sSample		Crash3
	sNote		$12
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$09
	sNote		$09
	sSample		Snare
	sNote		$12
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

BigBoss_FM1:
	sVoice		v00
	sPan		center

BigBoss_Jump05:
	sNote		nRst, $01
	sNote		nCs3, $06
	sCall		$0F, BigBoss_Loop2C
	sCall		$05, BigBoss_Loop2D

	sNote		nRst, $02
	sNote		nE3, $07
	sNote		nRst, $02
	sNote		nA2, $07
	sNote		nRst, $02
	sNote		nB2, $10

	sCall		$03, BigBoss_Loop2E
	sCall		$04, BigBoss_Loop2F
	sCall		$10, BigBoss_Loop2C
	sCall		$05, BigBoss_Loop2D
	sNote		nRst, $02
	sNote		nE3, $07
	sNote		nRst, $02
	sNote		nA2, $07
	sNote		nRst, $02
	sNote		nB2, $10

	sCall		$04, BigBoss_Loop2E
	sNote		nRst, $02
	sVol		-$01

	sFrac		$002D		; ssDetune $0D
	sNote		nB2, $01
	sFrac		$0023		; ssDetune $0C
	sNote		sHold, nC3
	sFrac		$0020		; ssDetune $12
	sNote		sHold, nCs3
	sFrac		-$0011		; ssDetune $10
	sNote		sHold, nD3
	sFrac		-$000A		; ssDetune $0F
	sNote		sHold, nDs3
	sFrac		$0025		; ssDetune $17
	sNote		sHold, nE3
	sFrac		-$000C		; ssDetune $16
	sNote		sHold, nF3
	sFrac		-$006E		; ssDetune $00
	sNote		sHold, nFs3, $02
	sFrac		-$0069		; ssDetune $EB
	sNote		sHold, $01
	sFrac		$0009		; ssDetune $EE
	sNote		sHold, nF3
	sFrac		$00D1		; ssDetune $14
	sNote		sHold, nDs3
	sNote		sHold, nD3
	sFrac		-$00ED		; ssDetune $EC
	sNote		sHold, $01
	sFrac		$00D3		; ssDetune $0D
	sNote		sHold, nC3
	sFrac		-$0026		; ssDetune $0E
	sNote		sHold, nB2
	sFrac		-$0031		; ssDetune $00
	sNote		sHold, $09
	sVol		$01

	sCall		$07, BigBoss_Loop2D
	sNote		nRst, $02
	sNote		nGs2, $10
	sCall		$06, BigBoss_Loop34

	sNote		nRst, $02
	sNote		nFs2, $10
	sCall		$06, BigBoss_Loop35

	sNote		nRst, $02
	sNote		nE3, $10
	sCall		$07, BigBoss_Loop36
	sCall		$07, BigBoss_Loop2D

	sNote		nRst, $02
	sNote		nGs2, $10
	sCall		$06, BigBoss_Loop34

	sNote		nRst, $02
	sNote		nAs2, $10
	sCall		$06, BigBoss_Loop39

	sNote		nRst, $02
	sNote		nGs2, $10
	sCall		$07, BigBoss_Loop34
	sCall		$08, BigBoss_Loop2C
	sCall		$08, BigBoss_Loop2F
	sCall		$08, BigBoss_Loop2E
	sCall		$08, BigBoss_Loop39
	sCall		$08, BigBoss_Loop2D
	sCall		$08, BigBoss_Loop34
	sCall		$08, BigBoss_Loop41
	sCall		$03, BigBoss_Loop34

	sNote		nRst, $02
	sNote		nGs2, $10
	sCall		$03, BigBoss_Loop34
	sCall		$08, BigBoss_Loop2C
	sCall		$08, BigBoss_Loop2F
	sCall		$08, BigBoss_Loop2E
	sCall		$08, BigBoss_Loop39
	sCall		$08, BigBoss_Loop2D
	sCall		$04, BigBoss_Loop2E
	sCall		$04, BigBoss_Loop34
	sCall		$03, BigBoss_Loop2D

	sNote		nRst, $02
	sNote		nB2, $10
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $02
	sNote		nCs3, $10
	sNote		nRst, $02
	sNote		nCs4, $07
	sNote		nRst, $02
	sNote		nB3, $07
	sNote		nRst, $02
	sNote		nGs3, $07
	sNote		nRst, $02
	sNote		nFs3, $07
	sNote		nRst, $02
	sNote		nE3, $07
	sNote		nRst, $02
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $02
	sJump		BigBoss_Jump05

BigBoss_Loop2C:
	sNote		nRst, $02
	sNote		nCs3, $07
	sRet

BigBoss_Loop2D:
	sNote		nRst, $02
	sNote		nA2, $07
	sRet

BigBoss_Loop2E:
	sNote		nRst, $02
	sNote		nB2, $07
	sRet

BigBoss_Loop2F:
	sNote		nRst, $02
	sNote		nC3, $07
	sRet

BigBoss_Loop34:
	sNote		nRst, $02
	sNote		nGs2, $07
	sRet

BigBoss_Loop35:
	sNote		nRst, $02
	sNote		nFs2, $07
	sRet

BigBoss_Loop36:
	sNote		nRst, $02
	sNote		nE3, $07
	sRet

BigBoss_Loop39:
	sNote		nRst, $02
	sNote		nAs2, $07
	sRet

BigBoss_Loop41:
	sNote		nRst, $02
	sNote		nG2, $07
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

BigBoss_FM2:
	sVibratoSet	FM2
	sVol		$03

BigBoss_Jump04:
	sVoice		v04
	sPan		left
	sNote		nRst, $01
	sNote		nGs2, $04
	sNote		nRst

	sCall		$05, BigBoss_Loop26
	sVol		$02
	sCall		$07, BigBoss_Loop27
	sNote		nDs2, $0E
	sCall		$07, BigBoss_Loop28
	sNote		nRst, $04
	sVol		-$02
	sCall		$05, BigBoss_Loop29
	sNote		nGs2, $05
	sNote		nRst, $04
	sVol		$02
	sCall		$07, BigBoss_Loop27
	sNote		nDs2, $0E
	sCall		$07, BigBoss_Loop28
	sNote		nRst, $04
	sVol		$03
	sNote		nA2, $3F
	sNote		nGs2, $48
	sNote		nFs2
	sNote		nE2, $51
	sNote		nA2, $3F
	sNote		nGs2, $48
	sNote		nAs2
	sNote		nC3, $23
	sNote		nRst, $01
	sNote		nC3, $2C
	sNote		nRst, $01

	sPan		center
	sVoice		v03
	sNote		nCs4, $09
	sFrac		-$003C		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$006B		; ssDetune $07
	sNote		sHold, nC4
	sFrac		-$0071		; ssDetune $ED
	sNote		sHold, $01
	sFrac		$0038		; ssDetune $FD
	sNote		sHold, nB3
	sFrac		$005C		; ssDetune $17
	sNote		sHold, nAs3
	sFrac		-$00AE		; ssDetune $E9
	sNote		sHold, $01
	sFrac		$006C		; ssDetune $04
	sNote		sHold, nA3
	sFrac		$0070		; ssDetune $1D
	sNote		sHold, nGs3
	sFrac		-$0080		; ssDetune $00

	sNote		nRst
	sNote		nGs3, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $11
	sNote		nRst, $01

	sNote		nGs4, $12
	sFrac		-$0050		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0030		; ssDetune $F9
	sNote		sHold, nG4
	sFrac		$0011		; ssDetune $FD
	sNote		sHold, nFs4
	sFrac		$0032		; ssDetune $07
	sNote		sHold, nF4
	sFrac		$0032		; ssDetune $10
	sNote		sHold, nE4
	sFrac		$000B		; ssDetune $11
	sNote		sHold, nDs4
	sFrac		-$00CB		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0033		; ssDetune $F7
	sNote		sHold, nD4
	sFrac		$0038		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01

	sNote		nCs5, $12
	sFrac		$0072		; ssDetune $11
	sNote		sHold, nC5, $01
	sFrac		-$0068		; ssDetune $03
	sNote		sHold, nB4
	sFrac		$006A		; ssDetune $1D
	sNote		sHold, nA4
	sFrac		-$005A		; ssDetune $06
	sNote		sHold, nGs4
	sFrac		-$005F		; ssDetune $F1
	sNote		sHold, nG4
	sFrac		$005E		; ssDetune $05
	sNote		sHold, nF4
	sFrac		-$005D		; ssDetune $F4
	sNote		sHold, nE4
	sFrac		$009D		; ssDetune $0F
	sNote		sHold, nD4
	sFrac		-$0059		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01
	sNote		nGs4, $23
	sNote		nRst, $01
	sNote		nFs4, $23
	sNote		nRst, $01
	sNote		nCs4, $04
	sNote		nRst, $01
	sNote		nDs4, $03
	sNote		nRst, $01

	sFrac		$0016		; ssDetune $04
	sNote		nDs4
	sFrac		$003F		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00B0		; ssDetune $F0
	sNote		sHold, nE4
	sFrac		$003F		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$001C		; ssDetune $00

	sNote		nRst
	sNote		nE4, $0C
	sNote		nRst, $01
	sNote		nFs4, $11
	sNote		nRst, $01
	sNote		nGs4, $11
	sNote		nRst, $01
	sNote		nA4, $08
	sNote		nRst, $01
	sNote		nGs4, $23
	sNote		nRst, $01

	sFrac		$0006		; ssDetune $01
	sNote		nC4
	sFrac		$001B		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0022		; ssDetune $0A
	sNote		sHold, $01
	sFrac		$001B		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$001B		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$00DE		; ssDetune $F1
	sNote		sHold, nCs4
	sFrac		$001B		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$001B		; ssDetune $F9
	sNote		sHold, $01
	sFrac		$0022		; ssDetune $FE
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $00
	sNote		sHold, $23

	sNote		nRst, $01
	sNote		nCs4, $11
	sNote		nRst, $01

	sNote		nDs4, $09
	sFrac		-$0017		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$00B8		; ssDetune $11
	sNote		sHold, nD4
	sFrac		-$0036		; ssDetune $08
	sNote		sHold, $01
	sFrac		-$003B		; ssDetune $FE
	sNote		sHold, $01
	sFrac		-$0045		; ssDetune $F3
	sNote		sHold, $01
	sFrac		$00C7		; ssDetune $13
	sNote		sHold, nCs4
	sFrac		-$0038		; ssDetune $0A
	sNote		sHold, $01
	sFrac		-$003E		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nDs4, $11
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nCs4, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nFs4, $02
	sNote		sHold, nG4
	sNote		nRst, $01
	sNote		nGs4, $27
	sNote		nRst, $01

	sNote		nCs4, $09
	sFrac		-$003C		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$006B		; ssDetune $07
	sNote		sHold, nC4
	sFrac		-$0071		; ssDetune $ED
	sNote		sHold, $01
	sFrac		$0038		; ssDetune $FD
	sNote		sHold, nB3
	sFrac		$005C		; ssDetune $17
	sNote		sHold, nAs3
	sFrac		-$00AE		; ssDetune $E9
	sNote		sHold, $01
	sFrac		$006C		; ssDetune $04
	sNote		sHold, nA3
	sFrac		$0070		; ssDetune $1D
	sNote		sHold, nGs3
	sFrac		-$0080		; ssDetune $00

	sNote		nRst
	sNote		nGs3, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $11
	sNote		nRst, $01

	sNote		nGs4, $12
	sFrac		-$0050		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0030		; ssDetune $F9
	sNote		sHold, nG4
	sFrac		$0011		; ssDetune $FD
	sNote		sHold, nFs4
	sFrac		$0032		; ssDetune $07
	sNote		sHold, nF4
	sFrac		$0032		; ssDetune $10
	sNote		sHold, nE4
	sFrac		$000B		; ssDetune $11
	sNote		sHold, nDs4
	sFrac		-$00CB		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0033		; ssDetune $F7
	sNote		sHold, nD4
	sFrac		$0038		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01

	sNote		nCs5, $12
	sFrac		$0072		; ssDetune $11
	sNote		sHold, nC5, $01
	sFrac		-$0068		; ssDetune $03
	sNote		sHold, nB4
	sFrac		$006A		; ssDetune $1D
	sNote		sHold, nA4
	sFrac		-$005A		; ssDetune $06
	sNote		sHold, nGs4
	sFrac		-$005F		; ssDetune $F1
	sNote		sHold, nG4
	sFrac		$005E		; ssDetune $05
	sNote		sHold, nF4
	sFrac		-$005D		; ssDetune $F4
	sNote		sHold, nE4
	sFrac		$009D		; ssDetune $0F
	sNote		sHold, nD4
	sFrac		-$0059		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01
	sNote		nGs4, $23
	sNote		nRst, $01
	sNote		nFs4, $23
	sNote		nRst, $01
	sNote		nCs4, $04
	sNote		nRst, $01
	sNote		nDs4, $03
	sNote		nRst, $01
	sNote		nE4, $23
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nDs4, $23
	sNote		nRst, $01
	sNote		nB3, $2C
	sNote		nRst, $01
	sNote		nCs4, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nCs4, $08
	sNote		nRst, $01
	sNote		nB3, $11
	sNote		nRst, $01
	sNote		nGs3, $08
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01

	sFrac		$000A		; ssDetune $03
	sNote		nB3
	sFrac		$001C		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$005A		; ssDetune $F1
	sNote		sHold, nC4
	sFrac		$001C		; ssDetune $F9
	sNote		sHold, $01
	sFrac		$001E		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0044		; ssDetune $0B
	sNote		sHold, $01
	sFrac		-$00C3		; ssDetune $EE
	sNote		sHold, nCs4
	sFrac		$003D		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$002F		; ssDetune $FE
	sNote		sHold, $48
	sFrac		$000D		; ssDetune $00

	sVol		-$05
	sNote		nRst, $01
	sJump		BigBoss_Jump04

BigBoss_Loop26:
	sNote		nGs2, $05
	sNote		nRst, $04
	sNote		nE3, $08
	sNote		nRst, $01
	sNote		nGs2, $05
	sNote		nRst, $04
	sRet

BigBoss_Loop27:
	sNote		nCs2, $05
	sNote		nRst, $04
	sRet

BigBoss_Loop28:
	sNote		nRst, $04
	sNote		nDs2, $05
	sRet

BigBoss_Loop29:
	sNote		nGs2, $05
	sNote		nRst, $04
	sNote		nGs2, $05
	sNote		nRst, $04
	sNote		nE3, $08
	sNote		nRst, $01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

BigBoss_FM3:
	sVol		$03
	sVibratoSet	FM2

BigBoss_Jump03:
	sNote		nRst, $01
	sVoice		v05
	sPan		left
	sNote		nGs2, $04
	sNote		nRst
	sCall		$05, BigBoss_Loop26
	sVol		$02
	sCall		$07, BigBoss_Loop27
	sNote		nDs2, $0E
	sCall		$07, BigBoss_Loop28
	sNote		nRst, $04
	sVol		-$02
	sCall		$05, BigBoss_Loop29
	sNote		nGs2, $05
	sNote		nRst, $04
	sVol		$02
	sCall		$07, BigBoss_Loop27
	sNote		nDs2, $0E
	sCall		$07, BigBoss_Loop28

	sNote		nRst, $04
	sVol		$03
	sNote		nA2, $3F
	sNote		nGs2, $48
	sNote		nFs2
	sNote		nE2, $51
	sNote		nA2, $3F
	sNote		nGs2, $48
	sNote		nAs2
	sNote		nC3, $23
	sNote		nRst, $01
	sNote		nC3, $2C
	sNote		nRst, $07

	sPan		right
	sVoice		v03
	sVol		$04

	sNote		nCs4, $09
	sFrac		-$0079		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0072		; ssDetune $FE
	sNote		sHold, nC4
	sFrac		$0026		; ssDetune $09
	sNote		sHold, nB3
	sFrac		-$004A		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$0044		; ssDetune $07
	sNote		sHold, nAs3
	sFrac		$004F		; ssDetune $1A
	sNote		sHold, nA3
	sFrac		-$0098		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$0072		; ssDetune $0F
	sNote		sHold, nGs3
	sFrac		-$0042		; ssDetune $00

	sNote		nRst
	sNote		nGs3, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $11
	sNote		nRst, $01
	sNote		nGs4, $12

	sFrac		$0059		; ssDetune $14
	sNote		sHold, nG4, $01
	sFrac		-$00C8		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $ED
	sNote		sHold, nFs4
	sFrac		$002F		; ssDetune $F7
	sNote		sHold, nF4
	sFrac		$0035		; ssDetune $01
	sNote		sHold, nE4
	sFrac		$000C		; ssDetune $03
	sNote		sHold, nDs4
	sFrac		$0030		; ssDetune $0B
	sNote		sHold, nD4
	sFrac		$0035		; ssDetune $13
	sNote		sHold, nCs4
	sFrac		-$0076		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01
	sNote		nCs5, $12

	sFrac		-$000A		; ssDetune $FD
	sNote		sHold, nC5, $01
	sFrac		-$002F		; ssDetune $F0
	sNote		sHold, nB4
	sFrac		$001F		; ssDetune $FA
	sNote		sHold, nA4
	sFrac		-$005A		; ssDetune $E6
	sNote		sHold, nGs4
	sFrac		$00A7		; ssDetune $0B
	sNote		sHold, nFs4
	sFrac		-$00A3		; ssDetune $EB
	sNote		sHold, nF4
	sFrac		$009D		; ssDetune $08
	sNote		sHold, nDs4
	sFrac		-$005E		; ssDetune $F8
	sNote		sHold, nD4
	sFrac		$0031		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01
	sNote		nGs4, $23
	sNote		nRst, $01
	sNote		nFs4, $23
	sNote		nRst, $01
	sNote		nCs4, $03
	sNote		nRst, $01
	sNote		nDs4, $04
	sNote		nRst, $01

	sFrac		$0033		; ssDetune $09
	sNote		nDs4
	sFrac		$003E		; ssDetune $14
	sNote		sHold, $01
	sFrac		-$00B5		; ssDetune $F4
	sNote		sHold, nE4
	sFrac		$0044		; ssDetune $00

	sNote		nRst
	sNote		nE4, $0D
	sNote		nRst, $01
	sNote		nFs4, $11
	sNote		nRst, $01
	sNote		nGs4, $11
	sNote		nRst, $01
	sNote		nA4, $08
	sNote		nRst, $01
	sNote		nGs4, $23
	sNote		nRst, $01

	sFrac		$0014		; ssDetune $03
	sNote		nC4
	sFrac		$0014		; ssDetune $06
	sNote		sHold, $01
	sFrac		$0022		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$0021		; ssDetune $10
	sNote		sHold, $01
	sFrac		-$00EB		; ssDetune $ED
	sNote		sHold, nCs4
	sFrac		$0022		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$001B		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$0022		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$001B		; ssDetune $FF
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $00

	sNote		sHold, $23
	sNote		nRst, $01
	sNote		nCs4, $11
	sNote		nRst, $01

	sNote		nDs4, $09
	sFrac		-$002F		; ssDetune $F8
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$00B8		; ssDetune $0D
	sNote		sHold, nD4
	sFrac		-$0036		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $FA
	sNote		sHold, $01
	sFrac		-$0045		; ssDetune $EF
	sNote		sHold, $01
	sFrac		$00C7		; ssDetune $0F
	sNote		sHold, nCs4
	sFrac		-$0038		; ssDetune $06
	sNote		sHold, $01
	sFrac		-$0025		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nDs4, $11
	sNote		nRst, $01
	sNote		nC4, $08
	sNote		nRst, $01
	sNote		nCs4, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nFs4, $02
	sNote		sHold, nG4, $01
	sNote		nRst
	sNote		nGs4, $28
	sNote		nRst, $01

	sNote		nCs4, $09
	sFrac		-$0079		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0072		; ssDetune $FE
	sNote		sHold, nC4
	sFrac		$0026		; ssDetune $09
	sNote		sHold, nB3
	sFrac		-$004A		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$0044		; ssDetune $07
	sNote		sHold, nAs3
	sFrac		$004F		; ssDetune $1A
	sNote		sHold, nA3
	sFrac		-$0098		; ssDetune $F5
	sNote		sHold, $01
	sFrac		$0072		; ssDetune $0F
	sNote		sHold, nGs3
	sFrac		-$0042		; ssDetune $00

	sNote		nRst
	sNote		nGs3, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $11
	sNote		nRst, $01

	sNote		nGs4, $12
	sFrac		$0059		; ssDetune $14
	sNote		sHold, nG4, $01
	sFrac		-$00C8		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $ED
	sNote		sHold, nFs4
	sFrac		$002F		; ssDetune $F7
	sNote		sHold, nF4
	sFrac		$0035		; ssDetune $01
	sNote		sHold, nE4
	sFrac		$000C		; ssDetune $03
	sNote		sHold, nDs4
	sFrac		$0030		; ssDetune $0B
	sNote		sHold, nD4
	sFrac		$0035		; ssDetune $13
	sNote		sHold, nCs4
	sFrac		-$0076		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01

	sNote		nCs5, $12
	sFrac		-$000A		; ssDetune $FD
	sNote		sHold, nC5, $01
	sFrac		-$002F		; ssDetune $F0
	sNote		sHold, nB4
	sFrac		$001F		; ssDetune $FA
	sNote		sHold, nA4
	sFrac		-$005A		; ssDetune $E6
	sNote		sHold, nGs4
	sFrac		$00A7		; ssDetune $0B
	sNote		sHold, nFs4
	sFrac		-$00A3		; ssDetune $EB
	sNote		sHold, nF4
	sFrac		$009D		; ssDetune $08
	sNote		sHold, nDs4
	sFrac		-$005E		; ssDetune $F8
	sNote		sHold, nD4
	sFrac		$0031		; ssDetune $00

	sNote		nRst
	sNote		nCs4, $11
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nGs4, $08
	sNote		nRst, $01
	sNote		nGs4, $23
	sNote		nRst, $01
	sNote		nFs4, $23
	sNote		nRst, $01
	sNote		nCs4, $03
	sNote		nRst, $01
	sNote		nDs4, $04
	sNote		nRst, $01
	sNote		nE4, $23
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nFs4, $08
	sNote		nRst, $01
	sNote		nE4, $08
	sNote		nRst, $01
	sNote		nDs4, $23
	sNote		nRst, $01
	sNote		nB3, $2C
	sNote		nRst, $01
	sNote		nCs4, $08
	sNote		nRst, $01
	sNote		nDs4, $08
	sNote		nRst, $01
	sNote		nCs4, $08
	sNote		nRst, $01
	sNote		nB3, $11
	sNote		nRst, $01
	sNote		nGs3, $08
	sNote		nRst, $01
	sNote		nB3, $08
	sNote		nRst, $01

	sFrac		$0015		; ssDetune $06
	sNote		nB3
	sFrac		$001C		; ssDetune $0E
	sNote		sHold, $01
	sFrac		-$005B		; ssDetune $F4
	sNote		sHold, nC4
	sFrac		$001C		; ssDetune $FC
	sNote		sHold, $01
	sFrac		$002F		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0044		; ssDetune $0F
	sNote		sHold, $01
	sFrac		-$00C3		; ssDetune $F2
	sNote		sHold, nCs4
	sFrac		$003D		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$0014		; ssDetune $FE
	sNote		sHold, $43

	sVol		-$09
	sJump		BigBoss_Jump03

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

BigBoss_FM4:
	sVoice		v01
	sPan		center
	sVol		$03

BigBoss_Jump02:
	sNote		nRst, $09
	sCall		$02, BigBoss_Loop12

	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nGs2, $0E
	sNote		nRst, $04
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nB2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nA2
	sNote		nRst, $02
	sNote		nGs2, $12

	sFrac		-$0008		; ssDetune $FE
	sNote		sHold, nA2, $05
	sFrac		$0008		; ssDetune $00
	sNote		sHold, nGs2, $02

	sNote		nRst
	sNote		nFs2, $10
	sNote		nRst, $02
	sNote		nE2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nCs2, $0B

	sCall		$02, BigBoss_Loop13
	sNote		nRst, $07
	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nGs2, $0E
	sNote		nRst, $04
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nB2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nA2
	sNote		nRst, $02
	sNote		nGs2, $12

	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nA2, $05
	sFrac		$0004		; ssDetune $00
	sNote		sHold, nGs2, $02

	sNote		nRst
	sNote		nFs2, $10
	sNote		nRst, $02
	sNote		nE2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nA2, $11
	sNote		nRst, $01
	sNote		nB2, $11
	sNote		nRst, $01
	sNote		nA2, $04
	sNote		nRst, $01
	sNote		nB2, $03
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $11
	sNote		nRst, $01
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nB2, $11
	sNote		nRst, $01

	sNote		nCs3, $12
	sFrac		$0072		; ssDetune $11
	sNote		sHold, nC3, $01
	sFrac		-$006F		; ssDetune $01
	sNote		sHold, nB2
	sFrac		$005D		; ssDetune $18
	sNote		sHold, nA2
	sFrac		-$0064		; ssDetune $FF
	sNote		sHold, nGs2
	sFrac		-$0067		; ssDetune $E9
	sNote		sHold, nG2
	sFrac		$0056		; ssDetune $FC
	sNote		sHold, nF2
	sFrac		-$0068		; ssDetune $EA
	sNote		sHold, nE2
	sFrac		$009A		; ssDetune $05
	sNote		sHold, nD2
	sFrac		-$001D		; ssDetune $00

	sNote		nRst
	sNote		nCs2, $08
	sNote		nRst, $01
	sNote		nFs2, $11
	sNote		nRst, $01
	sNote		nGs2, $11
	sNote		nRst, $01
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nA2, $11
	sNote		nRst, $01
	sNote		nB2, $11
	sNote		nRst, $01
	sNote		nA2, $04
	sNote		nRst, $01
	sNote		nB2, $03
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $11
	sNote		nRst, $01
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nCs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nCs3, $11
	sNote		nRst, $01
	sNote		nCs3, $23
	sNote		nRst, $01
	sNote		nC3, $2C
	sNote		nRst, $01

	sVol		$01
	sCall		$05, BigBoss_Loop14
	sCall		$03, BigBoss_Loop15
	sCall		$02, BigBoss_Loop16
	sNote		nAs2, $07
	sNote		nRst, $02
	sNote		nAs2, $07

	sCall		$02, BigBoss_Loop17
	sNote		nRst, $02
	sNote		nA2, $03
	sNote		nRst, $06
	sNote		nA2, $03

	sCall		$02, BigBoss_Loop18
	sNote		nRst, $06
	sNote		nGs2, $07
	sNote		nRst, $02
	sNote		nGs2, $07

	sCall		$02, BigBoss_Loop19
	sNote		nRst, $02
	sNote		nG2, $03
	sNote		nRst, $06
	sNote		nG2, $03

	sCall		$01, BigBoss_Loop18
	sNote		nRst, $06
	sNote		nGs2, $0C
	sNote		nRst, $06
	sNote		nGs2, $03
	sNote		nRst, $06
	sNote		nGs2, $07
	sNote		nRst, $02

	sCall		$05, BigBoss_Loop15
	sNote		nGs2, $07
	sNote		nRst, $02
	sCall		$03, BigBoss_Loop15
	sCall		$02, BigBoss_Loop16
	sNote		nAs2, $07
	sNote		nRst, $02
	sNote		nAs2, $07

	sCall		$02, BigBoss_Loop17
	sNote		nRst, $02
	sNote		nA2, $03
	sNote		nRst, $06
	sNote		nA2, $03

	sCall		$04, BigBoss_Loop1E
	sCall		$04, BigBoss_Loop1F
	sNote		nRst, $06
	sNote		nE2, $03
	sNote		nRst, $06
	sNote		nE2, $03
	sNote		nRst, $06
	sNote		nA2, $07
	sNote		nRst, $02
	sNote		nB2, $0C
	sNote		nRst, $06
	sNote		nB2, $03
	sNote		nRst, $06
	sNote		nB2, $03
	sNote		nRst, $06
	sNote		nCs3, $10
	sNote		nRst, $02
	sNote		nCs4, $07
	sNote		nRst, $02
	sNote		nB3, $07
	sNote		nRst, $02
	sNote		nGs3, $07
	sNote		nRst, $02
	sNote		nFs3, $07
	sNote		nRst, $02
	sNote		nE3, $07
	sNote		nRst, $02
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $02

	sVol		-$01
	sJump		BigBoss_Jump02

BigBoss_Loop12:
	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nB2
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nAs2
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sRet

BigBoss_Loop13:
	sNote		nRst, $07
	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nB2
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nAs2
	sNote		nRst, $02
	sNote		nCs2
	sRet

BigBoss_Loop14:
	sNote		nGs2, $03
	sNote		nRst, $06
	sNote		nGs2, $03
	sNote		nRst, $06
	sNote		nGs2, $07
	sNote		nRst, $02
	sRet

BigBoss_Loop15:
	sNote		nGs2, $07
	sNote		nRst, $02
	sNote		nGs2, $03
	sNote		nRst, $06
	sNote		nGs2, $03
	sNote		nRst, $06
	sRet

BigBoss_Loop16:
	sNote		nAs2, $07
	sNote		nRst, $02
	sNote		nAs2, $03
	sNote		nRst, $06
	sNote		nAs2, $03
	sNote		nRst, $06
	sRet

BigBoss_Loop17:
	sNote		nRst, $02
	sNote		nA2, $03
	sNote		nRst, $06
	sNote		nA2, $03
	sNote		nRst, $06
	sNote		nA2, $07
	sRet

BigBoss_Loop18:
	sNote		nRst, $06
	sNote		nGs2, $07
	sNote		nRst, $02
	sNote		nGs2, $03
	sNote		nRst, $06
	sNote		nGs2, $03
	sRet

BigBoss_Loop19:
	sNote		nRst, $02
	sNote		nG2, $03
	sNote		nRst, $06
	sNote		nG2, $03
	sNote		nRst, $06
	sNote		nG2, $07
	sRet

BigBoss_Loop1E:
	sNote		nRst, $06
	sNote		nFs2, $03
	sRet

BigBoss_Loop1F:
	sNote		nRst, $06
	sNote		nF2, $03
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

BigBoss_FM5:
	sVol		$03
	sVoice		v02
	sPan		center

BigBoss_Jump01:
	sNote		nRst, $09
	sCall		$02, BigBoss_Loop12

	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nGs2, $0E
	sNote		nRst, $04
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nB2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nA2
	sNote		nRst, $02

	sNote		nGs2, $12
	sFrac		-$0008		; ssDetune $FE
	sNote		sHold, nA2, $05
	sFrac		$0008		; ssDetune $00

	sNote		sHold, nGs2, $02
	sNote		nRst
	sNote		nFs2, $10
	sNote		nRst, $02
	sNote		nE2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nCs2, $0B

	sCall		$02, BigBoss_Loop13
	sNote		nRst, $07
	sNote		nCs2, $02
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nGs2, $0E
	sNote		nRst, $04
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nCs2, $03
	sNote		nRst, $06
	sNote		nB2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nA2
	sNote		nRst, $02
	sNote		nGs2, $12

	sFrac		-$0004		; ssDetune $FF
	sNote		sHold, nA2, $05
	sFrac		$0004		; ssDetune $00

	sNote		sHold, nGs2, $02
	sNote		nRst
	sNote		nFs2, $10
	sNote		nRst, $02
	sNote		nE2, $07
	sNote		nRst, $02
	sNote		nCs2
	sNote		nRst, $07
	sNote		nFs2
	sNote		nRst, $02
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nA2, $11
	sNote		nRst, $01
	sNote		nB2, $11
	sNote		nRst, $01
	sNote		nA2, $04
	sNote		nRst, $01
	sNote		nB2, $03
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $11
	sNote		nRst, $01
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nB2, $11
	sNote		nRst, $01

	sNote		nCs3, $12
	sFrac		$0072		; ssDetune $11
	sNote		sHold, nC3, $01
	sFrac		-$006F		; ssDetune $01
	sNote		sHold, nB2
	sFrac		$005D		; ssDetune $18
	sNote		sHold, nA2
	sFrac		-$0064		; ssDetune $FF
	sNote		sHold, nGs2
	sFrac		-$0067		; ssDetune $E9
	sNote		sHold, nG2
	sFrac		$0056		; ssDetune $FC
	sNote		sHold, nF2
	sFrac		-$0068		; ssDetune $EA
	sNote		sHold, nE2
	sFrac		$009A		; ssDetune $05
	sNote		sHold, nD2
	sFrac		-$001D		; ssDetune $00

	sNote		nRst
	sNote		nCs2, $08
	sNote		nRst, $01
	sNote		nFs2, $11
	sNote		nRst, $01
	sNote		nGs2, $11
	sNote		nRst, $01
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nA2, $11
	sNote		nRst, $01
	sNote		nB2, $11
	sNote		nRst, $01
	sNote		nA2, $04
	sNote		nRst, $01
	sNote		nB2, $03
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $01
	sNote		nGs2, $11
	sNote		nRst, $01
	sNote		nCs2, $11
	sNote		nRst, $01
	sNote		nDs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nCs2, $08
	sNote		nRst, $01
	sNote		nE2, $08
	sNote		nRst, $01
	sNote		nCs3, $11
	sNote		nRst, $01
	sNote		nCs3, $23
	sNote		nRst, $01
	sNote		nC3, $2C
	sNote		nRst, $01

	sVol		$01
	sCall		$05, BigBoss_Loop14
	sCall		$03, BigBoss_Loop15
	sCall		$02, BigBoss_Loop16
	sNote		nAs2, $07
	sNote		nRst, $02
	sNote		nAs2, $07

	sCall		$02, BigBoss_Loop17
	sNote		nRst, $02
	sNote		nA2, $03
	sNote		nRst, $06
	sNote		nA2, $03

	sCall		$02, BigBoss_Loop18
	sNote		nRst, $06
	sNote		nGs2, $07
	sNote		nRst, $02
	sNote		nGs2, $07

	sCall		$02, BigBoss_Loop19
	sNote		nRst, $02
	sNote		nG2, $03
	sNote		nRst, $06
	sNote		nG2, $03
	sCall		$01, BigBoss_Loop18
	sNote		nRst, $06
	sNote		nGs2, $0C
	sNote		nRst, $06
	sNote		nGs2, $03
	sNote		nRst, $06
	sNote		nGs2, $07
	sNote		nRst, $02

	sCall		$05, BigBoss_Loop15
	sNote		nGs2, $07
	sNote		nRst, $02
	sCall		$03, BigBoss_Loop15
	sCall		$02, BigBoss_Loop16
	sNote		nAs2, $07
	sNote		nRst, $02
	sNote		nAs2, $07

	sCall		$02, BigBoss_Loop17
	sNote		nRst, $02
	sNote		nA2, $03
	sNote		nRst, $06
	sNote		nA2, $03

	sCall		$04, BigBoss_Loop1E
	sCall		$04, BigBoss_Loop1F
	sNote		nRst, $06
	sNote		nE2, $03
	sNote		nRst, $06
	sNote		nE2, $03
	sNote		nRst, $06
	sNote		nA2, $07
	sNote		nRst, $02
	sNote		nB2, $0C
	sNote		nRst, $06
	sNote		nB2, $03
	sNote		nRst, $06
	sNote		nB2, $03
	sNote		nRst, $06
	sNote		nCs3, $10
	sNote		nRst, $02
	sNote		nCs4, $07
	sNote		nRst, $02
	sNote		nB3, $07
	sNote		nRst, $02
	sNote		nGs3, $07
	sNote		nRst, $02
	sNote		nFs3, $07
	sNote		nRst, $02
	sNote		nE3, $07
	sNote		nRst, $02
	sNote		nCs3, $07
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $02

	sVol		-$01
	sJump		BigBoss_Jump01

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

BigBoss_PSG1:
	sVibratoSet	PSG1
	sFrac		$0C00
	sVol		$20
	sVolEnv		v05

BigBoss_Jump07:
	sNote		nCs1, $59
	sNote		nCut, $01
	sNote		nGs0, $11
	sNote		nCut, $01
	sNote		nCs1, $11
	sNote		nCut, $01
	sNote		nDs1, $08
	sNote		nCut, $01
	sNote		nE1, $47
	sNote		nCut, $01
	sNote		nFs1, $47
	sNote		nCut, $01
	sNote		nCs1, $62
	sNote		nCut, $01
	sNote		nGs0, $11
	sNote		nCut, $01
	sNote		nCs1, $11
	sNote		nCut, $01
	sNote		nDs1, $08
	sNote		nCut, $01
	sNote		nE1, $47
	sNote		nCut, $01
	sNote		nFs1, $50
	sNote		nCut, $01
	sVol		-$10
	sNote		nE0, $1A
	sNote		nCut, $01
	sNote		nE1, $23
	sNote		nCut, $01
	sNote		nDs0, $23
	sNote		nCut, $01
	sNote		nDs1, $23
	sNote		nCut, $01
	sNote		nCs0, $23
	sNote		nCut, $01
	sNote		nCs1, $23
	sNote		nCut, $01
	sNote		nC0, $23
	sNote		nCut, $01
	sNote		nB0, $2C
	sNote		nCut, $01
	sNote		nE0, $1A
	sNote		nCut, $01
	sNote		nE1, $23
	sNote		nCut, $01
	sNote		nDs0, $23
	sNote		nCut, $01
	sNote		nDs1, $23
	sNote		nCut, $01
	sNote		nCs1, $23
	sNote		nCut, $01
	sNote		nCs2, $23
	sNote		nCut, $01
	sNote		nGs1, $23
	sNote		nCut, $01
	sNote		nGs1, $2C
	sNote		nCut, $01
	sVol		-$08
	sNote		nCs1, $47
	sNote		nCut, $01
	sNote		nC1, $47
	sNote		nCut, $01
	sNote		nB0, $47

	sCall		$03, BigBoss_Loop4F
	sNote		nCut, $01
	sNote		nAs0, $47
	sNote		nCut, $01
	sNote		nC1, $47
	sNote		nCut, $01
	sNote		nCs1, $47
	sNote		nCut, $01
	sNote		nC1, $47
	sNote		nCut, $01
	sNote		nB0, $47
	sCall		$02, BigBoss_Loop4F
	sNote		nCut, $01
	sNote		nB0, $47
	sNote		nCut, $01
	sNote		nA0, $1A
	sNote		nCut, $01
	sNote		nB0, $2C
	sNote		nCut, $01
	sNote		nCs1, $47
	sNote		nCut, $01

	sVol		$18
	sJump		BigBoss_Jump07

BigBoss_Loop4F:
	sNote		nCut, $01
	sNote		nCs1, $47
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

BigBoss_PSG2:
	sVibratoSet	PSG1
	sFrac		$0C00
	sVol		$30
	sVolEnv		v05

BigBoss_PSG2_00:
	sNote		nCut, $0E
	sNote		nCs1, $59
	sNote		nCut, $01
	sNote		nGs0, $11
	sNote		nCut, $01
	sNote		nCs1, $11
	sNote		nCut, $01
	sNote		nDs1, $08
	sNote		nCut, $01
	sNote		nE1, $47
	sNote		nCut, $01
	sNote		nFs1, $47
	sNote		nCut, $01
	sNote		nCs1, $62
	sNote		nCut, $01
	sNote		nGs0, $11
	sNote		nCut, $01
	sNote		nCs1, $11
	sNote		nCut, $01
	sNote		nDs1, $08
	sNote		nCut, $01
	sNote		nE1, $47
	sNote		nCut, $01
	sNote		nFs1, $42
	sNote		nCut, $01
	sVol		-$18
	sNote		nA0, $1A
	sNote		nCut, $01
	sNote		nA1, $23
	sNote		nCut, $01
	sNote		nGs0, $23
	sNote		nCut, $01
	sNote		nGs1, $23
	sNote		nCut, $01
	sNote		nFs0, $23
	sNote		nCut, $01
	sNote		nFs1, $23
	sNote		nCut, $01
	sNote		nE0, $23
	sNote		nCut, $01
	sNote		nE1, $2C
	sNote		nCut, $01
	sNote		nA0, $1A
	sNote		nCut, $01
	sNote		nA1, $23
	sNote		nCut, $01
	sNote		nGs0, $23
	sNote		nCut, $01
	sNote		nGs1, $23
	sNote		nCut, $01
	sNote		nAs0, $23
	sNote		nCut, $01
	sNote		nAs1, $23
	sNote		nCut, $01
	sNote		nC1, $23
	sNote		nCut, $01
	sNote		nC1, $2C
	sNote		nCut, $01
	sVol		-$08

	sCall		$03, BigBoss_Loop4D
	sNote		nAs0, $47
	sNote		nCut, $01
	sNote		nA0, $47
	sNote		nCut, $01
	sNote		nGs0, $47
	sNote		nCut, $01
	sNote		nG0, $47

	sCall		$04, BigBoss_Loop4E
	sNote		nCut, $01
	sNote		nAs0, $47
	sNote		nCut, $01
	sNote		nA0, $47
	sNote		nCut, $01
	sNote		nFs0, $47
	sNote		nCut, $01
	sNote		nE0, $1A
	sNote		nCut, $01
	sNote		nFs0, $2C
	sNote		nCut, $01
	sNote		nGs0, $47
	sNote		nCut, $01

	sVol		$20
	sJump		BigBoss_PSG2_00

BigBoss_Loop4D:
	sNote		nGs0, $47
	sNote		nCut, $01
	sRet

BigBoss_Loop4E:
	sNote		nCut, $01
	sNote		nGs0, $47
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Noise data
; ---------------------------------------------------------------------------

BigBoss_PSG3:
	sVol		$7F

BigBoss_PSG3_00:
	sNote		nHiHat, $100
	sJump		BigBoss_PSG3_00

BigBoss_PSG4:
	sVol		$10

BigBoss_Jump06:
	sNote		nRst, $01
	sVolEnv		v02
	sNote		nWhitePSG3, $08
	sCall		$FF, BigBoss_Loop4C
	sJump		BigBoss_Jump06

BigBoss_Loop4C:
	sNote		$09
	sRet


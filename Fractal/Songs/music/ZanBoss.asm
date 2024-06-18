; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	ZanBoss_Voice
	sHeaderSamples	ZanBoss_Samples
	sHeaderVibrato	ZanBoss_Vib
	sHeaderEnvelope	ZanBoss_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$66
	sChannel	DAC1, ZanBoss_DAC1
	sChannel	FM1, ZanBoss_FM1
	sChannel	FM2, ZanBoss_FM3
	sChannel	FM3, ZanBoss_FM2
	sChannel	FM4, ZanBoss_FM4
	sChannel	FM5, ZanBoss_FM5
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

ZanBoss_Voice:
	sNewVoice	v00
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$07, $06, $03, $00
	sMultiple	$01, $01, $02, $02
	sRateScale	$00, $03, $01, $00
	sAttackRate	$15, $1F, $1F, $10
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $05, $0C, $05
	sDecay2Rate	$04, $04, $04, $04
	sDecay1Level	$03, $03, $0F, $0F
	sReleaseRate	$08, $08, $08, $0A
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1B, $19, $19, $0E
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$03
	sFeedback	$00
	sDetune		$06, $00, $00, $00
	sMultiple	$0A, $01, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0C, $00, $00, $00
	sDecay2Rate	$00, $04, $00, $06
	sDecay1Level	$0F, $00, $00, $00
	sReleaseRate	$0A, $06, $0A, $08
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2F, $21, $17, $09
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$00
	sDetune		$03, $00, $00, $07
	sMultiple	$03, $03, $01, $01
	sRateScale	$03, $03, $02, $02
	sAttackRate	$16, $16, $19, $19
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $07, $08
	sDecay2Rate	$0C, $12, $08, $06
	sDecay1Level	$04, $04, $03, $03
	sReleaseRate	$00, $04, $07, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1E, $20, $1A, $10
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

ZanBoss_Samples:
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

	sNewSample	Timpani
	sSampFreq	$0100
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Timpani2
	sSampFreq	$00E0
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Timpani3
	sSampFreq	$00C0
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

ZanBoss_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

ZanBoss_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

ZanBoss_DAC1:
	sPan		center
	sVol		$04

ZanBoss_Jump00:
	sSample		Kick
	sCall		$06, ZanBoss_Loop00
	sSample		Timpani
	sNote		$01
	sNote		$02
	sNote		$03
	sNote		$03
	sSample		Timpani2
	sNote		$01
	sNote		$02
	sNote		$03
	sNote		$03
	sSample		Timpani3
	sNote		$01
	sNote		$02
	sNote		$03
	sNote		$03

	sCall		$02, ZanBoss_Loop01
	sSample		Snare
	sNote		$01
	sNote		$02
	sNote		$03
	sNote		$03

	sCall		$03, ZanBoss_Loop02
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$01
	sNote		$02
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$03
	sJump		ZanBoss_Jump00

ZanBoss_Loop00:
	sNote		nSample, $06
	sNote		$03
	sSample		Snare
	sNote		$03
	sSample		Kick
	sNote		$06
	sRet

ZanBoss_Loop01:
	sSample		Snare
	sNote		$01
	sNote		$02
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sSample		Timpani
	sNote		$01
	sNote		$02
	sNote		$03
	sSample		Kick
	sNote		$03
	sSample		Timpani2
	sNote		$01
	sNote		$02
	sNote		$03
	sSample		Kick
	sNote		$03
	sSample		Timpani3
	sNote		$01
	sNote		$02
	sNote		$03
	sSample		Kick
	sNote		$03
	sRet

ZanBoss_Loop02:
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$03
	sNote		$03
	sSample		Snare
	sNote		$06
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

ZanBoss_FM1:
	sVoice		v00
	sVol		$08
	sPan		center

ZanBoss_Jump05:
	sNote		nB4, $01
	sFrac		-$003D		; ssDetune $EF
	sNote		sHold, $01
	sFrac		$0021		; ssDetune $F8
	sNote		sHold, $01
	sFrac		$001C		; ssDetune $00
	sNote		sHold, $0F
	sNote		nF5, $09
	sNote		nB5
	sFrac		$004C		; ssDetune $13
	sNote		nA5, $01
	sFrac		-$00C8		; ssDetune $E1
	sNote		sHold, nAs5
	sFrac		$0044		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$0038		; ssDetune $00
	sNote		sHold, $0F
	sNote		nE5, $09
	sNote		nAs4
	sFrac		$004B		; ssDetune $15
	sNote		$01
	sFrac		-$0088		; ssDetune $EF
	sNote		sHold, nB4
	sFrac		$0021		; ssDetune $F8
	sNote		sHold, $01
	sFrac		$001C		; ssDetune $00
	sNote		sHold, $0F
	sNote		nF5, $09
	sNote		nB5
	sFrac		$004C		; ssDetune $13
	sNote		nA5, $01
	sFrac		-$00C8		; ssDetune $E1
	sNote		sHold, nAs5
	sFrac		$0044		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$0038		; ssDetune $00
	sNote		sHold, $0F
	sNote		nE5, $09
	sNote		nAs4

	sCall		$02, ZanBoss_Loop0E
	sJump		ZanBoss_Jump05

ZanBoss_Loop0E:
	sNote		nE4, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sFrac		$0050		; ssDetune $0F
	sNote		$03
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF4
	sFrac		$0045		; ssDetune $F6
	sNote		sHold, $03
	sFrac		$0035		; ssDetune $00
	sNote		sHold, $1B
	sNote		nFs4, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sFrac		$004F		; ssDetune $11
	sNote		$03
	sFrac		-$00C8		; ssDetune $E6
	sNote		sHold, nG4
	sFrac		$003D		; ssDetune $F3
	sNote		sHold, $03
	sFrac		$003C		; ssDetune $00
	sNote		sHold, $1B
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

ZanBoss_FM2:
	sVoice		v00
	sVol		$08
	sPan		center

ZanBoss_Jump04:
	sNote		nF4, $01
	sFrac		-$007A		; ssDetune $E9
	sNote		sHold, $01
	sFrac		$0045		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $00
	sNote		sHold, $0F
	sNote		nB4, $09
	sNote		nF5
	sFrac		$0050		; ssDetune $0F
	sNote		nE5, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF5
	sFrac		$0045		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $00
	sNote		sHold, $0F
	sNote		nAs4, $09
	sNote		nF4
	sFrac		$0050		; ssDetune $0F
	sNote		nE4, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF4
	sFrac		$0045		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $00
	sNote		sHold, $0F
	sNote		nB4, $09
	sNote		nF5
	sFrac		$0050		; ssDetune $0F
	sNote		nE5, $01
	sFrac		-$00CA		; ssDetune $E9
	sNote		sHold, nF5
	sFrac		$0045		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$0035		; ssDetune $00
	sNote		sHold, $0F
	sNote		nAs4, $09
	sNote		nF4

	sCall		$02, ZanBoss_Loop0D
	sJump		ZanBoss_Jump04

ZanBoss_Loop0D:
	sNote		nA4, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sFrac		$004C		; ssDetune $13
	sNote		$03
	sFrac		-$00C8		; ssDetune $E1
	sNote		sHold, nAs4
	sFrac		$0044		; ssDetune $F2
	sNote		sHold, $03
	sFrac		$0038		; ssDetune $00
	sNote		sHold, $1B
	sNote		nB4, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sFrac		$0026		; ssDetune $0B
	sNote		$03
	sFrac		-$0061		; ssDetune $EF
	sNote		sHold, nC5
	sFrac		$001F		; ssDetune $F8
	sNote		sHold, $03
	sFrac		$001C		; ssDetune $00
	sNote		sHold, $1B
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

ZanBoss_FM3:
	sVoice		v01
	sVol		$06
	sPan		center

ZanBoss_Jump03:
	sCall		$02, ZanBoss_Loop0B
	sCall		$02, ZanBoss_Loop0C
	sNote		nAs1, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nB1, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nC2, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nCs2, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nAs1, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nB1, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nC2, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		nCs2, $06
	sNote		$06
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		nCs3
	sNote		nCs2
	sNote		nCs3
	sNote		nCs2
	sNote		nCs3
	sJump		ZanBoss_Jump03

ZanBoss_Loop0B:
	sNote		nC2, $03
	sNote		nB1
	sNote		nC2
	sNote		nC2
	sNote		nB1
	sNote		nC2
	sNote		nD2
	sNote		nCs2
	sNote		nC2
	sNote		nDs2
	sNote		nD2
	sNote		nCs2
	sRet

ZanBoss_Loop0C:
	sNote		nE2
	sNote		nDs2
	sNote		nE2
	sNote		nE2
	sNote		nDs2
	sNote		nE2
	sNote		nE2
	sNote		nF2
	sNote		nFs2
	sNote		nG2
	sNote		nGs2
	sNote		nA2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

ZanBoss_FM4:
	sVoice		v02
	sVol		$06
	sPan		right

ZanBoss_Jump02:
	sCall		$08, ZanBoss_Loop07
	sCall		$02, ZanBoss_Loop0A
	sJump		ZanBoss_Jump02

ZanBoss_Loop07:
	sNote		nB3, $03
	sNote		nE4
	sNote		nF4
	sNote		nB4
	sNote		nF4
	sNote		nE4
	sRet

ZanBoss_Loop0A:
	sNote		nB3
	sNote		nC4
	sNote		nCs4
	sNote		nD4
	sNote		nDs4
	sNote		nE4
	sNote		nF4
	sNote		nFs4
	sNote		nG4
	sNote		nGs4
	sNote		nA4

	sCall		$06, ZanBoss_Loop08
	sNote		nAs4
	sNote		nCs4
	sNote		nD4
	sNote		nDs4
	sNote		nE4
	sNote		nF4
	sNote		nFs4
	sNote		nG4
	sNote		nGs4
	sNote		nA4
	sNote		nAs4
	sNote		nB4

	sCall		$06, ZanBoss_Loop09
	sNote		nC5
	sRet

ZanBoss_Loop08:
	sNote		nAs4
	sNote		nB4
	sRet

ZanBoss_Loop09:
	sNote		nC5
	sNote		nCs5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

ZanBoss_FM5:
	sVoice		v02
	sVol		$06
	sPan		right

ZanBoss_Jump01:
	sCall		$08, ZanBoss_Loop03
	sCall		$02, ZanBoss_Loop06
	sJump		ZanBoss_Jump01

ZanBoss_Loop03:
	sNote		nF3, $03
	sNote		nB3
	sNote		nE4
	sNote		nF4
	sNote		nE4
	sNote		nB3
	sRet

ZanBoss_Loop06:
	sNote		nD4
	sNote		nDs4
	sNote		nE4
	sNote		nF4
	sNote		nFs4
	sNote		nG4
	sNote		nGs4
	sNote		nA4
	sNote		nAs4
	sNote		nB4
	sNote		nC5

	sCall		$06, ZanBoss_Loop04
	sNote		nCs5
	sNote		nE4
	sNote		nF4
	sNote		nFs4
	sNote		nG4
	sNote		nGs4
	sNote		nA4
	sNote		nAs4
	sNote		nB4
	sNote		nC5
	sNote		nCs5
	sNote		nD5

	sCall		$06, ZanBoss_Loop05
	sNote		nDs5
	sRet

ZanBoss_Loop04:
	sNote		nCs5
	sNote		nD5
	sRet

ZanBoss_Loop05:
	sNote		nDs5
	sNote		nE5
	sRet

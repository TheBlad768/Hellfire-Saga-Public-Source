; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Filmore_Voice
	sHeaderSamples	Filmore_Samples
	sHeaderVibrato	Filmore_Vib
	sHeaderEnvelope	Filmore_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$F5
	sChannel	DAC1, Filmore_DAC1
	sChannel	FM1, Filmore_FM1
	sChannel	FM2, Filmore_FM2
	sChannel	FM3, Filmore_FM4
	sChannel	FM4, Filmore_FM5
	sChannel	FM5, Filmore_FM3
	sChannel	PSG1, Filmore_PSG2
	sChannel	PSG2, Filmore_PSG1
	sChannel	PSG3, Filmore_PSG3
	sChannel	PSG4, Filmore_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Filmore_Voice:
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
	sReleaseRate	$04, $06, $05, $07
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
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$02, $01, $01, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0E, $0E, $0E, $13
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0E, $0E, $0E, $04
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $00
	sReleaseRate	$06, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$18, $1D, $17, $0C
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Filmore_Samples:
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

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Filmore_Vib:
	sVibrato FM5_Main,	$00, $00, $4000, $0008, Sine		; sModAMPS $00, $01, $01, $03
	sVibrato FM5_X_2,	$00, $00, $4000, $0011, Sine		; sModAMPS $00, $01, $02, $03
	sVibrato FM5_X_3,	$00, $00, $4000, $0019, Sine		; sModAMPS $00, $01, $03, $03
	sVibrato FM5_X_4,	$00, $00, $4000, $0022, Sine		; sModAMPS $00, $01, $04, $03
	sVibrato FM5_X_5,	$00, $00, $4000, $002A, Sine		; sModAMPS $00, $01, $05, $03
	sVibrato FM5_X_6,	$00, $00, $4000, $0032, Sine		; sModAMPS $00, $01, $03, $03

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Filmore_Env:
	sEnvelope v01,		Filmore_Env_v01
	sEnvelope v02,		Filmore_Env_v02
	sEnvelope v08,		Filmore_Env_v08
; ---------------------------------------------------------------------------

Filmore_Env_v01:
	sEnv		delay=$03,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Filmore_Env_v02:
	sEnv		delay=$01,	$00, $10, $20, $30, $40, $7F
	seMute
; ---------------------------------------------------------------------------

Filmore_Env_v08:
	sEnv		delay=$05,	$00, $08
	sEnv		delay=$06,	$10
	sEnv		delay=$05,	$18, $20, $28, $30
	seHold		$38

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Filmore_DAC1:
	sPan		center
	sVol		$04

Filmore_Jump00:
	sSample		Kick
	sCall		$07, Filmore_Loop00

	sNote		$0F
	sNote		$04
	sNote		$04
	sNote		$03
	sNote		$04

	sCall		$02, Filmore_Loop01
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sSample		Snare
	sNote		$08
	sNote		$07
	sSample		Crash3
	sNote		$44
	sSample		Kick
	sNote		$07
	sSample		Snare
	sNote		$08
	sNote		$0F
	sSample		Kick
	sNote		$07
	sSample		Snare
	sNote		$08
	sNote		$07

	sSample		Crash3
	sCall		$02, Filmore_Loop02
	sSample		Crash3
	sCall		$02, Filmore_Loop02

	sSample		Crash3
	sNote		$1E
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$16
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$08
	sNote		$07
	sNote		$1E
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$16
	sNote		$0F
	sNote		$0F
	sSample		Snare
	sNote		$1E
	sSample		Crash3
	sNote		$1E

	sSample		Kick
	sCall		$03, Filmore_Loop04
	sNote		$1E
	sNote		$08
	sSample		Snare
	sNote		$07
	sNote		$0F
	sNote		$0F
	sNote		$08
	sNote		$07
	sSample		Crash3
	sNote		$1E

	sCall		$03, Filmore_Loop05
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sNote		$07
	sNote		$08
	sNote		$07
	sJump		Filmore_Jump00

Filmore_Loop00:
	sNote		nSample, $1E
	sRet

Filmore_Loop01:
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$08
	sSample		Crash3
	sNote		$07
	sSample		Kick
	sNote		$08
	sNote		$07
	sRet

Filmore_Loop02:
	sNote		$1E
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$0F
	sNote		$07
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$16
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$08
	sNote		$07
	sRet

Filmore_Loop04:
	sNote		$1E
	sNote		$1E
	sSample		Snare
	sNote		$1E
	sSample		Kick
	sNote		$1E
	sRet

Filmore_Loop05:
	sSample		Snare
	sNote		$0F
	sSample		Kick
	sNote		$0F
	sNote		$17
	sNote		$07
	sSample		Snare
	sNote		$08
	sSample		Kick
	sNote		$07
	sSample		Crash3
	sNote		$08
	sSample		Kick
	sNote		$07
	sNote		$1E
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Filmore_FM1_00:
	sNote		nFs2, $0E
	sNote		nRst, $01
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sVol		$03
	sNote		nFs3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $16
	sNote		nAs2, $08
	sNote		nRst, $07
	sVol		$03
	sNote		nAs3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $07
	sNote		nB2, $0E
	sNote		nRst, $01
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $06
	sNote		nRst, $01
	sVol		$03
	sNote		nB3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $06
	sNote		nRst, $01
	sNote		nB2, $08
	sNote		nRst, $16
	sNote		nGs2, $08
	sNote		nRst, $07
	sVol		$03
	sNote		nGs3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nGs2, $06
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $07
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $06
	sNote		nRst, $01
	sVol		$03
	sNote		nCs4, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $16
	sNote		nA2, $08
	sNote		nRst, $07
	sVol		$03
	sNote		nA3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $07
	sNote		nD3, $0E
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nD3, $07
	sVol		$03
	sNote		nD4, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $07
	sRet

Filmore_FM1:
	sVoice		v00
	sPan		center
	sVol		$02

Filmore_Jump05:
	sNote		nRst, $01
	sNote		nB2, $1D
	sNote		nA2, $1E
	sNote		nG2
	sNote		nFs2
	sNote		nF2, $78

	sCall		$04, Filmore_LoopDD
	sNote		nFs2, $2D
	sNote		nRst, $17
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01

	sCall		$02, Filmore_LoopDE
	sCall		$01, Filmore_FM1_00
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $07
	sVol		$03
	sNote		nCs4, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $07
	sCall		$01, Filmore_FM1_00
	sNote		nFs3, $0E
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $02
	sNote		nFs3, $07
	sVol		$03
	sNote		nFs4, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $07

	sCall		$04, Filmore_LoopDF
	sCall		$04, Filmore_LoopE0
	sCall		$06, Filmore_LoopE1
	sNote		nFs3, $06
	sNote		nRst, $02
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nFs4, $06
	sNote		nRst, $02
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nFs3, $0F
	sNote		nFs4, $06
	sNote		nRst, $02

;	ssDetune	$0F		; ???
;	dc.b $01
;	ssDetune	$E3
;	dc.b $01
;	ssDetune	$F2
;	dc.b $01
;	ssDetune	$00
;	dc.b $01
;	ssDetune	$0D
;	dc.b $01
;	ssDetune	$0C
;	dc.b $01
;	ssDetune	$E9
;	dc.b $01
	sNote		nRst, $07

	sCall		$02, Filmore_FM1_01
	sJump		Filmore_Jump05

Filmore_LoopDD:
	sNote		nFs2, $0E
	sNote		nRst, $01
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sRet

Filmore_LoopDF:
	sNote		nG3, $1D
	sNote		nRst, $01
	sRet

Filmore_LoopE0:
	sNote		nF3, $1D
	sNote		nRst, $01
	sRet

Filmore_LoopE1:
	sNote		nFs3, $1D
	sNote		nRst, $01
	sRet

Filmore_FM1_01:
	sFrac		$0044		; ssDetune $11
	sNote		nA2, $01
	sFrac		-$0041		; ssDetune $01
	sNote		sHold, nAs2
	sFrac		-$0023		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$001D		; ssDetune $FF
	sNote		sHold, $0C
	sFrac		$0003		; ssDetune $00

	sVol		$03
	sNote		nB3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $07
	sNote		nRst, $08
	sVol		$03
	sNote		nB3, $0D
	sNote		nRst, $02
	sNote		nB3, $05
	sNote		nRst, $02
	sVol		-$03

	sFrac		$003C		; ssDetune $0F
	sNote		nA2, $01
	sFrac		-$003C		; ssDetune $00
	sNote		sHold, nAs2
	sFrac		-$0020		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$001D		; ssDetune $FF
	sNote		sHold, $0C
	sFrac		$0003		; ssDetune $00

	sVol		$03
	sNote		nB3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB2, $07
	sVol		$03

	sNote		nB3, $08
	sFrac		-$0040		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0040		; ssDetune $00
	sNote		sHold, nAs3
	sFrac		-$0084		; ssDetune $DF
	sNote		sHold, $01
	sFrac		$0084		; ssDetune $00
	sNote		sHold, nA3
	sFrac		-$0088		; ssDetune $E1
	sNote		sHold, $01
	sFrac		$005C		; ssDetune $F6
	sNote		sHold, nGs3
	sFrac		$007C		; ssDetune $12
	sNote		sHold, nG3
	sFrac		-$0050		; ssDetune $00

	sVol		-$03
	sNote		nG2, $08
	sNote		nRst, $07
;	ssDetune	$1A			; ???
;	sNote		$01

	sVol		$03
	sFrac		$0041		; ssDetune $0E
	sNote		nFs3, $01
	sFrac		-$0041		; ssDetune $00
	sNote		sHold, nG3, $0E

	sNote		nRst, $08
	sVol		-$03

	sNote		nG2, $0F
	sFrac		-$0041		; ssDetune $F2
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $E5
	sNote		sHold, $01
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		-$003D		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$0040		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$00AA		; ssDetune $16
	sNote		sHold, nF2
	sFrac		-$0041		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$002D		; ssDetune $00

	sNote		$0F
	sVol		$03
	sNote		nF3, $05
	sNote		nRst, $0A
	sVol		-$03
	sNote		nFs2, $0F
	sVol		$03

	sNote		nFs3, $05
	sFrac		-$002D		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$006E		; ssDetune $0D
	sNote		sHold, nF3
	sFrac		-$0091		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FD
	sNote		sHold, nE3
	sFrac		$0071		; ssDetune $11
	sNote		sHold, nDs3
	sFrac		-$0095		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$0070		; ssDetune $0A
	sNote		sHold, nD3
	sFrac		-$008C		; ssDetune $F3
	sNote		sHold, $01
	sFrac		$003D		; ssDetune $FD
	sNote		sHold, nCs3
	sFrac		$0072		; ssDetune $0E
	sNote		sHold, nC3
	sFrac		-$005E		; ssDetune $00
	sVol		-$03
	sRet

Filmore_LoopDE:
	sNote		nB2, $0E
	sNote		nRst, $01
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $07
	sVol		$03
	sNote		nB3, $05
	sNote		nRst, $0A
	sVol		-$03
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB2, $0D
	sNote		nRst, $02
	sNote		nB2, $07
	sVol		$03
	sNote		nB3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $02
	sNote		nRst, $05
	sNote		nB2, $0F
	sNote		nG2, $0E
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nG2, $07
	sVol		$03
	sNote		nG3, $05
	sNote		nRst, $0A
	sVol		-$03
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nG2, $07
	sNote		nRst, $08
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nA2, $07
	sVol		$03
	sNote		nA3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nA2, $02
	sNote		nRst, $05
	sNote		nA2, $0F
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Filmore_FM2_00:
	sNote		nFs2, $0E
	sNote		nRst, $01
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sVol		$03
	sNote		nFs2, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $16
	sNote		nAs2, $08
	sNote		nRst, $07
	sVol		$03
	sNote		nAs2, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $07
	sNote		nB2, $0E
	sNote		nRst, $01
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $06
	sNote		nRst, $01
	sVol		$03
	sNote		nB2, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $06
	sNote		nRst, $01
	sNote		nB2, $08
	sNote		nRst, $16
	sNote		nGs2, $08
	sNote		nRst, $07
	sVol		$03
	sNote		nGs2, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nGs2, $06
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $07
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $06
	sNote		nRst, $01
	sVol		$03
	sNote		nCs3, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $16
	sNote		nA2, $08
	sNote		nRst, $07
	sVol		$03
	sNote		nA2, $05
	sNote		nRst, $03
	sVol		-$03
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $07
	sNote		nD3, $0E
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nD3, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $07
	sRet

Filmore_FM2:
	sVoice		v01
	sPan		center
	sVol		$06

Filmore_Jump04:
	sNote		nRst, $01
	sNote		nB2, $1D
	sNote		nA2, $1E
	sNote		nG2
	sNote		nFs2
	sNote		nF2, $78

	sCall		$04, Filmore_LoopDA
	sNote		nFs2, $78
	sCall		$02, Filmore_LoopDB
	sCall		$01, Filmore_FM2_00
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $07
	sCall		$01, Filmore_FM2_00
	sNote		nFs3, $0E
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $02
	sNote		nFs3, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst, $07
	sNote		nG2, $77
	sNote		nRst, $01
	sNote		nF2, $77
	sNote		nRst, $01
	sNote		nFs2, $77
	sNote		nRst, $01
	sNote		nFs2, $1D
	sNote		nRst, $01
	sNote		nFs2, $1D

	sNote		nRst, $01
	sCall		$02, Filmore_LoopDC

	sNote		nFs2, $17
	sFrac		$0041		; ssDetune $0D
	sNote		sHold, nF2, $01
	sFrac		-$00C1		; ssDetune $E8
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $F4
	sNote		sHold, nE2
	sFrac		$0044		; ssDetune $00
	sNote		sHold, nDs2
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD2
	sNote		sHold, nCs2
	sFrac		-$00BB		; ssDetune $ED
	sNote		sHold, $01
	sFrac		$0080		; ssDetune $00

	sCall		$02, Filmore_FM2_01
	sJump		Filmore_Jump04

Filmore_LoopDA:
	sNote		nFs2, $0E
	sNote		nRst, $01

Filmore_LoopDC:
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sRet

Filmore_LoopDB:
	sNote		nB2, $0E
	sNote		nRst, $01
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $0A
	sVol		-$03
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB2, $0D
	sNote		nRst, $02
	sNote		nB2, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $02
	sNote		nRst, $05
	sNote		nB2, $0F
	sNote		nG2, $0E
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nG2, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $0A
	sVol		-$03
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nG2, $07
	sNote		nRst, $08
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nA2, $07
	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nA2, $02
	sNote		nRst, $05
	sNote		nA2, $0F
	sRet

Filmore_FM2_01:
	sFrac		$0044		; ssDetune $11
	sNote		nA2
	sFrac		-$0041		; ssDetune $01
	sNote		sHold, nAs2
	sFrac		-$0023		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$001D		; ssDetune $FF
	sNote		sHold, $0C
	sFrac		$0003		; ssDetune $00

	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $07
	sNote		nRst, $08
	sVol		$03
	sNote		nB2, $0D
	sNote		nRst, $02
	sNote		nB2, $05
	sNote		nRst, $02
	sVol		-$03

	sFrac		$003C		; ssDetune $0F
	sNote		nA2, $01
	sFrac		-$003C		; ssDetune $00
	sNote		sHold, nAs2
	sFrac		-$0020		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$001D		; ssDetune $FF
	sNote		sHold, $0C
	sFrac		$0003		; ssDetune $00

	sVol		$03
	sNote		$05
	sNote		nRst, $03
	sVol		-$03
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB2, $07
	sVol		$03

	sNote		$08
	sFrac		-$0040		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0040		; ssDetune $00
	sNote		sHold, nAs2
	sFrac		-$0084		; ssDetune $DF
	sNote		sHold, $01
	sFrac		$0084		; ssDetune $00
	sNote		sHold, nA2
	sFrac		-$0088		; ssDetune $E1
	sNote		sHold, $01
	sFrac		$005C		; ssDetune $F6
	sNote		sHold, nGs2
	sFrac		$007C		; ssDetune $12
	sNote		sHold, nG2
	sFrac		-$0050		; ssDetune $00

	sVol		-$03
	sNote		$08
	sNote		nRst, $07
;	ssDetune	$1A			; ???
;	sNote		$01

	sVol		$03
	sFrac		$0041		; ssDetune $0E
	sNote		nFs2, $01
	sFrac		-$0041		; ssDetune $00
	sNote		sHold, nG2, $0E

	sNote		nRst, $08
	sVol		-$03

	sNote		nG2, $0F
	sFrac		-$0041		; ssDetune $F2
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $E5
	sNote		sHold, $01
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		-$003D		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$0040		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$00AA		; ssDetune $16
	sNote		sHold, nF2
	sFrac		-$0041		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$002D		; ssDetune $00
	sNote		$0F

	sVol		$03
	sNote		$05
	sNote		nRst, $0A
	sVol		-$03
	sNote		nFs2, $0F
	sVol		$03

	sNote		$05
	sFrac		-$002D		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$006E		; ssDetune $0D
	sNote		sHold, nF2
	sFrac		-$0091		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FD
	sNote		sHold, nE2
	sFrac		$0071		; ssDetune $11
	sNote		sHold, nDs2
	sFrac		-$0095		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$0070		; ssDetune $0A
	sNote		sHold, nD2
	sFrac		-$008C		; ssDetune $F3
	sNote		sHold, $01
	sFrac		$003D		; ssDetune $FD
	sNote		sHold, nCs2
	sFrac		$0072		; ssDetune $0E
	sNote		sHold, nC2
	sFrac		-$005E		; ssDetune $00
	sVol		-$03
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Filmore_FM3_00:
	sNote		nFs2, $0E
	sNote		nRst, $01
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs3, $05
	sNote		nRst, $03
	sNote		nFs2, $06
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nRst, $16
	sNote		nAs2, $08
	sNote		nRst, $07
	sNote		nAs3, $05
	sNote		nRst, $03
	sNote		nAs2, $06
	sNote		nRst, $01
	sNote		nAs2, $08
	sNote		nRst, $07
	sNote		nB2, $0E
	sNote		nRst, $01
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $06
	sNote		nRst, $01
	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nB2, $06
	sNote		nRst, $01
	sNote		nB2, $08
	sNote		nRst, $16
	sNote		nGs2, $08
	sNote		nRst, $07
	sNote		nGs3, $05
	sNote		nRst, $03
	sNote		nGs2, $06
	sNote		nRst, $01
	sNote		nGs2, $08
	sNote		nRst, $07
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $08
	sNote		nRst, $16
	sNote		nA2, $08
	sNote		nRst, $07
	sNote		nA3, $05
	sNote		nRst, $03
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nA2, $08
	sNote		nRst, $07
	sNote		nD3, $0E
	sNote		nRst, $01
	sNote		nD3, $06
	sNote		nRst, $02
	sNote		nD3, $07
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nD3, $06
	sNote		nRst, $01
	sNote		nD3, $08
	sNote		nRst, $07
	sRet

Filmore_FM3:
	sVoice		v02
	sPan		left
	sVol		$06

Filmore_Jump03:
	sNote		nRst, $01
	sNote		nFs3, $1D
	sNote		nE3, $1E
	sNote		nD3
	sNote		nCs3
	sNote		nC3, $78

	sCall		$04, Filmore_LoopD6
	sNote		nCs3, $78
	sCall		$02, Filmore_LoopD7
	sCall		$01, Filmore_FM3_00
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $07
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nCs3, $06
	sNote		nRst, $01
	sNote		nCs3, $06
	sNote		nRst, $02
	sNote		nCs3, $07
	sCall		$01, Filmore_FM3_00
	sNote		nFs3, $0E
	sNote		nRst, $01
	sNote		nFs3, $06
	sNote		nRst, $02
	sNote		nFs3, $07
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nFs3, $06
	sNote		nRst, $01
	sNote		nFs3, $08
	sNote		nRst
	sNote		nD3, $77
	sNote		nRst, $01
	sNote		nC3, $77
	sNote		nRst, $01
	sNote		nCs3, $77
	sNote		nRst, $01
	sNote		nCs3, $1D
	sNote		nRst, $01
	sNote		nCs3, $1D

	sCall		$02, Filmore_LoopD8
	sNote		nRst, $01
	sNote		nCs3, $16
	sFrac		$003C		; ssDetune $09
	sNote		sHold, nC3, $01
	sFrac		-$007E		; ssDetune $ED
	sNote		sHold, $01
	sFrac		$0022		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$0020		; ssDetune $00
	sNote		sHold, nAs2
	sFrac		$003C		; ssDetune $0F
	sNote		sHold, nA2
	sNote		sHold, nGs2
	sFrac		-$00BE		; ssDetune $E3
	sNote		sHold, $01
	sFrac		$0082		; ssDetune $00

	sCall		$02, Filmore_LoopD9
	sJump		Filmore_Jump03

Filmore_LoopD6:
	sNote		nCs3, $0E
	sNote		nRst, $01
	sNote		nFs2, $06
	sNote		nRst, $02
	sNote		nFs2, $06
	sNote		nRst, $01
	sRet

Filmore_LoopD8:
	sNote		nRst, $01
	sNote		nCs3, $07
	sNote		nRst, $01
	sNote		nCs3, $06
	sRet

Filmore_LoopD7:
	sNote		nB2, $0E
	sNote		nRst, $01
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nB3, $05
	sNote		nRst, $0A
	sNote		nB2, $06
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB2, $0D
	sNote		nRst, $02
	sNote		nB2, $07
	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nB2, $02
	sNote		nRst, $05
	sNote		nB2, $0F
	sNote		nG2, $0E
	sNote		nRst, $01
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nG2, $07
	sNote		nG3, $05
	sNote		nRst, $0A
	sNote		nG2, $06
	sNote		nRst, $02
	sNote		nG2, $07
	sNote		nRst, $08
	sNote		nA2, $06
	sNote		nRst, $01
	sNote		nA2, $06
	sNote		nRst, $02
	sNote		nA2, $07
	sNote		nA3, $05
	sNote		nRst, $03
	sNote		nA2, $02
	sNote		nRst, $05
	sNote		nA2, $0F
	sRet

Filmore_LoopD9:
	sFrac		$0044		; ssDetune $11
	sNote		nA2
	sFrac		-$0041		; ssDetune $01
	sNote		sHold, nAs2
	sFrac		-$0023		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$001D		; ssDetune $FF
	sNote		sHold, $0C
	sFrac		$0003		; ssDetune $00

	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB3, $0D
	sNote		nRst, $02
	sNote		nB3, $05
	sNote		nRst, $02

	sFrac		$003C		; ssDetune $0F
	sNote		nA2, $01
	sFrac		-$003C		; ssDetune $00
	sNote		sHold, nAs2
	sFrac		-$0020		; ssDetune $F7
	sNote		sHold, nB2
	sFrac		$001D		; ssDetune $FF
	sNote		sHold, $0C
	sFrac		$0003		; ssDetune $00

	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nB2, $07
	sNote		nRst, $08
	sNote		nB2, $07

	sNote		nB3, $08
	sFrac		-$0040		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0040		; ssDetune $00
	sNote		sHold, nAs3
	sFrac		-$0084		; ssDetune $DF
	sNote		sHold, $01
	sFrac		$0084		; ssDetune $00
	sNote		sHold, nA3
	sFrac		-$0088		; ssDetune $E1
	sNote		sHold, $01
	sFrac		$005C		; ssDetune $F6
	sNote		sHold, nGs3
	sFrac		$007C		; ssDetune $12
	sNote		sHold, nG3
	sFrac		-$0050		; ssDetune $00

	sNote		nG2, $08
	sNote		nRst, $07
;	ssDetune	$1A			; ???
;	sNote		$01

	sFrac		$0041		; ssDetune $0E
	sNote		nFs3, $01
	sFrac		-$0041		; ssDetune $00
	sNote		sHold, nG3, $0E

	sNote		nRst, $08

	sNote		nG2, $0F
	sFrac		-$0041		; ssDetune $F2
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $E5
	sNote		sHold, $01
	sFrac		$00BE		; ssDetune $0E
	sNote		sHold, nFs2
	sFrac		-$003D		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$0040		; ssDetune $F4
	sNote		sHold, $01
	sFrac		$00AA		; ssDetune $16
	sNote		sHold, nF2
	sFrac		-$0041		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$002D		; ssDetune $00
	sNote		$0F

	sNote		nF3, $05
	sNote		nRst, $0A
	sNote		nFs2, $0F

	sNote		nFs3, $05
	sFrac		-$002D		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$006E		; ssDetune $0D
	sNote		sHold, nF3
	sFrac		-$0091		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $FD
	sNote		sHold, nE3
	sFrac		$0071		; ssDetune $11
	sNote		sHold, nDs3
	sFrac		-$0095		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$0070		; ssDetune $0A
	sNote		sHold, nD3
	sFrac		-$008C		; ssDetune $F3
	sNote		sHold, $01
	sFrac		$003D		; ssDetune $FD
	sNote		sHold, nCs3
	sFrac		$0072		; ssDetune $0E
	sNote		sHold, nC3
	sFrac		-$005E		; ssDetune $00
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Filmore_FM4:
	sPan		center
	sVol		$03
	sJump		Filmore_FM45

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Filmore_FM5:
	sNote		nRst, $05
	sPan		right
	sVol		$07
	sFrac		-$1B		; ssDetune	-$4

Filmore_FM45:
	sVoice		v03
	sLFO		3.98hz
	sAMSFMS		0db, 20%

Filmore_Jump01:
	sNote		nRst, $08
	sVibratoSet	FM5_Main
	sNote		nFs3, $07
	sNote		nB3, $08
	sNote		nD4, $07
	sNote		nCs4, $08
	sNote		nFs3, $07
	sNote		nFs4, $08
	sNote		nFs3, $07
	sNote		nE4, $08
	sNote		nB3, $07
	sNote		nB4, $08
	sNote		nB3, $07
	sNote		nD4, $08
	sNote		nB3, $07
	sNote		nB4, $08
	sNote		nB3, $07
	sNote		nCs4, $08
	sNote		nGs3, $07
	sNote		nF3, $08
	sNote		nGs3, $07
	sNote		nCs4, $26
	sNote		nGs4, $07
	sNote		nF4, $08
	sNote		nGs4, $07
	sNote		nB4, $08
	sNote		nCs5, $07
	sNote		nD5, $08
	sNote		nB4, $07
	sNote		nFs4, $08
	sNote		nCs4, $07
	sNote		nG4, $08
	sNote		nCs4, $07
	sNote		nB4, $08
	sNote		nCs4, $07
	sNote		nAs4, $08
	sNote		nCs4, $07
	sNote		nD5, $08
	sNote		nFs4, $07
	sNote		nCs5, $08
	sNote		nFs4, $07
	sNote		nG5, $08
	sNote		nFs4, $07
	sNote		nFs5, $08
	sNote		nFs4, $07
	sNote		nCs4, $08
	sNote		nD4, $07
	sNote		nE4, $08
	sNote		nAs3, $07
	sNote		nB3, $08
	sNote		nCs4, $07
	sNote		nFs3, $08
	sNote		nGs3, $07
	sNote		nAs3, $08
	sNote		nB3, $07
	sNote		nCs4, $08
	sNote		nD4, $07
	sNote		nE4, $08
	sNote		nAs3, $07
	sNote		nB3, $08
	sNote		nCs4, $07

	sCall		$01, Filmore_FMA_1B
	sCall		$01, Filmore_FMA_06
	sCall		$01, Filmore_FMA_07
	sCall		$01, Filmore_FMA_08
	sCall		$01, Filmore_FMA_09
	sCall		$01, Filmore_FMA_1C
	sCall		$01, Filmore_FMA_0B

	sVibratoSet	FM5_Main
	sNote		nCs4, $07

	sCall		$01, Filmore_FMA_1B
	sCall		$01, Filmore_FMA_08
	sCall		$01, Filmore_FMA_07
	sCall		$01, Filmore_FMA_06

	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $0A

	sFrac		$0040		; ssDetune $0C
	sNote		nE4, $01
	sFrac		-$003B		; ssDetune $01
	sNote		sHold, nF4
	sFrac		-$003C		; ssDetune $F5
	sNote		sHold, nFs4
	sFrac		$0040		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0009		; ssDetune $00
	sNote		nRst, $0A

	sCall		$01, Filmore_FMA_1C
	sCall		$01, Filmore_FMA_0B

	sVibratoSet	FM5_Main
	sNote		nCs4, $05
	sNote		nRst, $02

	sCall		$01, Filmore_FMA_01

	sFrac		-$0080		; ssDetune $ED
	sNote		sHold, $01
	sFrac		$006B		; ssDetune $FA
	sNote		sHold, nC4
	sFrac		$003F		; ssDetune $0C
	sNote		sHold, nB3
	sFrac		-$002A		; ssDetune $00

	sCall		$01, Filmore_FMA_1D

	sFrac		$0017		; ssDetune $04
	sNote		sHold, nD4, $01
	sFrac		-$0052		; ssDetune $EF
	sNote		sHold, nC4
	sFrac		-$0021		; ssDetune $E9
	sNote		sHold, nAs3
	sFrac		$005C		; ssDetune $00

	sCall		$01, Filmore_FMA_12
	sCall		$01, Filmore_FMA_13
	sCall		$01, Filmore_FMA_01

	sFrac		$003C		; ssDetune $09
	sNote		sHold, nC4, $01
	sFrac		-$0020		; ssDetune $08
	sNote		sHold, nB3
	sFrac		-$005C		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$0040		; ssDetune $00

	sCall		$01, Filmore_FMA_1D

	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD4, $01
	sFrac		-$0045		; ssDetune $FD
	sNote		sHold, nC4
	sFrac		$0031		; ssDetune $0B
	sNote		sHold, nAs3
	sFrac		-$0027		; ssDetune $00

	sCall		$01, Filmore_FMA_12

	sNote		nE4, $16
	sNote		nFs4, $0F
	sFrac		$0027		; ssDetune $09
	sNote		nGs4, $01
	sFrac		-$0088		; ssDetune $EA
	sNote		sHold, nA4
	sFrac		$0089		; ssDetune $0A
	sNote		sHold, $01
	sFrac		-$0054		; ssDetune $F5
	sNote		sHold, nAs4
	sFrac		$002C		; ssDetune $00
	sNote		sHold, $13

	sNote		nB4, $16
	sFrac		$0011		; ssDetune $05
	sNote		$01
	sFrac		-$003B		; ssDetune $F4
	sNote		sHold, nC5
	sFrac		$0052		; ssDetune $06
	sNote		sHold, $01
	sFrac		-$0049		; ssDetune $FB
	sNote		sHold, nCs5
	sFrac		$0027		; ssDetune $01
	sNote		sHold, $0B
	sFrac		-$0006		; ssDetune $00

	sNote		nD5, $17
	sNote		nCs5, $16
	sNote		nB4, $17

	sFrac		$003B		; ssDetune $11
	sNote		$01
	sFrac		-$003B		; ssDetune $00
	sNote		sHold, nC5
	sFrac		-$0080		; ssDetune $ED
	sNote		sHold, nCs5
	sFrac		$0080		; ssDetune $00
	sNote		sHold, $13

	sNote		nD5, $0F
	sNote		nB4
	sNote		nGs4, $17
	sNote		nF4, $16
	sNote		nD4, $0F
	sNote		nB3, $17
	sNote		nAs3, $16
	sNote		nGs3, $0F

	sNote		nB3, $08
	sVibratoSet	FM5_X_2
	sNote		sHold, $0D
	sVibratoSet	FM5_X_3
	sNote		sHold, $0E
	sVibratoSet	FM5_X_4
	sNote		sHold, $0D
	sVibratoSet	FM5_X_5
	sNote		sHold, $0E
	sVibratoSet	FM5_X_6
	sNote		sHold, $2A

	sNote		nRst, $01
	sVibratoSet	FM5_Main
	sNote		nB3, $06
	sNote		nRst, $02

	sFrac		-$0063		; ssDetune $F0
	sNote		nD4, $01
	sFrac		$00A3		; ssDetune $0C
	sNote		sHold, nE4
	sFrac		-$0040		; ssDetune $00
	sNote		sHold, nFs4, $05

	sNote		$08
	sVibratoSet	FM5_X_2
	sNote		sHold, $0D
	sVibratoSet	FM5_X_3
	sNote		sHold, $0E
	sVibratoSet	FM5_X_4
	sNote		sHold, $0D
	sVibratoSet	FM5_X_5
	sNote		sHold, $0E
	sVibratoSet	FM5_X_6
	sNote		sHold, $1C

	sFrac		-$001E		; ssDetune $FA
	sNote		$01
	sFrac		-$005F		; ssDetune $E7
	sNote		sHold, $01
	sFrac		$00A0		; ssDetune $07
	sNote		sHold, nF4
	sFrac		-$0083		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$00A0		; ssDetune $0C
	sNote		sHold, nE4
	sFrac		-$0062		; ssDetune $FA
	sNote		sHold, $01
	sFrac		-$0060		; ssDetune $E9
	sNote		sHold, $01
	sFrac		$009E		; ssDetune $05
	sNote		sHold, nDs4
	sFrac		-$0081		; ssDetune $EF
	sNote		sHold, $01
	sFrac		$00A0		; ssDetune $0A
	sNote		sHold, nD4
	sFrac		-$0060		; ssDetune $FA
	sNote		sHold, $01
	sFrac		$00A1		; ssDetune $14
	sNote		sHold, nCs4
	sFrac		-$0064		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$007D		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$00A1		; ssDetune $09
	sNote		sHold, nC4
	sFrac		-$004D		; ssDetune $FB
	sNote		sHold, $01
	sFrac		$004C		; ssDetune $11
	sNote		sHold, nB3
	sFrac		-$0031		; ssDetune $03
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $F2
	sNote		sHold, $01
	sFrac		$006B		; ssDetune $10
	sNote		sHold, nAs3
	sFrac		-$0061		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$00A0		; ssDetune $1E
	sNote		sHold, nA3
	sFrac		-$0060		; ssDetune $06
	sNote		sHold, $01
	sFrac		-$0086		; ssDetune $E7
	sNote		sHold, $01
	sFrac		$00A7		; ssDetune $0D
	sNote		sHold, nGs3
	sFrac		-$0061		; ssDetune $F7
	sNote		sHold, $01
	sFrac		$009C		; ssDetune $1A
	sNote		sHold, nG3
	sFrac		-$005E		; ssDetune $05
	sNote		sHold, $01
	sFrac		-$0081		; ssDetune $E9
	sNote		sHold, $01
	sFrac		$00A2		; ssDetune $0C
	sNote		sHold, nFs3
	sFrac		-$0037		; ssDetune $00

	sVibratoSet	FM5_Main
	sCall		$01, Filmore_FMA_19
	sNote		nCs4, $08
	sNote		nAs3, $07
	sNote		nAs4, $08
	sNote		nAs3, $07
	sCall		$01, Filmore_FMA_19
	sNote		nCs4, $08
	sNote		nE4, $07
	sNote		nFs4, $08
	sNote		nAs4, $07
	sJump		Filmore_Jump01

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Shared
; ---------------------------------------------------------------------------

Filmore_FMA_19:
	sCall		$01, Filmore_FMA_1A
	sNote		nE4, $08
	sNote		nCs4, $07
	sNote		nAs4, $08
	sNote		nCs4, $07

Filmore_FMA_1A:
	sNote		nFs3, $08
	sNote		nB3, $07
	sNote		nD4, $08
	sNote		nFs4, $07
	sNote		nE4, $08
	sNote		nB3, $07
	sNote		nB4, $08
	sNote		nB3, $07
	sNote		nD4, $08
	sNote		nB3, $07
	sNote		nB4, $08
	sNote		nB3, $07
	sRet

Filmore_FMA_1B:
	sNote		nD4, $03
	sVibratoSet	FM5_X_2
	sNote		sHold, $07
	sVibratoSet	FM5_X_3
	sNote		sHold, $07
	sVibratoSet	FM5_X_4
	sNote		sHold, $07
	sVibratoSet	FM5_X_5
	sNote		sHold, $07
	sVibratoSet	FM5_X_6
	sNote		sHold, $0B
	sRet

Filmore_FMA_01:
	sNote		nCs4, $03
	sVibratoSet	FM5_X_2
	sNote		sHold, $07
	sVibratoSet	FM5_X_3
	sNote		sHold, $07
	sVibratoSet	FM5_X_4
	sNote		sHold, $07
	sVibratoSet	FM5_X_5
	sNote		sHold, $07
	sVibratoSet	FM5_X_6
	sNote		sHold, $0B
	sRet

Filmore_FMA_02:
	sNote		$05
	sNote		nRst, $03
	sNote		nB3, $05
	sNote		nRst, $02
	sNote		nCs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sRet

Filmore_FMA_03:
	sVibratoSet	FM5_Main
	sNote		nAs3, $05
	sNote		nRst, $03
	sNote		nB3, $05
	sNote		nRst, $02

	sNote		nCs4, $0C
	sFrac		$003C		; ssDetune $09
	sNote		sHold, nC4, $01
	sFrac		-$0020		; ssDetune $08
	sNote		sHold, nB3
	sFrac		$005A		; ssDetune $21
	sNote		sHold, nAs3
	sFrac		-$0076		; ssDetune $00
	sRet

Filmore_FMA_06:
	sFrac		$003E		; ssDetune $0A
	sNote		sHold, nCs4, $01
	sFrac		-$0002		; ssDetune $09
	sNote		sHold, nC4
	sFrac		-$007E		; ssDetune $ED
	sNote		sHold, $01
	sFrac		$0042		; ssDetune $00
	sRet

Filmore_FMA_07:
	sVibratoSet	FM5_Main
	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nD4, $0C
	sRet

Filmore_FMA_08:
	sFrac		$003E		; ssDetune $0A
	sNote		sHold, nCs4, $01
	sFrac		-$0002		; ssDetune $09
	sNote		sHold, nC4
	sFrac		-$0001		; ssDetune $11
	sNote		sHold, nB3
	sFrac		-$003B		; ssDetune $00
	sRet

Filmore_FMA_09:
	sNote		$05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $0A

	sFrac		$0055		; ssDetune $10
	sNote		nE4, $01
	sFrac		-$0046		; ssDetune $03
	sNote		sHold, nF4
	sFrac		-$0050		; ssDetune $F3
	sNote		sHold, nFs4
	sFrac		$0041		; ssDetune $00
	sNote		sHold, $02
	sNote		nRst, $0A
	sRet

Filmore_FMA_1D:
	sCall		$01, Filmore_FMA_03
	sCall		$01, Filmore_FMA_02
	sCall		$01, Filmore_FMA_1B
	sCall		$01, Filmore_FMA_0F
	sCall		$01, Filmore_FMA_07
	sCall		$01, Filmore_FMA_10
;	sCall		$01, Filmore_FMA_0A

Filmore_FMA_0A:
	sNote		nE4, $03
	sVibratoSet	FM5_X_2
	sNote		sHold, $07
	sVibratoSet	FM5_X_3
	sNote		sHold, $07
	sVibratoSet	FM5_X_4
	sNote		sHold, $07
	sVibratoSet	FM5_X_5
	sNote		sHold, $07
	sVibratoSet	FM5_X_6
	sNote		sHold, $0B
	sRet

Filmore_FMA_0B:
	sVibratoSet	FM5_Main
	sNote		nB3, $05
	sVibratoSet	FM5_X_2
	sNote		sHold, $0B
	sVibratoSet	FM5_X_3
	sNote		sHold, $0B
	sVibratoSet	FM5_X_4
	sNote		sHold, $0B
	sVibratoSet	FM5_X_5
	sNote		sHold, $0C
	sVibratoSet	FM5_X_6
	sNote		sHold, $12
	sRet

Filmore_FMA_0F:
	sFrac		$003E		; ssDetune $0A
	sNote		sHold, nCs4, $01
	sNote		sHold, nC4
	sFrac		-$0079		; ssDetune $EF
	sNote		sHold, $01
	sFrac		$003B		; ssDetune $00
	sRet

Filmore_FMA_10:
	sFrac		$003E		; ssDetune $0A
	sNote		sHold, nCs4, $01
	sFrac		-$0002		; ssDetune $09
	sNote		sHold, nC4
	sFrac		-$007B		; ssDetune $EE
	sNote		sHold, $01
	sFrac		$003F		; ssDetune $00

	sNote		nB3, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nD4, $05
	sNote		nRst, $03
	sNote		nFs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nD4, $05
	sNote		nRst, $02
	sRet

Filmore_FMA_12:
	sVibratoSet	FM5_Main
	sNote		nA3, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02

	sNote		nE4, $0C
	sFrac		$003B		; ssDetune $0A
	sNote		sHold, nD4, $01
	sFrac		-$0045		; ssDetune $FD
	sNote		sHold, nC4
	sFrac		$003C		; ssDetune $0E
	sNote		sHold, nAs3
	sFrac		-$0032		; ssDetune $00

	sNote		nA3, $05
	sNote		nRst, $03
	sNote		nCs4, $05
	sNote		nRst, $02
	sNote		nE4, $05
	sNote		nRst, $03
	sNote		nG4, $05
	sNote		nRst, $02
	sNote		nFs4, $05
	sNote		nRst, $03
	sNote		nE4, $05
	sNote		nRst, $02

	sFrac		$0030		; ssDetune $09
	sNote		nE4, $01
	sFrac		-$0080		; ssDetune $F1
	sNote		sHold, nF4
	sFrac		$007D		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$005A		; ssDetune $F7
	sNote		sHold, nFs4
	sFrac		$002D		; ssDetune $00
	sNote		sHold, $13
	sRet

Filmore_FMA_13:
	sNote		nE4, $16
	sNote		nD4, $0F

	sFrac		$0023		; ssDetune $08
	sNote		nG4, $01
	sFrac		-$007C		; ssDetune $EC
	sNote		sHold, nGs4
	sFrac		$0080		; ssDetune $09
	sNote		sHold, $01
	sFrac		-$0057		; ssDetune $F5
	sNote		sHold, nA4
	sFrac		$0030		; ssDetune $00
	sNote		sHold, $13

	sNote		nG4, $16
	sNote		nFs4, $0F
	sRet

Filmore_FMA_1C:
	sNote		nE4, $03
	sVibratoSet	FM5_X_2
	sNote		sHold, $07
	sVibratoSet	FM5_X_3
	sNote		sHold, $07
	sVibratoSet	FM5_X_4
	sNote		sHold, $07
	sVibratoSet	FM5_X_5
	sNote		sHold, $07
	sVibratoSet	FM5_X_6
	sNote		sHold, $0E
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 and PSG2 data
; ---------------------------------------------------------------------------

Filmore_PSG2:
	sNote		nCut, $0C
	sFrac		$0C		;	ssDetune	$01
	sVol		$10

Filmore_PSG1:
	sFrac		$0C00
	sVol		$18
	sVolEnv		v08

Filmore_PSG1_01:
	sCall		$04, Filmore_PSG1_00
	sNote		nGs2, $08
	sNote		nB2, $07
	sNote		nD3, $08
	sNote		nB2, $07
	sNote		nGs3, $08
	sNote		nD3, $07
	sNote		nB3, $08
	sNote		nGs3, $07
	sNote		nD4, $08
	sNote		nB3, $07
	sNote		nGs3, $08
	sNote		nD3, $07
	sNote		nGs3, $08
	sNote		nD3, $07
	sNote		nB2, $08
	sNote		nGs2, $07
	sNote		nCs2, $1E
	sNote		nDs2
	sNote		nE2
	sNote		nF2
	sNote		nFs4, $08
	sNote		nE4, $07
	sNote		nCs4, $08
	sNote		nAs3, $07
	sNote		nFs3, $08
	sNote		nE3, $07
	sNote		nCs3, $08
	sNote		nAs2, $07
	sNote		nFs2, $08
	sNote		nGs2, $07
	sNote		nAs2, $08
	sNote		nB2, $07
	sNote		nCs3, $08
	sNote		nD3, $07
	sNote		nE3, $08
	sNote		nCs3, $07
	sNote		nB1, $08
	sNote		nRst, $07
	sNote		nB1, $08
	sNote		nB2, $07
	sNote		nRst, $0F
	sNote		nFs2, $1D
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nE2, $07
	sNote		nD2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nD2, $07
	sNote		nGs1, $08
	sNote		nB1, $07
	sNote		nE2, $08
	sNote		nB1, $07
	sNote		nGs2, $08
	sNote		nE2, $07
	sNote		nB2, $08
	sNote		nGs2, $07
	sNote		nG1, $08
	sNote		nB1, $07
	sNote		nE2, $08
	sNote		nG2, $07
	sNote		nA1, $08
	sNote		nCs2, $07
	sNote		nE2, $08
	sNote		nFs2, $07
	sNote		nB1, $08
	sNote		nRst, $07
	sNote		nB1, $08
	sNote		nB2, $07
	sNote		nRst, $0F
	sNote		nFs2, $1D
	sNote		nRst, $01
	sNote		nFs2, $08
	sNote		nE2, $07
	sNote		nD2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nD2, $07
	sNote		nGs1, $08
	sNote		nB1, $07
	sNote		nE2, $08
	sNote		nB1, $07
	sNote		nGs2, $08
	sNote		nE2, $07
	sNote		nB2, $08
	sNote		nGs2, $07
	sNote		nG1, $08
	sNote		nB1, $07
	sNote		nE2, $08
	sNote		nG2, $07
	sNote		nFs2, $08
	sNote		nE2, $07
	sNote		nD2, $08
	sNote		nCs2, $07
	sNote		nE1, $08
	sNote		nAs1, $07
	sNote		nCs2, $08
	sNote		nAs1, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nG1, $08
	sNote		nAs1, $07
	sNote		nCs2, $08
	sNote		nAs1, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nFs1, $08

	sCall		$03, Filmore_LoopFE
	sNote		nB1, $07
	sNote		nG1, $08
	sNote		nB1, $07
	sNote		nD2, $08
	sNote		nB1, $07
	sNote		nGs1, $08
	sNote		nB1, $07
	sNote		nD2, $08
	sNote		nB1, $07
	sNote		nA1, $08
	sNote		nE1, $07
	sNote		nA1, $08
	sNote		nCs2, $07

	sCall		$02, Filmore_LoopFF
	sNote		nE2, $08
	sNote		nRst, $07
	sNote		nCs2, $08
	sNote		nRst, $07
	sNote		nD2, $08
	sNote		nCs2, $07
	sNote		nD2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nG2, $07
	sNote		nA2, $08
	sNote		nB2, $07
	sNote		nCs3, $08
	sNote		nB2, $07
	sNote		nA2, $08
	sNote		nG2, $07
	sNote		nFs2, $08
	sNote		nE2, $07
	sNote		nE1, $08
	sNote		nAs1, $07
	sNote		nCs2, $08
	sNote		nAs1, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nG1, $08
	sNote		nAs1, $07
	sNote		nCs2, $08
	sNote		nAs1, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nE2, $08
	sNote		nCs2, $07
	sNote		nFs1, $08

	sCall		$03, Filmore_LoopFE
	sNote		nB1, $07
	sNote		nG1, $08
	sNote		nB1, $07
	sNote		nD2, $08
	sNote		nB1, $07
	sNote		nGs1, $08
	sNote		nB1, $07
	sNote		nD2, $08
	sNote		nB1, $07
	sNote		nA1, $08
	sNote		nE1, $07
	sNote		nA1, $08
	sNote		nCs2, $07

	sCall		$02, Filmore_LoopFF
	sNote		nE2, $08
	sNote		nRst, $07
	sNote		nCs2, $08
	sNote		nRst, $07
	sNote		nD2, $08
	sNote		nCs2, $07
	sNote		nD2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nG2, $07
	sNote		nFs1, $08
	sNote		nAs1, $07
	sNote		nCs2, $08
	sNote		nE2, $07
	sNote		nFs2, $08
	sNote		nAs2, $07
	sNote		nCs3, $08
	sNote		nFs3, $07
	sNote		nB2, $4B
	sNote		nG2, $08
	sNote		nD2, $07
	sNote		nG2, $08
	sNote		nB2, $07
	sNote		nD3, $0F
	sNote		nF2, $17
	sNote		nD2, $16
	sNote		nB1, $0F
	sNote		nF1, $3C
	sNote		nFs1
	sNote		nE1
	sNote		nFs1, $1E
	sNote		nAs1
	sNote		nCs2
	sNote		nFs2

	sCall		$04, Filmore_Loop102
	sJump		Filmore_PSG1_01

Filmore_PSG1_00:
	sNote		nB1, $08
	sNote		nFs2, $07
	sNote		nB2, $08
	sNote		nFs2, $07
	sRet

Filmore_LoopFE:
	sNote		nB1, $07
	sNote		nD2, $08
	sRet

Filmore_LoopFF:
	sNote		nE2, $08
	sNote		nRst, $07
	sNote		nCs2, $08
	sNote		nD2, $07
	sRet

Filmore_Loop102:
	sNote		nD2
	sNote		nCs2
	sNote		nE2
	sNote		nCs2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG Noise data
; ---------------------------------------------------------------------------

Filmore_PSG3:
	sFlags		M
	sVol		$7F

Filmore_PSG3_00:
	sCall		$08, Filmore_PSG3_03
	sNote		nDs6, $2D
	sNote		nHiHat, $4B
	sNote		nDs6, $78
	sCall		$2F, Filmore_PSG3_03
	sNote		nDs6, $17
	sNote		nHiHat, $1AB
	sNote		nE6, $1E
	sNote		nDs6, $1E
	sCall		$03, Filmore_PSG3_03
	sCall		$03, Filmore_PSG3_01
	sNote		nE6, $1E
	sJump		Filmore_PSG3_00

Filmore_PSG3_01:
	sNote		nDs6, $08
	sNote		nHiHat, $07
	sNote		nDs6, $0F
	sCall		$02, Filmore_PSG3_03

Filmore_PSG3_03:
	sNote		nDs6, $08
	sNote		nHiHat, $16
	sRet
; ---------------------------------------------------------------------------

Filmore_PSG4:
	sVol		$08

Filmore_PSG4_00:
	sCall		$07, Filmore_LoopE2
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		$18
	sNote		$2D
	sNote		$2D
	sNote		$1E
	sNote		$78
	sNote		$08
	sVolEnv		v02
	sVol		-$18

	sCall		$02, Filmore_LoopE3
	sCall		$02, Filmore_LoopE4
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$03, Filmore_LoopE5
	sCall		$02, Filmore_LoopE6
	sCall		$02, Filmore_LoopE7
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$02, Filmore_LoopE8
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		$18
	sNote		$08
	sVolEnv		v02
	sVol		-$18
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$03, Filmore_LoopE9
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$03, Filmore_LoopEA
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$02, Filmore_LoopEB
	sCall		$02, Filmore_LoopEC
	sCall		$02, Filmore_LoopED
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		$18
	sNote		$08
	sVolEnv		v02
	sVol		-$18
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$03, Filmore_LoopEE
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$03, Filmore_LoopEF
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01

	sCall		$02, Filmore_LoopF0
	sCall		$02, Filmore_LoopF1
	sCall		$02, Filmore_LoopF2
	sNote		$0F
	sVolEnv		v01
	sNote		$08
	sVolEnv		v02
	sNote		$07
	sVolEnv		v02
	sVol		$10
	sNote		$1E
	sNote		$1E
	sNote		$0F
	sVol		-$10
	sNote		$08
	sNote		$16
	sVol		$10
	sNote		$0F
	sVolEnv		v02
	sNote		$1E
	sNote		$1E
	sNote		$0F
	sNote		$08
	sNote		$16
	sNote		$0F
	sVolEnv		v02
	sNote		$1E
	sNote		$1E
	sVolEnv		v02
	sNote		$0F
	sNote		$08
	sNote		$16
	sNote		$0F

	sCall		$02, Filmore_LoopF3
	sVolEnv		v01
	sVol		$10
	sNote		$1E
	sVol		-$20
	sNote		$1E
	sVol		$28
	sNote		$08
	sVolEnv		v02
	sVol		-$18

	sCall		$01, Filmore_PSG4_02
	sCall		$03, Filmore_PSG4_01
	sNote		$1E
	sJump		Filmore_PSG4_00

Filmore_PSG4_01:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sNote		$0F
	sNote		$08
	sVolEnv		v02
	sVol		$10

Filmore_PSG4_02:
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sVolEnv		v02
	sNote		$08
	sVol		$10
	sNote		$07
	sVolEnv		v01
	sVol		-$10

	sCall		$01, Filmore_LoopF7

Filmore_LoopF7:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sRet

Filmore_LoopE2:
	sNote		nWhitePSG3, $08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopE3:
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sRet

Filmore_LoopE4:
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sRet

Filmore_LoopE5:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopE6:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01
	sRet

Filmore_LoopE7:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopE8:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopE9:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopEA:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopEB:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopEC:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01
	sRet

Filmore_LoopED:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopEE:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopF3:
	sVolEnv		v02
	sNote		$0F
	sNote		$08
	sNote		$07
	sRet

Filmore_LoopEF:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopF0:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

Filmore_LoopF1:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sVol		-$10
	sNote		$07
	sVolEnv		v01
	sRet

Filmore_LoopF2:
	sNote		$08
	sVolEnv		v02
	sVol		$10
	sNote		$07
	sVolEnv		v02
	sNote		$08
	sNote		$07
	sVolEnv		v01
	sVol		-$10
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Dracula_Voice
	sHeaderSamples	Dracula_Samples
	sHeaderVibrato	Dracula_Vib
	sHeaderEnvelope	Dracula_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$EC
	sChannel	DAC1, Dracula_DAC1
	sChannel	FM1, Dracula_FM1
	sChannel	FM2, Dracula_FM3
	sChannel	FM3, Dracula_FM2
	sChannel	FM4, Dracula_FM4
	sChannel	FM5, Dracula_FM5
	sChannel	PSG1, Dracula_PSG1
	sChannel	PSG2, Dracula_PSG2
	sChannel	PSG3, Dracula_PSG3
	sChannel	PSG4, Dracula_PSG4
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Dracula_Voice:
	sNewVoice	v00
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0E, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $00, $00, $00
	sReleaseRate	$03, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1D, $0A, $0A, $0A
	sFinishVoice

	sNewVoice	v01
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
	sTotalLevel	$10, $08, $1C, $08
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$03
	sFeedback	$02
	sDetune		$02, $03, $03, $03
	sMultiple	$07, $00, $00, $01
	sRateScale	$01, $01, $01, $01
	sAttackRate	$16, $1C, $1C, $1C
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$02, $06, $09, $01
	sDecay2Rate	$00, $00, $02, $00
	sDecay1Level	$04, $03, $03, $05
	sReleaseRate	$03, $06, $04, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$10, $14, $32, $0C
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $0E, $0E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $1F, $1F, $1F
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $00, $00, $00
	sReleaseRate	$03, $06, $06, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1D, $0C, $0C, $0C
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Dracula_Samples:
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

	sNewSample	MidTimpani
	sSampFreq	$0130
	sSampStart	dsTom, deTom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	LowTimpani
	sSampFreq	$00E0
	sSampStart	dsTom, deTom
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

Dracula_Vib:
	sVibrato FM25,		$14, $00, $2000, $003F, Triangle
	sVibrato FM34,		$0C, $00, $2AA8, $002A, Triangle
	sVibrato PSG1,		$00, $00, $2AA8,-$0030, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Dracula_Env:
	sEnvelope v01,		Dracula_Env_v01
	sEnvelope v02,		Dracula_Env_v02
	sEnvelope v03,		Dracula_Env_v03
	sEnvelope v06,		Dracula_Env_v06
	sEnvelope v09,		Dracula_Env_v09
; ---------------------------------------------------------------------------

Dracula_Env_v01:
	sEnv		delay=$03,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Dracula_Env_v02:
	sEnv		delay=$01,	$00, $10, $20, $30, $40
	seMute
; ---------------------------------------------------------------------------

Dracula_Env_v03:
	sEnv		delay=$02,	$00, $08, $10, $18, $20, $28, $30
	seHold		$38
; ---------------------------------------------------------------------------

Dracula_Env_v06:
	sEnv		delay=$03,	$18, $10, $10, $08
	seHold		$00
; ---------------------------------------------------------------------------

Dracula_Env_v09:
	sEnv		$00, $08, $10, $18, $20, $28, $30, $38
	sEnv		$40, $48, $50, $58, $60, $68, $70
	seHold		$78

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Dracula_DAC1:
	sNote		nRst, $300
	sPan		center
	sVol		$04

	sSample		Kick
	sNote		nSample, $18
	sNote		$0C
	sSample		LowTimpani
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		LowTimpani
	sNote		$0C
	sSample		Kick
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0D
	sSample		LowTimpani
	sNote		$05
	sNote		$06
	sSample		Kick
	sNote		$18
	sNote		$0D
	sSample		LowTimpani
	sNote		$05
	sNote		$06
	sSample		Kick
	sNote		$0C
	sSample		LowTimpani
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Timpani7
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		LowTimpani
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		LowTimpani
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sNote		$0C
	sNote		$0C
	sNote		$0C

Dracula_Jump00:
	sSample		Crash3
	sCall		$01, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sCall		$03, Dracula_Loop01
	sNote		$0C
	sNote		$0C
	sSample		Snare
	sNote		$18
	sSample		Kick
	sCall		$01, Dracula_Loop01
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sCall		$01, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C

	sCall		$04, Dracula_Loop01
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sNote		$18
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Crash3
	sCall		$01, Dracula_Loop01
	sNote		$0C
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sCall		$03, Dracula_Loop01
	sNote		$0C
	sNote		$0C
	sSample		Snare
	sNote		$18
	sSample		Kick
	sCall		$01, Dracula_Loop01
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sCall		$01, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C

	sCall		$06, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		MidTimpani
	sNote		$06
	sSample		Snare
	sNote		$06
	sNote		$06
	sSample		Kick
	sNote		$06
	sSample		LowTimpani
	sNote		$06
	sSample		Timpani7
	sNote		$06
	sNote		$06
	sSample		Crash3
	sCall		$03, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sCall		$02, Dracula_Loop01
	sNote		$08
	sSample		Snare
	sNote		$05
	sNote		$0B
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sNote		$18
	sSample		Crash3
	sCall		$03, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sCall		$03, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Crash3

	sCall		$02, Dracula_Loop03
	sSample		Crash3
	sCall		$03, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sSample		Crash3
	sCall		$03, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$18
	sSample		Crash3
	sNote		$78

	sNote		nRst, $F0
	sNote		nRst, $F0

	sSample		Kick
	sNote		nSample, $48
	sSample		Snare
	sNote		$18
	sNote		$60
	sSample		Crash3
	sNote		$48
	sNote		$30
	sNote		$0C
	sSample		LowTimpani
	sNote		$0C
	sNote		$0C
	sNote		$06
	sSample		Timpani7
	sNote		$06
	sSample		Kick
	sNote		$18
	sSample		Snare
	sNote		$06
	sNote		$12
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sNote		$06
	sNote		$12
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$12
	sSample		Kick
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		Kick
	sNote		$06
	sNote		$06
	sSample		Snare
	sNote		$12
	sNote		$06
	sNote		$5A
	sJump		Dracula_Jump00

Dracula_Loop01:
	sNote		$18
	sSample		Snare
	sNote		$18
	sSample		Kick
	sRet

Dracula_Loop03:
	sCall		$03, Dracula_Loop01
	sNote		$18
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Dracula_FM1:
	sVoice		v02
	sPan		center
	sVol		$10
	sNote		nB2, $60
	sNote		nG2, $C0
	sNote		nB2, $60
	sNote		$C0
	sNote		nC3, $C0

	sVol		-$0B
	sCall		$02, Dracula_Loop15
	sNote		nD2, $10
	sNote		nRst, $08
	sCall		$06, Dracula_Loop16
	sNote		nD2, $10
	sNote		nRst, $08
	sCall		$06, Dracula_Loop16

Dracula_FM1_00:
	sCall		$02, Dracula_FM1_01
	sNote		nDs2, $0A
	sNote		nRst, $0E
	sNote		nDs2, $18
	sNote		nRst, $0C

	sCall		$03, Dracula_Loop1B
	sNote		nD2, $0A
	sNote		nRst, $0E
	sNote		nD2, $18
	sNote		nG2, $0A
	sNote		nRst, $0E
	sNote		nG2, $18
	sNote		nC2, $0A
	sNote		nRst, $0E
	sNote		nC2, $18
	sNote		nD2, $0A
	sNote		nRst, $0E
	sNote		nD2, $18
	sNote		nG2, $0A
	sNote		nRst, $0E
	sNote		nG2, $18
	sNote		nRst, $0C

	sCall		$03, Dracula_Loop18
	sNote		nDs2, $0A
	sNote		nRst, $0E
	sNote		nDs2, $18
	sNote		nRst, $0C

	sCall		$03, Dracula_Loop16
	sNote		nG2, $0A
	sNote		nRst, $0E
	sNote		nG2, $18
	sNote		nRst, $0C

	sCall		$03, Dracula_Loop34
	sNote		nE2, $0A
	sNote		nRst, $0E
	sNote		nE2, $18
	sNote		nA2, $0A
	sNote		nRst, $0E
	sNote		nA2, $18
	sNote		nD3, $0A
	sNote		nRst, $0E
	sNote		nD3, $18
	sNote		nRst, $0C
	sNote		nD4, $18
	sNote		$0A
	sNote		nRst, $02
	sNote		nD3, $0A
	sNote		nRst, $0E
	sNote		nD3, $18
	sNote		nRst, $0C

	sCall		$03, Dracula_Loop1F
	sCall		$02, Dracula_Loop18
	sNote		nG3, $0A
	sCall		$05, Dracula_Loop20
	sCall		$02, Dracula_Loop21
	sCall		$06, Dracula_Loop22

	sNote		nRst, $02
	sNote		nDs3, $0A
	sNote		nRst, $02
	sNote		nF3, $0A

	sCall		$02, Dracula_Loop23
	sCall		$08, Dracula_Loop20
	sCall		$08, Dracula_Loop25
	sCall		$08, Dracula_Loop26
	sCall		$08, Dracula_Loop14
	sCall		$04, Dracula_Loop22
	sCall		$04, Dracula_Loop25
	sCall		$06, Dracula_Loop20

	sNote		nRst, $02
	sNote		nG3, $0A
	sNote		nRst, $02
	sNote		nG2, $0A

	sCall		$04, Dracula_Loop26
	sCall		$04, Dracula_Loop14
	sCall		$08, Dracula_Loop20
	sCall		$04, Dracula_Loop2E
	sCall		$04, Dracula_Loop2F
	sNote		nRst, $02
	sCall		$02, Dracula_Loop1B

	sNote		nDs3, $0A
	sNote		nRst, $02
	sNote		nF3, $0A
	sNote		nRst, $02
	sCall		$02, Dracula_Loop34
	sNote		nF3, $0A
	sNote		nRst, $02
	sNote		nF2, $0A

	sCall		$02, Dracula_Loop30
	sCall		$08, Dracula_Loop2F
	sCall		$10, Dracula_Loop32

	sNote		nRst, $02
	sVol		$0B
	sNote		nAs2, $60
	sNote		nGs2
	sNote		nFs2
	sNote		nF2
	sNote		nRst, $18
	sVol		-$0B
	sNote		nAs2, $48
	sNote		nGs2, $0A
	sNote		nRst, $0E
	sNote		nGs2, $0A
	sNote		nRst, $56
	sNote		nFs2, $48
	sNote		nDs2, $30
	sNote		nF2
	sNote		nF2, $04
	sNote		nRst, $02
	sNote		nF2, $0A

	sCall		$01, Dracula_Loop33
	sNote		nRst, $14
	sNote		nAs2, $0A
	sNote		nRst, $08
	sNote		nA2, $0A
	sCall		$02, Dracula_Loop33
	sNote		nRst, $14
	sNote		nDs2, $0A
	sNote		nRst, $08

	sNote		nCs2, $04
	sFrac		-$0020		; ssDetune $FD
	sNote		sHold, $01
	sFrac		-$0035		; ssDetune $F8
	sNote		sHold, $01
	sFrac		-$004B		; ssDetune $F1
	sNote		sHold, $01
	sFrac		$0140		; ssDetune $0F
	sNote		sHold, nC2
	sFrac		-$0056		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0020		; ssDetune $04
	sNote		sHold, $01
	sNote		nRst
	sFrac		$00C0		; ssDetune $16
	sNote		$01
	sFrac		-$00E0		; ssDetune $01
	sNote		$06

	sCall		$05, Dracula_Loop34
	sNote		nAs2, $0A
	sNote		nRst, $08
	sNote		nA2, $0A
	sNote		nRst, $08
	sNote		nF2, $0A

	sFrac		-$000A		; ssDetune $00
	sNote		nRst, $56
	sJump		Dracula_FM1_00

Dracula_Loop34:
	sNote		nF2, $0A
	sNote		nRst, $02
	sRet

Dracula_Loop14:
	sNote		nRst, $02
	sNote		nD2, $0A
	sRet

Dracula_Loop15:
	sNote		nD2, $10
	sNote		nRst, $08
	sNote		nD2, $0A
	sNote		nRst, $02
	sNote		nD3, $0A

	sCall		$04, Dracula_Loop14
	sNote		nRst, $02
	sRet

Dracula_Loop16:
	sNote		nD2, $0A
	sNote		nRst, $02
	sRet

Dracula_Loop18:
	sNote		nG2, $0A
	sNote		nRst, $02
	sRet

Dracula_Loop19:
	sNote		nG2, $0A
	sNote		nRst, $0E
	sNote		nG2, $18
	sNote		nRst, $0C

	sCall		$03, Dracula_Loop18
	sRet

Dracula_FM1_01:
	sCall		$02, Dracula_Loop19
	sNote		nDs2, $0A
	sNote		nRst, $0E
	sNote		nDs2, $0A
	sNote		nRst, $0E
	sNote		nF2, $0A
	sNote		nRst, $0E
	sNote		nF2, $0A
	sNote		nRst, $0E
	sNote		nG2, $0A
	sNote		nRst, $0E
	sNote		nG2, $18
	sNote		nRst, $0C
	sCall		$03, Dracula_Loop18
	sRet

Dracula_Loop1B:
	sNote		nDs2, $0A
	sNote		nRst, $02
	sRet

Dracula_Loop30:
	sCall		$02, Dracula_Loop2E
	sNote		nRst, $02
	sNote		nFs3, $0A
	sNote		nRst, $02
	sNote		nFs2, $0A
	sRet

Dracula_Loop2F:
	sNote		nRst, $02
	sNote		nGs2, $0A
	sRet

Dracula_Loop1F:
	sNote		nD3, $0A
	sNote		nRst, $02
	sRet

Dracula_Loop20:
	sNote		nRst, $02
	sNote		nG2, $0A
	sRet

Dracula_Loop21:
	sNote		nRst, $02
	sCall		$02, Dracula_Loop34
	sNote		nF3, $0A
	sNote		nRst, $02
	sNote		nF2, $0A
	sRet

Dracula_Loop22:
	sNote		nRst, $02
	sNote		nDs2, $0A
	sRet

Dracula_Loop23:
	sCall		$02, Dracula_Loop14
	sNote		nRst, $02
	sNote		nD3, $0A
	sNote		nRst, $02
	sNote		nD2, $0A
	sRet

Dracula_Loop25:
	sNote		nRst, $02
	sNote		nF2, $0A
	sRet

Dracula_Loop26:
	sNote		nRst, $02
	sNote		nC2, $0A
	sRet

Dracula_Loop2E:
	sNote		nRst, $02
	sNote		nFs2, $0A
	sRet

Dracula_Loop32:
	sNote		nRst, $02
	sNote		nAs2, $0A
	sRet

Dracula_Loop33:
	sNote		nRst, $08
	sNote		nF2, $04
	sNote		nRst, $02
	sNote		nF2, $0A
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 ánd FM5 data
; ---------------------------------------------------------------------------

Dracula_FM5:
	sNote		nRst, $0A
	sFrac		-$001E
	sPan		right
	sVoice		v00
	sVol		$16
	sJump		Dracula_FM25

Dracula_FM2:
	sPan		center
	sVoice		v01
	sVol		$12

Dracula_FM25:
	sVibratoSet	FM25
	sCall		$08, Dracula_Loop0E
	sCall		$08, Dracula_Loop0F
	sCall		$07, Dracula_Loop0E

	sNote		nCs6
	sNote		nCs7
	sNote		nD6
	sNote		nD7
	sNote		nD6
	sNote		nD7
	sNote		nC6
	sNote		nC7
	sNote		nD6
	sNote		nD7
	sNote		nF6
	sNote		nF7
	sNote		nF6
	sNote		nF7
	sNote		nDs6
	sNote		nDs7
	sNote		nDs6
	sNote		nDs7

	sCall		$08, Dracula_Loop11
	sVol		-$03
	sCall		$04, Dracula_Loop11

	sVol		$01
	sNote		nD6
	sNote		nD7
	sNote		nD6
	sNote		nD7
	sVol		$02
	sNote		nD6
	sNote		nD7
	sVol		$06
	sNote		nD6
	sNote		nD7
	sVol		-$09

Dracula_Jump03:
	sVoice		v00
	sNote		nG5, $24
	sVol		-$05
	sNote		nA5, $06
	sVol		$03
	sNote		nAs5
	sNote		nFs5, $30
	sVol		$03
	sNote		nG5, $24
	sVol		-$06
	sNote		nA5, $06
	sVol		$03
	sNote		nAs5
	sNote		nC6, $10
	sVol		$03
	sNote		nAs5
	sNote		nA5
	sNote		nG5
	sVol		$02
	sNote		nF5
	sVol		-$03
	sNote		nDs5
	sNote		nA5
	sNote		nG5
	sNote		nF5
	sVol		-$04
	sNote		nG5, $54
	sNote		nRst, $0C
	sVol		$04
	sNote		nG5, $24
	sVol		-$05
	sNote		nA5, $06
	sVol		$03
	sNote		nAs5
	sNote		nFs5, $30
	sVol		$03
	sNote		nG5, $24
	sVol		-$06
	sNote		nA5, $06
	sVol		$03
	sNote		nAs5
	sNote		nC6, $10
	sVol		$03
	sNote		nAs5
	sNote		nA5
	sNote		nG5
	sVol		$02
	sNote		nF5
	sVol		-$03
	sNote		nDs5
	sNote		nA5
	sNote		nG5
	sNote		nF5
	sVol		-$04
	sNote		nG5, $5A
	sNote		nRst, $06
	sVol		$02
	sNote		nG5, $24
	sVol		-$03
	sNote		nA5, $06
	sVol		$03
	sNote		nAs5
	sVol		$02
	sNote		nG5, $10
	sVol		$03
	sNote		nF5
	sNote		nDs5
	sVol		-$02
	sNote		nF5, $24
	sVol		-$06
	sNote		nG5, $06
	sVol		$03
	sNote		nA5
	sNote		nAs5, $18
	sNote		nGs5
	sVol		$02
	sNote		nG5, $10
	sVol		$03
	sNote		nF5
	sNote		nDs5
	sVol		-$04
	sNote		nA5
	sVol		$04
	sNote		nG5
	sNote		nF5
	sVol		-$07
	sNote		nD5, $5A
	sNote		nRst, $06
	sVol		$08
	sNote		nDs5, $10
	sVol		-$01
	sNote		nF5
	sNote		nG5
	sVol		-$02
	sNote		nFs5
	sNote		nG5
	sNote		nA5
	sVol		-$01
	sNote		nAs5
	sNote		nA5
	sVol		-$01
	sNote		nG5, $40
	sVol		$02
	sNote		$10
	sVol		-$01
	sNote		nA5
	sNote		nAs5
	sVol		$01
	sNote		nA5
	sVol		-$01
	sNote		nE5
	sVol		$01
	sNote		nA5
	sVol		-$03
	sNote		nG5, $54
	sNote		nFs5, $06
	sNote		nE5
	sNote		nFs5, $60
	sNote		nD6, $22
	sNote		nRst, $02
	sVol		$03
	sNote		nAs5, $06
	sNote		nC6
	sVol		-$03
	sNote		nD6, $10
	sVol		$03
	sNote		nC6
	sNote		nAs5
	sVol		-$03
	sNote		nC6, $18
	sVol		$05
	sNote		nF5
	sVol		-$05
	sNote		nF6, $22
	sNote		nRst, $02
	sVol		$02
	sNote		nDs6, $06
	sNote		nD6
	sVol		-$02
	sNote		nDs6, $22
	sNote		nRst, $02
	sVol		$03
	sNote		nC6, $06
	sNote		nD6
	sVol		-$03
	sNote		nDs6, $22
	sNote		nRst, $02
	sVol		$03
	sNote		nD6, $06
	sNote		nC6
	sVol		-$03
	sNote		nD6, $18
	sVol		$02
	sNote		nA5
	sVol		-$02
	sNote		nAs5
	sNote		nC6
	sNote		nD6, $22
	sNote		nRst, $02
	sVol		$03
	sNote		nAs5, $06
	sNote		nC6
	sVol		-$03
	sNote		nD6, $10
	sVol		$03
	sNote		nC6
	sNote		nAs5
	sVol		-$03
	sNote		nC6, $18
	sVol		$05
	sNote		nF5
	sVol		-$05
	sNote		nF6, $22
	sNote		nRst, $02
	sVol		$02
	sNote		nDs6, $06
	sNote		nD6
	sVol		-$02
	sNote		nDs6, $22
	sNote		nRst, $02
	sNote		nC6, $06
	sNote		nD6
	sNote		nDs6, $22
	sNote		nRst, $02
	sNote		nD6, $06
	sNote		nC6
	sNote		nD6, $5A
	sNote		nRst, $06
	sNote		nDs6, $10
	sVol		$02
	sNote		nF6
	sNote		nG6
	sNote		nF6
	sVol		$03
	sNote		nC6
	sNote		nF6
	sNote		nD6, $5A
	sNote		nRst, $06
	sVol		-$05
	sNote		nG6, $10
	sVol		$02
	sNote		nA6
	sNote		nAs6
	sNote		nA6
	sVol		$03
	sNote		nF6
	sNote		nD6
	sVol		-$02
	sNote		nG6, $5A
	sNote		nRst, $06
	sVol		-$03
	sNote		nAs6, $10
	sNote		nC7
	sNote		nCs7
	sNote		nC7
	sVol		$05
	sNote		nGs6
	sNote		nF6
	sVol		-$05
	sNote		nAs6
	sNote		nC7
	sNote		nCs7
	sNote		nF7
	sVol		$02
	sNote		nDs7
	sNote		nC7
	sVol		-$02
	sNote		nCs7, $22
	sNote		nRst, $02
	sVol		$02
	sNote		nAs6, $06
	sNote		nC7
	sVol		-$02
	sNote		nCs7, $30
	sNote		nDs7, $22
	sNote		nRst, $02
	sVol		$02
	sNote		nC7, $06
	sNote		nCs7
	sVol		-$02
	sNote		nDs7, $30
	sNote		nF7, $C0

	sVoice		v01
	sVol		$05
	sCall		$02, Dracula_Loop13
	sNote		nRst, $180
	sVol		-$03
	sJump		Dracula_Jump03

Dracula_Loop0E:
	sNote		nB5, $0C
	sNote		nB6
	sRet

Dracula_Loop0F:
	sNote		nG5
	sNote		nG6
	sRet

Dracula_Loop11:
	sNote		nD6
	sNote		nD7
	sRet

Dracula_Loop13:
	sNote		nAs5, $0C
	sNote		nDs6
	sNote		nF6
	sNote		nAs5
	sNote		nAs5
	sNote		nDs6, $06
	sNote		nF6, $0C
	sNote		nAs5, $06
	sNote		nF6, $0C
	sNote		nAs5
	sNote		nDs6
	sNote		nF6
	sNote		nAs5
	sNote		nAs6
	sNote		nAs5, $06
	sNote		nGs6, $0C
	sNote		nAs5, $06
	sNote		nAs6, $0C
	sNote		nAs5
	sNote		nDs6
	sNote		nF6
	sNote		nAs5
	sNote		nAs5
	sNote		nDs6, $06
	sNote		nF6, $0C
	sNote		nAs5, $06
	sNote		nF6, $0C
	sNote		nAs5
	sNote		nDs6
	sNote		nF6
	sNote		nAs5
	sNote		nAs6
	sNote		nAs5, $06
	sNote		nA6, $0C
	sNote		nAs5, $06
	sNote		nFs6, $0C
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Dracula_FM3:
	sVibratoSet	FM34
	sPan		left
	sVoice		v03
	sVol		$11
	sNote		nFs6, $C0
	sVol		$04
	sNote		nA6, $60
	sVol		$05
	sNote		nG6, $30
	sNote		nA6
	sNote		nB6, $60
	sNote		nA6, $30
	sNote		nB6, $18
	sNote		nCs7
	sVol		-$06
	sNote		nC7, $C0
	sVol		$06
	sNote		nA6, $C0
	sNote		nRst, $C0
	sVol		-$06

Dracula_FM3_00:
	sCall		$02, Dracula_Loop0C
	sNote		nAs4
	sNote		nA4, $30
	sNote		nB4
	sVol		$0B
	sNote		$30
	sVol		$F5
	sNote		nG4, $12
	sNote		nA4
	sNote		nAs4, $0C
	sNote		nC5, $30
	sNote		nAs4, $60
	sNote		nRst, $30
	sNote		nD5, $60
	sNote		$12
	sNote		nC5
	sNote		nAs4, $0C
	sNote		nA4, $30
	sNote		nD5, $C0
	sVol		-$05
	sNote		nG5, $60
	sNote		nF5
	sNote		nG5
	sNote		nFs5, $18
	sNote		nD5
	sNote		nE5
	sNote		nFs5
	sNote		nG5, $60
	sNote		nF5
	sNote		nDs5
	sNote		nD5, $18
	sNote		nA4
	sNote		nAs4
	sNote		nC5
	sVol		$05
	sNote		nAs4, $30
	sNote		nC5
	sNote		nD5, $60
	sNote		nG4, $30
	sNote		nC5
	sNote		nAs4, $60
	sNote		nCs6, $30
	sNote		nDs6
	sNote		nCs6
	sNote		nC6
	sNote		nAs5, $60
	sNote		nC6
	sNote		nD6, $C0

	sVol		$01
	sCall		$02, Dracula_Loop0D
	sNote		nF5, $12C
	sNote		nRst, $54
	sVol		-$01
	sJump		Dracula_FM3_00

Dracula_Loop0C:
	sNote		nD5, $30
	sNote		nDs5
	sNote		nD5
	sVol		-$05
	sNote		nDs5
	sVol		$05
	sNote		$30
	sNote		nF5
	sNote		nG5, $60
	sRet

Dracula_Loop0D:
	sNote		nAs5, $60
	sNote		nGs5
	sNote		nFs5
	sNote		nDs5, $30
	sNote		nF5
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Dracula_FM4:
	sVibratoSet	FM34
	sVoice		v03
	sPan		right
	sVol		$11
	sNote		nA5, $C0
	sVol		$04
	sNote		nD6, $60
	sVol		$05
	sNote		nG5, $30
	sNote		nA5
	sNote		nB5, $60
	sNote		nA5, $30
	sNote		nB5, $18
	sNote		nCs6
	sVol		-$06
	sNote		nG6, $C0
	sVol		$06
	sNote		nFs6, $C0
	sNote		nRst, $C0
	sVol		-$06

Dracula_Jump02:
	sNote		nAs4, $30
	sNote		nFs4
	sNote		nG4, $24
	sVol		-$05
	sNote		nF4, $06
	sNote		nG4
	sNote		nC5, $30
	sVol		$05
	sNote		nAs4
	sVol		-$05
	sNote		nA4
	sVol		$05
	sNote		nC5, $24
	sNote		nD5, $06
	sNote		nC5
	sNote		nB4, $30
	sNote		nAs4
	sNote		nFs4
	sNote		nG4, $24
	sVol		-$05
	sNote		nF4, $06
	sNote		nG4
	sNote		nC5, $30
	sVol		$05
	sNote		nAs4
	sVol		-$05
	sNote		nA4
	sNote		nG4, $60

	sNote		nRst, $360

	sNote		nD5, $60
	sNote		nC5
	sNote		nAs4
	sNote		nD5, $18
	sNote		nA4
	sNote		nAs4
	sNote		nC5
	sNote		nD5, $60
	sNote		nC5
	sNote		nAs4
	sNote		nA4, $18
	sNote		nFs4
	sNote		nG4
	sNote		nA4
	sVol		$05
	sNote		nG4, $30
	sNote		nA4
	sNote		nAs4, $60
	sNote		nDs4, $30
	sNote		nA4
	sNote		nG4, $60
	sNote		nAs5, $30
	sNote		nC6
	sNote		nAs5
	sNote		nGs5
	sNote		nFs5, $60
	sNote		nGs5
	sNote		nAs5, $C0

	sVol		$01
	sCall		$02, Dracula_Loop0B
	sNote		nF4, $12C
	sNote		nRst, $54
	sVol		-$01
	sJump		Dracula_Jump02

Dracula_Loop0B:
	sNote		nAs4, $60
	sNote		nGs4
	sNote		nFs4
	sNote		nDs4, $30
	sNote		nF4
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Dracula_PSG1:
	sVolEnv		v06
	sVibratoSet	PSG1
	sFrac		$0C00
	sVol		$28
	sNote		nB1, $C0
	sVol		$10
	sNote		nA1, $60
	sVol		-$10
	sNote		nG1, $30
	sNote		nA1
	sNote		nB1, $60
	sVol		$20
	sNote		nA1, $18
	sVol		-$20
	sNote		$18
	sNote		nB1
	sNote		nCs2
	sNote		nD2, $30
	sNote		nC2, $18
	sNote		nD2
	sNote		nF2, $30
	sNote		nDs2
	sNote		nD2, $120
	sNote		nCut, $60

Dracula_Jump06:
	sNote		nCut, $120
	sVol		$10
	sNote		nC1, $24
	sNote		nD1, $06
	sNote		nC1
	sNote		nB0, $30
	sNote		nCut, $120
	sNote		nC1, $24
	sNote		nD1, $06
	sNote		nC1
	sNote		nB0, $18
	sVol		-$08
	sNote		nDs1, $06
	sNote		nF1
	sNote		nG1
	sNote		nA1, $08
	sNote		nG1, $22
	sNote		nA1, $06
	sNote		nAs1
	sNote		nG1, $10
	sNote		nF1
	sNote		nDs1
	sNote		nF1, $24
	sNote		nG1, $06
	sNote		nA1
	sNote		nAs1, $18
	sNote		nGs1
	sNote		nG1, $10
	sNote		nF1
	sNote		nDs1
	sNote		nA1
	sNote		nG1
	sNote		nF1
	sNote		nD1, $60
	sNote		nDs1, $10
	sNote		nF1
	sNote		nG1
	sNote		nFs1
	sNote		nG1
	sNote		nA1
	sNote		nAs1
	sNote		nA1
	sNote		nG1, $40
	sNote		$10
	sNote		nA1
	sNote		nAs1
	sNote		nA1
	sNote		nE1
	sNote		nA1
	sNote		nG1, $54
	sNote		nFs1, $06
	sNote		nE1
	sNote		nFs1, $60
	sVol		-$08
	sNote		nD2, $24
	sNote		nAs1, $06
	sNote		nC2
	sNote		nD2, $10
	sNote		nC2
	sNote		nAs1
	sNote		nC2, $18
	sNote		nF1
	sNote		nF2, $24
	sNote		nDs2, $06
	sNote		nD2
	sNote		nDs2, $22
	sNote		nCut, $02
	sNote		nC2, $06
	sNote		nD2
	sNote		nDs2, $22
	sNote		nCut, $02
	sNote		nD2, $06
	sNote		nC2
	sNote		nD2, $18
	sNote		nA1
	sNote		nAs1
	sNote		nC2
	sNote		nD2, $24
	sNote		nAs1, $06
	sNote		nC2
	sNote		nD2, $10
	sNote		nC2
	sNote		nAs1
	sNote		nC2, $18
	sNote		nF1
	sNote		nF2, $24
	sNote		nDs2, $06
	sNote		nD2
	sNote		nDs2, $24
	sNote		nC2, $06
	sNote		nD2
	sNote		nDs2, $22
	sNote		nCut, $02
	sNote		nD2, $06
	sNote		nC2
	sNote		nD2, $60
	sVol		-$10
	sNote		nDs1, $10
	sNote		nF1
	sNote		nG1
	sNote		nF1
	sNote		nC1
	sNote		nF1
	sNote		nD1, $60
	sNote		nG1, $10
	sNote		nA1
	sNote		nAs1
	sNote		nA1
	sNote		nF1
	sNote		nD1
	sNote		nG1, $60
	sNote		nAs1, $10
	sNote		nC2
	sNote		nCs2
	sNote		nC2
	sNote		nGs1
	sNote		nF1
	sNote		nAs1
	sNote		nC2
	sNote		nCs2
	sNote		nF2
	sNote		nDs2
	sNote		nC2
	sNote		nCs2, $24
	sNote		nAs1, $06
	sNote		nC2
	sNote		nCs2, $30
	sNote		nDs2, $24
	sNote		nC2, $06
	sNote		nCs2
	sNote		nDs2, $30
	sNote		nAs1, $C0
	sNote		nCut, $18
	sVol		$10
	sNote		nAs1, $0C
	sNote		nCut
	sVol		$18
	sNote		nAs1
	sNote		nCut
	sVol		$20
	sNote		nAs1
	sNote		nCut, $2C4
	sVol		-$38
	sNote		nFs1, $08
	sNote		nCut, $1C
	sVol		$10
	sNote		nF1, $08
	sNote		nCut, $0A
	sNote		nF1, $08
	sNote		nCut, $0A
	sNote		nC1, $18
	sNote		nCs1, $08
	sNote		nCut, $1C
	sVol		-$10
	sNote		nDs1, $08
	sNote		nCut, $0A
	sNote		nC1, $08
	sNote		nCut, $0A
	sNote		nF2, $18
	sNote		nFs2, $08
	sNote		nCut, $1C
	sNote		nAs2, $08
	sNote		nCut, $0A
	sNote		nA2, $08
	sNote		nCut, $0A
	sNote		nF2, $08
	sNote		nCut, $58
	sJump		Dracula_Jump06

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Dracula_PSG2:
;	sVibratoSet	PSG1
	sFrac		$0C00
	sVol		$30
	sNote		nG1, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $0A
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $06
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $11
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $12
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $0A
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $0E
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $05
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $18
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $1C
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $06
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $07
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $0E
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $04
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $07
	sNote		sHold, $0F
	sFrac		-$0010		; ssDetune $06
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FB
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FA
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $F9
	sNote		sHold, $0C
	sFrac		$000F		; ssDetune $FA
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FB
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $FC
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $0B
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$003C		; ssDetune $F8
	sNote		sHold, $01		; !!! This is where the fail happens

	sFrac		-$000F		; ssDetune -$09
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune -$0A
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune -$0B
	sNote		sHold, $01
	sFrac		-$002D		; ssDetune -$0E
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune -$0F
	sNote		sHold, $01
	sFrac		-$002D		; ssDetune -$12
	sNote		sHold, $01
	sFrac		-$000E		; ssDetune -$13
	sNote		sHold, $01
	sFrac		-$002B		; ssDetune -$16
	sNote		sHold, $01

	sFrac		-$000E		; ssDetune -$17
	sNote		sHold, $01
	sFrac		-$001C		; ssDetune -$19
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune -$1A
	sNote		sHold, $01
	sFrac		-$000E		; ssDetune -$1B
	sNote		sHold, $02
	sFrac		-$000E		; ssDetune -$1C
	sNote		sHold, $07
	sFrac		$000E		; ssDetune -$1B
	sNote		sHold, $05
	sFrac		$000E		; ssDetune -$1A
	sNote		sHold, $04
	sFrac		$000F		; ssDetune -$19
	sNote		sHold, $1C
	sFrac		-$000F		; ssDetune -$1A
	sNote		sHold, $04
	sFrac		-$000E		; ssDetune -$1B
	sNote		sHold, $0E
	sFrac		$000E		; ssDetune -$1A
	sNote		sHold, $02
	sFrac		$000F		; ssDetune -$19
	sNote		sHold, $02
	sFrac		$000E		; ssDetune -$18
	sNote		sHold, $02
	sFrac		$000E		; ssDetune -$17
	sNote		sHold, $03
	sFrac		$000E		; ssDetune -$16
	sNote		sHold, $01

	sFrac		$0000		; ssDetune -$16
	sNote		sHold, $01
	sFrac		$000F		; ssDetune -$15
	sNote		sHold, $03
	sFrac		$000E		; ssDetune -$14
	sNote		sHold, $04
	sFrac		$000E		; ssDetune -$13
	sNote		sHold, $05
	sFrac		$000E		; ssDetune -$12
	sNote		sHold, $05
	sFrac		$000E		; ssDetune -$11
	sNote		sHold, $14
	sFrac		-$000E		; ssDetune -$12
	sNote		sHold, $05
	sFrac		-$000E		; ssDetune -$13
	sNote		sHold, $06
	sFrac		-$000E		; ssDetune -$14
	sNote		sHold, $05
	sFrac		-$000E		; ssDetune -$15
	sNote		sHold, $20
	sFrac		$000E		; ssDetune -$14
	sNote		sHold, $02
	sFrac		$000E		; ssDetune -$13
	sNote		sHold, $03
	sFrac		$000E		; ssDetune -$12
	sNote		sHold, $02
	sFrac		$000E		; ssDetune -$11
	sNote		sHold, $02
	sFrac		$0010		; ssDetune -$10
	sNote		sHold, $03
	sFrac		$000F		; ssDetune -$0F
	sNote		sHold, $06
	sFrac		$000F		; ssDetune -$0E
	sNote		sHold, $12
	sFrac		-$000F		; ssDetune -$0F
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune -$10
	sNote		sHold, $0A
	sFrac		-$0010		; ssDetune -$11
	sNote		sHold, $0A
	sFrac		-$000E		; ssDetune -$12
	sNote		sHold, $0C
	sFrac		$000E		; ssDetune -$11
	sNote		sHold, $02
	sFrac		$0010		; ssDetune -$10
	sNote		sHold, $06
	sFrac		$000F		; ssDetune -$0F
	sNote		sHold, $04
	sFrac		$000F		; ssDetune -$0E
	sNote		sHold, $04
	sFrac		$000F		; ssDetune -$0D
	sNote		sHold, $03
	sFrac		$000F		; ssDetune -$0C
	sNote		sHold, $03
	sFrac		$000F		; ssDetune -$0B
	sNote		sHold, $05
	sFrac		$000F		; ssDetune -$0A
	sNote		sHold, $05
	sFrac		$000F		; ssDetune -$09
	sNote		sHold, $04
	sFrac		$000F		; ssDetune -$08
	sNote		sHold, $07
	sFrac		$000F		; ssDetune -$07
	sNote		sHold, $0F
	sFrac		-$000F		; ssDetune -$08
	sNote		sHold, $2E
	sFrac		$000F		; ssDetune -$07
	sNote		sHold, $03

	sFrac		-$000F		; ssDetune $F8
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $F9
	sNote		sHold, $05
	sFrac		$000F		; ssDetune $FA
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FB
	sNote		sHold, $04
	sFrac		$000F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $04
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $06
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $08
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $0F
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $05
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $07
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $0D
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $05
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $07
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $08
	sNote		sHold, $05

	sFrac		$0000		; ssDetune $08
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $09
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $0A
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $0B
	sNote		sHold, $12
	sFrac		-$0010		; ssDetune $0A
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $09
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $08
	sNote		sHold, $02

	sFrac		$0000		; ssDetune $08
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $07
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $06
	sNote		sHold, $09
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $09
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $07
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $08
	sNote		sHold, $03


	sFrac		$0000		; ssDetune $08
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $09
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $0A
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $0B
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $0C
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $0D
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $0E
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $0F
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $10
	sNote		sHold, $05
	sFrac		$0011		; ssDetune $11
	sNote		sHold, $03
	sFrac		$0011		; ssDetune $12
	sNote		sHold, $06
	sFrac		$0011		; ssDetune $13
	sNote		sHold, $16
	sFrac		-$0011		; ssDetune $12
	sNote		sHold, $04
	sFrac		-$0011		; ssDetune $11
	sNote		sHold, $06
	sFrac		-$0011		; ssDetune $10
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $0F
	sNote		sHold, $09
	sFrac		-$0010		; ssDetune $0E
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $0D
	sNote		sHold, $22
	sFrac		$0010		; ssDetune $0E
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $0F
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $10
	sNote		sHold, $05
	sFrac		$0011		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $12
	sNote		sHold, $05
	sFrac		$0011		; ssDetune $13
	sNote		sHold, $02
	sFrac		$0011		; ssDetune $14
	sNote		sHold, $03
	sFrac		$0011		; ssDetune $15
	sNote		sHold, $04
	sFrac		$0011		; ssDetune $16
	sNote		sHold, $03
	sFrac		$0011		; ssDetune $17
	sNote		sHold, $02
	sFrac		$0011		; ssDetune $18
	sNote		sHold, $03
	sFrac		$0011		; ssDetune $19
	sNote		sHold, $03

	sFrac		-$0011		; ssDetune $18
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $19
	sNote		sHold, $03
	sFrac		$0011		; ssDetune $1A
	sNote		sHold, $02
	sFrac		$0011		; ssDetune $1B
	sNote		sHold, $05
	sFrac		$0011		; ssDetune $1C
	sNote		sHold, $02
	sFrac		$0011		; ssDetune $1D
	sNote		sHold, $04
	sFrac		$0011		; ssDetune $1E
	sNote		sHold, $04
	sFrac		$0012		; ssDetune $1F
	sNote		sHold, $03
	sFrac		$0011		; ssDetune $20
	sNote		sHold, $05
	sFrac		$0011		; ssDetune $21
	sNote		sHold, $0B
	sFrac		-$0011		; ssDetune $20
	sNote		sHold, $05
	sFrac		-$0011		; ssDetune $1F
	sNote		sHold, $03
	sFrac		-$0012		; ssDetune $1E
	sNote		sHold, $02
	sFrac		-$0011		; ssDetune $1D
	sNote		sHold, $03
	sFrac		-$0011		; ssDetune $1C
	sNote		sHold, $02
	sFrac		-$01CC		; ssDetune $00

Dracula_Jump05:
	sNote		nCut, $5A0
	sVolEnv		v03
	sVol		-$08
	sCall		$06, Dracula_Loop59
	sNote		nD3
	sNote		nA2
	sNote		nG2
	sNote		nFs2
	sNote		nD2
	sNote		nA1
	sNote		nG1
	sNote		nFs1
	sVol		$10
	sNote		nD3
	sNote		nA2
	sNote		nG2
	sNote		nFs2
	sNote		nD2
	sNote		nA1
	sNote		nG1
	sNote		nFs1
	sVol		$18
	sNote		nD3
	sNote		nA2
	sNote		nG2
	sNote		nFs2
	sNote		nD2
	sNote		nA1
	sNote		nG1
	sNote		nFs1

	sNote		nCut, $330
	sVol		-$28
	sCall		$02, Dracula_Loop5B

	sNote		nD3
	sNote		nAs2
	sNote		nA2
	sNote		nG2
	sNote		nD2
	sNote		nAs1
	sNote		nG1

	sVol		-$20
	sNote		nCut, $36
	sCall		$02, Dracula_Loop5C

	sNote		nG3
	sNote		nD3
	sNote		nC3
	sNote		nAs2
	sNote		nG2
	sNote		nD2
	sNote		nAs1
	sNote		nCut, $F6

	sVol		-$28
	sNote		nGs1, $30
	sNote		nAs1, $C0

	sVolEnv		Null
	sVol		$10
	sNote		nG1, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $0A
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $06
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $11
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $12
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $0A
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $0E
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $05
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $18
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $1C
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $06
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $07
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $0E
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $04
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $07
	sNote		sHold, $0F
	sFrac		-$0010		; ssDetune $06
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FB
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FA
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $F9
	sNote		sHold, $0C
	sFrac		$000F		; ssDetune $FA
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FB
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $FC
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $0B
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $0B
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $06
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $11
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $12
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $0A
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $0E
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $04
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $05
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $18
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $1C
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $01
	sNote		sHold, $05
	sFrac		-$0010		; ssDetune $00
	sNote		sHold, $06
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $07
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $0E
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $03
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $05
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $04
	sFrac		$0010		; ssDetune $07
	sNote		sHold, $0F
	sFrac		-$0010		; ssDetune $06
	sNote		sHold, $04
	sFrac		-$0010		; ssDetune $05
	sNote		sHold, $03
	sFrac		-$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $03
	sNote		sHold, $01
	sFrac		-$0010		; ssDetune $02
	sNote		sHold, $02
	sFrac		-$0020		; ssDetune $00
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FD
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FC
	sNote		sHold, $01
	sFrac		-$000F		; ssDetune $FB
	sNote		sHold, $03
	sFrac		-$000F		; ssDetune $FA
	sNote		sHold, $02
	sFrac		-$000F		; ssDetune $F9
	sNote		sHold, $0B
	sFrac		$000F		; ssDetune $FA
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FB
	sNote		sHold, $04
	sFrac		$000F		; ssDetune $FC
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FD
	sNote		sHold, $02
	sFrac		$000F		; ssDetune $FE
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $FF
	sNote		sHold, $01
	sFrac		$000F		; ssDetune $00
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $01
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $02
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $03
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $04
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $05
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $06
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $07
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $08
	sNote		sHold, $02
	sFrac		-$00F8		; ssDetune $F8

	sNote		sHold, $02
	sFrac		$0108		; ssDetune $09
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $0A
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $0C
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $0D
	sNote		sHold, $03
	sFrac		$0010		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$0010		; ssDetune $0F
	sNote		sHold, $02
	sFrac		$0010		; ssDetune $10
	sNote		sHold, $02
	sFrac		$0011		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $12
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $13
	sNote		sHold, $02
	sFrac		$0022		; ssDetune $15
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $16
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $17
	sNote		sHold, $02
	sFrac		$0011		; ssDetune $18
	sNote		sHold, $01

	sFrac		$0011		; ssDetune $19
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $1A
	sNote		sHold, $01
	sFrac		$0011		; ssDetune $1B
	sNote		sHold, $01
	sFrac		-$01BB		; ssDetune $00

	sNote		nCut, $180
	sJump		Dracula_Jump05

Dracula_Loop59:
	sNote		nD3, $06
	sNote		nCut
	sVol		$28
	sNote		nD3
	sNote		nCut
	sVol		-$28
	sRet

Dracula_Loop5B:
	sNote		nD3, $06
	sNote		nAs2
	sNote		nA2
	sNote		nG2
	sNote		nD2
	sNote		nAs1
	sNote		nG1
	sNote		nCut
	sVol		$10
	sRet

Dracula_Loop5C:
	sNote		nG3, $06
	sNote		nD3
	sNote		nC3
	sNote		nAs2
	sNote		nG2
	sNote		nD2
	sNote		nAs1
	sNote		nCut
	sVol		$10
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG3 data
; ---------------------------------------------------------------------------

Dracula_PSG3:
	sVol		$7F

.loop
	sNote		nHiHat, $100
	sJump		.loop

Dracula_PSG4:
	sVol		$30
	sVolEnv		v02
	sCall		$03, Dracula_Loop35
	sCall		$01, Dracula_PSG3_Call456
	sCall		$02, Dracula_PSG3_Call4
	sNote		nCut
	sVol		-$20
	sNote		nWhitePSG3
	sVol		$50
	sNote		nWhitePSG3
	sVol		-$30
	sNote		nWhitePSG3
	sNote		nWhitePSG3
	sNote		nCut

	sVol		-$10
	sVolEnv		v01
	sNote		nWhitePSG3

	sVolEnv		v02
	sVol		$10
	sNote		nWhitePSG3
	sVol		$30
	sNote		nWhitePSG3
	sVol		-$30
	sNote		nWhitePSG3
	sNote		nCut
	sVol		-$10
	sNote		nWhitePSG3
	sVol		$40
	sCall		$01, Dracula_PSG3_Call2

	sNote		nWhitePSG3
	sVol		-$50
	sNote		nWhitePSG3
	sVol		$40
	sNote		nWhitePSG3
	sVol		$20
	sNote		nWhitePSG3
	sVol		-$30
	sNote		nWhitePSG3
	sNote		nCut
	sVol		-$20
	sCall		$01, Dracula_PSG3_Call1

	sNote		nWhitePSG3
	sNote		nCut
	sNote		nWhitePSG3
	sNote		nWhitePSG3
	sNote		nCut
	sVol		-$10
	sNote		nWhitePSG3
	sVol		$40
	sNote		nWhitePSG3
	sVol		-$20
	sNote		nWhitePSG3
	sVol		$40
	sNote		nWhitePSG3
	sVol		-$20
	sNote		nWhitePSG3
	sVol		$40
	sNote		nWhitePSG3
	sVol		-$30
	sNote		nWhitePSG3
	sNote		nCut
	sNote		nWhitePSG3
	sNote		nCut

	sVol		-$20
	sCall		$03, Dracula_Loop3A

	sNote		nWhitePSG3
	sNote		nCut
	sNote		nWhitePSG3
	sNote		nWhitePSG3
	sNote		nCut
	sVol		-$20

Dracula_Jump04:
	sNote		nCut, $18
	sNote		nWhitePSG3

	sCall		$0D, Dracula_Loop3D
	sVolEnv		v01
	sVol		$10
	sNote		$0C
	sNote		$18
	sNote		$0C

	sVolEnv		v02
	sVol		-$10
	sNote		$0C
	sVol		$20
	sNote		$24
	sVol		-$20

	sCall		$08, Dracula_Loop3E
	sNote		nWhitePSG3
	sVol		$20
	sNote		nWhitePSG3
	sVol		-$20
	sNote		nWhitePSG3
	sVol		$20
	sNote		nWhitePSG3

	sVolEnv		v01
	sVol		-$20
	sNote		$18

	sVolEnv		v02
	sVol		$10
	sNote		$0C

	sVolEnv		v01
	sVol		-$10
	sNote		$6C

	sVolEnv		v02
	sVol		$10
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$0C
	sVol		$20
	sNote		$0C
	sVol		-$20
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$18
	sVol		$10
	sNote		$18
	sNote		$18

	sVolEnv		v01
	sNote		$0C
	sNote		$24
	sNote		$0C
	sVol		$10
	sNote		$24

	sVolEnv		v02
	sCall		$02, Dracula_Loop3F
	sVol		-$20
	sCall		$05, Dracula_Loop40

	sVolEnv		v01
	sNote		$60

	sVolEnv		v09
	sVol		-$10
	sNote		$0C

	sVolEnv		v02
	sVol		$20

	sCall		$01, Dracula_PSG3_Call3
	sCall		$01, Dracula_PSG3_Call3
	sCall		$01, Dracula_PSG3_Call3
	sCall		$01, Dracula_PSG3_Call2
	sNote		nWhitePSG3

	sVolEnv		v01
	sVol		-$10
	sNote		$30

	sVolEnv		v09
	sVol		-$10
	sNote		$0C

	sVolEnv		v02
	sVol		$20

	sCall		$01, Dracula_PSG3_Call3
	sCall		$01, Dracula_PSG3_Call2
	sNote		$24
	sVol		-$10
	sNote		$0C
	sVol		$10
	sNote		nWhitePSG3
	sCall		$01, Dracula_PSG3_Call1
	sCall		$01, Dracula_PSG3_Call3
	sCall		$01, Dracula_PSG3_Call2
	sNote		$3C

	sVol		-$20
	sVolEnv		v09
	sNote		$0C

	sVolEnv		v02
	sVol		$20
	sCall		$01, Dracula_PSG3_Call3
	sCall		$03, Dracula_PSG3_Call2

	sNote		nWhitePSG3
	sVol		-$10
	sCall		$03, Dracula_Loop40
	sNote		nWhitePSG3
	sVol		$10
	sNote		nWhitePSG3
	sCall		$01, Dracula_PSG3_Call1
	sCall		$02, Dracula_PSG3_Call2
	sNote		$24

	sVol		-$20
	sVolEnv		v09
	sNote		$0C

	sVolEnv		v02
	sVol		$20
	sCall		$01, Dracula_PSG3_Call2
	sNote		nWhitePSG3
	sVol		-$10
	sNote		nWhitePSG3

	sVolEnv		v01
	sNote		nWhitePSG3

	sVolEnv		v02
	sNote		nWhitePSG3
	sVol		$10
	sNote		nWhitePSG3
	sCall		$01, Dracula_PSG3_Call1
	sCall		$01, Dracula_PSG3_Call3

	sNote		nWhitePSG3
	sVol		-$10
	sCall		$05, Dracula_Loop40
	sVolEnv		v01
	sNote		$30
	sVol		$10
	sCall		$07, Dracula_Loop4C

	sVolEnv		v02
	sCall		$03, Dracula_Loop35
	sCall		$01, Dracula_PSG3_Call456
	sCall		$01, Dracula_PSG3_Call456
	sCall		$01, Dracula_PSG3_Call456
	sCall		$02, Dracula_PSG3_Call4

	sNote		nCut
	sVol		-$10
	sNote		nWhitePSG3, $06
	sVol		$20
	sNote		nWhitePSG3
	sVol		-$10
	sNote		nWhitePSG3
	sVol		$10
	sNote		$1E
	sVol		-$20
	sNote		$0C

	sVolEnv		v01
	sVol		-$10
	sNote		$12
	sNote		$42

	sVolEnv		v02
	sVol		$10
	sNote		$0C

	sVolEnv		v01
	sNote		$12
	sNote		$12
	sNote		$0C
	sVol		$10
	sNote		$18
	sNote		$18
	sVol		-$10
	sNote		$12
	sNote		$72

	sVolEnv		v02
	sVol		-$10
	sJump		Dracula_Jump04

Dracula_Loop3A:
	sCall		$01, Dracula_PSG3_Call1
	sCall		$02, Dracula_PSG3_Call6
	sNote		nCut
	sJump		Dracula_PSG3_Call1

Dracula_PSG3_Call2:
	sNote		nWhitePSG3, $0C
	sVol		-$10
	sNote		nWhitePSG3
	sVol		$10
	sRet

Dracula_PSG3_Call3:
	sCall		$03, Dracula_PSG3_Call2
	sNote		nWhitePSG3

Dracula_PSG3_Call1:
	sVol		-$20
	sVolEnv		v09
	sNote		nWhitePSG3, $0C

	sVolEnv		v02
	sVol		$20
	sRet

Dracula_PSG3_Call4:
	sNote		nCut, $0C
	sNote		nWhitePSG3
	sNote		nWhitePSG3
	sRet

Dracula_PSG3_Call5:
	sNote		nCut, $0C
	sNote		nWhitePSG3
	sRet

Dracula_PSG3_Call456:
	sCall		$02, Dracula_PSG3_Call4
	sCall		$02, Dracula_PSG3_Call5
	sCall		$02, Dracula_PSG3_Call6
	sRet

Dracula_PSG3_Call6:
	sNote		nWhitePSG3
	sNote		nCut
	sNote		nWhitePSG3
	sRet

Dracula_Loop35:
	sNote		nWhitePSG3, $0C
	sNote		nCut
	sNote		nWhitePSG3
	sRet

Dracula_Loop3D:
	sNote		nWhitePSG3
	sVol		$40
	sNote		nWhitePSG3
	sVol		-$40
	sRet

Dracula_Loop3E:
	sNote		nWhitePSG3, $0C
	sVol		$40
	sNote		nWhitePSG3
	sVol		-$40
	sRet

Dracula_Loop3F:
	sVol		-$20
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$18
	sNote		$0C
	sVol		$20
	sNote		$0C
	sRet

Dracula_Loop40:
	sNote		nWhitePSG3
	sVol		$10
	sNote		nWhitePSG3
	sVol		-$10
	sRet

Dracula_Loop4C:
	sNote		$18
	sRet

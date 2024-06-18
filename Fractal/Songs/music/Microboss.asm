; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Microboss_Voice
	sHeaderSamples	Microboss_Samples
	sHeaderVibrato	Microboss_Vib
	sHeaderEnvelope	Microboss_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$92
	sChannel	DAC1, Microboss_DAC1
	sChannel	FM1, Microboss_FM1
	sChannel	FM2, Microboss_FM3
	sChannel	FM3, Microboss_FM2
	sChannel	FM4, Microboss_FM4
	sChannel	FM5, Microboss_FM5
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Microboss_Voice:
	sNewVoice	v00
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$03, $00, $00, $00
	sMultiple	$08, $00, $02, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1B, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0F, $0F, $0F
	sDecay1Level	$02, $02, $02, $00
	sDecay2Rate	$08, $08, $08, $08
	sReleaseRate	$07, $07, $07, $07
	sTotalLevel	$20, $10, $28, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$04
	sFeedback	$05
	sDetune		$05, $03, $05, $03
	sMultiple	$01, $00, $01, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$09, $0F, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $06, $00, $00
	sDecay1Level	$08, $01, $00, $00
	sDecay2Rate	$08, $04, $00, $00
	sReleaseRate	$07, $07, $07, $07
	sTotalLevel	$0A, $00, $00, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$03, $05, $03, $05
	sMultiple	$01, $00, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0F, $0F, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $00, $00, $03
	sDecay1Level	$00, $01, $00, $00
	sDecay2Rate	$00, $00, $00, $00
	sReleaseRate	$07, $07, $07, $07
	sTotalLevel	$1C, $1C, $00, $00
	sFinishVoice

	sNewVoice	v03
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $0E
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $13
	sDecay1Level	$00, $00, $00, $05
	sDecay2Rate	$00, $00, $00, $0C
	sReleaseRate	$00, $00, $00, $0A
	sTotalLevel	$00, $00, $00, $00
	sFinishVoice

	sNewVoice	v04
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$06, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $00, $00, $00
	sDecay1Level	$0F, $00, $00, $00
	sDecay2Rate	$1F, $00, $00, $00
	sReleaseRate	$0F, $05, $05, $05
	sTotalLevel	$00, $06, $06, $06
	sFinishVoice

	sNewVoice	v05
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$00, $00, $00, $00
	sMultiple	$01, $00, $01, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1B, $1F, $1B
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $10, $00, $00
	sDecay1Level	$00, $0F, $00, $00
	sDecay2Rate	$00, $18, $00, $00
	sReleaseRate	$05, $0F, $06, $05
	sTotalLevel	$00, $00, $00, $00
	sFinishVoice

	sNewVoice	v06
	sAlgorithm	$05
	sFeedback	$05
	sDetune		$00, $00, $00, $00
	sMultiple	$00, $00, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$19, $19, $19, $19
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$19, $00, $00, $00
	sDecay1Level	$0F, $00, $00, $00
	sDecay2Rate	$1F, $00, $00, $00
	sReleaseRate	$0F, $05, $05, $05
	sTotalLevel	$00, $09, $09, $09
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Microboss_Samples:
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

	sNewSample	HatCLD
	sSampFreq	$0100
	sSampStart	dsHatCLD, deHatCLD
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

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Microboss_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Microboss_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Microboss_FM1:
	sVol		$13
	sFrac		$0100

Microboss_FM1_00:
	sVoice		v02
	sCall		$01, Microboss_Call1
	sCall		$01, Microboss_Call1
	sCall		$01, Microboss_Call1
	sCall		$01, Microboss_Call1
	sVoice		v01
	sCall		$01, Microboss_Call2
	sCall		$01, Microboss_Call3
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		$0100
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		-$0100
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		$0100
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		-$0100
	sCall		$01, Microboss_Call5
	sJump		Microboss_FM1_00

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Microboss_FM2:
	sVol		$0B
	sFrac		$0100

Microboss_Jump1:
	sVoice		v00
	sCall		$04, Microboss_Call6
	sCall		$04, Microboss_Call7
	sCall		$04, Microboss_Call6
	sCall		$04, Microboss_Call7
	sCall		$04, Microboss_Call6
	sCall		$04, Microboss_Call7
	sCall		$04, Microboss_Call6
	sCall		$04, Microboss_Call7
	sCall		$01, Microboss_Call8
	sCall		$01, Microboss_Call9
	sCall		$01, Microboss_Call10
	sCall		$01, Microboss_Call10
	sFrac		$0100
	sCall		$01, Microboss_Call10
	sCall		$01, Microboss_Call10
	sFrac		-$0100
	sCall		$01, Microboss_Call10
	sCall		$01, Microboss_Call10
	sFrac		$0100
	sCall		$01, Microboss_Call10
	sCall		$01, Microboss_Call10
	sFrac		-$0100
	sCall		$01, Microboss_Call11
	sJump		Microboss_Jump1

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Microboss_FM3:
	sVol		$13
	sFrac		$0100

Microboss_FM3_00:
	sVoice		v02
	sCall		$01, Microboss_Call12
	sCall		$01, Microboss_Call13
	sCall		$01, Microboss_Call13
	sVoice		v01
	sCall		$01, Microboss_Call14
	sCall		$01, Microboss_Call15
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		$0100
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		-$0100
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		$0100
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		-$0100
	sCall		$01, Microboss_Call17
	sJump		Microboss_FM3_00

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Microboss_FM4:
	sNote		nRst, $06
	sVol		$19
	sFrac		$0100
	sFrac		$0013		; ssDetune $04
	sPan		left

Microboss_Jump2:
	sVoice		v02
	sCall		$01, Microboss_Call1
	sCall		$01, Microboss_Call1
	sCall		$01, Microboss_Call1
	sCall		$01, Microboss_Call1
	sVoice		v01
	sCall		$01, Microboss_Call2
	sCall		$01, Microboss_Call3
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		$0100
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		-$0100
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		$0100
	sCall		$01, Microboss_Call4
	sCall		$01, Microboss_Call4
	sFrac		-$0100
	sCall		$01, Microboss_Call5
	sJump		Microboss_Jump2

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Microboss_FM5:
	sNote		nRst, $06
	sFrac		$0013		; ssDetune $04
	sVol		$1C
	sFrac		$0100
	sPan		right

Microboss_Jump3:
	sVoice		v02
	sCall		$01, Microboss_Call12
	sCall		$01, Microboss_Call13
	sCall		$01, Microboss_Call13
	sVoice		v01
	sCall		$01, Microboss_Call14
	sCall		$01, Microboss_Call15
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		$0100
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		-$0100
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		$0100
	sCall		$01, Microboss_Call16
	sCall		$01, Microboss_Call16
	sFrac		-$0100
	sCall		$01, Microboss_Call17
	sJump		Microboss_Jump3

; ===========================================================================
; ---------------------------------------------------------------------------
; FM shared data
; ---------------------------------------------------------------------------

Microboss_Call6:
	sNote		nB2, $05
	sNote		nRst, $01
	sNote		nC3, $05
	sNote		nRst, $01
	sRet

Microboss_Call7:
	sNote		nCs3, $05
	sNote		nRst, $01
	sNote		nD3, $05
	sNote		nRst, $01
	sRet

Microboss_Call1:
	sNote		nFs4, $17
	sNote		nRst, $01
	sNote		nF4, $17
	sNote		nRst, $01
	sNote		nE4, $17
	sNote		nRst, $01
	sNote		nDs4, $17
	sNote		nRst, $01
	sRet

Microboss_Call13:
	sNote		nAs4, $17
	sNote		nRst, $01
	sNote		nA4, $17
	sNote		nRst, $01
	sNote		nGs4, $17
	sNote		nRst, $01
	sNote		nG4, $17
	sNote		nRst, $01
	sRet

Microboss_Call12:
	sNote		nRst, $90

	sVol		$04
	sNote		nRst, $18
	sNote		nFs4, $05
	sNote		nRst, $01
	sNote		nG4, $05
	sNote		nRst, $01
	sNote		nGs4, $05
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call8:
	sVol		$04
	sCall		$1C, .loop
	sVol		-$04
	sRet

.loop
	sNote		nB2, $05
	sNote		nRst, $01
	sNote		nB3, $05
	sNote		nRst, $01
	sRet

Microboss_Call2:
	sVol		$04
	sNote		nB3, $23
	sNote		nRst, $01
	sNote		nB3, $05
	sNote		nRst, $01
	sNote		nC4, $29
	sNote		nRst, $01
	sNote		nC4, $02
	sNote		nRst, $01
	sNote		nD4, $02
	sNote		nRst, $01
	sNote		nC4, $05
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call14:
	sVol		$04
	sNote		nE4, $23
	sNote		nRst, $01
	sNote		nE4, $05
	sNote		nRst, $01
	sNote		nF4, $29
	sNote		nRst, $01
	sNote		nF4, $02
	sNote		nRst, $01
	sNote		nG4, $02
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call3:
	sVol		$04
	sNote		nB3, $23
	sNote		nRst, $01
	sNote		nB3, $05
	sNote		nRst, $01
	sNote		nC4, $29
	sNote		nRst, $01
	sNote		nC4, $05
	sNote		nRst, $01
	sNote		nD4, $29
	sNote		nRst, $01
	sNote		nD4, $05
	sNote		nRst, $01
	sNote		nDs4, $29
	sNote		nRst, $01
	sNote		nDs4, $05
	sNote		nRst, $01
	sNote		nE4, $59
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call15:
	sVol		$04
	sNote		nE4, $23
	sNote		nRst, $01
	sNote		nE4, $05
	sNote		nRst, $01
	sNote		nF4, $29
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sNote		nG4, $29
	sNote		nRst, $01
	sNote		nG4, $05
	sNote		nRst, $01
	sNote		nGs4, $29
	sNote		nRst, $01
	sNote		nGs4, $05
	sNote		nRst, $01
	sNote		nA4, $59
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call9:
	sVol		$04
	sCall		$02, .loop
	sVol		-$04
	sRet

.loop
	sNote		nB2, $05
	sNote		nRst, $01
	sNote		nB3, $05
	sNote		nRst, $07
	sRet

Microboss_Call4:
	sVol		$04
	sNote		nFs4, $05
	sNote		nRst, $01
	sNote		nE4, $05
	sNote		nRst, $01
	sNote		nF4, $05
	sNote		nRst, $01
	sNote		nDs4, $05
	sNote		nRst, $01
	sNote		nE4, $05
	sNote		nRst, $01
	sNote		nB3, $11
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call16:
	sVol		$04
	sNote		nB4, $05
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $01
	sNote		nAs4, $05
	sNote		nRst, $01
	sNote		nGs4, $05
	sNote		nRst, $01
	sNote		nA4, $05
	sNote		nRst, $01
	sNote		nE4, $11
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call10:
	sVol		$04
	sNote		nFs3, $05
	sNote		nRst, $01
	sNote		nF3, $05
	sNote		nRst, $01
	sNote		nE3, $05
	sNote		nRst, $01
	sNote		nDs3, $05
	sNote		nRst, $01

	sCall		$04, Microboss_Loop1
	sVol		-$04
	sRet

Microboss_Loop1:
	sNote		nB2, $05
	sNote		nRst, $01
	sRet

Microboss_Call5:
	sVol		$04
;	ssPortamento	$01
	sNote		nB3, $30
	sNote		sHold, nB1, $2F
	sNote		nRst, $01
	sVol		-$04
	sRet

Microboss_Call17:
	sVol		$04
	sCall		$10, .loop
	sFrac		-$1000
	sVol		-$04
	sRet

.loop
	sNote		nE4, $02
	sNote		nRst, $01
	sNote		nB3, $02
	sNote		nRst, $01
	sFrac		$0100
	sRet

Microboss_Call11:
	sVol		$04
	sCall		$08, .loop
	sVol		-$04
	sRet

.loop
	sNote		nB1, $02
	sNote		nRst, $01
	sNote		nB2, $02
	sNote		nRst, $01
	sNote		nB3, $02
	sNote		nRst, $01
	sNote		nB4, $02
	sNote		nRst, $01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Microboss_DAC1:
	sVol		$04
	sPan		center

Microboss_DAC1_00:
	sSample		Kick
	sCall		$10, Microboss_DAC1_01
	sCall		$03, Microboss_Call19

	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$06
	sSample		Snare
	sNote		$03
	sNote		$03
	sNote		$06
	sNote		$06

	sCall		$0E, Microboss_Call20
	sCall		$01, Microboss_Call21
	sCall		$01, Microboss_Call21
	sCall		$01, Microboss_Call22
	sCall		$01, Microboss_Call22
	sCall		$01, Microboss_Call22
	sCall		$01, Microboss_Call23
	sCall		$01, Microboss_Call24
	sCall		$01, Microboss_Call24
	sCall		$01, Microboss_Call24
	sCall		$01, Microboss_Call25
	sCall		$01, Microboss_Call26
	sJump		Microboss_DAC1_00

Microboss_Call21:
	sSample		Kick
	sNote		$06
	sSample		Kick
	sNote		$06
	sPan		left
	sSample		Timpani
	sNote		$06
	sPan		center
	sRet

Microboss_Call22:
	sSample		Kick
	sNote		$06
	sPan		right
	sSample		MidTimpani
	sNote		$06
	sPan		center
	sSample		Snare
	sNote		$06
	sSample		LowTimpani
	sNote		$06
	sPan		left
	sSample		Timpani
	sNote		$06
	sPan		center
	sSample		Snare
	sNote		$06
	sSample		HatCLD
	sNote		$06
	sNote		$06
	sRet

Microboss_Call23:
	sSample		Kick
	sNote		$06
	sPan		right
	sSample		MidTimpani
	sNote		$06
	sPan		center
	sSample		Snare
	sNote		$06
	sSample		LowTimpani
	sNote		$06
	sPan		left
	sSample		Timpani
	sNote		$06
	sPan		center
	sSample		Snare
	sNote		$06
	sNote		$06
	sNote		$06
	sRet

Microboss_Call24:
	sSample		Kick
	sNote		$06
	sPan		right
	sSample		MidTimpani
	sNote		$03
	sNote		$03
	sPan		center
	sSample		Snare
	sNote		$03
	sNote		$03
	sSample		LowTimpani
	sNote		$03
	sNote		$03
	sPan		left
	sSample		Timpani
	sNote		$03
	sNote		$03
	sPan		center
	sSample		Snare
	sNote		$03
	sPan		right
	sSample		MidTimpani
	sNote		$03
	sPan		center
	sSample		LowTimpani
	sNote		$03
	sPan		left
	sSample		Timpani
	sNote		$03
	sPan		center
	sSample		Kick
	sNote		$06
	sRet

Microboss_Call25:
	sCall		$03, .loop
	sPan		center
	sSample		Snare
	sNote		$03
	sNote		$03
	sNote		$03
	sNote		$03
	sRet

.loop
	sSample		Snare
	sNote		$03
	sPan		right
	sSample		MidTimpani
	sNote		$03
	sPan		center
	sSample		LowTimpani
	sNote		$03
	sPan		left
	sSample		Timpani
	sNote		$03
	sPan		center
	sRet

Microboss_Call26:
	sCall		$03, .loop
	sSample		Kick
	sNote		$03
	sSample		Snare
	sNote		$03
	sSample		HatCLD
	sNote		$03

	sSample		Snare
	sCall		$05, .loop2
	sRet

.loop
	sSample		Kick
	sNote		$03
	sSample		Snare
	sNote		$03
	sSample		HatCLD
	sNote		$03
	sSample		Kick
	sNote		$03
	sSample		Snare
	sNote		$03
	sSample		HatCLD
	sNote		$03
	sNote		$03

.loop2
	sNote		$03
	sRet

Microboss_DAC1_01:
	sNote		nSample, $0C
	sRet

Microboss_Call19:
	sNote		$0C
	sSample		Snare
	sNote		$0C
	sSample		Kick
	sNote		$0C
	sNote		$0C
	sRet

Microboss_Call20:
	sSample		Kick
	sNote		$06
	sSample		HatCLD
	sNote		$06
	sSample		Snare
	sNote		$06
	sSample		HatCLD
	sNote		$06
	sRet

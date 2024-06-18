; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Stage51_Voice
	sHeaderSamples	Stage51_Samples
	sHeaderVibrato	Stage51_Vib
	sHeaderEnvelope	Stage51_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$E4
	sChannel	DAC1, Stage51_DAC1
	sChannel	FM1, Stage51_FM1
	sChannel	FM2, Stage51_FM3
	sChannel	FM3, Stage51_FM2
	sChannel	FM4, Stage51_FM4
	sChannel	FM5, Stage51_FM5
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Stage51_Voice:
	sNewVoice	v00
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$0F, $01, $06, $01
	sMultiple	$02, $02, $04, $02
	sRateScale	$00, $00, $02, $01
	sAttackRate	$0F, $0F, $0F, $0F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $03, $07, $02
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$01, $01, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $22, $24, $02
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$00, $07, $03, $00
	sMultiple	$02, $02, $01, $01
	sRateScale	$02, $00, $00, $00
	sAttackRate	$10, $11, $11, $11
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0D, $0E, $0E, $10
	sDecay2Rate	$00, $02, $02, $04
	sDecay1Level	$03, $02, $02, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $02, $03, $03
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$04
	sFeedback	$03
	sDetune		$01, $01, $02, $00
	sMultiple	$04, $02, $04, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$15, $15, $14, $14
	sDecay2Rate	$00, $00, $00, $00
	sDecay1Level	$05, $05, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0F, $0F, $0A, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Stage51_Samples:
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

Stage51_Vib:
	sVibrato FM1,		$21, $00, $1998, $0012, Triangle

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Stage51_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; DAC1 data
; ---------------------------------------------------------------------------

Stage51_DAC1:
	sPan		center
	sVol		$04
	sSample		Kick
	sCall		$01, Stage51_DAC1_01
	sNote		$18
	sNote		$10
	sCall		$01, Stage51_DAC1_01
	sNote		$10
	sNote		$08
	sNote		$08
	sNote		$08

Stage51_Jump00:
	sCall		$07, Stage51_Loop00
	sCall		$01, Stage51_DAC1_00
	sNote		$08
	sCall		$08, Stage51_Loop01
	sNote		$08
	sCall		$07, Stage51_Loop00
	sCall		$01, Stage51_DAC1_00
	sNote		$08
	sNote		$08
	sJump		Stage51_Jump00

Stage51_DAC1_01:
	sNote		nSample, $08
	sNote		$10
	sNote		$08
	sNote		$08
	sNote		$10
	sNote		$08
	sNote		$18
	sRet

Stage51_DAC1_00:
	sNote		$18
	sNote		$18
	sNote		$10
	sNote		$08
	sNote		$10
	sNote		$10
	sNote		$08
	sRet

Stage51_Loop00:
	sCall		$01, Stage51_DAC1_00
	sNote		$10
	sRet

Stage51_Loop01:
	sNote		$08
	sNote		$08
	sNote		$10
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Stage51_FM1:
	sVoice		v00
	sPan		center
	sVibratoSet	FM1
	sVol		$10

	sNote		nG3, $40
	sNote		nFs3
	sNote		nDs3
	sNote		nC4, $08
	sNote		nB3
	sNote		nGs3
	sNote		nG3
	sNote		nF3
	sNote		nG2
	sNote		nB2
	sNote		nDs3

Stage51_Jump02:
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $D0
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $10
	sNote		nA3, $18
	sNote		nFs3
	sNote		nG3, $10
	sNote		nDs3, $80
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $D0
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $10
	sNote		nA3, $18
	sNote		nFs3
	sNote		nG3, $10
	sNote		nDs3, $40
	sNote		nC4, $08
	sNote		nB3
	sNote		nGs3
	sNote		nG3
	sNote		nF3
	sNote		nG2
	sNote		nB2
	sNote		nDs3

	sCall		$02, Stage51_Loop51
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $D0
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $10
	sNote		nA3, $18
	sNote		nFs3
	sNote		nG3, $10
	sNote		nDs3, $80

	sVoice		v02
	sCall		$07, Stage51_Loop52
	sVoice		v00
	sNote		nC4, $08
	sNote		nB3
	sNote		nGs3
	sNote		nG3
	sNote		nF3
	sNote		nG2
	sNote		nB2
	sNote		nDs3
	sJump		Stage51_Jump02

Stage51_Loop51:
	sNote		nC4
	sNote		nC5
	sNote		nB4
	sNote		nC5
	sNote		nG4
	sNote		nGs4
	sNote		nDs5
	sNote		nB4
	sNote		nFs4
	sNote		nF4
	sNote		nDs4
	sNote		nB3
	sNote		nC4
	sNote		nFs3
	sNote		nG3
	sNote		nDs3
	sRet

Stage51_Loop52:
	sNote		nC4, $08
	sNote		$08
	sNote		nRst
	sNote		nG3
	sNote		nRst
	sNote		nDs4
	sNote		nFs3, $10
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Stage51_FM2:
	sVoice		v01
	sPan		center
	sVol		$10
	sCall		$03, Stage51_Loop4C

	sNote		nC3, $08
	sNote		nB2
	sNote		nGs2
	sNote		nG2
	sNote		nF2
	sNote		nG1
	sNote		nB1
	sNote		nDs2

Stage51_FM2_01:
	sCall		$03, Stage51_FM2_00
	sCall		$03, Stage51_Loop4E
	sNote		nC3, $08
	sNote		nB2
	sNote		nGs2
	sNote		nG2
	sNote		nF2
	sNote		nG1
	sNote		nB1
	sNote		nDs2

	sPan		left
	sNote		nRst, $03

	sFrac		$000A
	sVol		$05
	sNote		nC2, $18
	sNote		nG2
	sNote		nFs2, $10
	sNote		nC3, $18
	sNote		nFs2
	sNote		nG2, $10
	sNote		nDs2, $40
	sNote		nC2, $08
	sNote		$08
	sNote		nRst, $18
	sNote		nG2, $08
	sNote		nFs2, $0D

	sFrac		-$000A
	sPan		center
	sVol		-$05
	sCall		$02, Stage51_FM2_00
	sCall		$07, Stage51_Loop50

	sNote		nC3
	sNote		nB2
	sNote		nGs2
	sNote		nG2
	sNote		nF2
	sNote		nG1
	sNote		nB1
	sNote		nDs2
	sJump		Stage51_FM2_01

Stage51_Loop4C:
	sNote		nC2, $18
	sNote		nG1
	sNote		nFs1, $10
	sRet

Stage51_FM2_00:
	sCall		$03, Stage51_Loop4E
	sNote		nC2, $08
	sNote		nFs1
	sNote		nG1
	sNote		nB1
	sNote		nDs2
	sNote		nC2
	sNote		nFs2
	sNote		nG2
	sRet

Stage51_Loop4E:
	sNote		nC2, $10
	sNote		nFs1, $08
	sNote		nC2, $10
	sNote		nFs1, $18
	sRet

Stage51_Loop50:
	sNote		nC2
	sNote		nG1
	sNote		nG1
	sNote		nC2
	sNote		nG1
	sNote		nG1
	sNote		nDs2
	sNote		nFs2
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Stage51_FM3:
	sVoice		v00
	sPan		center
	sVibratoSet	FM1
	sVol		$10
	sNote		nC3, $40
	sNote		nB2
	sNote		nG2, $80

Stage51_Jump01:
	sNote		nC4, $58
	sNote		nFs4, $18
	sNote		nG4, $10
	sNote		nDs4, $40
	sNote		nFs4
	sNote		nC4
	sNote		nFs4
	sNote		nA4, $18
	sNote		nDs4
	sNote		nG4
	sNote		nFs4, $38
	sNote		nC4, $58
	sNote		nFs4, $18
	sNote		nG4, $10
	sNote		nDs4, $40
	sNote		nFs4
	sNote		nC4
	sNote		nFs4
	sNote		nA4, $18
	sNote		nDs4
	sNote		nG4, $50

	sVoice		v01
	sNote		nC2, $18
	sNote		nG2
	sNote		nFs2, $10
	sNote		nC3, $18
	sNote		nFs2
	sNote		nG2, $10
	sNote		nDs2, $40
	sNote		nC2, $08
	sNote		$08
	sNote		nRst, $18
	sNote		nG2, $08
	sNote		nFs2, $10

	sVoice		v00
	sNote		nC4, $58
	sNote		nFs4, $18
	sNote		nG4, $10
	sNote		nDs4, $40
	sNote		nFs4
	sNote		nC4
	sNote		nFs4
	sNote		nA4, $18
	sNote		nDs4
	sNote		nG4
	sNote		nFs4, $38
	sNote		nC4, $18
	sNote		nB3
	sNote		nDs4
	sNote		nD4
	sNote		nC4, $10
	sNote		nDs4
	sNote		nFs4, $40
	sNote		nG4
	sNote		nC4, $18
	sNote		nB3
	sNote		nDs4
	sNote		nD4
	sNote		nC4, $10
	sNote		nDs4
	sNote		nG3, $80
	sJump		Stage51_Jump01

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Stage51_FM4:
	sNote		nRst, $05

	sVoice		v00
	sPan		left
	sVol		$15
	sFrac		$000F

	sNote		nG3, $40
	sNote		nFs3
	sNote		nDs3

Stage51_FM4_00:
	sNote		nC4, $08
	sNote		nB3
	sNote		nGs3
	sNote		nG3
	sNote		nF3
	sNote		nG2
	sNote		nB2
	sNote		nDs3

	sVibratoSet	FM1
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $D0
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $10
	sNote		nA3, $18
	sNote		nFs3
	sNote		nG3, $10
	sNote		nDs3, $80
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $D0
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $10
	sNote		nA3, $18
	sNote		nFs3
	sNote		nG3, $10
	sNote		nDs3, $40
	sNote		nC4, $08
	sNote		nB3
	sNote		nGs3
	sNote		nG3
	sNote		nF3
	sNote		nG2
	sNote		nB2

	sCall		$02, Stage51_Loop04
	sNote		nDs3
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $D0
	sNote		nC3, $18
	sNote		nG3
	sNote		nFs3, $10
	sNote		nA3, $18
	sNote		nFs3
	sNote		nG3, $10
	sNote		nDs3, $80

	sVoice		v02
	sCall		$07, Stage51_Loop05
	sJump		Stage51_FM4_00

Stage51_Loop04:
	sNote		nDs3
	sNote		nC4
	sNote		nC5
	sNote		nB4
	sNote		nC5
	sNote		nG4
	sNote		nGs4
	sNote		nDs5
	sNote		nB4
	sNote		nFs4
	sNote		nF4
	sNote		nDs4
	sNote		nB3
	sNote		nC4
	sNote		nFs3
	sNote		nG3
	sRet

Stage51_Loop05:
	sNote		nC4, $08
	sNote		$08
	sNote		nRst
	sNote		nG3
	sNote		nRst
	sNote		nDs4
	sNote		nFs3, $10
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Stage51_FM5:
	sNote		nRst, $03
	sFrac		$000A
	sVoice		v00
	sPan		right
	sVol		$15

	sNote		nC3, $40
	sNote		nB2
	sNote		nG2, $80
	sVibratoSet	FM1

Stage51_Loop03:
	sNote		nC4, $58
	sNote		nFs4, $18
	sNote		nG4, $10
	sNote		nDs4, $40
	sNote		nFs4
	sNote		nC4
	sNote		nFs4
	sNote		nA4, $18
	sNote		nDs4
	sNote		nG4
	sNote		nFs4, $38
	sNote		nC4, $58
	sNote		nFs4, $18
	sNote		nG4, $10
	sNote		nDs4, $40
	sNote		nFs4
	sNote		nC4
	sNote		nFs4
	sNote		nA4, $18
	sNote		nDs4
	sNote		nG4, $50

	sVoice		v01
	sNote		nC2, $18
	sNote		nG2
	sNote		nFs2, $10
	sNote		nC3, $18
	sNote		nFs2
	sNote		nG2, $10
	sNote		nDs2, $40
	sNote		nC2, $08
	sNote		$08
	sNote		nRst, $18
	sNote		nG2, $08
	sNote		nFs2, $10

	sVoice		v00
	sNote		nC4, $58
	sNote		nFs4, $18
	sNote		nG4, $10
	sNote		nDs4, $40
	sNote		nFs4
	sNote		nC4
	sNote		nFs4
	sNote		nA4, $18
	sNote		nDs4
	sNote		nG4
	sNote		nFs4, $38
	sNote		nC4, $18
	sNote		nB3
	sNote		nDs4
	sNote		nD4
	sNote		nC4, $10
	sNote		nDs4
	sNote		nFs4, $40
	sNote		nG4
	sNote		nC4, $18
	sNote		nB3
	sNote		nDs4
	sNote		nD4
	sNote		nC4, $10
	sNote		nDs4
	sNote		nG3, $80
	sJump		Stage51_Loop03

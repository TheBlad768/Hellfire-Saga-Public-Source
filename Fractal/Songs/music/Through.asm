; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Snd_Passed_Voice
	sHeaderSamples	Snd_Passed_Samples
	sHeaderVibrato	Snd_Passed_Vib
	sHeaderEnvelope	Snd_Passed_Env
	sHeaderEnd

	sSong		music index=$00 flags= tempo=$FE
	sChannel	FM1, Snd_Passed_FM1
	sChannel	FM2, Snd_Passed_FM3
	sChannel	FM3, Snd_Passed_FM2
	sChannel	FM4, Snd_Passed_FM4
	sChannel	FM5, Snd_Passed_FM5
	sChannel	FM6, Snd_Passed_FM6
	sChannel	PSG1, Snd_Passed_PSG1
	sChannel	PSG2, Snd_Passed_PSG2
	sChannelEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Snd_Passed_Voice:
	sNewVoice	v00
	sAlgorithm	$01
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$0C, $01, $0A, $02
	sRateScale	$02, $02, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $03, $03, $03
	sDecay2Rate	$06, $00, $00, $00
	sDecay1Level	$02, $0F, $0F, $0F
	sReleaseRate	$0F, $07, $0F, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2C, $13, $2D, $00
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$01
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$0C, $01, $0A, $01
	sRateScale	$02, $02, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $03, $03, $03
	sDecay2Rate	$06, $00, $00, $00
	sDecay1Level	$02, $0F, $0F, $0F
	sReleaseRate	$0F, $07, $0F, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2C, $13, $2D, $00
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$01
	sFeedback	$00
	sDetune		$00, $00, $00, $00
	sMultiple	$07, $01, $06, $02
	sRateScale	$02, $02, $02, $02
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$07, $03, $03, $03
	sDecay2Rate	$06, $00, $00, $00
	sDecay1Level	$02, $0F, $0F, $0F
	sReleaseRate	$0F, $07, $0F, $06
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2C, $13, $2D, $00
	sFinishVoice

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Snd_Passed_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Snd_Passed_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Snd_Passed_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM1 data
; ---------------------------------------------------------------------------

Snd_Passed_FM1:
	sVoice		v00
	sVol		$0E
	sPan		center
	sNote		nC4, $0C
	sNote		nB3
	sNote		nC4, $18
	sNote		$0C
	sNote		nB3
	sNote		nC4, $18
	sNote		$0C
	sNote		nB3
	sNote		nGs3
	sNote		nF3
	sNote		nG3
	sNote		nG3
	sNote		nF3
	sNote		nDs3
	sNote		nD3
	sNote		nDs3
	sNote		nF3
	sNote		nDs3
	sNote		nG3
	sNote		nG3
	sNote		nF3
	sNote		nB2
	sNote		nC3, $64

	sCall		$06, Snd_Passed_Loop1A
	sVol		$01
	sNote		sHold, $04
	sVol		$01
	sNote		sHold, nC3
	sStop

Snd_Passed_Loop1A:
	sCall		$07, Snd_Passed_Loop19
	sVol		$01
	sNote		sHold, $08
	sRet

Snd_Passed_Loop19:
	sVol		$01
	sNote		sHold, $04
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; FM2 data
; ---------------------------------------------------------------------------

Snd_Passed_FM2:
	sNote		nRst, $30
	sVoice		v00
	sVol		$0E
	sPan		center
	sNote		nDs4, $0C
	sNote		nD4
	sNote		nDs4, $18
	sNote		$0C
	sNote		nD4
	sNote		nDs4
	sNote		nDs4
	sNote		nD4
	sNote		nD4
	sNote		nD4
	sNote		nB3
	sNote		nGs3
	sNote		nC4
	sNote		nD4
	sNote		nAs3
	sNote		nDs3
	sNote		nB3
	sNote		nD4
	sNote		nDs4
	sNote		nDs4, $64

	sCall		$06, Snd_Passed_Loop1A
	sVol		$01
	sNote		sHold, $04
	sVol		$01
	sNote		sHold, $04
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM3 data
; ---------------------------------------------------------------------------

Snd_Passed_FM3:
	sNote		nRst, $60
	sVoice		v00
	sVol		$0E
	sPan		right
	sNote		nGs4, $0C
	sNote		nG4
	sNote		nF4
	sNote		nGs4
	sNote		nG4
	sNote		nF4
	sNote		nDs4
	sNote		nD4
	sNote		nF4
	sNote		nG4
	sNote		nGs4
	sNote		nF4
	sNote		nB4
	sNote		nC5
	sNote		nD5
	sNote		nB4
	sNote		nC5, $64

	sCall		$06, Snd_Passed_Loop1A
	sVol		$01
	sNote		sHold, $04
	sVol		$01
	sNote		sHold, nC5
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM4 data
; ---------------------------------------------------------------------------

Snd_Passed_FM4:
	sNote		nRst, $02
	sVoice		v01
	sVol		$20
	sPan		left
	sNote		nC4, $0C
	sNote		nB3
	sNote		nC4, $18
	sPan		right
	sNote		nDs4, $0C
	sNote		nD4
	sNote		nDs4, $16
	sNote		nRst, $60
	sVol		-$12
	sPan		left
	sNote		nF2, $30
	sNote		nB1
	sNote		nC1, $64

	sCall		$06, Snd_Passed_Loop1A
	sVol		$01
	sNote		sHold, $04
	sVol		$01
	sNote		sHold, nC1
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM5 data
; ---------------------------------------------------------------------------

Snd_Passed_FM5:
	sNote		nRst, $90
	sVoice		v00
	sVol		$0E
	sPan		left
	sNote		nGs4, $0C
	sNote		nB4
	sNote		nC5
	sNote		nD5
	sNote		nDs5
	sNote		nD5
	sNote		nC5
	sNote		nAs4
	sNote		nGs4
	sNote		nG4, $03
	sNote		nG4
	sNote		nGs4
	sNote		nG4
	sNote		nF4, $0C
	sNote		nD4
	sNote		nC4, $64

	sCall		$06, Snd_Passed_Loop1A
	sVol		$01
	sNote		sHold, $04
	sVol		$01
	sNote		sHold, nC4
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FM6 data
; ---------------------------------------------------------------------------

Snd_Passed_FM6:
	sNote		nRst, $C0
	sVoice		v02
	sVol		$0E
	sPan		right
	sNote		nF2, $30
	sNote		nB1
	sNote		nC2, $64

	sCall		$06, Snd_Passed_Loop1A
	sVol		$01
	sNote		sHold, $04
	sVol		$01
	sNote		sHold, nC2
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG1 data
; ---------------------------------------------------------------------------

Snd_Passed_PSG1:
	sNote		nCut, $C0
	sVol		$40
	sFrac		$0C00
	sNote		nG4, $03
	sFrac		-$0005		; ssDetune $FF
	sNote		nF4, $01
	sNote		nE4
	sFrac		$0005		; ssDetune $00
	sNote		nDs4
	sNote		nD4
	sNote		nCs4, $02
	sFrac		-$0003		; ssDetune $FF
	sNote		nB3, $01
	sNote		nAs3
	sFrac		-$0005		; ssDetune $FE
	sNote		nA3
	sFrac		$000C		; ssDetune $01
	sNote		nA3
	sNote		nGs3
	sFrac		-$0004		; ssDetune $00
	sNote		nG3
	sFrac		-$0005		; ssDetune $FF
	sNote		nFs3
	sFrac		$000E		; ssDetune $02
	sNote		nFs3
	sFrac		-$0009		; ssDetune $00
	sNote		nF3
	sFrac		-$000B		; ssDetune $FE
	sNote		nE3
	sFrac		$0010		; ssDetune $01
	sNote		nE3
	sFrac		-$000A		; ssDetune $FF
	sNote		nDs3
	sFrac		$0010		; ssDetune $02
	sNote		nDs3
	sFrac		-$000B		; ssDetune $00
	sNote		nD3
	sFrac		-$0014		; ssDetune $FD
	sNote		nCs3
	sFrac		$0014		; ssDetune $00
	sNote		nCs3
	sFrac		-$000A		; ssDetune $FD
	sNote		nC3, $02
	sNote		nB2, $01
	sFrac		$000A		; ssDetune $00
	sNote		nB2
	sFrac		$000A		; ssDetune $03
	sNote		nB2
	sFrac		-$000E		; ssDetune $FF
	sNote		nAs2
	sFrac		$000B		; ssDetune $02
	sNote		nAs2
	sFrac		-$000F		; ssDetune $FE
	sNote		nA2
	sFrac		$000C		; ssDetune $01
	sNote		nA2
	sFrac		-$0015		; ssDetune $FC
	sNote		nGs2
	sFrac		$000D		; ssDetune $FF
	sNote		nGs2
	sFrac		$000C		; ssDetune $02
	sNote		nGs2
	sFrac		-$0015		; ssDetune $FD
	sNote		nG2
	sFrac		$000D		; ssDetune $00
	sNote		nG2
	sFrac		$000D		; ssDetune $03
	sNote		nG2
	sFrac		-$0017		; ssDetune $FE
	sNote		nFs2
	sFrac		$000E		; ssDetune $01
	sNote		nFs2
	sFrac		$000E		; ssDetune $04
	sNote		nFs2
	sFrac		-$001C		; ssDetune $FE
	sNote		nF2
	sFrac		$000F		; ssDetune $01
	sNote		nF2
	sFrac		$000F		; ssDetune $04
	sNote		nF2
	sFrac		-$001F		; ssDetune $FE
	sNote		nE2
	sFrac		$0010		; ssDetune $01
	sNote		nE2
	sFrac		$0010		; ssDetune $04
	sNote		nE2
	sFrac		-$002C		; ssDetune $FC
	sNote		nDs2
	sFrac		$0012		; ssDetune $FF
	sNote		nDs2
	sFrac		$0010		; ssDetune $02
	sNote		nDs2
	sFrac		-$002A		; ssDetune $FB
	sNote		nD2
	sFrac		$0013		; ssDetune $FE
	sNote		nD2
	sFrac		$0011		; ssDetune $01
	sNote		nD2
	sFrac		$0012		; ssDetune $04
	sNote		nD2
	sFrac		-$0031		; ssDetune $FC
	sNote		nCs2
	sFrac		$0014		; ssDetune $FF
	sNote		nCs2
	sFrac		$0012		; ssDetune $02
	sNote		nCs2
	sFrac		$0013		; ssDetune $05
	sNote		nCs2
	sFrac		-$0030		; ssDetune $FB
	sNote		nC2
	sFrac		$000A		; ssDetune $FE
	sNote		$02
	sFrac		$001B		; ssDetune $03
	sNote		$01
	sFrac		-$0029		; ssDetune $FA
	sNote		nB1
	sFrac		$000B		; ssDetune $FD
	sNote		nB1
	sFrac		$000A		; ssDetune $00
	sNote		nB1
	sFrac		$000A		; ssDetune $03
	sNote		nB1
	sFrac		$000B		; ssDetune $06
	sNote		nB1
	sFrac		-$0025		; ssDetune $FC
	sNote		nAs1
	sFrac		$000C		; ssDetune $FF
	sNote		nAs1
	sFrac		$000B		; ssDetune $02
	sNote		nAs1
	sFrac		$000B		; ssDetune $05
	sNote		nAs1
	sFrac		-$0030		; ssDetune $F9
	sNote		nA1
	sFrac		$000D		; ssDetune $FC
	sNote		nA1
	sFrac		$000D		; ssDetune $FF
	sNote		nA1
	sFrac		$000C		; ssDetune $02
	sNote		nA1
	sFrac		$000C		; ssDetune $05
	sNote		nA1
	sFrac		-$0033		; ssDetune $F9
	sNote		nGs1
	sFrac		$000E		; ssDetune $FC
	sNote		nGs1
	sFrac		$000D		; ssDetune $FF
	sNote		nGs1
	sFrac		$000C		; ssDetune $02
	sNote		nGs1
	sFrac		$000E		; ssDetune $05
	sNote		nGs1
	sFrac		-$003B		; ssDetune $F8
	sNote		nG1
	sFrac		$000E		; ssDetune $FB
	sNote		nG1
	sFrac		$000E		; ssDetune $FE
	sNote		nG1
	sFrac		$000D		; ssDetune $01
	sNote		nG1
	sFrac		$000D		; ssDetune $04
	sNote		nG1
	sFrac		$000E		; ssDetune $07
	sNote		nG1
	sFrac		-$0042		; ssDetune $F9
	sNote		nFs1
	sFrac		$000F		; ssDetune $FC
	sNote		nFs1
	sFrac		$000F		; ssDetune $FF
	sNote		nFs1
	sFrac		$000E		; ssDetune $02
	sNote		nFs1
	sFrac		$000E		; ssDetune $05
	sNote		nFs1
	sFrac		$000E		; ssDetune $08
	sNote		nFs1
	sFrac		-$004A		; ssDetune $F9
	sNote		nF1
	sFrac		$0010		; ssDetune $FC
	sNote		nF1
	sFrac		$0010		; ssDetune $FF
	sNote		nF1
	sFrac		$000F		; ssDetune $02
	sNote		nF1
	sFrac		$000F		; ssDetune $05
	sNote		nF1
	sFrac		$000F		; ssDetune $08
	sNote		nF1
	sFrac		-$0055		; ssDetune $F8
	sNote		nE1
	sFrac		$0011		; ssDetune $FB
	sNote		nE1
	sFrac		$0011		; ssDetune $FE
	sNote		nE1
	sFrac		$0010		; ssDetune $01
	sNote		nE1
	sFrac		$0010		; ssDetune $04
	sNote		nE1
	sFrac		$0010		; ssDetune $07
	sNote		nE1
	sFrac		-$0060		; ssDetune $F6
	sNote		nDs1
	sFrac		$0012		; ssDetune $F9
	sNote		nDs1
	sFrac		$0012		; ssDetune $FC
	sNote		nDs1
	sFrac		$0012		; ssDetune $FF
	sNote		nDs1
	sFrac		$0010		; ssDetune $02
	sNote		nDs1
	sFrac		$0011		; ssDetune $05
	sNote		nDs1
	sFrac		$0011		; ssDetune $08
	sNote		nDs1
	sFrac		-$0071		; ssDetune $F5
	sNote		nD1
	sFrac		$0013		; ssDetune $F8
	sNote		nD1
	sFrac		$0012		; ssDetune $FB
	sNote		nD1
	sFrac		$0013		; ssDetune $FE
	sNote		nD1
	sFrac		$0011		; ssDetune $01
	sNote		nD1
	sFrac		$0012		; ssDetune $04
	sNote		nD1
	sFrac		$0012		; ssDetune $07
	sNote		nD1
	sFrac		$0012		; ssDetune $0A
	sNote		nD1
	sFrac		-$0077		; ssDetune $F7
	sNote		nCs1
	sFrac		$0014		; ssDetune $FA
	sNote		nCs1
	sFrac		$0014		; ssDetune $FD
	sNote		nCs1
	sFrac		$0014		; ssDetune $00
	sNote		nCs1
	sFrac		$0012		; ssDetune $03
	sNote		nCs1
	sFrac		$0013		; ssDetune $06
	sNote		nCs1
	sFrac		$0013		; ssDetune $09
	sNote		nCs1
	sFrac		-$0062		; ssDetune $F4
	sNote		nC1
	sFrac		$000B		; ssDetune $F7
	sNote		nC1
	sFrac		$000A		; ssDetune $FA
	sNote		nC1
	sFrac		$000B		; ssDetune $FD
	sNote		nC1
	sFrac		$000A		; ssDetune $00
	sNote		$02
	sFrac		$0006		; ssDetune $01
	sNote		$39

	sCall		$06, Snd_Passed_Loop1F
	sStop

Snd_Passed_Loop1F:
	sVol		$08
	sNote		$04
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; PSG2 data
; ---------------------------------------------------------------------------

Snd_Passed_PSG2:
	sNote		nCut, $C0
	sVol		$40
	sFrac		$0C00
	sNote		nGs4, $03
	sNote		nF4, $01
	sFrac		$0005		; ssDetune $01
	sNote		nDs4
	sNote		nCs4, $02
	sFrac		-$0009		; ssDetune $FF
	sNote		nAs3, $01
	sFrac		$0008		; ssDetune $01
	sNote		nA3
	sFrac		-$0004		; ssDetune $00
	sNote		nG3
	sFrac		$0009		; ssDetune $02
	sNote		nFs3
	sFrac		-$0014		; ssDetune $FE
	sNote		nE3
	sFrac		$0006		; ssDetune $FF
	sNote		nDs3
	sFrac		$0005		; ssDetune $00
	sNote		nD3
	sNote		nCs3, $02
	sNote		nB2, $01
	sFrac		-$0004		; ssDetune $FF
	sNote		nAs2
	sFrac		-$0004		; ssDetune $FE
	sNote		nA2
	sFrac		-$0009		; ssDetune $FC
	sNote		nGs2
	sFrac		$0019		; ssDetune $02
	sNote		nGs2
	sFrac		-$0008		; ssDetune $00
	sNote		nG2
	sFrac		-$000A		; ssDetune $FE
	sNote		nFs2
	sFrac		$001C		; ssDetune $04
	sNote		nFs2
	sFrac		-$000D		; ssDetune $01
	sNote		nF2
	sFrac		-$0010		; ssDetune $FE
	sNote		nE2
	sFrac		$0020		; ssDetune $04
	sNote		nE2
	sFrac		-$001A		; ssDetune $FF
	sNote		nDs2
	sFrac		-$001A		; ssDetune $FB
	sNote		nD2
	sFrac		$0024		; ssDetune $01
	sNote		nD2
	sFrac		-$001F		; ssDetune $FC
	sNote		nCs2
	sFrac		$0026		; ssDetune $02
	sNote		nCs2
	sFrac		-$001D		; ssDetune $FB
	sNote		nC2, $02
	sFrac		-$0004		; ssDetune $FA
	sNote		nB1, $01
	sFrac		$0015		; ssDetune $00
	sNote		nB1
	sFrac		$0015		; ssDetune $06
	sNote		nB1
	sFrac		-$0019		; ssDetune $FF
	sNote		nAs1
	sFrac		$0016		; ssDetune $05
	sNote		nAs1
	sFrac		-$0023		; ssDetune $FC
	sNote		nA1
	sFrac		$0019		; ssDetune $02
	sNote		nA1
	sFrac		-$0027		; ssDetune $F9
	sNote		nGs1
	sFrac		$001B		; ssDetune $FF
	sNote		nGs1
	sFrac		$001A		; ssDetune $05
	sNote		nGs1
	sFrac		-$002D		; ssDetune $FB
	sNote		nG1
	sFrac		$001B		; ssDetune $01
	sNote		nG1
	sFrac		$001B		; ssDetune $07
	sNote		nG1
	sFrac		-$0033		; ssDetune $FC
	sNote		nFs1
	sFrac		$001D		; ssDetune $02
	sNote		nFs1
	sFrac		$001C		; ssDetune $08
	sNote		nFs1
	sFrac		-$003A		; ssDetune $FC
	sNote		nF1
	sFrac		$001F		; ssDetune $02
	sNote		nF1
	sFrac		$001E		; ssDetune $08
	sNote		nF1
	sFrac		-$0044		; ssDetune $FB
	sNote		nE1
	sFrac		$0021		; ssDetune $01
	sNote		nE1
	sFrac		$0020		; ssDetune $07
	sNote		nE1
	sFrac		-$004E		; ssDetune $F9
	sNote		nDs1
	sFrac		$0024		; ssDetune $FF
	sNote		nDs1
	sFrac		$0021		; ssDetune $05
	sNote		nDs1
	sFrac		-$0060		; ssDetune $F5
	sNote		nD1
	sFrac		$0025		; ssDetune $FB
	sNote		nD1
	sFrac		$0024		; ssDetune $01
	sNote		nD1
	sFrac		$0024		; ssDetune $07
	sNote		nD1
	sFrac		-$0065		; ssDetune $F7
	sNote		nCs1
	sFrac		$0028		; ssDetune $FD
	sNote		nCs1
	sFrac		$0026		; ssDetune $03
	sNote		nCs1
	sFrac		$0026		; ssDetune $09
	sNote		nCs1
	sFrac		-$0057		; ssDetune $F7
	sNote		nC1
	sFrac		$0015		; ssDetune $FD
	sNote		$02
	sFrac		$0039		; ssDetune $07
	sNote		$01
	sFrac		-$005A		; ssDetune $F4
	sNote		nB0
	sFrac		$0016		; ssDetune $FA
	sNote		nB0
	sFrac		$0015		; ssDetune $00
	sNote		nB0
	sFrac		$0015		; ssDetune $06
	sNote		nB0
	sFrac		$0015		; ssDetune $0C
	sNote		nB0
	sFrac		-$004E		; ssDetune $F7
	sNote		nAs0
	sFrac		$0018		; ssDetune $FD
	sNote		nAs0
	sFrac		$0016		; ssDetune $03
	sNote		nAs0
	sFrac		$0016		; ssDetune $09
	sNote		nAs0
	sFrac		-$0059		; ssDetune $F3
	sNote		nA0
	sFrac		$001B		; ssDetune $F9
	sNote		nA0
	sFrac		$001A		; ssDetune $FF
	sNote		nA0
	sFrac		$0018		; ssDetune $05
	sNote		nA0
	sFrac		$0018		; ssDetune $0B
	sNote		nA0
	sFrac		-$006A		; ssDetune $F2
	sNote		nGs0
	sFrac		$001B		; ssDetune $F8
	sNote		nGs0
	sFrac		$001B		; ssDetune $FE
	sNote		nGs0
	sFrac		$0019		; ssDetune $04
	sNote		nGs0
	sFrac		$001B		; ssDetune $0A
	sNote		nGs0
	sFrac		-$0076		; ssDetune $F0
	sNote		nG0
	sFrac		$001C		; ssDetune $F6
	sNote		nG0
	sFrac		$001C		; ssDetune $FC
	sNote		nG0
	sFrac		$001A		; ssDetune $02
	sNote		nG0
	sFrac		$001B		; ssDetune $08
	sNote		nG0
	sFrac		$001B		; ssDetune $0E
	sNote		nG0
	sFrac		-$0084		; ssDetune $F2
	sNote		nFs0
	sFrac		$001E		; ssDetune $F8
	sNote		nFs0
	sFrac		$001E		; ssDetune $FE
	sNote		nFs0
	sFrac		$001C		; ssDetune $04
	sNote		nFs0
	sFrac		$001C		; ssDetune $0A
	sNote		nFs0
	sFrac		$001C		; ssDetune $10
	sNote		nFs0
	sFrac		-$0094		; ssDetune $F2
	sNote		nF0
	sFrac		$0020		; ssDetune $F8
	sNote		nF0
	sFrac		$0020		; ssDetune $FE
	sNote		nF0
	sFrac		$001E		; ssDetune $04
	sNote		nF0
	sFrac		$001E		; ssDetune $0A
	sNote		nF0
	sFrac		$001E		; ssDetune $10
	sNote		nF0
	sFrac		-$00A5		; ssDetune $F1
	sNote		nE0
	sFrac		$0022		; ssDetune $F7
	sNote		nE0
	sFrac		$0022		; ssDetune $FD
	sNote		nE0
	sFrac		$0021		; ssDetune $03
	sNote		nE0
	sFrac		$0020		; ssDetune $09
	sNote		nE0
	sFrac		$0020		; ssDetune $0F
	sNote		nE0
	sFrac		-$00C7		; ssDetune $EC
	sNote		nDs0
	sFrac		$0024		; ssDetune $F2
	sNote		nDs0
	sFrac		$0024		; ssDetune $F8
	sNote		nDs0
	sFrac		$0024		; ssDetune $FE
	sNote		nDs0
	sFrac		$0021		; ssDetune $04
	sNote		nDs0
	sFrac		$0022		; ssDetune $0A
	sNote		nDs0
	sFrac		$0023		; ssDetune $10
	sNote		nDs0
	sFrac		-$00DE		; ssDetune $EB
	sNote		nD0
	sFrac		$0026		; ssDetune $F1
	sNote		nD0
	sFrac		$0025		; ssDetune $F7
	sNote		nD0
	sFrac		$0026		; ssDetune $FD
	sNote		nD0
	sFrac		$0023		; ssDetune $03
	sNote		nD0
	sFrac		$0024		; ssDetune $09
	sNote		nD0
	sFrac		$0024		; ssDetune $0F
	sNote		nD0
	sFrac		$0024		; ssDetune $15
	sNote		nD0
	sFrac		-$00F6		; ssDetune $EE
	sNote		nCs0
	sFrac		$0029		; ssDetune $F4
	sNote		nCs0
	sFrac		$0028		; ssDetune $FA
	sNote		nCs0
	sFrac		$0028		; ssDetune $00
	sNote		nCs0
	sFrac		$0025		; ssDetune $06
	sNote		nCs0
	sFrac		$0025		; ssDetune $0C
	sNote		nCs0
	sFrac		$0026		; ssDetune $12
	sNote		nCs0
	sFrac		-$00C4		; ssDetune $E8
	sNote		nC0
	sFrac		$0015		; ssDetune $EE
	sNote		nC0
	sFrac		$0015		; ssDetune $F4
	sNote		nC0
	sFrac		$0015		; ssDetune $FA
	sNote		nC0
	sFrac		$0015		; ssDetune $00
	sNote		$02
	sFrac		$0006		; ssDetune $01
	sNote		$32

	sCall		$06, Snd_Passed_Loop1E
	sStop

Snd_Passed_Loop1E:
	sVol		$08
	sNote		$04
	sRet

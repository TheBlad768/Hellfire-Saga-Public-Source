; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	Bosses_Voice
	sHeaderSamples	Bosses_Samples
	sHeaderVibrato	Bosses_Vib
	sHeaderEnvelope	Bosses_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

Bosses_Samples:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

Bosses_Voice:
	sNewVoice	SpikeAttack
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$07, $03, $03, $07
	sMultiple	$0B, $00, $00, $05
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0E, $0E, $0F, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $12, $1F
	sDecay2Rate	$00, $07, $00, $00
	sDecay1Level	$01, $01, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1A, $05, $1C, $01
	sFinishVoice

	sNewVoice	Arthur1
	sAlgorithm	$03
	sFeedback	$07
	sDetune		$03, $01, $07, $07
	sMultiple	$0F, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0D, $0E, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0A, $09, $0A, $04
	sDecay2Rate	$00, $00, $00, $05
	sDecay1Level	$05, $01, $05, $0A
	sReleaseRate	$03, $06, $05, $07
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$2F, $0B, $16, $07
	sFinishVoice

	sNewVoice	Arthur2
	sAlgorithm	$00
	sFeedback	$03
	sDetune		$00, $00, $00, $00
	sMultiple	$0A, $06, $0F, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $14, $07, $12
	sDecay2Rate	$00, $00, $08, $00
	sDecay1Level	$0F, $0F, $08, $0F
	sReleaseRate	$0F, $0F, $07, $0A
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $00, $00, $0B
	sFinishVoice

	sNewVoice	Boom
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$02, $00, $03, $02
	sMultiple	$0A, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$0E, $15, $11, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$05, $11, $00, $02
	sDecay2Rate	$0B, $10, $07, $05
	sDecay1Level	$01, $04, $00, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$33, $00, $10, $00
	sFinishVoice

	sNewVoice	Tear
	sAlgorithm	$03
	sFeedback	$06
	sDetune		$00, $00, $01, $00
	sMultiple	$00, $00, $01, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1B, $1F, $1F, $12
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$10, $1D, $1F, $1F
	sDecay2Rate	$14, $00, $19, $00
	sDecay1Level	$01, $00, $00, $00
	sReleaseRate	$01, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$16, $01, $00, $00
	sFinishVoice

	sNewVoice	MickeyAss1
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$00, $06, $06, $04
	sMultiple	$01, $01, $00, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1C, $1F, $1F, $10
	sDecay2Rate	$10, $0C, $08, $00
	sDecay1Level	$01, $00, $01, $01
	sReleaseRate	$0B, $0C, $0A, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$10, $1B, $00, $01
	sFinishVoice

	sNewVoice	MickeyAss2
	sAlgorithm	$00
	sFeedback	$06
	sDetune		$04, $02, $01, $06
	sMultiple	$0C, $00, $06, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1E, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $1F
	sDecay2Rate	$09, $0A, $0E, $00
	sDecay1Level	$01, $01, $01, $00
	sReleaseRate	$0B, $0C, $0A, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $0C, $1A, $01
	sFinishVoice

	sNewVoice	Raid
	sAlgorithm	$04
	sFeedback	$02
	sDetune		$04, $00, $00, $00
	sMultiple	$08, $03, $02, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$11, $0A, $00, $00
	sDecay2Rate	$00, $00, $05, $05
	sDecay1Level	$0F, $0F, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$02, $10, $00, $00
	sFinishVoice

	sNewVoice	FireShow
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$07, $00, $00, $02
	sMultiple	$0E, $00, $02, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1D, $1F, $15, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $0A, $1C, $1F
	sDecay2Rate	$04, $08, $09, $05
	sDecay1Level	$01, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$19, $15, $10, $03
	sFinishVoice

	sNewVoice	FireShot
	sAlgorithm	$02
	sFeedback	$07
	sDetune		$02, $01, $03, $03
	sMultiple	$01, $00, $01, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1B, $1C, $11, $16
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$14, $1F, $1F, $1F
	sDecay2Rate	$02, $06, $0E, $00
	sDecay1Level	$03, $00, $01, $00
	sReleaseRate	$0F, $09, $0A, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$15, $12, $00, $04
	sFinishVoice

	sNewVoice	Squeak
	sAlgorithm	$03
	sFeedback	$01
	sDetune		$07, $03, $07, $01
	sMultiple	$0D, $03, $0A, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1D, $1D, $1C, $1D
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $01, $0D, $08
	sDecay2Rate	$00, $01, $02, $01
	sDecay1Level	$00, $08, $01, $06
	sReleaseRate	$00, $00, $00, $00
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1E, $17, $12, $00
	sFinishVoice

	sNewVoice	Signal
	sAlgorithm	$02
	sFeedback	$03
	sDetune		$07, $02, $03, $06
	sMultiple	$05, $00, $00, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1B, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1A, $1C, $1F
	sDecay2Rate	$08, $09, $10, $00
	sDecay1Level	$01, $00, $00, $00
	sReleaseRate	$07, $0E, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$07, $10, $16, $02
	sFinishVoice

	sNewVoice	Electro1
	sAlgorithm	$01
	sFeedback	$00
	sDetune		$00, $0F, $0B, $04
	sMultiple	$01, $0C, $00, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $06, $04, $1F
	sDecay2Rate	$0B, $10, $10, $0F
	sDecay1Level	$00, $0F, $0F, $00
	sReleaseRate	$0F, $0F, $0F, $05
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$19, $28, $00, $00
	sFinishVoice

	sNewVoice	Electro2
	sAlgorithm	$01
	sFeedback	$00
	sDetune		$07, $00, $03, $01
	sMultiple	$00, $00, $00, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $07, $0B, $01
	sDecay2Rate	$08, $09, $01, $01
	sDecay1Level	$0C, $0F, $01, $0F
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$04, $02, $03, $06
	sFinishVoice

	sNewVoice	Bounce4
	sAlgorithm	$05
	sFeedback	$00
	sDetune		$00, $07, $03, $00
	sMultiple	$07, $02, $02, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1D, $1D, $1D, $1D
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $00, $00, $00
	sDecay2Rate	$0A, $09, $09, $08
	sDecay1Level	$02, $00, $00, $00
	sReleaseRate	$01, $00, $01, $00
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $0E, $0E, $0E
	sFinishVoice

	sNewVoice	HurtFire
	sAlgorithm	$01
	sFeedback	$07
	sDetune		$03, $00, $07, $00
	sMultiple	$01, $00, $02, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1B, $1F, $15, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $17
	sDecay2Rate	$05, $08, $0D, $00
	sDecay1Level	$01, $00, $01, $00
	sReleaseRate	$07, $0F, $0C, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1F, $1C, $11, $00
	sFinishVoice

	sNewVoice	Attachment1
	sAlgorithm	$02
	sFeedback	$06
	sDetune		$03, $01, $06, $00
	sMultiple	$03, $00, $0F, $03
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1C, $11
	sDecay2Rate	$12, $0D, $13, $00
	sDecay1Level	$01, $01, $02, $00
	sReleaseRate	$0F, $0F, $0F, $0A
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $18, $09, $00
	sFinishVoice

	sNewVoice	Attachment2
	sAlgorithm	$02
	sFeedback	$02
	sDetune		$00, $04, $07, $00
	sMultiple	$01, $00, $07, $0F
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1E, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$0F, $0F, $0C, $1F
	sDecay2Rate	$1B, $05, $1B, $00
	sDecay1Level	$00, $00, $01, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$1C, $10, $1B, $00
	sFinishVoice

	sNewVoice	v00
	sAlgorithm	$05
	sFeedback	$07
	sDetune		$01, $03, $07, $00
	sMultiple	$0E, $0F, $0D, $0C
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $1F
	sDecay2Rate	$10, $00, $00, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0E, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$0E, $0C, $0B, $0C
	sFinishVoice

	sNewVoice	v01
	sAlgorithm	$04
	sFeedback	$07
	sDetune		$07, $01, $02, $03
	sMultiple	$05, $09, $04, $00
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $15, $1F, $1F
	sDecay2Rate	$0F, $01, $00, $00
	sDecay1Level	$00, $02, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$08, $14, $00, $04
	sFinishVoice

	sNewVoice	v02
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $02, $02, $06
	sMultiple	$02, $02, $00, $04
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$1F, $1F, $1F, $1F
	sDecay2Rate	$1B, $10, $10, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$21, $06, $14, $04
	sFinishVoice

	sNewVoice	LaserBeam
	sAlgorithm	$00
	sFeedback	$07
	sDetune		$00, $03, $03, $00
	sMultiple	$01, $03, $03, $02
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1F, $1F, $1F
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$11, $10, $00, $00
	sDecay2Rate	$00, $00, $00, $06
	sDecay1Level	$0F, $01, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$00, $10, $13, $03
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

	sNewVoice	MechaSonic
	sAlgorithm	$03
	sFeedback	$06
	sDetune		$00, $01, $00, $03
	sMultiple	$00, $00, $00, $01
	sRateScale	$00, $00, $00, $00
	sAttackRate	$1F, $1D, $1E, $0E
	sAmpMod		$00, $00, $00, $00
	sDecay1Rate	$00, $0C, $1D, $00
	sDecay2Rate	$00, $00, $01, $00
	sDecay1Level	$00, $00, $00, $00
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG		$00, $00, $00, $00
	sTotalLevel	$08, $06, $07, $00
	sFinishVoice

	sNewVoice	Magic
	sAlgorithm		$06
	sFeedback		$06
	sDetune			$01, $00, $00, $00
	sMultiple		$01, $03, $00, $03
	sRateScale		$00, $00, $00, $00
	sAttackRate		$1F, $1F, $1F, $1F
	sAmpMod			$00, $00, $00, $00
	sDecay1Rate		$10, $0C, $0C, $0C
	sDecay2Rate		$0B, $10, $1F, $05
	sDecay1Level	$01, $04, $02, $02
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG			$00, $00, $00, $00
	sTotalLevel		$09, $12, $04, $0E
	sFinishVoice
	
	sNewVoice	Heart
	sAlgorithm		$04
	sFeedback		$01
	sDetune			$01, $00, $02, $04	
	sMultiple		$01, $01, $01, $01
	sRateScale		$00, $00, $00, $00
	sAttackRate		$12, $1A, $1E, $1C
	sAmpMod			$00, $00, $00, $00
	sDecay1Rate		$1D, $12, $0B, $0B
	sDecay2Rate		$10, $01, $0F, $0F
	sDecay1Level	$02, $02, $01, $01
	sReleaseRate	$0F, $0F, $0F, $0F
	sSSGEG			$00, $00, $00, $00
	sTotalLevel		$07, $18, $00, $00
	sFinishVoice

	sNewVoice	Magnet
	sAlgorithm     $04
	sFeedback      $07
	sDetune        $00, $00, $00, $00
	sMultiple    $01, $0A, $06, $0E
	sRateScale     $00, $00, $00, $00
	sAttackRate    $16, $1C, $0F, $10
	sAmpMod        $00, $00, $00, $00
	sDecay1Rate    $0E, $11, $11, $11
	sDecay2Rate    $09, $06, $0A, $0A
	sDecay1Level    $04, $03, $03, $03
	sReleaseRate   $0F, $0F, $0F, $0F
	sSSGEG			$00, $00, $00, $00
	sTotalLevel    $17, $20, $00, $00
	sFinishVoice

	sNewVoice	Fall
	sAlgorithm     	$06
	sFeedback      	$00
	sDetune        	$00, $00, $00, $00
	sMultiple    	$00, $09, $09, $09
	sRateScale     	$00, $00, $00, $00
	sAttackRate    	$1F, $0D, $0D, $0D
	sAmpMod        	$00, $00, $00, $00
	sDecay1Rate    	$00, $00, $00, $00
	sDecay2Rate    	$00, $00, $00, $00
	sDecay1Level    $00, $00, $00, $00
	sReleaseRate   	$0F, $0F, $0F, $0F
	sSSGEG			$00, $00, $00, $00
	sTotalLevel    	$20, $00, $00, $00
	sFinishVoice

	sNewVoice	RocketLaunch
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

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

Bosses_Vib:
	sVibrato SpikeAttack,	$00, $00, $07C0, $02AD, Triangle
	sVibrato Electro2,	$01, $00, $5554, $0099, Triangle
	sVibrato HurtFire,	$00, $00, $2490, $03E5, Triangle
	sVibrato HitBoss,	$01, $00, $8000, $0028, Triangle
	sVibrato Magic,		$01, $00, $00F4, $114C, Triangle
	sVibrato Magnet,	$01, $00, $2490, $002E, Sine

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

Bosses_Env:
	sEnvelope v07,		Player_Env_v07



; ===========================================================================
; ---------------------------------------------------------------------------
; RocketLaunch
; ---------------------------------------------------------------------------

	sSong		sfx index=$18 flags=v priority=$80
	sChannel	FM5, RocketLaunch_FM5
	sChannel	PSG3, RocketLaunch_PSG3
	sChannel	PSG4, RocketLaunch_PSG4
	sChannelEnd

RocketLaunch_FM5:

	sVoice		RocketLaunch
	sPan		center
	sPortaSpeed	$0400
	sPortaTarget	nC0, $00
	sVol		$02
	sNote		nGs7, $07
	sStop

RocketLaunch_PSG3:
	sNote		nCut, $07
	sVol		$7F
	sPortaSpeed	$0080
	sPortaTarget	nC5, $00
	sNote		nAs5, $4F
	sStop

RocketLaunch_PSG4:
	sNote		nCut, $07
	sVolEnv		v07
	sNote		nWhite40, $4F
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Fall
; ---------------------------------------------------------------------------

	sSong		sfx index=$17 flags=v priority=$80
	sChannel	FM5, Fall_FM5
	sChannelEnd

; FM5 Data
Fall_FM5:
	sVoice		Fall
	sVol 	$8
	sCall	$0C, .loop
	sStop

.loop:
	sNote	nCs3, $03
	sFrac -$100
	sVol      $02
	sRet
	
; ===========================================================================
; ---------------------------------------------------------------------------
; Magnet
; ---------------------------------------------------------------------------

	sSong		sfx index=$16 flags=v priority=$80
	sChannel	FM5, Magnet_FM5
	sChannelEnd


Magnet_FM5:
	sVoice		Magnet
	sVibratoSet	Magnet
	sNote	nG1, $36
	sStop


; ===========================================================================
; ---------------------------------------------------------------------------
; Heart
; ---------------------------------------------------------------------------

	sSong		sfx index=$15 flags=v priority=$80
	sChannel	FM4, Heart_FM4
	sChannelEnd


Heart_FM4:
	sVoice		Heart
	sPortaTarget	nC0, $00
	sPortaSpeed	-$007A
	sNote	nG1, $0B, nRst, $04
	sPortaTarget	nC0, $00
	sPortaSpeed	-$007A
	sNote	nG1, $0B, nRst, $50
	sStop


; ===========================================================================
; ---------------------------------------------------------------------------
; MAGIC
; ---------------------------------------------------------------------------

	sSong		sfx index=$14 flags=v priority=$80
	sChannel	FM5, Magic_FM5
	sChannel	FM4, Magic_FM4
	sChannelEnd

Magic_FM5:
	sVoice        Magic
	sNote	nRst, $04
	sVol	$B
	sCall 	$01, Magic_00

Magic_FM4:
	sVoice        Magic
	sVol	$C

Magic_00:
	sVibratoSet	Magic
	sCall	$05, .loop1	
	sCall	$05, .loop2
	sStop

.loop1:
	sNote	nC1, $06, nD1, nE1, nFs1
	sFrac	$566
	sVol	$FE
	sRet

.loop2:
	sNote	nC1, $06
	sVol	$05
	sRet
	

; ===========================================================================
; ---------------------------------------------------------------------------
; MechaSonic
; ---------------------------------------------------------------------------

	sSong		sfx index=$13 flags=v priority=$80
	sChannel	FM5, MechaSonic_FM5
	sChannelEnd

MechaSonic_FM5:
	sVoice		MechaSonic
	sPan		center
	sNote		freq(FM5. $2C3C), $24
	sCall		$08, .loop
	sStop

.loop
	sNote		sTie, freq(FM5. $2C3C), $04
	sVol		$04
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; HitBoss
; ---------------------------------------------------------------------------

	sSong		sfx index=$12 flags=v priority=$80
	sChannel	FM5, HitBoss_FM5
	sChannelEnd

HitBoss_FM5:
	sVoice		HitBoss
	sVibratoSet	HitBoss
	sPan		center
	sCall		$04, HitBoss_Loop00
	sStop

HitBoss_Loop00:
	sNote		nC0, $0A
	sVol		$10
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; LaserBeam
; ---------------------------------------------------------------------------

	sSong		sfx index=$11 flags=v priority=$80
	sChannel	FM4, LaserBeam_FM2
	sChannel	PSG3, LaserBeam_PSG3
	sChannel	PSG4, LaserBeam_PSG4
	sChannelEnd

LaserBeam_FM2:
	sVoice		LaserBeam
	sPortaSpeed	-$0027
	sPortaTarget	nC7, $00
	sNote		nC1, $50
	sStop

LaserBeam_PSG3:
	sVol		$7F
	sNote		nDs6, $58
	sStop

LaserBeam_PSG4:
	sNote		nWhitePSG3, $08
	sCall		$0A, LaserBeam_Loop00
	sStop

LaserBeam_Loop00:
	sNote		sHold, $08
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Activation
; ---------------------------------------------------------------------------

	sSong		sfx index=$10 flags=v priority=$80
	sChannel	FM4, Activation_FM4
	sChannel	FM5, Activation_FM5
	sChannel	PSG3, Activation_PSG3
	sChannel	PSG4, Activation_PSG4
	sChannelEnd

Activation_FM4:
	sVoice		v00
	sPan		center
	sNote		nB3, $03
	sNote		nRst, $01

	sVoice		v01
	sPortaTarget	nC0, $00
	sPortaSpeed	$003D
	sCall		$08, Activation_Loop01
	sStop

Activation_Loop01:
	sNote		nG2, $0B
	sVol		$04
	sRet

Activation_FM5:
	sVoice		v02
	sPan		center
	sNote		nF0, $03
	sNote		nRst, $01
	sCall		$08, Activation_Loop00
	sStop

Activation_Loop00:
	sNote		nC1, $0B
	sVol		$04
	sRet

Activation_PSG3:
	sVol		$7F
	sNote		nC3, $03
	sNote		nCut, $01

	sPortaTarget	nC0, $00
	sPortaSpeed	-$0009
	sCall		$08, Activation_Loop02
	sStop

Activation_Loop02:
	sNote		nG5, $0B
	sRet

Activation_PSG4:
	sNote		nWhitePSG3, $03
	sNote		nCut, $01
	sCall		$08, Activation_Loop03
	sStop

Activation_Loop03:
	sNote		nWhitePSG3, $0B
	sVol		$08
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Attachment
; ---------------------------------------------------------------------------

	sSong		sfx index=$0F flags=v priority=$80
	sChannel	FM4, Attachment_FM4
	sChannelEnd

Attachment_FM4:
	sVoice		Attachment1
	sPan		center
	sNote		nAs0, $04
	sNote		nRst, $01

	sVoice		Attachment2
	sCall		$03, Attachment_Loop00
	sStop

Attachment_Loop00:
	sNote		nC0, $07
	sVol		$0E
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; HurtFire
; ---------------------------------------------------------------------------

	sSong		sfx index=$0E flags=v priority=$80
	sChannel	FM5, HurtFire_FM5
	sChannelEnd

HurtFire_FM5:
	sVoice		HurtFire
	sVibratoSet	HurtFire
	sPan		center
	sNote		nD1, $04
	sNote		nRst, $01
	sNote		nCs2, $14
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Bounce
; ---------------------------------------------------------------------------

	sSong		sfx index=$0D flags=v priority=$80
	sChannel	FM5, Bounce_FM5
	sChannelEnd

Bounce_FM5:
	sVoice		Bounce4
	sPan		center
	sNote		nD1, $06
	sCall		$01, Bounce_FM5_00
	sVol		$09
	sNote		nD1, $02
	sCall		$01, Bounce_FM5_00
	sStop

Bounce_FM5_00:
	sFrac		$0035		; ssDetune $09
	sNote		sHold, $01
	sFrac		$003C		; ssDetune $13
	sNote		sHold, $01
	sFrac		-$00E8		; ssDetune $EC
	sNote		sHold, nDs1
	sFrac		$003C		; ssDetune $F6
	sNote		sHold, $01
	sFrac		$003B		; ssDetune $00
	sNote		sHold, $01
	sFrac		-$0038		; ssDetune $F7
	sNote		sHold, nE1
	sFrac		$0038		; ssDetune $00
	sNote		sHold, $01
	sNote		nRst, $04
	sRet
; ===========================================================================
; ---------------------------------------------------------------------------
; Electro2
; ---------------------------------------------------------------------------

	sSong		sfx index=$0C flags=v priority=$80
	sChannel	FM5, Electro2_FM5
	sChannelEnd

Electro2_FM5:
	sVoice		Electro2
	sVibratoSet	Electro2
	sPan		center
	sNote		nD3, $2C
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Electro1
; ---------------------------------------------------------------------------

	sSong		sfx index=$07 flags=v priority=$80
	sChannel	FM5, Electro1_FM5
	sChannelEnd

Electro1_FM5:
	sVoice		Electro1
	sPan		center
	sNote		nF2, $10
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Raid
; ---------------------------------------------------------------------------

	sSong		sfx index=$0B flags=v priority=$80
	sChannel	FM5, Raid_FM5
	sChannelEnd

Raid_FM5:
	sVoice		Raid
	sPan		center
	sNote		nD0, $0D
	sCall		$04, Raid_Loop00
	sStop

Raid_Loop00:
	sNote		nD0, $0D
	sVol		$15
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; MickeyAss
; ---------------------------------------------------------------------------

	sSong		sfx index=$0A flags=v priority=$80
	sChannel	FM5, MickeyAss_FM5
	sChannelEnd

MickeyAss_FM5:
	sVoice		MickeyAss1
	sPan		center
	sNote		nG0, $05
	sVoice		MickeyAss2
	sCall		$06, MickeyAss_Loop00
	sStop

MickeyAss_Loop00:
	sNote		nB1, $0A
	sVol		$06
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Signal
; ---------------------------------------------------------------------------

	sSong		sfx index=$09 flags=v priority=$80
	sChannel	FM5, Signal_FM5
	sChannelEnd

Signal_FM5:
	sVoice		Signal
	sPan		center
	sCall		$05, Signal_Loop00
	sStop

Signal_Loop00:
	sNote		nCs3, $0C
	sVol		$06
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Squeak
; ---------------------------------------------------------------------------

	sSong		sfx index=$08 flags=v priority=$80
	sChannel	FM5, Squeak_FM5
	sChannelEnd

Squeak_FM5:
	sVoice		Squeak
	sVol		$07
	sPan		center
	sNote		nB5, $01
	sNote		nB5

	sFrac		$0003		; ssDetune $01
	sNote		nB5, $01
	sFrac		$000B		; ssDetune $04
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $07
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $09
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $0F
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $12
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $15
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $18
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $1B
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $1D
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $20
	sNote		sHold, $01
	sFrac		-$0070		; ssDetune $00

	sNote		nRst, $02

	sFrac		$000D		; ssDetune $02
	sNote		nC6, $01
	sFrac		$0007		; ssDetune $03
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $06
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $09
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $0F
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$0072		; ssDetune $00

	sNote		nRst, $02

	sNote		nB5, $01
	sFrac		$0007		; ssDetune $02
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $08
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $13
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $16
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $19
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $1C
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $1F
	sNote		sHold, $01
	sFrac		-$006C		; ssDetune $00

	sNote		nRst, $02

	sFrac		$000C		; ssDetune $02
	sNote		nCs6, $01
	sFrac		$0006		; ssDetune $03
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $05
	sNote		sHold, $01
	sFrac		$000C		; ssDetune $07
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $08
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $0A
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $0D
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$000C		; ssDetune $10
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$006A		; ssDetune $00

	sNote		nRst, $02

	sNote		nB5, $01
	sFrac		$0007		; ssDetune $02
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $08
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $13
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $16
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $19
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $1C
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $1F
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $22
	sNote		sHold, $01
	sFrac		-$0077		; ssDetune $00

	sNote		nRst, $02

	sNote		nC6, $01
	sFrac		$0006		; ssDetune $01
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $02
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $04
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $05
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $07
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $08
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0A
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $0D
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $10
	sNote		sHold, $01
	sFrac		-$006B		; ssDetune $00

	sNote		nRst, $02

	sNote		nB5, $01
	sFrac		$0003		; ssDetune $01
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $04
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $07
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $09
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $0F
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $12
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $15
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $18
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $1B
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $1D
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $20
	sNote		sHold, $01
	sFrac		-$0070		; ssDetune $00

	sNote		nRst, $02

	sNote		nCs6, $01
	sFrac		$0006		; ssDetune $01
	sNote		sHold, $01
	sFrac		$000C		; ssDetune $03
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $04
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $06
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $07
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $09
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0A
	sNote		sHold, $01
	sFrac		$000C		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0F
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $12
	sNote		sHold, $01
	sFrac		-$0070		; ssDetune $00

	sNote		nRst
	sVol		$04

	sNote		nB5, $02
	sFrac		$0007		; ssDetune $02
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $08
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $13
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $16
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $19
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $1C
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $1F
	sNote		sHold, $01
	sFrac		-$006C		; ssDetune $00

	sNote		nRst, $02
	sVol		$02

	sFrac		$000D		; ssDetune $02
	sNote		nC6, $01
	sFrac		$0007		; ssDetune $03
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $06
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $09
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $0F
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $11
	sNote		sHold, $01
	sFrac		-$0072		; ssDetune $00

	sNote		nRst, $02
	sVol		$05

	sNote		nB5, $01
	sFrac		$0007		; ssDetune $02
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $05
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $08
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $11
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $13
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $16
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $19
	sNote		sHold, $01
	sFrac		$000B		; ssDetune $1C
	sNote		sHold, $01
	sFrac		$000A		; ssDetune $1F
	sNote		sHold, $01
	sFrac		-$006C		; ssDetune $00

	sNote		nRst, $02
	sVol		$05

	sFrac		$000D		; ssDetune $02
	sNote		nC6, $01
	sFrac		$0007		; ssDetune $03
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $05
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $06
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $08
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $09
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0B
	sNote		sHold, $01
	sFrac		$0006		; ssDetune $0C
	sNote		sHold, $01
	sFrac		$000E		; ssDetune $0E
	sNote		sHold, $01
	sFrac		$0007		; ssDetune $0F
	sNote		sHold, $01
	sFrac		$000D		; ssDetune $11
	sNote		sHold, $01
	sStop


; ===========================================================================
; ---------------------------------------------------------------------------
; FireShot
; ---------------------------------------------------------------------------

	sSong		sfx index=$06 flags=v priority=$80
	sChannel	FM5, FireShot_FM5
	sChannelEnd

FireShot_FM5:
	sVoice		FireShot
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	$0099
	sNote		nB0, $12
	sVol		$1A
	sNote		nB0, $12
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FireShow
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=v priority=$80
	sChannel	FM5, FireShow_FM5
	sChannelEnd

FireShow_FM5:
	sVoice		FireShow
	sPan		center
	sPortaTarget	nC0, $00
	sPortaSpeed	-$006F
	sNote		nE1, $1D
	sVol		$20
	sNote		nE1, $1D
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Tear
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	FM5, Tear_FM5
	sChannelEnd

Tear_FM5:
	sVoice		Tear
	sPan		center
	sPortaSpeed	$007C
	sPortaTarget	nC0, $00
	sNote		nB0, $04
	sCall		$0C, Tear_Loop00
	sStop

Tear_Loop00:
	sNote		nAs0, $06
	sVol		$01
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Boom
; ---------------------------------------------------------------------------

	sSong		sfx index=$03 flags=v priority=$80
	sChannel	FM5, Boom_FM5
	sChannelEnd

Boom_FM5:
	sVoice		Boom
	sPortaTarget	nC7, $00
	sPortaSpeed	-$0067
	sPan		center
	sCall		$03, .loop
	sStop

.loop
	sNote		nCs1, $18
	sVol		$0E
	sRet

; ===========================================================================
; ---------------------------------------------------------------------------
; Arthur2
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=v priority=$80
	sChannel	FM5, Arthur2_FM5
	sChannelEnd

Arthur2_FM5:
	sVoice		Arthur2
	sPan		center
	sNote		nCs2, $04
	sNote		nRst, $01
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Arthur1
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	FM5, Arthur1_FM5
	sChannel	FM4, Arthur1_FM4
	sChannelEnd

Arthur1_FM5:
	sVol		$04
	sFrac		-$0C00

Arthur1_FM4:
	sVoice		Arthur1
	sFrac		$003E		; ssDetune $0A
	sPan		center
	sNote		nCs6, $09
	sNote		nRst, $0B
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; SpikeAttack
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	FM5, SpikeAttack_FM5
	sChannelEnd

SpikeAttack_FM5:
	sNote		nRst, $01
	sVoice		SpikeAttack
	sVibratoSet	SpikeAttack
	sPan		center
	sCall		$03, SpikeAttack_Loop00
	sStop

SpikeAttack_Loop00:
	sNote		nC1, $0B
	sVol		$0A
	sRet



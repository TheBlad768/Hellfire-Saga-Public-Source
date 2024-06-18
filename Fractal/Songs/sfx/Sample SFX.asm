; ===========================================================================
; ---------------------------------------------------------------------------
; Header
; ---------------------------------------------------------------------------

	ASMCMP v0.11	style=Fractal
	sHeaderVoice	SampleSFX_Voice
	sHeaderSamples	SampleSFX_Samples
	sHeaderVibrato	SampleSFX_Vib
	sHeaderEnvelope	SampleSFX_Env
	sHeaderEnd

; ===========================================================================
; ---------------------------------------------------------------------------
; Envelopes - must be aligned
; ---------------------------------------------------------------------------

SampleSFX_Env:

; ===========================================================================
; ---------------------------------------------------------------------------
; Vibrato - must be aligned
; ---------------------------------------------------------------------------

SampleSFX_Vib:

; ===========================================================================
; ---------------------------------------------------------------------------
; FM Voices - must be aligned
; ---------------------------------------------------------------------------

SampleSFX_Voice:

; ===========================================================================
; ---------------------------------------------------------------------------
; Samples - must be aligned
; ---------------------------------------------------------------------------

SampleSFX_Samples:
	sNewSample	AstarothDeath
	sSampFreq	$0100
	sSampStart	dsAstarothDeath, deAstarothDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	ArcherArmorAtk
	sSampFreq	$0100
	sSampStart	dsArcherArmorAtk, deArcherArmorAtk
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	AxeGhostDeath
	sSampFreq	$0100
	sSampStart	dsAxeGhostDeath, deAxeGhostDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	BossFlame
	sSampFreq	$0100
	sSampStart	dsBossFlame, deBossFlame
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	CryPCM
	sSampFreq	$0100
	sSampStart	dsCryPCM, deCryPCM
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	GhostDeath
	sSampFreq	$0100
	sSampStart	dsGhostDeath, deGhostDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	GhoulDeath
	sSampFreq	$0100
	sSampStart	dsGhoulDeath, deGhoulDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	GluttonySpew
	sSampFreq	$0100
	sSampStart	dsGluttonySpew, deGluttonySpew
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	FireAtkFire
	sSampFreq	$0100
	sSampStart	dsFireAtkFire, deFireAtkFire
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	FireShield
	sSampFreq	$0100
	sSampStart	dsFireShield, deFireShield
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	FireHurt
	sSampFreq	$0100
	sSampStart	dsFireHurt, deFireHurt
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	FireDeath
	sSampFreq	$0100
	sSampStart	dsFireDeath, deFireDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	HoneyDeath
	sSampFreq	$0100
	sSampStart	dsHoneyDeath, deHoneyDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	HoneyHurt
	sSampFreq	$0100
	sSampStart	dsHoneyHurt, deHoneyHurt
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample


	sNewSample	HeadlissAtk
	sSampFreq	$0100
	sSampStart	dsHeadlissAtk, deHeadlissAtk
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Mwahaha
	sSampFreq	$0100
	sSampStart	dsMwahaha, deMwahaha
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	ShaftAttack
	sSampFreq	$0100
	sSampStart	dsShaftAttack, deShaftAttack
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	RainPCM
	sSampFreq	$0100
	sSampStart	dsRainPCM_S, deRainPCM_S
	sSampLoop	dsRainPCM, deRainPCM
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	PhantomHand
	sSampFreq	$0100
	sSampStart	dsPhantomHand, dePhantomHand
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	ShaftDeath
	sSampFreq	$0100
	sSampStart	dsShaftDeath, deShaftDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	ShaftAttack2
	sSampFreq	$0100
	sSampStart	dsShaftAttack2, deShaftAttack2
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	ShaftAttack3
	sSampFreq	$0100
	sSampStart	dsShaftAttack3, deShaftAttack3
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	UMK3PCM
	sSampFreq	$0100
	sSampStart	dsUMK3PCM, deUMK3PCM
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	ThunderLightning
	sSampFreq	$0100
	sSampStart	dsThunderLightning, deThunderLightning
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Thunderclamp
	sSampFreq	$0100
	sSampStart	dsThunderclamp, deThunderclamp
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	WolfJump
	sSampFreq	$0100
	sSampStart	dsWolfJump, deWolfJump
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	WolfDeath
	sSampFreq	$0100
	sSampStart	dsWolfDeath, deWolfDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	WolfAwoo
	sSampFreq	$0100
	sSampStart	dsWolfAwoo, deWolfAwoo
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	WindHowl
	sSampFreq	$0100
	sSampStart	dsWindHowl, deWindHowl
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	WeaselDeath
	sSampFreq	$0100
	sSampStart	dsWeaselDeath, deWeaselDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	WalkingArmorAtk
	sSampFreq	$0100
	sSampStart	dsWalkingArmorAtk, deWalkingArmorAtk
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	MechaDemon
	sSampFreq	$0100
	sSampStart	dsMechaDemon, deMechaDemon
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	DeathWounded
	sSampFreq	$0100
	sSampStart	dsDeathWounded, deDeathWounded
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

	sNewSample	Phantom
	sSampFreq	$0100
	sSampStart	dsPhantom, dePhantom
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample
	
	sNewSample	GluttonyDeath
	sSampFreq	$0100
	sSampStart	dsGluttonyDeath, deGluttonyDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample
	
	sNewSample	BatDeath
	sSampFreq	$0100
	sSampStart	dsBatDeath, deBatDeath
	sSampLoop	Null, Null
	sSampRest	Null, Null
	sSampRestLoop	Null, Null
	sFinishSample

; ===========================================================================
; ---------------------------------------------------------------------------
; Bat Death
; ---------------------------------------------------------------------------

	sSong		sfx index=$23 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		BatDeath
	sPan		center
	sNote		nSample, $65
	sStop


; ===========================================================================
; ---------------------------------------------------------------------------
; Gluttony Death
; ---------------------------------------------------------------------------

	sSong		sfx index=$22 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		GluttonyDeath
	sPan		center
	sNote		nSample, $65
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Phantom
; ---------------------------------------------------------------------------

	sSong		sfx index=$21 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		Phantom
	sPan		center
	sNote		nSample, $65
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Death Wounded
; ---------------------------------------------------------------------------

	sSong		sfx index=$20 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		DeathWounded
	sPan		center
	sNote		nSample, $65
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; MechaDemon
; ---------------------------------------------------------------------------

	sSong		sfx index=$1F flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		MechaDemon
	sPan		center
	sNote		nSample, $65
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; WalkingArmorAtk
; ---------------------------------------------------------------------------

	sSong		sfx index=$1E flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		WalkingArmorAtk
	sPan		center
	sNote		nSample, $65
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; WeaselDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$1D flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		WeaselDeath
	sPan		center
	sNote		nSample, $24
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; WolfAwoo
; ---------------------------------------------------------------------------

	sSong		sfx index=$1C flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		WolfAwoo
	sPan		center
	sNote		nSample, $80
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; WolfDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$1B flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		WolfDeath
	sPan		center
	sNote		nSample, $20
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; WolfJump
; ---------------------------------------------------------------------------

	sSong		sfx index=$1A flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		WolfJump
	sPan		center
	sNote		nSample, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Thunderclamp
; ---------------------------------------------------------------------------

	sSong		sfx index=$19 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		Thunderclamp
	sPan		center
	sNote		nSample, $60
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; ThunderLightning
; ---------------------------------------------------------------------------

	sSong		sfx index=$18 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		ThunderLightning
	sPan		center
	sNote		nSample, $D8
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; UMK3PCM
; ---------------------------------------------------------------------------

	sSong		sfx index=$17 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		UMK3PCM
	sPan		center
	sNote		nSample, $88
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; ShaftAttack3
; ---------------------------------------------------------------------------

	sSong		sfx index=$16 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		ShaftAttack3
	sPan		center
	sNote		nSample, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; ShaftAttack2
; ---------------------------------------------------------------------------

	sSong		sfx index=$15 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		ShaftAttack2
	sPan		center
	sNote		nSample, $3E
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; ShaftDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$14 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		ShaftDeath
	sPan		center
	sNote		nSample, $68
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; PhantomHand
; ---------------------------------------------------------------------------

	sSong		sfx index=$13 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		PhantomHand
	sPan		center
	sNote		nSample, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; RainPCM
; ---------------------------------------------------------------------------

	sSong		sfx index=$12 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		RainPCM
	sPan		center
	sNote		nSample, $DB, sTie, $00, sTie, $00
.loop:
	sNote		sTie, $DB
	sJump		.loop

; ===========================================================================
; ---------------------------------------------------------------------------
; ShaftAttack
; ---------------------------------------------------------------------------

	sSong		sfx index=$11 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		ShaftAttack
	sPan		center
	sNote		nSample, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; Mwahaha
; ---------------------------------------------------------------------------

	sSong		sfx index=$10 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		Mwahaha
	sPan		center
	sNote		nSample, $74
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; HoneyHurt
; ---------------------------------------------------------------------------

	sSong		sfx index=$0F flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		HoneyHurt
	sPan		center
	sNote		nSample, $22
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; HeadlissAtk
; ---------------------------------------------------------------------------

	sSong		sfx index=$0E flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		HeadlissAtk
	sPan		center
	sNote		nSample, $09
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; HoneyDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$0D flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		HoneyDeath
	sPan		center
	sNote		nSample, $38
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FireShield
; ---------------------------------------------------------------------------

	sSong		sfx index=$0C flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		FireShield
	sPan		center
	sNote		nSample, $32
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FireDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$0B flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		FireDeath
	sPan		center
	sNote		nSample, $68
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FireHurt
; ---------------------------------------------------------------------------

	sSong		sfx index=$0A flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		FireHurt
	sPan		center
	sNote		nSample, $22
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; FireAtkFire
; ---------------------------------------------------------------------------

	sSong		sfx index=$09 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		FireAtkFire
	sPan		center
	sNote		nSample, $34
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; GluttonySpew
; ---------------------------------------------------------------------------

	sSong		sfx index=$08 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		GluttonySpew
	sPan		center
	sNote		nSample, $74
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; GhoulDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$07 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		GhoulDeath
	sPan		center
	sNote		nSample, $38
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; GhostDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$06 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		GhostDeath
	sPan		center
	sNote		nSample, $2E
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; CryPCM
; ---------------------------------------------------------------------------

	sSong		sfx index=$05 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		CryPCM
	sPan		center
	sNote		nSample, $2E
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; BossFlame
; ---------------------------------------------------------------------------

	sSong		sfx index=$04 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		BossFlame
	sPan		center
	sNote		nSample, $30
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; AxeGhostDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$02 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		AxeGhostDeath
	sPan		center
	sNote		nSample, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; ArcherArmorAtk
; ---------------------------------------------------------------------------

	sSong		sfx index=$01 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		ArcherArmorAtk
	sPan		center
	sNote		nSample, $26
	sStop

; ===========================================================================
; ---------------------------------------------------------------------------
; AstarothDeath
; ---------------------------------------------------------------------------

	sSong		sfx index=$00 flags=v priority=$80
	sChannel	DAC2, .dac2
	sChannelEnd

.dac2
	sSample		AstarothDeath
	sPan		center
	sNote		nSample, $48
	sStop

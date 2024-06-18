; ===========================================================================
; ---------------------------------------------------------------------------
; Flags section. None of this is required, but I added it here to
; make it easier to debug built ROMS! If you would like easier
; assistance from Aurora, please keep this section intact!
; ---------------------------------------------------------------------------
	dc.b "AMPS-HFS2"		; ident str

	if safe
		dc.b "s"		; safe mode enabled

	else
		dc.b " "		; safe mode disabled
	endif

	if FEATURE_FM6
		dc.b "F6"		; FM6 enabled
	endif

	if FEATURE_PSG4
		dc.b "P4"		; PSG4 enabled
	endif

	if FEATURE_PSGADSR
		dc.b "PA"		; PSG ADSR enabled
	endif

	if FEATURE_SFX_MASTERVOL
		dc.b "SM"		; sfx ignore master volume
	endif

	if FEATURE_UNDERWATER
		dc.b "UW"		; underwater mode enabled
	endif

	if FEATURE_MODULATION
		dc.b "MO"		; modulation enabled
	endif

	if FEATURE_DACFMVOLENV
		dc.b "VE"		; FM & DAC volume envelope enabled
	endif

	if FEATURE_MODENV
		dc.b "ME"		; modulation envelope enabled
	endif

	if FEATURE_PORTAMENTO
		dc.b "PX"		; portamento enabled
	endif

	if FEATURE_BACKUP
		dc.b "BA"		; backup enabled
	endif

	if FEATURE_MODTL
		dc.b "MT"		; TL modulation
	endif

	if FEATURE_FM3SM
		dc.b "S3"		; FM3 special mode
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Define music and SFX
; ---------------------------------------------------------------------------

	if safe=0
		listings off		; if in safe mode, list data section.
	endif

__mus :=	MusOff

MusicIndex:
	ptrMusic optimize_scz1, $00, optimize_scz2, $00
	ptrMusic FDZ1, $00, FDZ2, $00, FDZ3, $00
	ptrMusic SCZ1, $00, SCZ2, $00, SCZ3, $00
	ptrMusic GMZ1, $00, GMZ2, $00, GMZ3, $00
	ptrMusic ZanBoss, $00, MicroBoss, $00, Boss1, $00, Boss2, $00
	ptrMusic Gloam1, $00, Gloam2, $00
	ptrMusic Eggman1, $00, Eggman2, $00
	ptrMusic Title, $00, Invincible, $00, Lust, $00
	ptrMusic Intro, $00, Ending, $00;, Credits, $00
	ptrMusic Drowning, $00, ArthurDeath, $00, Notice, $00
	ptrMusic Through, $00, Fatality, $00, FatalityEnd, $00
;	ptrMusic Test, $00

MusCount =	__mus-MusOff		; number of installed music tracks
SFXoff =	__mus			; first SFX ID
__sfx :=	SFXoff
mus_Credits =		mus_Invincible
; ---------------------------------------------------------------------------

SoundIndex:
	ptrSFX	$01, RingRight
	ptrSFX	0, RingLeft, RingLoss, Jump, Roll, Skid, SpinDash
	ptrSFX	0, Splash, DrownDing, Drown, Death, HitSpikes, SpikeMove
	ptrSFX	0, FireShield, FireAttack, BubbleShield, BubbleAttack
	ptrSFX	0, LightShield, LightAttack, BlueShield, InstaShield, KnucklesKick
	ptrSFX	0, Teleport, Signpost, Lamppost, BreakItem, Bomb, HitBoss
	ptrSFX	0, BreakWall, BreakBridge, Piff, Pump, Switch, Spring
	ptrSFX	0, Electro, FireBall, FireShow, FireShot, Arthur1, Arthur2
	ptrSFX	0, HurtFire, Tear, Raid, MickeyAss, Bounce, Explosion, Signal
	ptrSFX	0, Start, Boom, Attachment, Squeak, CutDown, PigmanWalk
	ptrSFX	0, ScreenShake, Basaran, LaserBeam, Register, Bumper, Grab
	ptrSFX	0, SuperEmerald, PushBlock, SegaKick, Electro2, Activation, SpikeAttack

	; continous SFX
	ptrSFX	$80, SpikeBall, Shake, SpecialRumble

SFXcount =	__sfx-SFXoff		; number of intalled sound effects
SampleOff =	__sfx
sfx_Ring =		sfx_RingRight
; ---------------------------------------------------------------------------

	; sampled sfx
	ptrSFX	0, DemonShout, GhostDeath, GhoulDeath, FireDeath, Mwahaha
	ptrSFX	0, HoneyDeath, LustDeath, FireHurt, HoneyHurt, LustHurt
	ptrSFX	0, WolfDeath, LegKick, KatanaKick, Bumerang, LSEnter
	ptrSFX	0, RainPCM, CryPCM, UMK3PCM, FireAtkFire, FireAtkWind
	ptrSFX	0, FireRush, AxeGhostDeath, GluttonySpew, AstarothDeath
	ptrSFX	0, WeaselDeath, Interlude, HeadlissAtk, Thunderclamp
	ptrSFX	0, WolfAwoo, WolfJump, SuccubusLaughter, Fire_Shield
	ptrSFX	0, ShaftAttack, ShaftAttack2, ShaftAttack3, ShaftDeath
	ptrSFX	0, ThunderLightning, ArcherArmorAtk, LustHah, BossFlame
	ptrSFX	0, HardLine, WalkingArmorAtk, Raindrop, WindHowl, PhantomHand
        ptrSFX  0, MechaDemon

SampleCount =	__sfx-SampleOff
SFXlast =	__sfx
; ===========================================================================
; ---------------------------------------------------------------------------
; Define samples
; ---------------------------------------------------------------------------

__samp :=	$80
SampleList:
	sample $0000, Stop, Stop			; 80 - Stop sample (DO NOT EDIT)
	sample $0100, KickNew, Stop, Kick		; 81 - Sonic 1 & 2
	sample $0100, SnareNew, Stop, Snare		; 82 - Sonic 1 & 2
	sample $0100, TomNew, Stop, Timpani		; 83 - Sonic 1 & 2
	sample $00E0, TomNew, Stop, Timpani2		; 84 - Sonic 1 & 2
	sample $00C0, TomNew, Stop, Timpani3		; 85 - Sonic 1 & 2
	sample $0080, CrashNew, Stop, Crash		; 86 - Sonic 1 & 2
	sample $0100, CrashNew, Stop, Crash1		; 87 - Sonic 1 & 2
	sample $0100, CrashNew, Stop, Crash2		; 88 - Sonic 1 & 2

	sample $0130, TomNew, Stop, MidTimpani		; 89 - Sonic 1 & 2
	sample $00E0, TomNew, Stop, LowTimpani		; 8A - Sonic 1 & 2
	sample $00C0, TomNew, Stop, VLowTimpani		; 8B - Sonic 1 & 2
	sample $00A0, TomNew, Stop, Timpani7		; 8C - Sonic 1 & 2
	sample $0100, CrashNew, Stop, Crash3		; 8D - Sonic 1 & 2
	sample $0120, TomNew, Stop, Timpani8		; 8E - Sonic 1 & 2
	sample $0100, KickNew, Stop, Kick2		; 8F - Sonic 1 & 2
	sample $0100, SnareNew, Stop, Snare2		; 90 - Sonic 1 & 2
	sample $0100, HatCLD, Stop			; 91 - Sonic 1 & 2
	sample $0100, KickSnareNew, Stop, KickSnare	; 92 - Sonic 1 & 2

	sample $0100, BansheeDeath, Stop, DemonShout	; 93 - Voice
	sample $0100, GhostDeath, Stop			; 94 - Voice
	sample $0100, GhoulDeath, Stop			; 95 - Voice
	sample $0100, FrbrndDeath, Stop, FireDeath	; 96 - Voice/Bosses
	sample $0100, HoneyDeath, Stop			; 97 - Voice/Bosses
	sample $0100, LustDeath, Stop			; 98 - Voice/Bosses
	sample $0100, FrbrndHurt, Stop, FireHurt	; 99 - Voice/Bosses
	sample $0100, HoneyHurt, Stop			; 9A - Voice/Bosses
	sample $0100, LustHurt, Stop			; 9B - Voice/Bosses
	sample $0100, WolfDeath, Stop			; 9C - Voice

	sample $0100, ShinobiLegKick, Stop, LegKick	; 9D - Voice/Bosses
	sample $0100, ShinobiKatanaKick, Stop, KatanaKick; 9E - Voice/Bosses
	sample $0100, PrinPrinBumerang, Stop, Bumerang	; 9F - Voice/Bosses
	sample $0100, LevelSelectEnter, Stop, LSEnter	; A0 - TitleScreen
	sample $0100, MainLogo1, Stop			; A1 - TitleScreen
	sample $0100, MainLogo2, Stop			; A2 - TitleScreen
	sample $0100, MainLogo3, Stop			; A3 - TitleScreen
	sample $0100, MainLogo4, Stop			; A4 - TitleScreen
	sample $0100, ShaoKannLaugh, Stop, Mwahaha	; A5 - TitleScreen

	sample $0100, RainPCM, Stop			; A6 - Voice
	sample $0100, CryPCM, Stop			; A7 - Voice
	sample $0100, UMK3PCM, Stop			; A8 - Voice
	sample $0100, FireAtkFire, Stop			; A9 - Voice/Bosses
	sample $0100, FireAtkWind, Stop			; AA - Voice/Bosses
	sample $0100, FireRush, Stop			; AB - Voice/Bosses

	sample $0100, AxeGhostDeath, Stop		; AC - Voice
	sample $0100, GluttonySpew, Stop		; AD - Voice/Bosses
	sample $0100, AstarothDeath, Stop		; AE - Voice/Bosses
	sample $0100, WeaselDeath, Stop			; AF - Voice
	sample $0100, Interlude, Interlude		; B0 - Voice
	sample $0100, HeadlissAtk, Stop			; B1 - Voice/Bosses
	sample $0100, Thunderclamp, Stop		; B2
	sample $0100, SuccubusLaughter, Stop		; B3 - Voice

	sample $0100, WolfAWoo, Stop			; B4 - Voice/Bosses
	sample $0100, WolfJump, Stop			; B5 - Voice/Bosses
	sample $0100, ShaftAttack, Stop			; B6 - Voice/Bosses
	sample $0100, ShaftAttack2, Stop		; B7 - Voice/Bosses
	sample $0100, ShaftAttack3, Stop		; B8 - Voice/Bosses
	sample $0100, ShaftDeath, Stop			; B9 - Voice/Bosses
	sample $0100, Flame, Stop, BossFlame		; BA - Voice/Bosses
	sample $0100, FireShield, Stop			; BB - Voice/Bosses
	sample $0100, LustHah, Stop			; BC - Voice/Bosses
	sample $0190, HardLine, Stop			; BD - Voice/Bosses
	sample $0100, ThunderLightning, Stop		; BE
	sample $0100, ArcherArmorAtk, Stop		; BF - Voice
	sample $0100, WalkingArmorAtk, Stop		; C0
	sample $0100, Ghost1, Stop			; C1
	sample $0100, Ghost2, Stop			; C2
	sample $0100, Raindrop, Stop			; C3
	sample $0100, WindHowl, Stop			; C4
	sample $0100, PhantomHand, Stop		; C5
	sample $0100, crash_sample, Stop	; C6
	sample $0100, MechaDemon, Stop	; C7
; ===========================================================================
; ---------------------------------------------------------------------------
; Define volume envelopes and their data
; ---------------------------------------------------------------------------

vNone =		$00
__venv :=	$01

VolEnvs:
	volenv 01, 02, 03, 04, 05, 06, 07, 08
	volenv 09, 17, Test, Test2
VolEnvs_End:
; ---------------------------------------------------------------------------

vd01:		dc.b $00, $00, $00, $08, $08, $08, $10, $10
		dc.b $10, $18, $18, $18, $20, $20, $20, $28
		dc.b $28, $28, $30, $30, $30, $38, eHold

vd02:		dc.b $00, $10, $20, $30, $40, $7F, eStop

vd03:		dc.b $00, $00, $08, $08, $10, $10, $18, $18
		dc.b $20, $20, $28, $28, $30, $30, $38, $38
		dc.b eHold

vd04:		dc.b $00, $00, $10, $18, $20, $20, $28, $28
		dc.b $28, $30, eHold

vd05:		dc.b $00, $00, $00, $00, $00, $00, $00, $00
		dc.b $00, $00, $08, $08, $08, $08, $08, $08
		dc.b $08, $08, $08, $08, $08, $08, $08, $08
		dc.b $10, $10, $10, $10, $10, $10, $10, $10
		dc.b $18, $18, $18, $18, $18, $18, $18, $18
		dc.b $20, eHold

vd06:		dc.b $18, $18, $18, $10, $10, $10, $10, $08
		dc.b $08, $08, $00, $00, $00, $00, eHold

vd07:		dc.b $00, $00, $00, $00, $00, $00, $08, $08
		dc.b $08, $08, $08, $10, $10, $10, $10, $10
		dc.b $18, $18, $18, $20, $20, $20, $28, $28
		dc.b $28, $30, $38, eHold

vd08:		dc.b $00, $00, $00, $00, $00, $08, $08, $08
		dc.b $08, $08, $10, $10, $10, $10, $10, $10
		dc.b $18, $18, $18, $18, $18, $20, $20, $20
		dc.b $20, $20, $28, $28, $28, $28, $28, $30
		dc.b $30, $30, $30, $30, $38, $38, $38, eHold

vd09:		dc.b $00, $08, $10, $18, $20, $28, $30, $38
		dc.b $40, $48, $50, $58, $60, $68, $70, $78
		dc.b eHold

; ported from S3K
vd17:		dc.b $08, $00, $00, $00, $00, $08, $08, $08
		dc.b $10, $10, $10, $18, $18, $18, $18, $20
		dc.b $20, $20, $28, $28, eHold

; test
vdTest:		dc.b $00, $00, $00, $04, $04, $02, $02, $02, $04, $04, eReset, $00

; test
vdTest2:	dc.b $00, $08, $10, $18, $20, $18, $08, eLoop
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; Define volume envelopes and their data
; ---------------------------------------------------------------------------

mNone =		$00
__menv :=	$01

ModEnvs:
ModEnvs_End:
; ---------------------------------------------------------------------------

	if FEATURE_MODENV

		even
	endif
; ===========================================================================
; ---------------------------------------------------------------------------
; Include music, sound effects and voice bank
; ---------------------------------------------------------------------------

	include "AMPS/ADSR.s2a"		; include universal ADSR bank
	include "AMPS/Voices.s2a"	; include universal Voice bank
; ---------------------------------------------------------------------------

; include SFX and music
sfxaddr:	incSFX
musaddr:	incMus
musend:
	even

dSoundNames:
	allnames			; include all sound names in an array
; ===========================================================================
; ---------------------------------------------------------------------------
; Include samples and filters
; ---------------------------------------------------------------------------

		align	$8000		; must be aligned to bank. By the way, these are also set in Z80.asm. Be sure to check it out
fLog:		binclude "AMPS/filters/Logarithmic.dat"	; logarithmic filter (no filter)
;fLinear:	binclude "AMPS/filters/Linear.dat"	; linear filter (no filter)

dacaddr:	asdata Z80E_Read*(MaxPitch/$100), $00
SWF_Stop:	asdata $8000-(2*Z80E_Read*(MaxPitch/$100)), $80
SWFR_Stop:	asdata Z80E_Read*(MaxPitch/$100), $00
; ---------------------------------------------------------------------------

	incSWF	KickNew, SnareNew, TomNew, CrashNew, KickSnareNew, HatCLD
	incSWF	BansheeDeath, GhostDeath, GhoulDeath, FrbrndDeath, HoneyDeath
	incSWF	LustDeath, ShaftDeath, AxeGhostDeath, AstarothDeath, WeaselDeath
	incSWF	FrbrndHurt, HoneyHurt, LustHurt, WolfAWoo, WolfJump, SuccubusLaughter
	incSWF	ShinobiLegKick, ShinobiKatanaKick, PrinPrinBumerang, LevelSelectEnter
	incSWF	MainLogo1, MainLogo2, MainLogo3, MainLogo4, ShaoKannLaugh, FireShield
	incSWF	RainPCM, CryPCM, UMK3PCM, FireAtkFire, FireAtkWind, FireRush, Flame
	incSWF	ShaftAttack, ShaftAttack2, ShaftAttack3, LustHah, ThunderLightning
	incSWF	HardLine, GluttonySpew, Interlude, ThunderClamp, HeadlissAtk, WolfDeath
	incSWF	ArcherArmorAtk, WalkingArmorAtk, Ghost1, Ghost2, Raindrop, WindHowl
	incSWF	PhantomHand, crash_sample, MechaDemon
	even

	listing on			; continue source listing
; ===========================================================================

; ===========================================================================
; ---------------------------------------------------------------------------
; Equates specialised for the DDZ boss
; ---------------------------------------------------------------------------
OffsetROM := *
; ---------------------------------------------------------------------------

	; --- SFX ---

SDD_Flash		=	sfx_Transform				; when the pentagrams flash the screen to bring in phase 1
SDD_Damage		=	sfx_HitBoss				; when the boss gets hit
SDD_Slam		=	sfx_Raid				; when the boss slams on the floor
SDD_MissileShoot	=	sfx_RocketLaunch				; when the missiles are shooting out the top
SDD_MissileDrop		=	sfx_Fall				; when the missiles start to drop
SDD_MissileExplode	=	sfx_BreakBridge				; when the missiles explode on the floor
SDD_LaserCharge		=	sfx_Electro				; when the laser is charging up
SDD_LaserShoot		=	sfx_Electro2				; when the laser has shot out
SDD_LaserHit		=	sfx_LaserBeam				; when the laser has thud on the floor

	; --- VDP ---

VDD_EggIntroArt		=	$4000					; VRAM address for eggman on the intro
VDD_EggCoverIntroArt	=	$5000					; VRAM address for eggman's cover on the intro
VDD_PentArt		=	$7000	;  600				; VRAM address for pentagram art
VDD_CandleArt		=	$7600	;  A00				; VRAM address for candle art

VDD_WormBodyArt		=	$3000					; VRAM address of worm body art (will be unpacked with rotated versions before phase 1)
VDD_FlyArt		=	$7000	;  240				; VRAM address for fly art (overwrites pentagram)
VDD_ArrowAim		=	$7240	; ?				; VRAM address of arrow assistence art (overwrites pentagram)
VDD_WormHeadArt		=	$8000					; VRAM address of worm head art
VDD_MissileArt		=	$8E20	;  880				; VRAM address for missile art
VDD_VortexArt		=	$8E20					; VRAM address for vortex art (overwrites missile art)

VDD_FlameExpArt		=	$B380	; warning, object is hard coded	; VRAM address for explosion flame art (overwrites default smoke explosion art)

	; --- 68k RAM ---

			phase	ramaddr($FFFF4000)
RDD_RAM			ds.b	0

	; General

RDD_HScrollFG		ds.b	$1C0
RDD_HScrollBG		ds.b	$1C0
RDD_VScrollFG		ds.b	$28
RDD_VScrollBG		ds.b	$28
			;	(PixY*PixX)*Buffers
RDD_PreRot_Unpack	ds.b	($40*$30)*2				; ram address to unpack to (two buffers, one for each nybble side)
RDD_PreRot_Pack		ds.b	$200					; ram address to rotate and pack to
RDD_PreRot_Mappings	ds.b	$1000					; ram address to dump generated sprite mappings to use rotated art

RDD_Event		ds.l	1					; address of event routine to run
RDD_Timer		ds.w	1					; timer for delays in events, etc...

RDD_Phase		ds.b	1					; phase number
RDD_NoLevelDraw		ds.b	1					; flag to stop the scroll routine making requests for level drawing
RDD_SliceVScroll	ds.b	1					; if sliced V-scroll is used
RDD_SlicePriority	ds.b	1					; which plane gets priority over V-scroll -1 slot (00 = FG | FF = BG)

	; Intro

RDD_PentAngle		ds.w	1					; angle of pentagram (QQ.FF)
RDD_PentAngPrev		ds.w	1					; previous angle (for update detection)
RDD_PentScale		ds.w	1					; pentagram scale/size
RDD_PentSpeed		ds.w	1					; speed of pentagram rotation (QQ.FF)
RDD_PentCycle		ds.b	1					; pentagram cycle palette flag
RDD_PentCycDelay	ds.b	1					; '' delay timer
RDD_PentCycDisable	ds.b	1					; if the cycling should be disabled (i.e. fading to white)
RDD_FirstRun		ds.b	1					; if this is the first time the player is going against the boss (00 = Yes | FF = No)
RDD_CandleAni		ds.w	1					; candle animation slot
RDD_CandleAniDelay	ds.b	1					; delay timer for animation
RDD_EggIntro_Frame	ds.b	1					; frame ID for eggman on the intro
RDD_EggIntro_Prev	ds.b	1					; previous frame ID (for update detection)
RDD_EggIntro_Ani	ds.b	1					; animation position
RDD_EggIntro_AniDelay	ds.b	1					; delay timer for animation
RDD_EggIntroShow	ds.b	1					; if eggman on the intro should show sprites
RDD_EggIntro_YPos	ds.w	1					; Y position of cover
RDD_EggIntro_YDest	ds.w	1					; Y destination cover is meant to move to
RDD_PentShow		ds.b	1					; if the pentagram should show
RDD_CandlesShow		ds.b	1					; if the candles of the pentagram should show
RDD_ExplodeTimer	ds.w	1					; timer for ending cut-scene sequence to let the boss explode before raising characters upwards
RDD_FinishTimer		ds.w	1					; timer for ending cut-scene sequence to run before fading white
RDD_VortexFrame		ds.b	1					; frame counter for vortex
			ds.b	1	; even

RDD_CandlePos		ds.l	2*5					; candle positions (QQQQ.FFFF) the pentagram will set these positions first, then later we can alter them
RDD_CandleSpeed		ds.l	2*5					; candle speeds (QQQQ.FFFF) for after the pentagram is finished and we're controlling the candles

RDD_BossColours:
	.Flash:		ds.w	$40					; palette of brighter flash colours for the boss
	.Shadow:	ds.w	$40					; palette of darker flash colours for the boss


	; Phase 1

			phase	0
WmShow			ds.b	1					; if the worm for phase 1 is meant to show
WmInLaserMode		ds.b	1					; flag used by missiles to use shorter time if boss is in laser mode (00 = not laser mode | FF = laser mode)
WmBeamOn		ds.b	1					; flag to turn on/off the beam
WmBeamCharge		ds.b	1					; charge timer for beam
WmDispX			ds.l	1					; X position of worm head display/collision (QQQQ.FFFF)
WmDispY			ds.l	1					; Y position of worm head display/collision (QQQQ.FFFF)
WmPosX			ds.l	1					; central X position of worm head (for wobble, etc)
WmPosY			ds.l	1					; central Y position ''
WmDestX			ds.w	1					; destination X (for example, a target to fly to)
WmDestY			ds.w	1					; destination Y
WmAngle			ds.w	1					; angle of head rotation (QQ.FF)
WmSpeed:
WmSpeedX		ds.w	1					; X speed of worm head
WmSpeedY		ds.w	1					; Y speed of worm head
WmWidth			ds.w	1					; HALF width of worm graphics on plane
WmHeight		ds.w	1					; HALF height of worm graphics on plane
WmFrame			ds.b	1					; frame to show (the beam exclusively) - the cover/dome auto flickers anyway
WmFramePrev		ds.b	1					; previous frame
WmBeam			ds.b	1					; beam height
WmBeamPrev		ds.b	1					; previous height
WmHeadMode		ds.b	1					; boss modes (phases in the worm boss)
WmBodyMode		ds.b	1					; 00 = Natural | 04 = fluid
WmWobble		ds.w	1					; wobble angle QQ.FF
WmWobDist		ds.w	1					; wobble distance
WmTimer			ds.w	2					; general timer
WmCounter		ds.b	4					; general counters
WmHitCount		ds.b	1					; number of hit points
WmDamage		ds.b	1					; invulnerable damage timer
WmStore			ds.w	4					; storage locations (for various things)
WmChild			ds.w	1					; child address to point to explosion object

WmSize:
			dephase

RDD_Worm:		ds.b	WmSize*1

DDZ_WORMBODY_MAXSIZE	=	$0A

			phase	0
	ObjX:		ds.l	1					; X position QQQQ.FFFF
	ObjY:		ds.l	1					; Y position QQQQ.FFFF
	Speed:
	SpeedX:		ds.w	1					; X speed QQ.FF
	SpeedY:		ds.w	1					; Y speed QQ.FF
	ObjAngleDraw:	ds.w	1					; angle QQ.FF
	PrevX:		ds.w	1					; previous X speed QQ.FF (for overflow checking)

	WormObj_Size:	ds.b	0
			dephase
RDD_WormObjects:	ds.b	WormObj_Size*DDZ_WORMBODY_MAXSIZE
RDD_WormObjects_End:



DDZ_WORMBEAMS_MAXSIZE	=	$10

			phase	0
	WbT:		ds.b	1					; type (00 = charge particle | FF = spark)
			ds.b	1			; even
	WbD:		ds.w	1					; distance
	WbA:		ds.w	1					; angle QQ.FF

	WormBeam_Size:	ds.b	0
			dephase

RDD_WormBeams:		ds.b	WormBeam_Size*DDZ_WORMBEAMS_MAXSIZE
RDD_WormBeams_End:


DDZ_MISSILE_MAXSIZE	=	4*2		; 4 missiles (4 smoke)

			phase	0
	MsT:		ds.b	1					; type (01 = missile | 02 = explosion)
	MsF:		ds.b	1					; smoke frame
	MsD:		ds.w	1					; timer before dropping the missile
	MsX:		ds.w	1					; missile X position (QQQQ only)
	MsY:		ds.l	1					; missile Y position (QQQQ.FFFF)
	MsS:		ds.w	1					; missile Y speed
	Ms_Size:	ds.b	0
			dephase

RDD_Missiles:		ds.b	Ms_Size*DDZ_MISSILE_MAXSIZE
RDD_Missiles_End:






	; End...

			ds.l	4	; Can't use align as the macro uses "!org" and screws up the assembly address
RDD_RAM_End		ds.b	0
			dephase

	; --- Defines ---

DDZ_BOSS_CENTRE_X	=	($8C0+(320/2))				; central X position in level where the boss arena is
DDZ_PENTAGRAM_ROTATE	=	(((($100<<8)*3)/5)+$55)			; angle rotation to next point in the pentagram (QQ.FF)
DDZ_WORM_HEIGHT		=	80					; height of body art itself (because the mapping file is taller)
DDZ_WORM_BEAMMAX	=	$0E					; maximum beam height for worm boss
DDZ_BOSS_ARENA		=	(512-$80)				; width of arena


DDZ_WORM_PLANEPOS	=	$0000					; plane position (relative to 6000|0003)

; ---------------------------------------------------------------------------
		!org	OffsetROM					; Reset the program counter
; ===========================================================================
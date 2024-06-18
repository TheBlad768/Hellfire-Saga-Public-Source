; ===========================================================================
; ---------------------------------------------------------------------------
; DDZ Boss Phase 2
; ---------------------------------------------------------------------------

	include	"Data\Phase 2\Devil Eggman\Include\Output\_Equates.asm"

; ---------------------------------------------------------------------------
; SFX ID list
; ---------------------------------------------------------------------------

MDE_Music	=	mus_FBoss						; music for the boss

SDE_Slash	=	sfx_FireShot						; when the claws slash on the black screen
SDE_HitBoss	=	sfx_HitBoss						; when the boss is hit by Sonic
SDE_FlyBack	=	sfx_Magic						; when the devil flies far away in the distance
SDE_BallDrop	=	sfx_Magnet						; when the energy balls fall from the top of the screen
SDE_BallShoot	=	sfx_Attachment						; when the energy balls are shot from a distance
SDE_HurtSonic	=	sfx_Death						; when Sonic is hurt
SDE_LaunchRock	=	sfx_RocketLaunch					; when rockets are launching from behind devil
SDE_ArmLaunch	=	sfx_Tear						; when the arms are launching off-screen from the devil
SDE_ArmSlam	=	sfx_Raid						; when the arms slam together
SDE_BoostSFX	=	sfx_Teleport						; when player has pressed the boost button to make Sonic roll into a ball
SDE_Explosion	=	sfx_Bomb						; when an explosion sprite goes off
SDE_ExplodeTime	=	6							; number of frames between explosion sfx plays
SDE_ChargeSFX	=	sfx_Spindash						; when Sonic is charging up the last boost
SDE_ReleaseSFX	=	sfx_Teleport						; when Sonic is releasing the last boost

; ---------------------------------------------------------------------------
; VDP/VRAM address list
; ---------------------------------------------------------------------------

VDE_DevilArt1	=	$0020
VDE_DevilArt2	=	VDE_DevilArt1+4
VDE_Eyes	=	VDE_DevilArt1+DE_DEVILARTSIZE			; Devil Eggman's eye art $10 tiles
VDE_Sonic	=	VDE_Eyes+($10*$20)				; Sonic's floating layer sprites
VDE_SonicRoll	=	VDE_Sonic+($700)				; Sonic's rolling sprites
VDE_ArmsBig	=	$2640						; massive arm art
VDE_ArmsSmall	=	($2E20+$C0)					; scale art for small arms
VDE_Energy	=	($31A0+$C0)					; energy ball art
VDE_MissileSca	=	($4BC0+$C0)					; scale art for missiles
VDE_Missile	=	($4DC0+$C0)					; rotation art for missiles
VDE_HUD		=	($53C0+$C0)					; HUD art
VDE_HitSign	=	($56C0+$C0)					; "HIT" sign art for slash attack
VDE_Explode	=	($5860+$C0)					; explosion graphics
VDE_Pause	=	$FD00						; VRAM address where pause art is
VDE_SonicCharge	=	VDE_ArmsBig					; charging occurs during death sequence, can overwrite big arms~

VDE_Slash	=	VDE_DevilArt1	; overwrites devil during slash	; slash claw art for slash attack

VDE_Vortex	=	$B800		; subtraction from this point backwards
VDE_Sprites	=	$B800
VDE_HScroll	=	$BC00
VDE_PlaneA	=	$C000
VDE_Window	=	$D000
VDE_PlaneB	=	$E000

; ---------------------------------------------------------------------------
; Kosinski PLC list for DDZ phase 2
; ---------------------------------------------------------------------------

	; --- First list ---

DE_KosArtList:
		dc.l	Art_SonLay
		dc.w	VDE_Sonic

		dc.l	Art_MissileDE
		dc.w	VDE_Missile

		dc.l	Art_EyesDE
		dc.w	VDE_Eyes

		dc.l	Art_ArmsBigDE
		dc.w	VDE_ArmsBig

		dc.l	Art_EnergyDE
		dc.w	VDE_Energy

		dc.l	Art_SonRoll
		dc.w	VDE_SonicRoll

		dc.w	$FFFF

	; --- List for after the PreRot stuff is done ---
	; The missiles PreRot to VRAM and then get read
	; out to RAM, so any art in the above list where
	; the PreRot was, will be overwritten, this secon
	; list runs after missile RreRot
	; -----------------------------------------------

DE_KosArtList2:
		dc.l	ArtKosM_Hud+2		; +2 skipping module, directly accessing non-module
		dc.w	VDE_HUD

		dc.l	Art_HitDE
		dc.w	VDE_HitSign

		dc.l	Art_ExplodeDE
		dc.w	VDE_Explode

		dc.w	$FFFF

; ---------------------------------------------------------------------------
; RAM equates list
; ---------------------------------------------------------------------------
OffsetROM := *
; ---------------------------------------------------------------------------

	; --- Boss objects ---

			phase	0
SO_PosX			ds.l	1					; X position (mainly for display)
SO_PosY			ds.l	1					; Y position (mainly for display)
SO_SpeedX		ds.l	1					; X speed
SO_SpeedY		ds.l	1					; Y speed
SO_SpeedZ		ds.l	1					; Z speed
SO_Frame		ds.w	1					; map frame number (multiples of 2)
SO_Pattern		ds.w	1					; pattern index
SO_Mappings		ds.l	1					; sprite mappings list (if MSB is negative, use scale version)
SO_PointX		ds.l	1					; actual X position (X point)
SO_PointY		ds.l	1					; actual Y position (Y point)
SO_PointZ		ds.l	1					; actual Z scale (Z point)
SO_Timer		ds.w	1					; generic timer
SO_Counter		ds.l	1					; generic counter
SO_DestX		ds.w	1					; generic destination X position
SO_DestY		ds.w	1					; generic destination Y position
SO_Angle		ds.w	1					; QQ.FF rotation angle
SO_AngSpeed		ds.w	1					; rotation speed
SO_AngDistX		ds.l	1					; angle rotation distance (radius)
SO_AngDistY		ds.l	1					; ''
SO_Touch		ds.b	1					; if the object was touched (must call the collision routine)
			ds.b	1	; even

SO_Size:
			dephase

	; --- Boss art RAM buffers (the fit nicely in the object RAM) ---

			phase	ramaddr(Object_RAM)
RDE_DevilArt:
RDE_DevilArtL1:		ds.b	(DE_DEVILSECTSIZE/2)
RDE_DevilArtL2:		ds.b	(DE_DEVILSECTSIZE/2)
RDE_DevilArtR1:		ds.b	(DE_DEVILSECTSIZE/2)
RDE_DevilArtR2:		ds.b	(DE_DEVILSECTSIZE/2)
			ds.l	4
RDE_DevilArt_End:	ds.b	0
			dephase

	; --- Rest of the RAM in chunk RAM area ---

			phase	ramaddr($FFFF0000)
RDE_RAM			ds.b	0

RDE_MissileArt		; we need 2000 bytes, the "Unpack" section is 1800 bytes bit, might as well use some of it
RDE_PreRot_Unpack	ds.b	$4000-$200	;($40*$30)*2		; ram address to unpack to (two buffers, one for each nybble side)
RDE_PreRot_Pack		ds.b	$200					; ram address to rotate and pack to
RDE_PreRot_Mappings	; ds.b $1000					; ram address to dump generated sprite mappings to use rotated art
	; using same spot for missile scale art *after* rotated frames have been generated
	; and copied out from VRAM, the mappings list is no longer needed (handled manually)
	; saving RAM space
RDE_Missile_Unpack	ds.b	$300*4					; ram address to unpack to (two buffers, one for each nybble side)
RDE_Missile_Pack	ds.b	$200					; ram address to scale and pack to (also the space to initially decompress the art to before unpacking)
RDE_Missile_ScaleCur	ds.w	1					; scale size (QQ.FF)
RDE_Missile_ScalePrev	ds.w	1					; '' previous scale
RDE_Missile_ScaleDMA	ds.w	1					; '' previous scale (for DMA)

RDE_ArmSml_Unpack	ds.b	$600*4					; ram address to unpack to (two buffers, one for each nybble side)
RDE_ArmSml_Pack		ds.b	$400					; ram address to scale and pack to (also the space to initially decompress the art to before unpacking)
RDE_ArmSml_ScaleCur	ds.w	1					; scale size (QQ.FF)
RDE_ArmSml_ScalePrev	ds.w	1					; '' previous scale
RDE_ArmSml_ScaleDMA	ds.w	1					; '' previous scale (for DMA)
RDE_ArmSml_ScaleMul	ds.w	1					; '' multiplication value (to use mulu instead of divu)

RDE_Events		ds.l	1					; events routine being ran
RDE_DelayRout		ds.l	1					; next events routine TO run when calling the delay event routine
RDE_Delay		ds.w	1					; delay timer for events
RDE_Counter		ds.w	1					; counter for events

RDE_Events2		ds.l	1					; second events routine to be ran (for a second move running alongside the first)
RDE_DelayRout2		ds.l	1					; next events routine TO run when calling the delay event routine
RDE_Delay2		ds.w	1					; delay timer for events
RDE_Counter2		ds.w	1					; counter for events


RDE_MoveBossIn								; flag to move the boss in slowly
RDE_MoveBossDist	ds.l	1					; distance boss should move back to before moving in (MSB is move in flag)
RDE_MoveBossSpeed	ds.l	1					; speed to move the boss in
RDE_AttackOrder		ds.l	1					; current list order address
RDE_AttackList		ds.l	1					; current list address

RDE_VortexTimer		ds.l	1					; cycle timer
RDE_VortexPos		ds.w	1					; current position
RDE_VortexSpeed		ds.w	1					; current speed
RDE_VortexAccel		ds.w	1					; accelleration/decelleration speed
RDE_VortexDest		ds.w	1					; destination speed
RDE_VortexColour	ds.w	1					; non-cycle colour to use
RDE_VortexCycle		ds.w	1					; cycle fade from 00.00 to 01.00
RDE_FadeCount		ds.b	1					; counter for palette fading
RDE_LastDPad		ds.b	1					; last D-pad buttons pressed for boost buttons
RDE_RollTimer		ds.w	1					; timer before boosting/rolling can be ran again
RDE_BossHScroll		ds.w	1					; H-scroll position for boss's FG plane
RDE_PrevHScroll		ds.w	1					; previous H-scroll position (so it doesn't need writing twice)
RDE_ScaleVPrev		ds.w	2*2					; previous V-scale position (no need to write it twice if it's not changed)
RDE_SlashFade		ds.w	1					; fade amount to black for the slash attack
RDE_SlashPrev		ds.w	1					; previous slash fading
RDE_DoneSlash		ds.b	1					; if the boss has done a slash move yet before moving onto a list again
RDE_ShowSonic		ds.b	1					; if Sonic should display yet (hidden until intro is ready)
RDE_IntroFinish		ds.b	1					; if the intro is finished processing (for the palette fading specifically)
RDE_SlashDirection	ds.b	1					; direction of slash move (multiples of $20)
RDE_LoadSlashArt	ds.b	1					; slash art flag
RDE_FinishBoss		ds.b	1					; if the boss is finished (no more attacks)

RDE_PosX		ds.l	1					; positions
RDE_PosY		ds.l	1					; ''
RDE_PosZ		ds.l	1					; ''
RDE_ScaleX		ds.l	1					; scaling
RDE_ScaleY		ds.l	1					; ''
RDE_ScaleX_CAP		ds.l	1					; capped version
RDE_ScaleY_CAP		ds.l	1					; ''
RDE_DispX		ds.w	1					; display positions (with Z accountance)
RDE_DispY		ds.w	1					; ''
RDE_Width		ds.w	1					; width of boss at full scale
RDE_Height		ds.w	1					; height of boss at full scale
RDE_ScaleS
RDE_ScaleW		ds.w	1					; width of boss at current scale
RDE_ScaleH		ds.w	1					; height of boss at current scale
RDE_AdjY		ds.l	1					; adjusted Y position (countering scale)
RDE_AdjX		ds.l	1					; adjusted X version (not really needed, but had to do the calculation for ScaleW, so might as well store...)
RDE_EyeY		ds.w	1					; Y relative position of eye (from centre of devil's body)
RDE_Damage		ds.b	1					; damage timer
RDE_DamagePal		ds.b	1					; if the palette should update for the boss line flashing/damage
RDE_SlashCount		ds.b	1					; number of slashes during the slash attack
RDE_HitSign		ds.b	1					; if the hit sign should show
RDE_SpeedX		ds.l	1					; X speed
RDE_SpeedY		ds.l	1					; Y speed
RDE_DestX		ds.w	1					; X destination
RDE_DestY		ds.w	1					; Y destination
RDE_DestZ		ds.w	1					; Z destination
RDE_DestTimer		ds.w	1					; timer before randomly getting a new destination
RDE_FollowTimer		ds.w	1					; timer for Sonic to follow and hit eggman before missed the chance
RDE_HitCount		ds.b	1					; hit counter (counts from 0)
RDE_WasHit		ds.b	1					; hit flag (to decide if the move should replay or not)

RDE_DistSonic		ds.w	1					; distance Sonic is away from devil eggman
RDE_AngSonic		ds.w	1					; angle Sonic is from devil eggman (QQ.FF)
RDE_SonicDead		ds.b	1					; if Sonic has been killed
RDE_FleshArt		ds.b	1					; if the flesh art needs transfering
RDE_FleshSize		ds.w	1					; size of flesh art to transfer (divided by 2 for DMA word)
RDE_DeathTimer		ds.w	1					; timer before level should reset
RDE_DeathFade		ds.b	1					; death fade timer
RDE_PausePresses	ds.b	1					; copy of the pause button presses
RDE_ExplodeSFX		ds.b	1					; timer before last explosion SFX was played
RDE_EndingScreen	ds.b	1					; if the boss is finished and we're moving to the ending screen
RDE_ControlPad_A							; player 1 held and pressed buttons
RDE_PadA_Held		ds.b	1					; held buttons
RDE_PadA_Pressed	ds.b	1					; pressed buttons
RDE_ControlPad_B							; player 2 held and pressed buttons
RDE_PadB_Held		ds.b	1					; held buttons
RDE_PadB_Pressed	ds.b	1					; pressed buttons
RDE_PadA_Late		ds.b	1					; Late presses
RDE_PadB_Late		ds.b	1					; Late presses
RDE_LastBoostTimer	ds.b	1					; timer for last boost (the charging one)
RDE_LastBoostArt	ds.b	1					; flag to load uncompressed charge frames
RDE_ShowEnergy		ds.b	1
RDE_ShowArms		ds.b	1
RDE_ShowMissiles	ds.b	1
			ds.b	1	; even

RDE_AniFrame		ds.w	1					; frame counter (counts up in 2's)
RDE_AniArms								; if animation is showing arms or not (0 = yes | 1 = no)
RDE_AniArt		ds.l	1					; animation address

RDE_Sonic:		ds.b	SO_Size
RDE_LeftArm:		ds.b	SO_Size
RDE_RightArm:		ds.b	SO_Size
RDE_Energy:		ds.b	SO_Size*5
RDE_Missiles:		ds.b	SO_Size*3
RDE_Claws:		ds.b	SO_Size*5*2
RDE_Devil:		ds.b	SO_Size					; dummy slot for the collision routine
RDE_FLESHCOUNT	=	$0C
RDE_Flesh:		ds.b	SO_Size*RDE_FLESHCOUNT

RDE_Touch		ds.b	1					; if a collision has occured
			ds.b	1	; even
RDE_Collision		ds.w	2+(20*3)+2 ; extra +2 is for end marker	; collision list SSSS | OOOO WWHH, OOOO WWHH, etc (S = start address, O = Object RAM address, W/H = Width/Height radius)
RDE_Explosion		ds.w	(20*3)+2 ; extra +2 is for end marker	; explosion list FFFF YYYY XXXX (F = frame)
RDE_ExplodeLast		ds.w	2					; last explosion slot

RDE_MissArt:		ds.w	2*3					; RAM address of missile art to transfer (3 slots)
RDE_MissAngle:		ds.w	1					; distance between each angle of missile rotation frame (copied from RDE_PreRot_Mappings+2)

RDE_VScrollSlot		ds.b	1
RDE_HOffScreen		ds.b	1
RDE_CyclesCount		ds.l	1
RDE_CyclesSaved		ds.l	1


RDE_BossColours:
	.Flash:		ds.w	$40					; palette of brighter flash colours for the boss
	.Shadow:	ds.w	$40					; palette of darker flash colours for the boss


			ds.l	4
RDE_RAM_End		ds.b	0
			dephase

	; --- Reference from hellfire's RAM ---

RDE_PaletteMain	=	Target_palette
RDE_PaletteCur	=	Normal_palette
RDE_PaletteShow =	Water_palette
RDE_HScrollFG	=	v_hscrolltablebuffer
RDE_HScrollBG	=	v_hscrolltablebuffer+(224*2)
RDE_VScrollA	=	h_vscrolltablebuffer
RDE_VScrollB	=	h_vscrolltablebuffer+(224*2)
RDE_Sprites	=	Sprite_table_buffer
RDE_KosDump	=	Kos_decomp_buffer

		!org	OffsetROM					; Reset the program counter

; ===========================================================================
; ---------------------------------------------------------------------------
; Screen mode start point
; ---------------------------------------------------------------------------

DDZ_Phase2:
		command	cmd_Reset
		sf.b	(Restart_level_flag).w				; clear reset flag

	;	lea	(Pal_FadeToBlack).w,a0				; load black fade routine
	;	tst.w	(Seizure_Flag).w				; is seizure mode on?
	;	bne.s	.DarkFade					; if so, do dark version instead

	;	lea	(Pal_FadeToWhite).w,a0				; load white fade routine
	; Looks like there isn't a white fade in Hellfire anymore
	; Dirty hack below...
		lea	(Pal_FadeToColour).w,a0
		lea	(RDE_PaletteMain).w,a1
		lea	(RDE_PaletteCur).w,a2
		move.l	#$0EEE0EEE,d0
		moveq	#($80/4)-1,d1
	.Light:	move.l	d0,(a1)+
		move.l	d0,(a2)+
		dbf	d1,.Light

	.DarkFade:
		jsr	(a0)						; run routine

		move.w	#$2700,sr
		cmpi.b	#id_DDZ_Ending,(Game_mode).w			; is this the ending screen?
		bne.s	.NoEnd						; if not, continue as normal
		jmp	DE_EndingScreen					; go straight to the ending screen

	.NoEnd:
		sf.b	(PauseSlot).w					; MJ: reset pause menu option to top
		sf.b	(YouDiedY).w					; MJ: reset "You Died" Y position

		; WARNING, THIS VERSION ONLY CHECKS THE ZONE, NOT THE ACT TOO
		; THIS JUST ENSURES THE INTRO TO ACT 1 IS STILL SKIPPED EVEN
		; THOUGH YOU DIED IN ACT 2....
		move.b	(Current_zone).w,d0				; load the current zone/act
		cmp.b	(Previous_zone).w,d0				; has it changed?
		sne.b	(FirstRun).w					; set/clear the first run flag if this zone has been played before (after death)
		move.b	d0,(Previous_zone).w				; update previous zone/act

		ResetDMAQueue
		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port

		move.w	#$8000|%00000100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00010100,(a6)			; 81	; SDVM P100 - SMS mode (0N|1Y) | Display (0N|1Y) | V-Interrupt (0N|1Y) | DMA (0N|1Y) | V-resolution (0-1C|1-1E)
		move.w	#$8200|(((VDE_PlaneA)>>$0A)&$FF),(a6)	; 82	; 00FE DCBA - Scroll Plane A Map Table VRam address
		move.w	#$8300|(((VDE_Window)>>$0A)&$FF),(a6)	; 83	; 00FE DCB0 / 00FE DC00 (20 Resolution) - Window Plane A Map Table VRam address
		move.w	#$8400|(((VDE_PlaneB)>>$0D)&$FF),(a6)	; 84	; 0000 0FED - Scroll Plane B Map Table VRam address
		move.w	#$8500|(((VDE_Sprites)>>$09)&$FF),(a6)	; 85	; 0FED CBA9 / 0FED CBA0 (20 Resolution) - Sprite Plane Map Table VRam address
		move.w	#$8600|$00,(a6)				; 86	; 0000 0000 - Unknown/Unused Register
		move.w	#$8700|$30,(a6)				; 87	; 00PP CCCC - Backdrop Colour: Palette Line 0/Colour ID 0
		move.w	#$8800|$00,(a6)				; 88	; 0000 0000 - Unknown/Unused Register
		move.w	#$8900|$00,(a6)				; 89	; 0000 0000 - Unknown/Unused Register
		move.w	#$8A00|$DF,(a6)				; 8A	; 7654 3210 - H-Interrupt Register
		move.w	#$8B00|%00000011,(a6)			; 8B	; 0000 EVHH - External Interrupt (0N|1Y) | V-Scroll: (0-Full|1-2Celled) | H-Scroll: (00-Full|10-Celled|11-Sliced)
		move.w	#$8C00|%10000001,(a6)			; 8C	; APHE SNNB - H-resol (0N|1Y) | Pixel int (0N|1Y) | H-sync (0N|1Y) | Extern-pix (0N|1Y) | S/H (0N|1Y) | Interlace (00N|01Y|11-Split) | H-resol (0-20|1-28)
		move.w	#$8D00|(((VDE_HScroll)>>$0A)&$FF),(a6)	; 8D	; 00FE DCBA - Horizontal Scroll Table VRam address
		move.w	#$8E00|$00,(a6)				; 8E	; 0000 0000 - Unknown/Unused Register
		move.w	#$8F00|$02,(a6)				; 8F	; 7654 3210 - Auto Increament
		move.w	#$9000|%00000011,(a6)			; 90	; 00VV 00HH - Plane Y Size (00-20|01-40|11-80) | Plane X size (00-20|01-40|11-80)
		move.w	#$9100|$00,(a6)				; 91	; 7654 3210 - Window Horizontal Position
		move.w	#$9200|$00,(a6)				; 92	; 7654 3210 - Window Vertical Position

	; --- Clearing data ---

		moveq	#$00,d0						; clear d0
		move.l	#$8F019780,(a6)					; set increment mode and DMA mode
		move.l	#$94FF93E0,(a6)					; set DMA size
		move.l	#$96009500,(a6)					; set DMA source (null for fill)
		move.l	#$40200080,(a6)					; set DMA destination
		move.w	d0,(a5)						; set DMA fill value

	; * Clear shit here... *

		lea	(RDE_RAM).l,a1					; load devil eggman screen RAM space
		move.w	#((RDE_RAM_End-RDE_RAM)/4)-1,d1			; size to clear

	.ClearRAM:
		move.l	d0,(a1)+					; clear RAM
		dbf	d1,.ClearRAM					; repeat for entire RAM space

		lea	(RDE_DevilArt).l,a1				; load devil eggman scaling art buffer
		move.w	#((RDE_DevilArt_End-RDE_DevilArt)/4)-1,d1	; size to clear

	.ClearDevil:
		move.l	d0,(a1)+					; clear buffer space
		dbf	d1,.ClearDevil					; repeat until buffers are clear

		lea	(RDE_Sprites).w,a1				; load sprite buffer
		moveq	#$01,d0						; prepare link ID with rest clear
		moveq	#$00,d1						; ''
		moveq	#$50-1,d2					; number of sprites to run through

	.ClearSprites:
		move.l	d0,(a1)+					; clear sprite (set link ID)
		move.l	d1,(a1)+					; ''
		addq.b	#$01,d0						; increase link ID
		dbf	d2,.ClearSprites				; repeat for all sprites
		move.w	#RDE_Sprites+3,(Sprite_Link).w			; set link clear address
		move.w	#8/2,(Sprite_Size).w				; set to transfer only the 1 sprite

		; Waiting for VDP DMA fill

		move.w	(a6),ccr					; load status
		bvs.s	*-$02						; if the VDP DMA busy flag was set (bit 1), branch to wait til finished...
		move.w	#$8F02,(a6)					; set VDP increment mode back to normal

	; --- Sonic ---

		lea	(Pal_Sonic).l,a0
		lea	(RDE_PaletteMain).w,a1
		moveq	#($20/2)-1,d7

	.LoadPalSon:
		move.w	(a0)+,(a1)+
		dbf	d7,.LoadPalSon

	; --- Kosinski art ---

		lea	DE_KosArtList(pc),a4				; load PLC list
		lea	(RDE_KosDump).l,a1				; load RAM buffer address to use for kosinski decompression
		jsr	KosDirectPLC					; decompress art and transfer to VRAM

	; --- Small arms ---

		lea	(Art_ArmsSmlDE).l,a0				; load small arm art
		lea	(RDE_ArmSml_Pack).l,a1				; load RAM space to decompress (decompressing to the scale area, the PreScale_Setup routine will unpack
		jsr	Kos_Decomp					; decompress and dump to RAM
		lea	(RDE_ArmSml_Pack).l,a1				; reload art address
		lea	(RDE_ArmSml_Unpack).l,a2			; load space to unpack the art to
		lea	(Map_ArmsSmlDE).l,a3				; load mappings so the routine knows which tiles to unpack for scaling
		adda.w	(a3),a3						; load first frame
		move.w	#$600*2,d6					; prepare size of buffer
		jsr	PreScale_Setup					; setup the art for pre-scaling

	; --- Missiles ---

		move.w	#VDE_Missile,d0					; VRAM address where art is
		moveq	#$03,d1						; width of sprite
		moveq	#$02,d2						; height of sprite
		move.w	#$E000|(VDE_Missile/$20),d4			; VRAM address to save rotated art to
		moveq	#$04,d7			; Must be power of 2!	; angle rate (speed of advancing the angle around)
		lea	(RDE_PreRot_Unpack).l,a1			; ram address to unpack to
		lea	(RDE_PreRot_Pack).l,a3				; ram address to rotate and pack to
		lea	(RDE_PreRot_Mappings).l,a4			; ram address to dump the sprite mappings
		jsr	PreRotate					; unpack and prerotate art from VRAM

		move.w	(RDE_PreRot_Mappings+2).l,(RDE_MissAngle).l	; store missile angle to somewhere else

; Not needed, it's onle a single sprite of the same shape, same VRAM, etc...
;		move.w	a4,d0						; get size of rotation mappings
;		subi.w	#(RDE_PreRot_Mappings+4)&$FFFF,d0		; ''
;		lsr.w	#$03,d0						; convert to dbf counter
;		subq.w	#$01,d0						; ''
;		subq.w	#$04,a4						; go back to pattern index
;
;	.SortVRAM:
;		andi.w	#$F800,(a4)					; keep only flags (clear tile index)
;		subq.w	#$08,a4						; go to previous sprite
;		dbf	d0,.SortVRAM					; repeat until all pieces are changed

		subi.w	#$E000|(VDE_Missile/$20),d4			; get size of art in VRAM now
		subq.w	#$01,d4						; ''
		move.l	#(((VDE_Missile)&$3FFF)<<$10)|((VDE_Missile)>>$E),(a6) ; set VRAM read
		lea	(RDE_MissileArt).l,a1				; RAM address where rotated missile art is to be copied out

	.ReadMissile:
		move.l	(a5),(a1)+					; load tile out
		move.l	(a5),(a1)+					; ''
		move.l	(a5),(a1)+					; ''
		move.l	(a5),(a1)+					; ''
		move.l	(a5),(a1)+					; ''
		move.l	(a5),(a1)+					; ''
		move.l	(a5),(a1)+					; ''
		move.l	(a5),(a1)+					; ''
		dbf	d4,.ReadMissile					; repeat until all frames are loaded out

	; --- Missile scale for launching ---

		lea	(RDE_MissileArt).l,a1				; reload art address
		lea	(RDE_Missile_Unpack).l,a2			; load space to unpack the art to
		lea	(Map_MissileDummy).l,a3				; load mappings so the routine knows which tiles to unpack for scaling
		move.w	#$300*2,d6					; prepare size of buffer
		jsr	PreScale_Setup					; setup the art for pre-scaling

	; --- Kosinski art second list ---

		lea	DE_KosArtList2(pc),a4				; load PLC list
		lea	(RDE_KosDump).l,a1				; load RAM buffer address to use for kosinski decompression
		jsr	KosDirectPLC					; decompress art and transfer to VRAM

	; --- Vortex BG ---

		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''

		lea	(Pal_Vortex).l,a0
		lea	(RDE_PaletteMain+$40).w,a1
		moveq	#((Pal_Vortex_End-Pal_Vortex)/2)-1,d7

	.LoadPalVor:
		move.w	(a0)+,(a1)+
		dbf	d7,.LoadPalVor

		move.w	#VDE_Vortex-(Art_Vortex_End-Art_Vortex),d1
		move.l	#$40000000,d0
		move.w	d1,d0
		rol.l	#$02,d0
		ror.w	#$02,d0
		swap	d0
		move.l	d0,(a6)
		lea	(Art_Vortex).l,a0
		move.w	#((Art_Vortex_End-Art_Vortex)/$20)-1,d7

	.LoadArtVor:
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		move.l	(a0)+,(a5)
		dbf	d7,.LoadArtVor

		lea	(Map_Vortex).l,a0
		move.l	#$60000003,(a6)
		move.w	#((Map_Vortex_End-Map_Vortex)/$20)-1,d7
		lsr.w	#$05,d1
		ori.w	#$4000,d1
		move.w	d1,d0
		swap	d1
		move.w	d0,d1

	.LoadMapVor:
		rept	8
		move.l	(a0)+,d0
		add.l	d1,d0
		move.l	d0,(a5)
		endr
		dbf	d7,.LoadMapVor

	; --- Devil Eggman ---

		lea	(Pal_DevEgg).l,a0
		lea	(RDE_PaletteMain+$20).w,a1
		moveq	#((Pal_DevEgg_End-Pal_DevEgg)/2)-1,d7

	.LoadPalDE:
		move.w	(a0)+,(a1)+
		dbf	d7,.LoadPalDE

		lea	(RDE_PaletteMain+$20).w,a0			; load line to brighten
		lea	(RDE_BossColours.Flash).l,a1			; load storage location for brighter colours
		jsr	DDZ_BrightPalette				; make brighter palette colours
		lea	(RDE_PaletteMain+$20).w,a0			; load line to brighten
		lea	(RDE_BossColours.Shadow).l,a1			; load storage location for brighter colours
		jsr	DDZ_DarkPalette					; make brighter palette colours

;	lea	(RDE_PaletteCur+$40).w,a1
;	move.l	#$00000EEE,(a1)+
;	move.l	#$0E8808E8,(a1)+
;	move.l	#$088E08EE,(a1)+
;	move.l	#$0EE80E8E,(a1)+

		; --- Mapping Devil Eggman ---
		; This will draw the mappings such that the centre
		; of the devil eggman will be at plane's 0 x 0 spot
		; ----------------------------

		lea	(Map_DevEgg).l,a0				; compressed mappings
		lea	(RDE_KosDump).l,a1				; RAM address to dump
		move.w	#$A000,d0					; tile adjustment
		jsr	EniDec						; decompress and dump

		move.w	#(VDE_DevilArt1/$20)-1,d7
		move.l	#$00036000+$100,d4				; prepare left address (start from right side)
		move.l	#$00036000,d5					; prepare right address (start from left side)
		jsr	DE_SetupDevilMap
	;	move.w	#(VDE_DevilArtB/$20)-1,d7
	;	move.l	#$00036080+$100,d4				; prepare left address (start from right side)
	;	move.l	#$00036080,d5					; prepare right address (start from left side)
	;	bsr.w	DE_SetupDevilMap

	; --- Flesh art ---

		lea	(ArtKosM_Flesh+2).l,a0				; load flesh art (skip module word)
		lea	(RDE_KosDump).l,a1				; load RAM buffer address to use for kosinski decompression
		jsr	KosDec						; decompress flesh art
		move.w	a1,d0						; get size of uncompressed data
		sub.w	#RDE_KosDump&$FFFF,d0				; ''
		lsr.w	#$01,d0						; divide by 2 for DMA word
		move.w	d0,(RDE_FleshSize).l				; store for later

	; --- Pause art ---

		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		lea	(ArtUnc_Pause).l,a0				; load pause art
		move.l	#$40000000|vdpCommDelta(VDE_Pause),(a6)		; set write address
		move.w	#((ArtUnc_Pause_End-ArtUnc_Pause)/4)-1,d7	; size of art to load

	.LoadPauseArt:
		move.l	(a0)+,(a5)					; copy tiles
		dbf	d7,.LoadPauseArt				; repeat until pause menu is copied over

	; --- Final stuff ---

		music	MDE_Music, 0

		clr.w	(RDE_ArmSml_ScaleCur).l				; set current scale size
		clr.w	(RDE_ArmSml_ScalePrev).l			; prevent first frame from being generated (art in RAM is already 0% scaled)
		st.b	(RDE_ArmSml_ScaleDMA).l				; force first frame to transfer
		move.w	#$0100,(RDE_ArmSml_ScaleMul).l			; force initial scale size to be 0

		clr.w	(RDE_Missile_ScaleCur).l			; set current scale size
		clr.w	(RDE_Missile_ScalePrev).l			; prevent first frame from being generated (art in RAM is already 0% scaled)
		st.b	(RDE_Missile_ScaleDMA).l			; force first frame to transfer

		move.w	#$0100,(RDE_SlashFade).l			; set fade to maximum

		sf.b	HUD_State.w					; force HUD off-screen initially
		bsr.w	DE_SetupHealth

		clr.l	(HP_Ani_Frames).w				; reset HUD animation
		st.b	(Update_HUD_ring_count).w			; update HUD
		move.w	#(60*3)/2,(RDE_DeathTimer).l			; reset death timer
		move.b	#$15,(RDE_DeathFade).l				; reset fade death counter

	; --- Setup before loop ---

		move.l	#VB_DevilBoss2,(V_int_addr).w
		move.l	#NullRTE,(H_int_addr).w
		move.w	#$8000|%00010100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00110100,(a6)			; 81	; SDVM P100
		bsr.w	WaitVBlank					; wait for V-blank
		; Don't use a6, it's being used for H-blank now...
		move.w	#$8100|%01110100,$04(a5)		; 81	; SDVM P100

; ---------------------------------------------------------------------------
; Main loop
; ---------------------------------------------------------------------------

ML_DDZ_Phase2:
		bsr.w	DE_DevilAnimate					; animate the boss's FG

		move.l	#VB_DevilBoss1,(V_int_addr).w
		bsr.w	WaitVBlank					; wait for V-blank
		jsr	WobbleScreen					; perform screen wobble (shaking)
		jsr	SynchroAnimate.SyncHUD				; allow HUD to animate
		bsr.w	DE_SonicControls				; run controls (for Sonic)
		bsr.w	DE_Events					; run events
		bsr.w	DE_CalcStuff					; calculate various universal stuff
		tst.w	(RDE_SlashFade).l				; is the fade completely black?
		ble.s	.Slash1						; if so, skip most of below
		bsr.w	DE_ControlVortex				; control the vortex display
		bsr.w	DE_ScaleArmArt					; allow arm art to scale (if it needs to)
		bsr.w	DE_ScaleMissileArt				; allow missile art to scale (if it needs to)
		bsr.w	DE_DevilScaleV					; control vertical scaling
		bsr.w	DE_DevilPosition				; control devil positioning
		lea	(LineData1).l,a2				; load line list data for the even scanlines
		lea	(RDE_DevilArtL1).l,a3				; load left word buffer for even scanlines
		lea	(RDE_DevilArtR1).l,a4				; load right word buffer for even scanlines
		bsr.w	DE_DevilScaleH					; control horizontal scaling

	.Slash1:
		bsr.w	DE_RenderSprites				; render all sprites
		bsr.w	DE_Collision					; handle collision
		bsr.w	DE_PaletteControl				; run palette fading control


		move.l	#VB_DevilBoss2,(V_int_addr).w
		bsr.w	WaitVBlank					; wait for V-blank
		jsr	WobbleScreen					; perform screen wobble (shaking)
		jsr	SynchroAnimate.SyncHUD				; allow HUD to animate
		bsr.w	DE_SonicControls				; run controls (for Sonic)
		bsr.w	DE_Events					; run events
		bsr.w	DE_CalcStuff					; calculate various universal stuff
		tst.w	(RDE_SlashFade).l				; is the fade completely black?
		ble.s	.Slash2						; if so, skip most of below
		bsr.w	DE_ControlVortex				; control the vortex display
		bsr.w	DE_ScaleArmArt					; allow arm art to scale (if it needs to)
		bsr.w	DE_ScaleMissileArt				; allow missile art to scale (if it needs to)
		bsr.w	DE_DevilScaleV					; control vertical scaling
		bsr.w	DE_DevilPosition				; control devil positioning
		lea	(LineData2).l,a2				; load line list data for the odd scanlines
		lea	(RDE_DevilArtL2).l,a3				; load left word buffer for odd scanlines
		lea	(RDE_DevilArtR2).l,a4				; load right word buffer for odd scanlines
		bsr.w	DE_DevilScaleH					; control horizontal scaling

	.Slash2:
		bsr.w	DE_RenderSprites				; render all sprites
		bsr.w	DE_Collision					; handle collision
		bsr.w	DE_PaletteControl				; run palette fading control

		bsr.w	DE_PauseGame					; allow the game to be paused
		tst.b	(RDE_EndingScreen).l				; are we now running the ending screen?
		beq.w	.NoEnding					; if not branch
		sf.b	(ScreenWobble).w				; stop screen shaking
		jmp	DE_EndingScreen					; run ending scene now

	.NoEnding:
		tst.b	(RDE_SonicDead).l				; is Sonic dead?
		beq.w	.NoDeath					; if not, loop
		subq.w	#$01,(RDE_DeathTimer).l				; decrease death timer
		ble.w	.Death						; if finished counting, branch

	.NoDeath:
		tst.b	(Restart_level_flag).w				; has the stage been set to reset?
		bne.w	DDZ_Phase2					; if so, branch
		cmpi.b	#id_DDZ_Phase2,(Game_mode).w			; has the game mode changed?
		beq.w	ML_DDZ_Phase2					; if not, loop
		move.w	#$2700,sr					; disable interrupts
		move.l	#VInt,(V_int_addr).w				; reset interrupt addresses
		move.l	#HInt,(H_int_addr).w				; ''
		jsr	Init_VDP					; reset VDP registers, VRAM, etc...
		sf.b	(ScreenWobble).w				; stop screen shaking
		enableScreen
		rts							; return (exit)

	.Death:
		clr.w	(RDE_DeathTimer).l				; keep timer at 0
		cmpi.w	#$0100,(RDE_SlashFade).l			; is the routine using the slash fade palette?
		bge.s	.NoObtain					; if not, continue normally
		lea	(RDE_PaletteShow+$20).w,a0			; slash/show palette
		lea	(RDE_PaletteCur+$20).w,a1			; actual palette
		moveq	#($60/4)-1,d7					; size of palette to copy back
	.ObtainPalette:
		move.l	(a0)+,(a1)+					; copy the show palette back
		dbf	d7,.ObtainPalette				; ''
	.NoObtain:

ML_DDZ_Phase2Fade:
		move.l	#VB_DevilBossFade,(V_int_addr).w		; set to use fade out V-blank routine
		bsr.w	WaitVBlank					; wait for V-blank
		bsr.w	DE_RenderSprites				; render all sprites
		lea	(RDE_PaletteCur).w,a0				; palette to fade
		moveq	#($80/2)-1,d0					; number of colours
	.Fade:	jsr	Pal_DecColor					; degrade colour
		dbf	d0,.Fade					; repeat for all colours in the palette
		subq.b	#$01,(RDE_DeathFade).l				; decrease fade timer
		bpl.s	ML_DDZ_Phase2Fade				; if still fading, loop
		move.w	#$2700,sr					; disable interrupts
		move.l	#VInt,(V_int_addr).w				; reset interrupt addresses
		move.l	#HInt,(H_int_addr).w				; ''
		jsr	Init_VDP					; reset VDP registers, VRAM, etc...
		sf.b	(ScreenWobble).w				; stop screen shaking

; ---------------------------------------------------------------------------
; The "Devil has no pause" screen
; Most of this is copy/paste from the title screen d=
; ---------------------------------------------------------------------------

		move.w	(Difficulty_Flag).l,d0				; is the game mode easy?
		beq.w	DDZ_Phase2					; if so, replay from phase 2 right away
		tst.b	(RDE_SonicDead).l				; was death caused by pressing the start button?
		bmi.w	.NoHardMessage					; if not, skip message

		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - HInt off, Enable HV counter read
		move.w	#$8200+(vram_fg>>10),(a6)			; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)			; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)				; Command $8700 - Background color Pal 0 Color 0
		move.w	#$8B03,(a6)					; Command $8B07 - VScroll cell-based, HScroll line-based
		move.w	#$8C89,(a6)					; Command $8C89 - 40cell screen size, no interlacing, shadow/highlight enabled
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9100,(a6)					; Command $9100 - Window H position at default
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		move.l	#$40000010,(a6)
		move.l	#$00000000,(a5)
		jsr	(Clear_Palette).w
		jsr	ClearScreen
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		lea	(PLC_Title).l,a5
		jsr	(LoadPLC_Raw_KosM).w

		lea	(MapEni_TitleBGStar).l,a0
		lea	(RAM_start).l,a1
		move.w	#$8030,d0
		jsr	(Eni_Decomp).w
		copyTilemap	vram_bg, 320, 224
		moveq	#palid_Sonic,d0
		jsr	(LoadPalette).w						; load Sonic's palette

	.LoadKosM:
		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	.LoadKosM

		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen

		lea	DE_DevilText(pc),a1
		locVRAM	$C684,d1
		move.w	#$8000,d3
		jsr	(Load_PlaneText).w
		jsr	Pal_TitleFadeFrom

		move.w	#5*60,(Demo_timer).w

	.MainLoop:
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Demo_timer).w
		beq.s	.NoHardMessage
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.MainLoop

	.NoHardMessage:
		enableScreen
		move.b	#id_Level,(Game_mode).w				; set screen mode to $04 (level)
		move.w	#$0300,(Current_zone_and_act).w			; set to DDZ act 1
		rts							; return

; ---------------------------------------------------------------------------
; Text for the "devil has no pause" screen
; ---------------------------------------------------------------------------

	; set the character
		CHARSET ' ', 47
		CHARSET '0','9', 1
		CHARSET 'A','Z', 19
		CHARSET 'a','z', 19
		CHARSET '?', 11
		CHARSET '!', 12
		CHARSET '-', 13
		CHARSET ',', 14
		CHARSET '@', 15
		CHARSET '.', 16
		CHARSET '*', 17
		CHARSET '/', 18

DE_DevilText:	dc.b	"          The Devil has no",$80
		dc.b	"            pause button",-1
		even

		CHARSET ; reset character set

; ---------------------------------------------------------------------------
; Subroutine to pause the game
; ---------------------------------------------------------------------------

DE_PauseGame:
		tst.b	(RDE_FinishBoss).l				; has the boss been defeated?
		bne.s	.NoPause					; if so, ignore pause
		tst.b	(RDE_SonicDead).l				; is Sonic dead?
		bne.s	.NoPause					; if so, ignore pausing (none allowed)
		tst.b	(RDE_PausePresses).l				; has start button been pressed?
		bmi.s	.Pause						; if so, branch

	.NoPause:
		rts							; return

	.Pause:
		sf.b	(RDE_PausePresses).l				; clear start button presses
		cmpi.w	#3,(Difficulty_Flag).l				; are we on maniac difficulty?
		blo.s	.NoManiac					; if not, do normal pause
		lea	(RDE_Sonic).l,a0				; load Sonic's RAM address
		bsr.w	DE_KillSonic					; kill Sonic correctly
		andi.b	#$7F,(RDE_SonicDead).l				; set death as caused by pause button
		rts							; return (no death)

	.NoManiac:
		sf.b	(PauseSlot).w					; reset pause slot
		command	cmd_Pause
		move.l	(RDE_VortexTimer).l,-(sp)			; store vortex timer's state

	.NoUnpause:
		move.l	#VB_DevilBossPause,(V_int_addr).w		; set to use fade out V-blank routine
		bsr.w	WaitVBlank					; wait for V-blank
		bchg.b	#$00,(RDE_VortexTimer+3).l			; change vortex odd/even scanline

		moveq	#$03,d0						; get up/down buttons
		and.b	(RDE_PadA_Pressed).l,d0				; ''
		beq.s	.NoSelection					; if none were pressed, branch
		lsr.b	#$01,d0						; check up
		bcc.s	.Down						; if not pressed, branch
		subq.b	#$01,(PauseSlot).w				; move menu option up
		bcc.s	.NoSelection					; if not gone too high, branch
		move.b	#$03-1,(PauseSlot).w				; reset to bottom
		bra.s	.NoSelection					; continue...

	.Down:
		addq.b	#$01,(PauseSlot).w				; move menu option down
		cmpi.b	#$03,(PauseSlot).w				; has it gone too low?
		blo.s	.NoSelection					; if not, branch
		sf.b	(PauseSlot).w					; reset to top

	.NoSelection:
		tst.b	(RDE_PadA_Pressed).l				; has pause button been pressed?
		bpl.s	.NoUnpause					; if not, branch
		move.l	(sp)+,(RDE_VortexTimer).l			; restore vortex timer's state
		move.b	(PauseSlot).w,d0				; load pause slot
		subq.b	#$01,d0						; check slot
		bcs.s	.Resume						; if pointing to "Resume", branch
		beq.s	.Reset						; if pointing to "Reset", branch
		move.b	#id_Title,(Game_mode).w				; set to exit to title screen
		bra.s	.Unpause					; continue

	.Reset:
		move.b	#$01,(Restart_level_flag).w			; reset the level

	.Resume:
		command	cmd_Unpause					; unpause music

	.Unpause:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup the health for Sonic on init
; ---------------------------------------------------------------------------

DE_SetupHealth:
		moveq	#5*5,d0						; prepare maximum health
		bclr.b	#$07,(Game_mode).w				; clear level select menu flag
		bne.s	.NoStartYet					; if it was set, start with full health
		move.w	(Difficulty_flag).l,d0				; load difficulty setting
		move.b	.HealthList(pc,d0.w),d0				; load health
		cmp.b	(v_hp).w,d0					; does Sonic have the minimum required health?
		ble.s	.NoMinHealth					; if he has larger than the minimum, skip

	.NoStartYet:
		move.b	d0,(v_hp).w					; force minimum

	.NoMinHealth:
		rts							; return

	.HealthList:
		dc.b 5*5	; Easy
		dc.b 4*5	; Normal
		dc.b 2*5	; Hard
		dc.b 0*5	; Maniac

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform collision reactions with objects
; ---------------------------------------------------------------------------

DEC_FLOAT	= %01000000
DEC_ROLL	= %00100000
DEC_HURT	= %00010000
DEC_EXPLODE	= %00000001

DE_Collision:
		lea	(RDE_Collision).l,a2				; load collision list
		move.w	#2-6,(a2)+					; reset jump list
		moveq	#-1,d0						; prepare RAM
		move.w	(a2),d0						; load object RAM address
		beq.w	.NoObjects					; if list is empty, skip
		clr.w	(a2)+						; clear the first slot
		tst.b	(RDE_SonicDead).l				; has Sonic been killed?
		bne.w	.NoObjects					; if so, quit (no collision)
		lea	(RDE_Sonic).l,a0				; load Sonic's object RAM
		tst.b	SO_Touch(a0)					; is Sonic already touched/hurt?
		bne.s	.NoObjects					; if so, ignore collision
		move.w	SO_PosX(a0),d4					; load Sonic's X and Y positions
		move.w	SO_PosY(a0),d5					; ''

	.Check:
		movea.l	d0,a1						; load object slot

		moveq	#$00,d1						; load width
		move.b	(a2)+,d1					; ''
		moveq	#$00,d2						; load height
		move.b	(a2)+,d2					; ''
		move.w	(a2)+,d3					; load type
		move.w	d4,d0						; get distance from Sonic on X
		add.w	d1,d0						; '' (with width)
		sub.w	SO_PosX(a1),d0					; ''
		add.w	d1,d1						; get diameter
		cmp.w	d1,d0						; is the object touching Sonic on X?
		bhs.s	.NoTouch					; if not, ignore
		move.w	d5,d0						; get distance from Sonic on Y
		add.w	d2,d0						; '' (with height)
		sub.w	SO_PosY(a1),d0					; ''
		add.w	d2,d2						; get diameter
		cmp.w	d2,d0						; is the object touching Sonic on Y?
		blo.s	.Touch						; if so, collision found

	.NoTouch:
		move.w	(a2)+,d0					; load next object RAM address
		bne.s	.Check						; if there's another slot, branch

	.NoObjects:
		rts							; return

	.Touch:
	;move.w	#$2700,sr
	;bra.w	*
		moveq	#$00,d0
		add.b	d3,d3						; check for floating bit
		bpl.s	.NoFloat					; if not set, skip floating check
		tst.w	(RDE_RollTimer).l				; is Sonic rolling?
		bne.s	.NoFloat					; if not, skip
		addq.b	#$01,d0						; set touch

	.NoFloat:
		add.b	d3,d3						; check for rolling bit
		bpl.s	.NoRoll						; if not set, skip rolling check
		tst.w	(RDE_RollTimer).l				; is Sonic rolling?
		beq.s	.NoRoll						; if not, then skip touch
		addq.b	#$01,d0						; set touch

	.NoRoll:
		tst.b	d0						; has Sonic touched the object in either of the two ways?
		beq.s	.NoTouch					; if not, skip this object
		st.b	(RDE_Touch).l					; mark a touch as having occured
		st.b	SO_Touch(a1)					; set object as touched

		add.b	d3,d3						; is the object meant to hurt?
		bpl.s	.NoHurt						; if not, branch
		move.b	#60*2,SO_Touch(a0)				; set hurt timer
		st.b	(Update_HUD_ring_count).w			; update HUD
		cmpi.w	#3,(Difficulty_Flag).l				; is this maniac difficulty?
		beq.s	.JustKill					; if so, just kill Sonic
		subq.b	#5,(v_hp).w					; decrease health
		bgt.s	.Hurt						; if not reached passed 0, branch

	.JustKill:
		bsr.s	DE_KillSonic					; kill Sonic correctly
		bra.s	.NoHurt						; skip over SFX play

	.Hurt:
		sfx	SDE_HurtSonic					; play hurt sound

	.NoHurt:
		add.b	d3,d3						; is the object meant to explode?
		beq.s	.NoExplode					; if not, branch
		move.w	SO_PosX(a1),d0					; load X and Y position
		move.w	SO_PosY(a1),d1					; ''
		st.b	d2						; play explosion sfx
		jsr	DE_AddExplosion					; load explosion

	.NoExplode:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Killing Sonic
; --- input -----------------------------------------------------------------
; a0.l = Sonic's object RAM
; ---------------------------------------------------------------------------	

DE_KillSonic:
		tst.b	(RDE_SonicDead).l				; is Sonic already dead?
		bne.w	.DeadAlready					; if so, cancel...
		movem.l	d0-d2/d7-a2,-(sp)				; store registers

		command	cmd_Reset
		music	mus_ArthurDeath					; play death music
		move.b	#$01,(YouDiedY).w				; set you died text to start loading/moving

		st.b	(Update_HUD_ring_count).w			; update the HUD
		sf.b	(v_hp).w					; force to 0
		st.b	(RDE_SonicDead).l				; set Sonic as dead
		st.b	(RDE_FleshArt).l				; load flesh art to VRAM

		lea	(RDE_Flesh).l,a1				; load flesh objects list
		lea	(SineTable+1).w,a2				; load sinewave table
		moveq	#RDE_FLESHCOUNT-1,d7				; number of peices
		moveq	#$00,d2						; reset angle

	.NextFlesh:
		move.w	SO_PosX(a0),SO_PosX(a1)				; set X and Y positions
		move.w	SO_PosY(a0),SO_PosY(a1)				; ''

		jsr	RandomNumber					; get a random number
		clr.w	d1
		swap	d1
		moveq	#$0F,d0						; keep within list
		and.b	d1,d0						; ''
		move.b	.FleshAniList(pc,d0.w),d0			; load correct animation ID from the list
		move.w	d0,SO_Frame(a1)					; set as animation
		lsr.w	#$04,d1						; get angle shift
		divu.w	#($0100/(RDE_FLESHCOUNT/2)),d1			; keep in range of wedge
		swap	d1						; ''
		add.b	d2,d1						; add angle to wedge
		addi.b	#($0100/(RDE_FLESHCOUNT/2)),d2			; rotate angle for next piece
		add.w	d1,d1						; load sine positions
		move.w	-$01(a2,d1.w),d0				; ''
		move.w	+$7F(a2,d1.w),d1				; ''
		ext.l	d0						; extend to long-word
		ext.l	d1						; ''
		asl.l	#$08,d0						; speed up
		asl.l	#$08,d1						; ''
		cmpi.w	#RDE_FLESHCOUNT/2,d7					; is this the inner track?
		bge.s	.Inner						; if so, skip over faster speed
		add.l	d0,d0						; speed up faster for outter track
		add.l	d1,d1						; ''

	.Inner:
		move.l	d0,SO_SpeedX(a1)				; set speed of flesh
		move.l	d1,SO_SpeedY(a1)				; ''
		lea	SO_Size(a1),a1					; advance to next slot
		dbf	d7,.NextFlesh					; repeat for all pieces
		movem.l	(sp)+,d0-d2/d7-a2				; restore registers

	.DeadAlready:
		rts							; return

	.FleshAniList:
		dc.b	$05,$01,$05,$03,$04,$05,$00,$05,$02,$05,$04,$05,$00,$01,$05,$03

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to save an object for collision
; --- input -----------------------------------------------------------------
; d0.b = width
; d1.b = height
; d2.w = Harm type
; a0.l = object RAM slot
; ---------------------------------------------------------------------------

DE_AddCollision:
		pea	(a2)						; store a2
		lea	(RDE_Collision).l,a2				; load collision list
		cmpi.w	#(20*3)+2,(a2)					; is the collision list full?
		bge.s	.NoSpace					; if so, skip
		addq.w	#$06,(a2)					; advance to next slot
		adda.w	(a2),a2						; advance to correct slot
		move.w	a0,(a2)+					; store object
		move.b	d0,(a2)+					; store width
		move.b	d1,(a2)+					; store height
		move.w	d2,(a2)+					; store harm type
		clr.w	(a2)						; set end of list

	.NoSpace:
		move.l	(sp)+,a2					; restore a2
		sf.b	SO_Touch(a0)					; clear touch flag
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

DE_DeleteObject:
		movem.l	d0/a0,-(sp)					; store d0 and objects
		moveq	#$00,d0						; clear d0
		rept	SO_Size/4
		move.l	d0,(a0)+					; clear object RAM long-word
		endm
		rept	(SO_Size-((SO_Size/4)*4))/2
		move.w	d0,(a0)+					; clear object RAM word
		endm
		movem.l	(sp)+,d0/a0					; restore d0 and object
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to control the palette - for fading when the slash attack occurs
; ---------------------------------------------------------------------------

DE_PaletteControl:
		subq.b	#$01,(RDE_Damage).l				; decrease hit timer
		bcc.s	.HurtFlash					; if still counting, branch
		sf.b	(RDE_Damage).l					; keep hit timer at 0
		bra.s	.NoHurt

	.HurtFlash:
		move.b	(RDE_Damage).l,d4				; load timer
		lea	(RDE_PaletteMain+$20).w,a1			; load original palette
		lea	(RDE_PaletteCur+$20).w,a2			; load destination palette
		lea	(RDE_BossColours).l,a3				; load flash palette
		jsr	DDZ_RunWormHead.HurtFlash			; run flashing
		st.b	(RDE_DamagePal).l				; set to update the boss's damage palette line

	.NoHurt:

		move.w	(RDE_SlashFade).l,d3				; load slash fading amount
		bgt.s	.NoBlack					; if not minimum, branch
		cmp.w	(RDE_SlashPrev).l,d3				; has the transfer already been done?
		beq.s	.NoTransfer					; if so, don't bother
		lea	(RDE_PaletteShow+$20).w,a1			; load destination palette
		moveq	#$00,d0						; clear d0
		moveq	#(($30/2)/4)-1,d1				; number of colours to clear and force black

	.YesBlack:
		move.l	d0,(a1)+					; force colours to black
		move.l	d0,(a1)+					; ''
		move.l	d0,(a1)+					; ''
		move.l	d0,(a1)+					; ''
		dbf	d1,.YesBlack					; ''

	.NoTransfer:
		rts							; return

	.NoBlack:
		cmpi.w	#$0100,d3					; is it at maximum?
		blo.s	.Convert					; if not, do a fade conversion
		rts							; return (PaletteCur will be DMA'd instead)

	.Convert:
		lea	(RDE_PaletteCur+$20).w,a0			; load source palette
		lea	(RDE_PaletteShow+$20).w,a1			; load destination palette
		moveq	#$30-1,d4					; number of colours left to fade

	.NextColour:
		moveq	#$00,d0						; load blue
		move.b	(a0)+,d0					; ''
		mulu.w	d3,d0						; scale blue
		moveq	#$00,d1						; load green and red
		move.b	(a0)+,d1					; ''
		moveq	#$0F,d2						; load red only
		and.b	d1,d2						; ''
		sub.b	d2,d1						; load green only
		mulu.w	d3,d1						; scale green
		mulu.w	d3,d2						; scale red
		andi.w	#$F000,d1					; fuse green and red together
		or.w	d2,d1						; ''
		move.w	d1,(a1)						; divide by 100
		move.b	(a1),d0						; '' (and save with blue)
		move.w	d0,(a1)+					; save blue, green, and red
		dbf	d4,.NextColour					; repeat for all colours
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to animate devil eggman correctly
; ---------------------------------------------------------------------------

DE_DevilAnimate:
	;tst.b	(RDE_LagOccur).l				; is the game lagging?
	;bne.s	.NoAni						; skip animating
		move.w	(RDE_AniFrame).l,d0				; load frame ID
		addq.w	#$02,d0						; advance frame ID
		move.w	d0,d1
		add.w	d1,d1
		lea	DE_AniList(pc),a0				; load animation list
		tst.b	(RDE_AniArms).l					; are we showing the arms?
		bne.s	.NoArms						; if not, branch
		lea	DE_AniListArms(pc),a0				; load animation list (with arms)
		move.l	(a0,d1.w),(RDE_AniArt).l			; load frame ID
		bpl.s	.Valid						; if not the end of the list, branch

	.Reset:
		moveq	#$00,d0						; reset frame
		move.w	d0,d1						; ''

	.NoArms:
		move.l	(a0,d1.w),(RDE_AniArt).l			; load frame ID
		bmi.s	.Reset						; if the end of the list, branch

	.Valid:
		move.w	d0,(RDE_AniFrame).l				; update frame ID

	.NoAni:
		rts							; return

	; --- Animation list (No arms) ---

DE_AniList:	dc.l	($01<<$18)|Art_DevEggN00
		dc.l	($01<<$18)|Art_DevEggN01
		dc.l	($01<<$18)|Art_DevEggN02
		dc.l	($01<<$18)|Art_DevEggN03
		dc.l	($01<<$18)|Art_DevEggN04
		dc.l	($01<<$18)|Art_DevEggN05
		dc.l	($01<<$18)|Art_DevEggN06
		dc.l	($01<<$18)|Art_DevEggN07
		dc.l	($01<<$18)|Art_DevEggN08
		dc.l	($01<<$18)|Art_DevEggN09
		dc.l	($01<<$18)|Art_DevEggN10
		dc.l	($01<<$18)|Art_DevEggN11
		dc.w	$FFFF

	; --- Animation list (WITH arms) ---

DE_AniListArms:	dc.l	Art_DevEggA00
		dc.l	Art_DevEggA01
		dc.l	Art_DevEggA02
		dc.l	Art_DevEggA03
		dc.l	Art_DevEggA04
		dc.l	Art_DevEggA05
		dc.l	Art_DevEggA06
		dc.l	Art_DevEggA07
		dc.l	Art_DevEggA08
		dc.l	Art_DevEggA09
		dc.l	Art_DevEggA10
		dc.l	Art_DevEggA11
		dc.w	$FFFF

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle proceedural events with the boss
; ---------------------------------------------------------------------------

DE_Events:
		move.l	(RDE_Events).l,d0				; load events routine
		bne.s	.Valid						; if valid, continue
		move.l	#DEE_Start,d0					; set to use starting routine instead

	.Valid:
		movea.l	d0,a0						; set address

		tst.b	(RDE_MoveBossIn).l				; is the boss set to move in slowly?
		beq.s	.NoMoveIn					; if not, branch
		move.l	(RDE_MoveBossSpeed).l,d1			; speed of scale
		sub.l	d1,(RDE_ScaleX).l				; scale X in
		bcc.s	.InX						; if we're not reached 0 yet, continue
		clr.l	(RDE_ScaleX).l					; keep at 0

	.InX:
		sub.l	d1,(RDE_ScaleY).l				; scale Y in
		bcc.s	.InY						; if we're not reached 0 yet, continue
		clr.l	(RDE_ScaleY).l					; keep at 0

	.InY:

	.NoMoveIn:
		lea	(RDE_Events).l,a4				; load events routine RAM address
		bsr.s	.RunMove					; run the normal routines
		lea	(RDE_Events2).l,a4				; load second events routine
		move.l	(a4),d0						; load routine
		beq.s	.NoRun						; if there is no second move, branch
		movea.l	d0,a0						; set address
		cmpi.l	#DEE_Idle,d0					; is it about to run the idle routine?
		bne.s	.RunMove					; if not, run the move
		clr.l	(a4)						; do NOT allow the second attack to run the idle routine (only the first one can)

	.NoRun:
		rts							; return

	.RunMove:
		subq.w	#$01,$08(a4)					; decrease delay timer
		bcc.s	.NoStopTimer					; if not finished, branch
		clr.w	$08(a4)						; force timer to 0 (and set the Z flag)

	.NoStopTimer:
		jmp	(a0)						; run event routine

; ---------------------------------------------------------------------------
; Startup / Intro
; ---------------------------------------------------------------------------

DEE_Start:
		move.w	#$0420,(RDE_VortexSpeed).l			; set starting speed
		move.w	#$0080,(RDE_VortexDest).l			; set destination speed
		clr.w	(RDE_VortexAccel).l				; no acceleration until next frame
		move.w	#320/2,(RDE_PosX).l				; set position of boss
		move.w	#224/2,(RDE_PosY).l				; ''

		lea	(RDE_Sonic).l,a0				; load Sonic's RAM
		move.w	#(320/2),SO_PosX(a0)				; set starting X position
		move.w	#(224/2)+32,SO_PosY(a0)				; set starting Y position
		move.w	#$8000|(VDE_SonicRoll/$20),SO_Pattern(a0)	; set pattern for rolling Sonic
		move.l	#Map_SonRoll,SO_Mappings(a0)			; set mappings for rolling Sonic

		move.l	#$00100000,(RDE_ScaleX).l			; set starting scale position
		move.l	#$00100000+$4000,(RDE_ScaleY).l			; ''
		move.w	#$0EEE,(RDE_VortexColour).l			; set starting vortex colour
		clr.w	(RDE_VortexCycle).l				; reset blend to colour amount
		move.l	#DEE_Intro,(a4)					; set next routine
		rts							; return

DEE_Intro:
		move.w	#$0008,(RDE_VortexAccel).l			; set vortex to accelerate/deccelerate
		moveq	#$03,d0						; get every 4 frames
		and.b	(RDE_VortexTimer+3).l,d0			; ''
		bne.s	.NoBlack					; if it's not been a 4th frame, branch
		subi.w	#$0111,(RDE_VortexColour).l			; reduce vortex colour to black
		bcc.s	.NoBlack					; if it's not reached black yet, branch
		clr.w	(RDE_VortexColour).l				; keep at black
		move.l	#DEE_Intro2,(a4)				; set next routine

	.NoBlack:

DEE_SetSonicPal:
		lea	(RDE_PaletteCur).w,a1				; load Sonic's palette line
		moveq	#($20/4)-1,d1					; size of line
		move.w	(RDE_VortexColour).l,d0				; load vortex colour to both words
		swap	d0						; ''
		move.w	(RDE_VortexColour).l,d0				; ''

	.SetSonic:
		move.l	d0,(a1)+					; set Sonic to use the same colours as the vortex
		dbf	d1,.SetSonic					; ''
		rts							; return


DEE_Intro2:
		move.w	(RDE_VortexDest).l,d0				; has the vortex reached destination speed?
		cmp.w	(RDE_VortexSpeed).l,d0				; ''
		beq.s	.Reached					; if so, branch to finish

		moveq	#$03,d0						; get every 4 frames
		and.b	(RDE_VortexTimer+3).l,d0			; ''
		bne.s	.NoInvert					; if it's not been a 4th frame, branch
		cmpi.w	#$0777,(RDE_VortexColour).l			; are we in the middle (grey)?
		bne.s	.NoShowSonic					; if not, don't show Sonic yet
		st.b	(RDE_ShowSonic).l				; allow Sonic to show now

	.NoShowSonic:
		cmpi.w	#$0EEE,(RDE_VortexColour).l			; has the colour reached white again?
		beq.s	.NoInvert					; if so, branch
		move.l	#$01110111,d0					; prepare colour add amount in both words
		add.w	d0,(RDE_VortexColour).l				; increase vortex from black to white
		lea	(RDE_PaletteCur+$20).w,a1			; decrease rest of palette from white to black
		moveq	#($60/4)-1,d1					; '' (size)

	.Invert:
		sub.l	d0,(a1)+					; decrease to black
		dbf	d1,.Invert					; ''

	.NoInvert:
		bra.w	DEE_SetSonicPal					; force Sonic's line to white

	.Reached:
		move.l	#DEE_Intro3,(a4)				; change to next routine
		move.b	#$16-1,(RDE_FadeCount).l			; set fade counter (for Sonic engine's palette fading)
		move.w	#$202F,(Palette_fade_info).w			; set palette line and size to fade


DEE_Intro3:
		tst.b	(RDE_VortexCycle).l				; has the vortex fully blended to cycle colours yet?
		bne.s	.BlendDone					; if so, skip blending
		addq.w	#$04,(RDE_VortexCycle).l			; increase blend from vortex colour to cycle colours
		subq.b	#$01,(RDE_FadeCount).l				; decrease fade counter
		bcs.s	.NoFade						; if finished, skip

	; --- Sonic's fading ---
	; Because hellfire has no white fading, it
	; has to be done manually
	; ----------------------

		btst.b	#$00,(RDE_FadeCount).l				; is this an odd frame?
		beq.s	.NoFadeSon					; if not, skip (Sonic's fading is quicker than the engine's)
		lea	(RDE_PaletteMain).w,a0				; load Sonic's palette
		lea	(RDE_PaletteCur).w,a1				; load Sonic's buffer
		moveq	#$10-1,d2					; number of colours to fade manually
		bsr.s	DEE_FadeToColour				; fade to white

	.NoFadeSon:
		jmp	Pal_FromBlack					; fade the rest from black normally

	.NoFade:
		sf.b	(RDE_FadeCount).l				; keep fade counter at 0
		rts							; return

	.BlendDone:
		move.b	#$01,HUD_State.w				; set HUD to move in
		move.l	#DEE_Intro4,(a4)				; set next events routine to run
		samp	sfx_Mwahaha					; play laughing sfx
		move.w	#$0004,(RDE_VortexAccel).l			; set acceleration speed
		move.w	#$0180,(RDE_VortexDest).l			; set destination speed to speed up
		st.b	(RDE_IntroFinish).l				; set intro as basically finished for the palette
		bra.w	DEE_Intro4					; run next events routine

DEE_FadeToColour:
	.NextCol:
		move.b	(a0)+,d0					; load blue
		cmp.b	(a1)+,d0					; has it reached?
		beq.s	.BlueOkay					; if so, skip
		subq.b	#$02,-$01(a1)					; reduce to colour

	.BlueOkay:
		move.b	(a0),d0						; load green
		move.b	(a1),d1						; ''
		andi.w	#$00E0,d0					; ''
		andi.w	#$00E0,d1					; ''
		cmp.w	d1,d0						; has it reached?
		beq.s	.GreenOkay					; if so, skip
		subi.b	#$20,(a1)					; reduce to colour

	.GreenOkay:
		moveq	#$0E,d1						; load red
		move.b	(a0)+,d0					; ''
		and.w	d1,d0						; ''
		and.b	(a1)+,d1					; ''
		cmp.b	d1,d0						; has it reached?
		beq.s	.RedOkay					; if so, skip
		subq.b	#$02,-$01(a1)					; reduce to colour

	.RedOkay:
		dbf	d2,.NextCol					; repeat for Sonic's palette line
		rts							; return


DEE_Intro4:
		move.l	(RDE_ScaleX).l,d0				; load X scaling
		move.l	(RDE_ScaleY).l,d1				; load Y scaling
		move.l	#$00002000,d2					; speed of scaling in
		sub.l	d2,d0						; scale X in
		bcc.s	.NoOverX					; if not finished, continue
		moveq	#$00,d0						; force to 0

	.NoOverX:
		sub.l	d2,d1						; scale Y in
		bcc.s	.NoOverY					; if not finished, continue
		moveq	#$00,d1						; force to 0

	.NoOverY:
		move.l	d0,(RDE_ScaleX).l				; update scale positions
		move.l	d1,(RDE_ScaleY).l				; ''
		or.l	d0,d1						; are both at 0?
		bne.s	DEE_Intro5.Wait					; if not, branch
		move.w	#$0080,(RDE_VortexDest).l			; set vortex destination speed to slow down again
		move.l	#DEE_Intro5,(a4)				; set next events routine to run

DEE_Intro5:
		move.w	(RDE_VortexDest).l,d0				; has the vortex reached destination speed?
		cmp.w	(RDE_VortexSpeed).l,d0				; ''
		bne.s	.Wait						; if not, branch and wait
		move.l	#DEE_Idle,(a4)					; set to idle phase

	; set delay timer here before idle should finish
	move.w	#60*2,$08(a4)					; set delay timer before idle finishes

	.Wait:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Moving out phase
; ---------------------------------------------------------------------------

DEE_MoveOut:
		bne.s	.Wait						; if not finished delaying, branch
		move.w	#$0008,(RDE_VortexAccel).l			; set vortex speed
		move.w	#$FF80,(RDE_VortexDest).l			; set destination to go backwards (while boss is flying in the distance)

		tst.w	(RDE_VortexSpeed).l				; has the vortex starting moving backwards yet?
		bne.s	.NoSFX						; if it's not reached exactly 0, branch
		sfx	SDE_FlyBack					; play flying back SFX
		bra.s	.NoScale					; continue

	.NoSFX:
		bpl.s	.NoScale					; if not, wait until it's going backwards before scaling boss away
		move.l	#$00000400,d1					; speed of scale
		move.l	(RDE_ScaleX).l,d0				; load X scale
		add.l	d1,(RDE_ScaleY).l				; move Y back
		add.l	d1,d0						; move X back
		cmp.l	(RDE_MoveBossDist).l,d0				; has it scaled back far enough?
		bmi.s	.ContScale					; if not, continue scaling
		move.w	#$0080,(RDE_VortexDest).l			; set destination to go forwards again

		move.l	#DEE_Idle,(a4)					; set to go to main idle routine
		move.w	#60*1,$08(a4)					; set delay time

		move.l	(RDE_MoveBossDist).l,d0				; force scale to end position
		move.l	d0,(RDE_ScaleY).l				; ''
		st.b	(RDE_MoveBossIn).l				; set boss to start moving in again

	.ContScale:
		move.l	d0,(RDE_ScaleX).l				; set X scale

	.NoScale:
	.Wait:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Idle phase - attack list processing
; ---------------------------------------------------------------------------
; This routine can ONLY be ran by the normal events routine, the second events
; routine must NEVER run this, as this routine decides which events routines
; are to be ran for both.
; ---------------------------------------------------------------------------

DEE_Idle:
		bne.w	.Wait						; if not finished delaying, branch
		tst.l	(RDE_Events2).l					; is there still a second attack running?
		bne.s	.Wait						; if so, don't load next move until it's finished

		move.l	(RDE_ScaleX_CAP).l,d0				; has the boss fully scaled in?
		or.l	(RDE_ScaleY_CAP).l,d0				; ''
		bne.w	.NoMoveOut					; if not, continue and do another move
		tst.b	(RDE_DoneSlash).l				; has the slash routine been ran?
		bpl.s	.DoneSlash					; if so, branch
		move.l	#DEE_SlashAttack,(RDE_Events).l			; set events routine to run the slash attack
		rts							; return (don't do next list until slash is done

	.DoneSlash:
		st.b	(RDE_DoneSlash).l				; clear flag for next list
		bne.s	.NoSlashHit					; if the slash is done, BUT Sonic was hit, branch to run the last move again

		move.l	(RDE_AttackOrder).l,d0				; load attack order list
		bne.s	.GetList					; if valid, continue
		move.w	(Difficulty_Flag).l,d0				; load difficulty flag
		add.w	d0,d0						; multiply to x4 long-word
		add.w	d0,d0						; ''
		lea	DEE_AttackDiff(pc),a0				; load correct attack list
		move.l	(a0,d0.w),d0					; ''

	.GetList:
		movea.l	d0,a0						; set address order list
		move.l	(a0)+,d0					; load list address
		bmi.w	DEE_EndBoss					; if it's the end of the list, reset...
		move.l	a0,(RDE_AttackOrder).l				; update attack order list
		movea.l	d0,a0						; set address of new attack list
		move.l	(a0)+,d0					; set distance to move back by (and clear the move in flag)

	.NoMovesInList:
		move.l	d0,(RDE_MoveBossDist).l
		move.l	(a0)+,(RDE_MoveBossSpeed).l			; set scaling in speed
		beq.s	.NoSlashImmediate				; if there's no scaling, then skip and allow idle routine to run again
		move.l	#DEE_MoveOut,(RDE_Events).l			; set move/routine

	.NoSlashImmediate:
		move.l	a0,(RDE_AttackList).l				; set list address

	.Wait:
		rts							; return

	.NoSlashHit:
		move.l	(RDE_AttackList).l,a0
		tst.l	-$08(a0)
		bne.s	.NotSlashOnly
		rts

	.NotSlashOnly:
		move.l	#$00008000,(RDE_MoveBossDist).l
		move.l	#$00000040,(RDE_MoveBossSpeed).l
		move.l	#DEE_MoveOut,(RDE_Events).l
		rts

	.NoMoveOut:
	;	move.l	(RDE_AttackList).l,d0				; load attack list address
	;	bne.s	.GetAttack					; if a list is set, branch (Shouldn't happen, but just in-case)
	;	move.l	#DEE_AttackList1+8,d0				; just set the first list (Shouldn't happen, but just in-case)
	;
	;.GetAttack:
	;	movea.l	d0,a0						; set address
		move.l	(RDE_AttackList).l,a0				; load attack list address
		move.l	(a0)+,d0					; load attack
		bpl.s	.ValidAttack					; if it's not the end of the list, branch
		lea	-$0C(a0),a0					; move back to last attack in the list
		move.l	(a0)+,d0					; load last attack again (just in-case)
		beq.s	.NoMovesInList					; if the list has no moving back (it's the first list, so branch up and do the slash attack normally again)

	.ValidAttack:
		move.l	(a0)+,(RDE_Events2).l				; set second move/routine
		move.l	a0,(RDE_AttackList).l				; update attack list
		move.l	d0,(RDE_Events).l				; set move/routine
		rts							; return

; ---------------------------------------------------------------------------
; Main attack list order
; ---------------------------------------------------------------------------
; DEE_AttackDiff:

		include "Attack List (Phase 2).asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Delay phase - Delays deliberately for a period, then runs the next routine requested
; ---------------------------------------------------------------------------

DEE_Delay:
		bne.s	.Wait						; if not finished delaying, branch
		move.l	$04(a4),(a4)					; set next move/routine to run

	.Wait:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; When the boss has been defeated
; ---------------------------------------------------------------------------

DEE_EndBoss:
		st.b	(RDE_FinishBoss).l				; set boss as now finished
		move.w	#$0001,(RDE_VortexAccel).l			; set vortex accel/decel to be slow
		move.w	#$FFC0,(RDE_VortexDest).l			; set destination to stop
		move.l	#DEE_Centralise,(RDE_Events).l			; send end routine
		move.w	#01,(RDE_RollTimer).l	; for animation speed	; set Sonic's roll timer

DEE_Centralise:
		move.l	#$00000400,d0					; speed of back scale
		move.l	#$00080000,d1					; last scale


		moveq	#$02,d5
		add.l	d0,(RDE_ScaleX).l
		cmp.l	(RDE_ScaleX).l,d1
		bpl.s	.ContScaleX
		move.l	d1,(RDE_ScaleX).l
		subq.b	#$01,d5

	.ContScaleX:
		add.l	d0,(RDE_ScaleY).l
		cmp.l	(RDE_ScaleY).l,d1
		bpl.s	.ContScaleY
		move.l	d1,(RDE_ScaleY).l
		subq.b	#$01,d5

	.ContScaleY:
		move.w	#320/2,d1
		sub.w	(RDE_PosX).l,d1
		move.w	#224/2,d2
		sub.w	(RDE_PosY).l,d2
	or.w	d1,d5
	or.w	d2,d5
	beq.s	.NoMoveBoss
		bsr.s	.MoveCentre
		add.l	d0,(RDE_PosX).l
		add.l	d1,(RDE_PosY).l

	.NoMoveBoss:
		move.w	#320/2,d1
		sub.w	(RDE_Sonic+SO_PosX).l,d1
		move.w	#224/2,d2
		sub.w	(RDE_Sonic+SO_PosY).l,d2
	or.w	d1,d5
	or.w	d2,d5
	bne.s	.MoveSonic
	move.l	#DEE_EndCharge,(RDE_Events).l
	sfx	SDE_BoostSFX					; play boost sfx
	move.w	#45,(RDE_RollTimer).l	; for animation speed	; set Sonic's roll timer to maximum
	move.w	#$0003,(RDE_VortexAccel).l			; set vortex accel/decel to be slow
	move.w	#$0200,(RDE_VortexDest).l			; set destination to something really fast
	move.b	#$30,(RDE_LastBoostTimer).l			; time to charge and release
	st.b	(RDE_LastBoostArt).l				; load the charging art...
	rts

	.MoveSonic:
		bsr.s	.MoveCentre
		add.l	d0,(RDE_Sonic+SO_PosX).l
		add.l	d1,(RDE_Sonic+SO_PosY).l
		rts

	.MoveCentre:
		jsr	CalcAngle					; get angle from distance
		lea	(SineTable+1).w,a0				; load sine table
		moveq	#$00,d1						; load only the low byte angle
		move.b	d0,d1						; ''
		add.w	d1,d1						; ''
		move.w	+$7F(a0,d1.w),d0				; get X
		move.w	-$01(a0,d1.w),d1				; get Y
		ext.l	d0						; align quotient
		ext.l	d1						; ''
		asl.l	#$08,d0						; ''
		asl.l	#$08,d1						; ''
		rts							; return

	; --- Zooming towards eggman to destroy him ---

DEE_EndCharge:
		move.b	(RDE_LastBoostTimer).l,d0			; load timer
		beq.s	.Finish						; if finished, skip over SFX
		subq.b	#$01,(RDE_LastBoostTimer).l			; decrease charge timer
		bne.s	.NoRelease					; if not just finished now, continue charging
		sfx	SDE_ReleaseSFX					; play dash release sfx
		bra.s	.Finish						; continue (dash done)

	.NoRelease:
		andi.w	#$0007,d0					; is it timer to charge SFX again?
		bne.s	.Finish						; if not, continue...
		sfx	SDE_ChargeSFX					; play dash charge sfx

	.Finish:
		move.l	(RDE_ScaleX).l,d0				; load X scaling
		move.l	(RDE_ScaleY).l,d1				; load Y scaling
		move.l	#$00001000,d2					; speed of scaling in
		sub.l	d2,d0						; scale X in
		bcc.s	.NoOverX					; if not finished, continue
		moveq	#$00,d0						; force to 0

	.NoOverX:
		sub.l	d2,d1						; scale Y in
		bcc.s	.NoOverY					; if not finished, continue
		moveq	#$00,d1						; force to 0

	.NoOverY:
		move.l	d0,(RDE_ScaleX).l				; update scale positions
		move.l	d1,(RDE_ScaleY).l				; ''
		or.l	d0,d1						; are both at 0?
		bne.s	.Wait						; if not, branch
		move.l	#DEE_EndExplode,(RDE_Events).l			; set explode routine
		move.b	#$16-1,(RDE_FadeCount).l			; set fade counter
		move.w	#$0EEE,(RDE_VortexColour).l			; set to fade vortex to white
		move.w	#60,(RDE_Delay).l				; set delay time for explosion before fading out
		fadeout							; fade out music

	.Wait:
		rts

	; --- Exploding and fading to white ---

DEE_EndExplode:
		jsr	RandomNumber					; randomise explosion positions
		andi.w	#$007F,d0					; get in range of X
		subi.w	#$0040,d0					; allow left side
		add.w	(RDE_DispX).l,d0				; move to boss centre
		lsr.w	#$08,d1						; get in rnage of Y
		andi.w	#$007F,d1					; ''
		subi.w	#$0040,d1					; allow top side
		add.w	(RDE_DispY).l,d1				; move to boss centre
		st.b	d2						; play explosion sfx
		jsr	DE_AddExplosion					; load explosion
		tst.w	(RDE_Delay).l					; is it time to fade in?
		bne.s	.Wait						; if not, branch
		moveq	#$01,d3						; reset done flag
		moveq	#$03,d0						; has it been a 4th frame?
		and.b	(RDE_VortexTimer+3).l,d0			; ''
		bne.s	.NoFade						; if not, skip palette fading (delaying speed of fade)
		move.b	#$20,(ScreenWobble).w				; set screen to shake
		moveq	#$00,d3						; set done flag
		lea	(RDE_PaletteCur).w,a0				; load palette
		moveq	#$80-1,d2					; number of colours to fade manually
		moveq	#$00,d0						; clear upper word of d0
		bsr.s	.NextColour					; convert palette

	.NoFade:
		tst.w	(RDE_VortexCycle).l				; has the vortex fully blended to cycle colours yet?
		beq.s	.BlendDone					; if so, skip blending
		subq.w	#$04,(RDE_VortexCycle).l			; increase blend from vortex colour to cycle colours
		rts

	.Wait:
		moveq	#$03,d0						; has it been a 4th frame?
		and.b	(RDE_VortexTimer+3).l,d0			; ''
		bne.s	.NoShake					; if not, skip palette fading (delaying speed of fade)
		move.b	#$20,(ScreenWobble).w				; set screen to shake

	.NoShake:
		rts

	.BlendDone:
		tst.b	d3						; have all palettes faded in fully?
		beq.s	.Finish						; if so, finish up
		rts							; return

	.NextColour:
		cmpi.b	#$0E,(a0)+					; has blue reached max?
		beq.s	.NoBlue						; if so, continue
		addq.b	#$01,-$01(a0)					; increase blue
		st.b	d3						; mark fade as unfinished

	.NoBlue:
		move.b	(a0),d0						; load green and red
		cmpi.w	#$00E0,d0					; has green reached max?
		bge.s	.NoGreen					; if so, continue
		addi.b	#$10,d0						; increase green
		st.b	d3						; mark fade as unfinished

	.NoGreen:
		moveq	#$0E,d1						; load red only
		and.b	d0,d1						; ''
		cmpi.b	#$0E,d1						; had red reached max?
		beq.s	.NoRed						; if so, continue
		addq.b	#$01,d0						; increase red
		st.b	d3						; mark fade as unfinished

	.NoRed:
		move.b	d0,(a0)+					; update green and red
		dbf	d2,.NextColour					; repeat for entire palette
		rts							; return

	.Finish:
		move.l	#DEE_EndDone,(RDE_Events).l			; Finish routine...
		st.b	(RDE_EndingScreen).l				; set to go to the ending screen

	; --- Finish ---

DEE_EndDone:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Slash attack
; ---------------------------------------------------------------------------

DEE_SlashAttack:
		cmpi.l	#VB_DevilBoss1,(V_int_addr).w			; are we on the right scanline?
		bne.s	.Cont						; if not, wait (don't want half a frame drawn and frozen)
		cmpi.w	#$0004,(RDE_AniFrame).l				; is the devil showing their full wing frame?
		beq.s	.Run						; if so, branch and do the fade out!

	.Cont:
		rts							; return (delay)

	.Run:
		move.l	#DEE_SlashFade,(a4)				; set next routine
		move.w	#$0001,(RDE_VortexAccel).l			; set vortex accel/decel to be slow
		clr.w	(RDE_VortexDest).l				; set destination to stop

DEE_SlashFade:
		subq.w	#$02,(RDE_SlashFade).l				; decrease slash fading speed
		bpl.s	DEE_SlashAttack.Cont				; if not finished, branch
		clr.w	(RDE_SlashFade).l				; keep fade at black
		st.b	(RDE_LoadSlashArt).l				; load slash art
		move.l	#DEE_SlashStart,(a4)				; set next routine
		move.b	#3,(RDE_SlashCount).l				; set number of slashes to do

	; --- Setting up objects for slash direction randomly ---

DEE_SlashStart:
		jsr	RandomNumber					; get random number
		andi.w	#$00E0,d0					; get slash angle
		move.b	d0,(RDE_SlashDirection).l			; save as slash direction
		lea	.Slash(pc,d0.w),a0				; load correct set of positions

		movem.l	(a0)+,d1-d6					; load positions, distances, and speeds

		swap	d0						; store slash angle for later
		move.l	(a0)+,d7					; get random X shift
		and.w	d0,d7						; ''
		swap	d7						; add shift to X position
		add.l	d7,d1						; ''

		move.l	(a0)+,d7					; get random Y shift
		and.w	d0,d7						; ''
		swap	d7						; add shift to Y position
		add.l	d7,d2						; ''
		swap	d0						; restore slash angle

		lsr.b	#$04,d0						; align angle for marker frame
		andi.b	#$06,d0						; ''
		addq.w	#$02,d0						; ''

		lea	(RDE_Claws).l,a0				; clear object RAM
		moveq	#5-1,d7						; number of claw objects (NOT the trails)

	.Next:
		jsr	DE_DeleteObject					; clear object slot
		move.w	d0,SO_Frame(a0)					; set frame number
		move.l	d1,SO_PointX(a0)				; set X position
		move.l	d1,SO_PosX(a0)					; ''
		move.l	d2,SO_PointY(a0)				; set Y position
		move.l	d2,SO_PosY(a0)					; ''
		add.l	d3,d1						; advance for next X
		add.l	d4,d2						; advance for next Y
		move.w	#$8000|(VDE_Slash/$20),SO_Pattern(a0)		; set pattern index
		move.l	#Map_SlashDE,SO_Mappings(a0)			; set mappings list to use

		move.l	d5,SO_SpeedX(a0)				; set X and Y speeds
		move.l	d6,SO_SpeedY(a0)				; ''
		sf.b	SO_Touch(a0)					; clear touch flag

		move.w	#90,SO_Timer(a0)				; set marker time going along the screen
		lea	SO_Size(a0),a0					; advance to next slot
		dbf	d7,.Next					; repeat for all 5 main claw objects

		sf.b	(RDE_Touch).l					; clear touch flag
		move.l	#DEE_SlashMarkers,(a4)				; set marker move routine
		rts							; return

	.Slash:	; 00 up
		dc.l	$00100000,$01200000	; X pos, Y pos
		dc.l	$00440000,$00000000	; X dist, Y dist
		dc.l	$00000000,$FFFC0000	; X speed, Y speed
		dc.l	$0000003F,$00000000	; X random mask, Y random mask

		; 20 up/right
		dc.l	$FFA00000,$00500000	; X pos, Y pos
		dc.l	$00440000,$00440000	; X dist, Y dist
		dc.l	$00030000,$FFFD0000	; X speed, Y speed
		dc.l	$0000003F,$0000003F	; X random mask, Y random mask

		; 40 right
		dc.l	$FFF00000,$FFE00000	; X pos, Y pos
		dc.l	$00000000,$00440000	; X dist, Y dist
		dc.l	$00040000,$00000000	; X speed, Y speed
		dc.l	$00000000,$0000003F	; X random mask, Y random mask

		; 60 right/down
		dc.l	$00700000,$FF800000	; X pos, Y pos
		dc.l	$FFBC0000,$00440000	; X dist, Y dist
		dc.l	$00030000,$00030000	; X speed, Y speed
		dc.l	$0000003F,$0000003F	; X random mask, Y random mask

		; 80 down
		dc.l	$00100000,$FFC00000	; X pos, X dist
		dc.l	$00440000,$00000000	; Y pos, Y dist
		dc.l	$00000000,$00040000	; X speed, Y speed
		dc.l	$0000003F,$00000000	; X random mask, Y random mask

		; A0 down/left
		dc.l	$01A00000,$00900000	; X pos, Y pos
		dc.l	$FFBC0000,$FFBC0000	; X dist, Y dist
		dc.l	$FFFD0000,$00030000	; X speed, Y speed
		dc.l	$0000003F,$0000003F	; X random mask, Y random mask

		; C0 left
		dc.l	$01500000,$FFE00000	; X pos, Y pos
		dc.l	$00000000,$00440000	; X dist, Y dist
		dc.l	$FFFC0000,$00000000	; X speed, Y speed
		dc.l	$00000000,$0000003F	; X random mask, Y random mask

		; E0 left/up
		dc.l	$00800000,$01700000	; X pos, Y pos
		dc.l	$00440000,$FFBC0000	; X dist, Y dist
		dc.l	$FFFC0000,$FFFC0000	; X speed, Y speed
		dc.l	$0000003F,$0000003F	; X random mask, Y random mask

	; --- Waiting for sprites to return that they've finished ---

DEE_SlashMarkers:
		tst.b	(RDE_DoneSlash).l				; has the slash been finished yet?
		bmi.s	.Cont						; if not, wait
		tst.b	(RDE_DoneSlash).l				; was Sonic hurt during the slash?
		bgt.s	.NoCount					; if so, skip
		subq.b	#$01,(RDE_SlashCount).l				; decrease slash count
		beq.s	.NoCount					; if finished, branch
		move.l	#DEE_SlashStart,(a4)				; do another slash
		st.b	(RDE_DoneSlash).l				; reset slash flag

	.Cont:
		rts							; return

	.NoCount:
		move.w	#$0008,(RDE_VortexAccel).l			; set vortex acceleration
		move.w	#$0080,d0					; set vortex speed
		move.w	d0,(RDE_VortexDest).l				; ''
		move.w	d0,(RDE_VortexSpeed).l				; '' force speed to be moving at destination already
		move.l	#DEE_SlashFadeIn,(a4)				; continue
		sf.b	(RDE_LoadSlashArt).l				; set devil art to continue transfering

DEE_SlashFadeIn:
		addq.w	#$04,(RDE_SlashFade).l				; increase fading
		cmpi.w	#$0100,(RDE_SlashFade).l			; have we reached maximum brightness?
		blt.s	.Cont						; if not, wait
		move.w	#$0100,(RDE_SlashFade).l			; force to maximum brightness

		tst.b	(RDE_DoneSlash).l				; was Sonic hurt during the slash?
		bgt.s	.Hurt						; if so, skip
		sf.b	(RDE_WasHit).l					; clear the hit flag
		move.l	#DEE_BossHit,(a4)				; move to boss hit routine
		clr.w	(RDE_DestTimer).l				; reset destination timer
		move.w	#60*10,(RDE_FollowTimer).l			; 10 seconds to hit the "hit it" sign
		lea	(RDE_Devil).l,a0				; load dummy RAM
		jmp	DE_DeleteObject					; clear object slot

	.Hurt:
		move.l	#DEE_Idle,(a4)					; go back to idle routine
		move.w	#60*2,$08(a4)					; set delay time

	.Cont:
		rts							; return

	; --- Trying to hit the boss while he floats around ---

DEE_BossHit:
		subq.w	#$01,(RDE_FollowTimer).l			; decrease follow timer
		bcc.w	.NoFinish					; if not finished, continue flying around

	; --- Finish ---
	; Moving back to centre
	; --------------

		clr.w	(RDE_FollowTimer).l				; keep timer at 0 from now on
		sf.b	(RDE_HitSign).l					; disable hit sign

		tst.b	(RDE_WasHit).l					; was the boss hit in the end?
		beq.s	.NoCheckLast					; if not, don't bother checking for the end
		move.l	(RDE_AttackOrder).l,a0				; load attack list address
		tst.l	(a0)						; is this the end of the list?
		bpl.s	.NoCheckLast					; if not, continue moving boss to centre like normal
		move.l	#DEE_EndBoss,(a4)				; go back to idle routine
		clr.w	$08(a4)						; set delay time to something quick
		rts							; return

	.NoCheckLast:
		moveq	#$02,d4						; reset finish check flag
		subi.w	#$0100,(RDE_ScaleX+2).l				; reduce X scale
		bpl.s	.SX_Okay					; if still running, branch
		clr.w	(RDE_ScaleX+2).l				; force to 0
		subq.b	#$01,d4						; mark one scale axis as done

	.SX_Okay:
		subi.w	#$0100,(RDE_ScaleY+2).l				; reduce Y scale
		bpl.s	.SY_Okay					; if still running, branch
		clr.w	(RDE_ScaleY+2).l				; force to 0
		subq.b	#$01,d4						; mark the other scale axis as done too

	.SY_Okay:
		cmpi.w	#320/2,(RDE_PosX).l				; has the boss gone back to the centre?
		beq.s	.PX_Okay					; if so, done X
		spl.b	d0						; convert direction to -1 / +1
		ext.w	d0						; ''
		add.w	d0,d0						; ''
		addq.w	#$01,d0						; ''
		add.w	d0,(RDE_PosX).l					; move towards centre
		st.b	d4						; mark as NOT finished yet (waiting for X)

	.PX_Okay:
		cmpi.w	#224/2,(RDE_PosY).l				; has the boss gone back to the centre?
		beq.s	.PY_Okay					; if so, done Y
		spl.b	d0						; convert direction to -1 / +1
		ext.w	d0						; ''
		add.w	d0,d0						; ''
		addq.w	#$01,d0						; ''
		add.w	d0,(RDE_PosY).l					; move towards centre
		st.b	d4						; mark as NOT finished yet (waiting for Y)

	.PY_Okay:
		tst.b	d4						; has the boss returned to centre at full scale?
		bne.s	.WaitReturn					; if not, wait until it has...

		tst.b	(RDE_WasHit).l					; was the boss hit in the end?
		bne.s	.WasHit						; if so, continue
		move.b	#$7F,(RDE_DoneSlash).l				; set slash as done, but boss wasn't his (or Sonic was)

	.WasHit:
		move.l	#DEE_Idle,(a4)					; go back to idle routine
		move.w	#60*1,$08(a4)					; set delay time

	.WaitReturn:
		rts							; return

	; --- Not Finished yet ---
	; The boss is floating around still
	; ------------------------

	.NoFinish:
		bsr.w	.DoPosition					; move the boss around first
		lea	(RDE_Devil).l,a0				; load dummy RAM
		cmpi.w	#60*(10-1),(RDE_FollowTimer).l			; has the devil moved around a little bit yet?
		bhs.s	.NoTouch					; if not, ignore touching
		tst.b	(RDE_HitCount).l				; is this the first hit?
		bne.s	.NoFirst					; if not, let the timer count down
		move.w	#$60*1,(RDE_FollowTimer).l			; keep timer running forever

	.NoFirst:
		st.b	(RDE_HitSign).l					; enable hit sign
		tst.b	SO_Touch(a0)					; was the devil hit?
		beq.s	.NoHit						; if not, continue
		clr.w	(RDE_FollowTimer).l				; clear follow timer
		move.b	#60*2,(RDE_Damage).l				; set damage flash timer
		move.b	#$20,(ScreenWobble).w				; set screen to shake
		addq.b	#$01,(RDE_HitCount).l				; increase hit count
		st.b	(RDE_WasHit).l					; set the hit flag
		sfx	SDE_HitBoss					; play the boss hit flag
		move.w	(RDE_PosX).l,d0					; load X and Y position for explosion
		move.w	(RDE_PosY).l,d1					; ''
		st.b	d2						; play explosion sfx
		jsr	DE_AddExplosion					; load explosion

	.NoTouch:
		rts							; return

	.NoHit:
		move.w	(RDE_PosX).l,SO_PosX(a0)			; set positions
		move.w	(RDE_PosY).l,SO_PosY(a0)			; set positions
		moveq	#$10,d0						; set width
		moveq	#$10,d1						; set height
		moveq	#DEC_ROLL|DEC_EXPLODE,d2			; collision type
		jmp	DE_AddCollision					; add object to collision
		

	.DoPosition:
		subq.w	#$01,(RDE_DestTimer).l				; decrease destination timer
		bcc.s	.Continue					; if still counting, branch
		move.w	#60*2,(RDE_DestTimer).l				; reset timer
		jsr	RandomNumber					; get a random number
		andi.w	#$00FF,d0					; keep in range
		subi.w	#($100-320)/2,d0				; keep fairly in screen around left/right side
		move.w	d0,(RDE_DestX).l				; set destination X position
		jsr	RandomNumber					; get a random number
		andi.w	#$007F,d0					; keep in range
		subi.w	#($80-224)/2,d0					; keep fairly in screen around top/bottom side
		move.w	d0,(RDE_DestY).l				; set destination Y position
		jsr	RandomNumber					; get a random number
		andi.w	#$7F00,d0					; keep in range
		subi.w	#$2000,d0					; get between 5F00 and 0000
		bcc.s	.NoLargest					; ''
		moveq	#$00,d0						; '' (this should encourage 0000 to occur a bit more often)

	.NoLargest:
		move.w	d0,(RDE_DestZ).l				; set as scale destination

	.Continue:

		move.l	#$00000C00,d2					; acceleration
		move.l	#$00000400,d3					; counter deceleration
		move.l	#$00040000,d4					; maximum speed
		moveq	#$00,d5						; get maximum speed in reverse
		sub.l	d4,d5						; ''

		; X pos

		move.l	(RDE_SpeedX).l,d1				; load current speed
		move.w	(RDE_DestX).l,d0				; get direction
		sub.w	(RDE_PosX).l,d0					; ''
		bsr.s	.SetSpeed					; calculate the speed
		move.l	d1,(RDE_SpeedX).l				; save new speed
		add.l	d1,(RDE_PosX).l					; advance position

		; Y pos

		move.l	(RDE_SpeedY).l,d1				; load current speed
		move.w	(RDE_DestY).l,d0				; get direction
		sub.w	(RDE_PosY).l,d0					; ''
		bsr.s	.SetSpeed					; calculate the speed
		move.l	d1,(RDE_SpeedY).l				; save new speed
		add.l	d1,(RDE_PosY).l					; advance position

		; Z pos (scale X and Y)

		move.w	(RDE_DestZ).l,d0				; get direction to move scale/Z
		sub.w	(RDE_ScaleX+2).l,d0				; ''
		beq.s	.Done						; if we've reached the desired Z scale, branch
		bpl.s	.Out						; if we're scaling out, branch
		subi.w	#$0100,(RDE_ScaleX+2).l				; scale in
		subi.w	#$0100,(RDE_ScaleY+2).l				; ''
		rts							; return

	.Out:
		addi.w	#$0100,(RDE_ScaleX+2).l				; scale out
		addi.w	#$0100,(RDE_ScaleY+2).l				; ''
		rts							; return

	; --- Speed setting ---
	; Generic for X, and Y
	; ---------------------

	.SetSpeed:
		bpl.s	.Right						; if moving right/down, branch
		sub.l	d2,d1						; move speed up/left
		bmi.s	.NoSlowL					; if we're heading that way, branch
		sub.l	d3,d1						; if not, move that direction quicker

	.NoSlowL:
		cmp.l	d5,d1						; is the boss moving at maximum speed?
		bge.s	.Done						; if not, continue
		move.l	d5,d1						; force to maximum speed

	.Done:
		rts							; return (done, d1 = speed)

	.Right:
		add.l	d2,d1						; move speed right/down
		bpl.s	.NoSlowR					; if we're heading that way, branch
		add.l	d3,d1						; if not, move that direction quicker

	.NoSlowR:
		cmp.l	d4,d1						; is the boss moving at maximum speed?
		ble.s	.Done						; if not, continue
		move.l	d4,d1						; force to maximum speed
		rts							; return (done, d1 = speed)

; ===========================================================================
; ---------------------------------------------------------------------------
; Missile attack
; ---------------------------------------------------------------------------

	; --- Prepare missiles ---

DEE_MissileAttack:
	st.b	(RDE_ShowMissiles).l				; allow missile sprites to show
		move.l	(RDE_ScaleX_CAP).l,d0				; load scale size
		lsr.l	#$08,d0						; align quotient
		move.w	d0,(RDE_Missile_ScaleCur).l			; set scale of missiles to match

		lea	(RDE_Missiles).l,a0				; load missiles object list
		moveq	#3-1,d7						; number of missiles
		moveq	#$01,d0						; delay timer start

	.NextMissile:
		jsr	DE_DeleteObject					; clear object slot
		move.w	(RDE_DispX).l,SO_PosX(a0)			; move missiles to centre of boss
		move.w	(RDE_DispY).l,SO_PosY(a0)			; ''
		st.b	SO_Frame(a0)					; set to use scale art
		move.w	d0,SO_Timer(a0)					; set delay timer
		addi.w	#30,d0						; increase delay time for next missile
		lea	SO_Size(a0),a0					; advance to next object
		dbf	d7,.NextMissile					; repeat for all missiles
		move.l	#DEE_MissileLaunch,(a4)				; advance to next routine
		rts							; return

	; --- Launching the missiles ---

DEE_MissileLaunch:
		lea	(RDE_Missiles).l,a0				; load missiles object list
		moveq	#3-1,d7						; number of missiles
		st.b	d6						; missile finish flag

	.NextMissile:
		subq.w	#$01,SO_Timer(a0)				; decrease launch timer
		bcc.s	.NoShoot					; if not ready to launch, skip
		clr.w	SO_Timer(a0)					; keep at 0
		move.l	SO_SpeedY(a0),d0				; ''
		add.l	SO_PosY(a0),d0					; ''
		cmpi.l	#-$200000,d0					; has the missile moved above the screen?
		bmi.s	.Finish						; if it's above the screen too high, stop moving...
		move.l	d0,SO_PosY(a0)					; move missile
		subi.l	#$00001000,SO_SpeedY(a0)			; increase speed upwards

		move.w	(RDE_PosY).l,d1					; load Y position
		sub.w	(RDE_ScaleH).l,d1				; move to top of boss's head
		move.w	SO_PosY(a0),d0					; load missile Y position
		addq.w	#$08,d0						; has the missile reached the top of the boss?
		sub.w	d1,d0						; ''
		cmpi.w	#$08,d0						; ''
		bhs.s	.NoShoot					; if not, skip
		move.w	(RDE_PosX).l,d0					; load X position for explosion
		sf.b	d2						; don't play explosion sfx
		jsr	DE_AddExplosion					; load explosion
		sfx	SDE_LaunchRock					; play rocket launching SFX

	.NoShoot:
		moveq	#$00,d6						; set missiles as not finished yet

	.Finish:
		lea	SO_Size(a0),a0					; advance to next object
		dbf	d7,.NextMissile					; repeat for all missiles
		tst.b	d6						; have all 3 missiles finished?
		beq.s	.NoFinish					; if not, don't advance

		; Setting missile rotation positions

		jsr	Random_Number					; get random number
		lea	(RDE_Missiles).l,a0				; reload missiles object list
		moveq	#3-1,d7						; number of missiles
		lea	(SineTable+1).w,a1				; load sinewave table

	.RotateMissile:
		moveq	#$00,d1						; get angle
		move.b	d0,d1						; ''
		add.w	d1,d1						; '' word size
		move.w	+$7F(a1,d1.w),d2				; load Y
		move.w	-$01(a1,d1.w),d1				; load X
		muls.w	#(320/2)+$20,d1					; move missile off-screen
		muls.w	#(320/2)+$20,d2					; ''
		asr.l	#$08,d1						; align quotient only
		asr.l	#$08,d2						; ''
		addi.w	#320/2,d1					; sine from centre
		addi.w	#224/2,d2					; ''
		move.w	d2,SO_PosY(a0)					; set missile's position
		move.w	d1,SO_PosX(a0)					; ''
		move.w	#60,SO_Timer(a0)				; make missile float around for 1 second before closing in on Sonic
		move.b	d0,d1						; take angle from camera and rotate it back a little
		subi.b	#$28,d1						; ''
		move.b	d1,SO_Angle(a0)					; set angle of missile
		move.b	#$01,SO_Frame(a0)				; set to use rotation frame
		move.w	#$0040,SO_AngSpeed(a0)				; reset starting angle speed
		sf.b	SO_Counter(a0)					; reset direction flag

		addi.w	#$100/3,d0					; rotate
		lea	SO_Size(a0),a0					; advance to next object
		dbf	d7,.RotateMissile				; repeat until all missiles are setup for rotation
		move.l	#DEE_MissileFollow,(a4)				; next routine

	.NoFinish:
		rts							; return

	; --- Making missiles follow Sonic ---

DEE_MissileFollow:
		lea	(RDE_Missiles).l,a0				; reload missiles object list
		moveq	#3-1,d7						; number of missiles
		moveq	#3-1,d6						; missile off-screen counter
		lea	(SineTable+1).w,a1				; load sinewave table

	.Next:
		tst.b	SO_Touch(a0)					; has the missile been touched?
		bne.s	.Out						; if so, branch to move missile out

		moveq	#$08,d0						; set width
		moveq	#$0C,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_EXPLODE|DEC_HURT,d2	; collision type
		jsr	DE_AddCollision					; add object to collision

		subq.w	#$01,SO_Timer(a0)				; decrease hold timer
		bcc.s	.NoRotate					; if still holding, don't change speed
		clr.w	SO_Timer(a0)					; keep timer at 0

		move.w	SO_AngSpeed(a0),d1				; load angle speed
		tst.b	SO_Counter(a0)					; are the rockets going out?
		beq.s	.RotateIn					; if not, rotate them in more
		subq.w	#$04,d1						; reduce rotation speed
		bcc.s	.RotateOut					; if we haven't reached 0 yet, continue
		moveq	#$00,d1						; keep angle at 0

		moveq	#$10,d0						; get missile distance on-screen
		add.w	SO_PosX(a0),d0					; ''
		cmpi.w	#320+$10,d0					; is it still on-screen?
		bhs.s	.Out						; if not, branch to mark it off
		moveq	#$10,d0						; get distance on Y as well
		add.w	SO_PosY(a0),d0					; ''
		cmpi.w	#224+$10,d0					; is it on-screen on Y?
		blo.s	.NoOut						; if not, don't count it off yet...

	.Out:
		moveq	#-$80,d0					; force the missile off-screen
		move.w	d0,SO_PosX(a0)					; ''
		move.w	d0,SO_PosY(a0)					; ''
		dbf	d6,.FinishMissile				; decrease off-screen coutner
		move.l	#DEE_Idle,(a4)					; next routine if all missiles are off-screen
		move.w	#60*2,$08(a4)					; set delay time
	sf.b	(RDE_ShowMissiles).l				; dis-allow missile sprites to show
		rts							; return

	.NoOut:
		bra.s	.RotateOut					; ''

	.RotateIn:
		addq.w	#$04,d1						; increase rotation speed
		cmpi.w	#$0200,d1					; check maximum speed
		blo.s	.RotateOut					; if maximum is not reached, keep going
		st.b	SO_Counter(a0)					; set to rotate out now
		move.w	#60*3,SO_Timer(a0)				; keep following Sonic at fastest speed for a second before rotating out

	.RotateOut:
		move.w	d1,SO_AngSpeed(a0)				; update angle

	.NoRotate:
		move.w	(RDE_Sonic+SO_PosX).l,d1			; X distance from Sonic
		sub.w	SO_PosX(a0),d1					; ''
		move.w	(RDE_Sonic+SO_PosY).l,d2			; Y distance from Sonic
		sub.w	SO_PosY(a0),d2					; ''
		jsr	CalcAngle					; get angle towards Sonic
		neg.b	d0						; correct it...
		subi.b	#$40,d0						; ''

		move.w	SO_AngSpeed(a0),d1				; load angle speed
		sub.b	SO_Angle(a0),d0					; get how far away the angle is
		bpl.s	.MoveRight					; if we need to rotate clockwise, branch
		neg.w	d1						; anti-clockwise

	.MoveRight:
		add.w	d1,SO_Angle(a0)					; rotate missile

		moveq	#$00,d0						; load angle
		move.b	SO_Angle(a0),d0					; ''
		addi.b	#$80,d0
		add.w	d0,d0						; '' word size
		move.w	+$7F(a1,d0.w),d1				; load Y
		move.w	-$01(a1,d0.w),d0				; load X
		swap	d1						; shift Y left by 9
		clr.w	d1						; ''
		asr.l	#$07,d1						; ''
		swap	d0						; shift X left by 9
		clr.w	d0						; ''
		asr.l	#$07,d0						; ''
		add.l	d1,SO_PosY(a0)					; move missile....
		add.l	d0,SO_PosX(a0)					; ''

	.FinishMissile:
		lea	SO_Size(a0),a0					; advance to next object
		dbf	d7,.Next					; repeat for all missiles
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Ball attack mode
; ---------------------------------------------------------------------------

	; --- Prepare energy balls ---

DEE_BallAttack:
	st.b	(RDE_ShowEnergy).l				; allow energy sprites to show
		move.l	(RDE_ScaleX_Cap).l,d6				; use the boss's scale as the ball's Z position
		lsl.l	#$08,d6						; ''

		lea	(RDE_Energy).l,a0				; load energy ball object list
		moveq	#5-1,d7						; number of energy balls
		moveq	#$00,d0						; clear d0
		lea	.Setup(pc),a2					; load setup positions

	.NextBall:
		jsr	DE_DeleteObject					; clear object slot
		move.l	#Map_EnergyDE,SO_Mappings(a0)			; set ball's mappings list
		st.b	SO_Frame(a0)					; enable ball's display

	move.w	(a2)+,SO_PointX(a0)
	move.w	(a2)+,SO_PointY(a0)
	move.w	(a2)+,SO_DestY(a0)
	move.w	(a2)+,SO_Timer(a0)
	move.w	(a2)+,SO_Angle(a0)

	;	move.w	#-$100,SO_PointY(a0)				; set ball above the screen
	;	move.w	#320/2,SO_PointX(a0)				; set ball's X position
		move.l	d6,SO_PointZ(a0)				; set ball's Z position

		lea	SO_Size(a0),a0					; advance to next energy ball
		dbf	d7,.NextBall					; repeat for every ball
		move.l	#DEE_BallDrop,(a4)				; set next routine
		rts							; return

		;	X pos,        Y pos, Y dest, Timer

	.Setup:	dc.w	(320/2)-$060, $FF00, (224/2)-$58,  $0000+1, $0000
		dc.w	(320/2)-$030, $FEC0, (224/2)-$70,  $0008+1, $F000
		dc.w	(320/2)-$000, $FE80, (224/2)-$80,  $0010+1, $E000
		dc.w	(320/2)+$030, $FEC0, (224/2)-$70,  $0018+1, $D000
		dc.w	(320/2)+$060, $FF00, (224/2)-$58,  $0020+1, $C000

	; --- Dropping balls from the air ---

DEE_BallDrop:
		lea	(RDE_Energy).l,a0				; load energy ball object list
		moveq	#5-1,d7						; number of energy balls
		moveq	#5-1,d1

	.NextBall:
		subq.w	#$01,SO_Timer(a0)				; decrease delay timer
		bne.s	.NoPrep						; if it's not reached exactly 0, skip
		move.w	#$0180,SO_AngSpeed(a0)				; start rotating the ball
		move.w	#$0008,SO_AngDistY(a0)				; set Y rotation distance
		move.w	#$0004,SO_AngDistX(a0)				; set X rotation distance
		sfx	SDE_BallDrop					; play ball drop SFX

	.NoPrep:
		bcc.s	.NoMove						; if not ready to drop, branch
		clr.w	SO_Timer(a0)					; keep at 0
		move.l	SO_DestY(a0),d0					; move to destination smoothly
		clr.w	d0						; ''
		sub.l	SO_PointY(a0),d0				; ''
		asr.l	#$04,d0						; 1/4 the distance at a time
		add.l	d0,SO_PointY(a0)				; ''
		andi.l	#$FFFFF800,d0					; have the balls more or less reached destination?
		bne.s	.NoMove						; if not, branch
		dbf	d1,.NoMove					; count down balls reaching destination
		lea	(RDE_Energy).l,a0				; load energy ball object list
		moveq	#5-1,d7						; number of energy balls
		moveq	#$01,d1						; timer before shooting

	.Setup:
		move.w	d1,SO_Timer(a0)					; setup timer
		addi.w	#$0030,d1					; increase timer for next ball
		lea	SO_Size(a0),a0					; advance to next energy ball
		dbf	d7,.Setup					; repeat until they're all setup
		move.l	#DEE_ShootBalls,(a4)				; set next routine
		rts							; return

	.NoMove:
		lea	SO_Size(a0),a0					; advance to next energy ball
		dbf	d7,.NextBall					; repeat for all 5 balls
		rts							; return

	; --- Shooting the balls at Sonic ---

DE_BALLSPEED	= $10

DEE_ShootBalls:
		lea	(RDE_Energy).l,a0				; load energy ball object list
		moveq	#5-1,d7						; number of energy balls
		moveq	#5-1,d6						; energy ball finish counter

	.NextBall:
		subq.w	#$01,SO_Timer(a0)				; decrease launch timer
		bne.s	.NoShoot					; if we haven't reached 0 (shooting), continue counting
		sfx	SDE_BallShoot					; play ball shoot SFX
		move.w	#-DE_BALLSPEED,SO_SpeedZ(a0)			; set speed of ball towards screen

		move.w	SO_PointZ(a0),d0				; get number of steps to move before reaching Sonic
		ext.l	d0						; ''
		divs.w	#DE_BALLSPEED,d0				; ''

		tst.w	d0
		bne.s	.Non0
		moveq	#$01,d0

	.Non0:

		move.W	(RDE_Sonic+SO_PosX).l,d1			; get distance on X
		sub.W	SO_PointX(a0),d1				; ''
		ext.l	d1						; divide by number of steps
		asl.l	#$08,d1						; ''
		divs.w	d0,d1						; ''
		ext.l	d1						; set as speed
		asl.l	#$08,d1						; ''
		move.l	d1,SO_SpeedX(a0)				; ''

		move.W	(RDE_Sonic+SO_PosY).l,d1			; get distance on Y
		sub.W	SO_PointY(a0),d1				; ''
		ext.l	d1						; divide by number of steps
		asl.l	#$08,d1						; ''
		divs.w	d0,d1						; ''
		ext.l	d1						; set as speed
		asl.l	#$08,d1						; ''
		move.l	d1,SO_SpeedY(a0)				; ''

		bra.s	.NoStopTimer					; continue

	.NoShoot:
		bcc.s	.NoStopTimer					; if not finished, branch
		clr.w	SO_Timer(a0)					; keep timer at 0

		tst.w	SO_AngDistX(a0)					; reduce X radius to 0
		beq.s	.NoStopX					; ''
		subi.l	#$00004000,SO_AngDistX(a0)			; ''

	.NoStopX:
		tst.w	SO_AngDistY(a0)					; reduce Y radius to 0
		beq.s	.NoStopY					; ''
		subi.l	#$00004000,SO_AngDistY(a0)			; ''

	.NoStopY:
		tst.l	SO_PointZ(a0)					; has the ball passed the screen?
		bgt.s	.NoStopTimer					; if not, continue
		moveq	#$00,d0						; stop the ball from moving on X or Y
		move.l	d0,SO_SpeedX(a0)				; ''
		move.l	d0,SO_SpeedY(a0)				; ''

		tst.w	SO_Frame(a0)					; is the ball finished/hidden?
		beq.s	.CountRunning					; if so, skip collision
		moveq	#$10,d0						; set width
		moveq	#$10,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_HURT,d2			; collision type
		jsr	DE_AddCollision					; add object to collision

		tst.w	SO_Counter(a0)					; has the counter started already?
		bne.s	.CountRunning					; if so, continue
		addq.w	#$04-1,SO_Counter(a0)				; start on the first explosion frame already (steps of 4 (a fraction of 2 bits))

	.CountRunning:
		addq.w	#$01,SO_Counter(a0)				; increase ball explosion frame (fraction advance)
		cmpi.w	#$03*4,SO_Counter(a0)				; has it finished exploding?
		blo.s	.NoStopTimer					; if not, branch
		move.w	#$03*4,SO_Counter(a0)				; force counter to stay at last frame
		clr.w	SO_Frame(a0)					; hide the ball
		dbf	d6,.NoStopTimer					; count number of orbs finished
		move.l	#DEE_Idle,(a4)					; set to go to main idle routine
		move.w	#60*2,$08(a4)					; set delay time
	sf.b	(RDE_ShowEnergy).l				; dis-allow energy sprites to show
		rts							; return

	.NoStopTimer:
		lea	SO_Size(a0),a0					; advance to next energy ball
		dbf	d7,.NextBall					; repeat for all balls
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Arm attack mode
; ---------------------------------------------------------------------------

	; --- Preparing small arm sprites ---

DEE_ArmAttack:
	st.b	(RDE_ShowArms).l				; allow arm sprites to show
		bset.b	#$00,(RDE_AniArms).l				; remove the arms

		move.l	#DEE_AA_Fly,(a4)				; set routine to run

		lea	(RDE_LeftArm).l,a0				; load left arm object
		jsr	DE_DeleteObject					; clear object slot
		move.l	#$00008000,SO_SpeedX(a0)
		move.l	#$00006000,SO_SpeedY(a0)
		moveq	#$05,d2						; frame ID to use
		bsr.s	.MakeArm					; make the arm
		lea	(RDE_RightArm).l,a0				; load right arm object
		jsr	DE_DeleteObject					; clear object slot
		move.l	#$FFFFC000,SO_SpeedX(a0)
		move.l	#$00006000,SO_SpeedY(a0)
		neg.w	d1						; reverse distance of elbow for right side
		subq.w	#$02,d2						; next frame ID to use

	.MakeArm:
		move.w	d2,SO_Frame(a0)					; save frame
		move.w	(RDE_DispX).l,SO_PosX(a0)			; save X position for arm
		move.w	(RDE_DispY).l,SO_PosY(a0)			; save Y position for arm
		move.w	#$A000|(VDE_ArmsSmall/$20),SO_Pattern(a0)	; set pattern index address
		move.l	#($FF<<$18)|Map_ArmsSmlDE,SO_Mappings(a0)	; set mappings address
		move.l	(RDE_ScaleX_CAP).l,d0				; load scale size
		lsr.l	#$08,d0						; align quotient
		move.w	d0,(RDE_ArmSml_ScaleCur).l			; set scale of arms to match
		sfx	SDE_ArmLaunch					; play arm launch SFX
		rts							; return

	; --- Flying small arm sprites off-screen ---

DEE_AA_Fly:
		lea	(RDE_LeftArm).l,a0				; load left arm object
		bsr.s	.MoveArm					; move the arm correctly
		move.w	SO_Frame(a0),d2					; load its frame (if 0, it's gone off-screen)
		lea	(RDE_RightArm).l,a0				; load right arm object
		bsr.s	.MoveArm					; move the arm correctly
		or.w	SO_Frame(a0),d2					; fuse it's frame with the left arm
		bne.s	.NoFinish					; if one or the other is not 0, then both arms are not off-screen yet, so branch and continue
		move.w	#3,$0A(a4)					; set to do the slamming 3 times

	.RedoSlam:
		move.l	#DEE_Delay,(a4)					; set delay routine to run
		move.w	#60*1,$08(a4)					; set delay time
		move.l	#DEE_AA_PrepLarge,$04(a4)			; set next routine to run after delay

	.NoFinish:
		rts							; return

	.MoveArm:
		move.l	SO_SpeedX(a0),d0				; load X speed
		move.l	d0,d1						; get fraction of speed
		asr.l	#$04,d1						; ''
		add.l	d0,d1						; increase the speed by the fraction
		move.l	d1,SO_SpeedX(a0)				; ''
		add.l	d0,SO_PosX(a0)					; move the arm on X
		moveq	#$20,d0						; reload X
		add.w	SO_PosX(a0),d0					; ''
		cmpi.w	#320+($20*2),d0					; has it gone off-screen completely?
		blo.s	.NoStop						; if not, continue
		clr.w	SO_Frame(a0)					; set no frame (invisible)
		rts							; return (finish, no point doing Y)

	.NoStop:
		move.l	SO_SpeedY(a0),d0				; load Y speed
		subi.l	#$00000800,d0					; counter drop (make it curve back upwards)
		move.l	d0,d1						; get fraction of speed
		asr.l	#$04,d1						; ''
		add.l	d0,d1						; increase speed by fraction
		move.l	d1,SO_SpeedY(a0)				; ''
		add.l	d0,SO_PosY(a0)					; move the arm on Y
		rts							; return

	; --- Preparing large arm sprites ---

DEE_AA_PrepLarge:
		moveq	#$00,d2						; clear d2 for Y speed setting

		lea	(RDE_LeftArm).l,a0				; load left arm object

		move.l	d2,SO_SpeedY(a0)				; clear Y speed
		move.w	#0+$1C,SO_SpeedX(a0)				; using speed for destination temporarily
		move.w	#0-$20,SO_PosX(a0)				; set arm off-screen
		jsr	(RandomNumber).w				; randomise the Y position a little
		andi.w	#$001F,d0					; ''
		addi.w	#(224/2)-$10,d0					; put somewhere slightly random at middle of screen
		move.w	d0,SO_PosY(a0)					; ''
		move.w	#8,SO_Frame(a0)					; set frame
		move.l	#Map_ArmsBigDE,SO_Mappings(a0)			; use big arm mappings
		move.w	#$A000|(VDE_ArmsBig/$20),SO_Pattern(a0)		; use big arm pattens

		lea	(RDE_RightArm).l,a0				; load left arm object

		move.l	d2,SO_SpeedY(a0)				; clear Y speed
		move.w	#320-$1C,SO_SpeedX(a0)				; using speed for destination temporarily
		move.w	#320+$20,SO_PosX(a0)				; set arm off-screen
		jsr	(RandomNumber).w				; randomise the Y position a little
		andi.w	#$001F,d0					; ''
		addi.w	#(224/2)-$10,d0					; put somewhere slightly random at middle of screen
		move.w	d0,SO_PosY(a0)					; ''
		move.w	#6,SO_Frame(a0)					; set frame
		move.l	#Map_ArmsBigDE,SO_Mappings(a0)			; use big arm mappings
		move.w	#$A000|(VDE_ArmsBig/$20),SO_Pattern(a0)		; use big arm pattens

	jsr	RandomNumber					; randomise the slamming timer
	moveq	#$00,d1						; upper word clear for divu
	move.w	d0,d1						; ''
	divu.w	#60*2,d1					; ''
	swap	d1						; ''
	addi.w	#60,d1						; get time between 1 and 3 seconds
	move.w	d1,$08(a4)					; '' delay time before slamming
	;	move.w	#60*2,$08(a4)					; delay time before slamming
		move.l	#DEE_AA_LargeCharge,(a4)			; set delay routine to run
		rts							; return

	; --- Charging the arms (following Sonic) ---

DEE_AA_LargeCharge:
		bne.s	.NoSlam						; if not finished delaying, branch
		move.l	#DEE_AA_LargeSlam,(a4)				; set routine to run

		move.l	(RDE_Sonic+SO_PosX).l,d0			; load Sonic's current X position as destination for arms to slam
		move.l	(RDE_LeftArm+SO_PosY).l,d2			; load the middle Y position between the arms so they both close together properly
		move.l	(RDE_RightArm+SO_PosY).l,d1			; ''
		sub.l	d2,d1						; ''
		asr.l	#$01,d1						; '' (halfway)
		add.l	d2,d1						; ''

		lea	(RDE_LeftArm).l,a0				; set left arm object
		bsr.s	.SetArm						; ''
		lea	(RDE_RightArm).l,a0				; set right arm object
		bsr.s	.SetArm						; ''
		move.w	#$10+1,$08(a4)					; delay time before slamming (10 frames)
		rts							; return

	.SetArm:
		move.l	d0,d2						; load position
		sub.l	SO_PosX(a0),d2					; get distance to Sonic
		asr.l	#$04,d2						; divide into 10 steps
		move.l	d2,SO_SpeedX(a0)				; set as speed (10 frames until hit)

		move.l	d1,d2						; load position
		sub.l	SO_PosY(a0),d2					; get distance to Sonic
		asr.l	#$04,d2						; divide into 10 steps
		move.l	d2,SO_SpeedY(a0)				; set as speed (10 frames until hit)

		subq.w	#$04,SO_Frame(a0)				; use full sprite set
		rts							; return

	.NoSlam:
		lea	(RDE_LeftArm).l,a0				; load left arm object
		bsr.s	.MoveArmIn
		lea	(RDE_RightArm).l,a0				; load right arm object

	.MoveArmIn:
		move.l	SO_SpeedX(a0),d0				; load destination X position
		sub.l	SO_PosX(a0),d0					; get distance
		asr.l	#$03,d0						; get fraction
		add.l	d0,SO_PosX(a0)					; move on-screen

		move.l	#$00000800,d2					; acceleration
		move.l	#$00020000,d3					; max speed

		bsr.s	.MoveArmY

		moveq	#$10,d0						; set width
		moveq	#$10,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_HURT,d2			; collision type
		jmp	DE_AddCollision					; add object to collision

	.MoveArmY:
		move.l	SO_SpeedY(a0),d1				; load current Y speed
		move.w	(RDE_Sonic+SO_PosY).l,d0			; load Sonic's Y position
		sub.w	SO_PosY(a0),d0					; get distance/direction arm is from Sonic
		bpl.s	.Down						; if the arm needs to move down, branch
		neg.l	d3						; reverse max speed
		sub.l	d2,d1						; move speed upwards
		bmi.s	.UpOK						; if the arm is moving up already, branch
		sub.l	d2,d1						; move up even faster

	.UpOK:
		cmp.l	d3,d1						; has it reached max speed?
		bgt.s	.OkayU						; if not, continue
		move.l	d3,d1						; force to max speed

	.OkayU:
		move.l	d1,SO_SpeedY(a0)				; set new speed
		add.l	d1,SO_PosY(a0)					; move arm
		rts							; return

	.Down:
		add.l	d2,d1						; move speed downwards
		bpl.s	.DownOK						; if the arm is moving down already, branch
		add.l	d2,d1						; move down even faster

	.DownOK:
		cmp.l	d3,d1						; has it reached max speed?
		blt.s	.OkayD						; if not, continue
		move.l	d3,d1						; force to max speed

	.OkayD:
		move.l	d1,SO_SpeedY(a0)				; set new speed
		add.l	d1,SO_PosY(a0)					; move arm
		rts							; return

	; --- Slamming the arms to where Sonic was ---

DEE_AA_LargeSlam:
		bne.s	.NoStop						; if not finished delaying, branch
		sfx	SDE_ArmSlam					; play slamming SFX
		move.b	#$20,(ScreenWobble).w				; set screen to shake
		move.l	#DEE_AA_LargeHold,(a4)				; set delay routine to run
		move.w	#60*1,$08(a4)					; set delay time for slam/shaking
		move.l	#-$00100000,(RDE_LeftArm+SO_SpeedX).l
		move.l	#$00100000,(RDE_RightArm+SO_SpeedX).l
		rts							; return

	.NoStop:
		lea	(RDE_LeftArm).l,a0				; load left arm object
		bsr.s	.ArmSlam
		lea	(RDE_RightArm).l,a0				; load right arm object

	.ArmSlam:
		move.l	SO_PosX(a0),d0					; load position
		add.l	SO_SpeedX(a0),d0				; add speed to move the arm towards Sonic
		move.l	d0,SO_PosX(a0)					; set arm position

		move.l	SO_PosY(a0),d0					; load position
		add.l	SO_SpeedY(a0),d0				; add speed to move the arm towards Sonic
		move.l	d0,SO_PosY(a0)					; set arm position

		moveq	#$10,d0						; set width
		moveq	#$10,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_HURT,d2			; collision type
		jmp	DE_AddCollision					; add object to collision

	; --- Holding arms in place ---

DEE_AA_LargeHold:
		bne.s	.Wait						; if timer isn't finished, branch
		move.l	#DEE_AA_LargeBack,(a4)				; set delay routine to run

	.Wait:
		lea	(RDE_LeftArm).l,a0				; load left arm object
		bsr.s	.DoCollision					; perform collision for left arm
		lea	(RDE_RightArm).l,a0				; load right arm object
									; perform collision for right arm
	.DoCollision:
		moveq	#$10,d0						; set width
		moveq	#$10,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_HURT,d2			; collision type
		jmp	DE_AddCollision					; add object to collision

	; --- Moving large arms off-screen ---

DEE_AA_LargeBack:
		lea	(RDE_LeftArm).l,a0				; load left arm object
		bsr.s	.MoveArm					; move the arm correctly
		move.w	SO_Frame(a0),d3					; load its frame (if 0, it's gone off-screen)
		lea	(RDE_RightArm).l,a0				; load right arm object
		bsr.s	.MoveArm					; move the arm correctly
		or.w	SO_Frame(a0),d3					; fuse it's frame with the left arm
		bne.s	.NoFinish					; if one or the other is not 0, then both arms are not off-screen yet, so branch and continue

		subq.w	#$01,$0A(a4)					; decrease counter
		bgt.w	DEE_AA_Fly.RedoSlam				; if not finished doing it 3 times, branch to redo...
		move.l	#DEE_AA_RestoreArms,(a4)			; set next routine to run (when finished)

	.NoFinish:
		rts							; return

	.MoveArm:
		move.l	SO_SpeedX(a0),d0				; load X speed
		add.l	d0,SO_PosX(a0)					; move arm off-screen
		move.w	SO_PosX(a0),d0					; load X position
		subi.w	#$1C,d0						; have the arms gone off enough to use shorter art?
		cmpi.w	#320-($1C*2),d0					; ''
		blo.s	.NoShrink					; if not, continue
		cmpi.w	#$06,SO_Frame(a0)				; have the frames already changed to shorter art?
		bhs.s	.DoneShrink					; if so, don't bother again
		addq.w	#$04,SO_Frame(a0)				; use the cut-off shorter arm

	.DoneShrink:
		addi.w	#$1C+$20,d0					; have the arms gone off screen fully?
		cmpi.w	#320+($20*2),d0					; ''
		blo.s	.NoShrink					; if not, branch
		clr.w	SO_Frame(a0)					; set no frame (finish)

	.NoShrink:
		moveq	#$10,d0						; set width
		moveq	#$10,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_HURT,d2			; collision type
		jmp	DE_AddCollision					; add object to collision

	; --- Restoring arms back onto the boss ---

DEE_AA_RestoreArms:
		move.l	#DEE_AA_Attach,(a4)				; set event routine to run next

		move.w	(RDE_DispX).l,d2				; load boss's X position
		move.w	(RDE_DispY).l,d1				; load boss's Y position

		lea	(RDE_LeftArm).l,a0				; load left arm object
		move.w	#$04,SO_Frame(a0)				; set to use normal arm sized frame
		move.w	#70,SO_PosY(a0)					; set starting Y position
		move.w	#320+$40,SO_PosX(a0)				; set starting X position (right of screen)
		move.w	(RDE_DispX).l,d0				; load boss's X position
		move.w	d2,SO_SpeedX(a0)				; set destination X position
		move.w	d1,SO_SpeedY(a0)				; set destination Y position (same for both arms)
		move.w	#$A000|(VDE_ArmsSmall/$20),SO_Pattern(a0)	; set pattern index address
		move.l	#($FF<<$18)|Map_ArmsSmlDE,SO_Mappings(a0)	; set mappings address

		lea	(RDE_RightArm).l,a0				; load right arm object
		move.w	#$02,SO_Frame(a0)				; set to use normal arm sized frame
		move.w	#70,SO_PosY(a0)					; set starting Y position
		move.w	#0-$40,SO_PosX(a0)				; set starting X position (left of screen)
		move.w	d2,SO_SpeedX(a0)				; set destination X position
		move.w	d1,SO_SpeedY(a0)				; set destination Y position (same for both arms)
		move.w	#$A000|(VDE_ArmsSmall/$20),SO_Pattern(a0)	; set pattern index address
		move.l	#($FF<<$18)|Map_ArmsSmlDE,SO_Mappings(a0)	; set mappings address


		move.l	(RDE_ScaleX_CAP).l,d0				; load scale size
		move.l	(RDE_MoveBossSpeed).l,d1			; use speed as a reference for how much bigger to scale the arms...
		lsl.l	#$07,d1						; '' ...because by the time the arms reach the body, the body will have...
		sub.l	d1,d0						; '' ...scaled up a bit.
		bcc.s	.NoMax						; if it's no reached maximum scale, continue
		moveq	#$00,d0						; keep at max scale
	.NoMax:	lsr.l	#$08,d0						; align quotient
		move.w	d0,(RDE_ArmSml_ScaleCur).l			; set sale of arms to match

		rts							; return

	; --- Moving and attaching the arms onto the body ---

DEE_AA_Attach:
		moveq	#$00,d2
		lea	(RDE_LeftArm).l,a0				; run left arm object
		bsr.s	.AttachArm					; ''
		lea	(RDE_RightArm).l,a0				; run right arm object
		bsr.s	.AttachArm					; ''
		bne.s	.NoFinish					; if at least one arm hasn't reached it's destination, skip and keep moving

		btst.b	#$00,(RDE_AniArms).l				; have the arms been enabled on the devil?
		bne.s	.WaitArms					; if not, wait for right frame to attach
		cmpi.w	#$0004,(RDE_AniFrame).l				; have the arms rendered on the devil?
		bne.s	.NoFinish					; if not, branch
		clr.w	(RDE_LeftArm+SO_Frame).l			; hide arm sprites
		clr.w	(RDE_RightArm+SO_Frame).l			; ''
		move.l	#DEE_Idle,(a4)					; set to go to main idle routine
		move.w	#60*2,$08(a4)					; set delay time
	sf.b	(RDE_ShowArms).l				; dis-allow arm sprites to show
		rts							; return

	.WaitArms:
		tst.w	(RDE_AniFrame).l				; have we reached just before frame 1?  (where the arms would match)
		bne.s	.NoFinish					; if not, wait...
		bclr.b	#$00,(RDE_AniArms).l				; enable arms, they will show when frame 1 appears

	.NoFinish:
		rts							; return

	.AttachArm:
		move.l	SO_SpeedX(a0),d0				; move arms towards spot
		sub.l	SO_PosX(a0),d0					; ''
		asr.l	#$03,d0						; ''
		add.l	d0,SO_PosX(a0)					; ''
		move.l	SO_SpeedY(a0),d1				; ''
		sub.l	SO_PosY(a0),d1					; ''
		asr.l	#$03,d1						; ''
		add.l	d1,SO_PosY(a0)					; ''

		addi.l	#$00004000,d0					; encourage FFFF to 0000
		addi.l	#$00004000,d1					; ''
		swap	d0						; get quotient
		swap	d1						; ''
		lsr.w	#$01,d0						; ensure both FFFF and 0000 become 0
		lsr.w	#$01,d1						; ''
		or.w	d0,d2						; set d2 non-zero if the arms have not reached destination
		or.w	d1,d2						; ''
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Setting up devil mappings
; ---------------------------------------------------------------------------

DE_SetupDevilMap:
		pea	(a1)						; store a1
		moveq	#-1,d0						; prepare dbf subtraction
		moveq	#$00,d2						; clear d2
		move.b	(a0)+,d2					; load width
		move.w	d2,d1						; '' (store half pixel size)
		add.w	d1,d1						; '' ('')
		add.w	d1,d1						; '' ('')
		move.w	d1,(RDE_Width).l				; '' ('')
		moveq	#-2,d1						; move left address back to correct start point
		and.w	d2,d1						; ''
		sub.w	d1,d4						; ''
		lsr.b	#$01,d2						; split in half
		move.w	d2,a3						; keep a copy for right side
		addx.w	d0,d2						; minus 1 for dbf (add 1 for odd width)
		move.w	d2,a2						; keep a copy for left side
		add.w	d0,a3						; minus 1 for dbf (WITHOUT odd adding)
		moveq	#$00,d3						; clear d3
		move.b	(a0),d3						; load height
		move.w	d3,d1						; move both addresses up to correct top start point
		add.w	d1,d1						; '' (store half pixel size)
		add.w	d1,d1						; '' ('')
		move.w	d1,(RDE_Height).l				; '' ('')
		lsl.w	#$05,d1						; ''
		moveq	#$00,d6						; '' (copy odd tile to another row)
		move.b	d1,d6						; '' ('')
		add.w	d6,d6						; '' ('')
		add.w	d6,d1						; '' ('')
		sf.b	d1						; '' (clear odd tile)
		sub.w	d1,d4						; ''
		sub.w	d1,d5						; ''
		lsr.b	#$01,d3						; split in half
		addx.w	d0,d3						; minus 1 for dbf (add 1 for odd height)
		swap	d4						; align addresses for VDP port
		swap	d5						; ''
		moveq	#2-1,d6						; set to repeat once for top once for bottom

	.NextHalf:
		move.w	d3,d1						; reload height

	.NextY:
		move.w	a2,d0						; reload width
		move.l	d4,(a6)						; set VDP address
		addi.l	#$01000000,d4					; advance to next row

	.NextXL:
		move.w	(a1)+,d2					; load tile
		beq.s	.BlankL						; if 0, save 0
		add.w	d7,d2						; add pattern index address

	.BlankL:
		move.w	d2,(a5)						; copy tile mappings
		dbf	d0,.NextXL					; repeat until left width is done

		move.l	d5,(a6)						; set VDP address
		addi.l	#$01000000,d5					; advance to next row
		move.w	a3,d0						; reload width

	.NextXR:
		move.w	(a1)+,d2					; load tile
		beq.s	.BlankR						; if 0, save 0
		add.w	d7,d2						; add pattern index address

	.BlankR:
		move.w	d2,(a5)						; copy tile mappings
		dbf	d0,.NextXR					; repeat until right width is done
		dbf	d1,.NextY					; repeat for all heights
		subi.l	#$20000000,d4					; wrap to top of plane
		subi.l	#$20000000,d5					; ''
		moveq	#$01,d0						; remove odd tile count from height
		and.b	(a0),d0						; '' (if applicable)
		sub.w	d0,d3						; ''
		dbf	d6,.NextHalf					; repeat for bottom half
		subq.w	#$01,a0						; restore a0
		move.l	(sp)+,a1					; restore a1
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to run and control Sonic
; ---------------------------------------------------------------------------

DE_SonicControls:
		tst.b	(RDE_FinishBoss).l				; has the boss been defeated?
		bne.s	.NoControl					; if so, no controls allowed
		tst.b	(RDE_ShowSonic).l				; is Sonic allowed to render?
		bne.s	.Control					; if so, continue

	.NoControl:
		rts							; return (no controls over Sonic)

	.Control:
		tst.b	(RDE_SonicDead).l				; is Sonic dead?
		bne.s	.NoControl					; if so, skip
		lea	(RDE_Sonic).l,a0				; load Sonic's RAM space

		move.l	#$00020000,d1					; default movement speed
		moveq	#$00,d2						; make negative version
		sub.l	d1,d2						; ''

		subq.w	#$01,(RDE_RollTimer).l				; decrease boost/roll timer
		bcc.s	.NoReset					; if still running, don't allow boost to be pressed
		clr.w	(RDE_RollTimer).l				; keep timer at 0 (ready for another boost)

	.NoReset:
		moveq	#$70,d3						; load pressed A, B, or C buttons
		and.b	(RDE_PadA_Pressed).l,d3				; ''
		beq.s	.NoBoost					; if no boost buttons were pressed, don't increase speed
		asl.l	#$02,d1						; increase speed
		asl.l	#$02,d2						; ''
		sfx	SDE_BoostSFX					; play boost sfx:
		move.w	#45,(RDE_RollTimer).l				; set to delay boosting again for 0.75 of a second

	.NoBoost:
		moveq	#$0F,d4						; load held D-pad buttons
		and.b	(RDE_PadA_Held).l,d4				; ''
		bne.s	.YesDPad					; if buttons were pressed, perform speed change
		tst.b	d3						; were A, B, or C pressed in the end?
		beq.s	.NoDPad						; if not, skip
		move.b	(RDE_LastDPad).l,d4				; load last direction buttons pressed

	.YesDPad:
		move.b	d4,(RDE_LastDPad).l				; store last D-pad presses for boost buttons
		roxr.b	#$04,d4						; align D-pad buttons to MSB
		bcc.s	.NoRight					; if right wasn't pressed, branch
		cmp.l	SO_SpeedX(a0),d1				; is the speed faster already?
		bmi.s	.NoIncR						; if so, skip
		move.l	d1,SO_SpeedX(a0)				; increase X speed

	.NoIncR:
		tst.b	d4						; check left

	.NoRight:
		bpl.s	.NoLeft						; if left wasn't pressed, branch
		cmp.l	SO_SpeedX(a0),d2				; is the speed faster already?
		bpl.s	.NoLeft						; if so, skip
		move.l	d2,SO_SpeedX(a0)				; increase X speed

	.NoLeft:
		add.b	d4,d4						; get next button
		bpl.s	.NoDown						; if down wasn't pressed, branch
		cmp.l	SO_SpeedY(a0),d1				; is the speed faster already?
		bmi.s	.NoDown						; if so, skip
		move.l	d1,SO_SpeedY(a0)				; increase Y speed

	.NoDown:
		add.b	d4,d4						; get next button
		bpl.s	.NoDPad						; if up wasn't pressed, branch
		cmp.l	SO_SpeedY(a0),d2				; is the speed faster already?
		bpl.s	.NoDPad						; if so, skip
		move.l	d2,SO_SpeedY(a0)				; increase Y speed

	.NoDPad:

	; --- Sonic's speed ---

		move.l	SO_SpeedX(a0),d0				; move Sonic on X at speed
		add.l	d0,SO_PosX(a0)					; ''
		asr.l	#$05,d0						; reduce X speed
		sub.l	d0,SO_SpeedX(a0)				; ''
		move.l	SO_SpeedY(a0),d0				; move Sonic on Y at speed
		add.l	d0,SO_PosY(a0)					; ''
		asr.l	#$05,d0						; reduce Y speed
		sub.l	d0,SO_SpeedY(a0)				; ''

	; --- Sonic's screen boundary ---

		lea	SO_PosX(a0),a1					; use X range
		moveq	#-$18,d1					; set X boundary on edge of screen
		move.w	#320,d2						; screen size on X
		bsr.s	.CheckBoundary					; check if Sonic is in range, if not, force him in
		lea	SO_PosY(a0),a1					; use Y range
		moveq	#-$18,d1					; set Y boundary on edge of screen
		move.w	#224,d2						; screen size on Y

	.CheckBoundary:
		move.w	(a1),d0						; load Sonic's position
		add.w	d1,d0						; account for left/top boundary
		add.w	d1,d2						; is Sonic in range of the screen between the boundaries?
		add.w	d1,d2						; ''
		sub.w	d2,d0						; ''
		blo.s	.InRange					; if so, ignore cap
		bmi.s	.LeftTop					; if Sonic is to the left/top, then cap left/top side
		sub.w	d0,(a1)						; force Sonic to right/bottom boundary
		rts							; return

	.LeftTop:
		neg.w	d1						; force Sonic to left/top boundary
		move.w	d1,(a1)						; ''

	.InRange:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to calculate a few universal stuff (that isn't calculated anywhere else)
; ---------------------------------------------------------------------------

DE_CalcStuff:
		addq.l	#$01,(RDE_VortexTimer).l			; increase vortex cycle timer

	; --- Temp ---

	; When the Z calculations are done properly, the display X/Y
	; will be adjusted...  PROBABLY here, donno yet...

	move.w	(RDE_PosX).l,d0
	move.w	(RDE_PosY).l,d1
	move.w	(RDE_PosZ).l,d2
	beq.s	.NoZ
	nop

	.NoZ:
	move.w	d0,(RDE_DispX).l
	move.w	d1,(RDE_DispY).l

	; --- Scaling ---

		move.l	#$007F0000,d1					; maximum scale amount

		move.l	(RDE_ScaleX).l,d0				; load X scaling
		cmp.l	d1,d0						; is it in range?
		bls.s	.RangeX						; if so, branch
		smi.b	d0						; set to min/max correctly
		swap	d0						; ''
		and.l	d1,d0						; '' (000000 or 7F0000)

	.RangeX:
		move.l	d0,(RDE_ScaleX_CAP).l				; set actual scale position

		move.l	(RDE_ScaleY).l,d0				; load Y scaling
		cmp.l	d1,d0						; is it in range?
		bls.s	.RangeY						; if so, branch
		smi.b	d0						; set to min/max correctly
		swap	d0						; ''
		and.l	d1,d0						; '' (000000 or 7F0000)

	.RangeY:
		move.l	d0,(RDE_ScaleY_CAP).l				; set actual scale position

	; --- The X scale calculation ---
	; The one for Y is done during the Y scaling
	; subroutine for the devil, but there is no
	; X one done there, so it's done here.
	; -------------------------------

		move.l	(RDE_ScaleX_CAP).l,d0				; prepare Y scaling
		addi.l	#$00010000,d0					; convert for division/multiplication 0 = x1, 1 = x2, 2 = x3, etc...
		asr.l	#$08,d0						; align quotient down with fraction in bottom half of word (for mulu and divu)

		; --- Calculating scale X position ---

		move.w	(RDE_PosX).l,d1					; load Y position
		mulu.w	d0,d1						; multiply by scale amount
		asl.l	#$08,d1						; divide by 100 (but in such a way the quotient is in upper word and fraction is in lower word)
		neg.l	d1						; reverse direction (V-scroll is upside down)
		move.l	d1,(RDE_AdjX).l	; (THIS MIGHT NOT BE NEEDED)	; store... 

		; --- Calculating scale width ---

		moveq	#$00,d1						; load height
		move.w	(RDE_Width).l,d1				; ''
		asl.l	#$08,d1						; create fraction space
		divu.w	d0,d1						; divide by scale to get scale height of devil
		move.w	d1,(RDE_ScaleW).l				; store it for later (can be used for collision later maybe...)

	; --- Eye Y position wobble ---

		; Eye Y relative wobble

		cmpi.w	#$0100,(RDE_SlashFade).l			; is the screen fading for flash?
		blt.w	.FrozenFrame					; if so, branch and DON'T update eye wobble position
		move.l	(RDE_ScaleY_CAP).l,d1				; load Y scale
		addi.l	#$00008000,d1					; round up to nearest quotient
		swap	d1						; get only quotient
		move.w	(RDE_AniFrame).l,d0				; load correct wobble
		move.w	.Wob(pc,d0.w),d0				; ''
		asr.w	d1,d0						; reduce wobble amount based on Y scale

		; Eye Y position itself

		moveq	#$00,d3						; load current scale height
		move.w	(RDE_ScaleH).l,d3				; ''
		asr.w	#$01,d3						; divide in half (only half from centre)
		swap	d3						; create fraction space
		move.l	d3,d1						; get an even small fraction
		asr.l	#$05,d1						; ''
		add.l	d1,d3						; apply fraction amount
		add.l	d1,d3						; ''
		add.l	d1,d3						; ''
		swap	d3						; get only quotient again
		sub.w	d0,d3						; account for eye wobble
		move.w	d3,(RDE_EyeY).l					; save as Y position for the eye (for display later)

	.FrozenFrame:

	; --- Direction Sonic is from boss ---

		move.w	(RDE_Sonic+SO_PosX).l,d1			; get X distance
		sub.w	(RDE_DispX).l,d1				; ''
		move.w	(RDE_Sonic+SO_PosY).l,d2			; get Y distance
		sub.w	(RDE_DispY).l,d2				; ''
		add.w	(RDE_EyeY).l,d2					; '' (From EYE not BODY CENTRE)
		jsr	(CalcDist).w					; get distance from eyes
		move.w	d0,(RDE_DistSonic).l				; store distance for later
		jsr	(CalcAngle).w					; get angle from eyes
		move.b	d0,(RDE_AngSonic).l				; store angle for display later
		rts							; return

	.Wob:	dc.w	+0, -1, -2, -2, -1, -1, +0, +0, +1, +1, +2, +1

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform scaling of the arm sprite art
; ---------------------------------------------------------------------------

DE_ScaleArmArt:
		move.w	(RDE_ArmSml_ScaleCur).l,d7			; load current scale amount
		cmpi.w	#$0200,d7					; has it surpassed maximum?
		blo.s	.Valid						; if not, branch
		spl.b	d7						; force to 0 or max based on direction
		ext.w	d7						; ''

	.Valid:
		andi.w	#$01FC,d7					; keep in range
		cmp.w	(RDE_ArmSml_ScalePrev).l,d7			; has the scale changed?
		beq.s	.Same						; if not, ignore scaling
		move.w	d7,(RDE_ArmSml_ScalePrev).l			; update as previous

		moveq	#$00,d0						; load scale as long-word
		move.w	d7,d0						; ''
		moveq	#$00,d1						; no scale adjust
		lsr.w	#$01,d0						; align to size of word per element
		sne.b	d1						; if the scale isn't 0, then add 8 to the mulu amount (to hide the pixel gap between pieces)
		ext.w	d1						; ''
		andi.w	#$FFF8,d1					; ''
		lea	DEDS_DivToMul(pc),a0				; load conversion table
		add.w	(a0,d0.w),d1					; load correct mulu division value
		move.w	d1,(RDE_ArmSml_ScaleMul).l			; save for sprites later

		lea	(RDE_ArmSml_Pack).l,a1				; load art pack address
		lea	(RDE_ArmSml_Unpack).l,a2			; load space where unpacked art is
		lea	(Map_ArmsSmlDE).l,a3				; load mappings so the routine knows which tiles to pack
		adda.w	(a3),a3						; load first frame
		move.w	#$600*2,d6					; prepare size of buffer
		jmp	PreScale					; scale the art in RAM

	.Same:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform scaling of the missile sprite art
; ---------------------------------------------------------------------------

DE_ScaleMissileArt:
		move.w	(RDE_Missile_ScaleCur).l,d7			; load current scale amount
		cmpi.w	#$0200,d7					; has it surpassed maximum?
		blo.s	.Valid						; if not, branch
		spl.b	d7						; force to 0 or max based on direction
		ext.w	d7						; ''

	.Valid:
		andi.w	#$01FC,d7					; keep in range
		cmp.w	(RDE_Missile_ScalePrev).l,d7			; has the scale changed?
		beq.s	.Same						; if not, ignore scaling
		move.w	d7,(RDE_Missile_ScalePrev).l			; update as previous

		lea	(RDE_Missile_Pack).l,a1				; load art pack address
		lea	(RDE_Missile_Unpack).l,a2			; load space where unpacked art is
		lea	Map_MissileDummy(pc),a3				; load mappings so the routine knows which tiles to pack
		move.w	#$300*2,d6					; prepare size of buffer
		jmp	PreScale					; scale the art in RAM

	.Same:
		rts							; return

Map_MissileDummy:
		dc.w	$0000,$0000,$0000,$000F,$0000	; dummy mappings just for the sprite count, the shape, and VRAM address

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render sprites correctly
; ---------------------------------------------------------------------------

DE_RenderSprites:
		lea	(RDE_Sprites).w,a4				; load sprite buffer

		move.w	#$8000|(VDE_HUD/$20),d1				; pattern index of HUD art
		jsr	Render_HUD					; render HUD (using hellfire saga's code)
		bsr.w	DE_HitSign					; render "HIT" sign
		bsr.w	DE_SlashClaws					; render the slash claws (Only the claws, infront of Sonic)
		bsr.w	DE_SpritesSonic					; render Sonic
		bsr.w	DE_SlashMarkers					; render the slash markers (Only the warning markers, behind Sonic)
		bsr.w	DE_Explosions					; render explosions
	bsr.w	DE_EnergyBalls					; render energy balls
		bsr.w	DE_SpritesArms					; render arms
		bsr.w	DE_SpritesMissiles				; render missile sprites
		bsr.w	DE_SpritesEyes					; render eggman's eyes

		move.w	#((RDE_Sprites+($50*8))-5)&$FFFF,d0		; prepare end of table address
		cmpa.w	d0,a4						; have we reached the last sprite?
		bpl.s	.Last						; if so, branch for last link
		clr.w	(a4)+						; hide next sprite
		moveq	#$01,d0						; get link address
		add.w	a4,d0						; ''

	.Last:
		move.w	d0,(Sprite_Link).w				; set link address
		addq.w	#$05,d0						; advance to end of sprite
		sub.w	#(RDE_Sprites&$FFFF),d0				; get number of sprites
		lsr.w	#$01,d0						; reduce for DMA size
		move.w	d0,(Sprite_Size).w				; set size to transfer

		rts							; return

; ---------------------------------------------------------------------------
; Rendering explosions
; ---------------------------------------------------------------------------

DE_Explosions:
		subq.b	#$01,(RDE_ExplodeSFX).l				; decrease explosion sfx timer
		bcc.s	.NoReset					; if still counting, branch
		sf.b	(RDE_ExplodeSFX).l				; reset/allow sfx

	.NoReset:
		lea	(RDE_Explosion).l,a0				; load explosion list
		move.w	(a0)+,d1					; load frame
		beq.s	.Finish						; if finished, branch
		lea	(Map_ExplodeDE).l,a2				; load mappings list
		move.w	#$8000|(VDE_Explode/$20),d2			; pattern index
		moveq	#$01,d3						; load odd/even frame as animation counter
		and.b	(RDE_VortexTimer+3).l,d3			; ''

	.Render:
		lea	(a2),a1						; reload mapping list
		move.w	d1,d0						; multiply by word size
		subq.w	#$01,d0						; '' (and account for 0)
		add.w	d0,d0						; ''
		adda.w	(a1,d0.w),a1					; advance to correct slot
		move.w	(a1)+,d7					; load number of pieces
		bmi.s	.NoRender					; if there are no pieces, branch

	.NextPiece:
		move.w	(a1)+,d0					; load Y position
		add.w	(a0),d0						; add explosion Y position
		move.w	d0,(a4)+					; save to sprite table
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a4)+					; save shape
		addq.w	#$01,a4						; skip link ID
		move.w	(a1)+,d0					; load pattern index
		add.w	d2,d0						; add base index
		move.w	d0,(a4)+					; save index
		move.w	(a1)+,d0					; load X position
		add.w	$02(a0),d0					; add explosion X position
		move.w	d0,(a4)+					; save X
		dbf	d7,.NextPiece					; repeat for all pieces

	.NoRender:
		sub.w	d3,d1						; decrease frame number
		bne.s	.Update						; if not reached 0, branch
		subq.w	#$02,a0						; move back
		pea	(a0)						; store current slot

	.MoveSlot:
		lea	$06(a0),a3					; load next slot
		move.l	(a3)+,(a0)+					; move slot backwards
		move.w	(a3)+,(a0)+					; ''
		tst.w	(a0)						; have we reached the last slot?
		bne.s	.MoveSlot					; if not, keep copying back
		move.l	(sp)+,a0					; restore slot
		move.w	(a0)+,d1					; load next frame
		bne.s	.Render						; if valid, branch
		bra.s	.Finish						; branch to finish set

	.Update:
		move.w	d1,-(a0)					; update frame number
		addq.w	#$06,a0						; advance to next frame

		move.w	(a0)+,d1					; load next frame
		bne.s	.Render						; if valid, branch

	.Finish:
		subq.w	#$02,a0						; move back to last slot
		move.w	a0,(RDE_ExplodeLast).l				; save as last address
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to add an explosion to the list
; --- input -----------------------------------------------------------------
; d0.w = X position
; d1.w = Y position
; d2.b = if explosion SFX should play (00 = no | FF = yes)
; ---------------------------------------------------------------------------

DE_AddExplosion:
		movem.l	d3/a1,-(sp)					; store registers
		moveq	#-1,d3						; load last slot address
		move.w	(RDE_ExplodeLast).l,d3				; ''
		bne.s	.Check						; if address is setup, branch
		move.w	#RDE_Explosion&$FFFF,d3				; setup as first slot

	.Check:
		cmp.w	#(RDE_ExplodeLast-2)&$FFFF,d3			; is it pointing to the last slot?
		beq.s	.NoSpace					; if so, skip
		movea.l	d3,a1						; set address
		move.w	#7,(a1)+					; set starting frame
		move.w	d1,(a1)+					; save Y
		move.w	d0,(a1)+					; save X
		move.w	a1,(RDE_ExplodeLast).l				; update last address
		tst.b	d2						; is SFX meant to play?
		beq.s	.NoSpace					; if not, skip SFX
		tst.b	(RDE_ExplodeSFX).l				; are sfx allowed to play yet?
		bne.s	.NoSpace					; if not, branch
		move.b	#SDE_ExplodeTime,(RDE_ExplodeSFX).l		; reset sfx counter
		sfx	SDE_Explosion					; play sfx

	.NoSpace:
		movem.l	(sp)+,d3/a1					; restore registers
		rts							; return

; ---------------------------------------------------------------------------
; "HIT" sign
; ---------------------------------------------------------------------------

DE_HitSign:
		tst.b	(RDE_HitSign).l					; is the sign meant to show?
		beq.s	.NoSign						; if not, skip rendering
		btst.b	#$02,(RDE_VortexTimer+3).l			; check flicker frame
		beq.s	.NoSign						; if blank time, skip

		lea	(Map_HitDE).l,a1				; load mappings
		move.w	(a1)+,d7					; load number of sprites
		bmi.s	.NoSign						; if there are none, finish
		move.w	(RDE_DispX).l,d1				; load devil eggman's centre
		move.w	(RDE_DispY).l,d2				; ''
		addi.w	#$10,d2						; move down below centre core
		move.w	#$E000|(VDE_HitSign/$20),d3			; prepare pattern index

	.NextSprite:
		move.w	(a1)+,d0					; load Y
		add.w	d2,d0						; add centre Y
		move.w	d0,(a4)+					; save Y
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a4)+					; save shape
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern
		add.w	d3,d0						; add base pattern
		move.w	d0,(a4)+					; save pattern
		move.w	(a1)+,d0					; load X	
		add.w	d1,d0						; add centre X
		move.w	d0,(a4)+					; save X
		dbf	d7,.NextSprite					; repeat for all pieces in the frame

	.NoSign:
		rts							; return (no sign)

; ---------------------------------------------------------------------------
; Slash sprites
; ---------------------------------------------------------------------------

	; --- warning markers ---

DE_SlashMarkers:
		tst.w	(RDE_SlashFade).l				; is the background black
		bgt.w	.NoSlash					; if not, ignore slashing claw sprites
		lea	(RDE_Claws).l,a0				; clear object RAM
		moveq	#(5*2)-1,d7					; number of claw objects

	.Next:
		moveq	#-2,d0						; is the claw object valid as a marker?
		add.w	SO_Frame(a0),d0					; ''
		cmpi.w	#$08,d0						; ''
		bhs.w	.Skip						; if not (not a marker or is empty), skip this slot

		move.l	SO_SpeedX(a0),d0				; load X and Y speed
		move.l	SO_SpeedY(a0),d1				; ''
		move.l	d0,d2						; is this a moving marker object?
		or.l	d1,d2						; ''
		beq.w	.Display					; if not, keep in place and just display

		subq.w	#$01,SO_Counter(a0)				; decrease trail timer
		bcc.s	.NoTrail					; if not ready to place trail, branch
		move.w	#15,SO_Counter(a0)				; set trail to half a second
		lea	SO_Size*5(a0),a1				; load trail marker
		move.w	SO_Frame(a0),SO_Frame(a1)			; copy frame ID
		move.l	SO_Mappings(a0),SO_Mappings(a1)			; copy mappings list
		move.w	SO_Pattern(a0),SO_Pattern(a1)			; copy pattern index
		move.w	SO_PosX(a0),SO_PosX(a1)				; move trail to marker
		move.w	SO_PosY(a0),SO_PosY(a1)				; ''

	.NoTrail:
		add.l	d0,SO_PosX(a0)					; advance X
		add.l	d1,SO_PosY(a0)					; advance Y

		subq.w	#$01,SO_Timer(a0)				; decrease slash time
		bcc.s	.Display					; if not finished, branch
		move.b	(RDE_SlashDirection).l,d0			; get slash direction
		andi.w	#$00E0,d0					; '' convert to correct claw frame
		lsr.w	#$04,d0						; ''
		addi.w	#$000A,d0					; ''
		move.w	d0,SO_Frame(a0)					; ''
		move.w	SO_PointX(a0),SO_PosX(a0)			; reset position back
		move.w	SO_PointY(a0),SO_PosY(a0)			; ''
		move.l	SO_SpeedX(a0),d0				; increase X speed for claws
		add.l	d0,d0						; ''
		move.l	d0,d1						; ''
		add.l	d1,d0						; ''
		add.l	d1,d0						; ''
		move.l	d0,SO_SpeedX(a0)				; ''
		move.l	SO_SpeedY(a0),d0				; increase Y speed for claws
		add.l	d0,d0						; ''
		move.l	d0,d1						; ''
		add.l	d1,d0						; ''
		add.l	d1,d0						; ''
		move.l	d0,SO_SpeedY(a0)				; ''
		move.w	#15,SO_Timer(a0)				; set new slash timer
		move.b	#$20,(ScreenWobble).w				; set screen to shake
		sfx	SDE_Slash					; play slash SFX

	.Display:
		moveq	#$10,d0						; is it off-screen?
		add.w	SO_PosX(a0),d0					; ''
		cmpi.w	#320+($10*2),d0					; ''
		bhs.s	.Skip						; if so, ignore rendering
		moveq	#$10,d0						; is it off-screen on Y?
		add.w	SO_PosY(a0),d0					; ''
		cmpi.w	#224+($10*2),d0					; ''
		bhs.s	.OffScreen					; if so, skip rendering
		bsr.w	DE_RenderStandard				; render the object

	.OffScreen:
	.Skip:
		lea	SO_Size(a0),a0					; advance to next object slot
		dbf	d7,.Next					; repeat until all claws have been processed

	.NoSlash:
		rts							; return

	; --- the slashing claws themselves ---

DE_SlashClaws:
		tst.w	(RDE_SlashFade).l				; is the background black
		bgt.w	.NoSlash					; if not, ignore slashing claw sprites
		lea	(RDE_Claws).l,a0				; clear object RAM
		moveq	#(5*2)-1,d7					; number of claw objects
		moveq	#5-1,d6						; number of actual claw objects to check for finishing

	.Next:
		moveq	#-8,d0						; is the claw object valid as a claw?
		add.w	SO_Frame(a0),d0					; ''
		ble.w	.Skip						; if not, skip this slot

		tst.b	SO_Touch(a0)					; was this claw touched?
		bne.s	.Touch						; if so, branch (prevent AddCollision from clearing the flag)
		moveq	#$0C,d0						; set width
		moveq	#$0C,d1						; set height
		moveq	#DEC_ROLL|DEC_FLOAT|DEC_HURT,d2			; collision type
		jsr	DE_AddCollision					; add object to collision

	.Touch:
		move.l	SO_SpeedX(a0),d2				; load X and Y speed
		move.l	SO_SpeedY(a0),d3				; ''
		move.l	d2,d0						; is this a moving marker object?
		or.l	d3,d0						; ''
		beq.s	.Display					; if not, keep in place and just display

		lea	SO_Size*5(a0),a1				; load trail marker
		move.w	SO_Frame(a0),SO_Frame(a1)			; copy frame ID
		move.l	SO_Mappings(a0),SO_Mappings(a1)			; copy mappings list
		move.w	SO_Pattern(a0),SO_Pattern(a1)			; copy pattern index
		jsr	RandomNumber					; get random number for slight jitter
		moveq	#$10-1,d1					; get jitter range
		and.w	d0,d1						; ''
		subi.w	#($10/2),d1					; align to centre
		add.w	SO_PosX(a0),d1					; add to current X position
		move.w	d1,SO_PosX(a1)					; ''
		andi.w	#($10-1)<<4,d0					; get jitter range for Y
		lsr.w	#$04,d0						; ''
		subi.w	#($10/2),d0					; align to centre
		add.w	SO_PosY(a0),d0					; add to current Y position
		move.w	d0,SO_PosY(a1)					; ''

	.NoTrail:
		add.l	d2,SO_PosX(a0)					; move claw
		add.l	d3,SO_PosY(a0)					; ''

		subq.w	#$01,SO_Timer(a0)				; decrease slash timer
		bcc.s	.Display					; if not finished, continue
		clr.w	SO_Timer(a0)					; keep timer at 0
		dbf	d6,.OffScreen					; repeat until all claws are finished slashing
		moveq	#$7F,d0						; if any object was touched d0 will...
		and.b	(RDE_Touch).l,d0				; ..contain 7F, otherwise if not, it'll contain 00
		move.b	d0,(RDE_DoneSlash).l				; set slash as done	
		clr.w	SO_Frame(a0)					; mark at least one object as blank (so it doesn't run down here again)
		bra.s	.OffScreen					; continue

	.Display:
		moveq	#$10,d0						; is it off-screen?
		add.w	SO_PosX(a0),d0					; ''
		cmpi.w	#320+($10*2),d0					; ''
		bhs.s	.Skip						; if so, ignore rendering
		moveq	#$10,d0						; is it off-screen on Y?
		add.w	SO_PosY(a0),d0					; ''
		cmpi.w	#224+($10*2),d0					; ''
		bhs.s	.OffScreen					; if so, skip rendering
		bsr.w	DE_RenderStandard				; render the object

	.OffScreen:


	.Skip:
		lea	SO_Size(a0),a0					; advance to next object slot
		dbf	d7,.Next					; repeat until all claws have been processed

	.NoSlash:
		rts							; return

; ---------------------------------------------------------------------------
; Rendering energy balls
; ---------------------------------------------------------------------------

DE_EnergyBalls:
	tst.b	(RDE_ShowEnergy).l				; are energy balls meant to show?
	beq.s	DE_SlashClaws.NoSlash				; if not, skip
		lea	(SineTable+1).w,a3				; load sinewave table
		lea	(RDE_Energy).l,a0				; load energy ball object list
		moveq	#5-2,d7						; number of energy balls

	.NextBall:
		bsr.s	.RenderBall					; render the ball
		lea	SO_Size(a0),a0					; advance to next energy ball
		dbf	d7,.NextBall					; repeat for 4 of the balls (last ball continues below)

	.RenderBall:
		move.l	SO_SpeedX(a0),d0				; move X
		add.l	d0,SO_PointX(a0)				; ''
		move.l	SO_SpeedY(a0),d0				; move Y
		add.l	d0,SO_PointY(a0)				; ''
		move.l	SO_SpeedZ(a0),d0				; move Z
		add.l	d0,SO_PointZ(a0)				; ''
		bpl.s	.InRange					; if not gone through the screen, branch
		clr.l	SO_PointZ(a0)					; keep at maximum position

	.InRange:

		tst.w	SO_Frame(a0)					; are the energy balls being rendered?
		bne.s	.OnScreen					; if so, perform rendering
		rts							; return

	.OnScreen:
		bsr.w	DE_ConvertZ					; create correct X and Y positions based on Z position
		lsr.w	#$03-1,d1					; align to frame rate of scale
		cmpi.w	#$01E0>>3,d1					; is the frame being shown out of range of what we have in VRAM?
		blo.s	.ValidFrame					; if not, carry on...
		spl.b	d1						; force to minimum or maximum
		andi.w	#$01E0>>3,d1					; ''

	.ValidFrame:
		tst.w	SO_Counter(a0)					; has the explosion flag been set?
		beq.s	.NoExplode					; if not, branch
		move.w	SO_Counter(a0),d0				; load frame from explosion counter
		lsr.w	#$01,d0						; remove fraction of counter
		move.w	d0,SO_Frame(a0)					; set as explosion frame
		bra.s	.Explode					; continue
		
	.NoExplode:
		addq.w	#$06,d1						; advance to starting frame
		moveq	#$04,d0						; load 4th frame timer as odd frame
		and.b	(RDE_VortexTimer+3).l,d0			; ''
		lsr.w	#$01,d0						; ''
		add.w	d0,d1						; ''
		move.w	d1,SO_Frame(a0)					; set frame address

	.Explode:
		moveq	#$00,d0						; load angle
		move.b	SO_Angle(a0),d0					; ''
		add.w	d0,d0						; ''
		move.w	SO_AngSpeed(a0),d1				; load angle speed
		add.w	d1,SO_Angle(a0)					; rotate angle

		move.w	SO_AngDistX(a0),d2				; load X radius
		beq.s	.NoRotateX					; if there is no radius, branch
		move.w	-$01(a3,d0.w),d1				; load sine
		muls.w	d2,d1						; multiply by radius
		asr.l	#$08,d1						; ''
		add.w	d1,SO_PosX(a0)					; add to X position

	.NoRotateX:
		move.w	SO_AngDistY(a0),d2				; load Y radius
		beq.s	.NoRotateY					; if there is no radius, branch
		move.w	+$7F(a3,d0.w),d1				; load cosine
		muls.w	d2,d1						; multiply by radius
		asr.l	#$08,d1						; ''
		add.w	d1,SO_PosY(a0)					; add to Y position

	.NoRotateY:

		move.b	(RDE_VortexTimer+3).l,d0			; load 8th frame timer as mirror flag
		moveq	#$08,d1						; ''
		eor.b	d1,d0						; '' (reverse it, animation is slightly backwards)
		and.w	d1,d0						; '' (get only that bit)
		lsl.w	#$08,d0						; ''
		ori.w	#$E000|(VDE_Energy/$20),d0			; fuse base pattern index with it
		move.w	d0,SO_pattern(a0)				; set as pattern index (correct mirror frame)
		bra.s	DE_RenderStandard				; render the energy ball

; ---------------------------------------------------------------------------
; Rendering eggman's detachable arms (when they're detached)
; ---------------------------------------------------------------------------

DE_SpritesArms:
	tst.b	(RDE_ShowArms).l				; are arms meant to show?
	beq.w	DE_RenderStandard.NoShow			; if not, skip
		lea	(RDE_LeftArm).l,a0				; load left arm
		bsr.s	DE_RenderStandard				; render left arm
		lea	(RDE_RightArm).l,a0				; load right arm
		; ...							; render right arm...

; ---------------------------------------------------------------------------
; Sprite rendering (standard and scaling versions)
; ---------------------------------------------------------------------------

	; --- Standard version ---

DE_RenderStandard:
		moveq	#-2,d0						; load frame
		and.w	SO_Frame(a0),d0					; ''
		beq.w	.BlankFrame					; if it's a blank frame, skip
		move.l	SO_Mappings(a0),d1				; load mappings address
		bmi.w	DE_RenderScale					; if it's the scale version, branch to scale subroutine
		movea.l	d1,a1						; set mappings address
		adda.w	-$02(a1,d0.w),a1				; advance to correct mappings
		move.w	(a1)+,d1					; load number of pieces
		bmi.w	.BlankFrame					; if none, skip rendering
		moveq	#-$80,d3					; load X and Y positions (with void space)
		move.w	SO_PosX(a0),d2					; ''
		sub.w	d3,d2						; ''
		sub.w	SO_PosY(a0),d3					; ''
		neg.w	d3						; ''
		add.w	(Screen_shaking_flag+2).w,d3			; add screenshake to Y position
		move.w	SO_Pattern(a0),d4				; load pattern index

		moveq	#$18,d0						; load flip mirror
		and.b	SO_Pattern(a0),d0				; ''
		jmp	.List(pc,d0.w)					; run correct render routine

	.List:	bra.w	.Normal
		dc.w	$0000,$0000
		bra.w	.Mirror
		dc.w	$0000,$0000,$0000
		bra.s	.Flip
		dc.w	$0000,$0000,$0000

	.MirFlip:
		move.w	(a1)+,d0					; load Y
		move.w	(a1),d5						; load shape
		add.b	d5,d5						; convert to word
		neg.w	d0						; reverse
		sub.w	.FlpSh(pc,d5.w),d0				; correct Y
		add.w	d3,d0						; add central Y
		move.w	d0,(a4)+					; save Y
		move.w	(a1)+,d0					; reload shape
		move.b	d0,(a4)+					; save shape
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern index
		add.w	d4,d0						; add base index
		move.w	d0,(a4)+					; save pattern index
		move.w	(a1)+,d0					; load X
		neg.w	d0						; reverse
		sub.w	.MirSh(pc,d5.w),d0				; correct X
		add.w	d2,d0						; add central X
		move.w	d0,(a4)+					; save X
		dbf	d1,.MirFlip					; repeat for all pieces

	.NoShow:
		rts							; return

	.FlpSh:	dc.w	$08,$10,$18,$20
		dc.w	$08,$10,$18,$20
		dc.w	$08,$10,$18,$20
		dc.w	$08,$10,$18,$20

	.Flip:
		move.w	(a1)+,d0					; load Y
		move.w	(a1)+,d5					; load shape
		add.b	d5,d5						; convert to word
		neg.w	d0						; reverse
		sub.w	.FlpSh(pc,d5.w),d0				; correct Y
		add.w	d3,d0						; add central Y
		move.w	d0,(a4)+					; save Y
		move.w	(a1)+,d0					; reload shape
		move.b	d0,(a4)+					; save shape
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern index
		add.w	d4,d0						; add base index
		move.w	d0,(a4)+					; save pattern index
		move.w	(a1)+,d0					; load X
		add.w	d2,d0						; add central X
		move.w	d0,(a4)+					; save X
		dbf	d1,.Flip					; repeat for all pieces
		rts							; return

	.MirSh:	dc.w	$08,$08,$08,$08
		dc.w	$10,$10,$10,$10
		dc.w	$18,$18,$18,$18
		dc.w	$20,$20,$20,$20

	.Mirror:
		move.w	(a1)+,d0					; load Y
		add.w	d3,d0						; add central Y
		move.w	d0,(a4)+					; save Y
		move.w	(a1)+,d5					; load shape
		move.b	d5,(a4)+					; save shape
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern index
		add.w	d4,d0						; add base index
		move.w	d0,(a4)+					; save pattern index
		move.w	(a1)+,d0					; load X
		neg.w	d0						; reverse
		add.b	d5,d5						; convert to word
		sub.w	.MirSh(pc,d5.w),d0				; correct X
		add.w	d2,d0						; add central X
		move.w	d0,(a4)+					; save X
		dbf	d1,.Mirror					; repeat for all pieces
		rts							; return

	.Normal:
		move.w	(a1)+,d0					; load Y
		add.w	d3,d0						; add central Y
		move.w	d0,(a4)+					; save Y
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a4)+					; save shape
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern index
		add.w	d4,d0						; add base index
		move.w	d0,(a4)+					; save pattern index
		move.w	(a1)+,d0					; load X
		add.w	d2,d0						; add central X
		move.w	d0,(a4)+					; save X
		dbf	d1,.Normal					; repeat for all pieces

	.BlankFrame:
		rts							; return

	; --- Scale version ---

DE_RenderScale:
		andi.l	#$00FFFFFF,d1					; some emulators fail the MSB address
		movea.l	d1,a1						; set mappings address
		adda.w	-$02(a1,d0.w),a1				; advance to correct mappings
		move.w	(a1)+,d1					; load number of pieces
		bmi.s	.BlankFrame					; if none, skip rendering
		moveq	#-$80,d3					; load X and Y positions (with void space)
		move.w	SO_PosX(a0),d2					; ''
		sub.w	d3,d2						; ''
		sub.w	SO_PosY(a0),d3					; ''
		neg.w	d3						; ''
		add.w	(Screen_shaking_flag+2).w,d3			; add screenshake to Y position
		move.w	SO_Pattern(a0),d4				; load pattern index
		move.w	(RDE_ArmSml_ScaleMul).l,d5			; prepare scale amount

	.NextPiece:
		move.w	(a1)+,d0					; load Y
		muls.w	d5,d0						; divide position down based on scale
		asr.l	#$08,d0						; ''
		sub.w	(a1)+,d0					; minus central height of sprite piece
		add.w	d3,d0						; add central Y
		move.w	d0,(a4)+					; save Y
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a4)+					; save shape
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern index
		add.w	d4,d0						; add base index
		move.w	d0,(a4)+					; save pattern index
		move.w	(a1)+,d0					; load X
		muls.w	d5,d0						; divide position down based on scale
		asr.l	#$08,d0						; ''
		sub.w	(a1)+,d0					; minus central width of sprite piece
		add.w	d2,d0						; add central X
		move.w	d0,(a4)+					; save X
		dbf	d1,.NextPiece					; repeat for all pieces

	.BlankFrame:
		rts							; return

; ---------------------------------------------------------------------------
; Rendering eggman's eyes behind his face
; ---------------------------------------------------------------------------

DE_SpritesEyes:
		cmpi.w	#$0008,(RDE_ScaleH).l				; is the boss too small to see the eyes (on height)?
		blo.s	DE_RenderScale.BlankFrame			; if so, ignore eyes
		cmpi.w	#$0014,(RDE_ScaleW).l				; is the boss too small to see the eyes (on width)?
		blo.s	DE_RenderScale.BlankFrame			; if so, ignore eyes

		moveq	#-$80,d7					; load X and Y positions (and account for void space)
		move.w	(RDE_DispX).l,d6				; ''
		sub.w	d7,d6						; ''
		sub.w	(RDE_DispY).l,d7				; ''
		neg.w	d7						; ''
		add.w	(Screen_shaking_flag+2).w,d7			; add screenshake to Y position
		sub.w	(RDE_EyeY).l,d7					; '' (get eye Y position instead of body centre)

	; d6 = X position
	; d7 = Y position

	; --- Eyes ---

		move.w	#$2000+(VDE_Eyes/$20),d3			; load eye pattern index address
		move.w	(RDE_ScaleY_CAP).l,d0				; load scale amount
		cmpi.w	#$08,d0						; is it beyond the maximum eye scale frame?
		blo.s	.EyeSize					; if not, use as scale frame
		moveq	#$07,d0						; force scale frame to last (smallest)

	.EyeSize:
		add.w	d0,d3						; advance to correct scale frame

		moveq	#$00,d0						; load angle Sonic is from eggman
		move.b	(RDE_AngSonic).l,d0				; ''
		add.w	d0,d0						; multiply by size of word element in sine table
		lea	(SineTable+1).w,a0				; load sinewave table
		move.w	-$01(a0,d0.w),d1				; load correct Y sine
		move.w	+$7F(a0,d0.w),d0				; load correct X sine
		asr.w	#$07,d1						; reduce to correct distance (size of eye move area)
		asr.w	#$07,d0						; ''
		add.w	d6,d0						; move to eye area on X
		subq.w	#$04,d0						; '' (ajustment)
		add.w	d7,d1						; move to eye area on Y
		subq.w	#$01,d1						; '' (ajustment)

		move.w	(RDE_ScaleW).l,d2				; load width for eye distance from centre
		lsr.w	#$04,d2						; reduce to correct-ish distance
		subq.w	#$01,d2						; '' (correction)

		; Right eye

		move.w	d1,(a4)+					; set Y position of black mask
		sf.b	(a4)+						; set shape
		addq.w	#$01,a4						; skip link
		move.w	d3,(a4)+					; set pattern index of black mask
		add.w	d2,d0						; move right for right eye
	;addq.w	#$07,d0
		move.w	d0,(a4)+					; set X position of black mask

		; Left eye

		move.w	d1,(a4)+					; set Y position of black mask
		sf.b	(a4)+						; set shape
		addq.w	#$01,a4						; skip link
		move.w	d3,(a4)+					; set pattern index of black mask
		sub.w	d2,d0						; move left for left eye
		sub.w	d2,d0						; ''
	;subi.w	#$000E,d0
		move.w	d0,(a4)+					; set X position of black mask


	; --- The black eye backdrop ---

		move.l	(RDE_ScaleS).l,d0				; get scale width and height
		moveq	#$0D,d5						; set largest size
		subq.w	#$08,d7						; move up for largest size/shape
		cmpi.w	#$0030,d0					; is it large enough for largest shape?
		bhs.s	.LargerY					; if so, continue
		addq.w	#$04,d7						; move down for single tile rather than double
		subq.b	#$01,d5						; reduce shape to signle tile instead of double
		cmpi.w	#$0010,d0					; is it even smaller?
		bhs.s	.LargerY					; if not, continue
		addq.w	#$02,d7						; move down a bit more (top of tile just barely overflows the head)

	.LargerY:
		swap	d0						; get width
		subi.w	#$10,d6						; centre the sprite on X (for 4 tile width)
		cmpi.w	#$0050,d0					; is it at its largest?
		bhs.s	.LargerX					; if so, continue
		addq.w	#$04,d6						; move sprite right (for 1 reduced tile)
		subq.b	#$04,d5						; reduce tile width by 1
		cmpi.w	#$0040,d0					; is it large enough for 3 tiles?
		bhs.s	.LargerX					; if so, continue
		addq.w	#$04,d6						; move right for a tile
		subq.b	#$04,d5						; reduce tile width by 1
		cmpi.w	#$0028,d0					; is it large enough for 2 tiles?
		bhs.s	.LargerX					; if so, continue
		addq.w	#$04,d6						; move right for a tile
		subq.b	#$04,d5						; reduce tile by 1

	.LargerX:
		move.w	d7,(a4)+					; set Y position of black mask
		move.b	d5,(a4)+					; set shape
		addq.w	#$01,a4						; skip link
		move.w	#$2008+(VDE_Eyes/$20),(a4)+			; set pattern index of black mask
		move.w	d6,(a4)+					; set X position of black mask
		rts							; return

; ---------------------------------------------------------------------------
; Rendering Missiles
; ---------------------------------------------------------------------------

DE_SpritesMissiles:
	tst.b	(RDE_ShowMissiles).l				; are missiles meant to show?
	beq.s	.NoMissiles					; if not, skip
		move.w	(RDE_MissAngle).l,d5				; load number of frames/angles from PreRot
		move.w	#$E000|(VDE_Missile/$20),d6			; VRAM address where missile art starts
		lea	(RDE_Missiles).l,a0				; load missile objects
		lea	(RDE_MissArt).l,a1				; load missile art request list
		moveq	#3-2,d7						; number of objects to run

	.NextObject:
		bsr.s	.RenderObject					; render the missile
		lea	SO_Size(a0),a0
		dbf	d7,.NextObject					; repeat for all objects

	.RenderObject:
		move.w	SO_Frame(a0),d0					; load frame ID
		bne.s	.ShowObject					; if there's a valid frame, missile can show
		addq.w	#$04,a1						; skip slot

	.NoMissiles:
		rts							; return

	.ShowObject:
		moveq	#$80-$10,d2					; load missile positions (with void space) (get centre)
		move.w	SO_PosX(a0),d3					; ''
		add.w	d2,d3						; ''
		add.w	SO_PosY(a0),d2					; ''
		tst.b	SO_Frame(a0)					; 
		bpl.s	.Rotation					; if this is a rotation rocket, branch

	; --- Scale rockets ---

		move.w	d2,(a4)+					; save Y position
		move.b	#$0F,(a4)+					; set shape
		addq.w	#$01,a4						; skip link
		move.w	#$6000|(VDE_MissileSca/$20),(a4)+		; set pattern index directly to the scale art
		move.w	d3,(a4)+					; save X position
		rts							; return

	; --- Rotation rockets ---

	.Rotation:
		tst.b	SO_Angle(a0)					; is the angle 180 to 359?
		smi.b	d0						; if so, force -1
		ext.w	d0						; ''
		sub.w	d0,d2						; shift sprite down if 180 to 359
		move.w	d2,(a4)+					; save Y position
		move.b	#$0F,(a4)+					; set shape
		addq.w	#$01,a4						; skip link ID

		move.w	d0,d1						; flip and mirror the piece if 180 to 259
		andi.w	#$1800,d1					; ''
		add.w	d6,d1						; ''
		move.w	d1,(a4)+					; save pattern index
		addi.w	#$0010,d6					; advance to next VRAM space
		sub.w	d0,d3						; shift sprite right if 180 to 359
		move.w	d3,(a4)+					; save X position

		moveq	#$7F,d0						; load 0 to 180 degrees either side
		and.b	SO_Angle(a0),d0					; ''

	lsr.b	#$02,d0						; divide by rotation angles 8 inside the generated list
	;	divu.w	d5,d0						; divide by rotation angles which were generated
		move.b	d0,(a4)						; multiply by 200 (size of art $10 tiles)
		move.w	(a4),d0						; ''
		sf.b	d0						; ''
		add.w	d0,d0						; ''
		addi.w	#RDE_MissileArt&$FFFF,d0			; add starting art RAM address
		move.w	d0,(a1)+					; send request
		addq.w	#$02,a1						; skip previous request
		rts							; return

; ---------------------------------------------------------------------------
; Rendering Sonic
; ---------------------------------------------------------------------------
DE_LAYEREDGE	= $20
; ---------------------------------------------------------------------------
DE_LAYERPOSX	macro	SPEED
POS := (-(SPEED*(224/2)))+$80000
	rept	((320-224)/2)+DE_LAYEREDGE
		dc.w	(POS>>$14)&$FFFF
	endm
	rept	224
		dc.w	(POS>>$14)&$FFFF
POS := POS+SPEED
	endm
	rept	((320-224)/2)+DE_LAYEREDGE
		dc.w	(POS>>$14)&$FFFF
	endm
		endm
; ---------------------------------------------------------------------------
DE_LAYERPOSY	macro	SPEED
POS := (-(SPEED*(224/2)))+$80000
	rept	DE_LAYEREDGE
		dc.w	(POS>>$14)&$FFFF
	endm
	rept	224
		dc.w	(POS>>$14)&$FFFF
POS := POS+SPEED
	endm
	rept	DE_LAYEREDGE
		dc.w	(POS>>$14)&$FFFF
	endm
		endm
; ---------------------------------------------------------------------------

DE_SpritesSonic:
		tst.b	(RDE_ShowSonic).l				; is Sonic allowed to render?
		bne.s	.Render						; if so, continue

	.Hide:
		rts							; return (hidden)

	.Render:
		lea	(RDE_Sonic).l,a0				; load Sonic's object RAM
		move.w	#$8000|(VDE_Sonic/$20),d6			; prepare pattern index address of sprites
		tst.b	(RDE_SonicDead).l				; is Sonic dead?
		bne.w	DE_SpritesFlesh					; if so, render flesh instead

		tst.w	(RDE_RollTimer).l				; is Sonic rolling?
		beq.w	DE_RenderSonic					; if not, render the layer version of sprites

		cmpi.w	#30,(RDE_RollTimer).l				; is there half a second left?
		bgt.s	.NoDelay					; if not, branch
		btst.b	#$00,(RDE_VortexTimer+3).l			; slow animation down by half a frame
		beq.s	.Delay						; ''
		cmpi.w	#15,(RDE_RollTimer).l				; is there a quarter second left?
		bgt.s	.NoDelay					; if not, branch
		btst.b	#$01,(RDE_VortexTimer+3).l			; slow animation down by a quarter frame
		beq.s	.Delay						; ''

	.NoDelay:
		move.w	SO_Counter(a0),d1				; load counter
		lea	.Ani(pc),a1

		move.w	#$8000|(VDE_SonicRoll/$20),SO_Pattern(a0)	; set pattern for rolling Sonic
		move.l	#Map_SonRoll,SO_Mappings(a0)			; set mappings for rolling Sonic
		tst.b	(RDE_LastBoostTimer).l				; are we charging?
		beq.s	.Normal						; if not, continue
		move.w	#$8000|(VDE_SonicCharge/$20),SO_Pattern(a0)	; set pattern for rolling Sonic
		move.l	#Map_SonCharge,SO_Mappings(a0)			; set mappings for rolling Sonic
		lea	.Ani2(pc),a1					; use charge animation

	.Normal:

	.Loop:
		move.w	d1,d0						; load frame
		move.w	(a1,d0.w),d1					; load correct animation frame
		beq.s	.Loop						; if the animation is finished, loop it
		addq.w	#$02,d0						; advancet to next frame
		move.w	d0,SO_Counter(a0)				; update counter
		move.w	d1,SO_Frame(a0)					; set frame

	.Delay:
		bsr.s	DE_FlashSonic					; allow Sonic to flash

		bra.w	DE_RenderStandard				; run normal animation

	.Ani:	dc.w	2, 4, 2, 6, 2, 8, 2, 10, 0	; Normal spin
	.Ani2:	dc.w	2, 4, 2, 6, 2, 8, 2, 10, 0	; Charge spin at end of boss

	; --- Sonic flashing when hurt ---

DE_FlashSonic:
		subq.b	#$01,SO_Touch(a0)				; decrease Sonic's hurt/touch timer
		scc.b	d0						; if reached 0, keep at 0
		and.b	d0,SO_Touch(a0)					; ''
		beq.s	.Show						; if 0, skip and show
		btst.b	#$01,SO_Touch(a0)				; is Sonic meant to flicker this frame?
		beq.w	.Show						; if not, branch and show
		addq.w	#$04,sp						; skip return (don't show Sonic)

	.Show:
		rts							; return

	; --- Special layer rendering routine for Sonic when not rolling ---

DE_RenderSonic:
		bsr.s	DE_FlashSonic					; allow Sonic to flash

		moveq	#DE_LAYEREDGE,d0				; prepare edge size (size of edge of screen where Sonic's sprite can go before off-screen)
		move.w	SO_PosX(a0),d4					; load X position
		add.w	d0,d4						; account for edge
		cmpi.w	#320+(DE_LAYEREDGE*2),d4			; is Sonic completely off-screen?
		blo.s	.ValidX						; if not, continue
		spl.b	d4						; force to left or right depending on polarity
		ext.w	d4						; ''
		andi.w	#(320+(DE_LAYEREDGE*2))-1,d4			; ''

	.ValidX:
		move.w	SO_PosY(a0),d5					; load Y position
		add.w	d0,d5						; account for edge
		cmpi.w	#224+(DE_LAYEREDGE*2),d5			; is Sonic completely off-screen?
		blo.s	.ValidY						; if not, continue
		spl.b	d5						; force to top or bottom depending on polarity
		ext.w	d5						; ''
		andi.w	#(224+(DE_LAYEREDGE*2))-1,d5			; ''

	.ValidY:
		add.w	(Screen_shaking_flag+2).w,d4			; add screenshake to Y position
		lea	(DE_LayPos).l,a2				; load layout position list
		lea	(Map_SonLay).l,a3				; load Sonic's layer mapping list
		move.w	(a3)+,d0					; load relative Y position
		moveq	#-DE_LAYEREDGE,d2				; load X sprite position (with edge of screen boundary)
		add.w	d4,d2						; ''
		moveq	#-DE_LAYEREDGE,d3				; load Y sprite position (with edge of screen boundary)
		add.w	d5,d3						; ''
		add.w	d4,d4						; setup X and Y for table reading
		add.w	d5,d5						; ''
		moveq	#$00,d7						; set no flapping pixel as having been added
		btst.b	#$02,(RDE_VortexTimer+3).l			; are we on a flap frame?
		beq.s	.NextPiece					; if not, branch
		moveq	#$01,d7						; set flapping pixel as added
		subq.w	#$01,d3						; move first layer up a pixel (to simulate flapping)
		bra.s	.NextPiece					; ignore first layer (needs no converting)

	.NextLayer:
		move.l	(a2)+,a1					; load X list
		sub.w	(a1,d4.w),d2					; display layer on X
		move.l	(a2)+,a1					; load Y list
		sub.w	(a1,d5.w),d3					; display layer on Y

	.NextPiece:
		add.w	d3,d0						; add Y position
		move.w	d0,(a4)+					; save to sprite table
		move.w	(a3)+,d0					; load shape
		move.b	d0,(a4)+					; save to sprite table
		addq.w	#$01,a4						; skip link ID
		move.w	(a3)+,d0					; load pattern index
		add.w	d6,d0						; add base index
		move.w	d0,(a4)+					; save to sprite table
		move.w	(a3)+,d0					; load X position
		add.w	d2,d0						; add X position
		move.w	d0,(a4)+					; save to sprite table
		move.w	(a3)+,d0					; load next relative Y position
		bgt.s	.NextPiece					; if it's another piece, branch
		add.w	d7,d3						; move first layer back down (if it were up)
		moveq	#$00,d7						; clear flapping flag
		neg.w	d0						; convert to positive
		bne.s	.NextLayer					; if it's a Y position for the next layer, branch
		rts							; return

; ---------------------------------------------------------------------------
; Relative displacement for the layers
; ---------------------------------------------------------------------------

DE_LayPos:	dc.l	DE_LayPosX_2, DE_LayPosY_2
		dc.l	DE_LayPosX_3, DE_LayPosY_3
		dc.l	DE_LayPosX_4, DE_LayPosY_4

DE_LayPosB:	dc.l	DE_LayPosX_2, DE_LayPosY_2
		dc.l	DE_LayPosX_3, DE_LayPosY_3
		dc.l	DE_LayPosX_4, DE_LayPosY_4

DE_LayPosX_2:	DE_LAYERPOSX	((((224/2)<<7)-((224/2)<<5))/2)
DE_LayPosX_3:	DE_LAYERPOSX	((((224/2)<<7)-((224/2)<<5))*1)
DE_LayPosX_4:	DE_LAYERPOSX	((((224/2)<<7)-((224/2)<<5))*2)

DE_LayPosY_2:	DE_LAYERPOSY	((((224/2)<<7)-((224/2)<<5))/2)
DE_LayPosY_3:	DE_LAYERPOSY	((((224/2)<<7)-((224/2)<<5))*1)
DE_LayPosY_4:	DE_LAYERPOSY	((((224/2)<<7)-((224/2)<<5))*2)

; ---------------------------------------------------------------------------
; Flesh rendering when Sonic is killed
; ---------------------------------------------------------------------------

DE_SpritesFlesh:
		lea	(RDE_Flesh).l,a0				; load flesh art
		moveq	#RDE_FLESHCOUNT-1,d7				; number of flesh pieces

	.NextFlesh:
		lea	(Ani_Flesh).l,a2				; load flesh animation

		move.w	SO_Frame(a0),d0					; load animation ID
		add.w	d0,d0						; ''
		adda.w	(a2,d0.w),a2					; advance to correct animation list
		subq.b	#$01,SO_Timer(a0)				; decrease delay timer
		bcc.s	.NoTimer					; if still counting, branch
		move.b	(a2),SO_Timer(a0)				; reset timer
		addq.b	#$01,SO_Timer+1(a0)				; advance animation position

	.NoTimer:
		moveq	#$00,d1						; load animation position
		move.b	SO_Timer+1(a0),d1				; ''

		move.b	$01(a2,d1.w),d0					; load parameter (if needed)
		move.b	(a2,d1.w),d1					; load frame ID
		bpl.s	.NoLoop						; if not a loop flag, branch
		addq.b	#$01,d1						; was it FF?
		beq.s	.Loop						; if so, branch for full loop
		sub.b	d0,SO_Timer+1(a0)				; move position back
		bra.s	.NoTimer					; reload frame

	.Loop:
		move.b	#$01,SO_Timer+1(a0)				; reset to beginning of animation
		move.b	$01(a2),d1					; load first frame

	.NoLoop:
		move.l	SO_SpeedX(a0),d0				; load X speed
		add.l	d0,SO_PosX(a0)					; move flesh
		asr.l	#$08,d0						; reduce speed
		sub.l	d0,SO_SpeedX(a0)				; ''
		move.l	SO_SpeedY(a0),d0				; load Y speed
		add.l	d0,SO_PosY(a0)					; move flesh
		asr.l	#$08,d0						; reduce speed
		sub.l	d0,SO_SpeedY(a0)				; ''
		bsr.s	.Render						; let piece render
		lea	SO_Size(a0),a0					; advance to next piece
		dbf	d7,.NextFlesh					; repeat for all flesh pieces
		rts							; return

	.Render:

		lea	(Map_Flesh).l,a1				; load the flesh mappings from hellfire saga
		add.w	d1,d1						; multiply frame number by size of word pointer
		adda.w	(a1,d1.w),a1					; advance to correct frame

		move.w	(a1)+,d5					; load number of pieces
		subq.w	#$01,d5						; minus 1 for dbf
		bcs.s	.NoPieces					; if there are no piece, branch

		moveq	#-$80,d0
		move.w	d6,d4
		move.w	SO_PosX(a0),d1
		move.w	SO_PosY(a0),d2
		btst.b	#$00,(RDE_VortexTimer+3).l
		bne.s	.NoFlip
		sub.w	(RDE_Sonic+SO_PosX).l,d1
		neg.w	d1
		add.w	(RDE_Sonic+SO_PosX).l,d1
		sub.w	(RDE_Sonic+SO_PosY).l,d2
		neg.w	d2
		add.w	(RDE_Sonic+SO_PosY).l,d2
		eori.w	#$1800,d4

	.NoFlip:
		move.w	d4,d3						; separate the flags from the tile index
		andi.w	#$F800,d3					; ''
		sub.w	d3,d4						; '' d4 = tile d3 = flags.
		sub.w	d0,d1
		sub.w	d0,d2

	;	moveq	#-$80,d2					; load X and Y positions (with void space)
	;	move.w	SO_PosX(a0),d1					; ''
	;	sub.w	d2,d1						; ''
	;	sub.w	SO_PosY(a0),d2					; ''
	;	neg.w	d2						; ''
		add.w	(Screen_shaking_flag+2).w,d2			; add screenshake to Y position

	.NextPiece:
		move.b	(a1)+,d0					; load Y position
		ext.w	d0						; expand to word
		add.w	d2,d0						; add centre Y position
		move.w	d0,(a4)+					; save to sprite table
		move.b	(a1)+,(a4)+					; save shape
		addq.w	#$01,a4						; skip link ID
		move.w	(a1)+,d0					; load pattern index
		add.w	d4,d0						; add base index
		add.w	d3,d0						; add base flags
		move.w	d0,(a4)+					; save pattern index
		move.w	(a1)+,d0					; load X position
		add.w	d1,d0						; add centre X position
		move.w	d0,(a4)+					; save to sprite table
		dbf	d5,.NextPiece					; repeat for all pieces

	.NoPieces:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to control the vortex display (palette, H-scroll, V-scroll, etc)
; ---------------------------------------------------------------------------

DE_ControlVortex:
		move.w	(RDE_VortexAccel).l,d1				; load accel/decel speed
		move.w	(RDE_VortexDest).l,d2				; load vortex's destination speed
		move.w	#$8000,d3					; prepare overflow flag
		move.w	(RDE_VortexSpeed).l,d0				; load vortex speed
		sub.w	d2,d0						; is the speed reached destination?
		beq.s	.Match						; if so, skip speed change
		bmi.s	.Slow						; if it's slower than destination, branch to speed up
		neg.w	d1						; reverse accel/decel speed

	.Slow:
		add.w	d3,d0						; change overflow bit
		add.w	d1,d0						; speed up/slow down
		bvc.s	.NoMatch					; if it hasn't reached destination, continue
		move.w	d3,d0						; force speed to destination

	.NoMatch:
		sub.w	d3,d0						; undo overflow bit
		add.w	d2,d0						; re-correct the speed
		move.w	d0,(RDE_VortexSpeed).l				; save as current speed

	.Match:
		move.w	(RDE_VortexSpeed).l,d0				; load vortex speed
		add.w	d0,(RDE_VortexPos).l				; add to position

		move.w	(RDE_VortexColour).l,d1				; load colour for vortex (on intro)

		move.l	(RDE_VortexTimer).l,d0				; load cycle timer
		lsr.l	#$03,d0						; reduce speed for colour cycles
		andi.w	#((DE_CycleList_End-DE_CycleList)-1)&(-2),d0	; wrap the table
		move.w	DE_CycleList(pc,d0.w),d2			; load cycle colour for the vortex

		tst.w	(RDE_VortexCycle).l				; are we fading colours?
		beq.s	.Solid						; if not, branch and use solid colour
		exg.l	d1,d2						; set to use cycle colour
		tst.b	(RDE_VortexCycle).l				; is the fade at maximum?
		bne.s	.Solid						; if so, use cycle colour

		move.w	(RDE_VortexCycle).l,d4

		move.w	#$0E00,d5
		moveq	#$00,d6
		moveq	#3-1,d7

	.NextGrade:
		move.w	d1,d0
		and.w	d5,d0
		move.w	d2,d3
		and.w	d5,d3
		sub.w	d3,d0
		muls.w	d4,d0
		lsr.l	#$08,d0
		add.w	d3,d0
		and.w	d5,d0
		or.w	d0,d6
		lsr.w	#$04,d5
		dbf	d7,.NextGrade
		move.w	d6,d1

	.Solid:
		move.w	(RDE_PaletteCur+$60).w,d4			; load backdrop colour
		lea	(RDE_PaletteCur+$42).w,a1			; load palette
		moveq	#$06,d0						; load vortex position wrapped within the palette mask
		and.b	(RDE_VortexPos).l,d0				; ''
		move.w	DE_PaletteMask(pc,d0.w),d0			; load correct mask list
		add.w	d0,d0						; check first bit

	.Next:
		bcc.s	.BG						; if slot is BG, branch
		move.w	d1,(a1)+					; set vortex colour
		add.w	d0,d0						; check next bit
		bne.s	.Next						; if there are still bits, continue processing
		rts							; return

	.BG:
		move.w	d4,(a1)+					; set BG colour
		add.w	d0,d0						; check next bit
		bne.s	.Next						; if there are still bits, continue processing
		rts							; return

		; --- Palette cycle slot mask ---------
		; 1-F = colour slot in palette (0 = BG | 1 = vortex colour)
		; M = end maker MUST be 1 to ensure reg isn't 0 until it's shifted out
		;
		;	%123456789ABCDEFM
		; -------------------------------------

DE_PaletteMask:	dc.w	%0011001100110011
		dc.w	%0101010101010101
		dc.w	%0000000011111111
		dc.w	%0000111100001111

		; --- Vortex colour cycling list ---

DE_CycleList:	dc.w	$070F,$070F,$061F,$052F,$043F,$043F,$034F,$025F,$016F,$016F,$007F,$008F,$009E,$009E,$00AD,$00BC
		dc.w	$00CB,$00CB,$00DA,$00E9,$00F8,$00F8,$00F7,$01F6,$02F5,$02F5,$03F4,$04F3,$05F2,$05F2,$06F1,$07F0
		dc.w	$08F0,$08F0,$09E0,$0AD0,$0BC0,$0BC0,$0CB0,$0DA0,$0E90,$0E90,$0F80,$0F70,$0F61,$0F61,$0F52,$0F43
		dc.w	$0F34,$0F34,$0F25,$0F16,$0F07,$0F07,$0F08,$0E09,$0D0A,$0D0A,$0C0B,$0B0C,$0A0D,$0A0D,$090E,$080F
DE_CycleList_End:

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to position the V/H-scroll positions for the devil plane
; ---------------------------------------------------------------------------

DE_DevilPosition:
		lea	(RDE_HScrollFG+$1C0).w,a4			; load FG H-scroll buffer
		move.w	(RDE_PosX).l,d0					; load X position

		move.w	(RDE_Width).l,d1				; load map width
		move.w	d1,d2						; make a copy for full width
		add.w	d2,d2						; ''
		add.w	d0,d1						; adjust for left side
		addi.w	#320,d2						; adjust for right side
		tst.b	(RDE_HOffScreen).l				; is the boss forced off-screen by V-scroll?
		bne.s	.OffScreen					; if so, force off-screen (saved CPU time)
		cmp.w	d2,d1						; is the devil on-screen?
		blo.s	.OnScreen					; if so, continue

	.OffScreen:
		move.w	d2,d0						; force it permanently off-screen

	.OnScreen:
		move.w	d0,(RDE_BossHScroll).l				; store for V-blank
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Old version that floods the H-scroll buffer with the same value for DMA
; later.  It turns out a manual transfer of the same word was quicker, so
; this is no longer needed...
; ---------------------------------------------------------------------------
; Subroutine to mass flood a H-scroll buffer with a value
; WARNING, registers d0 to a4 used!
; --- input -----------------------------------------------------------------
; d0.w = value to flood
; a4.l = H-scroll table buffer to flood
; ---------------------------------------------------------------------------

DE_FloodHScroll:
		move.w	d0,d1						; copy to both words of register
		swap	d0						; ''
		move.w	d1,d0						; ''

		move.l	d0,d1						; flood registers
		move.l	d0,d2
		move.l	d0,d3
		move.l	d0,d4
		move.l	d0,d5
		move.l	d0,d6
		move.l	d0,d7
		move.l	d0,a0
		lea	(a0),a1
		lea	(a0),a2
		lea	(a0),a3

	rept	9
		movem.l	d0-a3,-(a4)					; force H-scroll table to position
	endr
		movem.l	d0-d3,-(a4)					; '' (last bit)
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to control vertical scaling
; ---------------------------------------------------------------------------

	rept	224
		move.w	d0,(a1)+		; 8			; force scanline to blank
		subq.w	#$01,d0			; 4			; keep on blank scanline
	; Even though the long-word version is quicker by 4, the setup
	; in the routine itself took long enough that it had no effect...
	;	move.l	d0,(a1)+		; 12
	;	sub.l	d6,d0			; 8
	endr
DEDS_Blank:
		rts							; return

	rept	224
		move.w	d0,(a1)+					; write scanline
		add.w	d3,d1						; advance fractions
		addx.w	d2,d0						; advance quotients
	endr
DEDS_ScaleV:
		rts							; return

DE_DevilScaleV:
		sf.b	(RDE_HOffScreen).l				; clear H-scroll off-screen force flag

		lea	(RDE_ScaleVPrev).l,a4				; load previous Y pos and Y scale
		lea	(RDE_VScrollB).w,a1				; load buffer B
		tst.b	(RDE_VScrollSlot).l				; are we showing buffer A right now?
		bne.s	.ShowA						; if so, continue with B
		lea	(RDE_VScrollA).w,a1				; load buffer A instead as B is being shown
		addq.w	#$04,a4						; advance to A's previous Y pos and scale

	.ShowA:
		move.l	(RDE_ScaleY_CAP).l,d0				; prepare Y scaling
		addi.l	#$00010000,d0					; convert for division/multiplication 0 = x1, 1 = x2, 2 = x3, etc...
		asr.l	#$08,d0						; align quotient down with fraction in bottom half of word (for mulu and divu)

		move.w	(RDE_DispY).l,d1				; load Y position
		add.w	(Screen_shaking_flag+2).w,d1			; add screenshake
		cmp.w	(a4)+,d1					; has the Y position changed since last time?
		bne.s	.Change						; if so, branch
		cmp.w	(a4),d0						; has the Y scale changed?
		bne.s	.Change						; if so, branch
		rts							; return (V-scroll is the same as last time)

	.Change:
		move.w	d1,-$02(a4)					; update as not changed
		move.w	d0,(a4)						; ''

		move.l	#$00020002,d6					; prepare sub register for blank routine
		lea	DEDS_Blank(pc),a2				; load blank routine
		lea	DEDS_ScaleV(pc),a3				; load scale routine

		; --- Calculating scale Y position ---

		mulu.w	d0,d1						; multiply by scale amount
		asl.l	#$08,d1						; divide by 100 (but in such a way the quotient is in upper word and fraction is in lower word)
		neg.l	d1						; reverse direction (V-scroll is upside down)
		move.l	d1,(RDE_AdjY).l					; store...

		; --- Calculating scale height ---

		moveq	#$00,d1						; load height
		move.w	(RDE_Height).l,d1				; ''
	;addq.w	#$04,d1						; Counter half tile (IT TECHNICALLY SHOULDN'T BE DONE LIKE THIS, BUT TIME RESTRAINTS...)
		asl.l	#$08,d1						; create fraction space
		divu.w	d0,d1						; divide by scale to get scale height of devil
		move.w	d1,(RDE_ScaleH).l				; store it for later (can be used for collision later maybe...)

		; -------------------------------
		; Working out where on the screen the
		; devil is to perform the right scrolling
		; -------------------------------

	;	move.w	(RDE_Height).l,d1				; get height
		move.w	(RDE_DispY).l,d4				; load boss position
		add.w	(Screen_shaking_flag+2).w,d4			; add screenshake
		add.w	d1,d4						; adjust for top of screen height
		add.w	d1,d1						; prepare full size height
		move.w	d1,d2						; keep a copy for later
		addi.w	#224,d1						; account for screen height
		cmp.w	d1,d4						; is the boss entirely off-screen above or below?
		blo.s	.NoBlank					; if not, continue

		; --- Blank ---
		; When the devil is entirely off-screen above or below
		; -------------

	;	moveq	#$7F,d0						; prepare blank scanline
	;	jmp	-224*4(a2)					; draw entire blank screen

		; this will force the boss off-screen using H-scroll position rather
		; than writing V-scroll lines.  The H-scroll positions need writing anyway
		; so why waste time on V-scroll if it's off-screen.

		; It probably won't make much of a difference in the long-run as it only
		; saves CPU time when the boss is off-screen, but whatever...

		st.b	(RDE_HOffScreen).l				; set to display boss off-screen using H-scroll (no point wasting CPU on V-scroll)
		rts							; return

		; --- On-screen rendering ---

	.NoBlank:
		sub.w	d2,d4						; remove height
		move.w	#224,d1						; get height of screen with devil height removed
		sub.w	d2,d1						; ''
		sub.w	d1,d4						; is the boss fully on-screen (as in, not TOUCHING the top or bottom)?
		blo.w	.Middle						; if so, full boss render
		bpl.s	.Below						; if boss is partially touching the bottom of the screen, branch

		; --- Above ---
		; When the devil is partially overflowing
		; the top of the screen
		; -------------

	.Above:
		addi.w	#224,d4						; get size of devil to draw
		move.w	d4,d5						; preserve a copy

		add.w	d5,d5						; convert to instruction size
		move.w	d5,d0						; ''
		add.w	d5,d5						; ''
		add.w	d0,d5						; ''
		neg.w	d5						; negate for jump

		move.w	(RDE_AdjY).l,d0					; load position values
		move.w	(RDE_AdjY+2).l,d1				; ''
		move.w	(RDE_ScaleY_CAP).l,d2				; load add values
		move.w	(RDE_ScaleY_CAP+2).l,d3				; ''

		jsr	(a3,d5.w)					; render devil

		move.w	#224,d1						; get remaining screen size to do
		sub.w	d4,d1						; ''
		moveq	#$7F,d0						; get scanline number (in negative as V-scroll is reversed) and add 7F to offset to blank scanline)
		sub.w	d4,d0						; ''
		add.w	d1,d1						; convert to instruction size
		add.w	d1,d1						; ''
		neg.w	d1						; negate for jump
		jmp	(a2,d1.w)					; draw entire blank screen

		; --- Middle ---
		; When the devil is in the middle of
		; the screen, with NO overflow
		; -------------

	.Middle:
		add.w	d1,d4						; get size of blank area to do before reaching the devil scanline
		move.w	#224,d5						; get remaining size
		sub.w	d4,d5						; '' last of screen from this point on
		sub.w	d2,d5						; '' remove boss size from it (not it SHOULD be the last scanlines AFTER the top and middle are rendered)
		bsr.s	.DoTopMid					; do the top blank and middle render (same as below) but then return to do the bottom part
		move.w	#-(224-$7F),d0					; get scanline number (in negative as V-scroll is reversed) and add 7F to offset to blank scanline)
		add.w	d5,d0						; ''
		add.w	d5,d5						; convert to instruction size
		add.w	d5,d5						; ''
		neg.w	d5						; negate for jump
		jmp	(a2,d5.w)					; draw entire blank screen

		; --- Below ---
		; When the devil is partially overflowing
		; the bottom of the screen
		; -------------

	.Below:
		add.w	d1,d4						; get size of blank area to do before reaching the devil scanline
		move.w	#224,d2						; get remaining size
		sub.w	d4,d2						; ''

	.DoTopMid:
		move.w	d4,d1						; convert to instruction size

		add.w	d1,d1						; ''
		add.w	d1,d1						; ''
		neg.w	d1						; negate for jump
		moveq	#$7F,d0						; prepare blank scanline
		jsr	(a2,d1.w)					; draw entire blank screen

		; ------------------------
		; tl,dr; this is the same as adding the add values to the position values
		; by x ScaleY times...  Couldn't be bothered doing the quicker equation...
		; ------------------------

	;	move.w	(RDE_AdjY).l,d0					; load position values
	;	move.w	(RDE_AdjY+2).l,d1				; ''

		move.w	(RDE_ScaleY_CAP+2).l,d1				; multiply add fraction by number of blank scanlines we've just rendered
		mulu.w	d4,d1						; ''
		move.w	(RDE_ScaleY_CAP).l,d0				; multiply add quotient by number of blank scanlines we've just rendered
		mulu.w	d4,d0						; ''
		swap	d1						; add fraction overflow to quotient
		add.w	d0,d1						; ''
		swap	d1						; ''
		add.l	(RDE_AdjY).l,d1					; advance position to correct position is WOULD have been if the calculations
		move.l	d1,d0						; '' were performed during the blank scanlines, and separate the quotient/fraction
		swap	d0						; '' to d0 and d1 correctly...

		; --------------------------

	;	move.w	#224,d2						; get remaining size
	;	sub.w	d4,d2						; ''
		add.w	d2,d2						; convert to instruction size
		move.w	d2,d4						; ''
		add.w	d4,d4						; ''
		add.w	d2,d4						; ''
		neg.w	d4						; negate for jump

		move.w	(RDE_ScaleY_CAP).l,d2				; load add values
		move.w	(RDE_ScaleY_CAP+2).l,d3				; ''
		jmp	(a3,d4.w)					; render devil

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to wait for V-blank
; ---------------------------------------------------------------------------

WaitVBlank:
		clr.l	(RDE_CyclesCount).l				; reset cycle saved count
		st.b	(V_int_routine).w				; mark 68k as ready
		move.w	#$2300,sr					; enable interrupts
	.Wait:	addi.l	#$20+$C+$A,(RDE_CyclesCount).l			; increase cycles saved
		tst.b	(V_int_routine).w				; has V-blank ran yet?
		bmi.s	.Wait						; if not, wait
		addq.w	#$01,(Level_frame_counter).w			; increase frame counter
		move.l	(RDE_CyclesCount).l,(RDE_CyclesSaved).l		; store cycles saved

		jsr	dFractalExtra					; update extra functions
		jsr	dForceMuteYM2612				; force YM2612 channels to mute when requested
		jsr	dFractalSound					; update Fractal

		lea	($C00000).l,a5					; reload VDP registers
	;	lea	$04(a5),a6					; ''

	;move.l	(RDE_CyclesSaved).l,($FFFF0000).l

		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; V-blank for pausing
; ---------------------------------------------------------------------------

VB_DevilBossPause:
		movem.l	d0-a5,-(sp)					; store register data

		pea	VB_DevilHBlank(pc)				; set last routine for V-blank
		move.l	#NullRTE,(H_int_addr).w				; disable H-blank
		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''
		move.l	#$8F028AFF,(a6)					; restore increment mode and force H-blank to null

		;sf.b	(RDE_LagOccur).l				; clear lag flag
		tst.b	(V_int_routine).w				; is the 68k ready for V-blank?
		beq.w	VB_DevilBoss.Late68k				; if not, don't transfer anything

		move.l	#$40020010,(a6)					; set VDP to VSRAM
		move.b	(RDE_VortexTimer+3).l,d0			; load vortex timer
		add.b	(RDE_VortexPos).l,d0				; fuse vortex position with it
		andi.w	#$0001,d0					; get which interlaced scanline should be shown
		add.w	(Screen_shaking_flag+2).w,d0			; add screenshake to Y position
		move.w	d0,(a5)						; save V-scroll positions

		bsr.w	VB_VortexScroll					; manage BG/vortex H-scroll
		move.w	#$8F02,(a6)					; restore increment mode

		bsr.w	VB_BossPalette

		movea.w	(Sprite_Link).w,a0				; load link address
		move.b	(a0),d0						; store link
		sf.b	(a0)						; clear link
		movem.l	d0/a0,-(sp)					; store sprite data in stack
		move.l	#$8000|(VDE_Pause/$20)|(VDE_Sprites<<$10),d6	; pattern index where pause menu sprites are
		move.l	#$40000000|vdpCommDelta(VDE_Sprites),d4		; VRAM address where sprites are
		jsr	VB_SpritesPause					; transfer sprites with pause sprites first
		movem.l	(sp)+,d0/a0					; restore sprite data
		move.b	d0,(a0)						; restore link

		jmp	ReadControllers					; obtain controller data

; ---------------------------------------------------------------------------
; V-blank for fading out
; ---------------------------------------------------------------------------

VB_DevilBossFade:
		movem.l	d0-a5,-(sp)					; store register data
		pea	VB_DevilHBlank(pc)				; set last routine for V-blank
		bra.w	VB_DevilBoss					; run normal V-blank code

; ---------------------------------------------------------------------------
; V-blank for boss frames
; ---------------------------------------------------------------------------
DE_SOURCE	macro	Source
		dc.l	((Source&$1FE)<<$F)|((Source>>9)&$FF)|$95009600
		dc.w	((Source>>$11)&$7F)|$9700
		endm
; ---------------------------------------------------------------------------

VB_DevilArt1:	DE_SOURCE	RDE_DevilArtL1
		DE_SOURCE	RDE_DevilArtR1
VB_DevilArt2:	DE_SOURCE	RDE_DevilArtL2
		DE_SOURCE	RDE_DevilArtR2

	; --- Even scanlines ---

VB_DevilBoss1:
		movem.l	d0-a5,-(sp)					; store register data
		pea	VB_DevilHBlank(pc)				; set last routine for V-blank
		bsr.w	VB_DevilBoss					; run normal V-blank code
		lea	VB_DevilArt1(pc),a0				; art list to use (DMA scanline list)
		move.l	#(((VDE_DevilArt1&$3FFF)|$4000)<<$10)|(((VDE_DevilArt1>>$E)&3)|$80),d4 ; set destination
		bra.s	VB_DevilArt					; transfer even scanline art

	; --- Odd scanlines ---

VB_DevilBoss2:
		movem.l	d0-a5,-(sp)					; store register data
		pea	VB_DevilHBlank(pc)				; set last routine for V-blank
		bsr.w	VB_DevilBoss					; run normal V-blank code
		lea	VB_DevilArt2(pc),a0				; art list to use (DMA scanline list)
		move.l	#(((VDE_DevilArt2&$3FFF)|$4000)<<$10)|(((VDE_DevilArt2>>$E)&3)|$80),d4 ; set destination
							; continue to..	; transfer odd scanline art

; ---------------------------------------------------------------------------
; Subroutine to perform the devil art transfer
; ---------------------------------------------------------------------------

VB_DevilArt:
		tst.b	(RDE_LoadSlashArt).l				; is slash art enabled instead?
		beq.s	.NoSlash					; if not, continue
		bpl.s	.SlashDone					; if slash art has already been loaded, branch
		DMA	Art_SlashDE_End-Art_SlashDE, VRAM, VDE_Slash, Art_SlashDE
		andi.b	#$7F,(RDE_LoadSlashArt).l			; set art as already loaded now

	.SlashDone:
		rts							; return

	.NoSlash:
		move.w	#$8F20,(a6)					; set auto-increment size to single tiles' worth
		move.w	d4,-(sp)					; store last destination in stack
		swap	d4						; get first destination
		move.l	#((DE_DEVILSTREAM&$1FE)<<$F)|((DE_DEVILSTREAM>>9)&$FF)|$93009400,d3 ; size of DMA (always the same for all scanline sets)
COUNT := 0
	rept	2
		move.l	(a0)+,(a6)					; set source address
		move.w	(a0)+,(a6)					; ''
	rept	4
		move.l	d3,(a6)						; set size
		move.w	d4,(a6)						; set destination
	if COUNT=7
		move.w	(sp)+,(a6)					; restore stack (last destination from 68k due to bug on old hardware)
	else
		move.w	(sp),(a6)					; (last destination from 68k due to bug on old hardware)
	endif
	if (COUNT&3)=3
		subi.w	#((4*2)*3)-2,d4					; go back to next word of first scanline
	else
		addq.w	#4*2,d4						; advance to next odd scanline
	endif
COUNT := COUNT+1
	endm
	endr
		rts							; return

; ---------------------------------------------------------------------------
; Main V-blank routines themselves
; ---------------------------------------------------------------------------

VB_DevilBoss:
		move.l	#NullRTE,(H_int_addr).w				; disable H-blank
		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''
		move.l	#$8F028AFF,(a6)					; restore increment mode and force H-blank to null

		;sf.b	(RDE_LagOccur).l				; clear lag flag
		tst.b	(V_int_routine).w				; is the 68k ready for V-blank?
		beq.w	.Late68k					; if not, don't transfer anything
		not.b	(RDE_VScrollSlot).l				; change buffer

		; Sprites

		movea.w	(Sprite_Link).w,a0				; load link address
		move.b	(a0),d0						; store link
		sf.b	(a0)						; clear link
	tst.b	(YouDiedY).w
	beq.s	.NoDeath
	movem.l	d0/a0,-(sp)					; store sprite data in stack
	move.l	#$8000|(VDE_Pause/$20)|(VDE_Sprites<<$10),d6	; pattern index where pause menu sprites are
	move.l	#$40000000|vdpCommDelta(VDE_Sprites),d4		; VRAM address where sprites are
	jsr	VB_SpritesPause					; transfer sprites with pause sprites first
	movem.l	(sp)+,d0/a0					; restore sprite data
	bra.s	.YesDeath

	.NoDeath:
		lea	(R_VDP94).w,a1					; load DMA list
		move.w	(Sprite_Size).w,d1				; load size of table
		movep.w	d1,$01(a1)					; set DMA size registers
		move.l	(a1)+,(a6)					; ''
		move.l	#(((((((RDE_Sprites)&$FFFFFF)/$02)&$FF00)<<$08)+((((RDE_Sprites)&$FFFFFF)/$02)&$FF))+$96009500),(a6)
		move.l	#((((((RDE_Sprites)&$FFFFFF)/$02)&$7F0000)+$97000000)+((VDE_Sprites)&$3FFF)|$4000),(a6)
		move.w	#((((VDE_Sprites)>>$0E)&$03)|$80),(a1)		; last DMA source from 68k RAM
		move.w	(a1),(a6)

	.YesDeath:
		move.b	d0,(a0)						; restore link


		tst.b	(RDE_LastBoostArt).l				; is it time to load charging frame art?
		beq.s	.NoCharge					; if not, skip
		sf.b	(RDE_LastBoostArt).l				; clear flag
		DMA	(Art_SonChargeE-Art_SonCharge), VRAM, VDE_SonicCharge, Art_SonCharge

	.NoCharge:

		; Sonic death limbs/flesh

		tst.b	(RDE_FleshArt).l				; has flesh art been requested to load?
		beq.s	.NoFlesh					; if not, skip
		lea	(R_VDP94).w,a0					; load DMA size registers
		move.w	(RDE_FleshSize).l,d0				; load size of flesh art
		movep.w	d0,$01(a0)					; save with register ID's
		move.l	(a0)+,(a6)					; set DMA size
		move.l	#$96009500|(((RDE_KosDump/2)&$FF00)<<8)|((RDE_KosDump/2)&$FF),(a6)	; DMA source
		move.l	#$97004000|((RDE_KosDump/2)&$7F0000)|(VDE_Sonic&$3FFF),(a6)		; DMA source and first destination
		move.w	#$0080|((VDE_Sonic>>$E)&3),(a0)			; last DMA destination from 68k RAM
		move.w	(a0),(a6)					; ''
		bra.s	.NoOtherArt					; skip missile rotation this frame

	.NoFlesh:
		; missile rotation art

		tst.b	(Update_HUD_ring_count).w			; is the HUD being updated?
		bmi.s	.NoMissileRot					; if so, skip rocket rotation THIS ONE FRAME ONLY
		bsr.w	VB_MissileArt					; rotation art update cannot run at the same time as HUD update, not fast enough...

	.NoMissileRot:

		; missile scale art

		move.w	(RDE_Missile_ScalePrev).l,d0			; load scale amount in RAM
		cmp.w	(RDE_Missile_ScaleDMA).l,d0			; has it changed since last DMA transfer?
		beq.s	.NoMissileScale					; if not, ignore arm art transfer
		move.w	d0,(RDE_Missile_ScaleDMA).l			; update changed scale amount
		DMA	$0200, VRAM, VDE_MissileSca, RDE_Missile_Pack	; transfer art

	.NoMissileScale:

		; Small arm scale art

		move.w	(RDE_ArmSml_ScalePrev).l,d0			; load scale amount in RAM
		cmp.w	(RDE_ArmSml_ScaleDMA).l,d0			; has it changed since last DMA transfer?
		beq.s	.NoArmScale					; if not, ignore arm art transfer
		move.w	d0,(RDE_ArmSml_ScaleDMA).l			; update changed scale amount
		DMA	$0380, VRAM, VDE_ArmsSmall, RDE_ArmSml_Pack	; transfer art

	.NoArmScale:

	.NoOtherArt:

	.SkipArt:
		; H-scroll

	;	move.w	#$8F04,(a6)					; set increment mode
	;	DMA	$01C0, VRAM, VDE_HScroll+0, RDE_HScrollFG	; transfer H-scroll FG
	;	DMA	$01C0, VRAM, VDE_HScroll+2, RDE_HScrollBG	; transfer H-scroll BG
	;	move.w	#$8F02,(a6)					; restore increment mode

		bsr.w	VB_BossScroll					; manage FG/boss H-scroll
		bsr.w	VB_VortexScroll					; manage BG/vortex H-scroll
		move.w	#$8F02,(a6)					; restore increment mode

		; V-scroll (BG)

		move.l	#$40020010,(a6)					; set VDP to VSRAM
		move.b	(RDE_VortexTimer+3).l,d0			; load vortex timer
		add.b	(RDE_VortexPos).l,d0				; fuse vortex position with it
		andi.w	#$0001,d0					; get which interlaced scanline should be shown
		add.w	(Screen_shaking_flag+2).w,d0			; add screenshake to Y position
		move.w	d0,(a5)						; save V-scroll positions

		; Palette

		bsr.w	VB_BossPalette

		; Last stuff

		tst.b	(RDE_FleshArt).l				; has flesh art been requested to load?
		bne.s	.NoHud						; if so, skip
		locVRAM	VDE_HUD,d0
		jsr	UpdateHUD_Indirect				; update the HUD
		jsr	Process_DMA_Queue				; run DMA queue
		lea	($C00000).l,a5					; reload VDP registers correctly
		lea	$04(a5),a6					; ''

	.NoHud:
		sf.b	(RDE_FleshArt).l				; clear flash art load flag
		jsr	ReadControllers					; obtain controller data
		move.b	(RDE_PadA_Pressed).l,d0				; store start button presses
		or.b	d0,(RDE_PausePresses).l				; ''
		rts							; return

	.Late68k:
		;st.b	(RDE_LagOccur).l				; set late has occurred
		jmp	LateControllers					; read late controls

; ---------------------------------------------------------------------------
; Subroutine to handle palette transfers correctly (minimum transfers necessary)
; ---------------------------------------------------------------------------

VB_BossPalette:
		tst.b	(RDE_FinishBoss).l				; is the boss finally defeated?
		bne.w	.Full						; if so, transfer full as it's fading to white
		tst.w	(RDE_DeathTimer).l				; has the death timer finished?
		beq.w	.Full						; if so, transfer full palette as it's fading to black
		tst.b	(RDE_IntroFinish).l				; has the intro finished?
		beq.w	.Full						; if not, do full transfer
		move.w	(RDE_SlashFade).l,d0				; load slash fading
		beq.s	.Blank						; if black, branch
		cmpi.w	#$0100,d0					; is the fade at maximum colour?
		blt.w	.SlashFade					; if not, do a proper transfer

		cmp.w	(RDE_SlashPrev).l,d0				; has full colour been set yet?
		beq.s	.VortexOnly					; if not, update the entire palette
		move.w	d0,(RDE_SlashPrev).l				; update it
		DMA	$0060, CRAM, $0020, RDE_PaletteCur+$20		; transfer palette normally (without Sonic)
		rts							; return

	.VortexOnly:
		tst.b	(RDE_DamagePal).l				; is the boss flashing?
		beq.s	.NoFlash					; if not, do vortex only
		sf.b	(RDE_DamagePal).l				; clear the flash palette update flag
		DMA	$0040, CRAM, $0020, RDE_PaletteCur+$20		; transfer vortex and boss
		rts							; return

	.NoFlash:
		DMA	$001C, CRAM, $0044, RDE_PaletteCur+$44		; transfer only the vortex line
		rts							; return

	; --- Transfering palette during fade out slash events ---

	.Blank:
		cmp.w	(RDE_SlashPrev).l,d0				; has blank already been transfered?
		bne.s	.SlashFade					; if not, branch
		rts							; return (black/blank)

	.SlashFade:
		move.w	d0,(RDE_SlashPrev).l				; update previous slash value
		DMA	$0060, CRAM, $0020, RDE_PaletteShow+$20		; transfer all lines except Sonic
		rts							; return

	; --- Full palette transfer during intro ---

	.Full:
		DMA	$0080, CRAM, $0000, RDE_PaletteCur		; transfer palette
		rts							; return

; ---------------------------------------------------------------------------
; H-blank setup routine - Old version we cannot use because of Fractal...
; ---------------------------------------------------------------------------

VB_DevilHBlank:
;	tst.b	(V_int_routine).w				; was the 68k on time?
;	bne.s	.LateLag					; if not, branch
;	move.l	#$C0600000,(a6)
;	move.w	#$0EEE,(a5)
;
;	.LateLag:
		move.l	#$8F008A00,(a6)					; set auto-increment to 0 (and set H-blank interrupt to single line)
		move.l	#$40000010,(a6)					; set VDP to VSRAM write address (FG slot)
		lea	(RDE_VScrollA).w,a6				; load buffer A's scroll list
		tst.b	(RDE_VScrollSlot).l				; change buffer
		bne.s	.ShowA						; if we're showing buffer A, branch
		lea	(RDE_VScrollB).w,a6				; load buffer B's scroll list

	.ShowA:
		move.l	#HB_ScaleY,(H_int_addr).w			; set H-blank routine to Y scale set
		movem.l	(sp)+,d0-a5					; restore register date

		move.w	(a6)+,($C00000).l	;(a5)			; write V-scroll position

		tst.b	(V_int_routine).w				; was the 68k on time?
		beq.s	.Late						; if not, branch
		sf.b	(V_int_routine).w				; set V-blank as ran (Fractal will run after "WaitVBlank")
		rte							; return

	.Late:
		move.w	(sp),-$04(sp)					; move sr back
		subq.w	#$02,sp						; write new return address to fractal running routine
		move.l	#VB_RunFractal,(sp)				; ''
		subq.w	#$02,sp						; move back to new sr
		rte							; return

VB_RunFractal:
		move.w	sr,-(sp)					; store ccr
		movem.l	d0-a5,-(sp)					; store registers
		jsr	dFractalExtra					; run fractal routines
		jsr	dForceMuteYM2612				; force YM2612 channels to mute when requested
		jsr	dFractalSound					; ''
		movem.l	(sp)+,d0-a5					; restore registers
		rtr							; restore ccr

; ---------------------------------------------------------------------------
; H-blank
; ---------------------------------------------------------------------------

HB_ScaleY:
		move.w	(a6)+,($C00000).l	;(a5)			; write V-scroll position
		rte							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	collect standard 3-button controller holds/presses
; ---------------------------------------------------------------------------

ReadControllers:

	; --- Controller A ---

		lea	($A10003).l,a1				; load control port A data address
		move.b	#%00000000,(a1)				; set TH to low
		lea	(RDE_ControlPad_A).l,a0			; load control pad A address
		move.b	(a1),d0					; load returned Start and A button bits
		move.b	#%01000000,(a1)				; set TH to high
		lsl.b	#$02,d0					; send button bits furthest to the left
		andi.b	#%11000000,d0				; clear other bits
		move.b	(a1),d1					; load returned B, C and D-pad button bits
		andi.b	#%00111111,d1				; clear other bits
		or.b	d1,d0					; fuse buttons together
		not.b	d0					; reverse button states (for XOR below)
		or.b	(RDE_PadA_Late).l,d0			; fuse late controls to it
		move.b	(a0),d1					; load currently held buttons
		eor.b	d0,d1					; disable the buttons that are already held
		move.b	d0,(a0)+				; save all held buttons
		and.b	d0,d1					; get only the newly pressed buttons
		move.b	d1,(a0)+				; save all pressed buttons
		sf.b	(RDE_PadA_Late).l			; clear late controls

	; --- Controller B ---

		addq.w	#$02,a1					; load control pad B data address
		move.b	#%00000000,(a1)				; set TH to low
		lea	(RDE_ControlPad_B).l,a0			; load control pad B address
		move.b	(a1),d0					; load returned Start and A button bits
		move.b	#%01000000,(a1)				; set TH to high
		lsl.b	#$02,d0					; send button bits furthest to the left
		andi.b	#%11000000,d0				; clear other bits
		move.b	(a1),d1					; load returned B, C and D-pad button bits
		andi.b	#%00111111,d1				; clear other bits
		or.b	d1,d0					; fuse buttons together
		not.b	d0					; reverse button states (for XOR below)
		or.b	(RDE_PadB_Late).l,d0			; fuse late controls to it
		move.b	(a0),d1					; load currently held buttons
		eor.b	d0,d1					; disable the buttons that are already held
		move.b	d0,(a0)+				; save all held buttons
		and.b	d0,d1					; get only the newly pressed buttons
		move.b	d1,(a0)+				; save all pressed buttons
		sf.b	(RDE_PadB_Late).l			; clear late controls

		rts						; return

; ---------------------------------------------------------------------------
; When the 68k is late...
; ---------------------------------------------------------------------------

LateControllers:

	; --- Controller A ---

		lea	($A10003).l,a1				; load control port A data address
		move.b	#%00000000,(a1)				; set TH to low
		lea	(RDE_PadA_Late).l,a0			; load control pad A address
		move.b	(a1),d0					; load returned Start and A button bits
		move.b	#%01000000,(a1)				; set TH to high
		lsl.b	#$02,d0					; send button bits furthest to the left
		andi.b	#%11000000,d0				; clear other bits
		move.b	(a1),d1					; load returned B, C and D-pad button bits
		andi.b	#%00111111,d1				; clear other bits
		or.b	d1,d0					; fuse buttons together
		not.b	d0					; reverse button states
		or.b	d0,(a0)					; fuse with currently pressed buttons

	; --- Controller B ---

		addq.w	#$02,a1					; load control pad B data address
		move.b	#%00000000,(a1)				; set TH to low
		addq.w	#$01,a0					; load control pad B address
		move.b	(a1),d0					; load returned Start and A button bits
		move.b	#%01000000,(a1)				; set TH to high
		lsl.b	#$02,d0					; send button bits furthest to the left
		andi.b	#%11000000,d0				; clear other bits
		move.b	(a1),d1					; load returned B, C and D-pad button bits
		andi.b	#%00111111,d1				; clear other bits
		or.b	d1,d0					; fuse buttons together
		not.b	d0					; reverse button states
 		or.b	d0,(a0)					; fuse with currently pressed buttons

		rts						; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle H-scroll transfer for boss FG position
; ---------------------------------------------------------------------------
; This is ever so slightly quicker to manually transfer the word than it is
; to write to a buffer and DMA it.
; ---------------------------------------------------------------------------

VB_BossScroll:
		move.w	(RDE_BossHScroll).l,d0				; load H-scroll position
		cmp.w	(RDE_PrevHScroll).l,d0				; has it changed?
		bne.s	.Write						; if not, skip
		rts							; return

	.Write:
		move.w	#$8F04,(a6)					; set to skip a word
		move.w	d0,(RDE_PrevHScroll).l				; update previous flag
		move.l	#((((VDE_HScroll)&$3FFF)|$4000)<<$10)|((VDE_HScroll)>>$E),(a6)
		move.w	d0,d1						; save on both words of the register
		swap	d0						; ''
		move.w	d1,d0						; ''

	rept	$1C0/4
		move.l	d0,(a5)						; transfer positions to FG
	endm
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to transfer missile art
; ---------------------------------------------------------------------------

VB_MissileArt:
		move.l	#$40200000|VDE_Missile,d2			; prepare DMA VRAM write address
		lea	(RDE_MissArt).l,a1				; load missile art request list
		moveq	#3-1,d7						; number of objects to run
;	moveq	#$00,d7
;	moveq	#$03,d0
;	and.b	(RDE_VortexTimer+3).l,d0
;	subq.b	#$01,d0
;	bpl.s	.NoFlip
;	neg.b	d0
;
;	.NoFlip:
;	add.w	d0,d0
;	move.b	d0,-(sp)
;	add.w	d0,d0
;	adda.w	d0,a1
;	move.w	(sp)+,d0
;	sf.b	d0
;	add.w	d0,d2
		move.l	#$00FF0000,d0					; prepare RAM source
		lea	(R_VDP97).w,a2					; prepare DMA register set
		move.b	#$01,$07(a2)					; set size to $200 bytes
		sf.b	$09(a2)						; ''

	.NextSlot:
		move.w	(a1)+,d0					; load art request
		cmp.w	(a1)+,d0					; has it changed?
		beq.s	.NoUpdate					; if not, branch
		move.w	d0,-$02(a1)					; update address
		move.l	d0,d1						; preserve RAM source
		lsr.l	#$01,d1						; divide in half for word write
		movep.l	d1,-$01(a2)					; save source with DMA registers
		move.l	(a2)+,(a6)					; write source
		move.w	(a2)+,(a6)					; ''
		move.l	(a2)+,(a6)					; write size
		move.l	d2,d1						; align address for VDP port
		rol.l	#$02,d1						; ''
		ror.w	#$02,d1						; ''
		move.w	d1,(a6)						; write first word
		swap	d1						; write second word from 68k RAM
		move.w	d1,(a2)						; ''
		move.w	(a2),(a6)					; ''
		lea	(R_VDP97).w,a2					; prepare DMA register set

	.NoUpdate:
		addi.w	#$0200,d2					; advance to next slot
		dbf	d7,.NextSlot					; repeat for all 3 missiles
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle H-scroll transfer for BG/vortex correctly
; ---------------------------------------------------------------------------

;VB_VortexScroll:
	rts
		move.w	#$8F04,(a6)					; set to skip FG lines
		move.l	#(((((VDE_HScroll+2)+(000*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(000*2))>>$E),(a6) ; set VDP write address


		moveq	#$00,d0						; clear d2
		move.b	(RDE_VortexTimer+3).l,d0			; load timer for wave rotation
		add.w	d0,d0						; convert to word
		lea	(DE_WaveBG).l,a0				; load BG wave
		lea	(a0,d0.w),a0					; advance to correct starting angle

		move.w	#-384,d0					; set position for frames 0 to 7
		btst.b	#$03,(RDE_VortexPos).l				; are we showing frames 0 to 7?
		beq.s	.NoSect						; if so, branch
		move.w	#320,d0						; set position for frames 8 to F

	.NoSect: 
		swap	d0						; send to upper word
		bsr.s	.Transfer
		move.w	(a0)+,(a5)

	.Transfer:

	rept	224/4
		move.w	(a0)+,d0					; load sinewave
		move.l	d0,(a5)						; save to VRAM
	endm
		rts							; return





OLDER:

		move.w	#$8F08,(a6)					; set to skip FG lines

		moveq	#$00,d0						; clear d2
		move.b	(RDE_VortexTimer+3).l,d0			; load timer for wave rotation
		add.w	d0,d0						; convert to word
		lea	(DE_WaveBG).l,a0				; load BG wave
		lea	(a0,d0.w),a0					; advance to correct starting angle

		lea	(DE_VortexH_0_7).l,a2				; load H-scroll list for frames 0 to 7
		btst.b	#$03,(RDE_VortexPos).l				; are we showing frames 0 to 7?
		beq.s	.NoSect						; if so, branch
		lea	(DE_VortexH_8_F).l,a2				; load H-scroll list for frames 8 to F

	.NoSect:
		btst.b	#$00,(RDE_VortexTimer+3).l			; are we on an odd frame?
		bne.s	.OddFrame					; if not, do even lines
		exg.l	a0,a2						; do wave first

	.OddFrame:
		move.l	#(((((VDE_HScroll+2)+(000*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(000*2))>>$E),(a6) ; set VDP write address
		bsr.s	.Transfer
		move.l	#(((((VDE_HScroll+6)+(000*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+6)+(000*2))>>$E),(a6) ; set VDP write address
		exg.l	a0,a2
		bsr.s	.Transfer

		rts

	.Transfer:
		rept	224/16
		move.l	(a0)+,(a5)
		endm
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle H-scroll transfer for BG/vortex correctly OLD
; ---------------------------------------------------------------------------

VB_VortexList:	dc.l	(((((VDE_HScroll+2)+(000*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(000*2))>>$E)|$80
		dc.l	(((((VDE_HScroll+6)+(000*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(000*2))>>$E)|$80
	dc.l	(((((VDE_HScroll+2)+(112*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(112*2))>>$E)|$80
	dc.l	(((((VDE_HScroll+6)+(112*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(112*2))>>$E)|$80
		dc.l	(((((VDE_HScroll+2)+(224*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(224*2))>>$E)|$80
		dc.l	(((((VDE_HScroll+6)+(224*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(224*2))>>$E)|$80
	dc.l	(((((VDE_HScroll+2)+(336*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(336*2))>>$E)|$80
	dc.l	(((((VDE_HScroll+6)+(336*2))&$3FFF)|$4000)<<$10)|(((VDE_HScroll+2)+(336*2))>>$E)|$80

VB_VortexScroll:
		move.w	#$8F08,(a6)					; set to skip a FG and a BG line
		lea	(R_VDP97).w,a0					; load VDP DMA register list
	;	move.l	#$94009338,$06(a0)				; setup size registers (all four transfers are the same size)
	move.l	#$9400931C,$06(a0)				; setup size registers (all four transfers are the same size)

		moveq	#$00,d2						; clear d2
		move.b	(RDE_VortexTimer+3).l,d2			; load timer for wave rotation
	move.l	d2,d4
		addi.l	#DE_WaveBG>>1,d2				; add starting wave address
	addi.l	#DE_WaveBG2>>1,d4				; add starting wave address

		move.l	#(DE_VortexH_0_7>>1),d3				; load H-scroll list for frames 0 to 7
		btst.b	#$03,(RDE_VortexPos).l				; are we showing frames 0 to 7?
		beq.s	.NoSect						; if so, branch
		move.l	#(DE_VortexH_8_F>>1),d3				; load H-scroll list for frames 8 to F
		
	.NoSect:
	move.l	d3,d5


		btst.b	#$00,(RDE_VortexTimer+3).l			; are we on an odd frame?
		bne.s	.OddFrame					; if not, do even lines
		exg.l	d2,d3						; do wave first
	exg.l	d4,d5

	.OddFrame:
		lea	VB_VortexList(pc),a2				; load H-scroll DMA destination list
	;	moveq	#224/4,d1					; rotate source address forwards (wave needs to continue)
	moveq	#224/8,d1					; rotate source address forwards (wave needs to continue)
	add.l	d1,d4
	add.l	d1,d5
	add.w	d1,d1

		; The interlacing is swapped mid-screen which is why 

		move.l	d2,d0						; transfer vortex/BG scanlines
		bsr.s	.Transfer					; ''
		move.l	d3,d0						; transfer BG/vortex scanlines
		bsr.s	.Transfer					; ''
	move.l	d4,d0						; transfer BG/vortex scanlines
	bsr.s	.Transfer					; ''
	move.l	d5,d0						; transfer vortex/BG scanlines
	bsr.s	.Transfer					; ''


		add.l	d1,d2						; '' (need to do it to both as we don't know which one is the BG wave...
		add.l	d1,d3						; '' ...and which one is the vortex).  The vortex list has overflow data just in-case.
	add.l	d1,d4						; '' (need to do it to both as we don't know which one is the BG wave...
	add.l	d1,d5						; '' ...and which one is the vortex).  The vortex list has overflow data just in-case.
	move.l	d5,d0						; transfer BG/vortex scanlines
	bsr.s	.Transfer					; ''
	move.l	d4,d0						; transfer vortex/BG scanlines
	bsr.s	.Transfer					; ''
		move.l	d3,d0						; transfer BG/vortex scanlines
		bsr.s	.Transfer					; ''
		move.l	d2,d0						; transfer vortex/BG scanlines

	.Transfer:

	; a0 = VDP DMA list
	; d0 = source address
	; a2 = destination long-word

		lea	(a0),a1
		movep.l	d0,-$01(a1)					; setup source address
		move.l	(a1)+,(a6)					; set source
		move.w	(a1)+,(a6)					; ''
		move.l	(a1)+,(a6)					; set size
		move.w	(a2)+,(a6)					; set first destination
		move.w	(a2)+,(a6)					; set last destination
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to control horizontal scaling
; --- input -----------------------------------------------------------------
; a2.l = Scanline list
; a3.l = Left buffer
; a4.l = Right buffer
; ---------------------------------------------------------------------------

DE_DevilScaleH:
		cmpi.w	#$0100,(RDE_SlashFade).l			; is the slash fading at maximum brightness?
		bge.s	.NoSlash					; if so, continue normally

	.Finish:
		rts							; return (no animation/scaling)

	.NoSlash:
	;tst.b	(RDE_LagOccur).l				; is the game lagging?
	;bne.s	.Finish						; if so, no render...
		move.l	(RDE_AniArt).l,a1				; load art frame address

		move.l	(RDE_ScaleX_CAP).l,d4				; load quotient of X scale
		lsr.l	#$08,d4						; ''
		andi.l	#$00007FFC,d4					; ''
		move.l	d4,d1						; keep a copy for art routine reference

		lsr.w	#$01,d4						; load multiply version of division
		lea	DEDS_DivToMul(pc),a0				; ''
		move.w	(a0,d4.w),d4					; ''
		lea	DEDS_MulToID(pc),a0				; load multiply index ID of multiplication
		move.b	(a0,d4.w),d4					; ''

		lea	(DEDS_SH_List).l,a0				; load correct art routine
		adda.l	(a0,d1.l),a0					; ''

		moveq	#$00,d2						; keep upper byte clear
		lea	.Start(pc),a5					; load starting routine

	.Start:
		move.w	(a2)+,d1					; load size
		beq.s	.Finish						; if there are no more lines left, branch
		adda.w	(a2)+,a1					; advance to starting art address

		move.b	d1,d2						; keep a copy of actual size
		move.b	d4,d1						; multiply by scale
		move.b	DEDS_MulSwap(pc,d1.w),d1			; ''

		sub.b	d1,d2						; get difference from actual size
		beq.s	.NoClear					; if no clear size, branch

		; d2 = length to clear | d1 = length to render | d1 + d2 = full length

		; --- Skip/Clear ---

		moveq	#$03,d3						; load individual 3 bytes to clear later
		and.b	d2,d3						; ''
		sub.b	d3,d2						; get bulk 4 byte skip count
		beq.s	.NoBulkClear					; if there are no bulk bytes to skip/clear, ignore this part

		subq.b	#$04,d2						; remove a bulk (as it's getting cleared and shouldn't be counted in the skip)
		ble.s	.NoSkip						; if there's none to skip, branch
		lsr.b	#$01,d2						; align bulk 4 to 2 (each buffer is 2 bytes (total 4))
		adda.w	d2,a3						; skip bulk parts to point just before the art scale itself
		adda.w	d2,a4						; ''

	.NoSkip:
		clr.w	(a3)+						; clear a bulk (just in-case there is no 3 byte clear, don't want uncleared pixels behind)
		clr.w	(a4)+						; ''

	.NoBulkClear:
		subq.b	#$01,d3		; 4				; is 1 byte needed clearing?
		bcs.s	.NoClear	; 8 10				; if not, skip
		sf.b	(a3)+		; 12				; clear first bulk byte
		ble.s	.NoClear	; 8 10				; if 2 bytes are not needed clearing, skip
		sf.b	(a3)+		; 12				; clear second bulk byte
		subq.b	#$01,d3		; 4				; are 3 bytes needed clearing?
		ble.s	.NoClear	; 8 10				; if not, skip
		sf.b	(a4)+		; 12				; clear third bulk byte

	.NoClear:

		; --- Render ---

		ext.w	d1		; 4				; clear upper byte (will never be above $50 because (320/2 = $A0 / 8 * 4 = $50))
		neg.w	d1		; 4				; reverse for jump list
		add.b	d1,d1		; 4				; multiply by x4 (size of move index instruction)
		add.b	d1,d1		; 4				; ''
		jmp	(a0,d1.w)	; 14				; run correct routine

	; --- Mul ID x Art Range = swap list ---

DEDS_MulSwap:	binclude "Data\Phase 2\Devil Eggman\MulToID\MulSwap.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to perform Z position to X and Y conversion for objects
; ---------------------------------------------------------------------------

DE_ConvertZ:
		move.w	SO_PointZ(a0),d1				; load actual Z position
		andi.w	#$7FFC,d1					; keep in range of scale table
		lsr.w	#$01,d1						; align for table
		move.w	DEDS_DivToMul(pc,d1.w),d2			; load div conversion word

		move.w	SO_PointX(a0),d0				; load actual X position
		subi.w	#320/2,d0					; get relative from centre of screen
		muls.w	d2,d0						; divide by Z position
		asr.l	#$08,d0						; ''
		addi.w	#320/2,d0					; restore centre screen
		move.w	d0,SO_PosX(a0)					; save as display X position

		move.w	SO_PointY(a0),d0				; load actual Y position
		subi.w	#224/2,d0					; get relative from centre of screen
		muls.w	d2,d0						; divide by Z position
		asr.l	#$08,d0						; ''
		addi.w	#224/2,d0					; restore centre screen
		move.w	d0,SO_PosY(a0)					; save as display Y position
		rts

; ---------------------------------------------------------------------------
; Multiplication table with the inverse values to division
; ---------------------------------------------------------------------------
; Missing bytes from list:
; 01 8B 91 95 98 9B 9E A1 A4 A6 A9 AB AD AF B1 B3 B5 B7 B9 BB BD BF
; C1 C2 C4 C6 C8 C9 CB CD CE D0 D1 D3 D5 D6 D8 D9 DB DC DE DF E1 E2
; E4 E5 E7 E8 E9 EB EC EE EF F1 F2 F3 F5 F6 F7 F9 FA FB FD FE FF
; ---------------------------------------------------------------------------

DEDS_DivToMul:	binclude "Data\Phase 2\Devil Eggman\MulToID\DivToMul.bin"

; ---------------------------------------------------------------------------
; Mul to ID list (converts Mulu value to byte ID so the multiplication can
; be referenced from a word table
; ---------------------------------------------------------------------------
; Missing bytes from DivToMul list:
; 01 8B 91 95 98 9B 9E A1 A4 A6 A9 AB AD AF B1 B3 B5 B7 B9 BB BD BF
; C1 C2 C4 C6 C8 C9 CB CD CE D0 D1 D3 D5 D6 D8 D9 DB DC DE DF E1 E2
; E4 E5 E7 E8 E9 EB EC EE EF F1 F2 F3 F5 F6 F7 F9 FA FB FD FE FF
;
; Thus... we'll shift $02 to $100 down to $01 to $FF so it fits in a byte range.
;
; The main loopup table for multiplication will be XXYY where XX or YY would be
; an ID from the below table, and the other will be the width of the render range.
;
; The Mul to ID table can only ommit $41 values out of $100 (listed above) leaving $BF total.
;
; Render will only be 320/2 = $A0 / 8 * 4 = $50 total.
;
; Render is smaller, so it's better to have render as the XX byte so the table will
; at MOST be up to $50FF, rather than ID as XX up to $BFFF.
; ---------------------------------------------------------------------------

DEDS_MulToID:	binclude "Data\Phase 2\Devil Eggman\MulToID\MulToID.bin"

; ---------------------------------------------------------------------------
; H-scroll BG vortex animation positions
; ---------------------------------------------------------------------------

		align	$8000	; DMA alignment (should be good)

	; --- H-scroll positions for frames 0 to 7 ---

DE_VortexH_0_7:
	rept	224/2
		dc.w	-384
	endr

	; --- H-scroll positions for frames 8 to F ---

DE_VortexH_8_F:
	rept	224/2
		dc.w	320
	endr

DE_WaveBG:	dc.w	$FF00>>5,$FF06>>5,$FF0C>>5,$FF12>>5,$FF19>>5,$FF1F>>5,$FF25>>5,$FF2B>>5,$FF31>>5,$FF38>>5,$FF3E>>5,$FF44>>5,$FF4A>>5,$FF50>>5,$FF56>>5,$FF5C>>5
		dc.w	$FF61>>5,$FF67>>5,$FF6D>>5,$FF73>>5,$FF78>>5,$FF7E>>5,$FF83>>5,$FF88>>5,$FF8E>>5,$FF93>>5,$FF98>>5,$FF9D>>5,$FFA2>>5,$FFA7>>5,$FFAB>>5,$FFB0>>5
		dc.w	$FFB5>>5,$FFB9>>5,$FFBD>>5,$FFC1>>5,$FFC5>>5,$FFC9>>5,$FFCD>>5,$FFD1>>5,$FFD4>>5,$FFD8>>5,$FFDB>>5,$FFDE>>5,$FFE1>>5,$FFE4>>5,$FFE7>>5,$FFEA>>5
		dc.w	$FFEC>>5,$FFEE>>5,$FFF1>>5,$FFF3>>5,$FFF4>>5,$FFF6>>5,$FFF8>>5,$FFF9>>5,$FFFB>>5,$FFFC>>5,$FFFD>>5,$FFFE>>5,$FFFE>>5,$FFFF>>5,$FFFF>>5,$FFFF>>5
		dc.w	$0000>>5,$FFFF>>5,$FFFF>>5,$FFFF>>5,$FFFE>>5,$FFFE>>5,$FFFD>>5,$FFFC>>5,$FFFB>>5,$FFF9>>5,$FFF8>>5,$FFF6>>5,$FFF4>>5,$FFF3>>5,$FFF1>>5,$FFEE>>5
		dc.w	$FFEC>>5,$FFEA>>5,$FFE7>>5,$FFE4>>5,$FFE1>>5,$FFDE>>5,$FFDB>>5,$FFD8>>5,$FFD4>>5,$FFD1>>5,$FFCD>>5,$FFC9>>5,$FFC5>>5,$FFC1>>5,$FFBD>>5,$FFB9>>5
		dc.w	$FFB5>>5,$FFB0>>5,$FFAB>>5,$FFA7>>5,$FFA2>>5,$FF9D>>5,$FF98>>5,$FF93>>5,$FF8E>>5,$FF88>>5,$FF83>>5,$FF7E>>5,$FF78>>5,$FF73>>5,$FF6D>>5,$FF67>>5
		dc.w	$FF61>>5,$FF5C>>5,$FF56>>5,$FF50>>5,$FF4A>>5,$FF44>>5,$FF3E>>5,$FF38>>5,$FF31>>5,$FF2B>>5,$FF25>>5,$FF1F>>5,$FF19>>5,$FF12>>5,$FF0C>>5,$FF06>>5

		dc.w	$FF00>>5,$FEFA>>5,$FEF4>>5,$FEEE>>5,$FEE7>>5,$FEE1>>5,$FEDB>>5,$FED5>>5,$FECF>>5,$FEC8>>5,$FEC2>>5,$FEBC>>5,$FEB6>>5,$FEB0>>5,$FEAA>>5,$FEA4>>5
		dc.w	$FE9F>>5,$FE99>>5,$FE93>>5,$FE8B>>5,$FE88>>5,$FE82>>5,$FE7D>>5,$FE78>>5,$FE72>>5,$FE6D>>5,$FE68>>5,$FE63>>5,$FE5E>>5,$FE59>>5,$FE55>>5,$FE50>>5
		dc.w	$FE4B>>5,$FE47>>5,$FE43>>5,$FE3F>>5,$FE3B>>5,$FE37>>5,$FE33>>5,$FE2F>>5,$FE2C>>5,$FE28>>5,$FE25>>5,$FE22>>5,$FE1F>>5,$FE1C>>5,$FE19>>5,$FE16>>5
		dc.w	$FE14>>5,$FE12>>5,$FE0F>>5,$FE0D>>5,$FE0C>>5,$FE0A>>5,$FE08>>5,$FE07>>5,$FE05>>5,$FE04>>5,$FE03>>5,$FE02>>5,$FE02>>5,$FE01>>5,$FE01>>5,$FE01>>5
		dc.w	$FE00>>5,$FE01>>5,$FE01>>5,$FE01>>5,$FE02>>5,$FE02>>5,$FE03>>5,$FE04>>5,$FE05>>5,$FE07>>5,$FE08>>5,$FE0A>>5,$FE0C>>5,$FE0D>>5,$FE0F>>5,$FE12>>5
		dc.w	$FE14>>5,$FE16>>5,$FE19>>5,$FE1C>>5,$FE1F>>5,$FE22>>5,$FE25>>5,$FE28>>5,$FE2C>>5,$FE2F>>5,$FE33>>5,$FE37>>5,$FE3B>>5,$FE3F>>5,$FE43>>5,$FE47>>5
		dc.w	$FE4B>>5,$FE50>>5,$FE55>>5,$FE59>>5,$FE5E>>5,$FE63>>5,$FE68>>5,$FE6D>>5,$FE72>>5,$FE78>>5,$FE7D>>5,$FE82>>5,$FE88>>5,$FE8B>>5,$FE93>>5,$FE99>>5
		dc.w	$FE9F>>5,$FEA4>>5,$FEAA>>5,$FEB0>>5,$FEB6>>5,$FEBC>>5,$FEC2>>5,$FEC8>>5,$FECF>>5,$FED5>>5,$FEDB>>5,$FEE1>>5,$FEE7>>5,$FEEE>>5,$FEF4>>5,$FEFA>>5

		dc.w	$FF00>>5,$FF06>>5,$FF0C>>5,$FF12>>5,$FF19>>5,$FF1F>>5,$FF25>>5,$FF2B>>5,$FF31>>5,$FF38>>5,$FF3E>>5,$FF44>>5,$FF4A>>5,$FF50>>5,$FF56>>5,$FF5C>>5
		dc.w	$FF61>>5,$FF67>>5,$FF6D>>5,$FF73>>5,$FF78>>5,$FF7E>>5,$FF83>>5,$FF88>>5,$FF8E>>5,$FF93>>5,$FF98>>5,$FF9D>>5,$FFA2>>5,$FFA7>>5,$FFAB>>5,$FFB0>>5
		dc.w	$FFB5>>5,$FFB9>>5,$FFBD>>5,$FFC1>>5,$FFC5>>5,$FFC9>>5,$FFCD>>5,$FFD1>>5,$FFD4>>5,$FFD8>>5,$FFDB>>5,$FFDE>>5,$FFE1>>5,$FFE4>>5,$FFE7>>5,$FFEA>>5
		dc.w	$FFEC>>5,$FFEE>>5,$FFF1>>5,$FFF3>>5,$FFF4>>5,$FFF6>>5,$FFF8>>5,$FFF9>>5,$FFFB>>5,$FFFC>>5,$FFFD>>5,$FFFE>>5,$FFFE>>5,$FFFF>>5,$FFFF>>5,$FFFF>>5
		dc.w	$0000>>5,$FFFF>>5,$FFFF>>5,$FFFF>>5,$FFFE>>5,$FFFE>>5,$FFFD>>5,$FFFC>>5,$FFFB>>5,$FFF9>>5,$FFF8>>5,$FFF6>>5,$FFF4>>5,$FFF3>>5,$FFF1>>5,$FFEE>>5
		dc.w	$FFEC>>5,$FFEA>>5,$FFE7>>5,$FFE4>>5,$FFE1>>5,$FFDE>>5,$FFDB>>5,$FFD8>>5,$FFD4>>5,$FFD1>>5,$FFCD>>5,$FFC9>>5,$FFC5>>5,$FFC1>>5,$FFBD>>5,$FFB9>>5
		dc.w	$FFB5>>5,$FFB0>>5,$FFAB>>5,$FFA7>>5,$FFA2>>5,$FF9D>>5,$FF98>>5,$FF93>>5,$FF8E>>5,$FF88>>5,$FF83>>5,$FF7E>>5,$FF78>>5,$FF73>>5,$FF6D>>5,$FF67>>5
		dc.w	$FF61>>5,$FF5C>>5,$FF56>>5,$FF50>>5,$FF4A>>5,$FF44>>5,$FF3E>>5,$FF38>>5,$FF31>>5,$FF2B>>5,$FF25>>5,$FF1F>>5,$FF19>>5,$FF12>>5,$FF0C>>5,$FF06>>5

DE_WaveBG2:	dc.w	($FFF00+$100)>>7,($FFF06+$100)>>7,($FFF0C+$100)>>7,($FFF12+$100)>>7,($FFF19+$100)>>7,($FFF1F+$100)>>7,($FFF25+$100)>>7,($FFF2B+$100)>>7,($FFF31+$100)>>7,($FFF38+$100)>>7,($FFF3E+$100)>>7,($FFF44+$100)>>7,($FFF4A+$100)>>7,($FFF50+$100)>>7,($FFF56+$100)>>7,($FFF5C+$100)>>7
		dc.w	($FFF61+$100)>>7,($FFF67+$100)>>7,($FFF6D+$100)>>7,($FFF73+$100)>>7,($FFF78+$100)>>7,($FFF7E+$100)>>7,($FFF83+$100)>>7,($FFF88+$100)>>7,($FFF8E+$100)>>7,($FFF93+$100)>>7,($FFF98+$100)>>7,($FFF9D+$100)>>7,($FFFA2+$100)>>7,($FFFA7+$100)>>7,($FFFAB+$100)>>7,($FFFB0+$100)>>7
		dc.w	($FFFB5+$100)>>7,($FFFB9+$100)>>7,($FFFBD+$100)>>7,($FFFC1+$100)>>7,($FFFC5+$100)>>7,($FFFC9+$100)>>7,($FFFCD+$100)>>7,($FFFD1+$100)>>7,($FFFD4+$100)>>7,($FFFD8+$100)>>7,($FFFDB+$100)>>7,($FFFDE+$100)>>7,($FFFE1+$100)>>7,($FFFE4+$100)>>7,($FFFE7+$100)>>7,($FFFEA+$100)>>7
		dc.w	($FFFEC+$100)>>7,($FFFEE+$100)>>7,($FFFF1+$100)>>7,($FFFF3+$100)>>7,($FFFF4+$100)>>7,($FFFF6+$100)>>7,($FFFF8+$100)>>7,($FFFF9+$100)>>7,($FFFFB+$100)>>7,($FFFFC+$100)>>7,($FFFFD+$100)>>7,($FFFFE+$100)>>7,($FFFFE+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7
		dc.w	($00000+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7,($FFFFE+$100)>>7,($FFFFE+$100)>>7,($FFFFD+$100)>>7,($FFFFC+$100)>>7,($FFFFB+$100)>>7,($FFFF9+$100)>>7,($FFFF8+$100)>>7,($FFFF6+$100)>>7,($FFFF4+$100)>>7,($FFFF3+$100)>>7,($FFFF1+$100)>>7,($FFFEE+$100)>>7
		dc.w	($FFFEC+$100)>>7,($FFFEA+$100)>>7,($FFFE7+$100)>>7,($FFFE4+$100)>>7,($FFFE1+$100)>>7,($FFFDE+$100)>>7,($FFFDB+$100)>>7,($FFFD8+$100)>>7,($FFFD4+$100)>>7,($FFFD1+$100)>>7,($FFFCD+$100)>>7,($FFFC9+$100)>>7,($FFFC5+$100)>>7,($FFFC1+$100)>>7,($FFFBD+$100)>>7,($FFFB9+$100)>>7
		dc.w	($FFFB5+$100)>>7,($FFFB0+$100)>>7,($FFFAB+$100)>>7,($FFFA7+$100)>>7,($FFFA2+$100)>>7,($FFF9D+$100)>>7,($FFF98+$100)>>7,($FFF93+$100)>>7,($FFF8E+$100)>>7,($FFF88+$100)>>7,($FFF83+$100)>>7,($FFF7E+$100)>>7,($FFF78+$100)>>7,($FFF73+$100)>>7,($FFF6D+$100)>>7,($FFF67+$100)>>7
		dc.w	($FFF61+$100)>>7,($FFF5C+$100)>>7,($FFF56+$100)>>7,($FFF50+$100)>>7,($FFF4A+$100)>>7,($FFF44+$100)>>7,($FFF3E+$100)>>7,($FFF38+$100)>>7,($FFF31+$100)>>7,($FFF2B+$100)>>7,($FFF25+$100)>>7,($FFF1F+$100)>>7,($FFF19+$100)>>7,($FFF12+$100)>>7,($FFF0C+$100)>>7,($FFF06+$100)>>7

		dc.w	($FFF00+$100)>>7,($FFEFA+$100)>>7,($FFEF4+$100)>>7,($FFEEE+$100)>>7,($FFEE7+$100)>>7,($FFEE1+$100)>>7,($FFEDB+$100)>>7,($FFED5+$100)>>7,($FFECF+$100)>>7,($FFEC8+$100)>>7,($FFEC2+$100)>>7,($FFEBC+$100)>>7,($FFEB6+$100)>>7,($FFEB0+$100)>>7,($FFEAA+$100)>>7,($FFEA4+$100)>>7
		dc.w	($FFE9F+$100)>>7,($FFE99+$100)>>7,($FFE93+$100)>>7,($FFE8B+$100)>>7,($FFE88+$100)>>7,($FFE82+$100)>>7,($FFE7D+$100)>>7,($FFE78+$100)>>7,($FFE72+$100)>>7,($FFE6D+$100)>>7,($FFE68+$100)>>7,($FFE63+$100)>>7,($FFE5E+$100)>>7,($FFE59+$100)>>7,($FFE55+$100)>>7,($FFE50+$100)>>7
		dc.w	($FFE4B+$100)>>7,($FFE47+$100)>>7,($FFE43+$100)>>7,($FFE3F+$100)>>7,($FFE3B+$100)>>7,($FFE37+$100)>>7,($FFE33+$100)>>7,($FFE2F+$100)>>7,($FFE2C+$100)>>7,($FFE28+$100)>>7,($FFE25+$100)>>7,($FFE22+$100)>>7,($FFE1F+$100)>>7,($FFE1C+$100)>>7,($FFE19+$100)>>7,($FFE16+$100)>>7
		dc.w	($FFE14+$100)>>7,($FFE12+$100)>>7,($FFE0F+$100)>>7,($FFE0D+$100)>>7,($FFE0C+$100)>>7,($FFE0A+$100)>>7,($FFE08+$100)>>7,($FFE07+$100)>>7,($FFE05+$100)>>7,($FFE04+$100)>>7,($FFE03+$100)>>7,($FFE02+$100)>>7,($FFE02+$100)>>7,($FFE01+$100)>>7,($FFE01+$100)>>7,($FFE01+$100)>>7
		dc.w	($FFE00+$100)>>7,($FFE01+$100)>>7,($FFE01+$100)>>7,($FFE01+$100)>>7,($FFE02+$100)>>7,($FFE02+$100)>>7,($FFE03+$100)>>7,($FFE04+$100)>>7,($FFE05+$100)>>7,($FFE07+$100)>>7,($FFE08+$100)>>7,($FFE0A+$100)>>7,($FFE0C+$100)>>7,($FFE0D+$100)>>7,($FFE0F+$100)>>7,($FFE12+$100)>>7
		dc.w	($FFE14+$100)>>7,($FFE16+$100)>>7,($FFE19+$100)>>7,($FFE1C+$100)>>7,($FFE1F+$100)>>7,($FFE22+$100)>>7,($FFE25+$100)>>7,($FFE28+$100)>>7,($FFE2C+$100)>>7,($FFE2F+$100)>>7,($FFE33+$100)>>7,($FFE37+$100)>>7,($FFE3B+$100)>>7,($FFE3F+$100)>>7,($FFE43+$100)>>7,($FFE47+$100)>>7
		dc.w	($FFE4B+$100)>>7,($FFE50+$100)>>7,($FFE55+$100)>>7,($FFE59+$100)>>7,($FFE5E+$100)>>7,($FFE63+$100)>>7,($FFE68+$100)>>7,($FFE6D+$100)>>7,($FFE72+$100)>>7,($FFE78+$100)>>7,($FFE7D+$100)>>7,($FFE82+$100)>>7,($FFE88+$100)>>7,($FFE8B+$100)>>7,($FFE93+$100)>>7,($FFE99+$100)>>7
		dc.w	($FFE9F+$100)>>7,($FFEA4+$100)>>7,($FFEAA+$100)>>7,($FFEB0+$100)>>7,($FFEB6+$100)>>7,($FFEBC+$100)>>7,($FFEC2+$100)>>7,($FFEC8+$100)>>7,($FFECF+$100)>>7,($FFED5+$100)>>7,($FFEDB+$100)>>7,($FFEE1+$100)>>7,($FFEE7+$100)>>7,($FFEEE+$100)>>7,($FFEF4+$100)>>7,($FFEFA+$100)>>7

		dc.w	($FFF00+$100)>>7,($FFF06+$100)>>7,($FFF0C+$100)>>7,($FFF12+$100)>>7,($FFF19+$100)>>7,($FFF1F+$100)>>7,($FFF25+$100)>>7,($FFF2B+$100)>>7,($FFF31+$100)>>7,($FFF38+$100)>>7,($FFF3E+$100)>>7,($FFF44+$100)>>7,($FFF4A+$100)>>7,($FFF50+$100)>>7,($FFF56+$100)>>7,($FFF5C+$100)>>7
		dc.w	($FFF61+$100)>>7,($FFF67+$100)>>7,($FFF6D+$100)>>7,($FFF73+$100)>>7,($FFF78+$100)>>7,($FFF7E+$100)>>7,($FFF83+$100)>>7,($FFF88+$100)>>7,($FFF8E+$100)>>7,($FFF93+$100)>>7,($FFF98+$100)>>7,($FFF9D+$100)>>7,($FFFA2+$100)>>7,($FFFA7+$100)>>7,($FFFAB+$100)>>7,($FFFB0+$100)>>7
		dc.w	($FFFB5+$100)>>7,($FFFB9+$100)>>7,($FFFBD+$100)>>7,($FFFC1+$100)>>7,($FFFC5+$100)>>7,($FFFC9+$100)>>7,($FFFCD+$100)>>7,($FFFD1+$100)>>7,($FFFD4+$100)>>7,($FFFD8+$100)>>7,($FFFDB+$100)>>7,($FFFDE+$100)>>7,($FFFE1+$100)>>7,($FFFE4+$100)>>7,($FFFE7+$100)>>7,($FFFEA+$100)>>7
		dc.w	($FFFEC+$100)>>7,($FFFEE+$100)>>7,($FFFF1+$100)>>7,($FFFF3+$100)>>7,($FFFF4+$100)>>7,($FFFF6+$100)>>7,($FFFF8+$100)>>7,($FFFF9+$100)>>7,($FFFFB+$100)>>7,($FFFFC+$100)>>7,($FFFFD+$100)>>7,($FFFFE+$100)>>7,($FFFFE+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7
		dc.w	($00000+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7,($FFFFF+$100)>>7,($FFFFE+$100)>>7,($FFFFE+$100)>>7,($FFFFD+$100)>>7,($FFFFC+$100)>>7,($FFFFB+$100)>>7,($FFFF9+$100)>>7,($FFFF8+$100)>>7,($FFFF6+$100)>>7,($FFFF4+$100)>>7,($FFFF3+$100)>>7,($FFFF1+$100)>>7,($FFFEE+$100)>>7
		dc.w	($FFFEC+$100)>>7,($FFFEA+$100)>>7,($FFFE7+$100)>>7,($FFFE4+$100)>>7,($FFFE1+$100)>>7,($FFFDE+$100)>>7,($FFFDB+$100)>>7,($FFFD8+$100)>>7,($FFFD4+$100)>>7,($FFFD1+$100)>>7,($FFFCD+$100)>>7,($FFFC9+$100)>>7,($FFFC5+$100)>>7,($FFFC1+$100)>>7,($FFFBD+$100)>>7,($FFFB9+$100)>>7
		dc.w	($FFFB5+$100)>>7,($FFFB0+$100)>>7,($FFFAB+$100)>>7,($FFFA7+$100)>>7,($FFFA2+$100)>>7,($FFF9D+$100)>>7,($FFF98+$100)>>7,($FFF93+$100)>>7,($FFF8E+$100)>>7,($FFF88+$100)>>7,($FFF83+$100)>>7,($FFF7E+$100)>>7,($FFF78+$100)>>7,($FFF73+$100)>>7,($FFF6D+$100)>>7,($FFF67+$100)>>7
		dc.w	($FFF61+$100)>>7,($FFF5C+$100)>>7,($FFF56+$100)>>7,($FFF50+$100)>>7,($FFF4A+$100)>>7,($FFF44+$100)>>7,($FFF3E+$100)>>7,($FFF38+$100)>>7,($FFF31+$100)>>7,($FFF2B+$100)>>7,($FFF25+$100)>>7,($FFF1F+$100)>>7,($FFF19+$100)>>7,($FFF12+$100)>>7,($FFF0C+$100)>>7,($FFF06+$100)>>7


; ---------------------------------------------------------------------------
; H-scale routines
; ---------------------------------------------------------------------------

DEDS_SH_List:	binclude "Data\Phase 2\Devil Eggman\Include\_ScaleH.bin"

; ===========================================================================
; ---------------------------------------------------------------------------
; Included data
; ---------------------------------------------------------------------------

Pal_Vortex:	binclude "Data\Phase 2\Vortex BG\Palette.bin"
Pal_Vortex_End:	even
Art_Vortex:	binclude "Data\Phase 2\Vortex BG\Plane 00 Art.art"
Art_Vortex_End:	even
Map_Vortex:	binclude "Data\Phase 2\Vortex BG\Plane 00 Map.map"
Map_Vortex_End:	even

Art_SonLay:	binclude "Data\Phase 2\Sonic\Art.kos"
		even
Map_SonLay:	binclude "Data\Phase 2\Sonic\Map.bin"
		even
Art_SonRoll:	binclude "Data\Phase 2\Sonic\Rolling\Art.kos"
		even
Map_SonRoll:	binclude "Data\Phase 2\Sonic\Rolling\Map.bin"
		even
Art_SonCharge:	binclude "Data\Phase 2\Sonic\Charging\Art.unc"
Art_SonChargeE:	even
Map_SonCharge:	binclude "Data\Phase 2\Sonic\Charging\Map.bin"
		even
Art_MissileDE:	binclude "Data\Phase 2\Missiles\Art.kos"
		even
Art_EyesDE:	binclude "Data\Phase 2\Devil Eggman\_Eyes Art.kos"
		even

Art_ArmsBigDE:	binclude "Data\Phase 2\Arms Big\Art.kos"
		even
Map_ArmsBigDE:	binclude "Data\Phase 2\Arms Big\Map.bin"
		even

Art_ArmsSmlDE:	binclude "Data\Phase 2\Arms Small\Art.kos"
		even
Map_ArmsSmlDE:	binclude "Data\Phase 2\Arms Small\Map.bin"
		even

Art_EnergyDE:	binclude "Data\Phase 2\Energy Balls\Art.kos"
		even
Map_EnergyDE:	binclude "Data\Phase 2\Energy Balls\Map.bin"
		even

Art_HitDE:	binclude "Data\Phase 2\Hit Sign\Art.kos"
		even
Map_HitDE:	binclude "Data\Phase 2\Hit Sign\Map.bin"
		even

Art_SlashDE:	binclude "Data\Phase 2\Slash\Art.unc"
Art_SlashDE_End	even
Map_SlashDE:	binclude "Data\Phase 2\Slash\Map.bin"
		even

Art_ExplodeDE:	binclude "Data\Phase 2\Explosion\Art.kos"
		even
Map_ExplodeDE:	binclude "Data\Phase 2\Explosion\Map.bin"
		even

Pal_DevEgg:	binclude "Data\Phase 2\Devil Eggman\Include\Output\_Palette.bin"
Pal_DevEgg_End:	even
LineData1:	binclude "Data\Phase 2\Devil Eggman\Include\Output\_Line Info 1.bin"
LineData2:	binclude "Data\Phase 2\Devil Eggman\Include\Output\_Line Info 2.bin"
Map_DevEgg:	binclude "Data\Phase 2\Devil Eggman\Include\Output\_Map Data.eni"
		even

Art_DevEggA00:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 00.bin"
Art_DevEggA01:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 01.bin"
Art_DevEggA02:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 02.bin"
Art_DevEggA03:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 03.bin"
Art_DevEggA04:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 04.bin"
Art_DevEggA05:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 05.bin"
Art_DevEggA06:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 06.bin"
Art_DevEggA07:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 07.bin"
Art_DevEggA08:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 08.bin"
Art_DevEggA09:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 09.bin"
Art_DevEggA10:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 10.bin"
Art_DevEggA11:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art Arms 11.bin"
Art_DevEggN00:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 00.bin"
Art_DevEggN01:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 01.bin"
Art_DevEggN02:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 02.bin"
Art_DevEggN03:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 03.bin"
Art_DevEggN04:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 04.bin"
Art_DevEggN05:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 05.bin"
Art_DevEggN06:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 06.bin"
Art_DevEggN07:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 07.bin"
Art_DevEggN08:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 08.bin"
Art_DevEggN09:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 09.bin"
Art_DevEggN10:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 10.bin"
Art_DevEggN11:	binclude "Data\Phase 2\Devil Eggman\Include\Output\Art No Arms 11.bin"

; ===========================================================================
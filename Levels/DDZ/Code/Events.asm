; ===========================================================================
; ---------------------------------------------------------------------------
; Special events routine for DDZ boss
; ---------------------------------------------------------------------------

DDZ_SetupEvent:
	;st.b	(SwapPlanes).w
	;st.b	(SwapVScroll).w
	;st.b	(SwapHScroll).w
		move.l	#DDZ_CameraPos,(RDD_Event).l			; set next event routine
		samp	sfx_RainPCM					; request wind to play

DDZ_CameraPos:
		move.w	#DDZ_BOSS_CENTRE_X-(320/2),(Camera_max_X_pos).w	; lock right boundary
		cmp.w	#DDZ_BOSS_CENTRE_X-(320/2),(Camera_X_pos).w	; has the camera reached the boss area?
		bcc.s	.Reached					; if so, branch
		moveq	#$00,d0						; make yellow eyes be black temporarily
		move.l	d0,(Normal_palette+$52).w			; ''

	.WaitIntro:
		rts							; return

	.Reached:
		move.w	#DDZ_BOSS_CENTRE_X-(320/2),(Camera_min_X_pos).w	; lock left boundary

		; --- Drawing right side ---
		; The arena is a plane wide, the camera doesn't reach
		; the right side, so we render the last bit manually
		; here, so no level drawing is needed during the boss.
		; --------------------------

		jsr	(InitFGCam).w					; get BG parameters at proper registers
		moveq	#((64)/16)-1,d7					; width to draw
		move.w	(a3),d4						; get xpos
		move.w	4(a3),d5					; get ypos
		addi.w	#320,d4						; move right to render last few columns
		subi.w	#$10,d5						; begin drawing from 1 row to up
		jsr	(RedrawPMap_Full.loop).w			; (1 cam) refresh plane (full)

		; --------------------------

		move.w	#60*1,(RDD_Timer).l				; set to wait 1 second
		move.l	#DDZ_WaitIntro,(RDD_Event).l			; set next event routine

DDZ_WaitIntro:
		subq.w	#$01,(RDD_Timer).l				; decrease timer
		bcc.s	DDZ_CameraPos.WaitIntro				; wait for the intro

		st.b	(RDD_NoLevelDraw).l				; stop the level from being able to be drawn

	; --- Dialog cut-scene ---


		tst.b	(FirstRun).w					; is this the first run?
		bne.s	.FirstRun					; if so, skip
		move.l	#DDZ_DialogWait,(RDD_Event).l			; set next event routine
		bra.w	DDZ_DialogWait

	.FirstRun:
		move.w	#$002F,(RDD_EggIntro_YDest).l			; set new Y destination for the cover
		move.l	#DDZ_BossIntro,(RDD_Event).l			; set next event routine

DDZ_BossIntro:
		st.b	(Ctrl_1_locked).w				; lock controls
		lea	(Player_1).w,a1					; load Sonic object
		btst.b	#Status_InAir,obStatus(a1)			; is Sonic in the air?
		beq.s	.SonicFloor					; if not, branch
		rts							; return (wait for Sonic to land)

	.SonicFloor:
		clr.w	obVelX(a1)					; stop X speed
		clr.w	obInertia(a1)					; ''
		bclr.b	#Status_Facing,obStatus(a1)			; make Sonic face right
		move.w	obX(a1),d0					; load X position
		subi.w	#DDZ_BOSS_CENTRE_X,d0				; get distance from centre
		bmi.s	.FaceRight					; if Sonic is to the left, branch
		bset.b	#Status_Facing,obStatus(a1)			; make Sonic face left

	.FaceRight:
		move.w	#$0101,(Ctrl_1_logical).w			; force controls to hold up

		move.w	(RDD_EggIntro_YPos).l,d0			; load cover Y position
		cmp.w	(RDD_EggIntro_YDest).l,d0			; has it opened yet?
		beq.s	.LoadDialog					; if so, load dialog
		rts							; return

	.LoadDialog:
		st.b	(NoPause_flag).w
		st.b	(Level_end_flag).w				; move HUD off
		jsr	(Create_New_Sprite).w				; load a free object slot
		bne.s	.NoSlot						; if there's no slot, skip (see no reason not to be)
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_DDZStart,routine(a1)
		move.l	#DialogDDZStart_Process_Index-4,$34(a1)
		move.b	#(DialogDDZStart_Process_Index_End-DialogDDZStart_Process_Index)/8,$39(a1)

	.NoSlot:
		lea	(ArtKosM_BlackStretch).l,a1			; load art for boarder
		move.w	#tiles_to_bytes($580),d2			; VRAM address of boarder
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue
		jsr	Load_BlackStretch				; load boarder object

		move.l	#DDZ_DialogWait,(RDD_Event).l			; set next event routine

	; --- Waiting for dialog to finish ---

DDZ_DialogWait:
		tst.b	(Level_end_flag).w				; has dialog finished?
		bpl.s	.DialogFinish					; if so, continue
		rts							; return (no change)

	.DialogFinish:
		clr.w	(RDD_EggIntro_YDest).l				; move cover up
		tst.w	(RDD_EggIntro_YPos).l				; has cover closed yet?
		beq.s	.ScalePentagram					; if so, do pentagram next
		rts							; return

	.ScalePentagram:
		move.w	(RDD_PentScale).l,d0				; load scale
		subi.w	#$0010,d0					; has it reached smallest point?
		blo.s	.BreakCandles					; if so, branch
		bne.s	.NoSFX						; if we've not just reached flashing, skip SFX
		sfx	SDD_Flash					; play flashing SFX

	.NoSFX:
		subq.w	#$01,(RDD_PentScale).l				; decrease scale
		addi.w	#$0010,(RDD_PentSpeed).l			; increase speed

	; --- Palette flash ---

		cmpi.w	#$0010,d0					; is it time to flash the palettes yet?
		bgt.s	.NoFlash					; if not, branch
		st.b	(RDD_PentCycDisable).l				; disable cycling now
		st.b	d4						; set instant delay speed
		bra.w	DDZ_Flash					; perform flashing

	.NoFlash:
		rts							; return

	; --- Setting up candle breaking ---

	.BreakCandles:
		sf.b	(RDD_EggIntroShow).l				; hide the intro eggman sprites
		clr.w	(RDD_PentSpeed).l				; set no rotation of the pentagram
		sf.b	(RDD_PentShow).l				; hide the pentagram

		move.w	#VDD_WormBodyArt,d0				; VRAM address where art is
		moveq	#$03,d1						; width of sprite
		moveq	#$04,d2						; height of sprite
		move.w	#$6000|(VDD_WormBodyArt/$20),d4	; save to self	; VRAM address to save rotated art to
		moveq	#$04,d7			; Must be power of 2!	; angle rate (speed of advancing the angle around)
		lea	(RDD_PreRot_Unpack).l,a1			; ram address to unpack to
		lea	(RDD_PreRot_Pack).l,a3				; ram address to rotate and pack to
		lea	(RDD_PreRot_Mappings).l,a4			; ram address to dump the sprite mappings
		jsr	PreRotate					; unpack and prerotate art from VRAM

		; --- Clearing plane ---
		; There appears to be an issue where the plane ends up with
		; map data in it from another level sometimes, I think it's
		; the draw code.  This simply clears the entire B plane so
		; those graphics don't show up.
		;
		; Done inbetween kos queue setup for efficiency, and then
		; the boss's head mappings are loaded.
		; ----------------------

		move.w	sr,-(sp)					; store sr in the stack
		move.w	#$2700,sr					; disable interrupts
		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		moveq	#$00,d0						; clear d0
		move.l	#$8F019780,(a6)					; set increment mode and DMA mode
		move.l	#$940F93FF,(a6)					; set DMA size (size of plane)
		move.l	#$96009500,(a6)					; set DMA source (null for fill)
		move.l	#$60000083,(a6)					; set DMA destination
		move.w	d0,-4(a6)					; set DMA fille value

		lea	(ArtKosM_WormHead).l,a1				; load art for worm head
		move.w	#VDD_WormHeadArt,d2				; VRAM address of worm
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue
		lea	(ArtKosM_FlyDDZ).l,a1				; load art for fly object
		move.w	#VDD_FlyArt,d2					; VRAM address for fly
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue
		lea	(ArtKosM_Missiles).l,a1				; load art for missiles
		move.w	#VDD_MissileArt,d2				; VRAM address for missile
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue
		lea	(ArtKosM_DEZExplosion).l,a1			; load flame explosion art
		move.w	#VDD_FlameExpArt,d2				; VRAM address for flame explosion art
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue

		move.w	(a6),ccr					; load status
		bvs.s	*-$02						; if the VDP DMA busy flag was set (bit 1), branch to wait til finished...
		move.w	#$8F02,(a6)					; set VDP increment mode back to normal

		lea	(ArtUnc_BossAim).l,a1				; load arrow assistence art
		move.w	#VDD_ArrowAim,d2				; VRAM address for arrow assistence
		move.w	#((ArtUnc_BossAim_End-ArtUnc_BossAim)/$20)-1,d3 ; size of art to load
		jsr	(RDD_LoadUncArt).l				; load uncompressed art to VRAM

		bsr.w	DDZ_LoadWormHead				; load the worm head mappings to plane
		move.w	(sp)+,sr					; restore sr

		; ----------------------

		addq.b	#$01,(RDD_Phase).l				; advance to next phase
		music	mus_Hellfire, 0

		move.w	#DDZ_BOSS_CENTRE_X,(RDD_Worm+WmPosX).l		; set worm head starting X position
		move.w	(Camera_Y_pos).w,d0				; load Y position
		addi.w	#(224/2)-$13,d0					; align to correct starting position
		move.w	d0,(RDD_Worm+WmPosY).l				; set worm head starting Y position
		move.l	(RDD_Worm+WmPosX).l,(RDD_Worm+WmDispX).l	; set display/collision position
		move.l	(RDD_Worm+WmPosY).l,(RDD_Worm+WmDispY).l	; ''

		st.b	(RDD_Worm+WmShow).l				; enable the worm
		st.b	(RDD_SliceVScroll).l				; enable V-scroll sliced mode for the plane
		ori.b	#%10000000,(Player_1+art_tile).w		; force Sonic to high plane

		lea	(RDD_CandlePos).l,a1				; load candle positions
		lea	(RDD_CandleSpeed).l,a2				; load speeds address
		move.l	#DDZ_BOSS_CENTRE_X+$80,d1			; get X position where the pentagram is supposed to show
		sub.w	(Camera_X_pos).w,d1				; minus camera's X position
		swap	d1						; send to quotient area
		move.l	#(((224/2)-$20)+$80)<<$10,d2			; prepare central Y position
		moveq	#$05-1,d3					; number of candles to do

	.NextCandle:
		move.l	(a1)+,d0					; get Y position
		sub.l	d2,d0						; get relative from centre
		asr.l	#$02,d0						; slow it down
		move.l	d0,(a2)+					; save as speed
		move.l	(a1)+,d0					; get X position
		sub.l	d1,d0						; get relative from centre
		asr.l	#$02,d0						; slow it down
		move.l	d0,(a2)+					; save as speed
		dbf	d3,.NextCandle					; repeat for all candles

		move.l	#.WaitLight,(RDD_Event).l			; set next event routine
		; Need to give V-blank and subroutines a frame to render
		; before changing the palette...

		rts							; return

	.WaitLight:
		lea	(Normal_palette).w,a1				; load normal palette
		lea	(Target_palette).w,a0				; load original palette for Sonic's line
		moveq	#($10/2)-1,d1					; size of Sonic's line

	.LoadPalSonic:
		move.l	(a0)+,(a1)+					; restore Sonic's palette
		dbf	d1,.LoadPalSonic				; repeat til done

		lea	(Pal_DDZ_Light).l,a2				; load lighter level palette now
		moveq	#($30/2)-1,d1					; size of level palette

	.LoadPalBright:
		move.l	(a2)+,d0					; load colours
		move.l	d0,(a1)+					; save to current line
		move.l	d0,(a0)+					; save to target too (for restoration)
		dbf	d1,.LoadPalBright				; repeat for all colours in the light palette

		lea	(Target_palette+$60).w,a0			; load line to brighten
		lea	(RDD_BossColours.Flash).l,a1			; load storage location for brighter colours
		bsr.w	DDZ_BrightPalette				; make brighter palette colours
		lea	(Target_palette+$60).w,a0			; load line to brighten
		lea	(RDD_BossColours.Shadow).l,a1			; load storage location for brighter colours
		bsr.w	DDZ_DarkPalette					; make brighter palette colours

		bclr.b	#$07,(RDD_CandlesShow).l			; set candles to use line 3 and set as high plane now that the brighter palette is loaded

		jsr	DDZ_SetupWormBody				; setup worm body objects

		move.l	#DDZ_BreakCandles,(RDD_Event).l			; set next event routine

	; --- Candles breaking and flying away ---

DDZ_BreakCandles:
		jsr	DDZ_RunWormBody					; run the worm body objects

		not.b	(RDD_Timer).l					; delay arena size expansion by a frame each time
		bmi.s	.ArenaReady					; ''
		move.w	(Camera_min_X_pos).w,d0				; load left camera boundary
		cmpi.w	#DDZ_BOSS_CENTRE_X-(512/2),d0			; has the arena opened up enough yet?
		ble.s	.ArenaReady					; if so, branch
		subq.w	#$01,d0						; decrease left boundary
		move.w	d0,(Camera_min_X_pos).w				; ''
		addq.w	#$01,(Camera_max_X_pos).w			; increase right boundary

	.ArenaReady:
		lea	(RDD_CandlePos).l,a1				; load candle positions
		lea	(RDD_CandleSpeed).l,a2				; load speeds address
		moveq	#$05-1,d3					; number of candles to do
		moveq	#$05-1,d2					; ''

	.NextCandle:
		move.l	(a2),d0						; get Y speed
		add.l	(a1),d0						; add position to it
		cmpi.l	#(224+$80+$20)<<$10,d0				; has it dropped below the floor?
		blt.s	.InRange					; if not, branch
		move.l	#(224+$80+$20)<<$10,d0				; force to below the floor
		move.l	#-$00003800,(a2)				; set no speed
		dbf	d2,.InRange					; decrease count
		sf.b	(RDD_CandlesShow).l				; hide the candles
		move.l	#DDZ_Phase1,(RDD_Event).l			; set next event routine
		bra.w	DDZ_Phase1					; go to routine

	.InRange:
		addi.l	#$00003800,(a2)+				; increase speed
		move.l	d0,(a1)+					; save Y position
		move.l	(a2)+,d0					; get X speed
		add.l	d0,(a1)+					; add to position
		dbf	d3,.NextCandle					; repeat for all candles
		rts							; return

	; --- Loading the worm head mappings ---

DDZ_LoadWormHead:
		move.w	sr,-(sp)					; store status register
		move.w	#$2700,sr					; disable interrupts
		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		move.w	#$E000|(VDD_WormHeadArt/$20),d4			; prepare base index
		move.l	#$60000003+(DDZ_WORM_PLANEPOS<<$10),d5		; prepare VRAM plane address of boss worm head mappings
		moveq	#$00,d3						; load width of worm
		lea	(Map_WormHead).l,a1				; load worm head mappings
		move.b	(a1)+,d3					; ''
		addq.w	#$01,a1						; skip height (it's height of full set, not just the head)
		move.w	#(DDZ_WORM_HEIGHT/8)-1,d2			; load height of worm

	.NextY:
		move.w	d3,d1						; reload width
		move.l	d5,(a6)						; set VDP write address
		addi.l	#$00800000,d5					; advance to next row

	.NextX:
		move.w	(a1)+,d0					; load tile index
		add.w	d4,d0						; add base index
		move.w	d0,(a5)						; save to VRAM
		dbf	d1,.NextX					; repeat for all columns
		dbf	d2,.NextY					; repeat for all rows
		move.w	(sp)+,sr					; restore status register
		rts							; return

; Map_WormHead:
; file is included in "Levels\DDZ\Code\V-Blank.asm" source file

; ---------------------------------------------------------------------------
; Phase 1
; ---------------------------------------------------------------------------

DDZ_Phase1:
		jsr	DDZ_RunWormHead					; move the head
		jsr	DDZ_RunWormBody					; move the body pieces
		jsr	DDZ_RunLaserCollision				; allow laser to have collision with Sonic
		jsr	DDZ_RunMissileCollision				; allow missiles to have collision with Sonic
		cmpi.b	#$FE,(RDD_Worm+WmHeadMode).l			; is the worm defeated?
		bgt.w	.NoFinish					; if not, loop

		subq.w	#$01,(RDD_ExplodeTimer).l			; decrease explode timer
		bpl.w	.NoFinish					; if not finished, branch
		clr.w	(RDD_ExplodeTimer).l				; keep at 0
		lea	(Player_1).w,a1					; load Sonic's RAM space
		btst.b	#Status_InAir,obStatus(a1)			; is Sonic in the air?
		bne.w	.NoFinish					; if so, wait...
		lea	(RDD_Worm).l,a0					; load worm head RAM space
		tst.b	(Ctrl_1_locked).w				; have the controls been locked yet?
		bne.w	.Locked						; if so, continue
		clr.w	obVelX(a1)					; clear X and Y speeds
		clr.w	obVelY(a1)					; ''
		clr.w	obInertia(a1)					; ''
		st.b	(Ctrl_1_locked).w				; lock controls
		clr.w	(Ctrl_1_logical).w				; force no controls
		bset	#0,object_control(a1)				; force Sonic to lock
		bclr.b	#Status_Facing,obStatus(a1)			; make Sonic face right
		move.w	obX(a1),d0					; load X position
		subi.w	#DDZ_BOSS_CENTRE_X,d0				; get distance from centre
		bmi.s	.FaceRight					; if Sonic is to the left, branch
		bset.b	#Status_Facing,obStatus(a1)			; make Sonic face left

	.FaceRight:

		; Load vortex object here...

		sfx	sfx_Magic					; play vortex SFX

		movem.l	a0-a1,-(sp)					; store regs
		lea	(ArtKosM_Vortex).l,a1				; decompress vortex art
		move.w	#VDD_VortexArt,d2				; ''
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue
		movem.l	(sp)+,a0-a1					; restore regs

		move.w	#60,(RDD_FinishTimer).l				; set delay time before fading white

		lea	(SineTable+1).w,a2				; load sine table address

		move.w	#DDZ_BOSS_CENTRE_X,d1				; get X distance
		sub.w	obX(a1),d1					; ''
		move.w	#(224/2)-$20,d2					; get Y distance
		sub.w	obY(a1),d2					; ''
		bsr.s	.GetSpeed					; work out the right speed/direction
		move.w	d0,obVelX(a1)					; save speed
		move.w	d1,obVelY(a1)					; ''

		move.w	#DDZ_BOSS_CENTRE_X,d1				; get X distance
		sub.w	WmPosX(a0),d1					; ''
		move.w	#(224/2)-$20,d2					; get Y distance
		sub.w	WmPosY(a0),d2					; ''
		bsr.s	.GetSpeed					; work out the right speed/direction
		move.w	d0,WmSpeedX(a0)					; save speed
		move.w	d1,WmSpeedY(a0)					; ''

		rts							; return (directions are setup now)

	.GetSpeed:
		jsr	CalcDist					; get distance (for speed)
		move.w	d0,d5						; store it
		jsr	CalcAngle_NEW					; get angle
		subi.b	#$40,d0						; counter Sonic's team's 90 degree adjustment
		add.w	d0,d0						; align for table
		move.w	+$7F(a2,d0.w),d1				; load Y
		move.w	-$01(a2,d0.w),d0				; load X
		neg.w	d0						; reverse X (no fucking clue why right now, I'm too tired to care...)
		muls.w	d5,d0						; multiply direction by distance/speed
		muls.w	d5,d1						; ''
		asr.l	#$08,d0						; align quotient
		asr.l	#$08,d1						; ''
		rts							; return

	.Locked:

		move.b	#id_Rise,obAnim(a1)				; set Sonic's rising animation
		cmpi.b	#$45,obFrame(a1)				; has Sonic reached the floating frame?
		bne.s	.NoFloat					; if not, skip moving
		move.w	obVelY(a1),d0					; move Sonic on X
		ext.l	d0						; ''
		asl.l	#$08,d0						; ''
		add.l	d0,obY(a1)					; ''
		move.w	obVelX(a1),d0					; move Sonic on Y
		ext.l	d0						; ''
		asl.l	#$08,d0						; ''
		add.l	d0,obX(a1)					; ''

		btst.b	#$00,(Level_frame_counter+1).w			; slow the movement down in half...
		beq.s	.ArenaReady					; ...
		move.w	(Camera_min_X_pos).w,d0				; load left camera boundary
		cmpi.w	#DDZ_BOSS_CENTRE_X-(320/2),d0			; has the arena closed up enough yet?
		bgt.s	.ArenaReady					; if so, branch
		addq.w	#$01,d0						; increase left boundary
		move.w	d0,(Camera_min_X_pos).w				; ''
		subq.w	#$01,(Camera_max_X_pos).w			; decrease right boundary

	.ArenaReady:

	.NoFloat:
		moveq	#$03,d0						; check if it's been 4 frames
		and.b	(RDD_FinishTimer+1).l,d0			; ''
		bne.s	.NoShake					; if not, skip shaking
		move.b	#$10,(ScreenWobble).w				; set screen to shake

	.NoShake:
		subq.w	#$01,(RDD_FinishTimer).l			; decrease fade timer
		bcc.s	.NoFinish					; if not finished, branch
		clr.w	(RDD_FinishTimer).l				; keep fade timer finished
		moveq	#$07,d4						; set delay speed (btst against frame count0
		bsr.w	DDZ_Flash					; perform flashing
		bgt.s	.NoFinish					; if not finished, loop
		move.b	#id_DDZ_Phase2,(Game_mode).w			; set game mode to phase 2
		addq.b	#$01,(Current_zone+1).w				; increase act number

	.NoFinish:
		rts							; return

; ---------------------------------------------------------------------------
; Phase 2
; ---------------------------------------------------------------------------

	; Exists as its own game/screen mode
	; see "Levels\DDZ\Code\Phase 2.asm" for details...

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to flash a palette gradually
; ---------------------------------------------------------------------------

DDZ_Flash:
		tst.b	d4						; is the delay time instant?
		bmi.s	.Instant					; if so, continue without delay
		and.b	(Level_frame_counter+1).w,d4			; is this a delay frame?
		bne.s	.NoFade						; if so, skip a frame

	.Instant:
		lea	(Normal_palette).w,a1				; load normal palette
		moveq	#$00,d0						; clear d0
		moveq	#$40-1,d3					; number of colours
		move.w	#$40*3,d4					; reset colour fade count
		tst.w	(Seizure_Flag).w				; is seizure mode on?
		bne.s	.Dark						; if so, do dark version instead

	; Normal flashing mode

		moveq	#$0E,d1						; prepare blue and red colour check

	.NextColour:
		move.b	(a1),d0						; load blue
		cmp.b	d1,d0						; is it at maximum?
		bge.s	.MaxBlue					; if so, branch
		addq.b	#$01,d0						; increase blue
		subq.w	#$01,d4						; decrease colour count

	.MaxBlue:
		move.b	d0,(a1)+					; update blue
		move.b	(a1),d0						; load green and red
		cmpi.w	#$00E0,d0					; is green at maximum?
		bge.s	.MaxGreen					; if so, branch
		addi.b	#$10,d0						; increase green
		subq.w	#$01,d4						; decrease colour count

	.MaxGreen:
		move.b	d0,d2						; get red
		and.b	d1,d2						; ''
		cmp.b	d1,d2						; is the red at maximum?
		bge.s	.MaxRed						; if so, branch
		addq.b	#$01,d0						; increase red
		subq.w	#$01,d4						; decrease colour count

	.MaxRed:
		move.b	d0,(a1)+					; update green and red
		dbf	d3,.NextColour					; repeat for all colours
		neg.w	d4
		addi.w	#$40*3,d4
		tst.w	d4						; test on return

	.NoFade:
		rts							; return

	; Black version of fade for seizure mode

	.Dark:
		subq.b	#$01,(a1)+					; decrease blue
		bcc.s	.NoStop						; if not finished, resume
		sf.b	-$01(a1)					; keep at 0
		subq.w	#$01,d4						; decrease colour count

	.NoStop:
		move.b	(a1),d0						; load green/red
		subi.b	#$10,d0						; decrease green
		bcc.s	.NoGreen					; if not finished, continue
		addi.b	#$10,d0						; keep green at 0
		subq.w	#$01,d4						; decrease colour count

	.NoGreen:
		subq.w	#$01,d4						; decrease colour count for red
		moveq	#$0F,d1						; get red
		and.b	d0,d1						; ''
		beq.s	.NoRed						; if red is done, branch
		subq.b	#$01,d0						; reduce red
		addq.w	#$01,d4						; undo red count

	.NoRed:
		move.b	d0,(a1)+					; update green and red
		dbf	d3,.Dark					; repeat for all colours
		tst.w	d4						; test on return
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Loading uncompressed art
; --- input -----------------------------------------------------------------
; a1.l = Source art
; d2.w = VRAM address
; d3.w = number of tiles to load (minus 1 for dbf)
; a5/a6.l = VDP data and control port
; ---------------------------------------------------------------------------

RDD_LoadUncArt:
		lsl.l	#$02,d2						; align upper address bits
		addq.b	#$01,d2						; set write mode
		ror.w	#$02,d2						; align address bits
		swap	d2						; align for VDP
		andi.w	#$0003,d2					; clear rest of register
		move.l	d2,(a6)						; set VDP write mode

	.NextTile:
		rept	8
		move.l	(a1)+,(a5)					; copy tile
		endm
		dbf	d3,.NextTile					; repeat for all tiles
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Making a brighter versions of the palette
; --- input -----------------------------------------------------------------
; a0.l = Source palette line
; a1.l = Destination palette
; ---------------------------------------------------------------------------

DDZ_BrightPalette:
		bsr.s	.Bright1					; quarter way towards
		bsr.s	.Bright2					; halfway towards
		bsr.s	.Bright1					; quarter way towards
		rept	$20/4
		move.l	(a0)+,(a1)+					; copy normal colours
		endm
		rts							; return

	; --- Brightness 1 (1/4 towards E) ---

	.Bright1:
		pea	(a0)						; store source palette
		moveq	#$10-1,d2					; number of colours in a line

	.NextB1:
		moveq	#$0E,d0						; prepare maximum brightness
		sub.b	(a0),d0						; get blue difference
		lsr.b	#$02,d0						; get halfway between current and maximum
		add.b	(a0)+,d0					; ''
		move.b	d0,(a1)+					; save blue
		move.b	#$EE,d0						; prepare maximum brightness
		sub.b	(a0),d0						; get green and red difference
		lsr.b	#$02,d0						; get halfway between current and maximum
		and.b	#$33,d0						; clear overflow
		add.b	(a0)+,d0					; set actual colour
		move.b	d0,(a1)+					; save green and red
		dbf	d2,.NextB1					; repeat for all colours in the line
		move.l	(sp)+,a0					; restore source palette
		rts							; return

	; --- Brightness 2 (1/2 towards E) ---

	.Bright2:
		pea	(a0)						; store source palette
		moveq	#$10-1,d2					; number of colours in a line

	.NextB2:
		moveq	#$0E,d0						; prepare maximum brightness
		sub.b	(a0),d0						; get blue difference
		lsr.b	#$01,d0						; get halfway between current and maximum
		add.b	(a0)+,d0					; ''
		move.b	d0,(a1)+					; save blue
		move.b	#$EE,d0						; prepare maximum brightness
		sub.b	(a0),d0						; get green and red difference
		lsr.b	#$01,d0						; get halfway between current and maximum
		and.b	#$77,d0						; clear overflow
		add.b	(a0)+,d0					; set actual colour
		move.b	d0,(a1)+					; save green and red
		dbf	d2,.NextB2					; repeat for all colours in the line
		move.l	(sp)+,a0					; restore source palette
		rts							; return

; ---------------------------------------------------------------------------
; Making a drker versions of the palette
; --- input -----------------------------------------------------------------
; a0.l = Source palette line
; a1.l = Destination palette
; ---------------------------------------------------------------------------

DDZ_DarkPalette:
		bsr.s	.Dark1						; quarter way towards
		bsr.s	.Dark2						; halfway towards
		bsr.s	.Dark1						; quarter way towards
		rept	$20/4
		move.l	(a0)+,(a1)+					; copy normal colours
		endm
		rts							; return

	; --- Darkness 1 (1/4 towards 0) ---

	.Dark1:
		pea	(a0)						; store source palette
		moveq	#$10-1,d2					; number of colours in a line

	.NextD1:
		move.b	(a0)+,d0					; load blue
		move.b	d0,d1						; reduce quarter towards darkness
		lsr.b	#$02,d1						; ''
		sub.b	d1,d0						; ''
		move.b	d0,(a1)+					; save blue
		move.b	(a0)+,d0					; load green and red
		move.b	d0,d1						; reduce quarter towards dark
		lsr.b	#$02,d1						; ''
		andi.b	#$33,d1						; clear overflow
		sub.b	d1,d0						; reduce...
		move.b	d0,(a1)+					; save green and red
		dbf	d2,.NextD1					; repeat for all colours in the line
		move.l	(sp)+,a0					; restore source palette
		rts							; return

	; --- Darkness 2 (1/2 towards 0) ---

	.Dark2:
		pea	(a0)						; store source palette
		moveq	#$10-1,d2					; number of colours in a line

	.NextD2:
		move.b	(a0)+,d0					; load blue
		lsr.b	#$01,d0						; reduce halfway towards darkness
		move.b	d0,(a1)+					; save blue
		move.b	(a0)+,d0					; load green and red
		lsr.b	#$01,d0						; reduce halfway towards dark
		andi.b	#$77,d0						; clear overflow
		move.b	d0,(a1)+					; save green and red
		dbf	d2,.NextD2					; repeat for all colours in the line
		move.l	(sp)+,a0					; restore source palette
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Setting up the body pieces
; ---------------------------------------------------------------------------
DDZ_WORMBODY_DIST = $18			; distance between body pieces
; ---------------------------------------------------------------------------

DDZ_SetupWormBody:
		lea	(RDD_WormObjects).l,a0				; load object list
		moveq	#DDZ_WORMBODY_MAXSIZE-1,d7			; number of objects to run through
		move.w	(RDD_Worm+WmDispX).l,d5				; X position
		move.w	(RDD_Worm+WmDispY).l,d6				; Y position
		moveq	#DDZ_WORMBODY_DIST*2,d3				; distance between pieces

	.NextObject:
		add.w	d3,d6						; move piece down
		move.w	d5,ObjX(a0)					; save X
		move.w	d6,ObjY(a0)					; save Y
		lea	WormObj_Size(a0),a0				; advance to next slot
		dbf	d7,.NextObject					; repeat for all slots
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to run worm body objects
; ---------------------------------------------------------------------------

DDZ_RunWormBody:
		lea	(RDD_WormObjects).l,a0				; load object list
		moveq	#DDZ_WORMBODY_MAXSIZE-1,d7			; number of objects to run through
		move.w	(RDD_Worm+WmDispX).l,d5				; X position
		move.w	(RDD_Worm+WmDispY).l,d6				; Y position
		addi.w	#$0014,d6					; move down a bit
		lea	(SineTable+$01).w,a1				; load sine table

	.NextObject:
		moveq	#$00,d0						; load mode
		move.b	(RDD_Worm+WmBodyMode).l,d0			; ''
		jsr	.Modes(pc,d0.w)					; run correct mode
		bsr.w	DDZWRM_DisplayAngle				; load correct angle/frame of rotation
		move.w	ObjX(a0),d5					; load X and Y position of this object as previous for next object
		move.w	ObjY(a0),d6					; ''
		lea	WormObj_Size(a0),a0				; advance to next slot
		dbf	d7,.NextObject					; repeat for all slots
		rts							; return

; ---------------------------------------------------------------------------
; Modes
; ---------------------------------------------------------------------------

	.Modes:	bra.w	DDZWRM_Natural					; gravity, in-range, chain physics
		bra.w	DDZWRM_Fluid					; in-range

	; --- Natural mode ---

DDZWRM_Natural:
		move.w	#$0400,d2					; maximum gravity speed
		moveq	#$38,d3						; gravity
		bsr.s	DDZWRM_ConvertSpeed				; convert speed to position with gravity

		move.w	ObjX(a0),d1					; get X distance from previous piece
		sub.w	d5,d1						; ''
		move.w	ObjY(a0),d2					; get Y distance from previous piece
		sub.w	d6,d2						; ''
		jsr	CalcAngle_OLD					; get the angle
		moveq	#DDZ_WORMBODY_DIST,d3				; distance between pieces
		bsr.w	DDZWRM_KeepInRange				; keep the body piece in range
		blo.s	.InRange					; if the piece is in range, finish (no body connection physics required)
		bsr.w	DDZWRM_ChainPhysics				; run chain physics

	.InRange:

		; This handles floor collision for the body pieces if the
		; boss has been defeated, this will only affect pieces
		; which are above the floor, those that are below the
		; floor will behave normally (otherwise they'll snap up
		; to the floor).

		tst.b	(RDD_Worm+WmHeadMode).l				; has the boss been defeated?
		bpl.s	.NoDefeat					; if not, skip
		move.w	#(224/2)+$38,d1					; floor position
		move.w	ObjY(a0),d0					; load body Y position
		sub.w	d1,d0						; get distance from floor
		cmpi.w	#$0010,d0					; is the piece in the floor?
		bhi.s	.NoDefeat					; if not, continue (only if it touches the floor, but also don't want to include pieces that are deeply in the floor already)
		move.w	d1,ObjY(a0)					; force piece to the floor position itself
		tst.b	(RDD_Worm+WmSpeedX).l				; load the head's X speed and force the body pieces to go slightly...
		spl.b	d0						; '' ...in the opposite direction
		ext.w	d0						; '' (Stops the body pieces from sliding to one
		ori.w	#$01,d0						; ''  side exclusively)
		move.w	d0,SpeedX(a0)					; ''

	.NoDefeat:
		rts							; return

	; --- Fluid mode ---

DDZWRM_Fluid:
		moveq	#$00,d0
		move.l	d0,Speed(a0)

		move.w	ObjX(a0),d1					; get X distance from previous piece
		sub.w	d5,d1						; ''
		move.w	ObjY(a0),d2					; get Y distance from previous piece
		sub.w	d6,d2						; ''
		jsr	CalcAngle_NEW					; get the angle
		moveq	#$18,d3						; distance between pieces
		bra.w	DDZWRM_KeepInRange				; keep the body piece in range

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to convert speed to position with gravity
; --- input -----------------------------------------------------------------
; d2.w = maximum gravity speed
; d3.w = gravity
; ---------------------------------------------------------------------------

DDZWRM_ConvertSpeed:
		movem.w	Speed(a0),d0-d1					; load X and Y speeds
		asl.l	#$08,d0						; align speed to QQQQ.FFFF
		add.l	d0,ObjX(a0)					; change X positions
		cmp.w	d2,d1						; is Y speed at maximum gravity?
		blo.s	.NoMaxGrav					; if not, continue
		move.w	d2,d1						; cap Y speed
		move.w	d1,SpeedY(a0)					; ''

	.NoMaxGrav:
		asl.l	#$08,d1						; align speed to QQQQ.FFFF
		add.l	d1,ObjY(a0)					; change Y position
		add.w	d3,SpeedY(a0)					; increase gravity
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to setup the display angle of a body piece using the positions
; of the previous and next object positions
; ---------------------------------------------------------------------------

DDZWRM_DisplayAngle:
		tst.w	d7						; is this the last piece?
		beq.s	.NoNext						; if so, don't check for next piece

	; --- Angle from next piece ---

		move.w	WormObj_Size+ObjX(a0),d1			; get X distance from next piece
		sub.w	ObjX(a0),d1					; ''
		move.w	WormObj_Size+ObjY(a0),d2			; get Y distance from next piece
		sub.w	ObjY(a0),d2					; ''
		jsr	CalcAngle_NEW					; get arctangent angle
		addi.b	#$40,d0						; correct angle due to Sonic Team's insistence on 40 = up
		move.b	d0,d3						; store in d3

	; --- Angle from previous piece ---

	.NoNext:
	;	move.w	ObjX(a0),d1					; get X distance from previous piece
	;	sub.w	d5,d1						; ''
	;	move.w	ObjY(a0),d2					; get Y distance from previous piece
	;	sub.w	d6,d2						; ''
	;	jsr	CalcAngle_NEW					; get the angle
	;	addi.b	#$40,d0						; correct angle
	moveq	#$40,d0
	add.b	d4,d0
		tst.w	d7						; is this the last piece?
		bne.s	.YesNext					; if not, don't force next angle
		move.b	d0,d3						; force next angle to match previous

	.YesNext:

	; --- Angle to display inbetween the two ---

		sub.b	d0,d3						; get the angle inbetween the two
		asr.b	#$01,d3						; ''
		add.b	d0,d3						; ''
		subi.b	#$80,d3						; correct it for display
		neg.b	d3						; ''
		add.w	(RDD_PreRot_Mappings).l,d3			; rotate correctly based on half segment size
		move.b	d3,ObjAngleDraw(a0)				; save for display
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to detect if a body piece is out of range, and if so, to snap it
; back into range.
; --- input -----------------------------------------------------------------
; d1.w = X distance from previous piece
; d2.w = Y distance from previous piece
; d3.w = maximum distance allowed
; d0.w = angle from previous object for physics calculation later
; ---------------------------------------------------------------------------

DDZWRM_KeepInRange:
		move.w	d0,d4						; store angle for calculation later

	; WARNING; d1 and d2 must have the X and Y distance.

		jsr	CalcDist					; get distance pieces are away by
		cmp.w	d3,d0						; is the piece too far away?
		blo.s	.InRange					; if not, skip
		move.w	sr,-(sp)					; store ccr
		move.w	d4,d0						; load physics angle
		add.w	d0,d0						; multiply to size of word element
		move.w	+$7F(a1,d0.w),d1				; load sine distance
		move.w	-$01(a1,d0.w),d0				; ''
		muls.w	d3,d1						; set correct distance
		muls.w	d3,d0						; ''
		asr.l	#$08,d1						; remove $100 distance
		asr.l	#$08,d0						; ''
		add.w	d5,d1						; add centre of previous piece
		add.w	d6,d0						; ''
		move.w	d1,ObjX(a0)					; store positions
		move.w	d0,ObjY(a0)					; ''
		rtr							; return and restore ccr

	.InRange:
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to perform physics on a body piece as if it were a chain segment yanked
; --- input -----------------------------------------------------------------
; d4.w = angle the object is touching the edge of the previous object
; ---------------------------------------------------------------------------

DDZWRM_ChainPhysics:
		tst.b	d4						; is the piece touching the bottom half?
		bpl.s	.BottomHalf					; if so, branch
		rts							; return

	.BottomHalf:
		move.w	ObjX(a0),d0					; get X distance
		sub.w	d5,d0						; ''
		move.b	PrevX(a0),d1					; load previous/current speed (quotient only)

		; --- Gitter prevention ---
		; This will prevent gitter, if the distance is exactly
		; on 0, and the X speed is slower than +/- $100, the
		; pieces will immediately stop.
		; -------------------------

		bne.s	.NoStop						; if the speed isn't 00 quotient, skip
		tst.w	d0						; is the distance at 0 too?
		bne.s	.NoStop						; if not, skip
		move.w	d0,SpeedX(a0)					; stop moving on X (stops gitter)
		rts

	.NoStop:

		; -------------------------

		sub.w	d0,SpeedX(a0)					; subtract distance as speed
		beq.s	.NoCheck					; if the speed is exactly on 0, IGNORE overflow
		add.b	SpeedX(a0),d1					; can't XOR from index location, but add will be fine, we only want XOR on MSB
		bpl.s	.NoOverflow					; if the speed hasn't changed direction properly yet, branch
		asr.w	#$01,d0						; reduce speed by half
		bne.s	.NoPos0						; if we haven't reached 0, branch
		moveq	#$01,d0						; force 0 to 1 (FFFF always ends up as FFFF, so we wanted positive to always end up as 0001)

	.NoPos0:
		add.w	d0,SpeedX(a0)					; remove half the speed which was added (gradually slow it down)

	.NoOverflow:
		move.w	SpeedX(a0),PrevX(a0)				; store as previous speed for next time

	.NoCheck:
		; Do NOT store PrevX if the X speed is 0, otherwise
		; there's no way of telling if there was overflow from
		; positive/negative exclusively without zero.
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Loading a fly enemy object where the boss is
; ---------------------------------------------------------------------------

DDZ_CreateFly:
		jsr	(Create_New_Sprite).w				; find a new object slot
		bne.s	.NoFly						; if none are available, skip
		move.l	#Obj_Fly,(a1)					; load the enemy
		move.w	WmDispX(a0),obX(a1)				; set X and Y position to where the boss is
		move.w	WmDispY(a0),obY(a1)				; ''
		move.w	#$2000|(VDD_FlyArt/$20),obGfx(a1)		; set pattern index address
		move.l	#.FlyMappings,obMap(a1)				; set mapping list address

	.NoFly:
		rts							; return

	.FlyMappings:
		binclude "Levels\DDZ\Code\Data\Phase 1\Fly\Map.bin"	; mapping data for fly enemy
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Controlling the head (this will control the state of the body pieces)
; ---------------------------------------------------------------------------

DDZ_RunWormHead:
		lea	(RDD_Worm).l,a0					; load worm head RAM space
		moveq	#$00,d0						; load head modes
		move.b	WmHeadMode(a0),d0				; ''
		bmi.w	DDZ_RWH_Defeated				; if defeated, branch
		move.w	.HeadModes(pc,d0.w),d0				; run correct routine
		jsr	.HeadModes(pc,d0.w)				; ''
		subq.b	#$01,WmDamage(a0)				; decrease hit timer
		bcc.s	.HurtSet					; if still counting, branch
		sf.b	WmDamage(a0)					; keep hit timer at 0
		rts							; return

	.HeadModes:
		dc.w	DDZ_RWH_Init-.HeadModes				; 00 - initialise

		dc.w	DDZ_RWH_InitIdle-.HeadModes			; 02 - initialising idle mode
		dc.w	DDZ_RWH_Idle-.HeadModes				; 04 - idle
		dc.w	DDZ_RWH_Missile-.HeadModes			; 06 - missile
		dc.w	DDZ_RWH_SlamPrep-.HeadModes			; 08 - preparing to slam
		dc.w	DDZ_RWH_Slam-.HeadModes				; 0A - slamming down

		dc.w	DDZ_RWH_InitLaser-.HeadModes			; 0C - initialise laser mode
		dc.w	DDZ_RWH_PrepLaser-.HeadModes			; 0E - laser prep mode
		dc.w	DDZ_RWH_Missile-.HeadModes			; 10 - missile
		dc.w	DDZ_RWH_ChargeLaser-.HeadModes			; 12 - laser charge mode
		dc.w	DDZ_RWH_Laser-.HeadModes			; 14 - laser mode

	.HurtSet:
		move.b	WmDamage(a0),d4					; load timer
		lea	(Target_palette+$60).w,a1			; load original palette
		lea	(Normal_palette+$60).w,a2			; load normal palette
		lea	(RDD_BossColours).l,a3				; load flash palette

	; This section is called from phase 2 as well

	.HurtFlash:
		beq.s	.Restore					; if hurt counter is finished, restore the palette

		moveq	#$60,d3						; force mask to 00 (always cap)
		tst.w	(Seizure_Flag).w				; is seizure mode on?
		bne.s	.Seizure					; if so, don't flash brighter colours
		cmpi.b	#$30,d4						; set the lass flashy version if the timer is almost finished
		smi.b	d3						; ''
		andi.b	#$60,d3						; '' (If the mask is 00, then the counter below will *always* fail)

	.Seizure:
		move.b	d4,d0						; load damage timer
		neg.b	d0						; reverse direction
		lsl.b	#$04,d0						; align to size of palette line
		andi.w	#$00E0,d0					; ''
		moveq	#$10-1,d2					; number of colours to process

	.NextColour:
		andi.w	#$00FE,d0					; wrap within palette range
		move.w	(a3,d0.w),(a2)+					; copy correct flash colour to the palette
		addi.b	#$22,d0						; advance to next colour (and next flash slot)
		move.b	d3,d1						; load damage timer mask
		and.b	d0,d1						; mask the timer
		subi.b	#$20,d1						; check if the brightest and darkest versions are about to display
		bne.s	.Okay						; if not (or the mask is 00 because timer isn't low enough yet), continue with brightest/darkest
		addi.b	#$20,d0						; skip brightest/darkest line

	.Okay:
		dbf	d2,.NextColour					; repeat for all colours
		rts							; return

	.Restore:
		rept	$20/4
		move.l	(a1)+,(a2)+					; copy colours
		endm
		rts							; return

; ---------------------------------------------------------------------------
; Setting up the boss
; ---------------------------------------------------------------------------
DDZ_IDLE_SIDE		= ((320/2)-$0C)			; distance from centre of arena the boss is allowed to move
DDZ_IDLE_ACCEL		= $10				; acceleration
DDZ_IDLE_DECEL		= $10				; deceleration
DDZ_IDLE_SPEED		= $100				; maximum speed

DDZ_IDLE_TIMEATTACK	= 5				; number of seconds between each attack
DDZ_IDLE_DISTATTACK	= $80				; distance horizontally the boss can attack Sonic within
DDZ_IDLE_SLAMS		= 3				; number of times to slam before moving to next mode

DDZ_LASER_SIDE		= ((320/2)-$30)			; distance from centre of arena when to turn off the laser
DDZ_LASER_SPEED		= $200				; maximum speed of moving left/right with laser
DDZ_LASER_COUNT		= 3				; number of times to do the laser sweep

DDZ_MISSILE_COUNT	= 4				; number of missiles to shoot
; ---------------------------------------------------------------------------

DDZ_RWH_Init:
		addq.b	#$02,WmHeadMode(a0)				; advance to slam mode
	if Debug_EasyBoss=1
		move.b	#1,WmHitCount(a0)				; set hit counter to 1 for easy boss debug flag
	else
		move.w	(Difficulty_flag).w,d0				; load the difficulty flag
		move.b	.Diff(pc,d0.w),WmHitCount(a0)			; set correct number of hits based on difficulty
		bra.s	.Done						; jump over table

	.Diff:	dc.b	8		; easy
		dc.b	16		; normal
		dc.b	18		; hard
		dc.b	20		; maniac

	.Done:

	endif

; ---------------------------------------------------------------------------
; Idle initisialise routine
; ---------------------------------------------------------------------------

DDZ_RWH_InitIdle:
		addq.b	#$02,WmHeadMode(a0)				; advance to slam mode
		move.b	#DDZ_IDLE_SLAMS,WmCounter(a0)			; reset slam count

		move.b	#DDZ_MISSILE_COUNT,WmCounter+2(a0)		; set number of missiles to shoot out
		clr.w	WmTimer+2(a0)					; reset timer

		tst.b	WmCounter+1(a0)					; is this the first time the boss has ran?
		beq.s	.FirstTime					; if so, branch
		move.w	#60*DDZ_IDLE_TIMEATTACK,WmTimer(a0)		; set delay timer

	.FirstTime:

		sf.b	WmInLaserMode(a0)				; laser mode OFF

; ---------------------------------------------------------------------------
; Idle routine
; ---------------------------------------------------------------------------

DDZ_RWH_Idle:
		bsr.s	.Move						; set movement/speed
		bsr.w	DDZ_MoveWorm					; move the boss
		bsr.w	DDZ_WobbleWorm					; load wobble positions to d0 and d1
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxDome					; check dome hitbox

	.Move:
		cmpi.b	#$01,WmCounter+1(a0)				; has the worm move from side to side enough times?
		blo.s	.NoSlam						; if not, branch
		move.b	#$01,WmCounter+1(a0)				; keep at max now

		subq.w	#$01,WmTimer(a0)				; decrease timer
		bpl.s	.WaitSlam					; if still running, branch
		move.w	(Player_1+obX).w,d0				; load X poisition of player
		sub.w	WmPosX(a0),d0					; get distance of player from boss
		addi.w	#DDZ_IDLE_DISTATTACK,d0				; is the player in range of the boss?
		cmpi.w	#DDZ_IDLE_DISTATTACK*2,d0			; ''
		bhi.s	.WaitSlam					; if not, branch
		addq.b	#$02,WmHeadMode(a0)				; advance to slam mode
		bra.s	.MaxWobble

	.NoSlam:
		; First time the boss runs, the counter starts at 0 and
		; increases from side to side, then should attack immediately
		; as side to side is long enough time.

		; The second time and onwards, this instruction should never be ran
		; because the counter will stay at 2 (or whatever) for the rest of
		; the boss...
		clr.w	WmTimer(a0)					; force timer to 0

	.WaitSlam:

	; --- Wobble and Y positioning ---

		cmpi.b	#$30,WmWobDist(a0)				; is wobble at maximum?
		bhs.s	.MaxWobble					; if so, finish expanding
		addi.w	#$0040,WmWobDist(a0)				; expand wobble

	.MaxWobble:
		subi.l	#$00008000,WmPosY(a0)				; move worm upwards
		cmpi.w	#(224/2)-$40,WmPosY(a0)				; is the boss at the top of the screen?
		bhi.s	.NoMaxY						; if not, branch
		move.w	#(224/2)-$40,WmPosY(a0)				; force to top of screen

	.NoMaxY:
		move.w	#DDZ_IDLE_SPEED,d2				; set maximum speed to move at

	; --- Subroutine to move the boss from side to side ---

DDZ_RHW_MoveSideways:
		move.w	WmPosX(a0),d0					; load X position
		move.w	WmSpeedX(a0),d1					; load X speed
		bpl.s	.MoveRight					; if moving right, branch
		neg.w	d2						; reverse max speed direction

	; --- Moving towards left side ---

	.MoveLeft:
		cmpi.w	#DDZ_BOSS_CENTRE_X-DDZ_IDLE_SIDE,d0		; has the boss reached the left side?
		bls.s	.MaxLeft					; if so, branch
		subi.w	#DDZ_IDLE_ACCEL,d1				; increase X speed
		cmp.w	d2,d1						; has the speed reached maximum?
		bcc.s	.NoMaxL						; if not, branch
		move.w	d2,d1						; force to maximum

	.NoMaxL:
		move.w	d1,WmSpeedX(a0)					; update speed
		rts							; return

	.MaxLeft:
		addi.w	#DDZ_IDLE_DECEL,d1				; decrease X speed
		bcc.s	.NoStopL					; if not finished, branch
		addq.b	#$01,WmCounter+1(a0)				; increase count

	.NoStopL:
		move.w	d1,WmSpeedX(a0)					; update speed
		rts							; return

	; --- Moving towards right side ---

	.MoveRight:
		cmpi.w	#DDZ_BOSS_CENTRE_X+DDZ_IDLE_SIDE,d0		; has the boss reached the right side?
		bhs.s	.MaxRight					; if so, branch
		addi.w	#DDZ_IDLE_ACCEL,d1				; increase X speed
		cmp.w	d2,d1						; has the speed reached maximum?
		bcs.s	.NoMaxR						; if not, branch
		move.w	d2,d1						; force to maximum

	.NoMaxR:
		move.w	d1,WmSpeedX(a0)					; update speed
		rts							; return

	.MaxRight:
		subi.w	#DDZ_IDLE_DECEL,d1				; decrease X speed
		bcc.s	.NoStopR					; if not finished, branch
		addq.b	#$01,WmCounter+1(a0)				; increase count

	.NoStopR:
		move.w	d1,WmSpeedX(a0)					; update speed
		rts							; return

; ---------------------------------------------------------------------------
; Launching missiles
; ---------------------------------------------------------------------------

DDZ_RWH_Missile:
		btst.b	#$00,WmCounter+3(a0)				; is this a second event?
		bne.s	.NoSkip						; if not, branch
		addq.b	#$01,WmCounter+3(a0)				; increase missile pattern slot
		addq.b	#$02,WmHeadMode(a0)				; advance to next mode
		addq.w	#$04,sp						; remove return address for jump table
		bra.w	DDZ_RunWormHead					; redo jump table again...

	.NoSkip:
		subi.w	#$0080,WmWobDist(a0)				; reduce wobble
		bgt.s	.MaxWobble					; if not stopped wobbling yet, branch
		clr.w	WmWobDist(a0)

		subq.w	#$01,WmTimer+2(a0)				; decrease missile shoot delay time
		bpl.s	.MaxWobble					; if not finished, skip
		move.w	#30,WmTimer+2(a0)				; reset timer

		bsr.w	DDZ_FindMissileSlot				; find a free slot
		bne.s	.NoMissile					; if there's no slot available, skip
		move.w	#$0108,MsT(a1)					; set as missile and set 8 frames before smoke should load
		move.w	WmDispX(a0),MsX(a1)				; set X position
		move.w	WmDispY(a0),MsY(a1)				; set Y position
		move.w	#$F800,MsS(a1)					; set speed upwards
		sfx	SDD_MissileShoot				; play missile shooting SFX

	.NoMissile:
		subq.b	#$01,WmCounter+2(a0)				; decrease missile count
		bne.s	.MaxWobble					; if not finished, branch
		addq.b	#$02,WmHeadMode(a0)				; advance to slam mode
		addq.b	#$01,WmCounter+3(a0)				; increase missile pattern slot
		move.b	#DDZ_MISSILE_COUNT,WmCounter+2(a0)		; reset number of missiles to shoot out
		clr.w	WmTimer+2(a0)					; reset shooting timer

	.MaxWobble:
		bsr.w	DDZ_WobbleWorm					; get wobble positions (without rotating)
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxDome					; check dome hitbox

; ---------------------------------------------------------------------------
; Preparing to slam down (visual indiciation)
; ---------------------------------------------------------------------------

DDZ_RWH_SlamPrep:
		subq.w	#$01,WmPosY(a0)					; move the boss upwards

		subq.b	#$01,WmWobDist(a0)				; decrease distance
		bgt.s	.NoSlamReady					; if still valid distance, branch
		clr.w	WmWobDist(a0)					; keep at 0

	.NoSlamReady:
		cmpi.w	#((224/2)-$40)-$30,WmPosY(a0)			; this is the distance the boss *WOULD* have moved up if the wobble distance weren't 0 now...
		bgt.s	.NoSlam						; if not finished, continue

		addq.b	#$02,WmHeadMode(a0)				; advance to slam mode
		move.w	WmSpeedX(a0),WmStore+6(a0)			; store X speed (for return to idle mode)
		addq.b	#$04,WmBodyMode(a0)				; change to fluid mode
		move.w	(Player_1+obX).w,d0				; load X poisition of player
		move.w	d0,d3						; set as destination
		sub.w	WmPosX(a0),d0					; get distance of player from boss
		move.w	#DDZ_IDLE_DISTATTACK,d1				; prepare distance
		add.w	d1,d0						; is the player in range of the boss?
		move.w	d1,d2						; ''
		add.w	d2,d2						; '' (for both sides)
		cmp.w	d2,d0						; ''
		bls.s	.InRange					; if so, branch
		bpl.s	.MaxRange					; if Sonic is to the right, branch
		neg.w	d1						; reverse to left

	.MaxRange:
		add.w	WmPosX(a0),d1					; add position to range/direction
		move.w	d1,d3						; set as destination

	.InRange:
		move.w	d3,WmDestX(a0)					; set X destination
		move.w	#(224/2)+$20,WmDestY(a0)			; set Y destination

	.NoSlam:
		bsr.w	DDZ_WobbleWorm					; load wobble positions to d0 and d1
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxDome					; check dome hitbox

; ---------------------------------------------------------------------------
; Slamming down routine
; ---------------------------------------------------------------------------

DDZ_RWH_Slam:
		moveq	#$08,d3						; prepare speed ($800)
		bsr.w	DDZ_MoveToDest					; move boss to the destination
		bsr.w	DDZ_MoveWorm					; move the boss
		move.w	WmDestY(a0),d2					; get Y distance
		sub.w	WmPosY(a0),d2					; ''
		bgt.s	.NoSlam						; if the boss has not hit the floor yet, branch
		move.w	WmDestX(a0),WmPosX(a0)				; force boss to destination
		move.w	WmDestY(a0),WmPosY(a0)				; ''
		tst.b	WmBodyMode(a0)					; has body been set to natural yet?
		beq.s	.NoSlam						; if so, skip
		move.b	#$20,(ScreenWobble).w				; set screen to shake
		sfx	SDD_Slam					; play slam SFX
		sf.b	WmBodyMode(a0)					; change body back to natural
		moveq	#$00,d0						; clear speeds
		move.l	d0,WmSpeed(a0)					; ''
		move.w	#60*DDZ_IDLE_TIMEATTACK,WmTimer(a0)		; set delay timer

		addq.b	#$02,WmHeadMode(a0)				; move to next mode
		subq.b	#$01,WmCounter(a0)				; decrease slam counter
		beq.s	.FinishIdle					; if finished, branch
		subq.b	#$02+6,WmHeadMode(a0)				; go back to idle mode again
		tst.b	WmStore+6(a0)					; check direction the boss was moving before
		smi.b	d0						; transfer direction to d0
		ext.w	d0						; ''
		move.w	d0,WmSpeedX(a0)					; set as speed (so the boss continues moving that direction in idle mode)

	.FinishIdle:

	.NoSlam:
		moveq	#$00,d1						; no X wobble
		moveq	#$00,d0						; no Y wobble
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxHead					; check full head hitbox

; ===========================================================================
; ---------------------------------------------------------------------------
; Initialising laser mode
; ---------------------------------------------------------------------------

DDZ_RWH_InitLaser:
		addq.b	#$02,WmHeadMode(a0)				; move to laser prep mode
		move.w	#DDZ_BOSS_CENTRE_X,WmDestX(a0)			; set to move boss to centre top of arena
		move.w	#(224/2)-$40,WmDestY(a0)			; ''
		move.w	#60*2,WmTimer(a0)				; set to stay in place for 2 seconds after laser is fully shot out (first laser only)
		move.b	#DDZ_LASER_COUNT,WmCounter(a0)			; reset laser sweep counter

		st.b	WmInLaserMode(a0)				; laser mode ON

; ---------------------------------------------------------------------------
; preparing position for laser
; ---------------------------------------------------------------------------

DDZ_RWH_PrepLaser:
		moveq	#$01,d3						; prepare speed ($100)
		bsr.w	DDZ_MoveToDest					; move boss to the destination
		bne.s	.NoReady					; if not reached destination yet, branch
		subi.w	#$0080,WmWobDist(a0)				; reduce wobble
		bgt.s	.MaxWobble					; if not stopped wobbling yet, branch
		clr.w	WmWobDist(a0)					; keep wobble at 0
		addq.b	#$02,WmHeadMode(a0)				; advance to missile/charge mode
		bra.s	.MaxWobble					; cotinue

	.NoReady:
		cmpi.b	#$30,WmWobDist(a0)				; is wobble at maximum?
		bhs.s	.MaxWobble					; if so, finish expanding
		addi.w	#$0040,WmWobDist(a0)				; expand wobble

	.MaxWobble:
		bsr.w	DDZ_MoveWorm					; move the boss
		bsr.w	DDZ_WobbleWorm					; load wobble positions to d0 and d1
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxDome					; check dome hitbox

; ---------------------------------------------------------------------------
; charging the laser
; ---------------------------------------------------------------------------

DDZ_RWH_ChargeLaser:
		tst.b	WmBeamOn(a0)					; are the lasers already on?
		bne.s	.NoChargeSFX					; if so, skip SFX
		sfx	SDD_LaserCharge					; play laser charging SFX

	.NoChargeSFX:
		st.b	WmBeamOn(a0)					; turn the laser beams on
		tst.b	WmBeamCharge(a0)				; has the beam fully charged?
		bne.s	.MaxWobble					; if not, wait...
		subq.w	#$01,WmTimer(a0)				; decrease delay timer
		bpl.s	.MaxWobble					; if not finished, branch
		addq.b	#$02,WmHeadMode(a0)				; advance to laser mode
		bsr.w	DDZ_CreateFly					; make fly enemy
		moveq	#$01,d1						; set to move right
		move.w	WmPosX(a0),d0					; get distance from player
		sub.w	(Player_1+obX).w,d0				; ''
		bmi.s	.MoveRight					; if player is on right side, keep right movement
		neg.w	d1						; reverse direction left

	.MoveRight:
		move.w	d1,WmSpeedX(a0)					; set speed/direction

	.MaxWobble:
		cmpi.b	#$01,WmBeamCharge(a0)				; will the beam shoot next frame?
		bne.s	.NoShootSFX					; if not, skip SFX
		sfx	SDD_LaserShoot					; play laser shooting SFX

	.NoShootSFX:
		bsr.w	DDZ_MoveWorm					; move the boss
		bsr.w	DDZ_WobbleWorm					; load wobble positions to d0 and d1
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxDome					; check dome hitbox

; ---------------------------------------------------------------------------
; laser mode routine
; ---------------------------------------------------------------------------

DDZ_RWH_Laser:
		move.w	WmSpeedX(a0),d3					; store speed before moving
		move.w	#DDZ_LASER_SPEED,d2				; set maximum speed to move at
		bsr.w	DDZ_RHW_MoveSideways				; move left/right
		move.w	WmSpeedX(a0),d0					; load new speed
		eor.w	d0,d3						; is the boss still moving in the same direction?
		bpl.s	.StillMoving					; if so, continue
		move.w	WmPosX(a0),WmDestX(a0)				; force destination as reached
		clr.w	WmSpeedX(a0)					; set no X speed
		subq.b	#$06,WmHeadMode(a0)				; go back and recharge
		move.w	#60,WmTimer(a0)					; set to stay in place for 1 second after laser is fully shot out
		subq.b	#$01,WmCounter(a0)				; decrease sweep count
		bgt.s	.StillMoving					; if not finished, branch
		move.b	#$02,WmHeadMode(a0)				; reset back to idle mode again

	.StillMoving:
		bsr.w	DDZ_MoveWorm					; move the boss

		move.w	WmPosX(a0),d0					; load X position
		subi.w	#DDZ_BOSS_CENTRE_X-DDZ_LASER_SIDE,d0		; has the boss reached either side to shut off the laser?
		cmpi.w	#DDZ_LASER_SIDE*2,d0				; ''
		blo.s	.KeepBeamOn					; if not, continue with beam on

	.ShutOff:
		smi.b	d0						; set if on right or left
		move.b	WmSpeedX(a0),d1					; is the speed heading the same direction?
		eor.b	d1,d0						; ''
		bmi.s	.KeepBeamOn					; if not, then ignore (on wrong side)
		sf.b	WmBeamOn(a0)					; turn the beam off

	.KeepBeamOn:
		moveq	#$00,d1						; no X wobble
		moveq	#$00,d0						; no Y wobble
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		bra.w	DDZ_HitboxDome					; check dome hitbox

; ---------------------------------------------------------------------------
; Defeated mode
; ---------------------------------------------------------------------------

DDZ_RWH_Defeated:
		subi.w	#$0100,WmWobDist(a0)				; reduce wobble
		bgt.s	.ContinueWobble					; if not stopped wobbling yet, branch
		clr.w	WmWobDist(a0)					; keep wobble at 0

	.ContinueWobble:
		bsr.w	DDZ_MoveWorm					; move the boss
		cmpi.b	#$FE,WmHeadMode(a0)				; is the boss fully on the floor?
		beq.s	.NoFloor					; if so, skip gravity

		addi.w	#$001C,WmSpeedY(a0)				; increase gravity
		cmpi.w	#(224/2)+$20,WmPosY(a0)				; has the boss touched the floor?
		blt.s	.NoFloor					; if not, continue
		move.w	#(224/2)+$20,WmPosY(a0)				; force tot he floor
		move.w	WmSpeedX(a0),d0					; reduce the X speed (friction)
		asr.w	#$02,d0						; ''
		sub.w	d0,WmSpeedX(a0)					; ''
		neg.w	WmSpeedY(a0)					; reverse Y speed (bounc)
		addi.w	#$0180,WmSpeedY(a0)				; add resistence
		bcc.s	.HitFloor					; if the resistence isn't high enough yet, continue
		moveq	#$00,d0						; stop the boss moving
		move.l	d0,WmSpeed(a0)					; ''
		move.b	#$FE,WmHeadMode(a0)				; set defeated as now finished
		fadeout							; fade the music out
		bra.s	.NoFloor					; avoid screen shake

	.HitFloor:
		move.b	#$20,(ScreenWobble).w				; set screen to shake

	.NoFloor:
		bsr.w	DDZ_WobbleWorm					; load wobble positions to d0 and d1
		bsr.w	DDZ_DispWorm					; add positions to d0 and d1 and save as display positions
		move.w	WmChild(a0),d0					; load child explosion object
		beq.s	.NoObject					; if no object loaded, skip
		movea.w	d0,a1						; set address
		st.b	$39(a1)						; set explosions to constantly occur
		move.w	WmDispX(a0),x_pos(a1)				; move explosion to the boss
		move.w	WmDispY(a0),y_pos(a1)				; ''

	.NoObject:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Moving the boss to its destnation
; --- input -----------------------------------------------------------------
; d3.w = Speed (Quotient only)
; ---------------------------------------------------------------------------

DDZ_MoveToDest:
		move.w	WmDestY(a0),d2					; get Y distance
		sub.w	WmPosY(a0),d2					; ''
		move.w	WmDestX(a0),d1					; get X distance
		sub.w	WmPosX(a0),d1					; ''
		jsr	(CalcDist).w					; get 360 distance
		cmp.b	d3,d0						; have we reached the destination?
		bcs.s	.Reached					; if so, branch
		jsr	(CalcAngle_NEW).w				; get the angle
		lea	(SineTable+1).w,a1				; load sine table
		add.w	d0,d0						; convert angle to element word size
		move.w	-$01(a1,d0.w),d1				; load Y
		muls.w	d3,d1						; set Y as speed
		muls.w	+$7F(a1,d0.w),d3				; load X as speed
		move.w	d3,WmSpeedX(a0)					; set X speed
		move.w	d1,WmSpeedY(a0)					; set Y speed
		moveq	#-1,d3						; set non-zero
		rts							; return

	.Reached:
		move.w	WmDestX(a0),WmPosX(a0)				; force to destination
		move.w	WmDestY(a0),WmPosY(a0)				; ''
		moveq	#$00,d3						; set zero
		move.l	d3,WmSpeed(a0)					; clear speeds (keeps Z flag sero too)
		rts							; return

; ---------------------------------------------------------------------------
; Moving the boss using its speed
; ---------------------------------------------------------------------------

DDZ_MoveWorm:
		movem.w	WmSpeed(a0),d0-d1				; load X and Y speeds (QQ.FF)
		asl.l	#$08,d0						; align for position QQQQ.FFFF
		asl.l	#$08,d1						; ''
		add.l	d0,WmPosX(a0)					; move X
		add.l	d1,WmPosY(a0)					; move Y
		rts							; return

; ---------------------------------------------------------------------------
; Loading relative wobble positions to d1 and d0 (for display)
; ---------------------------------------------------------------------------

DDZ_WobbleWorm:
		addi.w	#$0200,WmWobble(a0)				; rotate/wobble the mode
		lea	(SineTable+1).w,a1				; load sine table
		moveq	#$00,d2						; clear d2
		move.b	WmWobble(a0),d2					; load quotient of wobble angle
		add.w	d2,d2						; multiply by size of word elemtn
		move.w	-$01(a1,d2.w),d1				; load X
		move.w	WmWobDist(a0),d0				; load wobble distance
		muls.w	d0,d1						; multiply and send to upper word
		lsr.w	#$03,d0						; reduce for Y distance
		muls.w	+$7F(a1,d2.w),d0				; multiply Y (to upper word)
		rts							; return

; ---------------------------------------------------------------------------
; Setting display positions and rotation angle
; --- input -----------------------------------------------------------------
; d0.l = relative wobble Y position
; d1.l = relative wobble X position
; ---------------------------------------------------------------------------

DDZ_DispWorm:
		add.l	WmPosY(a0),d0					; add Y position to d0 wobble
		move.l	d0,WmDispY(a0)					; save as display Y position

		move.l	WmDispX(a0),d0					; load current display X position

		add.l	WmPosX(a0),d1					; add X position to d1 wobble
		move.l	d1,WmDispX(a0)					; save as display X position

		sub.l	d1,d0						; get distance moved
		asr.l	#$04,d0						; align for angle
		move.w	d0,WmAngle(a0)					; set rotation angle for the worm
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Making the boss body peices collidable
; ---------------------------------------------------------------------------

	; --- The dome ---

DDZ_HitboxDome:
		tst.b	WmHeadMode(a0)					; is the boss defeated?
		bmi.w	.NoTouch					; if so, skip
		tst.b	WmDamage(a0)					; is the boss damaged/hurt?
		bne.w	.NoTouch					; if so, skip collision check
		lea	(Player_1).w,a1					; load player's object RAM

		; -------------
		; Insta-shield
		; -------------

		move.b	status_secondary(a0),d0				; load shield status
		andi.b	#$73,d0						; Does the player have any shields or is invincible?
		bne.s	.NoInsta					; If so, branch
		cmpi.b	#1,double_jump_flag(a0)				; Is the Insta-Shield currently in its 'attacking' mode?
		bne.s	.NoInsta					; If not, branch

		moveq	#$18,d1						; load width
		moveq	#$18,d2						; load height

		tst.w	(Enlarged_InstaShield).w			; is this an enlarged insta-shield?
		beq.s	.NoEnlarge					; if not, branch
		add.w	d1,d1						; expand by x2
		add.w	d2,d2						; ''

	.NoEnlarge:
		move.w	WmDispX(a0),d0					; load X and Y position to check against
		move.w	WmDispY(a0),d3					; ''
		bsr.w	DDZ_HitboxCheck					; check if insta-shield has touched the boss
		bls.s	.HurtBoss					; if so, branch

	.NoInsta:

		; --------------
		; Sonic himself
		; --------------

		moveq	#$10,d1						; load width
		moveq	#$14,d2						; load height
		move.w	WmDispX(a0),d0					; load X and Y position to check against
		move.w	WmDispY(a0),d3					; ''
		bsr.w	DDZ_HitboxCheck					; check if player has touched the boss
		bhi.w	.NoTouch					; if not, branch

		btst	#Status_Invincible,status_secondary(a1)		; does Sonic have invincibility?
		bne.s	.HurtBoss					; if yes, branch
		cmpi.b	#id_SpinDash,obAnim(a1)				; is Sonic Spin Dashing?
		beq.s	.HurtBoss					; if yes, branch
		cmpi.b	#id_Roll,obAnim(a1)				; is Sonic rolling/jumping?
		bne.w	DDZ_HurtSonic					; if not, branch

	.HurtBoss:
		move.w	obY(a1),d2					; get Y distance
		sub.w	WmDispY(a0),d2					; ''
		move.w	obX(a1),d1					; get X distance
		sub.w	WmDispX(a0),d1					; ''
		jsr	(CalcAngle_NEW).w				; get the angle
		lea	(SineTable+1).w,a2				; load sine table
		add.w	d0,d0						; convert angle to element word size
		move.w	-$01(a2,d0.w),d1				; load Y
		moveq	#$08,d2						; prepare speed ($800)
		muls.w	d2,d1						; set Y as speed
		muls.w	+$7F(a2,d0.w),d2				; load X as speed
		move.w	d2,obVelX(a1)					; set X speed
		move.w	d1,obVelY(a1)					; set Y speed
		subq.b	#$01,WmHitCount(a0)				; decrease hit counter
		bhi.s	.NoFinish					; if not finished, branch
		st.b	WmHeadMode(a0)					; set as defeated
		sf.b	WmBodyMode(a0)					; change bodyto natural mode
		move.w	#$0140,d0					; fall right
		cmp.w	#DDZ_BOSS_CENTRE_X,WmPosX(a0)			; check side boss is on
		bmi.s	.FallRight					; if boss is on the left, branch for right
		neg.w	d0						; fall left

	.FallRight:
		move.w	d0,WmSpeedX(a0)					; set fall direction
		move.w	#$FF00,WmSpeedY(a0)				; set Y speed
		sf.b	WmBeamOn(a0)					; turn the laser beams off

		jsr	(Create_New_Sprite).w				; load a free object slot
		bne.s	.NoFinish					; if there's no slot, skip (see no reason not to be)
		move.l	#Obj_CreateBossExplosion,address(a1)		; set object address
		move.w	a1,WmChild(a0)					; store explosion as child object
		move.b	#$24,$2C(a1)					; set explosion type
		move.w	WmDispX(a0),x_pos(a1)				; set X position
		move.w	WmDispY(a0),y_pos(a1)				; set Y position
		rts							; return (no damage timer)

	.NoFinish:
		move.b	#60*2,WmDamage(a0)				; set damage timer (2 seconds)
		sfx	SDD_Damage					; play damage SFX

	.NoTouch:
		rts							; return

	; --- The entire head ---

DDZ_HitboxHead:
		tst.b	WmHeadMode(a0)					; is the boss defeated?
		bmi.w	.NoTouch					; if so, skip
		lea	(Player_1).w,a1					; load player's object RAM
		moveq	#-$10,d1					; load width
		add.w	WmWidth(a0),d1					; ''
		moveq	#-$08,d2					; load height
		add.w	WmHeight(a0),d2					; ''
		move.w	WmDispX(a0),d0					; load X and Y position to check against
		move.w	WmDispY(a0),d3					; ''

		bsr.s	DDZ_HitboxCheck					; check if player has touched the boss
		bhi.s	.NoTouch					; if not, branch
		btst	#Status_Invincible,status_secondary(a1)		; does Sonic have invincibility?
		beq.s	DDZ_HurtSonic					; if not, branch

	.NoTouch:
		rts							; return

DDZ_HurtSonic:
	;rts	; No harm

		tst.w	(Debug_placement_mode).w			; is debug mode	active?
		bne.s	.NoHurt						; if so, skip getting hurt
		cmpi.b	#id_SonicHurt-1,routine(a1)			; is Sonic hurt/dead already?
		bhi.s	.NoHurt						; if so, return out of range
		exg.l	a0,a1						; swap player with boss
		pea	(a1)						; store boss RAM
		lea	WmPosX-obX(a1),a1				; load such that X position aligns with object RAM
		jsr	Touch_Hurt					; run Sonic hurt routine
		move.l	(sp)+,a1					; restore boss RAM
		exg.l	a0,a1						; restore RAM slots

	.NoHurt:
		rts							; return

; ---------------------------------------------------------------------------
; Checking if the hitbox has been touched
; --- input -----------------------------------------------------------------
; a0.l = Worm RAM
; a1.l = Sonic object RAM
; d1.w = Width of Worm boss
; d2.w = Height of Worm boss
; ---------------------------------------------------------------------------

;DDZ_HitboxCheck:
;		cmpi.b	#id_SonicHurt-1,routine(a1)			; is Sonic hurt/dead already?
;		bhi.s	.NoTouch					; if so, return out of range
;		move.w	WmDispY(a0),d0					; load display Y position
;		sub.w	obY(a1),d0					; minus player's Y position
;		add.b	y_radius(a1),d2					; account for player's height too
;		add.w	d2,d0						; check in range of boss's hitbox
;		add.w	d2,d2						; ''
;		cmp.w	d2,d0						; is the player in range?
;		bhi.s	.NoTouch					; if not, branch
;		move.w	WmDispX(a0),d0					; load display X position
;		sub.w	obX(a1),d0					; minus player's X position
;		add.b	x_radius(a1),d1					; account for player's width too
;		add.w	d1,d0						; check in range of boss's hitbox
;		add.w	d1,d1						; ''
;		cmp.w	d1,d0						; is the player in range?
;
;	.NoTouch:
;		rts							; return

; ---------------------------------------------------------------------------
; Checking if the hitbox has been touched
; --- input -----------------------------------------------------------------
; a1.l = Sonic object RAM
; d0.w = X position of object
; d1.w = Width of Worm boss
; d2.w = Height of Worm boss
; d3.w = Y position of object
; ---------------------------------------------------------------------------

DDZ_HitboxCheck:
		cmpi.b	#id_SonicHurt-1,routine(a1)			; is Sonic hurt/dead already?
		bhi.s	.NoTouch					; if so, return out of range
		sub.w	obY(a1),d3					; minus player's Y position from object Y position
		add.b	y_radius(a1),d2					; account for player's height too
		add.w	d2,d3						; check in range of boss's hitbox
		add.w	d2,d2						; ''
		cmp.w	d2,d3						; is the player in range?
		bhi.s	.NoTouch					; if not, branch
		sub.w	obX(a1),d0					; minus player's X position
		add.b	x_radius(a1),d1					; account for player's width too
		add.w	d1,d0						; check in range of boss's hitbox
		add.w	d1,d1						; ''
		cmp.w	d1,d0						; is the player in range?

	.NoTouch:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Performing collision with laser
; ---------------------------------------------------------------------------

DDZ_RunLaserCollision:
		tst.b	(RDD_Worm+WmHeadMode).l				; is the boss defeated?
		bmi.w	.NoLaser					; if so, skip
		moveq	#$00,d0						; load beam height
		move.b	(RDD_Worm+WmBeam).l,d0				; ''
		beq.s	.NoLaser					; if there's no height, ignore collision
		addq.w	#$01,d0						; add 1 for bottom dome piece
		lsl.w	#$03,d0						; multiply height by x8 (size of tile)

		moveq	#-$28,d1					; move top position down to where the sockets are
		add.w	d1,d0						; remove from height of beam

		lea	(Player_1).w,a1					; load player's object RAM
		add.w	obY(a1),d1					; load player's Y position (add top position)
		sub.w	(RDD_Worm+WmDispY).l,d1				; minus boss Y position
		moveq	#$00,d2						; load player's height
		move.b	y_radius(a1),d2					; ''
		add.w	d2,d1						; account for height on the top
		add.w	d2,d0						; account for height on the bottom
		add.w	d2,d0						; ''
		cmp.w	d0,d1						; is Sonic touching the beam on the Y axis?
		bhi.s	.NoLaser					; if not, skip

		move.w	obY(a1),d0					; load player's Y position
		lea	(RDD_HScrollBG).l,a0				; load BG H-scroll table starting from floor
		add.w	d0,d0						; multiply Y position by size of word
		move.w	(a0,d0.w),d0					; load X position
		add.w	(Camera_X_pos).w,d0				; add camera position (because player's X is relative to camera)
		add.w	(RDD_Worm+WmWidth).l,d0				; advance to centre of boss
		subq.w	#$08/2,d0					; minus half width of beam

		moveq	#$00,d2						; load player's width
		move.b	x_radius(a1),d2					; ''
		sub.w	d2,d0						; account for width on the left side of the beam
		move.w	obX(a1),d1					; load player's X position
		add.w	d2,d2						; get full width
		addq.w	#$08,d2						; add width of beam

	.CheckTouch:
		subi.w	#$1C,d1						; check left beam
		sub.w	d0,d1						; get distance from beam
		cmp.w	d2,d1						; is Sonic inside the beam?
		bls.w	DDZ_HurtSonic					; if so, branch for touch
		addi.w	#$1C*2,d1					; check right beam
		cmp.w	d2,d1						; is Sonic inside the beam?
		bls.w	DDZ_HurtSonic					; if so, branch for touch

	.NoLaser:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Finding a missile slot
; ---------------------------------------------------------------------------

DDZ_FindMissileSlot:
		lea	(RDD_Missiles).l,a1				; load missile RAM address
		moveq	#DDZ_MISSILE_MAXSIZE-1,d0			; number of slots to check

	.NextMissile:
		tst.b	MsT(a1)						; is this slot free?
		beq.s	.Free						; if so, break and use
		lea	Ms_Size(a1),a1					; advance to next slot
		dbf	d0,.NextMissile					; repeat for all slots

	.Free:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Performing collision with missiles
; ---------------------------------------------------------------------------

DDZ_RunMissileCollision:
		lea	(Player_1).w,a1					; load player's object RAM
		btst	#Status_Invincible,status_secondary(a1)		; does Sonic have invincibility?
		bne.s	.Finish						; if so, branch
		cmpi.b	#id_SonicHurt-1,routine(a1)			; is Sonic hurt/dead already?
		bhi.s	.Finish						; if so, return out of range

		lea	(RDD_Missiles-Ms_Size).l,a0			; load missile RAM address
		moveq	#DDZ_MISSILE_MAXSIZE-1,d6			; number of slots to check
		moveq	#$01,d5						; prepare missile ID (don't want to hurt on smoke)

	.NextMissile:
		lea	Ms_Size(a0),a0					; advance to next slot
		cmp.b	MsT(a0),d5					; have we found a missile slot?
		dbeq	d6,.NextMissile					; if not, repeat for all slots
		bne.s	.Finish						; if not slot was found, branch
		tst.w	MsS(a0)						; is the missile moving down?
		ble.s	.NoTouch					; if not, branch
		moveq	#$08,d1						; load width
		moveq	#$20,d2						; load height
		move.w	MsX(a0),d0					; load X and Y position to check against
		move.w	MsY(a0),d3					; ''
		bsr.w	DDZ_HitboxCheck					; check if player has touched the boss
		bls.w	DDZ_HurtSonic					; if so, branch

	.NoTouch:
		dbf	d6,.NextMissile					; repeat for all slots

	.Finish:
		rts							; return

; ===========================================================================

















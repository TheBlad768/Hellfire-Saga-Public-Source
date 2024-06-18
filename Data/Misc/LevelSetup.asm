
; =============== S U B R O U T I N E =======================================

LevelSetup:
		move.w	#$FFF,(Screen_Y_wrap_value).w
		move.w	#$FF0,(Camera_Y_pos_mask).w
		move.w	#$7C,(Layout_row_index_mask).w
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		movea.l	(Level_data_addr_RAM.ScreenInit).w,a1
		jsr	(a1)
		movea.l	(Level_data_addr_RAM.BackgroundInit).w,a1
		jsr	(a1)
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w
		rts
; ---------------------------------------------------------------------------

ScreenEvents:
		move.w	(Camera_X_pos).w,(Camera_X_pos_copy).w
		move.w	(Camera_Y_pos).w,(Camera_Y_pos_copy).w
		lea	PlaneBuf.w,a6					; get plane buffer array address for VInt
		movea.l	(Level_data_addr_RAM.ScreenEvent).w,a1
		jsr	(a1)
		movea.l	(Level_data_addr_RAM.BackgroundEvent).w,a1
		jsr	(a1)
		move.w	(Camera_Y_pos_copy).w,(V_scroll_value).w
		move.w	(Camera_Y_pos_BG_copy).w,(V_scroll_value_BG).w

		cmpi.w	#$0300,(Current_zone).w				; MJ: is this DDZ?
		bne.s	.NoDDZ						; MJ: if not, continue normally
		moveq	#-1,d0						; MJ: ensure the Y position is -1 so AND masking is okay for v-scroll bug
		move.w	d0,(Camera_Y_pos).w				; MJ: ''
		move.w	d0,(Camera_Y_pos_copy).w			; MJ: ''
		move.w	d0,(V_scroll_value).w				; MJ: ''
		move.l	(RDD_Event).l,d0				; MJ: load address
		bne.s	.ValidDDZ					; MJ: if invalid, branch
		move.l	#DDZ_SetupEvent,d0				; MJ: set starting event routine
		move.l	d0,(RDD_Event).l				; MJ: ''

	.ValidDDZ:
		movea.l	d0,a1						; MJ: set address
		jsr	(a1)						; MJ: run special events routine

	.NoDDZ:

ExtraRoutine_Null:
		rts
; ---------------------------------------------------------------------------
; Generic BG cam speed processing (BG0, doesn't update maps)
; ---------------------------------------------------------------------------

Camera_Generic	macro	v1,v2
		if ("v1"<>"-1")
			move.w	CamXFGcopy.w,d0			; take FG cam's current xpos
			if ("v1"<>"0")
				asr.w	#v1,d0			; divide
			endif
			move.w	d0,CamXBG.w
			move.w	d0,Camera_X_pos_BG_copy.w	; save as BG cam xpos
		endif
		if ("v2"<>"-1")
			move.w	CamYFGcopy.w,d0			; take FG cam's current ypos
			if ("v2"<>"0")
				asr.w	#v2,d0			; divide
			endif
			move.w	d0,CamYBG.w
			move.w	d0,Camera_Y_pos_BG_copy.w	; save as BG cam ypos
		endif
		endm
; ---------------------------------------------------------------------------
; Generic routine to refresh level's foreground
; ---------------------------------------------------------------------------

FGInit_Generic:
		jsr	(InitFGCam).w				; get FG parameters at proper registers
		jmp	(RedrawPMap).w				; refresh plane (just enough for camera)
; ---------------------------------------------------------------------------
; Generic routine to refresh level's background
; ---------------------------------------------------------------------------

BGInit_Generic:
		jsr	(InitBGCam).w				; get BG parameters at proper registers
		jmp	(RedrawPMap_Full).w				; (1 cam) refresh plane (full)
;		jmp	RedrawPMap				; (1 cam) refresh plane (just enough for camera)
;		jmp	RedrawBGMap_Full			; (3 cam) refresh plane (full)
;		jmp	RedrawBGMap				; (3 cam) refresh plane (just enough for camera)
; ---------------------------------------------------------------------------
; Generic routine to refresh level's foreground
; ---------------------------------------------------------------------------

FGInit_Generic2:
		jsr	(InitFGCam).w			; get FG parameters at proper registers
		jmp	(RedrawPMap_Full).w			; refresh plane (just enough for camera)
; ---------------------------------------------------------------------------
; Generic routine to update plane mappings as you move
; ---------------------------------------------------------------------------

FGScroll_Generic:
		jmp	(ScrollDrawFG_Generic).w			; update FG plane map
; ---------------------------------------------------------------------------
; Generic routine to update plane mappings as you move
; ---------------------------------------------------------------------------

BGScroll_Generic:
		jmp	(ScrollDrawBG_Simple).w			; (1 cam) update BG plane map

BGScroll_Generic2:
		jmp	(ScrollDrawBG_Generic).w			; (3 cam) update BG plane map

BGScroll_SimpleFull:
		jmp	(ScrollDrawBG_SimpleFull).w
; ===========================================================================
; ---------------------------------------------------------------------------
; FDZ 1-2 Events
; ---------------------------------------------------------------------------

FDZ_ScreenEvent:
		tst.b	(ScreenEvent_flag).w
		bne.s	.refresh
		move.w	(Screen_Shaking_Flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		jmp	FGScroll_Generic(pc)			; update FG maps (generic)
; ---------------------------------------------------------------------------

.refresh
		bpl.s	.fdz2spec				; branch if flag was set to update in FDZ2 cutscene
		jsr	BGInit_Generic(pc)
		sf	(ScreenEvent_flag).w
		jmp	FGInit_Generic2(pc)

.fdz2spec
		jsr	InitFGCam				; get BG parameters at proper registers
		clr.b	ScreenEvent_flag.w
		move.w	#224,d5					; load bottom-most row
		bsr.s	.load
		move.w	#224-16,d5				; load the row before
		bsr.s	.load
		move.w	#224-16-16,d5				; and before that

.load
		moveq	#(512/16)-1,d6				; load entire row
		moveq	#0,d4					; x-position
		add.w	Camera_Y_Pos.w,d5			; add camera y-pos to d5
		and.w	#$F0,d5					; keep in range
		jmp	DrawRow_Generic2			; load generic position
; ---------------------------------------------------------------------------

FDZ1_BackgroundEvent:
		tst.b	(BackgroundEvent_flag).w
		beq.w	.continue
		bmi.s	.loadkos				; load initial kosinski module data

		tst.w	Kos_modules_left.w			; wait until kosinski modules have loaded
		bne.w	.continue
		sf	BackgroundEvent_flag.w			; disable transition flag

		movem.l	d7-a0/a2-a3,-(sp)
		move.b	#1,Current_Act.w			; change to act 2
		move.w	Current_zone.w,Transition_Zone.w	; update transition zone to current zone
		jsr	Restart_LevelData			; load various level related data
		jsr	SaveZoneSRAM				; save zone/act to SRAM

		moveq	#0,d0					; x-offset
		moveq	#0,d1					; y-offset
		jsr	Reset_ObjectsPosition			; move objects backwards, so they line up with act 2

		jsr	(Change_ActSizes).w			; Set level size
		jsr	(Restore_PlayerControl).w
		lea	(PLC_Main2).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
		clr.b	(Ctrl_1_locked).w
		clr.b	(Level_end_flag).w
		clr.b	(Last_star_post_hit).w

		; check EX flag
		tst.b	(Extended_mode).w
		bne.s	.eskip
		move.b	#1,(HUD_State).w			; enable HUD

.eskip
		move.b	#30,(Player_1+air_left).w	; Reset air
		jsr	(Obj_PlayLevelMusic).w		; Play music

		movem.l	(sp)+,d7-a0/a2-a3

	;	st	ScreenEvent_flag.w			; reload BG and FG mappings (not actually required)
		jsr	Reset_TileOffsetPositionActual
		bra.s	.continue

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 2 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	FDZ2_128x128_Kos,a1			; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	FDZ2_8x8_KosM,a1			; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#FDZ2_16x16_Unc,Block_table_addr_ROM.w	; update block table address
		movem.l	(sp)+,d7-a0/a2-a3

.continue
		bsr.s	FDZ_Deform
		jsr	BGScroll_SimpleFull(pc)
		jmp	ShakeScreen_Setup
; ---------------------------------------------------------------------------

FDZ_BackgroundInit:
		pea	BGInit_Generic(pc)			; initialize BG last

FDZ_Deform:
	; update BG y-position (note, this code would be simpler if not for the MoveBG1 routine!)
		moveq	#0,d3
		move.w	CamYBG.w,d3				; load last y-pos
		swap	d3					; swap to high word

		move.w	CamYFGcopy.w,d1				; load camera y-position to d0
		asr.w	#5,d1					; divide by 8 (y-scroll speed)
		move.w	d1,CamYBG.w				; save as the background y-pos

		moveq	#0,d0
		move.w	d1,d0
		swap	d0					; needed for the below code
		jsr	(MoveBG1.y+$10).w			; set bg1 scroll flags for scroll engine

	; process BG
		lea	v_deformtablebuffer.w,a1		; get destination buffer to a1
		move.w	v_screenposx.w,d0			; load fg x-pos to d0
		add.w	(HScroll_Shift+2).w,d0
		clr.w	(a1)+					; moon does not move

		asr.w	#2,d0					; get 25% of x-pos to d0
		move.w	d0,d1					; copy to d1
		asr.w	#2,d1					; get 6.25% of x-pos to d1
		add.w	d1,d0					; get 31.25% of x-pos to d0 (= $50/$100)

		tst.b	Current_Act.w				; check if act is 1
		beq.s	.is1					; if so, branch
		add.w	#$80,d0					; shift by $80 pixels (accounts for act transition lol)

.is1
		move.w	d0,(a1)+				; save this as the forest position

		lea	.data(pc),a4
		lea	v_deformtablebuffer.w,a5
		jmp	ApplyDeformation			; apply deformation to the level
; ---------------------------------------------------------------------------

.data		dc.w 176, $7FFF					; moon, forest
; ---------------------------------------------------------------------------

FDZ2_BackgroundEvent:
		tst.b	(BackgroundEvent_flag).w
		beq.w	.continue
		bmi.s	.loadkos				; load initial kosinski module data
		tst.w	Kos_modules_left.w			; wait until kosinski modules have loaded
		bne.w	.continue

		moveq	#0,d0					; x-offset
		move.w	#$200,d1				; y-offset
		jsr	Reset_ObjectsPosition2			; there is less room in start of act 3, so move up once again =(

		movem.l	d7-a0/a2-a3,-(sp)
		move.b	#2,Current_Act.w			; change to act 3
		jsr	Restart_LevelData			; load various level related data
		jsr	SaveZoneSRAM				; save zone/act to SRAM
		jsr	Change_ActSizes				; make ABSOLUTELY sure the act boundaries are actually correct
		movem.l	(sp)+,d7-a0/a2-a3

		bsr.w	FDZ3_RainInit				; init FDZ3 rain effect
		clr.b	BackgroundEvent_flag.w			; disable transition flag
		clr.b	NoBackgroundEvent_flag.w		; clear this flag
		clr.b	LastAct_end_flag.w
		clr.b	Sonic_NoKill.w
		jsr	Reset_TileOffsetPositionActual

		move.w	#$F0,DrawPlane_Position.w		; redraw entire BG plane bottom to top.
		move.w	#$F,DrawPlane_Count.w			; redraw this many rows
		bra.s	.continue

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 3 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	FDZ3_128x128_Kos,a1			; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	FDZ3_8x8_KosM,a1			; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#FDZ3_16x16_Unc,Block_table_addr_ROM.w	; update block table address
		movem.l	(sp)+,d7-a0/a2-a3

.continue
		bsr.w	FDZ_Deform
		jsr	BGScroll_SimpleFull(pc)
		bsr.s	FDZ2_BackgroundEvent_Resize
		jmp	ShakeScreen_Setup
; ---------------------------------------------------------------------------

FDZ2_BackgroundEvent_Resize:
		moveq	#0,d0
		move.b	(BackgroundEvent_routine).w,d0
		move.w	FDZ2_BackgroundEvent_Resize_Index(pc,d0.w),d0
		jmp	FDZ2_BackgroundEvent_Resize_Index(pc,d0.w)
; ---------------------------------------------------------------------------

FDZ2_BackgroundEvent_Resize_Index: offsetTable
		offsetTableEntry.w FDZ2_BackgroundEvent_Resize_Return		; 0
		offsetTableEntry.w FDZ2_BackgroundEvent_Resize_Fix			; 2
		offsetTableEntry.w FDZ2_BackgroundEvent_Resize_SpeedUp	; 4
		offsetTableEntry.w FDZ2_BackgroundEvent_Resize_Scroll		; 6
		offsetTableEntry.w FDZ2_BackgroundEvent_Resize_Slowdown	; 8
; ---------------------------------------------------------------------------

FDZ2_BackgroundEvent_Resize_Fix:
		addq.b	#2,(BackgroundEvent_routine).w
		st	(ScreenEvent_flag).w
		moveq	#id_Walk,d0
		cmp.b	(Player_1+anim).w,d0
		beq.s	FDZ2_BackgroundEvent_Resize_SpeedUp
		move.b	d0,(Player_1+anim).w

FDZ2_BackgroundEvent_Resize_SpeedUp:
		addi.w	#8*2,hscroll_shift.w
		cmpi.w	#$600,hscroll_shift.w
		bne.s	FDZ2_BackgroundEvent_Resize_Scroll
		addq.b	#2,(BackgroundEvent_routine).w
		addq.b	#2,(Dynamic_resize_routine).w

FDZ2_BackgroundEvent_Resize_Scroll:
		moveq	#0,d0
		move.w	hscroll_shift.w,d0
		asl.l	#8,d0
		add.l	d0,hscroll_shift+2.w
		lea	v_hscrolltablebuffer.w,a1
		move.w	hscroll_shift+2.w,d0
		neg.w	d0
		move.w	#bytesToXcnt(224,8),d1

-	rept 8
		move.w	(a1),d2
		add.w	d0,d2
		move.w	d2,(a1)
		addq.w	#4,a1
	endm
		dbf	d1,-

FDZ2_BackgroundEvent_Resize_Return:
		rts
; ---------------------------------------------------------------------------

FDZ2_BackgroundEvent_Resize_Slowdown:
		subq.w	#8,hscroll_shift.w
		tst.w	hscroll_shift.w
		bne.s	FDZ2_BackgroundEvent_Resize_Scroll
		clr.b	(BackgroundEvent_routine).w
		addq.b	#2,(Dynamic_resize_routine).w
		bra.s	FDZ2_BackgroundEvent_Resize_Scroll
; ===========================================================================
; ---------------------------------------------------------------------------
; FDZ 3 Events
; ---------------------------------------------------------------------------

FDZ3_ScreenInit:
		jsr	FGInit_Generic(pc)
; ---------------------------------------------------------------------------

FDZ3_RainInit:
	clearRAM ExtraSpriteBuffer, ExtraSpriteBuffer_End	; clear buffer RAM
		move.l	#ExtraRt_FDZ3RainFront,ExtraSpriteRoutineFirst.w; set extra routine
		move.l	#ExtraRt_FDZ3RainBack,ExtraSpriteRoutineLast.w	; set extra routine
		move.w	#$0103,ExtraSpriteBuffer+4.w		; reset delays so that the code alternates loading front and back rain

		move.w	#(rain_frontmax<<8)|rain_backmax,ExtraSpriteBuffer.w; set maximum number of particles
		tst.w	(Seizure_Flag).w			; check seizure flag
		beq.s	.skip					; if not set, skip
		move.w	#$202,ExtraSpriteBuffer.w		; load only at most 3 particles!

.skip
		rts
; ---------------------------------------------------------------------------

FDZ3_BackgroundEvent:
		move.w	BackgroundEvent_routine.w,d0		; get routine number of bg event
		jmp	.routines(pc,d0.w)			; jump to the right handler

; ---------------------------------------------------------------------------
.routines	bra.w	.redrawbg				; $00, redraw BG plane
		bra.w	.normal					; $04, normal
; ---------------------------------------------------------------------------

.redrawbg
		jsr	InitBGCam				; get BG parameters at proper registers
		moveq	#$40-1,d6				; number of tiles to redraw
		moveq	#0,d4					; x-position
		moveq	#0,d3					; y-position
		jsr	DrawPlane_SlowFromBottom2		; redraw entire BG plane
		bpl.s	.normal					; branch if did not finish
		addq.w	#4,BackgroundEvent_routine.w		; increase routine counter if did
; ---------------------------------------------------------------------------

.normal
		tst.b	(BackgroundEvent_flag).w
		beq.w	.continue
		bmi.s	.loadkos				; load initial kosinski module data
		tst.w	Kos_modules_left.w			; wait until kosinski modules have loaded
		bne.w	.continue
		sf	BackgroundEvent_flag.w			; disable transition flag

		movem.l	d7-a0/a2-a3,-(sp)
		move.b	#3,Current_Act.w			; change to act 4
		move.w	Current_zone.w,Transition_Zone.w	; update transition zone to current zone
		jsr	Restart_LevelData			; load various level related data
		jsr	SaveZoneSRAM				; save zone/act to SRAM
		movem.l	(sp)+,d7-a0/a2-a3

		moveq	#0,d0					; x-offset
		moveq	#0,d1					; y-offset
		jsr	Reset_ObjectsPosition			; move objects backwards, so they line up with act 4
	;	st	ScreenEvent_flag.w			; reload BG and FG mappings (not actually required)
		jsr	Reset_TileOffsetPositionActual
		bra.s	.continue
; ---------------------------------------------------------------------------

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 4 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	FDZ3_128x128_Kos,a1			; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	FDZ3_8x8_KosM,a1			; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#FDZ3_16x16_Unc,Block_table_addr_ROM.w	; update block table address
		movem.l	(sp)+,d7-a0/a2-a3

.continue
		bsr.w	FDZ3_Deform
		jsr	BGScroll_SimpleFull(pc)
		jmp	ShakeScreen_Setup
; ---------------------------------------------------------------------------

FDZ3_BackgroundInit:
		tst.b	(Last_star_post_hit).w			; was starpost hit
		sne	FDZ3Rain_Spawn.w			; if yes, set flag
		beq.s	.norain					; if yes, load the rain now
		jsr	FDZ3_LoadRainPalette2			; AF: Load rain palette with custom routine

.norain
		move.w	#4,BackgroundEvent_routine.w		; set default routine to $04; $00 is used for transition
		pea	BGInit_Generic(pc)			; initialize BG last
; ---------------------------------------------------------------------------

FDZ3_Deform:
	; update BG y-position (note, this code would be simpler if not for the MoveBG1 routine!)
		moveq	#0,d3
		move.l	CamYBG.w,d3				; load last y-pos

		move.w	CamYFGcopy.w,d1				; load camera y-position to d0
		asr.w	#6,d1					; divide by 8 (y-scroll speed)
		move.w	d1,CamYBG.w				; save as the background y-pos

		moveq	#0,d0
		move.w	d1,d0
		swap	d0					; needed for the below code
		jsr	(MoveBG1.y+$10).w			; set bg1 scroll flags for scroll engine

	; process BG
		lea	v_deformtablebuffer.w,a1		; get destination buffer to a1
		move.l	v_screenposx.w,d0			; load fg x-pos to d0
		asr.l	#2,d0					; get 25% to d0 ($40)

	; leaves & forest
		move.l	d0,d1					; copy 25% to d1
		move.l	d0,d2					; copy 25% to d2
		asr.l	#3,d1					; get 3.125% to d1 ($08)
		add.l	d1,d0					; get 28.125% to d0 ($48)

		swap	d2					; swap low word for write
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; save 28.125% that as leaves position
		move.w	d2,(a1)+				; save 25% as forest position
		swap	d0					; swap low word for calculation

	; grass
		move.l	d1,d2					; copy 3.125% to d2 ($08)
		asr.l	#1,d2					; get 1.5625% to d2 ($04)
		sub.l	d2,d0					; get 26.5625% to d0 ($44)

		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass1 position
		swap	d0					; swap low word for calculation

		add.l	d1,d0					; get 29.6875% to d0 ($4C)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass2 position
		swap	d0					; swap low word for calculation

		add.l	d1,d0					; get 31.25% to d4 ($50)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass3 position
		swap	d0					; swap low word for calculation

		add.l	d2,d0					; get 32.8125% to d4 ($54)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass4 position
		swap	d0					; swap low word for calculation

		add.l	d1,d0					; get 35.9375% to d4 ($5C)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass5 position
		swap	d0					; swap low word for calculation

		add.l	d2,d0					; get 37.5% to d4 ($60)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass6 position
		swap	d0					; swap low word for calculation

		add.l	d2,d0					; get 39.0625% to d4 ($64)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass47position
		swap	d0					; swap low word for calculation

		add.l	d1,d0					; get 42.1875% to d4 ($6C)
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as the grass8 position


	; apply the deformation
		lea	.data(pc),a4
		lea	v_deformtablebuffer.w,a5
		jmp	ApplyDeformation			; apply deformation to the level
; ---------------------------------------------------------------------------

.data		dc.w 56, 136, 8, 8, 8, 8, 8, 8, $7FFF		; Leaves, Forest, Grass
; ===========================================================================
; ---------------------------------------------------------------------------
; FDZ3 rain renderer
; ---------------------------------------------------------------------------

rain_frame =		$00		; mapping frame of rain
rain_x =		$02		; x-position of rain
rain_y =		$04		; y-position of rain
rain_size =		$06		; size of each rain particle

rain_frontmax =		10		; max number of rain particles
RainSprite_Front =	ExtraSpriteBuffer+6
rain_backmax =		12		; max number of rain particles
RainSprite_Back =	RainSprite_Front+(rain_size*rain_frontmax)

	if RainSprite_Back+(rain_size*rain_backmax) > ExtraSpriteBuffer_End
		fatal "FDZ3 rain data requires more RAM than is available!"
	endif
; ---------------------------------------------------------------------------

ExtraRt_FDZ3RainBack:
		lea	RainSprite_Back.w,a0		; load sprite buffer data to a0
		tst.b	FDZ3Rain_Spawn.w		; check if rain is supposed to spawn
		beq.s	.process			; if not, branch

		lea	ExtraSpriteBuffer+1.w,a1	; load sprite params to a1
		moveq	#9,d2				; frame offset
		jsr	ExtraRt_FDZ3RainSpawn(pc)	; run spawning algorithm

.process
		moveq	#rain_backmax-1,d2		; load max number to d2
		lea	ExtraSpriteBuffer+3.w,a1	; load sprite counts to a1
		bra.s	ExtraRt_FDZ3RainProc
; ---------------------------------------------------------------------------

ExtraRt_FDZ3RainFront:
		lea	RainSprite_Front.w,a0		; load sprite buffer data to a1
		tst.b	FDZ3Rain_Spawn.w		; check if rain is supposed to spawn
		beq.s	.process			; if not, branch

		lea	ExtraSpriteBuffer.w,a1		; load sprite params to a1
		moveq	#1,d2				; frame offset
		jsr	ExtraRt_FDZ3RainSpawn(pc)	; run spawning algorithm

.process
		moveq	#rain_frontmax-1,d2		; load max number to d2
		lea	ExtraSpriteBuffer+2.w,a1	; load sprite counts to a1
; ---------------------------------------------------------------------------

ExtraRt_FDZ3RainProc:
		tst.w	d7				; check if there are more space for sprites
		bpl.s	.nextp				; if yes, then process them
		rts

.nextp
	; check if it needs to be deleted
		tst.w	rain_frame(a0)			; check if particle exists
		beq.s	.skipp				; branch if not
		cmp.w	#$80-$10,rain_x(a0)		; check if rain is already invisible horizontally
		blo.s	.delete				; if so, delete
		cmp.w	#$80+224,rain_y(a0)		; check if rain is already invisible vertically
		blo.s	.normv				; if so, delete

.delete
		subq.b	#1,(a1)				; remove particle from list
		clr.w	rain_frame(a0)			; clear frame
; ---------------------------------------------------------------------------

.skipp
		addq.w	#rain_size,a0			; goto next particle
		dbf	d2,.nextp			; process it
		rts
; ---------------------------------------------------------------------------

.normv
	; calculate speeds
		subq.w	#6,rain_x(a0)			; decrease x-position
		addq.w	#6,rain_y(a0)			; increase y-position
; ---------------------------------------------------------------------------

	; render particle
		move.w	rain_y(a0),(a6)+		; save y-pos to sprite table
		move.w	rain_frame(a0),d0		; load mappings frame to d0
		move.b	FDZ3Rain_Size-1(pc,d0.w),(a6)	; set sprite size to 8x8

		addq.w	#2,a6				; skip link parameter
		move.w	FDZ3Rain_Art-1(pc,d0.w),(a6)+	; save tile address to table
		move.w	rain_x(a0),(a6)+		; save x-pos to sprite table
; ---------------------------------------------------------------------------

	; go to next object
		addq.w	#rain_size,a0			; goto next particle
		subq.w	#1,d7				; decrease piece count
		dbmi	d2,.nextp			; process more if piece count is ok
		rts
; ---------------------------------------------------------------------------

FDZ3Rain_Size:
		dc.w $0500, $0500, $0000, $0000
		dc.w $0500, $0500, $0000, $0000
FDZ3Rain_Art:
		dc.w $E4E0, $E4E0, $E4E4, $E4E5
		dc.w $64E0, $64E0, $64E4, $64E5
; ---------------------------------------------------------------------------

ExtraRt_FDZ3RainSpawn:
		move.b	(a1),d0				; load max num of particles to d0
		cmp.b	2(a1),d0			; check if already loaded that many particles
		ble.s	.rts				; if so, skip to processing them

		subq.b	#1,4(a1)			; decrease delay
		bgt.s	.rts				; if positive still, skip
		jsr	Random_Number			; get random number
		and.b	#3,d0				; get a range in d0
		addq.b	#3,d0				; range of 3 to 6 frames
		move.b	d0,4(a1)			; save as new delay
; ---------------------------------------------------------------------------

	; find slot for particle (warning, if there is mismatch with particle counter, this WILL break)
		addq.b	#1,2(a1)			; add object as loaded
		lea	-rain_size(a0),a1		; copy sprites data to a0

.ploop
		addq.w	#rain_size,a1			; go to next particle data
		tst.w	(a1)				; check if loaded
		bne.s	.ploop				; if is, go to next one
; ---------------------------------------------------------------------------

	; load particle here
		jsr	Random_Number			; get random number
		andi.w	#$1FF,d0			; keep in range
		add.w	#$80,d0				; offset by the sprite plane
		move.w	d0,rain_x(a1)			; save as rain x-position
		move.w	#$80-$20,rain_y(a1)		; save default rain y-position

		swap	d0				; swap random words
		andi.w	#6,d0				; keep in range
		add.w	d2,d0				; add frame offset and set as loaded
		move.w	d0,rain_frame(a1)		; save rain timer and animation frame

.rts
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; SCZ Events
; ---------------------------------------------------------------------------

SCZ1_ScreenInit:
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts
		jmp	FGInit_Generic(pc)
; ---------------------------------------------------------------------------

SCZ1_ScreenEvent:
		tst.b	(ScreenEvent_flag).w
		bne.s	SCZ1_ScreenEvent_RefreshPlane
		move.w	(Screen_Shaking_Flag+2).w,d0
		add.w	d0,(Camera_Y_pos_copy).w
		jmp	FGScroll_Generic(pc)			; update FG maps (generic)
; ---------------------------------------------------------------------------

SCZ1_ScreenEvent_RefreshPlane:
		bpl.s	.fgonly
		jsr	FGInit_Generic2(pc)

.fgonly
		sf	(ScreenEvent_flag).w
		jmp	BGInit_Generic(pc)

; =============== S U B R O U T I N E =======================================

SCZ1_BackgroundEvent:
		tst.b	(BackgroundEvent_flag).w
		beq.w	.normal
		bmi.s	.loadkos							; load initial kosinski module data
		tst.w	Kos_modules_left.w				; wait until kosinski modules have loaded
		bne.w	.normal




		moveq	#PalID_SCZ2,d0
		jsr	LoadPalette_Immediate				; load SCZ2 palette

		movem.l	d7-a0/a2-a3,-(sp)
		move.b	#1,Current_Act.w					; change to act 2
		move.w	Current_zone.w,Transition_Zone.w	; update transition zone to current zone
		clr.w	AstarothCompleted.w				; set all bosses as not completed
		clr.l	(CamXBG).w							; fix BG Xpos
		clr.l	(CamYBG).w							; fix BG Ypos
		jsr	Restart_LevelData						; load various level related data
		jsr	SaveZoneSRAM				; save zone/act to SRAM
;		jsr	Change_ActSizes						; make ABSOLUTELY sure the act boundaries are actually correct
		jsr	WaterTrigger_CheckWaterPos			; for panel
		movem.l	(sp)+,d7-a0/a2-a3


		moveq	#0,d0							; x-offset
		move.w	#$400,d1						; y-offset
		jsr	Reset_ObjectsPosition					; move objects backwards, so they line up with act 2


		clr.b	BackgroundEvent_flag.w				; disable transition flag
		jsr	Reset_TileOffsetPositionActual

;		addq.b	#1,ScreenEvent_flag.w				; reload BG

		bsr.s	.normal

		jmp	BGInit_Generic
; ---------------------------------------------------------------------------

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 2 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	SCZ2_128x128_Kos,a1					; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	SCZ2_8x8_KosM,a1					; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#SCZ2_16x16_Unc,Block_table_addr_ROM.w	; update block table address

		movem.l	(sp)+,d7-a0/a2-a3

.normal
		bsr.s	SCZ1_Deform
		jsr	BGScroll_SimpleFull(pc)
		jmp	ShakeScreen_Setup
; ---------------------------------------------------------------------------

SCZ1_BackgroundInit:
		pea	BGInit_Generic(pc)			; initialize BG last

SCZ1_Deform:
	; update BG y-position (note, this code would be simpler if not for the MoveBG1 routine!)
		moveq	#0,d3
		move.w	CamYBG.w,d3				; load last y-pos
		swap	d3					; swap to high word

		move.w	CamYFGcopy.w,d1				; load camera y-position to d0
		asr.w	#5,d1					; divide by 8 (y-scroll speed)
		move.w	d1,CamYBG.w				; save as the background y-pos

		moveq	#0,d0
		move.w	d1,d0
		swap	d0					; needed for the below code
		jsr	(MoveBG1.y+$10).w			; set bg1 scroll flags for scroll engine

	; process BG
		lea	v_deformtablebuffer.w,a1		; get destination buffer to a1
		clr.w	(a1)+					; clouds do not scroll
		move.l	v_screenposx.w,d0			; load fg x-pos to d0
		asr.l	#3,d0					; get 12.5% to d0 ($20)
		move.l	d0,d1					; copy to d1
		asr.l	#2,d1					; get 3.125% to d1 ($08)

	; prepare for later
		move.l	d1,d4					; copy to d4
		asr.l	#1,d4					; get 1.5625% to d4 ($04)
		neg.l	d4					; negate it, -1.5625%
		add.l	d0,d4					; add 12.5% to d4

	; buildings
		swap	d1					; swap low word for write
		move.w	d1,(a1)+				; save this as the buildings position

	; clouds
		move.w	v_framecount.w,d3			; get frame count to d4 (all other positions are moving by itself)
		move.w	d3,d2					; copy to d2 for later
		add.w	d2,d2					; double frame count

		add.w	d1,d2					; add a little offset depending on scrolling
		ror.w	#2,d2					; shift down by 2 bits
		sub.w	d3,d2					; substract the frame count from result

		and.w	#1,d3					; get bit 0 of frame count
		addq.w	#1,d3					; add 1 to it (results in either 0 or 1)
		lsr.w	d3,d2					; shift right by that amount of bits

		moveq	#0,d3					; prepare high word to 0
		and.w	#$7F,d2					; get in-range positions
		lea	.cloud(pc),a4				; load cloud deform data to a4
		add.w	d2,a4					; add offset to table

	rept 13
		move.b	(a4)+,d3				; load offset to d3
		sub.w	d3,(a1)+				; add to cloud position
	endm

	rept 9
		move.b	(a4)+,d3				; load offset to d3
		add.w	d3,(a1)+				; add to cloud position
	endm

	; ground
		swap	d4					; swap low word for write
		move.w	d4,(a1)+				; save 12.5% as ground position


	; prepare lava
		move.w	v_framecount.w,d0			; get frame count to d0 (all other positions are moving by itself)
		swap	d0					; swap low word for calculation
		asr.l	#1,d0					; halve it

		swap	d0					; swap low word for calculation
		add.w	v_framecount.w,d0			; add frame count to d0 (all other positions are moving by itself)
		swap	d0					; swap low word for calculation
		add.l	v_screenposx.w,d0			; add fg x-pos to d0

		asr.l	#3,d0					; get 12.5% to d0 ($20)
		move.l	d0,d1					; copy to d1
		asr.l	#3,d1					; get 3.125% to d1 ($04)

	; lava
	rept 6
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; save d0 as lava position, 12.5%
		swap	d0					; swap low word for calculation
		add.l	d1,d0					; add to 1.5625% to d0
	endm

		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; save d0 as lava position

		lea	.data(pc),a4
		lea	v_deformtablebuffer.w,a5
		jmp	ApplyDeformation			; apply deformation to the level
; ---------------------------------------------------------------------------

; Algorithm for cloud deformation data:

; int num = 0, last = 0;
;
; for(int i = 0;i < 0xA0;i ++){
;   int r = 0;
;
;   // this code loops until the difference between r and last is no more than 1
;   // and if the same number wasnt repeated more than twice
;   // possible outputs are only 0 and 1, but 1 is more likely
;   do {
;     r = (int)((Math.random() * 1.7) + .3);
;   } while(Math.abs(r - last) > 1 || (last == r && num >= 1));
;
;   // r is the next number to output
;   num = last == r ? num + 1 : 0;
;   last = r;
; }

.cloud		dc.b 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0	; $10
		dc.b 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0	; $20
		dc.b 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0	; $30
		dc.b 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0	; $40
		dc.b 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1	; $50
		dc.b 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1	; $60
		dc.b 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1	; $70
		dc.b 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0	; $80
		dc.b 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1	; $90
		dc.b 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0	; $A0

.data		dc.w 20, 92, $800C, 6, $8009, 53		; moon, buildings, clouds, ground
		dc.w 5, 5, 10, 10, 10, 10, $7FFF		; lava
; ---------------------------------------------------------------------------

SCZ1_Transition:
		sf	(BackgroundEvent_flag).w
		rts

; =============== S U B R O U T I N E =======================================

SCZ2_BackgroundEvent:
		tst.b	(BackgroundEvent_flag).w
		beq.w	.normal
		bmi.s	.loadkos							; load initial kosinski module data
		tst.w	Kos_modules_left.w				; wait until kosinski modules have loaded
		bne.w	.normal

		moveq	#PalID_SCZ2,d0
		jsr	LoadPalette_Immediate				; load SCZ3 palette

		movem.l	d7-a0/a2-a3,-(sp)
		clr.w	AstarothCompleted.w				; set all bosses as not completed
		clr.l	(CamXBG).w							; fix BG Xpos
		clr.l	(CamYBG).w							; fix BG Ypos
		jsr	Restart_LevelData
		lea	(PLC_MainSCZ3).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		jsr	(LoadPLC_KosM).w
		jsr	(LoadPLC2_KosM).w
		movem.l	(sp)+,d7-a0/a2-a3

		move.w	#$3500,d0						; hardcoded x-offset
		move.w	#-$300,d1
		jsr	Reset_ObjectsPosition2

		clr.b	BackgroundEvent_flag.w				; disable transition flag

		jsr	Change_ActSizes
		jsr	Reset_TileOffsetPositionActual

		bsr.s	.normal

		jmp	BGInit_Generic
; ---------------------------------------------------------------------------

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 3 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	SCZ3_128x128_Kos,a1					; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	SCZ3_8x8_KosM,a1					; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#SCZ3_16x16_Unc,Block_table_addr_ROM.w	; update block table address

		movem.l	(sp)+,d7-a0/a2-a3

.normal
		bsr.s	Do_ShakeSound
		bsr.s	SCZ2_Deform
		jsr	BGScroll_SimpleFull
		jmp	ShakeScreen_Setup

; =============== S U B R O U T I N E =======================================

Do_ShakeSound:
		cmpi.b	#6,(Player_1+routine).w
		bhs.s	locret_512A4					; If dying, skip this

		tst.w	(Screen_shaking_sound).w
		beq.s	locret_512A4					; If screen is not shaking continuously, skip this
		subq.w	#1,(Screen_shaking_sound).w

		move.w	(Level_frame_counter).w,d0
		subq.w	#1,d0
		andi.w	#$F,d0
		bne.s	locret_512A4
		sfx	sfx_SpecialRumble

locret_512A4:
		rts
; ---------------------------------------------------------------------------

SCZ2_BackgroundInit:
		pea	BGInit_Generic(pc)				; initialize BG last
		jsr	WaterTrigger_CheckWaterPos		; for panel

SCZ2_Deform:
	; update BG y-position (note, this code would be simpler if not for the MoveBG1 routine!)
		moveq	#0,d3
		move.w	CamYBG.w,d3				; load last y-pos
		swap	d3							; swap to high word

		move.w	CamYFGcopy.w,d1				; load camera y-position to d0
		asr.w	#3,d1						; divide by 8 (y-scroll speed)
		move.w	d1,CamYBG.w				; save as the background y-pos

		moveq	#0,d0
		move.w	d1,d0
		swap	d0							; needed for the below code
		jsr	(MoveBG1.y+$10).w				; set bg1 scroll flags for scroll engine

	; process BG
		lea	v_deformtablebuffer.w,a1			; get destination buffer to a1

; pentagram
		clr.w	(a1)+						; pentagram do not scroll

		move.l	v_screenposx.w,d0
		asr.l	#5,d0

; clouds 1
		move.l	d0,d1
		move.l	d0,d2
		move.w	v_framecount.w,d3
		swap	d3
		clr.w	d3
		move.l	d3,d4
		lsr.l	#2,d3
		add.l	d3,d1
		swap	d1
		move.w	d1,(a1)+

; clouds 2
		lsr.l	#1,d4
		add.l	d4,d2
		swap	d2
		move.w	d2,(a1)+

; clouds 3
		move.l	d0,d1
		move.l	d0,d2
		add.l	d3,d1
		swap	d1
		move.w	d1,(a1)+

; clouds 4
		lsr.l	#1,d3
		add.l	d3,d2
		swap	d2
		move.w	d2,(a1)+

; clouds 5
		move.l	d0,d1
		move.l	d0,d2
		lsr.l	#1,d3
		add.l	d3,d1
		swap	d1
		move.w	d1,(a1)+

; clouds 6
		lsr.l	#2,d3
		add.l	d3,d2
		swap	d2
		move.w	d2,(a1)+

; pillars
		swap	d0
		move.w	d0,(a1)+

; pillars 2
		lea	SCZ1_Deform.cloud(pc),a4
		move.w	v_framecount.w,d2
		lsr.w	#3,d2
		moveq	#128-1,d4
		moveq	#bytesToXcnt(48,8),d3

-
	rept 8
		and.w	d4,d2
		move.b	(a4,d2.w),d1
		ext.w	d1
		add.w	d0,d1
		move.w	d1,(a1)+
		addq.b	#1,d2
	endr
		dbf	d3,-

; Water
		move.w	v_framecount.w,d0			; get frame count to d0 (all other positions are moving by itself)
		swap	d0							; swap low word for calculation
		asr.l	#1,d0							; halve it

		swap	d0							; swap low word for calculation
		add.w	v_framecount.w,d0			; add frame count to d0 (all other positions are moving by itself)
		swap	d0							; swap low word for calculation
		add.l	v_screenposx.w,d0			; add fg x-pos to d0

		asr.l	#3,d0							; get 12.5% to d0 ($20)
		move.l	d0,d1						; copy to d1
		asr.l	#3,d1							; get 3.125% to d1 ($04)

	; water
	rept 6
		swap	d0							; swap low word for write
		move.w	d0,(a1)+						; save d0 as lava position, 12.5%
		swap	d0							; swap low word for calculation
		add.l	d1,d0						; add to 1.5625% to d0
	endm

		swap	d0							; swap low word for write
		move.w	d0,(a1)+						; save d0 as lava position

		lea	.data(pc),a4
		lea	v_deformtablebuffer.w,a5
		jmp	ApplyDeformation				; apply deformation to the level
; ---------------------------------------------------------------------------

.data
		dc.w 112, 18, 32, 18, 8, 34, 16, 54, $8000+48		; pentagram, clouds, clouds 2, clouds 3, clouds 4, clouds 5, clouds 6, pillars, pillars 2
		dc.w 5, 5, 5, 5, 5, 5, 5, $7FFF						; water
; ===========================================================================
; ---------------------------------------------------------------------------
; GMZ1 Events
; ---------------------------------------------------------------------------

GMZ_ScreenInit:
	clearRAM ExtraSpriteBuffer, ExtraSpriteBuffer_End	; clear buffer RAM
		move.l	#ExtraRt_GMZEmbersFront,ExtraSpriteRoutineFirst.w; set extra routine
		move.l	#ExtraRt_GMZEmbersBack,ExtraSpriteRoutineLast.w	; set extra routine
		move.b	#120,MGZEmbers_Spawn.w			; enable spawning after some time
		clr.w	DPLC_SlottedRAM.w			; clear slotted RAM
		jmp	FGInit_Generic(pc)
; ---------------------------------------------------------------------------

GMZ1_FgLine_Offsets	macro off
	dc.w (($00-off)&$1F)*2, (($01-off)&$1F)*2, (($06-off)&$1F)*2, (($0B-off)&$1F)*2, (($17-off)&$1F)*2, (($1A-off)&$1F)*2, (($1B-off)&$1F)*2
	endm

GMZ1_BackgroundEvent:
		tst.b	(BackgroundEvent_flag).w
		beq.w	.notrans
		bmi.s	.loadkos				; load initial kosinski module data
		tst.w	Kos_modules_left.w			; wait until kosinski modules have loaded
		bne.w	.normal					; if not, do normal things

		move.w	#$3600,d0				; x-offset
		move.w	#-$200,d1				; y-offset
		jsr	Reset_ObjectsPosition3			;

		moveq	#PalID_GMZ2,d0
		jsr	LoadPalette_Immediate			; load GMZ2 palette
		move.w	#$7C,Layout_row_index_mask.w		; swap layout mask back to $7C (GMZ1 used $3C)

		movem.l	d7-a0/a2-a3,-(sp)
		move.b	#1,Current_Act.w			; change to act 2
		move.w	Current_zone.w,Transition_Zone.w	; update transition zone to current zone
		clr.w	AstarothCompleted.w			; set all bosses as not completed
		jsr	Restart_LevelData			; load various level related data
		jsr	SaveZoneSRAM				; save zone/act to SRAM
	;	jsr	Change_ActSizes				; make ABSOLUTELY sure the act boundaries are actually correct
		movem.l	(sp)+,d7-a0/a2-a3

		clr.b	BackgroundEvent_flag.w			; disable transition flag
		jsr	Reset_TileOffsetPositionActual
		addq.b	#1,ScreenEvent_flag.w			; reload BG
		bra.s	.normal

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 3 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	GMZ2_128x128_Kos,a1			; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	GMZ2_8x8_KosM,a1			; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#GMZ2_16x16_Unc,Block_table_addr_ROM.w	; update block table address
		movem.l	(sp)+,d7-a0/a2-a3
		bra.s	.normal
; ---------------------------------------------------------------------------

.notrans
		tst.b	Lava_Event.w				; NAT: Check if lava event is active
		beq.s	.normal					; branch if not
		move.w	Water_level.w,d0			; get the lava y-position to d0
		sub.w	CamYFG.w,d0				; substract the camera y-position from it

		cmp.w	#224,d0					; check if the lava is too far down
		blt.s	.nocap					; if not, branch
		st	H_int_counter_command+1.w		; set interrupt position
		bra.s	.normal					; do not attempt updating deform table

.nocap
		move.b	d0,H_int_counter_command+1.w		; set interrupt position
		lea	v_hscrolltablebuffer.w,a1		; load deform table buffer to a1
		add.w	d0,a1					; add offset 4 times to the table address
		add.w	d0,a1					; this way, we are going to overwrite the correct area of the table
		add.w	d0,a1					; due to the instruction below, we are going to add it 4x
		add.w	d0,a1					; instead of shifting first

		move.w	#224-1,d1				; prepare to calculate num of scanlines to do
		sub.w	d0,d1					; sub the start y-position from max scanline count

		move.w	CamXFG.w,d0				; get camera x-pos to d0
		neg.w	d0					; negate it (creates the correct illusion)

.repeat
		move.w	d0,(a1)					; overwrite scroll position
		addq.w	#4,a1					; skip BG position
		dbf	d1, .repeat				; loop for all the remaining scanlines

.normal
		bsr.s	GMZ1_Deform
		jsr	BGScroll_SimpleFull(pc)
		jmp	ShakeScreen_Setup
; ---------------------------------------------------------------------------

GMZ1_BackgroundInit:
		pea	BGInit_Generic(pc)			; initialize BG last
		move.w	#$3C,Layout_row_index_mask.w		; make the level loop back at 16 chunks as opposed to 32. Makes so that chunk row 15 is also solid at the top of the level

		cmp.b	#8,Last_star_post_hit.w			; check if we are at the checkpoints after the werewolf boss
		blo.s	GMZ1_Deform				; in case we are, we MUST load the GMZ1 lava ourselves...
		jsr	SingleObjLoad				; NAT: Load the object to handle the lava.
		bne.s	GMZ1_Deform				; this object was made to simplify lava processing
		move.l	#Obj_GMZ1Lava,(a1)			; and make it more consistent

GMZ1_Deform:
	; update BG y-position (note, this code would be simpler if not for the MoveBG1 routine!)
		moveq	#0,d3
		move.l	CamYBG.w,d3				; load last y-pos

		move.w	CamYFGcopy.w,d1				; load camera y-position to d0
		asr.w	#5,d1					; divide by 8 (y-scroll speed)
		move.w	d1,CamYBG.w				; save as the background y-pos

		moveq	#0,d0
		move.w	d1,d0
		swap	d0					; needed for the below code
		jsr	(MoveBG1.y+$10).w			; set bg1 scroll flags for scroll engine

	; process BG
		lea	v_deformtablebuffer.w,a1		; get destination buffer to a1

	; hell shore
		move.l	v_screenposx.w,d0			; load fg x-pos to d0
		move.l	d0,d1					; copy to d1
		asr.l	#6,d1					; get 3.125% to d1 ($04)
		move.l	d1,d2					; copy to d2
		asr.l	#2,d1					; get 0.78125% to d1 ($01)
		sub.l	d1,d2					; get 2.34375 to d2 ($03)
		swap	d2					; swap low word for write
		move.w	d2,(a1)+				; save as the hell shore position

	; positions
		swap	d0					; swap low word for calculation
		add.w	v_framecount.w,d0			; add frame count to d0 (all other positions are moving by itself)
		swap	d0					; swap low word for calculation
		asr.l	#5,d0					; get 12.5% to d0 ($08)
		move.l	d0,d1					; copy to d1
		move.l	d0,d2					; copy to d2
		asr.l	#1,d2					; get 3.125% to d2 ($04)
		move.l	d2,d3					; copy to d3
		asr.l	#1,d3					; get 1.5625% to d3 ($02)

	; lava
	rept 4
		add.l	d2,d0					; increment speed by $04
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as lava position
		swap	d0					; swap low word for write
	endm

		add.l	d3,d2					; get 4.6875% to d2 ($06)

	rept 4
		add.l	d2,d0					; increment speed by $06
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as lava position
		swap	d0					; swap low word for write
	endm

	rept 4
		add.l	d1,d0					; increment speed by $08
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as lava position
		swap	d0					; swap low word for write
	endm

		add.l	d1,d0					; increment speed by $08
		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; set as lava position

	; apply the deformation
		lea	.data(pc),a4
		lea	v_deformtablebuffer.w,a5
		jsr	ApplyDeformation			; apply deformation to the level

	; deform foreground
		lea	(H_scroll_buffer).w,a1
		lea	.deformdelta(pc),a2
		lea	(a2),a3
		move.w	(Level_frame_counter).w,d1

		move.w	(Camera_Y_pos_copy).w,d0
		asr.w	#1,d1
		add.w	d0,d1
		add.w	d0,d1
		andi.w	#$3E,d1
		move.w	(a2,d1.w),d1
		adda.w	d1,a2

		move.w	(Camera_Y_pos_BG_copy).w,d0
		asr.w	#1,d1
		add.w	d0,d1
		add.w	d0,d1
		andi.w	#$3E,d1
		move.w	(a3,d1.w),d1
		adda.w	d1,a3

		movem.w	(a2),d0-d6				; load FG offsets to d0-d6
		moveq	#16*4,d7				; load row increment value
		bsr.s	.layer					; process fg layer

		sub.w	#(224*4)-(16*4)-2,a1			; adjust to do BG layer
		movem.w	(a3),d0-d6				; load BG offsets to d0-d6

.layer
	rept 13
		addq.w	#1,(a1,d0.w)				; add 1 to each location
		addq.w	#1,(a1,d1.w)
		addq.w	#1,(a1,d2.w)
		addq.w	#1,(a1,d3.w)
		addq.w	#1,(a1,d4.w)
		addq.w	#1,(a1,d5.w)
		addq.w	#1,(a1,d6.w)

		add.w	d7,a1
	endm

		addq.w	#1,(a1,d0.w)				; add 1 to each location
		addq.w	#1,(a1,d1.w)
		addq.w	#1,(a1,d2.w)
		addq.w	#1,(a1,d3.w)
		addq.w	#1,(a1,d4.w)
		addq.w	#1,(a1,d5.w)
		addq.w	#1,(a1,d6.w)
		rts
; ---------------------------------------------------------------------------

.data		dc.w 180, 5, 5, 5, 5, 7, 7, 7, 7, 10, 10, 10, 10, $7FFF; shore, lava
; ---------------------------------------------------------------------------

.deformdelta
		dc.w .def00-.deformdelta, .def01-.deformdelta, .def02-.deformdelta, .def03-.deformdelta
		dc.w .def04-.deformdelta, .def05-.deformdelta, .def06-.deformdelta, .def07-.deformdelta
		dc.w .def08-.deformdelta, .def09-.deformdelta, .def0A-.deformdelta, .def0B-.deformdelta
		dc.w .def0C-.deformdelta, .def0D-.deformdelta, .def0E-.deformdelta, .def0F-.deformdelta
		dc.w .def10-.deformdelta, .def11-.deformdelta, .def12-.deformdelta, .def13-.deformdelta
		dc.w .def14-.deformdelta, .def15-.deformdelta, .def16-.deformdelta, .def17-.deformdelta
		dc.w .def18-.deformdelta, .def19-.deformdelta, .def1A-.deformdelta, .def1B-.deformdelta
		dc.w .def1C-.deformdelta, .def1D-.deformdelta, .def1E-.deformdelta, .def1F-.deformdelta

.def00		GMZ1_FgLine_Offsets $00
.def01		GMZ1_FgLine_Offsets $01
.def02		GMZ1_FgLine_Offsets $02
.def03		GMZ1_FgLine_Offsets $03
.def04		GMZ1_FgLine_Offsets $04
.def05		GMZ1_FgLine_Offsets $05
.def06		GMZ1_FgLine_Offsets $06
.def07		GMZ1_FgLine_Offsets $07
.def08		GMZ1_FgLine_Offsets $08
.def09		GMZ1_FgLine_Offsets $09
.def0A		GMZ1_FgLine_Offsets $0A
.def0B		GMZ1_FgLine_Offsets $0B
.def0C		GMZ1_FgLine_Offsets $0C
.def0D		GMZ1_FgLine_Offsets $0D
.def0E		GMZ1_FgLine_Offsets $0E
.def0F		GMZ1_FgLine_Offsets $0F
.def10		GMZ1_FgLine_Offsets $10
.def11		GMZ1_FgLine_Offsets $11
.def12		GMZ1_FgLine_Offsets $12
.def13		GMZ1_FgLine_Offsets $13
.def14		GMZ1_FgLine_Offsets $14
.def15		GMZ1_FgLine_Offsets $15
.def16		GMZ1_FgLine_Offsets $16
.def17		GMZ1_FgLine_Offsets $17
.def18		GMZ1_FgLine_Offsets $18
.def19		GMZ1_FgLine_Offsets $19
.def1A		GMZ1_FgLine_Offsets $1A
.def1B		GMZ1_FgLine_Offsets $1B
.def1C		GMZ1_FgLine_Offsets $1C
.def1D		GMZ1_FgLine_Offsets $1D
.def1E		GMZ1_FgLine_Offsets $1E
.def1F		GMZ1_FgLine_Offsets $1F

; ===========================================================================
; ---------------------------------------------------------------------------
; GMZ2 Events
; ---------------------------------------------------------------------------

GMZ2_BackgroundEvent:
		tst.b	(BackgroundEvent_flag).w
		beq.w	.normal
		bmi.s	.loadkos				; load initial kosinski module data
		tst.w	Kos_modules_left.w			; wait until kosinski modules have loaded
		bne.w	.normal					; if not, do normal things

		move.w	#$2600,d0				; x-offset
		move.w	#$200,d1				; y-offset
		jsr	Reset_ObjectsPosition3			;

		moveq	#PalID_GMZ3,d0
		jsr	LoadPalette_Immediate			; load GMZ3 palette

		movem.l	d7-a0/a2-a3,-(sp)
		move.b	#2,Current_Act.w			; change to act 3
		move.w	Current_zone.w,Transition_Zone.w	; update transition zone to current zone
		clr.w	AstarothCompleted.w			; set all bosses as not completed
		jsr	Restart_LevelData			; load various level related data
		jsr	SaveZoneSRAM				; save zone/act to SRAM
		jsr	Change_ActSizes				; make ABSOLUTELY sure the act boundaries are actually correct
		movem.l	(sp)+,d7-a0/a2-a3

		clr.b	BackgroundEvent_flag.w			; disable transition flag
		jsr	Reset_TileOffsetPositionActual
		addq.b	#1,ScreenEvent_flag.w			; reload BG
		bra.s	.normal

.loadkos
		move.b	#$7F,BackgroundEvent_flag.w		; set transition flag to eventually load the rest of act 3 in
		movem.l	d7-a0/a2-a3,-(sp)

		lea	GMZ3_128x128_Kos,a1			; load chunks as Kosinski
		lea	RAM_Start,a2
		jsr	Queue_Kos

		lea	GMZ3_8x8_KosM,a1			; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	Queue_Kos_Module

		move.l	#GMZ3_16x16_Unc,Block_table_addr_ROM.w	; update block table address
		movem.l	(sp)+,d7-a0/a2-a3

.normal
		bsr.s	GMZ2_Deform
		jsr	BGScroll_SimpleFull(pc)
		jmp	ShakeScreen_Setup
; ---------------------------------------------------------------------------

GMZ2_BackgroundInit:
		move.w	#$FF00,v_deformtablebuffer+(4*8).w	; force reload BG top layer

GMZ_BackgroundInit:
		pea	BGInit_Generic(pc)			; initialize BG last

GMZ2_Deform:
	; update BG y-position (note, this code would be simpler if not for the MoveBG1 routine!)
		moveq	#0,d3
		move.l	CamYBG.w,d3				; load last y-pos

		move.w	CamYFGcopy.w,d1				; load camera y-position to d0
		asr.w	#3,d1					; divide by 8 (y-scroll speed)
		move.w	d1,CamYBG.w				; save as the background y-pos

		moveq	#0,d0
		move.w	d1,d0
		swap	d0					; needed for the below code
		jsr	(MoveBG1.y+$10).w			; set bg1 scroll flags for scroll engine

	; process BG
		lea	v_deformtablebuffer.w,a1		; get destination buffer to a1
		lea	v_deformtablebuffer+(2*8).w,a2		; get get shadow buffer to a2

	; positions
		move.l	v_screenposx.w,d0			; load fg x-pos to d0
		asr.l	#3,d0					; get 12.5% to d0 ($20)
		move.l	d0,d2					; copy to d2
		asr.l	#1,d2					; get 6.25% to d2 ($10)
		move.l	d2,d3					; copy to d3
		asr.l	#1,d3					; get 3.125% to d3 ($08)

	; apply scrolling
		move.l	d0,d4					; copy 12.5% to d4
		add.l	d2,d4					; get 18.75% to d4
		swap	d4					; swap low word for write
		move.w	d4,(a1)+				; scroll top bar at 18.75% ($30)
		move.w	d4,(a2)+				; ''

		move.l	d0,d4					; copy 12.5% to d4
		add.l	d3,d4					; get 15.625% to d4
		swap	d4					; swap low word for write
		move.w	d4,(a1)+				; scroll small bar 15.625% ($28)
		move.w	d4,(a2)+				; ''

		swap	d0					; swap low word for write
		move.w	d0,(a1)+				; scroll bottom bar 12.5% ($20)
		move.w	d0,(a2)+				; ''

		add.l	d2,d3					; get faster speed to d3
		swap	d3					; swap low word for write
		move.w	d3,(a1)+				; scroll dark section 9.375% ($18)
		move.w	d3,(a2)+				; ''

		move.l	d2,d1					; copy 6.25% to d1
		move.l	d2,d5					; copy 6.25% to d5
		asr.l	#1,d2					; get an eighth
		swap	d1					; swap low word for write
		move.w	d1,(a1)+				; scroll far bg at 6.25% ($10)
		move.w	d1,(a2)+				; ''
		swap	d1					; swap low word for calculation
		sub.l	d2,d1					; calculate top layer position
		swap	d1					; swap low word for write

	; copy sections backwards
		move.w	d3,(a1)+				; scroll dark section 6.25% ($10)
		move.w	d3,(a2)+				; ''
		move.w	d0,(a1)+				; scroll bottom bar 12.5% ($20)
		move.w	d0,(a2)+				; ''
		move.w	d4,(a1)+				; scroll small bar 15.625% ($28)
		move.w	d4,(a2)+				; ''

	; determine if we need to DMA top layer of 3rd parallax
		and.b	#7,d1					; there are 8 possible positions for bg
		cmp.b	(a2),d1					; check if this is the same position as last frame
		beq.s	.notop					; branch if no top layer
		move.b	d1,(a2)					; save the offset in RAM

		move.w	(a2),d1					; load the offset from RAM
		move.w	d1,d0					; copy to d0
		lsr.w	#2,d0					; halve offset ($80)		; was 1	; halve offset ($40)
;		add.w	d1,d1					; double offset ($200)		; $100
		add.w	d0,d1					; combine them ($280)		; $140
		ext.l	d1					; extend to longword

		add.l	#ArtUnc_GMZ_TopLayer>>1,d1		; add tile location to d1
		move.w	#$27E*$20,d2				; VRAM address to load to
		move.w	#$280/2,d3				; transfer length
		jsr	Add_To_DMA_Queue			; DMA it!

.notop
	; determine if we need to DMA top lava layer of 3rd parallax
		addq.w	#2,a2					; skip last data
		move.l	(a2),d0					; load top lava position to d1
		sub.l	#$4400,d0				; move lava roughly every 8 frames
		move.l	d0,(a2)+				; save it back

		move.l	d5,d1					; copy plane position to d1
		sub.l	d0,d1					; sub lava position from it
		swap	d1					; swap low word for write

		and.b	#$1F,d1					; there are 32 possible positions for bg
		cmp.b	(a2),d1					; check if this is the same position as last frame
		beq.s	.lavabot				; branch if no top layer
		move.b	d1,(a2)					; save the offset in RAM

		move.w	(a2),d1					; load the offset from RAM
		lsr.w	#2,d1					; $40
		move.w	d1,d0					; copy to d0	; $40
		add.w	d0,d0					; $80
		add.w	d1,d0					; $C0
		lsr.w	#1,d1					; $20
		add.w	d1,d0					; $E0
		move.w	d0,d1					; copy to d1
		ext.l	d1							; extend to longword

		add.l	#ArtUnc_GMZ_BotLayer>>1,d1			; add tile location to d1
		move.w	#$292*$20,d2				; VRAM address to load to
		move.w	#$100/2,d3				; transfer length
		jsr	Add_To_DMA_Queue			; DMA it!

.lavabot
	; determine if we need to DMA bottom lava layer of 3rd parallax
		addq.w	#2,a2					; skip last data
		move.l	(a2),d0					; load top lava position to d1
		sub.l	#$3400,d0				; move lava roughly every 8 frames
		move.l	d0,(a2)+				; save it back

		move.l	d5,d1					; copy plane position to d1
		sub.l	d0,d1					; sub lava position from it
		swap	d1					; swap low word for write

		and.b	#$1F,d1					; there are 32 possible positions for bg
		cmp.b	(a2),d1					; check if this is the same position as last frame
		beq.s	.apply					; branch if no top layer
		move.b	d1,(a2)					; save the offset in RAM

		move.w	(a2),d1					; load the offset from RAM
		lsr.w	#2,d1					; $40
		move.w	d1,d0					; copy to d0	; $40
		add.w	d0,d0					; $80
		add.w	d1,d0					; $C0
		lsr.w	#1,d1					; $20
		add.w	d1,d0					; $E0
		move.w	d0,d1					; copy to d1
		ext.l	d1							; extend to longword

		add.l	#(ArtUnc_GMZ_BotLayer+$100)>>1,d1		; add tile location to d1
		move.w	#$29A*$20,d2				; VRAM address to load to
		move.w	#$C0/2,d3				; transfer length
		jsr	Add_To_DMA_Queue			; DMA it!

	; apply the deformation
.apply
		lea	.data(pc),a4
		lea	v_deformtablebuffer.w,a5
		jmp	ApplyDeformation			; apply deformation to the level
; ---------------------------------------------------------------------------

.data		dc.w 48, 8, 16, 16, 128, 16, 16, 8
		dc.w 48, 8, 16, 16, 128, 16, 16, $7FFF

; ---------------------------------------------------------------------------
; MGZ3 events
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Resize_GMZ3_DeformProcess:

		bsr.w	GMZ2_Deform

		move.w	(Level_frame_counter).w,d0
		move.w	(PalCycle_Timer3).w,d2
		lea	(SineTable).w,a2
		lea	(H_scroll_buffer).w,a1

		add.w	d0,d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	#224-1,d6

.loop
		andi.w	#$1FE,d0
		move.w	(a2,d0.w),d1
		muls.w	d2,d1
		asr.w	#8,d1

		btst	#0,d6
		beq.s	.skip
		neg.w	d1

.skip
		add.w	d1,(a1)+
		neg.w	d1
		add.w	d1,(a1)+
		addi.w	#$18,d0
		dbf	d6,.loop

		jmp	(ShakeScreen_Setup).w

; ===========================================================================
; ---------------------------------------------------------------------------
; GMZ3 Events
; ---------------------------------------------------------------------------

GMZ3_BackgroundEvent:
		bra.w	GMZ2_BackgroundEvent.normal
; ===========================================================================
; ---------------------------------------------------------------------------
; GMZ Embers renderer
; ---------------------------------------------------------------------------

	if 1=1
gem_timer =	$00		; time until ember is deleted
gem_frame =	$01		; frame number for ember
gem_x =		$02		; x-position of ember
gem_yvel =	$05		; y-velocity of ember
gem_y =		$06		; y-position of ember
gem_agdelt =	$08		; angle delta of ember
gem_angle =	$09		; angle of ember
gem_amp =	$0A		; amplitude of ember
gem_size =	$0C		; size of a single ember object

gem_delay =	9		; initial number of frames for delay
gem_delch =	6		; number of frames until delay is decremented

gem_maxfront =	24		; maximum number of loaded embers at front
EmberSprite_Front = ExtraSpriteBuffer+4
gem_maxback =	18		; maximum number of loaded embers at back
EmberSprite_Back = EmberSprite_Front+(gem_maxfront*gem_size)

	if EmberSprite_Back+(gem_size*gem_maxback) > ExtraSpriteBuffer_End
		fatal "GMZ ember data requires more RAM than is available!"
	endif
; ---------------------------------------------------------------------------

ExtraRt_GMZEmbersFront:
		lea	ExtraSpriteBuffer.w,a0		; load sprite buffer to a0
		tst.b	MGZEmbers_Spawn.w		; check if embers can spawn
		bne.w	.delayspawn			; if not, count until it can

		subq.b	#gem_delch,(a0)			; decrease amount of frames until next spawn
		bpl.w	.process			; if need to wait still, skip
		moveq	#gem_delch,d0			; load initial delay
		add.b	1(a0),d0			; add delay amount
		add.b	d0,(a0)+			; add to current delay
; ---------------------------------------------------------------------------

		cmp.b	#gem_delch,(a0)+		; check if minimum amount of delay
		bls.s	.mind				; branch if so
		subq.b	#1,-1(a0)			; decrement delay

.mind
		cmp.b	#gem_maxfront,(a0)+		; check if front slots are full
		bhs.w	.checkback			; if so, do not spawn
		addq.b	#1,-1(a0)			; set one more ember as loaded
		lea	EmberSprite_Front-gem_size.w,a0	; load the front sprites address
		moveq	#0,d2				; set frame num offset to 0
		bra.s	.spawn

.checkback
		cmp.b	#gem_maxback,(a0)+		; check if back slots are full
		bhs.w	.process			; if so, do not spawn
		addq.b	#1,-1(a0)			; set one more ember as loaded
		lea	EmberSprite_Back-gem_size.w,a0	; load the back sprites address
		moveq	#8,d2				; set frame num offset to 8
; ---------------------------------------------------------------------------

	; find slot for ember (warning, if there is mismatch with ember counter, this WILL break)
.spawn
		moveq	#gem_size,d0			; load gem size to d0

.emberloop
		add.w	d0,a0				; go to next ember data
		tst.b	(a0)				; check if loaded
		bne.s	.emberloop			; if is, go to next one
; ---------------------------------------------------------------------------

	; initialize ember
		jsr	Random_Number			; load random number
		andi.w	#$1FF,d0			; get a range for horizontal position
		cmpi.w	#$140,d0			; idk what this does
		blo.s	.skip0
		andi.w	#$3F,d0
		lsl.w	#3,d0

.skip0
		add.w	#$80,d0				; add horizontal sprite offset to d0
		move.w	d0,gem_x(a0)			; save result in RAM
		move.w	#$80+$FF,gem_y(a0)		; init vertical position in RAM

		swap	d0				; swap high word to low
		and.b	#6,d0				; keep in range
		add.b	d2,d0				; add frame num offset to the frame
		move.b	d0,gem_frame(a0)		; save as map frame

.nextrand
		jsr	Random_Number			; load random number
		and.w	#3,d0				; get velocity range
		beq.s	.nextrand			; if 0, try again
		neg.b	d0				; negate velocity
		move.b	d0,gem_yvel(a0)			; save it as vertical velocity

		swap	d0				; get the other word to get params
		andi.w	#3,d0				; keep in range
		move.b	.timer(pc,d0.w),gem_timer(a0)	; load timer
		move.b	.delta(pc,d0.w),gem_agdelt(a0)	; load angle delta for ember
		move.b	.amp(pc,d0.w),gem_amp(a0)	; load amplitude for ember
		bra.s	.process
; ---------------------------------------------------------------------------

.timer		dc.b $5F, $57, $4F, $65
.delta		dc.b 4, 3, 4, 6
.amp		dc.b 1, 2, 2, 2
		even
; ---------------------------------------------------------------------------

	; process each ember sequentially
.delayspawn
		subq.b	#1,MGZEmbers_Spawn.w		; decrease wait time
		move.b	#gem_delch*gem_delay,1(a0)	; set delay amount to memory

.process
		lea	EmberSprite_Front.w,a0		; load sprite buffer data to a0
		lea	ExtraSpriteBuffer+2.w,a1	; load list number for counts
		moveq	#gem_maxfront-1,d2		; load max number to d2
		bra.s	ExtraRt_GMZEmbersCommon
; ---------------------------------------------------------------------------

ExtraRt_GMZEmbersBack:
		lea	EmberSprite_Back.w,a0		; load sprite buffer data to a0
		lea	ExtraSpriteBuffer+3.w,a1	; load list number for counts
		moveq	#gem_maxback-1,d2		; load max number to d2
; ---------------------------------------------------------------------------

ExtraRt_GMZEmbersCommon:
		tst.w	d7				; check if there are more space for sprites
		bpl.s	.nextem				; if yes, then process them
		rts

.nextem
	; check if it needs to be deleted
		tst.b	gem_timer(a0)			; check if ember exists
		beq.s	.skipem				; if not, skip
		subq.b	#1,gem_timer(a0)		; decrease timer
		bne.s	.normv				; branch if we shouldn't be removed

		subq.b	#1,(a1)				; remove ember from list
		clr.b	gem_angle(a0)			; clear angle
; ---------------------------------------------------------------------------

.skipem
		add.w	#gem_size,a0			; goto next ember
		dbf	d2,.nextem			; process it
		rts
; ---------------------------------------------------------------------------

	; calculate x-velocity and update angles
.normv
		moveq	#0,d0
		move.b	gem_angle(a0),d0		; load angle to d0
		add.b	gem_agdelt(a0),d0		; add angle delta
		move.b	d0,gem_angle(a0)		; save angle
		jsr	GetSineCosine+4			; NAT: Skip and instruction - not needed

		move.b	gem_amp(a0),d1			; load amplitude to d1
		asr.w	d1,d0				; shift by amplitude
; ---------------------------------------------------------------------------

	; calculate speeds
		ext.l	d0				; extend x-vel to word
		asl.l	#8,d0				; multiply speed by $100
		add.l	d0,gem_x(a0)			; update x-axis position

		move.b	gem_yvel(a0),d0			; load vertical	speed
		ext.w	d0				; extend to word
		add.w	d0,gem_y(a0)			; update y-axis position
; ---------------------------------------------------------------------------

	; render ember
		move.w	gem_y(a0),(a6)+			; save y-pos to sprite table
		clr.b	(a6)				; set sprite size to 8x8
		addq.w	#2,a6				; skip link parameter

		moveq	#0,d0
		move.b	gem_frame(a0),d0		; load mappings frame to d0
		move.w	GMZEmbers_Map(pc,d0.w),(a6)+	; save tile address to table
		move.w	gem_x(a0),(a6)+			; save x-pos to sprite table
; ---------------------------------------------------------------------------

		add.w	#gem_size,a0			; goto next ember
		subq.w	#1,d7				; decrease piece count
		dbmi	d2,.nextem			; process more if piece count is ok
		rts
; ---------------------------------------------------------------------------

GMZEmbers_Map:
	;	dc.w $86E0, $86E0, $86E1, $86E2		; above all sprites and backgrounds
	;	dc.w $86E0, $86E0, $86E1, $86E2		; below sprites and backgrounds
		dc.w $869D, $869D, $869E, $869F		; above all sprites and backgrounds
		dc.w $869D, $869D, $869E, $869F		; below sprites and backgrounds
	endif
; ===========================================================================

	if 0=1
GMZEmbers_Pos = ExtraSpriteBuffer+4
GMZEmbers_X = ExtraSpriteBuffer+8
GMZEmbers_Y = ExtraSpriteBuffer+$C
; ---------------------------------------------------------------------------

ExtraRt_GMZEmberSprites	macro	shf
		; 76 cycles = no display, 52 cycles = display
		move.w	a2,d5				; copy screen y-position to d5
		lsr.w	#shf,d5				; shift screen position by d3
		add.w	d5,d5				; duplicate offset

		move.w	(a0)+,d3			; load data size to d3
		move.w	(a1,d5.w),d5			; load sprite to use
		bpl.s	.visible			; branch if visible

		add.w	d3,a0				; skip data
		add.w	d3,a0				; skip data
		bra.s	.continue

.visible	; 12 or 14 cycles
		subq.w	#1,d3				; decrement for dbf
		bmi.s	.continue			; skip if was 0
		rol.w	#1,d5				; shift tile bit into b15

.sprite		; 90 cycles per sprite
		and.b	d2,d4				; keep x-position in range
		or.b	(a0)+,d4			; OR the x-position offset to d4
		and.b	d6,d1				; keep y-position in range
		or.b	(a0)+,d1			; OR the y-position offset to d1

		move.w	d1,(a6)+			; save y-pos to sprite table
		clr.b	(a6)				; set sprite size to 8x8
		addq.w	#2,a6				; skip link parameter

		move.w	d5,(a6)+			; save tile address to table
		move.w	d4,(a6)+			; save x-pos to sprite table

		subq.w	#1,d7				; decrease sprite count
		dbmi	d3,.sprite			; loop for all sprites
		bmi.w	.rts				; branch if all used

.continue
	endm
; ---------------------------------------------------------------------------

ExtraRt_GMZEmbersFront:
		subq.w	#8,GMZEmbers_Pos.w		; change ember position
		bcc.s	.nowrap				; branch if no wrap
		move.w	#127*8,GMZEmbers_Pos.w		; reset ember pos

.nowrap
		move.w	GMZEmbers_Pos.w,d0		; load ember pos to d0
		lea	GMZEmbers_LUT,a0		; load LUT to a0
		move.l	(a0,d0.w),a0			; load data to a0

		lea	GMZEmberMap_Front(pc),a1	; load mapping data to a1
		bra.s	ExtraRt_GMZEmbersCommon
; ---------------------------------------------------------------------------

ExtraRt_GMZEmbersBack:
		move.w	GMZEmbers_Pos.w,d0		; load ember pos to d0
		lea	GMZEmbers_LUT,a0		; load LUT to a0
		move.l	4(a0,d0.w),a0			; load data to a0
		lea	GMZEmberMap_Back(pc),a1		; load mapping data to a1
; ---------------------------------------------------------------------------

ExtraRt_GMZEmbersCommon:
		move.w	#$1F0,d2			; load x-range check to d2
		move.w	#$F0,d6				; load y-range check to d6
		move.w	GMZEmbers_Y.w,a2		; load ember scroll position to a2
; ---------------------------------------------------------------------------

.nexty
		move.w	a2,d1				; load y-position to d1
		tst.w	(a0)				; check
		bpl.s	.yesy

.rts
		rts

.skipy
		add.w	d3,a0				; skip the whole y-position data
		tst.w	(a0)				; check
		bmi.s	.nexty

.yesy
		add.w	(a0)+,d1			; add offset to y-pos
		and.w	d6,d1				; keep in range of 512 px

		move.w	(a0)+,d3			; load data size to d3
		cmp.w	d6,d1				; check if y-position is out of range
		bhi.s	.skipy				; branch if we should skip

		move.w	d1,a2				; load y-position back to a2
		add.w	#$80,d1				; offset sprite position

		move.w	GMZEmbers_X.w,d0		; load ember scroll position to d0
		bra.s	.nextx
; ---------------------------------------------------------------------------

.skipx
		add.w	d3,a0				; skip the whole x-position data

.nextx		; 60 cycles = get next sprites
		tst.w	(a0)				; check
		bmi.s	.nexty
		add.w	(a0)+,d0			; add offset to x-pos

		and.w	d2,d0				; keep in range of 512 px
		move.w	(a0)+,d3			; load data size to d2
		cmp.w	d2,d0				; check if x-position is out of range
		bhi.s	.skipx				; branch if we should skip

		move.w	d0,d4				; copy x to d4
		add.w	#$80,d4				; offset sprite position
; ---------------------------------------------------------------------------

		ExtraRt_GMZEmberSprites 2		; load sprites that go high
		ExtraRt_GMZEmberSprites 3		; load sprites that go low
		bra.w	.nextx				; go to next x-cell
; ---------------------------------------------------------------------------

GMZEmberMap_Front:
		dc.w [16] ($06E0<<1)|1
		dc.w [9] ($06E1<<1)|1
		dc.w [5] ($06E2<<1)|1
		dc.w [10] -1
		dc.w [40] -1
; ---------------------------------------------------------------------------

GMZEmberMap_Back:
		dc.w [13] ($06E0<<1)
		dc.w [8] ($06E1<<1)
		dc.w [3] ($06E2<<1)
		dc.w [16] -1
		dc.w [40] -1
	endif

; ===========================================================================
; ---------------------------------------------------------------------------
; Devil's Descent Events
; ---------------------------------------------------------------------------
; DDZ_BackgroundInit:
; DDZ_BackgroundEvent:
	; Please see real include in main root "Sonic.asm"
	;	include	"../../Levels/DDZ/Code/Scroll.asm"


; ===========================================================================
; ---------------------------------------------------------------------------
; Credits Screen events setup
; ---------------------------------------------------------------------------

CRE_ScreenInit:
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts
		jsr	(InitFGCam).w					; get FG parameters at proper registers
		jmp	(RedrawPMap_Credits).w				; refresh plane (just enough for camera)

; ---------------------------------------------------------------------------
; Credits Screen events
; ---------------------------------------------------------------------------

CRE_ScreenEvent:

	; --- Boundary ---

		moveq	#$00,d2						; force left level boundary
		move.w	(CreditsBoundPos).w,d1				; load current boundary required
		tst.b	(CreditsHold).w					; is the boundary able to open fully?
		bne.s	.NoOpen						; if not, skip
		move.w	d1,(Camera_max_X_pos).w				; force boundary fully open

	.NoOpen:
		cmp.w	(CRE_RT_Hold.Bound+4).l,d1			; is it at maximum?
		bge.s	.NoBoundLeft					; if so, skip left boundary
		move.w	(Camera_X_pos).w,d2				; force left boundary to camera so player cannot move backwards

	.NoBoundLeft:
		move.w	d2,(Camera_min_X_pos).w				; set left boundary
		move.w	(Camera_max_X_pos).w,d0				; load current boundary
		sub.w	d1,d0						; has the boundary moved?
		beq.s	.MatchBound					; if not, skip
		st.b	d1						; move boundary backwards
		bpl.s	.PosBound					; if it needs moving backwards, branch
		addq.b	#$02,d1						; move boundary forwards

	.PosBound:
		ext.w	d1						; word x4 pixels
		add.w	d1,d1						; ''
		add.w	d1,d1						; ''
		addi.w	#$8000,d0					; check if we crossed the boundary
		add.w	d1,d0						; ''
		bvc.s	.NoFlow						; if not, carry on moving
		addi.w	#$8000,d0					; get remaining pixels required
		sub.w	d0,d1						; ''

	.NoFlow:
		add.w	d1,(Camera_max_X_pos).w				; move boundary

	.MatchBound:

	; --- Boundary check ---

		cmpi.w	#$0240,(Camera_Y_pos).w				; is the camera below where the tunnel is?
		blo.w	.NoMessage					; if not, continue
		cmpi.b	#$08,(CreditsMonCount).w			; are credits rolling?
		beq.w	.LockCredits					; if so, branch
		tst.b	(CreditsDelayMSG).w				; is there a delayed message ready to go?
		beq.s	.NoDelay					; if not, continue
		tst.l	(CreditsRoutine).w				; is text already loaded?
		bne.w	.NoMessage					; if so, wait...
		move.b	(CreditsDelayMSG).w,(CreditsMessage).w		; set message to use
		move.l	#CRE_RT_Start,(CreditsRoutine).w		; set to show the message
		sf.b	(CreditsDelayMSG).w				; clear delay message ID
		bra.w	.NoMessage

	.NoDelay:
		move.w	(Camera_X_pos).w,d0				; load camera's position
		cmp.w	(CRE_RT_Hold.Bound+4).l,d0			; has it reached the boundary?
		blo.w	.NoMessage					; if not, continue
		cmpi.w	#$0240,(Camera_Y_pos).w				; is the camera below where the tunnel is?
		blo.w	.NoMessage					; if not, continue

		cmpi.b	#$07,(CreditsMonCount).w			; have all monitors been collected?
		beq.s	.CheckCredits					; if so, branch
		cmp.b	#$08,(CreditsLastMSG).w				; was the last message already the "find monitors" message?
		beq.w	.NoMessage					; if so, skip (show it only one time)
		tst.l	(CreditsRoutine).w				; is text already loaded?
		bne.s	.DelayMessage					; if so, wait...
		move.b	#$08,(CreditsMessage).w				; set message to use
		move.l	#CRE_RT_Start,(CreditsRoutine).w		; set to show the message
		bra.w	.NoMessage					; continue

	.DelayMessage:
		move.b	#$01,(CreditsHold).w				; force previous message to finish
		move.b	#$08,(CreditsDelayMSG).w			; set this message to go next
		bra.w	.NoMessage					; continue

	.CheckCredits:
		cmpi.l	#CRE_RT_MoveOut,(CreditsRoutine).w		; are credits moving out?
		beq.s	.RunCred					; if so, branch
		tst.l	(CreditsRoutine).w				; is text already loaded?
		beq.s	.RunCred					; if not, run credits
		move.b	#$01,(CreditsHold).w				; force previous message to finish
		bra.w	.NoMessage					; continue and wait

	.RunCred:
		addq.b	#$01,(CreditsMonCount).w			; set flag as message move done
		clr.w	(Pal_BlendAmount).w				; reset blend amount

	.LockCredits:
		st.b	(Ctrl_1_locked).w				; lock controls
		move.w	#$0808,(Ctrl_1_logical).w			; force controls to hold right
		move.b	(Player_1+obAnim).w,d0				; check animation
		cmpi.b	#id_Walk,d0					; if not walking/running or waiting then...
		beq.s	.NoJump						; ...we perform a jump to make sure he won't get...
		cmpi.b	#id_Run,d0					; ...stuck rolling or something stupid.
		beq.s	.NoJump						; ''
		cmpi.b	#id_Wait,d0					; ''
		beq.s	.NoJump						; ''
		ori.w	#$1010,(Ctrl_1_logical).w			; force Sonic to jump (so he comes out of spindash/roll/whatever)

	.NoJump:
		move.w	#$0320,d0					; is the boundary too far low down?
		cmp.w	(Camera_max_Y_pos).w,d0				; ''
		bpl.s	.NoSnap						; if not, continue
		move.w	d0,(Camera_max_Y_pos).w				; force boundary to bottom so it starts moving up quicker

	.NoSnap:

		; Forcing Sonic to move

	cmpi.w	#$0600,(Player_1+obInertia).w			; is Sonic moving faster than maximum speed?
	ble.s	.NoTrailRemove					; if not, continue
	move.w	#$0600,(Player_1+obInertia).w			; force to maximum

	.NoTrailRemove:
		move.w	#$02C0,(Camera_target_max_Y_pos).w		; set target
		cmpi.w	#$02C0,(Camera_max_Y_pos).w			; has the boundary reached destination yet?
		bne.w	.NoMessage					; if not, skip
		tst.b	(CreditsFinish).w				; is this the end?
		bne.s	.NoCam						; if so, branch
		move.w	#$1800,d0					; has the camera passed this point?
		cmp.w	(Camera_X_pos).w,d0				; ''
		bpl.s	.NoCam						; if not, continue
		move.w	#$0200,d0					; move back
		sub.w	d0,(Player_1+obX).w				; '' Sonic
		sub.w	d0,(Camera_X_pos).w				; '' Camera
		sub.w	d0,(Camera_X_pos_copy).w			; ''
		sub.w	d0,(Camera_X_pos_rounded).w			; ''
		sub.w	d0,(Camera_X_pos_coarse).w			; ''
		sub.w	d0,(Camera_X_pos_coarse_back).w			; ''

	.NoCam:

		; Fading palette

		cmpi.w	#$0100,(Pal_BlendAmount).w			; has the palette faded completely?
		bge.s	.FinalCredits					; if so, branch
		lea	(Target_palette+$20).w,a0			; load source palette 1 (0000)
		lea	(Pal_CreditsNew2).l,a1				; load source palette 2 (0100)
		lea	(Normal_palette+$20).w,a2			; load destination palette buffer
		moveq	#($60/2)-1,d0					; palette size
		move.w	(Pal_BlendAmount).w,d1				; load blend amount
		addq.w	#$08,d1						; increase blend amount
		jsr	(Pal_BlendPalette).w				; blend the palette
		move.w	d1,(Pal_BlendAmount).w				; update blend amount (if capped)
		bra.w	.NoMessage					; continue

	; --- The actual final credits ---

	.FinalCredits:

		cmpi.w	#$1180,(Camera_X_pos).w				; has the screen reached the plane credits area?
		bmi.w	.NoCredits					; if not, branch

		tst.w	(CamYBG).w					; have BG positions been setup yet?
		bne.s	.NoSetupBG					; if so, continue
		move.w	#$0110,(CamYBG).w				; move down to black chunks
		move.w	#$0200+$1E0,(CamXBG).w				; move to the right to render left
		lea	(ArtKosM_CreditsTails).l,a1			; load art for tails
		move.w	#VRAM_CreditsTails,d2				; VRAM address of tails
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue

	.NoSetupBG:
		cmpi.w	#$0000+$1E0,(CamXBG).w				; has the entire plane been rendered?
		ble.s	.DoneBG						; if so, quit
		subi.w	#$0010,(CamXBG).w				; move left
		move.w	#$0100,(ScrollBG1+4).w				; set render flags
		lea	PlaneBuf.w,a6					; load buffer
		jsr	(ScrollDrawBG_SimpleFull).w			; render the column
		jsr	ScrollDraw_VInt					; draw to VRAM
		bra.s	.NoCredits					; resume

	.DoneBG:
		tst.b	(SwapPlanes).w					; have the planes already swapped?
		bne.s	.SwappedBG					; if so, branch
		st.b	(SwapPlanes).w					; instruct planes to swap
		st.b	(SwapVScroll).w					; instruct V-scroll to swap
		st.b	(CreditsFinalText).w				; set uncompressed text art to load
		move.b	#$16<<2,(CreditsFadeTimer).l			; reset fade timer
		move.w	#$003F,(Palette_fade_info).w			; set fade information correctly for all four lines

	.SwappedBG:
		bsr.w	CRE_CreditsRoll					; run credits roll rendering
		tst.b	(CreditsFinish).w				; have the credits finished rolling?
		bpl.s	.NoCredits					; if not, branch
		subq.b	#$01,(CreditsFadeTimer).l			; decrease timer
		bgt.s	.Fade						; if still running, branch
		sf.b	(CreditsFadeTimer).l				; force timer to 0
		move.b	#id_Thanks,(Game_mode).w			; go to thanks screen
		bra.s	.NoCredits					; continue

	.Fade:
		moveq	#$03,d0						; has it been 4 frames?
		and.b	(CreditsFadeTimer).l,d0				; ''
		bne.s	.NoCredits					; if not, skip fading
		jsr	(Pal_ToBlack).w					; fade to black

	.NoCredits:

	; --- Other crap ---

	.NoMessage:
		tst.b	(ScreenEvent_flag).w				; has the screen been requested to refresh?
		bne.s	.Refresh					; if so, branch
		move.w	(Screen_Shaking_Flag+2).w,d0			; load shaking amount
		add.w	d0,(Camera_Y_pos_copy).w			; add to camera's Y position for rendering strips while shaking
		lea	PlaneBuf.w,a6
		jsr	(ScrollDrawFG_Generic).w			; update FG plane map
		tst.b	(CreditsLine).w					; is there a line change effect occuring?
		bne.s	CRE_SpecialRender				; if so, branch
		rts							; return

	.Refresh:
		bpl.s	.NoFG						; if the BG is to be refreshed, branch
		jsr	(InitFGCam).w					; get FG parameters at proper registers
		jsr	(RedrawPMap_Credits_Full).w			; refresh plane (just enough for camera)

	.NoFG:
		sf.b	(ScreenEvent_flag).w				; set refresh as done
		jsr	(InitBGCam).w					; get BG parameters at proper registers
		jmp	(RedrawPMap_Full).w				; (1 cam) refresh plane (full)

; ---------------------------------------------------------------------------
; Special tile rendering
; ---------------------------------------------------------------------------

CRE_SpecialRender:
		cmpi.w	#(CreditsLineRender_End-CreditsLineRender)/$20,(CreditsLine_Amount).w ; is the line loading fully done?
		blo.s	.RenderLine					; if not, continue
		rts							; return (no more rendering)

	.RenderLine:
		addq.w	#$08,(CreditsLine_Amount).w			; increase effect position
		cmpi.w	#(CreditsLineRender_End-CreditsLineRender)/$20,(CreditsLine_Amount).w ; is the line loading fully done?
		blo.s	.NoFinish					; if not, continue
		move.w	#22,(Palette_fade_timer).w			; allow BG to fade in
		move.w	#$6A09,(Palette_fade_info).w			; ''

	.NoFinish:

	; --- Updating plane tiles ---

		lea	(PlaneBuf).w,a0					; load plane list
		move.w	(a0)+,d0					; load first entry
		beq.s	.NoBlock					; if there are no blocks, branch
		lea	(CreditsPlane-$4000).l,a1			; load plane RAM
		lea	$80(a1),a2					; '' but a tile line lower

	.NextBlock:
		move.l	(a0)+,(a1,d0.w)					; write top two tiles
		move.l	(a0)+,(a2,d0.w)					; write bottom two tiles
		move.w	(a0)+,d0					; load next entry
		bne.s	.NextBlock					; if valid, continue transfering

	.NoBlock:

	; --- Copying plane tiles across ---

		lea	(CreditsPlane).l,a6				; load plane RAM

REVERSE = 1	; Render down = 0 / Render up = 1
REGSIZE := 4*14
	rept	$1000/REGSIZE
		movem.l	(a6)+,d0-a5
		movem.l	d0-a5,$1000-REGSIZE(a6)
	endm
		move.l	(a6)+,$1000-4(a6)
		move.l	(a6)+,$1000-4(a6)

	; --- Marking tile changes ---

		lea	(CreditsPlane+$1000).l,a6			; load plane buffer

		lea	(CreditsLineRender).l,a1			; load render list
		moveq	#$00,d0						; clear entire long-word
		move.w	(CreditsLine_Amount).w,d0			; advance to correct starting frame/tile row
		bpl.s	.Valid						; '' if valid, continue
		moveq	#$00,d0						; '' keep at 0 (negative is invalid)
	.Valid:	lsl.l	#$05,d0						; ''
		adda.l	d0,a1						; ''

		move.w	(Camera_Y_pos).w,d6				; get correct Y position in plane
	if REVERSE=1
		subq.w	#$08,d6						; advance to bottom of screen (quicker to sub 8 than to add F8)
	endif
		andi.w	#$00F8,d6					; ''
		lsl.w	#$05,d6						; ''

		move.w	(Camera_X_pos).w,d0				; get correct X position in plane
		neg.w	d0						; ''
		addq.w	#$08,d0						; '' adjust precisely for left side (when scroll is not multiple of 8)
		andi.w	#$01F8,d0					; ''
		lsr.w	#$02,d0						; ''

		or.b	d0,d6						; setup index address
		moveq	#$20-1,d7					; number of rows

	.NextRow:
		andi.w	#$1F7E,d6					; wrap Y
		lea	(a1,d6.w),a0					; load correct line of render values
	if REVERSE=1
		subi.w	#$0100,d6					; advance to next line
	else
		addi.w	#$0100,d6					; advance to next line
	endif
		rept	$20/6
		movem.l	(a0)+,d0-d5					; load render patterns
		add.l	d0,(a6)+					; advance to line tiles (if necessary)
		add.l	d1,(a6)+					; ''
		add.l	d2,(a6)+					; ''
		add.l	d3,(a6)+					; ''
		add.l	d4,(a6)+					; ''
		add.l	d5,(a6)+					; ''
		endm
		rept	$20-(($20/6)*6)
		move.l	(a0)+,d0					; render last tiles
		add.l	d0,(a6)+					; ''
		endm
		dbf	d7,.NextRow					; repeat for all rows
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Special credits roll text on very end of credits
; ---------------------------------------------------------------------------

CRE_CreditsRoll:
		move.l	(CreditsString).w,d0				; load string address
		bne.s	.Valid						; if we've already started, branch
		clr.l	(Camera_Y_pos_BG_copy).l			; set no scroll (especially the fraction)
		clr.l	(CreditsPlane).l				; set no transfer
		st.b	(CreditsMapText).w				; enable credits mappings transfer
		move.l	#CRE_FinalRoll,d0				; set string to use
		move.l	d0,(CreditsString).w				; ''

	.Valid:
		movea.l	d0,a0						; set string address
		addi.l	#$00004000,(Camera_Y_pos_BG_copy).l		; scroll credits down
		move.l	(Camera_Y_pos_BG_copy).l,d0			; load scroll position
		andi.l	#$0007FFFF,d0					; has it rounded to a nice 8 pixel position?
		bne.w	.NoRender					; if not, skip

	; --- Plane address setup ---

		moveq	#-8,d0						; load plane position line which is about to come on-screen
		add.w	(Camera_Y_pos_BG_copy).l,d0			; ''
		lsl.w	#$04,d0						; align to plane row slot
		andi.w	#$0F80,d0					; ''
		ori.w	#$6000,d0					; set as VDP write mode
		lea	(CreditsPlane).l,a1				; load credits plane mappings to use
		move.w	#$0083,(a1)+					; ''
		move.w	d0,(a1)+					; save VDP write mode to plane list

		move.l	#$A000A000|((VRAM_CreditsText/$20)-1)|(((VRAM_CreditsLargeChars/$20)-4)<<$10),d2  ; pattern indexes
		tst.b	(CreditsMapDouble).w				; are we mapping large letters?
		beq.s	.Start						; if not, branch
		swap	d2						; swap pattern indexes

	.Start:

	; --- character loop ---

		moveq	#$00,d0						; clear d0
		move.b	(a0)+,d0					; load first character
		bmi.s	.Flag						; if it's a flag, branch

	.Check:
		bne.s	.NoSpace					; if it's not a space, branch
		clr.w	(a1)+						; set space character
		bra.s	.Next						; continue

	.NoSpace:
		tst.b	(CreditsMapDouble).w				; are we mapping large letters?
		beq.s	.Draw						; if not, branch
		add.w	d0,d0						; multiply by x4
		add.w	d0,d0						; ''
		tst.b	(CreditsMapDouble).w				; are we mapping the bottom two letters?
		bmi.s	.DoTop						; if not, branch
		addq.w	#$01,d0						; advance to bottom row tiles

	.DoTop:
		add.w	d2,d0						; advance to correct pattern index
		move.w	d0,(a1)+					; save left tile
		addq.w	#$02,d0						; advance to right tile
		move.w	d0,(a1)+					; save right tile
		bra.s	.Next						; continue

	.Draw:
		add.w	d2,d0						; add pattern index address
		move.w	d0,(a1)+

	.Next:
		moveq	#$00,d0						; clear d0
		move.b	(a0)+,d0					; load next character
		bpl.s	.Check						; if it's not a flag, branch to check character

	.Flag:
		add.b	d0,d0						; check if it's an end of string marker
		bpl.s	.EndList					; if it's 80, skip and finish the list
		add.b	d0,d0						; check if it's a palette change
		bpl.s	.SwapPalette					; if so, branch
		add.b	d0,d0						; check if it's a large letter line
		bmi.s	.EndLine					; if not, branch

		tst.b	(CreditsMapDouble).w				; is double line enabled?
		bne.s	.Next						; if so, skip
		st.b	(CreditsMapDouble).w				; enable double line
		swap	d2						; switch
		bra.s	.Next						; continue

	.SwapPalette:
		eori.l	#$20002000,d2					; swap the palette line
		bra.s	.Next						; continue

	.EndLine:
		tst.b	(CreditsMapDouble).w				; is this the first of a double line?
		bmi.s	.RepeatLine					; if so, skip
		move.l	a0,(CreditsString).w				; update string address
		sf.b	(CreditsMapDouble).w				; disable double line

	.RepeatLine:
		neg.b	(CreditsMapDouble).w				; swap lines
		move.w	(Camera_Y_pos_BG_copy).l,(CreditsLastVScroll).l	; store V-scroll position
		bra.s	.NoEnd

	.EndList:
		move.w	(Camera_Y_pos_BG_copy).l,d0			; get distance credits has scrolled since last line of text
		sub.w	(CreditsLastVScroll).l,d0			; ''
		cmpi.w	#224-$08,d0					; has it scrolled enough to go off-screen for Sonic to shift off?
		bne.s	.NoSonic					; if not, continue
		tst.b	(CreditsFinish).w				; has shift Sonic been loaded already?
		bne.s	.NoSonic					; if so, branch (don't request load twice)
		ori.b	#$01,(CreditsFinish).w				; set shift Sonic as loaded
		movem.l	d0/a1,-(sp)					; store registers
		jsr	CreateSonicShift				; load the Sonic shift object
		movem.l	(sp)+,d0/a1					; restore registers

	.NoSonic:
		cmpi.w	#224+$20,d0					; has it scrolled enough to go off-screen?
		bmi.s	.NoEnd						; if not, continue
		tst.b	(CreditsFinish).w				; have credits been set to finish already?
		bmi.s	.NoEnd						; if so, branch (don't request fadeout twice)
		fadeout							; fade out music
		st.b	(CreditsFinish).w				; set credits to finish

	.NoEnd:
		moveq	#($40/2)-1,d7					; number of characters on the plane allowed at once
		moveq	#$00,d0						; clear d0

	.ClearRest:
		move.l	d0,(a1)+					; clear rest of line
		dbf	d7,.ClearRest					; ''

	.NoRender:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Credits backgound scrolling setup
; ---------------------------------------------------------------------------

CRE_BackgroundInit:
		jsr	CRE_DeformFG					; perform scrolling
		jsr	(InitFGCam).w					; get FG parameters at proper registers
		jsr	(RedrawPMap_Credits_Full).w			; (1 cam) refresh plane (full)
		jsr	(InitBGCam).w					; get BG parameters at proper registers
		jmp	(RedrawPMap_Full).w				; (1 cam) refresh plane (full)

; ---------------------------------------------------------------------------
; Credits backgound scrolling
; ---------------------------------------------------------------------------

CRE_BackgroundEvent:
		bsr.w	CRE_DeformFG					; scroll foreground
		jmp	WobbleScreen					; allow the screen to wobble

; ===========================================================================
; ---------------------------------------------------------------------------
; Foreground (level) scrolling
; ---------------------------------------------------------------------------

CRE_DeformFG:
		lea	(v_hscrolltablebuffer).l,a1			; load H-scroll table
		moveq	#$00,d0						; clear X position for BG
		move.w	(v_screenposx).w,d0				; load X position for FG
		neg.w	d0						; reverse direction for H-scroll table

		tst.w	(CamYBG).w					; has the BG scrolled down?
		beq.s	.ScrollClouds					; if not, do scroll for the clouds

	; --- Credits roll scrolling ---

		tst.b	(SwapPlanes).w					; have the planes swapped yet?
		bne.s	.Swap						; if so, swap BG and FG
		swap	d0						; send to upper word

	.Swap:
		move.w	#224-1,d7					; section size
		bra.s	.Next						; write section

	; --- Cloud scrolling ---

	.ScrollClouds:
	move.w	d0,d5
	asr.w	#$01,d5
		swap	d0						; send to upper word
		move.w	(Level_frame_counter).w,d6			; load frame timer
		neg.w	d6						; reverse direction
		asr.w	#$01,d6						; slow it down

	move.w	d6,d0
	move.w	d6,d4
	asr.w	#$02,d0
	sub.w	d0,d4

		move.w	d6,d0						; get speed
		asr.w	#$01,d0						; ''
		move.w	#16-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d4,d0						; get speed
		move.w	#48-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d6,d0						; get speed
		asr.w	#$02,d0						; ''
		move.w	#16-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d6,d0						; get speed
		asr.w	#$01,d0						; ''
		move.w	#8-1,d7						; section size
		bsr.s	.Write						; write section

		move.w	d4,d0						; get speed
		move.w	#40-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d6,d0						; get speed
		asr.w	#$01,d0						; ''
		move.w	#48-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d6,d0						; get speed
		asr.w	#$02,d0						; ''
		move.w	#16-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d6,d0						; get speed
		asr.w	#$01,d0						; ''
		move.w	#16-1,d7					; section size
		bsr.s	.Write						; write section

		move.w	d4,d0						; get speed
		move.w	#16-1,d7					; section size


	.Write:
		add.w	d5,d0

	.Next:
		move.l	d0,(a1)+					; write H-scroll position
		dbf	d7,.Next					; ''
		rts							; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Universal zone and act saving subroutine, because zone changes are all over the bloody place
; ---------------------------------------------------------------------------

SaveZoneSRAM:
		tst.b	(Extended_mode).w				; check EX flag
		bne.s	.Return						; if EX mode, skip saving

		movem.l	d0-a0,-(sp)					; store registers
		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; load from first slot
		jsr	LoadSlot					; load it
		beq.s	.FailLoad					; if failed, skip saving
		move.b	(Current_zone).w,SR_Zone(a0)			; save Zone and Act
		move.b	(Current_Act).w,SR_Act(a0)			; ''
		moveq	#$00,d0						; save to first slot
		jsr	SaveSLot					; save it
		bne.s	.FailLoad					; if successful, skip
		nop	; Donno...

	.FailLoad:
		movem.l	(sp)+,d0-a0					; restore registers

	.Return:
		rts							; return

; ===========================================================================

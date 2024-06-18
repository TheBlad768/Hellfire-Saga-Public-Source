; ---------------------------------------------------------------------------
; Options Screen
; ---------------------------------------------------------------------------

; RAM
v_Options_Cursor:				= Camera_RAM		; word
v_Options_AniFrame:				= Camera_RAM+2	; word
v_Options_AniTimer:				= Camera_RAM+4	; word
v_Options_ProcessEnd:			= Camera_RAM+6	; byte
v_Options_Process2End:			= Camera_RAM+7	; byte
v_Options_ScrollProcess_Timer:	= Camera_RAM+8	; word
v_Options_Delete:		= Camera_RAM+10		; MJ: for delete slot option
v_Options_DelFinish:		= Camera_RAM+11		; MJ: for when delete screen is finished and objects need to fly off

; =============== S U B R O U T I N E =======================================

Options_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		disableInts
		move.w	#-1,(Previous_zone).w				; MJ: reset previous zone/act
		move.l	#VInt,(V_int_addr).w				; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w				; MJ: restore H-blank address
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts

		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; set to load from first slot
		jsr	LoadSlot					; load it...
		beq.s	.FailLoad					; if failed, skip
		move.b	SR_Difficulty(a0),d0				; load difficulty
		move.w	d0,(Difficulty_Flag).w				; ''
		move.b	SR_Camera(a0),d0				; load camera mode
		move.w	d0,(ExtendedCam_Flag).w				; ''

	.FailLoad:
		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)					; Command $8004 - Disable HInt, HV Counter
		move.w	#$8200+(vram_fg>>10),(a6)	; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)	; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)			; Command $8700 - BG color is Pal 0 Color 0
		move.w	#$8B03,(a6)					; Command $8B00 - Vscroll full, HScroll full
		move.w	#$8C81,(a6)					; Command $8C81 - 40cell screen size, no interlacing, no s/h
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		lea	(H_scroll_buffer+2).w,a1
		move.w	#224-1,d6
		move.w	#-170,d0

-		move.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-

		lea	PLC_Options(pc),a5
		jsr	(LoadPLC_Raw_KosM).w

		lea	(MapEni_SoundTestBG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$40,d0
		jsr	(EniDec).w
		copyTilemap	vram_bg, 512, 224

		moveq	#palid_Sonic,d0
		jsr	(LoadPalette).w						; load Sonic's palette
		lea	(Pal_Options).l,a1
		lea	(Target_palette_line_2).w,a2
		moveq	#(16/2)-1,d0
		jsr	(PalLoad_Line.loop).w

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	-
		music	mus_Boss2,0
		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
		jsr	(Pal_FadeFromBlack).w

Options_Screen2:
		lea	(v_Dust).w,a0
		move.l	#Obj_OptionsBGText,address(a0)
		move.l	#Map_OptionsBGText,mappings(a0)
		move.w	#$350,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$210,x_pos(a0)
		move.w	#$142,y_pos(a0)

-		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_Options_ProcessEnd).w
		beq.s	-
		sf	(v_Options_ProcessEnd).w
		lea	(Object_RAM+next_object).w,a0
		move.l	#Obj_OptionsDifficulty,address(a0)
		move.l	#Map_OptionsText,mappings(a0)
		move.w	#$214A,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$229,x_pos(a0)
		move.w	#$A5,y_pos(a0)
		lea	next_object(a0),a0
		move.l	#Obj_OptionsSeizure,address(a0)
		move.l	#Map_OptionsText2,mappings(a0)
		move.w	#$214A,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$250,x_pos(a0)
		move.w	#$BD,y_pos(a0)
		lea	next_object(a0),a0
		move.l	#Obj_OptionsMenu,address(a0)
		move.l	#Map_OptionsFGText,mappings(a0)
		move.w	#$200,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$201-$10,x_pos(a0)
		move.w	#$B0,y_pos(a0)
		lea	next_object(a0),a0
		move.l	#Obj_OptionsCam,address(a0)
		move.l	#Map_OptionsText2,mappings(a0)
		move.w	#$214A,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$250,x_pos(a0)
		move.w	#$D4,y_pos(a0)

-		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_Options_ProcessEnd).w
		beq.s	-
		sf	(v_Options_ProcessEnd).w
		lea	(Object_RAM).w,a0
		move.l	#Obj_OptionsCursor,address(a0)
		move.l	#Map_OptionsCursor,mappings(a0)
		move.w	#$1BF,art_tile(a0)
		bset	#5,render_flags(a0)	; set static mappings flag
		move.w	#$80,priority(a0)
		move.w	#$10C,x_pos(a0)
		move.w	#$A5,y_pos(a0)

-		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		disableInts
		moveq	#0,d0
		move.b	(Ctrl_1_pressed).w,d1
		bsr.w	Options_Controls
		move.w	(v_Options_Cursor).w,d2
		add.w	d2,d2
		add.w	d2,d2
		lea	Options_Main(pc),a1
		jsr	(a1,d2.w)
		enableInts
		tst.b	(Ctrl_1_pressed).w
		bpl.s	-

		disableInts
		dmaFillVRAM 0,$C000,(256<<4)	; clear plane A PNT
		enableInts
		lea	(Object_RAM).w,a1
		lea	(Delete_Referenced_Sprite).w,a2
		jsr	(a2)
;		jsr	(a2)
;		jsr	(a2)

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_Options_ProcessEnd).w
		beq.s	-

		sf	(v_Options_ProcessEnd).w
		fadeout
		cmpi.w	#3,(v_Options_Cursor).w
		beq.w	SoundTest_Screen

		cmpi.w	#4,(v_Options_Cursor).w			; MJ: is this the "delete" slot?
		beq.s	Delete_Screen				; MJ: if so, run delete screen

		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; load from first slot
		jsr	LoadSlot					; load it
		beq.s	.FailSave					; if failed, skip saving
		move.w	(Difficulty_Flag).w,d0				; set difficulty
		move.b	d0,SR_Difficulty(a0)				; ''
		move.w	(ExtendedCam_Flag).w,d0				; set camera
		move.b	d0,SR_Camera(a0)				; ''
		moveq	#$00,d0						; save to first slot
		jsr	SaveSlot					; save it
		bne.s	.FailSave					; if succeeded, branch
		nop	; no idea what to do...

	.FailSave:

		move.b	#id_Title,(Game_mode).w
		bra.w	Pal_TitleFade

; ---------------------------------------------------------------------------
; Delete screen - MarkeyJester
; ---------------------------------------------------------------------------

	; Most of this is copy/paste from sound test screen...

Delete_Screen:
-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w

		lea	(H_scroll_buffer+2).w,a1
		move.w	#224-1,d6
		moveq	#2,d0

-		add.w	d0,(a1)+
		addq.w	#2,a1
		dbf	d6,-
		cmpi.w	#-98,(H_scroll_buffer+2).w
		bne.s	--

		lea	(Dynamic_object_RAM+(object_size*$10)).w,a0	; load object RAM slot

		move.l	#Obj_AreYouSure,address(a0)			; Are You Sure object
		move.l	#Map_OptionsFGText,mappings(a0)
		move.w	#$200,art_tile(a0)
		move.w	#$80,priority(a0)
		move.w	#$00E8,x_pos(a0)
		move.w	#-$20,y_pos(a0)
		move.w	#$E8,$30(a0)	; destination X
		move.w	#$D0,$32(a0)	; destination Y
	move.l	#$00000000,$34(a0)
	move.l	#$00010000,$38(a0)
		move.b	#$01,mapping_frame(a0)

		lea	object_size(a0),a0

		move.l	#Obj_No,address(a0)				; No Object
		move.l	#Map_OptionsText3,mappings(a0)
		move.w	#$80,priority(a0)
		move.w	#$080,x_pos(a0)
		move.w	#$200,y_pos(a0)
		move.w	#$100,$30(a0)	; destination X
		move.w	#$130,$32(a0)	; destination Y
	move.l	#$00010000,$34(a0)
	move.l	#$FFFF0000,$38(a0)
		move.b	#$00,mapping_frame(a0)

		lea	object_size(a0),a0

		move.l	#Obj_Yes,address(a0)				; Yes Object
		move.l	#Map_OptionsText3,mappings(a0)
		move.w	#$80,priority(a0)
		move.w	#$1C4,x_pos(a0)
		move.w	#$200,y_pos(a0)
		move.w	#$144,$30(a0)	; destination X
		move.w	#$130,$32(a0)	; destination Y
	move.l	#$FFFF0000,$34(a0)
	move.l	#$FFFF0000,$38(a0)
		move.b	#$01,mapping_frame(a0)

		sf.b	(v_Options_Delete).w				; default "NO"
		sf.b	(v_Options_DelFinish).w				; set not finished with delete

		andi.b	#$7F,(Ctrl_1_pressed).w				; clear start button as been pressed

	.LoopDelete:
		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w

		moveq	#$0C,d0						; get left/right controls
		and.b	(Ctrl_1_pressed).w,d0				; ''
		beq.s	.NoChange					; if neither pressed, skip change
		not.b	(v_Options_Delete).w				; change option

	.NoChange:
		tst.b	(Ctrl_1_pressed).w				; has the player pressed start again?
		bpl.s	.LoopDelete					; if not, loop and wait

		tst.b	(v_Options_Delete).w				; is the option set to "yes"?
		beq.s	.No						; if not, skip

		move.w	#$0001,(Difficulty_Flag).w			; reset difficulty flag
		clr.w	(ExtendedCam_Flag).w				; reset cinematic view to on
		sf.b	(v_Title_Levelselect_flag).w			; disable level select
		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		sf.b	SR_Zone(a0)					; reset Zone to 0
		sf.b	SR_Act(a0)					; reset Act to 0
		move.w	(Difficulty_Flag).w,d0				; reset difficulty to normal
		move.b	d0,SR_Difficulty(a0)				; ''
		move.w	(ExtendedCam_Flag).w,d0				; reset camera to cinematic view
		move.b	d0,SR_Camera(a0)				; ''
		move.b	(v_Title_Levelselect_flag).w,SR_Complete(a0)	; reset game complete flag
		moveq	#$00,d0						; save to first slot
		jsr	SaveSlot					; save it
		bne.s	.No						; if success, branch
		nop	; Really no idea what to do...

	.No:
		st.b	(v_Options_DelFinish).w				; set delete as done

	.LoopFinish:
		move.b	#VintID_Menu,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w

		lea	(Dynamic_object_RAM+(object_size*$10)).w,a0
		move.l	address(a0),d0
		lea	object_size(a0),a0
		or.l	address(a0),d0
		lea	object_size(a0),a0
		or.l	address(a0),d0
		bne.s	.LoopFinish

		sf.b	(v_Options_Process2End).w			; clear sound test options text flag
		bra.w	ReturnToOptions					; return correctly

; ---------------------------------------------------------------------------
; Yes/No objects
; ---------------------------------------------------------------------------

Obj_No:
		move.b	(v_Options_Delete).w,d0				; load option
		bra.s	Obj_Yes.ObjDisp

Obj_Yes:
		move.b	(v_Options_Delete).w,d0				; load option
		not.b	d0						; invert option for yes
		
	.ObjDisp:
		ext.w	d0						; extend to upper word
		andi.w	#$2000,d0					; get only palette line
		addi.w	#$214A,d0					; advance between line 2 and 3 depending on option
		move.w	d0,art_tile(a0)					; set new palette line

Obj_AreYouSure:
		move.b	(v_Options_DelFinish).w,d1
		move.l	$30(a0),d0
		clr.w	d0
		sub.l	x_pos(a0),d0
		tst.b	d1
		beq.s	.ContX
		add.l	$34(a0),d0
		move.l	d0,d2
		swap	d2
		addi.w	#$0100,d2
		cmpi.w	#$0100+320,d2
		bhs.s	.Delete
		neg.l	d0
		add.l	d0,d0

	.ContX:
		asr.l	#$04,d0
		add.l	d0,x_pos(a0)
		move.l	$32(a0),d0
		clr.w	d0
		sub.l	y_pos(a0),d0
		tst.b	d1
		beq.s	.ContY
		add.l	$38(a0),d0
		move.l	d0,d2
		swap	d2
		addi.w	#$0100,d2
		cmpi.w	#$0100+224,d2
		bhs.s	.Delete
		neg.l	d0
		add.l	d0,d0

	.ContY:
		asr.l	#$04,d0
		add.l	d0,y_pos(a0)
		jmp	(Draw_Sprite).w					; render the sprites

	.Delete:
		jmp	(Delete_Current_Sprite).w			; delete the sprite

; ---------------------------------------------------------------------------

Options_Main:
		bra.w	Options_Controls_Difficulty	; 0
		bra.w	Options_Controls_Seizure	; 1
		bra.w	Options_Controls_Cam		; 2
		bra.w	Options_Controls_Return		; 3
		bra.w	Options_Controls_Return		; 4
		bra.w	Options_Controls_Return		; 5

; =============== S U B R O U T I N E =======================================

Options_Controls:
		move.w	#6-1,d2
		move.w	(v_Options_Cursor).w,d3
		bsr.s	Options_UpDownControls
		move.w	d3,(v_Options_Cursor).w

Options_Controls_Return:
		rts

; =============== S U B R O U T I N E =======================================

Options_UpDownControls:
		btst	#button_up,d1
		beq.s	.notup
		samp	sfx_WalkingArmorAtk		; Yes/No?
		subq.w	#1,d3
		bpl.s	.notup
		move.w	d2,d3

.notup
		btst	#button_down,d1
		beq.s	.return
		samp	sfx_WalkingArmorAtk		; Yes/No?
		addq.w	#1,d3
		cmp.w	d2,d3
		bls.s		.return
		moveq	#0,d3

.return
		rts

; =============== S U B R O U T I N E =======================================

Options_LeftRightControls:
		btst	#button_left,d1
		beq.s	.notleft
		samp	sfx_WalkingArmorAtk		; Yes/No?
		subq.w	#1,d3
		bpl.s	.notleft
		move.w	d2,d3

.notleft
		btst	#button_right,d1
		beq.s	.return
		samp	sfx_WalkingArmorAtk		; Yes/No?
		addq.w	#1,d3
		cmp.w	d2,d3
		bls.s		.return
		moveq	#0,d3

.return
		rts

; =============== S U B R O U T I N E =======================================

Options_Controls_Difficulty:
		move.w	#4-1,d2
		move.w	(Difficulty_Flag).w,d3
		bsr.s	Options_LeftRightControls
		move.w	d3,(Difficulty_Flag).w
		rts

; =============== S U B R O U T I N E =======================================

Options_Controls_Seizure:
		move.w	#2-1,d2
		move.w	(Seizure_Flag).w,d3
		bsr.s	Options_LeftRightControls
		move.w	d3,(Seizure_Flag).w
		rts

; =============== S U B R O U T I N E =======================================

Options_Controls_Cam:
		move.w	#2-1,d2
		move.w	(ExtendedCam_Flag).w,d3
		bsr.s	Options_LeftRightControls
		move.w	d3,(ExtendedCam_Flag).w
		rts

; =============== S U B R O U T I N E =======================================

Obj_OptionsBGText:
		move.w	#-$400,x_vel(a0)
		move.l	#OptionsBGText_CheckFrame,address(a0)

OptionsBGText_CheckFrame:
		cmpi.w	#$1DA,x_pos(a0)
		bge.s	OptionsBGText_Draw
		addq.b	#1,mapping_frame(a0)
		move.l	#OptionsBGText_Stop,address(a0)

OptionsBGText_Stop:
		add.w	#$0C,x_vel(a0)
		bmi.s	OptionsBGText_Draw
		clr.w	x_vel(a0)
		st	(v_Options_ProcessEnd).w
		move.l	#OptionsBGText_CheckStart,address(a0)

OptionsBGText_CheckStart:
		tst.b	(v_Options_Process2End).w
		beq.s	OptionsBGText_Draw
		move.l	#OptionsBGText_CheckFrame2,address(a0)

OptionsBGText_CheckFrame2:
		subi.w	#$38,x_vel(a0)
		cmpi.w	#$60,x_pos(a0)
		bge.s	OptionsBGText_Draw
		addq.b	#1,mapping_frame(a0)
		move.l	#OptionsBGText_Stop2,address(a0)

OptionsBGText_Stop2:
		subi.w	#$38,x_vel(a0)
		cmpi.w	#-$30,x_pos(a0)
		bge.s	OptionsBGText_Draw
		clr.w	x_vel(a0)
		move.w	#$17,$2E(a0)
		move.l	#OptionsBGText_Wait,address(a0)

OptionsBGText_Wait:
		subq.w	#1,$2E(a0)
		bpl.s	OptionsBGText_Draw
		st	(v_Options_ProcessEnd).w
		move.l	#Delete_Current_Sprite,address(a0)

OptionsBGText_Draw:
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_OptionsMenu:
		move.w	#-$400,x_vel(a0)
		move.l	#OptionsMenu_CheckPos,address(a0)

OptionsMenu_CheckPos:
		cmpi.w	#$1C4,x_pos(a0)
		bge.s	OptionsMenu_Draw
		move.l	#OptionsMenu_Stop,address(a0)

OptionsMenu_Stop:
		add.w	#$0C,x_vel(a0)
		bmi.s	OptionsMenu_Draw
		clr.w	x_vel(a0)
		move.w	#$118,x_pos(a0)
		move.l	#OptionsMenu_CheckStart,address(a0)
		st	(v_Options_ProcessEnd).w

OptionsMenu_CheckStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	OptionsBGText_Draw
		st	(v_Options_Process2End).w
		move.l	#OptionsMenu_CheckPos2,address(a0)

OptionsMenu_CheckPos2:
		addi.w	#$38,x_vel(a0)
		cmpi.w	#$1F8-$20,x_pos(a0)
		ble.s	OptionsMenu_Draw
		move.l	#Delete_Current_Sprite,address(a0)

OptionsMenu_Draw:
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_OptionsDifficulty:
	;	move.w	#$1F,$2E(a0)
	;	move.l	#OptionsDifficulty_Timer,address(a0)

OptionsDifficulty_Timer:
	;	subq.w	#1,$2E(a0)
	;	bpl.s	OptionsDifficulty_Draw
		move.w	#-$400,x_vel(a0)
		move.l	#OptionsDifficulty_Stop,address(a0)

OptionsDifficulty_Stop:
		add.w	#$0C,x_vel(a0)
		bmi.s	OptionsDifficulty_Draw
		clr.w	x_vel(a0)
		move.w	#$180,x_pos(a0)
		move.l	#OptionsDifficulty_CheckStart,address(a0)

OptionsDifficulty_CheckStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	OptionsDifficulty_Draw
		move.l	#OptionsDifficulty_CheckPos,address(a0)

OptionsDifficulty_CheckPos:
		addi.w	#$38,x_vel(a0)
		cmpi.w	#$210,x_pos(a0)
		ble.s	OptionsDifficulty_Draw
		move.l	#Delete_Current_Sprite,address(a0)

OptionsDifficulty_Draw:
		move.b	(Difficulty_Flag+1).w,mapping_frame(a0)
		jsr	(MoveSprite2).w
		bra.w	OptionsCursor_Draw

; =============== S U B R O U T I N E =======================================

Obj_OptionsSeizure:
	;	move.w	#$1F,$2E(a0)
	;	move.l	#OptionsSeizure_Timer,address(a0)

OptionsSeizure_Timer:
	;	subq.w	#1,$2E(a0)
	;	bpl.s	OptionsSeizure_Draw
		move.w	#-$400,x_vel(a0)
		move.l	#OptionsSeizure_Stop,address(a0)

OptionsSeizure_Stop:
		add.w	#$0C,x_vel(a0)
		bmi.s	OptionsSeizure_Draw
		clr.w	x_vel(a0)
		move.w	#$1A7,x_pos(a0)
		move.l	#OptionsSeizure_CheckStart,address(a0)

OptionsSeizure_CheckStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	OptionsSeizure_Draw
		move.l	#OptionsSeizure_CheckPos,address(a0)

OptionsSeizure_CheckPos:
		addi.w	#$38,x_vel(a0)
		cmpi.w	#$210,x_pos(a0)
		ble.s	OptionsSeizure_Draw
		move.l	#Delete_Current_Sprite,address(a0)

OptionsSeizure_Draw:
		move.b	(Seizure_Flag+1).w,mapping_frame(a0)
		jsr	(MoveSprite2).w
		bra.s	OptionsCursor_Draw

; =============== S U B R O U T I N E =======================================

Obj_OptionsCam:
	;	move.w	#$1F,$2E(a0)
	;	move.l	#OptionsCam_Timer,address(a0)

OptionsCam_Timer:
	;	subq.w	#1,$2E(a0)
	;	bpl.s	OptionsCam_Draw
		move.w	#-$400,x_vel(a0)
		move.l	#OptionsCam_Stop,address(a0)

OptionsCam_Stop:
		add.w	#$0C,x_vel(a0)
		bmi.s	OptionsCam_Draw
		clr.w	x_vel(a0)
		move.w	#$1A7,x_pos(a0)
		move.l	#OptionsCam_CheckStart,address(a0)

OptionsCam_CheckStart:
		tst.b	(Ctrl_1_pressed).w
		bpl.s	OptionsCam_Draw
		move.l	#OptionsCam_CheckPos,address(a0)

OptionsCam_CheckPos:
		addi.w	#$38,x_vel(a0)
		cmpi.w	#$210,x_pos(a0)
		ble.s	OptionsCam_Draw
		move.l	#Delete_Current_Sprite,address(a0)

OptionsCam_Draw:
		move.b	(ExtendedCam_Flag+1).w,mapping_frame(a0)
		jsr	(MoveSprite2).w
		bra.s	OptionsCursor_Draw

; =============== S U B R O U T I N E =======================================

Obj_OptionsCursor:
		moveq	#0,d0
		move.w	(v_Options_Cursor).w,d0
		add.w	d0,d0
		move.w	OptionsCursor_Pos(pc,d0.w),y_pos(a0)

OptionsCursor_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

OptionsCursor_Pos:
		dc.w $A5
		dc.w $BC
		dc.w $D3
		dc.w $EA
		dc.w $101
		dc.w $125
Map_OptionsCursor:
		dc.b $F8			; Ypos
		dc.b 0			; Tile size(0=8x8)
		dc.w 0			; VRAM
		dc.w -8			; Xpos

; =============== S U B R O U T I N E =======================================

PLC_Options:
		dc.w ((PLC_Options_End-PLC_Options)/6)-1
		plreq 1, ArtKosM_SoundTestText
		plreq $38, ArtKosM_SoundTestEQ
		plreq $40, ArtKosM_SoundTestBG
		plreq $14A, ArtKosM_OptionsText2
		plreq $200, ArtKosM_OptionsText
		plreq $350, ArtKosM_OptionsBGText
PLC_Options_End
; ---------------------------------------------------------------------------

			include "Data/Screens/Options/Object data/Map - Text.asm"
Map_OptionsFGText:	include "Data/Screens/Options/Object data/Map - FG Text.asm"
			include "Data/Screens/Options/Object data/Map - BG Text.asm"

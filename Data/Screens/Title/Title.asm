; ---------------------------------------------------------------------------
; Title Screen
; By TheBlad768 (2022)
; ---------------------------------------------------------------------------

; RAM (Main)
v_Title_ProcessTimer:			= Camera_RAM			; word
v_Title_ProcessEnd:			= Camera_RAM+2		; byte
v_Title_Levelselect_flag:		= Camera_RAM+3		; byte
v_Title_DCount:				= Camera_RAM+6		; word
v_Title_Start:				= Camera_RAM+8		; byte
v_Title_Select:				= Camera_RAM+9		; byte
v_Title_DFactor:				= Camera_RAM+$A		; word
v_Title_DFactor2:				= Camera_RAM+$C		; word
v_Title_DFactor2_Amp:		= Camera_RAM+$E		; byte
; byte
v_Title_Deform_Addr:			= Camera_RAM+$10		; word

; RAM (Extra)
v_Title_Buffer:				= RAM_Start				; $3AC0 bytes
v_Title_Buffer_End			= RAM_Start+$3AC0
v_Title_VDeformBuffer:		= RAM_Start+$3AC0		; $28 bytes

; =============== S U B R O U T I N E =======================================

DetectBadEmulator:
		; check VRAM DMA to see if its length is borked. This detects Gens
		lea	VDP_data_port,a0
		lea	4(a0),a1
		move.l	#$40000000,(a1)				; VRAM WRITE 0
		move.l	$10000,d0				; load ROM value to d0
		not.l	d0					; make sure the value != ROM at address $10000
		move.l	d0,(a0)					; write to VRAM

		move.l	#$93009400,(a1)				; DMA length = $10000
		move.l	#$95009600,(a1)				; DMA source = $xx0000
		move.w	#$9700,(a1)				; DMA source = $00xxxx
		move.l	#$40000080,(a1)				; start DMA to VRAM address $0000

		move.l	#$00000000,(a1)				; VRAM READ $0000
		not.l	d0					; make sure the value == ROM at address $10000
		move.l	(a0),d1					; load VRAM value to d1
		cmp.l	d1,d0					; check if VRAM has the ROM value correctly at $0000
		bne.s	.bademu					; branch if this is bad (this should check Fusion and Gens)

		moveq	#0,d0					; this emulator is good
		rts

.bademu
		moveq	#1,d0					; oh no! this is a bad emulator. Anyway!
		rts
; ---------------------------------------------------------------------------

Title_Screen_Notice_BadEmu:
		move.w	#5*60,(Demo_timer).w

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Demo_timer).w
		bne.s	.loop
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop

.rts
		rts
; ---------------------------------------------------------------------------

Title_Screen_Notice:
		move.w	#9*60,(Demo_timer).w

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Demo_timer).w
		beq.s	.rts
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop

.rts
		rts
; ---------------------------------------------------------------------------

Title_Screen_Notice_Select:
		move.w	#0,Seizure_Flag.w			; enable by default
		bsr.s	.redraw					; draw indicator

.loop
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w

		moveq	#$0C,d0					; check left/right
		and.b	Ctrl_1_pressed.w,d0			; check if either is pressed
		beq.s	.nolr					; if not, do not update flag
		eor.w	#1,Seizure_Flag.w			; toggle between 0000 and 0001
		bsr.s	.redraw					; draw indicator

.nolr
		tst.b	(Ctrl_1_pressed).w
		bpl.s	.loop

.rts
		rts
; ---------------------------------------------------------------------------

.redraw
		tst.w	Seizure_Flag.w				; check if seizure mode is enabled
		sne	d0					; if yes, set d0 to $FF
		and.w	#2,d0					; its either 0 or 2 now
		move.l	.chars(pc,d0.w),d0			; load characters to d0 (this overwrites with either blank or - for each option)

		lea	VDP_data_port,a0			; load data port to a0
		lea	4(a0),a1				; load command port to a1

		locVRAM	$CB14,(a1)				; set VRAM location
		move.w	d0,(a0)					; write tile
		locVRAM	$CB22,(a1)				; set VRAM location
		move.w	d0,(a0)					; write tile
		swap	d0					; get the alternate tile to d0

		locVRAM	$CB2C,(a1)				; set VRAM location
		move.w	d0,(a0)					; write tile
		locVRAM	$CB3C,(a1)				; set VRAM location
		move.w	d0,(a0)					; write tile
		rts

.chars		dc.w $8000, $800D, $8000
; ---------------------------------------------------------------------------

Title_Screen:
		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Pal_FadeToBlack).w
		clr.b	(VilliansMeetingPassed).w
		clr.b	(SCZ1_Cutscene).w
		clr.b	(Check_dead).w
		clr.w	(AstarothCompleted).w
		clr.w	(Death_count).w
		clr.l	(Timer).w
		clr.b	(TSecrets_count).w
		clr.b	(Update_HUD_timer).w
		clr.b	(Extended_mode).w
		jsr	(Clear_Secrets).l
		disableInts
		move.w	#-1,(Previous_zone).w				; MJ: reset previous zone/act
		move.l	#VInt,(V_int_addr).w				; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w				; MJ: restore H-blank address

		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts

		jsr	DetectBadEmulator(pc)				; check if this emulator is terrible
		move.b	d0,(BadEmulator).w				; MJ: store bad emulator flag

		disableScreen
		jsr	(Clear_DisplayData).w
		lea	(VDP_control_port).l,a6

		; Clearing V-scroll in VSRAM
		; Some other screens when using VSRAM in slice mode
		; the contents are still left in there.

		move.l	#$40000010,(a6)					; MJ: set VDP to VSRAM write mode
		moveq	#$00,d0						; MJ: clear d0
		lea	-$04(a6),a5					; MJ: load VDP data port
		moveq	#$14-1,d7					; MJ: number of V-scroll slots

	.ClearVScroll:
		move.l	d0,(a5)						; MJ: clear all VSRAM slots
		dbf	d7,.ClearVScroll				; MJ: ''

		move.w	#$8004,(a6)					; Command $8004 - HInt off, Enable HV counter read
		move.w	#$8200+(vram_fg>>10),(a6)			; Command $8230 - Nametable A at $C000
		move.w	#$8400+(vram_bg>>13),(a6)			; Command $8407 - Nametable B at $E000
		move.w	#$8700+(0<<4),(a6)				; Command $8700 - Background color Pal 0 Color 0
		move.w	#$8B07,(a6)					; Command $8B07 - VScroll cell-based, HScroll line-based
		move.w	#$8C89,(a6)					; Command $8C89 - 40cell screen size, no interlacing, shadow/highlight enabled
		move.w	#$9001,(a6)					; Command $9001 - 64x32 cell nametable area
		move.w	#$9100,(a6)					; Command $9100 - Window H position at default
		move.w	#$9200,(a6)					; Command $9200 - Window V position at default
		jsr	(Clear_Palette).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		lea	PLC_Title(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		cmp.b	#id_TitleWithNotice,Game_mode.w			; check if we should process notices
		bne.w	.nonotice					; branch if not

		lea	(MapEni_TitleBGStar).l,a0
		lea	(RAM_start).l,a1
		move.w	#$8030,d0
		jsr	(Eni_Decomp).w
		copyTilemap	vram_bg, 320, 224
		moveq	#palid_Sonic,d0
		jsr	(LoadPalette).w						; load Sonic's palette

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	-
		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		enableScreen
; ---------------------------------------------------------------------------

		command	cmd_Reset

		tst.b	(BadEmulator).w					; MJ: was this a bad emulator?
		beq.w	.goodemu					; if not, then we good

		lea	Title_TextBadEmu(pc),a1
		locVRAM	$C104,d1
		move.w	#$8000,d3
		jsr	(Load_PlaneText).w
		bsr.w	Pal_TitleFadeFrom
	;	bsr.w	Title_Screen_Notice_BadEmu

		move.w	#$2700,sr					; disable interrupts
		move.l	#$1000000,d1					; delay a long while to hide the sample a little bit...
		swap	d1
	.Delay:	swap	d1
		dbf	d1,*
		swap	d1
		dbf	d1,.Delay

		lea	(Demons).l,a0					; sample start address
		move.l	#Demons_End-Demons,d1				; prepare size of sample
		moveq	#$28,d2						; delay/speed
		jsr	PlayPCM						; play PCM sample

		bra.w	*						; trap...


	;	dmaFillVRAM 0,$C000,(256<<4)	; clear plane A PNT
	;	lea	Title_Text1(pc),a1
	;	locVRAM	$C104,d1
	;	move.w	#$8000,d3
	;	jsr	(Load_PlaneText).w
	;	bra.s	.continue

.goodemu
		music	mus_Notice

		lea	Title_Text1(pc),a1
		locVRAM	$C104,d1
		move.w	#$8000,d3
		jsr	(Load_PlaneText).w
		bsr.w	Pal_TitleFadeFrom
; ---------------------------------------------------------------------------

.continue
		bsr.w	Title_Screen_Notice

		dmaFillVRAM 0,$C000,(256<<4)	; clear plane A PNT
		lea	Title_TextFlash(pc),a1
		locVRAM	$C104,d1
		move.w	#$8000,d3
		jsr	(Load_PlaneText).w
		bsr.w	Title_Screen_Notice_Select
		command	cmd_Reset

		jsr	(Pal_FadeToBlack).w
		disableInts
		dmaFillVRAM 0,$C000,(256<<4)	; clear plane A PNT
		dmaFillVRAM 0,$E000,(256<<4)	; clear plane B PNT

.nonotice
		lea	PLC_Title2(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		samp	sfx_ThunderLightning		; Yes/No?
		move.w	#-$410,(v_Title_DFactor).w
		lea	(MapEni_TitleFG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$A030,d0
		jsr	(Eni_Decomp).w
		copyTilemap	vram_fg, 320, 224
		lea	(MapEni_TitleBG).l,a0
		lea	(RAM_start).l,a1
		move.w	#$E430,d0
		jsr	(Eni_Decomp).w
		copyTilemap	vram_bg, 512, 224
		lea	(Pal_Title).l,a1
		lea	(Target_palette_line_2).w,a2
		moveq	#(16/2)-1,d0
		jsr	(PalLoad_Line.loop).w
		bsr.w	Title_Deform
		lea	obDat_TitleMisc(pc),a1
		lea	(Object_RAM).w,a0
		moveq	#(obDat_TitleMisc_End-obDat_TitleMisc)/$10-1,d1

-		move.l	(a1)+,address(a0)
		move.l	(a1)+,mappings(a0)
		move.w	(a1)+,art_tile(a0)
		move.w	(a1)+,priority(a0)
		move.w	(a1)+,x_pos(a0)
		move.w	(a1)+,y_pos(a0)
		lea	next_object(a0),a0
		dbf	d1,-


;		lea	Title_Text2(pc),a1
;		locVRAM	$C082,d1
;		move.w	#$8000,d3
;		jsr	(Load_PlaneText).w


	if GameDebug
		st	(v_Title_Levelselect_flag).w
	endif

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Kos_Module_Queue).w
		bsr.w	Title_Process
		bsr.w	Title_Deform
		tst.w	(Kos_modules_left).w
		bne.s	-
		clearRAM v_Title_Buffer, v_Title_Buffer_End
		move.w	#3,(v_Title_ProcessTimer).w
		move.b	#$14,(vInsertCoin_TextFactor).w

		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		bsr.w	Title_Process
		bsr.w	Title_Deform
		enableScreen
;		jsr	(Pal_FadeFromBlack).w

		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#$F,subtype(a1)
		move.l	#Target_palette,$30(a1)
		move.w	#Normal_palette,$34(a1)
		move.w	#64-1,$38(a1)
+

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	Title_Process
		bsr.w	Title_Deform
	if ~~GameDebug
		bsr.w	TitleScreen_Code
	endif
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_Title_ProcessEnd).w
		beq.s	-
		sf	(v_Title_ProcessEnd).w
		move.l	#Obj_PressStartSelect_Process,(Reserved_object_3).w

-		move.b	#VintID_Main,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		bsr.w	Title_Deform
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.b	(v_Title_ProcessEnd).w
		beq.s	-
		cmpi.b	#2,(v_Title_Select).w
		bne.s	TitleScreen_End
		move.b	#id_Options,(Game_mode).w
		rts
; ---------------------------------------------------------------------------

TitleScreen_End:
		moveq	#0,d0						; default Zone and Act if no SRAM present

		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; load from first slot
		jsr	LoadSlot					; load it
		beq.s	.FailLoad					; if failed, skip saving
		move.b	SR_Difficulty(a0),d0				; load difficulty setting
		move.w	d0,(Difficulty_Flag).w				; set it correctly
		move.b	SR_Camera(a0),d0				; load camera mode
		move.w	d0,(ExtendedCam_Flag).w				; set camera mode correctly

		cmpi.b	#1,(v_Title_Select).w
		beq.s	.exmode

		tst.b	SR_Complete(a0)					; has the game been completed?
		bne.s	.LevelSelect					; if so, go straight to level select
		move.b	SR_Zone(a0),d0					; load Zone and Act
		lsl.w	#$08,d0						; ''
		move.b	SR_Act(a0),d0					; ''

.FailLoad:
		cmpi.b	#1,(v_Title_Select).w
		beq.s	.exmode

.FailLoad2:
		move.w	d0,(Current_zone_and_act).w
		move.w	d0,(Transition_Zone).w

		moveq	#id_Level,d0
		tst.w	(Difficulty_Flag).w
		bne.s	+
		moveq	#id_AssistWarning,d0
+
		tst.b (Extended_mode).w
		beq.s	+
		moveq	#id_EXMode,d0
+
		tst.b	(v_Title_Levelselect_flag).w
		beq.s	+
		btst	#button_A,(Ctrl_1_held).w
		beq.s	+

.LevelSelect:
		moveq	#id_LevelSelect,d0
+
		move.b	d0,(Game_mode).w
		rts
; ---------------------------------------------------------------------------

.exmode

		; set
		move.b	#1,(Update_HUD_timer).w
		st	(Extended_mode).w

		moveq	#0,d0						; default Zone and Act
		bra.s	.FailLoad2

; ---------------------------------------------------------------------------
; Title process
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Title_Process:
		clr.w	d0
		move.b	(Object_load_routine).w,d0
		jmp	.index(pc,d0.w)
; ---------------------------------------------------------------------------

.index:
		bra.w	Title_Process_DeformFBG				; 0
		bra.w	Title_Process_DeformFBG_Increase		; 4
		bra.w	Title_Process_DeformFBG_Amplitude	; 8
		bra.w	Title_Process_LoadLogo				; C
		bra.w	Title_Process_PressButton				; 10
		bra.w	Title_Process_Wait					; 14
		bra.w	Title_Process_Return					; 18
; ---------------------------------------------------------------------------

Title_Process_DeformFBG:
		addq.w	#8,(v_Title_DFactor).w
		bmi.w	Title_Process_Return
		addq.b	#4,(Object_load_routine).w

Title_Process_DeformFBG_Increase:
		moveq	#8,d0
		addq.w	#1,(v_Title_DFactor2).w
		cmp.w	(v_Title_DFactor2).w,d0
		bhs.s	Title_Process_DeformFBG_Amplitude
		move.w	d0,(v_Title_DFactor2).w
		addq.b	#4,(Object_load_routine).w

Title_Process_DeformFBG_Amplitude:
		move.b	(v_Title_DFactor2_Amp).w,d0
		addq.b	#2,(v_Title_DFactor2_Amp).w
		jsr	(GetSineCosine).w
		muls.w	(v_Title_DFactor2).w,d1
		asr.l	#8,d1
		move.w	d1,(v_Title_DFactor).w
		bne.w	Title_Process_Return
		cmpi.b	#4,(Object_load_routine).w
		beq.w	Title_Process_Return
		clr.w	(v_Title_DFactor).w
		addq.b	#4,(Object_load_routine).w
		move.w	#$5F,(v_Title_ProcessTimer).w
		jsr	(Create_New_Sprite).w
		bne.s	Title_Process_LoadLogo
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#1,subtype(a1)
		move.w	#$23,$2E(a1)
		move.l	#Pal_Title,$30(a1)
		move.w	#Normal_palette_line_3,$34(a1)
		move.w	#16-1,$38(a1)

Title_Process_LoadLogo:
		subq.w	#1,(v_Title_ProcessTimer).w
		bpl.w	Title_Process_Return
		clr.w	(v_Title_ProcessTimer).w
		lea	(ArtUnc_TitleLogo).l,a1									; Original Art
		lea	(RAM_Start).l,a2											; Mod Art
		move.w	#((ArtUnc_TitleLogo_End-ArtUnc_TitleLogo)/$20)-1,d5	; Art size
		jsr	InsertCoin_SmoothDrawArtText
		move.l	#RAM_Start>>1,d1
		move.w	#tiles_to_bytes($250),d2								; VRAM
		move.w	#(ArtUnc_TitleLogo_End-ArtUnc_TitleLogo)/2,d3			; Size/2
		jsr	(Add_To_DMA_Queue).w
		tst.b	(vInsertCoin_TextFactor).w
		bne.w	Title_Process_Return
		addq.b	#4,(Object_load_routine).w
		music	mus_Title,0
		jsr	(Create_New_Sprite).w
		bne.s	Title_Process_PressButton
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#$F,subtype(a1)
		move.l	#Pal_Title+$20,$30(a1)
		move.w	#Normal_palette_line_4,$34(a1)
		move.w	#16-1,$38(a1)

Title_Process_PressButton:
		tst.b	(v_Title_Start).w
		beq.s	Title_Process_Return
		addq.b	#4,(Object_load_routine).w
		move.w	#60,(v_Title_ProcessTimer).w
		sfx	sfx_Start,0		; CastlevaniaStart
		samp	sfx_Mwahaha

Title_Process_Wait:
		subq.w	#1,(v_Title_ProcessTimer).w
		bpl.s	Title_Process_Return
		addq.b	#4,(Object_load_routine).w
		st	(v_Title_ProcessEnd).w

Title_Process_Return:
		rts

; ---------------------------------------------------------------------------
; Logo (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_TitleLogo:
		cmpi.b	#$10,(Object_load_routine).w
		blo.s		TitleLogo_Draw
		move.l	#TitleLogo_Swing,address(a0)
		moveq	#$30,d0
		move.w	d0,$3E(a0)
		neg.w	d0
		move.w	d0,y_vel(a0)
		move.w	#1,$40(a0)
		bclr	#0,$38(a0)

TitleLogo_Swing:
		lea	(v_Dust).w,a1
		cmpi.l	#PressStartSelect_Remove,address(a1)
		beq.s	TitleLogo_MoveUpSet
		jsr	(Swing_UpAndDown).w

TitleLogo_Move:
		jsr	(MoveSprite2).w

TitleLogo_Draw:
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

TitleLogo_MoveUpSet:
		move.l	#TitleLogo_MoveUp,address(a0)

TitleLogo_MoveUp:
		subi.w	#$38,y_vel(a0)
		tst.w	y_pos(a0)
		bpl.s	TitleLogo_Move
		bra.s	PressStart_Remove

; ---------------------------------------------------------------------------
; Press Start (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_PressStart:
		cmpi.b	#$10,(Object_load_routine).w
		blo.s		PressStart_Main
		addq.b	#1,mapping_frame(a0)
		move.w	#-$200,y_vel(a0)
		move.l	#PressStart_CheckPos,address(a0)

PressStart_CheckPos:
		move.w	#$184,d0
		cmp.w	y_pos(a0),d0
		bhs.s	PressStart_Main
		move.w	d0,y_pos(a0)
		move.l	#PressStart_MoveUp,address(a0)

PressStart_MoveUp:
		addq.w	#8,y_vel(a0)
		bmi.s	PressStart_Main
		move.l	#PressStart_Flashing,address(a0)
		clr.w	y_vel(a0)

PressStart_Flashing:
		moveq	#5,d1
		bsr.s	PressStart_FlashingProcess
		tst.b	(Ctrl_1_pressed).w
		bpl.s	PressStart_Return
		st	(v_Title_Start).w
		move.l	#PressStart_FlashingPressStart,address(a0)

PressStart_Return:
		rts
; ---------------------------------------------------------------------------

PressStart_FlashingPressStart:
		moveq	#1,d1

PressStart_FlashingProcess:
		moveq	#0,d0
		btst	d1,(Level_frame_counter+1).w
		beq.s	+
		addq.b	#1,d0
+		move.b	d0,mapping_frame(a0)

PressStart_Main:
		tst.b	(v_Title_ProcessEnd).w
		bne.s	PressStart_Remove
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

PressStart_Remove:
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Press Start Select (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_PressStartSelect_Process:
		lea	(v_Dust).w,a1
		move.l	#PressStartSelect_Process_Wait,address(a0)

; Object 1
		move.l	#Map_TitleText,d1				; MJ: use default "START" graphics
		pea	(a0)						; MJ: store object
		lea	(TempSaveRAM).l,a0				; MJ: load temporary save RAM
		moveq	#$00,d0						; MJ: load first slot
		jsr	LoadSlot					; MJ: ''
		beq.s	.NoLoad						; MJ: if SRAM is invalid, skip...
		move.b	SR_Zone(a0),d0					; MJ: is Zone and Act at beginning?
		or.b	SR_Act(a0),d0					; MJ: ''
		beq.s	.NoLoad						; MJ: if so, skip...
		move.l	#Map_TitleText3,d1				; MJ: use "CONTINUE" graphics instead

	.NoLoad:
		move.l	(sp)+,a0					; MJ: restore object

		move.l	#Obj_PressStartSelect,address(a1)
		move.l	d1,mappings(a1)
		move.w	#$A490,art_tile(a1)
		move.w	#$80,priority(a1)
		move.w	#$D8,x_pos(a1)
		move.w	#$180,y_pos(a1)
		clr.b	mapping_frame(a1)
		clr.w	$2E(a1)

; Object 2
		lea	next_object(a1),a1
		move.l	#Obj_PressStartSelect,address(a1)
		move.l	#Map_TitleText4,mappings(a1)
		move.w	#$A490,art_tile(a1)
		move.w	#$80,priority(a1)
		move.w	#$D8,x_pos(a1)
		move.w	#$180,y_pos(a1)
		move.b	#2,subtype(a1)
		clr.b	mapping_frame(a1)
		move.w	#7,$2E(a1)

; Object 3
		lea	next_object(a1),a1
		move.l	#Obj_PressStartSelect,address(a1)
		move.l	#Map_TitleText2,mappings(a1)
		move.w	#$A490,art_tile(a1)
		move.w	#$80,priority(a1)
		move.w	#$D8,x_pos(a1)
		move.w	#$180,y_pos(a1)
		move.b	#2,subtype(a1)
		clr.b	mapping_frame(a1)
		move.w	#7*2,$2E(a1)

PressStartSelect_Process_Wait:
		rts
; ---------------------------------------------------------------------------

PressStartSelect_Process_Control:
		moveq	#3-1,d3
		move.b	(v_Title_Select).w,d2
		move.b	(Ctrl_1_pressed).w,d1
		btst	#bitUp,d1							; is button Up pressed?
		beq.s	.notup							; if not, branch
		samp	sfx_WalkingArmorAtk
		subq.b	#1,d2
		bpl.s	.notup
		move.b	d3,d2

.notup
		btst	#bitDn,d1							; is button Down pressed?
		beq.s	.notpress							; if not, branch
		samp	sfx_WalkingArmorAtk
		addq.b	#1,d2
		cmp.b	d3,d2
		bls.s		.notpress
		moveq	#0,d2

.notpress
		move.b	d2,(v_Title_Select).w
		lea	(v_Dust).w,a1
		move.b	d2,anim(a1)
		lea	next_object(a1),a1
		move.b	d2,anim(a1)
		lea	next_object(a1),a1
		move.b	d2,anim(a1)

		; check
		tst.b	(Ctrl_1_pressed).w
		bpl.s	PressStartSelect_Process_Return
		fadeout				; fade out music
		sfx	sfx_Start,0		; CastlevaniaStart
		move.l	#Delete_Current_Sprite,address(a0)
		lea	(v_Dust).w,a1
		move.w	#$27+7,$2E(a1)
		addq.b	#1,d2
		move.b	d2,mapping_frame(a1)
		move.l	#PressStartSelect_Remove,address(a1)
		lea	next_object(a1),a1
		move.w	#$27,$2E(a1)
		move.b	d2,mapping_frame(a1)
		move.l	#PressStartSelect_Remove,address(a1)
		lea	next_object(a1),a1
		move.w	#$27-7,$2E(a1)
		move.b	d2,mapping_frame(a1)
		move.l	#PressStartSelect_Remove,address(a1)

PressStartSelect_Process_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_PressStartSelect:
		subq.w	#1,$2E(a0)
		bpl.s	PressStartSelect_Process_Return
		move.w	#-$200,y_vel(a0)
		move.l	#PressStartSelect_CheckPos,address(a0)

PressStartSelect_CheckPos:
		move.w	#$178,d0
		cmp.w	y_pos(a0),d0
		blo.s		PressStartSelect_Draw
		move.w	d0,y_pos(a0)
		move.l	#PressStartSelect_MoveUp,address(a0)

PressStartSelect_MoveUp:
		addq.w	#8,y_vel(a0)
		bmi.s	PressStartSelect_Draw
		clr.w	y_vel(a0)
		move.l	#PressStartSelect_Flashing,address(a0)
		tst.b	subtype(a0)
		bne.s	PressStartSelect_Flashing
		lea	(Reserved_object_3).w,a1
		move.l	#PressStartSelect_Process_Control,address(a1)

PressStartSelect_Flashing:
		lea	Ani_TitleText(pc),a1
		jsr	(AnimateSprite).w

PressStartSelect_Draw:
		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

PressStartSelect_Remove:
		subq.w	#1,$2E(a0)
		bmi.s	PressStartSelect_Remove2

PressStartSelect_RemoveDraw:
		btst	#0,(Level_frame_counter+1).w
		bne.s	PressStartSelect_Draw
		rts
; ---------------------------------------------------------------------------

PressStartSelect_Remove2:
		move.w	#$1F,$2E(a0)
		move.l	#PressStartSelect_RemoveDown,address(a0)
		tst.b	subtype(a0)
		bne.s	PressStartSelect_RemoveDown
		jsr	(Create_New_Sprite).w
		bne.s	PressStartSelect_RemoveDown
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#7,subtype(a1)
		move.w	#$F,$2E(a1)
		move.l	#Pal_Title+$40,$30(a1)
		move.w	#Normal_palette_line_1,$34(a1)
		move.w	#64-1,$38(a1)

PressStartSelect_RemoveDown:
		jsr	(MoveSprite).w
		subq.w	#1,$2E(a0)
		bpl.s	PressStartSelect_RemoveDraw
		move.l	#Delete_Current_Sprite,address(a0)
		tst.b	subtype(a0)
		bne.s	PressStartSelect_Return
		st	(v_Title_ProcessEnd).w

PressStartSelect_Return:
		rts

; =============== S U B R O U T I N E =======================================

Pal_TitleFadeFrom:
		moveq	#$15,d7

-		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Wait_VSync).w
		move.b	(V_int_run_count+3).w,d6
		andi.b	#8-1,d6
		bne.s	-
		lea	(Target_palette).w,a1
		lea	(Normal_palette_line_1).w,a0
		moveq	#16-1,d6

-		jsr	(Pal_AddColor).w
		dbf	d6,-
		dbf	d7,--
		rts

; =============== S U B R O U T I N E =======================================

Pal_TitleFade:
		moveq	#$15,d7

-		move.b	#VintID_Fade,(V_int_routine).w
		jsr	(Wait_VSync).w
		move.b	(V_int_run_count+3).w,d6
		andi.b	#8-1,d6
		bne.s	-
		lea	(Normal_palette_line_1).w,a0
		moveq	#16-1,d6

-		jsr	(Pal_DecColor).w
		dbf	d6,-
		dbf	d7,--
		rts

; =============== S U B R O U T I N E =======================================

	; Here, we praying to the GOD for protecting our code from bugs and other things.
	; This is really crucial step! Be adviced to not remove it, even if you don't believer.
	; See: https://www.youtube.com/watch?v=uPtRPBZb2h4

Title_Deform:
		lea	(SineTable).w,a1
		move.w	(Level_frame_counter).w,d0
		cmpi.b	#$10,(Object_load_routine).w
		blo.w	Title_StartupDeform

; BG (Fire)	; Horizontal deformation
		lea	(H_scroll_buffer+(20*4)+2).w,a0
		move.w	d0,d3
		move.w	d0,d4
		andi.w	#$FE,d0
		add.w	d0,d0
		add.w	d0,d0
		neg.w	d3
		asr.w	#3,d3
		move.w	#168,d6

-		andi.w	#$1FE,d0
		move.w	(a1,d0.w),d1
		ext.l	d1
		lsl.l	#6,d1
		moveq	#$40,d2
		sub.w	d6,d2
		addi.w	#$20,d2
		lsl.l	#6,d2
		addq.w	#1,d2
		divs.w	d2,d1
		add.w	d3,d1
		move.w	d1,(a0)+
		addq.w	#2,a0		; skip FG
		addi.w	#$20,d0
		dbf	d6,-

; BG (Fire)	; Vertical deformation (Maybe it is better to use DMA there?)
		disableIntsSave
		lea	(v_Title_VDeformBuffer).l,a0
		lea	(VDP_data_port).l,a6
		move.l	#vdpComm($0000,VSRAM,WRITE),VDP_control_port-VDP_data_port(a6)
		move.w	d4,d0
		add.w	d0,d0
		moveq	#((320*2)/16)/2-1,d6

-		andi.w	#$1FE,d0
		move.w	(a1,d0.w),d1
		muls.w	#3,d1
		asr.l	#8,d1
		move.w	d1,(a0)
		move.w	#0,VDP_data_port-VDP_data_port(a6)
		move.w	(a0)+,VDP_data_port-VDP_data_port(a6)
		addq.w	#8,d0
		dbf	d6,-
		enableIntsSave
		rts

; =============== S U B R O U T I N E =======================================

Title_StartupDeform:
		lea	(H_scroll_buffer).w,a0
		add.w	d0,d0
		move.w	#512-2,d2
		moveq	#bytesToXcnt(224,8),d6
		move.w	(v_Title_DFactor).w,d3

; FG (Wall)

-
	rept 8
		and.w	d2,d0
		move.w	(a1,d0.w),d1
		muls.w	d3,d1
		asr.l	#8,d1
		move.w	d1,(a0)+
		addq.w	#2,a0		; skip BG
		addq.w	#2,d0
	endr

		dbf	d6,-
		rts

	if ~~GameDebug

; =============== S U B R O U T I N E =======================================

TitleScreen_Code:
		lea	TitleScreen_CodeDat(pc),a1
		lea	(v_Title_DCount).w,a2
		moveq	#0,d0
		move.b	(a2),d0
		adda.w	d0,a1
		move.b	(Ctrl_1_pressed).w,d0
		andi.b	#$7F,d0
		beq.s	TitleScreen_Code_Return
		move.b	(Ctrl_1).w,d0
		cmp.b	(a1)+,d0
		bne.s	TitleScreen_Code_Fail
		addq.b	#1,(a2)
		tst.b	(a1)
		bne.s	TitleScreen_Code_Return
		sfx	sfx_FireShow,0
		st	(v_Title_Levelselect_flag).w

TitleScreen_Code_Fail:
		clr.b	(a2)

TitleScreen_Code_Return:
		rts
; ---------------------------------------------------------------------------

TitleScreen_CodeDat:
		dc.b btnUp, btnUp, btnDn, btnDn, btnL, btnR, btnL, btnR, btnB, btnA
		dc.b 0		; Stop
	even
	endif
; ---------------------------------------------------------------------------

obDat_TitleMisc:
		dc.l Obj_TitleLogo, Map_TitleLogo		; 0
		dc.w $C250, $100, $120, $DC
		dc.l Obj_PressStart, Map_TitleMisc		; 1
		dc.w $E470, $80, $100, $188
obDat_TitleMisc_End

PLC_Title: plrlistheader
		plreq 1, ArtKosM_CreditsText
		plreq $30, ArtKosM_TitleBGStar
		plreq $470, ArtKosM_TitleMisc
		plreq $490, ArtKosM_TitleText
PLC_Title_End

PLC_Title2: plrlistheader
		plreq $30, ArtKosM_TitleFG
		plreq $430, ArtKosM_TitleBG
PLC_Title2_End

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

Title_TextBadEmu:
		dc.b "               Notice",$84
		dc.b "    Your emulator is unsupported",$80
		dc.b "     and will result in glitches",$80
		dc.b "      and unknown other issues.",$82
		dc.b "     The emulator you are using",$80
		dc.b "     is very inaccurate and out",$80
		dc.b "       of date, and you should",$80
		dc.b "     consider using a newer one.",$82
		dc.b "        We recommend BlastEm",$80
		dc.b "        and Genesis Plus GX.",$83
		dc.b "    Thank you for understanding.",-1

Title_Text1:
		dc.b "               Notice",$84
		dc.b "   This hack is a tribute to the",$80
		dc.b "    Sonic, Ghosts n Goblins and ",$80
		dc.b "        Castlevania series.",$82
		dc.b "   Even though this hack includes",$80
		dc.b "     hell, demons and bloodshed,",$80
		dc.b "it has nothing to do with Sonic.EXE.",$83
		dc.b "       We hope you will enjoy",$80
		dc.b "     playing this sonic 3k hack.",$85
		dc.b "        Press *start* button",-1
Title_Text2:
		dc.b "SHC2023",-1

Title_TextFlash:
		dc.b "               Notice",$84
		dc.b "This game features flashing effects",$80
		dc.b "       to make certain events",$80
		dc.b "        feel more impactful.",$81
		dc.b "  However, if you do not want them,",$80
		dc.b "     you can disable them below.",$82
		dc.b "     If you are photosensitive,",$80
		dc.b "   please exercise extra caution.",$82
		dc.b "  This setting can also be changed",$80
		dc.b "           in the options.",$81
		dc.b "         Enable      Disable",-1
		even

		CHARSET ; reset character set

; ---------------------------------------------------------------------------

		include "Data/Screens/Title/Object data/Anim - Text.asm"
		include "Data/Screens/Title/Object data/Map - Logo.asm"
		include "Data/Screens/Title/Object data/Map - Misc.asm"
		include "Data/Screens/Title/Object data/Map - Text.asm"
		include "Data/Screens/Title/Object data/Map - Text2.asm"
		include "Data/Screens/Title/Object data/Map - Text3.asm"
		include "Data/Screens/Title/Object data/Map - Text4.asm"

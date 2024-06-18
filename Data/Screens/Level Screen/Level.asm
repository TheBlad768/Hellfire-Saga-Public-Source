; ===========================================================================
; ---------------------------------------------------------------------------
; Level screen
; ---------------------------------------------------------------------------

GM_Level:
		bset	#GameModeFlag_TitleCard,(Game_mode).w		; Set bit 7 is indicate that we're loading the level
		fadeout					; fade out music

		jsr	(Clear_Kos_Module_Queue).w					; Clear KosM PLCs
		jsr	(Pal_FadeToBlack).w
		move.b  #$00,(Check_GluttonyDead).w
		move.b  #0,(Lust_Dead).w
		move.w	(Current_zone).w,(Transition_Zone).w		; update transition zone to current zone

		jsr	SaveZoneSRAM					; MJ: save zone/act to SRAM

		move.w	(Current_zone).w,d0				; MJ: load the current zone/act
		cmp.w	(Previous_zone).w,d0				; MJ: has it changed?
		sne.b	(FirstRun).w					; MJ: set/clear the first run flag if this zone has been played before (after death)
		move.w	d0,(Previous_zone).w				; MJ: update previous zone/act
		disableInts
		move.l	#VInt,(V_int_addr).w				; MJ: restore V-blank address
		move.l	#HInt,(H_int_addr).w				; MJ: restore H-blank address
		jsr	(ClearScreen).w
		enableInts
		tst.b	(Last_star_post_hit).w
		beq.s	+										; If no lampost was set, branch
		move.w	(Saved_zone_and_act).w,(Current_zone_and_act).w
+
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts

		lea	(VDP_control_port).l,a6
		move.w	#$8004,(a6)								; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6)				; set foreground nametable address
		move.w	#$8300+($DC00>>10),(a6)				; set window nametable address
		move.w	#$8400+(vram_bg>>13),(a6)				; set background nametable address
		move.w	#$8700+(2<<4),(a6)						; set background colour (line 3; colour 0)
		move.w	#$8B03,(a6)								; line scroll mode
		move.w	#$8C81,(a6)
		move.w	#$9001,(a6)								; 64-cell hscroll size
		move.w	#$9200,(a6)

		moveq	#$00,d0						; MJ: clear d0

		lea	(CreditsData).l,a0				; MJ: load credits RAM
		moveq	#((CreditsData_End-CreditsData)/2)-1,d7		; MJ: size to clear

	.ResetCredits:
		move.w	d0,(a0)+					; MJ: clear credits RAM (must be done on non-credits levels too...
		dbf	d7,.ResetCredits				; MJ: ...to ensure they don't run anything credits related)

		lea	(Map_PlantFG).l,a2				; MJ: load FG plant mapping RAM storage area
		moveq	#OBJFGP_SLOTS-1,d6				; MJ: number of slots to clear

	.ClearPlantMap:
		move.l	d0,(a2)+					; MJ: clear all slots
		dbf	d6,.ClearPlantMap				; MJ: ''

		sf.b	(PauseSlot).w					; MJ: reset pause menu option to top
		sf.b	(YouDiedY).w					; MJ: reset "You Died" Y position

	; --- Credits Screen - MarkeyJester -------------------
	; This section will display the credits screen
	; and load the misc PLC art before the level
	; fades in, since the line art version of the level's graphics
	; are in the PLC, they load too late for the level
	; -----------------------------------------------------

		cmpi.b	#$04,(Current_Zone).w				; is this the credits?
		bne.w	.NoMessage					; if not, skip message
		lea	(PLC1_CRE_Misc).l,a5				; load misc PLC list
		jsr	(LoadPLC_Raw_KosM).w				; ''

	.KosDec_Credits:
		move.b	#VintID_TitleCard,(V_int_routine).w		; interrupt routine
		jsr	(Process_Kos_Queue).w				; decompress module
		jsr	(Wait_VSync).w					; wait for V-blank
		jsr	(Process_Kos_Module_Queue).w			; obtain next art file if previous one is finished
		tst.w	(Kos_modules_left).w				; have all art files fully decompressed and transferred?
		bne.s	.KosDec_Credits					; if not, loop

		moveq	#$00,d0						; load Sonic's palette
		jsr	(LoadPalette).w					; ''
		lea	.MisoPal(pc),a0					; load miso small logo palette
		lea	(Target_palette+$20).w,a1			; buffer to second line
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''
		move.l	(a0)+,(a1)+					; ''


		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port
		movea.l	(CRE_TextList).l,a0				; text to draw (first entry)
		sf.b	(CreditsMessage).w				; reset credits text to start on
		clr.l	(CreditsRoutine).w				; set no text routine to start with
		move.w	#(VRAM_CreditsText/$20)-1,d1			; character art VRAM address
		move.l	#$438C0003,d2					; plane VRAM address
		jsr	CRE_DrawText					; draw the text

		lea	(Sprite_table_buffer).w,a1
		lea	.MisoMap(pc),a0
		move.w	(a0)+,d7					; load number of pieces
		bmi.s	.NoMiso						; if there are no pieces, branch
		move.w	#$A000|(VRAM_CreditsMiso/$20),d3		; base index
		move.w	#108,d1
		move.w	#62,d2

	.NextMiso:
		move.w	(a0)+,d0					; load Y
		add.w	d2,d0						; add base Y
		move.w	d0,(a1)+					; save to table
		move.w	(a0)+,d0					; load shape
		move.b	d0,(a1)+					; save shape
		addq.w	#$01,a1						; skip link
		move.w	(a0)+,d0					; load pattern
		add.w	d3,d0						; add base pattern
		move.w	d0,(a1)+					; save to table
		move.w	(a0)+,d0					; load X
		add.w	d1,d0						; add base X
		move.w	d0,(a1)+					; save to table
		dbf	d7,.NextMiso					; repeat for all pieces

	.NoMiso:

		move.w	#60*1,(Demo_timer).w				; set time before showing the screen
	.Black:	move.b	#VintID_TitleCard,(V_int_routine).w		; interrupt routine
		jsr	(Wait_VSync).w					; wait for V-blank
		subq.w	#$01,(Demo_timer).w				; decrease delay timer
		bcc.s	.Black						; if not finished, continue waiting

		jsr	(Pal_FadeFromBlack).w				; fade in
		move.w	#60*12,(Demo_timer).w				; set time to show the screen
	.Wait:	move.b	#VintID_TitleCard,(V_int_routine).w		; interrupt routine
		jsr	(Wait_VSync).w					; wait for V-blank
		subq.w	#$01,(Demo_timer).w				; decrease delay timer
		bcc.s	.Wait						; if not finished, continue waiting
		jsr	(Pal_FadeToBlack).w				; fade out
		disableInts
		dmaFillVRAM 0,$C000,$1000				; clear plane RAM
		clearRAM Sprite_table_buffer, Sprite_table_buffer_End	; clear sprite table
		jsr	Init_SpriteTable				; reinitialise the table...

		lea	(CreditsLetters).l,a0				; MJ: clear letter space
		moveq	#$00,d0						; ''
		move.w	#(($2000/4)/4)-1,d1				; '' size of clear

	.Clear:
		move.l	d0,(a0)+					; ''
		move.l	d0,(a0)+					; ''
		move.l	d0,(a0)+					; ''
		move.l	d0,(a0)+					; ''
		dbf	d1,.Clear					; ''
		st.b	(CreditsLetters+CreShape).l			; force last piece on first entry
		st.b	(CreditsText_Ready).w				; allow text sprites to show
		bra.s	.NoMessage

	.MisoPal: binclude "Data\Screens\Thanks\Data\Red Miso Logo\Pal.bin"
		even
	.MisoMap: binclude "Data\Screens\Thanks\Data\Red Miso Logo\Map.bin"
		even

	.NoMessage:

	; --- Pause menu art ----------------------------------

		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port

	;	move.l	#$8F019780,(a6)					; set increment mode and DMA mode
	;	move.l	#$94FF93E0,(a6)					; set DMA size
	;	move.l	#$96009500,(a6)					; set DMA source (null for fill)
	;	move.l	#$40200080,(a6)					; set DMA destination
	;	move.w	#$1111,(a5)					; set DMA fill value
	;	nop
	;	nop
	;	nop
	;	nop
	;	move.w	(a6),ccr					; load status
	;	bvs.s	*-$02						; if the VDP DMA busy flag was set (bit 1), branch to wait til finished...
	;	move.w	#$8F02,(a6)					; set VDP increment mode back to normal

	move.w	#$2700,sr
		lea	(ArtUnc_Pause).l,a0				; load pause art
		move.l	#$40000000|vdpCommDelta((ArtTile_Pause*$20)),(a6) ; set write address
		move.w	#((ArtUnc_Pause_End-ArtUnc_Pause)/4)-1,d7	; size of art to load

	.LoadPauseArt:
		move.l	(a0)+,(a5)					; copy tiles
		dbf	d7,.LoadPauseArt				; repeat until pause menu is copied over
	move.w	#$2300,sr

	; -----------------------------------------------------

	if GameDebug=1
		btst	#bitA,(Ctrl_1).w								; is A button held?
		beq.s	+										; if not, branch
		move.b	#1,(Debug_mode_flag).w 					; enable debug mode
+
	endif

		move.l	#$8AFF8800,(H_int_counter_command).w		; set palette change position (for water)
		move.w	(H_int_counter_command).w,(a6)
		ResetDMAQueue
		lea	(PLC_Main).l,a5
		jsr	(LoadPLC_Raw_KosM).w						; load hud and ring art
		jsr	(CheckLevelForWater).l
		clearRAM Water_palette_line_2, Normal_palette

		cmpi.w	#$0300,(Current_zone).w				; MJ: is this DDZ?
		bne.s	.NoDDZ						; MJ: if not, continue normally
		jsr	Level_InitDDZ					; MJ: setup ready for DDZ boss

	.NoDDZ:
		; AF: this code will load normal and water palette into d0
		jsr	GetLevelPaletteId(pc)				; load palette ID's
		move.w	d0,d1
		jsr	(LoadPalette).w					; load Sonic's dry palette
		move.w	d1,d0
		jsr	(LoadPalette_Immediate).w

		tst.b	(Water_flag).w
		beq.s	+
		move.w	#$8014,VDP_control_port-VDP_control_port(a6)	; H-int enabled

		swap	d0						; this is water palette from above line
		move.w	d0,d1
		jsr	(LoadPalette2).w				; load Sonic's water palette
		move.w	d1,d0
		jsr	(LoadPalette2_Immediate).w
+
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#5,d0
		lea	(LevelMusic_Playlist).l,a1						; load music playlist
		move.l	#Obj_Song_Fade_Transition_LevelStart,(Reserved_object_2).w
		move.w	(a1,d0.w),(Reserved_object_2+subtype).w					; play music after fadeout
		move.l	#Obj_TitleCard,(Dynamic_object_RAM+(object_size*5)).w			; load title card object

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Dynamic_object_RAM+(object_size*5)+objoff_48).w		; has title card sequence finished?
		bne.s	-													; if not, branch
		tst.w	(Kos_modules_left).w									; are there any items in the pattern load cue?
		bne.s	-													; if yes, branch

	if GameDebug=1
		disableInts
		jsr	(HUD_DrawInitial).w
		enableInts
	endif

		jsr	(LoadLevelPointer).w
		jsr	(Get_LevelSizeStart).l
		jsr	(ScrollCamera).w
		jsr	(LoadLevelLoadBlock).w
		jsr	(LoadLevelLoadBlock2).w
		disableInts
		jsr	(LevelSetup).l
		enableInts

		cmpi.b	#$04,(Current_Zone).w					; MJ: is this the credits?
		bne.s	.NoCreditsBound						; MJ: if not, skip boundary setting
		move.w	(CRE_RT_Hold.Bound).l,d0				; MJ: set first boundary
		move.w	d0,(CreditsBoundPos).w					; MJ: ''
		move.w	d0,(Camera_max_X_pos).w					; MJ: ''

	.NoCreditsBound:
		jsr	(Load_Solids).w
		jsr	(Handle_Onscreen_Water_Height).l
		moveq	#0,d0
		move.w	d0,(Ctrl_1_logical).w
		move.w	d0,(Ctrl_1).w
		move.l	d0,(HP_Ani_Frames).w					; NOV: Clear HUD ring animation frames
		move.b	d0,(HUD_State).w

		tst.b	(Last_star_post_hit).w					; are you starting from a lamppost?
		bne.s	+										; if yes, branch
		move.b	d0,(Ring_count).w						; set rings
		move.b	d0,(Saved_status_secondary).w

+		move.b	d0,(Time_over_flag).w
		jsr	(OscillateNumInit).w
		tst.b	(Last_star_post_hit).w
		bne.s	.razborki
		move.b	#25,(v_rings).w				; NOV: Maximize HP
		move.b	#25,(v_prevhp).w			; NOV: ''
		bra.s	.contload

.razborki:
		cmpi.b	#10,(v_rings).w				; NOV: Is the HP at least at 2 HP rings?
		bge.s	.contload					; NOV: If so, branch
		move.b	#10,(v_rings).w				; NOV: Cap HP at 2 HP rings
		move.b	#10,(v_prevhp).w			; NOV: ''

.contload:
		move.b	#1,(Ctrl_1_locked).w
		move.b	#1,(Update_HUD_ring_count).w			; update rings counter
		move.b	#1,(Level_started_flag).w
		tst.b	(Water_flag).w
		beq.s	+
		move.l	#Obj_WaterWave,(v_WaterWave).w
+		bsr.w	SpawnLevelMainSprites
		jsr	(Load_Sprites).w
		jsr	(Load_Rings).w
		jsr	(Process_Sprites).w
		jsr	(Render_Sprites).w
		jsr	(Animate_Tiles).l
		jsr	(LoadWaterPalette).l
		clearRAM Water_palette_line_2, Normal_palette
		move.w	#bytes_to_word(16*2,48-1),(Palette_fade_info).w	; set fade info and fade count
		jsr	(Pal_FillBlack).w
		moveq	#22,d0
		move.w	d0,(Palette_fade_timer).w								; time for Pal_FromBlack
		move.w	d0,(Dynamic_object_RAM+(object_size*5)+objoff_2E).w	; time for Title Card
		move.w	#$7F00,(Ctrl_1).w
		andi.b	#$7F,(Last_star_post_hit).w
		bclr	#GameModeFlag_TitleCard,(Game_mode).w		; subtract $80 from mode to end pre-level stuff

; ---------------------------------------------------------------------------

ML_Level:
		jsr	(Pause_Game).w
		move.b	#VintID_Level,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		jsr	(Wait_VSync).w
		addq.w	#1,(Level_frame_counter).w
		jsr	(Animate_Palette).l
		jsr	(Load_Sprites).w
		jsr	(Process_Sprites).w
		tst.w	(Restart_level_flag).w
		bne.w	GM_Level
		jsr	(ScrollCamera).w
		jsr	(ScreenEvents).l
		jsr	(Handle_Onscreen_Water_Height).l
		jsr	(Load_Rings).w
		jsr	(Animate_Tiles).l
		jsr	(Process_Kos_Module_Queue).w
		jsr	(OscillateNumDo).w
		jsr	(SynchroAnimate).w
		cmpi.b	#$04,(Current_Zone).w				; MJ: is this the credits?
		bne.s	.NoCredits					; MJ: if not, continue
		jsr	CRE_RunText					; MJ: run credits text handler

	.NoCredits:
		jsr	(Render_Sprites).w
		cmpi.b	#id_Level,(Game_mode).w
		beq.s	ML_Level
		rts

; =============== S U B R O U T I N E =======================================

SpawnLevelMainSprites:
		move.l	#Obj_Collision_Response_List,(Reserved_object_3).w
		move.l	#Obj_Sonic,(Player_1).w
		move.l	#Obj_DashDust,(v_Dust).w
		move.l	#Obj_Insta_Shield,(v_Shield).w
		move.l	#Obj_Sonic_Trail,(v_Trail).w
		rts
; End of function SpawnLevelMainSprites

; =============== S U B R O U T I N E =======================================

Obj_Collision_Response_List:
		clr.w	(Collision_response_list).w
		rts
; End of function Obj_Collision_Response_List

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load level palette IDs into d0
; ---------------------------------------------------------------------------

GetLevelPaletteId:
		move.w	Current_zone_and_act.w,d0			; load level ID as xxyy
		lsl.b	#6,d0						; shift act ID to only covert 2 bits (4 acts total)
		lsr.w	#5,d0						; shift act ID to be multiples of 2
		lea	LevelPaletteArray(pc,d0.w),a1			; load the palette array data to a1

		moveq	#0,d0
		move.b	(a1)+,d0					; load water palette as 00xx0000
		swap	d0
		move.b	(a1)+,d0					; load dry palette as 000000xx
		rts
; ---------------------------------------------------------------------------

LevelPaletteArray:
		dc.b palid_WaterSonic,	palid_SonicFDZ			; FDZ1
		dc.b palid_WaterSonic,	palid_SonicFDZ			; FDZ2
		dc.b palid_WaterSonic,	palid_SonicFDZ			; FDZ3
		dc.b palid_WaterSonic,	palid_SonicFDZ			; FDZ4

		dc.b palid_WaterSonic,	palid_SonicSCZ			; SCZ1
		dc.b palid_WaterSonic,	palid_SonicSCZ			; SCZ2
		dc.b palid_WaterSonic,	palid_SonicSCZ			; SCZ3
		dc.b palid_WaterSonic,	palid_SonicSCZ			; SCZ4

		dc.b palid_WaterSonic,	palid_SonicMGZ			; MGZ1
		dc.b palid_WaterSonic,	palid_SonicMGZ2			; MGZ2
		dc.b palid_WaterSonic,	palid_SonicMGZ2			; MGZ3
		dc.b palid_WaterSonic,	palid_SonicMGZ			; MGZ4

		dc.b palid_WaterSonic,	palid_SonicDDZ			; DDZ1
		dc.b palid_WaterSonic,	palid_SonicDDZ			; DDZ2
		dc.b palid_WaterSonic,	palid_SonicDDZ			; DDZ3
		dc.b palid_WaterSonic,	palid_SonicDDZ			; DDZ4

		dc.b palid_WaterSonic,	palid_SonicFDZ			; Credits

; ---------------------------------------------------------------------------

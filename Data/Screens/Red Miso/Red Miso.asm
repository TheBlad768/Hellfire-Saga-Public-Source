; ===========================================================================
; ---------------------------------------------------------------------------
; Red Miso screen
; ---------------------------------------------------------------------------

SRM_Sound	=	sfx_Transform

; ---------------------------------------------------------------------------
; VDP/VRAM address list
; ---------------------------------------------------------------------------

VRM_RedMisoFG	=	$0020
VRM_RedMisoBG	=	$4000
VRM_LogoSEGA	=	$8000
VRM_Window	=	$A000
VRM_Sprites	=	$B800
VRM_HScroll	=	$BC00
VRM_PlaneA	=	$C000
VRM_PlaneB	=	$E000

; ---------------------------------------------------------------------------
; Kosinski PLC list
; ---------------------------------------------------------------------------

RM_KosArtList:
		dc.l	Art_RedMisoFG
		dc.w	VRM_RedMisoFG

		dc.l	Art_RedMisoBG
		dc.w	VRM_RedMisoBG

		dc.l	Art_LogoSEGA
		dc.w	VRM_LogoSEGA

		dc.w	$FFFF

; ---------------------------------------------------------------------------
; RAM equates list
; ---------------------------------------------------------------------------
OffsetROM := *
; ---------------------------------------------------------------------------

			phase	ramaddr($FFFF0000)
RRM_RAM			ds.b	0
RRM_KosDump		ds.b	$6000					; kosinski dump area
RRM_PalSlot		ds.b	1					; palette cycle slot
RRM_FlashTimer		ds.b	1					; palette flash timer
RRM_FlashCount		ds.b	1					; number of flashes
RRM_ReflashTime		ds.b	1					; time before reflashing
RRM_FinishTimer		ds.w	1					; time before screen is finished
RRM_SegaDone		ds.b	1					; if the SEGA logo has been done
RRM_SegaShow		ds.b	1					; if the SEGA logo is being shown
RRM_SegaTimer		ds.w	1					; timer before SEGA logo finishes showing
RRM_SegaPCM		ds.b	1					; if the SEGA PCM sample is set to play
RRM_StopFractal		ds.b	1					; if fractal is meant NOT to run
			ds.l	1
RRM_RAM_End		ds.b	0
			dephase

RRM_PaletteMain	=	Target_palette
RRM_PaletteCur	=	Normal_palette
RRM_HScrollFG	=	v_hscrolltablebuffer
RRM_HScrollBG	=	v_hscrolltablebuffer+(224*2)
RRM_VScroll	=	h_vscrolltablebuffer
RRM_VScrollFG	=	RRM_VScroll
RRM_VScrollBG	=	RRM_VScroll+4
RRM_Sprites	=	Sprite_table_buffer

; ===========================================================================
; ---------------------------------------------------------------------------
; Screen mode start point
; ---------------------------------------------------------------------------
		!org	OffsetROM					; Reset the program counter
; ---------------------------------------------------------------------------

RedMiso:
		command	cmd_Reset

		fadeout							; fade out music
		jsr	(Clear_Kos_Module_Queue).w			; stop kosinski decompression
		jsr	(Pal_FadeToBlack).w				; fade out

		disableInts
		move.w	#-1,(Previous_zone).w				; reset previous zone/act
		move.l	#VInt,(V_int_addr).w				; restore V-blank address
		move.l	#HInt,(H_int_addr).w				; restore H-blank address
		jsr	(ClearScreen).w
		ResetDMAQueue

		lea	($C00000).l,a5
		lea	$04(a5),a6

		move.w	#$8000|%00000100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00010100,(a6)			; 81	; SDVM P100 - SMS mode (0N|1Y) | Display (0N|1Y) | V-Interrupt (0N|1Y) | DMA (0N|1Y) | V-resolution (0-1C|1-1E)
		move.w	#$8200|(((VRM_PlaneA)>>$0A)&$FF),(a6)	; 82	; 00FE DCBA - Scroll Plane A Map Table VRam address
		move.w	#$8300|(((VRM_Window)>>$0A)&$FF),(a6)	; 83	; 00FE DCB0 / 00FE DC00 (20 Resolution) - Window Plane A Map Table VRam address
		move.w	#$8400|(((VRM_PlaneB)>>$0D)&$FF),(a6)	; 84	; 0000 0FED - Scroll Plane B Map Table VRam address
		move.w	#$8500|(((VRM_Sprites)>>$09)&$FF),(a6)	; 85	; 0FED CBA9 / 0FED CBA0 (20 Resolution) - Sprite Plane Map Table VRam address
		move.w	#$8600|$00,(a6)				; 86	; 0000 0000 - Unknown/Unused Register
		move.w	#$8700|$30,(a6)				; 87	; 00PP CCCC - Backdrop Colour: Palette Line 0/Colour ID 0
		move.w	#$8800|$00,(a6)				; 88	; 0000 0000 - Unknown/Unused Register
		move.w	#$8900|$00,(a6)				; 89	; 0000 0000 - Unknown/Unused Register
		move.w	#$8A00|$DF,(a6)				; 8A	; 7654 3210 - H-Interrupt Register
		move.w	#$8B00|%00000000,(a6)			; 8B	; 0000 EVHH - External Interrupt (0N|1Y) | V-Scroll: (0-Full|1-2Celled) | H-Scroll: (00-Full|10-Celled|11-Sliced)
		move.w	#$8C00|%10000001,(a6)			; 8C	; APHE SNNB - H-resol (0N|1Y) | Pixel int (0N|1Y) | H-sync (0N|1Y) | Extern-pix (0N|1Y) | S/H (0N|1Y) | Interlace (00N|01Y|11-Split) | H-resol (0-20|1-28)
		move.w	#$8D00|(((VRM_HScroll)>>$0A)&$FF),(a6)	; 8D	; 00FE DCBA - Horizontal Scroll Table VRam address
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

		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		clearRAM RRM_HScrollFG, RRM_HScrollFG+$1C0
		clearRAM RRM_HScrollBG, RRM_HScrollBG+$1C0

		clr.l	(RRM_VScroll).w

		moveq	#$00,d0						; clear d0
		lea	(RRM_RAM).l,a1					; load devil eggman screen RAM space
		move.w	#((RRM_RAM_End-RRM_RAM)/4)-1,d1			; size to clear

	.ClearRAM:
		move.l	d0,(a1)+					; clear RAM
		dbf	d1,.ClearRAM					; repeat for entire RAM space

		lea	(RRM_Sprites).w,a1				; load sprite buffer
		moveq	#$01,d0						; prepare link ID with rest clear
		moveq	#$00,d1						; ''
		moveq	#$50-1,d2					; number of sprites to run through

	.ClearSprites:
		move.l	d0,(a1)+					; clear sprite (set link ID)
		move.l	d1,(a1)+					; ''
		addq.b	#$01,d0						; increase link ID
		dbf	d2,.ClearSprites				; repeat for all sprites
		move.w	#RRM_Sprites+3,(Sprite_Link).w			; set link clear address
		move.w	#8/2,(Sprite_Size).w				; set to transfer only the 1 sprite

		; Waiting for VDP DMA fill

		move.w	(a6),ccr					; load status
		bvs.s	*-$02						; if the VDP DMA busy flag was set (bit 1), branch to wait til finished...
		move.w	#$8F02,(a6)					; set VDP increment mode back to normal

	; --- Palette ---

		lea	(RRM_PaletteCur).w,a1				; to main palette

		lea	(Pal_RedMiso).l,a0				; load palette source
		moveq	#($40/4)-1,d7					; size of palette

	.LoadPal:
		move.l	(a0)+,(a1)+					; copy colours
		dbf	d7,.LoadPal					; repeat til done
		lea	(Pal_BlankSEGA).l,a0				; load palette source
		moveq	#($40/4)-1,d7					; size of palette

	.BlankPal:
		move.l	(a0)+,(a1)+					; copy colours
		dbf	d7,.BlankPal					; repeat til done

	; --- Kosinski art ---

		lea	RM_KosArtList(pc),a4				; load PLC list
		lea	(RRM_KosDump).l,a1				; load RAM buffer address to use for kosinski decompression
		jsr	KosDirectPLC					; decompress art and transfer to VRAM

		lea	($C00000).l,a5					; reload VDP ports
		lea	$04(a5),a6					; ''

	; --- Plane mappings ---

		move.l	#$01000000,d3					; prepare line advance

		lea	(Map_RedMisoFG).l,a0				; compressed mappings
		moveq	#$00,d2						; clear d0
		move.b	(a0)+,d2					; load X count
		moveq	#$00,d1						; clear d1
		move.b	(a0)+,d1					; load Y count
		lea	(RRM_KosDump).l,a1				; RAM address to dump
		move.w	#(VRM_RedMisoFG/$20),d0				; tile adjustment
		jsr	EniDec						; decompress and dump
		move.w	(a1),d5						; store blank tile ID for later
		move.l	#$40000000|vdpCommDelta(VRM_PlaneA),d4		; set plane address
		bsr.w	MapScreen					; transfer mappings to VRAM

		lea	(Map_RedMisoBG).l,a0				; compressed mappings
		moveq	#$00,d2						; clear d0
		move.b	(a0)+,d2					; load X count
		moveq	#$00,d1						; clear d1
		move.b	(a0)+,d1					; load Y count
		lea	(RRM_KosDump).l,a1				; RAM address to dump
		move.w	#(VRM_RedMisoBG/$20),d0				; tile adjustment
		jsr	EniDec						; decompress and dump
		move.l	#$40000000|vdpCommDelta(VRM_PlaneB),d4		; set plane address
		bsr.w	MapScreen					; transfer mappings to VRAM

	; --- SEGA Stereo Setup ---

		tst.b	(v_Title_Levelselect_flag).w			; has level select been unlocked?  (just in-case they don't have SRAM but completed the game)
		bne.s	.SetupStereo					; if so, do the stereo version
		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; load from first slot
		jsr	LoadSlot					; load it
		beq.s	.FailLoad					; if failed, skip and use mono
		tst.b	SR_Complete(a0)					; has the game been completed?
		beq.s	.FailLoad					; if not, skip and use mono

	.SetupStereo:
		st.b	(RRM_StopFractal).l				; set fractal to stop
		jsr	PlayPCM_StereoInit				; Setup PCM stereo

	.FailLoad:

	; --- Final stuff ---

		move.w	#(RRM_Sprites&$FFFF)+3,(Sprite_Link).w		; reset link address
		move.w	#8,(Sprite_Size).w				; reset link size

		move.w	#$0300,(RRM_HScrollFG).w			; set starting FG position
		move.w	#$0400-320,(RRM_HScrollBG).w			; set starting BG position

		move.b	#60,(RRM_FlashTimer).l				; time before flashing logo
		move.b	#1-1,(RRM_FlashCount).l				; do 1 flash (did do 2 originally, but seizures...)
		move.w	#60*3,(RRM_FinishTimer).l			; set time before finishing the screen
		move.w	#60*1,(RRM_SegaTimer).l				; set delay timer for SEGA to show (after PCM sample)
		clr.w	(Pal_BlendAmount).w				; reset blend timer

		move.l	#VB_RedMiso,(V_int_addr).w
		move.l	#NullRTE,(H_int_addr).w
		move.w	#$8000|%00010100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00110100,(a6)			; 81	; SDVM P100
		st.b	(V_int_routine).w				; set V-blank as ready
		jsr	(Wait_VSync).w					; wait for V-blank

; ---------------------------------------------------------------------------
; Main loop
; ---------------------------------------------------------------------------

ML_RedMiso:
		st.b	(V_int_routine).w				; set V-blank as ready
		jsr	(Wait_VSync).w					; wait for V-blank
		bsr.w	RM_Sprites					;  render sprites

	; --- SEGA Logo ---

		tst.b	(RRM_SegaDone).l				; has the SEGA logo been done?
		bne.w	.DoneSEGA					; if so, skip
		cmp.w	#$0400-((320*2)+88),(RRM_HScrollBG).w		; has the BG reached position where the SEGA logo can show?
		bgt.w	.DoneSEGA					; if not, continue
		st.b	(RRM_SegaShow).l				; allow sprites to show
		tst.b	(RRM_SegaPCM).l					; is it time to play the SEGA sound?
		beq.w	.NoPCM						; if not, branch
		sf.b	(RRM_SegaPCM).l					; clear flag

		; --- SEGA PCM ---
		; There are two playbacks, one is mono and the other is stereo.  In order for
		; the stereo version to work, Fractal and Dual PCM need to be stopped.
		;
		; The setup for stereo is above in the init code, and will only run if the game
		; has been completed, it'll be responsible for setting the "StopFractal" flag
		; and setting up the YM2612 correctly.  It's done in the init because it takes
		; a while to get the sinewave positions corrected.
		;
		; Here below, if the "StopFractal" flag is set, it assumes the init code has
		; setup YM2612 for stereo and will play-back the stereo version.  Do note...
		; After the stereo code is run, Fractal is re-initialised again.
		; ----------------

		tst.b	(RRM_StopFractal).l				; has fractal been stopped for stereo PCM?
		bne.s	.DoStereo					; if so, do the stereo version

		; Mono Version

		lea	(SEGA).l,a0					; sample start address
		move.l	#SEGA_End-SEGA,d1				; prepare size of sample
		moveq	#$19,d2						; delay/speed
		jsr	PlayPCM						; play PCM sample

		bra.s	.NoPCM						; finish (skip over stereo code)

	.DoStereo:

		; Stereo Version

		lea	(SEGA_Stereo).l,a0				; sample start address
		move.l	#SEGA_StereoEnd-SEGA_Stereo,d1			; prepare size of sample
		moveq	#$0B,d2						; delay/speed
		jsr	PlayPCM_Stereo					; play PCM sample
		move.w	#$0000,($A11100).l				; request Z80 start
		lea	(KosDec).l,a3					; load the routine to decompress Dual PCM
		jsr	InitSound					; re-init sound chips and fractal
		sf.b	(RRM_StopFractal).l				; set fractal as allowed to run now

		; ----------------

	.NoPCM:
		lea	(Pal_BlankSEGA).l,a0				; load source palette 1 (0000)
		lea	(Pal_RedMiso+$40).l,a1				; load source palette 2 (0100)
		lea	(Normal_palette+$40).w,a2			; load destination palette buffer
		moveq	#($40/2)-1,d0					; palette size
		move.w	(Pal_BlendAmount).w,d1				; load blend amount
		tst.w	(RRM_SegaTimer).l				; are we blending in or out?
		bne.s	.SegaIn						; if in, branch
		subi.w	#$0010*2,d1					; blend out

	.SegaIn:
		addi.w	#$0010,d1					; increase blend/fade
		cmpi.w	#$0100,d1					; has it JUST reached maximum now?
		seq.b	(RRM_SegaPCM).l					; if so, set to play SEGA sound
		tst.w	d1						; recheck blend/fade amount
		jsr	(Pal_BlendPalette).w				; blend the palette
		move.w	d1,(Pal_BlendAmount).w				; update blend amount (if capped)
		bne.s	.NoFinishSega
		st.b	(RRM_SegaDone).l				; set SEGA as done
		sf.b	(RRM_SegaShow).l				; hide the sprites
		bra.s	.DoneSEGA

	.NoFinishSega:
		cmpi.w	#$0100,d1					; has it reached maximum?
		bne.w	ML_RedMiso					; if not, loop
		subq.w	#$01,(RRM_SegaTimer).l				; decrease delay timer
		bra.w	ML_RedMiso					; loop back

	.DoneSEGA:
		subq.w	#$01,(RRM_FinishTimer).l			; decrease finish timer
		bcs.w	RM_Finish					; if finished, branch

	; --- Red Miso Logo ---

		move.l	(RRM_HScrollBG).w,d0				; load BG position
		asr.l	#$03,d0						; get fraction
		sub.l	d0,(RRM_HScrollBG).w				; move BG towards screen
		cmpi.w	#$0100,(RRM_HScrollBG).w			; has the BG moved in enough yet?
		bgt.s	.NoFG						; if not, leave FG still
		move.l	(RRM_HScrollFG).w,d0				; load FG position
		asr.l	#$03,d0						; get fraction
		sub.l	d0,(RRM_HScrollFG).w				; move FG towards screen

	.NoFG:
		cmpi.w	#$0020,(RRM_HScrollBG).w			; has the BG moved in enough yet?
		bgt.s	.NoPal						; if not, don't animate the palette
		cmpi.b	#$20,(RRM_PalSlot).l				; has the palette finished animating the BG?
		bge.s	.NoPal						; if so, skip
		addq.b	#$01,(RRM_PalSlot).l				; increase palette slot
		moveq	#$1E,d0						; load slot
		and.b	(RRM_PalSlot).l,d0				; ''
		beq.s	.NoPal						; '' unless it's slot 00 transparent...
		lea	(RRM_PaletteCur+$22).w,a0			; load current palette
		move.w	(a0),-$02(a0,d0.w)				; copy BG colour to the colour slots

	.NoPal:
		subq.b	#$01,(RRM_FlashTimer).l				; decrease flash timer
		bne.s	.NoFlash					; if not finished, branch
		lea	(RRM_PaletteCur).w,a0				; load palette
		moveq	#($20/4)-1,d0					; size of line
	.Flash:
		move.l	$20(a0),(a0)+					; copy white flash colours back
		dbf	d0,.Flash					; ''
		clr.w	(Pal_BlendAmount).w				; reset blend amount
		move.b	#8,(RRM_ReflashTime).l				; time before flashing again
		bra.s	.NoFlashOut

	.NoFlash:
		bcc.s	.NoFlashOut					; if not time to flash, branch
		sf.b	(RRM_FlashTimer).l				; keep timer at 0
		tst.b	(RRM_FlashCount).l				; are there any flashes left to do?
		beq.s	.NoReflash					; if not, branch
		subq.b	#$01,(RRM_ReflashTime).l			; decrease reflash timer
		bcc.s	.NoReflash					; if still counting, branch
		subq.b	#$01,(RRM_FlashCount).l				; decrease count
		move.b	#$01,(RRM_FlashTimer).l				; force a flash again

	.NoReflash:
		lea	(Pal_WhiteMiso).l,a0				; load source palette 1 (0000)
		lea	(Pal_RedMiso).l,a1				; load source palette 2 (0100)
		lea	(Normal_palette).w,a2				; load destination palette buffer
		moveq	#($20/2)-1,d0					; palette size
		move.w	(Pal_BlendAmount).w,d1				; load blend amount
		addq.w	#$06,d1						; increase blend/fade
		jsr	(Pal_BlendPalette).w				; blend the palette
		move.w	d1,(Pal_BlendAmount).w				; update blend amount (if capped)

	.NoFlashOut:
		bra.w	ML_RedMiso					; loop

	; --- Finishing ---

RM_Finish:
		clr.w	(RRM_FinishTimer).l				; keep timer at 0

		cmpi.b	#$04,(RRM_PalSlot).l				; has the palette finished animating the BG?
		beq.s	.NoPal						; if so, skip
		subq.b	#$01,(RRM_PalSlot).l				; decrease palette slot
		moveq	#$1E,d0						; load slot
		and.b	(RRM_PalSlot).l,d0				; ''
		beq.s	.NoPal						; '' unless it's slot 00 transparent...
		lea	(RRM_PaletteCur+$20).w,a0			; load current palette
		move.w	(a0),(a0,d0.w)					; copy black colour to the colour slots

	.NoPal:
		move.l	(RRM_HScrollBG).w,d0				; load BG position
		asr.l	#$03,d0						; get fraction
		addi.l	#$00004000,d0
		add.l	d0,(RRM_HScrollBG).w				; move BG towards screen

		move.l	(RRM_HScrollFG).w,d0				; load FG position
		asr.l	#$03,d0						; get fraction
		subi.l	#$00004000,d0
		add.l	d0,(RRM_HScrollFG).w				; move FG towards screen

		moveq	#$02,d0						; finish counter (both FG and BG need to be off-screen)
		cmpi.w	#$0400-320,(RRM_HScrollBG).w			; has the BG gone fully off-screen yet?
		bmi.s	.NoBGFinish					; if not, continue
		move.w	#$0400-320,(RRM_HScrollBG).w			; force off-screen
		subq.b	#$01,d0						; decrease finish counter

	.NoBGFinish:
		cmpi.w	#-320,(RRM_HScrollFG).w				; has the BG gone fully off-screen yet?
		bgt.s	.NoFGFinish					; if not, continue
		move.w	#-320,(RRM_HScrollFG).w				; force off-screen
		subq.b	#$01,d0						; decrease finish counter

	.NoFGFinish:
		tst.b	d0						; are both the FG and BG off-screen?
		bne.w	ML_RedMiso					; if not, loop screen

		move.w	#$2700,sr					; disable interrupts
		move.l	#VInt,(V_int_addr).w				; reset interrupt addresses
		move.l	#HInt,(H_int_addr).w				; ''
		jsr	Init_VDP					; reset VDP registers, VRAM, etc...
		enableScreen

	; ---------------------------------------------
	; Ripped from the SEGA screen and moved here...
	; ---------------------------------------------

	if Debug_LevelId<0

		if Enable_SplashScreen
			move.b	#id_HardLine_Screen,(Game_mode).w
		else
			move.b	#id_TitleWithNotice,(Game_mode).w
		endif

	;	move.w	#$202,(Current_zone_and_act).w
	;	move.b	#id_Level,d0
	;	move.b	d0,(Game_mode).w
	else
		; load the debug values into the starpost register (pretend as if we hit a starpost)
		move.b	#id_Level,(Game_mode).w
		move.w	#Debug_LevelId,Saved_zone_and_act.w
		move.w	#Debug_LevelId,Current_zone_and_act.w
		move.b	#1,Last_star_post_hit.w
		move.w	#Debug_Xpos,Saved_X_pos.w
		move.w	#Debug_Ypos,Saved_Y_pos.w
		move.w	#Debug_Xpos-$40,Saved_camera_X_pos.w
		move.w	#Debug_Ypos-$40,Saved_camera_Y_pos.w

		move.b	#Debug_Resize,Saved_dynamic_resize_routine.w
		move.w	#make_art_tile(ArtTile_Sonic,0,0),Saved_art_tile.w
		move.w	#$1000,Saved_camera_max_Y_pos.w
		move.w	#$7F00,Saved_camera_max_X_pos.w
		move.w	#$C0D,Saved_solid_bits.w
		clr.b	Saved_ring_count.w
		clr.b	Saved_GravityAngle.w
	endif
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; V-blank
; ---------------------------------------------------------------------------

RM_Sprites:
		lea	(RRM_Sprites).l,a6				; load sprite buffer
		tst.b	(RRM_SegaShow).l				; has the SEGA logo been requested to show?
		beq.s	.Finish						; if not, skip
		lea	Map_LogoSEGA(pc),a4				; load mapping data
		move.w	(a4)+,d7					; load number of peices
		bmi.s	.Finish						; if there are no pieces (doubtful, why bother...), skip
		move.w	#320/2,d2					; X and Y are central
		move.w	#224/2,d3					; ''
		move.w	#$6000|(VRM_LogoSEGA/$20),d1			; pattern index address where art is

	.NextPiece:
		move.w	(a4)+,d0					; load Y position
		add.w	d3,d0						; add base
		move.w	d0,(a6)+					; save to table
		move.w	(a4)+,d0					; load shape
		move.b	d0,(a6)+					; save shape to table
		addq.w	#$01,a6						; skip link
		move.w	(a4)+,d0					; load pattern index
		add.w	d1,d0						; add base
		move.w	d0,(a6)+					; save to table
		move.w	(a4)+,d0					; load X position
		add.w	d2,d0						; add base
		move.w	d0,(a6)+					; save to table
		dbf	d7,.NextPiece					; repeat for all pieces

	.Finish:
		move.w	#((RRM_Sprites+($50*8))-5)&$FFFF,d0		; prepare end of table address
		cmpa.w	d0,a6						; have we reached the last sprite?
		bpl.s	.Last						; if so, branch for last link
		clr.w	(a6)+						; hide next sprite
		moveq	#$01,d0						; get link address
		add.w	a6,d0						; ''

	.Last:
		move.w	d0,(Sprite_Link).w				; set link address
		addq.w	#$05,d0						; advance to end of sprite
		sub.w	#(RRM_Sprites&$FFFF),d0				; get number of sprites
		lsr.w	#$01,d0						; reduce for DMA size
		move.w	d0,(Sprite_Size).w				; set size to transfer
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; V-blank
; ---------------------------------------------------------------------------

VB_RedMiso:
		movem.l	d0-a5,-(sp)					; store registers

		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''
		move.w	#$8100|%01110100,(a6)				; enable display (doing it here because of a line flicker on-screen)

		tst.b	(V_int_routine).w				; is the 68k ready for V-blank?
		beq.w	.Late68k					; if not, don't transfer anything
		sf.b	(V_int_routine).w				; set V-blank as ran

		; Sprites

		movea.w	(Sprite_Link).w,a0				; load link address
		move.b	(a0),d0						; store link
		sf.b	(a0)						; clear link
		lea	(R_VDP94).w,a1					; load DMA list
		move.w	(Sprite_Size).w,d1				; load size of table
		movep.w	d1,$01(a1)					; set DMA size registers
		move.l	(a1)+,(a6)					; ''
		move.l	#(((((((RRM_Sprites)&$FFFFFF)/$02)&$FF00)<<$08)+((((RRM_Sprites)&$FFFFFF)/$02)&$FF))+$96009500),(a6)
		move.l	#((((((RRM_Sprites)&$FFFFFF)/$02)&$7F0000)+$97000000)+((VRM_Sprites)&$3FFF)|$4000),(a6)
		move.w	#((((VRM_Sprites)>>$0E)&$03)|$80),(a1)		; last DMA source from 68k RAM
		move.w	(a1),(a6)
		move.b	d0,(a0)						; restore link

		move.l	#$40000000|vdpCommDelta(VRM_HScroll),(a6)	; set VDP to VRAM H-scroll table write
		move.w	(RRM_HScrollFG).w,(a5)				; write FG H-scroll
		move.w	(RRM_HScrollBG).w,(a5)				; write BG H-scroll

		move.l	#$40000010,(a6)					; set VDP to VSRAM
		move.l	(RRM_VScroll).w,(a5)				; set no V-scroll

		move.w	#$100,d0					; delay a bit before the palette
		dbf	d0,*						; '' (just not enough data about to delay it)
		DMA	$0080, CRAM, $0000, RRM_PaletteCur		; transfer all lines

	.Late68k:
		jsr	(Poll_Controllers).w				; get controls

		movem.l	(sp)+,d0-a5					; restore registers
	tst.b	(RRM_StopFractal).l
	bne.s	.NoFractal
		move.w	(sp),-$04(sp)					; move sr back
		subq.w	#$02,sp						; write new return address to fractal running routine
		move.l	#.Fractal,(sp)					; ''
		subq.w	#$02,sp						; move back to new sr

	.NoFractal:
		rte							; return

	.Fractal:
		move.w	sr,-(sp)					; store ccr
		movem.l	d0-a5,-(sp)					; store registers
		jsr	dFractalExtra					; run fractal routines
		jsr	dForceMuteYM2612				; force YM2612 channels to mute when requested
		jsr	dFractalSound					; ''
		movem.l	(sp)+,d0-a5					; restore registers
		rtr							; restore ccr

; ===========================================================================
; ---------------------------------------------------------------------------
; Included data
; ---------------------------------------------------------------------------

Pal_WhiteMiso:	dc.w	$0000,$0EEE,$0EEE,$0EEE,$0EEE,$0EEE,$0EEE,$0EEE
		dc.w	$0EEE,$0EEE,$0EEE,$0EEE,$0EEE,$0EEE,$0EEE,$0EEE

Pal_RedMiso:	binclude "Data\Miso Logo\Palette.bin"
		even

Pal_BlankSEGA:	dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dc.w	$0000,$0200,$0200,$0200,$0200,$0200,$0200,$0200
		dc.w	$0200,$0200,$0200,$0200,$0200,$0200,$0200,$0200

Art_RedMisoFG:	binclude "Data\Miso Logo\FG Art.kos"
		even
Map_RedMisoFG:	binclude "Data\Miso Logo\FG Map.eni"
		even
Art_RedMisoBG:	binclude "Data\Miso Logo\BG Art.kos"
		even
Map_RedMisoBG:	binclude "Data\Miso Logo\BG Map.eni"
		even
Art_LogoSEGA:	binclude "Data\SEGA Logo\Art.kos"
		even
Map_LogoSEGA:	binclude "Data\SEGA Logo\Map.bin"
		even

; ===========================================================================
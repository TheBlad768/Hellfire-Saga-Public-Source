; ===========================================================================
; ---------------------------------------------------------------------------
; Thanks Screen
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; VDP/VRAM address list
; ---------------------------------------------------------------------------

VTH_ThanksFG	=	$0020
VTH_ThanksBG	=	$6000
VTH_SpriteArt	=	$7000
VTH_ThanksArt	=	$9800

VTH_Window	=	$A000
VTH_Sprites	=	$B800
VTH_HScroll	=	$BC00
VTH_PlaneA	=	$C000
VTH_PlaneB	=	$E000

DTH_WINDOWPOS	=	$06
DTH_WINDOWSIZE	=	$0E

; ---------------------------------------------------------------------------
; Kosinski PLC list
; ---------------------------------------------------------------------------

TH_KosArtList:
		dc.l	Art_ThanksFG
		dc.w	VTH_ThanksFG

		dc.l	Art_ThanksBG
		dc.w	VTH_ThanksBG

		dc.l	Art_ThanksSpr
		dc.w	VTH_SpriteArt

		dc.w	$FFFF

; ---------------------------------------------------------------------------
; RAM equates list
; ---------------------------------------------------------------------------
OffsetROM := *
; ---------------------------------------------------------------------------

			phase	0
TH_PosX			ds.l	1
TH_PosY			ds.l	1
TH_SpeedY		ds.l	1
TH_DestY		ds.w	1
TH_Flash		ds.b	1
TH_Valid		ds.b	1
TH_Size
			dephase

			phase	ramaddr($FFFF0000)
RTH_RAM			ds.b	0
RTH_KosDump		ds.b	$6000					; kosinski dump area
RTH_FrameCount		ds.w	1					; frame timer/counter
RTH_FadeTimer		ds.b	1					; fade timer/counter
RTH_FadeDirection	ds.b	1					; if fading in or out (00 = in | FF = out)
RTH_WaitTimer		ds.w	1					; delay time before start button can be pressed after fading
RTH_ShowMessage		ds.b	1					; if the thank you text is to show
RTH_SlotMessage		ds.b	1					; the letter we're dealing with
RTH_SlotNewLine		ds.b	1					; when text moves to a new slot, how much to subtract for X calculation
RTH_SlotY		ds.b	1					; slot Y position
RTH_TimeMessage		ds.w	1					; timer before each letter can show
RTH_EggmanX		ds.l	1					; eggman's BG X and Y position
RTH_EggmanY		ds.l	1					; ''
RTH_SmokeX		ds.l	1					; smoke's BG X and Y position
RTH_SmokeY		ds.l	1					; ''
RTH_EggAni		ds.b	1					; animation timer for eggman
RTH_SmokeAni		ds.b	1					; ''

RTH_Letters		ds.b	TH_Size*$40				; letter sprite SST

RTH_ScrollFG		ds.l	1
			ds.l	4
RTH_RAM_End		ds.b	0
			dephase

RTH_PaletteMain	=	Target_palette
RTH_PaletteCur	=	Normal_palette
RTH_HScrollFG	=	v_hscrolltablebuffer
RTH_HScrollBG	=	v_hscrolltablebuffer+(224*2)
RTH_VScroll	=	h_vscrolltablebuffer
RTH_VScrollFG	=	RTH_VScroll
RTH_VScrollBG	=	RTH_VScroll+4
RTH_Sprites	=	Sprite_table_buffer

; ===========================================================================
; ---------------------------------------------------------------------------
; Screen mode start point
; ---------------------------------------------------------------------------
		!org	OffsetROM					; Reset the program counter
; ---------------------------------------------------------------------------

Thanks:
		st.b	(v_Title_Levelselect_flag).w		; enable level select

		lea	(TempSaveRAM).l,a0				; load temporary RAM space for saving data
		moveq	#$00,d0						; set to load from first slot
		jsr	LoadSlot					; load it...
		beq.s	.FailLoad					; if failed, skip
		move.b	(v_Title_LevelSelect_flag).w,SR_Complete(a0)	; set complete flag
		moveq	#$00,d0						; set to save from first slot
		jsr	SaveSlot					; save it...
		beq.s	.FailLoad					; if failed, skip
		nop	; Donno...

	.FailLoad:

		command	cmd_Reset

		fadeout						; fade out music
		jsr	(Clear_Kos_Module_Queue).w		; stop kosinski decompression
		jsr	(Pal_FadeToBlack).w			; fade out
		move.w	#$0401,(Current_Zone).w			; set zone/act just in-case...

		disableInts
		move.w	#-1,(Previous_zone).w			; reset previous zone/act
		move.l	#VInt,(V_int_addr).w			; restore V-blank address
		move.l	#HInt,(H_int_addr).w			; restore H-blank address
		jsr	(ClearScreen).w
		ResetDMAQueue

		lea	($C00000).l,a5
		lea	$04(a5),a6

		move.w	#$8000|%00000100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00010100,(a6)			; 81	; SDVM P100 - SMS mode (0N|1Y) | Display (0N|1Y) | V-Interrupt (0N|1Y) | DMA (0N|1Y) | V-resolution (0-1C|1-1E)
		move.w	#$8200|(((VTH_PlaneA)>>$0A)&$FF),(a6)	; 82	; 00FE DCBA - Scroll Plane A Map Table VRam address
		move.w	#$8300|(((VTH_Window)>>$0A)&$FF),(a6)	; 83	; 00FE DCB0 / 00FE DC00 (20 Resolution) - Window Plane A Map Table VRam address
		move.w	#$8400|(((VTH_PlaneB)>>$0D)&$FF),(a6)	; 84	; 0000 0FED - Scroll Plane B Map Table VRam address
		move.w	#$8500|(((VTH_Sprites)>>$09)&$FF),(a6)	; 85	; 0FED CBA9 / 0FED CBA0 (20 Resolution) - Sprite Plane Map Table VRam address
		move.w	#$8600|$00,(a6)				; 86	; 0000 0000 - Unknown/Unused Register
		move.w	#$8700|$30,(a6)				; 87	; 00PP CCCC - Backdrop Colour: Palette Line 0/Colour ID 0
		move.w	#$8800|$00,(a6)				; 88	; 0000 0000 - Unknown/Unused Register
		move.w	#$8900|$00,(a6)				; 89	; 0000 0000 - Unknown/Unused Register
		move.w	#$8A00|$DF,(a6)				; 8A	; 7654 3210 - H-Interrupt Register
		move.w	#$8B00|%00000011,(a6)			; 8B	; 0000 EVHH - External Interrupt (0N|1Y) | V-Scroll: (0-Full|1-2Celled) | H-Scroll: (00-Full|10-Celled|11-Sliced)
		move.w	#$8C00|%10000001,(a6)			; 8C	; APHE SNNB - H-resol (0N|1Y) | Pixel int (0N|1Y) | H-sync (0N|1Y) | Extern-pix (0N|1Y) | S/H (0N|1Y) | Interlace (00N|01Y|11-Split) | H-resol (0-20|1-28)
		move.w	#$8D00|(((VTH_HScroll)>>$0A)&$FF),(a6)	; 8D	; 00FE DCBA - Horizontal Scroll Table VRam address
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
		clearRAM RTH_HScrollFG, RTH_HScrollFG+$1C0
		clearRAM RTH_HScrollBG, RTH_HScrollBG+$1C0

		clr.l	(RTH_VScroll).w

		moveq	#$00,d0						; clear d0
		lea	(RTH_RAM).l,a1					; load devil eggman screen RAM space
		move.w	#((RTH_RAM_End-RTH_RAM)/4)-1,d1			; size to clear

	.ClearRAM:
		move.l	d0,(a1)+					; clear RAM
		dbf	d1,.ClearRAM					; repeat for entire RAM space

		lea	(RTH_Sprites).w,a1				; load sprite buffer
		moveq	#$01,d0						; prepare link ID with rest clear
		moveq	#$00,d1						; ''
		moveq	#$50-1,d2					; number of sprites to run through

	.ClearSprites:
		move.l	d0,(a1)+					; clear sprite (set link ID)
		move.l	d1,(a1)+					; ''
		addq.b	#$01,d0						; increase link ID
		dbf	d2,.ClearSprites				; repeat for all sprites
		move.w	#RTH_Sprites+3,(Sprite_Link).w			; set link clear address
		move.w	#8/2,(Sprite_Size).w				; set to transfer only the 1 sprite

		; Waiting for VDP DMA fill

		move.w	(a6),ccr					; load status
		bvs.s	*-$02						; if the VDP DMA busy flag was set (bit 1), branch to wait til finished...
		move.w	#$8F02,(a6)					; set VDP increment mode back to normal

	; --- Palette ---

		lea	(Pal_Thanks).l,a0				; load palette source
		lea	(RTH_PaletteMain).w,a1				; to main palette
		moveq	#((Pal_Thanks_End-Pal_Thanks)/4)-1,d7		; size of palette

	.LoadPal:
		move.l	(a0)+,(a1)+					; copy colours
		dbf	d7,.LoadPal					; repeat til done

	; --- Kosinski art ---

		lea	TH_KosArtList(pc),a4				; load PLC list
		lea	(RTH_KosDump).l,a1				; load RAM buffer address to use for kosinski decompression
		jsr	KosDirectPLC					; decompress art and transfer to VRAM

		lea	($C00000).l,a5					; reload VDP ports
		lea	$04(a5),a6					; ''

	; --- Plane mappings ---

		move.l	#$01000000,d3					; prepare line advance

		lea	(Map_ThanksFG).l,a0				; compressed mappings
		moveq	#$00,d2						; clear d0
		move.b	(a0)+,d2					; load X count
		moveq	#$00,d1						; clear d1
		move.b	(a0)+,d1					; load Y count
		lea	(RTH_KosDump).l,a1				; RAM address to dump
		move.w	#(VTH_ThanksFG/$20),d0				; tile adjustment
		jsr	EniDec						; decompress and dump
		move.w	(a1),d5						; store blank tile ID for later
		move.l	#$40000000|vdpCommDelta(VTH_PlaneA),d4		; set plane address
		bsr.w	MapScreen					; transfer mappings to VRAM


		lea	(Map_ThanksBG).l,a0				; compressed mappings
		moveq	#$00,d2						; clear d0
		move.b	(a0)+,d2					; load X count
		moveq	#$00,d1						; clear d1
		move.b	(a0)+,d1					; load Y count
		lea	(RTH_KosDump).l,a1				; RAM address to dump
		move.w	#(VTH_ThanksBG/$20),d0				; tile adjustment
		jsr	EniDec						; decompress and dump
		move.l	#$40000000|vdpCommDelta(VTH_PlaneB),d4		; set plane address
		bsr.w	MapScreen					; transfer mappings to VRAM

		move.l	#$40000000|vdpCommDelta(VTH_Window),(a6)	; set VDP VRAM write to window
		move.w	d5,d0						; prepare black tiles from plane A left edge
		swap	d0						; ''
		move.w	d5,d0						; ''
		move.w	#(($1000/4)/4)-1,d7				; size of window plane area

	.MapWindow:
		move.l	d0,(a5)						; setup window to contain entirely black
		move.l	d0,(a5)						; ''
		move.l	d0,(a5)						; ''
		move.l	d0,(a5)						; ''
		dbf	d7,.MapWindow					; repeat until window is filled

	; --- Final stuff ---

		move.w	#(RTH_Sprites&$FFFF)+3,(Sprite_Link).w		; reset link address
		move.w	#8,(Sprite_Size).w				; reset link size
		move.l	#$FF700000,d0					; set starting scroll position
		move.l	d0,(RTH_VScrollFG).w				; ''
		asr.l	#$01,d0						; BG is half the distance
		move.l	d0,(RTH_VScrollBG).w				; ''
		move.w	#$003F,(Palette_fade_info).w			; set fade information correctly for all four lines

		move.w	#320,(RTH_EggmanX).l				; set eggman's starting X position
		move.w	#128,(RTH_EggmanY).l				; set eggman's starting Y position

		sf.b	(RTH_FadeDirection).l				; set to fade in
		move.b	#$16<<2,(RTH_FadeTimer).l			; reset fade timer
		move.w	#7*60,(RTH_WaitTimer).l				; set delay time before player can press start button

		move.l	#VB_Thanks,(V_int_addr).w
		move.l	#NullRTE,(H_int_addr).w
		move.w	#$8000|%00010100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00110100,(a6)			; 81	; SDVM P100
		st.b	(V_int_routine).w				; set V-blank as ready
		jsr	(Wait_VSync).w					; wait for V-blank
		; Don't use a6, it's being used for H-blank now...
		move.w	#$8100|%01110100,(a6)			; 81	; SDVM P100

; ---------------------------------------------------------------------------
; Main loop
; ---------------------------------------------------------------------------

ML_Thanks:
		st.b	(V_int_routine).w				; set V-blank as ready
		jsr	(Wait_VSync).w					; wait for V-blank
		addq.w	#$01,(RTH_FrameCount).l				; increase frame counter

		bsr.w	TH_Scroll					; run scroll control
		bsr.w	TH_RenderSprites				; render the sprites
		subq.b	#$01,(RTH_FadeTimer).l				; decrease timer
		bgt.s	.Fade						; if still running, branch
		sf.b	(RTH_FadeTimer).l				; force timer to 0
		tst.b	(RTH_FadeDirection).l				; is direction set to fade out?
		beq.s	.CheckFinish					; if not, continue
		move.w	#$2700,sr					; disable interrupts
		move.l	#VInt,(V_int_addr).w				; reset interrupt addresses
		move.l	#HInt,(H_int_addr).w				; ''
		jsr	Init_VDP					; reset VDP registers, VRAM, etc...
		enableScreen
		move.b	#id_SegaScreen,(Game_mode).w			; reset to SEGA screen
		rts							; return (run SEGA screen next)

	.CheckFinish:
		subq.w	#$01,(RTH_WaitTimer).l				; decrease button timer
		bcc.s	.NoFade						; if not finished, don't allow start to be pressed
		clr.w	(RTH_WaitTimer).l				; keep timer finished
		tst.b	(Ctrl_1_pressed).w				; has player 1 pressed start button?
		bpl.s	.NoFade						; if not, branch
		st.b	(RTH_FadeDirection).l				; set to fade out
		move.b	#$16<<2,(RTH_FadeTimer).l			; reset fade timer
		bra.s	.NoFade						; continue

	.Fade:
		moveq	#$03,d0						; has it been 4 frames?
		and.b	(RTH_FadeTimer).l,d0				; ''
		bne.s	.NoFade						; if not, skip fading
		lea	(Pal_FromBlack).w,a0				; get fade in routine
		tst.b	(RTH_FadeDirection).l				; are we fading in?
		beq.s	.DoFade						; if so, use fade in routine
		lea	(Pal_ToBlack).w,a0				; fade fade out routine

	.DoFade:
		jsr	(a0)						; run fading routine

	.NoFade:
		bra.w	ML_Thanks					; loop

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to handle V and H-scroll
; ---------------------------------------------------------------------------

TH_Scroll:

	; --- V-Scroll ---

		move.l	(RTH_VScrollFG).w,d0				; load FG scroll
		asr.l	#$06,d0						; reduce distance for speed
		sub.l	d0,(RTH_VScrollFG).l				; move scroll position up
		neg.l	d0
		move.l	#$FFFFF000,d1					; if the message has scrolled in enough, enable the message
		and.l	d1,d0						; '' (ignore parts of the fraction)
		seq.b	(RTH_ShowMessage).l				; ''
		move.l	(RTH_VScrollBG).w,d0				; load BG scroll
		asr.l	#$06,d0						; reduce distance for speed
		sub.l	d0,(RTH_VScrollBG).l				; move scroll position up

	; --- H-Scroll FG ---

		moveq	#$30,d0						; get four frames of animation from the time
		and.w	(RTH_FrameCount).l,d0				; ''
		lsr.w	#$04,d0						; ''
		subq.w	#$01,d0						; convert 0 1 2 3 to 1 0 1 2
		bpl.s	.NoWrap						; ''
		neg.w	d0						; '' (1)

	.NoWrap:
		mulu.w	#288,d0						; multiply by width of frame
		neg.w	d0						; reverse direction (because H-scroll)
		move.w	d0,d1						; copy to upper word
		swap	d0						; ''
		move.w	d1,d0						; ''
		lea	(RTH_HScrollFG).w,a1				; load FG scroll table
		moveq	#((224/2)/4)-1,d7				; number of scanlines
	.AniFG:	rept	4
		move.l	d0,(a1)+					; set frame position
		endm
		dbf	d7,.AniFG					; repeat for all scanlines

	; --- H-Scroll BG ---

		lea	(RTH_HScrollBG).w,a1				; load BG scroll table
		move.w	#224,d7						; number of scanlines to write
		move.w	(RTH_FrameCount).l,d5				; load frame count as speed
		neg.w	d5						; reverse direction
		asr.w	#$02,d5						; slow it down for all speeds below

		moveq	#72,d6						; get number of lines for top part
		sub.w	(RTH_VScrollBG).l,d6				; change starting size based on scroll position
		moveq	#$00,d0						; no movement for top sky (no point)
		bsr.s	.WriteScroll					; do top sky

		move.w	d5,d0						; load speed
		move.w	d0,d1						; slow down by a fraction
		asr.w	#$02,d1						; ''
		sub.w	d1,d0						; ''
		moveq	#30,d6						; top clouds size
		bsr.s	.WriteScroll					; do top clouds

		move.w	d5,d0						; load speed
		asr.w	#$01,d0						; slow speed down for bottom sky
		moveq	#18,d6						; mid clouds size
		bsr.s	.WriteScroll					; do mid clouds

		move.w	d5,d0						; load speed
		asr.w	#$02,d0						; slow speed down
		moveq	#13,d6						; bottom clouds size
		bsr.s	.WriteScroll					; do bottom clouds

		move.w	d5,d0						; load speed
		asr.w	#$01,d0						; slow speed down for mid clouds
		moveq	#27,d6						; bottom sky size


	.WriteScroll:
		sub.w	d6,d7						; remove count from remaining scanlines
		bpl.s	.Valid						; if not run out of scanlines, branch
		add.w	d7,d6						; get remaining scanlines left
		moveq	#$00,d7						; force no more scanlines

	.Valid:
		dbf	d6,.Write					; minus 1 for dbf
		rts							; return (if none, doubt it...)

	.Write:
		move.w	d0,(a1)+					; write scroll position
		dbf	d6,.Write					; repeat until section is done
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to map tiles to a VDP plane area
; --- inputs ----------------------------------------------------------------
; d1.w = Y count
; d2.w = X count
; a1.l = mappings to write
; d3.l = VDP line advancement amount
; d4.l = VDP address to write mappings to
; ---------------------------------------------------------------------------

MapScreen:

	.NextY:
		move.l	d4,(a6)						; set VDP to VRAM write address
		add.l	d3,d4						; advance to next column
		move.w	d2,d0						; reload X count

	.NextX:
		move.w	(a1)+,(a5)					; copy mappings into VRAM
		dbf	d0,.NextX					; repeat for all columns
		dbf	d1,.NextY					; repeat for all rows
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render sprites correctly
; ---------------------------------------------------------------------------

TH_RenderSprites:
		lea	(RTH_Sprites).w,a4				; load sprite buffer

		lea	Map_ThanksSpr(pc),a2				; load mappings to use for the below sprites

		bsr.s	TH_SpriteText					; render "thank you" message

		move.w	#$8000|(VTH_SpriteArt/$20),d6			; pattern index address for below sprites
		bsr.w	TH_MaskBoarder					; prevent sprites showing below the boarder
		bsr.w	TH_SpriteSonic					; do Sonic now
		bsr.w	TH_SpriteFlower					; do the animated flower
		andi.w	#$7FFF,d6					; set low plane
		bsr.w	TH_SpriteEggman					; do eggman sprites
		bsr.w	TH_SpriteClouds					; do the clouds sprites
		bsr.w	TH_SpriteMoon					; do the moon

		move.w	#((RTH_Sprites+($50*8))-5)&$FFFF,d0		; prepare end of table address
		cmpa.w	d0,a4						; have we reached the last sprite?
		bpl.s	.Last						; if so, branch for last link
		clr.w	(a4)+						; hide next sprite
		moveq	#$01,d0						; get link address
		add.w	a4,d0						; ''

	.Last:
		move.w	d0,(Sprite_Link).w				; set link address
		addq.w	#$05,d0						; advance to end of sprite
		sub.w	#(RTH_Sprites&$FFFF),d0				; get number of sprites
		lsr.w	#$01,d0						; reduce for DMA size
		move.w	d0,(Sprite_Size).w				; set size to transfer
		rts							; return

; ---------------------------------------------------------------------------
; Rendering thank you text sprites
; ---------------------------------------------------------------------------

TH_SpriteText:
		tst.b	(RTH_ShowMessage).l				; are we allowed to show the message yet?
		bne.s	.Show						; if so, knock yourself out
		rts							; uh uh uh... Markey didn't say...

	.Show:
		subq.w	#$01,(RTH_TimeMessage).l			; decrease timer between letters
		bcc.w	.NoLoad						; if still running, branch
		move.w	#3,(RTH_TimeMessage).l				; set delay time before next message
		lea	(CRE_Thanks).l,a0				; load thanks message
		move.l	#$40000000,d0					; clear registers
		moveq	#$00,d1						; ''
		move.b	(RTH_SlotMessage).l,d0				; load slot

	.NextLine:
		move.b	(a0,d0.w),d1					; load letter
		bpl.s	.NoNewLine					; if it's the end of the message, branch
		add.b	d1,d1						; is it a new line?
		bmi.w	.NoLoad						; if not, skip
		addq.b	#$01,d0						; increase by 1 for next character
		move.b	d0,(RTH_SlotNewLine).l				; set X subtraction
		addi.b	#$0C,(RTH_SlotY).l				; move down a line
		bra.s	.NextLine					; reload

	.NoNewLine:
		addq.b	#$01,(RTH_SlotMessage).l			; advance slot forwards

		lsl.w	#$05,d1						; multiply to size of tile
		beq.w	.NoLoad						; if it's a space character, branch
		addi.l	#CRE_CreditsArt-$20,d1				; advance to correct letter
		movea.l	d1,a0						; set letter art address
		move.w	d0,d1						; keep a copy of the slot ID
		lsl.w	#$05,d0						; load correct VRAM address
		addi.w	#VTH_ThanksArt,d0				; start at correct address
		rol.l	#$02,d0						; align for VDP
		ror.w	#$02,d0						; ''
		swap	d0						; ''

		; Should technically do this transfer in V-blank, but
		; because the H-blank interrupt isn't precise and can
		; vary a little on which scanline, we can get away with
		; this...

		move.w	#$2700,sr					; disable interrupts
		move.l	d0,(a6)						; set VDP write address
		rept	8
		move.l	(a0)+,(a5)					; copy tile over
		endm
		move.w	#$2300,sr					; enable interrupts

		move.w	d1,d0						; keep a copy of the slot
		mulu.w	#TH_Size,d1					; get slot
		addi.w	#(RTH_Letters&$FFFF),d1				; advance to correct RAM address/slot
		moveq	#-1,d2
		move.w	d1,d2
		movea.l	d2,a0						; set object/sst slot

		moveq	#$00,d2						; get slot line
		move.b	(RTH_SlotNewLine).l,d2				; ''
		sub.w	d2,d0						; move back for correct X position
		lsl.w	#$03,d0						; get slot number as 8 pixel position
		addi.w	#40+$80,d0					; move to correct starting position on the left
		move.w	d0,TH_PosX(a0)					; set slot's X position
		moveq	#$00,d0						; load Y line to render on
		move.b	(RTH_SlotY).l,d0				; ''
		move.w	d0,d1						; keep a copy for Y destination
		addi.w	#224+$80,d0					; set starting Y to below the screen
		move.w	d0,TH_PosY(a0)					; ''
		addi.w	#180+$80,d1					; advance to destination line
		move.w	d1,TH_DestY(a0)					; ''
		move.l	#$FFFC0000,TH_SpeedY(a0)			; set Y speed
		st.b	TH_Valid(a0)					; set this letter as valid
		move.b	#$E0,TH_Flash(a0)				; reset flash timer

	.NoLoad:
		lea	(RTH_Letters).l,a0				; load letter RAM
		moveq	#$00,d7						; load number of slots
		move.b	(RTH_SlotMessage).l,d7				; ''
		subq.w	#$01,d7						; minus 1 for dbf
		bcs.w	.Finish						; if there are no slots, branch
		move.w	#$8000|(VTH_ThanksArt/$20),d6			; pattern index for letters

	.NextLetter:
		tst.b	TH_Valid(a0)					; is this slot valid?
		beq.s	.Space						; if not, branch
		move.w	#$6000,d3					; reset palette line

		move.w	TH_DestY(a0),d2					; destination Y
		move.l	TH_SpeedY(a0),d0				; load speed for Y movement
		cmp.w	TH_PosY(a0),d2					; get direction to move the letter
		bpl.s	.Down

		cmpi.l	#$FFFC0000,d0
		ble.s	.Move
		subi.l	#$00001000,d0
		bmi.s	.Move
		subi.l	#$00002000,d0
		bra.s	.Move

	.Down:
		bne.s	.NoCheckStop
		tst.l	d0
		bne.s	.NoCheckStop
		tst.b	TH_Flash(a0)
		beq.s	.NoMove
		subi.b	#$10,TH_Flash(a0)

		move.w	#$6000,d0					; get palette line
		and.w	TH_Flash(a0),d0					; ''
		cmpi.w	#$6000,d0					; will it subtract to the first line?
		bne.s	.NoMax						; if not, no worries
		move.w	#$2000,d0					; force down to 3rd line instead

	.NoMax:
		sub.w	d0,d3						; move palette line up to correct brightness
		bra.s	.NoMove						; resume

	.NoCheckStop:
		addi.l	#$00001000,d0
		bpl.s	.Move
		addi.l	#$00002000,d0

	.Move:
		move.l	d0,TH_SpeedY(a0)
		add.l	d0,TH_PosY(a0)

	.NoMove:
		move.w	TH_PosY(a0),(a4)+				; save Y position
		sf.b	(a4)+						; shape is single tile
		addq.w	#$01,a4						; skip link
		eor.w	d6,d3						; fuse base index with palette line index
		move.w	d3,(a4)+					; set pattern index
		move.w	TH_PosX(a0),(a4)+				; set X position

	.Space:
		addq.w	#$01,d6						; advance to next letter
		lea	TH_Size(a0),a0					; advance to next slot
		dbf	d7,.NextLetter					; repeat for all slots

	.Finish:
		rts							; return (done)

; ---------------------------------------------------------------------------
; Creating mask on left boarder
; ---------------------------------------------------------------------------

TH_MaskBoarder:
		move.w	#((DTH_WINDOWPOS+DTH_WINDOWSIZE)*8)+$80,d0	; set starting Y position
		moveq	#$01,d1						; prepare X mask positions
		moveq	#$00,d2						; ''
		moveq	#$03,d3						; prepare size
		move.w	#(224+$80)+($20-1),d4				; get number of sprites required for masking
		sub.w	d0,d4						; '' ($20-1 is for partial sprites)
		lsr.w	#$05,d4						; ''
		subq.w	#$01,d4						; minus 1 for dbf
		bmi.s	.NoMask						; if no sprites required, branch

	.NextMask:
		move.w	d0,(a4)+					; render non-mask sprite first
		move.b	d3,(a4)+					; '' (the mask effect doesn't work unless a sprite before hand was rendered in the Y spot)
		addq.w	#$01,a4						; ''
		move.w	d6,(a4)+					; ''
		move.w	d1,(a4)+					; ''
		move.w	d0,(a4)+					; render the actual mask sprite now
		move.b	d3,(a4)+					; ''
		addq.w	#$01,a4						; ''
		move.w	d6,(a4)+					; ''
		move.w	d2,(a4)+					; ''
		addi.w	#$0020,d0					; move down to next spot
		dbf	d4,.NextMask					; repeat for the size of the bottom boarder

	.NoMask:
		rts							; finish

; ---------------------------------------------------------------------------
; Sonic
; ---------------------------------------------------------------------------

TH_SpriteSonic:
		moveq	#$08,d0						; get odd/even animation frame based on timer
		and.w	(RTH_FrameCount).l,d0				; ''
		lsr.w	#$02,d0						; ''
		addi.w	#$1C,d0						; align to starting frame number
		move.w	#118,d4						; X position
		move.w	#130,d5						; Y position
		sub.w	(RTH_VScrollFG).l,d5				; move with FG
		bra.w	TH_DrawSprites					; render the cloud

; ---------------------------------------------------------------------------
; The flowers
; ---------------------------------------------------------------------------

TH_SpriteFlower:
		moveq	#$00,d0						; load frame counter
		move.w	(RTH_FrameCount).l,d0				; ''
		lsr.w	#$02,d0						; slow animation down a little
		divu.w	#.Size-.List,d0					; keep within the table range
		swap	d0						; ''
		move.b	.List(pc,d0.w),d0				; load correct frame
		add.w	d0,d0						; convert to word size
		addq.w	#$06-2,d0					; advance to starting frame (and counter the 1)
		move.w	#256,d4						; X position
		move.w	#128,d5						; Y position
		sub.w	(RTH_VScrollFG).l,d5				; move with FG
		bra.w	TH_DrawSprites					; render the cloud

	.List:	dc.b	1,1,1,1,2,3,3,4,4,4,5,6,7,8,9,8,9,8,9,10,11
	.Size:	even

; ---------------------------------------------------------------------------
; Eggman sprites
; ---------------------------------------------------------------------------

TH_SpriteEggman:
		tst.w	(RTH_EggmanX).l					; has eggman gone off-screen on left?
		ble.w	.NoEggman					; if so, no more show
		subi.l	#$00004000,(RTH_EggmanX).l			; move robotnik left
		subi.l	#$00001000,(RTH_EggmanY).l			; move him up a little
		subq.b	#$01,(RTH_EggAni).l				; decrease animation timer
		bcc.s	.Valid						; if not finished, branch
		move.b	#(3*4)-1,(RTH_EggAni).l				; reset timer
		tst.b	(RTH_SmokeAni).l				; is it time to spawn smoke?
		bne.s	.Valid						; if not, continue
		move.b	#(3*$10)-1,(RTH_SmokeAni).l			; reset smoke timer
		move.w	(RTH_EggmanX).l,d0				; set smoke X and Y positions
		addi.w	#$0A,d0						; '' right of flame
		move.w	d0,(RTH_SmokeX).l				; ''
		move.w	(RTH_EggmanY).l,d0				; ''
		addq.w	#$02,d0						; '' down to flame
		move.w	d0,(RTH_SmokeY).l				; ''

	.Valid:
		addi.l	#$00004000,(RTH_SmokeX).l			; move smoke right
		addi.l	#$00001000,(RTH_SmokeY).l			; move smoke down
		move.b	(RTH_SmokeAni).l,d0				; load timer as frame slot
		beq.s	.NoAni						; if timer is finished, keep using last frame
		subq.b	#$01,(RTH_SmokeAni).l				; decrease smoke timer
		lsr.b	#$03,d0						; align to frame slot

	.NoAni:
		andi.w	#$00FE,d0					; '' (keep multiple of 2)
		addi.w	#$0026,d0					; advance to starting slot
		move.w	(RTH_SmokeX).l,d4				; load X and Y smoke positions
		move.w	(RTH_SmokeY).l,d5				; ''
		sub.w	(RTH_VScrollBG).l,d5				; move with BG
		bsr.w	TH_DrawSprites					; render smoke

		move.b	(RTH_EggAni).l,d0				; load timer as frame slot
		lsr.b	#$01,d0						; ''
		andi.w	#$00FE,d0					; '' (keep multiple of 2)
		addi.w	#$0020,d0					; advance to starting slot
		move.w	(RTH_EggmanX).l,d4				; load X and Y eggman positions
		move.w	(RTH_EggmanY).l,d5				; ''
		sub.w	(RTH_VScrollBG).l,d5				; move with BG
		bra.w	TH_DrawSprites					; render eggman

	.NoEggman:
		rts							; return (no more eggman)

; ---------------------------------------------------------------------------
; Clouds
; ---------------------------------------------------------------------------

TH_SpriteClouds:
		move.w	(RTH_FrameCount).l,d4				; load timer as scroll position
		neg.w	d4						; reverse direction
		asr.w	#$03,d4						; reduce for speed
		addi.w	#320/2,d4					; add starting X position
		move.w	#100,d2						; base Y position
		sub.w	(RTH_VScrollBG).l,d2				; move with BG
		moveq	#3-1,d3						; 3 clouds

	.NextCloud:
		moveq	#$03,d5						; get cloud number as Y position
		and.w	d3,d5						; ''
		subq.w	#$02,d5						; mix it up
	;	not.w	d5						; ''
		lsl.w	#$04,d5						; align to distance
		add.w	d2,d5						; add Y base position of clouds
		moveq	#$02,d0						; frame to use
		bsr.s	TH_DrawSprites					; render the cloud
		addi.w	#$200/3,d4					; ensure clouds are distributed evenly in the sprite range
		dbf	d3,.NextCloud					; repeat for all clouds
		rts							; done...

; ---------------------------------------------------------------------------
; Moon
; ---------------------------------------------------------------------------

TH_SpriteMoon:
		moveq	#$04,d0						; frame to use
		move.w	#320/2,d4					; X position
		move.w	#94,d5						; Y position
		sub.w	(RTH_VScrollBG).l,d5				; move with BG

; ===========================================================================
; ---------------------------------------------------------------------------
; Drawing basic sprites
; --- input -----------------------------------------------------------------
; d0.w = frame number x2
; d4.w = X position on-screen
; d5.w = Y position on-screen
; d6.w = base pattern index
; a2.l = mapping list
; a4.l = sprite table buffer
; ---------------------------------------------------------------------------

TH_DrawSprites:
		andi.w	#-2,d0						; clear odd bit
		lea	(a2),a1						; get mapping list
		adda.w	(a1,d0.w),a1					; advance to correct frame mappings
		move.w	(a1)+,d7					; load sprite count
		bmi.s	.Finish						; if there are no pieces, branch

	.NextPiece:
		move.w	(a1)+,d0					; load Y
		add.w	d5,d0						; add base Y
		move.w	d0,(a4)+					; save to sprite table
		move.w	(a1)+,d0					; load shape
		move.b	d0,(a4)+					; save to table
		addq.w	#$01,a4						; skip link
		move.w	(a1)+,d0					; load pattern
		add.w	d6,d0						; add base pattern
		move.w	d0,(a4)+					; save to sprite table
		move.w	(a1)+,d0					; load X
		add.w	d4,d0						; add base X
		andi.w	#$01FF,d0					; keep within boundary
		beq.s	.Mask						; if 0, branch to prevent masking
		move.w	d0,(a4)+					; save to table
		dbf	d7,.NextPiece					; repeat for all pieces
		rts							; return

	.Mask:
		move.w	#1,(a4)+					; set X to non-0 but off-screen
		dbf	d7,.NextPiece					; continue

	.Finish:
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; V-blank
; ---------------------------------------------------------------------------

VB_Thanks:
		movem.l	d0-a5,-(sp)					; store registers

		move.l	#NullRTE,(H_int_addr).w				; disable H-blank
		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''
		move.l	#$8F028AFF,(a6)					; restore increment mode and force H-blank to null

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
		move.l	#(((((((RTH_Sprites)&$FFFFFF)/$02)&$FF00)<<$08)+((((RTH_Sprites)&$FFFFFF)/$02)&$FF))+$96009500),(a6)
		move.l	#((((((RTH_Sprites)&$FFFFFF)/$02)&$7F0000)+$97000000)+((VTH_Sprites)&$3FFF)|$4000),(a6)
		move.w	#((((VTH_Sprites)>>$0E)&$03)|$80),(a1)		; last DMA source from 68k RAM
		move.w	(a1),(a6)
		move.b	d0,(a0)						; restore link

		move.w	#$8F04,(a6)					; set increment mode
		DMA	$01C0, VRAM, VTH_HScroll+0, RTH_HScrollFG	; transfer H-scroll FG
		DMA	$01C0, VRAM, VTH_HScroll+2, RTH_HScrollBG	; transfer H-scroll BG
		move.w	#$8F02,(a6)					; restore increment mode

		move.l	#$40000010,(a6)					; set VDP to VSRAM
		move.w	(RTH_VScrollFG).w,(a5)				; write V-scroll positions
		move.w	(RTH_VScrollBG).w,(a5)				; ''

		DMA	$0080, CRAM, $0000, RTH_PaletteCur		; transfer all lines

	.Late68k:
		jsr	(Poll_Controllers).w				; get controls

		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''

		move.l	#$8A409200|DTH_WINDOWPOS,(a6)			; set window boarder to top and set interrupt in the middle
		move.w	#$8A40,(a6)					; set interrupt line to change the window boarder to the bottom on
		move.l	#HB_Thanks,(H_int_addr).w			; set H-blank routine for boarder change

		movem.l	(sp)+,d0-a5					; restore registers
		move.w	(sp),-$04(sp)					; move sr back
		subq.w	#$02,sp						; write new return address to fractal running routine
		move.l	#.Fractal,(sp)					; ''
		subq.w	#$02,sp						; move back to new sr
		rte							; return

	.Fractal:
		move.w	sr,-(sp)					; store ccr
		movem.l	d0-a5,-(sp)					; store registers
		jsr	dFractalExtra					; run fractal routines
		jsr	dForceMuteYM2612				; force YM2612 channels to mute when requested
		jsr	dFractalSound					; ''
		movem.l	(sp)+,d0-a5					; restore registers
		rtr							; restore ccr

; ---------------------------------------------------------------------------
; H-blank for window boarder
; ---------------------------------------------------------------------------

HB_Thanks:
		move.l	#$8AFF9200|($E0+DTH_WINDOWPOS+DTH_WINDOWSIZE),(a6) ; disable H-blank and force window boarder to the bottom of the screen
		move.l	#NullRTE,(H_int_addr).w				; ''
		rte							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Included data
; ---------------------------------------------------------------------------

Pal_Thanks:	binclude "Data\Thanks Planes\Palette.bin"
Pal_Thanks_End:	even

Art_ThanksFG:	binclude "Data\Thanks Planes\FG Art.kos"
		even
Map_ThanksFG:	binclude "Data\Thanks Planes\FG Map.eni"
		even
Art_ThanksBG:	binclude "Data\Thanks Planes\BG Art.kos"
		even
Map_ThanksBG:	binclude "Data\Thanks Planes\BG Map.eni"
		even

Art_ThanksSpr:	binclude "Data\Thanks Sprites\Art.kos"
		even
Map_ThanksSpr:	binclude "Data\Thanks Sprites\Map.bin"
		even

; ===========================================================================
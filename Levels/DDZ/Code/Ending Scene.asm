; ===========================================================================
; ---------------------------------------------------------------------------
; Ending screen
; ---------------------------------------------------------------------------

SDE_SmallExplode	=	sfx_RocketLaunch			; small explosion sprites
SDE_BigExplode		=	sfx_Bomb				; big final explosion

; ---------------------------------------------------------------------------
; VRAM equates
; ---------------------------------------------------------------------------

VDS_Background	=	$0020
VDS_MoonSprite	=	$4000
VDS_BossSprite	=	$5000

VDS_Window	=	$8000
VDS_Sprites	=	$B800
VDS_HScroll	=	$BC00
VDS_PlaneA	=	$C000
VDS_PlaneB	=	$E000

; ---------------------------------------------------------------------------
; Kosinski PLC list for DDZ phase 2
; ---------------------------------------------------------------------------

	; --- First list ---

DES_KosArtList:
		dc.l	Art_EndingBG
		dc.w	VDS_Background

		dc.l	Art_MoonDS
		dc.w	VDS_MoonSprite

		dc.l	Art_BossDS
		dc.w	VDS_BossSprite

		dc.w	$FFFF

; ---------------------------------------------------------------------------
; RAM equates list
; ---------------------------------------------------------------------------
OffsetROM := *
; ---------------------------------------------------------------------------

			phase	ramaddr($FFFF0000)
RDS_RAM			ds.b	0

RDS_HScrollFG		ds.b	$1C0
RDS_HScrollBG		ds.b	$1C0
RDS_FadeTimer		ds.b	1					; fade delay timer
RDS_BossSprites		ds.b	1					; when boss sprites are allowed to show
RDS_DialogObject	ds.w	1					; place to hold the RAM address of the dialog, so I can control when to make the backdrop black at the right time
RDS_BoarderObject	ds.w	1					; place to hold the RAM address of the boarder
RDS_ScrollV_FG		ds.l	1					; V-scroll position for FG and BG
RDS_ScrollV_BG		ds.l	1					; '' (QQQQFFFF)
RDS_Flash		ds.b	1					; if the palette should flash from the blast
RDS_FinishEnding	ds.b	1					; if the ending is now finished


EDS_ObjCount	=	$20
RDS_Objects		ds.b	SO_Size*EDS_ObjCount			; see "Phase 2.asm" for the structure
RDS_Sonic		ds.b	SO_Size
RDS_Eggman		ds.b	SO_Size

RDS_EniDump
RDS_KosDump		ds.b	$4000					; place to dump kos and eni data (eni mappings are $4000 bytes bit for this screen)

			ds.l	4
RDS_RAM_End		ds.b	0
			dephase

RDS_Sprites	=	Sprite_table_buffer

; ---------------------------------------------------------------------------
; Screen code
; ---------------------------------------------------------------------------

DE_EndingScreen:
		move.w	#$2700,sr					; disable interrupts
		move.l	#NullRTE,(H_int_addr).w				; disable H-blank
		move.l	#VB_EndingScreen,(V_int_addr).w			; set new V-blank routine
		lea	($C00000).l,a5					; reload VDP registers
		lea	$04(a5),a6					; ''

	; --- Setting up VDP and RAM ---

		lea	($C00000).l,a5					; load VDP data and control port
		lea	$04(a5),a6					; ''

		move.w	#$8000|%00000100,(a6)			; 80	; 00LH 01CD - Leftover SMS bar (0N|1Y) | H-Interrupt (0N|1Y) | H,V Counter (0N|1Y) | Disable video signal (0N|1Y)
		move.w	#$8100|%00010100,(a6)			; 81	; SDVM P100 - SMS mode (0N|1Y) | Display (0N|1Y) | V-Interrupt (0N|1Y) | DMA (0N|1Y) | V-resolution (0-1C|1-1E)
		move.w	#$8200|(((VDS_PlaneA)>>$0A)&$FF),(a6)	; 82	; 00FE DCBA - Scroll Plane A Map Table VRam address
		move.w	#$8300|(((VDS_Window)>>$0A)&$FF),(a6)	; 83	; 00FE DCB0 / 00FE DC00 (20 Resolution) - Window Plane A Map Table VRam address
		move.w	#$8400|(((VDS_PlaneB)>>$0D)&$FF),(a6)	; 84	; 0000 0FED - Scroll Plane B Map Table VRam address
		move.w	#$8500|(((VDS_Sprites)>>$09)&$FF),(a6)	; 85	; 0FED CBA9 / 0FED CBA0 (20 Resolution) - Sprite Plane Map Table VRam address
		move.w	#$8600|$00,(a6)				; 86	; 0000 0000 - Unknown/Unused Register
		move.w	#$8700|$30,(a6)				; 87	; 00PP CCCC - Backdrop Colour: Palette Line 0/Colour ID 0
		move.w	#$8800|$00,(a6)				; 88	; 0000 0000 - Unknown/Unused Register
		move.w	#$8900|$00,(a6)				; 89	; 0000 0000 - Unknown/Unused Register
		move.w	#$8A00|$DF,(a6)				; 8A	; 7654 3210 - H-Interrupt Register
		move.w	#$8B00|%00000011,(a6)			; 8B	; 0000 EVHH - External Interrupt (0N|1Y) | V-Scroll: (0-Full|1-2Celled) | H-Scroll: (00-Full|10-Celled|11-Sliced)
		move.w	#$8C00|%10000001,(a6)			; 8C	; APHE SNNB - H-resol (0N|1Y) | Pixel int (0N|1Y) | H-sync (0N|1Y) | Extern-pix (0N|1Y) | S/H (0N|1Y) | Interlace (00N|01Y|11-Split) | H-resol (0-20|1-28)
		move.w	#$8D00|(((VDS_HScroll)>>$0A)&$FF),(a6)	; 8D	; 00FE DCBA - Horizontal Scroll Table VRam address
		move.w	#$8E00|$00,(a6)				; 8E	; 0000 0000 - Unknown/Unused Register
		move.w	#$8F00|$02,(a6)				; 8F	; 7654 3210 - Auto Increament
		move.w	#$9000|%00010001,(a6)			; 90	; 00VV 00HH - Plane Y Size (00-20|01-40|11-80) | Plane X size (00-20|01-40|11-80)
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

		lea	(RDS_RAM).l,a1					; load devil eggman screen RAM space
		move.w	#((RDS_RAM_End-RDS_RAM)/4)-1,d1			; size to clear

	.ClearRAM:
		move.l	d0,(a1)+					; clear RAM
		dbf	d1,.ClearRAM					; repeat for entire RAM space

		; Waiting for VDP DMA fill

		move.w	(a6),ccr					; load status
		bvs.s	*-$02						; if the VDP DMA busy flag was set (bit 1), branch to wait til finished...
		move.w	#$8F02,(a6)					; set VDP increment mode back to normal

	; --- Hellfire saga engine crap ---

		command	cmd_Reset
		jsr	(Clear_Kos_Module_Queue).w
		jsr	(Clear_DisplayData).w
		clearRAM Object_RAM, Object_RAM_End
		clearRAM Lag_frame_count, Lag_frame_count_End
		clearRAM Camera_RAM, Camera_RAM_End
		clearRAM v_oscillate, v_oscillate_end
		ResetDMAQueue

		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineFirst.w	; set extra routine to just rts
		move.l	#ExtraRoutine_Null,ExtraSpriteRoutineLast.w	; set extra routine to just rts

	; --- Kosinski art ---

		lea	DES_KosArtList(pc),a4				; load PLC list
		lea	(RDS_KosDump).l,a1				; load RAM buffer address to use for kosinski decompression
		jsr	KosDirectPLC					; decompress art and transfer to VRAM

	; --- Dialog ---

		st.b	(NoPause_flag).w
		st.b	(Level_end_flag).w				; move HUD off
		jsr	(Create_New_Sprite).w				; load a free object slot
		bne.s	.NoSlot						; if there's no slot, skip (see no reason not to be)
		move.w	a1,(RDS_DialogObject).l				; store dialog object RAM address for detection later
		move.l	#Obj_Dialog_Process,address(a1)
		move.b	#_DDZStart,routine(a1)
		move.l	#DialogDDZEnd_Process_Index-4,$34(a1)
		move.b	#(DialogDDZEnd_Process_Index_End-DialogDDZEnd_Process_Index)/8,$39(a1)

	.NoSlot:
		lea	(ArtKosM_BlackStretch).l,a1			; load art for boarder
		move.w	#tiles_to_bytes($580),d2			; VRAM address of boarder
		jsr	(Queue_Kos_Module).w				; add kosinski art to queue
		jsr	Load_BlackStretch				; load boarder object
		move.w	a1,(RDS_BoarderObject).l

	; --- Mappings ---

		lea	($C00000).l,a5					; reload VDP data and control port
		lea	$04(a5),a6					; ''

		lea	(Map_EndingBG).l,a0				; compressed mappings
		moveq	#$00,d3						; load width
		move.b	(a0)+,d3					; ''
		moveq	#$00,d2						; load height
		move.b	(a0)+,d2					; ''
		lea	(RDS_EniDump).l,a1				; RAM address to dump
		moveq	#$00,d0
		jsr	EniDec						; decompress and dump
		move.w	#$2000|((VDS_Background/$20)-1),d5		; tile adjustment
		move.l	#$40000000|(((VDS_PlaneA)&$3FFF)<<$10)|((VDS_PlaneA)>>$E),d4 ; starting VRAM address

	.NextY:
		move.l	d4,(a6)						; set plane line address
		addi.l	#$00800000,d4					; advance to next line
		move.w	d3,d1						; load Y count

	.NextX:
		move.w	(a1)+,d0					; load tile
		add.w	d5,d0						; add base index
		move.w	d0,(a5)						; save to VRAM
		dbf	d1,.NextX					; repeat for rows
		dbf	d2,.NextY					; repeat for columns

	; --- Palette ---

	.SKIPLAST:
		lea	(Pal_Sonic+2).l,a0
		lea	(Normal_palette).w,a1
		lea	(Target_palette).w,a2
		clr.w	(a1)+
		clr.w	(a2)+
		move.w	(a0)+,d0
		move.w	d0,(a1)+
		move.w	d0,(a2)+
		rept	$1C/4
		move.l	(a0)+,d0
		move.l	d0,(a1)+
		move.l	d0,(a2)+
		endm
		move.l	#$0EEE0EEE,d0
		moveq	#($60/4)-1,d7
		.ClearPal:
		move.l	d0,(a1)+
		dbf	d7,.ClearPal

	lea	(Pal_Ending).l,a0
	moveq	#((Pal_Ending_End-Pal_Ending)/4)-1,d7

	.TEMPPALETTE:
	move.l	(a0)+,(a2)+
	dbf	d7,.TEMPPALETTE

	moveq	#$00,d0
	rept	$20/4
	move.l	d0,(a2)+
	endm

		move.w	#(RDE_Sprites+3)&$FFFF,(Sprite_Link).w		; set starting link address
		move.w	#$0004,(Sprite_Size).w				; set starting transfer size

		move.l	#($0120-($90*2))<<$10,(RDS_ScrollV_FG).l	; starting plane Y positions
		move.l	#($0120-($90*1))<<$10,(RDS_ScrollV_BG).l	; ''

		move.w	#$8100|%01110100,(a6)			; 81	; SDVM P100 - SMS mode (0N|1Y) | Display (0N|1Y) | V-Interrupt (0N|1Y) | DMA (0N|1Y) | V-resolution (0-1C|1-1E)

; ---------------------------------------------------------------------------
; Ending screen main loop
; ---------------------------------------------------------------------------

ML_EndingScreen:
		jsr	(Process_Kos_Queue).w
		st.b	(V_int_routine).w				; set 68k as ready
		jsr	Wait_VSync					; wait for V-blank
		bsr.w	DES_Events					; run events
		addq.w	#1,(Level_frame_counter).w			; increase frame counter

		movea.w	(RDS_BoarderObject).l,a1			; load boarder object
		tst.l	address(a1)					; has it been deleted yet?
		beq.s	.NoEngine					; if so, normal objects enging is now finished
		jsr	(Process_Sprites).w				; run engine objects
		jsr	(Render_Sprites).w				; display engine sprites
		bra.s	.DoneEngine					; continue

	.NoEngine:
		bsr.w	DES_RenderSprites				; run real sprites

	.DoneEngine:
		jsr	(Process_Kos_Module_Queue).w			; process kosinski queue
		tst.b	(RDS_FinishEnding).l				; is the ending finished?
		beq.s	ML_EndingScreen					; if not, branch
		move.w	#$2700,sr					; disable interrupts
		move.l	#VInt,(V_int_addr).w				; reset interrupt addresses
		move.l	#HInt,(H_int_addr).w				; ''
		jsr	Init_VDP					; reset VDP registers, VRAM, etc...
		enableScreen
		move.b	#id_Level,(Game_mode).w				; set screen mode
		move.w	#$0400,(Current_Zone).w				; set level to credits stage
		rts							; return

; ---------------------------------------------------------------------------
; Events routines
; ---------------------------------------------------------------------------

DES_Events:
		tst.b	(Level_end_flag).w				; has dialog finished?
		bpl.s	.DialogFinish					; if so, continue
		movea.w	(RDS_DialogObject).l,a1				; load dialog address
		cmpi.w	#$0047,$2E(a1)					; has the dialog reached a time where it's about to bring in the sprite boarder?
		bne.s	.NoBoarder					; if not, don't change backdrop yet
		clr.w	(Normal_palette+$60).w				; change backdrop to black JUST BEFORE the sprite boarder comes in (make it look part of the boarder =3)

	.NoBoarder:
	.NoFade:
		rts							; return (no change)

	.DialogFinish:
		cmpi.w	#$0120,(RDS_ScrollV_FG).l			; has the screen fully scrolled in?
		bne.s	.MoveScreen					; if not, branch
		tst.b	(RDS_BossSprites).l				; have the sprites already been enabled?
		bne.s	.SetupDone					; if so, skip
		st.b	(RDS_BossSprites).l				; enable boss sprites

		move.w	#$2000|(VDS_BossSprite/$20),d6			; prepare VRAM address
		lea	(Map_BossDS).l,a2				; prepare map list
		move.l	#$FFFF8000,d2					; Y speed to move
		lea	(RDS_Objects).l,a0				; load object list



		lea	(RDS_Sonic).l,a0

	; sonic

		move.w	d6,SO_Pattern(a0)				; set pattern index
		move.l	a2,SO_Mappings(a0)				; set mappigns
		move.w	#180,SO_PosY(a0)				; Y position
		move.w	#215,SO_PosX(a0)				; X position
		move.w	#$0004,SO_Frame(a0)				; set frame
		move.l	d2,SO_SpeedY(a0)				; Y speed
		lea	SO_Size(a0),a0					; slot done

	; moth

		move.w	d6,SO_Pattern(a0)				; set pattern index
		move.l	a2,SO_Mappings(a0)				; set mappigns
		move.w	#180,SO_PosY(a0)				; Y position
		move.w	#215,SO_PosX(a0)				; X position
		move.w	#$0002,SO_Frame(a0)				; set frame
		move.l	d2,SO_SpeedY(a0)				; Y speed
		lea	SO_Size(a0),a0					; slot done



	.SetupDone:
		tst.b	(RDS_Flash).l					; has flash occurred?
		bne.s	.Flash						; if so, branch
		rts							; return

	.MoveScreen:
		move.l	#$01200000,d0					; get distance for FG
		sub.l	(RDS_ScrollV_FG).l,d0				; ''
		asr.l	#$06,d0						; reduce distance for speed
		addi.l	#$8888,d0					; round upwards
		add.l	d0,(RDS_ScrollV_FG).l				; move scroll position up
		move.l	#$01200000,d0					; get distance for BG
		sub.l	(RDS_ScrollV_BG).l,d0				; ''
		asr.l	#$06,d0						; reduce distance for speed
		addi.l	#$8888,d0					; round upwards
		add.l	d0,(RDS_ScrollV_BG).l				; move scroll position up


	.Flash:
		subq.b	#$01,(RDS_FadeTimer).l				; reduce delay timer
		bcc.w	.NoFade						; if delaying, skip fading
		move.b	#$03,(RDS_FadeTimer).l				; reset delay timer

		lea	(Target_palette+$20).w,a0			; load palette to fade to
		lea	(Normal_palette+$20).w,a1			; load current palette address
		moveq	#($60/2)-1,d7					; size of entire palette

	.NextColour:
		move.w	(a0)+,d0					; copy destination colour	
		move.w	(a1),d2						; load current colour
		moveq	#$0E,d1						; get only red
		move.b	d2,d3						; ''
		and.b	d1,d3						; ''
		and.b	d0,d1						; ''
		cmp.b	d1,d3						; have we reached red?
		beq.s	.NoRed						; if so, skip
		subq.w	#$0002,(a1)+					; reduce red
		dbf	d7,.NextColour					; repeat for all colours
		rts							; return

	.NoRed:
		move.b	d2,d3						; get only green
		andi.w	#$00E0,d3					; ''
		cmp.b	d3,d0						; have we reached green?
		bcc.s	.NoGreen					; if so, skip
		subi.w	#$0020,(a1)+					; reduce green
		dbf	d7,.NextColour					; repeat for all colours
		rts							; return

	.NoGreen:
		move.w	d2,d3						; get only blue
		sf.b	d3						; ''
		cmp.w	d3,d0						; have we reached blue?
		bpl.s	.NoBlue						; if so, skip
		subi.w	#$0200,(a1)+					; reduce blue
		dbf	d7,.NextColour					; repeat for all colours
		rts							; return

	.NoBlue:
		addq.w	#$02,a1						; skip colour (this one's done)
		dbf	d7,.NextColour					; repeat for all colours
		rts							; return

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to render sprites
; ---------------------------------------------------------------------------

DES_RenderSprites:
		lea	(RDE_Sprites).w,a4				; load sprite buffer

		tst.b	(RDS_BossSprites).l				; are boss sprites enabled?
		beq.s	.NoBoss						; if not, branch
		bsr.s	DES_BossSprites					; render boss sprites

	.NoBoss:
		bsr.w	DES_MoonSprites					; render moon/cloud sprites

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
; Boss/explosion sprites
; ---------------------------------------------------------------------------

DES_BossSprites:
		lea	(RDS_Objects).l,a0				; load boss objects
		moveq	#EDS_ObjCount-1,d7				; number of slots

	.Next:
		move.w	SO_Frame(a0),d0					; load frame
		beq.s	.NoSlot						; if blank, branch
		subq.w	#$01,SO_Timer(a0)				; decrease animation timer
		bcc.s	.Continue					; if still counting, branch
		move.w	#$07,SO_Timer(a0)				; reset animation timer
		addq.w	#$01,d0						; increase slot
		cmpi.w	#$0016,d0					; is this the end of a small explosion?
		beq.s	.Delete						; if so, branch to stop it
		cmpi.w	#$001E,d0					; is this the end of a larger explosion?
		bne.s	.ContNoGrav					; if not, don't stop it yet

	.Delete:
		moveq	#$00,d0						; clear slot

	.Continue:
		addi.l	#$00000400,SO_SpeedY(a0)			; increase gravity

	.ContNoGrav:
		move.w	d0,SO_Frame(a0)					; update frame
		bsr.w	.Move						; move and render the explosion

	.NoSlot:
		lea	SO_Size(a0),a0					; advance to next slot
		dbf	d7,.Next					; repeat for all slots

	; --- Sonic ---

		lea	(RDS_Sonic).l,a0				; load boss objects
		moveq	#$50,d0						; has Sonic moved above the screen fully?
		add.w	SO_PosY(a0),d0					; ''
		bpl.s	.NoFinish					; if not, continue
		st.b	(RDS_FinishEnding).l				; set ending as finished

	.NoFinish:
		move.w	SO_Frame(a0),d0					; load frame ID of Sonic
		addq.w	#$01,d0						; animate frame
		cmpi.w	#$0C,d0						; have we reached the last frame?
		blo.s	.SonicAni					; if not, continue
		moveq	#$04,d0						; reset animation

	.SonicAni:
		move.w	d0,SO_Frame(a0)					; update frame ID
		bsr.w	.Move						; move and render Sonic

	; --- Eggman ---

		lea	SO_Size(a0),a0					; advance to devil object
		tst.w	SO_Frame(a0)					; has the devil exploded already?
		beq.w	.NoExplode					; if so, branch
		cmpi.w	#$0020,SO_PosY(a0)				; has eggman reached explode area?
		bgt.s	.KeepMoving					; if not, branch
		clr.w	SO_Frame(a0)					; delete devil object
		bsr.w	DES_FindObjectSlot				; find a free object slot
		bne.w	.NoExplode					; if none available, branch
		move.w	SO_PosX(a0),SO_PosX(a1)				; move explosion to eggman
		move.w	SO_PosY(a0),SO_PosY(a1)				; ''
		move.w	#$0016,SO_Frame(a1)				; set frame to explosion
		st.b	(RDS_Flash).l					; flash the palette
		bsr.w	DES_FlashPalette				; flash palette brighter
		sfx	SDE_BigExplode					; play big explosion sfx
		bra.s	.LargeExplode					; continue the pattern/mapping copy

	.KeepMoving:
		subq.w	#$01,SO_Timer(a0)				; decrease explosion counter
		bcc.s	.NoExplode					; if still running, branch
		move.w	#7,SO_Timer(a0)					; reset timer
		bsr.w	DES_FindObjectSlot				; find a free object slot
		bne.s	.NoExplode					; if none available, branch
		jsr	RandomNumber					; get a random number
		andi.w	#$000F,d0					; get random X
		subq.w	#$08,d0						; allow for left and right side
		swap	d1						; get random Y (lower word nybble is always the same)
		andi.w	#$0007,d1					; ''
		subq.w	#$08,d1
		add.w	SO_PosX(a0),d0					; randomise X around eggman
		move.w	d0,SO_PosX(a1)					; ''
		add.w	SO_PosY(a0),d1					; randomise Y around eggman
		move.w	d1,SO_PosY(a1)					; ''
		move.w	#$000C,SO_Frame(a1)				; set frame to explosion
		move.l	#$FFFD000,SO_SpeedY(a1)				; set starting speed to move up slightly first
		sfx	SDE_SmallExplode				; play small explosion sfx

	.LargeExplode:
		move.w	SO_Pattern(a0),SO_Pattern(a1)			; pattern index match
		move.l	SO_Mappings(a0),SO_Mappings(a1)			; mappings list match

	.NoExplode:
							; continue to..	; move and render eggman

	; --------------------------
	; Move and render routine...
	; --------------------------

	.Move:
		move.l	SO_SpeedX(a0),d0				; move on X
		add.l	d0,SO_PosX(a0)					; ''
		move.l	SO_SpeedY(a0),d0				; move on Y
		add.l	d0,SO_PosY(a0)					; ''
		jmp	DE_RenderStandard				; render the object as standard

; ---------------------------------------------------------------------------
; Subroutine to brighten the palette
; ---------------------------------------------------------------------------

DES_FLASHAMOUNT	= 6

DES_FlashPalette:
		lea	(Normal_palette+$20).w,a2			; load current palette address
		moveq	#($60/2)-1,d7					; size of entire palette

	.FlashNext:
		move.b	(a2),d0						; load blue
		addq.b	#DES_FLASHAMOUNT,d0				; increase brightness
		cmpi.b	#$0E,d0						; has it gone passed full?
		bls.s	.OkayBlue					; if not, branch
		moveq	#$0E,d0						; force to full

	.OkayBlue:
		move.b	d0,(a2)+					; update blue
		move.b	(a2),d0						; load green and red
		moveq	#$0E,d1						; get red
		and.w	d0,d1						; ''
		sub.b	d1,d0						; get green
		addi.b	#DES_FLASHAMOUNT<<4,d0				; increase green
		bcc.s	.OkayGreen					; if not reached maximum, branch
		moveq	#-$20,d0					; keep at maximum

	.OkayGreen:
		addq.b	#DES_FLASHAMOUNT,d1				; increase red
		cmpi.b	#$0E,d1						; has it gone passed full?
		bls.s	.OkayRed					; if not, branch
		moveq	#$0E,d1						; force to full

	.OkayRed:
		or.b	d1,d0						; fuse red with green
		move.b	d0,(a2)+					; update greeen and red
		dbf	d7,.FlashNext					; repeat for all colours
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to find a free object slot for explosions
; ---------------------------------------------------------------------------

DES_FindObjectSlot:
		lea	(RDS_Objects).l,a1				; load boss objects
		moveq	#EDS_ObjCount-1,d7				; number of slots

	.Next:
		tst.w	SO_Frame(a1)					; is this slot free?
		beq.s	.Found						; if so, branch
		lea	SO_Size(a1),a1					; advance to next slot
		dbf	d7,.Next					; repeat for all slots

	.Found:
		rts							; return

; ---------------------------------------------------------------------------
; BG moon/cloud sprites
; ---------------------------------------------------------------------------

DES_MoonSprites:
		lea	(Map_MoonDS).l,a2				; load mappings
		move.w	#$2000|(VDS_MoonSprite/$20),d3			; prepare pattern index

		move.w	#$0120,d4					; get distance from finish the BG scroll is
		sub.w	(RDS_ScrollV_BG).l,d4				; '' (use as sprite scroll)

		moveq	#$27,d2						; Y position
		move.w	#160,d1						; X position
		moveq	#0*2,d0						; moon
		bsr.s	DES_RenderElement				; ''

		moveq	#$31,d2						; Y position
	move.w	d4,d0
	asr.w	#$02,d0
	move.w	d4,d1
	sub.w	d0,d1
	add.w	d1,d2
		move.w	#95,d1						; X position
		moveq	#1*2,d0						; left cloud
		bsr.s	DES_RenderElement				; ''

		moveq	#$46,d2						; Y position
	move.w	d4,d0
	asr.w	#$02,d0
	move.w	d4,d1
	sub.w	d0,d1
	add.w	d1,d2
		move.w	#222,d1						; X position
		moveq	#2*2,d0						; right cloud
		bsr.s	DES_RenderElement				; ''

		moveq	#$2F,d2						; Y position
	move.w	d4,d0
	asr.w	#$01,d0
	add.w	d0,d2
		move.w	#247,d1						; X position
		moveq	#3*2,d0						; right cloud small

; ---------------------------------------------------------------------------
; Rendering a sprite element
; --- input -----------------------------------------------------------------
; d0.w = frame ID * 2
; d1.w = X position
; d2.w = Y position
; d3.w = pattern index
; a2.l = sprite mappings
; a4.l = sprite table
; ---------------------------------------------------------------------------

DES_RenderElement:
		lea	(a2),a1
		adda.w	(a1,d0.w),a1
		move.w	(a1)+,d7					; load number of sprites
		bmi.s	.NoMoon						; if there are none, finish

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

	.NoMoon:
		rts							; return (no sign)

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending V-blank
; ---------------------------------------------------------------------------

VB_EndingScreen:
		movem.l	d0-a6,-(sp)					; store register contents
		tst.b	(V_int_routine).w				; is the 68k ready for V-blank?
		beq.w	.Late68k					; if not, branch
		sf.b	(V_int_routine).w				; set V-blank as now ran
		stopZ80
		jsr	Poll_Controllers				; obtain controller data
		startZ80

		lea	($C00000).l,a5					; load VDP data port
		lea	$04(a5),a6					; load VDP control port

		move.l	#$40000010,(a6)					; set VSRAM
		move.w	(RDS_ScrollV_FG).l,(a5)				; ''
		move.w	(RDS_ScrollV_BG).l,(a5)				; ''

		move.w	#$8F04,(a6)					; set increment to skip a word
		DMA	$01C0, VRAM, VDS_HScroll,   RDS_HScrollFG	; transfer H-scroll FG
		DMA	$01C0, VRAM, VDS_HScroll+2, RDS_HScrollBG	; transfer H-scroll BG
		move.w	#$8F02,(a6)					; restore increment mode

		; Sprites

		movea.w	(RDS_BoarderObject).l,a1			; load boarder object
		tst.l	address(a1)					; has it been deleted yet?
		beq.s	.NoEngine					; if so, normal objects enging is now finished
		DMA	$0280, VRAM, VDS_Sprites, Sprite_table_buffer	; transfer sprites
		bra.s	.DoneEngine					; continue

	.NoEngine:
		movea.w	(Sprite_Link).w,a0				; load link address
		move.b	(a0),d0						; store link
		sf.b	(a0)						; clear link
		lea	(R_VDP94).w,a1					; load DMA list
		move.w	(Sprite_Size).w,d1				; load size of table
		movep.w	d1,$01(a1)					; set DMA size registers
		move.l	(a1)+,(a6)					; ''
		move.l	#(((((((RDS_Sprites)&$FFFFFF)/$02)&$FF00)<<$08)+((((RDS_Sprites)&$FFFFFF)/$02)&$FF))+$96009500),(a6)
		move.l	#((((((RDS_Sprites)&$FFFFFF)/$02)&$7F0000)+$97000000)+((VDS_Sprites)&$3FFF)|$4000),(a6)
		move.w	#((((VDS_Sprites)>>$0E)&$03)|$80),(a1)		; last DMA source from 68k RAM
		move.w	(a1),(a6)
		move.b	d0,(a0)						; restore link

	.DoneEngine:


		DMA	$0080, CRAM, $0000, Normal_palette		; transfer palette

		jsr	Process_DMA_Queue				; run DMA queue
		subq.w	#$04,sp						; move stack back for kosinski routine
		jsr	Set_Kos_Bookmark				; setup kos to resume on return it were interrupted mid-way
		addq.w	#$04,sp						; restore stack
		st.b	(Lag_frame_count).w				; reset lag count

	.Late68k:
		addq.b	#$01,(Lag_frame_count).w			; increase lag count

	.Cont68k:
		jsr	dFractalExtra					; update extra functions
		jsr	dForceMuteYM2612				; force YM2612 channels to mute when requested
		jsr	dFractalSound					; update Fractal
		jsr	Random_Number					; mix random number up more
		addq.l	#$01,(V_int_run_count).w			; increase frame count

		movem.l	(sp)+,d0-a6					; restore register data
		rte							; return


; ===========================================================================
; ---------------------------------------------------------------------------
; Included data
; ---------------------------------------------------------------------------

Pal_Ending:	binclude "Data\Phase 2 Ending Scene\Background\Palette.bin"
Pal_Ending_End:	even

Art_EndingBG:	binclude "Data\Phase 2 Ending Scene\Background\Planes Art.kos"
		even
Map_EndingBG:	binclude "Data\Phase 2 Ending Scene\Background\Planes Map.eni"
		even

Art_MoonDS:	binclude "Data\Phase 2 Ending Scene\Background\Moon Sprite\Art.kos"
		even
Map_MoonDS:	binclude "Data\Phase 2 Ending Scene\Background\Moon Sprite\Map.bin"
		even

Art_BossDS:	binclude "Data\Phase 2 Ending Scene\Boss Sprites\Art.kos"
		even
Map_BossDS:	binclude "Data\Phase 2 Ending Scene\Boss Sprites\Map.bin"
		even

; ===========================================================================
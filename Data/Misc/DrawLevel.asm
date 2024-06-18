; ===========================================================================
; ---------------------------------------------------------------------------
; Prepare FG parameters for RedrawPMap
; ---------------------------------------------------------------------------

InitFGCam:
		lea	CamXFG.w,a3			; Get base (FG) camera address
		movea.l	Layout.w,a4			; Get level layout address
		move.w	#$4000+((vram_fg)&$3FFF),d2	; Set "Master" base VRAM
		move.w	#0,a2				; FG ptr address prefix
		rts
; ---------------------------------------------------------------------------
; Prepare BG parameters for RedrawPMap
; ---------------------------------------------------------------------------

InitBGCam:
		lea	CamXBG.w,a3			; Get base (BG) camera address
		movea.l	Layout.w,a4			; Get level layout address
		move.w	#$4000+((vram_bg)&$3FFF),d2	; Set "Master" base VRAM
		move.w	#2,a2				; BG ptr address prefix
		rts
; ---------------------------------------------------------------------------
; Subroutine to redraw a plane map with level data given proper settings
; "Straight", single-cam way
; > Writes only to visibly necessary according to X/Y pos
; in:
; a3 = Cam addr
; a4 = Layout addr
; a2 = Layout prefix addr
; d2 = VRAM destination (highest 16 bits VRAM Write comm ($C000-$FFFF range))
; ---------------------------------------------------------------------------

RedrawPMap:
		moveq	#((320+16+16)/16)-1,d7		; screen width + 1 column forwards + 1 backwards

		move.w	(a3),d4				; get xpos
		move.w	4(a3),d5			; get ypos
		subi.w	#$10,d4				; but begin drawing from 1 column to left
		subi.w	#$10,d5				; but begin drawing from 1 row to up

.loop		lea	PlaneBuf.w,a6			; load VInt array address
		move.w	d5,-(sp)			; backup "current" ypos
		jsr	DrawColumn_Generic(pc)		; map column
		jsr	ScrollDraw_VInt(pc)		; upload column
		move.w	(sp)+,d5			; restore "current" ypos
		addi.w	#$10,d4				; increment xpos (do next column)
		dbf	d7,.loop			; repeat
		rts

	; --- Special FG credits version ---

RedrawPMap_Credits:
		moveq	#((320+16+16)/16)-1,d7		; screen width + 1 column forwards + 1 backwards

		move.w	(a3),d4				; get xpos
		move.w	4(a3),d5			; get ypos
		subi.w	#$10,d4				; but begin drawing from 1 column to left
		subi.w	#$10,d5				; but begin drawing from 1 row to up

.loop		lea	PlaneBuf.w,a6			; load VInt array address
		move.w	d5,-(sp)			; backup "current" ypos
		jsr	DrawColumn_Generic(pc)		; map column
		jsr	ScrollDraw_Credits_VInt		; upload column
		move.w	(sp)+,d5			; restore "current" ypos
		addi.w	#$10,d4				; increment xpos (do next column)
		dbf	d7,.loop			; repeat
		rts

; ---------------------------------------------------------------------------
; Subroutine to redraw a full plane map with level data given proper settings
; "Straight", single-cam way
; in:
; a3 = Cam addr
; a4 = Layout addr
; a2 = Layout prefix addr
; d2 = VRAM destination (highest 16 bits VRAM Write comm ($C000-$FFFF range))
; ---------------------------------------------------------------------------

RedrawPMap_full:
		moveq	#((512)/16)-1,d7		; screen width
		move.w	(a3),d4				; get xpos
		move.w	4(a3),d5			; get ypos
;		subi.w	#$10,d4				; but begin drawing from 1 column to left
		subi.w	#$10,d5				; but begin drawing from 1 row to up

.loop		lea	PlaneBuf.w,a6			; load VInt array address
		move.w	d5,-(sp)			; backup "current" ypos
		jsr	DrawColumn_Generic(pc)		; map column
		jsr	ScrollDraw_VInt(pc)		; upload column
		move.w	(sp)+,d5			; restore "current" ypos
		addi.w	#$10,d4				; increment xpos (do next column)
		dbf	d7,.loop			; repeat
		rts

	; --- Special FG credits version ---

RedrawPMap_Credits_full:
		moveq	#((512)/16)-1,d7		; screen width
		move.w	(a3),d4				; get xpos
		move.w	4(a3),d5			; get ypos
;		subi.w	#$10,d4				; but begin drawing from 1 column to left
		subi.w	#$10,d5				; but begin drawing from 1 row to up

.loop		lea	PlaneBuf.w,a6			; load VInt array address
		move.w	d5,-(sp)			; backup "current" ypos
		jsr	DrawColumn_Generic(pc)		; map column
		jsr	ScrollDraw_Credits_VInt		; upload column
		move.w	(sp)+,d5			; restore "current" ypos
		addi.w	#$10,d4				; increment xpos (do next column)
		dbf	d7,.loop			; repeat
		rts

; ---------------------------------------------------------------------------
; Subroutine to redraw BG plane map with level data respecting the proper
; cameras, all given proper settings
; > Writes only to visibly necessary according to X/Y pos
; ---------------------------------------------------------------------------

RedrawBGMap:
		bsr.s	.DrawBG1
		bsr.s	.DrawBG2
;		bra.s	.DrawBG3

.DrawBG3	moveq	#$03,d7				; set cam ID
		lea	ScrollBG3.w,a5			; Get scroll flags
		lea	CamXBG3.w,a3			; Get cam position
		bra.s	.drawlayer

.DrawBG2	moveq	#$02,d7				; set cam ID
		lea	ScrollBG2.w,a5			; Get scroll flags
		lea	CamXBG2.w,a3			; Get cam position
		bra.s	.drawlayer

.DrawBG1	moveq	#$01,d7				; set cam ID
		lea	ScrollBG1.w,a5			; Get scroll flags
		lea	CamXBG.w,a3			; Get cam position

; in:
; d7 = BG cam ID
.drawlayer	moveq	#((320+16+16)/16)-1,d6		; screen width + 1 column forwards + 1 backwards

		move.w	(a3),d4				; get xpos
		move.w	4(a3),d5			; get ypos
		subi.w	#$10,d4				; but begin drawing from 1 column to left
		subi.w	#$10,d5				; but begin drawing from 1 row to up

.loop		lea	PlaneBuf.w,a6			; load VInt array address
		move.w	d5,-(sp)			; backup "current" ypos
		move.w	d6,-(sp)			; backup loop counter
		jsr	DrawColumnBG_Generic(pc)	; map column
		jsr	ScrollDraw_VInt(pc)		; upload column
		move.w	(sp)+,d6			; restore loop counter
		move.w	(sp)+,d5			; restore "current" ypos
		addi.w	#$10,d4				; increment xpos (do next column)
		dbf	d6,.loop			; repeat
		rts
; ---------------------------------------------------------------------------
; Macro to convert x/ypos into a VRAM Write comm
; in:
; d2 = base VRAM (highest 16 bits VRAM Write comm ($C000-$FFFF range))
; d4 = "current" xpos
; d5 = "current" ypos
; ---------------------------------------------------------------------------

CalcVRAMPos	macro
		move.w	d4,d3				; get xpos
		lsr.w	#2,d3				; divide by 4 (ex: $10 -> $04)
		andi.w	#$7C,d3				; keep/wrap within Plane Map's x range (tile row = $80 bytes)

		move.w	d5,d1				; get ypos
		lsl.w	#4,d1				; multiply by $10 (ex: $10 -> $100)
		andi.w	#$F00,d1			; keep/wrap within Plane Map's y range (512x256 Plane map = $1000 bytes)

		add.w	d1,d3				; add final ypos
		add.w	d2,d3				; add base VRAM
	endm
; ---------------------------------------------------------------------------
; Macro that return xpos and address from the camera found given proper ypos
; in:
; d5 = current ypos
; a1 = scroll bg array
; a3 = first camera address
; ---------------------------------------------------------------------------

GetCamAddr	macro
		move.w	d5,d0				; copy ypos
		andi.w	#$7FF0,d0			; keep in range
		lsr.w	#3,d0				; $10 -> $02
		move.w	(a1,d0.w),d0			; get camera address
	endm
; ---------------------------------------------------------------------------
; Generic subroutine to update BG column
; in:
; d7 = BG cam ID
; ---------------------------------------------------------------------------

DrawColumnBG_Generic:
		moveq	#((224+16+16)/16)-1,d6		; screen height + 1 column forwards + 1 backwards

.loop		GetCamAddr				; get cam and xpos to use
		cmp.w	d0,d7				; is currently got camera the same we intend to use?
		bne.s	.next				; if not, branch

		and.w	Screen_Y_wrap_value.w,d5	; keep within vertical limits
		jsr	GetBlock(pc)			; get block to draw at this location
		CalcVRAMPos				; calculate VRAM address to position the block
		jsr	DrawBlock(pc)			; draw the found block
.next		addi.w	#$10,d5				; increment ypos (next block down)
		dbf	d6,.loop			; repeat
		rts
; ---------------------------------------------------------------------------
; Generic subroutine to update a column
; ---------------------------------------------------------------------------

DrawColumn_Generic:
		moveq	#((224+16+16)/16)-1,d6		; screen height + 1 column forwards + 1 backwards

.loop		and.w	Screen_Y_wrap_value.w,d5	; keep within vertical limits
		jsr	GetBlock(pc)			; get block to draw at this location
		CalcVRAMPos				; calculate VRAM address to position the block
		jsr	DrawBlock(pc)			; draw the found block
		addi.w	#$10,d5				; increment ypos (next block down)
		dbf	d6,.loop			; repeat
		rts
; ---------------------------------------------------------------------------
; subroutine to redraw a plane from bottom to top, row per frame
; in:
; d3 = base y-pos of background
; d4 = base x-pos of background
; d6 = number of tiles to load
; d7 = BG cam ID
; ---------------------------------------------------------------------------

DrawPlane_SlowFromBottom:
		moveq	#((320+16+16)/16)-1,d6		; screen width + 1 column forwards + 1 backwards

DrawPlane_SlowFromBottom2:
		and.w	#$FF0,d3
		move.w	DrawPlane_Position.w,d5
		cmp.w	d3,d5
		blo.s	.nodraw

		move.w	d3,d0
		addi.w	#$F0,d0
		and.w	#$FF0,d0
		cmp.w	d0,d5
		bhi.s	.nodraw
		bsr.s	DrawRow_Generic2

.nodraw
		subi.w	#$10,DrawPlane_Position.w
		subq.w	#1,DrawPlane_Count.w
		rts
; ---------------------------------------------------------------------------
; Generic subroutine to draw BG row
; in:
; d7 = BG cam ID
; ---------------------------------------------------------------------------

DrawRowBG_Generic:
		GetCamAddr				; get cam and xpos to use
		cmp.w	d0,d7				; is currently got camera the same we intend to use?
		beq.s	DrawRow_Generic2		; if yes, branch
		rts					; if not, don't draw block
; ---------------------------------------------------------------------------
; Generic subroutine to draw a row
; ---------------------------------------------------------------------------

DrawRow_Generic:
		moveq	#((320+16+16)/16)-1,d6		; screen width + 1 column forwards + 1 backwards

DrawRow_Generic2:
		and.w	Screen_Y_wrap_value.w,d5	; keep within vertical limits

.loop		jsr	GetBlock(pc)			; get block to draw at this location
		CalcVRAMPos				; calculate VRAM address to position the block
		jsr	DrawBlock(pc)			; draw the found block
		addi.w	#$10,d4				; increment xpos (next block right)
		dbf	d6,.loop			; repeat
		rts
; ---------------------------------------------------------------------------
; Subroutine to find a Block's ID within level layout
; in:
; d4 = "current" xpos
; d5 = "current" ypos
; a2 = level layout ptr addr prefix
; ---------------------------------------------------------------------------

GetBlock:
		lea	8(a4),a0			; get layout addr and skip header

		move.w	d4,d0				; get current xpos
		move.w	d5,d1				; get current ypos
; ---------------------------------------------------------------------------
; Finds Chunk ID from given layout file
; ---------------------------------------------------------------------------

GetChunkID	lsr.w	#5,d1				; divide ypos by 4 (ex: $80 -> $04)
		andi.w	#$FFFC,d1
		add.w	a2,d1				; add ptr address prefix
		move.w	(a0,d1.w),d1			; get proper chunks "row map" address
		andi.w	#$7FFF,d1			; keep in proper range
		lsr.w	#7,d0				; divide xpos by 128 (ex $80 -> $01)
		add.w	d0,d1				; add it to row map address

		moveq	#-1,d0				; prepare $FFFFFFFF
		move.b	(a4,d1.w),d0			; collect proper chunk ID
; ---------------------------------------------------------------------------
; Finds Block ID from given Chunk ID
; ---------------------------------------------------------------------------

GetBlockID	andi.w	#$FF,d0				; clear unnecessary bits
		lsl.w	#7,d0				; multiply ID by $80 (size of chunk)

		move.w	d4,d1				; get current xpos
		lsr.w	#3,d1				; divide by 8 (ex $10 -> $02)
		andi.w	#$E,d1				; keep/wrap inside chunk's x range
		add.w	d1,d0				; add to in-chunk address

		move.w	d5,d1				; get current ypos
		andi.w	#$70,d1				; keep/wrap inside chunk's y range
		add.w	d1,d0				; add to in-chunk address

		movea.l	d0,a0				; copy final address to register
		move.w	(a0),d0				; collect proper block ID
		rts
; ---------------------------------------------------------------------------
; Generic subroutine to update FG tilemap
; ---------------------------------------------------------------------------

ScrollDrawFG_Generic:
		jsr	InitFGCam(pc)

ScrollDrawFG_Generic2:
		lea	ScrollFG.w,a5			; Get scroll flags

ScrollDraw_Normal:
CheckScrollFG:
		move.l	(a5),d0
		add.l	4(a5),d0
		beq.w	ScrollDraw_NoScroll		; if no scroll flags were set, quit

.ChkScrollUp
-		tst.b	(a5)				; level scrolls up? / any rows left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		add.w	d0,d5				; shift the ypos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawRow_Generic(pc)		; draw from top
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollDown
-		tst.b	(a5)				; level scrolls down? / any rows left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		sub.w	d0,d5				; shift the ypos
		addi.w	#224,d5				; fix ypos
		jsr	DrawRow_Generic(pc)		; draw from bottom
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollLeft
-		tst.b	(a5)				; level scrolls left? / any columns left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		add.w	d0,d4				; shift the xpos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawColumn_Generic(pc)		; draw from left
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollRight
-		tst.b	(a5)				; level scrolls left? / any columns left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		sub.w	d0,d4				; shift the xpos
		addi.w	#320,d4				; fix xpos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawColumn_Generic(pc)		; draw from right
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+

ScrollDraw_NoScroll:
		rts
; ---------------------------------------------------------------------------
; Simplistic subroutine to update BG tilemap
; ---------------------------------------------------------------------------

ScrollDrawBG_Simple:	; 1-camera bg map updating
		jsr	InitBGCam(pc)

ScrollDrawBG_Simple2:
		lea	ScrollBG1.w,a5			; Get scroll flags
		jmp	ScrollDraw_Normal(pc)		; ++ to-do: this one was a .s branch, fix that, ew
; ---------------------------------------------------------------------------
; Generic subroutine to update BG tilemap
; in:
; a1 = Cameras array
; ---------------------------------------------------------------------------

ScrollDrawBG_Generic:
		jsr	InitBGCam(pc)
		moveq	#((320+16+16)/16)-1,d6		; screen width + 1 column forwards + 1 backwards

ScrollDrawBG_Generic2:
		bsr.s	.DrawBG0
		bsr.s	.DrawBG1
		bsr.s	.DrawBG2
;		bra.s	.DrawBG3

.DrawBG3	moveq	#$03,d7				; set cam ID
		lea	ScrollBG3.w,a5			; Get scroll flags
		lea	CamXBG3.w,a3			; Get cam position
		bra.s	CheckScrollBG

.DrawBG2	moveq	#$02,d7				; set cam ID
		lea	ScrollBG2.w,a5			; Get scroll flags
		lea	CamXBG2.w,a3			; Get cam position
		bra.s	CheckScrollBG

.DrawBG1	moveq	#$01,d7				; set cam ID
		lea	ScrollBG1.w,a5			; Get scroll flags
		lea	CamXBG.w,a3			; Get cam position
		bra.s	CheckScrollBG

.DrawBG0	moveq	#$00,d7				; set cam ID
		lea	ScrollBG1.w,a5			; Get scroll flags
		lea	NullCam.w,a3			; Get cam position

; in:
; d7 = BG cam ID
CheckScrollBG:
		move.l	(a5),d0
		add.l	4(a5),d0
		beq.s	ScrollDraw_NoScroll		; if no scroll flags were set, quit
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos

.ChkScrollUp
-		tst.b	(a5)				; level scrolls up? / any rows left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		add.w	d0,d5				; shift the ypos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawRowBG_Generic(pc)		; draw from top
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollDown
-		tst.b	(a5)				; level scrolls down? / any rows left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		sub.w	d0,d5				; shift the ypos
		addi.w	#224,d5				; fix ypos
		jsr	DrawRowBG_Generic(pc)		; draw from bottom
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollLeft
-		tst.b	(a5)				; level scrolls left? / any columns left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		add.w	d0,d4				; shift the xpos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawColumnBG_Generic(pc)	; draw from left
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollRight
-		tst.b	(a5)				; level scrolls left? / any columns left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		sub.w	d0,d4				; shift the xpos
		addi.w	#320,d4				; fix xpos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawColumnBG_Generic(pc)	; draw from right
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+

.NoScroll	rts


; ---------------------------------------------------------------------------
; Generic subroutine to update BG tilemap
; Full plane width, 1 cam
; ---------------------------------------------------------------------------

ScrollDrawBG_SimpleFull:
		jsr	InitBGCam(pc)
		moveq	#((512)/16)-1,d6		; screen width + 1 column forwards + 1 backwards

.DrawBG1	moveq	#$01,d7				; set cam ID
		lea	ScrollBG1.w,a5			; Get scroll flags
		lea	CamXBG.w,a3			; Get cam position

		move.l	(a5),d0
		add.l	4(a5),d0
		beq.w	ScrollDraw_NoScroll		; if no scroll flags were set, quit
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos

.ChkScrollUp
-		tst.b	(a5)				; level scrolls up? / any rows left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		add.w	d0,d5				; shift the ypos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawRow_Generic2(pc)		; draw from top
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollDown
-		tst.b	(a5)				; level scrolls down? / any rows left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		sub.w	d0,d5				; shift the ypos
		addi.w	#224,d5				; fix ypos
		jsr	DrawRow_Generic2(pc)		; draw from bottom
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollLeft
-		tst.b	(a5)				; level scrolls left? / any columns left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		add.w	d0,d4				; shift the xpos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawColumn_Generic(pc)		; draw from left
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+		lea	2(a5),a5			; advance to next direction flags

.ChkScrollRight
-		tst.b	(a5)				; level scrolls left? / any columns left?
		beq.s	+				; if not, branch
		move.w	(a3),d4				; get cam xpos
		move.w	4(a3),d5			; get cam ypos
		moveq	#0,d0				; clear register
		move.b	1(a5),d0			; get shift amount
		sub.w	d0,d4				; shift the xpos
		addi.w	#320,d4				; fix xpos
		subi.w	#16,d5				; fix ypos ; begin 1 more above top (VDP workaround)
		jsr	DrawColumn_Generic(pc)		; draw from right
		subq.b	#1,(a5)				; decrease direction counter
		addi.b	#$10,1(a5)			; shift next position
		bra.s	-				; loop
+

.NoScroll	rts

; ---------------------------------------------------------------------------
; Draws a 16x16 px (2x2 tiles) block
; in:
; d0 = block ID	; TheBlad768: Now load uncompressed blocks.
; d3 = VRAM address (high 16 bits from VRAM WRITE comm)
; ---------------------------------------------------------------------------

DrawBlock:
	; each 2x2 tiles block is 8 bytes long, arranged left to right
	; same format as VDP tiles
		move.w	d3,(a6)+		; save VRAM address to VInt array
		movea.l	Block_table_addr_ROM.w,a0		; load blocks array
		move.w	d0,d1			; backup 16x16 ref
		andi.w	#%0000001111111111,d0	; filter Block ID bits
		lsl.w	#3,d0			; multiply block ID by 8
		lea	(a0,d0.w),a0		; jump to specified block's data

		andi.w	#%0000110000000000,d1	; filter X/Y flip bits
		lsl.w	#4,d1			; move to high bits
		beq.s	.dbnormal		; if both bits zero, branch
		bmi.s	.chkYflip		; if Y bit set, branch
						; if not, we know only X bit is set
; ---------------------------------------------------------------------------
.dbXflip	move.l	(a0)+,d0		; get 2 tiles from Top
		swap	d0			; exchange their positions
		eori.l	#$08000800,d0		; X-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array
		move.l	(a0)+,d0		; get 2 tiles from Bottom
		swap	d0			; exchange their positions
		eori.l	#$08000800,d0		; X-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.chkYflip	andi.w	#%0100000000000000,d1	; filter X flip bit
		bne.s	.dbXYflip		; if also set, branch
; ---------------------------------------------------------------------------
.dbYflip	move.l	4(a0),d0		; get 2 tiles from Bottom
		eori.l	#$10001000,d0		; Y-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array
		move.l	(a0),d0			; get 2 tiles from Top
		eori.l	#$10001000,d0		; Y-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.dbXYflip	move.l	4(a0),d0		; get 2 tiles from Bottom
		swap	d0			; exchange their positions
		eori.l	#$18001800,d0		; XY-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array
		move.l	(a0),d0			; get 2 tiles from Top
		swap	d0			; exchange their positions
		eori.l	#$18001800,d0		; XY-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.dbnormal	move.l	(a0)+,(a6)+		; directly save tile data to VInt array
		move.l	(a0)+,(a6)+		; directly save tile data to VInt array
		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
; Draws a 16x8 px (2x1 tiles) block
; in:
; d0 = block ID	; TheBlad768: Now load uncompressed blocks.
; d3 = VRAM address (high 16 bits from VRAM WRITE comm)
; d5 = "current" ypos
; ---------------------------------------------------------------------------

DrawHalfBlock:
		move.w	d5,d1
		andi.w	#$7FF8,d1
		andi.b	#8,d1
		bne.s	DHB_bottom

DHB_top:
DrawBlock_2P:
		move.w	d3,(a6)+		; save VRAM address to VInt array
		movea.l	Block_table_addr_ROM.w,a0		; load blocks array
		move.w	d0,d1			; backup 16x16 ref

		andi.w	#%0000001111111111,d0	; filter Block ID bits
		lsl.w	#3,d0			; multiply block ID by 8
		lea	(a0,d0.w),a0		; jump to specified block's data

		andi.w	#%0000110000000000,d1	; filter X/Y flip bits
		lsl.w	#4,d1			; move to high bits
		beq.s	.dbnormal		; if both bits zero, branch
		bmi.s	.chkYflip		; if Y bit set, branch
						; if not, we know only X bit is set
; ---------------------------------------------------------------------------
.dbXflip	move.l	(a0)+,d0		; get 2 tiles from Top
		swap	d0			; exchange their positions
		eori.l	#$08000800,d0		; X-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.chkYflip	andi.w	#%0100000000000000,d1	; filter X flip bit
		bne.s	.dbXYflip		; if also set, branch
; ---------------------------------------------------------------------------
.dbYflip	; to-do: fix 2p support? perhaps split _2P separately?
		move.l	4(a0),d0		; get 2 tiles from Bottom
		eori.l	#$10001000,d0		; Y-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.dbXYflip	move.l	4(a0),d0		; get 2 tiles from Bottom
		swap	d0			; exchange their positions
		eori.l	#$18001800,d0		; XY-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.dbnormal	move.l	(a0)+,(a6)+		; directly save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------

DHB_bottom:
		addi.w	#$80,d3			; display at next, odd tile row
		move.w	d3,(a6)+		; save VRAM address to VInt array
		movea.l	Block_table_addr_ROM.w,a0		; load blocks array
		move.w	d0,d1			; backup 16x16 ref

		andi.w	#%0000001111111111,d0	; filter Block ID bits
		lsl.w	#3,d0			; multiply block ID by 8
		lea	(a0,d0.w),a0		; jump to specified block's data

		andi.w	#%0000110000000000,d1	; filter X/Y flip bits
		lsl.w	#4,d1			; move to high bits
		beq.s	.dbnormal		; if both bits zero, branch
		bmi.s	.chkYflip		; if Y bit set, branch
						; if not, we know only X bit is set
; ---------------------------------------------------------------------------
.dbXflip	move.l	4(a0),d0		; get 2 tiles from Bottom
		swap	d0			; exchange their positions
		eori.l	#$08000800,d0		; X-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.chkYflip	andi.w	#%0100000000000000,d1	; filter X flip bit
		bne.s	.dbXYflip		; if also set, branch
; ---------------------------------------------------------------------------
.dbYflip	move.l	(a0),d0			; get 2 tiles from Top
		eori.l	#$10001000,d0		; Y-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.dbXYflip	move.l	(a0),d0			; get 2 tiles from Top
		swap	d0			; exchange their positions
		eori.l	#$18001800,d0		; XY-flip the tiles
		move.l	d0,(a6)+		; save tile data to VInt array

		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
.dbnormal	move.l	4(a0),(a6)+		; directly save tile data to VInt array
		clr.w	(a6)			; save tail to VInt array
		rts
; ---------------------------------------------------------------------------
; Subroutine to	upload buffered tiles to VRAM when VInt is triggered
; ---------------------------------------------------------------------------

ScrollDraw_VInt:
		lea	vdp_control_port,a5	; get VDP control port address
		lea	vdp_data_port,a6	; get VDP data port address
		lea	PlaneBuf.w,a0		; get VInt plane write array
		moveq	#3,d0			; the low bits for VRAM WRITE comm
		bra.s	.chk

.loop	disableInts
		move.w	d3,(a5)			; set VRAM WRITE at saved address
		move.w	d0,(a5)			; ... and send the remaining bits
		move.l	(a0)+,(a6)		; send top of block to VRAM
		addi.w	#$80,d3			; set VRAM WRITE to next row
		move.w	d3,(a5)			; set VRAM WRITE at new address
		move.w	d0,(a5)			; ... and send the remaining bits
		move.l	(a0)+,(a6)		; send bottom of block to VRAM
	enableInts
.chk		move.w	(a0)+,d3		; get VRAM address
		bne.s	.loop			; if we're not done (didn't get Tail), loop

.rts		clr.w	PlaneBuf.w		; set new tail at beginning
		rts
; ---------------------------------------------------------------------------
; Subroutine to	upload buffered tiles to VRAM when VInt is triggered
; ---------------------------------------------------------------------------

ScrollHalfDraw_Vint:
		lea	vdp_control_port,a5	; get VDP control port address
		lea	vdp_data_port,a6	; get VDP data port address
		lea	PlaneBuf.w,a0		; get VInt plane write array
		moveq	#3,d0			; the low bits for VRAM WRITE comm
		bra.s	.chk

.loop	disableInts
		move.w	d3,(a5)			; set VRAM WRITE at saved address
		move.w	d0,(a5)			; ... and send the remaining bits
		move.l	(a0)+,(a6)		; send top of block to VRAM
	enableInts
.chk		move.w	(a0)+,d3		; get VRAM address
		bne.s	.loop			; if we're not done (didn't get Tail), loop

.rts		clr.w	PlaneBuf.w		; set new tail at beginning
		rts
; ---------------------------------------------------------------------------
; CPU REGISTERS USAGE TABLE
; ---------------------------------------------------------------------------
;MAIN
; A3:		CAMERA
; A4:		LAYOUT
; CHUNKS.L:	CHUNKS
; Block_table_addr_ROM.w:	BLOCKS
; D2:		"MASTER" BASE VRAM
; D3:		"CURRENT" VRAM ADDR
; A2:		LAYOUT FILE BASE
; (a3): 	"CAM" XPOS
; 4(a3):	"CAM" YPOS
; D4:		"CURRENT" XPOS (to draw)
; D5:		"CURRENT" YPOS (to draw)
; D6:		"LOCAL" LOOP
; D7:		"MASTER" LOOP
; ---------------------------------------------------------------------------
;LOCALS
; D0, D1
; A0, A1, A5
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Reset_TileOffsetPositionActual:
		move.w	(Camera_X_pos_copy).w,d0
		move.w	d0,d1
		andi.w	#-$10,d0
		move.w	d0,(Camera_X_pos_rounded).w
		move.w	(Camera_Y_pos_copy).w,d0
		and.w	(Camera_Y_pos_mask).w,d0
		move.w	d0,(Camera_Y_pos_rounded).w
		rts
; End of function Reset_TileOffsetPositionActual

; =============== S U B R O U T I N E =======================================

Reset_TileOffsetPositionEff:
		move.w	(Camera_X_pos_BG_copy).w,d0
		move.w	d0,d1
		andi.w	#-$10,d0
		move.w	d0,d2
		move.w	d0,(Camera_X_pos_BG_rounded).w
		move.w	(Camera_Y_pos_BG_copy).w,d0
		and.w	(Camera_Y_pos_mask).w,d0
		move.w	d0,(Camera_Y_pos_BG_rounded).w
		rts
; End of function Reset_TileOffsetPositionEff

; =============== S U B R O U T I N E =======================================

Clear_Switches:
		clearRAM Level_trigger_array, v_oscillate_end

locret_4EE9C:
		rts
; End of function Clear_Switches

; =============== S U B R O U T I N E =======================================

Restart_LevelData:
		clr.b	(BackgroundEvent_routine).w
		clr.b	(Dynamic_resize_routine).w
		clr.b	(Object_load_routine).w
		clr.b	(Rings_manager_routine).w
		clr.b	(Boss_flag).w
		bsr.w	LoadLevelPointer
		bsr.s	Clear_Switches
		bsr.w	Load_Level
		bsr.w	Load_Solids
		jmp	CheckLevelForWater
; End of function Restart_LevelData

; =============== S U B R O U T I N E =======================================

Reset_ObjectsPosition3:
		bsr.s	Reset_ObjectsPosition2
		move.w	(Camera_X_pos).w,(Camera_min_X_pos).w
		move.w	(Camera_X_pos).w,(Camera_max_X_pos).w
		move.w	(Camera_Y_pos).w,(Camera_min_Y_pos).w
		move.w	(Camera_Y_pos).w,(Camera_max_Y_pos).w
		rts

Reset_ObjectsPosition2:
		sub.w	d1,(Player_1+y_pos).w
		sub.w	d0,(Player_1+x_pos).w
		sub.w	d0,(Camera_X_pos).w
		sub.w	d1,(Camera_Y_pos).w
		sub.w	d0,(Camera_X_pos_copy).w
		sub.w	d1,(Camera_Y_pos_copy).w
		move.w	(Camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
		bra.s	Offset_ObjectsDuringTransition

Reset_ObjectsPosition:
		sub.w	d1,(Player_1+y_pos).w
		move.w	(Camera_X_pos).w,d0
		sub.w	d0,(Player_1+x_pos).w
		sub.w	d0,(Camera_X_pos).w
		sub.w	d1,(Camera_Y_pos).w
		sub.w	d0,(Camera_X_pos_copy).w
		sub.w	d1,(Camera_Y_pos_copy).w
		sub.w	d0,(Camera_min_X_pos).w
		sub.w	d0,(Camera_max_X_pos).w
		sub.w	d1,(Camera_min_Y_pos).w
		sub.w	d1,(Camera_max_Y_pos).w
		move.w	(Camera_max_Y_pos).w,(Camera_target_max_Y_pos).w
; End of function Reset_ObjectsPosition

; =============== S U B R O U T I N E =======================================

Offset_ObjectsDuringTransition:
		lea	(Dynamic_object_RAM+next_object).w,a1
		moveq	#((Dynamic_object_RAM_End-Dynamic_object_RAM)/object_size)-1,d2

-		tst.l	address(a1)
		beq.s	+
		btst	#2,render_flags(a1)
		beq.s	+
		sub.w	d0,x_pos(a1)
		sub.w	d1,y_pos(a1)
+		lea	next_object(a1),a1
		dbf	d2,-
		rts
; End of function Offset_ObjectsDuringTransition

; =============== S U B R O U T I N E =======================================

Change_ActSizes:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#3,d0
		lea	(LevelSizes).l,a1
		lea	(a1,d0.w),a1
		move.l	(a1)+,d0
		move.l	d0,(Camera_min_X_pos).w
		move.l	d0,(Camera_target_min_X_pos).w
		move.l	(a1)+,d0
		move.l	d0,(Camera_min_Y_pos).w
		move.l	d0,(Camera_target_min_Y_pos).w
		rts
; End of function Change_ActSizes

; =============== S U B R O U T I N E =======================================

LoadLevelLoadBlock:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	(LevelLoadBlock).l,a2
		lea	(a2,d0.w),a2
		move.l	(a2)+,d0
		andi.l	#$FFFFFF,d0
		movea.l	d0,a1
		move.w	#0,d2
		jsr	(Queue_Kos_Module).w

-		move.b	#VintID_TitleCard,(V_int_routine).w
		jsr	(Process_Kos_Queue).w
		bsr.w	Wait_VSync
		jsr	(Process_Kos_Module_Queue).w
		tst.w	(Kos_modules_left).w
		bne.s	-
		rts
; End of function LoadLevelLoadBlock

; =============== S U B R O U T I N E =======================================

LoadLevelLoadBlock2:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	(LevelLoadBlock).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.w	#4,a2
		move.l	(a2)+,(Block_table_addr_ROM).w
		movea.l	(a2)+,a0
		lea	(RAM_start).l,a1
		jsr	(Kos_Decomp).w
		bsr.s	Load_Level
		jsr	(LoadPLC_KosM).w
		movea.l	(sp)+,a2
		moveq	#0,d0
		move.b	(a2),d0

		; FDZ2(3) pal fix
		cmpi.w	#2,(Current_zone_and_act).w
		bne.s	.load

		; check rain
		tst.b	(Last_star_post_hit).w
		beq.s	.load
		moveq	#palid_FDZ3Rain,d0		; set rain palette

.load
		jmp	(LoadPalette).w
; End of function LoadLevelLoadBlock2

; =============== S U B R O U T I N E =======================================

Load_Level:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#4,d0
		lea	(LevelPtrs).l,a0

		tst.b (Extended_mode).w
		beq.s .skip
		lea	(LevelPtrs2).l,a0

.skip:
		movea.l	(a0,d0.w),a0

Load_Level2:
		move.l	a0,(Level_layout_addr_ROM).w
		addq.l	#8,a0
		move.l	a0,(Level_layout2_addr_ROM).w
		rts
; End of function Load_Level

; =============== S U B R O U T I N E =======================================

LoadLevelPointer:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#3,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d0,d0
		add.w	d1,d0
		lea	(LevelLoadPointer).l,a2
		lea	(a2,d0.w),a2
		lea	(Level_Data_addr_RAM).w,a3

	rept	(Level_data_addr_RAM_End-Level_data_addr_RAM)/4
		move.l	(a2)+,(a3)+
	endm
		rts
; ---------------------------------------------------------------------------
; Collision index pointer loading subroutine
; Uses Sonic & Knuckles format mapping
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Load_Solids:
		moveq	#0,d0
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#4,d0
		lea	(SolidIndexes).l,a0
		movea.l	(a0,d0.w),a0

Load_Solids2:
		move.l	a0,(Primary_collision_addr).w
		move.l	a0,(Collision_addr).w
		addq.l	#1,a0
		move.l	a0,(Secondary_collision_addr).w
		rts
; End of function Load_Solids


; ===========================================================================

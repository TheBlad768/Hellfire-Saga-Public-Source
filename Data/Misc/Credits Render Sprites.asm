; ===========================================================================
; ---------------------------------------------------------------------------
; Sprite line rendering for Credits
; ---------------------------------------------------------------------------

Render_SpriteLine:
		cmpi.b	#$04,(Current_zone).w			; is this the credits?
		bne.s	.NoLine					; if not, don't render anything
		tst.b	(CreditsLine).w				; is there a line change effect occuring?
		beq.s	.NoLine					; if not, skip line sprites
		move.w	(CreditsLine_Amount).w,d0		; load line amount/position
		ble.s	.NoLine					; if 0 or invalid negative, skip
		cmpi.w	#(CreditsLineRender_End-CreditsLineRender)/$20,d0	; is it fully rendered?
		bhs.s	.NoLine					; if so, skip rendering too

		andi.w	#$03F8,d0				; snap to nearest tile

		move.l	#$0200|(($E000|(VRAM_CreditsSprites/$20))<<$10),d1 ; prepare base index and starting X position
		sub.w	d0,d1					; reduce X position to correct place on-screen

		moveq	#$07,d2					; get X precise pixel position
		and.w	(Camera_X_pos).w,d2			; ''
		sub.w	d2,d1					; apply to sprite X position
		add.w	#$0080-8,d1				; account for void space (and remove 8 as plane is -8 due to left column, where scroll might not be multiple of 8)

		moveq	#$07,d2					; get Y precise pixel position
		and.w	(Camera_Y_pos).w,d2			; ''
		neg.w	d2					; ''
		addi.w	#$0080,d2				; account for void space

		moveq	#$04,d4					; prepare shape
		move.l	#$00000008,d3				; prepare pattern add and X/Y add

		move.w	#$0200-1,d5				; prepare range check

		moveq	#(224/8),d6				; number of pieces to render

		move.w	d1,d0					; is X in range yet?
		bne.s	.NoCounterOver				; if the first one isn't exactly 0, branch
		addi.l	#$00010000,d1				; counter the overflow correction below (this one rare instance doesn't overflow from 0, only -1 and below)

	.NoCounterOver:
		subq.w	#$01,d0					; ''
		cmp.w	d5,d0					; ''
		blo.s	.LookForEnd				; if so, start rendering but check if it goes out of range
		add.w	d3,d2					; advance Y
		add.l	d3,d1					; advance pattern and X
		dbf	d6,.FindPiece				; repeat for all slots

	.NoLine:
		rts						; return

	.FindPiece:
		move.w	d1,d0					; is X in range yet?
		subq.w	#$01,d0					; ''
		cmp.w	d5,d0					; ''
		blo.s	.Found					; if so, start rendering (No need to check for end, won't make it off the screen)
		add.w	d3,d2					; advance Y
		add.l	d3,d1					; advance pattern and X
		dbf	d6,.FindPiece				; repeat for all slots
		rts						; return

	.Found:
		subi.l	#$00010000,d1				; minus 1 (due to overflow of X from minus to positive, increasing the pattern index by 1)

	.FoundNext:
		subq.w	#$01,d7					; decrease sprite counter
		move.w	d2,(a6)+				; save Y
		move.b	d4,(a6)+				; save shape
		addq.w	#$01,a6					; skip link
		move.l	d1,(a6)+				; save pattern and X
		add.w	d3,d2					; advance Y
		add.l	d3,d1					; advance X
		dbf	d6,.FoundNext				; render remaining pieces
		rts						; return

	.LookForEnd:
		subq.w	#$01,d7					; decrease sprite counter
		move.w	d2,(a6)+				; save Y
		move.b	d4,(a6)+				; save shape
		addq.w	#$01,a6					; skip link
		move.l	d1,(a6)+				; save pattern and X
		add.w	d3,d2					; advance Y
		add.l	d3,d1					; advance X
		move.w	d1,d0					; is X in range yet?
		subq.w	#$01,d0					; ''
		cmp.w	d5,d0					; ''
		bhs.s	.NoLine					; if not, end has been found, no more rendering
		dbf	d6,.LookForEnd				; repeat for all slots
		rts						; return

; ===========================================================================
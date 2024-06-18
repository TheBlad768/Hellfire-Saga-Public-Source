
; =============== S U B R O U T I N E =======================================

Obj_ForegroundPlant:
		move.l	#Map_FGPlant,mappings(a0)
		ori.b	#4,render_flags(a0)
		move.w	x_pos(a0),$30(a0)
		move.w	y_pos(a0),$32(a0)
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	word_2C242(pc,d0.w),a1
		move.w	(a1)+,art_tile(a0)
		move.w	(a1)+,priority(a0)
		move.b	(a1)+,width_pixels(a0)
		move.b	(a1)+,height_pixels(a0)
		move.b	subtype(a0),d0
		lsr.w	#2,d0
		andi.w	#$3C,d0
		move.l	off_2C24E(pc,d0.w),address(a0)
		rts
; ---------------------------------------------------------------------------

word_2C242:
; 0
		dc.w $C000		; VRAM
		dc.w $80			; Priority
		dc.b 32/2		; Width
		dc.b 256/2		; Height
; 1
		dc.w $C000		; VRAM
		dc.w $80			; Priority
		dc.b 32/2		; Width
		dc.b 256/2		; Height
; 2
		dc.w $C000		; VRAM
		dc.w $80			; Priority
		dc.b 32/2		; Width
		dc.b 256/2		; Height
; 3
		dc.w $C000		; VRAM
		dc.w $80			; Priority
		dc.b 56/2		; Width
		dc.b 256/2		; Height
; 4
		dc.w $C000		; VRAM
		dc.w $80			; Priority
		dc.b 32/2		; Width
		dc.b 256/2		; Height
; 5
		dc.w $C000		; VRAM
		dc.w $80			; Priority
		dc.b 32/2		; Width
		dc.b 256/2		; Height
off_2C24E:
		dc.l loc_2C26A
		dc.l loc_2C270
		dc.l loc_2C2A6
		dc.l loc_2C2DC
		dc.l loc_2C312
		dc.l loc_2C348
		dc.l loc_2C37A
; ---------------------------------------------------------------------------

loc_2C26A:
		jsr	ObjFGP_MakeMappings
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

loc_2C270:
		move.w	$30(a0),d1
		move.w	d1,d2
		subi.w	#$A0,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#4,d1
		add.w	d2,d1
		move.w	d1,$10(a0)
		move.w	$32(a0),d1
		move.w	d1,d2
		subi.w	#$70,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#4,d1
		add.w	d2,d1
		move.w	d1,$14(a0)
		jsr	ObjFGP_MakeMappings
		move.w	$30(a0),d0
		jsr	(Sprite_OnScreen_Test2).w
		jmp	ObjFGP_DeleteMappings
; ---------------------------------------------------------------------------

loc_2C2A6:
		move.w	$30(a0),d1
		move.w	d1,d2
		subi.w	#$A0,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#3,d1
		add.w	d2,d1
		move.w	d1,$10(a0)
		move.w	$32(a0),d1
		move.w	d1,d2
		subi.w	#$70,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#3,d1
		add.w	d2,d1
		move.w	d1,$14(a0)
		jsr	ObjFGP_MakeMappings
		move.w	$30(a0),d0
		jsr	(Sprite_OnScreen_Test2).w
		jmp	ObjFGP_DeleteMappings
; ---------------------------------------------------------------------------

loc_2C2DC:
		move.w	$30(a0),d1
		move.w	d1,d2
		subi.w	#$A0,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#2,d1
		add.w	d2,d1
		move.w	d1,$10(a0)
		move.w	$32(a0),d1
		move.w	d1,d2
		subi.w	#$70,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#2,d1
		add.w	d2,d1
		move.w	d1,$14(a0)
		jsr	ObjFGP_MakeMappings
		move.w	$30(a0),d0
		jsr	(Sprite_OnScreen_Test2).w
		jmp	ObjFGP_DeleteMappings
; ---------------------------------------------------------------------------

loc_2C312:
		move.w	$30(a0),d1
		move.w	d1,d2
		subi.w	#$A0,d1
		sub.w	(Camera_X_pos).w,d1
		asr.w	#1,d1
		add.w	d2,d1
		move.w	d1,$10(a0)
		move.w	$32(a0),d1
		move.w	d1,d2
		subi.w	#$70,d1
		sub.w	(Camera_Y_pos).w,d1
		asr.w	#1,d1
		add.w	d2,d1
		move.w	d1,$14(a0)
		jsr	ObjFGP_MakeMappings
		move.w	$30(a0),d0
		jsr	(Sprite_OnScreen_Test2).w
		jmp	ObjFGP_DeleteMappings
; ---------------------------------------------------------------------------

loc_2C348:
		move.w	$30(a0),d1
		move.w	d1,d2
		subi.w	#$A0,d1
		sub.w	(Camera_X_pos).w,d1
		add.w	d2,d1
		move.w	d1,$10(a0)
		move.w	$32(a0),d1
		move.w	d1,d2
		subi.w	#$70,d1
		sub.w	(Camera_Y_pos).w,d1
		add.w	d2,d1
		move.w	d1,$14(a0)
		jsr	ObjFGP_MakeMappings
		move.w	$30(a0),d0
		jsr	(Sprite_OnScreen_Test2).w
		jmp	ObjFGP_DeleteMappings
; ---------------------------------------------------------------------------

loc_2C37A:
		move.w	$30(a0),d1
		move.w	d1,d2
		subi.w	#$A0,d1
		sub.w	(Camera_X_pos).w,d1
		add.w	d1,d1
		add.w	d2,d1
		move.w	d1,$10(a0)
		move.w	$32(a0),d1
		move.w	d1,d2
		subi.w	#$70,d1
		sub.w	(Camera_Y_pos).w,d1
		add.w	d2,d1
		move.w	d1,$14(a0)
		jsr	ObjFGP_MakeMappings
		move.w	$30(a0),d0
		jsr	(Sprite_OnScreen_Test2).w
		jmp	ObjFGP_DeleteMappings
; ---------------------------------------------------------------------------

		include "Objects/Foreground Plant/Object data/Map - Foreground Plant.asm"

; ---------------------------------------------------------------------------
; Subroutine to make the mappings for the forground plant object in realtime
; depending on its position relative to the screen - MarkeyJester
; ---------------------------------------------------------------------------
; These will be inside "Variables.asm" so it's close to the allocation of the RAM itself...
; OBJFGP_FAST OBJFGP_SLOTS OBJFGP_SIZE
; ---------------------------------------------------------------------------

ObjFGP_MakeMappings:
		tst.b	render_flags(a0)				; is the object on-screen?
		bpl.s	.OffScreen					; if not, don't bother

	; --- Finding relevant slot ---

		lea	(Map_PlantFG).w,a2				; load FG mappings list
		moveq	#((OBJFGP_SLOTS*4)*2)-2,d5			; set starting address of mappings
		move.w	#OBJFGP_SIZE-4,d1				; size of each mappings data address
		moveq	#OBJFGP_SLOTS-1,d6				; number of slots to check

	.NextFull:
		move.w	(a2),d0						; load slot
		beq.s	.Empty						; if it's empty, branch to keep track of it
		cmp.w	a0,d0						; does this slot already belong to this object?
		beq.s	.Found						; if so, branch and use it...
		addq.w	#$04,a2						; advance to next slot
		add.w	d1,d5						; advance to next mapping slot
		dbf	d6,.NextFull					; repeat until all slots are checked

	.OffScreen:
		rts							; return (doesn't exist and there's no space)

	.Empty:
		lea	(a2),a3						; store this slot as an empty slot
		addq.w	#$04,a2						; advance to next slot
		dbf	d6,.NextEmpty					; repeat until all slots are checked
		bra.s	.New						; use the empty slot which was stored in a3

	.NextEmpty:
		cmpa.w	(a2),a0						; does this slot already belong to this object?
		beq.s	.Found						; if so, branch/use it...
		addq.w	#$04,a2						; advance to next slot
		dbf	d6,.NextEmpty					; repeat until all slots are checked

	.New:
		lea	(a3),a2						; use first empty slot
		move.w	a0,(a3)+					; store this object's RAM address
		move.w	d5,(a3)						; store mapping list address

		moveq	#$00,d0						; load mapping frame
		move.b	mapping_frame(a0),d0				; ''
		add.w	d0,d0						; get word index
		move.l	mappings(a0),a1					; load mappings list address
		adda.w	(a1,d0.w),a1					; advance to correct slot
		move.l	a1,OBJFGP_SLOTS*4(a2)				; store source mappings address
		move.l	a3,mappings(a0)					; set as new mappings list address
		sf.b	mapping_frame(a0)				; set to use frame 0

	.Found:

	; --- processing mappings ---

		move.l	OBJFGP_SLOTS*4(a2),a1				; load source mappings list address
		addq.w	#$02,a2						; advancet to mapping pointer
		adda.w	(a2),a2						; advance to destination mappings list address
		lea	(a2),a3						; store address for later
		addq.w	#$02,a2						; advance to mapping data itself

		moveq	#$00,d5						; reset piece count
		move.w	(a1)+,d6					; load number of pieces to process
		beq.s	.Finish						; if there are none, skip
		subq.w	#$01,d6						; minus 1 for dbf counter

	if OBJFGP_FAST=0
		move.w	obY(a0),d3					; load Y position of object
		move.w	#224,d2						; prepare screen height
	else
		moveq	#$20,d3						; load Y position (and account for largest piece height)
		add.w	obY(a0),d3					; ''
		move.w	#224+($20),d1					; prepare screen height (and account for largest piece height)
	endif
		sub.w	(Camera_Y_pos).w,d3				; get relative to the screen

	.NextPiece:
		move.b	(a1),d0						; load Y relative position
		ext.w	d0						; ''
		add.w	d3,d0						; get relative from screen
	if OBJFGP_FAST=0
		moveq	#$03,d1						; load shape (Y axis only)
		and.w	(a1),d1						; ''
		addq.b	#$01,d1						; correct (0 - 3 to 1 - 4)
		lsl.w	#$03,d1						; multiply by x8 (size of tile)
		add.w	d1,d0						; change Y position
		add.w	d2,d1						; add screen height
	endif
		cmp.w	d1,d0						; is the piece off-screen?
		bhs.s	.SkipPiece					; if so, skip
		move.l	(a1)+,(a2)+					; copy mapping piece over
		move.w	(a1)+,(a2)+					; ''
		addq.w	#$01,d5						; increase piece count by 1
		dbf	d6,.NextPiece					; repeat for all pieces

	.Finish:
		move.w	d5,(a3)						; save number of pieces loaded
		rts							; return

	.SkipPiece:
		addq.w	#$06,a1						; advance to next piece
		dbf	d6,.NextPiece					; repeat for all pieces
		move.w	d5,(a3)						; save number of pieces loaded
		rts							; return

; ---------------------------------------------------------------------------
; Subroutine to remove an object from the mapping list
; ---------------------------------------------------------------------------

ObjFGP_DeleteMappings:
		tst.l	address(a0)					; has the object been deleted?
		bne.s	.NoDelete					; if not, skip
		lea	(Map_PlantFG).w,a2				; load FG mappings list
		moveq	#OBJFGP_SLOTS-1,d6				; number of slots to check

	.NextSlot:
		cmpa.w	(a2),a0						; does this slot belong to the object?
		beq.s	.Found						; if so, branch to clear it
		addq.w	#$04,a2						; advance to next slot
		dbf	d6,.NextSlot					; repeat until all slots are checked

	.NoDelete:
		rts							; return

	.Found:
		clr.w	(a2)						; clear slot
		rts							; return

; ===========================================================================




















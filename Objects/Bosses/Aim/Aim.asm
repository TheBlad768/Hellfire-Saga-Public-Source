; ---------------------------------------------------------------------------
; Aim for bosses.
; Version 1.0
; By TheBlad768 (2021).
; ---------------------------------------------------------------------------

; Dynamic object variables
obBA_JumpSubtype		= $30	; .l
obBA_Jump				= $34	; .l
obBA_BTimer			= $3A	; .w
obBA_Xpos				= $42	; .w
obBA_Ypos				= $44	; .w

; =============== S U B R O U T I N E =======================================

Obj_BossAim:
		moveq	#0,d0					; FIXES VRAM
		move.b	subtype(a0),d0
		move.b	d0,d1
		andi.w	#$07,d0					; Art ID
		andi.w	#$70,d1					; Jump ID
		lsr.b	#3,d1
		lea	BossAim_SubtypeIndex(pc),a1
		adda.w	(a1,d1.w),a1
		move.l	a1,obBA_JumpSubtype(a0)
		move.w	art_tile(a0),d2
		andi.w	#$7FF,d2
		lsl.w	#5,d2
		move.l	#ArtUnc_BossAim>>1,d1
		lsl.w	#6,d0
		add.l	d0,d1
		move.w	#$80/2,d3
		jsr	(Add_To_DMA_Queue).w

BossAim_SkipLoadArt:
		move.w	#bytes_to_word(16/2,16/2),height_pixels(a0)		; set height and width
		move.l	#Map_BossAim,mappings(a0)
		move.b	#rfCoord+rfStatic,render_flags(a0)	; set screen coordinates and static flag
		move.w	#$80,priority(a0)
		move.l	#Go_Delete_Sprite,obBA_Jump(a0)
		move.l	#BossAim_BeforeWait,address(a0)
		tst.w	$2E(a0)
		bne.s	BossAim_BeforeWait
		move.w	#3*60,$2E(a0)			; Default Timer

BossAim_BeforeWait:
		subq.w	#1,obBA_BTimer(a0)
		bpl.s	BossAim_CheckParent
		move.l	#BossAim_Draw,address(a0)

BossAim_Draw:
		movea.l	obBA_JumpSubtype(a0),a1
		jsr	(a1)
		jsr	(Obj_Wait).w

		tst.w	Seizure_flag.w			; check if photosensitivity
		bne.s	.draw				; if so, no flicker
		btst	#1,(V_int_run_count+3).w
		bne.s	BossAim_CheckParent

.draw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

BossAim_CheckParent:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

BossAim_SubtypeIndex: offsetTable
		offsetTableEntry.w BossAim_ObjectPosition	; 0
		offsetTableEntry.w BossAim_CameraPosition	; 1
		offsetTableEntry.w BossAim_ScythePosition	; 2

ChildObjDat6_BossAim:
		dc.w 1-1
		dc.l Obj_BossAim

Map_BossAim:
		dc.b $F0			; Ypos
		dc.b 5			; Tile size(5=16x16)
		dc.w 0			; VRAM
		dc.w -8			; Xpos

; =============== S U B R O U T I N E =======================================

BossAim_ObjectPosition:
		movea.w	parent3(a0),a1
		move.w	x_pos(a1),d0
		move.w	obBA_Xpos(a0),d1
		btst	#0,render_flags(a1)
		beq.s	.notxflip
		neg.w	d1

.notxflip
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	y_pos(a1),d0
		add.w	obBA_Ypos(a0),d0
		move.w	d0,y_pos(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossAim_CameraPosition:
		move.w	(Camera_X_pos).w,d0
		add.w	obBA_Xpos(a0),d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		add.w	obBA_Ypos(a0),d0
		move.w	d0,y_pos(a0)

.return
		rts

; =============== S U B R O U T I N E =======================================

BossAim_ScythePosition:
		movea.w	parent3(a0),a1
		move.w	x_pos(a1),d0
		move.w	obBA_Xpos(a0),d1
		btst	#0,render_flags(a1)
		beq.s	.notxflip
		neg.w	d1

.notxflip
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		add.w	obBA_Ypos(a0),d0
		move.w	d0,y_pos(a0)

		; check draw
		move.w	(Water_level).w,d0
		cmp.w	y_pos(a1),d0						; is Scythe above the water?
		blo.s		BossAim_CameraPosition.return	; if yes, branch
		addq.w	#4,sp							; not draw
		jmp	(Child_CheckParent).w

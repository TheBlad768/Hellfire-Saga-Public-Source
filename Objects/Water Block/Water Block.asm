; ---------------------------------------------------------------------------
; Water block from Sonic 1.
; Version 1.0
; By TheBlad768 (2021).
; ---------------------------------------------------------------------------

; Dynamic object variables
obWB_Timer					= $2E	; .w
obWB_PushTimer				= $30	; .w
obWB_SaveStatus				= $32	; .b
; ---------------------------------------------------------------------------

WaterBlock_Data:			; push timer, frame, width, height, unused
		dc.w 2				; 0
		dc.b 0, 32/2, 32/2, 0
		dc.w 1				; 1
		dc.b 1, 64/2, 32/2, 0
		dc.w 8				; 2
		dc.b 2, 96/2, 32/2, 0
		dc.w 12				; 3
		dc.b 3, 128/2, 32/2, 0
		dc.w 2				; 4
		dc.b 4, 64/2, 64/2, 0
		dc.w $7FFF			; 5 (Stop)
		dc.b 0, 32/2, 32/2, 0
		dc.w 1+$8000		; 6 (Water)
		dc.b 2, 96/2, 32/2, 0
	even

; =============== S U B R O U T I N E =======================================

Obj_WaterBlock:
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		add.b	d0,d0
		move.b	d0,d1
		add.b	d0,d0
		add.b	d1,d0
		lea	WaterBlock_Data(pc,d0.w),a1
		move.w	(a1)+,obWB_PushTimer(a0)
		move.b	(a1)+,mapping_frame(a0)
		move.b	(a1)+,d0
		move.b	d0,width_pixels(a0)
		move.b	d0,x_radius(a0)
		move.b	(a1)+,d0
		move.b	d0,height_pixels(a0)
		move.b	d0,y_radius(a0)
		move.l	#Map_WaterBlock,mappings(a0)
		move.w	#$4400,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$200,priority(a0)
		move.l	#WaterBlock_Main,address(a0)

WaterBlock_Main:
		bsr.s	WaterBlock_Push
		bsr.w	WaterBlock_Fall
		tst.b	render_flags(a0)
		bpl.s	WaterBlock_Draw
		move.b	(Player_1+status).w,obWB_SaveStatus(a0)
		move.w	x_pos(a0),-(sp)
		jsr	(MoveSprite2_XOnly).w
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	(sp)+,d4
		jsr	(SolidObjectFull).w

WaterBlock_Draw:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------
; Push block
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

WaterBlock_Push:
		move.w	obWB_PushTimer(a0),d4
		cmpi.w	#$7FFF,d4
		beq.w	WaterBlock_Push_Return
		andi.w	#$00FF,d4
		move.b	status(a0),d3
		btst	#Status_Underwater,d3			; check underwater flag
		bne.w	WaterBlock_MoveBoat			; if already underwater, branch
		andi.b	#$60,d3
		beq.s	WaterBlock_Push_Return
		move.w	x_pos(a0),d2
		lea	(Player_1).w,a1
		move.b	obWB_SaveStatus(a0),d0
		moveq	#Status_Push,d6

WaterBlock_CheckPush:
		btst	d6,d3
		beq.s	WaterBlock_Push_Return
		btst	d6,d0
		beq.s	WaterBlock_Push_Return
		moveq	#1,d0
		cmp.w	x_pos(a1),d2
		blo.s		+
		moveq	#-1,d0
+		subq.w	#1,obWB_Timer(a0)
		bpl.s	WaterBlock_Push_Return
		move.w	d4,obWB_Timer(a0)
		sub.w	d0,x_pos(a0)
		sub.w	d0,x_pos(a1)
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	.notleft
		sub.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

.notleft:
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	WaterBlock_Push_Sound
		add.w	d1,x_pos(a0)
		rts
; ---------------------------------------------------------------------------

WaterBlock_Push_Sound:
		subq.w	#1,$34(a0)
		bpl.s	WaterBlock_Push_Return
		move.w	#3,$34(a0)
		sfx	sfx_PushBlock

WaterBlock_Push_Return:
		rts
; ---------------------------------------------------------------------------
; Check water and fall
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

WaterBlock_MoveBoat:
		move.w	obWB_PushTimer(a0),d4
		andi.w	#$FF00,d4
		bpl.s	WaterBlock_MoveBoat_Return
		andi.w	#$0F00,d4
		lsr.w	#6,d4
		jmp	.index(pc,d4.w)
; ---------------------------------------------------------------------------

.index:
		bra.w	WaterBlock_MoveBoat_CheckTouch		; 0
		bra.w	WaterBlock_MoveBoat_CheckWall		; 4
		bra.w	WaterBlock_MoveBoat_Return			; 8
; ---------------------------------------------------------------------------

WaterBlock_MoveBoat_CheckTouch:
		btst	#p1_standing_bit,status(a0)
		beq.s	WaterBlock_MoveBoat_CheckTouch_Return
		move.w	#$100,d0
		btst	#0,render_flags(a0)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a0)
		addi.b	#$01,obWB_PushTimer(a0)

WaterBlock_MoveBoat_CheckTouch_Return:
		rts
; ---------------------------------------------------------------------------

WaterBlock_MoveBoat_CheckWall:
		tst.w	x_vel(a0)
		bpl.s	.right
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	WaterBlock_MoveBoat_Return
		sub.w	d1,x_pos(a0)
		bra.s	WaterBlock_MoveBoat_CheckWall_Done
; ---------------------------------------------------------------------------

.right:
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	WaterBlock_MoveBoat_Return
		add.w	d1,x_pos(a0)

WaterBlock_MoveBoat_CheckWall_Done:
		addi.b	#$01,obWB_PushTimer(a0)
		clr.w	x_vel(a0)

WaterBlock_MoveBoat_Return:
		rts
; ---------------------------------------------------------------------------
; Check water and fall
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

WaterBlock_Fall:


; Check Water
		move.w	(Water_level).w,d0
		sub.w	y_pos(a0),d0			; is block level with water?
		beq.s	.inwater				; if yes, branch
		bhs.s	.floor				; branch if block is above water
		cmpi.w	#-2,d0
		bge.s	.checkceiling
		moveq	#-2,d0

.checkceiling:
		add.w	d0,y_pos(a0)			; make the block rise with water level
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		add.w	x_pos(a0),d3
		moveq	#$D,d5
		jsr	(ObjCheckCeilingDist2).w
		tst.w	d1
		bmi.s	.fixceiling
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		neg.w	d3
		add.w	x_pos(a0),d3
		moveq	#$D,d5
		jsr	(ObjCheckCeilingDist2).w
		tst.w	d1
		bpl.s	.return

.fixceiling:
		sub.w	d1,y_pos(a0)			; stop block

.return:
		rts
; ---------------------------------------------------------------------------

.inwater:
		bset	#Status_Underwater,status(a0)	; set underwater flag

;		bne.s	.return3					; if already underwater, branch
;		sfx	sfx_Splash

.return3:
		rts
; ---------------------------------------------------------------------------

.floor:
		cmpi.w	#2,d0
		ble.s		.checkfloor
		moveq	#2,d0

.checkfloor:
		add.w	d0,y_pos(a0)			; make the block sink with water level
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.s	.notleftwall
		sub.w	d1,x_pos(a0)

.notleftwall:
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.s	.notrightwall
		add.w	d1,x_pos(a0)

.notrightwall:
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		add.w	x_pos(a0),d3
		jsr	(ObjCheckFloorDist2).w
		tst.w	d1
		bmi.s	.fixfloor
		move.b	x_radius(a0),d3		; NAT: Get radius to d3
		ext.w	d3
		neg.w	d3
		add.w	x_pos(a0),d3
		jsr	(ObjCheckFloorDist2).w
		tst.w	d1
		bpl.s	.falltest

.fixfloor:
		addq.w	#1,d1
		add.w	d1,y_pos(a0)
		clr.w	y_vel(a0)
		bclr	#Status_Underwater,status(a0)	; clr underwater flag

.return2:
		rts
; ---------------------------------------------------------------------------

.falltest:
		btst	#Status_Underwater,status(a0)	; check underwater flag
		bne.s	.return2					; if already underwater, branch
		jmp	(MoveSprite_LightGravity_YOnly).w
; ---------------------------------------------------------------------------

		include "Objects/Water Block/Object data/Map - Water Block.asm"

; ---------------------------------------------------------------------------
; Object 15 - swinging platforms (GHZ, MZ, SLZ)
; - spiked ball on a chain (SBZ)
; ---------------------------------------------------------------------------

; Debug
_SPLATFORM_POS_		= 0	; sonic 1 version

; Dynamic object variables
swing_origX				= $42 ; original x-axis position
swing_origY				= $44 ; original y-axis position

; =============== S U B R O U T I N E =======================================

Obj_SwingingPlatform:
		move.l	#Map_Swing_GHZ,mappings(a0)
		move.w	#$42D,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#bytes_to_word(32/2,64/2),height_pixels(a0)		; set height and width
		move.w	#$200,priority(a0)
		move.w	x_pos(a0),swing_origX(a0)
		move.w	y_pos(a0),swing_origY(a0)

		; create chain
		jsr	(Create_New_Sprite3).w
		bne.s	.notfree
		move.l	#Draw_Sprite,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.w	#bytes_to_word(192/2,192/2),height_pixels(a1)		; set height and width
		move.w	#$280,priority(a1)
		bset	#6,render_flags(a1)	; set multi-draw flag
		move.w	a1,parent3(a0)	; save chain address
		move.w	x_pos(a0),d2
		move.w	d2,x_pos(a1)
		move.w	y_pos(a0),d3
		move.w	d3,y_pos(a1)
		move.b	subtype(a0),d1
		andi.w	#$F,d1
		move.w	d1,mainspr_childsprites(a1)
		subq.w	#1,d1
		blo.s		.delete

		lea	sub2_x_pos(a1),a2

.loop
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		move.w	#1,(a2)+
		dbf	d1,.loop
		move.b	#2,mapping_frame(a1)

.notfree
		move.l	#.main,address(a0)

.main
		move.w	x_pos(a0),-(sp)
		bsr.s	SwingingPlatform_Move
		moveq	#48/2,d1
		moveq	#18/2,d3
		move.w	(sp)+,d4
		jsr	(SolidObjectTop).w

		move.w	swing_origX(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.s	.offscreen
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete
		movea.w	parent3(a0),a1	; load chain address
		jsr	(Delete_Referenced_Sprite).w
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

SwingingPlatform_Move:
		moveq	#0,d0
		move.b	(Oscillating_Data+$18).w,d0
		tst.b	subtype(a0)
		bpl.s	.normal
		move.b	(Vine_Acceleration).w,d0

.normal
		btst	#0,status(a0)
		beq.s	.notflipx
		neg.b	d0
		addi.b	#$80,d0

.notflipx
		btst	#1,status(a0)
		beq.s	.notflipy
		neg.b	d0

.notflipy
		jsr	(GetSineCosine).w
		move.w	swing_origY(a0),d2
		move.w	swing_origX(a0),d3
		moveq	#0,d6
		movea.w	parent3(a0),a1	; load chain address
		move.w	mainspr_childsprites(a1),d6
		subq.w	#1,d6
		blo.s		.return
		swap	d0
		clr.w	d0
		swap	d1
		clr.w	d1
		asr.l	#4,d0
		asr.l	#4,d1
		move.l	d0,d4
		move.l	d1,d5
		lea	sub2_x_pos(a1),a2

.loop
		movem.l	d4-d5,-(sp)
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,(a2)+
		move.w	d4,(a2)+
		movem.l	(sp)+,d4-d5
		add.l	d0,d4
		add.l	d1,d5
		addq.w	#2,a2
		dbf	d6,.loop

	if _SPLATFORM_POS_
		; sonic 1 fix pos
		asr.l	d0
		asr.l	d1
		sub.l	d0,d4
		sub.l	d1,d5
	endif

		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,x_pos(a0)
		move.w	d4,y_pos(a0)

.return
		rts
; ---------------------------------------------------------------------------

		include "Objects/Swinging Platform/Object Data/Map - Swinging Platforms.asm"

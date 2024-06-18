
; =============== S U B R O U T I N E =======================================

Obj_MGZSwingingSpikeBall:
		move.l	#Map_MGZSwingingSpikeBall,mappings(a0)
		move.w	#$C350,art_tile(a0)
		move.b	#4,render_flags(a0)
		moveq	#32/2,d0
		move.b	d0,width_pixels(a0)
		move.b	d0,height_pixels(a0)
		move.w	#$280,priority(a0)
		move.w	x_pos(a0),objoff_44(a0)
		move.w	y_pos(a0),objoff_46(a0)
		move.b	#$1A|$80,collision_flags(a0)
		jsr	(Create_New_Sprite3).w
		bne.s	loc_435CA
		move.l	#loc_435FE,address(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	#160/2,width_pixels(a1)
		move.b	#160/2,height_pixels(a1)
		move.w	#$280,priority(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		bset	#6,render_flags(a1)	; set multi-draw flag
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		addq.w	#1,d0
		move.w	d0,mainspr_childsprites(a1)
		lea	sub2_x_pos(a1),a2
		move.w	mainspr_childsprites(a1),d0
		subq.w	#1,d0

-		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)+
		move.w	#1,(a2)+
		dbf	d0,-
		move.b	#1,mapping_frame(a1)
		move.w	a1,objoff_3C(a0)

loc_435CA:
		moveq	#2,d0
		btst	#0,status(a0)
		beq.s	loc_435D6
		neg.w	d0

loc_435D6:
		move.b	d0,objoff_36(a0)
		move.l	#loc_435E0,address(a0)

loc_435E0:
		movea.w	objoff_3C(a0),a1
		bsr.s	sub_43604
		move.b	objoff_34(a0),d2
		move.b	objoff_36(a0),d0
		add.b	d0,objoff_34(a0)
		move.w	objoff_44(a0),d0
		jmp	(Sprite_OnScreen_Test_Collision.skipxpos).w
; ---------------------------------------------------------------------------

loc_435FE:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_43604:
		move.b	objoff_34(a0),d0
		jsr	(GetSineCosine).w
		move.w	objoff_46(a0),d2
		move.w	objoff_44(a0),d3
		swap	d0
		swap	d1
		asr.l	#4,d0
		asr.l	#4,d1
		move.l	d0,d4
		move.l	d1,d5
		tst.b	subtype(a0)
		bpl.s	.plus
		add.l	d0,d4
		add.l	d1,d5

.plus:
		lea	sub2_x_pos(a1),a2
		move.w	mainspr_childsprites(a1),d6
		subq.w	#1,d6

-		movem.l	d4-d5,-(sp)
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
		dbf	d6,-
		swap	d4
		swap	d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d5,x_pos(a0)
		move.w	d4,y_pos(a0)
		rts
; ---------------------------------------------------------------------------

		include "Objects/MGZ Swinging SpikeBall/Object Data/Map - Swinging Spike Ball.asm"

; ---------------------------------------------------------------------------
; Object 3C - smashable wall (GHZ, SLZ)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BreakableWall:
		move.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		move.l	#loc_21568,address(a0)
		move.b	subtype(a0),d0
		move.b	d0,mapping_frame(a0)
		move.l	#Map_BreakableWall,mappings(a0)
		move.w	#$4000,art_tile(a0)
		move.w	#bytes_to_word(64/2,32/2),height_pixels(a0)		; set height and width
		move.l	#BreakableWall_FragSpd1,objoff_34(a0)
		move.l	#BreakableWall_FragSpd2,objoff_38(a0)

loc_21568:
		move.w	(Player_1+x_vel).w,objoff_30(a0)
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	height_pixels(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectFull).w
		swap	d6
		andi.w	#3,d6
		bne.s	loc_215B2

loc_215AC:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

loc_215B2:
		lea	(Player_1).w,a1
		move.w	objoff_30(a0),d1
		move.w	d6,d0
		andi.w	#1,d0
		beq.s	loc_215AC
		btst	#Status_FireShield,shield_reaction(a1)
		bne.s	loc_215E0
		btst	#5,status(a0)
		beq.s	loc_215AC

loc_215E0:
		cmpi.b	#id_Roll,anim(a1)
		bne.s	loc_215AC
		move.w	d1,d0
		bpl.s	loc_215EE
		neg.w	d0

loc_215EE:
		cmpi.w	#$480,d0
		blo.s		loc_215AC
		move.w	d1,x_vel(a1)
		addq.w	#4,x_pos(a1)
		movea.l	objoff_34(a0),a4
		move.w	x_pos(a0),d0
		cmp.w	x_pos(a1),d0
		blo.s		loc_2167A
		subq.w	#8,x_pos(a1)
		movea.l	objoff_38(a0),a4

loc_2167A:
		move.w	x_vel(a1),ground_vel(a1)
		bclr	#5,status(a1)

loc_21686:
		move.l	#loc_21692,address(a0)
		bsr.s	sub_216B0

loc_21692:
		jsr	(MoveSprite2).w
		addi.w	#$70,y_vel(a0)
		tst.b	render_flags(a0)
		bpl.s	loc_216AA
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_216AE:
		movea.l	objoff_34(a0),a4
		bra.s	loc_21686
; ---------------------------------------------------------------------------

loc_216AA:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_216B0:
		sfx	sfx_BreakWall		; play smashing sound
		move.w	#$80,priority(a0)
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		add.w	d0,d0
		movea.l	mappings(a0),a3
		adda.w	(a3,d0.w),a3
		move.w	(a3)+,d1
		subq.w	#1,d1
		bset	#5,render_flags(a0)
		move.l	address(a0),d4
		move.b	render_flags(a0),d5
		movea.l	a0,a1
		bra.s	loc_216EC
; ---------------------------------------------------------------------------

loc_216E2:
		jsr	(Create_New_Sprite3).w
		bne.s	locret_2172C
		addq.w	#6,a3

loc_216EC:
		move.l	d4,address(a1)
		move.l	a3,mappings(a1)
		move.b	d5,render_flags(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	art_tile(a0),art_tile(a1)
		ori.w	#$8000,art_tile(a1)
		move.w	priority(a0),priority(a1)			; fix S1 byte priority
		move.b	width_pixels(a0),width_pixels(a1)
		move.b	height_pixels(a0),height_pixels(a1)
		move.l	(a4)+,x_vel(a1)
		dbf	d1,loc_216E2

locret_2172C:
		rts
; ---------------------------------------------------------------------------

BreakableWall_FragSpd1:
		dc.w $400
		dc.w $FB00
		dc.w $600
		dc.w $FA00
		dc.w $600
		dc.w $FF00
		dc.w $800
		dc.w $FE00
		dc.w $600
		dc.w $100
		dc.w $800
		dc.w $200
		dc.w $400
		dc.w $500
		dc.w $600
		dc.w $600
BreakableWall_FragSpd2:
		dc.w $FA00
		dc.w $FA00
		dc.w $FC00
		dc.w $FB00
		dc.w $F800
		dc.w $FE00
		dc.w $FA00
		dc.w $FF00
		dc.w $F800
		dc.w $200
		dc.w $FA00
		dc.w $100
		dc.w $FA00
		dc.w $600
		dc.w $FC00
		dc.w $500
; ---------------------------------------------------------------------------

		include "Objects/Breakable Wall/Object Data/Map - Breakable Wall.asm"


; =============== S U B R O U T I N E =======================================

Obj_MGZFlameThrower:
		move.l	#Map_MGZFlameThrower,mappings(a0)
		move.w	#$235C,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#48/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.w	#$280,priority(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		bpl.s	loc_43DC4
		andi.w	#$7F,d0
		lsl.w	#2,d0
		move.w	d0,$32(a0)
		move.w	#2*60,$30(a0)
		move.b	#7,mapping_frame(a0)
		btst	#0,status(a0)
		beq.s	loc_43DBA
		bset	#1,render_flags(a0)

loc_43DBA:
		move.l	#loc_43F12,address(a0)
		bra.w	loc_43F12
; ---------------------------------------------------------------------------

loc_43DC4:
		lsl.w	#2,d0
		move.w	d0,$32(a0)
		move.w	#2*60,$30(a0)
		move.b	#6,mapping_frame(a0)
		move.l	#loc_43DDC,address(a0)

loc_43DDC:
		tst.b	$2F(a0)
		bne.s	loc_43DF8
		subq.w	#1,$30(a0)
		bpl.s	loc_43E14
		move.w	$32(a0),$30(a0)
		move.b	#1,$2F(a0)
		bra.w	loc_43EF6
; ---------------------------------------------------------------------------

loc_43DF8:
		subq.w	#1,$30(a0)
		bpl.w	loc_43EF6
		move.w	#2*60,$30(a0)
		clr.b	$2F(a0)
		sfx	sfx_LavaBall

loc_43E14:
		subq.b	#1,$24(a0)
		bpl.s	loc_43E2A
		move.b	#2,$24(a0)
		addq.b	#1,$25(a0)
		andi.b	#1,$25(a0)

loc_43E2A:
		move.b	(Level_frame_counter+1).w,d0
		move.b	d0,d1
		andi.b	#3,d0
		bne.w	loc_43EF6
		andi.b	#$F,d1
		bne.s	loc_43E4E
		cmpi.w	#$1E,$30(a0)
		blo.s		loc_43E4E
		sfx	sfx_LavaBall

loc_43E4E:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		asr.w	#4,d0
		move.b	d0,$2E(a0)
		addq.b	#8,angle(a0)
		tst.b	render_flags(a0)
		bpl.w	loc_43EF6
		jsr	(Create_New_Sprite3).w
		bne.w	loc_43EF6
		move.l	#loc_44048,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$10,x_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$235C,art_tile(a1)
		move.w	#$300,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.b	#$18|$80,collision_flags(a1)
		bset	#Status_FireShield,shield_reaction(a1)
		move.b	$2E(a0),d0
		jsr	(GetSineCosine).w
		asl.w	#2,d1
		asl.w	#2,d0
		move.w	d1,x_vel(a1)
		move.w	d0,y_vel(a1)
		btst	#0,status(a0)
		beq.s	loc_43EE4
		neg.w	x_vel(a1)
		subi.w	#$20,x_pos(a1)

loc_43EE4:
		move.b	$25(a0),mapping_frame(a1)
		move.b	$24(a0),$25(a1)
		move.b	#8,$24(a1)

loc_43EF6:
		move.w	#$23,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

loc_43F12:
		tst.b	$2F(a0)
		bne.s	loc_43F2E
		subq.w	#1,$30(a0)
		bpl.s	loc_43F4A
		move.w	$32(a0),$30(a0)
		move.b	#1,$2F(a0)
		bra.w	loc_4402C
; ---------------------------------------------------------------------------

loc_43F2E:
		subq.w	#1,$30(a0)
		bpl.w	loc_4402C
		move.w	#2*60,$30(a0)
		clr.b	$2F(a0)
		sfx	sfx_LavaBall

loc_43F4A:
		subq.b	#1,$24(a0)
		bpl.s	loc_43F60
		move.b	#2,$24(a0)
		addq.b	#1,$25(a0)
		andi.b	#1,$25(a0)

loc_43F60:
		move.b	(Level_frame_counter+1).w,d0
		move.b	d0,d1
		andi.b	#3,d0
		bne.w	loc_4402C
		andi.b	#$F,d1
		bne.s	loc_43F84
		cmpi.w	#$1E,$30(a0)
		blo.s		loc_43F84
		sfx	sfx_LavaBall

loc_43F84:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		asr.w	#4,d0
		move.b	d0,$2E(a0)
		addq.b	#8,angle(a0)
		tst.b	render_flags(a0)
		bpl.w	loc_4402C
		jsr	(Create_New_Sprite3).w
		bne.w	loc_4402C
		move.l	#loc_44048,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addi.w	#$10,y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$2310,art_tile(a1)
		move.w	#$300,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.b	#$18|$80,collision_flags(a1)
		bset	#Status_FireShield,shield_reaction(a1)
		move.b	$2E(a0),d0
		jsr	(GetSineCosine).w
		asl.w	#2,d1
		asl.w	#2,d0
		move.w	d1,y_vel(a1)
		move.w	d0,x_vel(a1)
		btst	#0,status(a0)
		beq.s	loc_4401A
		neg.w	y_vel(a1)
		subi.w	#$20,y_pos(a1)

loc_4401A:
		move.b	$25(a0),mapping_frame(a1)
		move.b	$24(a0),$25(a1)
		move.b	#8,$24(a1)

loc_4402C:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	x_pos(a0),d4
		jsr	(SolidObjectFull).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

loc_44048:
		subq.b	#1,$24(a0)
		bpl.s	loc_44060
		move.b	#7,$24(a0)
		addq.b	#2,mapping_frame(a0)
		cmpi.b	#6,mapping_frame(a0)
		bhs.s	loc_44084

loc_44060:
		subq.b	#1,$25(a0)
		bpl.s	loc_44072
		move.b	#2,$25(a0)
		bchg	#0,mapping_frame(a0)

loc_44072:
		jsr	(MoveSprite2).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

loc_44084:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

		include "Objects/MGZ Flame Thrower/Object Data/Map - Flamethrower.asm"

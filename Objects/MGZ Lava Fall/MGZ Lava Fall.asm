
; =============== S U B R O U T I N E =======================================

Obj_MGZLavaFall:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	d0,objoff_30(a0)
		move.l	#loc_436A8,address(a0)

loc_436A8:
		move.w	(Level_frame_counter).w,d0
		andi.w	#$FF,d0
		cmp.w	objoff_30(a0),d0
		blo.w	loc_43746
		subq.b	#1,anim_frame_timer(a0)
		bpl.w	loc_43746
		move.b	#5,anim_frame_timer(a0)
		jsr	(Create_New_Sprite3).w
		bne.s	loc_43746
		move.l	#loc_43764,address(a1)
		addq.b	#1,$25(a0)
		cmpi.b	#2,$25(a0)
		blo.s	loc_436EE
		clr.b	$25(a0)
		move.l	#loc_4374C,address(a1)

loc_436EE:
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.l	#Map_MGZLavaFall,mappings(a1)
		move.w	#$3CF,art_tile(a1)
		ori.b	#$84,render_flags(a1)
		move.w	#$300,priority(a1)
		moveq	#64/2,d0
		move.b	d0,width_pixels(a1)
		move.b	d0,height_pixels(a1)
		move.b	#$19|$80,collision_flags(a1)
		bset	#Status_FireShield,shield_reaction(a1)
		move.w	#$800,y_vel(a1)
		move.w	#$1C,$2E(a1)
		btst	#0,status(a0)
		beq.s	loc_43746
		move.w	#$24,$2E(a1)

loc_43746:
		jmp	(Delete_Sprite_If_Not_In_Range).w
; ---------------------------------------------------------------------------

loc_4374C:
		tst.b	render_flags(a0)
		bpl.s	loc_43764
		move.b	(Level_frame_counter+1).w,d0
		andi.b	#$F,d0
		bne.s	loc_43764
		sfx	sfx_LavaFall

loc_43764:
		subq.w	#1,$2E(a0)
		bmi.s	loc_4377C
		jsr	(MoveSprite2).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

loc_4377C:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

		include "Objects/MGZ Lava Fall/Object Data/Map - Lava Fall.asm"

; ===========================================================================
; Object 47 - pinball bumper (SYZ)
; ===========================================================================

Obj_Bumper:
		move.l	#Map_Bump,mappings(a0)
		move.w	#$410,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		moveq	#32/2,d0
		move.b	d0,height_pixels(a0)
		move.b	d0,width_pixels(a0)
		move.b	#$17|$C0,collision_flags(a0)
		move.l	#.hit,address(a0)

.hit:
		bclr	#0,collision_property(a0)		; has Sonic touched the	bumper?
		beq.s	.display					; if not, branch
		lea	(Player_1).w,a1
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		move.b	(Level_frame_counter).w,d1
		andi.w	#3,d1
		add.w	d1,d0
		jsr	(GetSineCosine).w
		move.w	#-$700,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a1)
		bset	#Status_InAir,status(a1)
		bclr	#Status_RollJump,status(a1)
		bclr	#Status_Push,status(a1)
		clr.b	jumping(a1)
		move.b	#1,anim(a0)			; use "hit" animation
		sfx	sfx_Bumper				; play bumper sound

.display:
		lea	Ani_Bump(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test_Collision).w
; ---------------------------------------------------------------------------

		include "Objects/Bumper/Object data/Anim - Bumper.asm"
		include "Objects/Bumper/Object data/Map - Bumper.asm"

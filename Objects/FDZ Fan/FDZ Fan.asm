; ---------------------------------------------------------------------------
; Fan from Sonic 2 and Sonic 3 & Knuckles.
; Version 1.0
; By TheBlad768 (2022).
; ---------------------------------------------------------------------------

; Dynamic object variables
obFF_Force					= objoff_2E	; .w
obFF_Force2					= objoff_30	; .w
obFF_Range					= objoff_32	; .w
; ---------------------------------------------------------------------------

FDZFan_Data:			; force, range
		dc.w $1A8, 24	; 0
		dc.w $90, 64		; 1
		dc.w $C0, 24	; 2

; =============== S U B R O U T I N E =======================================

Obj_FDZFan:
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		add.b	d0,d0
		lea	FDZFan_Data(pc,d0.w),a1
		move.w	(a1)+,d0
		move.w	d0,obFF_Force(a0)
		addi.w	#48,d0
		move.w	d0,obFF_Force2(a0)
		move.w	(a1)+,obFF_Range(a0)
		moveq	#32/2,d0
		move.b	d0,width_pixels(a0)
		move.b	d0,height_pixels(a0)
		move.l	#Map_FDZFan,mappings(a0)
		move.w	#$C2D0,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		move.l	#.main,address(a0)

.main
		lea	(Player_1).w,a1
		cmpi.b	#id_SonicHurt,routine(a1)
		bhs.w	.anim
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		move.w	obFF_Range(a0),d1
		add.w	d1,d1
		add.w	obFF_Range(a0),d0
		cmp.w	d1,d0
		bhs.s	.anim
		moveq	#0,d1
		move.b	(v_oscillate+$16).w,d1
		add.w	y_pos(a1),d1
		add.w	obFF_Force(a0),d1
		sub.w	y_pos(a0),d1
		blo.s		.anim
		cmp.w	obFF_Force2(a0),d1
		bhs.s	.anim
		tst.b	object_control(a1)
		bne.s	.control
		sub.w	obFF_Force(a0),d1
		blo.s		.skip
		not.w	d1
		add.w	d1,d1

.skip
		add.w	obFF_Force(a0),d1
		neg.w	d1
		asr.w	#6,d1
		add.w	d1,y_pos(a1)
		bset	#Status_InAir,status(a1)
		bclr	#Status_RollJump,status(a1)
		clr.w	y_vel(a1)
		clr.b	double_jump_flag(a1)
		clr.b	jumping(a1)
		move.w	#1,ground_vel(a1)
		tst.b	flip_angle(a1)
		bne.s	.anim
		move.b	#1,flip_angle(a1)
		clr.b	anim(a1)
		move.b	#$7F,flips_remaining(a1)
		move.b	#8,flip_speed(a1)

.anim

		; anim and draw
		lea	AniRaw_FDZFan(pc),a1
		jsr	(Animate_RawNoSST).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

.control
		move.w	#1,ground_vel(a1)

		; anim and draw
		bra.s	.anim
; ---------------------------------------------------------------------------

		include "Objects/FDZ Fan/Object Data/Anim - Fan.asm"
		include "Objects/FDZ Fan/Object Data/Map - Fan.asm"

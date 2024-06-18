
; =============== S U B R O U T I N E =======================================

Obj_MGZGravitySwitch:
		move.l	#Map_MGZGravitySwitch,$C(a0)
		move.w	#$43B0,$A(a0)
		ori.b	#4,4(a0)
		move.b	#$10,7(a0)
		move.b	#8,6(a0)
		move.w	#$280,8(a0)
		move.l	#loc_48AD6,(a0)

loc_48AD6:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#9,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectFull).w
		swap	d6
		move.w	d6,d0
		andi.w	#$14,d0
		beq.w	loc_48B3A
		move.b	#1,$22(a0)
		move.l	#MGZGravitySwitch_PressSwitch,(a0)
		move.w	#3,$30(a0)
		moveq	#8,d0
		btst	#1,4(a0)
		beq.s	loc_48B16
		neg.w	d0

loc_48B16:
		add.w	d0,$14(a0)
		lea	(Player_1).w,a1
		move.w	d6,d2
		move.w	#$14,d3
		bsr.s	MGZGravitySwitch_RemovePlayerFlags
		sfx	sfx_Bounce
		move.w #$14,(Screen_Shaking_Flag).w

loc_48B3A:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

MGZGravitySwitch_RemovePlayerFlags:
		tst.b	$2E(a1)
		bne.s	locret_48B7C
		moveq	#0,d1
		move.b	d1,$20(a1)
		move.b	d1,$2D(a1)
		move.b	d1,double_jump_flag(a1)
		move.b	d1,$40(a1)
		move.b	d1,$3D(a1)
		move.w	d1,$1C(a1)
		move.w	d1,$18(a1)
		move.w	d1,$1A(a1)
		bset	#1,$2A(a1)
		bclr	#3,$2A(a1)
		and.w	d3,d2
		beq.s	locret_48B7C
		add.w	d0,$14(a1)

locret_48B7C:
		rts
; End of function MGZGravitySwitch_RemovePlayerFlags

; =============== S U B R O U T I N E =======================================

MGZGravitySwitch_PressSwitch:
		subq.w	#1,$30(a0)
		bpl.s	MGZGravitySwitch_PressSwitch_Draw
		move.w	#$13,$30(a0)
		add.b	#$80,GravityAngle.w
		move.l	#MGZGravitySwitch_PressSwitch_Solid,(a0)

MGZGravitySwitch_PressSwitch_Draw:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

MGZGravitySwitch_PressSwitch_Solid:
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#9,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectFull).w
		btst	#3,$2A(a0)
		beq.s	loc_48BC2
		move.w	#0,$30(a0)
		bra.s	loc_48BE4
; ---------------------------------------------------------------------------

loc_48BC2:
		subq.w	#1,$30(a0)
		bpl.s	loc_48BE4
		move.b	#0,$22(a0)
		moveq	#8,d0
		btst	#1,4(a0)
		beq.s	loc_48BDA
		neg.w	d0

loc_48BDA:
		sub.w	d0,$14(a0)
		move.l	#loc_48AD6,(a0)

loc_48BE4:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

		include "Objects/Gravity Switch/Object data/Map - Gravity Switch.asm"

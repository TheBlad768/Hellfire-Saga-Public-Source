PlatformSz_Regular:; width, height, frame #
		dc.b $20, $10, 0, 0
		dc.b $18, $C, 0, 0
		dc.b $20, $14, 0, 0

; =============== S U B R O U T I N E =======================================

Obj_FloatingPlatform:
		tst.b	obSubtype(a0)
		bmi.s	.checknegative

		move.l	#Map_FloatingPlatformFDZ,$C(a0)
		tst.b	Current_Zone.w			; NAT: check if this is FDZ
		beq.s	.loaded

		move.l	#Map_FloatingPlatformSCZ,$C(a0)
		cmp.b	#1,Current_Zone.w		; check if this is SCZ
		beq.s	.loaded

		move.l	#Map_FloatingPlatformMGZ1,$C(a0)
                cmpi.w	#$200,(Current_zone_and_act).w ; check if this is MGZ1
		beq.s	.loaded

		move.l	#Map_FloatingPlatformMGZ2,$C(a0)
		bra.s	.loaded

.checknegative:
		move.l	#Map_FloatingPlatformFDZStoned,$C(a0)

.loaded:
		move.w	#$4000,$A(a0)
		move.b	#4,4(a0)
		move.w	#$180,8(a0)

		moveq	#0,d0
		move.b	$2C(a0),d0
		lsr.w	#2,d0
		andi.w	#$1C,d0
		lea	PlatformSz_Regular(pc,d0.w),a2
		move.b	(a2,d0.w),7(a0)
		move.b	1(a2,d0.w),6(a0)
		move.b	2(a2,d0.w),$22(a0)

		move.w	$10(a0),$30(a0)
		move.w	$10(a0),$32(a0)
		move.w	$14(a0),$34(a0)
		move.b	$2A(a0),$2E(a0)
		move.w	#$280,$42(a0)
		move.w	$10(a0),$44(a0)

		moveq	#0,d0
		move.b	$2C(a0),d0
		andi.w	#$F,d0
		subq.w	#8,d0
		bcs.s	loc_255E0
		cmpi.w	#4,d0
		bcc.s	loc_255D4
		lsl.w	#2,d0
		lea	(v_oscillate+$2C).w,a2
		lea	(a2,d0.w),a2
		tst.w	(a2)
		bpl.s	loc_255E0
		bchg	#0,$2E(a0)
		bra.s	loc_255E0
; ---------------------------------------------------------------------------

loc_255D4:
		move.w	#$380,$42(a0)
		addi.w	#$100,$44(a0)

loc_255E0:
		move.b	$2C(a0),d0
		andi.b	#$F,d0
		add.b	d0,d0
		move.b	d0,$2C(a0)
		move.l	#loc_255F4,(a0)

loc_255F4:
		move.w	$10(a0),-(sp)
		moveq	#0,d0
		move.b	$2C(a0),d0
		lea	(off_24F76).l,a1
		move.w	(a1,d0.w),d1
		jsr	(a1,d1.w)
		move.w	(sp)+,d4

		tst.b	4(a0)
		bpl.s	loc_25628
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#0,d3
		move.b	height_pixels(a0),d3
		addq.w	#1,d3
		jsr	(SolidObjectTop).w

loc_25628:
		move.w	$44(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmp.w	$42(a0),d0
		bhi.w	loc_25642
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_25642:
		move.w	respawn_addr(a0),d0
		beq.s	loc_2564E
		movea.w	d0,a2
		bclr	#7,(a2)

loc_2564E:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

off_24F76:
		dc.w loc_24F90-off_24F76
		dc.w loc_24FC8-off_24F76
		dc.w loc_24FD4-off_24F76
		dc.w loc_24FF6-off_24F76
		dc.w loc_25002-off_24F76
		dc.w loc_25024-off_24F76
		dc.w loc_2503E-off_24F76
		dc.w loc_251E4-off_24F76
		dc.w loc_25278-off_24F76
		dc.w loc_2528A-off_24F76
		dc.w loc_2529A-off_24F76
		dc.w loc_252AA-off_24F76
		dc.w loc_250AC-off_24F76
; ---------------------------------------------------------------------------

loc_24F90:
		move.b	$2A(a0),d0
		andi.b	#$18,d0
		bne.s	loc_24FA6
		tst.b	$3A(a0)
		beq.s	loc_24FB2
		subq.b	#4,$3A(a0)
		bra.s	loc_24FB2
; ---------------------------------------------------------------------------

loc_24FA6:
		cmpi.b	#$40,$3A(a0)
		beq.s	loc_24FB2
		addq.b	#4,$3A(a0)

loc_24FB2:
		move.b	$3A(a0),d0
		jsr	(GetSineCosine).w
		asr.w	#6,d0

		tst.b	GravityAngle.w		; NAT: Check if we are in reverse gravity
		bpl.s	.norev			; if not, skip
		neg.w	d0			; negate offset

.norev
		add.w	$34(a0),d0
		move.w	d0,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_24FC8:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	sub_24FDE
; ---------------------------------------------------------------------------

loc_24FD4:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

sub_24FDE:
		btst	#0,$2A(a0)
		beq.s	loc_24FEA
		neg.w	d0
		add.w	d1,d0

loc_24FEA:
		move.w	$30(a0),d1
		add.w	d0,d1
		move.w	d1,$10(a0)
		rts
; End of function sub_24FDE
; ---------------------------------------------------------------------------

loc_24FF6:
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$A).w,d0
		bra.s	loc_2500C
; ---------------------------------------------------------------------------

loc_25002:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0

loc_2500C:
		btst	#0,$2A(a0)
		beq.s	loc_25018
		neg.w	d0
		add.w	d1,d0

loc_25018:
		move.w	$34(a0),d1
		sub.w	d0,d1
		move.w	d1,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_25024:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0
		bsr.s	sub_24FDE
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0
		lsr.b	#1,d0
		bra.s	loc_2500C
; ---------------------------------------------------------------------------

loc_2503E:
		move.w	#$80,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0
		neg.w	d0
		add.w	d1,d0
		bsr.s	sub_24FDE
		move.w	#$40,d1
		moveq	#0,d0
		move.b	(v_oscillate+$1E).w,d0
		lsr.b	#1,d0
		bra.s	loc_2500C
; ---------------------------------------------------------------------------

loc_250AC:
		move.w	#$7F,d2
		tst.b	$3C(a0)
		bne.s	loc_250D2
		move.w	$40(a0),d1
		addq.w	#4,d1
		move.w	d1,$40(a0)
		add.w	d1,$36(a0)
		cmp.b	$36(a0),d2
		bhi.s	loc_250EC
		move.b	#1,$3C(a0)
		bra.s	loc_250EC
; ---------------------------------------------------------------------------

loc_250D2:
		move.w	$40(a0),d1
		subq.w	#4,d1
		move.w	d1,$40(a0)
		add.w	d1,$36(a0)
		cmp.b	$36(a0),d2
		bls.s	loc_250EC
		move.b	#0,$3C(a0)

loc_250EC:
		moveq	#0,d0
		move.b	$36(a0),d0
		btst	#0,$2A(a0)
		beq.s	loc_250FE
		neg.w	d0
		add.w	d2,d0

loc_250FE:
		add.w	$30(a0),d0
		move.w	d0,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_251E4:
		tst.b	$3C(a0)
		bne.s	loc_25202
		move.b	$2A(a0),d0
		andi.b	#$18,d0
		beq.s	locret_25200
		move.b	#1,$3C(a0)
		move.b	#$C,$1E(a0)

locret_25200:
		rts
; ---------------------------------------------------------------------------

loc_25202:
		jsr	(MoveSprite2).w
		moveq	#8,d1
		move.w	$34(a0),d0
		subi.w	#$80,d0
		cmp.w	$14(a0),d0
		bhs.s	loc_2521E
		neg.w	d1
		add.w	d1,$1A(a0)

loc_2521E:
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1
		bpl.s	loc_25236
		sub.w	d1,$14(a0)
		clr.b	$3C(a0)
		clr.w	$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_25236:
		btst	#3,$2A(a0)
		beq.s	locret_25276
		move.l	a0,-(sp)
		lea	(Player_1).w,a0
		jsr	(sub_F846).w
		tst.w	d1
		bpl.s	loc_25254
		jsr	(Kill_Character).l

loc_25254:
		movea.l	(sp)+,a0

locret_25276:
		rts
; ---------------------------------------------------------------------------

loc_25278:
		move.w	#$10,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2A).w,d0
		lsr.w	#1,d0
		move.w	(v_oscillate+$2C).w,d3
		bra.s	loc_252B8
; ---------------------------------------------------------------------------

loc_2528A:
		move.w	#$30,d1
		moveq	#0,d0
		move.b	(v_oscillate+$2E).w,d0
		move.w	(v_oscillate+$30).w,d3
		bra.s	loc_252B8
; ---------------------------------------------------------------------------

loc_2529A:
		move.w	#$50,d1
		moveq	#0,d0
		move.b	(v_oscillate+$32).w,d0
		move.w	(v_oscillate+$34).w,d3
		bra.s	loc_252B8
; ---------------------------------------------------------------------------

loc_252AA:
		move.w	#$70,d1
		moveq	#0,d0
		move.b	(v_oscillate+$36).w,d0
		move.w	(v_oscillate+$38).w,d3

loc_252B8:
		tst.w	d3
		bne.s	loc_252C6
		addq.b	#1,$2E(a0)
		andi.b	#3,$2E(a0)

loc_252C6:
		move.b	$2E(a0),d2
		andi.b	#3,d2
		bne.s	loc_252E6
		sub.w	d1,d0
		add.w	$30(a0),d0
		move.w	d0,$10(a0)
		neg.w	d1
		add.w	$34(a0),d1
		move.w	d1,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_252E6:
		subq.b	#1,d2
		bne.s	loc_25304
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$34(a0),d0
		move.w	d0,$14(a0)
		addq.w	#1,d1
		add.w	$30(a0),d1
		move.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

loc_25304:
		subq.b	#1,d2
		bne.s	loc_25322
		subq.w	#1,d1
		sub.w	d1,d0
		neg.w	d0
		add.w	$30(a0),d0
		move.w	d0,$10(a0)
		addq.w	#1,d1
		add.w	$34(a0),d1
		move.w	d1,$14(a0)
		rts
; ---------------------------------------------------------------------------

loc_25322:
		sub.w	d1,d0
		add.w	$34(a0),d0
		move.w	d0,$14(a0)
		neg.w	d1
		add.w	$30(a0),d1
		move.w	d1,$10(a0)
		rts
; ---------------------------------------------------------------------------

		include "Objects/Floating Platform/Object data/Map - Floating PlatformMGZ1.asm"
		include "Objects/Floating Platform/Object data/Map - Floating PlatformMGZ2.asm"
		include "Objects/Floating Platform/Object data/Map - Floating PlatformFDZ.asm"
		include "Objects/Floating Platform/Object data/Map - Floating PlatformFDZ3.asm"
		include "Objects/Floating Platform/Object data/Map - Floating PlatformSCZ.asm"
		include "Objects/Floating Platform/Object data/Map - Floating PlatformFDZ (Stone).asm"

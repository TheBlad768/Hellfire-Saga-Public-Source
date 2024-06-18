
; =============== S U B R O U T I N E =======================================

Obj_FBZ_ChainLink:
		move.b	$2C(a0),d0
		bpl.s	loc_3A7E6
		andi.w	#$3F,d0
		lsl.w	#4,d0
		move.w	d0,$3E(a0)
		move.l	#loc_3AA5A,(a0)
		bra.w	loc_3AA5A
; ---------------------------------------------------------------------------

loc_3A7E6:
		move.b	#4,4(a0)
		move.b	#$10,7(a0)
		move.w	#$80,8(a0)
		move.b	#-$80,6(a0)
		move.w	$14(a0),$46(a0)
		move.l	#Map_FBZChainLink,$C(a0)
		move.w	#$4420,$A(a0)
		move.b	$2C(a0),d0
		andi.w	#$7F,d0
		lsl.w	#3,d0
		move.w	d0,$2E(a0)
		move.w	#2,$3C(a0)
		move.b	$2C(a0),d0
		bpl.s	loc_3A846
		move.w	$2E(a0),d0
		move.w	d0,$3A(a0)
		move.b	#1,$38(a0)
		add.w	d0,$14(a0)
		lsr.w	#4,d0
		addq.w	#1,d0
		move.b	d0,$22(a0)

loc_3A846:
		move.l	#loc_3A84C,(a0)

loc_3A84C:
		tst.b	$38(a0)
		beq.s	loc_3A85A
		tst.w	$30(a0)
		bne.s	loc_3A870
		bra.s	loc_3A860
; ---------------------------------------------------------------------------

loc_3A85A:
		tst.w	$30(a0)
		beq.s	loc_3A870

loc_3A860:
		move.w	$3A(a0),d2
		cmp.w	$2E(a0),d2
		beq.s	loc_3A894
		add.w	$3C(a0),d2
		bra.s	loc_3A87A
; ---------------------------------------------------------------------------

loc_3A870:
		move.w	$3A(a0),d2
		beq.s	loc_3A894
		sub.w	$3C(a0),d2

loc_3A87A:
		move.w	d2,$3A(a0)
		move.w	$46(a0),d0
		add.w	d2,d0
		move.w	d0,$14(a0)
		move.w	d2,d0
		beq.s	loc_3A890
		lsr.w	#4,d0
		addq.w	#1,d0

loc_3A890:
		move.b	d0,$22(a0)

loc_3A894:
		lea	$30(a0),a2
		lea	(Player_1).w,a1
		move.w	(Ctrl_1_logical).w,d0
		bsr.w	sub_3A8B8

;		lea	(Player_2).w,a1
;		addq.w	#1,a2
;		move.w	(Ctrl_2_logical).w,d0
;		bsr.w	sub_3A8B8

		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_3A8B8:
		tst.b	(a2)
		beq.w	loc_3A9A6
		tst.b	4(a1)
		bpl.w	loc_3A954
		tst.w	(Debug_placement_mode).w
		bne.w	loc_3A954
		cmpi.b	#4,5(a1)
		bhs.s	loc_3A954
		andi.b	#$70,d0
		beq.w	loc_3A96E
		clr.b	$2E(a1)
		clr.b	(a2)
		move.b	#$12,2(a2)
		andi.w	#$F00,d0
		beq.w	loc_3A8F8
		move.b	#$3C,2(a2)

loc_3A8F8:
		btst	#$A,d0
		beq.s	loc_3A904
		move.w	#-$200,$18(a1)

loc_3A904:
		btst	#$B,d0
		beq.s	loc_3A910
		move.w	#$200,$18(a1)

loc_3A910:
		move.w	#-$380,$1A(a1)
		bset	#1,$2A(a1)
		move.b	#1,$40(a1)
		move.b	#$E,$1E(a1)
		move.b	#7,$1F(a1)
		move.b	#2,anim(a1)
		bset	#2,$2A(a1)
		bclr	#4,$2A(a1)
		move.b	#0,$27(a1)
		bclr	#3,$2A(a1)
		move.w	#0,$42(a1)
		rts
; ---------------------------------------------------------------------------

loc_3A954:
		clr.b	$2E(a1)
		clr.b	(a2)
		move.b	#$3C,2(a2)
		bclr	#3,$2A(a1)
		move.w	#0,$42(a1)
		rts
; ---------------------------------------------------------------------------

loc_3A96E:
		btst	#$A,d0
		beq.s	loc_3A97A
		bset	#0,$2A(a1)

loc_3A97A:
		btst	#$B,d0
		beq.s	loc_3A986
		bclr	#0,$2A(a1)

loc_3A986:
		move.b	$2A(a1),d0
		andi.b	#1,d0
		andi.b	#-2,4(a1)
		or.b	d0,4(a1)
		move.w	$14(a0),$14(a1)
		addi.w	#$9C,$14(a1)
		rts
; ---------------------------------------------------------------------------

loc_3A9A6:
		tst.b	2(a2)
		beq.s	loc_3A9B4
		subq.b	#1,2(a2)
		bne.w	locret_3AA58

loc_3A9B4:
		move.w	$10(a1),d0
		sub.w	$10(a0),d0
		addi.w	#$10,d0
		cmpi.w	#$20,d0
		bhs.w	locret_3AA58
		move.w	$14(a1),d1
		sub.w	$14(a0),d1
		subi.w	#$90,d1
		cmpi.w	#$18,d1
		bhs.w	locret_3AA58
		tst.b	$2E(a1)
		bmi.w	locret_3AA58
		cmpi.b	#4,5(a1)
		bhs.s	locret_3AA58
		tst.w	(Debug_placement_mode).w
		bne.s	locret_3AA58
		btst	#3,$2A(a1)
		beq.s	loc_3AA18
		movea.w	$42(a1),a3
		cmpi.l	#loc_3AA5A,(a3)
		bne.s	loc_3AA18
		move.w	a2,d0
		sub.w	a0,d0
		adda.w	d0,a3
		tst.b	4(a3)
		bne.s	locret_3AA58
		clr.b	(a3)
		move.b	#$3C,2(a3)

loc_3AA18:
		move.w	a0,$42(a1)
		bset	#3,$2A(a1)
		clr.w	$18(a1)
		clr.w	$1A(a1)
		clr.w	$1C(a1)
		move.w	$10(a0),$10(a1)
		move.w	$14(a0),$14(a1)
		addi.w	#$9C,$14(a1)
		move.b	#$14,anim(a1)
		move.b	#1,$2E(a1)
		move.b	#1,(a2)
		sfx	sfx_Grab

locret_3AA58:
		rts
; ---------------------------------------------------------------------------

loc_3AA5A:
		lea	$30(a0),a2
		lea	(Player_1).w,a1
		move.w	(Ctrl_1_logical).w,d0
		bsr.w	sub_3AA7E

;		lea	(Player_2).w,a1
;		addq.w	#1,a2
;		move.w	(Ctrl_2_logical).w,d0
;		bsr.w	sub_3AA7E

		jmp	(Delete_Sprite_If_Not_In_Range).w
; End of function sub_3A8B8

; =============== S U B R O U T I N E =======================================

sub_3AA7E:
		tst.b	(a2)
		beq.w	loc_3AC86
		tst.b	4(a1)
		bpl.w	loc_3AB24
		tst.w	(Debug_placement_mode).w
		bne.w	loc_3AB24
		cmpi.b	#4,5(a1)
		bhs.w	loc_3AB24
		andi.b	#$70,d0
		beq.w	loc_3AB3E
		clr.b	$2E(a1)
		clr.b	(a2)
		move.b	#$12,2(a2)
		andi.w	#$F00,d0
		beq.w	loc_3AAC0
		move.b	#$3C,2(a2)

loc_3AAC0:
		btst	#$A,d0
		beq.s	loc_3AACC
		move.w	#-$200,$18(a1)

loc_3AACC:
		btst	#$B,d0
		beq.s	loc_3AAD8
		move.w	#$200,$18(a1)

loc_3AAD8:
		move.w	#-$380,$1A(a1)
		bset	#1,$2A(a1)
		move.b	#1,$40(a1)
		move.b	#$E,$1E(a1)
		move.b	#7,$1F(a1)
		move.b	#2,anim(a1)
		move.b	#$46,mapping_frame(a1)	; $96
		bset	#2,$2A(a1)
		bclr	#4,$2A(a1)
		move.b	#0,$27(a1)
		bclr	#3,$2A(a1)
		move.w	#0,$42(a1)
		bra.w	loc_3AC26
; ---------------------------------------------------------------------------

loc_3AB24:
		clr.b	$2E(a1)
		clr.b	(a2)
		move.b	#$3C,2(a2)
		bclr	#3,$2A(a1)
		move.w	#0,$42(a1)
		rts
; ---------------------------------------------------------------------------

loc_3AB3E:
		tst.b	4(a2)
		bne.s	loc_3ABBE

loc_3AB44:
		move.w	$3E(a0),d2
		subi.w	#$10,d2
		btst	#$A,d0
		beq.s	loc_3AB70
		bset	#0,$2A(a1)
		move.w	$10(a1),d1
		sub.w	$10(a0),d1
		add.w	d2,d1
		beq.s	loc_3AB70
		move.b	#4,4(a2)
		move.b	#1,2(a2)

loc_3AB70:
		btst	#$B,d0
		beq.s	loc_3AB9A
		bclr	#0,$2A(a1)
		move.w	$10(a1),d1
		sub.w	$10(a0),d1
		add.w	d2,d1
		add.w	d2,d2
		cmp.w	d2,d1
		beq.w	loc_3AB9A
		move.b	#4,4(a2)
		move.b	#0,2(a2)

loc_3AB9A:
		move.b	$2A(a1),d0
		andi.b	#1,d0
		andi.b	#-4,4(a1)
		or.b	d0,4(a1)
		move.w	$14(a0),$14(a1)
		addi.w	#$12,$14(a1)
		tst.b	4(a2)
		beq.s	loc_3AC26

loc_3ABBE:
		subq.b	#1,6(a2)
		bpl.s	loc_3AC26
		move.b	#7,6(a2)
		move.b	#0,anim(a1)
		moveq	#0,d1
		move.b	4(a2),d1
		cmpi.b	#2,d1
		bne.s	loc_3ABE4
		sfx	sfx_Grab

loc_3ABE4:
		subq.w	#1,d1
		bne.s	loc_3ABEE
		move.b	#$14,anim(a1)

loc_3ABEE:
		add.b	8(a2),d1
		move.b	RawAni_3AC38(pc,d1.w),mapping_frame(a1)
		move.b	byte_3AC40(pc,d1.w),d1
		ext.w	d1
		tst.b	2(a2)
		beq.s	loc_3AC06
		neg.w	d1

loc_3AC06:
		add.w	d1,$10(a1)
		subq.b	#1,4(a2)
		bne.s	loc_3AC26
		bsr.s	sub_3AC48
		move.b	#0,6(a2)
		bchg	#2,8(a2)
		andi.w	#$C00,d0
		bne.w	loc_3AB44

loc_3AC26:
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.l	a2,-(sp)
		jsr	(Sonic_Load_PLC2).l
		movea.l	(sp)+,a2
		rts
; End of function sub_3AA7E
; ---------------------------------------------------------------------------

RawAni_3AC38:	dc.b  $88, $83, $82, $87, $88, $86, $85, $84
byte_3AC40:		dc.b    4,  $C,  $A,   6,   4,  $C,  $C,   4

; =============== S U B R O U T I N E =======================================

sub_3AC48:
		btst	#6,$2C(a0)
		beq.s	locret_3AC84
		move.w	$3E(a0),d2
		subi.w	#$10,d2
		btst	#0,$2A(a0)
		beq.s	loc_3AC70
		move.w	$10(a1),d1
		sub.w	$10(a0),d1
		add.w	d2,d1
		bne.s	locret_3AC84
		bra.w	loc_3AB24
; ---------------------------------------------------------------------------

loc_3AC70:
		move.w	$10(a1),d1
		sub.w	$10(a0),d1
		add.w	d2,d1
		add.w	d2,d2
		cmp.w	d2,d1
		bne.s	locret_3AC84
		bra.w	loc_3AB24
; ---------------------------------------------------------------------------

locret_3AC84:
		rts
; End of function sub_3AC48
; ---------------------------------------------------------------------------

loc_3AC86:
		tst.b	2(a2)
		beq.s	loc_3AC94
		subq.b	#1,2(a2)
		bne.w	locret_3AD88

loc_3AC94:
		move.w	$3E(a0),d2
		move.w	$10(a1),d0
		sub.w	$10(a0),d0
		add.w	d2,d0
		add.w	d2,d2
		cmp.w	d2,d0
		bhs.w	locret_3AD88
		move.w	$14(a1),d1
		sub.w	$14(a0),d1
		cmpi.w	#$18,d1
		bhs.w	locret_3AD88
		tst.b	$2E(a1)
		bmi.w	locret_3AD88
		cmpi.b	#4,5(a1)
		bhs.w	locret_3AD88
		tst.w	(Debug_placement_mode).w
		bne.w	locret_3AD88
		btst	#3,$2A(a1)
		beq.s	loc_3ACEA
		movea.w	$42(a1),a3
		cmpi.l	#loc_3A84C,(a3)
		beq.w	locret_3AD88

loc_3ACEA:
		andi.w	#-$20,d0
		btst	#6,$2C(a0)
		beq.s	loc_3AD10
		btst	#0,$2A(a0)
		beq.s	loc_3AD06
		tst.w	d0
		beq.w	locret_3AD88
		bra.s	loc_3AD10
; ---------------------------------------------------------------------------

loc_3AD06:
		subi.w	#$20,d2
		cmp.w	d2,d0
		beq.w	locret_3AD88

loc_3AD10:
		addi.w	#$10,d0
		sub.w	$3E(a0),d0
		add.w	$10(a0),d0
		move.w	d0,$10(a1)
		move.w	a0,$42(a1)
		bset	#3,$2A(a1)
		clr.w	$18(a1)
		clr.w	$1A(a1)
		clr.w	$1C(a1)
		move.w	$14(a0),$14(a1)
		addi.w	#$12,$14(a1)
		move.b	#$14,anim(a1)
		move.b	#3,$2E(a1)
		andi.b	#-3,4(a1)
		move.b	#1,(a2)
		move.b	#0,2(a2)
		move.b	#0,4(a2)
		move.b	#0,6(a2)
		move.b	#$88,mapping_frame(a1)	; $91
		moveq	#0,d0
		move.b	mapping_frame(a1),d0
		move.l	a2,-(sp)
		jsr	(Sonic_Load_PLC2).l
		movea.l	(sp)+,a2
		sfx	sfx_Grab

locret_3AD88:
		rts
; ---------------------------------------------------------------------------

		include "Objects/ChainLink/Object data/Map - Chain Link.asm"

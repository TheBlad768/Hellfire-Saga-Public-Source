
; =============== S U B R O U T I N E =======================================

Obj_Spring:
		move.l	#Map_Spring,$C(a0)
		move.w	#$500,$A(a0)	; set red
		ori.b	#4,4(a0)
		move.b	#$10,7(a0)
		move.b	#$10,6(a0)
		move.w	#$200,8(a0)
		move.w	$10(a0),$32(a0)
		move.w	$14(a0),$34(a0)
		move.b	$2C(a0),d0
		lsr.w	#3,d0
		andi.w	#$E,d0
		move.w	off_22D4A(pc,d0.w),d0
		jmp	off_22D4A(pc,d0.w)
; End of function Obj_Spring
; ---------------------------------------------------------------------------

off_22D4A: offsetTable
		offsetTableEntry.w loc_22E8E
		offsetTableEntry.w loc_22DB0
		offsetTableEntry.w loc_22DEE
		offsetTableEntry.w loc_22E28
		offsetTableEntry.w loc_22E58
; ---------------------------------------------------------------------------

loc_22DB0:
		move.b	#2,$20(a0)
		move.b	#3,$22(a0)
		move.w	#$50C,$A(a0)	; set yellow
		move.b	#8,7(a0)
		move.l	#loc_23050,(a0)
		bra.s	loc_22EC4
; ---------------------------------------------------------------------------

loc_22DEE:
	;	tst.b	(Reverse_gravity_flag).w
	;	bne.s	loc_22E96
		bset	#1,$2A(a0)

loc_22DFC:
		move.l	#loc_23326,(a0)
		move.b	#6,$22(a0)
		bra.s	loc_22EC4
; ---------------------------------------------------------------------------

loc_22E28:
		move.b	#4,$20(a0)
		move.b	#7,$22(a0)
		move.w	#$4D8,$A(a0)	; set diagonal
		move.l	#loc_23490,(a0)
		bra.s	loc_22EC4
; ---------------------------------------------------------------------------

loc_22E58:
		move.b	#4,$20(a0)
		move.b	#$A,$22(a0)
		move.w	#$4D8,$A(a0)	; set diagonal
		bset	#1,$2A(a0)
		move.l	#loc_235D2,(a0)
		bra.s	loc_22EC4
; ---------------------------------------------------------------------------

loc_22E8E:
;		tst.b	(Reverse_gravity_flag).w
;		bne.s	loc_22DFC

loc_22E96:
		move.l	#loc_22EF4,(a0)

loc_22EC4:
		move.b	$2C(a0),d0
		andi.w	#2,d0
		move.w	word_22EF0(pc,d0.w),$30(a0)
		btst	#1,d0
		beq.s	locret_22EEE
		move.l	#Map_Spring2,$C(a0)	; set yellow

locret_22EEE:
		rts
; ---------------------------------------------------------------------------

word_22EF0:
		dc.w -$1000
		dc.w -$A00
; ---------------------------------------------------------------------------

loc_22EF4:
		tst.b	GravityAngle.w			; NAT: Check if reversed flag is set
		bmi.w	loc_23326.rev			; if not, handle collision slightly differently

.rev
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#$10,d3
		move.w	$10(a0),d4
		lea	(Player_1).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		jsr	(SolidObjectTop_1P).w
		btst	#3,$2A(a0)
		beq.s	loc_22F1C
		bsr.s	sub_22F98

loc_22F1C:
		movem.l	(sp)+,d1-d4
		lea	Ani_Spring(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_22F98:
		move.w	#$100,$20(a0)
		addq.w	#8,$14(a1)
		tst.b	GravityAngle.w
		bpl.s	loc_22FAE
		subi.w	#$10,$14(a1)

loc_22FAE:
		move.w	$30(a0),$1A(a1)
		bset	#1,$2A(a1)
		bclr	#3,$2A(a1)
		clr.b	$40(a1)
		clr.b	$3D(a1)
		move.b	#$10,$20(a1)
		move.b	#2,5(a1)
		move.b	$2C(a0),d0
		bpl.s	loc_22FE0
		move.w	#0,$18(a1)

loc_22FE0:
		btst	#0,d0
		beq.s	loc_23020
		move.w	#1,$1C(a1)
		move.b	#1,$27(a1)
		move.b	#0,$20(a1)
		move.b	#0,$30(a1)
		move.b	#4,$31(a1)
		btst	#1,d0
		bne.s	loc_23010
		move.b	#1,$30(a1)

loc_23010:
		btst	#0,$2A(a1)
		beq.s	loc_23020
		neg.b	$27(a1)
		neg.w	$1C(a1)

loc_23020:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_23036
		move.b	#$C,$46(a1)
		move.b	#$D,$47(a1)

loc_23036:
		cmpi.b	#8,d0
		bne.s	loc_23048
		move.b	#$E,$46(a1)
		move.b	#$F,$47(a1)

loc_23048:
		sfx	sfx_Spring
		rts
; End of function sub_22F98
; ---------------------------------------------------------------------------

loc_23050:
		move.w	#$13,d1
		move.w	#$E,d2
		move.w	#$F,d3
		move.w	$10(a0),d4
		lea	(Player_1).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		jsr	(SolidObjectFull2_1P).w
		swap	d6
		andi.w	#1,d6
		beq.s	loc_23092
		move.b	$2A(a0),d1
		move.w	$10(a0),d0
		sub.w	$10(a1),d0
		bcs.s	loc_23088
		eori.b	#1,d1

loc_23088:
		andi.b	#1,d1
		bne.s	loc_23092
		bsr.s	sub_23190

loc_23092:
		movem.l	(sp)+,d1-d4
		bsr.w	sub_2326C
		lea	Ani_Spring(pc),a1
		jsr	(Animate_Sprite).w
		move.w	$32(a0),d0
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_23190:
		move.w	#$300,$20(a0)
		move.w	$30(a0),$18(a1)
		addq.w	#8,$10(a1)
		bset	#0,$2A(a1)
		btst	#0,$2A(a0)
		bne.s	loc_231BE
		bclr	#0,$2A(a1)
		subi.w	#$10,$10(a1)
		neg.w	$18(a1)

loc_231BE:
		move.w	#$F,$32(a1)
		move.w	$18(a1),$1C(a1)
		btst	#2,$2A(a1)
		bne.s	loc_231D8
		move.b	#0,$20(a1)

loc_231D8:
		move.b	$2C(a0),d0
		bpl.s	loc_231E4
		move.w	#0,$1A(a1)

loc_231E4:
		btst	#0,d0
		beq.s	loc_23224
		move.w	#1,$1C(a1)
		move.b	#1,$27(a1)
		move.b	#0,$20(a1)
		move.b	#1,$30(a1)
		move.b	#8,$31(a1)
		btst	#1,d0
		bne.s	loc_23214
		move.b	#3,$30(a1)

loc_23214:
		btst	#0,$2A(a1)
		beq.s	loc_23224
		neg.b	$27(a1)
		neg.w	$1C(a1)

loc_23224:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_2323A
		move.b	#$C,$46(a1)
		move.b	#$D,$47(a1)

loc_2323A:
		cmpi.b	#8,d0
		bne.s	loc_2324C
		move.b	#$E,$46(a1)
		move.b	#$F,$47(a1)

loc_2324C:
		bclr	#5,$2A(a0)
		bclr	#6,$2A(a0)
		bclr	#5,$2A(a1)
		move.b	#0,$2F(a1)
		sfx	sfx_Spring
		rts
; End of function sub_23190

; =============== S U B R O U T I N E =======================================

sub_2326C:
		cmpi.b	#3,$20(a0)
		beq.s	locret_23324
		move.w	$10(a0),d0
		move.w	d0,d1
		addi.w	#$28,d1
		btst	#0,$2A(a0)
		beq.s	loc_2328E
		move.w	d0,d1
		subi.w	#$28,d0

loc_2328E:
		move.w	$14(a0),d2
		move.w	d2,d3
		subi.w	#$18,d2
		addi.w	#$18,d3
		lea	(Player_1).w,a1
		btst	#1,$2A(a1)
		bne.s	locret_23324
		move.w	$1C(a1),d4
		btst	#0,$2A(a0)
		beq.s	loc_232B6
		neg.w	d4

loc_232B6:
		tst.w	d4
		bmi.s	locret_23324
		move.w	$10(a1),d4
		cmp.w	d0,d4
		blo.s	locret_23324
		cmp.w	d1,d4
		bhs.s	locret_23324
		move.w	$14(a1),d4
		cmp.w	d2,d4
		blo.s	locret_23324
		cmp.w	d3,d4
		bhs.s	locret_23324
		move.w	d0,-(sp)
		bsr.w	sub_23190
		move.w	(sp)+,d0

locret_23324:
		rts
; End of function sub_2326C
; ---------------------------------------------------------------------------

loc_23326:
		tst.b	GravityAngle.w			; NAT: Check if reversed flag is set
		bmi.w	loc_22EF4.rev			; if not, handle collision slightly differently

.rev
		move.w	#$1B,d1
		move.w	#8,d2
		move.w	#9,d3
		move.w	$10(a0),d4
		lea	(Player_1).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		jsr	(SolidObjectFull2_1P).w
		cmpi.w	#-2,d4
		bne.s	loc_2334C
		bsr.s	sub_233CA

loc_2334C:
		movem.l	(sp)+,d1-d4
		lea	Ani_Spring(pc),a1
		jsr	(Animate_Sprite).w
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_233CA:
		subq.w	#8,$14(a1)
		tst.b	GravityAngle.w
		bpl.s	loc_233DA
		addi.w	#$10,$14(a1)

loc_233DA:
		move.w	#$100,$20(a0)
		move.w	$30(a0),$1A(a1)
		neg.w	$1A(a1)
		cmpi.w	#$1000,$1A(a1)
		bne.s	loc_233F8
		move.w	#$D00,$1A(a1)

loc_233F8:
		move.b	$2C(a0),d0
		bpl.s	loc_23404
		move.w	#0,$18(a1)

loc_23404:
		btst	#0,d0
		beq.s	loc_23444
		move.w	#1,$1C(a1)
		move.b	#1,$27(a1)
		move.b	#0,$20(a1)
		move.b	#0,$30(a1)
		move.b	#4,$31(a1)
		btst	#1,d0
		bne.s	loc_23434
		move.b	#1,$30(a1)

loc_23434:
		btst	#0,$2A(a1)
		beq.s	loc_23444
		neg.b	$27(a1)
		neg.w	$1C(a1)

loc_23444:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_2345A
		move.b	#$C,$46(a1)
		move.b	#$D,$47(a1)

loc_2345A:
		cmpi.b	#8,d0
		bne.s	loc_2346C
		move.b	#$E,$46(a1)
		move.b	#$F,$47(a1)

loc_2346C:
		bset	#1,$2A(a1)
		bclr	#3,$2A(a1)
		clr.b	$40(a1)
		move.b	#2,5(a1)
		move.b	#0,$2F(a1)
		sfx	sfx_Spring
		rts
; End of function sub_233CA
; ---------------------------------------------------------------------------

loc_23490:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	$10(a0),d4
		lea	byte_236EA(pc),a2
		lea	(Player_1).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		jsr	(sub_1DD24).w
		btst	#3,$2A(a0)
		beq.s	loc_234B8
		bsr.s	sub_234E6

loc_234B8:
		movem.l	(sp)+,d1-d4
		lea	Ani_Spring(pc),a1
		jsr	(Animate_Sprite).w
		move.w	$32(a0),d0
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_234E6:
		btst	#0,$2A(a0)
		bne.s	loc_234FC
		move.w	$10(a0),d0
		subq.w	#4,d0
		cmp.w	$10(a1),d0
		blo.s	loc_2350A
		rts
; ---------------------------------------------------------------------------

loc_234FC:
		move.w	$10(a0),d0
		addq.w	#4,d0
		cmp.w	$10(a1),d0
		bhs.s	loc_2350A
		rts
; ---------------------------------------------------------------------------

loc_2350A:
		move.w	#$500,$20(a0)
		move.w	$30(a0),$1A(a1)
		move.w	$30(a0),$18(a1)
		addq.w	#6,$14(a1)
		addq.w	#6,$10(a1)
		bset	#0,$2A(a1)
		btst	#0,$2A(a0)
		bne.s	loc_23542
		bclr	#0,$2A(a1)
		subi.w	#$C,$10(a1)
		neg.w	$18(a1)

loc_23542:
		bset	#1,$2A(a1)
		bclr	#3,$2A(a1)
		clr.b	$40(a1)
		move.b	#$10,$20(a1)
		move.b	#2,5(a1)
		move.b	$2C(a0),d0
		btst	#0,d0
		beq.s	loc_235A2
		move.w	#1,$1C(a1)
		move.b	#1,$27(a1)
		move.b	#0,$20(a1)
		move.b	#1,$30(a1)
		move.b	#8,$31(a1)
		btst	#1,d0
		bne.s	loc_23592
		move.b	#3,$30(a1)

loc_23592:
		btst	#0,$2A(a1)
		beq.s	loc_235A2
		neg.b	$27(a1)
		neg.w	$1C(a1)

loc_235A2:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_235B8
		move.b	#$C,$46(a1)
		move.b	#$D,$47(a1)

loc_235B8:
		cmpi.b	#8,d0
		bne.s	loc_235CA
		move.b	#$E,$46(a1)
		move.b	#$F,$47(a1)

loc_235CA:
		sfx	sfx_Spring
		rts
; End of function sub_234E6
; ---------------------------------------------------------------------------

loc_235D2:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	$10(a0),d4
		lea	byte_23706(pc),a2
		lea	(Player_1).w,a1
		moveq	#3,d6
		movem.l	d1-d4,-(sp)
		jsr	(sub_1DD24).w
		cmpi.w	#-2,d4
		bne.s	loc_235F8
		bsr.s	sub_23624

loc_235F8:
		movem.l	(sp)+,d1-d4
		lea	Ani_Spring(pc),a1
		jsr	(Animate_Sprite).w
		move.w	$32(a0),d0
		jmp	(Sprite_OnScreen_Test2).w

; =============== S U B R O U T I N E =======================================

sub_23624:
		move.w	#$500,$20(a0)
		move.w	$30(a0),$1A(a1)
		neg.w	$1A(a1)
		move.w	$30(a0),$18(a1)
		subq.w	#6,$14(a1)
		addq.w	#6,$10(a1)
		bset	#0,$2A(a1)
		btst	#0,$2A(a0)
		bne.s	loc_23660
		bclr	#0,$2A(a1)
		subi.w	#$C,$10(a1)
		neg.w	$18(a1)

loc_23660:
		bset	#1,$2A(a1)
		bclr	#3,$2A(a1)
		clr.b	$40(a1)
		move.b	#2,5(a1)
		move.b	$2C(a0),d0
		btst	#0,d0
		beq.s	loc_236BA
		move.w	#1,$1C(a1)
		move.b	#1,$27(a1)
		move.b	#0,$20(a1)
		move.b	#1,$30(a1)
		move.b	#8,$31(a1)
		btst	#1,d0
		bne.s	loc_236AA
		move.b	#3,$30(a1)

loc_236AA:
		btst	#0,$2A(a1)
		beq.s	loc_236BA
		neg.b	$27(a1)
		neg.w	$1C(a1)

loc_236BA:
		andi.b	#$C,d0
		cmpi.b	#4,d0
		bne.s	loc_236D0
		move.b	#$C,$46(a1)
		move.b	#$D,$47(a1)

loc_236D0:
		cmpi.b	#8,d0
		bne.s	loc_236E2
		move.b	#$E,$46(a1)
		move.b	#$F,$47(a1)

loc_236E2:
		sfx	sfx_Spring
		rts
; End of function sub_23624
; ---------------------------------------------------------------------------

byte_236EA:
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $E
		dc.b $C
		dc.b $A
		dc.b 8
		dc.b 6
		dc.b 4
		dc.b 2
		dc.b 0
		dc.b $FE
		dc.b $FC
		dc.b $FC
		dc.b $FC
		dc.b $FC
		dc.b $FC
		dc.b $FC
		dc.b $FC
byte_23706:
		dc.b $F4
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F0
		dc.b $F2
		dc.b $F4
		dc.b $F6
		dc.b $F8
		dc.b $FA
		dc.b $FC
		dc.b $FE
		dc.b 0
		dc.b 2
		dc.b 4
		dc.b 4
		dc.b 4
		dc.b 4
		dc.b 4
		dc.b 4
		dc.b 4
; ---------------------------------------------------------------------------

		include "Objects/Spring/Object data/Anim - Spring.asm"
		include "Objects/Spring/Object data/Map - Spring(Red).asm"
		include "Objects/Spring/Object data/Map - Spring(Yellow).asm"

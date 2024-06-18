
; =============== S U B R O U T I N E =======================================

Obj_HCZHandLauncher:
		ori.b	#4,4(a0)
		move.w	#$200,8(a0)
		move.l	#Map_HCZHandLauncher,$C(a0)
		move.w	#$23B0,$A(a0)
		move.b	#$20,7(a0)
		move.b	#$40,6(a0)
		move.w	$14(a0),$32(a0)
		move.b	#6,$22(a0)
		move.w	#$50,$30(a0)
		bset	#7,$2A(a0)
		jsr	(Create_New_Sprite3).w
		bne.s	loc_30B52
		move.l	#loc_30DEC,(a1)
		move.l	#Map_HCZHandLauncher,$C(a1)
		move.w	#$23B0,$A(a1)
		move.b	4(a0),4(a1)
		move.b	#$20,7(a1)
		move.b	#$30,7(a1)
		move.w	#$280,8(a1)
		move.w	$10(a0),$10(a1)
		move.w	$14(a0),$14(a1)
		move.w	a0,$3C(a1)

loc_30B52:
		move.l	#loc_30B58,(a0)

loc_30B58:
		btst	#Status_InAir,(Player_1+status).w
		bne.s	loc_30BD6
		move.w	$10(a0),d1
		subi.w	#$20,d1
		move.w	(Player_1+x_pos).w,d0
		sub.w	d1,d0
		cmpi.w	#$40,d0
		blo.s		loc_30B78
		bra.s	loc_30BD6

;		move.w	(Player_2+x_pos).w,d0
;		sub.w	d1,d0
;		cmpi.w	#$40,d0
;		bhs.s	loc_30BD6

loc_30B78:
		tst.b	$34(a0)
		beq.s	loc_30BB0
		move.b	#7,$22(a0)
		move.w	#$80,8(a0)
		tst.w	$36(a0)
		beq.s	loc_30B96
		subq.w	#1,$36(a0)
		bra.s	loc_30BD0
; ---------------------------------------------------------------------------

loc_30B96:
		tst.w	$30(a0)
		beq.s	loc_30BA2
		subq.w	#8,$30(a0)
		bra.s	loc_30BD0
; ---------------------------------------------------------------------------

loc_30BA2:
		move.l	#loc_30C06,(a0)
		move.w	#$3B,$36(a0)
		bra.s	loc_30BD0
; ---------------------------------------------------------------------------

loc_30BB0:
		move.w	#$13,$36(a0)
		move.b	#6,$22(a0)
		move.w	#$200,8(a0)
		cmpi.w	#$18,$30(a0)
		bls.s	loc_30BD0
		subq.w	#8,$30(a0)
		bra.s	loc_30BE2
; ---------------------------------------------------------------------------

loc_30BD0:
		bsr.w	sub_30CE0
		bra.s	loc_30BE2
; ---------------------------------------------------------------------------

loc_30BD6:
		cmpi.w	#$50,$30(a0)
		beq.s	loc_30BE2
		addq.w	#8,$30(a0)

loc_30BE2:
		move.w	$30(a0),d0
		add.w	$32(a0),d0
		move.w	d0,$14(a0)
		move.w	#$20,d1
		move.w	#$11,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectTop).w
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

loc_30C06:
		tst.w	$36(a0)
		beq.s	loc_30C16
		subq.w	#1,$36(a0)
		bsr.w	sub_30CE0
		bra.s	loc_30C50
; ---------------------------------------------------------------------------

loc_30C16:
		cmpi.w	#$50,$30(a0)
		bne.s	loc_30C34
		move.b	#0,$34(a0)
		move.l	#loc_30B58,(a0)
		sfx	sfx_Teleport
		bra.s	loc_30C50
; ---------------------------------------------------------------------------

loc_30C34:
		cmpi.w	#$18,$30(a0)
		bne.s	loc_30C4C
		bsr.w	sub_30C7C
		move.b	#6,$22(a0)
		move.w	#$200,8(a0)

loc_30C4C:
		addq.w	#8,$30(a0)

loc_30C50:
		move.w	$30(a0),d0
		add.w	$32(a0),d0
		move.w	d0,$14(a0)
		cmpi.w	#$18,$30(a0)
		bhi.s	loc_30C76
		move.w	#$20,d1
		move.w	#$11,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectTop).w

loc_30C76:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

sub_30C7C:
		lea	(Player_1).w,a1
		moveq	#3,d6

;		bsr.w	sub_30C8C
;		lea	(Player_2).w,a1
;		moveq	#4,d6
; End of function sub_30C7C

; =============== S U B R O U T I N E =======================================

sub_30C8C:
		bclr	d6,$35(a0)
		beq.s	loc_30CCC
		move.w	#$1000,$1C(a1)
		move.w	#$1000,$18(a1)
		move.w	#0,$1A(a1)
		btst	#0,$2A(a0)
		beq.s	loc_30CB4
		neg.w	$1C(a1)
		neg.w	$18(a1)

loc_30CB4:
		move.b	#0,$20(a1)
		move.b	#0,$2E(a1)
		bclr	#3,$2A(a1)
		bclr	d6,$2A(a0)
		rts
; ---------------------------------------------------------------------------

loc_30CCC:
		bclr	d6,$2A(a0)
		beq.s	locret_30CDE
		bclr	#3,$2A(a1)
		bset	#1,$2A(a1)

locret_30CDE:
		rts
; End of function sub_30C8C

; =============== S U B R O U T I N E =======================================

sub_30CE0:
		lea	(Player_1).w,a1
		moveq	#3,d6
		move.b	(Ctrl_1_pressed_logical).w,d0

;		bsr.w	sub_30CF8
;		lea	(Player_2).w,a1
;		moveq	#4,d6
;		move.b	(Ctrl_2_pressed_logical).w,d0
; End of function sub_30CE0

; =============== S U B R O U T I N E =======================================

sub_30CF8:
		btst	d6,$35(a0)
		beq.s	loc_30D4E
		andi.b	#$70,d0
		beq.s	locret_30D4C
		bclr	d6,$35(a0)
		bclr	d6,$2A(a0)
		move.w	#$800,$1C(a1)
		move.w	#$800,$18(a1)
		move.w	#-$400,$1A(a1)
		btst	#0,$2A(a0)
		beq.s	loc_30D2E
		neg.w	$1C(a1)
		neg.w	$18(a1)

loc_30D2E:
		move.b	#0,$2E(a1)
		bclr	#3,$2A(a1)
		bset	#1,$2A(a1)
		tst.b	$35(a0)
		bne.s	locret_30D4C
		move.b	#0,$34(a0)

locret_30D4C:
		rts
; ---------------------------------------------------------------------------

loc_30D4E:
		btst	d6,$2A(a0)
		beq.w	locret_30DEA
		tst.b	$34(a0)
		bne.s	loc_30D6E
		move.w	$10(a1),d0
		addi.w	#8,d0
		sub.w	$10(a0),d0
		cmpi.w	#$10,d0
		bhs.s	locret_30DEA

loc_30D6E:
		tst.b	$2E(a1)
		bne.s	locret_30DEA
		tst.w	(Debug_placement_mode).w
		bne.s	locret_30DEA
		bset	d6,$35(a0)
		sfx	sfx_Roll
		move.b	#0,$20(a1)
		move.b	#$13,$1E(a1)
		move.b	#9,$1F(a1)
		bclr	#2,$2A(a1)

;		cmpi.l	#Obj_Tails,address(a1)
;		bne.s	loc_30DAC
;		move.b	#$F,$1E(a1)

loc_30DAC:
		move.b	#1,$2E(a1)
		bclr	#5,$2A(a1)
		move.w	$10(a0),$10(a1)
		subq.w	#2,$10(a1)
		move.w	#$1000,$1C(a1)
		bclr	#0,$2A(a1)
		btst	#0,$2A(a0)
		beq.s	loc_30DE4
		addq.w	#4,$10(a1)
		neg.w	$1C(a1)
		bset	#0,$2A(a1)

loc_30DE4:
		move.b	#1,$34(a0)

locret_30DEA:
		rts
; End of function sub_30CF8
; ---------------------------------------------------------------------------

loc_30DEC:
		movea.w	$3C(a0),a1
		move.w	$14(a1),$14(a0)
		cmpi.w	#$18,$30(a1)
		bls.s		loc_30E00
		rts
; ---------------------------------------------------------------------------

loc_30E00:
		addq.b	#1,$22(a0)
		cmpi.b	#6,$22(a0)
		blo.s		loc_30E12
		move.b	#0,$22(a0)

loc_30E12:
		jmp	(Sprite_OnScreen_Test).w
; ---------------------------------------------------------------------------

		include "Objects/HandLauncher/Object data/Map - Hand Launcher.asm"
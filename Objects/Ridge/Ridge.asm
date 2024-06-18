
; =============== S U B R O U T I N E =======================================

Obj_Ridge:
		lea	(Player_1).w,a1
		bsr.s	sub_24D9A
		move.w	$10(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_24D88
		rts
; ---------------------------------------------------------------------------

loc_24D88:
		move.w	respawn_addr(a0),d0
		beq.s	loc_24D94
		movea.w	d0,a2
		bclr	#7,(a2)

loc_24D94:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_24D9A:
		btst	#1,$2A(a1)
		bne.w	locret_24E32
		move.w	$10(a1),d0
		addi.w	#$10,d0
		sub.w	$10(a0),d0
		bcs.w	locret_24E32
		cmpi.w	#$20,d0
		bge.w	locret_24E32
		move.w	$14(a1),d0
		sub.w	$14(a0),d0
		cmpi.w	#-$14,d0
		blt.s	locret_24E32
		cmpi.w	#$20,d0
		bgt.s	locret_24E32
		tst.b	$2E(a1)
		bne.s	locret_24E32
		btst	#0,$2A(a0)
		bne.s	loc_24DEE
		cmpi.w	#$400,$18(a1)
		blt.s	locret_24E32
		addi.w	#$400,$18(a1)
		bra.s	loc_24DFC
; ---------------------------------------------------------------------------

loc_24DEE:
		cmpi.w	#-$400,$18(a1)
		bgt.s	locret_24E32
		subi.w	#$400,$18(a1)

loc_24DFC:
		move.w	#-$700,$1A(a1)
		bset	#1,$2A(a1)
		move.b	#2,5(a1)
		move.w	#1,$1C(a1)
		move.b	#1,$27(a1)
		move.b	#0,$20(a1)
		move.b	#0,$30(a1)
		move.b	#4,$31(a1)
		move.b	#5,$2D(a1)

locret_24E32:
		rts
; End of function sub_24D9A

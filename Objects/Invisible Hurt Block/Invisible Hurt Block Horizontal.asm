; ---------------------------------------------------------------------------
; Invisible horizontal shock block (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_InvisibleShockBlock:
		bset	#Status_LtngShield,shield_reaction(a0)
		bra.s	Obj_InvisibleHurtBlockHorizontal

; ---------------------------------------------------------------------------
; Invisible horizontal lava block (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_InvisibleLavaBlock:
		bset	#Status_FireShield,shield_reaction(a0)

; ---------------------------------------------------------------------------
; Invisible horizontal hurt block (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_InvisibleHurtBlockHorizontal:
		move.l	#Map_InvisibleBlock,$C(a0)
		move.w	#make_art_tile(ArtTile_Powerups,0,1),art_tile(a0)
		ori.b	#4,4(a0)
		move.w	#$200,8(a0)
		bset	#7,$2A(a0)
		move.b	$2C(a0),d0
		move.b	d0,d1
		andi.w	#$F0,d0
		addi.w	#$10,d0
		lsr.w	#1,d0
		move.b	d0,7(a0)
		andi.w	#$F,d1
		addq.w	#1,d1
		lsl.w	#3,d1
		addq.w  #$4,d1
		move.b	d1,6(a0)
		btst	#0,$2A(a0) ; object flipping
		beq.s	loc_1F448
		move.l	#loc_1F4C4,(a0)
		rts
; ---------------------------------------------------------------------------

loc_1F448:
		btst	#1,$2A(a0) ; is object vertical
		beq.s	loc_1F458  ; branch
		move.l	#loc_1F528,(a0)

locret_1F456:
		rts
; ---------------------------------------------------------------------------

loc_1F458:
		move.l	#loc_1F45E,(a0)

loc_1F45E:
		moveq	#0,d1
		move.b	7(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	6(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectFull2).w
		move.b	$2A(a0),d6
		andi.b	#$18,d6
		beq.s	loc_1F4A2
		move.b	d6,d0
		andi.b	#8,d0
		beq.s	loc_1F4A2
		lea	(Player_1).w,a1
		bsr.w	sub_1F58C

loc_1F4A2:
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1EBAA
		tst.w	(Debug_placement_mode).w
		beq.s	locret_1F456
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_1F4C4:
		moveq	#0,d1
		move.b	7(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	6(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectFull2).w
		swap	d6
		andi.w	#3,d6
		beq.s	loc_1F506
		move.b	d6,d0
		andi.b	#1,d0
		beq.s	loc_1F506
		lea	(Player_1).w,a1
		bsr.w	sub_1F58C

loc_1F506:
		move.w	$10(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1EBAA
		tst.w	(Debug_placement_mode).w
		beq.s	locret_1F59E
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_1F528:
		moveq	#0,d1
		move.b	7(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	6(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	$10(a0),d4
		jsr	(SolidObjectFull2).w
		swap	d6
		andi.w	#$C,d6
		beq.s	loc_1F56A
		move.b	d6,d0
		andi.b	#4,d0
		beq.s	loc_1F56A
		lea	(Player_1).w,a1
		bsr.w	sub_1F58C

loc_1F56A:
		move.w	$10(a0),d0
		andi.w	#$FF80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	loc_1EBAA
		tst.w	(Debug_placement_mode).w
		beq.s	locret_1F59E
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_1F58C:
		move.b	$2B(a0),d0
		andi.b	#$73,d0
		and.b	$2B(a1),d0
		bne.s	locret_1F59E

		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
                bne.s	locret_1F59E				; If so, branch

		bsr.w	sub_24280				; if not, branch

locret_1F59E:
		rts

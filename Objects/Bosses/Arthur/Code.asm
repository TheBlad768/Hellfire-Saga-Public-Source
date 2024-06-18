; ---------------------------------------------------------------------------
; Demonic Sir Arthur, FDZ1 mini-boss
; ---------------------------------------------------------------------------

Obj_Arthur:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Arthur_Index(pc,d0.w),d1
		jsr	Obj_Arthur_Index(pc,d1.w)
		jsr	Obj_Arthur_ShipProcess
		lea	(Ani_Arthur).l,a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_Arthur(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Obj_Arthur_Display).l
; ===========================================================================

Obj_Arthur_Index:
		dc.w Obj_Arthur_Main-Obj_Arthur_Index				; 0
		dc.w Obj_Arthur_DropDown-Obj_Arthur_Index			; 2
		dc.w Obj_Arthur_Stand-Obj_Arthur_Index			; 4
		dc.w Obj_Arthur_RunLeft1-Obj_Arthur_Index			; 6
		dc.w Obj_Arthur_RunLeft2-Obj_Arthur_Index			; 8
		dc.w Obj_Arthur_RunLeft21-Obj_Arthur_Index			; A
		dc.w Obj_Arthur_AttackLeft-Obj_Arthur_Index			; C
		dc.w Obj_Arthur_Stand2-Obj_Arthur_Index			; $E
		dc.w Obj_Arthur_RunRight1-Obj_Arthur_Index			; $10
		dc.w Obj_Arthur_RunRight2-Obj_Arthur_Index			; $12
		dc.w Obj_Arthur_RunRight21-Obj_Arthur_Index			; $14
		dc.w Obj_Arthur_JumpLeft1-Obj_Arthur_Index			; $16
		dc.w Obj_Arthur_JumpLeft2-Obj_Arthur_Index			; $18
		dc.w Obj_Arthur_JumpLeft3-Obj_Arthur_Index			; $1A
		dc.w Obj_Arthur_JumpRight1-Obj_Arthur_Index			; $1C
		dc.w Obj_Arthur_JumpRight2-Obj_Arthur_Index			; $1E
		dc.w Obj_Arthur_JumpRight3-Obj_Arthur_Index			; $20
		dc.w Obj_Arthur_AttackRight-Obj_Arthur_Index			; $22
		dc.w Obj_Arthur_Fin-Obj_Arthur_Index			; $22

; ===========================================================================

Obj_Arthur_Display:
		move.b	$1C(a0),d0
		beq.s	Obj_Arthur_Animate
		lsr.b	#3,d0
		bcc.w	Obj_Arthur_Return

Obj_Arthur_Animate:
		jmp	(Draw_And_Touch_Sprite).w

; ===========================================================================

Obj_Arthur_ShipProcess:
		tst.b	$28(a0)
		bne.s	.lacricium3
		tst.b	$29(a0)
		beq.s	Obj_Arthur_ShipGone
		tst.b	$1C(a0)
		bne.s	.whatizit3
		move.b	#$2C,$1C(a0)
		move.b	#0,obColType(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit3:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash3
		addi.w	#4,d0

.flash3:
		subq.b	#1,$1C(a0)
		bne.s	.lacricium3
		move.b	#$23,obColType(a0)
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)

.lacricium3:
		rts
; ===========================================================================
;loc_1784C:
Obj_Arthur_ShipGone:
		lea	(Player_1).w,a1
		bset	#7,object_control(a1)

		sfx	sfx_Arthur1
		lea	(ArtKosM_Gloamglozer).l,a1
		move.w  #tiles_to_bytes($3A0),d2
		jsr     (Queue_Kos_Module).w

		jsr	(SingleObjLoad2).w
		bne.w	+
		move.l	#Obj_ArmorShard,(a1)
		move.b  #8,obAnim(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w 	#$150,obVelX(a1);
		move.w 	#-$400,obVelY(a1);
		jsr	(SingleObjLoad2).w
		bne.w   +
		move.l	#Obj_ArmorShard,(a1)
		move.b  #7,obAnim(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w 	#-$150,obVelX(a1);
		move.w 	#-$400,obVelY(a1);

		jsr	(SingleObjLoad2).w
		bne.w   +
		move.l	#Obj_ArmorShard,(a1)
		move.b  #9,obAnim(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addq.w  #8,obY(a1)
		move.w 	#$100,obVelX(a1);
		move.w 	#-$300,obVelY(a1);
		jsr	(SingleObjLoad2).w
		bne.w   +
		move.l	#Obj_ArmorShard,(a1)
		move.b  #$A,obAnim(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addq.w  #8,obY(a1)
		move.w 	#-$100,obVelX(a1);
		move.w 	#-$300,obVelY(a1);

+
;		lea	(ArtKosM_DialogueGloam).l,a1
;		move.w	#tiles_to_bytes($540),d2
;		jsr	(Queue_Kos_Module).w

		move.b	#$A,(Dynamic_resize_routine).w
		jsr	(Obj_KillBloodCreate).l
		move.l	#Go_Delete_Sprite,(a0)
;		move.w	#(Obj_Arthur_Fin-Obj_Arthur_ShipIndex),routine(a0)

		tst.b	(Extended_mode).w
		beq.s	.rts
		move.b	#$2E,(Dynamic_resize_routine).w

.rts
		rts
; ===========================================================================

Obj_Arthur_HP:
		dc.b 10/2	; Easy
		dc.b 10		; Normal
		dc.b 10+4	; Hard
		dc.b 10+4	; Maniac

Obj_Arthur_Main:
		lea	ObjDat4_Arthur(pc),a1
		jsr	SetUp_ObjAttributes
		st	$3A(a0)					; set current frame as invalid
  		move.b	#0,obSubtype(a0)
  		move.w  #$1E,obTimer(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	Obj_Arthur_HP(pc,d0.w),$29(a0)

Obj_Arthur_DropDown:
                sub.w   #1,obTimer(a0)
                bpl.w   Obj_Arthur_Stand_Rts
		move.b	#2,obAnim(a0)
		cmpi.b	#1,objoff_48(a0)
		bne.w	+
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$70,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		cmpi.w	#$372,obY(a0)
		blt.w	Obj_Arthur_Return
		move.w	#$372,obY(a0)
		move.w	#45,obTimer(a0)
		move.b	#0,obAnim(a0)
		clr.w	obVelX(a0)
  		move.b	#0,obSubtype(a0)
		move.b	#$E,routine(a0)
		rts

+		move.w	(Camera_min_x_pos).w,d0
		add.w	#$FF,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		cmpi.w	#$372,obY(a0)
		blt.w	Obj_Arthur_Return
		move.w	#$372,obY(a0)
		move.w	#45,obTimer(a0)
		move.b	#0,obAnim(a0)
		clr.w	obVelX(a0)
  		move.b	#0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_Stand:
		cmpi.b	#$C,obAnim(a0)
		beq.w	Obj_Arthur_Return
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Arthur_Return
		jsr	(RandomNumber).w
		andi.b	#3,d0
		beq.s	+
		addq.b	#2,routine(a0)
		bra.s	Obj_Arthur_Stand_Rts
+		move.b	#$16,routine(a0)

Obj_Arthur_Stand_Rts:
		rts

Obj_Arthur_MoveL:
		cmpi.w	#0,objoff_46(a0)
		beq.s	+
		sub.w	#1,objoff_46(a0)
		cmpi.w	#-$300,obVelX(a0)
		blt.s	++
		sub.w	#$30,obVelX(a0)
		bra.s	++
+		add.w	#$A,obVelX(a0)
+		rts

Obj_Arthur_MoveR:
		cmpi.w	#0,objoff_46(a0)
		beq.s	+
		sub.w	#1,objoff_46(a0)
		cmpi.w	#$300,obVelX(a0)
		bcc.s	++
		add.w	#$30,obVelX(a0)
		bra.s	++
+		sub.w	#$A,obVelX(a0)
+		rts

Obj_Arthur_RunLeft1:
		move.b  #1,obAnim(a0)
  		move.b  #1,obSubtype(a0)
		move.w	#60,objoff_46(a0)
		move.w	#0,obVelY(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_RunLeft2:
		jsr	(Obj_Arthur_MoveL).l
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$25,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		bcc.w	Obj_Arthur_Return
		bchg	#0,obStatus(a0)
		move.w  #45,obTimer(a0)
		move.b  #0,obAnim(a0)
  		move.b  #0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_RunLeft21:
		cmpi.b	#$C,obAnim(a0)
		beq.w	Obj_Arthur_Return
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Arthur_Return
		move.w	#20,obTimer(a0)
		move.b	#$D,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		clr.w	obVelX(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_AttackLeft:
		cmpi.b	#3,obAnim(a0)
		bne.w	Obj_Arthur_Stand_Rts2
		jsr	(RandomNumber).w
		andi.b	#3,d0
		cmpi.b	#1,d0
		beq.w	Obj_Arthur_ThrowBomb
		cmpi.b	#2,d0
		beq.w	Obj_Arthur_ThrowAxe

Obj_Arthur_ThrowSpear:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Arthur_RunLeft3
		move.l	#Obj_Spear,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		bchg	#0,obStatus(a1)
		move.w	#$600,obVelX(a1)
		bra.w	Obj_Arthur_RunLeft3

Obj_Arthur_ThrowAxe:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Arthur_RunLeft3
		move.l	#Obj_Axe,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		bchg	#0,obStatus(a1)
		move.w	#$500,obVelX(a1)
		move.w	(Player_1+obY).w,d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a1)
		bchg	#0,obStatus(a1)
		bra.w	Obj_Arthur_RunLeft3

Obj_Arthur_ThrowBomb:
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Arthur_RunLeft3
		move.l	#Obj_Arthur_Firebomb,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent(a1)
		bchg	#0,obStatus(a1)
		move.w	#$300,obVelX(a1)
		move.w	#-$500,obVelY(a1)
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Arthur_RunLeft3
		move.l	#Obj_Arthur_Firebomb,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		bchg	#0,obStatus(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		move.w	#-$400,obVelY(a1)

Obj_Arthur_RunLeft3:
		move.b	#$E,routine(a0)
		sfx	sfx_Arthur2

Obj_Arthur_Stand2:
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Arthur_Return
		jsr	(RandomNumber).w
		andi.b	#3,d0
		beq.s	+
		move.b	#$10,routine(a0)
		bra.s	Obj_Arthur_Stand_Rts2

+		move.b	#$1C,routine(a0)

Obj_Arthur_Stand_Rts2:
		rts

Obj_Arthur_RunRight1:
		clr.w	obVelX(a0)
		addq.b	#2,routine(a0)
		move.b  #1,obAnim(a0)
  		move.b	#1,obSubtype(a0)
		move.w	#60,objoff_46(a0)
		move.w	#0,obVelY(a0)

Obj_Arthur_RunRight2:
		jsr	(Obj_Arthur_MoveR).l
		jsr	(SpeedToPos).w
		move.w	(Camera_min_x_pos).w,d0
		add.w	#$11D,d0
		move.w	obX(a0),d1
		cmp.w	d0,d1
		blt.w	Obj_Arthur_Return
		bchg	#0,obStatus(a0)
		move.w	#45,obTimer(a0)
		move.b	#0,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_RunRight21:
		cmpi.b	#$C,obAnim(a0)
		beq.w	Obj_Arthur_Return
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Arthur_Return
		move.w	#20,obTimer(a0)
		move.b	#$D,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		clr.w	obVelX(a0)
		move.b	#$22,routine(a0)
		sfx	sfx_Arthur2
		bra.w	Obj_Arthur_Return

Obj_Arthur_JumpLeft1:
		addq.b	#2,routine(a0)
		sfx	sfx_Arthur2
		move.b	#2,obAnim(a0)
  		move.b	#2,obSubtype(a0)
		move.w	(Camera_x_pos).w,d0
		add.w	#$43,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		move.w	#-$400,obVelY(a0)

Obj_Arthur_JumpLeft2:
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		cmpi.w	#$372,obY(a0)
		blt.w	Obj_Arthur_Return
		move.w	#$372,obY(a0)
		clr.w	obVelX(a0)
		bchg	#0,obStatus(a0)
		move.w	#45,obTimer(a0)
		move.b	#0,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_JumpLeft3:
		cmpi.b	#$C,obAnim(a0)
		beq.w	Obj_Arthur_Return
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Arthur_Return
		move.w	#20,obTimer(a0)
		move.b	#$D,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		move.b	#$C,routine(a0)		; jump to AttackLeft
		sfx	sfx_Arthur2
		bra.w	Obj_Arthur_Return

Obj_Arthur_JumpRight1:
		addq.b	#2,routine(a0)
+		sfx	sfx_Arthur2
		move.b	#2,obAnim(a0)
  		move.b	#2,obSubtype(a0)
		move.w	(Camera_x_pos).w,d0
		add.w	#$FF,d0
		sub.w	obX(a0),d0
+		asl.w	#2,d0
		move.w	d0,obVelX(a0)
		move.w	#-$400,obVelY(a0)

Obj_Arthur_JumpRight2:
		jsr	(ObjectFall).w
		jsr	(SpeedToPos).w
		cmpi.w	#$372,obY(a0)
		blt.w	Obj_Arthur_Return
		move.w	#$372,obY(a0)
		clr.w	obVelX(a0)
		bchg	#0,obStatus(a0)
		move.w	#20,obTimer(a0)
		move.b	#0,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_JumpRight3:
		cmpi.b	#$C,obAnim(a0)
		beq.w	Obj_Arthur_Return
		subq.w	#1,obTimer(a0)
		bpl.w	Obj_Arthur_Return
		move.w	#45,obTimer(a0)
		move.b	#$D,obAnim(a0)
  		move.b	#0,obSubtype(a0)
		addq.b	#2,routine(a0)

Obj_Arthur_AttackRight:
		cmpi.b	#3,obAnim(a0)
		bne.w	Obj_Arthur_Stand_Rts2
		jsr	(RandomNumber).w
		andi.b	#3,d0
		cmpi.b	#1,d0
		beq.w	Obj_Arthur_ThrowBomb2
		cmpi.b	#2,d0
		beq.w	Obj_Arthur_ThrowAxe2

Obj_Arthur_ThrowSpear2:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Arthur_RunRight3
		move.l	#Obj_Spear,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		bchg	#0,obStatus(a1)
		move.w	#-$600,obVelX(a1)
		bchg	#0,obStatus(a1)
		bra.w	Obj_Arthur_RunRight3

Obj_Arthur_ThrowAxe2:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Arthur_RunRight3
		move.l	#Obj_Axe,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		bchg	#0,obStatus(a1)
		move.w	#-$500,obVelX(a1)
		move.w	(Player_1+obY).w,d0
		sub.w	obY(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelY(a1)
		bra.w	Obj_Arthur_RunRight3

Obj_Arthur_ThrowBomb2:
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Arthur_RunRight3
		move.l	#Obj_Arthur_Firebomb,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent(a1)
		bchg	#0,obStatus(a1)
		move.w	#-$300,obVelX(a1)
		move.w	#-$500,obVelY(a1)
		jsr	(SingleObjLoad2).w
		bne.s	Obj_Arthur_RunRight3
		move.l	#Obj_Arthur_Firebomb,(a1)
		move.w	a0,parent(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		bchg	#0,obStatus(a1)
		move.w	(Player_1+obX).w,d0
		sub.w	obX(a0),d0
		asl.w	#2,d0
		move.w	d0,obVelX(a1)
		move.w	#-$400,obVelY(a1)

Obj_Arthur_RunRight3:
		move.b	#4,routine(a0)
		sfx	sfx_Arthur2
		rts
; ===========================================================================

Obj_Arthur_Fin:
		jmp	(DeleteObject).w

Obj_Arthur_Return:
		rts


; ===========================================================================

DPLCPtr_Arthur:	dc.l ArtUnc_Arthur>>1, DPLC_Arthur

ObjDat4_Arthur:
		dc.l SME_OAZDa			; Mapping
		dc.w $23A0			; VRAM
		dc.w $300			; Priority
		dc.b 14/2			; Width	(64/2)
		dc.b 38/2			; Height	(64/2)
		dc.b 0				; Frame
		dc.b $23			; Collision

PLC_BossArthur: plrlistheader
		plreq $3A0, ArtKosM_Arthur
PLC_BossArthur_End


		include "Objects/Bosses/Arthur/Object data/Ani - Arthur.asm"
		include "Objects/Bosses/Arthur/Object data/Ani - Dialogue.asm"
		include "Objects/Bosses/Arthur/Object data/Map - Arthur.asm"
		include "Objects/Bosses/Arthur/Object data/DPLC - Arthur.asm"
		include "Objects/Bosses/Arthur/Object data/Map - Weapon.asm"
		include "Objects/Bosses/Arthur/Object data/Map - Dialogue.asm"
		include "Objects/Bosses/Arthur/Firebrand.asm"

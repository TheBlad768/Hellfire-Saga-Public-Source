
; =============== S U B R O U T I N E =======================================

Obj_Explosion:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	off_1E5EE(pc,d0.w),d1
		jmp	off_1E5EE(pc,d1.w)
; ---------------------------------------------------------------------------

off_1E5EE: offsetTable
		offsetTableEntry.w loc_1E5F6
		offsetTableEntry.w loc_1E61A
		offsetTableEntry.w loc_1E66E
		offsetTableEntry.w loc_1E626
; ---------------------------------------------------------------------------

loc_1E5F6:
		addq.b	#2,routine(a0)
;		bsr.w	Create_New_Sprite
;		bne.s	loc_1E61A
;		move.l	#Obj_Animal,(a1)
;		move.w	$10(a0),$10(a1)
;		move.w	$14(a0),$14(a1)
;		move.w	$3E(a0),$3E(a1)

loc_1E61A:
		cmpi.w	#1,obSubtype(a0)
		beq.s	.bomb
		cmpi.w	#2,obSubtype(a0)
		beq.s	.wallbreak
		move.w	#sfx_BreakItem,d0
		bra.s	.cont

.bomb
		move.w	#sfx_Bomb,d0
		bra.s	.cont

.wallbreak
		move.w	#sfx_BreakWall,d0

.cont
		jsr	dFractalQueue

.slotdone
		addq.b	#2,routine(a0)

loc_1E626:
		move.l	#Map_Explosion,$C(a0)
		move.w	art_tile(a0),d0
		andi.w	#$8000,d0
		move.w	#$5A8,d1					; MJ: prepare pattern index address
		cmpi.w	#$0300,(Current_zone).w				; MJ: is this DDZ?
		bne.s	.NoDDZ						; MJ: if not, continue normally
		move.w	#(VDD_FlameExpArt/$20),d1			; MJ: prepare flame explosion instead

	.NoDDZ:
		or.w	d1,d0						; MJ: set pattern address
		move.w	d0,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#0,collision_flags(a0)
		move.b	#$C,width_pixels(a0)
		move.b	#$C,height_pixels(a0)
		move.b	#3,anim_frame_timer(a0)
		move.b	#0,mapping_frame(a0)
		move.l	#loc_1E66E,(a0)

loc_1E66E:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.w	loc_1E758
+		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_FireShield_Dissipate:
		move.l	#Map_Explosion,mappings(a0)
		move.w	#$5A8,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		move.b	#$C,width_pixels(a0)
		move.b	#$C,height_pixels(a0)
		move.b	#3,anim_frame_timer(a0)
		move.b	#1,mapping_frame(a0)
		move.l	#loc_1E6C6,(a0)

loc_1E6C6:
		jsr	(MoveSprite2).w
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.s	loc_1E758
+		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

loc_1E6EC:
		move.l	#Map_Explosion,mappings(a0)
		move.w	#$85A0,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$100,priority(a0)
		move.b	#$C,width_pixels(a0)
		move.b	#$C,height_pixels(a0)
		move.b	#0,mapping_frame(a0)
		move.l	#loc_1E71E,(a0)

loc_1E71E:
		subq.b	#1,anim_frame_timer(a0)
		bmi.s	loc_1E726
		rts
; ---------------------------------------------------------------------------

loc_1E726:
		move.b	#3,anim_frame_timer(a0)
		move.l	#loc_1E732,(a0)

loc_1E732:
		jsr	(MoveSprite2).w
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.s	loc_1E758
+		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_1E758:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_EnemyScore:
		move.l	#Map_EnemyScore,mappings(a0)
		move.w	#$85E4,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.b	#8,width_pixels(a0)
		move.w	#-$400,y_vel(a0)
		move.l	#loc_2CD0C,(a0)

loc_2CD0C:
		tst.w	y_vel(a0)
		bpl.s	loc_1E758
		jsr	(MoveSprite2).w
		addi.w	#$20,y_vel(a0)
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

		include "Objects/Explosion/Object data/Map - Explosion.asm"

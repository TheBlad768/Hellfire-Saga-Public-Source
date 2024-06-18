
; =============== S U B R O U T I N E =======================================

Obj_WaterTrigger:
		moveq	#32/2,d0
		move.b	d0,width_pixels(a0)
		move.b	d0,height_pixels(a0)
		move.l	#Map_WaterTrigger,mappings(a0)
		move.w	#$2340,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$280,priority(a0)
		bset	#6,render_flags(a0)				; set multi-draw flag
		move.w	#1,mainspr_childsprites(a0)
		lea	$18(a0),a2
		move.w	x_pos(a0),(a2)+
		move.w	y_pos(a0),(a2)+
		move.w	#0,(a2)+
		move.l	#loc_25D9C,address(a0)

loc_25D9C:
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	x_pos(a0),d4
		lea	WaterTrigger_SlopeData(pc),a2
		jsr	(sub_1DD0E).w
		swap	d6
		andi.w	#$33,d6
		beq.w	loc_25DF0
		move.b	d6,d0
		andi.b	#$11,d0
		beq.w	loc_25DF0
		lea	(Player_1).w,a1
		cmpi.b	#id_SpinDash,anim(a1)
		bne.s	loc_25DF0
		tst.b	objoff_32(a0)
		bne.s	loc_25DF0
		move.w	#1*60,$30(a0)	; set timer
		move.b	subtype(a0),d0
		andi.w	#$F,d0
		add.w	d0,d0
		move.w	WaterData(pc,d0.w),d0
		move.w	d0,d1
		sub.w	(Target_water_level).w,d1
		beq.s	loc_25E00					; return water
		move.w	(Target_water_level).w,(Water_trigger_save).w

loc_25DC0:

-		neg.w	d1
		bmi.s	-
		ori.w	#$F,d1						; fix
		move.w	d1,(Screen_shaking_flag).w
		move.w	d1,(Screen_shaking_sound).w
		move.w	d1,objoff_30(a0)				; set timer
		move.w	d0,(Target_water_level).w
		bsr.w	WaterTrigger_CheckWaterPos.skip

loc_25DD8:
		move.b	#1,$32(a0)
		move.b	status(a1),d0
		add.b	status(a0),d0
		andi.b	#1,d0
		bne.s	loc_25DF0
		st	objoff_32(a0)

loc_25DF0:
		tst.w	objoff_30(a0)
		beq.s	loc_25EA0
		subq.w	#1,objoff_30(a0)
		bne.s	loc_25E4A

loc_25DFC:
		clr.b	objoff_32(a0)
		clr.b	mapping_frame(a0)
		bra.s	loc_25EA0
; ---------------------------------------------------------------------------

WaterData:
		dc.w $3D0		; 0
		dc.w $158		; 1
		dc.w $5B8		; 2
		dc.w $500		; 3
		dc.w $420		; 4
; ---------------------------------------------------------------------------

loc_25E00:
		move.w	(Water_trigger_save).w,d0
		move.w	d0,d1
		sub.w	(Target_water_level).w,d1
		bra.s	loc_25DC0
; ---------------------------------------------------------------------------

loc_25E4A:
		move.b	status(a0),d6
		andi.w	#$18,d6
		beq.s	loc_25E72
		move.w	d6,d0
		andi.w	#8,d0
		beq.s	loc_25E72
		lea	(Player_1).w,a1
		bsr.s	sub_25EA6

loc_25E72:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	loc_25E8C
		move.b	#1,anim_frame_timer(a0)
		move.b	$32(a0),d0
		add.b	d0,objoff_1D(a0)
		andi.b	#3,objoff_1D(a0)

loc_25E8C:
		tst.b	mapping_frame(a0)
		beq.s	loc_25E9A
		clr.b	mapping_frame(a0)
		bra.s	loc_25EA0
; ---------------------------------------------------------------------------

loc_25E9A:
		move.b	#4,mapping_frame(a0)

loc_25EA0:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

WaterTrigger_CheckWaterPos:
		move.w	(Target_water_level).w,d0

.skip
		moveq	#2,d1						; level 3
		cmpi.w	#$200,d0
		blo.s		.set
		subq.b	#1,d1						; level 2
		cmpi.w	#$480,d0
		blo.s		.set
		subq.b	#1,d1						; level 3

.set
		move.b	d1,(SCZ2_WaterLevel).w
		st	(UpdatePanelSCZ2).w
		rts

; =============== S U B R O U T I N E =======================================

sub_25EA6:
		move.w	x_pos(a0),d1
		subi.w	#$10,d1
		btst	#0,status(a0)
		beq.s	loc_25EBA
		addi.w	#$20,d1

loc_25EBA:
		move.w	y_pos(a0),d2
		addi.w	#$10,d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#-$700,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a1)
		bset	#1,status(a1)
		bclr	#4,status(a1)
		bclr	#5,status(a1)
		clr.b	jumping(a1)
		clr.b	spin_dash_flag(a1)
		sfx	sfx_Bumper
		rts
; End of function sub_25EA6
; ---------------------------------------------------------------------------

WaterTrigger_SlopeData:
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $F
		dc.b $F
		dc.b $E
		dc.b $E
		dc.b $D
		dc.b $C
		dc.b $A
		dc.b 8
		dc.b 6
		dc.b 4
		dc.b 0
		dc.b $FC
		dc.b $F8
		dc.b $F6
		dc.b $F6
		dc.b $F6
		dc.b $F6
		dc.b $F6
		dc.b $F6
	even
; ---------------------------------------------------------------------------

		include "Objects/Water Trigger/Object data/Map - Water Trigger.asm"
Obj_Mecha_BurningSkull:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_Mecha_BurningSkull_Index(pc,d0.w),d1
		jsr	Obj_Mecha_BurningSkull_Index(pc,d1.w)
		lea	(Ani_MechaSonic).l,a1
		jsr	(AnimateSprite).w
		movea.w	parent(a0),a1
		btst	#7,status(a1)
		bne.s	Obj_Mecha_BurningSkull_Remove
		jmp	(Obj_Mecha_BurningSkull_Display).l
; ---------------------------------------------------------------------------

Obj_Mecha_BurningSkull_Index:
		dc.w	Obj_Mecha_BurningSkull_Main-Obj_Mecha_BurningSkull_Index
		dc.w	Obj_Mecha_BurningSkull_Flash-Obj_Mecha_BurningSkull_Index
		dc.w	Obj_Mecha_BurningSkull_Fly-Obj_Mecha_BurningSkull_Index
; ---------------------------------------------------------------------------

Obj_Mecha_BurningSkull_Remove:
		move.l	#Go_Delete_Sprite,address(a0)
		rts
; ---------------------------------------------------------------------------

Obj_Mecha_BurningSkull_Display:
		cmpi.b	#4,routine(a0)
		beq.s	+
		add.w   #1,objoff_46(a0)
		cmpi.w	#3,objoff_46(a0)
		bne.s	++
		clr.w	objoff_46(a0)
+		jmp	(Draw_And_Touch_Sprite).w
+		rts
; ---------------------------------------------------------------------------
Obj_Mecha_BurningSkull_Main:
		move.w	#50,obTimer(a0)
		addq.b	#2,routine(a0)
		move.l	#Map_Debris,obMap(a0)
		move.w	#$370,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.b	#$A,obAnim(a0)
		move.b	#6|$80,obColType(a0)

Obj_Mecha_BurningSkull_Flash:
		move.w	parent(a0),a1
		cmpi.b	#$30,routine_secondary(a1)
		beq.w	Obj_Mecha_BurningSkull_Delete
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_Mecha_BurningSkull_Return
		move.w	parent(a0),a1
		move.b	obStatus(a1),obStatus(a0)
		moveq	#3,d5
		jsr	(Shot_Object).w
		addq.b	#2,routine(a0)
		sfx	sfx_FireShield
		cmpi.b	#5,objoff_48(a0)
		beq.s	+
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_Mecha_BurningSkull,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	parent(a0),parent(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	objoff_48(a0),objoff_48(a1)
		add.b	#1,objoff_48(a1)

+		rts

Obj_Mecha_BurningSkull_Fly:
		move.w	parent(a0),a1
		cmpi.b	#$30,routine_secondary(a1)
		beq.w	Obj_Mecha_BurningSkull_Delete
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		bne.s	Obj_Mecha_BurningSkull_Delete
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_Mecha_BurningSkull_Return
		add.w	d1,obY(a0)
		sfx	sfx_BreakBridge
		move.l	#Go_Delete_Sprite,address(a0)
		move.w	#$14,(Screen_Shaking_Flag).w
		lea	ChildObjDat_DEZExplosion(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

Obj_Mecha_BurningSkull_Delete:
		move.l	#Go_Delete_Sprite,(a0)

Obj_Mecha_BurningSkull_Return:
		rts
; ---------------------------------------------------------------------------
; Взрывы
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_DEZExplosion:
		moveq	#1,d2
		move.w	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_DEZExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$859C,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.w	d2,d3
		asl.w	#8,d3
		neg.w	d3
		move.w	d3,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)

;		move.b	#$8B,collision_flags(a1)

		addq.w	#1,d2
		dbf	d1,-
+		bra.s	DEZExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DEZExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	DEZExplosion_Delete
                bra.s   .draw
                rts

.draw:
		jsr	(MoveSprite).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

DEZExplosion_Delete:
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

ChildObjDat_DEZExplosion:
		dc.w 1-1
		dc.l Obj_DEZExplosion
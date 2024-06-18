; -------------------------------------------
; Mickey Mouse form used by Gloamglozer
; -------------------------------------------

Obj_MickeyFantom:
	moveq   #0,d0
	move.b	obRoutine(a0),d0
	move.w  Obj_MickeyFantom_Index(pc,d0.w),d1
	jsr     Obj_MickeyFantom_Index(pc,d1.w)
	lea     (Ani_MickeyFantom).l,a1
	jsr     (AnimateSprite).w
	jmp	(Obj_GloamglozerForm_CheckReturnPal).l

Obj_MickeyFantom_Index:
	dc.w Obj_MickeyFantom_Main-Obj_MickeyFantom_Index	; 0
	dc.w Obj_MickeyFantom_Preparing-Obj_MickeyFantom_Index	; 2
	dc.w Obj_MickeyFantom_Fall-Obj_MickeyFantom_Index	; 4
	dc.w Obj_MickeyFantom_Jump-Obj_MickeyFantom_Index	; 6
	dc.w Obj_MickeyFantom_Explode-Obj_MickeyFantom_Index	; 8

Obj_MickeyFantom_Main:
		addq.b	#2,obRoutine(a0)
		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_SmoothPalette,(a1)
		move.w	#$E,subtype(a1)
		move.l	#Pal_Mickey,$30(a1)
		move.w	#Normal_palette_line_2,$34(a1)
                move.w	#16-1,$38(a1)
+		move.l	#SME_uvwMe,obMap(a0)
		move.w	#$2380,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$10,obHeight(a0)
		move.b	#$10,obWidth(a0)
		move.b	#$10,x_radius(a0)
		move.b	#$10,y_radius(a0)
		move.w	#0,obSubtype(a0)
		move.b	#$3C,obTimer(a0)
		bset	#5,shield_reaction(a0)
		jsr	(Obj_PrinPrinFantom_CheckInCamera).l

Obj_MickeyFantom_Preparing:
		subq.b	#1,obTimer(a0)
		bpl.w	Obj_MickeyFantom_Return
		jsr	(SingleObjLoad2).w
		bne.w	Obj_MickeyFantom_Return
		move.l	#Obj_Explosion,(a1)
                move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		addq.b  #2,obRoutine(a0);

Obj_MickeyFantom_Fall:
		jsr	(Obj_MickeyFantom_CorrectAni).l
		jsr	(Obj_MickeyFantom_CheckInCamera).l
		jsr	(SpeedToPos).w
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.w	Obj_MickeyFantom_Return
                add.w 	d1,obY(a0)
		move.w	#0,obVelX(a0)

		cmpi.w	#3,obSubtype(a0)
		blt.s	+
		move.b	#8,obRoutine(a0)
		rts

+		add.w	#1,obSubtype(a0)

		jsr	(SingleObjLoad2).w
		bne.w	Obj_MickeyFantom_Return
		move.l	#Obj_Love_Bullet2,(a1) ; this is thunder in this level
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#-$A0,obVelX(a1);
		move.w	#-$600,obVelY(a1);
		move.w	a0,parent3(a1)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_MickeyFantom_Return
		move.l	#Obj_Love_Bullet2,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	#$A0,obVelX(a1);
		move.w	#-$600,obVelY(a1);
		move.w	a0,parent3(a1)

		addq.b	#2,obRoutine(a0)
		rts

Obj_MickeyFantom_Jump:
		jsr	(Obj_MickeyFantom_CorrectAni).l
		jsr	(Find_Sonic).w
		cmpi.w	#$128,d2
		bcc.w	Obj_MickeyFantom_Return
		bset	#0,obStatus(a0)
		tst.w	d0
		bne.s	+
		bclr	#0,obStatus(a0)
+		subq.b	#2,obRoutine(a0)
		move.w	#-$500,obVelY(a0)
		sfx	sfx_MickeyAss

		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#-$100,d0
		jmp	(Change_VelocityWithFlipX).w

Obj_MickeyFantom_Explode:
                move.l  #Delete_Current_Sprite,(a0)
                bset	#7,obStatus(a0)
		move.w  parent3(a0),a1
		move.b	#1,objoff_48(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		subi.w	#$20,obY(a1)

Obj_MickeyFantom_Return:
		rts

Obj_MickeyFantom_CorrectAni:
		cmpi.w  #0,obVelY(a0)
		bpl.s   +
		move.b	#0,obAnim(a0)
		rts
+		move.b	#1,obAnim(a0)
		rts

Obj_MickeyFantom_CheckInCamera:
		move.w	(Camera_x_pos).w,d0
		cmp.w	obX(a0),d0
		blt.s	+
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
+		addi.w	#$128,d0
		cmp.w	obX(a0),d0
		bgt.s	+
		neg.w	obVelX(a0)
		bchg	#0,obStatus(a0)
+		rts

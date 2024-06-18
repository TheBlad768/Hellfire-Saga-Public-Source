; ---------------------------------------------------------------------------
; Death in Gloamglozer cutscene (Death!!!)
; ---------------------------------------------------------------------------

Obj_HellgirlFDZ4:
;		move.b	#4,(Hyper_Sonic_flash_timer).w
;		samp	sfx_ThunderClamp
;		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
;		jsr	(CreateChild6_Simple).w

		lea	(Pal_DeathIntro).l,a1
		lea	(Normal_palette_line_4).w,a2
		moveq	#(16/2)-1,d0
-		move.l	(a1)+,(a2)+
		dbf	d0,-

		st	$3A(a0)					; set current frame as invalid
		move.l	#Map_DeathIntro,obMap(a0)
		move.w	#$6390,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		moveq	#80/2,d0
		move.b	d0,obHeight(a0)
		move.b	d0,obWidth(a0)
		bset	#0,render_flags(a0)
		move.w	#$1F,$2E(a0)
		move.l	#HellgirlFDZ4_Attack,address(a0)

HellgirlFDZ4_Attack:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		move.l	#HellgirlFDZ4_Draw,address(a0)
		sfx	sfx_FireShot
		lea	ChildObjDat_HellgirlFDZ4_MissileAttack(pc),a2
		jsr	(CreateChild6_Simple).w
		bra.w	HellgirlFDZ4_Draw
; ---------------------------------------------------------------------------

HellgirlFDZ4_Wait:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		move.w	parent3(a0),a1
		move.b	#0,obAnim(a1)
		movea.w	$44(a0),a1
		move.l	#Obj_Gloamglozer_CutsceneSonicWait2_Return,address(a1)
		move.l	#HellgirlFDZ4_SonicDown,address(a0)

HellgirlFDZ4_SonicDown:
		lea	(Player_1).w,a1
		addq.w	#3,y_pos(a1)
		move.w	y_pos(a1),d0
		sub.w	(Camera_Y_pos).w,d0
		cmpi.w	#$BA,d0
		ble.w	HellgirlFDZ4_Draw
		move.w	#id_Lies<<8,anim(a1)
		move.w	#$1F,$2E(a0)
		move.l	#HellgirlFDZ4_SonicTired,address(a0)

HellgirlFDZ4_SonicTired:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		lea	(Player_1).w,a1
		move.w	#id_Tired<<8,anim(a1)
		move.w	#$1F,$2E(a0)
		move.l	#HellgirlFDZ4_Move,address(a0)

HellgirlFDZ4_Move:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		move.w	#$180,x_vel(a0)
		move.l	#HellgirlFDZ4_CheckPos,address(a0)

HellgirlFDZ4_CheckPos:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$40,d0
		cmp.w	x_pos(a0),d0
		bge.w	HellgirlFDZ4_Draw
		clr.w	x_vel(a0)
		move.w	#$1F,$2E(a0)
		move.l	#HellgirlFDZ4_Dialog,address(a0)

HellgirlFDZ4_Dialog:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		move.l	#HellgirlFDZ4_DialogWait,address(a0)
		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	HellgirlFDZ4_Draw
		move.b	#_FDZ4EndHell,routine(a1)
		move.l	#DialogFDZ4EndHell_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ4EndHell_Process_Index_End-DialogFDZ4EndHell_Process_Index)/8,$39(a1)
		move.w	a1,$42(a0)

HellgirlFDZ4_DialogWait:
		movea.w	$42(a0),a1
		cmpi.b	#5,obDialogWinowsText(a1)
		bne.s	HellgirlFDZ4_Draw
		move.l	#HellgirlFDZ4_SonicWait,address(a0)

HellgirlFDZ4_SonicWait:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		lea	(Player_1).w,a1
		move.w	#id_Wait2<<8,anim(a1)
		move.w	#$1F,$2E(a0)
		move.l	#HellgirlFDZ4_SonicLookBack,address(a0)

HellgirlFDZ4_SonicLookBack:
		subq.w	#1,$2E(a0)
		bpl.w	HellgirlFDZ4_Draw
		lea	(Player_1).w,a1
		move.w	#id_LookL<<8,anim(a1)
		move.w	#$1F,$2E(a0)
		move.l	#HellgirlFDZ4_Draw,address(a0)

HellgirlFDZ4_Draw:
		jsr	(SpeedToPos).w
		lea	Ani_DeathIntro(pc),a1
		jsr	(Animate_Sprite).w
		lea	DPLCPtr_DeathIntro(pc),a2
		jsr	(Perform_DPLC).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

HellgirlFDZ4_Remove:
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.w	$44(a0),a1
		move.l	#Obj_Gloamglozer_CutsceneSonicLookUp,address(a1)
		move.w	#$3F,$2E(a1)
		move.l	#Go_Delete_Sprite,address(a0)

HellgirlFDZ4_Return:
		rts
; ---------------------------------------------------------------------------
; Hell girl in Gloamglozer cutscene (Missile)
; ---------------------------------------------------------------------------

Obj_HellgirlFDZ4_Missile:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#5,d0
		move.b	d0,objoff_3C(a0)
		move.l	#Map_BigFireball,obMap(a0)
		move.w	#$320,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#2*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.b	#32,objoff_3A(a0)
		move.b	#4,objoff_40(a0)
		move.l	#HellgirlFDZ4_Missile_Cicrular,address(a0)

HellgirlFDZ4_Missile_Cicrular:
		subq.b	#1,objoff_3A(a0)
		bne.s	+
		move.l	#Go_Delete_Sprite,address(a0)
		tst.b subtype(a0)
		bne.s	+
		sfx	sfx_FireShot
		move.l	#Obj_HellgirlFDZ4_MissileAttack,address(a0)
+		move.b	objoff_40(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		btst	#0,(Level_frame_counter+1).w
		bne.s	HellgirlFDZ4_CheckParent

HellgirlFDZ4_Missile_Draw:
;		lea	(Ani_BigFireball).l,a1
;		jsr	(Animate_Sprite).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

HellgirlFDZ4_CheckParent:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

ChildObjDat_HellgirlFDZ4_Missile:
		dc.w 4-1
		dc.l Obj_HellgirlFDZ4_Missile
ChildObjDat_HellgirlFDZ4_MissileAttack:
		dc.w 1-1
		dc.l Obj_HellgirlFDZ4_MissileAttack
; ---------------------------------------------------------------------------
; Hell girl in Gloamglozer cutscene (Missile Attack)
; ---------------------------------------------------------------------------

Obj_HellgirlFDZ4_MissileAttack:
		move.l	#Map_BigFireball,obMap(a0)
		move.w	#$320,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#2*$80,obPriority(a0)
		move.b	#4,obHeight(a0)
		move.b	#4,obWidth(a0)
		move.w	#$800,x_vel(a0)
		move.b	#1,anim(a0)
		bset	#0,status(a0)
		move.l	#HellgirlFDZ4_MissileAttack_Draw,address(a0)

HellgirlFDZ4_MissileAttack_Draw:
		move.w	(Camera_X_pos).w,d0
		addi.w	#$100,d0
		cmp.w	x_pos(a0),d0
		ble.s		HellgirlFDZ4_MissileAttack_Remove
		jsr	(SpeedToPos).w
		lea	(Ani_BigFireball).l,a1
		jsr	(Animate_Sprite).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

HellgirlFDZ4_MissileAttack_Remove:
		samp	sfx_ThunderClamp
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#Go_Delete_Sprite,address(a0)
		move.w	parent3(a0),a1
		move.w	#$1F,$2E(a1)
		move.l	#HellgirlFDZ4_Wait,address(a1)
		samp	sfx_FireHurt
		move.w	parent3(a1),a1
		move.b	#3,obAnim(a1)
		sf	(Screen_Shaking_Flag).w
		move.b	#4,(Hyper_Sonic_flash_timer).w
		rts

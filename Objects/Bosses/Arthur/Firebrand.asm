
; =============== S U B R O U T I N E =======================================

Obj_FDZ1_Process:
;		st	obDialogTextLock(a1)		; WHAT?
		music	mus_Microboss
		command	cmd_FadeReset

		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_DialogueFirebrand,address(a1)	; load FDZ megaboss
		bset	#0,obStatus(a1)
		move.w	a1,$44(a0)
		move.w	a0,parent3(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$60,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$60,d2
		move.w	d2,y_pos(a1)
		bset	#0,render_flags(a1)
+		move.l	#FDZ1_Process_SonicScared,address(a0)
		lea	(Player_1).w,a1
		move.b	#4,routine(a1)		; Hit animation
		bclr	#3,status(a1)
		bclr	#5,status(a1)				; Player is not standing on/pushing an object
		bset	#1,status(a1)
		move.w	#-$300,y_vel(a1)
		move.w	#0,ground_vel(a1)		; Zero out inertia
		move.b	#id_Hurt,anim(a1)	; Set falling animation
		rts
; ---------------------------------------------------------------------------

FDZ1_Process_SonicScared:
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		bne.s	+
		move.l	#FDZ1_Process_SonicWait,address(a0)
		move.b	#0,invulnerability_timer(a1)
		move.b	#$81,object_control(a1)
		move.w	#id_LookF<<8,anim(a1)
		bset	#Status_Facing,status(a1)
		move.w	#$37,$2E(a0)
+		rts
; ---------------------------------------------------------------------------

FDZ1_Process_SonicWait:
		subq.w	#1,$2E(a0)
		bpl.s	+
		lea	(Player_1).w,a1
		move.w	#id_Wait2<<8,anim(a1)
		move.l	#FDZ1_Process_SonicLookUp,address(a0)
		move.w	#7,$2E(a0)
+		rts
; ---------------------------------------------------------------------------

FDZ1_Process_SonicLookUp:
		subq.w	#1,$2E(a0)
		bpl.s	+
		lea	(Player_1).w,a1
		move.w	#id_LookUp<<8,anim(a1)
		move.l	#FDZ1_Process_LoadDialog,address(a0)
+		rts
; ---------------------------------------------------------------------------

FDZ1_Process_LoadDialog:
		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#_FDZ1,routine(a1)
		move.l	#DialogFDZ1_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ1_Process_Index_End-DialogFDZ1_Process_Index)/8,$39(a1)
		move.w	a1,parent3(a0)
+		move.l	#FDZ1_Process_CheckDialog,address(a0)

FDZ1_Process_CheckDialog:
		movea.w	parent3(a0),a1
		cmpi.b	#1,obDialogWinowsText(a1)
		bne.s	FDZ1_Process_Return
		st	obDialogTextLock(a1)
		movea.w	$44(a0),a1
		move.l	#DialogueFirebrand_Remove,address(a1)
		move.l	#FDZ1_Process_Return,address(a0)
		lea	(Player_1).w,a1
		move.w	#id_LookU<<8,anim(a1)

FDZ1_Process_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_DialogueFirebrand:
		move.b	#3,(Hyper_Sonic_flash_timer).w
		st	(Screen_Shaking_Flag).w
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		lea	ObjDat4_DialogueGloamglozer(pc),a1
		jsr	SetUp_ObjAttributes.l
		st	$3A(a0)					; set current frame as invalid
		move.w	#$4F,$2E(a0)
		move.l	#DialogueFirebrand_Wait,address(a0)
		move.w	#$C0,d0				; Down
		move.w	d0,$3E(a0)
		move.w	d0,$1A(a0)
		move.w	#$10,$40(a0)		; Time
		bclr	#0,$38(a0)
		rts
; ---------------------------------------------------------------------------

DialogueFirebrand_Wait:
		btst	#2,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_DialogueFirebrand_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		samp	sfx_ThunderClamp
		move.b	#1,(Hyper_Sonic_flash_timer).w
+		subq.w	#1,$2E(a0)
		bpl.s	DialogueFirebrand_Draw
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		sf	obDialogTextLock(a1)
		sf	(Screen_Shaking_Flag).w
		st	$42(a0)
		move.l	#DialogueFirebrand_Draw,address(a0)

;DialogueFirebrand_Move:
;		moveq	#0,d0
;		move.b	angle(a0),d0
;		addq.b	#2,d0
;		move.b	d0,angle(a0)
;		jsr	(GetSineCosine).w
;		asr.w	#2,d0
;		move.w	d0,x_vel(a0)

DialogueFirebrand_Draw:
		jsr	(Swing_UpAndDown).w
		jsr	(MoveSprite2).w
		lea	(Ani_Gloamglozer).l,a1
		jsr	(AnimateSprite).w
		lea	DPLCPtr_Gloamglozer(pc),a2
		jsr	(Perform_DPLC).w
		tst.b	$42(a0)
		bne.s	+
		btst	#0,(Level_frame_counter+1).w
		beq.w	DialogueFirebrand_Return
+		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DialogueFirebrand_Remove:
		move.b	#3,(Hyper_Sonic_flash_timer).w
		st	(Screen_Shaking_Flag).w
		move.w	#$4F,$2E(a0)
		sf	$42(a0)
		move.l	#DialogueFirebrand_Remove_Wait,address(a0)

DialogueFirebrand_Remove_Wait:
		btst	#2,(Level_frame_counter+1).w
		beq.s	+
		lea	ChildObjDat_DialogueFirebrand_Fire(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#48/2,$3A(a1)
		move.b	#48/2,$3B(a1)
		move.w	#$100,$3C(a1)
+		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	+
		samp	sfx_ThunderClamp
		move.b	#1,(Hyper_Sonic_flash_timer).w
+		subq.w	#1,$2E(a0)
		bpl.w	DialogueFirebrand_Draw
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a1
		sf	obDialogTextLock(a1)
		sf	(Screen_Shaking_Flag).w
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion(pc),a2
		jsr	(CreateChild6_Simple).w

;		lea	(Player_1).w,a1
;		move.w	#id_Wait2<<8,anim(a1)
		move.l	#Delete_Current_Sprite,address(a0)

DialogueFirebrand_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_DialogueFirebrandRadiusExplosion:
		moveq	#0,d2
		move.w	#8-1,d1

-		jsr	(Create_New_Sprite3).w
		bne.s	++
		move.l	#Obj_DialogueFirebrandRadiusExplosion_GetVelocity,address(a1)
		move.l	#Map_Explosion,mappings(a1)
		move.w	#$5A8,art_tile(a1)
		tst.b	$40(a0)
		beq.s	+
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$59C,art_tile(a1)
+		move.b	#4,render_flags(a1)
		move.w	#$80,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		move.b	d2,angle(a1)
		move.b	#3,anim_frame_timer(a1)
		addi.w	#$20,d2
		dbf	d1,-
+		bra.s	DialogueFirebrandExplosion_Delete
; ---------------------------------------------------------------------------

Obj_DialogueFirebrandRadiusExplosion_GetVelocity:
		move.b	angle(a0),d0
		jsr	(GetSineCosine).w
		move.w	#$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		move.l	#Obj_DialogueFirebrandRadiusExplosion_Anim,address(a0)

Obj_DialogueFirebrandRadiusExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#5,mapping_frame(a0)
		beq.s	DialogueFirebrandExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

DialogueFirebrandExplosion_Delete:
		move.l	#Delete_Current_Sprite,address(a0)
		rts

; =============== S U B R O U T I N E =======================================

Obj_DialogueFirebrand_Fire:
		move.w	#1-1,d6

-		jsr	(Create_New_Sprite3).w
		bne.w	+++		; NAT: This was wrong originally. This is why you should never use + or - as a label! Its really messy and leads to bugs like what was here!
		move.l	#Obj_DialogueFirebrandRadiusExplosion_Anim,address(a1)
		move.l	#Map_Explosion,mappings(a1)
		move.w	$30(a0),d0
		bne.s	+
		move.w	#$5A8,d0
+		move.w	d0,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	$3C(a0),priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		jsr	(loc_83E90).l
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		movea.w	parent3(a0),a2
		btst	#0,render_flags(a2)
		beq.s	+
		neg.w	d0
+		move.w	d0,x_vel(a1)
		jsr	(Random_Number).w
		andi.w	#$FF,d0
		addi.w	#$200,d0
		neg.w	d0
		move.w	d0,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		dbf	d6,-
+		bra.w	DialogueFirebrandExplosion_Delete

; =============== S U B R O U T I N E =======================================

ObjDat4_DialogueGloamglozer:
		dc.l SME_gSjKD			; Mapping
		dc.w $23A0			; VRAM
		dc.w $280			; Priority
		dc.b 64/2			; Width	(64/2)
		dc.b 64/2			; Height	(64/2)
		dc.b 0				; Frame
		dc.b 0				; Collision

ChildObjDat_DialogueFirebrandRadiusExplosion:
		dc.w 1-1
		dc.l Obj_DialogueFirebrandRadiusExplosion

ChildObjDat_DialogueFirebrand_Fire:
		dc.w 1-1
		dc.l Obj_DialogueFirebrand_Fire

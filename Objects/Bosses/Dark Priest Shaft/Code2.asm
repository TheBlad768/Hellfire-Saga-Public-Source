;These shafts used in cutscenes

Obj_DPShaftGhost:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj_DPShaftGhost_Index(pc,d0.w),d1
		jmp	Obj_DPShaftGhost_Index(pc,d1.w)
; ==================================================================
Obj_DPShaftGhost_Index:
		dc.w Obj_DPShaftGhost_Main-Obj_DPShaftGhost_Index
		dc.w Obj_DPShaftGhost_Vanish-Obj_DPShaftGhost_Index
; ==================================================================

Obj_DPShaftGhost_Main:
		tst.w	(Kos_modules_left).w		; check if decompression is finished
		beq.s	.load					; if not, do not bother doing anything
		rts

.load		addq.b	#2,obRoutine(a0)
		move.l	#SME_jKIVw,obMap(a0)
		move.w	#$2475,obGfx(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#8,obHeight(a0)
		move.b	#$13,obWidth(a0)
		move.b	#8,x_radius(a0)
		move.b	#$13,y_radius(a0)
		move.b	#$A,obAnim(a0)
		move.w	#30,obTimer(a0)
		move.w	#$B00,obVelX(a0)

Obj_DPShaftGhost_Vanish:
		move.w	(Camera_y_pos).w,obY(a0)
		add.w	#$1D,obY(a0)
		jsr	(SpeedToPos).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_DPShaftGhost_Display
		lea	(Pal_GMZ1Lava).l,a1
		jsr	(PalLoad_Line1).w

;		lea	(ArtKosM_GMZ1Lava).l,a1
;		move.w	#tiles_to_bytes($4B4),d2
;		jsr	(Queue_Kos_Module).w

		move.b	#$14,(Dynamic_resize_routine).w
		lea	ChildObjDat_DialogueFirebrandRadiusExplosion22(pc),a2
		jsr	(CreateChild6_Simple).w
		move.l	#Delete_Current_Sprite,(a0)
		lea	(Pal_GMZ).l,a1
		jmp	(PalLoad_Line1).w

Obj_DPShaftGhost_Display:
		lea	Ani_DPShaft(pc),a1
		jsr	(AnimateSprite).w
		jmp	(Draw_Sprite).w

ChildObjDat_DialogueFirebrandRadiusExplosion22:
		dc.w 1-1
		dc.l Obj_DialogueFirebrandRadiusExplosion


Obj_DShaft:
		moveq	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_DShaft_Index(pc,d0.w),d1
		jsr    	Obj_DShaft_Index(pc,d1.w)
		lea    	Ani_DPShaft(pc),a1
		jsr    	(AnimateSprite).w
		lea	DPLCPtr_DPShaft(pc),a2
		jsr	(Perform_DPLC).w
		jmp    	(Sprite_CheckDeleteTouchSlotted).l
; ==================================================================
Obj_DShaft_Index:
		dc.w Obj_DShaft_Main-Obj_DShaft_Index;0
		dc.w Obj_DShaft_ChkXCoord-Obj_DShaft_Index;2
		dc.w Obj_DShaft_Cast-Obj_DShaft_Index;4
; ==================================================================
Obj_DShaft_Main:
		lea	ObjDat4_DPShaft(pc),a1
		jsr	SetUp_ObjAttributes
		st	$3A(a0)					; set current frame as invalid

Obj_DShaft_ChkXCoord:
		cmpi.b	#8,(Dynamic_resize_routine).w
		bne.w	Obj_DShaft_Return
		move.b	#$E,obAnim(a0)
		move.w	#70,obTimer(a0)
		addq.b 	#2,obRoutine(a0)

Obj_DShaft_Cast:
		subq.w	#1,obTimer(a0)
		bpl.s	Obj_DShaft_Return
		sf	(Ctrl_1_locked).w
		move.w	#$14,(Screen_Shaking_Flag).w
		move.b	#$4,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp

		move.b	#$C,(Dynamic_resize_routine).w
		move.l	#Delete_Current_Sprite,(a0)

Obj_DShaft_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_MGZ3_Process:
		movea.w	parent3(a0),a1
		cmpi.b	#7,obDialogWinowsText(a1)
		bcc.s	MGZ3_Process_Return

		command	cmd_FadeReset
		command	cmd_StopMus
		move.l	#Delete_Current_Sprite,address(a0)

MGZ3_Process_Return:
		rts
; ==================================================================

		include	"Objects/Bosses/Dark Priest Shaft/Object data/Map - Ghost.asm"

; ---------------------------------------------------------------------------
; Босс-Shaft (Интро)
; ---------------------------------------------------------------------------

; Attributes
;_Setup1					= 2
;_Setup2					= 4
;_Setup3					= 6

; Dynamic object variables
obShaft2_Draw			= $30	; .b
obShaft2_Timer			= $38	; .w

; =============== S U B R O U T I N E =======================================

Obj_Shaft2:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Shaft2_Index(pc,d0.w),d0
		jsr	Shaft2_Index(pc,d0.w)
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		lea	Ani_Shaft(pc),a1
		jsr	(Animate_Sprite).w
		lea	DPLCPtr_Shaft(pc),a2
		jsr	(Perform_DPLC).w
		tst.w	obShaft2_Timer(a0)
		beq.s	+
		subq.w	#1,obShaft2_Timer(a0)
		btst	#0,(V_int_run_count+3).w
		beq.s	Shaft2_Return
+		tst.b	obShaft2_Draw(a0)
		bne.s	Shaft2_Return
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Shaft2_Index: offsetTable
		offsetTableEntry.w Shaft2_Init		; 0
		offsetTableEntry.w Shaft2_Setup	; 2
		offsetTableEntry.w Shaft2_Setup2	; 4
		offsetTableEntry.w Shaft2_Setup3	; 6
		offsetTableEntry.w Shaft2_Setup4	; 8
; ---------------------------------------------------------------------------

Shaft2_Init:
		lea	ObjDat4_Shaft2(pc),a1
		jsr	LoadObjects_Data
		st	$3A(a0)					; set current frame as invalid
		move.l	#Shaft2_Return,$34(a0)
		sfx	sfx_Bounce
		lea	ChildObjDat_Shaft_Clone_Contraction(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	Shaft2_Return
		st	obShaft2_Draw(a0)
		st	$41(a1)
		move.l	#Shaft2_Wait,$30(a1)

Shaft2_Return:
		rts
; ---------------------------------------------------------------------------

Shaft2_Setup4:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		bne.s	Shaft2_Setup2			; if yes, do not flash

		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	Shaft2_Setup2
		move.b	#1,(Hyper_Sonic_flash_timer).w

Shaft2_Setup2:
		moveq	#2,d0
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		bne.s	.swap				; if yes, swap palette less often
		moveq	#0,d0

.swap
		btst	d0,(Level_frame_counter+1).w
		beq.s	Shaft2_Setup
		eori.w	#$2000,art_tile(a0)
		bra.s	Shaft2_Setup
; ---------------------------------------------------------------------------

Shaft2_Setup3:
		bsr.s	Shaft2_CreateExplosion

Shaft2_Setup:
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

Shaft2_CreateExplosion:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.create				; if not, spawn every frame
		moveq	#3,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	+

.create
		lea	ChildObjDat_ShaftExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#64/2,$3A(a1)
		move.b	#96/2,$3B(a1)
		move.w	#$A0,$30(a1)
		move.w	#$B0,$32(a1)
+		rts

; =============== S U B R O U T I N E =======================================

Shaft2_Wait:
		move.w	#$BF,$2E(a0)
		move.l	#Shaft2_Start,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft2_Start:
		move.w	#$1F,$2E(a0)
		move.l	#Shaft2_Shaking,$34(a0)
		addq.b	#1,anim(a0)
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

Shaft2_Shaking:
		move.b	#_Setup4,routine(a0)
		move.w	#$10,$2E(a0)
		move.l	#Shaft2_Flash,$34(a0)
		st	(Screen_shaking_flag).w
		sfx	sfx_Squeak
		lea	ChildObjDat_Shaft2CircularBall_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.w	#$4F,$30(a1)
+		rts
; ---------------------------------------------------------------------------

Shaft2_Flash:
		move.w	#$BF,$2E(a0)
		move.l	#Shaft2_WaitExplosion,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft2_WaitExplosion:
		move.b	#_Setup3,routine(a0)
		sfx	sfx_Explosion
		move.w	#$8F,d0
		move.w	d0,$2E(a0)
		move.w	d0,obShaft_Timer(a0)
		ori.w	#$2000,art_tile(a0)
		move.l	#Shaft2_Explosion,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft2_Explosion:
		move.l	#Shaft2_Return,$34(a0)
		lea	ChildObjDat_Shaft_Clone_Expansion(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		st	obShaft_Draw(a0)
		st	$41(a1)
		move.l	#Shaft_CreateCerberus,$30(a1)
+		rts
; ---------------------------------------------------------------------------

Shaft_CreateCerberus:
		move.l	#Obj_Cerberus,address(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A8,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$A8,d0
		move.w	d0,y_pos(a0)
		clr.b	routine(a0)
		clr.b	anim(a0)
		sf	(Screen_shaking_flag).w
		jsr	(Find_SonicTails).w
		bclr	#0,status(a0)
		tst.w	d0
		bne.s	+
		bset	#0,status(a0)

+		lea	(PLC_BossCerberus).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_BossCerberus).l,a1
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------
; Вращающиеся шары (Процесс)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Shaft2CircularBall_Process:
		subq.w	#1,$30(a0)
		bmi.w	Obj_ShaftExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.s	Shaft2CircularBall_Process_Return
		move.w	#$12,$2E(a0)
		move.l	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	ChildObjDat_Shaft2CircularBall(pc),a2
		jsr	(CreateChild6_Simple).w
		movea.l	(sp)+,a0

Shaft2CircularBall_Process_Return:
		rts
; ---------------------------------------------------------------------------
; Вращающиеся шары
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Shaft2CircularBall:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#5,d0
		move.b	d0,objoff_3C(a0)
		lea	ObjDat3_ShaftExplosion(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#128,objoff_3A(a0)
		move.b	#4,objoff_40(a0)
		moveq	#-8,d0
		move.b	d0,child_dx(a0)
		move.b	d0,child_dy(a0)
		move.l	#Shaft2CircularBall_Circular,address(a0)

Shaft2CircularBall_Circular:
		subq.b	#1,objoff_3A(a0)
		beq.w	Obj_ShaftExplosion_Delete
		move.b	objoff_40(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

ObjDat4_Shaft2:
		dc.l Map_Shaft			; Mapping
		dc.w $2403			; VRAM
		dc.w $200			; Priority
		dc.b 64/2			; Width	(64/2)
		dc.b 64/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $11|$80			; Collision

ChildObjDat_Shaft2CircularBall_Process:
		dc.w 1-1
		dc.l Obj_Shaft2CircularBall_Process

ChildObjDat_Shaft2CircularBall:
		dc.w 4-1
		dc.l Obj_Shaft2CircularBall

PLC_Shaft2: plrlistheader
		plreq $59C, ArtKosM_DEZExplosion
PLC_Shaft2_End

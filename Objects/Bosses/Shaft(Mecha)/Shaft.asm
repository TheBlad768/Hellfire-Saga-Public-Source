; ---------------------------------------------------------------------------
; Босс-Shaft (Интро)
; ---------------------------------------------------------------------------

; Attributes
;_Setup1					= 2
;_Setup2					= 4
;_Setup3					= 6

; Dynamic object variables
obShaft3_Draw			= $30	; .b
obShaft3_Timer			= $38	; .w

; =============== S U B R O U T I N E =======================================

Obj_Shaft3:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Shaft3_Index(pc,d0.w),d0
		jsr	Shaft3_Index(pc,d0.w)
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		lea	Ani_Shaft(pc),a1
		jsr	(Animate_Sprite).w
		lea	DPLCPtr_Shaft(pc),a2
		jsr	(Perform_DPLC).w
		tst.w	obShaft3_Timer(a0)
		beq.s	+
		subq.w	#1,obShaft3_Timer(a0)
		btst	#0,(V_int_run_count+3).w
		beq.s	Shaft3_Return
+		tst.b	obShaft3_Draw(a0)
		bne.s	Shaft3_Return
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Shaft3_Index: offsetTable
		offsetTableEntry.w Shaft3_Init		; 0
		offsetTableEntry.w Shaft3_Setup	; 2
		offsetTableEntry.w Shaft3_Setup2	; 4
		offsetTableEntry.w Shaft3_Setup3	; 6
		offsetTableEntry.w Shaft3_Setup4	; 8
; ---------------------------------------------------------------------------

Shaft3_Init:
		lea	ObjDat4_Shaft3(pc),a1
		jsr	SetUp_ObjAttributes
		st	$3A(a0)					; set current frame as invalid
		move.l	#Shaft3_Return,$34(a0)
		sfx	sfx_Bounce
		lea	ChildObjDat_Shaft_Clone_Contraction(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	Shaft3_Return
		st	obShaft3_Draw(a0)
		st	$41(a1)
                move.l	#Shaft3_Wait,$30(a1)

Shaft3_Return:
		rts
; ---------------------------------------------------------------------------

Shaft3_Setup4:
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		bne.s	Shaft3_Setup2			; if yes, do not flash

		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	Shaft3_Setup2
		move.b	#1,(Hyper_Sonic_flash_timer).w

Shaft3_Setup2:
		moveq	#2,d0
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		bne.s	.swap				; if yes, swap palette less often
		moveq	#0,d0

.swap
		btst	d0,(Level_frame_counter+1).w
		beq.s	Shaft3_Setup
		eori.w	#$2000,art_tile(a0)
		bra.s	Shaft3_Setup
; ---------------------------------------------------------------------------

Shaft3_Setup3:
		bsr.s	Shaft3_CreateExplosion

Shaft3_Setup:
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

Shaft3_CreateExplosion:
		lea	ChildObjDat_ShaftExplosion(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#64/2,$3A(a1)
		move.b	#96/2,$3B(a1)
		move.w	#$120,$30(a1)
		move.w	#$B0,$32(a1)
+		rts

; =============== S U B R O U T I N E =======================================

Shaft3_Wait:
                cmpi.b  #8,(Dynamic_resize_routine).w
                bne.s   .return
                cmpi.w  #3,(AstarothCompleted).w
                beq.s   .settimer
		bra.s   .next

.settimer:
		move.w	#$BF,$2E(a0)

.next:
		move.l	#Shaft3_Start,$34(a0)

.return:
		rts
; ---------------------------------------------------------------------------

Shaft3_Start:
		move.w	#$1F,$2E(a0)
		move.l	#Shaft3_Shaking,$34(a0)
		addq.b	#1,anim(a0)
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

Shaft3_Shaking:
		move.b	#_Setup4,routine(a0)
		move.w	#$10,$2E(a0)
		move.l	#Shaft3_Flash,$34(a0)
		st	(Screen_shaking_flag).w
		sfx	sfx_Squeak
		lea	ChildObjDat_Shaft3CircularBall_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.w	#$4F,$30(a1)
+		rts
; ---------------------------------------------------------------------------

Shaft3_Flash:
		move.w	#$B7,$2E(a0)
		move.l	#Shaft3_WaitExplosion,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft3_WaitExplosion:
		move.b	#_Setup3,routine(a0)
		sfx	sfx_Explosion
		move.w	#$8F,d0
		move.w	d0,$2E(a0)
		move.w	d0,obShaft_Timer(a0)
		ori.w	#$2000,art_tile(a0)
		move.l	#Shaft3_Explosion,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft3_Explosion:
		move.l	#Shaft3_Return,$34(a0)
		lea	ChildObjDat_Shaft_Clone_Expansion(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		st	obShaft_Draw(a0)
		st	$41(a1)
		move.l	#Shaft_LoadMechaSonic,$30(a1)
+		rts
; ---------------------------------------------------------------------------

Shaft_LoadMechaSonic:
		lea	(PLC_MechaSonic).l,a5
		jsr	(LoadPLC_Raw_KosM).w
		move.l	#Shaft_CreateMechaSonic,address(a0)
		lea	(Pal_MechaSonic).l,a1
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------

Shaft_CreateMechaSonic:
		bsr.w	Shaft3_CreateExplosion
		tst.w	(Kos_modules_left).w
		bne.s	Shaft_CreateMechaSonic_Return
		move.l	#Go_Delete_Sprite,address(a0)
                cmpi.w  #3,(AstarothCompleted).w
                beq.w   +
		music	mus_Boss1
		command	cmd_FadeReset
+		jsr	(Create_New_Sprite).w
		bne.s	+
		move.l	#Obj_Mecha,address(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$11D,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$B0,d0
		move.w	d0,y_pos(a1)
                move.w  #3,(AstarothCompleted).w
+		sf	(Screen_shaking_flag).w

Shaft_CreateMechaSonic_Return:
		rts
; ---------------------------------------------------------------------------
; Вращающиеся шары (Процесс)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Shaft3CircularBall_Process:
		subq.w	#1,$30(a0)
		bmi.w	Obj_ShaftExplosion_Delete
		subq.w	#1,$2E(a0)
		bpl.s	Shaft3CircularBall_Process_Return
		move.w	#$12,$2E(a0)
		move.l	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	ChildObjDat_Shaft3CircularBall(pc),a2
		jsr	(CreateChild6_Simple).w
		movea.l	(sp)+,a0

Shaft3CircularBall_Process_Return:
		rts
; ---------------------------------------------------------------------------
; Вращающиеся шары
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_Shaft3CircularBall:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#5,d0
		move.b	d0,objoff_3C(a0)
		lea	ObjDat3_ShaftExplosion(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#-8,objoff_40(a0)
		moveq	#-8,d0
		move.b	d0,child_dx(a0)
		move.b	d0,child_dy(a0)
		move.l	#Shaft3CircularBall_Circular,address(a0)

Shaft3CircularBall_Circular:
		addq.b	#1,objoff_3A(a0)
		cmpi.b	#128,objoff_3A(a0)
		beq.w	Obj_ShaftExplosion_Delete
		move.b	objoff_40(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		jmp	(Child_Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

ObjDat4_Shaft3:
		dc.l Map_Shaft			; Mapping
		dc.w $2310			; VRAM
		dc.w $200			; Priority
		dc.b 64/2			; Width	(64/2)
		dc.b 64/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $11|$80			; Collision

ChildObjDat_Shaft3CircularBall_Process:
		dc.w 1-1
		dc.l Obj_Shaft3CircularBall_Process

ChildObjDat_Shaft3CircularBall:
		dc.w 4-1
		dc.l Obj_Shaft3CircularBall

PLC_MechaSonic: plrlistheader
	;	plreq $370, ArtKosM_Mecha
	;	plreq $3D0, ArtKosM_MechaDemon
                plreq $370, ArtKosM_Debris
		plreq $3AD, ArtKosM_Spark
		plreq $4FC, ArtKosM_Spark2
PLC_MechaSonic_End

; ---------------------------------------------------------------------------
; ����-Shaft (�����)
; ---------------------------------------------------------------------------

; Attributes
;_Setup1					= 2
;_Setup2					= 4
;_Setup3					= 6

; Dynamic object variables
obShaft_Draw			= $30	; .b
obShaft_Timer			= $38	; .w

; =============== S U B R O U T I N E =======================================

Obj_Shaft:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Shaft_Index(pc,d0.w),d0
		jsr	Shaft_Index(pc,d0.w)
		st	MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		lea	Ani_Shaft(pc),a1
		jsr	(Animate_Sprite).w
		lea	DPLCPtr_Shaft(pc),a2
		jsr	(Perform_DPLC).w
		tst.w	obShaft_Timer(a0)
		beq.s	+
		subq.w	#1,obShaft_Timer(a0)
		btst	#0,(V_int_run_count+3).w
		beq.s	Shaft_Return
+		tst.b	obShaft_Draw(a0)
		bne.s	Shaft_Return
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Shaft_Index: offsetTable
		offsetTableEntry.w Shaft_Init		; 0
		offsetTableEntry.w Shaft_Setup		; 2
		offsetTableEntry.w Shaft_Setup2	; 4
		offsetTableEntry.w Shaft_Setup3	; 4
; ---------------------------------------------------------------------------

Shaft_Init:
		lea	ObjDat4_Shaft(pc),a1
		jsr	SetUp_ObjAttributes
		st	$3A(a0)					; set current frame as invalid
		move.l	#Shaft_Return,$34(a0)
		sfx	sfx_Bounce
		lea	ChildObjDat_Shaft_Clone_Contraction(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	Shaft_Return
		st	obShaft_Draw(a0)
		st	$41(a1)
                move.l	#Shaft_Wait,$30(a1)

Shaft_Return:
		rts
; ---------------------------------------------------------------------------

Shaft_Setup2:
		moveq	#0,d0
		tst.w	Seizure_flag.w			; check if photosensitivity mode is on
		beq.s	.swap				; if not, swap every frame
		moveq	#2,d0

.swap
		btst	d0,(Level_frame_counter+1).w
		beq.s	Shaft_Setup
		eori.w	#$2000,art_tile(a0)
		bra.s	Shaft_Setup
; ---------------------------------------------------------------------------

Shaft_Setup3:
		bsr.s	Shaft_CreateExplosion

Shaft_Setup:
		jmp	(Obj_Wait).w

; =============== S U B R O U T I N E =======================================

Shaft_CreateExplosion:
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
		move.w	#$110,$30(a1)
		move.w	#$B0,$32(a1)
+		rts

; =============== S U B R O U T I N E =======================================

Shaft_Wait:
		cmpi.b	#$20,(Dynamic_resize_routine).w
		bne.s	Shaft_Return
                cmpi.w  #3,(AstarothCompleted).w
                beq.s   .settimer
		bra.s   .next
                
.settimer:
		move.w	#$BF,$2E(a0)
.next:
		move.l	#Shaft_Start,$34(a0)
                rts

Shaft_Start:
		move.w	#$1F,$2E(a0)
		move.l	#Shaft_Shaking,$34(a0)
		addq.b	#1,anim(a0)
		sf	(Ctrl_1_locked).w
		jmp	(Restore_PlayerControl).w
; ---------------------------------------------------------------------------

Shaft_Shaking:
		move.w	#$10,$2E(a0)
		move.l	#Shaft_Flash,$34(a0)
		st	(Screen_shaking_flag).w
		sfx	sfx_Squeak
		lea	ChildObjDat_ShaftCircularBall(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

Shaft_Flash:
		move.b	#_Setup2,routine(a0)
		move.w	#$8F,$2E(a0)
		move.l	#Shaft_WaitExplosion,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft_WaitExplosion:
		move.b	#_Setup3,routine(a0)
		sfx	sfx_Explosion
		move.w	#$8F,d0
		move.w	d0,$2E(a0)
		move.w	d0,obShaft_Timer(a0)
		ori.w	#$2000,art_tile(a0)
		move.l	#Shaft_Explosion,$34(a0)
		rts
; ---------------------------------------------------------------------------

Shaft_Explosion:
		move.l	#Shaft_Return,$34(a0)
		lea	ChildObjDat_Shaft_Clone_Expansion(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		st	obShaft_Draw(a0)
		st	$41(a1)
		move.l	#Shaft_CreateShielder,$30(a1)
+		rts
; ---------------------------------------------------------------------------

Shaft_CreateShielder:
                move.w  #3,(AstarothCompleted).w
		move.l	#Obj_Shielder,address(a0)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$108,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		subi.w	#$48,d0
		move.w	d0,y_pos(a0)
		clr.b	routine(a0)
		clr.b	anim(a0)
		bclr	#0,status(a0)
		lea	PLC_BossShielder(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		lea	(Pal_BossShielder).l,a1
		jmp	(PalLoad_Line1).w
; ---------------------------------------------------------------------------
; ����� Shaft
; ---------------------------------------------------------------------------

Shaft_Clone_Xpos:
		dc.w -16, -32
		dc.w 16, 32
Shaft_Clone_Xvel:
		dc.w $200, $400
		dc.w -$200, -$400

; =============== S U B R O U T I N E =======================================

Obj_Shaft_Clone_Contraction:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	Shaft_Clone_Xpos(pc,d0.w),d0
		asl.w	#3,d0
		add.w	d0,x_pos(a0)

Obj_Shaft_Clone_Expansion:
		moveq	#0,d0
		move.b	subtype(a0),d0
		move.w	Shaft_Clone_Xvel(pc,d0.w),x_vel(a0)
		lea	ObjDat3_Shaft_Clone(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		movea.w	parent3(a0),a1
		bclr	#0,render_flags(a0)
		btst	#0,status(a1)
		beq.s	+
		bset	#0,render_flags(a0)
+		move.b	mapping_frame(a1),mapping_frame(a0)
		move.l	#Shaft_Clone_Contraction_Main,d0
		cmpi.l	#Obj_Shaft_Clone_Expansion,address(a0)
		bne.s	+
		neg.w	x_vel(a0)
		move.w	#$2F,$2E(a0)
		move.l	#Shaft_Clone_Expansion_Stop,$34(a0)
		move.l	#Shaft_Clone_Expansion_Main,d0
+		move.l	d0,address(a0)
		rts
; --------------------------------------------------------------------------

Shaft_Clone_Expansion_Stop:
		clr.w	x_vel(a0)
		move.w	#$F,$2E(a0)
		move.l	#Shaft_Clone_Remove,$34(a0)
		rts
; --------------------------------------------------------------------------

Shaft_Clone_Expansion_Main:
		jsr	(Obj_Wait).w
		bra.s	Shaft_Clone_Draw
; --------------------------------------------------------------------------

Shaft_Clone_Contraction_Main:
		movea.w	parent3(a0),a1
		jsr	(Find_OtherObject).w
		tst.w	d2
		beq.s	Shaft_Clone_Remove

Shaft_Clone_Draw:
		jsr	(MoveSprite2).w
		btst	#0,(Level_frame_counter+1).w
		beq.w	ShaftCircularBall_CheckParent
		movea.w	parent3(a0),a1
		move.b	mapping_frame(a1),mapping_frame(a0)
		jmp	(Child_Draw_Sprite).w
; --------------------------------------------------------------------------

Shaft_Clone_Remove:
		tst.b	$41(a0)
		beq.s	Shaft_Clone_Remove2
		movea.w	parent3(a0),a1
		move.l	$30(a0),$34(a1)
		sf	obShaft_Draw(a1)

Shaft_Clone_Remove2:        
                cmpi.w	#$201,(Current_zone_and_act).w
                beq.s   +
		cmpi.l	#Shaft_Clone_Expansion_Main,address(a0)
		beq.s	+
                tst.b   subtype(a0)
                bne.s   +
                cmpi.w  #3,(AstarothCompleted).w
                beq.s   +
		lea	(ArtKosM_BlackStretch).l,a1
		move.w	#tiles_to_bytes($580),d2
		jsr	(Queue_Kos_Module).w
		st	(NoPause_flag).w
		jsr	(Load_BlackStretch).l
+		move.l	#Go_Delete_Sprite,address(a0)

Shaft_Clone_Return:
		rts
; ---------------------------------------------------------------------------
; ����������� ����
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShaftCircularBall:
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.b	d0,objoff_3C(a0)
		lea	ObjDat3_ShaftExplosion(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#128,objoff_3A(a0)
		move.b	#4,objoff_40(a0)
		moveq	#-8,d0
		move.b	d0,child_dx(a0)
		move.b	d0,child_dy(a0)
		move.l	#ShaftCircularBall_Circular,address(a0)

ShaftCircularBall_Circular:
		subq.b	#1,objoff_3A(a0)
		beq.w	Obj_ShaftExplosion_Delete
		move.b	objoff_40(a0),d0
		add.b	d0,objoff_3C(a0)
		jsr	(MoveSprite_Circular).w
		btst	#0,(Level_frame_counter+1).w
		bne.s	ShaftCircularBall_CheckParent
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

ShaftCircularBall_CheckParent:
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------
; ������
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_ShaftExplosion:
		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_ShaftExplosion_Anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$59C,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.w	(Camera_X_pos).w,d0
		add.w	$30(a0),d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		add.w	$32(a0),d0
		move.w	d0,y_pos(a1)
		jsr	(loc_83E90).l
		move.w	#-$600,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)
		move.b	#$8B,collision_flags(a1)
+		bra.s	Obj_ShaftExplosion_Delete
; ---------------------------------------------------------------------------

Obj_ShaftExplosion_Anim:
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	+
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	Obj_ShaftExplosion_Delete
+		jsr	(MoveSprite2).w
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

Obj_ShaftExplosion_Delete:
		jmp	(Delete_Current_Sprite).w

; =============== S U B R O U T I N E =======================================

ObjDat4_Shaft:
		dc.l Map_Shaft			; Mapping
		dc.w $2224			; VRAM
		dc.w $200			; Priority
		dc.b 64/2			; Width	(64/2)
		dc.b 64/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b $11|$80			; Collision

ObjDat3_Shaft_Clone:
		dc.w $200			; Priority
		dc.b 64/2			; Width	(64/2)
		dc.b 64/2			; Height (64/2)
		dc.b 0				; Frame
		dc.b 0				; Collision

ObjDat3_ShaftExplosion:
		dc.l Map_BossDEZExplosion
		dc.w $859C
		dc.w $100
		dc.b 24/2
		dc.b 24/2
		dc.b 0
		dc.b 0

DPLCPtr_Shaft:	dc.l ArtUnc_Shaft>>1, DPLC_Shaft

ChildObjDat_Shaft_Clone_Contraction:
		dc.w 4-1
		dc.l Obj_Shaft_Clone_Contraction

ChildObjDat_Shaft_Clone_Expansion:
		dc.w 4-1
		dc.l Obj_Shaft_Clone_Expansion

ChildObjDat_ShaftCircularBall:
		dc.w 16-1
		dc.l Obj_ShaftCircularBall

ChildObjDat_ShaftExplosion:
		dc.w 1-1
		dc.l Obj_ShaftExplosion

PLC_Shaft: plrlistheader
		plreq $59C, ArtKosM_DEZExplosion
PLC_Shaft_End
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Shaft/Object data/Anim - Shaft.asm"
		include "Objects/Bosses/Shaft/Object data/DPLC - Shaft.asm"
		include "Objects/Bosses/Shaft/Object data/Map - Shaft.asm"

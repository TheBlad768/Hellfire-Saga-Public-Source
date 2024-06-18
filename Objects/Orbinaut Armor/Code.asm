Obj_OrbinautArmor:
		jsr 	Obj_WaitOffscreen
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_OrbinautArmor_Index(pc,d0.w),d1
		jsr	Obj_OrbinautArmor_Index(pc,d1.w)
		bsr.w	Obj_OrbinautArmor_Process

		lea	Ani_OrbinautArmor(pc),a1
		jsr	AnimateSprite
		lea	DPLCPtr_OrbinautArmor(pc),a2
		jsr	Perform_DPLC
		jmp	Sprite_CheckDeleteTouchSlotted
; ---------------------------------------------------------------------------

Obj_OrbinautArmor_Index:
		dc.w Obj_OrbinautArmor_Main-Obj_OrbinautArmor_Index		; 0
		dc.w Obj_OrbinautArmor_ChkSonic-Obj_OrbinautArmor_Index 	; 2
		dc.w Obj_OrbinautArmor_Die-Obj_OrbinautArmor_Index 	; 4
; ---------------------------------------------------------------------------

Obj_OrbinautArmor_Process:
		tst.b	$28(a0)
		bne.w	.lacricium
		tst.b	$29(a0)
		beq.s	.gone
		tst.b	$1C(a0)
		bne.s	.whatizit
		move.b	#$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset	#6,$2A(a0)

.whatizit:
		moveq	#0,d0
		btst	#0,$1C(a0)
		bne.s	.flash
		addi.w	#4,d0

.flash:
		subq.b	#1,$1C(a0)
		bne.s	.lacricium
		bclr	#6,$2A(a0)
		move.b	$25(a0),$28(a0)
		rts

.gone:
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		move.b	#1,objoff_46(a0)
		clr.w (DPLC_SlottedRAM).w
		move.l	#Go_Delete_SpriteSlotted2,(a0)

.lacricium:
		rts
; ---------------------------------------------------------------------------

Obj_OrbinautArmor_Main:
		lea	ObjDat4_OrbinautArmor(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#45,obTimer(a0)
		move.b  #1,$29(a0)

		moveq	#4-1,d5			; create 4 spikeballs
		moveq	#0,d6			; first subtype
		moveq	#2,d4			; next object subtype offset
;		sub.b	obSubtype(a0),d6	; sub parent subtype from subtypes
		move.l	#Obj_OA_SpikedBall,d3	; object to create

.create
		jsr	SingleObjLoad2
		bne.w	Obj_OrbinautArmor_Return
		move.l	d3,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent3(a1)
		move.b	obSubtype(a0),objoff_49(a1)
		move.b	#30,objoff_3A(a1)
		move.w	#30,obTimer(a1)

		move.b	d6,obSubtype(a1)	; save subtype
		add.b	d4,d6			; get next subtype to view
		dbf	d5,.create		; create next object
		jmp     (Swing_Setup_Hellgirl).w
; ---------------------------------------------------------------------------

Obj_OrbinautArmor_ChkSonic:
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		move.w 	(Player_1+obX).w,d0
		sub.w 	obX(a0),d0
		bpl.s 	Obj_OrbinautArmor_Command
		neg.w 	d0

Obj_OrbinautArmor_Command:
		cmpi.w 	#$75,d0
		bcc.w 	Obj_OrbinautArmor_Return
		move.b	#1,objoff_48(a0)
		addq.b	#2,routine(a0)

Obj_OrbinautArmor_Die:
		jsr	(Swing_UpAndDown).w
		jsr	(SpeedToPos).w
		cmpi.b	#5,objoff_48(a0)
		bne.w	Obj_OrbinautArmor_Return
		move.b	#1,objoff_46(a0)
		clr.w (DPLC_SlottedRAM).w
		move.l  #Obj_Explosion,(a0)
                clr.b   routine(a0)

Obj_OrbinautArmor_Return:
		rts
; ---------------------------------------------------------------------------

Obj_OA_SpikedBall:
		jsr 	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_OA_SpikedBall_Index(pc,d0.w),d1
		jsr	Obj_OA_SpikedBall_Index(pc,d1.w)
		jmp	(Child_DrawTouch_Sprite).w
; ===========================================================================

Obj_OA_SpikedBall_Index:
		dc.w Obj_OA_SpikedBall_Main-Obj_OA_SpikedBall_Index
		dc.w Obj_OA_SpikedBall_Rotate-Obj_OA_SpikedBall_Index
		dc.w Obj_OA_SpikedBall_GetReady-Obj_OA_SpikedBall_Index
		dc.w Obj_OA_SpikedBall_GetReady2-Obj_OA_SpikedBall_Index
; ===========================================================================

Obj_OA_SpikedBall_Main:
		move.w	#$3D0,obGfx(a0)
		move.l	#SME_NDvlp,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)
		addq.b	#2,routine(a0)
; ---------------------------------------------------------------------------

Obj_OA_SpikedBall_Rotate:
		addq.b	#2,$3C(a0)
		jsr     (MoveSprite_Circular).w
		move.w	parent3(a0),a1
		cmpi.b	#1,objoff_48(a1)
		bne.w	Obj_OA_SpikedBall_Return
		cmpi.b	#1,objoff_46(a1)
		beq.w	Obj_OA_SpikedBall_DIE
		addq.b	#2,routine(a0)
; ---------------------------------------------------------------------------

Obj_OA_SpikedBall_GetReady:
		move.w	parent3(a0),a1
		cmpi.b	#1,objoff_46(a1)
		beq.w	Obj_OA_SpikedBall_DIE
		sub.b	#1,objoff_3A(a0)
		addq.b	#6,$3C(a0)
		jsr     (MoveSprite_Circular).w
		sub.w	#1,obTimer(a0)
		bpl.w	Obj_OA_SpikedBall_Return
		addq.b	#2,routine(a0)
; ---------------------------------------------------------------------------

Obj_OA_SpikedBall_GetReady2:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		lsl.b	#5,d0
		move.b	d0,$3C(a0)
		jsr     (MoveSprite_Circular).w

		sub.w	#1,obTimer(a0)
		bpl.w	Obj_OA_SpikedBall_Return

		sfx	sfx_Teleport
		move.l	#Go_Delete_Sprite,(a0)
		jsr	(SingleObjLoad2).w
		bne.w	+
		move.l	#Obj_OA_SpikedBall2,(a1)
		move.b	objoff_49(a0),objoff_49(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obSubtype(a0),obSubtype(a1)
+		move.w	parent3(a0),a1
		add.b	#1,objoff_48(a1)
		move.l	#Go_Delete_Sprite,(a0)

Obj_OA_SpikedBall_Return:
		rts
; ---------------------------------------------------------------------------

Obj_OA_SpikedBall_DIE:
		move.l	#Go_Delete_Sprite,(a0)
		rts
; ---------------------------------------------------------------------------

Obj_OA_SpikedBall2:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_OA_SpikedBall2_Index(pc,d0.w),d1
		jsr	Obj_OA_SpikedBall2_Index(pc,d1.w)
		jmp	(Draw_And_Touch_Sprite).w
; ===========================================================================

Obj_OA_SpikedBall2_Index:
	dc.w Obj_OA_SpikedBall2_Main-Obj_OA_SpikedBall2_Index
	dc.w Obj_OA_SpikedBall2_Fly-Obj_OA_SpikedBall2_Index
; ===========================================================================

Obj_OA_SpikedBall2_Main:
		move.w	#$3D0,obGfx(a0)
		move.l	#SME_NDvlp,obMap(a0)
		move.b	#4,obRender(a0)
		move.w	#3*$80,obPriority(a0)
		move.b	#$87,obColType(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.b	#$F,x_radius(a0)
		move.b	#$F,y_radius(a0)

		cmpi.b	#1,objoff_49(a0)
		beq.s	+

		move.b	obSubtype(a0),d0
		lea	(Obj_OA_SpikedBall3_XVel).l,a1
                move.w	(a1,d0.w),obVelX(a0)
		lea	(Obj_OA_SpikedBall3_YVel).l,a1
                move.w	(a1,d0.w),obVelY(a0)
		bra.s	++
		rts

+		move.b	obSubtype(a0),d0
		lea	(Obj_OA_SpikedBall2_XVel).l,a1
                move.w	(a1,d0.w),obVelX(a0)
		lea	(Obj_OA_SpikedBall2_YVel).l,a1
                move.w	(a1,d0.w),obVelY(a0)
+		addq.b	#2,routine(a0)

Obj_OA_SpikedBall2_Fly:
		jsr	(SpeedToPos).w
		jsr	(ChkObjOnScreen).w
		beq.s	+
		move.l	#Go_Delete_Sprite,(a0)
+		rts

Obj_OA_SpikedBall2_XVel:
		dc.w	0
		dc.w	$600
		dc.w	0
		dc.w	-$600

Obj_OA_SpikedBall2_YVel:
		dc.w	$600 ;
		dc.w	0 ;
		dc.w	-$600
		dc.w	0

Obj_OA_SpikedBall3_XVel:
		dc.w	$400 ;
		dc.w	$400 ;
		dc.w	-$400
		dc.w	-$400

Obj_OA_SpikedBall3_YVel:
		dc.w	$400
		dc.w	-$400
		dc.w	-$400
		dc.w	$400

DPLCPtr_OrbinautArmor:	dc.l ArtUnc_OrbinautArmor>>1, DPLC_OrbinautArmor


;	SlotDataMGZ1	$0000, SME_Y49kQ, $300, 20/2, 56/2, $00, $23

ObjDat4_OrbinautArmor:
           		dc.l SME_Y49kQ
                	dc.w $3D4
                	dc.w $300
                	dc.b 56/2
                	dc.b 20/2
                  	dc.b 0
                  	dc.b $23
; ---------------------------------------------------------------------------

		include "Objects/Orbinaut Armor/Object data/Ani - Orbinaut Armor.asm"
		include	"Objects/Orbinaut Armor/Object data/DPLC - Orbinaut Armor.asm"
		include "Objects/Orbinaut Armor/Object data/Map - Orbinaut Armor.asm"
		include "Objects/Orbinaut Armor/Object data/Map - Ball.asm"

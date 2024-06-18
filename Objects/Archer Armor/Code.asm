Obj_ArcherArmor:
		jsr	(Obj_WaitOffscreen).w
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Obj_ArcherArmor_Index(pc,d0.w),d1
		jsr	Obj_ArcherArmor_Index(pc,d1.w)
		bsr.w	Obj_ArcherArmor_Process

		lea	(Ani_ArcherArmor).l,a1
		jsr	(AnimateSprite).w
		lea	DatDPLC_ArcherArmor(pc),a2
		jsr	Perform_DPLC
		jmp	(Obj_ArcherArmor_Display).l
; ---------------------------------------------------------------------------

Obj_ArcherArmor_Index:
		dc.w Obj_ArcherArmor_Main-Obj_ArcherArmor_Index		; 0
		dc.w Obj_ArcherArmor_Move-Obj_ArcherArmor_Index
		dc.w Obj_ArcherArmor_FindFloor-Obj_ArcherArmor_Index
		dc.w Obj_ArcherArmor_Shoot-Obj_ArcherArmor_Index
		dc.w Obj_ArcherArmor_WaitUntil-Obj_ArcherArmor_Index

DatDPLC_ArcherArmor:
		dc.l ArtUnc_ArcherArmor>>1, ObjDPLC_ArcherArmor
; ---------------------------------------------------------------------------

Obj_ArcherArmor_Display:
                btst    #6,$2A(a0)
                bne.s  	+
                move.b 	#0,d0
                move.b 	obAnim(a0),d0
                move.b 	ArcherArmor_Data_Collision(pc,d0.w),d1
                move.b 	d1,obColType(a0)

+  		move.b	$1C(a0),d0
		beq.s	Obj_ArcherArmor_Animate
		lsr.b	#3,d0
		bcc.w	Obj_ArcherArmor_Return

Obj_ArcherArmor_Animate:
		jmp	Sprite_CheckDeleteTouchSlotted		; NAT: Also delete object if offscreen
; ---------------------------------------------------------------------------

ArcherArmor_Data_Collision:
                dc.b  $23, $17, $17, $17, 0, 0
; ---------------------------------------------------------------------------

Obj_ArcherArmor_GetReady:
		jsr	(ChkObjOnScreen).w
		bne.w	Obj_ArcherArmor_Return
		jsr	(Find_Sonic).w
		cmpi.w	#$40,d3
		bcc.w	Obj_ArcherArmor_Return
		sub.w	#1,objoff_44(a0)
		bpl.w	Obj_ArcherArmor_Return
		samp	sfx_ArcherArmorAtk
		move.b	#1,obAnim(a0)
		jsr	(Obj_Eggman_LookOnSonic).l
		move.b	#6,routine(a0)
		rts

Obj_ArcherArmor_Process:
		tst.b   $28(a0)
		bne.w   .rts
		tst.b   $29(a0)
		beq.s   .gone
		tst.b   $1C(a0)
		bne.s   .whatizit
		move.b  #$3C,$1C(a0)
		sfx	sfx_KnucklesKick
		bset    #6,$2A(a0)

		move.w	respawn_addr(a0),d0	; load respawn address
		beq.s	.whatizit		; if 0, ignore
		move.w	d0,a2			; copy to a2
		move.b	(a2),d0			; load to d0
		and.b	#$7F,d0			; clear custom bits
		or.b	$29(a0),d0		; put the hit counter there
		move.b	d0,(a2)			; save it back

.whatizit:
		moveq   #0,d0
		btst    #0,$1C(a0)
		bne.s   .flash
		addi.w  #4,d0

.flash:
		subq.b   #1,$1C(a0)
		bne.s    .rts
		bclr     #6,$2A(a0)
		move.b   $25(a0),$28(a0)

.rts
		rts

.gone:
		move.w	respawn_addr(a0),d0	; load respawn address
		beq.s	.norespawn		; if 0, ignore
		move.w	d0,a2			; copy to a2
		move.b	#$82,(a2)		; make sure object does not respawn

.norespawn
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.lacricium
		move.b	#8,$2C(a1)
		move.l	#Go_Delete_SpriteSlotted2,(a0)

.lacricium:
		jmp	Go_Delete_SpriteSlotted3
; ---------------------------------------------------------------------------

Obj_ArcherArmor_Main:
		lea	ObjDat_ArcherArmor(pc),a1
		jsr	SetUp_ObjAttributesSlotted

		move.w	#30,objoff_44(a0)
		or.b	#4,obRender(a0)
		move.b	#16,x_radius(a0)
		move.b	#$1E,y_radius(a0)
		move.b	#1,$29(a0)
                move.w	(Difficulty_Flag).l,d0
                beq.s   +
		move.b	#2,$29(a0)

+		move.w	respawn_addr(a0),d0	; load respawn address
		beq.s	.norespawn		; if 0, ignore
		move.w	d0,a2			; copy to a2
		move.b	(a2),d0			; get contents to d0
		and.b	#$7F,d0			; get only custom bits
		sub.b	d0,$29(a0)		; sub from hit counter

.norespawn
		jsr	(ObjectFall).w
		jsr	(ObjHitFloor).w
		tst.w	d1
		bpl.s	+
		add.w	d1,obY(a0)			; match	object's position with the floor
		move.w	#0,obVelY(a0)
		bchg	#0,obStatus(a0)		; change object's orientation
+		rts
; -----------------------------------------------------------------------------

Obj_ArcherArmor_Move:
		addq.b	#2,routine(a0)
		move.w	#-$100,obVelX(a0)	; move object to the left
		move.b	#0,obAnim(a0)			; change direction
		bchg	#0,obStatus(a0)
		bne.w	Obj_ArcherArmor_Return
		neg.w	obVelX(a0)			; change direction
; ---------------------------------------------------------------------------

Obj_ArcherArmor_FindFloor:
		jsr	(SpeedToPos).w

		move.w	x_pos(a0),d3
		subi.w	#8,d3
		btst	#0,obStatus(a0)
		beq.s	+
		addi.w	#$F,d3
+		jsr	(ObjCheckFloorDist2).w
		cmpi.w	#-8,d1
		blt.s	Obj_ArcherArmor_Pause
		cmpi.w	#$C,d1
		bge.s	Obj_ArcherArmor_Pause
		add.w	d1,obY(a0)				; match object's position with the floor
		jmp	(Obj_ArcherArmor_GetReady).l
; ---------------------------------------------------------------------------

Obj_ArcherArmor_Pause:
		subq.b	#2,routine(a0)
		rts

Obj_ArcherArmor_Shoot:
		cmpi.b	#2,obAnim(a0)
		bne.w	Obj_ArcherArmor_Return
		move.w	#18,objoff_44(a0)
		jsr	(SingleObjLoad2).w
		bne.w	Obj_ArcherArmor_Return
		move.l	#Obj_ArcherArmor_Arrow,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	a0,parent(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.w	#-$600,obVelY(a1)
		move.w	#$500,obVelX(a1)
		btst	#0,obStatus(a0)		; is Coconuts facing left?
		bne.w	+			; if not, branch
		neg.w	obVelX(a1)
+		addq.b	#2,routine(a0)

Obj_ArcherArmor_WaitUntil:
;		cmpi.b	#1,objoff_47(a0)
;		bne.s	Obj_ArcherArmor_Return
;		clr.b	objoff_47(a0)
		sub.w	#1,objoff_44(a0)
		bpl.w	Obj_ArcherArmor_Return
		move.b	#0,obAnim(a0)
		move.w	#90,objoff_44(a0)
		move.b	#2,routine(a0)

Obj_ArcherArmor_Return:
		rts
; ---------------------------------------------------------------------------

ObjDat_ArcherArmor:
	SlotDataMGZ0	$0000, SME_7Vgsz, 4*$80, 48/2, $22, $00, $29

ObjDat_ArcherArmorArrow:
        subObjData SME_7Vgsz,$4E0,4*$80, 4, 4, $00, $26|$80
; ---------------------------------------------------------------------------

Obj_ArcherArmor_Arrow:
		lea	ObjDat_ArcherArmorArrow(pc),a1
		jsr	(SetUp_ObjAttributes).w

		move.b	#4,obRender(a0)
		move.b	#4,x_radius(a0)
		move.b	#4,y_radius(a0)
		move.b	#4,obAnim(a0)
		clr.b	objoff_47(a0)
		move.l	#Obj_ArcherArmor_Arrow_Move,(a0)

Obj_ArcherArmor_Arrow_Move:
		move.w	(Camera_max_y_pos).w,d0
		add.w	#224,d0			; NAT: We need to check BOTTOM of screen, not top!
		move.w	obY(a0),d1
		cmp.w	d0,d1
		bgt.s	.delete
		move.w	(Camera_min_y_pos).w,d0
		cmp.w	d0,d1
		ble.s	.delete

		jsr	SpeedToPos
		jsr	ObjHitFloor
		tst.w	d1
		bpl.s	.display

		neg.w	obVelY(a0)
		addq.b	#1,objoff_47(a0)
		cmpi.b	#4,objoff_47(a0)	; check if bounced 4 times
		blo.s	.flip			; if not, just flip object

.delete
		move.l  #Go_Delete_SpriteSlotted2,(a0)		; delete object
		bra.s	.display

.flip
		bchg	#1,obStatus(a0)

.display
		lea	Ani_ArcherArmor(pc),a1
		jsr	AnimateSprite
		lea	DatDPLC_ArcherArmor(pc),a2
		jsr	Perform_DPLC
		jmp	Sprite_CheckDeleteTouchSlotted
; ---------------------------------------------------------------------------

		include "Objects/Archer Armor/Object data/Ani - Archer Armor.asm"
		include "Objects/Archer Armor/Object data/Map - Archer Armor.asm"

ObjDPLC_ArcherArmor:
		include "Objects/Archer Armor/Object data/DPLC - Archer Armor.asm"

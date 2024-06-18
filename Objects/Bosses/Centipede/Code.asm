;CentipedePosTable = Pos_objTable
obNebTarget = objoff_30		; word
obNebCeilingX = objoff_34		; word
obNebTimer = objoff_36		; byte
obSub3Speed = objoff_37		; byte
obNebCeilingY = objoff_38		; word
obNebTablePos = objoff_3A		; word
obNebNum = objoff_2F		; byte
Centipede_Frames = $60
Centipede_Sprites = $A

Obj_Centipede:
		tst.w	(AstarothCompleted).w
		bne.w	Obj_Centipede_Delete
		moveq 	#0,d0
		move.b 	obRoutine(a0),d0
		move.w 	Obj_Centipede_Index(pc,d0.w),d1
		jsr	Obj_Centipede_Index(pc,d1.w)
		bsr.w	Obj_Centipede_MoveChildren
		bsr.w	Obj_Centipede_MoveParticles
		bsr.w	Obj_Centipede_MoveEyes
		bsr.w	Obj_Centipede_StorePos
		move.b	(v_framebyte),d0
		andi.b	#3,d0
		bne.s	.display
		bchg	#0,obRender(a0)
	.display:
		jmp	(Draw_And_Touch_Sprite).w
; ==================================================================
Obj_Centipede_Index:
		dc.w Obj_Centipede_Init-Obj_Centipede_Index	; 0
		dc.w Obj_Centipede_Main-Obj_Centipede_Index	; 2 Inside Walls
		dc.w Obj_Centipede_Main-Obj_Centipede_Index	; 4 Outside Walls
; ==================================================================

Obj_Centipede_Process:
		move.b	#60,MGZEmbers_Spawn.w			; disable ember spawning while boss is alive
		tst.b   obColType(a0)
		bne.w   .lacricium
		tst.b   obColProp(a0)
		beq.s   .gone
		tst.b   obInertia(a0)
		bne.s   .whatizit
		move.b  #$3C,obInertia(a0)
		sfx	sfx_KnucklesKick
		move.w	parent(a0),a1
		move.b	#0,obColType(a1)
		bset    #6,obStatus(a0)

.whatizit:
		moveq   #0,d0
		btst    #0,obInertia(a0)
		bne.s   .flash

		addi.w	#7*2,d0

.flash:
		jsr	(BossFlash_Nebiroth).l
		subq.b	#1,obInertia(a0)
		bne.w	.lacricium
		move.w	parent(a0),a1
		move.b	#$8A,obColType(a1)
		bclr	#6,obStatus(a0)
		move.b	collision_restore_flags(a0),obColType(a0)
		rts

; ==================================================================

.gone:
		move.w	#1,(AstarothCompleted).w
		move.b	#1,objoff_49(a0)
		clr.b	(MidBoss_flag).w
		sf	(Screen_shaking_flag).w
		jsr	(Create_New_Sprite).w
		bne.s	.skip1
		move.l	#Obj_Song_Fade_ToLevelMusic,(a1)
.skip1

		clr.w	(Camera_min_X_pos).w
	;	move.b	#4,(Hyper_Sonic_flash_timer).w
		cmpi.w  #70,(v_rings).w;
		bcc.s   .contdying
		move.w	#70,(v_rings).w
		move.b	#$80,(Update_HUD_ring_count).w

.contdying:
		jsr	(Obj_KillBloodCreate).l
      		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild1_Normal).w
		bne.s	.skip
		move.b	#8,obSubtype(a1)

.skip		move.l	#Delete_Current_Sprite,(a0)
		lea	(PLC2_GMZ2_Enemy).l,a5
		jsr	(LoadPLC_Raw_KosM).w

.lacricium:
		rts

; =============== S U B R O U T I N E =======================================

Obj_Centipede_Flash:
		lea	.palettelines(pc),a1
		lea	.colors(pc,d0.w),a2
		jmp	CopyWordData_4
; ---------------------------------------------------------------------------

.palettelines:
		dc.w Normal_palette_line_2+$10
		dc.w Normal_palette_line_2+$12
		dc.w Normal_palette_line_2+$14
		dc.w Normal_palette_line_2+$16

.colors:
		dc.w $222
		dc.w $442
		dc.w $462
		dc.w $682
		dc.w $8E8
		dc.w $AEA
		dc.w $CEC
		dc.w $EEE

; ==================================================================

BossFlash_Nebiroth:
		lea	.palcycle(pc,d0.w),a2			; temporary code? :D
		lea	.palram(pc),a1
		jmp	(CopyWordData_7).w
; ---------------------------------------------------------------------------

.palram
		dc.w Normal_palette_line_2+2
		dc.w Normal_palette_line_2+4
		dc.w Normal_palette_line_2+6
		dc.w Normal_palette_line_2+8
		dc.w Normal_palette_line_2+$A
		dc.w Normal_palette_line_2+$C
		dc.w Normal_palette_line_2+$E
.palcycle
		dc.w $202, $224, $246, $268, $28A, $2AC, $6CE
		dc.w $222, $444, $666, $888, $AAA, $CCC, $EEE
; ==================================================================

Obj_Centipede_Init:
		move.w	#$400,obVelX(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Centipede,obMap(a0)
		move.w	#$2403,obGfx(a0)
		move.b	#0,obFrame(a0)
		move.b	#4,obRender(a0)
		move.w	#4*$80,obPriority(a0)
		move.b	#$8F,obColType(a0)
		move.b	#$1F,obHeight(a0)
		move.b	#$1F,obWidth(a0)
		move.b	#$1F,x_radius(a0)
		move.b	#$1F,y_radius(a0)
		move.b	#0,objoff_49(a0)
		move.b	#0,obAngle(a0)
		move.w	#$180,obInertia(a0)
		move.w	#(v_player+obX)&$FFFF,obNebTarget(a0)
		move.w	#$400,obNebCeilingX(a0)
		move.w	#$160,obNebCeilingY(a0)

		jsr	(SingleObjLoad).w
		bne.w	.created
		move.w	a1,obParent3(a0)
		move.l	#Draw_Sprite,(a1)
		move.l	#Map_Centipede,obMap(a1)
		move.w	#$2403,obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	#3*$80,obPriority(a1)
		move.b	#4,obHeight(a1)
		move.b	#4,obWidth(a1)
		move.b	#4,x_radius(a1)
		move.b	#4,y_radius(a1)
		move.b	#5,obFrame(a1)
		movea.w	a1,a2
		jsr	(SingleObjLoad).w
		bne.w	.created
		move.w	a1,obParent3(a2)
		move.l	#Draw_Sprite,(a1)
		move.l	#Map_Centipede,obMap(a1)
		move.w	#$2403,obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	#3*$80,obPriority(a1)
		move.b	#4,obHeight(a1)
		move.b	#4,obWidth(a1)
		move.b	#4,x_radius(a1)
		move.b	#4,y_radius(a1)
		move.b	#5,obFrame(a1)

		moveq	#0,d3
		move.w	#Centipede_Sprites-1,d1
		movea.w	a0,a2
		lea	Obj_Centipede_Frame,a3

	.createchild:
		jsr	(SingleObjLoad).w
		bne.s	.created
		move.w	a1,obParent(a2)
		move.l	#Obj_Centipede_Child,(a1)
		move.l	#Map_Centipede,obMap(a1)
		move.b	d3,obNebNum(a1)
		addq.b	#2,d3
		move.w	#$2403,obGfx(a1)
		move.b	#4,obRender(a1)
		move.w	#4*$80,obPriority(a1)
		move.b	#$1F,obHeight(a1)
		move.b	#$1F,obWidth(a1)
		move.b	#$1F,x_radius(a1)
		move.b	#$1F,y_radius(a1)
		move.b	(a3)+,obFrame(a1)
		move.b	(a3)+,obColType(a1)
		movea.w	a1,a2
		dbf	d1,.createchild
		move.l	#Obj_Centipede_Vulnerable,(a1)
		move.b	#$1A,obColType(a1)
		move.b	#4,obFrame(a1)
		move.w	(Difficulty_Flag).w,d0
		move.b  Obj_Centipede_HP(pc,d0.w),obColProp(a1)

	.created:
		bsr.w	Obj_Centipede_CreateTable
		clr.w	obNebTablePos(a0)
		bsr.w	Obj_Centipede_CreateParticles
		bra.s	Obj_Centipede_Main

Obj_Centipede_HP:
		dc.b 6/2	; Easy
		dc.b 6		; Normal
		dc.b 6+2	; Hard
		dc.b 6+2	; Maniac
; ==================================================================

Obj_Centipede_Frame:
		dc.b	0, $9A
		dc.b	0, $9A
		dc.b	1, $8B
		dc.b	1, $8B
		dc.b	2, $8B
		dc.b	2, $8B
		dc.b	3, $87
		dc.b	3, $87
		dc.b	3, $87
; ==================================================================

Obj_Centipede_Main:
		move.w	obX(a0),d0
		subi.w	#$380+8,d0
		bcs.w	.inground
		cmpi.w	#$100-$10,d0
		bcc.w	.inground
		move.w	obY(a0),d0
		subi.w	#$140+8,d0
		bcs.s	.inground
		cmpi.w	#$C0-$10,d0
		bcc.s	.inground
		cmpi.b	#2,obRoutine(a0)
		bne.s	.outside
		sfx	sfx_BreakWall
		sf	(Screen_shaking_flag).w
		addq.b	#2,obRoutine(a0)
		move.b	obAngle(a0),d0
		jsr	(CalcSine).w
		muls.w	obInertia(a0),d1
		asr.l	#7,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#7,d0
		move.w	d0,obVelY(a0)

		movea.w	obParent2(a0),a1
		moveq	#$38,d4

	.spawnloop:
		move.w	d4,-(sp)
		bsr.w	Obj_Centipede_SpawnParticle
		move.w	(sp)+,d4
		subq.w	#8,d4
		bcc.s	.spawnloop

	.outside:
		addi.w	#8,obVelY(a0)
		jsr	(SpeedToPos).w
		move.w	obVelX(a0),d1
		move.w	obVelY(a0),d2
		jsr	(CalcAngle).w
		move.b	d0,obAngle(a0)
		rts

	.inground:
		cmpi.b	#2,obRoutine(a0)
		beq.s	.inside
		subq.b	#2,obRoutine(a0)
		move.b	#30,obNebTimer(a0)
		st	(Screen_shaking_flag).w
		move.w	#(v_player+obX)&$FFFF,obNebTarget(a0)
		jsr	(Random_Number).w
		andi.b	#7,d0
		bne.s	.inside
		lea	obNebCeilingX(a0),a1
		move.w	a1,obNebTarget(a0)

	.inside:
		moveq	#3,d0
		and.b	V_int_run_count+3.w,d0			; check if this is every 4th frame
		bne.s	.nosfx4u				; if not, branch
		samp	sfx_SpecialRumble			; low priority sfx

	.nosfx4u:
		subq.b	#1,obNebTimer(a0)
		bpl.s	.speed
		addq.b	#1,obNebTimer(a0)
		movea.w	obNebTarget(a0),a1
		move.w	0(a1),d1
		move.w	d1,obNebCeilingX(a0)
		sub.w	obX(a0),d1
		move.w	4(a1),d2
		sub.w	obY(a0),d2
		jsr	(CalcAngle).w
		move.b	obAngle(a0),d1
		sub.b	d1,d0
		beq.s	.correct
		bmi.s	.decrease
		addq.b	#2,d1

	.decrease:
		subq.b	#1,d1

	.correct:
		move.b	d1,d0
		move.b	d0,obAngle(a0)
		jsr	(CalcSine).w
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)

	.speed:
		jmp	(SpeedToPos).w

Obj_Centipede_Return:
		rts

; ==================================================================
Obj_Centipede_Child:
		tst.w	(AstarothCompleted).w
		bne.s	Obj_Centipede_Delete2
		move.b	(v_framebyte),d0
		add.b	obNebNum(a0),d0
		andi.b	#3,d0
		bne.s	.display
		bchg	#0,obRender(a0)
	.display:
		jmp	(Draw_And_Touch_Sprite).w

Obj_Centipede_Delete:
		movea.w	obParent2(a0),a1
		jsr	(DeleteChild).w
		movea.w	obParent3(a0),a2
		movea.w	obParent3(a2),a1
		jsr	(DeleteChild).w
		move.w	a2,a1
		jsr	(DeleteChild).w
		addq.b	#2,(Dynamic_resize_routine).w

Obj_Centipede_Delete2:
		jmp	(DeleteObject).w

Obj_Centipede_Vulnerable:
		bsr.w	Obj_Centipede_Process
		move.b	#4,obFrame(a0)
		jmp	(Draw_And_Touch_Sprite).w

; ==================================================================
Obj_Centipede_CreateTable:
		move.l	obX(a0),d0
		move.w	obY(a0),d0
		moveq	#Centipede_Frames-1,d1
		lea	(CentipedePosTable).w,a2

	.filltable:
		move.l	d0,(a2)+
		dbf	d1,.filltable
		rts

; ==================================================================
Obj_Centipede_StorePos:
		move.w	obNebTablePos(a0),d0
		lea	(CentipedePosTable).w,a2
		adda.w	d0,a2
		move.w	obX(a0),(a2)+
		move.w	obY(a0),(a2)+
		addq.w	#4,d0
		cmpi.w	#Centipede_Frames*4,d0
		bne.s	.return
		moveq	#0,d0

	.return:
		move.w	d0,obNebTablePos(a0)
		rts

; ==================================================================
Obj_Centipede_MoveChildren:
		move.w	obNebTablePos(a0),d0
		move.w	#Centipede_Sprites-1,d1
		moveq	#0,d2
		movea.w	obParent(a0),a1
		lea	(CentipedePosTable).w,a3

	.childloop:
		move.b	obNebNum(a1),d2
		sub.w	Obj_Centipede_Timing(pc,d2.w),d0
		bcc.s	.noreset
		addi.w	#Centipede_Frames*4,d0

	.noreset:
		movea.w	a3,a2
		adda.w	d0,a2
		move.w	(a2)+,obX(a1)
		move.w	(a2)+,obY(a1)
		movea.w	obParent(a1),a1
		dbf	d1,.childloop
		rts

Obj_Centipede_Timing:
		dc.w	7*4, 7*4, 6*4, 5*4, 5*4, 5*4, 5*4, 4*4, 4*4, 4*4

; ==================================================================

Obj_Centipede_CreateParticles:
		jsr	(SingleObjLoad).w
		bne.s	.exit
		move.w	a1,obParent2(a0)
		move.l	#Draw_Sprite,(a1)
		move.b	#8,obHeight(a1)
		move.b	#8,obWidth(a1)
		move.w	#$360,obX(a1)
		move.w	#$12C,obY(a1)
		move.l	#Map_Centipede,obMap(a1)
		move.b	#0,obFrame(a1)
		move.w	#$C403,obGfx(a1)
		move.b	#$44,obRender(a1)				; set multi-draw flag
		move.w	#$80,obPriority(a1)
		move.w	#8,mainspr_childsprites(a1)
	.exit:
		rts
; ==================================================================

Obj_Centipede_MoveParticles:
		movea.w	obParent2(a0),a1
		cmpi.b	#2,obRoutine(a0)
		bne.s	.moveparticles
		move.w	(v_framecount).w,d4
		move.w	d4,d5
		andi.w	#7,d5
		bne.w	.moveparticles
		bsr.w	Obj_Centipede_SpawnParticle

	.moveparticles:
		lea	sub2_x_pos(a1),a2
		moveq	#0,d0
		bsr.s	.loop
		moveq	#0,d1
		move.b	5(a2),d1
		subi.w	#$F,d1
		sub.w	d1,(a2)
		cmpi.w	#$240,2(a2)
		bhi.s	.next
		move.b	obSub3Speed(a0),d1
		ext.w	d1
		add.w	d1,2(a2)
		addq.b	#1,obSub3Speed(a0)

	.next:
		adda.w	#6,a2
		moveq	#5,d0

	.loop:
		moveq	#0,d1
		move.b	5(a2),d1
		subi.w	#$F,d1
		sub.w	d1,(a2)
		cmpi.w	#$240,2(a2)
		bhi.s	.next2
		move.b	4(a2),d1
		ext.w	d1
		add.w	d1,2(a2)
		addq.b	#1,4(a2)

	.next2:
		adda.w	#6,a2
		dbf	d0,.loop
		move.b	#9,obFrame(a1)
		rts
; ==================================================================

Obj_Centipede_SpawnParticle:
		move.w	obX(a0),d0
		move.w	obY(a0),d1
		cmpi.w	#$380+$A,d0
		blo.s	.left
		cmpi.w	#$480-$A,d0
		bhi.s	.right
		cmpi.w	#$140+$A,d1
		blo.s	.top
		cmpi.w	#$200-$A,d1
		bhi.w	.bottom
		rts

	.left:
		jsr	(Random_Number).w
		andi.b	#1,d0
		move.b	d0,d6
		addi.b	#$D,d6
		move.w	#$380,d2
		move.w	#$140,d3
		move.w	obY(a0),d1
		cmpi.w	#$140,d1
		blo.s	.cont
		move.w	#$200,d3
		cmpi.w	#$200,d1
		bhi.s	.cont
		move.w	d1,d3
		bra.s	.cont

	.right:
		jsr	(Random_Number).w
		andi.b	#1,d0
		move.b	d0,d6
		addi.b	#$10,d6
		move.w	#$480,d2
		move.w	#$140,d3
		move.w	obY(a0),d1
		cmpi.w	#$140,d1
		blo.s	.cont
		move.w	#$200,d3
		cmpi.w	#$200,d1
		bhi.s	.cont
		move.w	d1,d3
		bra.s	.cont

	.top:
		jsr	(Random_Number).w
		andi.b	#3,d0
		move.b	d0,d6
		addi.b	#$D,d6
		cmpi.b	#$F,d6
		bne.s	.toprando
		addq.b	#2,d6

	.toprando:
		move.w	obX(a0),d2
		move.w	#$140,d3
		bra.s	.cont

	.bottom:
		jsr	(Random_Number).w
		andi.b	#3,d0
		move.b	d0,d6
		addi.b	#$D,d6
		cmpi.b	#$F,d6
		bne.s	.botrando
		addq.b	#2,d6

	.botrando:
		move.w	obX(a0),d2
		move.w	#$200,d3

	.cont:
		andi.w	#$38,d4
		lsr.w	#2,d4
		move.w	d4,d5
		add.w	d5,d5
		add.w	d5,d4
		lea	sub2_x_pos(a1),a2
		adda.w	d4,a2
		move.w	d2,(a2)+
		move.w	d3,(a2)+
		jsr	(Random_Number).w
		andi.b	#7,d0
		subi.b	#9,d0
		cmpi.w	#6,d4
		bne.s	.normal
		move.w	d6,(a2)
		move.b	d0,obSub3Speed(a0)
		rts

	.normal:
		move.b	d0,(a2)+
		move.b	d6,(a2)
		rts
; ==================================================================
Obj_NebParticles:
		jmp	(Draw_Sprite).w

; ==================================================================

Obj_Centipede_MoveEyes:
		lea	(v_player).w,a2
		movea.w	obParent3(a0),a1
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obX(a2),d1
		sub.w	obX(a0),d1
		move.w	obY(a2),d2
		sub.w	obY(a0),d2
		jsr	(CalcAngle).l
		move.b	d0,d2
		addi.b	#$10,d0
		lsr.b	#5,d2
		addi.b	#5,d2
		move.b	d2,obFrame(a1)


		move.b	obAngle(a0),d0
		addi.b	#$10,d0
		jsr	(CalcSine).l
		asr.w	#4,d0
		asr.w	#4,d1
		add.w	d1,obX(a1)
		add.w	d0,obY(a1)
		movea.w	obParent3(a1),a1
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obAngle(a0),d0
		subi.b	#$10,d0
		move.b	d2,obFrame(a1)

		jsr	(CalcSine).l
		asr.w	#4,d0
		asr.w	#4,d1
		add.w	d1,obX(a1)
		add.w	d0,obY(a1)
		rts

; ==================================================================
		include "Objects/Bosses/Centipede/Object data/Map - Centipede.asm"

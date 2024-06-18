; ---------------------------------------------------------------------------
; Boss Grim Reaper from the Gaiares.
; Version 1.0
; By TheBlad768 (2022).
; ---------------------------------------------------------------------------

; Debug
_BD_TEST_					= 0	; draw collision

; Hits
BossGrimReaper_Hits			= 4
BossGrimReaper_VRAM		= $60
BossGrimReaper_Width		= 184
BossGrimReaper_Height		= 240

; Dynamic object variables
obBGR_Flash					= objoff_1C	; .b
obBGR_Wait					= objoff_2E	; .w
obBGR_DeformFactor			= objoff_30	; .w
obBGR_Jump				= objoff_34	; .l
obBGR_Opt					= objoff_38	; .b
obBGR_Count				= objoff_39	; .b
obBGR_SaveFrame			= objoff_3A	; .b
obBGR_Routine				= objoff_3E	; .b
obBGR_Attack				= objoff_3F	; .b
obBGR_Boat					= objoff_46	; .w

; Functions (objoff_38 Opt)
optBGR_Pinch				= 0
optBGR_Hide				= 1
optBGR_Hurt				= 2

; RAM
BossGrimReaper_buffer		= $FFFF1000		; $1000 bytes
BossGrimReaper_buffer_end	= $FFFF2000

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper:

		; fill palette with black
		moveq	#cBlack,d0
		moveq	#16/4-1,d1
		lea	(Normal_palette_line_4).w,a1

.clrRAM
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,.clrRAM

		; clear buffer
		bsr.w	BossGrimReaper_Animate.clearframe

		; clear scroll buffer
		clearRAM H_scroll_buffer, H_scroll_buffer_End

		; init
		move.l	#VInt_BossGrimReaper,(V_int_addr).w
		move.l	#SCZ1_ScreenEvent_Boss,(Level_data_addr_RAM.ScreenEvent).w
		move.l	#SCZ3_BackgroundEvent,(Level_data_addr_RAM.BackgroundEvent).w
		move.w	#-$50,(Camera_X_pos_BG_copy).w
		clr.w	(Camera_Y_pos_BG_copy).w
		st	(Boss_flag).w
		st	(Screen_shaking_flag).w
		st	(Sonic_NoKill).w
		bclr	#7,(Player_1+art_tile).w
		bclr	#optBGR_Hide,obBGR_Opt(a0)
		st	obBGR_SaveFrame(a0)				; reset dplc frame

		; mapping
		lea	ObjDat3_BossGrimReaper(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		clr.b	routine(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	BossGrimReaper_HP(pc,d0.w),collision_property(a0)	; set hits
		move.w	#bytes_to_word(32/4,16/4),y_radius(a0)
		move.w	#$F,obBGR_Wait(a0)
		move.l	#BossGrimReaper_Startup,$34(a0)
		move.l	#BossGrimReaper_SetupMove,address(a0)

	if _BD_TEST_
		; test
		move.l	#Map_Monitor,mappings(a0)
		move.w	#BossGrimReaper_VRAM|$8000,art_tile(a0)
		; test
	endif

		lea	Child6_BossGrimReaper_Mask(pc),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGrimReaper_HP:
		dc.b BossGrimReaper_Hits/2	; Easy
		dc.b BossGrimReaper_Hits		; Normal
		dc.b BossGrimReaper_Hits		; Hard
		dc.b BossGrimReaper_Hits		; Maniac
; ---------------------------------------------------------------------------

BossGrimReaper_SetupMoveSwing:

		; swing move
		move.b	angle(a0),d0
		addq.b	#2,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#3,d0
		move.w	d0,y_vel(a0)

BossGrimReaper_SetupMoveBG:

		; move boss plane
		bsr.w	BossGrimReaper_Deform_MoveBG

		bra.s	BossGrimReaper_SetupMove
; ---------------------------------------------------------------------------

BossGrimReaper_SetupDeform:

		; deform boss
		bsr.w	BossGrimReaper_Deform

BossGrimReaper_SetupMove:

		; move BG boss
		movem.w	x_vel(a0),d0-d1
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,(Camera_X_pos_BG_copy).w
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,(Camera_Y_pos_BG_copy).w

		; collision xpos
		move.w	(Camera_X_pos).w,d0
		move.b	x_radius(a0),d1
		ext.w	d1
		add.w	d1,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	d0,x_pos(a0)

		; collision ypos
		move.w	(Camera_Y_pos).w,d0
		sub.w	(Camera_Y_pos_BG_copy).w,d0
		move.b	y_radius(a0),d1
		ext.w	d1
		add.w	d1,d1
		add.w	d1,d1
		add.w	d1,d0
		move.w	d0,y_pos(a0)

		; main process
		pea	BossGrimReaper_MainProcess(pc)
		jmp	(Obj_Wait).w

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGrimReaper_Startup:
		move.w	#7,obBGR_Wait(a0)
		move.l	#BossGrimReaper_Appearance,$34(a0)
		move.l	#BossGrimReaper_SetupDeform,address(a0)
		move.w	#$7E,obBGR_DeformFactor(a0)

.find
		moveq	#0,d0
		move.b	obBGR_Routine(a0),d0
		addq.b	#1,obBGR_Routine(a0)

		; check mode
		lea	.setmovement2(pc),a1				; assist, normal
		cmpi.w	#2,(Difficulty_Flag).w
		blo.s		.load
		lea	.setmovement1(pc),a1				; hard, maniac

.load
		move.b	(a1,d0.w),d0
		bmi.s	.restart
		move.b	d0,obBGR_Attack(a0)
		rts
; ---------------------------------------------------------------------------

.restart
		clr.b	obBGR_Routine(a0)
		bra.s	.find
; ---------------------------------------------------------------------------

.setmovement1

._attack		= 0
._spring		= 1
._end		= -1

		dc.b ._attack	; left
		dc.b ._attack	; right
		dc.b ._spring	; left
		dc.b ._attack	; right
		dc.b ._spring	; left
		dc.b ._spring	; right
		dc.b ._attack	; left
		dc.b ._spring	; right
		dc.b ._attack	; left

		dc.b ._end
	even

.setmovement2
		dc.b ._spring	; left
		dc.b ._attack	; right
		dc.b ._spring	; left
		dc.b ._attack	; right
		dc.b ._spring	; left
		dc.b ._attack	; right
		dc.b ._spring	; left
		dc.b ._spring	; right
		dc.b ._attack	; left
		dc.b ._spring	; right
		dc.b ._attack	; left
		dc.b ._attack	; right

		dc.b ._end
	even

; =============== S U B R O U T I N E =======================================

BossGrimReaper_Appearance:

		; normal palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#7,subtype(a1)						; wait time
		move.w	#$7F,objoff_2E(a1)					; wait time
		move.w	#Normal_palette_line_4,objoff_34(a1)	; palette ram
		move.w	#16-1,objoff_38(a1)					; palette size

		move.l	#Pal_BossGrimReaper,d0
		btst	#optBGR_Pinch,obBGR_Opt(a0)
		beq.s	.notpinchsp
		move.l	#Pal_BossGrimReaper+$40,d0

.notpinchsp
		move.l	d0,objoff_30(a1)						; palette pointer

.notfree

		; water palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	#7,subtype(a1)						; wait time
		move.w	#$7F,objoff_2E(a1)					; wait time
		move.w	#Water_palette_line_4,objoff_34(a1)	; palette ram
		move.w	#16-1,objoff_38(a1)					; palette size

		move.l	#Pal_BossGrimReaperWater,d0
		btst	#optBGR_Pinch,obBGR_Opt(a0)
		beq.s	.notpinchsp2
		move.l	#Pal_BossGrimReaperWater+$20,d0

.notpinchsp2
		move.l	d0,objoff_30(a1)						; palette pointer

.notfree2
		sfx	sfx_Magic
		bclr	#7,(Player_1+art_tile).w
		bclr	#optBGR_Hide,obBGR_Opt(a0)
		clr.l	(Camera_Y_pos_BG_copy).w
		move.b	#1,anim(a0)
		move.l	#BossGrimReaper_AppearanceDeform,$34(a0)

BossGrimReaper_AppearanceDeform:
		movea.w	obBGR_Boat(a0),a1
		moveq	#-4,d1
		move.w	#-$90,d0		; left side
		move.w	#$100,d2		; time for boat
		btst	#0,status(a0)
		beq.s	.notflipx
		neg.w	d1
		move.w	#$A0,d0			; right side
		moveq	#$40,d2			; time for boat

.notflipx
		move.w	d2,$2E(a1)		; time for boat
		add.w	d1,(Camera_X_pos_BG_copy).w
		cmp.w	(Camera_X_pos_BG_copy).w,d0
		bne.s	BossGrimReaper_AppearanceDeform2
		move.l	#BossGrimReaper_AppearanceDeform2,$34(a0)

BossGrimReaper_AppearanceDeform2:
		subq.w	#1,obBGR_DeformFactor(a0)
		bpl.s	.return
		clr.w	obBGR_DeformFactor(a0)
		sfx	sfx_Activation
		move.w	#$F,obBGR_Wait(a0)
		move.l	#BossGrimReaper_ClearMovement,$34(a0)
		move.l	#BossGrimReaper_SetupMove,address(a0)
		move.b	#$14,(Negative_flash_timer).w
		bset	#7,(Player_1+art_tile).w
		bset	#optBGR_Hide,obBGR_Opt(a0)

.return
		rts
; ---------------------------------------------------------------------------

BossGrimReaper_ClearMovement:
		move.w	#$1F,obBGR_Wait(a0)
		move.l	#BossGrimReaper_Attack,$34(a0)
		clr.l	x_vel(a0)
		clr.w	(Screen_shaking_flag).w

		moveq	#2-1,d0
		btst	#optBGR_Pinch,obBGR_Opt(a0)
		beq.s	.notpinch
		addq.b	#2,d0

.notpinch
		move.b	d0,obBGR_Count(a0)

BossGrimReaper_Return:
		rts
; ---------------------------------------------------------------------------

BossGrimReaper_Attack:
		moveq	#0,d0
		move.l	#BossGrimReaper_Return,$34(a0)
		move.b	obBGR_Count(a0),d0
		add.b	d0,d0
		add.b	d0,d0
		lea	BossGrimReaper_AttackIndex(pc,d0.w),a2
		tst.b	obBGR_Attack(a0)
		beq.s	.checkpunchline
		lea	BossGrimReaper_Attack2Index(pc,d0.w),a2

.checkpunchline
		btst	#optBGR_Pinch,obBGR_Opt(a0)
		beq.s	.create
		addq.w	#2*4,a2	; skip normal

.create
		movea.l	(a2),a2
		jmp	(CreateChild6_Simple).w
; ---------------------------------------------------------------------------

BossGrimReaper_AttackIndex:
		dc.l Child6_BossGrimReaper_ScytheChase		; 1
		dc.l Child6_BossGrimReaper_Scythe				; 0
; punchline � Yo!
		dc.l Child6_BossGrimReaper_ScytheChase		; 3
		dc.l Child6_BossGrimReaper_VortexBall_Process	; 2
		dc.l Child6_BossGrimReaper_Rings				; 1
		dc.l Child6_BossGrimReaper_Rings2				; 0

BossGrimReaper_Attack2Index:
		dc.l Child6_BossGrimReaper_Spring				; 1
		dc.l Child6_BossGrimReaper_Scythe				; 0
; punchline � Yo!
		dc.l Child6_BossGrimReaper_Spring				; 3
		dc.l Child6_BossGrimReaper_VortexBall_Process	; 2
		dc.l Child6_BossGrimReaper_Rings				; 1
		dc.l Child6_BossGrimReaper_Rings2				; 0
; ---------------------------------------------------------------------------

BossGrimReaper_DisappearanceHand:
		move.b	#3,anim(a0)
		move.w	#$4F,obBGR_Wait(a0)
		move.l	#BossGrimReaper_DisappearanceHand_MoveBoat,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossGrimReaper_DisappearanceHand_MoveBoat:
		movea.w	obBGR_Boat(a0),a1
		move.w	#$A0,$2E(a1)	; time for boat

BossGrimReaper_DisappearanceHand2:
		move.w	#$1F,obBGR_Wait(a0)

BossGrimReaper_DisappearanceHand3:
		move.l	#BossGrimReaper_Attack,d0
		subq.b	#1,obBGR_Count(a0)
		bpl.s	.notend
		move.w	#7,obBGR_Wait(a0)
		move.l	#BossGrimReaper_SetupDeform,address(a0)
		move.l	#BossGrimReaper_Disappearance,d0

.notend
		move.l	d0,$34(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossGrimReaper_Disappearance:

		; normal palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$F,subtype(a1)							; wait time
		move.w	#Normal_palette_line_4,objoff_34(a1)		; palette ram
		move.l	#Pal_BossGrimReaper+$20,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)						; palette size

.notfree

		; water palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	#$F,subtype(a1)							; wait time
		move.w	#Water_palette_line_4,objoff_34(a1)		; palette ram
		move.l	#Pal_BossGrimReaper+$20,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)						; palette size

.notfree2
		sfx	sfx_Magic
		bclr	#7,(Player_1+art_tile).w
		bclr	#optBGR_Hide,obBGR_Opt(a0)
		clr.l	(Camera_Y_pos_BG_copy).w
		move.b	#1,anim(a0)
		move.l	#BossGrimReaper_DisappearanceDeform,$34(a0)
		move.l	#BossGrimReaper_SetupDeform,address(a0)

BossGrimReaper_DisappearanceDeform:
		addq.w	#1,obBGR_DeformFactor(a0)
		cmpi.w	#$7E,obBGR_DeformFactor(a0)
		bne.s	.return
		move.w	#7,obBGR_Wait(a0)
		move.l	#BossGrimReaper_Startup,$34(a0)
		st	obBGR_SaveFrame(a0)

		moveq	#304/4,d0	; right side
		bchg	#0,status(a0)
		beq.s	.notflipx
		moveq	#16/4,d0		; left side

.notflipx
		move.b	d0,x_radius(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Mask (static)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Mask:

		; mapping
		lea	ObjDat_BossGrimReaper_Mask(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		bset	#5,render_flags(a0)	; set static mappings flag
		move.w	#bytes_to_word(-16,-23),child_dx(a0)	; set dxy
		move.l	#.refpos,address(a0)

.refpos
		jsr	(Refresh_ChildPositionAdjusted).w

		; not shaking mask
		move.w	(Screen_shaking_flag+2).w,d0
		add.w	d0,y_pos(a0)

.draw
		movea.w	parent3(a0),a1
		move.w	(Difficulty_Flag).w,d0
		move.b	collision_property(a1),d1
		lea	BossGrimReaper_CheckHP(pc),a2
		cmp.b	(a2,d0.w),d1
		beq.s	.delete
		btst	#optBGR_Hide,obBGR_Opt(a1)
		beq.s	.notdraw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.delete
		move.b	#$2F,(Negative_flash_timer).w
		lea	(Child6_CreateBossExplosion).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.skip
		move.b	#$22,subtype(a1)

.skip
		moveq	#3*4,d0
		jmp	(loc_849D8).w	; flicker

; ---------------------------------------------------------------------------
; Scythe (attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Scythe:

		; set xypos
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)

		; timer
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsl.w	#3,d0
		move.w	d0,d1
		add.w	d1,d1
		add.w	d1,d0
		addi.w	#8+$1F,d0
		move.w	d0,$2E(a0)

		; mapping
		lea	ObjDat_BossGrimReaper_Scythe(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.l	#.wait,address(a0)

		tst.b	subtype(a0)				; is the first scythe?
		bne.s	.return				; if not, branch

		; show boss hand
		movea.w	parent3(a0),a1
		move.b	#2,anim(a1)

.return
		rts
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.w	#$F,$2E(a0)
		move.l	#.waitaim,address(a0)

		; draw aim
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$8530,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$20,$44(a1)			; ypos
		move.w	#60-28,$2E(a1)		; timer
		move.b	#$10,subtype(a1)		; jump|art id nibble

.notfree
		movea.w	(sp)+,a0

.waitaim
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		sfx	sfx_LaserBeam
		move.l	#.endanim,address(a0)
		move.b	#$14,(Negative_flash_timer).w
		move.w	#$14,(Screen_shaking_flag).w

.endanim
		tst.b	routine(a0)
		beq.s	.anim
		clr.b	routine(a0)
		move.b	#$F|$80,collision_flags(a0)
		move.l	#.move,address(a0)
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	(Player_1+x_pos).w,d1
		sub.w	(Player_1+y_pos).w,d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		move.w	#-$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

		cmpi.b	#3*2-2,subtype(a0)	; is the last scythe?
		bne.s	.move				; if not, branch

		; hide boss hand
		movea.w	parent3(a0),a1
		move.w	#7,obBGR_Wait(a1)
		move.l	#BossGrimReaper_DisappearanceHand,$34(a1)

.move
		jsr	(MoveSprite2).w

.anim
		lea	Anim_BossGrimReaperScythe(pc),a1
		jsr	(Animate_Sprite).w

.draw
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Sprite_ChildCheckDeleteXY_NoDraw).w

; ---------------------------------------------------------------------------
; Scythe chase (attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_ScytheChase:

		; set xypos
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)

		; timer
		move.w	#$1F,$2E(a0)		; wait

		; mapping
		lea	ObjDat_BossGrimReaper_Scythe(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.l	#.waitboat,address(a0)
		rts
; ---------------------------------------------------------------------------

.waitboat
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.l	#.wait,address(a0)

		; timer
		move.w	#8+$1F,$2E(a0)		; wait + show hand

		; show boss hand
		movea.w	parent3(a0),a1
		move.b	#2,anim(a1)
		rts
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.w	#$1F,$2E(a0)
		move.l	#.waitaim,address(a0)

		; draw aim
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$8530,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$20,$44(a1)			; ypos
		move.w	#60-28,$2E(a1)		; timer
		move.b	#$10,subtype(a1)		; jump|art id nibble

.notfree
		movea.w	(sp)+,a0

.waitaim
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		sfx	sfx_LaserBeam
		move.l	#.endanim,address(a0)
		move.b	#$14,(Negative_flash_timer).w
		move.w	#$14,(Screen_shaking_flag).w

		; hide boss hand
		movea.w	parent3(a0),a1
		move.b	#3,anim(a1)
		move.l	#BossGrimReaper_SetupMoveSwing,address(a1)

.endanim
		tst.b	routine(a0)
		beq.s	.anim
		clr.b	routine(a0)
		move.b	#$F|$80,collision_flags(a0)
		move.w	#4*60,$2E(a0)
		move.l	#.chase,address(a0)

		; draw aim
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.chase
		move.w	#$8534,art_tile(a1)	; VRAM
		move.w	#$A0,$44(a1)		; ypos
		move.w	$2E(a0),$2E(a1)		; timer
		move.b	#$20,subtype(a1)		; jump|art id nibble

.chase
		jsr	(Find_SonicTails).w
		jsr	(Change_FlipX).w
		move.w	#$400,d0			; maximum speed
		moveq	#$10,d1				; acceleration
		jsr	(Chase_Object).w
		jsr	(MoveSprite2).w
		subq.w	#1,$2E(a0)
		bmi.s	.delete

.anim
		lea	Anim_BossGrimReaperScythe(pc),a1
		jsr	(Animate_Sprite).w

.draw
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.delete
		movea.w	parent3(a0),a1
		clr.l	x_vel(a1)
		move.w	#$F,obBGR_Wait(a1)
		move.l	#BossGrimReaper_SetupMove,address(a1)
		move.l	#BossGrimReaper_DisappearanceHand2,$34(a1)
		sfx	sfx_Transform
		move.b	#$14,(Negative_flash_timer).w
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Rings #2 (attack)
; ---------------------------------------------------------------------------

; Dynamic object variables
obBGRR_AltMode			= objoff_40	; .b

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Rings2:
		st	$40(a0)

; ---------------------------------------------------------------------------
; Rings (attack)
; ---------------------------------------------------------------------------

; Dynamic object variables
obBGRR_Frame			= objoff_30	; .b
obBGRR_Count			= objoff_39	; .b

obBGRR_SlotBit			= objoff_3B	; .b
obBGRR_SlotAddress		= objoff_3C	; .w

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Rings:

		; set xypos
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)

		; timer
		move.w	#$1F,$2E(a0)		; wait

		; mapping
		lea	ObjDat_BossGrimReaper_Scythe(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		clr.w	mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		move.l	#.wait,address(a0)

		; show boss hand
		movea.w	parent3(a0),a1
		move.b	#2,anim(a1)
		rts
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.w	#$1F,$2E(a0)
		move.l	#.waitaim,address(a0)

		; draw aim
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$8534,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$20,$44(a1)			; ypos
		move.w	#60-28,$2E(a1)		; timer
		move.b	#$10,subtype(a1)		; jump|art id nibble

.notfree
		movea.w	(sp)+,a0

.waitaim
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.l	#.endanim,address(a0)

		; hide boss hand
		movea.w	parent3(a0),a1
		move.b	#3,anim(a1)

		; draw aim
		move.w	a0,-(sp)
		movea.w	a1,a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	#$8530,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$20,$44(a1)			; ypos
		move.w	#60-48,$2E(a1)		; timer
		move.b	#$10,subtype(a1)		; jump|art id nibble

.notfree2
		movea.w	(sp)+,a0
		sfx	sfx_FireShow
		move.b	#$14,(Negative_flash_timer).w
		move.w	#$14,(Screen_shaking_flag).w

.endanim
		tst.b	routine(a0)
		beq.w	Obj_BossGrimReaper_ScytheChase.anim
		clr.b	routine(a0)
		clr.b	anim(a0)
		clr.w	mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		move.l	#.extrarings2,address(a0)
		lea	Child6_BossGrimReaper_RingsExtra(pc),a2
		moveq	#2,d2					; set subtype
		jmp	(CreateChild6_Simple2).w

; ---------------------------------------------------------------------------
; Extra rings (attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.extrarings
		movea.w	parent3(a0),a1
		move.w	parent3(a1),parent3(a0)	; boss address
		tst.b	$40(a1)
		sne	$40(a0)

.extrarings2

		; timer
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		move.w	d0,$2E(a0)

		; mapping
		lea	ObjDat4_BossGrimReaper_Rings(pc),a1
		jsr	(SetUp_ObjAttributesSlotted).w
		clr.b	routine(a0)
		move.l	#.ringswait,address(a0)
		rts
; ---------------------------------------------------------------------------

.ringswait
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.w	#2*60,$2E(a0)
		move.b	#4,anim_frame_timer(a0)
		clr.b	$30(a0)
		addq.w	#1,(Screen_shaking_flag).w
		move.l	#.anim,address(a0)

		movea.w	a0,a1
		lea	(Player_1).w,a2
		jsr	(CalcObjAngle).w
		move.b	d0,angle(a0)
		bsr.w	.getframe

		lea	.sonicangle(pc),a1
		tst.b	$40(a0)
		beq.s	.notset
		lea	.attackangle(pc),a1

.notset
		jsr	(a1)
		jsr	(GetSineCosine).w
		move.w	#-$400,d2
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

.anim
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.move
		move.b	#6,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		addq.b	#1,$30(a0)
		cmpi.b	#5,$30(a0)
		bne.s	.move
		move.l	#.move,address(a0)

.move
		jsr	(MoveSprite2).w

.dplc
		lea	DatDPLC_BossGrimReaper_Rings(pc),a2
		jsr	(Perform_DPLC).w

.draw
		move.w	x_pos(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.delete
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.s	.delete
		movea.w	parent3(a0),a1
		btst	#7,status(a1)
		bne.s	.delete
		jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.delete
		tst.b	subtype(a0)				; is the first ring?
		beq.s	.waitdelete			; if yes, branch
		jmp	(Go_Delete_SpriteSlotted2).w
; ---------------------------------------------------------------------------

.waitdelete
		jsr	(Remove_From_TrackingSlot).w
		move.l	#.waitdplc,address(a0)
		rts
; ---------------------------------------------------------------------------

.waitdplc
		tst.b	(Slotted_object_bits).w	; other rings removed?
		bne.s	.notdraw				; if not, branch

		; hide boss hand
		movea.w	parent3(a0),a1
		move.l	#BossGrimReaper_DisappearanceHand3,$34(a1)
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.sonicangle
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	(Player_1+x_pos).w,d1
		sub.w	(Player_1+y_pos).w,d2
		jmp	(GetArcTan).w
; ---------------------------------------------------------------------------

.attackangle
		move.b	subtype(a0),d0
		move.b	d0,d1
		lsl.b	#3,d0
		lsl.b	#2,d1
		add.b	d1,d0
		addi.b	#$80,d0
		tst.b	angle(a0)
		bpl.s	.return
		addi.b	#$40,d0

.return
		rts
; ---------------------------------------------------------------------------

.getframe
		moveq	#0,d0
		move.b	angle(a0),d0
		move.b	d0,d1

		; set flipx
		smi	d2				; 0 or $80

		; set flipy
		andi.b	#$40,d1		; 0 or $40 only
		seq	d3				; set flipy flag
		tst.b	d2				; is minus?
		beq.s	.findframe	; if not, skip
		eori.b	#-1,d3		; fix flipy

.findframe
		moveq	#0,d1

.find
		lea	.data(pc,d1.w),a1
		cmp.b	(a1)+,d0
		bls.s		.found
		addq.w	#2,d1
		bra.s	.find
; ---------------------------------------------------------------------------

.found
		move.b	(a1),mapping_frame(a0)
		move.b	render_flags(a0),d0
		andi.b	#-4,d0

		tst.b	d2		; check flipx flag
		beq.s	.notflipx
		ori.b	#1,d0

.notflipx
		tst.b	d3		; check flipy flag
		beq.s	.notflipy
		ori.b	#2,d0

.notflipy
		move.b	d0,render_flags(a0)
		rts
; ---------------------------------------------------------------------------

.data	; angle, frame
		dc.b 0, 0			; 1
		dc.b $10, 6
		dc.b $20, $C
		dc.b $30, $12
		dc.b $3F, $18

		dc.b $40, $18		; 2
		dc.b $50, $12
		dc.b $60, $C
		dc.b $70, 6
		dc.b $7F, 0

		dc.b $80, 0		; 3
		dc.b $90, 6
		dc.b $A0, $C
		dc.b $B0, $12
		dc.b $BF, $18

		dc.b $C0, $18		; 4
		dc.b $D0, $12
		dc.b $E0, $C
		dc.b $F0, 6
		dc.b $FF, 0

; ---------------------------------------------------------------------------
; Vortex ball (process)
; ---------------------------------------------------------------------------

; Dynamic object variables
obBGRVB_BoatAddr			= objoff_30	; .w

obBGRVB_Radius				= objoff_3A	; .w
obBGRVB_WaterPos			= objoff_3E	; .w

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_VortexBall_Process:

		; set xypos
		movea.w	parent3(a0),a1
		move.w	(Camera_X_pos).w,d0
		move.w	#$90,d1
		btst	#0,status(a1)
		beq.s	.notflipx
		move.w	#$B0,d1

.notflipx
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$40,d0
		move.w	d0,y_pos(a0)

		; timer
		move.w	#8+$1F,$2E(a0)		; wait + show hand

		; mapping
		lea	ObjDat_BossGrimReaper_Scythe(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.l	#.wait,address(a0)

		; show boss hand
		movea.w	parent3(a0),a1
		move.b	#2,anim(a1)
		rts
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.w	#$1F,$2E(a0)
		move.l	#.waitaim,address(a0)

		; draw aim
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$8530,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$20,$44(a1)			; ypos
		move.w	#60-28,$2E(a1)		; timer
		move.b	#$10,subtype(a1)		; jump|art id nibble

.notfree
		movea.w	(sp)+,a0

.waitaim
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.l	#.endanim,address(a0)
		sfx	sfx_LaserBeam
		move.b	#$14,(Negative_flash_timer).w
		move.w	#$14,(Screen_shaking_flag).w

.endanim
		tst.b	routine(a0)
		beq.w	Obj_BossGrimReaper_ScytheChase.anim
		clr.b	routine(a0)
		clr.b	anim(a0)
		clr.w	mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		move.w	(Mean_water_level).w,objoff_3E(a0)
		move.b	#8,objoff_3A(a0)
		move.l	#.radius,address(a0)
		movea.w	parent3(a0),a1
		movea.w	obBGR_Boat(a1),a2
		moveq	#1,d0
		btst	#0,status(a1)
		beq.s	.notflipx2
		neg.w	d0

.notflipx2
		move.w	d0,objoff_30(a0)

.radius
		addi.w	#$20,objoff_3A(a0)
		cmpi.b	#24,objoff_3A(a0)
		bne.s	.moveboat
		move.l	#.moveboat,address(a0)

.moveboat
		movea.w	parent3(a0),a1
		movea.w	obBGR_Boat(a1),a2
		move.w	objoff_30(a0),d0
		sub.w	d0,$2E(a2)
		cmpi.w	#$A0,$2E(a2)
		bne.s	.shaking
		move.w	#$5F,$2E(a0)
		move.l	#.timer,address(a0)

.timer
		subq.w	#1,$2E(a0)
		bmi.s	.delete

.shaking
		move.b	angle(a0),d0
		addi.b	#$40,angle(a0)
		jsr	(GetSineCosine).w
		asr.w	#6,d0
		add.w	objoff_3E(a0),d0
		move.w	d0,(Mean_water_level).w
		st	(Screen_shaking_flag).w

		move.b	(V_int_run_count+3).w,d0
		andi.w	#3,d0
		bne.s	.notdraw
		sfx	sfx_FireShow
		lea	Child6_BossGrimReaper_VortexBall(pc),a2
		jsr	(CreateChild6_Simple).w

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.delete
		; hide boss hand
		movea.w	parent3(a0),a1
		move.b	#3,anim(a1)
		move.w	#7,obBGR_Wait(a1)
		move.l	#BossGrimReaper_DisappearanceHand3,$34(a1)

		sfx	sfx_Transform
		clr.b	(Screen_shaking_flag).w
		move.w	objoff_3E(a0),(Mean_water_level).w
		move.b	#$14,(Negative_flash_timer).w
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Vortex ball (attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_VortexBall:

		; init
		movea.w	parent3(a0),a1
		move.b	objoff_3A(a1),objoff_3A(a0)	; circular radius
		move.b	#64,objoff_3C(a0)				; circular pos
		move.w	#$600,y_vel(a0)				; set speedy

		; mapping
		lea	ObjDat_BossGrimReaper_Ball(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.b	#7,anim_frame_timer(a0)
		move.l	#.wait,address(a0)
		movea.w	parent3(a0),a1
		movea.w	parent3(a1),a2
		move.b	(V_int_run_count+3).w,d0
		asl.b	#2,d0
		tst.b	subtype(a0)
		beq.s	.setpos
		neg.b	d0

.setpos
		btst	#0,status(a2)
		bne.s	.notflipx
		not.b	d0

.notflipx
		jsr	(GetSineCosine).w
		move.w	objoff_3A(a0),d2
		muls.w	d0,d2
		swap	d2
		move.w	y_pos(a1),y_pos(a0)
		move.w	x_pos(a1),d0
		add.w	d2,d0
		move.w	d0,x_pos(a0)

.wait
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.move
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#2,mapping_frame(a0)
		bne.s	.move
		move.l	#.move,address(a0)

.move
		jsr	(MoveSprite2).w

		; flicker
		btst	#1,subtype(a0)
		bne.s	.check
		btst	#0,(Level_frame_counter+1).w
		bne.s	.notdraw

.draw
		jmp	(Sprite_ChildCheckDeleteTouchXY).w
; ---------------------------------------------------------------------------

.check
		btst	#0,(Level_frame_counter+1).w
		bne.s	.draw

.notdraw
		jmp	(Sprite_ChildCheckDeleteXY_NoDraw).w

; ---------------------------------------------------------------------------
; Spring (hit)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Spring:

		; set xypos
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$50,d0
		move.w	d0,y_pos(a0)

		; timer
		move.w	#$3F,$2E(a0)		; wait

		; mapping
		lea	ObjDat_BossGrimReaper_Scythe(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.b	#14/2,y_radius(a0)
		clr.b	routine(a0)
		move.l	#.waitboat,address(a0)

		; spring
		move.w	#-$800,objoff_30(a0)	; spring power
		rts
; ---------------------------------------------------------------------------

.waitboat
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.l	#.wait,address(a0)

		; timer
		move.w	#8+$1F,$2E(a0)		; wait + show hand

		; show boss hand
		movea.w	parent3(a0),a1
		move.b	#2,anim(a1)
		rts
; ---------------------------------------------------------------------------

.wait
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.w	#$2F,$2E(a0)
		move.l	#.waitaim,address(a0)

		; draw aim
		move.w	a0,-(sp)
		movea.w	parent3(a0),a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$8538,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$20,$44(a1)			; ypos
		move.w	#60-14,$2E(a1)		; timer
		move.b	#$11,subtype(a1)		; jump|art id nibble

.notfree
		movea.w	(sp)+,a0

.waitaim
		subq.w	#1,$2E(a0)			; wait time
		bpl.w	.notdraw
		move.l	#.endanim,address(a0)

		; hide boss hand and set touch
		movea.w	parent3(a0),a1
		move.b	#3,anim(a1)
		bset	#optBGR_Hurt,obBGR_Opt(a1)
		move.l	#BossGrimReaper_SetupMoveSwing,address(a1)

		; draw aim
		move.w	a0,-(sp)
		movea.w	a1,a0
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	#$8530,art_tile(a1)	; VRAM
		move.w	#64,$42(a1)			; xpos
		move.w	#8,$44(a1)			; ypos
		move.w	#3*60,$2E(a1)		; timer
		moveq	#3,d0
		btst	#0,status(a0)
		beq.s	.notxflip
		addq.b	#2,d0

.notxflip
		move.b	d0,subtype(a1)		; jump|art id nibble

.notfree2
		movea.w	(sp)+,a0
		sfx	sfx_Transform
		move.b	#$14,(Negative_flash_timer).w
		move.w	#$14,(Screen_shaking_flag).w

.endanim
		tst.b	routine(a0)
		beq.w	Obj_BossGrimReaper_ScytheChase.anim
		clr.b	routine(a0)

		; mapping
		lea	ObjDat_BossGrimReaper_Spring(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		clr.b	anim(a0)
		clr.w	mapping_frame(a0)
		clr.b	anim_frame_timer(a0)
		move.l	#.fall,address(a0)

.fall
		jsr	(MoveSprite).w

		; calc boat ypos
		bsr.s	.calcboatypos
		cmp.w	y_pos(a0),d1
		bhs.w	.anim

		clr.w	y_vel(a0)
		move.w	#3*60,$2E(a0)
		move.l	#.jump,address(a0)

		; draw aim
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.jump
		move.w	#$8534,art_tile(a1)	; VRAM
		move.w	#-24,$44(a1)			; ypos
		move.w	#2*60,$2E(a1)		; timer
		move.b	#$02,subtype(a1)		; jump|art id nibble

.jump
		moveq	#$1B,d1
		moveq	#8,d2
		moveq	#$10,d3
		move.w	x_pos(a0),d4
		lea	(Player_1).w,a1
		moveq	#p1_standing_bit,d6
		jsr	(SolidObjectTop_1P).w

		; calc boat ypos
		bsr.s	.calcboatypos
		move.w	d1,y_pos(a0)
		move.w	x_pos(a2),x_pos(a0)

		btst	#p1_standing_bit,status(a0)
		beq.s	.notjump
		jsr	(sub_22F98).l
		move.b	#id_Roll,anim(a1)
		bra.s	.afterjump
; ---------------------------------------------------------------------------

.calcboatypos

		; get boat ypos
		movea.w	parent3(a0),a2
		movea.w	obBGR_Boat(a2),a2
		move.b	y_radius(a0),d0
		ext.w	d0
		move.w	y_pos(a2),d1
		add.w	d0,d0
		sub.w	d0,d1
		rts
; ---------------------------------------------------------------------------

.notjump
		subq.w	#1,$2E(a0)
		bmi.s	.delete

.anim
		lea	(Ani_Spring).l,a1
		jsr	(Animate_Sprite).w

.draw
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.afterjump
		move.w	#10,$2E(a0)
		move.l	#.waitspring,address(a0)

.waitspring
		subq.w	#1,$2E(a0)
		bpl.s	.anim

		; remove
		sfx	sfx_Transform
		move.b	#$14,(Negative_flash_timer).w
		move.w	#1*60,$2E(a0)
		bset	#7,status(a0)
		move.l	#.waitdelete,address(a0)

.waitdelete
		subq.w	#1,$2E(a0)
		bmi.s	.delete2

.return
		rts
; ---------------------------------------------------------------------------

.delete
		sfx	sfx_Transform
		move.b	#$14,(Negative_flash_timer).w

.delete2
		movea.w	parent3(a0),a1
		clr.l	x_vel(a1)
		bclr	#optBGR_Hurt,obBGR_Opt(a1)
		move.w	#$F,obBGR_Wait(a1)
		move.l	#BossGrimReaper_SetupMove,address(a1)
		move.l	#BossGrimReaper_DisappearanceHand2,$34(a1)
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Boat
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Boat:
		lea	ObjDat_BossGrimReaper_Boat(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		bset	#7,status(a0)									; balance anim off
		move.b	(Water_entered_counter).w,$36(a0)
		move.l	#.wait,address(a0)

.wait
		move.w	(Camera_X_pos).w,d0
		move.w	d0,(Camera_X_pos).w
		move.w	d0,(Camera_X_pos_copy).w
		move.w	d0,(Camera_min_X_pos).w
		cmp.w	#$930,d0
		bne.w	.solid
		btst	#Status_OnObj,status(a0)
		beq.w	.solid

		; reload art
		lea	(ArtKosM_DEZExplosion).l,a1
		move.w	#tiles_to_bytes($59C),d2
		jsr	(Queue_Kos_Module).w

		; check music
		cmpi.w	#mus_SCZ3,(Level_music).w
		bne.s	.notplay
		music	mus_SCZ3Boss							; play boss theme
		command	cmd_FadeReset

.notplay
		move.w	#$100,x_vel(a0)
		move.w	#$480,(Camera_min_Y_pos).w
		move.l	#.checkpos,address(a0)

		; normal palette
		lea	(ChildObjDat6_SmoothPalette2).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	a1,parent3(a0)
		move.w	#$6F,$2E(a1)								; wait time
		move.w	#3,subtype(a1)							; wait time
		move.l	#BGRPalBoat_Index,objoff_30(a1)			; index pointer

.notfree2

		; normal palette
		lea	(ChildObjDat6_SmoothPalette2).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.checkpos
		move.w	a1,parent4(a0)
		move.w	#$BF,$2E(a1)								; wait time
		move.w	#3,subtype(a1)							; wait time
		move.l	#BGRPalBoat2_Index,objoff_30(a1)			; index pointer

.checkpos

		; check fade-in
		movea.w	parent3(a0),a1
		cmpi.l	#Obj_SmoothPalette2.main,address(a1)
		bne.s	.checkpos2
		cmpi.b	#4,objoff_36(a1)
		bhi.s	.checkpos2
		move.l	#.fixhint,address(a0)
		move.w	#$8004,(VDP_control_port).l				; hide Hint CRAM dots (disabling hint)

.fixhint

		; check fade-out
		movea.w	parent4(a0),a1
		cmpi.l	#Obj_SmoothPalette2.main,address(a1)
		bne.s	.checkpos2
		cmpi.b	#4,objoff_36(a1)
		bhi.s	.checkpos2
		move.l	#.checkpos2,address(a0)
		move.w	#$8014,(VDP_control_port).l				; draw Hint CRAM dots (enabling hint)

.checkpos2

		; fix Sonic's pos on boat
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		beq.s	.notfix
		addq.w	#1,x_pos(a1)

.notfix
		move.w	(Camera_X_pos).w,d0
		addq.w	#1,d0
		move.w	d0,(Camera_X_pos).w
		move.w	d0,(Camera_X_pos_copy).w
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w
		cmp.w	#$B00,d0
		bne.s	.solid
		clr.w	x_vel(a0)
		move.l	#.moveboat,address(a0)

		; reset rings
		lea	(Arthur_Rings).l,a1
		jsr	(Set_LostRings).w

		; create boss
		jsr	(Create_New_Sprite).w
		bne.s	.notfree
		move.l	#Obj_BossGrimReaper,address(a1)
		move.w	a0,parent3(a1)
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$10,d0
		move.w	d0,y_pos(a1)

.notfree
		; init boss arena+
		lea	PLC_GrimReaperStuff(pc),a5
		jsr	(LoadPLC_Raw_KosM).w
		addq.b	#2,(Background_event_routine).w
		move.w	#$100,(FGHscroll_shift).w
		move.l	#AnPal_SCZ3,(Level_data_addr_RAM.AnPal).w
		bra.s	.solid
; ---------------------------------------------------------------------------

.moveboat
		move.w	(Camera_X_pos).w,d1
		move.w	$2E(a0),d0
		beq.s	.solid
		add.w	d0,d1
		sub.w	x_pos(a0),d1
		move.w	d1,d2
		asl.w	#2,d1
		asl.w	d2
		add.w	d2,d1
		move.w	d1,x_vel(a0)

.solid
		move.w	x_pos(a0),-(sp)
		bsr.s	.swaying
		moveq	#0,d1
		move.b	width_pixels(a0),d1
		moveq	#16/2,d3		; height
		move.w	(sp)+,d4
		jsr	(SolidObjectTop).w

.draw
		bsr.w	.animangle
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.swaying
		tst.b	objoff_34(a0)
		bmi.s	.checkflag
		move.b	objoff_36(a0),d0
		cmp.b	(Water_entered_counter).w,d0
		beq.s	.same
		move.b	(Water_entered_counter).w,objoff_36(a0)
		move.b	#$81,objoff_34(a0)
		bra.s	.checkflag
; ---------------------------------------------------------------------------

.same
		move.b	status(a0),d0		; check if player is standing on boat
		andi.b	#$18,d0
		bne.s	.checkflag
		tst.b	objoff_32(a0)
		beq.s	.swing
		subq.b	#4,objoff_32(a0)
		bra.s	.swing
; ---------------------------------------------------------------------------

.checkflag
		tst.b	objoff_34(a0)
		bne.s	.alreadyset
		move.b	#1,objoff_34(a0)

.alreadyset
		cmpi.b	#64,objoff_32(a0)
		beq.s	.clearmflag
		addq.b	#4,objoff_32(a0)
		bra.s	.swing
; ---------------------------------------------------------------------------

.clearmflag
		andi.b	#$7F,objoff_34(a0)

.swing
		move.b	objoff_32(a0),d0
		jsr	(GetSineCosine).w
		asr.w	#5,d0
		add.w	(Water_level).w,d0
		move.w	d0,y_pos(a0)
		bsr.s	.waterjump
		jmp	(MoveSprite2).w
; ---------------------------------------------------------------------------

.waterjump
		tst.b	(Sonic_NoKill).w
		beq.w	.return

		; save character
		lea	(Player_1).w,a1

		cmpi.b	#id_SonicDeath,routine(a1)
		bhs.w	.return

		move.w	(Camera_max_Y_pos).w,d0
		addi.w	#224,d0
		cmp.w	y_pos(a1),d0
		bgt.w	.return

		; jump
		sfx	sfx_Death
		move.b	#id_SonicControl,routine(a1)
		move.b	#id_Roll,anim(a1)
		clr.w	x_vel(a1)
		move.w	#-$600,y_vel(a1)
		bset	#Status_InAir,status(a1)
		bclr	#Status_OnObj,status(a1)
		clr.b	jumping(a1)
		clr.b	double_jump_flag(a1)

		; saving
		cmpi.b	#id_SonicHurt,routine(a1)
		bhs.s	.return
		tst.b	invulnerability_timer(a1)				; is the player invulnerable?
		bne.s	.return							; if so, branch
		btst	#Status_BublShield,status_secondary(a1)	; does Sonic have shield?
		bne.s	.return							; if yes, branch

		move.b	#3*60,invulnerability_timer(a1)

		; ring punishment
		moveq	#0,d1							; NOV: Calculate the amount we need to subtract from the HP
		move.b	(Ring_count).w,d1					; NOV: Get HP % 5
		divu.w	#5,d1							; NOV: ''
		swap	d1								; NOV: ''
		addq.b	#5,d1							; NOV: Add full HP ring amount
		sub.b	d1,(Ring_count).w					; NOV: Decrement from the current HP
		bpl.s	.skipclr							; NOV: If it did not underflow, branch
		clr.b	(Ring_count).w						; NOV: Cap HP at 0

.skipclr
		bne.s	.update							; NOV: If the HP is 0, branch
		clr.b	(Sonic_NoKill).w

		; kill character
		move.w	a0,-(sp)
		movea.w	a1,a0
		jsr	(Kill_Character).l
		movea.w	(sp)+,a0

.update
		move.b	#$80,(Update_HUD_ring_count).w

.return
		rts
; ---------------------------------------------------------------------------

.afterboss
		addq.b	#2,(Background_event_routine).w
		move.l	#.afterbosswait,address(a0)

		; restore chunks
		lea	(SCZ3_128x128_Kos).l,a1
		lea	(RAM_start).l,a2
		jsr	(Queue_Kos).w

		; restore art
		lea	(SCZ3_8x8_KosM).l,a1					; load tiles as Kosinski Moduled
		moveq	#0,d2
		jsr	(Queue_Kos_Module).w

.afterbosswait
		tst.b	(Background_event_routine).w
		bne.w	.solid

		move.w	#$200,x_vel(a0)

		move.l	#.afterbossmove,address(a0)

.afterbossmove

		; fix Sonic's pos on boat
		lea	(Player_1).w,a1
		btst	#Status_InAir,status(a1)
		beq.s	.notfix2
		addq.w	#2,x_pos(a1)

.notfix2
		move.w	(Camera_X_pos).w,d0
		addq.w	#2,d0
		move.w	d0,(Camera_X_pos).w
		move.w	d0,(Camera_X_pos_copy).w
		move.w	d0,(Camera_min_X_pos).w
		move.w	d0,(Camera_max_X_pos).w
		cmp.w	#$EA8,d0
		bne.w	.solid
		clr.w	x_vel(a0)
		move.w	#$1100,(Camera_max_X_pos).w
		move.l	#SCZ3_Resize_AfterBoss,(Level_data_addr_RAM.Resize).w
		move.l	#.delete,address(a0)

.delete
		cmpi.w	#$F80,(Camera_X_pos).w
		blt.w	.solid
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.animangle
		move.b	status(a0),d0		; check if player is standing on boat
		andi.b	#$18,d0
		beq.s	.animangleclr
		move.w	(Player_1+x_pos).w,d0
		sub.w	x_pos(a0),d0
		asr.w	#4,d0
		move.b	.framedata+6(pc,d0.w),mapping_frame(a0)
		rts
; ---------------------------------------------------------------------------

.framedata	dc.b 6, 6, 6, 6, 5, 4, 0, 1, 2, 3, 3, 3, 3	; width
	even
; ---------------------------------------------------------------------------

.animangleclr
		tst.b	mapping_frame(a0)
		beq.s	.animanglerts

		; wait
		moveq	#7,d0
		and.b	(Level_frame_counter+1).w,d0
		bne.s	.animanglerts

		; return to normal pos
		subq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		bne.s	.animanglerts
		clr.b	mapping_frame(a0)

.animanglerts
		rts

; ---------------------------------------------------------------------------
; Explosion
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossGrimReaper_Explosion:
		move.l	#Map_BossDEZExplosion,mappings(a0)
		move.w	#$859C,art_tile(a0)
		move.b	#4,render_flags(a0)
		move.w	#$80,priority(a0)
		move.w	#bytes_to_word(24/2,24/2),height_pixels(a0)		; set height and width
		move.b	#3,anim_frame_timer(a0)
		move.l	#.anim,address(a0)

.anim
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		move.b	#7,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	.delete

.draw
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Collision, Animate, Drawing
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGrimReaper_MainProcess:
		bsr.s	BossGrimReaper_CheckTouch

	if _BD_TEST_
		; test
		pea	(Draw_Sprite).w
		; test
	endif

		btst	#optBGR_Hurt,obBGR_Opt(a0)
		beq.w	BossGrimReaper_Animate
		jsr	(Add_SpriteToCollisionResponseList).l
		bra.w	BossGrimReaper_Animate

; ---------------------------------------------------------------------------
; Test collision
; ---------------------------------------------------------------------------

BossGrimReaper_CheckHP:
		dc.b BossGrimReaper_Hits/4		; Easy
		dc.b BossGrimReaper_Hits/2		; Normal
		dc.b BossGrimReaper_Hits/2		; Hard
		dc.b BossGrimReaper_Hits/2		; Maniac

; =============== S U B R O U T I N E =======================================

BossGrimReaper_CheckTouch:
		tst.b	collision_flags(a0)
		bne.w	.return
		move.b	collision_property(a0),d1
		beq.w	BossGrimReaper_WaitExplosive
		tst.b	obBGR_Flash(a0)
		bne.w	.flash
		sfx	sfx_HurtFire
		move.b	#$40,obBGR_Flash(a0)
		bset	#6,status(a0)

		move.w	(Difficulty_Flag).w,d2
		cmp.b	BossGrimReaper_CheckHP(pc,d2.w),d1
		bne.s	.notpinch
		bset	#optBGR_Pinch,obBGR_Opt(a0)

		; alt normal palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#3,subtype(a1)							; wait time
		move.w	#Normal_palette_line_4,objoff_34(a1)		; palette ram
		move.l	#Pal_BossGrimReaper+$40,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)						; palette size

.notfree

		; alt water palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notpinch
		move.w	#3,subtype(a1)								; wait time
		move.w	#Water_palette_line_4,objoff_34(a1)			; palette ram
		move.l	#Pal_BossGrimReaperWater+$20,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)							; palette size

.notpinch

		; save player
		bsr.s	.save

.flash
		tst.w	(Seizure_Flag).w								; check if photosensitivity
		bne.s	.noflash										; branch if yes

		moveq	#0,d0
		btst	#0,obBGR_Flash(a0)
		bne.s	.skip
		addi.w	#5*2,d0

.skip
		bsr.w	BossGrimReaper_PalFlash

.noflash
		subq.b	#1,obBGR_Flash(a0)
		bne.s	.return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

.return
		rts
; ---------------------------------------------------------------------------

.save

		; save player
		move.w	#$400,d0	; set kinetic energy
		btst	#0,status(a0)
		beq.s	.notxflip
		neg.w	d0

.notxflip
		lea	(Player_1).w,a1
		move.w	d0,x_vel(a1)
		move.w	d0,ground_vel(a1)
		rts

; ---------------------------------------------------------------------------
; Exploding boss
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGrimReaper_WaitExplosive:
		move.l	#BossGrimReaper_WaitPlayerExplosive,address(a0)
		move.l	#AnPal_None,(Level_data_addr_RAM.AnPal).w

		; save player
;		bsr.s	BossGrimReaper_CheckTouch.save

		; normal palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$17,$2E(a1)
		move.w	#$1F,subtype(a1)							; wait time
		move.w	#Normal_palette_line_4,objoff_34(a1)		; palette ram
		move.l	#Pal_BossGrimReaper+$20,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)						; palette size

.notfree

		; water palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	#$17,$2E(a1)
		move.w	#$1F,subtype(a1)							; wait time
		move.w	#Water_palette_line_4,objoff_34(a1)		; palette ram
		move.l	#Pal_BossGrimReaper+$20,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)						; palette size

.notfree2
		clr.l	x_vel(a0)
		jmp	(BossDefeated).w
; ---------------------------------------------------------------------------

BossGrimReaper_WaitPlayerExplosive:
		lea	(ChildObjDat_BossCerberus_Fire).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#bytes_to_word(64/2,255/2),$3A(a1)
		move.w	#$100,$3C(a1)

.notfree
		move.b	(Level_frame_counter+1).w,d0
		andi.w	#7,d0
		bne.s	.skip
		sfx	sfx_BreakBridge

.skip
		subq.w	#1,$2E(a0)
		bne.s	.return
		bclr	#7,(Player_1+art_tile).w
		clr.l	(Camera_Y_pos_BG_copy).w
		move.l	#.deform,address(a0)

.deform

		; deform boss
		bsr.w	BossGrimReaper_Deform

		addq.w	#1,obBGR_DeformFactor(a0)
		cmpi.w	#$32,obBGR_DeformFactor(a0)
		bne.s	.return

		move.l	#.delete,address(a0)

		; flash
		move.b	#$1F,(Negative_flash_timer).w

		; sample
		samp	sfx_Thunderclamp

		; clear buffer
		bra.w	BossGrimReaper_Animate.clearframe
; ---------------------------------------------------------------------------

.delete

		; set
		clr.b	(Boss_flag).w
		move.l	#VInt,(V_int_addr).w
		move.l	#SCZ1_ScreenEvent,(Level_data_addr_RAM.ScreenEvent).w

		; boat
		movea.w	obBGR_Boat(a0),a1
		move.l	#Obj_BossGrimReaper_Boat.afterboss,address(a1)

		; fade
		fadeout					; fade out music

		; delete
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.return
		rts

; ---------------------------------------------------------------------------
; Animate Boss Grim Reaper
; ---------------------------------------------------------------------------

BossGrimReaper_Animate_FrameData:
		dc.w -1			; 0 (null)
		dc.w 0			; 1 (right)
		dc.w $564		; 2 (right)
		dc.w -1			; 3 (null)
		dc.w -1			; 4 (null)
		dc.w 2*$564		; 5 (left)
		dc.w 3*$564		; 6 (left)
		dc.w -1			; 7 (null)

; =============== S U B R O U T I N E =======================================

BossGrimReaper_Animate:
		lea	Anim_BossGrimReaper(pc),a1
		jsr	(Animate_Sprite).w
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	obBGR_SaveFrame(a0),d0
		beq.s	.return
		move.b	d0,obBGR_SaveFrame(a0)
		andi.w	#3,d0
		add.w	d0,d0			; right side
		btst	#0,status(a0)
		beq.s	.notflipx
		addq.w	#4*2,d0			; left side

.notflipx
		move.w	BossGrimReaper_Animate_FrameData(pc,d0.w),d0
		bmi.s	.clearframe
		lea	(MapUnc_BossGrimReaper).l,a1
		adda.w	d0,a1

.loadframe
		bsr.s	.clearframe
		lea	(BossGrimReaper_buffer+planeLocH40(1,0)).l,a2	; right xpos
		btst	#0,status(a0)
		bne.s	.notflipx2
		lea	planeLocH40($D,0)(a2),a2			; left xpos

.notflipx2
		lea	(a2),a3
		moveq	#(BossGrimReaper_Height/8-1),d2

.copy
		movea.l	a2,a3

	rept BossGrimReaper_Width/16
		move.l	(a1)+,(a3)+
	endr

	if BossGrimReaper_Width&8
		move.w	(a1)+,(a3)+
	endif

		lea	$80(a2),a2	; next line
		dbf	d2,.copy

.return
		rts
; ---------------------------------------------------------------------------

.clearframe
		lea	(BossGrimReaper_buffer).l,a2
		moveq	#0,d0
		move.w	#$1000/64-1,d3

.clear

	rept 64/4
		move.l	d0,(a2)+
	endr

		dbf	d3,.clear
		rts

; ---------------------------------------------------------------------------
; VInt Boss Grim Reaper
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

VInt_BossGrimReaper:
		movem.l	d0-a6,-(sp)	; save all the registers to the stack

		; update buffer
		dma68kToVDP BossGrimReaper_buffer,vram_bg,$1000,VRAM

		jmp	VInt.main

; ---------------------------------------------------------------------------
; Deform Boss Grim Reaper
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGrimReaper_Deform:
		lea	(SineTable).w,a2
		lea	(H_scroll_buffer+2).w,a1
		move.w	(Camera_X_pos_BG_copy).w,d4
		move.w	#$1FE,d2
		move.w	(Level_frame_counter).w,d0
		add.w	d0,d0
		moveq	#bytesToXcnt(224,8),d6
		move.w	obBGR_DeformFactor(a0),d3

.loop
	rept 8
		and.w	d2,d0
		move.w	(a2,d0.w),d1
		muls.w	d3,d1
		asr.w	#5,d1
		add.w	d4,d1
		move.w	d1,(a1)
		addq.w	#4,a1		; skip FBG
		addq.w	#8,d0
	endr

		dbf	d6,.loop
		rts

; ---------------------------------------------------------------------------
; Move BG
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGrimReaper_Deform_MoveBG:
		lea	(H_scroll_buffer+2).w,a1
		move.w	(Camera_X_pos_BG_copy).w,d0
		moveq	#bytesToXcnt(224,8),d1

.loop
	rept 8
		move.w	d0,(a1)
		addq.w	#4,a1		; skip FBG
	endr
		dbf	d1,.loop
		rts

; ---------------------------------------------------------------------------
; Palette flash
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossGrimReaper_PalFlash:
		lea	LoadBossGrimReaper_PalCycle(pc,d0.w),a2
		btst	#optBGR_Pinch,obBGR_Opt(a0)
		beq.s	.notpalpinch
		lea	LoadBossGrimReaper_PalCycle2(pc,d0.w),a2

.notpalpinch
		lea	LoadBossGrimReaper_PalRAM(pc),a1
		jsr	(CopyWordData_5).w

		; water
		lea	LoadBossGrimReaperWater_PalCycle(pc,d0.w),a2
		btst	#optBGR_Pinch,obBGR_Opt(a0)
		beq.s	.notpalpinchwater
		lea	LoadBossGrimReaperWater_PalCycle2(pc,d0.w),a2

.notpalpinchwater
		lea	LoadBossGrimReaperWater_PalRAM(pc),a1
		jmp	(CopyWordData_5).w
; ---------------------------------------------------------------------------

LoadBossGrimReaper_PalRAM:
		dc.w Normal_palette_line_4+2
		dc.w Normal_palette_line_4+4
		dc.w Normal_palette_line_4+6
		dc.w Normal_palette_line_4+8
		dc.w Normal_palette_line_4+$A
LoadBossGrimReaper_PalCycle:
		dc.w $200, $402, $424, $A48, $E8C
		dc.w $EEE, $EEE, $EEE, $EEE, $EEE
LoadBossGrimReaper_PalCycle2:
		dc.w $202, $406, $428, $A4C, $E8E
		dc.w $EEE, $EEE, $EEE, $EEE, $EEE

LoadBossGrimReaperWater_PalRAM:
		dc.w Water_palette_line_4+2
		dc.w Water_palette_line_4+4
		dc.w Water_palette_line_4+6
		dc.w Water_palette_line_4+8
		dc.w Water_palette_line_4+$A
LoadBossGrimReaperWater_PalCycle:
		dc.w 0, $200, $202, $826, $C6A
		dc.w $888, $888, $888, $888, $888
LoadBossGrimReaperWater_PalCycle2:
		dc.w 0, $204, $206, $82A, $C6C
		dc.w $888, $888, $888, $888, $888

; =============== S U B R O U T I N E =======================================

BGRPalBoat_Index:
		dc.w 4-1

		; 1
		dc.l Pal_BossTwoFacesBlack
		dc.w Normal_palette_line_1
		dc.w 16-1

		; 2
		dc.l Pal_BossTwoFacesBlack
		dc.w Water_palette_line_1
		dc.w 16-1

		; 3
		dc.l Pal_BossTwoFacesBlack
		dc.w Normal_palette_line_3
		dc.w 16-1

		; 4
		dc.l Pal_BossTwoFacesBlack
		dc.w Water_palette_line_3
		dc.w 16-1

BGRPalBoat2_Index:
		dc.w 4-1

		; 1
		dc.l Pal_SonicSCZ
		dc.w Normal_palette_line_1
		dc.w 16-1

		; 2
		dc.l Pal_WaterSonic
		dc.w Water_palette_line_1
		dc.w 16-1

		; 3
		dc.l Pal_SCZ3
		dc.w Normal_palette_line_3
		dc.w 16-1

		; 4
		dc.l Pal_SCZWater+$20
		dc.w Water_palette_line_3
		dc.w 16-1

; =============== S U B R O U T I N E =======================================

ObjDat3_BossGrimReaper:			subObjData3 $200, 32/2, 32/2, 0, 6
ObjDat_BossGrimReaper_Mask:	subObjData Map_BossGrimReaperMask, $E302, $180, 32/2, 32/2, 0, 0
ObjDat_BossGrimReaper_Scythe:	subObjData Map_BossGrimReaperScythe, $E2B0, $80, 64/2, 64/2, 0, 0
ObjDat_BossGrimReaper_Ball:		subObjData Map_BossGrimReaperBall, $8312, $180, 24/2, 24/2, 0, $B|$80
ObjDat4_BossGrimReaper_Rings:	subObjSlotData 6, $8356, $15, 0, Map_BossGrimReaperRings, $80, 64, 64, 0, ($1A|$80)
DatDPLC_BossGrimReaper_Rings:	dc.l ArtUnc_BossGrimReaperRings>>1, DPLC_BossGrimReaperRings
ObjDat_BossGrimReaper_Spring:	subObjData Map_Spring2, $500, $200, 32/2, 32/2, 0, 0
ObjDat_BossGrimReaper_Boat:		subObjData Map_BossGrimReaperBoat, $C323, $80, 112/2, 96/2, 0, 0

Child6_BossGrimReaper_Mask:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_Mask
Child6_BossGrimReaper_Scythe:
		dc.w 3-1
		dc.l Obj_BossGrimReaper_Scythe
Child6_BossGrimReaper_ScytheChase:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_ScytheChase
Child6_BossGrimReaper_Rings:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_Rings
Child6_BossGrimReaper_Rings2:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_Rings2
Child6_BossGrimReaper_RingsExtra:
		dc.w 5-1
		dc.l Obj_BossGrimReaper_Rings.extrarings
Child6_BossGrimReaper_VortexBall_Process:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_VortexBall_Process
Child6_BossGrimReaper_VortexBall:
		dc.w 2-1
		dc.l Obj_BossGrimReaper_VortexBall
Child6_BossGrimReaper_Spring:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_Spring
Child6_BossGrimReaper_Explosion:
		dc.w 1-1
		dc.l Obj_BossGrimReaper_Explosion

PLC_GrimReaperStuff: plrlistheader
		plreq $60, ArtKosM_BossGrimReaper				; boss
		plreq $2B0, ArtKosM_BossGrimReaperScythe			; boss (scythe)
		plreq $302, ArtKosM_BossGrimReaperMask			; boss (mask)
		plreq $312, ArtKosM_BossGrimReaperBall			; boss (ball)
		plreq $478, ArtKosM_SignpostStub
PLC_GrimReaperStuff_End
; ---------------------------------------------------------------------------

		include "Objects/Bosses/Grim Reaper/Object Data/Anim - BossGrimReaper.asm"
		include "Objects/Bosses/Grim Reaper/Object Data/Anim - BossGrimReaper(Scythe).asm"
		include "Objects/Bosses/Grim Reaper/Object Data/Map - BossGrimReaper(Mask).asm"
		include "Objects/Bosses/Grim Reaper/Object Data/Map - BossGrimReaper(Scythe).asm"
		include "Objects/Bosses/Grim Reaper/Object Data/Map - BossGrimReaper(Ball).asm"
		include "Objects/Bosses/Grim Reaper/Object Data/Map - BossGrimReaper(Rings).asm"
		include "Objects/Bosses/Grim Reaper/Object Data/DPLC - BossGrimReaper(Rings).asm"
		include "Objects/Bosses/Grim Reaper/Object Data/Map - BossGrimReaper(Boat).asm"

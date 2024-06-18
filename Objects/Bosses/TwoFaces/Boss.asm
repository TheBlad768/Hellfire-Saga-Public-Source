; ---------------------------------------------------------------------------
; Boss TwoFaces from the Castlevania - Bloodlines.
; Version 1.0
; By TheBlad768 (2022).
; ---------------------------------------------------------------------------

; Debug
_BTF_TEST_					= 0	; draw collision
_BTF_BALL_					= 3	; ball count
_BTF_BALLSIZE_				= 3	; ball tail size

; Misc
BossTwoFaces_Hits			= 8
BossTwoFaces_VRAM			= $60
BossTwoFaces_Width			= 72
BossTwoFaces_Height			= 112

; Dynamic object variables
obBTF_Flash					= objoff_1C	; .w
obBTF_Wait					= objoff_2E	; .w
obBTF_Jump					= objoff_34	; .l
obBTF_Opt					= objoff_38	; .b
obBTF_SaveFrame			= objoff_3A	; .b

; Functions (objoff_38 Opt)
optBTF_Hurt					= 3

; Animate
aBTF_Blank					= 0
aBTF_Closed					= 1
aBTF_Appearance				= 2
aBTF_Open					= 3
aBTF_Disappearance			= 4
aBTF_Heart					= 5

; RAM
BossTwoFaces_buffer			= $FFFF2000	; $1000 bytes
BossTwoFaces_buffer_end		= $FFFF3000

BossTwoFaces_buffer2			= $FFFF3000		; $1000 bytes
BossTwoFaces_buffer2_end		= $FFFF4000

; =============== S U B R O U T I N E =======================================

Obj_BossTwoFaces:
		tst.w	(Kos_modules_left).w
		bne.s	.return

		; init
		move.w	#$5F,obBTF_Wait(a0)
		move.l	#BossTwoFaces_Main,obBTF_Jump(a0)
		move.l	#Obj_Wait,address(a0)

		; set flags
		st	(Boss_flag).w
		bset	#7,(Player_1+art_tile).w

		; set buffer
		bsr.w	BossTwoFaces_BlindsEffect_LoadTiles

		; normal palette to black
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.return
		move.w	#3,subtype(a1)						; wait time
		move.w	#Normal_palette_line_3,objoff_34(a1)	; palette ram
		move.l	#Pal_BossTwoFacesBlack,objoff_30(a1)	; palette pointer
		move.w	#16-1,objoff_38(a1)					; palette size

.return
		rts
; ---------------------------------------------------------------------------

BossTwoFaces_Main:

		; update foreground
		lea	(MapKosM_BossTwoFacesFG).l,a1
		move.w	#tiles_to_bytes($600),d2
		jsr	(Queue_Kos_Module).w

		; clear buffer
		bsr.w	BossTwoFaces_Animate.clearframe

		; set buffer
		bsr.w	BossTwoFaces_BlindsEffect_LoadMap

		; clear scroll buffer
		clearRAM H_scroll_buffer, H_scroll_buffer_End

		; init
		move.l	#SCZ1_ScreenEvent_Boss,(Level_data_addr_RAM.ScreenEvent).w
		move.l	#SCZ1_BackgroundEvent_Boss,(Level_data_addr_RAM.BackgroundEvent).w
		clr.w	(Camera_X_pos_BG_copy).w
		clr.w	(Camera_Y_pos_BG_copy).w

		; mapping
		lea	ObjDat3_BossTwoFaces(pc),a1
		jsr	(SetUp_ObjAttributes3).w
		clr.b	routine(a0)
		move.w	(Difficulty_Flag).w,d0
		move.b	BossTwoFaces_HP(pc,d0.w),collision_property(a0)		; set hits
		move.w	#bytes_to_word(96/4,156/4),y_radius(a0)	; yxpos
		move.w	#$7F,obBTF_Wait(a0)

		; set jmp
		move.l	#.return,d0
		move.l	d0,$34(a0)
		move.l	d0,address(a0)

	if _BTF_TEST_
		; test
		move.l	#Map_Monitor,mappings(a0)
		move.w	#BossTwoFaces_VRAM|$8000,art_tile(a0)
		; test
	endif

		; load boss palette
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$F,subtype(a1)						; wait time
		move.w	$2E(a0),$2E(a1)						; wait time
		move.w	#Normal_palette_line_3,objoff_34(a1)	; palette ram
		move.l	#Pal_BossTwoFaces,objoff_30(a1)		; palette pointer
		move.w	#16-1,objoff_38(a1)					; palette size

.notfree
		lea	Child6_BossTwoFaces_BlindsEffect_Process(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.return
		move.w	$2E(a0),$2E(a1)
		move.l	#BossTwoFaces_BlindsEffect_Process_LoadBoss,$34(a1)

.return
		rts
; ---------------------------------------------------------------------------

BossTwoFaces_HP:
		dc.b BossTwoFaces_Hits/2	; Easy
		dc.b BossTwoFaces_Hits	; Normal
		dc.b BossTwoFaces_Hits+2	; Hard
		dc.b BossTwoFaces_Hits+2	; Maniac
; ---------------------------------------------------------------------------

BossTwoFaces_SetupMove_Heartbeat:
		move.w	#sfx_Heart,d0
		moveq	#$F,d2
		jsr	(Play_SFX_Continuous).w

BossTwoFaces_SetupMove:

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
		pea	BossTwoFaces_MainProcess(pc)
		jmp	(Obj_Wait).w

; ---------------------------------------------------------------------------
; Load
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Load:
		move.w	#$F,$2E(a0)
		move.l	#BossTwoFaces_Startup,$34(a0)

		; set VInt
		move.l	#VInt_BossTwoFaces,(V_int_addr).w
		rts

; ---------------------------------------------------------------------------
; Start
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Startup:

		; backup palette
		lea	(Normal_palette).w,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line64).w

.skip

		; sub palette (shadow mode)
		bsr.w	BossTwoFaces_DarkPalette

		move.w	#$F,$2E(a0)
		move.l	#BossTwoFaces_Appearance,$34(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Appearance:
		move.b	#aBTF_Appearance,anim(a0)
		move.l	#.sound,$34(a0)

.sound
		cmpi.b	#aBTF_Appearance,anim(a0)
		bne.s	.setopen
		tst.b	routine(a0)
		beq.s	.return
		clr.b	routine(a0)
		sfx	sfx_Magnet

.return
		rts
; ---------------------------------------------------------------------------

.setopen
		move.w	#$3F,$2E(a0)
		move.l	#.open,$34(a0)

		; restore palette
		lea	(Target_palette).w,a1
		lea	(Normal_palette).w,a2
		jmp	(PalLoad_Line64).w
; ---------------------------------------------------------------------------

.open
		move.b	#aBTF_Open,anim(a0)
		move.w	#$1F,$2E(a0)
		move.l	#BossTwoFaces_Attack,$34(a0)
		rts

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Attack:

		; draw aim
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#$84E0,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$40,$44(a1)			; ypos
		move.w	#30,$2E(a1)			; timer
		move.b	#$10,subtype(a1)		; jump|art id nibble

.notfree

		move.l	#BossTwoFaces_Appearance.return,$34(a0)
		lea	Child6_BossTwoFaces_Ball_Process(pc),a2
		jmp	(CreateChild6_Simple).w

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Disappearance_CloseEyes:
		move.b	#aBTF_Closed,anim(a0)
		move.w	#$F,$2E(a0)
		move.l	#BossTwoFaces_Disappearance,$34(a0)
		rts
; ---------------------------------------------------------------------------

BossTwoFaces_Disappearance:

		; sub palette (shadow mode)
		bsr.w	BossTwoFaces_DarkPalette

		move.b	#aBTF_Disappearance,anim(a0)
		move.l	#.sound,$34(a0)

.sound
		cmpi.b	#aBTF_Disappearance,anim(a0)
		bne.s	.setopen
		tst.b	routine(a0)
		beq.s	.return
		clr.b	routine(a0)
		sfx	sfx_Magnet

.return
		rts
; ---------------------------------------------------------------------------

.setopen
		move.w	#$1F,$2E(a0)
		move.l	#BossTwoFaces_Touch,$34(a0)

		; restore palette
		lea	(Target_palette).w,a1
		lea	(Normal_palette).w,a2
		jmp	(PalLoad_Line64).w

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Touch:
		move.w	#$9F,$2E(a0)
		move.l	#BossTwoFaces_SetupMove_Heartbeat,address(a0)
		move.l	#BossTwoFaces_Touch_Restart,$34(a0)
		bset	#optBTF_Hurt,obBTF_Opt(a0)

		; draw aim
		lea	(ChildObjDat6_BossAim).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.return
		move.w	#$84E0,art_tile(a1)	; VRAM
		move.w	#$A0,$42(a1)		; xpos
		move.w	#$30,$44(a1)			; ypos
		move.w	$2E(a0),$2E(a1)		; timer
		move.b	#$12,subtype(a1)		; jump|art id nibble

.return
		rts
; ---------------------------------------------------------------------------

BossTwoFaces_Touch_Restart:
		move.l	#BossTwoFaces_SetupMove,address(a0)
		move.l	#BossTwoFaces_Startup.skip,$34(a0)
		bclr	#optBTF_Hurt,obBTF_Opt(a0)
		rts

; ---------------------------------------------------------------------------
; Ball (process)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossTwoFaces_Ball_Process:

		; set xypos
		move.w	(Camera_X_pos).w,d0
		addi.w	#$A0,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$5C,d0
		move.w	d0,y_pos(a0)

		; extra balls
		lea	Child6_BossTwoFaces_IntroBall(pc),a2
		jsr	(CreateChild6_Simple).w

		; mapping
		lea	ObjDat_BossTwoFaces_Ball(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.w	#$2F,subtype(a0)
		move.b	#_BTF_BALL_,$39(a0)	; count
		move.b	#5,anim_frame_timer(a0)
		move.l	#.nextframe,address(a0)
		rts
; ---------------------------------------------------------------------------

.attack
		subq.w	#1,$2E(a0)			; wait time
		bpl.s	.nextframe

		; attack balls
		lea	Child6_BossTwoFaces_ShotBall(pc),a2
		jsr	(CreateChild6_Simple).w

		; set timer and check count
		move.w	subtype(a0),$2E(a0)
		subq.b	#1,$39(a0)
		bne.s	.nextframe
		move.l	#.delete,address(a0)

		; set close eyes
		movea.w	parent3(a0),a1
		move.w	#$7F,$2E(a1)
		move.l	#BossTwoFaces_Disappearance_CloseEyes,$34(a1)

.nextframe
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.move
		move.b	#5,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		bne.s	.move
		clr.b	mapping_frame(a0)
		move.b	#5,anim_frame_timer(a0)

.move
		jsr	(MoveSprite2).w

.draw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Ball (intro attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossTwoFaces_IntroBall:

		; timer
		moveq	#0,d0
		move.b	subtype(a0),d0
		lsr.b	d0
		andi.b	#$1E,d0
		lsr.b	d0
		lsl.w	#4,d0
		move.w	d0,$2E(a0)

		; set xypos
		move.w	(Camera_X_pos).w,d0
		moveq	#$5C,d1		; xpos
		move.w	#$400,d2	; xvel
		btst	#1,subtype(a0)
		beq.s	.notright
		move.w	#$E4,d1		; xpos
		neg.w	d2			; xvel

.notright
		add.w	d1,d0
		move.w	d0,x_pos(a0)
		move.w	d2,x_vel(a0)

		; set parents
		movea.w	parent3(a0),a1
		move.w	parent3(a0),parent4(a0)	; process address
		move.w	parent3(a1),parent3(a0)	; boss address

		; mapping
		lea	ObjDat_BossTwoFaces_Ball(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.b	#5,anim_frame_timer(a0)
		move.l	#.wait,address(a0)

.wait
		subq.w	#1,$2E(a0)				; wait time
		bpl.s	.notdraw
		move.l	#.nextframe,address(a0)

		btst	#1,subtype(a0)
		bne.s	.nextframe
		sfx	sfx_LaserBeam				; play sound

.nextframe
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.move
		move.b	#5,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#2,mapping_frame(a0)
		bne.s	.move
		move.l	#.delete,address(a0)

		cmpi.b	#(_BTF_BALL_*4)-2,subtype(a0)	; is the last ball?
		bne.s	.move							; if not, branch

		; set attack
		movea.w	parent4(a0),a1
		move.l	#Obj_BossTwoFaces_Ball_Process.attack,address(a1)

.move
		jsr	(MoveSprite2).w

		; flicker
		btst	#1,subtype(a0)
		bne.s	.check
		btst	#0,(Level_frame_counter+1).w
		bne.s	.notdraw

.draw
		jmp	(Child_Draw_Sprite).w
; ---------------------------------------------------------------------------

.check
		btst	#0,(Level_frame_counter+1).w
		bne.s	.draw

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Ball (attack)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossTwoFaces_ShotBall:

		; timer
		moveq	#0,d0
		move.b	subtype(a0),d0
		add.w	d0,d0
		add.w	d0,d0
		move.w	d0,$2E(a0)

		; mapping
		lea	ObjDat_BossTwoFaces_Ball(pc),a1
		jsr	(SetUp_ObjAttributes).w
		clr.b	routine(a0)
		move.b	#5,anim_frame_timer(a0)
		move.l	#.wait,address(a0)

		; set parents
		movea.w	parent3(a0),a1
		move.w	parent3(a1),parent3(a0)	; boss address

		; randomly shooting a Sonic
		move.b	(Oscillating_Data+$01).w,d0
		jsr	(GetSineCosine).w
		move.w	#-$280,d2				; speed
		muls.w	d2,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)

.wait
		subq.w	#1,$2E(a0)
		bpl.s	.notdraw
		move.w	#6*60,$2E(a0)			; attack time
		move.l	#.nextframe,address(a0)
		tst.b	subtype(a0)					; is the first ball?
		bne.s	.nextframe				; if not, branch
		sfx	sfx_FireShow					; play sound

.nextframe
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.move
		move.b	#5,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		bne.s	.move
		clr.b	mapping_frame(a0)
		move.b	#5,anim_frame_timer(a0)

.move
		bsr.s	.checkwall
		jsr	(MoveSprite2).w
		subq.w	#1,$2E(a0)
		bmi.s	.delete

.draw
		jmp	(Child_DrawTouch_Sprite).w
; ---------------------------------------------------------------------------

.notdraw
		jmp	(Child_CheckParent).w
; ---------------------------------------------------------------------------

.delete
		jmp	(Go_Delete_Sprite).w
; ---------------------------------------------------------------------------

.checkwall
		move.w	(Camera_Y_pos).w,d0
		tst.w	y_vel(a0)
		beq.s	.left
		bmi.s	.ceiling

		; check floor
		addi.w	#$D0,d0
		cmp.w	y_pos(a0),d0
		blo.s		.negy
		bra.s	.left

.ceiling
		addi.w	#$10,d0
		cmp.w	y_pos(a0),d0
		blo.s		.left

.negy
		neg.w	y_vel(a0)

.left

		; check wall
		move.w	(Camera_X_pos).w,d0
		tst.w	x_vel(a0)
		beq.s	.return
		bpl.s	.right

		; left
		addq.w	#8,d0
		cmp.w	x_pos(a0),d0
		bhs.s	.negx
		rts

.right
		addi.w	#$138,d0
		cmp.w	x_pos(a0),d0
		bhs.s	.return

.negx
		neg.w	x_vel(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Boss Two Faces (Collision, Animate, Drawing)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_MainProcess:
		bsr.s	BossTwoFaces_CheckTouch

	if _BTF_TEST_
		; test
		pea	(Draw_Sprite).w
		; test
	endif

		btst	#optBTF_Hurt,obBTF_Opt(a0)
		beq.w	BossTwoFaces_Animate
		jsr	(Add_SpriteToCollisionResponseList).l
		bra.w	BossTwoFaces_Animate

; ---------------------------------------------------------------------------
; Boss Two Faces (Test collision)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_CheckTouch:
		tst.b	collision_flags(a0)
		bne.s	.return
		tst.b	collision_property(a0)
		beq.s	BossTwoFaces_Defeated
		tst.b	obBTF_Flash(a0)
		bne.s	.flash
		sfx	sfx_HurtFire
		move.b	#$40,obBTF_Flash(a0)
		bset	#6,status(a0)
		move.w	#$14,(Screen_shaking_flag).w
		jsr	(Obj_HurtBloodCreate).l

.flash
		moveq	#0,d0
		btst	#0,obBTF_Flash(a0)
		bne.s	.skip
		addi.w	#6*2,d0

.skip
		bsr.w	BossTwoFaces_PalFlash
		subq.b	#1,obBTF_Flash(a0)
		bne.s	.return
		bclr	#6,status(a0)
		move.b	collision_restore_flags(a0),collision_flags(a0)

.return
		rts

; ---------------------------------------------------------------------------
; Boss Two Faces (Defeated)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Defeated:
		move.w	#$EF,$2E(a0)
		move.l	#.explosion,address(a0)

		; set defeated
		move.b	#6,anim(a0)
		st	(Screen_shaking_flag).w

		; normal palette to black
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree
		move.w	#7,subtype(a1)						; wait time
		move.w	#$9F,$2E(a1)							; wait time
		move.w	#Normal_palette_line_1,objoff_34(a1)	; palette ram
		move.l	#Pal_BossTwoFacesBlack,objoff_30(a1)	; palette pointer
		move.w	#64-1,objoff_38(a1)					; palette size

.notfree
		jmp	(BossDefeated_NoTime).w
; ---------------------------------------------------------------------------

.explosion
		lea	Child6_BossTwoFaces_Explosion(pc),a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree2
		move.w	#bytes_to_word(255/2,255/2),$3A(a1)
		move.l	#word_to_long($A0,$80),$30(a1)

.notfree2
		move.b	(Level_frame_counter+1).w,d0
		andi.b	#3,d0
		bne.s	.skip
		sfx	sfx_Bomb

.skip
		bsr.w	BossTwoFaces_Animate
		subq.w	#1,$2E(a0)
		bpl.s	.return
		move.l	#.delete,address(a0)

.return
		rts
; ---------------------------------------------------------------------------

.delete

		; set
		clr.b	(Boss_flag).w
		clr.w	(Screen_shaking_flag).w
		move.l	#VInt,(V_int_addr).w

		; restore palette
		lea	(Pal_SonicSCZ).l,a1
		lea	(Target_palette).w,a2
		jsr	(PalLoad_Line16).w
		lea	(Pal_SCZ).l,a1
		jsr	(PalLoad_Line48).w
		lea	(ChildObjDat6_SmoothPalette).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	.notfree3
		move.w	a1,parent4(a0)						; save address
		move.w	#7,subtype(a1)						; wait time
		move.w	#$2F,$2E(a1)							; wait time
		move.w	#Normal_palette,objoff_34(a1)			; palette ram
		move.l	#Target_palette,objoff_30(a1)			; palette pointer
		move.w	#64-1,objoff_38(a1)					; palette size

.notfree3

		; fade
		fadeout										; fade out music

		move.w	#$17,$2E(a0)
		move.l	#.reload,address(a0)

.reload
		subq.w	#1,$2E(a0)
		bpl.w	.return

		move.l	#.check,address(a0)

		; set
		move.l	#SCZ1_ScreenEvent,(Level_data_addr_RAM.ScreenEvent).w
		move.l	#SCZ1_BackgroundEvent_RefleshFG,(Level_data_addr_RAM.BackgroundEvent).w

		; reload chunks
		move.l	a0,-(sp)
		lea	(SCZ1_128x128_Kos).l,a0
		lea	(RAM_start).l,a1
		jsr	(Kos_Decomp).w
		movea.l	(sp)+,a0

.check
		cmpi.l	#SCZ1_BackgroundEvent,(Level_data_addr_RAM.BackgroundEvent).w
		bne.w	.return
		move.l	#.wait,address(a0)

.wait
		movea.w	parent4(a0),a1
		tst.b	objoff_36(a1)			; wait smooth palette
		bpl.w	.return
		addq.b	#2,(Dynamic_resize_routine).w

		; clear priority
		bclr	#7,(Player_1+art_tile).w

		; delete
		move.w	#1,(AstarothCompleted).w
		jmp	(Go_Delete_Sprite).w

; ---------------------------------------------------------------------------
; Boss Two Faces (Animate)
; ---------------------------------------------------------------------------

BossTwoFaces_Animate_FrameData:
		dc.w -1			; 0 (null)
		dc.w 0			; 1 (closex2)
		dc.w 2*$FC		; 2 (openx2)
		dc.w 4*$FC		; 3 (heart1)
		dc.w 5*$FC		; 4 (heart2)
		dc.w -1			; 5 (null)
		dc.w -1			; 6 (null)
		dc.w -1			; 7 (null)

; =============== S U B R O U T I N E =======================================

BossTwoFaces_Animate:
		lea	Anim_BossTwoFaces(pc),a1
		jsr	(Animate_SpriteIrregularDelay).w
		moveq	#0,d0
		move.b	mapping_frame(a0),d0
		cmp.b	obBTF_SaveFrame(a0),d0
		beq.s	.return
		move.b	d0,obBTF_SaveFrame(a0)
		andi.w	#7,d0
		move.b	d0,d1
		add.w	d0,d0
		move.w	BossTwoFaces_Animate_FrameData(pc,d0.w),d0
		bmi.s	.clearframe
		lea	(MapUnc_BossTwoFaces).l,a1
		adda.w	d0,a1

.loadframe
		bsr.s	.clearframe
		cmpi.b	#3,d1
		blo.s		.notheart
		lea	(BossTwoFaces_buffer+planeLocH40(16,6)).l,a2
		bra.s	.buffer
; ---------------------------------------------------------------------------

.notheart
		lea	(BossTwoFaces_buffer+planeLocH40(8,6)).l,a2
		bsr.s	.buffer
		lea	planeLocH40(16,-14)(a2),a2

.buffer
		lea	(a2),a3
		moveq	#(BossTwoFaces_Height/8-1),d2

.copy
		movea.l	a2,a3

	rept BossTwoFaces_Width/16
		move.l	(a1)+,(a3)+
	endr

	if BossTwoFaces_Width&8
		move.w	(a1)+,(a3)+
	endif

		lea	$80(a2),a2	; next line
		dbf	d2,.copy

.return
		rts
; ---------------------------------------------------------------------------

.clearframe
		lea	(BossTwoFaces_buffer).l,a2
		moveq	#0,d0
		move.w	#$1000/64-1,d3

.clear

	rept 64/4
		move.l	d0,(a2)+
	endr

		dbf	d3,.clear
		rts

; ---------------------------------------------------------------------------
; Boss Two Faces (Vertical interrupt)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

VInt_BossTwoFaces:
		movem.l	d0-a6,-(sp)	; save all the registers to the stack
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5

		; update buffer
		dma68kToVDP BossTwoFaces_buffer,vram_bg,$1000,VRAM

		jmp	VInt.main

; ---------------------------------------------------------------------------
; Boss Two Faces (Dark Palette)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_DarkPalette:

		; sub palette (shadow mode)
		move.w	a0,-(sp)
		lea	(Pal_DecColor).w,a1
		moveq	#3-1,d6

.loop
		lea	(Normal_palette).w,a0
		moveq	#64/2-1,d5

.nextcolour
		jsr	(a1)
		jsr	(a1)
		dbf	d5,.nextcolour
		dbf	d6,.loop
		movea.w	(sp)+,a0

.return
		rts

; ---------------------------------------------------------------------------
; Blinds Effect process (After)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_BlindsEffect_Process_LoadBoss:
		movea.w	parent3(a0),a1
		move.w	#$3F,$2E(a1)
		move.l	#BossTwoFaces_Load,$34(a1)
		move.l	#BossTwoFaces_SetupMove,address(a1)
		rts

; ---------------------------------------------------------------------------
; Blinds Effect process (Object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossTwoFaces_BlindsEffect_Process:

		; wait
		subq.w	#1,$2E(a0)
		bpl.s	BossTwoFaces_DarkPalette.return
		move.w	#1,$2E(a0)

		; process
		move.w	objoff_30(a0),d0
		addq.w	#2,objoff_30(a0)	; next
		bsr.s	BossTwoFaces_BlindsEffect
		cmpi.w	#66+2,d0
		beq.s	.jump

		; buffer
		move.l	#BossTwoFaces_buffer2>>1,d1
		move.w	#tiles_to_bytes($3C6),d2
		move.w	#$380/2,d3
		jmp	(Add_To_DMA_Queue).w
; ---------------------------------------------------------------------------

.jump

		; jump
		move.l	$34(a0),d0
		beq.s	.delete
		movea.l	d0,a1
		jsr	(a1)

.delete
		jmp	(Delete_Current_Sprite).w

; ---------------------------------------------------------------------------
; Blinds Effect (Process)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_BlindsEffect:
		lea	.data(pc),a1
		lea	(BossTwoFaces_buffer2).l,a2

.altdata
		moveq	#(._end-.data)/2-1,d3	; size data

.loop
		move.w	d0,d1		; get 'next' count
		sub.w	(a1)+,d1
		bmi.s	.skip
		cmpi.w	#32-1,d1
		bhi.s	.skip
		move.w	d3,d2		; get dbf count
		lsl.w	#6,d2			; calc pos
		add.w	d1,d1		; "
		add.w	d1,d2		; "
		clr.l	(a2,d2.w)		; clear 4 pixels (8x1 tile)

.skip
		dbf	d3,.loop
		rts
; ---------------------------------------------------------------------------

.data	; wait
		dc.w 26	; 14
		dc.w 24	; 13
		dc.w 22	; 12
		dc.w 20	; 11
		dc.w 18	; 10
		dc.w 16	; 9
		dc.w 14	; 8
		dc.w 12	; 7
		dc.w 10	; 6
		dc.w 8	; 5
		dc.w 6	; 4
		dc.w 4	; 3
		dc.w 2	; 2
		dc.w 0	; 1
._end

		dc.b $54, $68, $65, $42, $6C, $61, $64, $37, $36, $38

; ---------------------------------------------------------------------------
; Blinds Effect load mapping
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_BlindsEffect_LoadMap:
		disableIntsSave
		lea	(VDP_data_port).l,a6
		lea	VDP_control_port-VDP_data_port(a6),a5

		; load mapping
		locVRAM	$E000,VDP_control_port-VDP_control_port(a5)
		move.w	#$83C6,d0
		moveq	#224/8-1,d2		; 224 pixels (height)

.loop2
		moveq	#64-1,d1			; 512 pixels (width)

.loop
		move.w	d0,VDP_data_port-VDP_data_port(a6)
		dbf	d1,.loop
		addq.w	#1,d0			; next tile
		dbf	d2,.loop2
		enableIntsSave
		rts

; ---------------------------------------------------------------------------
; Blinds Effect load tiles
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_BlindsEffect_LoadTiles:

		; load tiles
		lea	(BossTwoFaces_buffer2).l,a1
		moveq	#-1,d0			; set tile
		moveq	#224/16-1,d1		; 224 pixels

.loop

	rept 16	; 2 tiles
		move.l	d0,(a1)+
	endr

		dbf	d1,.loop

		; buffer
		move.l	#BossTwoFaces_buffer2>>1,d1
		move.w	#tiles_to_bytes($3C6),d2
		move.w	#$380/2,d3
		jmp	(Add_To_DMA_Queue).w

; ---------------------------------------------------------------------------
; Explosion
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_BossTwoFaces_Explosion:
		jsr	(Create_New_Sprite3).w
		bne.s	.delete
		move.l	#.anim,address(a1)
		move.l	#Map_BossDEZExplosion,mappings(a1)
		move.w	#$859C,art_tile(a1)
		move.b	#4,render_flags(a1)
		move.w	#$100,priority(a1)
		move.w	#bytes_to_word(24/2,24/2),height_pixels(a0)		; set height and width
		move.w	(Camera_X_pos).w,d0
		add.w	objoff_30(a0),d0
		move.w	d0,x_pos(a1)
		move.w	(Camera_Y_pos).w,d0
		add.w	objoff_32(a0),d0
		move.w	d0,y_pos(a1)
		jsr	(loc_83E90).l
		move.b	(Oscillating_Data+$01).w,d1
		ext.w	d1
		asl.w	d1
		add.w	d1,x_vel(a1)
		move.w	#-$600,y_vel(a1)
		move.b	#3,anim_frame_timer(a1)

.delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.anim
		jsr	(MoveSprite2).w
		subq.b	#1,anim_frame_timer(a0)
		bpl.s	.draw
		move.b	#3,anim_frame_timer(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#7,mapping_frame(a0)
		beq.s	.delete

.draw
		jmp	(Draw_Sprite).w

; ---------------------------------------------------------------------------
; Palette flash
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

BossTwoFaces_PalFlash:
		lea	LoadBossTwoFaces_PalCycle(pc,d0.w),a2
		lea	LoadBossTwoFaces_PalRAM(pc),a1
		jmp	(CopyWordData_6).w
; ---------------------------------------------------------------------------

LoadBossTwoFaces_PalRAM:
		dc.w Normal_palette_line_3+$C
		dc.w Normal_palette_line_3+$E
		dc.w Normal_palette_line_3+$10
		dc.w Normal_palette_line_3+$12
		dc.w Normal_palette_line_3+$14
		dc.w Normal_palette_line_3+$16
LoadBossTwoFaces_PalCycle:
		dc.w $202, 4, $224, $226, $248, $468
		dc.w $EEE, $EEE, $EEE, $EEE, $EEE, $EEE

; =============== S U B R O U T I N E =======================================

ObjDat3_BossTwoFaces:			subObjData3 $200, 48/2, 48/2, 0, $F
ObjDat_BossTwoFaces_Ball:		subObjData Map_BossTwoFacesBall, $83BD, $180, 24/2, 24/2, 0, $18|$80

Child6_BossTwoFaces_Ball_Process:
		dc.w 1-1
		dc.l Obj_BossTwoFaces_Ball_Process
Child6_BossTwoFaces_IntroBall:
		dc.w (_BTF_BALL_*2)-1
		dc.l Obj_BossTwoFaces_IntroBall
Child6_BossTwoFaces_ShotBall:
		dc.w _BTF_BALLSIZE_-1
		dc.l Obj_BossTwoFaces_ShotBall
Child6_BossTwoFaces_BlindsEffect_Process:
		dc.w 1-1
		dc.l Obj_BossTwoFaces_BlindsEffect_Process
Child6_BossTwoFaces_Explosion:
		dc.w 1-1
		dc.l Obj_BossTwoFaces_Explosion

PLC_BossTwoFaces: plrlistheader
		plreq $230, ArtKosM_BossTwoFaces			; boss
		plreq $358, ArtKosM_BossTwoFacesFG		; boss (fg)
		plreq $3BD, ArtKosM_BossTwoFacesBall		; boss (ball)
		plreq $59C, ArtKosM_DEZExplosion			; boss (explosion)
PLC_BossTwoFaces_end
; ---------------------------------------------------------------------------

		include "Objects/Bosses/TwoFaces/Object Data/Anim - BossTwoFaces.asm"
		include "Objects/Bosses/TwoFaces/Object Data/Map - BossTwoFaces(Ball).asm"

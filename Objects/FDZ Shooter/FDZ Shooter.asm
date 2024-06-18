; ---------------------------------------------------------------------------
; Arrow from Sonic 2.
; Version 1.0
; By TheBlad768 (2022).
; ---------------------------------------------------------------------------

; Debug
_FS_SAFE_			= 1

; Dynamic object variables
obFS_Timer				= objoff_2E	; .w
obFS_Slot				= objoff_30	; .w
obFS_SaveTimer			= objoff_32	; .w
obFS_Opt				= objoff_38	; .b

; Options
_FDZSA_Fall				= 0
_FDZSA_First			= 1

; Animates (Shooter)
Anim_FDZSWait			= 0
Anim_FDZSFlash			= 1
Anim_FDZSOpenClose		= 2

; Animates (Arrow)
Anim_FDZSANormal		= 0
Anim_FDZSABend		= 1

; ---------------------------------------------------------------------------
; Shooter (object) (Subtype 1)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FDZShooter:
		lea	ObjDat_FDZShooter(pc),a1					; "
		jsr	(SetUp_ObjAttributes).w					; load mapping
		clr.b	routine(a0)
		move.b	subtype(a0),d0
		bmi.w	.altshot
		move.l	#.main,address(a0)					; "

.main
		cmpi.b	#Anim_FDZSOpenClose,anim(a0)		; the shooter closed?
		beq.s	.anim								; if not, branch
		move.w	x_pos(a0),d2							; get absolute value of xpos
		sub.w	(Player_1+x_pos).w,d2					; "
		bpl.s	.absx								; "
		neg.w	d2									; "

.absx
		moveq	#Anim_FDZSWait,d0					; the wait animation
		cmpi.w	#64,d2								; is the player within 64 pixels of the shooter?
		bhs.s	.notinrange							; if not, branch
		moveq	#Anim_FDZSFlash,d0					; change the shooter's flash animation

.notinrange
		tst.b	d0										; is the shooter's flash animation?
		bne.s	.setanim								; if yes, branch
		tst.b	anim(a0)								; the shooter's flash animation set?
		beq.s	.setanim								; if not, branch
		moveq	#Anim_FDZSOpenClose,d0				; change the shooter's open/close animation

.setanim
		move.b	d0,anim(a0)							; set animate
		subq.b	#Anim_FDZSOpenClose,d0				; is the shooter's open/close animation?
		bne.s	.anim								; if not, branch
		move.l	#.attack,address(a0)					; "

.attack
		tst.b	routine(a0)								; is the shooter open?
		beq.s	.anim								; if not, branch
		clr.b	routine(a0)								; clear open flag
		move.l	#.main,address(a0)					; "
		tst.b	subtype(a0)								; "
		bpl.s	.skipalt								; "
		move.l	#.altcheckanim,address(a0)				; "

.skipalt
		lea	ChildObjDat10_FDZShooter_Arrow(pc),a2	; create arrow
		jsr	(CreateChild10_NormalAdjusted).w			; "
		bne.s	.anim								; if arrow not created, skip
		move.b	status(a0),status(a1)					; "
		sfx	sfx_FireShot								; play sound

.anim
		lea	Anim_FDZShooter(pc),a1					; "
		jsr	(Animate_Sprite).w						; animate shooter
		jmp	(Sprite_OnScreen_Test).w					; draw shooter

; ---------------------------------------------------------------------------
; Shooter (object) (Subtype 2)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

.altshot
		andi.w	#$7F,d0								; "
		addq.w	#1,d0								; zero fix
		add.w	d0,d0								; "
		move.w	d0,obFS_SaveTimer(a0)				; set waiting time
		move.l	#.altcheckanim,address(a0)				; "

.altcheckanim
		cmpi.b	#Anim_FDZSOpenClose,anim(a0)		; the shooter closed?
		beq.s	.anim								; if not, branch
		move.l	#.altcheckrange,address(a0)			; "

.altcheckrange
		tst.b	render_flags(a0)							; shooter visible on the screen?
		bpl.s	.anim								; if not, branch
		move.w	obFS_SaveTimer(a0),obFS_Timer(a0)	; set waiting time from backup
		move.b	#Anim_FDZSFlash,anim(a0)			; change the shooter's flash animation
		move.l	#.altwait,address(a0)					; "

.altwait
		subq.w	#1,obFS_Timer(a0)					; wait
		bpl.s	.anim								; "
		move.b	#Anim_FDZSOpenClose,anim(a0)		; change the shooter's open/close animation
		move.l	#.attack,address(a0)					; "
		bra.s	.anim								; "

; ---------------------------------------------------------------------------
; Arrow (object)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Obj_FDZShooter_Arrow:
		move.l	#.main,address(a0)					; "
		lea	ObjDat3_FDZShooter_Arrow(pc),a1			; "
		jsr	(SetUp_ObjAttributes3).w					; load mapping
		move.b	#32/2-4,x_radius(a0)					; "
		clr.b	routine(a0)
		move.w	#$400,x_vel(a0)						; set arrow move to right
		btst	#0,status(a0)								; is object facing right?
		beq.s	.main								; if yes, branch
		neg.w	x_vel(a0)							; change arrow move to left

.main
		jsr	(MoveSprite2_XOnly).w
		jsr	(Add_SpriteToCollisionResponseList).l
		btst	#0,status(a0)								; is object facing right?
		beq.s	.notleft								; if yes, branch
		move.b	x_radius(a0),d3
		ext.w	d3
		neg.w	d3
		jsr	(ObjCheckLeftWallDist).w
		tst.w	d1
		bpl.w	.draw
		sub.w	d1,x_pos(a0)
		bra.s	.stop
; ---------------------------------------------------------------------------

.notleft
		move.b	x_radius(a0),d3
		ext.w	d3
		jsr	(ObjCheckRightWallDist).w
		tst.w	d1
		bpl.w	.draw
		add.w	d1,x_pos(a0)

.stop
		sfx	sfx_Arthur2								; play sound
		move.b	#Anim_FDZSABend,anim(a0)			; set bend animate
		move.w	#2*60,obFS_Timer(a0)				; set waiting time
		move.l	#.solid,address(a0)					; "
		clr.w	x_vel(a0)							; stop move
		movea.w	parent3(a0),a1						; get shooter address
		tst.w	obFS_Slot(a1)						; is the first arrow object?
		bne.s	.second								; if not, branch
		move.w	a0,obFS_Slot(a1)						; set first arrow address
		bset	#_FDZSA_First,obFS_Opt(a0)				; set first arrow flag

.second
		btst	#_FDZSA_First,obFS_Opt(a0)				; is the first arrow object?
		bne.s	.solid								; if yes, branch
		movea.w	obFS_Slot(a1),a2						; get first arrow address
	if _FS_SAFE_
		cmpi.l	#Map_FDZShooter,mappings(a2)		; is the arrow object?
		bne		.skip								; if not, branch
	endif
		move.w	a0,obFS_Slot(a1)						; set first arrow address
		bset	#_FDZSA_First,obFS_Opt(a0)				; now second arrow is the first
		bset	#_FDZSA_Fall,obFS_Opt(a2)				; set fall flag for first arrow object
		move.w	#-$80,y_vel(a2)						; set kickback

.solid
		moveq	#0,d1								; "
		move.b	width_pixels(a0),d1					; "
		addi.w	#$B,d1								; "
		moveq	#0,d3								; "
		move.b	height_pixels(a0),d3					; "
		subq.w	#2,d3								; "
		move.w	x_pos(a0),d4							; "
		jsr	(SolidObjectTop).w						; "
		tst.b	anim(a0)								; is the arrow's bend animation?
		bne.s	.draw								; if yes, branch
		btst	#_FDZSA_Fall,obFS_Opt(a0)				; second arrow hit the first?
		bne.s	.skip								; if yes, branch
		subq.w	#1,obFS_Timer(a0)					; wait before falling
		bpl.s	.draw								; "
		btst	#_FDZSA_First,obFS_Opt(a0)				; is the first arrow object?
		beq.s	.skip								; if not, branch
		movea.w	parent3(a0),a1						; get shooter address
		cmpa.w	obFS_Slot(a1),a0						; is it the same object?
		bne.s	.skip								; if not, branch
		clr.w	obFS_Slot(a1)						; clear first arrow address

.skip
		move.l	#.fall,address(a0)						; ***THIS IS WHERE YOU FALL DOWN***
		jsr	(Displace_PlayerOffObject).w				; release Sonic from object

.draw
		lea	Anim_FDZShooter_Arrow(pc),a1			; "
		jsr	(Animate_Sprite).w						; animate arrow
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.offscreen
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

.offscreen
		move.w	respawn_addr(a0),d0
		beq.s	.delete
		movea.w	d0,a2
		bclr	#7,(a2)

.delete
		move.l	#Go_Delete_Sprite,address(a0)			; "
		btst	#_FDZSA_First,obFS_Opt(a0)				; is the first arrow object?
		beq.s	.return								; if not, branch
		movea.w	parent3(a0),a1						; get shooter address
		cmpa.w	obFS_Slot(a1),a0						; is it the same object?
		bne.s	.return								; if not, branch
		clr.w	obFS_Slot(a1)						; clear first arrow address

.return
		rts
; ---------------------------------------------------------------------------

.fall
		moveq	#$38,d2
		jsr	(MoveSprite_CustomGravity_YOnly).w
		move.w	x_pos(a0),d0
		andi.w	#-128,d0
		sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#128+320+192,d0
		bhi.s	.delete
		move.w	y_pos(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#320+192,d0
		bhi.s	.delete
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

ObjDat_FDZShooter:			subObjData Map_FDZShooter, $C404, $180, 32/2, 16/2, 0, 0
ObjDat3_FDZShooter_Arrow:	subObjData3 $200, 32/2, 8/2, 0, $1B|$80

ChildObjDat10_FDZShooter_Arrow:
		dc.w 1-1
		dc.l Obj_FDZShooter_Arrow
		dc.b 0, 0
; ---------------------------------------------------------------------------

		include "Objects/FDZ Shooter/Object Data/Anim - Arrow.asm"
		include "Objects/FDZ Shooter/Object Data/Anim - Shooter.asm"
		include "Objects/FDZ Shooter/Object Data/Map - Shooter.asm"

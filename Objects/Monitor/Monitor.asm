
; =============== S U B R O U T I N E =======================================

Obj_Monitor:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	Monitor_Index(pc,d0.w),d1
		jmp	Monitor_Index(pc,d1.w)
; ---------------------------------------------------------------------------

Monitor_Index: offsetTable
		offsetTableEntry.w Obj_MonitorInit
		offsetTableEntry.w Obj_MonitorMain
		offsetTableEntry.w Obj_MonitorBreak
		offsetTableEntry.w Obj_MonitorAnimate
		offsetTableEntry.w loc_1D61A
; ---------------------------------------------------------------------------

Obj_MonitorInit:
		addq.b	#2,routine(a0)
		move.b	#$F,y_radius(a0)
		move.b	#$F,x_radius(a0)
		move.l	#Map_Monitor,mappings(a0)
		move.w  x_pos(a0),objoff_44(a0)
		move.w	#make_art_tile(ArtTile_Powerups,0,0),art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.w	#$180,priority(a0)
		move.b	#$E,width_pixels(a0)
		move.b	#$10,height_pixels(a0)
		move.w	respawn_addr(a0),d0				; Get address in respawn table
		beq.s	.notbroken						; If it's zero, it isn't remembered
		movea.w	d0,a2							; Load address into a2
		btst	#0,(a2)								; Is this monitor broken?
		beq.s	.notbroken						; If not, branch
		move.b	#$B,mapping_frame(a0)			; Use 'broken monitor' frame
		move.l	#Sprite_OnScreen_Test,(a0)
		rts
; ---------------------------------------------------------------------------

.notbroken:
		move.b	#$46,collision_flags(a0)
		move.b	subtype(a0),anim(a0)				; Subtype determines what powerup is inside

Obj_MonitorMain:
		bsr.w	Obj_MonitorFall
		move.w	x_pos(a0),-(sp)
                bsr.s   MonitorMoveWithParent
;SolidObject_Monitor:
		move.w	#$19,d1							; Monitor's width
		move.w	#$10,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	(sp)+,d4
		lea	(Player_1).w,a1

	cmpi.b	#$04,(Current_Zone).w					; MJ: is this the credits?
	bne.s	.NoCredits						; MJ: if not, continue normally
	move.b	#$46,collision_flags(a0)				; MJ: set valid collision
	tst.l	(CreditsRoutine).w					; MJ: is an effect running?
	beq.s	.NoCredits						; MJ: if not, continue normally
	sf.b	collision_flags(a0)					; MJ: set NO collision (cannot destroy monitor)

	move.w	obX(a0),d0						; MJ: is Sonic near the monitor on X?
	sub.w	obX(a1),d0						; MJ: ''
	addi.w	#$0020,d0						; MJ: ''
	cmpi.w	#$0040,d0						; MJ: ''
	bhs.s	.NoCredits						; MJ: if not, continue
	move.w	obY(a0),d0						; MJ: is Sonic near OR ABOVE the monitor on Y?
	sub.w	obY(a1),d0						; MJ: ''
	addi.w	#$0080,d0						; MJ: ''
	cmpi.w	#$00C0,d0						; MJ: ''
	bhs.s	.NoCredits						; MJ: if not, continue
	move.b	#$01,(CreditsHold).w					; MJ: force current message to fly off...

	.NoCredMessage:

	.NoCredits:

		moveq	#p1_standing_bit,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SolidObject_Monitor_SonicKnux
		movem.l	(sp)+,d1-d4

		jsr	(Add_SpriteToCollisionResponseList).l
		lea	Ani_Monitor(pc),a1
		jsr	(Animate_Sprite).w
                jmp	(Sprite_OnScreen_Test).w
loc_1D61A:
                bsr.s   MonitorMoveWithParent
                jmp	(Sprite_OnScreen_Test).w
MonitorMoveWithParent:
                move.w    parent3(a0),d0   ; is this monitor child type ?
                beq.s    .return   ; if not then its a level placement type
                movea.w  d0,a1
                move.l   x_pos(a1),d0
                swap     d0 ; get lower word
                subq.w   #$1,d0
                swap     d0
                move.l   d0,x_pos(a0)
                move.l   y_pos(a1),d0
                swap     d0 ; get lower word
                addi.w   #$15,d0 ; add 1C to it
                swap     d0   ; go back to preivous like go back to x pos not subxpo
                move.l   d0,y_pos(a0)
 .return:
                rts
; ---------------------------------------------------------------------------

Obj_MonitorAnimate:
		cmpi.b	#$B,mapping_frame(a0)			; Is monitor broken?
		bne.s	.notbroken						; If not, branch
		move.l	#loc_1D61A,(a0)

.notbroken:
		lea	Ani_Monitor(pc),a1
		jsr	(Animate_Sprite).w
		bsr.s   MonitorMoveWithParent
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Obj_MonitorFall:
		move.b	routine_secondary(a0),d0
		beq.s	locret_1D694
		btst	#1,render_flags(a0)					; Is monitor upside down?
		bne.s	Obj_MonitorFallUpsideDown		; If so, branch

Obj_MonitorFallUpsideUp:
		jsr	(MoveSprite).w
		tst.w	y_vel(a0)						; Is monitor moving up?
		bmi.s	locret_1D694						; If so, return
		jsr	(ObjCheckFloorDist).w
		tst.w	d1								; Is monitor in the ground?
		beq.s	.inground						; If so, branch
		bpl.s	locret_1D694						; if not, return

.inground:
		add.w	d1,y_pos(a0)						; Move monitor out of the ground
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)					; Stop monitor from falling
		rts
; ---------------------------------------------------------------------------

Obj_MonitorFallUpsideDown:
		jsr	(MoveSprite2).w
		subi.w	#$38,y_vel(a0)
		tst.w	y_vel(a0)						; Is monitor moving down?
		bpl.s	locret_1D694						; If so, return
		jsr	(ObjCheckCeilingDist).w
		tst.w	d1								; Is monitor in the ground (ceiling)?
		beq.s	.inground						; If so, branch
		bpl.s	locret_1D694						; if not, return

.inground:
		sub.w	d1,y_pos(a0)						; Move monitor out of the ground
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)					; Stop monitor from falling

locret_1D694:
		rts
; End of function Obj_MonitorFall

; =============== S U B R O U T I N E =======================================

SolidObject_Monitor_SonicKnux:
		btst	d6,status(a0)							; Is Sonic/Knux standing on the monitor?
		bne.s	Monitor_ChkOverEdge				; If so, branch

		cmpi.b	#$04,(Current_Zone).w					; MJ: is this the credits?
		bne.s	.NoCredits						; MJ: if not, continue normally
		tst.l	(CreditsRoutine).w					; MJ: is an effect running?
		bne.s	.SolidCredits						; MJ: if so, make monitor non-hitable (just solid)

	.NoCredits:
		cmpi.b	#id_Roll,anim(a1)					; Is Sonic/Knux in their rolling animation?
		beq.s	locret_1D694						; If so, return

	.SolidCredits:
		jmp	SolidObject_cont
; End of function SolidObject_Monitor_SonicKnux

; =============== S U B R O U T I N E =======================================

Monitor_ChkOverEdge:
		move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)							; Is the character in the air?
		bne.s	.notonmonitor					; If so, branch
		; Check if character is standing on
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	.notonmonitor					; Branch, if character is behind the left edge of the monitor
		cmp.w	d2,d0
		blo.s	Monitor_CharStandOn				; Branch, if character is not beyond the right edge of the monitor

.notonmonitor:
		; if the character isn't standing on the monitor
		bclr	#3,status(a1)							; Clear 'on object' bit
		bset	#1,status(a1)							; Set 'in air' bit
		bclr	d6,status(a0)							; Clear 'standing on' bit for the current character
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Monitor_CharStandOn:
		move.w	d4,d2
		jsr	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function SolidObject_Monitor_Tails

; =============== S U B R O U T I N E =======================================

Obj_MonitorBreak:
                bsr.w     MonitorMoveWithParent
                moveq   #0,d0 ; clears x and y pos long word info stuff
		move.b	status(a0),d0
		andi.b	#standing_mask|pushing_mask,d0	; Is someone touching the monitor?
		beq.s	Obj_MonitorSpawnIcon			; If not, branch
		move.b	d0,d1
		andi.b	#p1_standing|p1_pushing,d1		; Is it the main character?
		beq.s	Obj_MonitorSpawnIcon			; If not, branch
		andi.b	#$D7,(Player_1+status).w
		ori.b	#2,(Player_1+status).w				; Prevent main character from walking in the air

Obj_MonitorSpawnIcon:
		andi.b	#3,status(a0)
		clr.b	collision_flags(a0)
		jsr	(Create_New_Sprite3).w
		bne.s	.skipiconcreation

	cmpi.b	#$04,(Current_Zone).w					; MJ: is this the credits?
	bne.s	.NoCredits						; MJ: if not, continue normally
	move.l	#CRE_MonitorWait,(CreditsRoutine).w			; MJ: set effect routine to something null (but prevent another monitor from being broken)

	.NoCredits:
		move.l	#Obj_MonitorContents,address(a1)
		move.w	x_pos(a0),x_pos(a1)				; Set icon's position
		move.w	y_pos(a0),y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.b	status(a0),status(a1)
		move.b	anim(a0),d0
		cmpi.b	#9,d0							; Is it the random monitor?
		bne.s	.skipanim						; If not, branch
		move.b	anim_frame(a0),d0
		addq.b	#1,d0

.skipanim:
		move.b	d0,anim(a1)						; Set anim

.skipiconcreation:
		jsr	(Create_New_Sprite3).w
		bne.s	.skipexplosioncreation
		move.l	#Obj_Explosion,address(a1)
		addq.b	#2,routine(a1)					; => loc_1E61A
		move.w	x_pos(a0),x_pos(a1)				; Set explosion's position
		move.w	y_pos(a0),y_pos(a1)

.skipexplosioncreation:
		move.w	respawn_addr(a0),d0				; Get address in respawn table
		beq.s	.notremembered					; If it's zero, it isn't remembered
		movea.w	d0,a2							; Load address into a2
		bset	#0,(a2)								; Mark monitor as destroyed

.notremembered:
		move.b	#$A,anim(a0)					; Display 'broken' animation
		move.l	#Obj_MonitorAnimate,(a0)
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

Obj_MonitorContents:
		moveq	#0,d0
		move.b	routine(a0),d0
		move.w	off_1D7C8(pc,d0.w),d1
		jmp	off_1D7C8(pc,d1.w)
; ---------------------------------------------------------------------------

off_1D7C8:
		dc.w loc_1D7CE-off_1D7C8
		dc.w loc_1D81A-off_1D7C8
		dc.w loc_1DB2E-off_1D7C8
; ---------------------------------------------------------------------------

loc_1D7CE:
		addq.b	#2,routine(a0)
		move.w	#make_art_tile(ArtTile_Powerups,0,1),art_tile(a0)	; always on top
		ori.b	#$24,render_flags(a0)
		move.w	#1*$80,priority(a0)		; always on top!
		move.b	#8,width_pixels(a0)
		move.w	#-$300,y_vel(a0)
		btst	#1,render_flags(a0)		; is monitor Upside-Down
		beq.s	loc_1D7FC 				; if not, branch
		neg.w	y_vel(a0)				; move downwards

loc_1D7FC:
		moveq	#0,d0
		move.b	$20(a0),d0
		move.b	d0,$22(a0)
		lea	Map_Monitor(pc),a1
		add.b	d0,d0
		adda.w	4(a1,d0.w),a1
		addq.w	#2,a1
		move.l	a1,$C(a0)

loc_1D81A:
		bsr.s	sub_1D820
		jmp	(Draw_Sprite).w

; =============== S U B R O U T I N E =======================================

sub_1D820:
		btst	#1,render_flags(a0)
		bne.s	loc_1D83C
		tst.w	$1A(a0)
		bpl.w	loc_1D850
		jsr	(MoveSprite2).w
		addi.w	#$18,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_1D83C:
		tst.w	$1A(a0)
		bmi.w	loc_1D850
		jsr	(MoveSprite2).w
		subi.w	#$18,$1A(a0)
		rts
; ---------------------------------------------------------------------------

loc_1D850:
		addq.b	#2,routine(a0)
		move.w	#$1D,$24(a0)
		lea	(Player_1).w,a1
		moveq	#0,d0
		move.b	anim(a0),d0
		add.w	d0,d0
		cmpi.b	#$04,(Current_Zone).w			; MJ: is this credits?
		beq.s	.Credits				; MJ: if so, use special credits routines
		move.w	off_1D87C(pc,d0.w),d0
		jmp	off_1D87C(pc,d0.w)

	.Credits:
		jmp	Monitor_Credits				; MJ: see "Data\Misc\Credits Text Sprites.asm"
; End of function sub_1D820
; ---------------------------------------------------------------------------

off_1D87C: offsetTable
		offsetTableEntry.w Monitor_Give_Eggman			; 0 (Null)
		offsetTableEntry.w Monitor_Give_Eggman			; 1 (Robotnik)
		offsetTableEntry.w Monitor_Give_Rings				; 2 (Rings)
		offsetTableEntry.w Monitor_Give_Fire_Shield			; 3 (Fire)
		offsetTableEntry.w Monitor_Give_Lightning_Shield	; 4 (Electro)
		offsetTableEntry.w Monitor_Give_Bubble_Shield		; 5 (Bubble)
		offsetTableEntry.w Monitor_Give_Blue_Shield			; 6 (Blue)
		offsetTableEntry.w Monitor_Give_Empty				; 7 (Sword)
		offsetTableEntry.w Monitor_Give_Empty				; 8 (Skull)
		offsetTableEntry.w Monitor_Give_Empty				; 9 (Random)
; ---------------------------------------------------------------------------

Monitor_Give_Eggman:
		bra.w	sub_24280
; ---------------------------------------------------------------------------

Monitor_Give_Rings:
;		cmpi.w	#0,(Skull_Invulnerability).w
;		beq.s	.giverings
;		move.w	#1,(Spirit_Shield).w
;		jsr	(SingleObjLoad2).w
;		bne.w	.giverings
;		move.l	#Obj_MSkullIndicator,(a1)

;.giverings:
		move.b	(v_rings).w,d1			; NOV: Get current HP
		addq.b	#5,d1					; NOV: Increment it by a full HP ring
		cmpi.b	#25,d1					; NOV: Is the HP already maximized?
		blt.s	.sethp					; NOV: If not, branch
		move.b	#25,d1					; NOV: Cap it

.sethp:
		move.b	d1,(v_rings).w			; NOV: Store new HP counter

.updatecounter:
		ori.b	#1,(f_ringcount).w		; NOV: Update HP in the HUD
		ringsfx	d0				; play ring sound
		rts
; ---------------------------------------------------------------------------

;Monitor_Give_Super_Sneakers:
		bset	#2,status_secondary(a1)
		move.b	#150,speed_shoes_timer(a1)
		move.w	#$C00,(Sonic_Knux_top_speed).w
		move.w	#$18,(Sonic_Knux_acceleration).w
		move.w	#$80,(Sonic_Knux_deceleration).w
		command	cmd_ShoesOn		; Speed up the music
		rts
; ---------------------------------------------------------------------------

Monitor_Give_Fire_Shield:
		tst.w	(Enlarged_InstaShield).w
		beq.s	+
		move.w 	#1,(Enlarged_InstaShield).w
+		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		bset	#Status_FireShield,status_secondary(a1)
		move.l	#Obj_Fire_Shield,(v_Shield).w
		sfx	sfx_FireShield
		rts
; ---------------------------------------------------------------------------

Monitor_Give_Lightning_Shield:
		tst.w	(Enlarged_InstaShield).w
		beq.s	+
		move.w 	#1,(Enlarged_InstaShield).w
+		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		bset	#Status_LtngShield,status_secondary(a1)
		move.l	#Obj_Lightning_Shield,(v_Shield).w
		sfx	sfx_LightShield
		rts
; ---------------------------------------------------------------------------

Monitor_Give_Bubble_Shield:
		tst.w	(Enlarged_InstaShield).w
		beq.s	+
		move.w 	#1,(Enlarged_InstaShield).w
+		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		bset	#Status_BublShield,status_secondary(a1)
		move.l	#Obj_Bubble_Shield,(v_Shield).w
		sfx	sfx_BubbleShield
		rts
; ---------------------------------------------------------------------------

;Monitor_Give_Invincibility:
		bset	#1,status_secondary(a1)
		move.b	#150,invincibility_timer(a1)
		tst.b	(Boss_flag).w
		bne.s	loc_1DA3E
		cmpi.b	#12,air_left(a1)
		bls.s	loc_1DA3E
		music	mus_Invincible

loc_1DA3E:
		move.l	#Obj_Invincibility,(v_Invincibility_stars).w
		rts
; ---------------------------------------------------------------------------

Monitor_Give_Sword:
		rts
		lea	(Player_1).w,a1
		move.b	status_secondary(a1),d0
		andi.b	#$73,d0				; Does the player have any shields or is invincible?
		bne.s	Monitor_Give_Empty		; if yes, branch
		andi.b	#$8E,status_secondary(a1)
		move.w 	#$438,(Enlarged_InstaShield).w
		move.l	#Obj_Big_Insta_Shield,(v_Shield).w
		move.b	#4,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp
		jsr	(Create_New_Sprite3).w
		bne.s	+
		move.l	#Obj_SmoothPalette,address(a1)
		move.w	#7,subtype(a1)
		move.l	#Pal_BigInstaShieldSonic,$30(a1)
		move.w	#Normal_palette_line_1,$34(a1)
		move.w	#16-1,$38(a1)
+		rts
; ---------------------------------------------------------------------------

Monitor_Give_Empty:
		rts
; ---------------------------------------------------------------------------

Monitor_Give_Blue_Shield:
		tst.w	(Enlarged_InstaShield).w
		beq.s	+
		move.w 	#1,(Enlarged_InstaShield).w
+		andi.b	#$8E,status_secondary(a1)
		bset	#Status_Shield,status_secondary(a1)
		move.l	#Obj_BlueShield,(v_Shield).w
		sfx	sfx_BlueShield
		rts
; ---------------------------------------------------------------------------

loc_1DB2E:
		subq.w	#1,$24(a0)
		bmi.s	loc_1DB34
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

loc_1DB34:
		jmp	(Delete_Current_Sprite).w

; ===========================================================================

		include "Objects/Monitor/Object data/Anim - Monitor.asm"
		include "Objects/Monitor/Object data/Map - Monitor.asm"

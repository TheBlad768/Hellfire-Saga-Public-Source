
; =============== S U B R O U T I N E =======================================

Obj_GMZ1Lava_y =	x_vel		; longword

Obj_GMZ1Lava:
		move.l	#H_GMZ1Lava2,H_int_addr.w		; NAT: set null h-int address
		move.w	#$8014,VDP_control_port			; NAT: enable h-ints

		move.l	#Obj_wait,(a0)				; delay a few frames to let VDP and game settle
		move.w	#3,$2E(a0)
		move.l	#.wait,$34(a0)				; run this routine after 3 frames

		lea	MapKosM_GMZ1Lava,a1
		move.w	#tiles_to_bytes($434),d2
		jmp	Queue_Kos_Module
; ---------------------------------------------------------------------------

.wait
		move.l	#H_GMZ1Lava,H_int_addr.w		; NAT: set to new h-int address
		move.w	#$7D8,x_vel(a0)				; NAT: Set the object y-position
		move.w	#$8230,Extra_VDP_Write.w		; NAT: Fix plane on each v-int
		st	Lava_Event.w

		move.l	#.main,(a0)
		cmp.b	#8,Last_star_post_hit.w			; check if we are at the starpost after the lava section
		bhi.s	.initkill				; if not, branch

.rts3
		rts
; ---------------------------------------------------------------------------

.initkill
		move.l	#.chkkill,(a0)				; change the routine

.chkkill
		move.w	#$310,Obj_GMZ1Lava_y(a0)		; move the lava lower
		tst.b	Boss_flag.w				; check if level is ending
		bne.w	.levelend				; branch to level end routine

		cmp.w	#$3200,Camera_x_pos.w			; check if camera is already far behind the curve
		bhs.s	.copypos				; if so, do not kill player!
		move.l	#$26E0000,Obj_GMZ1Lava_y(a0)		; setup lava so that it does not move
		bra.s	.normal
; ---------------------------------------------------------------------------

.sound
		move.b	v_vbla_byte.w,d0			; get frame #
		andi.b	#$F,d0					; check for every $20th frame
		bne.s	.copypos				; if not, skip
		sfx	sfx_SpecialRumble			; play rumbling sound

.copypos
		move.w	Obj_GMZ1Lava_y(a0),Water_level.w	; copy object y-pos to lava pos

.rts
		rts
; ---------------------------------------------------------------------------

.main
		cmp.w	#$1A0,Camera_Y_pos.w			; check if camera is so high that its safe to switch over
		bhs.s	.noswitch				; if not, dont bother
		cmp.w	#$2D00,Camera_x_pos.w			; check if the camera is also far enough away (cleared that halfpipe)
		bhi.w	.stoplava				; if so, stop lava movement

.noswitch
		tst.b	Lava_Event.w				; check if lava should move upwards
		ble.s	.copypos				; if no, branch
; ---------------------------------------------------------------------------

.normal
	; process player collision with lava
		move.w	Player_1+x_pos.w,d4			; copy x-pos
		moveq	#$10,d1					; give some bogus width
		sub.w	d1,d4					; center the position
		add.w	d1,d1					; double the x-pos
		move.b	d1,width_pixels(a0)			; set the width of the object (silly player)
		move.w	d4,x_pos(a0)				; copy d4 to x-pos

		moveq	#$0C,d3					; height that matches the lava line
		move.w	Obj_GMZ1Lava_y(a0),y_pos(a0)		; copy y-pos for the top routine
		add.w	#$12,y_pos(a0)				; adjust so that Sonic stands on the lava instead
		jsr	SolidObjectTop.w			; handle solid object

	; hide broken lava buffer
		move.w	y_pos(a0),d0					; copy y-pos
		subi.w	#224/2+20,d0				; set camera position
		move.w	d0,Camera_max_Y_pos.w		; locked bottom camera

	; thank u for enjoying this masterpiece
		cmp.b	#4,Player_1+routine.w			; check if player is hurt or dead
		bge.s	.copypos				; if so, branch
		tst.b	invulnerability_timer(a1)
		bne.s	.copypos
		btst	#p1_standing_bit,status(a0)		; check if Sonic is standing on the object
		beq.s	.movewtr				; branch if not
		tst.w	(Skull_Invulnerability).w
                bne.s	.movewtr
		tst.w	(Debug_placement_mode).w
		bne.s	.movewtr
		btst	#Status_Invincible,status_secondary(a1)
		bne.s	.movewtr

		movea.l	a0,a2
		lea	Player_1.w,a0				; get player data to a0
		jsr	HurtCharacter.l				; make Sonic go owie
		movea.l	a2,a0
		rts
; ---------------------------------------------------------------------------

.movewtr
		moveq	#0,d0					; clear upper word
		move.w	Difficulty_Flag.w,d0			; load difficulty to d0
		add.w	d0,d0					; *2
		move.w	.lavaspeed(pc,d0.w),d0			; load lava speed to d0

		sub.l	d0,Obj_GMZ1Lava_y(a0)			; move y-position of object

;		move.w	#$60,Distance_from_screen_top.w		; stop camera from scrolling! Very important, lava is too short

		cmp.w	#$26E,Water_level.w			; check if the lava is high enough already
		bhi.w	.sound					; if not, move the lava still

.stoplava
		move.l	#.chkkill,(a0)				; run routine that checks whether player should get killed by the surface
		st	Lava_Event.w				; stop lava moving. It will still display
		clr.b	Screen_Shaking_Flag.w

.rts2
		rts
; ---------------------------------------------------------------------------

.levelend
		move.l	#.lavadown,(a0)				; make the lava go down (for transition)

.lavadown
		add.l	#$8000,Obj_GMZ1Lava_y(a0)		; increase lava position
		move.w	Obj_GMZ1Lava_y(a0),Water_level.w	; copy it
		cmp.w	#$340,Water_level.w			; check if lava is so low we can't see it anymore
		blo.s	.rts2					; if not, skip

		clr.b	Lava_Event.w				; remove lava event
		move.l	#$80048230,VDP_control_port		; NAT: disable h-ints & set the forerground plane location
		move.l	#HInt,(H_int_addr).w			; NAT: Reset h-int address
		move.l	#$8AFF8800,H_int_counter_command.w	; NAT: make sure no glitches can appear
		jmp	Delete_Current_Sprite			; delete the object! no longer needed
; ---------------------------------------------------------------------------

;		lea	(PLC2_GMZ1_Enemy).l,a5
;		jsr	(LoadPLC_Raw_KosM).w
;		jmp	(LoadPLC_KosM).w						; reload graphics

.lavaspeed
		dc.w $8000, $C000, $E000, $FFFF			; lava speeds at various difficulties

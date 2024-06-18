; ---------------------------------------------------------------------------
; Subroutine to react to obColType(a0)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

; Test_Sprite_Collisions:
TouchResponse:
		bsr.w	Test_Ring_Collisions
		bsr.w	ShieldTouchResponse
		tst.b	character_id(a0)								; Is the player Sonic?
		bne.s	.Touch_NoInstaShield						; If not, branch
		move.b	status_secondary(a0),d0
		andi.b	#$73,d0									; Does the player have any shields or is invincible?
		bne.s	.Touch_NoInstaShield						; If so, branch
		; By this point, we're focussing purely on the Insta-Shield
		cmpi.b	#1,double_jump_flag(a0)					; Is the Insta-Shield currently in its 'attacking' mode?
		bne.s	.Touch_NoInstaShield						; If not, branch
		move.b	status_secondary(a0),d0					; Get status_secondary...
		move.w	d0,-(sp)									; ...and save it
		bset	#Status_Invincible,status_secondary(a0)			; Make the player invincible
		move.w	x_pos(a0),d2								; Get player's x_pos
		move.w	y_pos(a0),d3								; Get player's y_pos
		subi.w	#$18,d2									; Subtract width of Insta-Shield
		subi.w	#$18,d3									; Subtract height of Insta-Shield

		cmpi.w	#0,(Enlarged_InstaShield).w
		beq.s	.SkipDuplication
		subi.w  #$18,d2		; Subtract width/height of Insta Shield one more time
		subi.w	#$18,d3

.SkipDuplication:
		move.w	#$30,d4									; Player's width
		move.w	#$30,d5									; Player's height
		bsr.s	.Touch_Process
		move.w	(sp)+,d0									; Get the backed-up status_secondary
		btst	#Status_Invincible,d0							; Was the player already invincible (wait, what? An earlier check ensures that this can't happen)
		bne.s	.alreadyinvincible							; If so, branch
		bclr	#Status_Invincible,status_secondary(a0)			; Make the player vulnerable again

.alreadyinvincible:
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

.Touch_NoInstaShield:
		move.w	x_pos(a0),d2				; Get player's x_pos
		move.w	y_pos(a0),d3				; Get player's y_pos
		subq.w	#8,d2
		moveq	#0,d5
		move.b	y_radius(a0),d5	; load Sonic's height
		subq.b	#3,d5
		sub.w	d5,d3
		; Note the lack of a check for if the player is ducking
		; Height is no longer reduced by ducking
		move.w	#$10,d4			; Player's collision width
		add.w	d5,d5

.Touch_Process:
		lea	(Collision_response_list).w,a4
		move.w	(a4)+,d6				; Get number of objects queued
		beq.s	locret_FF1C				; If there are none, return

Touch_Loop:
		movea.w	(a4)+,a1				; Get address of first object's RAM
		move.b	collision_flags(a1),d0			; Get its collision_flags
		bne.s	Touch_Width				; If it actually has collision, branch

; loc_FF16:
Touch_NextObj:
		subq.w	#2,d6					; Count the object as done
		bne.s	Touch_Loop				; If there are still objects left, loop
		moveq	#0,d0

locret_FF1C:
		rts
; ---------------------------------------------------------------------------

Touch_Width:
		andi.w	#$3F,d0					; Get only collision size
		add.w	d0,d0					; Turn into index
		lea	Touch_Sizes(pc,d0.w),a2
		moveq	#0,d1
		move.b	(a2)+,d1				; Get width value from Touch_Sizes
		move.w	x_pos(a1),d0				; Get object's x_pos
		sub.w	d1,d0					; Subtract object's width
		sub.w	d2,d0					; Subtract player's left collision boundary
		bcc.s	.checkrightside				; If player's left side is to the left of the object, branch
		add.w	d1,d1					; Double object's width value
		add.w	d1,d0					; Add object's width*2 (now at right of object)
		bcs.s	Touch_Height				; If carry, branch (player is within the object's boundaries)
		bra.s	Touch_NextObj				; If not, loop and check next object
; ---------------------------------------------------------------------------

; loc_FF3E:
.checkrightside:
		cmp.w	d4,d0					; Is player's right side to the left of the object?
		bhi.s	Touch_NextObj				; If so, loop and check next object
; loc_FF42:
Touch_Height:
		moveq	#0,d1
		move.b	(a2)+,d1				; Get height value from Touch_Sizes
		move.w	y_pos(a1),d0				; Get object's y_pos
		sub.w	d1,d0					; Subtract object's height
		sub.w	d3,d0					; Subtract player's bottom collision boundary
		bcc.s	.checktop				; If bottom of player is under the object, branch
		add.w	d1,d1					; Double object's height value
		add.w	d1,d0					; Add object's height*2 (now at top of object)
		bcs.w	Touch_ChkValue				; If carry, branch (player is within the object's boundaries)
		bra.s	Touch_NextObj				; If not, loop and check next object
; ---------------------------------------------------------------------------
; loc_FF5A:
.checktop:
		cmp.w	d5,d0					; Is top of player under the object?
		bhi.s	Touch_NextObj				; If so, loop and check next object
		bra.w	Touch_ChkValue
; ---------------------------------------------------------------------------
; collision sizes (width,height)
Touch_Sizes:
		dc.b 8/2, 8/2		; 0
		dc.b 40/2, 40/2	; 1
		dc.b 24/2, 40/2	; 2
		dc.b 40/2, 24/2	; 3
		dc.b 8/2, 32/2	; 4
		dc.b 24/2, 36/2	; 5
		dc.b 32/2, 32/2	; 6
		dc.b 12/2, 12/2	; 7
		dc.b 48/2, 24/2	; 8
		dc.b 24/2, 32/2	; 9
		dc.b 32/2, 16/2	; A
		dc.b 16/2, 16/2	; B
		dc.b 40/2, 32/2	; C
		dc.b 40/2, 16/2	; D
		dc.b 28/2, 28/2	; E
		dc.b 48/2, 48/2	; F
		dc.b 80/2, 32/2	; 10
		dc.b 32/2, 48/2	; 11
		dc.b 16/2, 32/2	; 12
		dc.b 64/2, 224/2	; 13
		dc.b 128/2, 64/2	; 14
		dc.b 256/2, 64/2	; 15
		dc.b 64/2, 64/2	; 16
		dc.b 16/2, 16/2	; 17
		dc.b 8/2, 8/2		; 18
		dc.b 64/2, 16/2	; 19
		dc.b 24/2, 24/2	; 1A
		dc.b 16/2, 8/2	; 1B
		dc.b 48/2, 8/2	; 1C
		dc.b 80/2, 8/2	; 1D
		dc.b 8/2, 16/2	; 1E
		dc.b 8/2, 48/2	; 1F
		dc.b 8/2, 80/2	; 20
		dc.b 48/2, 48/2	; 21
		dc.b 16/2, 48/2	; 22
		dc.b 24/2, 48/2	; 23
		dc.b 144/2, 16/2	; 24
		dc.b 48/2, 80/2	; 25
		dc.b 32/2, 8/2	; 26
		dc.b 64/2, 4/2	; 27
		dc.b 32/2, 56/2	; 28
		dc.b 24/2, 72/2	; 29
		dc.b 32/2, 4/2	; 2A
		dc.b 8/2, 128/2	; 2B
		dc.b 48/2, 128/2	; 2C
		dc.b 64/2, 32/2	; 2D
		dc.b 56/2, 40/2	; 2E
		dc.b 32/2, 4/2	; 2F
		dc.b 32/2, 40/2	; 30
		dc.b 4/2, 16/2	; 31
		dc.b 32/2, 128/2	; 32
		dc.b 24/2, 8/2	; 33
		dc.b 16/2, 24/2	; 34
		dc.b 80/2, 64/2	; 35
		dc.b 128/2, 4/2	; 36
		dc.b 192/2, 8/2	; 37
		dc.b 80/2, 80/2	; 38
		dc.b 80/2, 48/2	; 39
; ---------------------------------------------------------------------------

Touch_ChkValue:
		move.b	collision_flags(a1),d1					; Get its collision_flags
		andi.b	#$C0,d1								; Get only collision type bits
		beq.w	Touch_Enemy						; If 00, enemy, branch
		cmpi.b	#$C0,d1
		beq.w	Touch_Special						; If 11, "special thing for starpole", branch
		tst.b	d1
		bmi.w	Touch_ChkHurt						; If 10, "harmful", branch
		; If 01...
		move.b	collision_flags(a1),d0					; Get collision_flags
		andi.b	#$3F,d0								; Get only collision size
		cmpi.b	#6,d0								; Is touch response $46 ?
		beq.w	Touch_Monitor						; if yes, branch
		cmpi.b	#$1B,d0								; Is touch response $5B ?
		beq.s	Touch_Phantom_Hand						; if yes, branch
		cmpi.b	#5,d0								; Is touch response $45 ?
		beq.w	Touch_Red_Guardian						; if yes, branch
		move.b	(Player_1+invulnerability_timer).w,d0	; Get the main character's invulnerability_timer
		cmpi.b	#90,d0								; Is there more than 90 frames on the timer remaining?
		bhs.w	.locret								; If so, branch
		move.b	#4,routine(a1)						; Set target object's routine to 4 (must be reserved for collision response)

.locret:
		rts
; ---------------------------------------------------------------------------
Touch_Phantom_Hand:
		cmpi.w	#1,(Hand_Squeezes_Player).w
		beq.s	.chkrings
		cmpi.b	#id_SpinDash,obAnim(a0)			; is Sonic Spin Dashing?
		beq.s	.chkRoutine
                cmpi.b  #id_Roll,obAnim(a0)
                beq.s   .chkRoutine
                bra.s   .capture

.chkRoutine:
                cmpi.b  #8,routine(a1)
                beq.w   Touch_Hurt
                bra.w   .kill

.capture:
		btst	#Status_Shield,status_secondary(a0)	; does Sonic have shield?
		beq.s	+	; if no, branch
                bsr.w   Sonichasshield
+               move.w  #1,(Hand_Squeezes_Player).w
                move.w	#$80,priority(a1)
		move.b	#$A,routine(a1)
		move.b	#2,obAnim(a1)
		cmpi.w	#$100,ground_vel(a0)
		blt.s	.capspeed
		move.w	#$100,ground_vel(a0)

.capspeed:
		move.w	#$100,(Sonic_Knux_top_speed).w
		move.w	#8,(Sonic_Knux_acceleration).w
		bra.w	.return

.chkrings:
		move.b	(v_rings).w,d0
		cmpi.b	#5,d0
		bcc.s	.substractrings
		move.l	#Obj_Explosion,(a1)
		clr.b	routine(a1)
		clr.b	(v_rings).w
		beq.w	KillSonic

.substractrings:
		move.w	(V_int_run_count+2).w,d0
		andi.w	#$3C,d0
		bne.w	.chkspin
		ringsfx	d0
		sub.b	#1,(v_rings).w
		bpl.s	.updatering								; NOV: If it did not underflow, branch
		clr.b	(v_rings).w						; NOV: Cap HP at 0

.updatering:
		move.b	#$80,(Update_HUD_ring_count).w

.chkspin:
		cmpi.b	#id_SpinDash,obAnim(a0)			; is Sonic Spin Dashing?
		beq.s	.kill
		cmpi.b	#id_Roll,obAnim(a0)			; is Sonic Spin Dashing?
		beq.s	.kill
		bra.s	.return

.kill:
                move.b  #$C,routine(a1)

.return:
		rts
; ---------------------------------------------------------------------------
Touch_Red_Guardian:
		cmpi.b	#id_SpinDash,obAnim(a0)			; is Sonic Spin Dashing?
		beq.w	.kill
                cmpi.b	#id_Roll,obAnim(a0)			; is Sonic rolling?
		bne.w	Touch_Enemy

		cmpi.b  #0,$33(a1)
		bne.s   .return

                neg.w   x_vel(a0)
                neg.w   y_vel(a0)

                move.w  x_pos(a1),d0
                sub.w   #$F,d0
                move.w  x_pos(a0),d1
                cmp.w   d0,d1
                blt.s   .protect

                move.w  x_pos(a1),d0
                add.w   #$F,d0
                move.w  x_pos(a0),d1
                cmp.w   d0,d1
                bcc.s   .protect

.kill:
                samp	sfx_GhostDeath
		move.l	#Obj_Explosion,(a1)
		clr.b	routine(a1)
		jsr	(Obj_HurtBloodCreate).l
                rts

.protect:
                btst	#1,status(a0)
                beq.s   .kill
                move.b  #2,obAnim(a1)
		move.b  #$1E,$33(a1)
                sfx	sfx_Pump
		bset    #6,$2A(a1)

.return:
                rts
; ---------------------------------------------------------------------------

Touch_Monitor:
		cmpi.l	#Obj_Honey_BombMissile,(a1)
		beq.w	Touch_LoveBomb
	;	move.w	y_vel(a0),d0				; Get player's y_vel
	;	tst.b	GravityAngle.w				; Are we in reverse gravity mode?
	;	bpl.s	.normalgravity				; If not, branch
	;	neg.w	d0					; Negate player's y_vel

.normalgravity:
	;	btst	#1,render_flags(a1)			; Is the monitor upside down?
	;	beq.s	.monitornotupsidedown			; If not, branch
	;	tst.w	d0
	;	beq.s	.checkdestroy				; If player isn't moving up or down at all, branch
	;	bmi.s	.checkdestroy				; If player is moving up, branch
	;	bra.s	.checkfall				; If player is moving down, branch
; ---------------------------------------------------------------------------

.monitornotupsidedown:
	;	tst.w	d0
	;	bpl.s	.checkdestroy				; If player is moving down, branch

.checkfall:
	;	bra.s	.checkdestroy				; AF: fix upside-down monitor behavior
; ---------------------------------------------------------------------------

.checkdestroy:
		cmpi.b	#id_Roll,obAnim(a0) ; is Sonic rolling/jumping?
		bne.s	.locret
		neg.w	y_vel(a0)
		move.b	#4,routine(a1)

.locret:
		rts

Touch_LoveBomb:
		move.b	#4,routine(a1)
		bra.w	Touch_ChkHurt
; ---------------------------------------------------------------------------

Touch_Enemy:
		btst	#Status_Invincible,status_secondary(a0)	; does Sonic have invincibility?
		bne.s	.checkhurtenemy					; if yes, branch
		cmpi.b	#id_SpinDash,obAnim(a0)			; is Sonic Spin Dashing?
		beq.s	.checkhurtenemy					; if yes, branch
		cmpi.b	#id_Roll,obAnim(a0)				; is Sonic rolling/jumping?
		beq.s	.checkhurtenemy					; if not, branch
		cmpi.b	#2,character_id(a0)				; Is player Knuckles?
		bne.s	.notknuckles						; If not, branch
		cmpi.b	#1,double_jump_flag(a0)			; Is Knuckles gliding?
		beq.s	.checkhurtenemy					; If so, branch
		cmpi.b	#3,double_jump_flag(a0)			; Is Knuckles sliding across the ground after gliding?
		beq.s	.checkhurtenemy					; If so, branch
		bra.w	Touch_ChkHurt
; ---------------------------------------------------------------------------

.notknuckles:
		cmpi.b	#1,character_id(a0)			; Is player Tails
		bne.w	Touch_ChkHurt				; If not, branch
		tst.b	double_jump_flag(a0)			; Is Tails flying ("gravity-affected")
		beq.w	Touch_ChkHurt				; If not, branch
		btst	#Status_Underwater,status(a0)		; Is Tails underwater
		bne.w	Touch_ChkHurt				; If not, branch
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		subi.b	#$20,d0
		cmpi.b	#$40,d0
		bhs.w	Touch_ChkHurt

.checkhurtenemy:
		; Boss related? Could be special enemies in general
		tst.b	boss_hitcount2(a1)
		beq.w	Touch_EnemyNormal
		cmpi.l	#Obj_Ghoul,(a1)
		beq.w	.ghoulspecial
		cmpi.l	#Obj_Fly,(a1)
		beq.w	.ignorex
		cmpi.l	#Obj_Wolf,(a1)
		beq.w	.ignorex
		cmpi.l	#Obj_AxeGhost,(a1)
		beq.s	.ignorex
		cmpi.l	#Obj_Feal2,(a1)
		beq.w	.jumpover
		neg.w	x_vel(a0)						; Bounce player directly off boss
		bra.s	.ignorex

.ghoulspecial:
		samp	sfx_GhoulDeath

.ignorex:
		neg.w	y_vel(a0)
		neg.w	ground_vel(a0)

.jumpover:
		move.b	collision_flags(a1),collision_restore_flags(a1)
		clr.b	collision_flags(a1)

	if Debug_EasyBoss
		clr.b	boss_hitcount2(a1)
	else
		subq.b	#1,boss_hitcount2(a1)
		bne.s	.bossnotedefeated
	endif
		bset	#7,status(a1)

.bossnotedefeated:
		rts
; ---------------------------------------------------------------------------

Touch_EnemyNormal:
		btst	#2,status(a1)			; Should the object remember that it's been destroyed (Remember Sprite State flag)?
		beq.s	.dontremember			; If not, branch
		move.b	ros_bit(a1),d0
		movea.w	ros_addr(a1),a2
		bclr	d0,(a2)				; Mark object as destroyed
; loc_101AC:
.dontremember:
		bset	#7,obStatus(a1)
		move.l	#Obj_Explosion,(a1) ; change object to explosion
		clr.b	routine(a1)
		tst.w	y_vel(a0)
		bmi.s	.bouncedown
		move.w	y_pos(a0),d0
		cmp.w	y_pos(a1),d0			; Was player above, or at the same height as, the enemy when it was destroyed
		bhs.s	.bounceup
		neg.w	y_vel(a0)
		rts
; ---------------------------------------------------------------------------

.bouncedown:
		addi.w	#$100,y_vel(a0)			; Bounce down
		rts
; ---------------------------------------------------------------------------

.bounceup:
		subi.w	#$100,y_vel(a0)			; Bounce up
		rts
; ---------------------------------------------------------------------------

Enemy_Points:	dc.w 10, 20, 50, 100	; points awarded div 10
; ---------------------------------------------------------------------------
; Subroutine for checking if Sonic/Tails/Knuckles should be hurt and hurting them if so
; note: character must be at a0
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Touch_ChkHurt:
		move.b	status_secondary(a0),d0
		andi.b	#$73,d0					; Does player have any shields or is invincible?
		beq.s	Touch_ChkHurt_NoPowerUp			; If not, branch
		and.b	shield_reaction(a1),d0			; Does one of the player's shields grant immunity to this object??
		bne.s	Touch_ChkHurt_Return			; If so, branch
		btst	#Status_Shield,status_secondary(a0)	; Does the player have a shield (strange time to ask)
		bne.s	Touch_ChkHurt_HaveShield		; If so, branch

Touch_ChkHurt2:
		btst	#Status_Invincible,status_secondary(a0)	; does Sonic have invincibility?
		beq.s	Touch_Hurt	; if not, branch

Touch_ChkHurt_Return:
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

Touch_ChkHurt_NoPowerUp:
		; Note that this check could apply to the Insta-Shield,
		; but the check that branches to this requires the player not be invincible.
		; The Insta-Shield grants temporary invincibility. See the problem?
		cmpi.b	#1,double_jump_flag(a0)			; Is player Insta-Shield-attacking (Sonic), flying (Tails) or gliding (Knuckles)?
		bne.s	Touch_ChkHurt2				; If not, branch

Touch_ChkHurt_HaveShield:
		move.b	shield_reaction(a1),d0
		andi.b	#8,d0					; Should the object be bounced away by a shield?
		beq.s	Touch_ChkHurt2				; If not, branch

Touch_ChkHurt_Bounce_Projectile:
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		muls.w	#-$800,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		muls.w	#-$800,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a1)
		clr.b	collision_flags(a1)
		bra.s	Touch_ChkHurt_Return
; ---------------------------------------------------------------------------

Touch_Hurt:
		tst.b	invulnerability_timer(a0)	; Is the player invulnerable?
		bne.s	Touch_ChkHurt_Return		; If so, branch
		tst.w	(Skull_Invulnerability).w	; Is the player invulnerable?
		bne.s	Touch_ChkHurt_Return		; If so, branch
		movea.l	a1,a2

; End of function TouchResponse
; continue straight to HurtCharacter
; ---------------------------------------------------------------------------
; Hurting Sonic/Tails/Knuckles subroutine
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

HurtSonic:
HurtCharacter:
		moveq	#0,d0
		move.b	(Ring_count).w,d0
		btst	#Status_Shield,status_secondary(a0)	; does Sonic have shield?
		bne.s	Sonichasshield	; if yes, branch
		tst.b	status_tertiary(a0)
		bmi.s	Sonicbounce
		tst.b	d0	; does Sonic have any rings?
		beq.w	Sonicnorings	; if not, branch
		cmpi.w	#3,(Difficulty_Flag).w
		beq.w	Sonicnorings

;		bsr.w	Create_New_Sprite
;		bne.s	Sonichasshield
;		move.l	#Obj_Bouncing_Ring,(a1)				; load bouncing multi rings object

		move.b	#$80,(Update_HUD_ring_count).w	; NOV: Update HP in the HUD
		moveq	#0,d1							; NOV: Calculate the amount we need to subtract from the HP
		move.b  (v_rings).w,d1					; NOV: Get HP % 5
		divu.w	#5,d1							; NOV: ''
		swap	d1								; NOV: ''
		addq.b	#5,d1							; NOV: Add full HP ring amount
		sub.b	d1,(v_rings).w					; NOV: Decrement from the current HP
		bpl.s	+								; NOV: If it did not underflow, branch
		clr.b	(v_rings).w						; NOV: Cap HP at 0
+
		beq.w	KillSonic						; NOV: If the HP is 0, branch

		move.l	a2,-(sp)
		jsr	(Obj_HurtBloodCreate).l
		movea.l	(sp)+,a2

Sonichasshield:
		andi.b	#-$72,status_secondary(a0)

Sonicbounce:
		move.b	#4,obRoutine(a0)
		bsr.w	Sonic_ResetOnFloor
		bset	#1,obStatus(a0)
		cmpi.w #1,(EvilEye_GravityEvent).w
		beq.s 	+
		move.w	#-$400,obVelY(a0)			; make Sonic bounce away from the object
		move.w	#-$200,obVelX(a0)
		btst	#Status_Underwater,obStatus(a0)		; is Sonic underwater?
		beq.s	.isdry						; if not, branch
+		move.w	#-$200,obVelY(a0)			; slower bounce
		move.w	#-$100,obVelX(a0)

.isdry:
		move.w	obX(a0),d0
		cmp.w	obX(a2),d0
		blo.s	.isleft						; if Sonic is left of the object, branch
		neg.w	obVelX(a0)					; if Sonic is right of the object, reverse

.isleft:
		move.w	#0,obInertia(a0)
		move.b	#id_Hurt,obAnim(a0)
		move.b	#120,invulnerability_timer(a0)		; set temp invincible time to 2 seconds

		move.w	#sfx_Death,d0				; load normal damage sound
		cmpi.l	#Obj_Spikes,(a2)				; was damage caused by spikes?
		blo.s	.sound						; if not, branch
		cmpi.l	#sub_24280,(a2)
		bhs.s	.sound
		move.w	#sfx_HitSpikes,d0				; load spikes damage sound

.sound:
		jsr	dFractalQueue
		moveq	#-1,d0
		rts
; ---------------------------------------------------------------------------

Sonicnorings:
		move.w	#sfx_Death,d0				; load normal damage sound
		cmpi.l	#Obj_Spikes,(a2)				; was damage caused by spikes?
		blo.s	loc_10364					; if not, branch
		cmpi.l	#sub_24280,(a2)
		bhs.s	loc_10364
		move.w	#sfx_HitSpikes,d0				; load spikes damage sound

loc_10364:
		bra.s	loc_1036E
; ---------------------------------------------------------------------------

KillSonic:
Kill_Character:
		tst.w	(Debug_placement_mode).w	; is debug mode	active?
		bne.s	loc_1036E.dontdie	; if yes, branch
	;	move.w	#sfx_Death,d0

loc_1036E:
		st.b	(Update_HUD_ring_count).w	; NOV: Update HP in the HUD
		clr.b	(v_rings).w						; NOV: Set HP at 0
		st	(NoPause_flag).w
		clr.b	status_secondary(a0)
		clr.b	status_tertiary(a0)
		clr.b	(Sonic_NoKill).w
		move.b	#6,obRoutine(a0)
		jsr	Sonic_ResetOnFloor
		bset	#1,obStatus(a0)
		bset	#7,obGfx(a0)
		clr.l	obVelX(a0)
		clr.b	(Lust_Cutscene).w
		move.b  #id_Null,obAnim(a0)
		clr.w  (Hand_Squeezes_Player).w
		jsr	Obj_KillBloodCreate

.dontdie:
		;moveq	#$FFFFFF84,d0
		;jsr	(PlaySample).l
		moveq	#-1,d0
		rts
; End of function KillSonic
; ---------------------------------------------------------------------------

Touch_Special:
		move.b	collision_flags(a1),d1	; Get collision_flags
		andi.b	#$3F,d1				; Get only collision size (but that doesn't seems to be its use here)
		cmpi.b	#7,d1
		beq.s	loc_103FA
		cmpi.b	#6,d1
		beq.s	loc_103FA
		cmpi.b	#$A,d1
		beq.s	loc_103FA
		cmpi.b	#$C,d1
		beq.s	loc_103FA
		cmpi.b	#$15,d1
		beq.s	loc_103FA
		cmpi.b	#$16,d1
		beq.s	loc_103FA
		cmpi.b	#$17,d1
		beq.s	loc_103FA
		cmpi.b	#$18,d1
		beq.s	loc_103FA
		cmpi.b	#$21,d1
		beq.s	loc_103FA
		rts
; ---------------------------------------------------------------------------

loc_103FA:
		addq.b	#1,collision_property(a1)	; Otherwise, it seems everything else does double
		rts
; End of function Touch_Special

; =============== S U B R O U T I N E =======================================

Add_SpriteToCollisionResponseList:
		lea	(Collision_response_list).w,a1
		cmpi.w	#$7E,(a1)	; Is list full?
		bhs.s	.locret		; If so, return
		addq.w	#2,(a1)		; Count this new entry
		adda.w	(a1),a1		; Offset into right area of list
		move.w	a0,(a1)		; Store RAM address in list

.locret:
		rts
; End of function Add_SpriteToCollisionResponseList

; =============== S U B R O U T I N E =======================================

ShieldTouchResponse:
		move.b	status_secondary(a0),d0
		andi.b	#$71,d0				; Does the player have any shields?
		beq.s	locret_1045C
		move.w	x_pos(a0),d2			; Get player's x_pos
		move.w	y_pos(a0),d3			; Get player's y_pos
		subi.w	#$18,d2				; Subtract width of shield
		subi.w	#$18,d3				; Subtract height of shield
		move.w	#$30,d4				; Player's width
		move.w	#$30,d5				; Player's height
		lea	(Collision_response_list).w,a4
		move.w	(a4)+,d6			; Get number of objects queued
		beq.s	locret_1045C			; If there are none, return
; loc_10448:
ShieldTouch_Loop:
		movea.w	(a4)+,a1			; Get address of first object's RAM
		move.b	collision_flags(a1),d0		; Get its collision_flags
		andi.b	#$C0,d0				; Get only collision type bits
		cmpi.b	#$80,d0				; Is only the high bit set ("harmful")?
		beq.s	ShieldTouch_Width		; If so, branch
; loc_10458:
ShieldTouch_NextObj:
		subq.w	#2,d6				; Count the object as done
		bne.s	ShieldTouch_Loop		; If there are still objects left, loop

locret_1045C:
		rts
; ---------------------------------------------------------------------------
; loc_1045E:
ShieldTouch_Width:
		move.b	collision_flags(a1),d0		; Get collision_flags
		andi.w	#$3F,d0				; Get only collision size
		beq.s	ShieldTouch_NextObj		; If it doesn't have a size, branch
		add.w	d0,d0				; Turn into index
		lea	Touch_Sizes(pc),a2
		lea	(a2,d0.w),a2			; Go to correct entry
		moveq	#0,d1
		move.b	(a2)+,d1			; Get width value from Touch_Sizes
		move.w	x_pos(a1),d0			; Get object's x_pos
		sub.w	d1,d0				; Subtract object's width
		sub.w	d2,d0				; Subtract player's left collision boundary
		bhs.s	.checkrightside			; If player's left side is to the left of the object, branch
		add.w	d1,d1				; Double object's width value
		add.w	d1,d0				; Add object's width*2 (now at right of object)
		blo.s	ShieldTouch_Height		; If carry, branch (player is within the object's boundaries)
		bra.s	ShieldTouch_NextObj		; If not, loop and check next object
; ---------------------------------------------------------------------------
; loc_1048A:
.checkrightside:
		cmp.w	d4,d0				; Is player's right side to the left of the object?
		bhi.s	ShieldTouch_NextObj		; If so, loop and check next object
; loc_1048E:
ShieldTouch_Height:
		moveq	#0,d1
		move.b	(a2)+,d1			; Get height value from Touch_Sizes
		move.w	y_pos(a1),d0			; Get object's y_pos
		sub.w	d1,d0				; Subtract object's height
		sub.w	d3,d0				; Subtract player's bottom collision boundary
		bcc.s	.checktop			; If bottom of player is under the object, branch
		add.w	d1,d1				; Double object's height value
		add.w	d1,d0				; Add object's height*2 (now at top of object)
		bcs.w	.checkdeflect			; If carry, branch (player is within the object's boundaries)
		bra.s	ShieldTouch_NextObj		; If not, loop and check next object
; ---------------------------------------------------------------------------
; loc_104A6:
.checktop:
		cmp.w	d5,d0				; Is top of player under the object?
		bhi.s	ShieldTouch_NextObj		; If so, loop and check next object
; loc_104AA:
.checkdeflect:
		move.b	shield_reaction(a1),d0
		andi.b	#8,d0				; Should the object be bounced away by a shield?
		beq.s	ShieldTouch_NextObj		; If not, branch
		move.w	x_pos(a0),d1
		move.w	y_pos(a0),d2
		sub.w	x_pos(a1),d1
		sub.w	y_pos(a1),d2
		jsr	(GetArcTan).w
		jsr	(GetSineCosine).w
		muls.w	#-$800,d1
		asr.l	#8,d1
		move.w	d1,x_vel(a1)
		muls.w	#-$800,d0
		asr.l	#8,d0
		move.w	d0,y_vel(a1)
		clr.b	collision_flags(a1)
		rts
; End of function ShieldTouchResponse


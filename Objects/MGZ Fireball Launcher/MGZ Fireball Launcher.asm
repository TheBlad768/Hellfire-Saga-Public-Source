
; =============== S U B R O U T I N E =======================================

Obj_MGZFireballLauncher:
		move.l	#Map_MGZFireballLauncherH,mappings(a0)
		move.w	#$435C,art_tile(a0)
		ori.b	#4,render_flags(a0)
		move.b	#16/2,width_pixels(a0)
		move.b	#32/2,height_pixels(a0)
		move.w	#$280,priority(a0)
		move.b	#3,mapping_frame(a0)
		moveq	#0,d0
		move.b	subtype(a0),d0
		bpl.w	MGZFireballLauncher_Vertical_Init
		andi.w	#$7F,d0
		lsl.w	#2,d0
		move.w	d0,$30(a0)
		move.l	#.horizontal,address(a0)

.horizontal:
		subq.w	#1,$2E(a0)
		bpl.w	.draw
		move.w	$30(a0),$2E(a0)
		tst.b	render_flags(a0)
		bpl.s	.draw
		jsr	(Create_New_Sprite3).w
		bne.s	.draw
		move.l	#Obj_MGZFireballLauncher_Fireball,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addq.w	#8,x_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	#$35C,art_tile(a1)
		move.w	#$300,priority(a1)
		move.b	#24/2,width_pixels(a1)
		move.b	#16/2,height_pixels(a1)
		move.b	#$1B|$80,collision_flags(a1)
		bset	#Status_FireShield,shield_reaction(a1)
		move.w	#$200,x_vel(a1)
		btst	#0,status(a0)
		beq.s	.sound
		neg.w	x_vel(a1)
		subi.w	#$10,x_pos(a1)

.sound:
		sfx	sfx_LavaBall

.draw:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

MGZFireballLauncher_Vertical_Init:
		lsl.w	#2,d0
		move.w	d0,$30(a0)
		move.l	#Map_MGZFireballLauncherV,mappings(a0)
		move.b	#32/2,width_pixels(a0)
		move.b	#16/2,height_pixels(a0)
		move.l	#.vertical,address(a0)

.vertical:
		subq.w	#1,$2E(a0)
		bpl.w	.draw
		move.w	$30(a0),$2E(a0)
		tst.b	render_flags(a0)
		bpl.w	.draw
		jsr	(Create_New_Sprite3).w
		bne.w	.draw
		move.l	#Obj_MGZFireballLauncher_Fireball,address(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		addq.w	#8,y_pos(a1)
		move.b	render_flags(a0),render_flags(a1)
		move.l	mappings(a0),mappings(a1)
		move.w  #$35C,d6
		move.w	d6,art_tile(a1)

		move.w	#$300,priority(a1)
		move.b	#16/2,width_pixels(a1)
		move.b	#24/2,height_pixels(a1)
		move.b	#$1E|$80,collision_flags(a1)
		move.b  subtype(a0),subtype(a1)
		bset	#Status_FireShield,shield_reaction(a1)
		move.b  #0,objoff_44(a1) ; set as not reverse gravity flag
		move.w	#-$600,y_vel(a1)
		tst.b   Current_act.w
		beq.s   .Act1FireBall
		move.w  #-$200,y_vel(a1)
 .Act1FireBall:
		btst	#1,status(a0)
		beq.s	.sound
		neg.w	y_vel(a1)
		subi.w	#$10,y_pos(a1)
		move.b  #1,objoff_44(a1) ; set as vertically reverse gravity flag

.sound:
		sfx	sfx_LavaBall

.draw:
		jmp	(Sprite_OnScreen_Test).w

; =============== S U B R O U T I N E =======================================

Obj_MGZFireballLauncher_Fireball:
		move.b	(Level_frame_counter+1).w,d0
		andi.b	#1,d0
		bne.s	.draw
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#3,mapping_frame(a0)
		bne.s	.draw
		clr.b	mapping_frame(a0)

.draw:
		tst.b	render_flags(a0)
		bpl.s	.delete
		tst.b   Current_act.w
		bne.s   .NotVertical
		cmpi.b  #$20,subtype(a0)
		bne.s   .NotVertical
		tst.b   objoff_44(a0)
		beq.s   .NotVeticallyFlippedType
		tst.w   y_vel(a0)
		bpl.s   .FireFall
		bra.s   .CheckFlipping
.NotVeticallyFlippedType:
		tst.w   y_vel(a0)
		bmi.s   .FireFall
 .CheckFlipping:
		tst.b   routine(a0)
		bne.s   .CheckFloor
		btst    #1,render_flags(a0)
		bne.s   .AlreadyFlipped
	        bset    #1,render_flags(a0)
	        addq.b  #1,routine(a0)
	        bra.s   .CheckFloor
 .AlreadyFlipped:
                bclr    #1,render_flags(a0)
                addq.b  #1,routine(a0) ; set as done flipping object flag
 .CheckFloor:
		jsr	ObjCheckFloorDist
		tst.w	d1
		bpl.s	.FireFall
		add.w	d1,y_pos(a0)

                clr.w    y_vel(a0)
                bra.s   .delete
 .FireFall:
                bchg    #0,objoff_47(a0)
                beq.s   .DrawAndTouch
                addi.w	#$30,y_vel(a0) ; make object fall

 .NotVertical:
		bsr.s	FireBallMoveSprite
 .DrawAndTouch:
		jmp	(Draw_And_Touch_Sprite).w
; ---------------------------------------------------------------------------

.delete:
		jmp	(Delete_Current_Sprite).w
FireBallMoveSprite:
         	movem.w	x_vel(a0),d0/d2		; load horizontal speed
         ;	tst.b  	(GravityAngle).w
	  ;      beq.s	.NogravityApplied
	   ;     neg.w   d0
	    ;    neg.w   d2   ; do this to not have to add extra code for gravity flipping
	     ;   ext.l   d0
	      ;  ext.l   d2
 .NogravityApplied:
		asl.l	#8,d0				; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,x_pos(a0)		; add to x-axis position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
		asl.l	#8,d2				; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d2,y_pos(a0)		; add to y-axis position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
		rts
; ---------------------------------------------------------------------------

		include "Objects/MGZ Fireball Launcher/Object Data/Map - Fireball Launcher(Horizontal).asm"
		include "Objects/MGZ Fireball Launcher/Object Data/Map - Fireball Launcher(Vertical).asm"


; =============== S U B R O U T I N E =======================================
ChainsAddr = objoff_44
Chains_status = objoff_38
ChainsSize = objoff_43 ; chains radius
ChainSpeed = objoff_3A
ChainAngle = objoff_3C
MGZSwingingBall2:
                move.l  #SetObjectsNonDisplay,(a0)
         	move.l	#Map_MGZSwingingSpikeBall,mappings(a0)
		move.w	#$C350,art_tile(a0)
		addq.b	#4,render_flags(a0)
		move.w	#$180,priority(a0)
		move.b	#$18,width_pixels(a0)
		addq.b	#8,height_pixels(a0)
		addq.b  #2,mapping_frame(a0)
              	lea	ChildObjDat_HPZSwing_list(pc),a2
		jmp	(CreateChild20_TreeList_SubtypeBased).l
SetObjectsNonDisplay:
                move.w	x_pos(a0),d0
		andi.w	#-$80,d0
	        sub.w	(Camera_X_pos_coarse_back).w,d0
		cmpi.w	#$280,d0
		bhi.w	.Delete
		rts
.Delete:
	        move.w	respawn_addr(a0),d0	; get address in respawn table
		beq.w	+	; if it's zero, don't remember object
		;MacroDeleteAndUpdateObj
		movea.w	d0,a2
		bclr	#7,(a2)
+
		jmp	Delete_Current_Sprite
ChildObjDat_HPZSwing_list:
		dc.l Obj_HPZSwing_Chain_Lock
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains
		dc.l HPZ_Chains ; chain id $9
		dc.l HPZ_Chains ; chain id $A
		dc.l  Chain_Ball

;------------------------------------------------------------------------------
Obj_HPZSwing_Chain_Lock:
                tst.b   routine(a0)
                beq.s   HPZ_SwingHandel_init
                bsr.s   SwingCalculations
                jmp     Improved_Sprite_DeleteFlicker_LargeObject

; ---------------------------------------------------------------------------

HPZ_SwingHandel_init:
         	addq.b	#2,routine(a0)
	       	move.l	#Map_MGZSwingingSpikeBall,mappings(a0)
		move.w	#$C350,art_tile(a0)
		bset	#2,render_flags(a0)
		;MacroSetDisplayOb $180
		move.w	#$180,priority(a0)
		move.b	#$18,width_pixels(a0)
		move.b	#8,height_pixels(a0)
		move.b	#$1,ChainsSize(a0) ; distance from parent
		move.b  v_oscillate+$1A.w,ChainAngle(a0)
		move.b  #1,mapping_frame(a0)


.Neg_Swing:
                rts
; ---------------------------------------------------------------------------

; ------------------------------------------------------------------------------
;   subroutine to swing the object and its angle and speed and speed subtracting
;-------------------------------------------------------------------------------
SwingCalculations:
                move.w  #$200*$20,d0
		sub.w   v_oscillate+$1A+$4.w,d0 ; target the swinging platform angles from the oclating routines
                move.w  d0,ChainAngle(a0) ; add it to child postiions
		jmp	(Refresh_ChildPosition).l

;----------------------------------------------------------------------------
;  The small Swinging chains Tied to emerald
;----------------------------------------------------------------------------
HPZ_Chains:


		addq.b	#4,ChainSpeed(a0)  ; chain distance
            	move.l	#SwingChainedObject,(a0)
		move.l	#Map_MGZSwingingSpikeBall,mappings(a0)
		move.w	#$C350,art_tile(a0)
                bset	#2,render_flags(a0)
                move.w  #$200,priority(a0)
                addq.b  #1,mapping_frame(a0)
		move.b	#$18,width_pixels(a0)
		addq.b	#8,height_pixels(a0)
.IfNotLegacyIgnore:
		rts
; ---------------------------------------------------------------------------


SwingChainedObject:
		movea.w	parent3(a0),a1
		move.b	ChainAngle(a1),ChainAngle(a0)  ; 3C d0
		move.b	ChainSpeed(a0),d2       ;d2
		pea	MoveSprite_CircularSimple
Improved_Sprite_DeleteFlicker_LargeObject:
	        movea.w	parent3(a0),a1
		tst.l   (a1)
		beq.s   +
		jmp     Draw_Sprite
+
                jmp    Delete_Current_Sprite
ChainBallRadius = $3A
Chain_Ball:



		addq.b	#5,ChainBallRadius(a0)  ; ball distance from main

               	move.l	#Map_FGPlant,mappings(a0)
		move.w	#$C000,art_tile(a0)
		move.b	#40/2,width_pixels(a0)
		move.b	#84/2,height_pixels(a0)
		moveq   #2,d0
              	move.b  d0,mapping_frame(a0)
              	subq.l  #2,d0
              	move.b  d0,collision_flags(a0)
              	move.l  #ChainSetToMovement,(a0)
              	bset    #2,render_flags(a0)

              	jsr     Create_New_Sprite3
              	bne.s   .Fail
              	move.l  #Obj_Monitor,(a1)
              	move.l   x_pos(a0),x_pos(a1)
              	move.l   y_pos(a0),y_pos(a1)
              	move.w  a0,parent3(a1) ; copy main addr
              	move.b  subtype+1(a0),subtype(a1) ; write to monitor's subtype
              	move.w  respawn_addr(a0),respawn_addr(a1) ; get object respawn table so its used in monitor's mark as destroyed code !
 .Fail:
              	rts
ChainSetToMovement:
               	pea	Improved_Sprite_DeleteFlicker_LargeObject
                pea    	Add_SpriteToCollisionResponseList
                movea.w	parent3(a0),a1
		move.b	$3C(a1),$3C(a0)  ; 3C d0
		move.b	ChainBallRadius(a0),d2       ;d2
                move.w	x_pos(a0),-(sp)   ; store the x post
		jsr	MoveSprite_CircularSimple  ; do math stuff
	        move.w    (sp)+,d4      ; restore
                moveq    #$20,d1
                moveq    #$E,d2
                moveq    #$12,d3 ; height
                addi.w   #$36,y_pos(a0) ; subtract 40 from collsion pos
             	jsr	SolidObjectTop ; this will do math things according to the subtract we did
             	subi.w   #$36,y_pos(a0)  ; then restore what you subtracted to begin with
             	rts
; ---------------------------------------------------------------------------
LinksLimit = $B ; how many chains can be spawned also btw you have to edit level layout to fix if you extend this
CreateChild20_TreeList_SubtypeBased:
                movea.l	a0,a3				; Same as routine 8, but creates seperate objects in a list rather than repeating the same object
		moveq	#0,d2
		moveq	#0,d3
		moveq   #0,d6
		move.b  subtype(a0),d6
		moveq   #0,d4
                move.w  d6,d4
		;and.w	#$F0,d6 ; read only first digit to get chain links amount from layout

                and.w   #7,d4 ; get monitor subtype
                move.w  d4,d3   ; copy monitor subtype
                sub.w   d4,d6 ; subtract second digit from first digit
                ori.w   #$7,d6 ; move digit 1 in digit 2 place
                move.w  d6,d4     ; copt what we got in d4
                and.w   #$7,d4    ; read only digit 2 from that
                move.w  d4,d6     ; results in chain amount
                move.w  d3,d4     ;restore monitor subtye

                ;move.w  d6,d3    ; save subtype to data regester
                ;andi.w  #LinksLimit,d6
;	        subi.w  #LinksLimit,d6
 ;               bmi.s    .SetLoopToLinkAmount ; branch if d6 is 0

  ;              move.w  d3,d6  ; retore old subtype but gaint ball flag is set in here
   ;             subi.w  #LinksLimit,d6   ; subtract it again
    ;            moveq   #1,d1 ; set as type 1 end of link

     ;           bra.s    .loopChildLists
; .SetLoopToLinkAmount:
 ;                 moveq   #0,d6
  ;                move.b  subtype(a0),d6
   ;               and.w	 #$F0,d6 ; read only first digit to get chain links amount from layout
    ;              moveq   #0,d1 ; set as ordinary swing type
 .loopChildLists:
                ;lea     (a3),a1 ; get a3 in a1 ; this was bugged
		jsr	Create_New_Sprite3
		bne.s   .return
		move.w	a3,parent3(a1) ; get main parent addr in new slot ( the first object gets the orignal slot but then it gets the slots from dynamic obj ram)
		move.w	a0,ChainsAddr(a1) ; get orignal addr in chains addr (unused)
		lea	(a1),a3   ; wirite object slot addr in a3 so that next object gets this addr
                move.l	mappings(a0),mappings(a1)
                move.w	priority(a0),priority(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.l	(a2)+,(a1)     ; gets id
		tst.w   d6      ; is there 1 left in d6 ?
		bne.s   .BranchToNormal   ; if not go as planned
                move.l  #Chain_Ball,(a1)
                move.b   d4,subtype+1(a1)  ; get monitor subtype
                move.w  respawn_addr(a0),respawn_addr(a1) ; get this objects to know  what your object respawn table addr is
                move.w  Player_1+priority.w,d4
                subi.w  #$80,d4
                bmi.s   .InvalidPriority ; if sonic's priority is toggled to 0 it will change priority of this object and
                move.w  d4,priority(a1)
                bra.s   .BranchToNormal
  .InvalidPriority:
                move.w  #$80,priority(a1)
 .BranchToNormal:
		move.b	d2,subtype(a1)
                move.l	x_pos(a0),x_pos(a1)
		move.l	y_pos(a0),y_pos(a1)


		addq.w	#2,d2

		dbeq	d6,.loopChildLists


 .return:
		rts
; End of function CreateChild20_TreeList



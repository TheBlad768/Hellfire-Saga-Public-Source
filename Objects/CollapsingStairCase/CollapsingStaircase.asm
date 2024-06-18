;---------------CollapsingStairCasestructer---------------------------------------------
; varables that are saved in the main object (good example if you wanna edit this object
;---------------------------------------------------------------------------------------
ObStairMappedVarables = objoff_2E  ;$2e,$2f
Stair0deleteFlag =  objoff_30
Stair0StodOnFlag =  objoff_31

ObCollapsingBlock_1_Addr = objoff_32 ;$32,$33
Stair1deleteFlag =  objoff_34
Stair1StodOnFlag =  objoff_35

ObCollapsingBlock2Addr = objoff_36 ;$36,$37
Stair2_deleteFlag =  objoff_38
Stair2_StodOnFlag =  objoff_39

ObCollapsingBlock3Addr = objoff_3A ;$3A,$3B
Stair3_deleteFlag =  objoff_3C
Stair3_StodOnFlag =  objoff_3D
ObCollapsingBlock4Addr = objoff_3E  ;$3E,$3F
Stair4_deleteFlag =  objoff_40
Stair4_StodOnFlag =  objoff_41
ObCollapsingBlock5Addr = objoff_42 ;42,43
Stair5_deleteFlag =  objoff_44
Stair5_StodOnFlag =  objoff_45
StairsVarables_Size = $4 ; 4 bytes per block

StairSkipDeleteFlag = $2
stair_Interact = $3
;------------------------------------------------------------
; varables used by  "DisplayStairCaseWhileWaiting" object
StairCollapseTimer = subtype+1
;------------------------------------------------------------
; =============== S U B R O U T I N E =======================================
;start of obj code
ObjCollapsingStairCase:
                  lea    ObStairMappedVarables(a0),a3 ; save current addr  ($2E,$32,$36,$3A) (3E,$42) and else until) $46 are additional blocks (6 block sprites are the final limit)
                  moveq   #0,d1
                  move.b   subtype(a0),d1
                  move.w  x_pos(a0),d2 ; load x pos
                  move.w  y_pos(a0),d3  ; load y pos
 .loop:
		  jsr	(SingleObjLoad2).w
		  bne.s	.fail
		  move.w  a1,(a3)  ; save in the main obj
		  move.b  #1,StairSkipDeleteFlag(a3) ; if the obj should delete flag
                  move.b  #1,stair_Interact(a3) ; if the object is marked as stepped on
	  	  move.w  a0,parent3(a1)
                  move.l  #DisplayStairCaseWhileWaiting,(a1)  ; make the object draw itself
 	          move.l  #Map_Stair,obMap(a1)
		  move.w  #$441D,obGfx(a1)
		  move.b  #4,render_flags(a1)
	   	  move.w  #3*$80,priority(a1)
	          move.b  #$20,width_pixels(a1)
		  move.b  #16,height_pixels(a1)
 	          move.w  d2,x_pos(a1) ; input x post from orignal x the first time then custom x the other 3 times
	       	  move.w  d3,y_pos(a1)
	  	  addi.w  #$20,d2 ; advance our child sprite's x post
		  addq.w  #StairsVarables_Size,a3 ; the format size
		  dbf     d1,.loop
 	          move.l  #CollapsingPtfmControl,(a0)  ; go to next pointer
 .fail:
	      	  rts
; =============== S U B R O U T I N E =======================================
CollapsingPtfmControl:
                   lea    ObStairMappedVarables(a0),a3 ; save current addr
                   moveq   #0,d5
                   move.b   subtype(a0),d5

  StairCaseAddressesloop:
                   ;a3 = object (and his varables shown above)
                   ;a0 = 'DisplayStairCaseWhileWaiting' child object
                   ;a4 = saved object addr
                   movea.w    a0,a4  ; save parent's addr
                   movea.w    (a3),a0  ; get child sprite addr a0 = child obj a4 = parent
		   btst        #$3,status(a0)
		   beq.s       .NotOnObj
		   tst.b       stair_Interact(a3) ; is the obj marked as stepped on ?
		   beq.s       .NotOnObj  ; if so then ignore checking if sonic is on it or not
		   clr.b       stair_Interact(a3) ; mark as stepped on
		   clr.b       StairSkipDeleteFlag(a3) ; mark as not part of the delete from MarkObjGone
		   move.l      #CollapsingStairWait,(a0)
		   move.b      #$20,StairCollapseTimer(a0)
		   jsr	       Displace_PlayerOffObject


	.NotOnObj:
		   movea.w     a4,a0   ;  restore parent into a0
		   addq.w      #$4,a3   ; advance child sprite sst
                   dbf     d5,StairCaseAddressesloop ; loop 4 times
                   jmp  CollapsingStairCheckOffScreen
; =============== S U B R O U T I N E =======================================
DisplayStairCaseWhileWaiting:
                   jsr    DisplaySprite
 ObjCollapsingStairCaseData:
                   movea.w      parent3(a0),a1
                   tst.l        (a1)
                   beq.s        DeleteBlockWhenEveryoneISDeleted
                   moveq	#0,d1
		   move.b	width_pixels(a0),d1
		   moveq	#0,d2
		   move.b	height_pixels(a0),d2
		   move.w	d2,d3
	 	   addq.w	#1,d3
		   move.w	x_pos(a0),d4   ; restore x post  to use in solid obj top
		   jmp	       (SolidObjectTop).w
DeleteBlockWhenEveryoneISDeleted:
		   jmp         Delete_Current_Sprite
; =============== S U B R O U T I N E =======================================
 CollapsingStairWait:

                   subq.b  #1,StairCollapseTimer(a0)
                   bpl.s   DisplayStairCaseWhileWaiting
                   move.l  #Obj_FlickerMove,(a0)
                   jmp	    Displace_PlayerOffObject
; =============== S U B R O U T I N E =======================================
CollapsingStairCheckOffScreen:

                   move.w	x_pos(a0),d0
                   andi.w	#$FF80,d0
                   sub.w	(Camera_X_pos_coarse_back).w,d0
                   cmpi.w	#$280,d0
                   bhi.w	.OffScreen
                   moveq   #1,d1 ; on screen
                   rts
; ---------------------------------------------------------------------------
; =============== S U B R O U T I N E =======================================
 .OffScreen:
	           move.w	respawn_addr(a0),d0
	       	   beq.s	.Delete
	           movea.w	d0,a2
	       	   bclr	#7,(a2)

 .Delete:
                   move.l a0,-(sp)
                   lea     ObStairMappedVarables(a0),a3 ; save current addr
                   moveq   #0,d5
                   move.b   subtype(a0),d5
 .loop:
                   movea.w (a3),a1
                   tst.b   StairSkipDeleteFlag(a3) ; is this obj part of this delete code ? (was it already changed to the flicker object)
                   beq.s   .CheckNextObject ;if so then go check for other objects
                   jsr	Delete_Referenced_Sprite
                   addq.w  #StairsVarables_Size,a3
 .CheckNextObject:
                   dbf     d5,.loop
                   move.l  (sp)+,a1
		   jsr	Delete_Referenced_Sprite
       		   moveq   #0,d1 ; offscreen flag
            	   rts


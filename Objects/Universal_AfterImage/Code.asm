; ---------------------------------------------------------------------------
; Universal After Image
; ---------------------------------------------------------------------------

Obj_AfterImage:
      moveq    #0,d0
      move.b   routine(a0),d0
      move.w   Obj_AfterImage_Index(pc,d0.w),d1
      jmp      Obj_AfterImage_Index(pc,d1.w)

; ===========================================================================
Obj_AfterImage_Index:
      dc.w Obj_AfterImage_NoShow-Obj_AfterImage_Index
      dc.w Obj_AfterImage_NoShow-Obj_AfterImage_Index
      dc.w Obj_AfterImage_NoShow-Obj_AfterImage_Index
      dc.w Obj_AfterImage_PriorityStart-Obj_AfterImage_Index
      dc.w Obj_AfterImage_NoShow-Obj_AfterImage_Index
      dc.w Obj_AfterImage_NoShow-Obj_AfterImage_Index
      dc.w Obj_AfterImage_PrioritySwitch-Obj_AfterImage_Index
      dc.w Obj_AfterImage_Delete-Obj_AfterImage_Index
; ===========================================================================
Obj_AfterImage_NoShow:
      addq.b   #2,routine(a0)
      rts
; ===========================================================================
Obj_AfterImage_PriorityStart:
      move.w   #3*$80,obPriority(a0)
      bra.s   Obj_AfterImage_Show
; ===========================================================================
Obj_AfterImage_PrioritySwitch:
      move.w   #4*$80,obPriority(a0)
; ===========================================================================
Obj_AfterImage_Show:
      addq.b   #2,routine(a0)
      jsr      (RandomNumber).w
      andi.b   #2,d0
      bne.s    Obj_AfterImage_Show_exception
      rts

Obj_AfterImage_Show_exception:
      move.w	parent(a0),a1
      move.w	obFrame(a1),obFrame(a0)
      move.w	obStatus(a1),obStatus(a0)
      jmp	(Draw_Sprite).w
; ===========================================================================
Obj_AfterImage_Delete:
      jmp	(Delete_Current_Sprite).w

; ===========================================================================
; Subroutine to produce After Image
; ===========================================================================
Obj_Produce_AfterImage:
		jsr	(SingleObjLoad2).w
		bne.w	Obj_Produce_AfterImage_Return
		move.l	#Obj_AfterImage,(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.l	obMap(a0),obMap(a1)
		move.w	obPriority(a0),obPriority(a1)
		move.b	obRender(a0),obRender(a1)
		move.w	a0,parent(a1)

Obj_Produce_AfterImage_Return:
		rts
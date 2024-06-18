
; =============== S U B R O U T I N E =======================================

Obj_FDZ3Rain_Process:
		moveq	#10,d0
		tst.w	(Seizure_Flag).w
		beq.s	+
		moveq	#3,d0
+		move.b	d0,$30(a0)
		lea	ObjDat3_FDZ3Rain_Process(pc),a1
		jsr	(SetUp_ObjAttributes).w
		st	(FDZ3Rain_Process).w
		clr.b	(FDZ3Rain_Count).w
		move.l	#FDZ3Rain_Process_Main,address(a0)

FDZ3Rain_Process_Main:
		move.w	(Camera_X_pos_copy).w,x_pos(a0)
		move.w	(Camera_Y_pos_copy).w,y_pos(a0)
		subq.w	#8,y_pos(a0)
		subq.w	#1,$2E(a0)
		bpl.s	FDZ3Rain_Return
		move.w	#2,$2E(a0)
		move.b	(FDZ3Rain_Count).w,d0
		addq.b	#1,d0
		cmp.b	$30(a0),d0
		bhi.s	FDZ3Rain_Return
		move.b	d0,(FDZ3Rain_Count).w
		jsr	(Create_New_Sprite).w
		bne.s	FDZ3Rain_Return
		move.l	#Obj_FDZ3Rain,address(a1)

FDZ3Rain_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_FDZ3Rain:
		lea	ObjDat3_FDZ3Rain(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.w	#$F,$2E(a0)
		move.w	#-$600,x_vel(a0)
		move.w	#$800,y_vel(a0)
		move.l	#FDZ3Rain_Draw,address(a0)
		jsr	(Random_Number).w
		andi.w	#$1FF,d0
		cmpi.w	#$140,d0
		blo.s		+
		andi.w	#$3F,d0
		lsl.w	#3,d0
+		add.w	(Camera_X_pos).w,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		subq.w	#4,d0
		move.w	d0,y_pos(a0)
		swap	d0
		andi.w	#3,d0
		move.b	d0,mapping_frame(a0)
		add.w	d0,d0
		move.w	FDZ3Rain_Priority(pc,d0.w),priority(a0)

FDZ3Rain_Draw:
		jsr	(MoveSprite2).w
		subq.w	#1,$2E(a0)
		bmi.s	FDZ3Rain_Jump
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

FDZ3Rain_Priority:	dc.w $80, $380, $80, $80
; ---------------------------------------------------------------------------

FDZ3Rain_Jump:
		move.l	#FDZ3Rain_Draw2,address(a0)
		rts
; ---------------------------------------------------------------------------

FDZ3Rain_Draw2:
		jsr	(MoveSprite2).w
		tst.b	render_flags(a0)
		bpl.s	FDZ3Rain_Remove
		jmp	(Draw_Sprite).w
; ---------------------------------------------------------------------------

FDZ3Rain_Remove:
		move.b	(FDZ3Rain_Count).w,d0
		subq.b	#1,d0
		bmi.s	+
		move.b	d0,(FDZ3Rain_Count).w
+		move.l	#Delete_Current_Sprite,address(a0)
		rts

; =============== S U B R O U T I N E =======================================

ObjDat3_FDZ3Rain_Process:
		dc.l Map_Offscreen
		dc.w 0
		dc.w $80
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
ObjDat3_FDZ3Rain:
		dc.l Map_FDZ3Rain
		dc.w $E45B
		dc.w $80
		dc.b 16/2
		dc.b 16/2
		dc.b 0
		dc.b 0
; ---------------------------------------------------------------------------

		include "Objects/FDZ3Rain/Object data/Map - Rain.asm"
; ---------------------------------------------------------------------------
; �����
; ---------------------------------------------------------------------------

; Dynamic object variables
obEmbers_Speed			= $30	; .b
obEmbers_Amplitude		= $31	; .b

; =============== S U B R O U T I N E =======================================

Obj_GMZ1Embers_Process:
		lea	ObjDat3_GMZ1Embers_Process(pc),a1
		jsr	(SetUp_ObjAttributes).w
;		st	(FDZ3Rain_Process).w
		clr.b	(FDZ3Rain_Count).w
		move.l	#GMZ1Embers_Process_Main,address(a0)

GMZ1Embers_Process_Main:
		move.w	(Camera_X_pos_copy).w,x_pos(a0)
		move.w	(Camera_Y_pos_copy).w,y_pos(a0)
		subq.w	#8,y_pos(a0)
		subq.w	#1,$2E(a0)
		bpl.s	GMZ1Embers_Return
		move.w	#1,$2E(a0)
		move.b	(FDZ3Rain_Count).w,d0
		addq.b	#1,d0
		cmpi.b	#40,d0
		bhi.s	GMZ1Embers_Return
		move.b	d0,(FDZ3Rain_Count).w
		jsr	(Create_New_Sprite).w
		bne.s	GMZ1Embers_Return
		move.l	#Obj_GMZ1Embers,address(a1)

GMZ1Embers_Return:
		rts

; =============== S U B R O U T I N E =======================================

Obj_GMZ1Embers:
		lea	ObjDat3_GMZ1Embers(pc),a1
		jsr	(SetUp_ObjAttributes).w
		move.l	#GMZ1Embers_Draw,address(a0)

		jsr	(Random_Number).w
		andi.w	#$1FF,d0
		cmpi.w	#$140,d0
		blo.s	+
		andi.w	#$3F,d0
		lsl.w	#3,d0

+		add.w	(Camera_X_pos).w,d0
		subi.w	#$60,d0
		move.w	d0,x_pos(a0)
		move.w	(Camera_Y_pos).w,d0
		addi.w	#$FF,d0
		move.w	d0,y_pos(a0)
		swap	d0
		andi.w	#3,d0
		move.b	d0,mapping_frame(a0)

-		jsr	(Random_Number).w
		andi.w	#$300,d0
		beq.s	-
		neg.w	d0
		move.w	d0,y_vel(a0)
		andi.w	#6,d0
		move.w	GMZ1Embers_Timer(pc,d0.w),$2E(a0)
		lea	GMZ1Embers_Amplitude(pc,d0.w),a1
		move.b	(a1)+,obEmbers_Speed(a0)
		move.b	(a1)+,obEmbers_Amplitude(a0)

GMZ1Embers_Draw:
		moveq	#0,d0
		move.b	angle(a0),d0
		add.b	obEmbers_Speed(a0),d0
		move.b	d0,angle(a0)
		jsr	GetSineCosine+4		; NAT: Skip and instruction - not needed

		moveq	#0,d1
		move.b	obEmbers_Amplitude(a0),d1
		asr.w	d1,d0
		move.w	d0,x_vel(a0)
;		jsr	(MoveSprite2).w

	; inline for efficiency
		move.w	x_vel(a0),d0		; load horizontal speed
		ext.l	d0
		asl.l	#8,d0				; multiply speed by $100
		add.l	d0,x_pos(a0)		; update x-axis position
		move.w	y_vel(a0),d0		; load vertical	speed
		ext.l	d0
		asl.l	#8,d0				; multiply by $100
		add.l	d0,y_pos(a0)		; update y-axis position

		subq.w	#1,$2E(a0)
		bmi.s	GMZ1Embers_Remove
;		jmp	(Draw_Sprite).w

	; inline for efficiency
		lea	Sprite_table_input+$80.w,a1
		cmpi.w	#$7E,(a1)
		bhs.s	.rts
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)

.rts
		rts
; ---------------------------------------------------------------------------

GMZ1Embers_Timer:	dc.w $5F, $5F, $4F, $5F
GMZ1Embers_Amplitude:
		dc.b 4, 1
		dc.b 4, 2
		dc.b 4, 2
		dc.b 4, 2
; ---------------------------------------------------------------------------

GMZ1Embers_Remove:
		move.b	(FDZ3Rain_Count).w,d0
		subq.b	#1,d0
		bmi.s	+
		move.b	d0,(FDZ3Rain_Count).w
+		move.l	#Delete_Current_Sprite,address(a0)
		rts

; =============== S U B R O U T I N E =======================================

ObjDat3_GMZ1Embers_Process:
		dc.l Map_Offscreen
		dc.w 0
		dc.w $80
		dc.b 0
		dc.b 0
		dc.b 0
		dc.b 0
ObjDat3_GMZ1Embers:
		dc.l Map_GMZ1Embers
		dc.w $869D		; $86E0
		dc.w $80
		dc.b 8/2
		dc.b 8/2
		dc.b 0
		dc.b 0
; ---------------------------------------------------------------------------

		include "Objects/GMZ1Embers/Object data/Map - Embers.asm"

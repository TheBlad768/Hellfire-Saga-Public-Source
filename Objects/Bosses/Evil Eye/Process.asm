
; =============== S U B R O U T I N E =======================================

Obj_FDZ3_Process:
		lea	(ChildObjDat_Dialog_Process).l,a2
		jsr	(CreateChild6_Simple).w
		bne.s	+
		move.b	#_FDZ3,routine(a1)
		move.l	#DialogFDZ1Start_Process_Index-4,$34(a1)
		move.b	#(DialogFDZ1Start_Process_Index_End-DialogFDZ1Start_Process_Index)/8,$39(a1)
		move.w	a1,parent3(a0)
+		move.l	#FDZ3_Process_CheckDialog,address(a0)

FDZ3_Process_CheckDialog:
		movea.w	parent3(a0),a1
		cmpi.b	#3,obDialogWinowsText(a1)
		bne.s	FDZ3_Process_Return
		st	obDialogTextLock(a1)
		music	mus_Microboss
		jsr	(SingleObjLoad2).w
		bne.s	+
		move.l	#Obj_DialogueFirebrand,address(a1)	; load FDZ megaboss
		move.w	a1,$44(a0)
		move.w	a0,parent3(a1)
		move.w	(Camera_X_pos).w,d2
		addi.w	#$E0,d2
		move.w	d2,x_pos(a1)
		move.w	(Camera_Y_pos).w,d2
		addi.w	#$60,d2
		move.w	d2,y_pos(a1)
+		lea	(Player_1).w,a1
		move.w	#id_LookUp<<8,anim(a1)
		move.l	#FDZ3_Process_CheckDialog2,address(a0)

FDZ3_Process_CheckDialog2:
		movea.w	parent3(a0),a1
		cmpi.b	#0,obDialogWinowsText(a1)
		bne.s	FDZ3_Process_Return
		st	obDialogTextLock(a1)
		movea.w	$44(a0),a1
		move.l	#DialogueFirebrand_Remove,address(a1)
		move.l	#FDZ3_Process_Return,address(a0)

FDZ3_Process_Return:
		rts

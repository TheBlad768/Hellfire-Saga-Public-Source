; ---------------------------------------------------------------------------
; Secrets (Object)
; Version 1.0
; By TheBlad768 (2023).
; ---------------------------------------------------------------------------

; dynamic object variables
obSecret_Slot					= objoff_30	; .w

; macro to declare sub-object data
subObjDataS	macro address,render,routine,height,width,priority,art,mappings,frame,collision
		dc.l address						; address
		dc.b render, routine, height, width	; render, routine, height, width
		dc.w priority, art					; priority, art tile
		dc.l mappings						; mappings
		dc.b frame, collision				; mapping frame, collision flags
    endm

; =============== S U B R O U T I N E =======================================

Obj_Secrets:

		; check count
		lea	(TSecrets_count).w,a1					; load secrets count
		move.b	(a1)+,d0							; get total secrets
		cmp.b	(a1),d0							; check max secrets
		bhs.w	.delete							; if maximum, branch

		; calc slot
		lea	(Secrets_buffer).w,a1
		move.w	(Current_zone_and_act).w,d0
		ror.b	#2,d0
		lsr.w	#5,d0
		adda.w	d0,a1							; shift
		move.b	subtype(a0),d0					; max 2 secrets in act
		andi.w	#1,d0							; "
		adda.w	d0,a1							; shift
		tst.b	(a1)									; is free?
		bne.s	.delete							; if not, branch
		move.w	a1,obSecret_Slot(a0)				; save address

		; init
		lea	ObjDat_Secrets(pc),a1					; load object data
		movem.l	(a1)+,d0-d3						; copy data to d0-d3
		movem.l	d0-d3,address(a0)					; set data from d0-d3 to current object
		move.b	(a1)+,mapping_frame(a0)			; set mapping frame
		move.b	(a1),collision_flags(a0)				; set collision flags

		; set side
		move.b	status(a0),d0
		andi.b	#1,d0
		andi.b	#$FC,render_flags(a0)
		or.b	d0,render_flags(a0)

		; set swing
		move.w	#$80,d0
		move.w	d0,objoff_3E(a0)
		move.w	d0,y_vel(a0)
		move.w	#8,objoff_40(a0)
		bclr	#0,objoff_38(a0)

.main

		; swing
		jsr	(Swing_UpAndDown).w
		move.w	y_vel(a0),d0
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,y_pos(a0)

		; check touch
		tst.b	collision_property(a0)					; has Sonic touched the secret?
		beq.s	.draw							; if not, branch

		; set taken
		movea.w	obSecret_Slot(a0),a1				; load slot
		st	(a1)									; set slot as occupied

		; taken
		addq.b	#1,(TSecrets_count).w
		move.w	#$14,(Screen_Shaking_Flag).w
		move.b	#4,(Hyper_Sonic_flash_timer).w
		samp	sfx_ThunderClamp

.delete
		jmp	(Delete_Current_Sprite).w
; ---------------------------------------------------------------------------

.draw
		jmp	(Sprite_OnScreen_Test_Collision).w

; ---------------------------------------------------------------------------
; Secrets (Clear)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

Clear_Secrets:
		moveq	#0,d0
		lea	(Secrets_buffer).w,a1
	rept	bytesTo2Lcnt(Secrets_buffer_end-Secrets_buffer)
		move.l	d0,(a1)+
	endm
	if (Secrets_buffer_end-Secrets_buffer)&2
		move.w	d0,(a1)+
	endif
		rts

; ---------------------------------------------------------------------------
; Secrets (Data)
; ---------------------------------------------------------------------------

; =============== S U B R O U T I N E =======================================

ObjDat_Secrets:	subObjDataS Obj_Secrets.main, rfCoord+rfStatic, 0, 32/2, 32/2, $200, $596, Map_Secrets, 0, 6|$C0
; ---------------------------------------------------------------------------

		include "Objects/Secrets/Object Data/Map - Secrets.asm"
